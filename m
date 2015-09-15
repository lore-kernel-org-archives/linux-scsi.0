From: Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH] Block, SCSI: notify block layer about runtime PM status
 change following system resume
Date: Tue, 15 Sep 2015 15:33:09 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1509151526410.1420-100000@iolanthe.rowland.org>
References: <1442297293.3050.14.camel@kxue-X58A-UD3R>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:56161 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751014AbbIOTdK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Sep 2015 15:33:10 -0400
In-Reply-To: <1442297293.3050.14.camel@kxue-X58A-UD3R>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, Jens Axboe <axboe@kernel.dk>
Cc: Ken Xue <Ken.Xue@amd.com>, SCSI development list <linux-scsi@vger.kernel.org>, Shane.Huang@amd.com, SPG_Linux_Kernel@amd.com

The request-queue-based runtime PM implementation is missing an
ingredient.  There's no way to tell the block layer that a device has
passed directly from runtime-suspended to runtime-resumed without
invoking any runtime-PM callbacks.

Typically this happens during a system resume.  A resume callback
routine will contain some variant of the following:

	if (err == 0) {
		pm_runtime_disable(dev);
		pm_runtime_set_active(dev);
		pm_runtime_enable(dev);
	}

This lets the runtime-PM core know that following the system resume,
the device is back in the active state.  Without a corresponding way
to inform the block layer, the device will become unusable.  Requests
added to the queue will never be dispatched because the device still
appears to be suspended, and attempts to perform a runtime resume will
fail because the runtime-PM core knows the device is already active.
To make matters worse, any attempt to use the device will prevent it
from going back into runtime suspend, because now the request queue
will be non-empty.

This patch remedies the situation by adding a blk_runtime_activate()
function and calling it at the appropriate place in the
scsi_dev_type_resume() routine.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Reported-by: Ken Xue <Ken.Xue@amd.com>
Tested-by: Ken Xue <Ken.Xue@amd.com>
CC: <stable@vger.kernel.org>

---


[as1785]


 block/blk-core.c       |   19 +++++++++++++++++++
 drivers/scsi/scsi_pm.c |    4 +++-
 include/linux/blkdev.h |    2 ++
 3 files changed, 24 insertions(+), 1 deletion(-)

Index: usb-4.2/include/linux/blkdev.h
===================================================================
--- usb-4.2.orig/include/linux/blkdev.h
+++ usb-4.2/include/linux/blkdev.h
@@ -1017,6 +1017,7 @@ extern int blk_pre_runtime_suspend(struc
 extern void blk_post_runtime_suspend(struct request_queue *q, int err);
 extern void blk_pre_runtime_resume(struct request_queue *q);
 extern void blk_post_runtime_resume(struct request_queue *q, int err);
+extern void blk_runtime_activate(struct request_queue *q);
 #else
 static inline void blk_pm_runtime_init(struct request_queue *q,
 	struct device *dev) {}
@@ -1027,6 +1028,7 @@ static inline int blk_pre_runtime_suspen
 static inline void blk_post_runtime_suspend(struct request_queue *q, int err) {}
 static inline void blk_pre_runtime_resume(struct request_queue *q) {}
 static inline void blk_post_runtime_resume(struct request_queue *q, int err) {}
+static inline void blk_runtime_activate(struct request_queue *q) {}
 #endif
 
 /*
Index: usb-4.2/block/blk-core.c
===================================================================
--- usb-4.2.orig/block/blk-core.c
+++ usb-4.2/block/blk-core.c
@@ -3377,6 +3377,25 @@ void blk_post_runtime_resume(struct requ
 	spin_unlock_irq(q->queue_lock);
 }
 EXPORT_SYMBOL(blk_post_runtime_resume);
+
+/**
+ * blk_runtime_activate - Runtime activation processing
+ * @q: the queue of the device
+ *
+ * Description:
+ *	Tell the block layer that the device has changed directly to the
+ *	runtime-resumed state without executing any runtime-PM callbacks,
+ *	(for example, during system resume).  Does the same things as
+ *	blk_post_runtime_resume().
+ *
+ *	This function should be called after pm_runtime_set_active() and
+ *	pm_runtime_enable().
+ */
+void blk_runtime_activate(struct request_queue *q)
+{
+	blk_post_runtime_resume(q, 0);
+}
+EXPORT_SYMBOL(blk_runtime_activate);
 #endif
 
 int __init blk_dev_init(void)
Index: usb-4.2/drivers/scsi/scsi_pm.c
===================================================================
--- usb-4.2.orig/drivers/scsi/scsi_pm.c
+++ usb-4.2/drivers/scsi/scsi_pm.c
@@ -70,17 +70,19 @@ static int scsi_dev_type_suspend(struct
 static int scsi_dev_type_resume(struct device *dev,
 		int (*cb)(struct device *, const struct dev_pm_ops *))
 {
+	struct scsi_device *sdev = to_scsi_device(dev);
 	const struct dev_pm_ops *pm = dev->driver ? dev->driver->pm : NULL;
 	int err = 0;
 
 	err = cb(dev, pm);
-	scsi_device_resume(to_scsi_device(dev));
+	scsi_device_resume(sdev);
 	dev_dbg(dev, "scsi resume: %d\n", err);
 
 	if (err == 0) {
 		pm_runtime_disable(dev);
 		pm_runtime_set_active(dev);
 		pm_runtime_enable(dev);
+		blk_runtime_activate(sdev->request_queue);
 	}
 
 	return err;

