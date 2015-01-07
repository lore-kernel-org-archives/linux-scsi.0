From: Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH for v3.19, v2] Avoid that sd_shutdown() triggers a kernel
 warning
Date: Wed, 07 Jan 2015 14:03:22 +0100
Message-ID: <54AD2E9A.50709@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sf1.bxl.stone.is ([87.238.167.36]:35963 "EHLO sf1.bxl.stone.is"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752951AbbAGNiu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 7 Jan 2015 08:38:50 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>, Christoph Hellwig <hch@infradead.org>
Cc: Hannes Reinecke <hare@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Since kernel v3.19-rc1 module_refcount() returns 1 instead of 0
when called from inside module_exit(). This breaks the
module_refcount() test in scsi_device_put() and hence causes the
following kernel warning to be reported when unloading the ib_srp
kernel module:

WARNING: CPU: 5 PID: 228 at kernel/module.c:954 module_put+0x207/0x220()

Call Trace:
 [<ffffffff814d1fcf>] dump_stack+0x4c/0x65
 [<ffffffff81053ada>] warn_slowpath_common+0x8a/0xc0
 [<ffffffff81053bca>] warn_slowpath_null+0x1a/0x20
 [<ffffffff810d0507>] module_put+0x207/0x220
 [<ffffffffa000bea8>] scsi_device_put+0x48/0x50 [scsi_mod]
 [<ffffffffa03676d2>] scsi_disk_put+0x32/0x50 [sd_mod]
 [<ffffffffa0368d4c>] sd_shutdown+0x8c/0x150 [sd_mod]
 [<ffffffffa0368e79>] sd_remove+0x69/0xc0 [sd_mod]
 [<ffffffff813457ef>] __device_release_driver+0x7f/0xf0
 [<ffffffff81345885>] device_release_driver+0x25/0x40
 [<ffffffff81345134>] bus_remove_device+0x124/0x1b0
 [<ffffffff8134189e>] device_del+0x13e/0x250
 [<ffffffffa001cdcd>] __scsi_remove_device+0xcd/0xe0 [scsi_mod]
 [<ffffffffa001b39f>] scsi_forget_host+0x6f/0x80 [scsi_mod]
 [<ffffffffa000d5f6>] scsi_remove_host+0x86/0x140 [scsi_mod]
 [<ffffffffa07d5c0b>] srp_remove_work+0x9b/0x210 [ib_srp]
 [<ffffffff8106fd28>] process_one_work+0x1d8/0x780
 [<ffffffff810703eb>] worker_thread+0x11b/0x4a0
 [<ffffffff81075a6f>] kthread+0xef/0x110
 [<ffffffff814dad6c>] ret_from_fork+0x7c/0xb0

See also patch "module: Remove stop_machine from module unloading"
(Masami Hiramatsu; commit e513cc1c07e2; kernel v3.19-rc1).

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/scsi.c        | 63 ++++++++++++++++++++++++++++++++--------------
 drivers/scsi/sd.c          | 44 +++++++++++++++++---------------
 include/scsi/scsi_device.h |  2 ++
 3 files changed, 70 insertions(+), 39 deletions(-)

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index e028854..2cae46b 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -973,30 +973,63 @@ int scsi_report_opcode(struct scsi_device *sdev, unsigned char *buffer,
 EXPORT_SYMBOL(scsi_report_opcode);
 
 /**
- * scsi_device_get  -  get an additional reference to a scsi_device
+ * scsi_dev_get - get an additional reference to a scsi_device
  * @sdev:	device to get a reference to
+ * @get_lld:    whether or not to increase the LLD kernel module refcount
  *
- * Description: Gets a reference to the scsi_device and increments the use count
- * of the underlying LLDD module.  You must hold host_lock of the
- * parent Scsi_Host or already have a reference when calling this.
+ * Description: Gets a reference to the scsi_device and optionally increments
+ * the use count of the associated LLDD module. You must hold host_lock of
+ * the parent Scsi_Host or already have a reference when calling this.
  */
-int scsi_device_get(struct scsi_device *sdev)
+int scsi_dev_get(struct scsi_device *sdev, bool get_lld)
 {
 	if (sdev->sdev_state == SDEV_DEL)
 		return -ENXIO;
 	if (!get_device(&sdev->sdev_gendev))
 		return -ENXIO;
-	/* We can fail this if we're doing SCSI operations
-	 * from module exit (like cache flush) */
-	try_module_get(sdev->host->hostt->module);
+	/* Can fail if invoked during module exit (like cache flush) */
+	if (get_lld && !try_module_get(sdev->host->hostt->module)) {
+		put_device(&sdev->sdev_gendev);
+		return -ENXIO;
+	}
 
 	return 0;
 }
+EXPORT_SYMBOL(scsi_dev_get);
+
+/**
+ * scsi_dev_put - release a reference to a scsi_device
+ * @sdev:	device to release a reference on
+ * @put_lld:    whether or not to decrease the LLD kernel module refcount
+ *
+ * Description: Release a reference to the scsi_device. The device is freed
+ * once the last user vanishes.
+ */
+void scsi_dev_put(struct scsi_device *sdev, bool put_lld)
+{
+	if (put_lld)
+		module_put(sdev->host->hostt->module);
+	put_device(&sdev->sdev_gendev);
+}
+EXPORT_SYMBOL(scsi_dev_put);
+
+/**
+ * scsi_device_get - get an additional reference to a scsi_device
+ * @sdev:	device to get a reference to
+ *
+ * Description: Gets a reference to the scsi_device and increments the use count
+ * of the underlying LLDD module.  You must hold host_lock of the
+ * parent Scsi_Host or already have a reference when calling this.
+ */
+int scsi_device_get(struct scsi_device *sdev)
+{
+	return scsi_dev_get(sdev, true);
+}
 EXPORT_SYMBOL(scsi_device_get);
 
 /**
- * scsi_device_put  -  release a reference to a scsi_device
- * @sdev:	device to release a reference on.
+ * scsi_device_put - release a reference to a scsi_device
+ * @sdev:	device to release a reference on
  *
  * Description: Release a reference to the scsi_device and decrements the use
  * count of the underlying LLDD module.  The device is freed once the last
@@ -1004,15 +1037,7 @@ EXPORT_SYMBOL(scsi_device_get);
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
-	put_device(&sdev->sdev_gendev);
+	scsi_dev_put(sdev, true);
 }
 EXPORT_SYMBOL(scsi_device_put);
 
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index fedab3c..05ab2ec 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -564,13 +564,13 @@ static int sd_major(int major_idx)
 	}
 }
 
-static struct scsi_disk *__scsi_disk_get(struct gendisk *disk)
+static struct scsi_disk *__scsi_disk_get(struct gendisk *disk, bool get_lld)
 {
 	struct scsi_disk *sdkp = NULL;
 
 	if (disk->private_data) {
 		sdkp = scsi_disk(disk);
-		if (scsi_device_get(sdkp->device) == 0)
+		if (scsi_dev_get(sdkp->device, get_lld) == 0)
 			get_device(&sdkp->dev);
 		else
 			sdkp = NULL;
@@ -578,35 +578,36 @@ static struct scsi_disk *__scsi_disk_get(struct gendisk *disk)
 	return sdkp;
 }
 
-static struct scsi_disk *scsi_disk_get(struct gendisk *disk)
+static struct scsi_disk *scsi_disk_get(struct gendisk *disk, bool get_lld)
 {
 	struct scsi_disk *sdkp;
 
 	mutex_lock(&sd_ref_mutex);
-	sdkp = __scsi_disk_get(disk);
+	sdkp = __scsi_disk_get(disk, get_lld);
 	mutex_unlock(&sd_ref_mutex);
 	return sdkp;
 }
 
-static struct scsi_disk *scsi_disk_get_from_dev(struct device *dev)
+static struct scsi_disk *scsi_disk_get_from_dev(struct device *dev,
+						bool get_lld)
 {
 	struct scsi_disk *sdkp;
 
 	mutex_lock(&sd_ref_mutex);
 	sdkp = dev_get_drvdata(dev);
 	if (sdkp)
-		sdkp = __scsi_disk_get(sdkp->disk);
+		sdkp = __scsi_disk_get(sdkp->disk, get_lld);
 	mutex_unlock(&sd_ref_mutex);
 	return sdkp;
 }
 
-static void scsi_disk_put(struct scsi_disk *sdkp)
+static void scsi_disk_put(struct scsi_disk *sdkp, bool put_lld)
 {
 	struct scsi_device *sdev = sdkp->device;
 
 	mutex_lock(&sd_ref_mutex);
 	put_device(&sdkp->dev);
-	scsi_device_put(sdev);
+	scsi_dev_put(sdev, put_lld);
 	mutex_unlock(&sd_ref_mutex);
 }
 
@@ -1184,7 +1185,7 @@ static void sd_uninit_command(struct scsi_cmnd *SCpnt)
  **/
 static int sd_open(struct block_device *bdev, fmode_t mode)
 {
-	struct scsi_disk *sdkp = scsi_disk_get(bdev->bd_disk);
+	struct scsi_disk *sdkp = scsi_disk_get(bdev->bd_disk, true);
 	struct scsi_device *sdev;
 	int retval;
 
@@ -1239,7 +1240,7 @@ static int sd_open(struct block_device *bdev, fmode_t mode)
 	return 0;
 
 error_out:
-	scsi_disk_put(sdkp);
+	scsi_disk_put(sdkp, true);
 	return retval;	
 }
 
@@ -1273,7 +1274,7 @@ static void sd_release(struct gendisk *disk, fmode_t mode)
 	 * XXX is followed by a "rmmod sd_mod"?
 	 */
 
-	scsi_disk_put(sdkp);
+	scsi_disk_put(sdkp, true);
 }
 
 static int sd_getgeo(struct block_device *bdev, struct hd_geometry *geo)
@@ -1525,11 +1526,11 @@ static int sd_sync_cache(struct scsi_disk *sdkp)
 
 static void sd_rescan(struct device *dev)
 {
-	struct scsi_disk *sdkp = scsi_disk_get_from_dev(dev);
+	struct scsi_disk *sdkp = scsi_disk_get_from_dev(dev, true);
 
 	if (sdkp) {
 		revalidate_disk(sdkp->disk);
-		scsi_disk_put(sdkp);
+		scsi_disk_put(sdkp, true);
 	}
 }
 
@@ -3142,11 +3143,14 @@ static int sd_start_stop_device(struct scsi_disk *sdkp, int start)
 /*
  * Send a SYNCHRONIZE CACHE instruction down to the device through
  * the normal SCSI command structure.  Wait for the command to
- * complete.
+ * complete.  Since this function can be called during SCSI LLD kernel
+ * module unload and since try_module_get() fails after kernel module
+ * unload has started this function must not try to increase the SCSI
+ * LLD kernel module refcount.
  */
 static void sd_shutdown(struct device *dev)
 {
-	struct scsi_disk *sdkp = scsi_disk_get_from_dev(dev);
+	struct scsi_disk *sdkp = scsi_disk_get_from_dev(dev, false);
 
 	if (!sdkp)
 		return;         /* this can happen */
@@ -3165,12 +3169,12 @@ static void sd_shutdown(struct device *dev)
 	}
 
 exit:
-	scsi_disk_put(sdkp);
+	scsi_disk_put(sdkp, false);
 }
 
 static int sd_suspend_common(struct device *dev, bool ignore_stop_errors)
 {
-	struct scsi_disk *sdkp = scsi_disk_get_from_dev(dev);
+	struct scsi_disk *sdkp = scsi_disk_get_from_dev(dev, true);
 	int ret = 0;
 
 	if (!sdkp)
@@ -3196,7 +3200,7 @@ static int sd_suspend_common(struct device *dev, bool ignore_stop_errors)
 	}
 
 done:
-	scsi_disk_put(sdkp);
+	scsi_disk_put(sdkp, true);
 	return ret;
 }
 
@@ -3212,7 +3216,7 @@ static int sd_suspend_runtime(struct device *dev)
 
 static int sd_resume(struct device *dev)
 {
-	struct scsi_disk *sdkp = scsi_disk_get_from_dev(dev);
+	struct scsi_disk *sdkp = scsi_disk_get_from_dev(dev, true);
 	int ret = 0;
 
 	if (!sdkp->device->manage_start_stop)
@@ -3222,7 +3226,7 @@ static int sd_resume(struct device *dev)
 	ret = sd_start_stop_device(sdkp, 1);
 
 done:
-	scsi_disk_put(sdkp);
+	scsi_disk_put(sdkp, true);
 	return ret;
 }
 
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 3a4edd1..a4cb852 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -330,6 +330,8 @@ extern void scsi_remove_device(struct scsi_device *);
 extern int scsi_unregister_device_handler(struct scsi_device_handler *scsi_dh);
 void scsi_attach_vpd(struct scsi_device *sdev);
 
+extern int scsi_dev_get(struct scsi_device *, bool get_lld);
+extern void scsi_dev_put(struct scsi_device *, bool put_lld);
 extern int scsi_device_get(struct scsi_device *);
 extern void scsi_device_put(struct scsi_device *);
 extern struct scsi_device *scsi_device_lookup(struct Scsi_Host *,
-- 
2.1.2

