From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH for v3.19, v2] Avoid that sd_shutdown() triggers a kernel
 warning
Date: Thu, 8 Jan 2015 05:15:08 -0800
Message-ID: <20150108131508.GA31022@infradead.org>
References: <54AD2E9A.50709@acm.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="dDRMvlgZJXvWKvBx"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:52329 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754419AbbAHNPM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Jan 2015 08:15:12 -0500
Content-Disposition: inline
In-Reply-To: <54AD2E9A.50709@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: James Bottomley <jbottomley@parallels.com>, Christoph Hellwig <hch@infradead.org>, Hannes Reinecke <hare@suse.de>, Alan Stern <stern@rowland.harvard.edu>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>


--dDRMvlgZJXvWKvBx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jan 07, 2015 at 02:03:22PM +0100, Bart Van Assche wrote:
> Since kernel v3.19-rc1 module_refcount() returns 1 instead of 0
> when called from inside module_exit(). This breaks the
> module_refcount() test in scsi_device_put() and hence causes the
> following kernel warning to be reported when unloading the ib_srp
> kernel module:

This is getting better, but I still think we need to sort out the root
cause.

The problemt started with commit 39b7f1e25 ("[SCSI] sd: Fix refcounting"),
which added the calls to scsi_device_get in various struct
device_driver/scsi_driver methods.  From the BZ it seems like the
rationale was to protect against races between ->rescan and ->remove,
but instead of doing that using refcounting we better ensure that
in the SCSI midlayer by taking scan_mutex around calls to ->rescan.
The first attached patch does that, which allows us to functionally
revert 39b7f1e25, which then also allows to revert 85b6c720
("[SCSI] sd: fix cache flushing on module removal (and individual
device removal)").

See the attached series to do that.  Warnings: so far it only got
minimal testing.


--dDRMvlgZJXvWKvBx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="0001-scsi-serialize-rescan-against-remove.patch"

>From f92b9687a9663d4bf304303658acfe03167e0667 Mon Sep 17 00:00:00 2001
From: Christoph Hellwig <hch@lst.de>
Date: Thu, 8 Jan 2015 11:59:56 +0100
Subject: scsi: serialize ->rescan against ->remove

Take the scan_mutex when rescanning a device to protect against a
concurrent device removal.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/scsi_scan.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 0deb385..7d926cd 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -1569,16 +1569,18 @@ EXPORT_SYMBOL(scsi_add_device);
 
 void scsi_rescan_device(struct device *dev)
 {
-	if (!dev->driver)
-		return;
+	struct scsi_device *sdev = to_scsi_device(dev);
+	struct Scsi_Host *shost = sdev->host;
 
-	if (try_module_get(dev->driver->owner)) {
+	mutex_lock(&shost->scan_mutex);
+	if (dev->driver && try_module_get(dev->driver->owner)) {
 		struct scsi_driver *drv = to_scsi_driver(dev->driver);
 
 		if (drv->rescan)
 			drv->rescan(dev);
 		module_put(dev->driver->owner);
 	}
+	mutex_unlock(&shost->scan_mutex);
 }
 EXPORT_SYMBOL(scsi_rescan_device);
 
-- 
1.9.1


--dDRMvlgZJXvWKvBx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="0002-sd-don-t-grab-reference-device-references-from-drive.patch"

>From c056e4f177617d095eca495f94753f16043eb38b Mon Sep 17 00:00:00 2001
From: Christoph Hellwig <hch@lst.de>
Date: Thu, 8 Jan 2015 12:07:05 +0100
Subject: sd: don't grab reference device references from driver methods

The device model already takes care of races from ->remove and ->shutdown
vs its other methods, and we now take care for the scsi-specific methods
as well.

This is a partial, manual revert of commit 39b7f1e25
("[SCSI] sd: Fix refcounting").

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/sd.c | 55 +++++++++++--------------------------------------------
 1 file changed, 11 insertions(+), 44 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index ebf35cb6..be76130 100644
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


--dDRMvlgZJXvWKvBx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="0003-Revert-SCSI-sd-fix-cache-flushing-on-module-removal-.patch"

>From 53378be96577c3fdb31dc1bdc0a73ec49171c763 Mon Sep 17 00:00:00 2001
From: Christoph Hellwig <hch@lst.de>
Date: Thu, 8 Jan 2015 12:10:29 +0100
Subject: Revert "[SCSI] sd: fix cache flushing on module removal (and
 individual device removal)"

This reverts commit 85b6c720b0931101c8bcc3a5abdc2b8514b0fb4b.

We now never call scsi_device_get from the shutdown path, and this
workaround turned out to create more problems than it solves.  Move
back to properly checking the device state and carefully handle
module refcounting including checking the return value.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/scsi.c | 19 ++++++-------------
 1 file changed, 6 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 08c90a7..ff8f888 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -975,14 +975,14 @@ EXPORT_SYMBOL(scsi_report_opcode);
  */
 int scsi_device_get(struct scsi_device *sdev)
 {
-	if (sdev->sdev_state == SDEV_DEL)
+	if (sdev->sdev_state == SDEV_DEL || sdev->sdev_state == SDEV_CANCEL)
 		return -ENXIO;
 	if (!get_device(&sdev->sdev_gendev))
 		return -ENXIO;
-	/* We can fail this if we're doing SCSI operations
-	 * from module exit (like cache flush) */
-	try_module_get(sdev->host->hostt->module);
-
+	if (!try_module_get(sdev->host->hostt->module)) {
+		put_device(&sdev->sdev_gendev);
+		return -ENXIO;
+	}
 	return 0;
 }
 EXPORT_SYMBOL(scsi_device_get);
@@ -997,14 +997,7 @@ EXPORT_SYMBOL(scsi_device_get);
  */
 void scsi_device_put(struct scsi_device *sdev)
 {
-#ifdef CONFIG_MODULE_UNLOAD
-	struct module *module = sdev->host->hostt->module;
-
-	/* The module refcount will be zero if scsi_device_get()
-	 * was called from a module removal routine */
-	if (module && module_refcount(module) != 0)
-		module_put(module);
-#endif
+	module_put(sdev->host->hostt->module);
 	put_device(&sdev->sdev_gendev);
 }
 EXPORT_SYMBOL(scsi_device_put);
-- 
1.9.1


--dDRMvlgZJXvWKvBx--
