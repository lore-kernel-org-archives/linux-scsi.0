From: Pat LaVarre <p.lavarre@ieee.org>
Subject: Re: CDC_RAM for lk 2.4, PATCH proposed
Date: 20 May 2004 16:01:40 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1085090500.3822.20.camel@patibmrh9>
References: <20040519081534.GE30348@suse.de><1084981551.3082.80.camel@patib
	mrh9>  <20040520080622.GF1952@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email-out2.iomega.com ([147.178.1.83]:7116 "EHLO
	email.iomega.com") by vger.kernel.org with ESMTP id S265264AbUETWBz
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 20 May 2004 18:01:55 -0400
In-Reply-To: <20040520080622.GF1952@suse.de>
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@suse.de>
Cc: linux-scsi@vger.kernel.org, John McKell <McKellj@iomega.com>

Jens A:

> 2.4.26 patch should apply to 2.4.27-pre3 as well, I think.
> But it doesn't hurt to check.

In short:

Yes, it applies.

> 2.4.26 patch should apply to 2.4.27-pre3 as well, I think.
> But it doesn't hurt to check.

At length ...

John McKell's 2.4.26 patch still applies clean.  I see:

$ cd linux-2.4.27-pre3/
$ patch --dry-run -p1 <http://marc.theaimsgroup.com/?l=linux-scsi&m=...
patching file include/linux/cdrom.h
patching file drivers/ide/ide-cd.h
patching file drivers/ide/ide-cd.c
patching file drivers/scsi/sr.c
patching file drivers/cdrom/cdrom.c
$

Also I include a copy inline below for your convenience.

Also I will install & reboot & look for trouble.

diff confirms for me the patch inline of this post matches what John
McKell posted, except for the trivial difference of folder names & dates
and the substantive difference that I did comment out the per-open
printk:

- + printk("cdrom: %s opening for WRITE\n", current->comm);
+ + /* printk("cdrom: %s opening for WRITE\n", current->comm); */

> > I fear to answer fully, because I see I have a history of answering in
> > ways that make you lose interest.
> 
> Sorry you feel that way. It's not loss of interesting, mainly juggling
> other tasks.

Thanks for finding the time to correct my interpretation.

Sorry I did not understand.

I see you volunteering, I'm trying to discover how I the newbie can help
more than I hurt.

> > I believe 2.4.18 patch actually makes `mount -w` work there by way of
> > "see all DVD/CD drives as DVD-RAM/ DVD-ROM compatible".
> 
> But that's not what the patch does at all. The patch simply says "If we
> succeeded in retriving the mode capability page, ignore what it says and
> flag the drive as dvd-rom/ram capable" which is clearly bogus.

To newbie me, this is not clearly bogus, sorry.

1)

I see my 2.4.18 patch makes `mount -w` work, by way of breaking `cat
/proc/sys/dev/cdrom/info`.

mount matters more to me than proc.

Besides, the breakage is small.  I'm not falsely claiming that a DVD-RAM
disc is present.  I'm only falsely claiming that a DVD-RAM disc could be
present.  Software that branches visibly on which kind of disc might
someday be present looks very nearly bogus to me.

2)

I see my 2.4.18 patch is extremely short and simple.

Simplicity in the patch matters more to me the further I step back from
the latest available at kernel.org.

Pat LaVarre

diff -Nurp linux-2.4.27-pre3/include/linux/cdrom.h linux-2.4.27-pre3-pel/include/linux/cdrom.h
--- linux-2.4.27-pre3/include/linux/cdrom.h	2001-11-22 12:47:04.000000000 -0700
+++ linux-2.4.27-pre3-pel/include/linux/cdrom.h	2004-05-20 15:39:26.573524352 -0600
@@ -5,7 +5,8 @@
  *               1994, 1995   Eberhard Moenkeberg, emoenke@gwdg.de
  *               1996         David van Leeuwen, david@tm.tno.nl
  *               1997, 1998   Erik Andersen, andersee@debian.org
- *               1998-2000    Jens Axboe, axboe@suse.de
+ *               1998-2004    Jens Axboe, axboe@suse.de
+ *               2004         Iomega Corp
  */
  
 #ifndef	_LINUX_CDROM_H
@@ -387,6 +388,7 @@ struct cdrom_generic_command
 #define CDC_DVD			0x8000	/* drive is a DVD */
 #define CDC_DVD_R		0x10000	/* drive can write DVD-R */
 #define CDC_DVD_RAM		0x20000	/* drive can write DVD-RAM */
+#define CDC_RAM			0x100000 /* ok to open WRITE */
 
 /* drive status possibilities returned by CDROM_DRIVE_STATUS ioctl */
 #define CDS_NO_INFO		0	/* if not implemented */
@@ -714,16 +716,43 @@ struct request_sense {
 	__u8 asb[46];
 };
 
-#ifdef __KERNEL__
-#include <linux/devfs_fs_kernel.h>
+/*
+ * feature profile
+ */
+#define CDF_RWRT	0x0020
+#define CDF_HWDM	0x0024
 
-struct cdrom_write_settings {
-	unsigned char fpacket;		/* fixed/variable packets */
-	unsigned long packet_size;	/* write out this number of packets */
-	unsigned long nwa;		/* next writeable address */
-	unsigned char writeable;	/* cdrom is writeable */
+/* cf. mmc4r02g.pdf 5.3.10 Random Writable Feature (0020h) pg 197 of 635 */
+struct rwrt_feature_desc {
+	__u16 feature_code;
+#if defined(__BIG_ENDIAN_BITFIELD)
+	__u8 reserved1		: 2;
+	__u8 feature_version	: 4;
+	__u8 persistent		: 1;
+	__u8 curr		: 1;
+#elif defined(__LITTLE_ENDIAN_BITFIELD)
+	__u8 curr		: 1;
+	__u8 persistent		: 1;
+	__u8 feature_version	: 4;
+	__u8 reserved1		: 2;
+#endif
+	__u8 add_len;
+	__u32 last_lba;
+	__u32 block_size;
+	__u16 blocking;
+#if defined(__BIG_ENDIAN_BITFIELD)
+	__u8 reserved2		: 7;
+	__u8 page_present	: 1;
+#elif defined(__LITTLE_ENDIAN_BITFIELD)
+	__u8 page_present	: 1;
+	__u8 reserved2		: 7;
+#endif
+	__u8 reserved3;
 };
 
+#ifdef __KERNEL__
+#include <linux/devfs_fs_kernel.h>
+
 /* Uniform cdrom data structures for cdrom.c */
 struct cdrom_device_info {
 	struct cdrom_device_ops  *ops;  /* link to device_ops */
@@ -744,7 +773,6 @@ struct cdrom_device_info {
 /* per-device flags */
         __u8 sanyo_slot		: 2;	/* Sanyo 3 CD changer support */
         __u8 reserved		: 6;	/* not used yet */
-	struct cdrom_write_settings write;
 };
 
 struct cdrom_device_ops {
@@ -1053,6 +1081,17 @@ typedef struct {
 	__u8 reserved3;
 } rpc_state_t;
 
-#endif  /* End of kernel only stuff */ 
+struct feature_header {
+	__u32 data_len;
+	__u8 reserved1;
+	__u8 reserved2;
+	__u16 curr_profile;
+};
+
+extern int cdrom_get_disc_info(kdev_t dev, disc_information *di);
+extern int cdrom_get_track_info(kdev_t dev, __u16 track, __u8 type,
+				track_information *ti);
+extern int cdrom_is_random_writable(struct cdrom_device_info *cdi, int *write);
+#endif /* __KERNEL__ */
 
 #endif  /* _LINUX_CDROM_H */
diff -Nurp linux-2.4.27-pre3/drivers/ide/ide-cd.h linux-2.4.27-pre3-pel/drivers/ide/ide-cd.h
--- linux-2.4.27-pre3/drivers/ide/ide-cd.h	2003-06-13 08:51:33.000000000 -0600
+++ linux-2.4.27-pre3-pel/drivers/ide/ide-cd.h	2004-05-20 15:39:26.589521920 -0600
@@ -2,7 +2,8 @@
  *  linux/drivers/ide/ide_cd.h
  *
  *  Copyright (C) 1996-98  Erik Andersen
- *  Copyright (C) 1998-2000 Jens Axboe
+ *  Copyright (C) 1998-2004 Jens Axboe
+ *  Copyright (C) 2004 Iomega Corp
  */
 #ifndef _IDE_CD_H
 #define _IDE_CD_H
@@ -75,6 +76,7 @@ struct ide_cd_config_flags {
 	__u8 dvd		: 1; /* Drive is a DVD-ROM */
 	__u8 dvd_r		: 1; /* Drive can write DVD-R */
 	__u8 dvd_ram		: 1; /* Drive can write DVD-RAM */
+	__u8 ram		: 1; /* generic WRITE (dvd-ram/mrw) */
 	__u8 test_write		: 1; /* Drive can fake writes */
 	__u8 supp_disc_present	: 1; /* Changer can report exact contents
 					of slots. */
diff -Nurp linux-2.4.27-pre3/drivers/ide/ide-cd.c linux-2.4.27-pre3-pel/drivers/ide/ide-cd.c
--- linux-2.4.27-pre3/drivers/ide/ide-cd.c	2003-11-28 11:26:20.000000000 -0700
+++ linux-2.4.27-pre3-pel/drivers/ide/ide-cd.c	2004-05-20 15:39:26.614518120 -0600
@@ -3,7 +3,8 @@
  *
  * Copyright (C) 1994, 1995, 1996  scott snyder  <snyder@fnald0.fnal.gov>
  * Copyright (C) 1996-1998  Erik Andersen <andersee@debian.org>
- * Copyright (C) 1998-2000  Jens Axboe <axboe@suse.de>
+ * Copyright (C) 1998-2004  Jens Axboe <axboe@suse.de>
+ * Copyright (C) 2004 Iomega Corp
  *
  * May be copied or modified under the terms of the GNU General Public
  * License.  See linux/COPYING for more information.
@@ -2683,7 +2684,7 @@ static struct cdrom_device_ops ide_cdrom
 				CDC_MEDIA_CHANGED | CDC_PLAY_AUDIO | CDC_RESET |
 				CDC_IOCTLS | CDC_DRIVE_STATUS | CDC_CD_R |
 				CDC_CD_RW | CDC_DVD | CDC_DVD_R| CDC_DVD_RAM |
-				CDC_GENERIC_PACKET,
+				CDC_GENERIC_PACKET | CDC_RAM,
 	generic_packet:		ide_cdrom_packet,
 };
 
@@ -2718,6 +2719,8 @@ static int ide_cdrom_register (ide_drive
 		devinfo->mask |= CDC_PLAY_AUDIO;
 	if (!CDROM_CONFIG_FLAGS(drive)->close_tray)
 		devinfo->mask |= CDC_CLOSE_TRAY;
+	if (!CDROM_CONFIG_FLAGS(drive)->ram)
+		devinfo->mask |= CDC_RAM;
 
 	devinfo->de = devfs_register(drive->de, "cd", DEVFS_FL_DEFAULT,
 				     HWIF(drive)->major, minor,
@@ -2766,7 +2769,7 @@ int ide_cdrom_probe_capabilities (ide_dr
 	struct cdrom_info *info = drive->driver_data;
 	struct cdrom_device_info *cdi = &info->devinfo;
 	struct atapi_capabilities_page cap;
-	int nslots = 1;
+	int nslots = 1, ram_write = 0;
 
 	if (CDROM_CONFIG_FLAGS(drive)->nec260) {
 		CDROM_CONFIG_FLAGS(drive)->no_eject = 0;                       
@@ -2776,7 +2779,9 @@ int ide_cdrom_probe_capabilities (ide_dr
 
 	if (ide_cdrom_get_capabilities(drive, &cap))
 		return 0;
-
+	cdrom_is_random_writable(cdi, &ram_write);
+	if (ram_write) 
+		CDROM_CONFIG_FLAGS(drive)->ram = 1;
 	if (cap.lock == 0)
 		CDROM_CONFIG_FLAGS(drive)->no_doorlock = 1;
 	if (cap.eject)
@@ -2789,8 +2794,10 @@ int ide_cdrom_probe_capabilities (ide_dr
 		CDROM_CONFIG_FLAGS(drive)->test_write = 1;
 	if (cap.dvd_ram_read || cap.dvd_r_read || cap.dvd_rom)
 		CDROM_CONFIG_FLAGS(drive)->dvd = 1;
-	if (cap.dvd_ram_write)
+	if (cap.dvd_ram_write) {
 		CDROM_CONFIG_FLAGS(drive)->dvd_ram = 1;
+		CDROM_CONFIG_FLAGS(drive)->ram = 1;
+	}
 	if (cap.dvd_r_write)
 		CDROM_CONFIG_FLAGS(drive)->dvd_r = 1;
 	if (cap.audio_play)
@@ -3000,7 +3007,8 @@ int ide_cdrom_setup (ide_drive_t *drive)
 
 	nslots = ide_cdrom_probe_capabilities (drive);
 
-	if (CDROM_CONFIG_FLAGS(drive)->dvd_ram)
+	if ((CDROM_CONFIG_FLAGS(drive)->dvd_ram) ||
+	    (CDROM_CONFIG_FLAGS(drive)->ram))
 		set_device_ro(MKDEV(HWIF(drive)->major, minor), 0);
 
 #if 0
diff -Nurp linux-2.4.27-pre3/drivers/scsi/sr.c linux-2.4.27-pre3-pel/drivers/scsi/sr.c
--- linux-2.4.27-pre3/drivers/scsi/sr.c	2003-06-13 08:51:36.000000000 -0600
+++ linux-2.4.27-pre3-pel/drivers/scsi/sr.c	2004-05-20 15:39:26.615517968 -0600
@@ -1,6 +1,7 @@
 /*
  *  sr.c Copyright (C) 1992 David Giller
  *           Copyright (C) 1993, 1994, 1995, 1999 Eric Youngdale
+ *       Copyright (C) 2004 Iomega Corp
  *
  *  adapted from:
  *      sd.c Copyright (C) 1992 Drew Eckhardt
@@ -128,7 +129,7 @@ static struct cdrom_device_ops sr_dops =
 				CDC_MEDIA_CHANGED | CDC_PLAY_AUDIO |
 				CDC_RESET | CDC_IOCTLS | CDC_DRIVE_STATUS |
 				CDC_CD_R | CDC_CD_RW | CDC_DVD | CDC_DVD_R |
-				CDC_DVD_RAM | CDC_GENERIC_PACKET,
+				CDC_DVD_RAM | CDC_GENERIC_PACKET | CDC_RAM,
 	generic_packet:		sr_packet,
 };
 
@@ -693,7 +694,7 @@ void get_capabilities(int i)
 {
 	unsigned char cmd[6];
 	unsigned char *buffer;
-	int rc, n;
+	int rc, n, ram_write=0;
 
 	static char *loadmech[] =
 	{
@@ -731,6 +732,11 @@ void get_capabilities(int i)
 		printk("sr%i: scsi-1 drive\n", i);
 		return;
 	}
+	if (cdrom_is_random_writable(&scsi_CDs[i].cdi, &ram_write))
+		scsi_CDs[i].cdi.mask |= CDC_RAM;
+	if (!ram_write)
+		scsi_CDs[i].cdi.mask |= CDC_RAM;
+
 	n = buffer[3] + 4;
 	scsi_CDs[i].cdi.speed = ((buffer[n + 8] << 8) + buffer[n + 9]) / 176;
 	scsi_CDs[i].readcd_known = 1;
@@ -754,8 +760,6 @@ void get_capabilities(int i)
 	if ((buffer[n + 3] & 0x20) == 0) {
 		/* can't write DVD-RAM media */
 		scsi_CDs[i].cdi.mask |= CDC_DVD_RAM;
-	} else {
-		scsi_CDs[i].device->writeable = 1;
 	}
 	if ((buffer[n + 3] & 0x10) == 0)
 		/* can't write DVD-R media */
@@ -780,6 +784,13 @@ void get_capabilities(int i)
 	/*else    I don't think it can close its tray
 	   scsi_CDs[i].cdi.mask |= CDC_CLOSE_TRAY; */
 
+	/*
+	 * if DVD-RAM of MRW-W, we are randomly writeable
+	 */
+	if ((scsi_CDs[i].cdi.mask & (CDC_DVD_RAM | CDC_RAM)) !=
+	    (CDC_DVD_RAM | CDC_RAM))
+		scsi_CDs[i].device->writeable = 1;
+
 	scsi_free(buffer, 512);
 }
 
diff -Nurp linux-2.4.27-pre3/drivers/cdrom/cdrom.c linux-2.4.27-pre3-pel/drivers/cdrom/cdrom.c
--- linux-2.4.27-pre3/drivers/cdrom/cdrom.c	2003-11-28 11:26:20.000000000 -0700
+++ linux-2.4.27-pre3-pel/drivers/cdrom/cdrom.c	2004-05-20 15:39:26.632515384 -0600
@@ -1,7 +1,8 @@
 /* linux/drivers/cdrom/cdrom.c. 
    Copyright (c) 1996, 1997 David A. van Leeuwen.
    Copyright (c) 1997, 1998 Erik Andersen <andersee@debian.org>
-   Copyright (c) 1998, 1999 Jens Axboe <axboe@image.dk>
+   Copyright (c) 1998-2004 Jens Axboe <axboe@image.dk>
+   Copyright (c) 2004, Iomega Corp.
 
    May be copied or modified under the terms of the GNU General Public
    License.  See linux/COPYING for more information.
@@ -447,6 +448,112 @@ struct cdrom_device_info *cdrom_find_dev
 	return cdi;
 }
 
+int cdrom_get_random_writable(struct cdrom_device_info *cdi,
+			      struct rwrt_feature_desc *rfd)
+{
+	struct cdrom_generic_command cgc;
+	char buffer[24];
+	struct feature_header *fh;
+	int ret;
+
+	init_cdrom_command(&cgc, buffer, sizeof(buffer), CGC_DATA_READ);
+
+	cgc.cmd[0] = GPCMD_GET_CONFIGURATION;	/* often 0x46 */
+	cgc.cmd[3] = CDF_RWRT;			/* often 0x0020 */
+	cgc.cmd[8] = sizeof(buffer);		/* often 0x18 */
+	cgc.quiet = 1;
+
+	if ((ret = cdi->ops->generic_packet(cdi, &cgc)))
+		return ret;
+
+	fh = (struct feature_header *)&buffer[0];
+	if (be32_to_cpu(fh->data_len) >= (sizeof(struct feature_header)+
+					  sizeof(struct rwrt_feature_desc)))
+		memcpy(rfd, &buffer[sizeof(struct feature_header)],
+		       sizeof (*rfd));
+	else
+		memset(rfd, 0, sizeof(*rfd));
+
+	return 0;
+}
+
+int cdrom_has_defect_mgt(struct cdrom_device_info *cdi)
+{
+	struct cdrom_generic_command cgc;
+	char buffer[16];
+	struct feature_header *fh;
+	__u16 *feature_code;
+	int ret;
+
+	init_cdrom_command(&cgc, buffer, sizeof(buffer), CGC_DATA_READ);
+
+	cgc.cmd[0] = GPCMD_GET_CONFIGURATION;	/* often 0x46 */
+	cgc.cmd[3] = CDF_HWDM;			/* often 0x0024 */
+	cgc.cmd[8] = sizeof(buffer);		/* often 0x10 */
+	cgc.quiet = 1;
+
+	if ((ret = cdi->ops->generic_packet(cdi, &cgc)))
+		return ret;
+
+	fh = (struct feature_header *)&buffer[0];
+	ret = 1;
+	if (be32_to_cpu(fh->data_len) >= (sizeof(struct feature_header)+8)) {
+		feature_code = (__u16 *)&buffer[sizeof(struct feature_header)];
+		if (CDF_HWDM == be16_to_cpu(*feature_code))
+			ret = 0;
+	}
+	return ret;
+}
+
+
+int cdrom_is_random_writable(struct cdrom_device_info *cdi, int *write)
+{
+	struct rwrt_feature_desc rfd;
+	int ret;
+
+	*write = 0;
+
+	if ((ret = cdrom_get_random_writable(cdi, &rfd)))
+		return ret;
+
+	if (CDF_RWRT == be16_to_cpu(rfd.feature_code))
+		*write = 1;
+
+	return 0;
+}
+
+static int cdrom_ram_open_write(struct cdrom_device_info *cdi)
+{
+	struct rwrt_feature_desc rfd;
+	int ret;
+
+	if ((ret = cdrom_has_defect_mgt(cdi)))
+		return ret;
+	else
+		if ((ret = cdrom_get_random_writable(cdi, &rfd)))
+			return ret;
+		else if (CDF_RWRT == be16_to_cpu(rfd.feature_code))
+			ret = !rfd.curr;
+
+	cdinfo(CD_OPEN, "can open for random write\n");
+	return ret;
+}
+
+/*
+ * returns 0 for ok to open write, non-0 to disallow
+ */
+static int cdrom_open_write(struct cdrom_device_info *cdi)
+{
+	int ret;
+	if (CDROM_CAN(CDC_RAM) &&
+	    !CDROM_CAN(CDC_CD_R|CDC_CD_RW|CDC_DVD|CDC_DVD_R)) 
+		ret = cdrom_ram_open_write(cdi);
+	else
+		ret = 1;
+
+	return ret;
+}
+
 /* We use the open-option O_NONBLOCK to indicate that the
  * purpose of opening is only for subsequent ioctl() calls; no device
  * integrity checks are performed.
@@ -465,8 +572,15 @@ int cdrom_open(struct inode *ip, struct 
 	if ((cdi = cdrom_find_device(dev)) == NULL)
 		return -ENODEV;
 
-	if ((fp->f_mode & FMODE_WRITE) && !CDROM_CAN(CDC_DVD_RAM))
-		return -EROFS;
+	cdi->use_count++;
+	ret = -EROFS;
+	if (fp->f_mode & FMODE_WRITE) {
+		/* printk("cdrom: %s opening for WRITE\n", current->comm); */
+		if (!CDROM_CAN(CDC_RAM))
+			goto out;
+		if (cdrom_open_write(cdi))
+			goto out;
+	}
 
 	/* if this was a O_NONBLOCK open and we should honor the flags,
 	 * do a quick open without drive/disc integrity checks. */
@@ -475,12 +589,13 @@ int cdrom_open(struct inode *ip, struct 
 	else
 		ret = open_for_data(cdi);
 
-	if (!ret) cdi->use_count++;
-
 	cdinfo(CD_OPEN, "Use count for \"/dev/%s\" now %d\n", cdi->name, cdi->use_count);
 	/* Do this on open.  Don't wait for mount, because they might
 	    not be mounting, but opening with O_NONBLOCK */
 	check_disk_change(dev);
+out:
+	if (ret)
+		cdi->use_count--;
 	return ret;
 }
 
@@ -657,15 +772,14 @@ int cdrom_release(struct inode *ip, stru
 
 	cdinfo(CD_CLOSE, "entering cdrom_release\n"); 
 
-	if (cdi->use_count > 0)
-		cdi->use_count--;
-	if (cdi->use_count == 0)
+	if (!--cdi->use_count) {
 		cdinfo(CD_CLOSE, "Use count for \"/dev/%s\" now zero\n", cdi->name);
-	if (cdi->use_count == 0 &&
-	    cdo->capability & CDC_LOCK && !keeplocked) {
-		cdinfo(CD_CLOSE, "Unlocking door!\n");
-		cdo->lock_door(cdi, 0);
+		if ((cdo->capability & CDC_LOCK) && !keeplocked) {
+			cdinfo(CD_CLOSE, "Unlocking door!\n");
+			cdo->lock_door(cdi, 0);
+		}
 	}
+
 	opened_for_data = !(cdi->options & CDO_USE_FFLAGS) ||
 		!(fp && fp->f_flags & O_NONBLOCK);
 	cdo->release(cdi);
@@ -1909,10 +2023,24 @@ static int cdrom_do_cmd(struct cdrom_dev
 		}
 	}
 
+	/*
+	 * queue command and wait for it to complete
+	 */
 	ret = cdi->ops->generic_packet(cdi, cgc);
-	__copy_to_user(usense, cgc->sense, sizeof(*usense));
+
+	/*
+	 * always copy back sense, command need not have failed for it to
+	 * contain useful info
+	 */
+	if (usense)
+		__copy_to_user(usense, cgc->sense, sizeof(*usense));
+
+	/*
+	 * this really needs to be modified to copy back good bytes
+	 */
 	if (!ret && cgc->data_direction == CGC_DATA_READ)
 		__copy_to_user(ubuf, cgc->buffer, cgc->buflen);
+
 	if (cgc->data_direction == CGC_DATA_READ ||
 	    cgc->data_direction == CGC_DATA_WRITE) {
 		kfree(cgc->buffer);
@@ -2392,6 +2520,7 @@ EXPORT_SYMBOL(cdrom_mode_select);
 EXPORT_SYMBOL(cdrom_mode_sense);
 EXPORT_SYMBOL(init_cdrom_command);
 EXPORT_SYMBOL(cdrom_find_device);
+EXPORT_SYMBOL(cdrom_is_random_writable);
 
 #ifdef CONFIG_SYSCTL
 
@@ -2488,6 +2617,10 @@ int cdrom_sysctl_info(ctl_table *ctl, in
 	for (cdi=topCdromPtr;cdi!=NULL;cdi=cdi->next)
 	    pos += sprintf(info+pos, "\t%d", CDROM_CAN(CDC_DVD_RAM) != 0);
 
+	pos += sprintf(info+pos, "\nCan write RAM:\t");
+	for (cdi=topCdromPtr;cdi!=NULL;cdi=cdi->next)
+	    pos += sprintf(info+pos, "\t%d", CDROM_CAN(CDC_RAM) != 0);
+
 	strcpy(info+pos,"\n\n");
 		
         return proc_dostring(ctl, write, filp, buffer, lenp);


