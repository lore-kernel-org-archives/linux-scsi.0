From: Pat LaVarre <p.lavarre@ieee.org>
Subject: Re: writable mmc profiles actually are writable
Date: 10 Oct 2003 16:43:19 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1065825799.2867.38.camel@patehci2>
References: <20031006182510.GG972@suse.de>
	 <1065469831.5185.44.camel@patehci2> <20031006203816.GJ972@suse.de>
	 <1065473899.6835.41.camel@patehci2> <1065478448.2361.1.camel@patehci2>
	 <1065484607.2899.7.camel@patehci2> <20031007053858.GL972@suse.de>
	 <20031006234543.A11937@one-eyed-alien.net> <20031007064829.GQ972@suse.de>
	 <20031007000018.B11937@one-eyed-alien.net>  <20031007070404.GU972@suse.de>
	 <1065818209.7434.11.camel@patehci2>  <1065819846.7434.35.camel@patehci2>
	 <1065821134.7434.46.camel@patehci2>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email-out2.iomega.com ([147.178.1.83]:13759 "EHLO
	email.iomega.com") by vger.kernel.org with ESMTP id S262732AbTJJWny
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 10 Oct 2003 18:43:54 -0400
In-Reply-To: <1065821134.7434.46.camel@patehci2>
List-Id: linux-scsi@vger.kernel.org
To: axboe@suse.de
Cc: mdharm-scsi@one-eyed-alien.net, linux-scsi@vger.kernel.org

May our review recommence!

The patch here changes four source files.

Please tell me if I have or I have not correctly patched as many as
three of the four source files:

include/linux/cdrom.h
drivers/ide/ide-cd.c
drivers/scsi/sr.c

I'm confident I have not correctly patched the source file:

drivers/cdrom/cdrom.c

I plead for review by eye of this patch, but I do Not recommend applying
this patch.  As yet this patch erroneously makes all /dev/scd*
writeable, just like the four-line patch that began this thread.

Pat LaVarre

diff -Nur linux-2.6.0-test7/include/linux/cdrom.h linux/include/linux/cdrom.h
--- linux-2.6.0-test7/include/linux/cdrom.h	2003-10-08 13:24:00.000000000 -0600
+++ linux/include/linux/cdrom.h	2003-10-10 15:37:16.000000000 -0600
@@ -388,6 +388,7 @@
 #define CDC_DVD_R		0x10000	/* drive can write DVD-R */
 #define CDC_DVD_RAM		0x20000	/* drive can write DVD-RAM */
 #define CDC_MO_DRIVE		0x40000 /* drive is an MO device */
+#define CDC_MMC_WR		0x80000	/* profile includes random write */
 
 /* drive status possibilities returned by CDROM_DRIVE_STATUS ioctl */
 #define CDS_NO_INFO		0	/* if not implemented */
diff -Nur linux-2.6.0-test7/drivers/ide/ide-cd.c linux/drivers/ide/ide-cd.c
--- linux-2.6.0-test7/drivers/ide/ide-cd.c	2003-10-08 13:24:04.000000000 -0600
+++ linux/drivers/ide/ide-cd.c	2003-10-10 15:36:33.000000000 -0600
@@ -2822,7 +2822,7 @@
 				CDC_MEDIA_CHANGED | CDC_PLAY_AUDIO | CDC_RESET |
 				CDC_IOCTLS | CDC_DRIVE_STATUS | CDC_CD_R |
 				CDC_CD_RW | CDC_DVD | CDC_DVD_R| CDC_DVD_RAM |
-				CDC_GENERIC_PACKET | CDC_MO_DRIVE,
+				CDC_GENERIC_PACKET | CDC_MO_DRIVE | CDC_MMC_WR,
 	.generic_packet		= ide_cdrom_packet,
 };
 
@@ -2832,7 +2832,7 @@
 	struct cdrom_device_info *devinfo = &info->devinfo;
 
 	devinfo->ops = &ide_cdrom_dops;
-	devinfo->mask = 0;
+	devinfo->mask = CDC_MMC_WR;
 	devinfo->speed = CDROM_STATE_FLAGS(drive)->current_speed;
 	devinfo->capacity = nslots;
 	devinfo->handle = (void *) drive;
diff -Nur linux-2.6.0-test7/drivers/scsi/sr.c linux/drivers/scsi/sr.c
--- linux-2.6.0-test7/drivers/scsi/sr.c	2003-10-08 13:24:03.000000000 -0600
+++ linux/drivers/scsi/sr.c	2003-10-10 15:48:12.322686720 -0600
@@ -67,7 +67,8 @@
 	(CDC_CLOSE_TRAY|CDC_OPEN_TRAY|CDC_LOCK|CDC_SELECT_SPEED| \
 	 CDC_SELECT_DISC|CDC_MULTI_SESSION|CDC_MCN|CDC_MEDIA_CHANGED| \
 	 CDC_PLAY_AUDIO|CDC_RESET|CDC_IOCTLS|CDC_DRIVE_STATUS| \
-	 CDC_CD_R|CDC_CD_RW|CDC_DVD|CDC_DVD_R|CDC_DVD_RAM|CDC_GENERIC_PACKET)
+	 CDC_CD_R|CDC_CD_RW|CDC_DVD|CDC_DVD_R|CDC_DVD_RAM|CDC_GENERIC_PACKET| \
+	 CDC_MMC_WR)
 
 static int sr_probe(struct device *);
 static int sr_remove(struct device *);
@@ -327,8 +328,12 @@
 	}
 
 	if (rq_data_dir(SCpnt->request) == WRITE) {
-		if (!cd->device->writeable)
-			return 0;
+		if (!cd->device->writeable) {
+			if ((cd->cdi.mask & CDC_MMC_WR) != 0) {
+				return 0;
+			}
+			cd->device->writeable = 1;
+		}
 		SCpnt->cmnd[0] = WRITE_10;
 		SCpnt->sc_data_direction = SCSI_DATA_WRITE;
 	} else if (rq_data_dir(SCpnt->request) == READ) {
@@ -550,7 +555,7 @@
 
 	cd->cdi.ops = &sr_dops;
 	cd->cdi.handle = cd;
-	cd->cdi.mask = 0;
+	cd->cdi.mask = CDC_MMC_WR;
 	cd->cdi.capacity = 1;
 	sprintf(cd->cdi.name, "sr%d", minor);
 
diff -Nur linux-2.6.0-test7/drivers/cdrom/cdrom.c linux/drivers/cdrom/cdrom.c
--- linux-2.6.0-test7/drivers/cdrom/cdrom.c	2003-10-08 13:24:02.000000000 -0600
+++ linux/drivers/cdrom/cdrom.c	2003-10-10 15:45:59.648856208 -0600
@@ -408,6 +408,24 @@
 	return 0;
 }
 
+/* Say if profile includes random write or not.
+ */
+static int cdrom_cdc_mmc_wr(struct cdrom_device_info *cdi)
+{
+	printk(KERN_INFO "cdrom_cdc_mmc_wr\n");
+	if (CDROM_CAN(CDC_DVD_RAM)) {
+		return 1;
+	}
+#if 0 /* FIXME */
+#error "try op x5A GPCMD_MODE_SENSE_10 of page x2A GPMODE_CAPABILITIES_PAGE"
+#error "return 0 if failed"
+#error "try op x46 GPGPCMD_GET_CONFIGURATION"
+#error "return 0 if failed"
+#error "return 0 if not random writable profile"
+#endif
+	return 1;
+}
+
 /* We use the open-option O_NONBLOCK to indicate that the
  * purpose of opening is only for subsequent ioctl() calls; no device
  * integrity checks are performed.
@@ -426,8 +444,12 @@
 	if ((fp->f_flags & O_NONBLOCK) && (cdi->options & CDO_USE_FFLAGS))
 		ret = cdi->ops->open(cdi, 1);
 	else {
-		if ((fp->f_mode & FMODE_WRITE) && !CDROM_CAN(CDC_DVD_RAM))
-			return -EROFS;
+		if ((fp->f_mode & FMODE_WRITE) && !CDROM_CAN(CDC_MMC_WR)) {
+			if (!cdrom_cdc_mmc_wr(cdi)) {
+				return -EROFS;
+			}
+			cdi->mask &= ~CDC_MMC_WR;
+		}
 
 		ret = open_for_data(cdi);
 	}
@@ -2406,6 +2428,10 @@
 	for (cdi=topCdromPtr;cdi!=NULL;cdi=cdi->next)
 	    pos += sprintf(info+pos, "\t%d", CDROM_CAN(CDC_DVD_RAM) != 0);
 
+	pos += sprintf(info+pos, "\nTolerates random write:");
+	for (cdi=topCdromPtr;cdi!=NULL;cdi=cdi->next)
+	    pos += sprintf(info+pos, "\t%d", CDROM_CAN(CDC_MMC_WR) != 0);
+
 	strcpy(info+pos,"\n\n");
 		
         return proc_dostring(ctl, write, filp, buffer, lenp);


