#!/bin/sh
echo -e "\nCreating a sonarqube user:"
sudo adduser --system --no-create-home --group --disabled-login sonarqube

# installing unzip if missing
sudo apt-get install unzip

echo -e "\nWe need to create a database and credentials that SonarQube will use. Log in to the MySQL server as the root use"
echo -e "\nHelp:"
echo -e "\nTo create the SonarQube database: 
\nCREATE DATABASE sonarqube;"
echo -e "\nTo create the credentials that SonarQube will use to access the database: \nCREATE USER 'sonar'@'localhost' IDENTIFIED BY 'sonar';
\nCREATE USER sonar@'%' IDENTIFIED BY 'sonar';
\nGRANT ALL PRIVILEGES ON sonarqube.* TO 'sonar'@'localhost';
\nGRANT ALL PRIVILEGES ON sonarqube.* TO 'sonar'@'%';
\nEXIT;"

mysql -u root -p
# CREATE DATABASE sonarqube;
# CREATE USER 'sonarqube'@'localhost' IDENTIFIED BY 'sonarqube';
# GRANT ALL PRIVILEGES ON sonarqube.* TO 'sonarqube'@'localhost';
# FLUSH PRIVILEGES;
## CREATE USER 'user'@'localhost' IDENTIFIED BY 'password';
## GRANT ALL PRIVILEGES ON database.* TO 'user'@'localhost';


echo -e "\nCreating the directory that will hold the SonarQube files:"
sudo mkdir /opt/sonarqube
cd /opt/sonarqube
echo -e "\n\nDownloading and Installing SonarQube:"
sudo wget https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-7.7.zip
sudo unzip sonarqube-7.7.zip
sudo rm sonarqube-7.7.zip
echo -e "\nUpdating the permissions so that the sonarqube user will be able to read and write files in this directory:"
sudo chown -R sonarqube:sonarqube /opt/sonarqube

echo -e "\n\nConfiguring Sonaqube:"
echo -e "Update-
\n\tsonar.jdbc.username=sonarqube
\n\tsonar.jdbc.password=sonarqube
\n\tsonar.jdbc.url=jdbc:mysql://localhost:3306/sonarqube?useUnicode=true&characterEncoding=utf8&rewriteBatchedStatements=true&useConfigs=maxPerformance&useSSL=false
\n\tsonar.web.host=127.0.0.1
\n\tsonar.web.javaAdditionalOpts=-server"
echo -e "Press any key to continue..."
read enter
sudo nano /opt/sonarqube/sonarqube-7.7/conf/sonar.properties

echo -e "\n\nCreate the service file.
Add the below content to the file."
echo "
\n[Unit]
\nDescription=SonarQube service
\nAfter=syslog.target network.target
\n
\n[Service]
\nType=forking
\n
\nExecStart=/opt/sonarqube/sonarqube-7.7/bin/linux-x86-64/sonar.sh start
\nExecStop=/opt/sonarqube/sonarqube-7.7/bin/linux-x86-64/sonar.sh stop
\n
\nUser=sonarqube
\nGroup=sonarqube
\nRestart=always
\n
\n[Install]
\nWantedBy=multi-user.target
"
sudo nano /etc/systemd/system/sonarqube.service

sudo service sonarqube start
sudo service sonarqube status
# sudo systemctl enable sonarqube
