From: Pat LaVarre <p.lavarre@ieee.org>
Subject: [PATCH] sr cd->device->writeable without purpose
Date: 06 Nov 2003 17:02:23 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1068163343.2285.55.camel@patrh9>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email-out1.iomega.com ([147.178.1.82]:41962 "EHLO
	email.iomega.com") by vger.kernel.org with ESMTP id S261240AbTKGACu
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 6 Nov 2003 19:02:50 -0500
Received: from royntex01.iomegacorp.com (unknown [147.178.90.120])
	by email.iomega.com (Postfix) with ESMTP id 614C329FC
	for <linux-scsi@vger.kernel.org>; Thu,  6 Nov 2003 17:02:49 -0700 (MST)
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

> http://marc.theaimsgroup.com/?l=linux-scsi&m=106813641032686
> List:     linux-scsi
> Subject:  Re: [PATCH] CDC_MMC_WR
> Date:     2003-11-06 16:32:35

The inline text patch of this email concretely demoes why I think the sr
cd->device->writeable bit becomes vestigial - has no remaining purpose -
once we branch on CDC_MMC_WR instead of cd->device->writeable to decide
to pass thru or reject writes.

This patch differs from that simpler CDC_MMC_WR patch by updating sr
cd->device->writeable bit whenever cdrom corrects the sr guess of
CDC_MMC_WR via op x46 GPCMD_GET_CONFIGURATION.

But as far as I can tell, Linux works no better when I add this
complication.  Can anyone educate me differently?  I need to learn
something new before I can understand that offline suggestion of "have
the ->writeable bit actually be set if the device is writeable".

Running this code against ATAPI/USB DVD/CD of various kinds, I notice
sr_cdi_notify always clears cd->device->writeable.  This consequence
arises naturally from the fact that this patch calls cdo->cdi_notify
only after cdi->mask |= CDC_MMC_WR.

Pat LaVarre x4402

diff -Nur linux-2.6.0-test9/drivers/cdrom/cdrom.c linux/drivers/cdrom/cdrom.c
--- linux-2.6.0-test9/drivers/cdrom/cdrom.c	2003-10-25 12:43:01.000000000 -0600
+++ linux/drivers/cdrom/cdrom.c	2003-11-06 16:18:55.470432000 -0700
@@ -313,6 +313,7 @@
 #define CHECKAUDIO if ((ret=check_for_audio_disc(cdi, cdo))) return ret
 
 /* Not-exported routines. */
+static void cdrom_get_cdc(struct cdrom_device_info *cdi);
 static int open_for_data(struct cdrom_device_info * cdi);
 static int check_for_audio_disc(struct cdrom_device_info * cdi,
 			 struct cdrom_device_ops * cdo);
@@ -365,6 +366,7 @@
 	ENSURE(audio_ioctl, CDC_PLAY_AUDIO);
 	ENSURE(dev_ioctl, CDC_IOCTLS);
 	ENSURE(generic_packet, CDC_GENERIC_PACKET);
+/*	ENSURE(cdi_notify, CDC_); */
 	cdi->mc_flags = 0;
 	cdo->n_minors = 0;
         cdi->options = CDO_USE_FFLAGS;
@@ -381,6 +383,8 @@
 	cdinfo(CD_REG_UNREG, "drive \"/dev/%s\" registered\n", cdi->name);
 	cdi->next = topCdromPtr; 	
 	topCdromPtr = cdi;
+
+	cdrom_get_cdc(cdi);
 	return 0;
 }
 #undef ENSURE
@@ -408,6 +412,52 @@
 	return 0;
 }
 
+static int cdrom_get_configuration(struct cdrom_device_info *cdi)
+{
+	struct cdrom_generic_command cgc;
+	struct cdrom_device_ops *cdo = cdi->ops;
+	u_char buf[8];
+	int ret;
+	init_cdrom_command(&cgc, buf, sizeof(buf), CGC_DATA_READ);
+	cgc.cmd[0] = GPCMD_GET_CONFIGURATION;
+	cgc.cmd[7] = cgc.buflen >> 8;
+	cgc.cmd[8] = cgc.buflen & 0xff;
+	cgc.data_direction = CGC_DATA_READ;
+	ret = cdo->generic_packet(cdi, &cgc);
+	if (!ret) {
+		int profile = buf[6] << 8 | buf[7];
+		cdinfo(CD_REG_UNREG, "/dev/%s: "
+			"MMC profile x%04X\n", cdi->name, profile);
+		switch (profile) {
+			case 0x0001: /* Non-Removable Disk */
+			case 0x0002: /* Removable Disk */
+			case 0x0003: /* Magneto-Optical Erasable */
+			case 0x0005: /* AS-MO */
+			case 0x0012: /* DVD-RAM */
+			case 0x0022: /* DDCD-RW */
+				return 0;
+			case 0x001A: /* DVD+RW = not much rewrite in place */
+			default:
+				break;
+		}
+	}
+	cdi->mask |= CDC_MMC_WR;
+	if (cdo->cdi_notify != NULL) cdo->cdi_notify(cdi);
+	return ret; /* ret may here be zero */
+}
+
+static void cdrom_get_cdc(struct cdrom_device_info *cdi)
+{
+	if (CDROM_CAN(CDC_MMC_WR) && !CDROM_CAN(CDC_DVD_RAM)) {
+		cdinfo(CD_REG_UNREG, "/dev/%s: "
+			"cdrom_get_configuration\n", cdi->name);
+		if (cdrom_get_configuration(cdi)) {
+			cdinfo(CD_REG_UNREG, "/dev/%s: "
+				"cdrom_get_configuration not\n", cdi->name);
+		}
+	}
+}
+
 /* We use the open-option O_NONBLOCK to indicate that the
  * purpose of opening is only for subsequent ioctl() calls; no device
  * integrity checks are performed.
@@ -426,8 +476,9 @@
 	if ((fp->f_flags & O_NONBLOCK) && (cdi->options & CDO_USE_FFLAGS))
 		ret = cdi->ops->open(cdi, 1);
 	else {
-		if ((fp->f_mode & FMODE_WRITE) && !CDROM_CAN(CDC_DVD_RAM))
+		if ((fp->f_mode & FMODE_WRITE) && !CDROM_CAN(CDC_MMC_WR)) {
 			return -EROFS;
+		}
 
 		ret = open_for_data(cdi);
 	}
@@ -2406,6 +2457,10 @@
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
+++ linux/include/linux/cdrom.h	2003-11-06 14:47:52.000000000 -0700
@@ -388,6 +388,7 @@
 #define CDC_DVD_R		0x10000	/* drive can write DVD-R */
 #define CDC_DVD_RAM		0x20000	/* drive can write DVD-RAM */
 #define CDC_MO_DRIVE		0x40000 /* drive is an MO device */
+#define CDC_MMC_WR		0x80000	/* profile includes random write */
 
 /* drive status possibilities returned by CDROM_DRIVE_STATUS ioctl */
 #define CDS_NO_INFO		0	/* if not implemented */
@@ -773,6 +774,7 @@
 	/* handle uniform packets for scsi type devices (scsi,atapi) */
 	int (*generic_packet) (struct cdrom_device_info *,
 			       struct cdrom_generic_command *);
+	void (*cdi_notify) (struct cdrom_device_info *);
 };
 
 /* the general block_device operations structure: */
diff -Nur linux-2.6.0-test9/drivers/ide/ide-cd.c linux/drivers/ide/ide-cd.c
--- linux-2.6.0-test9/drivers/ide/ide-cd.c	2003-10-25 12:43:32.000000000 -0600
+++ linux/drivers/ide/ide-cd.c	2003-11-06 14:48:18.000000000 -0700
@@ -2822,7 +2822,8 @@
 				CDC_MEDIA_CHANGED | CDC_PLAY_AUDIO | CDC_RESET |
 				CDC_IOCTLS | CDC_DRIVE_STATUS | CDC_CD_R |
 				CDC_CD_RW | CDC_DVD | CDC_DVD_R| CDC_DVD_RAM |
-				CDC_GENERIC_PACKET | CDC_MO_DRIVE,
+				CDC_GENERIC_PACKET | CDC_MO_DRIVE | CDC_MMC_WR,
+	.cdi_notify		= NULL,
 	.generic_packet		= ide_cdrom_packet,
 };
 
diff -Nur linux-2.6.0-test9/drivers/scsi/sr.c linux/drivers/scsi/sr.c
--- linux-2.6.0-test9/drivers/scsi/sr.c	2003-10-25 12:43:12.000000000 -0600
+++ linux/drivers/scsi/sr.c	2003-11-06 15:04:33.000000000 -0700
@@ -67,7 +67,8 @@
 	(CDC_CLOSE_TRAY|CDC_OPEN_TRAY|CDC_LOCK|CDC_SELECT_SPEED| \
 	 CDC_SELECT_DISC|CDC_MULTI_SESSION|CDC_MCN|CDC_MEDIA_CHANGED| \
 	 CDC_PLAY_AUDIO|CDC_RESET|CDC_IOCTLS|CDC_DRIVE_STATUS| \
-	 CDC_CD_R|CDC_CD_RW|CDC_DVD|CDC_DVD_R|CDC_DVD_RAM|CDC_GENERIC_PACKET)
+	 CDC_CD_R|CDC_CD_RW|CDC_DVD|CDC_DVD_R|CDC_DVD_RAM|CDC_GENERIC_PACKET| \
+	 CDC_MMC_WR)
 
 static int sr_probe(struct device *);
 static int sr_remove(struct device *);
@@ -94,6 +95,7 @@
 
 static int sr_media_change(struct cdrom_device_info *, int);
 static int sr_packet(struct cdrom_device_info *, struct cdrom_generic_command *);
+static void sr_cdi_notify(struct cdrom_device_info *);
 
 static struct cdrom_device_ops sr_dops = {
 	.open			= sr_open,
@@ -110,9 +112,23 @@
 	.dev_ioctl		= sr_dev_ioctl,
 	.capability		= SR_CAPABILITIES,
 	.generic_packet		= sr_packet,
+	.cdi_notify		= sr_cdi_notify,
 };
 
 /*
+ * sr_cdi_notify carelessly accepts any cdi change whatsoever,
+ * and copies CDC_MMC_WR-not-masked into writeable more often than useful.
+ */
+
+static void sr_cdi_notify(struct cdrom_device_info *cdi)
+{
+	struct scsi_cd *cd = cdi->handle;
+	cd->device->writeable = ((cd->cdi.mask & CDC_MMC_WR) == 0);
+	printk("/dev/%s: sr_cdi_notify: writeable %d\n",
+		cdi->name, cd->device->writeable);
+}
+
+/*
  * This function checks to see if the media has been changed in the
  * CDROM drive.  It is possible that we have already sensed a change,
  * or the drive may have sensed one and not yet reported it.  We must
@@ -327,8 +343,9 @@
 	}
 
 	if (rq_data_dir(SCpnt->request) == WRITE) {
-		if (!cd->device->writeable)
+		if ((cd->cdi.mask & CDC_MMC_WR) != 0) {
 			return 0;
+		}
 		SCpnt->cmnd[0] = WRITE_10;
 		SCpnt->sc_data_direction = SCSI_DATA_WRITE;
 	} else if (rq_data_dir(SCpnt->request) == READ) {
@@ -557,6 +574,7 @@
 	sdev->sector_size = 2048;	/* A guess, just in case */
 
 	/* FIXME: need to handle a get_capabilities failure properly ?? */
+	cd->device->writeable = 1; /* ((cd->cdi.mask & CDC_MMC_WR) == 0); */
 	get_capabilities(cd);
 	sr_vendor_init(cd);
 
@@ -788,8 +806,6 @@
 	if ((buffer[n + 3] & 0x20) == 0) {
 		/* can't write DVD-RAM media */
 		cd->cdi.mask |= CDC_DVD_RAM;
-	} else {
-		cd->device->writeable = 1;
 	}
 	if ((buffer[n + 3] & 0x10) == 0)
 		/* can't write DVD-R media */


