#!/bin/bash
#################################################################
#								#
#                          Configurations			#
#								#
#################################################################

###### Screen Resolution ######
## 640x480 ##
#ScreenWidth=640
#ScreenHeight=480
## 1280x800 ##
ScreenWidth=1280
ScreenHeight=800
## 1920x1080 ##
#ScreenWidth=1920
#ScreenHeight=1080

###### Values derived from Resolution which change the layout ######
#### This option created 1 row with 4 rather tall digits [hhmm] ####
let "ImageWidth=ScreenWidth / 4"
let "ImageHeight=ScreenHeight*1"
let "Digit3X=ImageWidth*3"
let "Digit2X=ImageWidth*2"
let "Digit1X=ImageWidth*1"
let "Digit0X=ImageWidth*0"
let "Digit3Y=ImageHeight*0"
let "Digit2Y=ImageHeight*0"
let "Digit1Y=ImageHeight*0"
let "Digit0Y=ImageHeight*0"
#### This option creates 2 rows with 2 digits [hh/mm] ####
#let "ImageWidth=ScreenWidth / 2"
#let "ImageHeight=ScreenHeight / 2"
#let "Digit3X=ImageWidth*1"
#let "Digit2X=ImageWidth*0"
#let "Digit1X=ImageWidth*1"
#let "Digit0X=ImageWidth*0"
#let "Digit3Y=ImageHeight*0"
#let "Digit2Y=ImageHeight*0"
#let "Digit1Y=ImageHeight*1"
#let "Digit0Y=ImageHeight*1"

###### Pictures ######
## The ImagePath needs to contain 10 directories "0", "1", "2", "3", etc... ##
## The images stored in each of these directories will be used ##
ImagePath="./"

### Image Cycle Duration ###
Duration3=1
Duration2=10
Duration1=60
Duration0=90

### Pause Duration - this delay is used to pause the script to ensure the new images are loaded before the old images are killed ###
PauseDuration=3

### Initial PID values used to detect the first loop ###
OLDPID3=0
OLDPID2=0
OLDPID1=0
OLDPID0=0

#################################################################
#								#
#	    While loop, that just keeps looping			#
#								#
#################################################################

while true ; do
	### While loop just keeps running forever ###
	CURRENTHOUR=`date +%H`
	CURRENTMINUTE=`date +%M`
	if [ "$CURRENTHOUR" != "$TEMPHOUR" ] ; then
		### First Run or after hour changes ###
		TEMPMINUTE=$CURRENTMINUTE
		TEMPHOUR=$CURRENTHOUR
		DIGIT0=${TEMPHOUR:0:1}
                DIGIT1=${TEMPHOUR:1:1}
                DIGIT2=${TEMPMINUTE:0:1}
                DIGIT3=${TEMPMINUTE:1:1}
		### Starts displaying 4 images based on the time ###
		feh -z -x -s -p -q -D $Duration0 --zoom fill -g "$ImageWidth"x"$ImageHeight"+"$Digit0X"+"$Digit0Y" $ImagePath$DIGIT0/ &
                PID0=$!
                feh -z -x -s -p -q -D $Duration1 --zoom fill -g "$ImageWidth"x"$ImageHeight"+"$Digit1X"+"$Digit1Y" $ImagePath$DIGIT1/ &
                PID1=$!
                feh -z -x -s -p -q -D $Duration2 --zoom fill -g "$ImageWidth"x"$ImageHeight"+"$Digit2X"+"$Digit2Y" $ImagePath$DIGIT2/ &
                PID2=$!
                feh -z -x -s -p -q -D $Duration3 --zoom fill -g "$ImageWidth"x"$ImageHeight"+"$Digit3X"+"$Digit3Y" $ImagePath$DIGIT3/ &
                PID3=$!

		if [ "$OLDPID0" != 0 ] ; then
			### If not first run, then kill old instances of feh ###
                        sleep $PauseDuration
                        kill $OLDPID0
                        kill $OLDPID1
                        kill $OLDPID2
                        kill $OLDPID3
                        sleep $PauseDuration
		fi
		### Copy PID values into OLDPID variables ###
                OLDPID0=$PID0
                OLDPID1=$PID1
                OLDPID2=$PID2
                OLDPID3=$PID3
	else
		if [ "$CURRENTMINUTE" != "$TEMPMINUTE" ] ; then
			### When minute changes, update last 2 digits
			TEMPMINUTE=$CURRENTMINUTE
			DIGIT2=${TEMPMINUTE:0:1}
			DIGIT3=${TEMPMINUTE:1:1}
			### Displays the two new minute digits ###
			feh -z -x -s -p -q -D $Duration2 --zoom fill -g "$ImageWidth"x"$ImageHeight"+"$Digit2X"+"$Digit2Y" $ImagePath$DIGIT2/ &
			PID2=$!
			feh -z -x -s -p -q -D $Duration3 --zoom fill -g "$ImageWidth"x"$ImageHeight"+"$Digit3X"+"$Digit3Y" $ImagePath$DIGIT3/ &
			PID3=$!
			### Pause is inserted to ensure the new images are loaded before killing the old images ###
                        sleep $PauseDuration
			### Kills the two previous images###
                        kill $OLDPID3
                        kill $OLDPID2
			sleep $PauseDuration
                        OLDPID3=$PID3
                        OLDPID2=$PID2
		fi

	fi
done
