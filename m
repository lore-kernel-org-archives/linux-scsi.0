From: Alan Stern <stern@rowland.harvard.edu>
Subject: PATCH: (as54) Fix hot-unplugging for sr.c
Date: Mon, 7 Jul 2003 11:19:48 -0400 (EDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44L0.0307071111240.838-100000@ida.rowland.org>
References: <20030703221940.GA5983@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ida.rowland.org ([192.131.102.52]:3588 "HELO ida.rowland.org")
	by vger.kernel.org with SMTP id S265030AbTGGPFP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Jul 2003 11:05:15 -0400
In-Reply-To: <20030703221940.GA5983@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@us.ibm.com>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

Mike:

This is the final version of my patch to fix hot-unplugging for the SCSI 
cdrom driver.  It prevents the private data structure from being 
deallocated until all references to it have been dropped, and it prevents 
races between sr_block_open() and sr_remove().

The patch does assume, however, that it is legal to submit requests (via 
scsi_ioctl, for example) for a device that is marked offline.

Similar changes may be needed for the sd, st, and sg drivers; I haven't 
looked at them.

Alan Stern


--- usb-2.5/drivers/scsi/sr.h.orig	Mon Jun 16 15:28:36 2003
+++ usb-2.5/drivers/scsi/sr.h	Fri Jul  4 14:11:29 2003
@@ -35,6 +35,8 @@
 	unsigned xa_flag:1;	/* CD has XA sectors ? */
 	unsigned readcd_known:1;	/* drive supports READ_CD (0xbe) */
 	unsigned readcd_cdda:1;	/* reading audio data using READ_CD */
+	unsigned gone:1;	/* device has been hot-unplugged */
+	unsigned int use_count;	/* number of current users */
 	struct cdrom_device_info cdi;
 	struct gendisk *disk;
 } Scsi_CD;
--- usb-2.5/drivers/scsi/sr.c.orig	Wed Jul  2 11:42:54 2003
+++ usb-2.5/drivers/scsi/sr.c	Sun Jul  6 15:19:40 2003
@@ -86,6 +86,9 @@
 static unsigned long sr_index_bits[SR_DISKS / BITS_PER_LONG];
 static spinlock_t sr_index_lock = SPIN_LOCK_UNLOCKED;
 
+/* prevent races between sr_block_open() and sr_remove() */
+static DECLARE_MUTEX (sr_open_remove_sem);
+
 static int sr_open(struct cdrom_device_info *, int);
 static void sr_release(struct cdrom_device_info *);
 
@@ -166,7 +169,7 @@
  
 static inline struct scsi_cd *scsi_cd(struct gendisk *disk)
 {
-	return container_of(disk->private_data, struct scsi_cd, driver);
+	return disk->private_data;
 }
 
 /*
@@ -387,13 +390,40 @@
 static int sr_block_open(struct inode *inode, struct file *file)
 {
 	struct scsi_cd *cd = scsi_cd(inode->i_bdev->bd_disk);
-	return cdrom_open(&cd->cdi, inode, file);
+	int rc;
+
+	down(&sr_open_remove_sem);
+	if (!cd || cd->gone)
+		rc = -ENODEV;
+	else {
+		++cd->use_count;
+		up(&sr_open_remove_sem);
+		rc = cdrom_open(&cd->cdi, inode, file);
+		down(&sr_open_remove_sem);
+		if (rc) {
+			if (--cd->use_count == 0 && cd->gone) {
+				cd->disk->private_data = NULL;
+				kfree(cd);
+			}
+		}
+	}
+	up(&sr_open_remove_sem);
+	return rc;
 }
 
 static int sr_block_release(struct inode *inode, struct file *file)
 {
 	struct scsi_cd *cd = scsi_cd(inode->i_bdev->bd_disk);
-	return cdrom_release(&cd->cdi, file);
+	int rc;
+
+	rc = cdrom_release(&cd->cdi, file);
+	down(&sr_open_remove_sem);
+	if (--cd->use_count == 0 && cd->gone) {
+		cd->disk->private_data = NULL;
+		kfree(cd);
+	}
+	up(&sr_open_remove_sem);
+	return rc;
 }
 
 static int sr_block_ioctl(struct inode *inode, struct file *file, unsigned cmd,
@@ -417,6 +447,9 @@
 static int sr_block_media_changed(struct gendisk *disk)
 {
 	struct scsi_cd *cd = scsi_cd(disk);
+
+	if (!cd)
+		return 1;
 	return cdrom_media_changed(&cd->cdi);
 }
 
@@ -511,7 +544,6 @@
 	cd->device = sdev;
 	cd->disk = disk;
 	cd->driver = &sr_template;
-	cd->disk = disk;
 	cd->capacity = 0x1fffff;
 	cd->needs_sector_size = 1;
 	cd->device->changed = 1;	/* force recheck CD type */
@@ -536,7 +568,7 @@
 	disk->driverfs_dev = &sdev->sdev_driverfs_dev;
 	register_cdrom(&cd->cdi);
 	set_capacity(disk, cd->capacity);
-	disk->private_data = &cd->driver;
+	disk->private_data = cd;
 	disk->queue = sdev->request_queue;
 
 	dev_set_drvdata(dev, cd);
@@ -766,6 +798,7 @@
 static int sr_remove(struct device *dev)
 {
 	struct scsi_cd *cd = dev_get_drvdata(dev);
+	struct gendisk *disk = cd->disk;
 
 	del_gendisk(cd->disk);
 
@@ -773,10 +806,17 @@
 	clear_bit(cd->disk->first_minor, sr_index_bits);
 	spin_unlock(&sr_index_lock);
 
-	put_disk(cd->disk);
 	unregister_cdrom(&cd->cdi);
-	kfree(cd);
 
+	down(&sr_open_remove_sem);
+	cd->gone = 1;
+	if (cd->use_count == 0) {
+		cd->disk->private_data = NULL;
+		kfree(cd);
+	}
+	up(&sr_open_remove_sem);
+
+	put_disk(disk);
 	return 0;
 }
 

