From: James Bottomley <James.Bottomley@steeleye.com>
Subject: [PATCH] update sd to use kref and fix open/release race
Date: 09 Apr 2004 08:52:59 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1081518779.2203.29.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:48280 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261317AbUDINxA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 9 Apr 2004 09:53:00 -0400
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>
Cc: greg@kroah.com

All this does is replace our kobject usage with a kref.

James

===== sd.c 1.144 vs edited =====
--- 1.144/drivers/scsi/sd.c	Tue Mar 16 19:57:15 2004
+++ edited/sd.c	Fri Apr  9 09:35:31 2004
@@ -48,6 +48,7 @@
 #include <linux/vmalloc.h>
 #include <linux/blkdev.h>
 #include <linux/blkpg.h>
+#include <linux/kref.h>
 #include <asm/uaccess.h>
 
 #include "scsi.h"
@@ -77,16 +78,12 @@
  */
 #define SD_MAX_RETRIES		5
 
-static void scsi_disk_release (struct kobject *kobj);
-
-static struct kobj_type scsi_disk_kobj_type = {
-	.release = scsi_disk_release,
-};
+static void scsi_disk_release(struct kref *kref);
 
 struct scsi_disk {
 	struct scsi_driver *driver;	/* always &sd_template */
 	struct scsi_device *device;
-	struct kobject	kobj;
+	struct kref	kref;
 	struct gendisk	*disk;
 	unsigned int	openers;	/* protected by BKL for now, yuck */
 	sector_t	capacity;	/* size in 512-byte sectors */
@@ -100,6 +97,7 @@
 
 static unsigned long sd_index_bits[SD_DISKS / BITS_PER_LONG];
 static spinlock_t sd_index_lock = SPIN_LOCK_UNLOCKED;
+static DECLARE_MUTEX(sd_ref_sem);
 
 static int sd_revalidate_disk(struct gendisk *disk);
 static void sd_rw_intr(struct scsi_cmnd * SCpnt);
@@ -161,31 +159,33 @@
 
 /* reverse mapping dev -> (sd_nr, part) not currently needed */
 
-#define to_scsi_disk(obj) container_of(obj,struct scsi_disk,kobj);
+#define to_scsi_disk(obj) container_of(obj,struct scsi_disk,kref);
 
 static inline struct scsi_disk *scsi_disk(struct gendisk *disk)
 {
 	return container_of(disk->private_data, struct scsi_disk, driver);
 }
 
-static int scsi_disk_get(struct scsi_disk *sdkp)
+static struct scsi_disk *scsi_disk_get(struct gendisk *disk)
 {
-	if (!kobject_get(&sdkp->kobj))
-		goto out;
-	if (scsi_device_get(sdkp->device))
-		goto out_put_kobj;
-	return 0;
+	struct scsi_disk *sdkp = NULL;
 
-out_put_kobj:
-	kobject_put(&sdkp->kobj);
-out:
-	return -ENXIO;
+	down(&sd_ref_sem);
+	if (disk->private_data == NULL)
+		goto out;
+	sdkp = scsi_disk(disk);
+	if (!kref_get(&sdkp->kref))
+		sdkp = NULL;
+ out:
+	up(&sd_ref_sem);
+	return sdkp;
 }
 
 static void scsi_disk_put(struct scsi_disk *sdkp)
 {
-	scsi_device_put(sdkp->device);
-	kobject_put(&sdkp->kobj);
+	down(&sd_ref_sem);
+	kref_put(&sdkp->kref);
+	up(&sd_ref_sem);
 }
 
 /**
@@ -406,15 +406,15 @@
 static int sd_open(struct inode *inode, struct file *filp)
 {
 	struct gendisk *disk = inode->i_bdev->bd_disk;
-	struct scsi_disk *sdkp = scsi_disk(disk);
+	struct scsi_disk *sdkp;
 	struct scsi_device *sdev;
 	int retval;
 
-	SCSI_LOG_HLQUEUE(3, printk("sd_open: disk=%s\n", disk->disk_name));
+	if (!(sdkp = scsi_disk_get(disk)))
+		return -ENXIO;
 
-	retval = scsi_disk_get(sdkp);
-	if (retval)
-		return retval;
+
+	SCSI_LOG_HLQUEUE(3, printk("sd_open: disk=%s\n", disk->disk_name));
 
 	sdev = sdkp->device;
 
@@ -1338,17 +1338,19 @@
 	if ((sdp->type != TYPE_DISK) && (sdp->type != TYPE_MOD))
 		goto out;
 
+	if ((error = scsi_device_get(sdp)) != 0)
+		goto out;
+
 	SCSI_LOG_HLQUEUE(3, printk("sd_attach: scsi device: <%d,%d,%d,%d>\n", 
 			 sdp->host->host_no, sdp->channel, sdp->id, sdp->lun));
 
 	error = -ENOMEM;
 	sdkp = kmalloc(sizeof(*sdkp), GFP_KERNEL);
 	if (!sdkp)
-		goto out;
+		goto out_put_sdev;
 
 	memset (sdkp, 0, sizeof(*sdkp));
-	kobject_init(&sdkp->kobj);
-	sdkp->kobj.ktype = &scsi_disk_kobj_type;
+	kref_init(&sdkp->kref, scsi_disk_release);
 
 	/* Note: We can accomodate 64 partitions, but the genhd code
 	 * assumes partitions allocate consecutive minors, which they don't.
@@ -1421,6 +1423,8 @@
 	put_disk(gd);
 out_free:
 	kfree(sdkp);
+out_put_sdev:
+	scsi_device_put(sdp);
 out:
 	return error;
 }
@@ -1442,26 +1446,32 @@
 
 	del_gendisk(sdkp->disk);
 	sd_shutdown(dev);
-	kobject_put(&sdkp->kobj);
+	scsi_disk_put(sdkp);
 
 	return 0;
 }
 
 /**
  *	scsi_disk_release - Called to free the scsi_disk structure
- *	@kobj: pointer to embedded kobject
+ *	@kref: pointer to embedded kref
  **/
-static void scsi_disk_release(struct kobject *kobj)
+static void scsi_disk_release(struct kref *kref)
 {
-	struct scsi_disk *sdkp = to_scsi_disk(kobj);
+	struct scsi_disk *sdkp = to_scsi_disk(kref);
+	struct scsi_device *sdev = sdkp->device;
+	struct gendisk *disk = sdkp->disk;
 	
-	put_disk(sdkp->disk);
-
 	spin_lock(&sd_index_lock);
 	clear_bit(sdkp->index, sd_index_bits);
 	spin_unlock(&sd_index_lock);
 
+	disk->private_data = NULL;
+
+	put_disk(disk);
+
 	kfree(sdkp);
+
+	scsi_device_put(sdev);
 }
 
 /*


