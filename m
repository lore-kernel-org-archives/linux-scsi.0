From: James Bottomley <James.Bottomley@steeleye.com>
Subject: [PATCH] fix sr open/remove race
Date: 08 Apr 2004 15:53:00 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1081457583.2105.632.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:63189 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261925AbUDHUxI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 8 Apr 2004 16:53:08 -0400
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@suse.de>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>


There's a race where open and remove may be executing simultaneously and
cause various oopses depending on who wins.

This fixes the race by ensuring that acquire/release of the scsi_cd
refcounted object are atomic with respect to each other.

James

===== drivers/scsi/sr.c 1.104 vs edited =====
--- 1.104/drivers/scsi/sr.c	Thu Apr  8 08:39:12 2004
+++ edited/drivers/scsi/sr.c	Thu Apr  8 16:33:11 2004
@@ -86,6 +86,7 @@
 
 static unsigned long sr_index_bits[SR_DISKS / BITS_PER_LONG];
 static spinlock_t sr_index_lock = SPIN_LOCK_UNLOCKED;
+static DECLARE_MUTEX(sr_ref_sem);
 
 static int sr_open(struct cdrom_device_info *, int);
 static void sr_release(struct cdrom_device_info *);
@@ -119,20 +120,35 @@
 	.release = sr_kobject_release,
 };
 
+static inline struct scsi_cd *scsi_cd(struct gendisk *disk)
+{
+	return container_of(disk->private_data, struct scsi_cd, driver);
+}
+
 /*
  * The get and put routines for the struct scsi_cd.  Note this entity
  * has a scsi_device pointer and owns a reference to this.
  */
-static inline int scsi_cd_get(struct scsi_cd *cd)
+static inline struct scsi_cd *scsi_cd_get(struct gendisk *disk)
 {
+	struct scsi_cd *cd = NULL;
+
+	down(&sr_ref_sem);
+	if (disk->private_data == NULL)
+		goto out;
+	cd = scsi_cd(disk);
 	if (!kobject_get(&cd->kobj))
-		return -ENODEV;
-	return 0;
+		cd = NULL;
+ out:
+	up(&sr_ref_sem);
+	return cd;
 }
 
 static inline void scsi_cd_put(struct scsi_cd *cd)
 {
+	down(&sr_ref_sem);
 	kobject_put(&cd->kobj);
+	up(&sr_ref_sem);
 }
 
 /*
@@ -187,11 +203,6 @@
 	return retval;
 }
  
-static inline struct scsi_cd *scsi_cd(struct gendisk *disk)
-{
-	return container_of(disk->private_data, struct scsi_cd, driver);
-}
-
 /*
  * rw_intr is the interrupt routine for the device driver.
  *
@@ -440,8 +451,17 @@
 
 static int sr_block_open(struct inode *inode, struct file *file)
 {
+	struct gendisk *disk = inode->i_bdev->bd_disk;
 	struct scsi_cd *cd = scsi_cd(inode->i_bdev->bd_disk);
-	return cdrom_open(&cd->cdi, inode, file);
+	int ret = 0;
+
+	if(!(cd = scsi_cd_get(disk)))
+		return -ENXIO;
+
+	if((ret = cdrom_open(&cd->cdi, inode, file)) != 0)
+		scsi_cd_put(cd);
+
+	return ret;
 }
 
 static int sr_block_release(struct inode *inode, struct file *file)
@@ -496,10 +516,6 @@
 	struct scsi_device *sdev = cd->device;
 	int retval;
 
-	retval = scsi_cd_get(cd);
-	if (retval)
-		return retval;
-	
 	/*
 	 * If the device is in error recovery, wait until it is done.
 	 * If the device is offline, then disallow any access to it.

