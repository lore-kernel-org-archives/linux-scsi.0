From: Pat LaVarre <p.lavarre@ieee.org>
Subject: Re: writable mmc profiles actually are writable
Date: 06 Oct 2003 17:56:47 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1065484607.2899.7.camel@patehci2>
References: <1064847281.24854.2.camel@patehci2>
	 <1064850600.25057.7.camel@patehci2> <20030929164654.GS15415@suse.de>
	 <1064855570.3184.3.camel@patehci2> <1064865746.4262.63.camel@patehci2>
	 <1065460336.10804.1.camel@patehci2> <1065463946.5185.8.camel@patehci2>
	 <20031006182223.GF972@suse.de> <20031006182510.GG972@suse.de>
	 <1065469831.5185.44.camel@patehci2>  <20031006203816.GJ972@suse.de>
	 <1065473899.6835.41.camel@patehci2>  <1065478448.2361.1.camel@patehci2>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email-out1.iomega.com ([147.178.1.82]:1160 "EHLO
	email.iomega.com") by vger.kernel.org with ESMTP id S261761AbTJFX4x
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 6 Oct 2003 19:56:53 -0400
In-Reply-To: <1065478448.2361.1.camel@patehci2>
List-Id: linux-scsi@vger.kernel.org
To: axboe@suse.de
Cc: linux-scsi@vger.kernel.org

Yep, still happy, same in -test6 as in -test5 e.g.

$ dmesg | grep ^sr
sr0: scsi3-mmc drive: 125x/125x caddy
sr0: scsi3-mmc maybe not writeable
sr0: scsi3-mmc writable profile: 0x0002
$
$ grep MMC /proc/sys/dev/cdrom/info
Can write other MMC-RW: 1 ...
$

Pat LaVarre

diff -ur linux-2.6.0-test6/include/scsi/scsi.h linux/include/scsi/scsi.h
--- linux-2.6.0-test6/include/scsi/scsi.h	2003-09-27 18:51:13.000000000 -0600
+++ linux/include/scsi/scsi.h	2003-10-06 16:11:52.000000000 -0600
@@ -74,6 +74,7 @@
 #define CHANGE_DEFINITION     0x40
 #define WRITE_SAME            0x41
 #define READ_TOC              0x43
+#define GET_CONFIGURATION     0x46
 #define LOG_SELECT            0x4c
 #define LOG_SENSE             0x4d
 #define MODE_SELECT_10        0x55
diff -ur linux-2.6.0-test6/include/linux/cdrom.h linux/include/linux/cdrom.h
--- linux-2.6.0-test6/include/linux/cdrom.h	2003-09-27 18:50:06.000000000 -0600
+++ linux/include/linux/cdrom.h	2003-10-06 16:11:52.000000000 -0600
@@ -388,6 +388,7 @@
 #define CDC_DVD_R		0x10000	/* drive can write DVD-R */
 #define CDC_DVD_RAM		0x20000	/* drive can write DVD-RAM */
 #define CDC_MO_DRIVE		0x40000 /* drive is an MO device */
+#define CDC_MMC_RW		0x80000 /* drive is other mmc "writable" "profile" */
 
 /* drive status possibilities returned by CDROM_DRIVE_STATUS ioctl */
 #define CDS_NO_INFO		0	/* if not implemented */
diff -ur linux-2.6.0-test6/drivers/cdrom/cdrom.c linux/drivers/cdrom/cdrom.c
--- linux-2.6.0-test6/drivers/cdrom/cdrom.c	2003-09-27 18:50:10.000000000 -0600
+++ linux/drivers/cdrom/cdrom.c	2003-10-06 17:50:21.934425152 -0600
@@ -426,7 +426,7 @@
 	if ((fp->f_flags & O_NONBLOCK) && (cdi->options & CDO_USE_FFLAGS))
 		ret = cdi->ops->open(cdi, 1);
 	else {
-		if ((fp->f_mode & FMODE_WRITE) && !CDROM_CAN(CDC_DVD_RAM))
+		if ((fp->f_mode & FMODE_WRITE) && !CDROM_CAN(CDC_DVD_RAM|CDC_MMC_RW))
 			return -EROFS;
 
 		ret = open_for_data(cdi);
@@ -2465,6 +2465,10 @@
 	for (cdi=topCdromPtr;cdi!=NULL;cdi=cdi->next)
 	    pos += sprintf(info+pos, "\t%d", CDROM_CAN(CDC_DVD_RAM) != 0);
 
+	pos += sprintf(info+pos, "\nCan write other MMC-RW:");
+	for (cdi=topCdromPtr;cdi!=NULL;cdi=cdi->next)
+	    pos += sprintf(info+pos, "\t%d", CDROM_CAN(CDC_MMC_RW) != 0);
+
 	strcpy(info+pos,"\n\n");
 		
         return proc_dostring(ctl, write, filp, buffer, lenp);
diff -ur linux-2.6.0-test6/drivers/scsi/sr.c linux/drivers/scsi/sr.c
--- linux-2.6.0-test6/drivers/scsi/sr.c	2003-09-27 18:50:13.000000000 -0600
+++ linux/drivers/scsi/sr.c	2003-10-06 17:50:15.781360560 -0600
@@ -67,7 +67,8 @@
 	(CDC_CLOSE_TRAY|CDC_OPEN_TRAY|CDC_LOCK|CDC_SELECT_SPEED| \
 	 CDC_SELECT_DISC|CDC_MULTI_SESSION|CDC_MCN|CDC_MEDIA_CHANGED| \
 	 CDC_PLAY_AUDIO|CDC_RESET|CDC_IOCTLS|CDC_DRIVE_STATUS| \
-	 CDC_CD_R|CDC_CD_RW|CDC_DVD|CDC_DVD_R|CDC_DVD_RAM|CDC_GENERIC_PACKET)
+	 CDC_CD_R|CDC_CD_RW|CDC_DVD|CDC_DVD_R|CDC_DVD_RAM|CDC_GENERIC_PACKET| \
+	 CDC_MMC_RW)
 
 static int sr_probe(struct device *);
 static int sr_remove(struct device *);
@@ -92,6 +93,10 @@
 static void get_sectorsize(struct scsi_cd *);
 static void get_capabilities(struct scsi_cd *);
 
+static void get_configuration(struct scsi_cd *);
+static int scsi_get_configuration(struct scsi_device *sdev,
+	unsigned char *buffer, int len, int timeout, int retries);
+
 static int sr_media_change(struct cdrom_device_info *, int);
 static int sr_packet(struct cdrom_device_info *, struct cdrom_generic_command *);
 
@@ -754,6 +759,7 @@
 	rc = scsi_mode_sense(cd->device, 0, 0x2a, buffer, 128,
 			     SR_TIMEOUT, 3, &data);
 
+	cd->cdi.mask |= CDC_MMC_RW;
 	if (!scsi_status_is_good(rc)) {
 		/* failed, drive doesn't have capabilities mode page */
 		cd->cdi.speed = 1;
@@ -816,6 +822,83 @@
 
 	scsi_release_request(SRpnt);
 	kfree(buffer);
+
+	if (!cd->device->writeable) {
+		printk("%s: scsi3-mmc maybe not writeable\n",
+		       cd->cdi.name);
+		get_configuration(cd);
+	}
+}
+
+static void get_configuration(struct scsi_cd *cd)
+{
+	unsigned char *buffer;
+	int rc, mmc_profile;
+
+	buffer = kmalloc(512, GFP_KERNEL | GFP_DMA);
+	if (!buffer) {
+		printk(KERN_ERR "sr: out of memory.\n");
+		return;
+	}
+
+	rc = scsi_get_configuration(cd->device, buffer, 8,
+			     SR_TIMEOUT, 1);
+	if (!scsi_status_is_good(rc)) {
+		kfree(buffer);
+		return;
+	}
+
+	mmc_profile = ((buffer[6] << 8) + buffer[7]);
+	switch (mmc_profile) {
+	case 0x0001: /* Non-Removable Disk */
+	case 0x0002: /* Removable Disk */
+	case 0x0003: /* Magneto-Optical Erasable */
+	case 0x0005: /* AS-MO */
+	case 0x0012: /* DVD-RAM */
+	case 0x001A: /* DVD+RW */
+	case 0x0022: /* DDCD-RW */
+		printk("%s: scsi3-mmc writable profile: 0x%04x\n",
+		       cd->cdi.name, mmc_profile);
+		cd->device->writeable = 1;
+		if (mmc_profile != 0x001A) { /* != DVD+RW */
+			cd->cdi.mask &= ~CDC_MMC_RW;
+		}
+		break;
+	default:
+		break;
+	}
+
+	kfree(buffer);
+}
+
+/* intended to be block-copy-edit of scsi_lib.c scsi_mode_sense */
+static int
+scsi_get_configuration(struct scsi_device *sdev,
+		  unsigned char *buffer, int len, int timeout, int retries)
+{
+	struct scsi_request *sreq = scsi_allocate_request(sdev, GFP_KERNEL);
+	unsigned char cmd[MAX_COMMAND_SIZE];
+	int ret;
+
+	if (!sreq)
+		return -1;
+
+	memset(&cmd[0], 0, MAX_COMMAND_SIZE);
+	cmd[0] = GET_CONFIGURATION;
+	cmd[8] = len;
+
+	sreq->sr_cmd_len = 0;
+	sreq->sr_sense_buffer[0] = 0;
+	sreq->sr_sense_buffer[2] = 0;
+	sreq->sr_data_direction = DMA_FROM_DEVICE;
+
+	memset(buffer, 0, len);
+
+	scsi_wait_req(sreq, cmd, buffer, len, timeout, retries);
+
+	ret = sreq->sr_result;
+	scsi_release_request(sreq);
+	return ret;
 }
 
 /*



