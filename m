From: Pat LaVarre <p.lavarre@ieee.org>
Subject: [PATCH] MMC device writeable discovery
Date: 07 Nov 2003 16:35:28 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1068248128.7669.35.camel@patrh9>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email-out2.iomega.com ([147.178.1.83]:22249 "EHLO
	email.iomega.com") by vger.kernel.org with ESMTP id S262041AbTKGXf6
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 7 Nov 2003 18:35:58 -0500
Received: from royntex01.iomegacorp.com (unknown [147.178.90.120])
	by email.iomega.com (Postfix) with ESMTP id 5C3202D35
	for <linux-scsi@vger.kernel.org>; Fri,  7 Nov 2003 16:35:57 -0700 (MST)
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

-----Forwarded Message-----

From: Pat LaVarre <p.lavarre@ieee.org>
Subject: [PATCH] MMC device writeable discovery
Date: 07 Nov 2003 16:33:59 -0700

...:

[[[In hopes of connecting with more MMC gurus, I will forward these
remarks to linux-scsi after I send them to you.]]]

With this patch, I think we're there now!  I think by now we have taught
me how to persuade Linux that a PDT x05 DVD/CD is writable, no matter
via sr or ide-cd.

But now that we have peeled off that layer of the onion of this problem,
I regret to report I now have a new idea.  I'm now actually saying:

1) Please do NOT merge this patch into kernel.org Linux, not yet.

2) Please tell me if you want a version of this CDC_MMC_WR patch without
the GPCMD_GET_CONFIGURATION.  That smaller patch would warn people of
the coming change in /proc/sys/dev/cdrom/info without yet changing the
CDB's sent to the drive.

Sorry to surprise everyone.  You see, just now I took some bus traces
with this now-completed patch and reviewed those with a device-side MMC
guru of my acquaintance.  While I now believe we are correctly hooking
into Linux to help decide whether a device will ever be writeable or not
...

... I also now believe we're not yet correctly hooking into the device. 
Some of the pre-production device firmware with which I was testing had
a bug here.

Specifically now in bus traces often I see op x46 bytes 7:8
CurrentProfile = x0000.  Mmc4r02c.pdf English (page 224 of 606) says yes
we should expect to see x0000 any time the device has "no Profile"
"currently active".  

I'm now guessing we should fetch all the "feature"s, and then declare a
DVD/CD device writable if the x0020 RandomWritable feature is present,
no matter if "current".

As I learn more, I'll keep you & linux-scsi aware.

Pat LaVarre

diff -Nur linux-2.6.0-test9/drivers/cdrom/cdrom.c linux/drivers/cdrom/cdrom.c
--- linux-2.6.0-test9/drivers/cdrom/cdrom.c	2003-10-25 12:43:01.000000000 -0600
+++ linux/drivers/cdrom/cdrom.c	2003-11-07 15:40:42.467059144 -0700
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
@@ -408,6 +411,48 @@
 	return 0;
 }
 
+static int cdrom_get_configuration(struct cdrom_device_info *cdi)
+{
+	struct cdrom_generic_command cgc;
+	struct cdrom_device_ops *cdo = cdi->ops;
+	u_char buf[8];
+	int ret;
+	init_cdrom_command(&cgc, buf, sizeof(buf), CGC_DATA_READ);
+	cgc.cmd[0] = GPCMD_GET_CONFIGURATION; /* 0x46 */
+	cgc.cmd[7] = cgc.buflen >> 8;
+	cgc.cmd[8] = cgc.buflen & 0xff;
+	ret = cdo->generic_packet(cdi, &cgc);
+	if (!ret) {
+		int profile = buf[6] << 8 | buf[7];
+		cdinfo(CD_REG_UNREG, "MMC profile x%04X\n", profile);
+		switch (profile) {
+			case 0x0001: /* Non-Removable Disk */
+			case 0x0002: /* Removable Disk */
+			case 0x0003: /* Magneto-Optical Erasable */
+			case 0x0005: /* AS-MO */
+			case 0x0012: /* DVD-RAM */
+			case 0x0022: /* DDCD-RW */
+				return 0;
+			case 0x0000: /* "no Profile" "currently active" */
+			case 0x001A: /* DVD+RW = not much rewrite in place */
+			default:
+				break;
+		}
+	}
+	cdi->mask |= CDC_MMC_WR;
+	return ret;
+}
+
+static void cdrom_get_cdc(struct cdrom_device_info *cdi)
+{
+	if (CDROM_CAN(CDC_MMC_WR) && !CDROM_CAN(CDC_DVD_RAM)) {
+		cdinfo(CD_REG_UNREG, "cdrom_get_configuration\n");
+		if (cdrom_get_configuration(cdi)) {
+			cdinfo(CD_REG_UNREG, "cdrom_get_configuration NOT\n");
+		}
+	}
+}
+
 /* We use the open-option O_NONBLOCK to indicate that the
  * purpose of opening is only for subsequent ioctl() calls; no device
  * integrity checks are performed.
@@ -426,7 +471,7 @@
 	if ((fp->f_flags & O_NONBLOCK) && (cdi->options & CDO_USE_FFLAGS))
 		ret = cdi->ops->open(cdi, 1);
 	else {
-		if ((fp->f_mode & FMODE_WRITE) && !CDROM_CAN(CDC_DVD_RAM))
+		if ((fp->f_mode & FMODE_WRITE) && !CDROM_CAN(CDC_MMC_WR))
 			return -EROFS;
 
 		ret = open_for_data(cdi);
@@ -2406,6 +2451,10 @@
 	for (cdi=topCdromPtr;cdi!=NULL;cdi=cdi->next)
 	    pos += sprintf(info+pos, "\t%d", CDROM_CAN(CDC_DVD_RAM) != 0);
 
+	pos += sprintf(info+pos, "\nTolerates random write:");
+	for (cdi=topCdromPtr;cdi!=NULL;cdi=cdi->next)
+	    pos += sprintf(info+pos, "\t%d", CDROM_CAN(CDC_MMC_WR) != 0);
+
 	strcpy(info+pos,"\n\n");
 		
         return proc_dostring(ctl, write, filp, buffer, lenp);
diff -Nur linux-2.6.0-test9/include/linux/cdrom.h linux/include/linux/cdrom.h
--- linux-2.6.0-test9/include/linux/cdrom.h	2003-10-25 12:42:47.000000000 -0600
+++ linux/include/linux/cdrom.h	2003-11-07 15:06:56.967981808 -0700
@@ -388,6 +388,7 @@
 #define CDC_DVD_R		0x10000	/* drive can write DVD-R */
 #define CDC_DVD_RAM		0x20000	/* drive can write DVD-RAM */
 #define CDC_MO_DRIVE		0x40000 /* drive is an MO device */
+#define CDC_MMC_WR		0x80000	/* profile includes random write */
 
 /* drive status possibilities returned by CDROM_DRIVE_STATUS ioctl */
 #define CDS_NO_INFO		0	/* if not implemented */
diff -Nur linux-2.6.0-test9/drivers/ide/ide-cd.c linux/drivers/ide/ide-cd.c
--- linux-2.6.0-test9/drivers/ide/ide-cd.c	2003-10-25 12:43:32.000000000 -0600
+++ linux/drivers/ide/ide-cd.c	2003-11-07 15:07:15.658140472 -0700
@@ -2822,7 +2822,7 @@
 				CDC_MEDIA_CHANGED | CDC_PLAY_AUDIO | CDC_RESET |
 				CDC_IOCTLS | CDC_DRIVE_STATUS | CDC_CD_R |
 				CDC_CD_RW | CDC_DVD | CDC_DVD_R| CDC_DVD_RAM |
-				CDC_GENERIC_PACKET | CDC_MO_DRIVE,
+				CDC_GENERIC_PACKET | CDC_MO_DRIVE | CDC_MMC_WR,
 	.generic_packet		= ide_cdrom_packet,
 };
 
diff -Nur linux-2.6.0-test9/drivers/scsi/sr.c linux/drivers/scsi/sr.c
--- linux-2.6.0-test9/drivers/scsi/sr.c	2003-10-25 12:43:12.000000000 -0600
+++ linux/drivers/scsi/sr.c	2003-11-07 15:36:04.796271520 -0700
@@ -67,7 +67,8 @@
 	(CDC_CLOSE_TRAY|CDC_OPEN_TRAY|CDC_LOCK|CDC_SELECT_SPEED| \
 	 CDC_SELECT_DISC|CDC_MULTI_SESSION|CDC_MCN|CDC_MEDIA_CHANGED| \
 	 CDC_PLAY_AUDIO|CDC_RESET|CDC_IOCTLS|CDC_DRIVE_STATUS| \
-	 CDC_CD_R|CDC_CD_RW|CDC_DVD|CDC_DVD_R|CDC_DVD_RAM|CDC_GENERIC_PACKET)
+	 CDC_CD_R|CDC_CD_RW|CDC_DVD|CDC_DVD_R|CDC_DVD_RAM|CDC_GENERIC_PACKET| \
+	 CDC_MMC_WR)
 
 static int sr_probe(struct device *);
 static int sr_remove(struct device *);
@@ -327,8 +328,9 @@
 	}
 
 	if (rq_data_dir(SCpnt->request) == WRITE) {
-		if (!cd->device->writeable)
+		if ((cd->cdi.mask & CDC_MMC_WR) != 0) {
 			return 0;
+		}
 		SCpnt->cmnd[0] = WRITE_10;
 		SCpnt->sc_data_direction = SCSI_DATA_WRITE;
 	} else if (rq_data_dir(SCpnt->request) == READ) {
@@ -557,6 +559,7 @@
 	sdev->sector_size = 2048;	/* A guess, just in case */
 
 	/* FIXME: need to handle a get_capabilities failure properly ?? */
+	cd->device->writeable = 1; /* = ((cd->cdi.mask & CDC_MMC_WR) == 0); */
 	get_capabilities(cd);
 	sr_vendor_init(cd);
 
@@ -564,6 +567,7 @@
 			"%s/cd", sdev->devfs_name);
 	disk->driverfs_dev = &sdev->sdev_gendev;
 	register_cdrom(&cd->cdi);
+	cd->device->writeable = ((cd->cdi.mask & CDC_MMC_WR) == 0);
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


