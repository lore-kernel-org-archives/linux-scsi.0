From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH] Fix a bdi reregistration race, v3
Date: Mon, 28 Mar 2016 14:29:19 -0700
Message-ID: <56F9A22F.7020002@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn1on0074.outbound.protection.outlook.com ([157.56.110.74]:64592
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752252AbcC1V3m (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 28 Mar 2016 17:29:42 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <james.bottomley@hansenpartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Avoid that the sd driver registers a BDI device with a name that
is still in use. This patch avoids that the following warning gets
triggered:

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
Cc: <stable@vger.kernel.org>
---
 drivers/scsi/scsi_sysfs.c | 30 +++++++++++++++++++++++++++++-
 1 file changed, 29 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 2b642b1..567f2a0 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -1272,9 +1272,26 @@ int scsi_sysfs_add_sdev(struct scsi_device *sdev)
 	return error;
 }
 
+static int scsi_return_dev(struct device *dev, void *data)
+{
+	struct device **childp = data;
+
+	*childp = dev;
+	return 0;
+}
+
+/* Caller must call put_device() if this function does not return NULL. */
+static struct device *scsi_get_child_dev(struct device *dev)
+{
+	struct device *child = NULL;
+
+	device_for_each_child(dev, &child, scsi_return_dev);
+	return get_device(child);
+}
+
 void __scsi_remove_device(struct scsi_device *sdev)
 {
-	struct device *dev = &sdev->sdev_gendev;
+	struct device *dev = &sdev->sdev_gendev, *sdkp = NULL;
 
 	/*
 	 * This cleanup path is not reentrant and while it is impossible
@@ -1289,6 +1306,7 @@ void __scsi_remove_device(struct scsi_device *sdev)
 			return;
 
 		bsg_unregister_queue(sdev->request_queue);
+		sdkp = scsi_get_child_dev(dev);
 		device_unregister(&sdev->sdev_dev);
 		transport_remove_device(dev);
 		scsi_dh_remove_device(sdev);
@@ -1305,6 +1323,16 @@ void __scsi_remove_device(struct scsi_device *sdev)
 	blk_cleanup_queue(sdev->request_queue);
 	cancel_work_sync(&sdev->requeue_work);
 
+	/*
+	 * blk_cleanup_queue() unregisters the BDI device. The name of the
+	 * BDI device is derived from the dev_t of the /dev/sd<n> device.
+	 * Keep a reference to the /dev/sd<n> device until the BDI device
+	 * has been unregistered to avoid that a BDI device with the same
+	 * name gets registered before blk_cleanup_queue() has finished.
+	 */
+	if (sdkp)
+		put_device(sdkp);
+
 	if (sdev->host->hostt->slave_destroy)
 		sdev->host->hostt->slave_destroy(sdev);
 	transport_destroy_device(dev);
-- 
2.7.3

