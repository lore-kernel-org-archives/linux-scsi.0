From: Pat LaVarre <p.lavarre@ieee.org>
Subject: [PATCH] Backport CDC_MMC_WR
Date: 31 Oct 2003 18:22:49 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1067649769.2842.5.camel@patrh9>
References: <1067647915.2682.5.camel@patrh9>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email-out1.iomega.com ([147.178.1.82]:60347 "EHLO
	email.iomega.com") by vger.kernel.org with ESMTP id S262224AbTKABXM
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 31 Oct 2003 20:23:12 -0500
In-Reply-To: <1067647915.2682.5.camel@patrh9>
List-Id: linux-scsi@vger.kernel.org
To: axboe@suse.de
Cc: linux-scsi@vger.kernel.org

Jens A:

I have not yet seen you comment.

> To see that 2.6.0-test7 patch that works -test8 or -test9 as well ...
> http://marc.theaimsgroup.com/?l=linux-scsi&m=106605749929120&q=raw

With the inline plain text patch below, 2.4.22 seemingly works too, if
we transliterate to 2.4 syntax from 2.6 syntax.  Also here you can see I
added some cdinfo %s cdi->name.  I imagine we want those in 2.6.1 as
well.

Personally I'm still too ignorant to know how to test for trouble, if by
chance a patch of mine declares a /dev/scd$n writable that actually is
not writable.

Pat LaVarre

diff -Nur linux-2.4.22/drivers/cdrom/cdrom.c linux/drivers/cdrom/cdrom.c
--- linux-2.4.22/drivers/cdrom/cdrom.c	2002-11-28 16:53:12.000000000 -0700
+++ linux/drivers/cdrom/cdrom.c	2003-10-31 18:04:41.005317408 -0700
@@ -310,6 +310,7 @@
 #define CHECKAUDIO if ((ret=check_for_audio_disc(cdi, cdo))) return ret
 
 /* Not-exported routines. */
+static void cdrom_get_cdc(struct cdrom_device_info *cdi);
 static int open_for_data(struct cdrom_device_info * cdi);
 static int check_for_audio_disc(struct cdrom_device_info * cdi,
 			 struct cdrom_device_ops * cdo);
@@ -402,6 +403,8 @@
 	cdinfo(CD_REG_UNREG, "drive \"/dev/%s\" registered\n", cdi->name);
 	cdi->next = topCdromPtr; 	
 	topCdromPtr = cdi;
+
+	cdrom_get_cdc(cdi);
 	return 0;
 }
 #undef ENSURE
@@ -436,6 +439,51 @@
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
+		cdinfo(CD_REG_UNREG, "/dev/%s profile x%04X\n",
+			cdi->name, profile);
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
+		cdinfo(CD_REG_UNREG, "/dev/%s"
+			" cdrom_get_configuration\n", cdi->name);
+		if (cdrom_get_configuration(cdi)) {
+			cdinfo(CD_REG_UNREG, "/dev/%s"
+				" cdrom_get_configuration not\n", cdi->name);
+		}
+	}
+}
+
 struct cdrom_device_info *cdrom_find_device(kdev_t dev)
 {
 	struct cdrom_device_info *cdi;
@@ -465,7 +513,7 @@
 	if ((cdi = cdrom_find_device(dev)) == NULL)
 		return -ENODEV;
 
-	if ((fp->f_mode & FMODE_WRITE) && !CDROM_CAN(CDC_DVD_RAM))
+	if ((fp->f_mode & FMODE_WRITE) && !CDROM_CAN(CDC_MMC_WR))
 		return -EROFS;
 
 	/* if this was a O_NONBLOCK open and we should honor the flags,
@@ -2479,6 +2527,10 @@
 	for (cdi=topCdromPtr;cdi!=NULL;cdi=cdi->next)
 	    pos += sprintf(info+pos, "\t%d", CDROM_CAN(CDC_DVD_RAM) != 0);
 
+	pos += sprintf(info+pos, "\nTolerates random write:");
+	for (cdi=topCdromPtr;cdi!=NULL;cdi=cdi->next)
+	    pos += sprintf(info+pos, "\t%d", CDROM_CAN(CDC_MMC_WR) != 0);
+
 	strcpy(info+pos,"\n\n");
 		
         return proc_dostring(ctl, write, filp, buffer, lenp);
diff -Nur linux-2.4.22/include/linux/cdrom.h linux/include/linux/cdrom.h
--- linux-2.4.22/include/linux/cdrom.h	2001-11-22 12:47:04.000000000 -0700
+++ linux/include/linux/cdrom.h	2003-10-31 17:57:45.468488608 -0700
@@ -387,6 +387,8 @@
 #define CDC_DVD			0x8000	/* drive is a DVD */
 #define CDC_DVD_R		0x10000	/* drive can write DVD-R */
 #define CDC_DVD_RAM		0x20000	/* drive can write DVD-RAM */
+// CDC_MO_DRIVE
+#define CDC_MMC_WR		0x80000 /* profile includes random write */
 
 /* drive status possibilities returned by CDROM_DRIVE_STATUS ioctl */
 #define CDS_NO_INFO		0	/* if not implemented */
diff -Nur linux-2.4.22/drivers/ide/ide-cd.c linux/drivers/ide/ide-cd.c
--- linux-2.4.22/drivers/ide/ide-cd.c	2003-08-25 05:44:41.000000000 -0600
+++ linux/drivers/ide/ide-cd.c	2003-10-31 17:56:50.384862592 -0700
@@ -2683,7 +2683,7 @@
 				CDC_MEDIA_CHANGED | CDC_PLAY_AUDIO | CDC_RESET |
 				CDC_IOCTLS | CDC_DRIVE_STATUS | CDC_CD_R |
 				CDC_CD_RW | CDC_DVD | CDC_DVD_R| CDC_DVD_RAM |
-				CDC_GENERIC_PACKET,
+				CDC_GENERIC_PACKET | CDC_MMC_WR,
 	generic_packet:		ide_cdrom_packet,
 };
 
diff -Nur linux-2.4.22/drivers/scsi/sr.c linux/drivers/scsi/sr.c
--- linux-2.4.22/drivers/scsi/sr.c	2003-06-13 08:51:36.000000000 -0600
+++ linux/drivers/scsi/sr.c	2003-10-31 18:06:41.932933616 -0700
@@ -128,7 +128,8 @@
 				CDC_MEDIA_CHANGED | CDC_PLAY_AUDIO |
 				CDC_RESET | CDC_IOCTLS | CDC_DRIVE_STATUS |
 				CDC_CD_R | CDC_CD_RW | CDC_DVD | CDC_DVD_R |
-				CDC_DVD_RAM | CDC_GENERIC_PACKET,
+				CDC_DVD_RAM | CDC_GENERIC_PACKET |
+				CDC_MMC_WR,
 	generic_packet:		sr_packet,
 };
 
@@ -407,7 +408,8 @@
 		return 0;
 	}
 
-	if ((SCpnt->request.cmd == WRITE) && !scsi_CDs[dev].device->writeable)
+	if ((SCpnt->request.cmd == WRITE) &&
+			((scsi_CDs[dev].cdi.mask & CDC_MMC_WR) != 0))
 		return 0;
 
 	/*
@@ -754,8 +756,6 @@
 	if ((buffer[n + 3] & 0x20) == 0) {
 		/* can't write DVD-RAM media */
 		scsi_CDs[i].cdi.mask |= CDC_DVD_RAM;
-	} else {
-		scsi_CDs[i].device->writeable = 1;
 	}
 	if ((buffer[n + 3] & 0x10) == 0)
 		/* can't write DVD-R media */


