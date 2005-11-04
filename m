From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH] sd: fix race between rescan and remove
Date: Fri, 4 Nov 2005 11:40:23 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.0511041039180.4812-100000@iolanthe.rowland.org>
References: <1131070114.3352.14.camel@mulgrave>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:2272 "HELO
	iolanthe.rowland.org") by vger.kernel.org with SMTP
	id S1750711AbVKDQk0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 4 Nov 2005 11:40:26 -0500
In-Reply-To: <1131070114.3352.14.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

On Thu, 3 Nov 2005, James Bottomley wrote:

> Thanks for investigating this ... I really hate debugging these obscure
> object reference races.

Yeah, it was a real pain to find the cause.  Took most of two days.  And 
yet it should have been obvious where to look...

> I'm afraid that your fix isn't quite right:  The problem occurs because
> in most cases scsi_remove_device will call sd_remove (via the driver
> model call backs from device_del).  The kref_put in sd_remove will
> (almost always) trigger scsi_disk_release which frees sdkp.  So, I'm
> afraid you can't rely on sdkp->device being correct.

Hmm.  Surely that's a problem for the old scsi_disk_get routine rather 
than the new scsi_disk_get_from_dev routine?

The problem I fixed was different: sdkp was getting freed while it was 
still in use by the rescan procedure.  But I agree that after sd_remove 
returns, we can't depend on sdkp->device being correct.

> The fix for this one is a bit nasty because it's a reversal in the
> logic.  The usual logic is that the user does something, so we have a
> refcounted gendisk object that we tie to scsi_disk and then scsi_device.
> In this case, we actually get a scsi_device and we have to try to work
> out how to get a valid refcounted scsi_disk object out of it.
> Unfortunately, this problem doesn't just affect sd_rescan, it affects
> the flush functions too where they try to do the same thing.

I wasn't sure about them.  It wasn't clear if they could get called after 
sd_remove.  However it certainly doesn't hurt to make them call the new 
routine.

> Could you take a look at the attached?  I just threw it together on a
> 'plane, so it's completely untested.  It tries to implement the secure
> get of struct scsi_disk by tying the nulling out of drvdata to the
> sd_ref_sem, so we can now either get a reference to the scsi_disk or
> return NULL.  I also fixed all the other relevant driver data users to
> follow this model.

I see three differences between your patch and mine:

	You refactored the common code in scsi_disk_get and
	scsi_disk_get_from_dev.  Okay, that's fine, although
	it looks a little strange to be going all the way
	down to the disk just to go back up to the sdkp.
	Note that when scsi_disk_get_from_dev calls __scsi_disk_get,
	it's not possible for disk->private_data to be NULL.

	You added calls to scsi_disk_get_from_dev in the flush
	and shutdown routines.  That's good; I would have done
	it originally had I known it was needed.

	You added dev_set_drvdata(dev, NULL) to sd_remove.
	Actually I'm astonished it wasn't there before and that
	I didn't realize it was missing.  I guess nobody
	considered that the scsi_device might outlive the disk.

This is all good.  I've made a few stylistic changes (mostly to avoid goto
statements).  By the way, is there any reason that disk->private_data is
set to &sdkp->driver instead of to sdkp?  I don't see any, so I'll change
it.

However this still doesn't solve the problem you mentioned.  Somehow
sd_remove has to tell __scsi_disk_get that sdkp->device might be gone.  
The only way I can think of is to add an extra bitfield to the scsi_disk
structure.

This patch solves the original problem and works okay on my system.  If it 
looks okay to you, I'll resend it as a proper patch submission.

Alan Stern



Index: usb-2.6/drivers/scsi/sd.c
===================================================================
--- usb-2.6.orig/drivers/scsi/sd.c
+++ usb-2.6/drivers/scsi/sd.c
@@ -102,6 +102,7 @@ struct scsi_disk {
 	u8		write_prot;
 	unsigned	WCE : 1;	/* state of disk WCE bit */
 	unsigned	RCD : 1;	/* state of disk RCD bit, unused */
+	unsigned	gone : 1;	/* the scsi_device has been removed */
 };
 
 static DEFINE_IDR(sd_index_idr);
@@ -174,27 +175,38 @@ static int sd_major(int major_idx)
 
 static inline struct scsi_disk *scsi_disk(struct gendisk *disk)
 {
-	return container_of(disk->private_data, struct scsi_disk, driver);
+	return (struct scsi_disk *) (disk->private_data);
+}
+
+static struct scsi_disk *__scsi_disk_get(struct gendisk *disk)
+{
+	struct scsi_disk *sdkp = scsi_disk(disk);
+
+	if (sdkp && !sdkp->gone && scsi_device_get(sdkp->device) == 0)
+		kref_get(&sdkp->kref);
+	else
+		sdkp = NULL;
+	return sdkp;
 }
 
 static struct scsi_disk *scsi_disk_get(struct gendisk *disk)
 {
-	struct scsi_disk *sdkp = NULL;
+	struct scsi_disk *sdkp;
 
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
@@ -716,16 +728,18 @@ static int sd_sync_cache(struct scsi_dev
 
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
+	if (sdkp->WCE)
+		ret = sd_sync_cache(sdp);
 
-	return sd_sync_cache(sdp);
+	scsi_disk_put(sdkp);
+	return ret;
 }
 
 static void sd_end_flush(request_queue_t *q, struct request *flush_rq)
@@ -754,13 +768,14 @@ static void sd_end_flush(request_queue_t
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
 
@@ -769,8 +784,12 @@ static int sd_prepare_flush(request_queu
 
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
 
 
@@ -1593,7 +1612,7 @@ static int sd_probe(struct device *dev)
 			'a' + m1, 'a' + m2, 'a' + m3);
 	}
 
-	gd->private_data = &sdkp->driver;
+	gd->private_data = sdkp;
 
 	sd_revalidate_disk(gd);
 
@@ -1638,7 +1657,10 @@ static int sd_remove(struct device *dev)
 
 	del_gendisk(sdkp->disk);
 	sd_shutdown(dev);
+
 	down(&sd_ref_sem);
+	dev_set_drvdata(dev, NULL);
+	sdkp->gone = 1;
 	kref_put(&sdkp->kref, scsi_disk_release);
 	up(&sd_ref_sem);
 
@@ -1664,7 +1686,6 @@ static void scsi_disk_release(struct kre
 	spin_unlock(&sd_index_lock);
 
 	disk->private_data = NULL;
-
 	put_disk(disk);
 
 	kfree(sdkp);
@@ -1678,18 +1699,18 @@ static void scsi_disk_release(struct kre
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

