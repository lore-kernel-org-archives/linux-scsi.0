From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [PATCH] update sr to use kref and fix open/release race
Date: 09 Apr 2004 08:58:01 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1081519081.2203.31.camel@mulgrave>
References: <1081518680.2202.27.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:65176 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261321AbUDIN6L (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 9 Apr 2004 09:58:11 -0400
In-Reply-To: <1081518680.2202.27.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Jens Axboe <axboe@suse.de>, grek@kroah.com, SCSI Mailing List <linux-scsi@vger.kernel.org>

And, er, with the correct patch this time.

James

===== sr.c 1.104 vs edited =====
--- 1.104/drivers/scsi/sr.c	Thu Apr  8 08:39:12 2004
+++ edited/sr.c	Fri Apr  9 09:26:07 2004
@@ -86,6 +86,7 @@
 
 static unsigned long sr_index_bits[SR_DISKS / BITS_PER_LONG];
 static spinlock_t sr_index_lock = SPIN_LOCK_UNLOCKED;
+static DECLARE_MUTEX(sr_ref_sem);
 
 static int sr_open(struct cdrom_device_info *, int);
 static void sr_release(struct cdrom_device_info *);
@@ -113,26 +114,37 @@
 	.generic_packet		= sr_packet,
 };
 
-static void sr_kobject_release(struct kobject *kobj);
+static void sr_kref_release(struct kref *kref);
 
-static struct kobj_type scsi_cdrom_kobj_type = {
-	.release = sr_kobject_release,
-};
+static inline struct scsi_cd *scsi_cd(struct gendisk *disk)
+{
+	return container_of(disk->private_data, struct scsi_cd, driver);
+}
 
 /*
  * The get and put routines for the struct scsi_cd.  Note this entity
  * has a scsi_device pointer and owns a reference to this.
  */
-static inline int scsi_cd_get(struct scsi_cd *cd)
+static inline struct scsi_cd *scsi_cd_get(struct gendisk *disk)
 {
-	if (!kobject_get(&cd->kobj))
-		return -ENODEV;
-	return 0;
+	struct scsi_cd *cd = NULL;
+
+	down(&sr_ref_sem);
+	if (disk->private_data == NULL)
+		goto out;
+	cd = scsi_cd(disk);
+	if (!kref_get(&cd->kref))
+		cd = NULL;
+ out:
+	up(&sr_ref_sem);
+	return cd;
 }
 
 static inline void scsi_cd_put(struct scsi_cd *cd)
 {
-	kobject_put(&cd->kobj);
+	down(&sr_ref_sem);
+	kref_put(&cd->kref);
+	up(&sr_ref_sem);
 }
 
 /*
@@ -187,11 +199,6 @@
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
@@ -440,8 +447,17 @@
 
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
@@ -496,10 +512,6 @@
 	struct scsi_device *sdev = cd->device;
 	int retval;
 
-	retval = scsi_cd_get(cd);
-	if (retval)
-		return retval;
-	
 	/*
 	 * If the device is in error recovery, wait until it is done.
 	 * If the device is offline, then disallow any access to it.
@@ -551,8 +563,7 @@
 		goto fail_put_sdev;
 	memset(cd, 0, sizeof(*cd));
 
-	kobject_init(&cd->kobj);
-	cd->kobj.ktype = &scsi_cdrom_kobj_type;
+	kref_init(&cd->kref, sr_kref_release);
 
 	disk = alloc_disk(1);
 	if (!disk)
@@ -899,18 +910,21 @@
 	return cgc->stat;
 }
 
-static void sr_kobject_release(struct kobject *kobj)
+static void sr_kref_release(struct kref *kref)
 {
-	struct scsi_cd *cd = container_of(kobj, struct scsi_cd, kobj);
+	struct scsi_cd *cd = container_of(kref, struct scsi_cd, kref);
 	struct scsi_device *sdev = cd->device;
+	struct gendisk *disk = cd->disk;
 
 	spin_lock(&sr_index_lock);
-	clear_bit(cd->disk->first_minor, sr_index_bits);
+	clear_bit(disk->first_minor, sr_index_bits);
 	spin_unlock(&sr_index_lock);
 
 	unregister_cdrom(&cd->cdi);
 
-	put_disk(cd->disk);
+	disk->private_data = NULL;
+
+	put_disk(disk);
 
 	kfree(cd);
 
===== sr.h 1.11 vs edited =====
--- 1.11/drivers/scsi/sr.h	Wed Apr  7 09:21:27 2004
+++ edited/sr.h	Fri Apr  9 09:27:42 2004
@@ -19,6 +19,7 @@
 
 #include "scsi.h"
 #include <linux/genhd.h>
+#include <linux/kref.h>
 
 /* The CDROM is fairly slow, so we need a little extra time */
 /* In fact, it is very slow if it has to spin up first */
@@ -37,8 +38,8 @@
 	unsigned readcd_cdda:1;	/* reading audio data using READ_CD */
 	struct cdrom_device_info cdi;
 	/* We hold gendisk and scsi_device references on probe and use
-	 * the refs on this kobj to decide when to release them */
-	struct kobject kobj;
+	 * the refs on this kref to decide when to release them */
+	struct kref kref;
 	struct gendisk *disk;
 } Scsi_CD;
 

