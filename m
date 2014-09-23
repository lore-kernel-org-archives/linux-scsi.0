From: Kristian Hagsted Rasmussen <kristian@hagsted.dk>
Subject: open-iSCSI with BluRay drive use sr driver scsi-1 instead of
 scsi3-mmc.
Date: Tue, 23 Sep 2014 12:30:19 +0000
Message-ID: <4600033142b34df8b366a4ae132beaf7@hagsted-cserver.hagsted.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hagsted.dk ([2.108.107.22]:41013 "EHLO hagsted.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751412AbaIWMkG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 23 Sep 2014 08:40:06 -0400
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "To recipients. Use the Arrow keys to navigate the list, and the Enter
	key to open a contact card." <linux-scsi@vger.kernel.org>

Dear List 

I have a server with a BluRay drive that is shared as an iSCSI target, with either SCST or LIO (I have tried both too see if the error was on the target implementation). It is possible for me to connect to this drive both from Linux using open-iSCSI and from windows using the MS-iSCSI-initiator. On windows I can use the drive like it was a local drive, meaning that I can play all type of content from it including encrypted DVDs and I would also be able to change the region settings on the drive if I felt for it. However on Linux with open-iSCSI I'm not able to play encrypted DVDs, unless a MS-Windows computer is also connected to the drive. I am also not able to retrieve the region settings of the drive with the regionset utility. After much poking around I found some differences between t
 he server system and the initiator system when binding the drive to the sr module. 

For the  server system, which can play encrypted DVDs the log entries are: 
[    6.661163] scsi 2:0:0:0: CD-ROM            Optiarc  BD ROM BC-5600S  1.82 PQ: 0 ANSI: 5 
[    6.675635] sr0: scsi3-mmc drive: 16x/16x writer dvd-ram cd/rw xa/form2 cdda tray 
[    6.675639] cdrom: Uniform CD-ROM driver Revision: 3.20 
[    6.675801] sr 2:0:0:0: Attached scsi CD-ROM sr0 
[    6.675910] sr 2:0:0:0: Attached scsi generic sg2 type 5 

For the initiator system, which cannot play encrypted DVDs the log entries are: 
[   36.650119] scsi 9:0:0:0: CD-ROM            Optiarc  BD ROM BC-5600S  1.82 PQ: 0 ANSI: 5 
[   36.663525] sr0: scsi-1 drive 
[   36.663530] cdrom: Uniform CD-ROM driver Revision: 3.20 
[   36.663806] sr 9:0:0:0: Attached scsi CD-ROM sr0 
[   36.664068] sr 9:0:0:0: Attached scsi generic sg4 type 5 

Please note here the difference in the second entry on the two systems, one says "sr0: scsi3-mmc drive" and the other "sr0: scsi-1 drive". By looking through the linux kernel code I found out that the module falls back to scsi-1 if it cannot read the capabilities mode page of the attached drive. Please refer to "drivers/scsi/sr.c" from around line 873 in the Linux source code. Is there a way to ensure that linux used the correct drive type, or enable reading of the capability mode page? 

It should be noted that I am running on Ubuntu 14.04, with libdvdread4 and libdvdcss2 installed correctly. 

I hope someone can help me fix this problem as I would like to switch completely to Linux. 

Please fell free to ask for further info. 

Best regards Kristian Hagsted Rasmussen 
