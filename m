From: Pat LaVarre <p.lavarre@ieee.org>
Subject: [PATCH] CDC_WR
Date: 10 Nov 2003 08:58:46 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1068479926.2313.7.camel@patrh9>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email-out2.iomega.com ([147.178.1.83]:3300 "EHLO
	email.iomega.com") by vger.kernel.org with ESMTP id S263936AbTKJP7N
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 10 Nov 2003 10:59:13 -0500
Received: from royntex01.iomegacorp.com (unknown [147.178.90.120])
	by email.iomega.com (Postfix) with ESMTP id 17E292363
	for <linux-scsi@vger.kernel.org>; Mon, 10 Nov 2003 08:59:12 -0700 (MST)
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

-----Forwarded Message-----

From: Pat LaVarre <p.lavarre@ieee.org>
Subject: [PATCH] CDC_WR
Date: 10 Nov 2003 08:57:12 -0700

...:

If as yet you vote we move forward in precisely the following direction,
fine.  If not, of course I hope you can find time to redirect me.

> > a version of this CDC_MMC_WR patch
> > without the GPCMD_GET_CONFIGURATION ...
> > warn ... change ... /proc/sys/dev/cdrom/info
> > without yet changing the CDB's sent to the drive ...

The plain text inline patch of This email takes just that baby step of
distinguishing CDC_WR from CDC_DVD_RAM.

This patch is my CDC_MMC_WR patch yet again, but with my final wrong
step forward deleted.  In this patch we do Not fetch the mmc
drive-with-disc "profile" that we Now know so often appears not
"currently active".

In my quest for a solution, I hear Three relevant rumours, slanderous or
not:

1) Microsoft/ Apple/ etc. distinguish only writable discs from
unwritable discs, not writable devices from unwritable devices, so from
those precedents we get no guidance to follow in guessing what SCSI
commands will reliably tell us if a device is writable.

2) Linux sd wrestles with this same trouble, now seen in cdrom above
sr/ide-cd, for the same reason.

3) Linux doesn't yet support the write-protect tabs on dvd-ram discs, so
we can't look there to find code we can copy-edit for distinguishing
rewritable from read-only discs.

I'll work now to sort truth from fiction out of these rumours, and to
try and dream up an mmc command sequence that distinguish mmc drives
that support truly rewritable dvd discs such as dvd-ram from mmc drives
that support only the the not-so-very rewritable-in-place DVD+RW discs.

Pat LaVarre

diff -Nur linux-2.6.0-test9/drivers/cdrom/cdrom.c linux/drivers/cdrom/cdrom.c
--- linux-2.6.0-test9/drivers/cdrom/cdrom.c	2003-10-25 12:43:01.000000000 -0600
+++ linux/drivers/cdrom/cdrom.c	2003-11-10 08:41:23.000000000 -0700
@@ -313,6 +313,7 @@
 #define CHECKAUDIO if ((ret=check_for_audio_disc(cdi, cdo))) return ret
 
 /* Not-exported routines. */
+static void cdrom_get_cdc(struct cdrom_device_info *cdi);
 static int open_for_data(struct cdrom_device_info * cdi);
 static int check_for_audio_disc(struct cdrom_device_info * cdi,
 			 struct cdrom_device_ops * cdo);
@@ -381,6 +382,8 @@
 	cdinfo(CD_REG_UNREG, "drive \"/dev/%s\" registered\n", cdi->name);
 	cdi->next = topCdromPtr; 	
 	topCdromPtr = cdi;
+
+	cdrom_get_cdc(cdi);
 	return 0;
 }
 #undef ENSURE
@@ -408,6 +411,14 @@
 	return 0;
 }
 
+static void cdrom_get_cdc(struct cdrom_device_info *cdi)
+{
+	if (CDROM_CAN(CDC_WR) && !CDROM_CAN(CDC_DVD_RAM)) {
+		cdinfo(CD_REG_UNREG, "might not write well\n");
+		cdi->mask |= CDC_WR;
+	}
+}
+
 /* We use the open-option O_NONBLOCK to indicate that the
  * purpose of opening is only for subsequent ioctl() calls; no device
  * integrity checks are performed.
@@ -426,7 +437,7 @@
 	if ((fp->f_flags & O_NONBLOCK) && (cdi->options & CDO_USE_FFLAGS))
 		ret = cdi->ops->open(cdi, 1);
 	else {
-		if ((fp->f_mode & FMODE_WRITE) && !CDROM_CAN(CDC_DVD_RAM))
+		if ((fp->f_mode & FMODE_WRITE) && !CDROM_CAN(CDC_WR))
 			return -EROFS;
 
 		ret = open_for_data(cdi);
@@ -2406,6 +2417,10 @@
 	for (cdi=topCdromPtr;cdi!=NULL;cdi=cdi->next)
 	    pos += sprintf(info+pos, "\t%d", CDROM_CAN(CDC_DVD_RAM) != 0);
 
+	pos += sprintf(info+pos, "\nTolerates random write:");
+	for (cdi=topCdromPtr;cdi!=NULL;cdi=cdi->next)
+	    pos += sprintf(info+pos, "\t%d", CDROM_CAN(CDC_WR) != 0);
+
 	strcpy(info+pos,"\n\n");
 		
         return proc_dostring(ctl, write, filp, buffer, lenp);
diff -Nur linux-2.6.0-test9/include/linux/cdrom.h linux/include/linux/cdrom.h
--- linux-2.6.0-test9/include/linux/cdrom.h	2003-10-25 12:42:47.000000000 -0600
+++ linux/include/linux/cdrom.h	2003-11-10 08:28:59.000000000 -0700
@@ -388,6 +388,7 @@
 #define CDC_DVD_R		0x10000	/* drive can write DVD-R */
 #define CDC_DVD_RAM		0x20000	/* drive can write DVD-RAM */
 #define CDC_MO_DRIVE		0x40000 /* drive is an MO device */
+#define CDC_WR			0x80000	/* drive tolerates random write */
 
 /* drive status possibilities returned by CDROM_DRIVE_STATUS ioctl */
 #define CDS_NO_INFO		0	/* if not implemented */
diff -Nur linux-2.6.0-test9/drivers/ide/ide-cd.c linux/drivers/ide/ide-cd.c
--- linux-2.6.0-test9/drivers/ide/ide-cd.c	2003-10-25 12:43:32.000000000 -0600
+++ linux/drivers/ide/ide-cd.c	2003-11-10 08:41:52.000000000 -0700
@@ -2822,7 +2822,7 @@
 				CDC_MEDIA_CHANGED | CDC_PLAY_AUDIO | CDC_RESET |
 				CDC_IOCTLS | CDC_DRIVE_STATUS | CDC_CD_R |
 				CDC_CD_RW | CDC_DVD | CDC_DVD_R| CDC_DVD_RAM |
-				CDC_GENERIC_PACKET | CDC_MO_DRIVE,
+				CDC_GENERIC_PACKET | CDC_MO_DRIVE | CDC_WR,
 	.generic_packet		= ide_cdrom_packet,
 };
 
diff -Nur linux-2.6.0-test9/drivers/scsi/sr.c linux/drivers/scsi/sr.c
--- linux-2.6.0-test9/drivers/scsi/sr.c	2003-10-25 12:43:12.000000000 -0600
+++ linux/drivers/scsi/sr.c	2003-11-10 08:46:04.000000000 -0700
@@ -67,7 +67,8 @@
 	(CDC_CLOSE_TRAY|CDC_OPEN_TRAY|CDC_LOCK|CDC_SELECT_SPEED| \
 	 CDC_SELECT_DISC|CDC_MULTI_SESSION|CDC_MCN|CDC_MEDIA_CHANGED| \
 	 CDC_PLAY_AUDIO|CDC_RESET|CDC_IOCTLS|CDC_DRIVE_STATUS| \
-	 CDC_CD_R|CDC_CD_RW|CDC_DVD|CDC_DVD_R|CDC_DVD_RAM|CDC_GENERIC_PACKET)
+	 CDC_CD_R|CDC_CD_RW|CDC_DVD|CDC_DVD_R|CDC_DVD_RAM|CDC_GENERIC_PACKET| \
+	 CDC_WR)
 
 static int sr_probe(struct device *);
 static int sr_remove(struct device *);
@@ -327,8 +328,9 @@
 	}
 
 	if (rq_data_dir(SCpnt->request) == WRITE) {
-		if (!cd->device->writeable)
+		if ((cd->cdi.mask & CDC_WR) != 0) {
 			return 0;
+		}
 		SCpnt->cmnd[0] = WRITE_10;
 		SCpnt->sc_data_direction = SCSI_DATA_WRITE;
 	} else if (rq_data_dir(SCpnt->request) == READ) {
@@ -557,6 +559,7 @@
 	sdev->sector_size = 2048;	/* A guess, just in case */
 
 	/* FIXME: need to handle a get_capabilities failure properly ?? */
+	cd->device->writeable = 1; /* = ((cd->cdi.mask & CDC_WR) == 0); */
 	get_capabilities(cd);
 	sr_vendor_init(cd);
 
@@ -564,6 +567,7 @@
 			"%s/cd", sdev->devfs_name);
 	disk->driverfs_dev = &sdev->sdev_gendev;
 	register_cdrom(&cd->cdi);
+	cd->device->writeable = ((cd->cdi.mask & CDC_WR) == 0);
 	set_capacity(disk, cd->capacity);
 	disk->private_data = &cd->driver;
 	disk->queue = sdev->request_queue;
@@ -788,8 +792,6 @@
 	if ((buffer[n + 3] & 0x20) == 0) {
 		/* can't write DVD-RAM media */
 		cd->cdi.mask |= CDC_DVD_RAM;
-	} else {
-		cd->device->writeable = 1;
 	}
 	if ((buffer[n + 3] & 0x10) == 0)
 		/* can't write DVD-R media */


