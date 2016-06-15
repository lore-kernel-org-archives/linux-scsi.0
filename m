From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH] Fix an sd reregistration race, v5
Date: Wed, 15 Jun 2016 12:58:00 +0200
Message-ID: <4345e7a0-5487-b122-28ad-7426043259b6@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2on0073.outbound.protection.outlook.com ([207.46.100.73]:45888
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751778AbcFOK6R (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 15 Jun 2016 06:58:17 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Joe Lawrence <joe.lawrence@stratus.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Avoid that the sd driver registers a BDI device with a name that
is still in use. This patch avoids that the following warning is
triggered sporadically:

WARNING: CPU: 7 PID: 203 at fs/sysfs/dir.c:31 sysfs_warn_dup+0x68/0x80()
sysfs: cannot create duplicate filename '/devices/virtual/bdi/8:32'
Workqueue: events_unbound async_run_entry_fn
Call Trace:
[<ffffffff814ff5a4>] dump_stack+0x4c/0x65
[<ffffffff810746ba>] warn_slowpath_common+0x8a/0xc0
[<ffffffff81074736>] warn_slowpath_fmt+0x46/0x50
[<ffffffff81237ca8>] sysfs_warn_dup+0x68/0x80
[<ffffffff81237d8e>] sysfs_create_dir_ns+0x7e/0x90
[<ffffffff81291f58>] kobject_add_internal+0xa8/0x320
[<ffffffff812923a0>] kobject_add+0x60/0xb0
[<ffffffff8138c937>] device_add+0x107/0x5e0
[<ffffffff8138d018>] device_create_groups_vargs+0xd8/0x100
[<ffffffff8138d05c>] device_create_vargs+0x1c/0x20
[<ffffffff8117f233>] bdi_register+0x63/0x2a0
[<ffffffff8117f497>] bdi_register_dev+0x27/0x30
[<ffffffff81281549>] add_disk+0x1a9/0x4e0
[<ffffffffa00c5739>] sd_probe_async+0x119/0x1d0 [sd_mod]
[<ffffffff8109a81a>] async_run_entry_fn+0x4a/0x140
[<ffffffff81091078>] process_one_work+0x1d8/0x7c0
[<ffffffff81091774>] worker_thread+0x114/0x460
[<ffffffff81097878>] kthread+0xf8/0x110
[<ffffffff8150801f>] ret_from_fork+0x3f/0x70

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Joe Lawrence <joe.lawrence@stratus.com>
Cc: <stable@vger.kernel.org>
---

Changes compared to v4:
- Renamed the device filter function.
- Added test to skip sg child device.

Changes between v3 and v4:
- Added (dev->class != &sdev_class) test to device filter function.

Changes between v2 and v3:
- Switched from separating BDI unregistration and deletion to increasing
  the sd device reference count.

Changes between v1 and v2:
- Changed the approach from swapping the device_del() and
  blk_cleanup_queue() calls to separating BDI unregistration and deletion.

 drivers/scsi/scsi_sysfs.c | 45 ++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 44 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 0734927..64cebf5 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -1273,9 +1273,41 @@ int scsi_sysfs_add_sdev(struct scsi_device *sdev)
 	return error;
 }
 
+/**
+ * scsi_filter_ulpdev - Look up the device created by the ULP SCSI driver
+ * @dev: A sdev_gendev device
+ * @data: A struct device pointer
+ *
+ * sdev_gendev devices have multiple children: the device(s) that has been
+ * created by the SCSI ULP driver (e.g. sd), the sdev_dev device and the sg
+ * device. The sd driver creates one device instance itself and zero or more
+ * device instances by creating genhd instances. These last devices represent
+ * partitions. Select the device that has been created by the ULP SCSI driver
+ * by returning the first device that is not the sdev_dev device nor the sg
+ * device.
+ */
+static int scsi_filter_ulpdev(struct device *dev, void *data)
+{
+	struct device **childp = data;
+
+	if (!*childp && dev->class != &sdev_class &&
+	    strncmp(dev_name(dev), "sg", 2) != 0)
+		*childp = dev;
+	return 0;
+}
+
+/* Caller must call put_device() if this function does not return NULL. */
+static struct device *scsi_get_ulpdev(struct device *dev)
+{
+	struct device *child = NULL;
+
+	device_for_each_child(dev, &child, scsi_filter_ulpdev);
+	return get_device(child);
+}
+
 void __scsi_remove_device(struct scsi_device *sdev)
 {
-	struct device *dev = &sdev->sdev_gendev;
+	struct device *dev = &sdev->sdev_gendev, *sdp = NULL;
 
 	/*
 	 * This cleanup path is not reentrant and while it is impossible
@@ -1290,6 +1322,7 @@ void __scsi_remove_device(struct scsi_device *sdev)
 			return;
 
 		bsg_unregister_queue(sdev->request_queue);
+		sdp = scsi_get_ulpdev(dev);
 		device_unregister(&sdev->sdev_dev);
 		transport_remove_device(dev);
 		scsi_dh_remove_device(sdev);
@@ -1306,6 +1339,16 @@ void __scsi_remove_device(struct scsi_device *sdev)
 	blk_cleanup_queue(sdev->request_queue);
 	cancel_work_sync(&sdev->requeue_work);
 
+	/*
+	 * blk_cleanup_queue() unregisters the BDI device. The name of the
+	 * BDI device is derived from the dev_t of the /dev/sd<n> device.
+	 * Keep a reference to the /dev/sd<n> device until the BDI device
+	 * has been unregistered to avoid that a BDI device with the same
+	 * name gets registered before blk_cleanup_queue() has finished.
+	 */
+	if (sdp)
+		put_device(sdp);
+
 	if (sdev->host->hostt->slave_destroy)
 		sdev->host->hostt->slave_destroy(sdev);
 	transport_destroy_device(dev);
-- 
2.8.4

