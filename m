From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 2/3] sd: don't grab a device references from driver methods
Date: Mon,  2 Feb 2015 14:01:25 +0100
Message-ID: <1422882086-1863-2-git-send-email-hch@lst.de>
References: <1422882086-1863-1-git-send-email-hch@lst.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:59567 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932373AbbBBNCr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Feb 2015 08:02:47 -0500
In-Reply-To: <1422882086-1863-1-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Bart Van Assche <bvanassche@acm.org>, James Bottomley <jbottomley@parallels.com>, Alan Stern <stern@rowland.harvard.edu>

The device model already takes care of races between ->remove and
->shutdown vs its other methods, and we now take care about locking
them out for ->rescan as well.

This is a partial revert of commit 39b7f1 ("[SCSI] sd: Fix refcounting").

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/sd.c | 55 +++++++++++--------------------------------------------
 1 file changed, 11 insertions(+), 44 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 3995169..1f06274 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -564,10 +564,12 @@ static int sd_major(int major_idx)
 	}
 }
 
-static struct scsi_disk *__scsi_disk_get(struct gendisk *disk)
+static struct scsi_disk *scsi_disk_get(struct gendisk *disk)
 {
 	struct scsi_disk *sdkp = NULL;
 
+	mutex_lock(&sd_ref_mutex);
+
 	if (disk->private_data) {
 		sdkp = scsi_disk(disk);
 		if (scsi_device_get(sdkp->device) == 0)
@@ -575,27 +577,6 @@ static struct scsi_disk *__scsi_disk_get(struct gendisk *disk)
 		else
 			sdkp = NULL;
 	}
-	return sdkp;
-}
-
-static struct scsi_disk *scsi_disk_get(struct gendisk *disk)
-{
-	struct scsi_disk *sdkp;
-
-	mutex_lock(&sd_ref_mutex);
-	sdkp = __scsi_disk_get(disk);
-	mutex_unlock(&sd_ref_mutex);
-	return sdkp;
-}
-
-static struct scsi_disk *scsi_disk_get_from_dev(struct device *dev)
-{
-	struct scsi_disk *sdkp;
-
-	mutex_lock(&sd_ref_mutex);
-	sdkp = dev_get_drvdata(dev);
-	if (sdkp)
-		sdkp = __scsi_disk_get(sdkp->disk);
 	mutex_unlock(&sd_ref_mutex);
 	return sdkp;
 }
@@ -610,8 +591,6 @@ static void scsi_disk_put(struct scsi_disk *sdkp)
 	mutex_unlock(&sd_ref_mutex);
 }
 
-
-
 static unsigned char sd_setup_protect_cmnd(struct scsi_cmnd *scmd,
 					   unsigned int dix, unsigned int dif)
 {
@@ -1525,12 +1504,9 @@ static int sd_sync_cache(struct scsi_disk *sdkp)
 
 static void sd_rescan(struct device *dev)
 {
-	struct scsi_disk *sdkp = scsi_disk_get_from_dev(dev);
+	struct scsi_disk *sdkp = dev_get_drvdata(dev);
 
-	if (sdkp) {
-		revalidate_disk(sdkp->disk);
-		scsi_disk_put(sdkp);
-	}
+	revalidate_disk(sdkp->disk);
 }
 
 
@@ -3147,13 +3123,13 @@ static int sd_start_stop_device(struct scsi_disk *sdkp, int start)
  */
 static void sd_shutdown(struct device *dev)
 {
-	struct scsi_disk *sdkp = scsi_disk_get_from_dev(dev);
+	struct scsi_disk *sdkp = dev_get_drvdata(dev);
 
 	if (!sdkp)
 		return;         /* this can happen */
 
 	if (pm_runtime_suspended(dev))
-		goto exit;
+		return;
 
 	if (sdkp->WCE && sdkp->media_present) {
 		sd_printk(KERN_NOTICE, sdkp, "Synchronizing SCSI cache\n");
@@ -3164,14 +3140,11 @@ static void sd_shutdown(struct device *dev)
 		sd_printk(KERN_NOTICE, sdkp, "Stopping disk\n");
 		sd_start_stop_device(sdkp, 0);
 	}
-
-exit:
-	scsi_disk_put(sdkp);
 }
 
 static int sd_suspend_common(struct device *dev, bool ignore_stop_errors)
 {
-	struct scsi_disk *sdkp = scsi_disk_get_from_dev(dev);
+	struct scsi_disk *sdkp = dev_get_drvdata(dev);
 	int ret = 0;
 
 	if (!sdkp)
@@ -3197,7 +3170,6 @@ static int sd_suspend_common(struct device *dev, bool ignore_stop_errors)
 	}
 
 done:
-	scsi_disk_put(sdkp);
 	return ret;
 }
 
@@ -3213,18 +3185,13 @@ static int sd_suspend_runtime(struct device *dev)
 
 static int sd_resume(struct device *dev)
 {
-	struct scsi_disk *sdkp = scsi_disk_get_from_dev(dev);
-	int ret = 0;
+	struct scsi_disk *sdkp = dev_get_drvdata(dev);
 
 	if (!sdkp->device->manage_start_stop)
-		goto done;
+		return 0;
 
 	sd_printk(KERN_NOTICE, sdkp, "Starting disk\n");
-	ret = sd_start_stop_device(sdkp, 1);
-
-done:
-	scsi_disk_put(sdkp);
-	return ret;
+	return sd_start_stop_device(sdkp, 1);
 }
 
 /**
-- 
1.9.1

