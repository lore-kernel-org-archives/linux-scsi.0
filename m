From: Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH] Fix refcounting in SCSI disk driver
Date: Fri, 4 Nov 2005 14:44:41 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.0511041411310.4652-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:37090 "HELO
	iolanthe.rowland.org") by vger.kernel.org with SMTP
	id S1750740AbVKDTon (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 4 Nov 2005 14:44:43 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

James:

This patch (as597b) fixes some holes in the reference counting for the
SCSI disk driver.  Currently the driver takes a reference only for
requests coming by way of the gendisk, not for requests coming by way of
the struct device or struct scsi_device.  Such requests can arrive in the
rescan, flush, and shutdown pathways.

The patch also makes the scsi_disk keep a reference to the underlying
scsi_device, and it erases the scsi_device's pointer to the scsi_disk
when the scsi_device is removed (since the pointer should no longer be 
used).

This resolves Bugzilla entry #5237.

Alan Stern



Signed-off-by: Alan Stern <stern@rowland.harvard.edu>

---

Index: usb-2.6/drivers/scsi/sd.c
===================================================================
--- usb-2.6.orig/drivers/scsi/sd.c
+++ usb-2.6/drivers/scsi/sd.c
@@ -177,24 +177,38 @@ static inline struct scsi_disk *scsi_dis
 	return container_of(disk->private_data, struct scsi_disk, driver);
 }
 
-static struct scsi_disk *scsi_disk_get(struct gendisk *disk)
+static struct scsi_disk *__scsi_disk_get(struct gendisk *disk)
 {
 	struct scsi_disk *sdkp = NULL;
 
+	if (disk->private_data) {
+		sdkp = scsi_disk(disk);
+		if (scsi_device_get(sdkp->device) == 0)
+			kref_get(&sdkp->kref);
+		else
+			sdkp = NULL;
+	}
+	return sdkp;
+}
+
+static struct scsi_disk *scsi_disk_get(struct gendisk *disk)
+{
+	struct scsi_disk *sdkp;
+
 	down(&sd_ref_sem);
-	if (disk->private_data == NULL)
-		goto out;
-	sdkp = scsi_disk(disk);
-	kref_get(&sdkp->kref);
-	if (scsi_device_get(sdkp->device))
-		goto out_put;
+	sdkp = __scsi_disk_get(disk);
 	up(&sd_ref_sem);
 	return sdkp;
+}
 
- out_put:
-	kref_put(&sdkp->kref, scsi_disk_release);
-	sdkp = NULL;
- out:
+static struct scsi_disk *scsi_disk_get_from_dev(struct device *dev)
+{
+	struct scsi_disk *sdkp;
+
+	down(&sd_ref_sem);
+	sdkp = dev_get_drvdata(dev);
+	if (sdkp)
+		sdkp = __scsi_disk_get(sdkp->disk);
 	up(&sd_ref_sem);
 	return sdkp;
 }
@@ -716,16 +730,17 @@ static int sd_sync_cache(struct scsi_dev
 
 static int sd_issue_flush(struct device *dev, sector_t *error_sector)
 {
+	int ret = 0;
 	struct scsi_device *sdp = to_scsi_device(dev);
-	struct scsi_disk *sdkp = dev_get_drvdata(dev);
+	struct scsi_disk *sdkp = scsi_disk_get_from_dev(dev);
 
 	if (!sdkp)
                return -ENODEV;
 
-	if (!sdkp->WCE)
-		return 0;
-
-	return sd_sync_cache(sdp);
+	if (sdkp->WCE)
+		ret = sd_sync_cache(sdp);
+	scsi_disk_put(sdkp);
+	return ret;
 }
 
 static void sd_end_flush(request_queue_t *q, struct request *flush_rq)
@@ -754,23 +769,30 @@ static void sd_end_flush(request_queue_t
 static int sd_prepare_flush(request_queue_t *q, struct request *rq)
 {
 	struct scsi_device *sdev = q->queuedata;
-	struct scsi_disk *sdkp = dev_get_drvdata(&sdev->sdev_gendev);
+	struct scsi_disk *sdkp = scsi_disk_get_from_dev(&sdev->sdev_gendev);
+	int ret = 0;
 
-	if (sdkp->WCE) {
-		memset(rq->cmd, 0, sizeof(rq->cmd));
-		rq->flags |= REQ_BLOCK_PC | REQ_SOFTBARRIER;
-		rq->timeout = SD_TIMEOUT;
-		rq->cmd[0] = SYNCHRONIZE_CACHE;
-		return 1;
+	if (sdkp) {
+		if (sdkp->WCE) {
+			memset(rq->cmd, 0, sizeof(rq->cmd));
+			rq->flags |= REQ_BLOCK_PC | REQ_SOFTBARRIER;
+			rq->timeout = SD_TIMEOUT;
+			rq->cmd[0] = SYNCHRONIZE_CACHE;
+			ret = 1;
+		}
+		scsi_disk_put(sdkp);
 	}
-
-	return 0;
+	return ret;
 }
 
 static void sd_rescan(struct device *dev)
 {
-	struct scsi_disk *sdkp = dev_get_drvdata(dev);
-	sd_revalidate_disk(sdkp->disk);
+	struct scsi_disk *sdkp = scsi_disk_get_from_dev(dev);
+
+	if (sdkp) {
+		sd_revalidate_disk(sdkp->disk);
+		scsi_disk_put(sdkp);
+	}
 }
 
 
@@ -1562,6 +1584,7 @@ static int sd_probe(struct device *dev)
 	if (error)
 		goto out_put;
 
+	get_device(&sdp->sdev_gendev);
 	sdkp->device = sdp;
 	sdkp->driver = &sd_template;
 	sdkp->disk = gd;
@@ -1638,7 +1661,9 @@ static int sd_remove(struct device *dev)
 
 	del_gendisk(sdkp->disk);
 	sd_shutdown(dev);
+
 	down(&sd_ref_sem);
+	dev_set_drvdata(dev, NULL);
 	kref_put(&sdkp->kref, scsi_disk_release);
 	up(&sd_ref_sem);
 
@@ -1664,8 +1689,8 @@ static void scsi_disk_release(struct kre
 	spin_unlock(&sd_index_lock);
 
 	disk->private_data = NULL;
-
 	put_disk(disk);
+	put_device(&sdkp->device->sdev_gendev);
 
 	kfree(sdkp);
 }
@@ -1678,18 +1703,18 @@ static void scsi_disk_release(struct kre
 static void sd_shutdown(struct device *dev)
 {
 	struct scsi_device *sdp = to_scsi_device(dev);
-	struct scsi_disk *sdkp = dev_get_drvdata(dev);
+	struct scsi_disk *sdkp = scsi_disk_get_from_dev(dev);
 
 	if (!sdkp)
 		return;         /* this can happen */
 
-	if (!sdkp->WCE)
-		return;
-
-	printk(KERN_NOTICE "Synchronizing SCSI cache for disk %s: \n",
-			sdkp->disk->disk_name);
-	sd_sync_cache(sdp);
-}	
+	if (sdkp->WCE) {
+		printk(KERN_NOTICE "Synchronizing SCSI cache for disk %s: \n",
+				sdkp->disk->disk_name);
+		sd_sync_cache(sdp);
+	}
+	scsi_disk_put(sdkp);
+}
 
 /**
  *	init_sd - entry point for this driver (both when built in or when

