From: Pat LaVarre <p.lavarre@ieee.org>
Subject: [PATCH] CDC_WR_OVER
Date: 14 Nov 2003 16:13:06 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1068851585.2851.17.camel@patrh9>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email-out2.iomega.com ([147.178.1.83]:59818 "EHLO
	email.iomega.com") by vger.kernel.org with ESMTP id S262729AbTKNXNl
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 14 Nov 2003 18:13:41 -0500
Received: from royntex01.iomegacorp.com (unknown [147.178.90.120])
	by email.iomega.com (Postfix) with ESMTP id B195B1F41
	for <linux-scsi@vger.kernel.org>; Fri, 14 Nov 2003 16:13:40 -0700 (MST)
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

-----Forwarded Message-----

From: Pat LaVarre <p.lavarre@ieee.org>
Subject: [PATCH] CDC_WR_OVER
Date: 14 Nov 2003 16:11:44 -0700
...

I'm thinking 2.6.0-test9 cdrom.ko passes writes thru to a drive that
accepts DVD-RAM discs, no matter if that drive also accepts DVD-RW and
DVD+RW discs.

Do you agree?  Is that ok?  If no, when/how to do we fix it?

This issue grows more current e..g. Google tells me we now find such
intermixtures as "DVD+RW 4x2.4x12, DVD-RW 4x2x12, DVD-RAM 3x, CD-RW
24x16x32" in one drive.

I guess I'm feeling confused in particular over how we can say it's ok
to pass writes thru to DVD-RW discs while we say it's bad to pass writes
thru to any cdrom device.

Perhaps you agree we can begin to move forward now by accepting or
revising the patch of this e-mail?

---

This code distinguishes CDC_WR from CDC_DVD_RAM as we have discussed
previously, but then works harder.  Three steps now:

1)

Usually we try op x46 GPCMD_GET_CONFIGURATION for the header alone. 
Reasons Not to try now include:

a) CDC_CAN(CDC_DVD_RAM) because ide-cd/sr saw that in 
GPMODE_CAPABILITIES_PAGE

b) sr tried but failed to fetch GPMODE_CAPABILITIES_PAGE

2)

Usually we next fetch all the available op x46 GPCMD_GET_CONFIGURATION
data.  Reasons to fetch none or less than all available include:

a) Nothing beyond the header reported available.
b) Not a multiple of four bytes reported available, thus violating MMC.
c) xFFF0 estimate of MMC max of xFFFE bytes per CDB exceeded.
d) GFP_KERNEL kmalloc fails.

3)

Having fetched all the features we can, we loop thru them, one at a
time.  From that info we guess whether we want to pass writes thru to
the device or not.

We guess yes only:

a) if CDC_CAN(CDC_DVD_RAM), or
b) if CDC_CAN(CDC_WR) and CDC_CAN(CDC_WR_OVER).

We default to !CDC_CAN(CDC_WR), but we switch to CDC_CAN(CDC_WR) if we
discover current-or-not feature x0020 "Random Writable".

We default to CDC_CAN(CDC_WR_OVER), but we switch to
!CDC_CAN(CDC_WR_OVER) if we discover any current-or-not "profile" other
than a standard MMC profile that requires feature x0020.

---

Do you like this patch?  Or pieces of it?  How can I help next?

Pat LaVarre

diff -Nur linux-2.6.0-test9/include/linux/cdrom.h linux/include/linux/cdrom.h
--- linux-2.6.0-test9/include/linux/cdrom.h	2003-10-25 12:42:47.000000000 -0600
+++ linux/include/linux/cdrom.h	2003-11-14 15:10:20.000000000 -0700
@@ -388,6 +388,8 @@
 #define CDC_DVD_R		0x10000	/* drive can write DVD-R */
 #define CDC_DVD_RAM		0x20000	/* drive can write DVD-RAM */
 #define CDC_MO_DRIVE		0x40000 /* drive is an MO device */
+#define CDC_WR			0x80000	/* tolerates random write */
+#define CDC_WR_OVER		0x100000 /* tolerates much rewrite */
 
 /* drive status possibilities returned by CDROM_DRIVE_STATUS ioctl */
 #define CDS_NO_INFO		0	/* if not implemented */
diff -Nur linux-2.6.0-test9/drivers/cdrom/cdrom.c linux/drivers/cdrom/cdrom.c
--- linux-2.6.0-test9/drivers/cdrom/cdrom.c	2003-10-25 12:43:01.000000000 -0600
+++ linux/drivers/cdrom/cdrom.c	2003-11-14 15:31:58.233745888 -0700
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
@@ -408,6 +411,132 @@
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
+			case 0x0004: /* Optical Write Once */
+			case 0x0008: /* CD-ROM */
+			case 0x0009: /* CD-R */
+			case 0x000A: /* CD-RW */
+			case 0x0010: /* DVD-ROM */
+			case 0x0011: /* DVD-R Sequential Recording */
+			case 0x0013: /* DVD-RW Restricted Overwrite */
+			case 0x0014: /* DVD-RW Sequential recording */
+			case 0x001A: /* DVD+RW */
+			case 0x001B: /* DVD+R */
+			case 0x0020: /* DDCD-ROM */
+			case 0x0021: /* DDCD-R */
+			default:
+				cdi->mask |= CDC_WR_OVER;
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
+	u_char min[8];
+	int ret;
+	init_cdrom_command(&cgc, min, 8, CGC_DATA_READ);
+	cgc.cmd[0] = GPCMD_GET_CONFIGURATION; /* 0x46 */
+	cgc.cmd[7] = cgc.buflen >> 8;
+	cgc.cmd[8] = cgc.buflen & 0xff;
+	ret = cdo->generic_packet(cdi, &cgc);
+	if (!ret) {
+		int max = 0xFFF0; /* xFFFE = mmc4r0f.pdf max per CDB */
+		int len = (0 + 4 +
+			(min[0] << 24 | min[1] << 16 | min[2] << 8 | min[3]));
+		if (max < len) len = max;
+		if (((sizeof min) < len) && ((len % 4) == 0)) {
+			u_char * whole = kmalloc(len, GFP_KERNEL);
+			if (!whole)
+				return -ENOMEM;
+			init_cdrom_command(&cgc, whole, len, CGC_DATA_READ);
+			cgc.cmd[0] = GPCMD_GET_CONFIGURATION; /* 0x46 */
+			cgc.cmd[7] = cgc.buflen >> 8;
+			cgc.cmd[8] = cgc.buflen & 0xff;
+			ret = cdo->generic_packet(cdi, &cgc);
+			if (!ret) {
+				ret = cdrom_each_feature(cdi, whole, len);
+			}
+			kfree(whole);
+		}
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
+		cdi->mask |= CDC_WR;
+		if (cdrom_get_configuration(cdi)) {
+			cdinfo(CD_REG_UNREG, "indeterminate features\n");
+		}
+	}
+	if (!CDROM_CAN(CDC_WR_OVER)) {
+		cdi->mask |= CDC_WR;
+	}
+}
+
 /* We use the open-option O_NONBLOCK to indicate that the
  * purpose of opening is only for subsequent ioctl() calls; no device
  * integrity checks are performed.
@@ -426,7 +555,7 @@
 	if ((fp->f_flags & O_NONBLOCK) && (cdi->options & CDO_USE_FFLAGS))
 		ret = cdi->ops->open(cdi, 1);
 	else {
-		if ((fp->f_mode & FMODE_WRITE) && !CDROM_CAN(CDC_DVD_RAM))
+		if ((fp->f_mode & FMODE_WRITE) && !CDROM_CAN(CDC_WR))
 			return -EROFS;
 
 		ret = open_for_data(cdi);
@@ -2406,6 +2535,10 @@
 	for (cdi=topCdromPtr;cdi!=NULL;cdi=cdi->next)
 	    pos += sprintf(info+pos, "\t%d", CDROM_CAN(CDC_DVD_RAM) != 0);
 
+	pos += sprintf(info+pos, "\nTolerates random write:");
+	for (cdi=topCdromPtr;cdi!=NULL;cdi=cdi->next)
+	    pos += sprintf(info+pos, "\t%d", CDROM_CAN(CDC_WR) != 0);
+
 	strcpy(info+pos,"\n\n");
 		
         return proc_dostring(ctl, write, filp, buffer, lenp);
diff -Nur linux-2.6.0-test9/drivers/ide/ide-cd.c linux/drivers/ide/ide-cd.c
--- linux-2.6.0-test9/drivers/ide/ide-cd.c	2003-10-25 12:43:32.000000000 -0600
+++ linux/drivers/ide/ide-cd.c	2003-11-14 15:36:11.573232432 -0700
@@ -2822,7 +2822,8 @@
 				CDC_MEDIA_CHANGED | CDC_PLAY_AUDIO | CDC_RESET |
 				CDC_IOCTLS | CDC_DRIVE_STATUS | CDC_CD_R |
 				CDC_CD_RW | CDC_DVD | CDC_DVD_R| CDC_DVD_RAM |
-				CDC_GENERIC_PACKET | CDC_MO_DRIVE,
+				CDC_GENERIC_PACKET | CDC_MO_DRIVE |
+				CDC_WR | CDC_WR_OVER,
 	.generic_packet		= ide_cdrom_packet,
 };
 
@@ -2914,8 +2915,10 @@
 		return nslots;
 	}
 
-	if (ide_cdrom_get_capabilities(drive, &cap))
+	if (ide_cdrom_get_capabilities(drive, &cap)) {
+		; /* FIXME: mask CDC_WR */
 		return 0;
+	}
 
 	if (cap.lock == 0)
 		CDROM_CONFIG_FLAGS(drive)->no_doorlock = 1;
@@ -3211,6 +3214,7 @@
 
 	nslots = ide_cdrom_probe_capabilities (drive);
 
+	; /* FIXME: also not ro if CDC_WR */
 	if (CDROM_CONFIG_FLAGS(drive)->dvd_ram)
 		set_disk_ro(drive->disk, 0);
 
diff -Nur linux-2.6.0-test9/drivers/scsi/sr.c linux/drivers/scsi/sr.c
--- linux-2.6.0-test9/drivers/scsi/sr.c	2003-10-25 12:43:12.000000000 -0600
+++ linux/drivers/scsi/sr.c	2003-11-14 15:32:35.952011840 -0700
@@ -67,7 +67,8 @@
 	(CDC_CLOSE_TRAY|CDC_OPEN_TRAY|CDC_LOCK|CDC_SELECT_SPEED| \
 	 CDC_SELECT_DISC|CDC_MULTI_SESSION|CDC_MCN|CDC_MEDIA_CHANGED| \
 	 CDC_PLAY_AUDIO|CDC_RESET|CDC_IOCTLS|CDC_DRIVE_STATUS| \
-	 CDC_CD_R|CDC_CD_RW|CDC_DVD|CDC_DVD_R|CDC_DVD_RAM|CDC_GENERIC_PACKET)
+	 CDC_CD_R|CDC_CD_RW|CDC_DVD|CDC_DVD_R|CDC_DVD_RAM|CDC_GENERIC_PACKET| \
+	 CDC_WR|CDC_WR_OVER)
 
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
@@ -564,6 +566,7 @@
 			"%s/cd", sdev->devfs_name);
 	disk->driverfs_dev = &sdev->sdev_gendev;
 	register_cdrom(&cd->cdi);
+	cd->device->writeable = ((cd->cdi.mask & CDC_WR) == 0);
 	set_capacity(disk, cd->capacity);
 	disk->private_data = &cd->driver;
 	disk->queue = sdev->request_queue;
@@ -759,7 +762,8 @@
 		cd->cdi.speed = 1;
 		cd->cdi.mask |= (CDC_CD_R | CDC_CD_RW | CDC_DVD_R |
 					 CDC_DVD | CDC_DVD_RAM |
-					 CDC_SELECT_DISC | CDC_SELECT_SPEED);
+					 CDC_SELECT_DISC | CDC_SELECT_SPEED |
+					 CDC_WR | CDC_WR_OVER);
 		scsi_release_request(SRpnt);
 		kfree(buffer);
 		printk("%s: scsi-1 drive\n", cd->cdi.name);
@@ -788,8 +792,6 @@
 	if ((buffer[n + 3] & 0x20) == 0) {
 		/* can't write DVD-RAM media */
 		cd->cdi.mask |= CDC_DVD_RAM;
-	} else {
-		cd->device->writeable = 1;
 	}
 	if ((buffer[n + 3] & 0x10) == 0)
 		/* can't write DVD-R media */


