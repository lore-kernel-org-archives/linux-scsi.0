From: Pat LaVarre <p.lavarre@ieee.org>
Subject: Re: [PATCH] CDC_MMC_WR
Date: 13 Oct 2003 09:02:05 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1066057325.2253.1.camel@patehci2>
References: <1065832684.2877.37.camel@patehci2>
	 <20031011082144.GK10614@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email-out2.iomega.com ([147.178.1.83]:55036 "EHLO
	email.iomega.com") by vger.kernel.org with ESMTP id S261782AbTJMPCT
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 13 Oct 2003 11:02:19 -0400
In-Reply-To: <20031011082144.GK10614@suse.de>
List-Id: linux-scsi@vger.kernel.org
To: axboe@suse.de
Cc: linux-scsi@vger.kernel.org

Jens A:

Much better now?

Pat LaVarre

diff -Nur linux-2.6.0-test7/drivers/cdrom/cdrom.c linux/drivers/cdrom/cdrom.c
--- linux-2.6.0-test7/drivers/cdrom/cdrom.c	2003-10-08 13:24:02.000000000 -0600
+++ linux/drivers/cdrom/cdrom.c	2003-10-13 08:45:24.550496936 -0600
@@ -1,7 +1,7 @@
 /* linux/drivers/cdrom/cdrom.c. 
    Copyright (c) 1996, 1997 David A. van Leeuwen.
    Copyright (c) 1997, 1998 Erik Andersen <andersee@debian.org>
-   Copyright (c) 1998, 1999 Jens Axboe <axboe@image.dk>
+   Copyright (c) 1998, 1999, 2003 Jens Axboe <axboe@image.dk>
 
    May be copied or modified under the terms of the GNU General Public
    License.  See linux/COPYING for more information.
@@ -228,10 +228,13 @@
    3.12 Oct 18, 2000 - Jens Axboe <axboe@suse.de>
   -- Use quiet bit on packet commands not known to work
 
+   3.13 Oct 13, 2003 - Jens Axboe <axboe@suse.de>
+  -- Now mask CDC_MMC_WR only if not std. rewritable, was mask if not DVD_RAM.
+
 -------------------------------------------------------------------------*/
 
-#define REVISION "Revision: 3.12"
-#define VERSION "Id: cdrom.c 3.12 2000/10/18"
+#define REVISION "Revision: 3.13"
+#define VERSION "Id: cdrom.c 3.13 2003/10/13"
 
 /* I use an error-log mask to give fine grain control over the type of
    messages dumped to the system logs.  The available masks include: */
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
@@ -408,6 +414,48 @@
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
+		cdinfo(CD_REG_UNREG, "profile x%04X\n", profile);
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
+	return ret;
+}
+
+static void cdrom_get_cdc(struct cdrom_device_info *cdi)
+{
+	if (CDROM_CAN(CDC_MMC_WR) && !CDROM_CAN(CDC_DVD_RAM)) {
+		cdinfo(CD_REG_UNREG, "cdrom_get_configuration\n");
+		if (cdrom_get_configuration(cdi)) {
+			cdinfo(CD_REG_UNREG, "cdrom_get_configuration not\n");
+		}
+	}
+}
+
 /* We use the open-option O_NONBLOCK to indicate that the
  * purpose of opening is only for subsequent ioctl() calls; no device
  * integrity checks are performed.
@@ -426,8 +474,9 @@
 	if ((fp->f_flags & O_NONBLOCK) && (cdi->options & CDO_USE_FFLAGS))
 		ret = cdi->ops->open(cdi, 1);
 	else {
-		if ((fp->f_mode & FMODE_WRITE) && !CDROM_CAN(CDC_DVD_RAM))
+		if ((fp->f_mode & FMODE_WRITE) && !CDROM_CAN(CDC_MMC_WR)) {
 			return -EROFS;
+		}
 
 		ret = open_for_data(cdi);
 	}
@@ -2406,6 +2455,10 @@
 	for (cdi=topCdromPtr;cdi!=NULL;cdi=cdi->next)
 	    pos += sprintf(info+pos, "\t%d", CDROM_CAN(CDC_DVD_RAM) != 0);
 
+	pos += sprintf(info+pos, "\nTolerates random write:");
+	for (cdi=topCdromPtr;cdi!=NULL;cdi=cdi->next)
+	    pos += sprintf(info+pos, "\t%d", CDROM_CAN(CDC_MMC_WR) != 0);
+
 	strcpy(info+pos,"\n\n");
 		
         return proc_dostring(ctl, write, filp, buffer, lenp);
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
+++ linux/drivers/ide/ide-cd.c	2003-10-13 08:35:49.362938736 -0600
@@ -2822,7 +2822,7 @@
 				CDC_MEDIA_CHANGED | CDC_PLAY_AUDIO | CDC_RESET |
 				CDC_IOCTLS | CDC_DRIVE_STATUS | CDC_CD_R |
 				CDC_CD_RW | CDC_DVD | CDC_DVD_R| CDC_DVD_RAM |
-				CDC_GENERIC_PACKET | CDC_MO_DRIVE,
+				CDC_GENERIC_PACKET | CDC_MO_DRIVE | CDC_MMC_WR,
 	.generic_packet		= ide_cdrom_packet,
 };
 
diff -Nur linux-2.6.0-test7/drivers/scsi/sr.c linux/drivers/scsi/sr.c
--- linux-2.6.0-test7/drivers/scsi/sr.c	2003-10-08 13:24:03.000000000 -0600
+++ linux/drivers/scsi/sr.c	2003-10-13 08:38:40.603906152 -0600
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
@@ -788,8 +790,6 @@
 	if ((buffer[n + 3] & 0x20) == 0) {
 		/* can't write DVD-RAM media */
 		cd->cdi.mask |= CDC_DVD_RAM;
-	} else {
-		cd->device->writeable = 1;
 	}
 	if ((buffer[n + 3] & 0x10) == 0)
 		/* can't write DVD-R media */


