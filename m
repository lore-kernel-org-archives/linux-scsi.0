From: Pat LaVarre <p.lavarre@ieee.org>
Subject: Re: writable mmc profiles actually are writable
Date: 06 Oct 2003 14:58:20 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1065473899.6835.41.camel@patehci2>
References: <1064847281.24854.2.camel@patehci2>
	 <1064850600.25057.7.camel@patehci2> <20030929164654.GS15415@suse.de>
	 <1064855570.3184.3.camel@patehci2> <1064865746.4262.63.camel@patehci2>
	 <1065460336.10804.1.camel@patehci2> <1065463946.5185.8.camel@patehci2>
	 <20031006182223.GF972@suse.de> <20031006182510.GG972@suse.de>
	 <1065469831.5185.44.camel@patehci2>  <20031006203816.GJ972@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email-out1.iomega.com ([147.178.1.82]:16890 "EHLO
	email.iomega.com") by vger.kernel.org with ESMTP id S261749AbTJFU6c
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 6 Oct 2003 16:58:32 -0400
In-Reply-To: <20031006203816.GJ972@suse.de>
List-Id: linux-scsi@vger.kernel.org
To: axboe@suse.de
Cc: linux-scsi@vger.kernel.org

> patches to make the detection more modern ...

Below appears a copy of an old patch to try op x46 get_configuration any
time mode page x2a doesn't already say the pdt x05 dvd/cd device is
writable.

> I'd propose just adding better detection of
> new devices, and adding a specific "randomly
> writable" flag instead of abusing CDC_DVD_RAM.

Ah, did that, see below.  With this remark to motivate me, I will rev
this -test5 patch to fit with -test6 and then repost.

> I haven't yet had to deal with dvd+rw or
> ddcd_rw (is this like mtr?

Sorry I do not know mtr.

> mo and dvd-ram have been supported for a long
> time and should be set with CDC_DVD_RAM,

Sorry I do not understand.  I remember noticing CDC_MO_DRIVE appears
only drivers/ide/ not in drivers/scsi/.  Weakly I conclude mo doesn't
work the same in atapi and usb-storage.

> the disk profiles aren't driven by ide-cd or
> sr.

Sorry I do not understand.

In drivers/scsi/sr.c I find:
cd->cdi.mask |= CDC_DVD_RAM;

In drivers/ide/ide-cd.c I find:
devinfo->mask |= CDC_DVD_RAM;

I conclude sr and ide-cd tell cdrom whether the device "profile" is
writable or not.  Is that wrong?

> you should have done

Thanks again for finding the time to clue me in.

Pat LaVarre

diff -Nur linux-2.6.0-test5/include/scsi/scsi.h linux/include/scsi/scsi.h
diff -Nur linux-2.6.0-test5/include/linux/cdrom.h linux/include/linux/cdrom.h
diff -Nur linux-2.6.0-test5/drivers/cdrom/cdrom.c linux/drivers/cdrom/cdrom.c
diff -Nur linux-2.6.0-test5/drivers/scsi/sr.c linux/drivers/scsi/sr.c
--- linux-2.6.0-test5/include/scsi/scsi.h	2003-09-08 13:50:41.000000000 -0600
+++ linux/include/scsi/scsi.h	2003-09-10 17:05:37.000000000 -0600
@@ -81,6 +81,7 @@
 #define CHANGE_DEFINITION     0x40
 #define WRITE_SAME            0x41
 #define READ_TOC              0x43
+#define GET_CONFIGURATION     0x46
 #define LOG_SELECT            0x4c
 #define LOG_SENSE             0x4d
 #define MODE_SELECT_10        0x55
--- linux-2.6.0-test5/include/linux/cdrom.h	2003-09-08 13:49:51.000000000 -0600
+++ linux/include/linux/cdrom.h	2003-09-10 17:05:37.000000000 -0600
@@ -388,6 +388,7 @@
 #define CDC_DVD_R		0x10000	/* drive can write DVD-R */
 #define CDC_DVD_RAM		0x20000	/* drive can write DVD-RAM */
 #define CDC_MO_DRIVE		0x40000 /* drive is an MO device */
+#define CDC_MMC_RW		0x80000 /* drive is other mmc "writable" "profile" */
 
 /* drive status possibilities returned by CDROM_DRIVE_STATUS ioctl */
 #define CDS_NO_INFO		0	/* if not implemented */
--- linux-2.6.0-test5/drivers/cdrom/cdrom.c	2003-09-08 13:49:53.000000000 -0600
+++ linux/drivers/cdrom/cdrom.c	2003-09-10 17:05:37.000000000 -0600
@@ -426,7 +426,7 @@
 	if ((fp->f_flags & O_NONBLOCK) && (cdi->options & CDO_USE_FFLAGS))
 		ret = cdi->ops->open(cdi, 1);
 	else {
-		if ((fp->f_mode & FMODE_WRITE) && !CDROM_CAN(CDC_DVD_RAM))
+		if ((fp->f_mode & FMODE_WRITE) && !CDROM_CAN(CDC_DVD_RAM|CDC_MMC_RW))
 			return -EROFS;
 
 		ret = open_for_data(cdi);
@@ -2456,6 +2456,10 @@
 	for (cdi=topCdromPtr;cdi!=NULL;cdi=cdi->next)
 	    pos += sprintf(info+pos, "\t%d", CDROM_CAN(CDC_DVD_RAM) != 0);
 
+	pos += sprintf(info+pos, "\nCan write other MMC-RW:");
+	for (cdi=topCdromPtr;cdi!=NULL;cdi=cdi->next)
+	    pos += sprintf(info+pos, "\t%d", CDROM_CAN(CDC_MMC_RW) != 0);
+
 	strcpy(info+pos,"\n\n");
 		
         return proc_dostring(ctl, write, filp, buffer, lenp);
--- linux-2.6.0-test5/drivers/scsi/sr.c	2003-09-08 13:49:58.000000000 -0600
+++ linux/drivers/scsi/sr.c	2003-09-10 17:13:08.000000000 -0600
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
 
@@ -755,6 +760,7 @@
 	rc = scsi_mode_sense(cd->device, 0, 0x2a, buffer, 128,
 			     SR_TIMEOUT, 3, &data);
 
+	cd->cdi.mask |= CDC_MMC_RW;
 	if (!scsi_status_is_good(rc)) {
 		/* failed, drive doesn't have capabilities mode page */
 		cd->cdi.speed = 1;
@@ -817,6 +823,83 @@
 
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
+/* intended to be block-copy-edit of scsi.lib.c scsi_mode_sense */
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


