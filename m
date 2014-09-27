From: Kristian Hagsted Rasmussen <kristian@hagsted.dk>
Subject: RE: open-iSCSI with BluRay drive use sr driver scsi-1 instead of
 scsi3-mmc.
Date: Sat, 27 Sep 2014 11:37:18 +0000
Message-ID: <8f945515af104ed79939164aaf14f629@hagsted-cserver.hagsted.dk>
References: <4600033142b34df8b366a4ae132beaf7@hagsted-cserver.hagsted.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hagsted.dk ([2.108.107.22]:39944 "EHLO hagsted.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752759AbaI0Oss convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 27 Sep 2014 10:48:48 -0400
In-Reply-To: <4600033142b34df8b366a4ae132beaf7@hagsted-cserver.hagsted.dk>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "To recipients. Use the Arrow keys to navigate the list, and the Enter
	key to open a contact card." <linux-scsi@vger.kernel.org>

I will just add some more info, as I have just attached the iscsi BD-ROM will having extended DEBUG turn on for iscsi, by:
    echo 0x9411 > /proc/sys/dev/scsi/logging_level

the most interesting part in the logs, the part with errors is:

[  502.793948] sr 11:0:0:0: CDB:
[  502.793950] Mode Sense(6): 1a 00 2a 00 80 00
[  502.801905] sr 11:0:0:0: Done:
[  502.801909] SUCCESS
[  502.801912] sr 11:0:0:0:
[  502.801914] Result: hostbyte=DID_TARGET_FAILURE driverbyte=DRIVER_OK
[  502.801917] sr 11:0:0:0: CDB:
[  502.801919] Mode Sense(6): 1a 00 2a 00 80 00
[  502.801927] sr 11:0:0:0:
[  502.801929] Sense Key : Illegal Request [current]
[  502.801933] sr 11:0:0:0:
[  502.801937] Add. Sense: Invalid command operation code
[  502.801959] sr0: scsi-1 drive
[  502.801962] cdrom: Uniform CD-ROM driver Revision: 3.20
[  502.802236] sr 11:0:0:0: Attached scsi CD-ROM sr0
[  502.802333] sr 11:0:0:0: Send:

and later

[  502.863152] sr 11:0:0:0: [sr0] CDB:
[  502.863154] ATA command pass through(16): 85 08 2e 00 00 00 01 00 00 00 00 00 00 00 a1 00
[  502.865959] sr 11:0:0:0: [sr0] Done:
[  502.865963] SUCCESS
[  502.865966] sr 11:0:0:0: [sr0]
[  502.865968] Result: hostbyte=DID_OK driverbyte=DRIVER_OK
[  502.865971] sr 11:0:0:0: [sr0] CDB:
[  502.865973] ATA command pass through(16): 85 08 2e 00 00 00 01 00 00 00 00 00 00 00 a1 00
[  502.865987] sr 11:0:0:0: [sr0]
[  502.865989] Sense Key : Recovered Error [current] [descriptor]
[  502.865993] Descriptor sense data with sense descriptors (in hex):
[  502.865995]         72 01 00 1d 00 00 00 0e 09 0c 00 00 00 02 00 00
[  502.866006]         00 00 00 02 00 50
[  502.866013] sr 11:0:0:0: [sr0]
[  502.866016] Add. Sense: ATA pass through information available
[  502.866073] sr 11:0:0:0: Send:

I hope this further info is of use.

Best regards Kristian

________________________________________
From: linux-scsi-owner@vger.kernel.org on behalf of Kristian Hagsted Rasmussen
Sent: Tuesday, September 23, 2014 14:30
To: To recipients. Use the Arrow keys to navigate the list, and the Enter       key to open a contact card.
Subject: open-iSCSI with BluRay drive use sr driver scsi-1 instead of scsi3-mmc.

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
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
