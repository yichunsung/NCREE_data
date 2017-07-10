setwd('c:/NCREE_data')
rawData <- read.csv('data/raw_data.csv')
rawData$ID <- sub(" ",replacement ="",rawData$ID)
stName <- as.vector(unique(rawData$ID))

new_rawData <- data.frame(ID = rawData$ID, rawData[,6:14])
new_rawData$date <- as.Date(new_rawData$date)

#### T.G = Track/Graticule
#### T.Area = T.G/Area
#### T.A.Day = T.Area/EXP.T
#### X.T.A.Day = T.A.Day*0.027

for(k in 1:length(stName)){
  every_station <- subset(new_rawData, new_rawData$ID == stName[k])

  testEXPT <- c()
  for(i in 1:length(every_station$date)){
    testEXPT <-c(testEXPT, as.numeric(every_station$date[i+1] - every_station$date[i]))
  }
  testEXPT <-testEXPT[1:length(testEXPT)-1]
  testEXPT <- c(every_station$Exposure.T[1], testEXPT)
  # every_station <- cbind(every_station, testEXPT)
  every_station$Exposure.T <- testEXPT
  every_station$T.G <- every_station$Tracks/every_station$Graticule
  every_station$T.Area <- every_station$T.G/every_station$AREA
  every_station$T.A.Day <- every_station$T.Area/every_station$Exposure.T
  every_station$X.T.A.Day <- every_station$T.A.Day*0.027
  # write csv file
  write.csv(every_station, file = paste("c:/NCREE_data/data/temp_data/", stName[k], ".csv", sep = ""))
}
