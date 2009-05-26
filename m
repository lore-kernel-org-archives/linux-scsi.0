From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: Bug in SCSI async probing
Date: Tue, 26 May 2009 20:35:48 +0000
Message-ID: <1243370148.2815.72.camel@localhost.localdomain>
References: <Pine.LNX.4.44L0.0905261545360.9278-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:38757 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752248AbZEZUfr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 26 May 2009 16:35:47 -0400
In-Reply-To: <Pine.LNX.4.44L0.0905261545360.9278-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Arjan van de Ven <arjan@linux.intel.com>, SCSI development list <linux-scsi@vger.kernel.org>, Kernel development list <linux-kernel@vger.kernel.org>

On Tue, 2009-05-26 at 15:48 -0400, Alan Stern wrote:
> On Tue, 26 May 2009, James Bottomley wrote:
> 
> > Details?...  In theory the sd driver can be attached at any time and
> > nothing should be relying on it being there when the inquiry scan
> > finishes, so if there's a bug it would be exposed by async scanning, not
> > really caused by it.
> 
> Provided the async scanning is implemented correctly...
> 
> > > (Which reminds me...  Are the calls in wait_scan_init() really enough?  
> > > wait_for_device_probe() does async_synchronize_full() and then
> > > scsi_complete_async_scans() finishes the SCSI scanning.  But if this
> > > scanning involves calling sd_probe(), then more async work will be
> > > queued.  Maybe a second call to wait_for_device_probe() is needed.)
> 
> You didn't respond to this point.

Well this was the response:

> > None of this really got reviewed through the SCSI list, so I'll let
> > Arjan answer.
> > 
> > > And why is it that the "out_free_index:" code in sd_probe() acquires 
> > > sd_index_lock but the corresponding code in sd_probe_async() doesn't?
> > 
> > This one looks to be a mismerge between the async tree and the SCSI
> > tree.
> 
> Well then, how does this patch look?

Well, it's adding complexity, the best fix is to let async only take
care of the pieces which can't fail, that way we don't need complex
error handling.  The piece that slows probing isn't really the sysfs
appearances, it's the SCSI probing, and the last piece that needs error
handling is the device_add() for sysfs visibility, so that should be the
dividing line between sync and async.

This should restore the logical flow and fix all the error leg problems
(by eliminating the error legs).

James

---

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index bcf3bd4..d74315d 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1902,24 +1902,6 @@ static void sd_probe_async(void *data, async_cookie_t cookie)
 	index = sdkp->index;
 	dev = &sdp->sdev_gendev;
 
-	if (!sdp->request_queue->rq_timeout) {
-		if (sdp->type != TYPE_MOD)
-			blk_queue_rq_timeout(sdp->request_queue, SD_TIMEOUT);
-		else
-			blk_queue_rq_timeout(sdp->request_queue,
-					     SD_MOD_TIMEOUT);
-	}
-
-	device_initialize(&sdkp->dev);
-	sdkp->dev.parent = &sdp->sdev_gendev;
-	sdkp->dev.class = &sd_disk_class;
-	dev_set_name(&sdkp->dev, dev_name(&sdp->sdev_gendev));
-
-	if (device_add(&sdkp->dev))
-		goto out_free_index;
-
-	get_device(&sdp->sdev_gendev);
-
 	if (index < SD_MAX_DISKS) {
 		gd->major = sd_major((index & 0xf0) >> 4);
 		gd->first_minor = ((index & 0xf) << 4) | (index & 0xfff00);
@@ -1954,11 +1936,6 @@ static void sd_probe_async(void *data, async_cookie_t cookie)
 
 	sd_printk(KERN_NOTICE, sdkp, "Attached SCSI %sdisk\n",
 		  sdp->removable ? "removable " : "");
-
-	return;
-
- out_free_index:
-	ida_remove(&sd_index_ida, index);
 }
 
 /**
@@ -2026,6 +2003,24 @@ static int sd_probe(struct device *dev)
 	sdkp->openers = 0;
 	sdkp->previous_state = 1;
 
+	if (!sdp->request_queue->rq_timeout) {
+		if (sdp->type != TYPE_MOD)
+			blk_queue_rq_timeout(sdp->request_queue, SD_TIMEOUT);
+		else
+			blk_queue_rq_timeout(sdp->request_queue,
+					     SD_MOD_TIMEOUT);
+	}
+
+	device_initialize(&sdkp->dev);
+	sdkp->dev.parent = &sdp->sdev_gendev;
+	sdkp->dev.class = &sd_disk_class;
+	dev_set_name(&sdkp->dev, dev_name(&sdp->sdev_gendev));
+
+	if (device_add(&sdkp->dev))
+		goto out_free_index;
+
+	get_device(&sdp->sdev_gendev);
+
 	async_schedule(sd_probe_async, sdkp);
 
 	return 0;
@@ -2057,6 +2052,7 @@ static int sd_remove(struct device *dev)
 {
 	struct scsi_disk *sdkp = dev_get_drvdata(dev);
 
+	async_synchronize_full();
 	device_del(&sdkp->dev);
 	del_gendisk(sdkp->disk);
 	sd_shutdown(dev);


