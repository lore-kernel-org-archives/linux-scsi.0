From: Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH] sd: no errors allowed during async probing
Date: Tue, 2 Jun 2009 14:05:44 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0906021401350.3228-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:50245 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755713AbZFBSFn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Jun 2009 14:05:43 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

This patch (as1252) fixes a bug in the sd probing code.  When the
probe routine was split up into a synchronous and an asynchronous
part, too much was put into the asynchronous part.  It's important
that all the possible failure modes occur synchronously, so that the
driver core knows whether the probe was successful even before the
async part is complete.

Another bug is that device removal has to wait for the async probing
to finish!  The patch addresses both bugs, by moving some code back
from sd_probe_async() to sd_probe() and by adding a call to
async_synchronize_full() at the start of sd_remove().

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>

---

James:

I haven't seen any progress on this patch yet, so I'm officially 
submitting it as a bug fix.  Admittedly, it's kind of presumptuous to 
put my own Signed-off-by on it, but there doesn't seem to be any other 
choice.

Alan Stern



Index: usb-2.6/drivers/scsi/sd.c
===================================================================
--- usb-2.6.orig/drivers/scsi/sd.c
+++ usb-2.6/drivers/scsi/sd.c
@@ -1902,24 +1902,6 @@ static void sd_probe_async(void *data, a
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
@@ -1954,11 +1936,6 @@ static void sd_probe_async(void *data, a
 
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
@@ -2055,7 +2050,11 @@ static int sd_probe(struct device *dev)
  **/
 static int sd_remove(struct device *dev)
 {
-	struct scsi_disk *sdkp = dev_get_drvdata(dev);
+	struct scsi_disk *sdkp;
+
+	/* Wait for sd_probe_async to finish */
+	async_synchronize_full();
+	sdkp = dev_get_drvdata(dev);
 
 	device_del(&sdkp->dev);
 	del_gendisk(sdkp->disk);

