From: James Bottomley <James.Bottomley@steeleye.com>
Subject: [PATCH] fix sd open/remove race
Date: 06 Apr 2004 22:25:51 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1081308352.1759.58.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:63192 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S264079AbUDGDZ5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 6 Apr 2004 23:25:57 -0400
Received: from midgard.sc.steeleye.com (midgard.sc.steeleye.com [172.17.6.40])
	by hancock.sc.steeleye.com (8.11.6/linuxconf) with ESMTP id i373Pua10416
	for <linux-scsi@vger.kernel.org>; Tue, 6 Apr 2004 23:25:56 -0400
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>

There's a race where open and remove may be executing simultaneously and
cause various oopses depending on who wins.

This fixes the race by ensuring that acquire/release of the scsi_disk
refcounted object are atomic with respect to each other.

James

===== drivers/scsi/sd.c 1.144 vs edited =====
--- 1.144/drivers/scsi/sd.c	Tue Mar 16 18:57:15 2004
+++ edited/drivers/scsi/sd.c	Tue Apr  6 22:20:38 2004
@@ -100,6 +100,7 @@
 
 static unsigned long sd_index_bits[SD_DISKS / BITS_PER_LONG];
 static spinlock_t sd_index_lock = SPIN_LOCK_UNLOCKED;
+DECLARE_MUTEX(sd_ref_sem);
 
 static int sd_revalidate_disk(struct gendisk *disk);
 static void sd_rw_intr(struct scsi_cmnd * SCpnt);
@@ -168,24 +169,26 @@
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
+	if (!kobject_get(&sdkp->kobj))
+		sdkp = NULL;
+ out:
+	up(&sd_ref_sem);
+	return sdkp;
 }
 
 static void scsi_disk_put(struct scsi_disk *sdkp)
 {
-	scsi_device_put(sdkp->device);
+	down(&sd_ref_sem);
 	kobject_put(&sdkp->kobj);
+	up(&sd_ref_sem);
 }
 
 /**
@@ -406,15 +409,15 @@
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
 
@@ -1338,13 +1341,16 @@
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
 	kobject_init(&sdkp->kobj);
@@ -1421,6 +1427,8 @@
 	put_disk(gd);
 out_free:
 	kfree(sdkp);
+out_put_sdev:
+	scsi_device_put(sdp);
 out:
 	return error;
 }
@@ -1454,14 +1462,20 @@
 static void scsi_disk_release(struct kobject *kobj)
 {
 	struct scsi_disk *sdkp = to_scsi_disk(kobj);
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

