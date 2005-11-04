From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] sd: fix race between rescan and remove
Date: Thu, 03 Nov 2005 21:08:33 -0500
Message-ID: <1131070114.3352.14.camel@mulgrave>
References: <Pine.LNX.4.44L0.0511031047350.5056-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:15577 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1030587AbVKDCJN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 3 Nov 2005 21:09:13 -0500
In-Reply-To: <Pine.LNX.4.44L0.0511031047350.5056-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

On Thu, 2005-11-03 at 10:54 -0500, Alan Stern wrote: 
> When the well-known open/remove race was fixed in sd.c, a closely-related
> race between rescan and remove was ignored.  Probably because rescan gets 
> called from an unusual pathway (via sysfs).  It's easy for this race to
> trigger an oops, especially if you unplug a USB storage device while a
> user program continually writes to the "rescan" attribute file.
> 
> This patch (as597) fixes the race by making the rescan routine acquire the 
> appropriate references.  It also cleans up the code scsi_disk_get 
> somewhat.  This resolves Bugzilla entry #5237.

Thanks for investigating this ... I really hate debugging these obscure
object reference races.

I'm afraid that your fix isn't quite right:  The problem occurs because
in most cases scsi_remove_device will call sd_remove (via the driver
model call backs from device_del).  The kref_put in sd_remove will
(almost always) trigger scsi_disk_release which frees sdkp.  So, I'm
afraid you can't rely on sdkp->device being correct.

The fix for this one is a bit nasty because it's a reversal in the
logic.  The usual logic is that the user does something, so we have a
refcounted gendisk object that we tie to scsi_disk and then scsi_device.
In this case, we actually get a scsi_device and we have to try to work
out how to get a valid refcounted scsi_disk object out of it.
Unfortunately, this problem doesn't just affect sd_rescan, it affects
the flush functions too where they try to do the same thing.

Could you take a look at the attached?  I just threw it together on a
'plane, so it's completely untested.  It tries to implement the secure
get of struct scsi_disk by tying the nulling out of drvdata to the
sd_ref_sem, so we can now either get a reference to the scsi_disk or
return NULL.  I also fixed all the other relevant driver data users to
follow this model.

Thanks,

James

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -177,24 +177,38 @@ static inline struct scsi_disk *scsi_dis
 	return container_of(disk->private_data, struct scsi_disk, driver);
 }
 
-static struct scsi_disk *scsi_disk_get(struct gendisk *disk)
+static struct scsi_disk *__scsi_disk_get(struct gendisk *disk)
 {
 	struct scsi_disk *sdkp = NULL;
 
-	down(&sd_ref_sem);
 	if (disk->private_data == NULL)
 		goto out;
 	sdkp = scsi_disk(disk);
+	if (scsi_device_get(sdkp->device)) {
+		sdkp = NULL;
+		goto out;
+	}
 	kref_get(&sdkp->kref);
-	if (scsi_device_get(sdkp->device))
-		goto out_put;
+ out:
+	return sdkp;
+}
+
+static struct scsi_disk *scsi_disk_get(struct gendisk *disk)
+{
+	struct scsi_disk *sdkp;
+	down(&sd_ref_sem);
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
+	down(&sd_ref_sem);
+	sdkp = dev_get_drvdata(dev);
+	if (sdkp)
+		sdkp = __scsi_disk_get(sdkp->disk);
 	up(&sd_ref_sem);
 	return sdkp;
 }
@@ -716,16 +730,20 @@ static int sd_sync_cache(struct scsi_dev
 
 static int sd_issue_flush(struct device *dev, sector_t *error_sector)
 {
+	int ret = 0;
 	struct scsi_device *sdp = to_scsi_device(dev);
-	struct scsi_disk *sdkp = dev_get_drvdata(dev);
+	struct scsi_disk *sdkp = scsi_disk_get_from_dev(dev);
 
 	if (!sdkp)
                return -ENODEV;
 
 	if (!sdkp->WCE)
-		return 0;
+		goto out;
 
-	return sd_sync_cache(sdp);
+	ret = sd_sync_cache(sdp);
+ out:
+	scsi_disk_put(sdkp);
+	return ret;
 }
 
 static void sd_end_flush(request_queue_t *q, struct request *flush_rq)
@@ -754,13 +772,14 @@ static void sd_end_flush(request_queue_t
 static int sd_prepare_flush(request_queue_t *q, struct request *rq)
 {
 	struct scsi_device *sdev = q->queuedata;
-	struct scsi_disk *sdkp = dev_get_drvdata(&sdev->sdev_gendev);
+	struct scsi_disk *sdkp = scsi_disk_get_from_dev(&sdev->sdev_gendev);
 
-	if (sdkp->WCE) {
+	if (sdkp && sdkp->WCE) {
 		memset(rq->cmd, 0, sizeof(rq->cmd));
 		rq->flags |= REQ_BLOCK_PC | REQ_SOFTBARRIER;
 		rq->timeout = SD_TIMEOUT;
 		rq->cmd[0] = SYNCHRONIZE_CACHE;
+		scsi_disk_put(sdkp);
 		return 1;
 	}
 
@@ -769,8 +788,11 @@ static int sd_prepare_flush(request_queu
 
 static void sd_rescan(struct device *dev)
 {
-	struct scsi_disk *sdkp = dev_get_drvdata(dev);
-	sd_revalidate_disk(sdkp->disk);
+	struct scsi_disk *sdkp = scsi_disk_get_from_dev(dev);
+	if (sdkp) {
+		sd_revalidate_disk(sdkp->disk);
+		scsi_disk_put(sdkp);
+	}
 }
 
 
@@ -1641,6 +1663,7 @@ static int sd_remove(struct device *dev)
 	del_gendisk(sdkp->disk);
 	sd_shutdown(dev);
 	down(&sd_ref_sem);
+	dev_set_drvdata(dev, NULL);
 	kref_put(&sdkp->kref, scsi_disk_release);
 	up(&sd_ref_sem);
 
@@ -1680,18 +1703,20 @@ static void scsi_disk_release(struct kre
 static void sd_shutdown(struct device *dev)
 {
 	struct scsi_device *sdp = to_scsi_device(dev);
-	struct scsi_disk *sdkp = dev_get_drvdata(dev);
+	struct scsi_disk *sdkp = scsi_disk_get_from_dev(dev);
 
 	if (!sdkp)
 		return;         /* this can happen */
 
 	if (!sdkp->WCE)
-		return;
+		goto out;
 
 	printk(KERN_NOTICE "Synchronizing SCSI cache for disk %s: \n",
 			sdkp->disk->disk_name);
 	sd_sync_cache(sdp);
-}	
+ out:
+	scsi_disk_put(sdkp);
+}
 
 /**
  *	init_sd - entry point for this driver (both when built in or when


