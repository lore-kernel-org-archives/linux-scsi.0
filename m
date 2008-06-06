From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Subject: [regression/bisected] corrupt CD data after media change and delay
Date: Fri, 6 Jun 2008 16:06:28 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0806061458300.6228@vixen.sonytel.be>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-584349381-2109928023-1212761188=:16998"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vervifontaine.sonytel.be ([80.88.33.193]:33031 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753269AbYFFOGb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Jun 2008 10:06:31 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: David Martin <tasio@tasio.net>, Maarten Bressers <mbres@gentoo.org>, Daniel Drake <dsd@gentoo.org>, linux-scsi@vger.kernel.org, Linux Kernel Development <linux-kernel@vger.kernel.org>, Cell Broadband Engine OSS Development <cbe-oss-dev@ozlabs.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---584349381-2109928023-1212761188=:16998
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

	Hi all,

When mounting a CD/DVD more than 30 seconds after inserting it, and reading
from it, we get:

    attempt to access beyond end of device
    sr0: rw=0, want=371932, limit=371928
    Buffer I/O error on device sr0, logical block 92982
    attempt to access beyond end of device
    sr0: rw=0, want=371936, limit=371928
    Buffer I/O error on device sr0, logical block 92983
    attempt to access beyond end of device
    sr0: rw=0, want=371940, limit=371928
    Buffer I/O error on device sr0, logical block 92984
    attempt to access beyond end of device
    sr0: rw=0, want=371944, limit=371928
    Buffer I/O error on device sr0, logical block 92985
    attempt to access beyond end of device
    sr0: rw=0, want=371948, limit=371928
    Buffer I/O error on device sr0, logical block 92986
    ...

It can be reproduced on a PS3 with busybox userland using:

    # Insert first CD
    $ mount /dev/sr0 /mnt
    $ ls -R /mnt
    $ umount /mnt
    $ eject
    # Remove first CD

    # Insert second CD
    # Wait at least 30 seconds
    $ mount /dev/sr0 /mnt
    $ tar cf /dev/null /mnt

It does not happen when mounting the second CD within 30 seconds after
inserting it, which is consistent with

    #define SR_TIMEOUT     (30 * HZ)

I can't seem to reproduce it with a Debian or Fedora Core 6 userland.

The problem is present in 2.6.25.
2.6.24 is OK.

After bisecting, it seems to be introduced by

    commit 210ba1d1724f5c4ed87a2ab1a21ca861a915f734
    Author: James Bottomley <James.Bottomley@HansenPartnership.com>
    Date:   Sat Jan 5 10:39:51 2008 -0600

	[SCSI] sr: update to follow tray status correctly
	
	Based on an original patch from: David Martin <tasio@tasio.net>
	
	When trying to get the drive status via ioctl CDROM_DRIVE_STATUS, with
	no disk it gives CDS_TRAY_OPEN even if the tray is closed.
	
	ioctl works as expected with ide-cd driver.
	
	Gentoo bug report: http://bugs.gentoo.org/show_bug.cgi?id=196879
	
	Cc: Maarten Bressers <mbres@gentoo.org>
	Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>

After reverting both 210ba1d1724f5c4ed87a2ab1a21ca861a915f734 and

    commit 38582a62ecd337de4212004c7d4844899dc57890
    Author: James Bottomley <James.Bottomley@HansenPartnership.com>
    Date:   Wed Feb 6 13:01:58 2008 -0600

	[SCSI] sr: fix test unit ready responses
	
	Commit 210ba1d1724f5c4ed87a2ab1a21ca861a915f734 updated sr.c to use
	the scsi_test_unit_ready() function.  Unfortunately, this has the
	wrong characteristic of eating NOT_READY returns which sr.c relies on
	for tray status.
	
	Fix by rolling an internal sr_test_unit_ready() that doesn't do this.
	
	Tested-by: Daniel Drake <dsd@gentoo.org>
	Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>

(which reverse-depends on it), the problem goes away.

As I have not much of a clue about what's really going wrong, I added the debug
code below, and retried.

1. Mount first CD, read, unmount, eject:

    +0+ the_result = 0x8000002 Sense Key : 0x0 [current] [descriptor]
    +0+ the_result = 0x8000002 Sense Key : 0x0 [current] [descriptor]
    +0+ the_result = 0x8000002 Sense Key : 0x0 [current] [descriptor]
    Sense Key : 0x2 [current] 
    +5+ CDS_DISC_OK
    +0+ the_result = 0x8000002 Sense Key : 0x0 [current] [descriptor]
    +0+ the_result = 0x8000002 Sense Key : 0x0 [current] [descriptor]
    +0+ the_result = 0x8000002 Sense Key : 0x0 [current] [descriptor]
    Sense Key : 0x2 [current] 
    +5+ CDS_DISC_OK
    +0+ the_result = 0x0 Sense Key : 0x0 [current] [descriptor]
    +1+ CDS_DISC_OK
    +0+ the_result = 0x0 Sense Key : 0x0 [current] [descriptor]
    +1+ CDS_DISC_OK
    +0+ the_result = 0x0 Sense Key : 0x0 [current] [descriptor]
    ISO 9660 Extensions: RRIP_1991A
    +0+ the_result = 0x0 Sense Key : 0x0 [current] [descriptor]
    +1+ CDS_DISC_OK
    +0+ the_result = 0x0 Sense Key : 0x0 [current] [descriptor]
    +1+ CDS_DISC_OK
    +0+ the_result = 0x0 Sense Key : 0x0 [current] [descriptor]
    +0+ the_result = 0x0 Sense Key : 0x0 [current] [descriptor]


2. Mount second CD more than 30 seconds after insertion, try to read, unmount,
   eject:

    +0+ the_result = 0x8000002 Sense Key : 0x0 [current] [descriptor]
    +0+ the_result = 0x0 Sense Key : 0x0 [current] [descriptor]
    +1+ CDS_DISC_OK
    +0+ the_result = 0x0 Sense Key : 0x0 [current] [descriptor]
    +1+ CDS_DISC_OK
    +0+ the_result = 0x0 Sense Key : 0x0 [current] [descriptor]
    +1+ CDS_DISC_OK
    +0+ the_result = 0x0 Sense Key : 0x0 [current] [descriptor]
    +1+ CDS_DISC_OK
    +0+ the_result = 0x0 Sense Key : 0x0 [current] [descriptor]
    ISO 9660 Extensions: Microsoft Joliet Level 3
    ISO 9660 Extensions: RRIP_1991A
    attempt to access beyond end of device
    sr0: rw=0, want=371932, limit=371928
    Buffer I/O error on device sr0, logical block 92982
    attempt to access beyond end of device
    sr0: rw=0, want=371936, limit=371928
    Buffer I/O error on device sr0, logical block 92983
    [...]
    sr 0:0:0:0: [sr0] Device not ready: Sense Key : 0x2 [current] 
    sr 0:0:0:0: [sr0] Device not ready: ASC=0x3a ASCQ=0x0
    end_request: I/O error, dev sr0, sector 367332
    __ratelimit: 76 messages suppressed
    ...
    sr 0:0:0:0: [sr0] Device not ready: Sense Key : 0x2 [current] 
    sr 0:0:0:0: [sr0] Device not ready: ASC=0x3a ASCQ=0x0
    end_request: I/O error, dev sr0, sector 215608
    __ratelimit: 12 messages suppressed
    Buffer I/O error on device sr0, logical block 53902
    Buffer I/O error on device sr0, logical block 53903
    Buffer I/O error on device sr0, logical block 53904
    Buffer I/O error on device sr0, logical block 53905
    Buffer I/O error on device sr0, logical block 53906
    Buffer I/O error on device sr0, logical block 53907
    Buffer I/O error on device sr0, logical block 53908
    sr 0:0:0:0: [sr0] Device not ready: Sense Key : 0x2 [current] 
    sr 0:0:0:0: [sr0] Device not ready: ASC=0x3a ASCQ=0x0
    end_request: I/O error, dev sr0, sector 215608
    sr 0:0:0:0: [sr0] Device not ready: Sense Key : 0x2 [current] 
    sr 0:0:0:0: [sr0] Device not ready: ASC=0x3a ASCQ=0x0
    end_request: I/O error, dev sr0, sector 270656
    __ratelimit: 27 messages suppressed
    Buffer I/O error on device sr0, logical block 67664
    +0+ the_result = 0x0 Sense Key : 0x0 [current] [descriptor]
    +1+ CDS_DISC_OK
    +0+ the_result = 0x0 Sense Key : 0x0 [current] [descriptor]
    +1+ CDS_DISC_OK
    +0+ the_result = 0x0 Sense Key : 0x0 [current] [descriptor]


3. Mount second CD immediately after insertion, read, unmount, eject:

    +0+ the_result = 0x8000002 Sense Key : 0x0 [current] [descriptor]
    +0+ the_result = 0x8000002 Sense Key : 0x0 [current] [descriptor]
    +0+ the_result = 0x8000002 Sense Key : 0x0 [current] [descriptor]
    Sense Key : 0x2 [current] 
    +5+ CDS_DISC_OK
    +0+ the_result = 0x8000002 Sense Key : 0x0 [current] [descriptor]
    +0+ the_result = 0x8000002 Sense Key : 0x0 [current] [descriptor]
    +0+ the_result = 0x8000002 Sense Key : 0x0 [current] [descriptor]
    Sense Key : 0x2 [current] 
    +5+ CDS_DISC_OK
    +0+ the_result = 0x0 Sense Key : 0x0 [current] [descriptor]
    +1+ CDS_DISC_OK
    +0+ the_result = 0x0 Sense Key : 0x0 [current] [descriptor]
    +1+ CDS_DISC_OK
    +0+ the_result = 0x0 Sense Key : 0x0 [current] [descriptor]
    ISO 9660 Extensions: Microsoft Joliet Level 3
    ISO 9660 Extensions: RRIP_1991A
    +0+ the_result = 0x0 Sense Key : 0x0 [current] [descriptor]
    +1+ CDS_DISC_OK
    +0+ the_result = 0x0 Sense Key : 0x0 [current] [descriptor]
    +1+ CDS_DISC_OK
    +0+ the_result = 0x0 Sense Key : 0x0 [current] [descriptor]
    +0+ the_result = 0x0 Sense Key : 0x0 [current] [descriptor]


When running a Debian userland, I see some debug messages every few seconds.
Probably there's a deamon polling all drives with removable media, preventing
the problem from happening.

Is this a bug in the generic SCSI CD-ROM code, or does it merely expose a bug
in the ps3rom driver?

Thanks in advance!

Index: ps3-linux-2.6/drivers/scsi/sr.c
===================================================================
--- ps3-linux-2.6.orig/drivers/scsi/sr.c	2008-06-06 14:59:50.000000000 +0200
+++ ps3-linux-2.6/drivers/scsi/sr.c	2008-06-06 15:30:03.000000000 +0200
@@ -178,6 +178,8 @@ int sr_test_unit_ready(struct scsi_devic
 		the_result = scsi_execute_req(sdev, cmd, DMA_NONE, NULL,
 					      0, sshdr, SR_TIMEOUT,
 					      retries--);
+		printk("+0+ the_result = 0x%x ", the_result);
+		scsi_show_sense_hdr(&sshdr);
 
 	} while (retries > 0 &&
 		 (!scsi_status_is_good(the_result) ||
Index: ps3-linux-2.6/drivers/scsi/sr_ioctl.c
===================================================================
--- ps3-linux-2.6.orig/drivers/scsi/sr_ioctl.c	2008-06-06 14:59:50.000000000 +0200
+++ ps3-linux-2.6/drivers/scsi/sr_ioctl.c	2008-06-06 15:04:28.000000000 +0200
@@ -306,23 +306,32 @@ int sr_drive_status(struct cdrom_device_
 		/* we have no changer support */
 		return -EINVAL;
 	}
-	if (0 == sr_test_unit_ready(cd->device, &sshdr))
+	if (0 == sr_test_unit_ready(cd->device, &sshdr)) {
+		printk("+1+ CDS_DISC_OK\n");
 		return CDS_DISC_OK;
+	}
+	scsi_show_sense_hdr(&sshdr);
 
 	if (!cdrom_get_media_event(cdi, &med)) {
-		if (med.media_present)
+		if (med.media_present) {
+			printk("+2+ CDS_DISC_OK\n");
 			return CDS_DISC_OK;
-		else if (med.door_open)
+		} else if (med.door_open) {
+			printk("+3+ CDS_TRAY_OPEN\n");
 			return CDS_TRAY_OPEN;
-		else
+		} else {
+			printk("+4+ CDS_NO_DISC\n");
 			return CDS_NO_DISC;
+		}
 	}
 
 	/*
 	 * 0x04 is format in progress .. but there must be a disc present!
 	 */
-	if (sshdr.sense_key == NOT_READY && sshdr.asc == 0x04)
+	if (sshdr.sense_key == NOT_READY && sshdr.asc == 0x04) {
+		printk("+5+ CDS_DISC_OK\n");
 		return CDS_DISC_OK;
+	}
 
 	/*
 	 * If not using Mt Fuji extended media tray reports,
@@ -331,11 +340,15 @@ int sr_drive_status(struct cdrom_device_
 	 */
 	if (scsi_sense_valid(&sshdr) &&
 	    /* 0x3a is medium not present */
-	    sshdr.asc == 0x3a)
+	    sshdr.asc == 0x3a) {
+		printk("+6+ CDS_NO_DISC\n");
 		return CDS_NO_DISC;
-	else
+	} else {
+		printk("+7+ CDS_TRAY_OPEN\n");
 		return CDS_TRAY_OPEN;
+	}
 
+	printk("+8+ CDS_DRIVE_NOT_READY\n");
 	return CDS_DRIVE_NOT_READY;
 }
 

With kind regards,
 
Geert Uytterhoeven
Software Architect

Sony Techsoft Centre
The Corporate Village · Da Vincilaan 7-D1 · B-1935 Zaventem · Belgium
 
Phone:    +32 (0)2 700 8453	
Fax:      +32 (0)2 700 8622	
E-mail:   Geert.Uytterhoeven@sonycom.com	
Internet: http://www.sony-europe.com/
 	
Sony Technology and Software Centre Europe	
A division of Sony Service Centre (Europe) N.V.	
Registered office: Technologielaan 7 · B-1840 Londerzeel · Belgium	
VAT BE 0413.825.160 · RPR Brussels	
Fortis 293-0376800-10 GEBA-BE-BB
---584349381-2109928023-1212761188=:16998--
