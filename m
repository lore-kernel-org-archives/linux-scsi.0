From: Pat LaVarre <p.lavarre@ieee.org>
Subject: Re: [PATCH] CDC_WR
Date: 14 Nov 2003 11:10:01 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1068833401.5539.86.camel@patrh9>
References: <1068479926.2313.7.camel@patrh9>
	 <1068485442.4495.25.camel@patrh9>  <1068589440.5909.33.camel@patrh9>
	 <1068762936.2851.50.camel@patrh9>  <1068763630.2851.56.camel@patrh9>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email-out1.iomega.com ([147.178.1.82]:27364 "EHLO
	email.iomega.com") by vger.kernel.org with ESMTP id S262790AbTKNSKg
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 14 Nov 2003 13:10:36 -0500
Received: from royntex01.iomegacorp.com (unknown [147.178.90.120])
	by email.iomega.com (Postfix) with ESMTP id 413DC1F16
	for <linux-scsi@vger.kernel.org>; Fri, 14 Nov 2003 11:10:36 -0700 (MST)
In-Reply-To: <1068763630.2851.56.camel@patrh9>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

The inline patch of this post sketches how we might choose to teach
cdrom.ko to interpret MMC features ... after we decide what
interpretation we like.

As is, this code clearly still needs work e.g. it says more cdrom.ko
devices are writable then we mean to consider writable, and it goes
badly wrong if ever a device reports more than xFFFF bytes of features
available.

Meanwhile, for the sake of development, as yet this patch conveniently
spits out a dump of all the "feature code"s and "profile"s.

For example, the dmesg I saw from a device that mixes not-current
profile x0002 "Removable Disk" together with not-current feature code
"x0020 "Random Writable" ... despite not actually supporting much
rewrite in place was:

hdc: ATAPI 48X DVD-ROM CD-R/RW drive, 2048kB Cache, UDMA(33)
cdrom: entering register_cdrom
Uniform CD-ROM driver Revision: 3.12
cdrom: drive "/dev/hdc" registered
cdrom: may be writable
cdrom: feature code x0000
cdrom: profile x0010
cdrom: profile x000A
cdrom: profile x0009
cdrom: profile x0008
cdrom: profile x0002 // Removable Disk
cdrom: feature code x0001
cdrom: feature code x0002
cdrom: feature code x0003
cdrom: feature code x0010
cdrom: feature code x001D
cdrom: feature code x001E
cdrom: feature code x001F
cdrom: feature code x0020 // Random Writable
cdrom: feature code x0021
cdrom: feature code x0023
cdrom: feature code x0024
cdrom: feature code x0026
cdrom: feature code x0027
cdrom: feature code x0028
cdrom: feature code x002A
cdrom: feature code x002B
cdrom: feature code x002D
cdrom: feature code x002E
cdrom: feature code x0100
cdrom: feature code x0101
cdrom: feature code x0103
cdrom: feature code x0104
cdrom: feature code x0105
cdrom: feature code x0106
cdrom: feature code x0107
cdrom: entering cdrom_open
...

Pat LaVarre

diff -Nur linux-2.6.0-test9/drivers/cdrom/cdrom.c linux/drivers/cdrom/cdrom.c
--- linux-2.6.0-test9/drivers/cdrom/cdrom.c	2003-10-25 12:43:01.000000000 -0600
+++ linux/drivers/cdrom/cdrom.c	2003-11-13 15:50:38.000000000 -0700
@@ -251,6 +251,9 @@
 /* #define ERRLOGMASK (CD_WARNING|CD_OPEN|CD_COUNT_TRACKS|CD_CLOSE) */
 /* #define ERRLOGMASK (CD_WARNING|CD_REG_UNREG|CD_DO_IOCTL|CD_OPEN|CD_CLOSE|CD_COUNT_TRACKS) */
 
+#undef ERRLOGMASK
+#define ERRLOGMASK (CD_WARNING|CD_REG_UNREG|CD_DO_IOCTL|CD_OPEN|CD_CLOSE|CD_COUNT_TRACKS)
+
 #include <linux/config.h>
 #include <linux/module.h>
 #include <linux/fs.h>
@@ -313,6 +316,7 @@
 #define CHECKAUDIO if ((ret=check_for_audio_disc(cdi, cdo))) return ret
 
 /* Not-exported routines. */
+static void cdrom_get_cdc(struct cdrom_device_info *cdi);
 static int open_for_data(struct cdrom_device_info * cdi);
 static int check_for_audio_disc(struct cdrom_device_info * cdi,
 			 struct cdrom_device_ops * cdo);
@@ -381,6 +385,8 @@
 	cdinfo(CD_REG_UNREG, "drive \"/dev/%s\" registered\n", cdi->name);
 	cdi->next = topCdromPtr; 	
 	topCdromPtr = cdi;
+
+	cdrom_get_cdc(cdi);
 	return 0;
 }
 #undef ENSURE
@@ -408,6 +414,114 @@
 	return 0;
 }
 
+/* Interpret the MMC feature x0000 "Profile List". */
+
+static int cdrom_profile_list(struct cdrom_device_info *cdi,
+	u_char * buf, int len)
+{
+	int offset;
+	for (offset = 4; (offset + 4) <= len; offset += 4) {
+		int profile = buf[offset] << 8 | buf[offset + 1];
+		cdinfo(CD_REG_UNREG, "profile x%04X\n", profile);
+		switch (profile) {
+			case 0x0001: /* Non-Removable Disk */
+			case 0x0002: /* Removable Disk */
+			case 0x0003: /* Magneto-Optical Erasable */
+			case 0x0005: /* AS-MO */
+			case 0x0012: /* DVD-RAM */
+			case 0x0022: /* DDCD-RW */
+				break;
+			case 0x001A: /* DVD+RW = not much rewrite in place */
+			default:
+				cdi->mask |= CDC_WR;
+				break;
+		}
+	}
+	return 0;
+}
+
+/* Interpret an MMC feature. */
+
+static int cdrom_feature(struct cdrom_device_info *cdi,
+	u_char * buf, int len)
+{
+	int feature_code = buf[0] << 8 | buf[1];
+	cdinfo(CD_REG_UNREG, "feature code x%04X\n", feature_code);
+	switch (feature_code) {
+		case 0x0000: /* "Profile List" */
+			cdrom_profile_list(cdi, buf, len);
+			break;
+		case 0x0020: /* "Random Writable" */
+			cdi->mask &= ~CDC_WR;
+			break;
+		default:
+			break;
+	}
+	return 0;
+}
+
+/* Interpret each MMC feature in order per mmc4r02f.pdf. */
+
+static int cdrom_each_feature(struct cdrom_device_info *cdi,
+	u_char * buf, int len)
+{
+	int ret = 0;
+	int offset;
+	int step;
+	for (offset = 8; (offset + 4) <= len; offset += step) {
+		step = (3 + 1 + buf[offset + 3]);
+		if ((offset + step) <= len) {
+			ret |= cdrom_feature(cdi, &buf[offset], step);
+		}
+	}
+	return ret;
+}
+
+/* Fetch the first few available MMC "feature"s. */
+
+static int cdrom_get_configuration(struct cdrom_device_info *cdi)
+{
+	struct cdrom_generic_command cgc;
+	struct cdrom_device_ops *cdo = cdi->ops;
+	u_char part[8];
+	int ret;
+	init_cdrom_command(&cgc, part, 8, CGC_DATA_READ);
+	cgc.cmd[0] = GPCMD_GET_CONFIGURATION; /* 0x46 */
+	cgc.cmd[7] = cgc.buflen >> 8;
+	cgc.cmd[8] = cgc.buflen & 0xff;
+	ret = cdo->generic_packet(cdi, &cgc);
+	if (!ret) {
+		int len = (4 + 0 + (part[0] << 24 | part[1] << 16 |
+			part[2] << 8 | part[3]));
+		u_char * whole = kmalloc(len, GFP_KERNEL);
+		if (!whole)
+			return -ENOMEM;
+		init_cdrom_command(&cgc, whole, len, CGC_DATA_READ);
+		cgc.cmd[0] = GPCMD_GET_CONFIGURATION; /* 0x46 */
+		cgc.cmd[7] = cgc.buflen >> 8;
+		cgc.cmd[8] = cgc.buflen & 0xff;
+		ret = cdo->generic_packet(cdi, &cgc);
+		if (!ret) {
+			ret = cdrom_each_feature(cdi, whole, len);
+		}
+		kfree(whole);
+	}
+	return ret;
+}
+
+/* Tweak cdi->mask to agree with MMC "feature" descriptors. */
+
+static void cdrom_get_cdc(struct cdrom_device_info *cdi)
+{
+	if (CDROM_CAN(CDC_WR) && !CDROM_CAN(CDC_DVD_RAM)) {
+		cdinfo(CD_REG_UNREG, "may be writable\n");
+		cdi->mask |= CDC_WR; /* guess not */
+		if (cdrom_get_configuration(cdi)) {
+			cdinfo(CD_REG_UNREG, "indeterminate features\n");
+		}
+	}
+}
+
 /* We use the open-option O_NONBLOCK to indicate that the
  * purpose of opening is only for subsequent ioctl() calls; no device
  * integrity checks are performed.
@@ -426,7 +540,7 @@
 	if ((fp->f_flags & O_NONBLOCK) && (cdi->options & CDO_USE_FFLAGS))
 		ret = cdi->ops->open(cdi, 1);
 	else {
-		if ((fp->f_mode & FMODE_WRITE) && !CDROM_CAN(CDC_DVD_RAM))
+		if ((fp->f_mode & FMODE_WRITE) && !CDROM_CAN(CDC_WR))
 			return -EROFS;
 
 		ret = open_for_data(cdi);
@@ -2406,6 +2520,10 @@
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


