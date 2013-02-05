From: Aaron Lu <aaron.lu@intel.com>
Subject: [PATCH v9 2/4] block: add runtime pm helpers
Date: Tue,  5 Feb 2013 16:03:14 +0800
Message-ID: <1360051396-3080-3-git-send-email-aaron.lu@intel.com>
References: <1360051396-3080-1-git-send-email-aaron.lu@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1360051396-3080-1-git-send-email-aaron.lu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>, Jens Axboe <axboe@kernel.dk>, "Rafael J. Wysocki" <rjw@sisk.pl>, James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, Aaron Lu <aaron.lwe@gmail.com>, Aaron Lu <aaron.lu@intel.com>, Shane Huang <shane.huang@amd.com>
List-Id: linux-scsi@vger.kernel.org

From: Lin Ming <ming.m.lin@intel.com>

Add runtime pm helper functions:

void blk_pm_runtime_init(struct request_queue *q, struct device *dev)
  - Initialization function for drivers to call.

int blk_pre_runtime_suspend(struct request_queue *q)
  - If any requests are in the queue, mark last busy and return -EBUSY.
    Otherwise set q->rpm_status to RPM_SUSPENDING and return 0.

void blk_post_runtime_suspend(struct request_queue *q, int err)
  - If the suspend succeeded then set q->rpm_status to RPM_SUSPENDED.
    Otherwise set it to RPM_ACTIVE and mark last busy.

void blk_pre_runtime_resume(struct request_queue *q)
  - Set q->rpm_status to RPM_RESUMING.

void blk_post_runtime_resume(struct request_queue *q, int err)
  - If the resume succeeded then set q->rpm_status to RPM_ACTIVE
    and call __blk_run_queue, then mark last busy and autosuspend.
    Otherwise set q->rpm_status to RPM_SUSPENDED.

Signed-off-by: Lin Ming <ming.m.lin@intel.com>
Signed-off-by: Aaron Lu <aaron.lu@intel.com>
---
 block/blk-core.c       | 144 +++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/blkdev.h |  27 ++++++++++
 2 files changed, 171 insertions(+)

diff --git a/block/blk-core.c b/block/blk-core.c
index 66d3168..ce7d366 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -30,6 +30,7 @@
 #include <linux/list_sort.h>
 #include <linux/delay.h>
 #include <linux/ratelimit.h>
+#include <linux/pm_runtime.h>
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/block.h>
@@ -3043,6 +3044,149 @@ void blk_finish_plug(struct blk_plug *plug)
 }
 EXPORT_SYMBOL(blk_finish_plug);
 
+#ifdef CONFIG_PM_RUNTIME
+/**
+ * blk_pm_runtime_init - Block layer runtime PM initialization routine
+ * @q: the queue of the device
+ * @dev: the device the queue belongs to
+ *
+ * Description:
+ *    Initialize runtime-PM-related fields for @q and start auto suspend for
+ *    @dev. Drivers that want to take advantage of request-based runtime PM
+ *    should call this function after @dev has been initialized, and its
+ *    request queue @q has been allocated, and runtime PM for it can not happen
+ *    yet(either due to disabled/forbidden or its usage_count > 0). In most
+ *    cases, driver should call this function before any I/O has taken place.
+ *
+ *    This function takes care of setting up using auto suspend for the device,
+ *    the autosuspend delay is set to -1 to make runtime suspend impossible
+ *    until an updated value is either set by user or by driver. Drivers do
+ *    not need to touch other autosuspend settings.
+ *
+ *    The block layer runtime PM is request based, so only works for drivers
+ *    that use request as their IO unit instead of those directly use bio's.
+ */
+void blk_pm_runtime_init(struct request_queue *q, struct device *dev)
+{
+	q->dev = dev;
+	q->rpm_status = RPM_ACTIVE;
+	pm_runtime_set_autosuspend_delay(q->dev, -1);
+	pm_runtime_use_autosuspend(q->dev);
+}
+EXPORT_SYMBOL(blk_pm_runtime_init);
+
+/**
+ * blk_pre_runtime_suspend - Pre runtime suspend check
+ * @q: the queue of the device
+ *
+ * Description:
+ *    This function will check if runtime suspend is allowed for the device
+ *    by examining if there are any requests pending in the queue. If there
+ *    are requests pending, the device can not be runtime suspended; otherwise,
+ *    the queue's status will be updated to SUSPENDING and the driver can
+ *    proceed to suspend the device.
+ *
+ *    For the not allowed case, we mark last busy for the device so that
+ *    runtime PM core will try to autosuspend it some time later.
+ *
+ *    This function should be called near the start of the device's
+ *    runtime_suspend callback.
+ *
+ * Return:
+ *    0		- OK to runtime suspend the device
+ *    -EBUSY	- Device should not be runtime suspended
+ */
+int blk_pre_runtime_suspend(struct request_queue *q)
+{
+	int ret = 0;
+
+	spin_lock_irq(q->queue_lock);
+	if (q->nr_pending) {
+		ret = -EBUSY;
+		pm_runtime_mark_last_busy(q->dev);
+	} else {
+		q->rpm_status = RPM_SUSPENDING;
+	}
+	spin_unlock_irq(q->queue_lock);
+	return ret;
+}
+EXPORT_SYMBOL(blk_pre_runtime_suspend);
+
+/**
+ * blk_post_runtime_suspend - Post runtime suspend processing
+ * @q: the queue of the device
+ * @err: return value of the device's runtime_suspend function
+ *
+ * Description:
+ *    Update the queue's runtime status according to the return value of the
+ *    device's runtime suspend function and mark last busy for the device so
+ *    that PM core will try to auto suspend the device at a later time.
+ *
+ *    This function should be called near the end of the device's
+ *    runtime_suspend callback.
+ */
+void blk_post_runtime_suspend(struct request_queue *q, int err)
+{
+	spin_lock_irq(q->queue_lock);
+	if (!err) {
+		q->rpm_status = RPM_SUSPENDED;
+	} else {
+		q->rpm_status = RPM_ACTIVE;
+		pm_runtime_mark_last_busy(q->dev);
+	}
+	spin_unlock_irq(q->queue_lock);
+}
+EXPORT_SYMBOL(blk_post_runtime_suspend);
+
+/**
+ * blk_pre_runtime_resume - Pre runtime resume processing
+ * @q: the queue of the device
+ *
+ * Description:
+ *    Update the queue's runtime status to RESUMING in preparation for the
+ *    runtime resume of the device.
+ *
+ *    This function should be called near the start of the device's
+ *    runtime_resume callback.
+ */
+void blk_pre_runtime_resume(struct request_queue *q)
+{
+	spin_lock_irq(q->queue_lock);
+	q->rpm_status = RPM_RESUMING;
+	spin_unlock_irq(q->queue_lock);
+}
+EXPORT_SYMBOL(blk_pre_runtime_resume);
+
+/**
+ * blk_post_runtime_resume - Post runtime resume processing
+ * @q: the queue of the device
+ * @err: return value of the device's runtime_resume function
+ *
+ * Description:
+ *    Update the queue's runtime status according to the return value of the
+ *    device's runtime_resume function. If it is successfully resumed, process
+ *    the requests that are queued into the device's queue when it is resuming
+ *    and then mark last busy and initiate autosuspend for it.
+ *
+ *    This function should be called near the end of the device's
+ *    runtime_resume callback.
+ */
+void blk_post_runtime_resume(struct request_queue *q, int err)
+{
+	spin_lock_irq(q->queue_lock);
+	if (!err) {
+		q->rpm_status = RPM_ACTIVE;
+		__blk_run_queue(q);
+		pm_runtime_mark_last_busy(q->dev);
+		pm_runtime_autosuspend(q->dev);
+	} else {
+		q->rpm_status = RPM_SUSPENDED;
+	}
+	spin_unlock_irq(q->queue_lock);
+}
+EXPORT_SYMBOL(blk_post_runtime_resume);
+#endif
+
 int __init blk_dev_init(void)
 {
 	BUILD_BUG_ON(__REQ_NR_BITS > 8 *
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 78feda9..89d89c7 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -361,6 +361,12 @@ struct request_queue {
 	 */
 	struct kobject kobj;
 
+#ifdef CONFIG_PM_RUNTIME
+	struct device		*dev;
+	int			rpm_status;
+	unsigned int		nr_pending;
+#endif
+
 	/*
 	 * queue settings
 	 */
@@ -961,6 +967,27 @@ struct request_queue *blk_alloc_queue_node(gfp_t, int);
 extern void blk_put_queue(struct request_queue *);
 
 /*
+ * block layer runtime pm functions
+ */
+#ifdef CONFIG_PM_RUNTIME
+extern void blk_pm_runtime_init(struct request_queue *q, struct device *dev);
+extern int blk_pre_runtime_suspend(struct request_queue *q);
+extern void blk_post_runtime_suspend(struct request_queue *q, int err);
+extern void blk_pre_runtime_resume(struct request_queue *q);
+extern void blk_post_runtime_resume(struct request_queue *q, int err);
+#else
+static inline void blk_pm_runtime_init(struct request_queue *q,
+	struct device *dev) {}
+static inline int blk_pre_runtime_suspend(struct request_queue *q)
+{
+	return -ENOSYS;
+}
+static inline void blk_post_runtime_suspend(struct request_queue *q, int err) {}
+static inline void blk_pre_runtime_resume(struct request_queue *q) {}
+static inline void blk_post_runtime_resume(struct request_queue *q, int err) {}
+#endif
+
+/*
  * blk_plug permits building a queue of related requests by holding the I/O
  * fragments for a short period. This allows merging of sequential requests
  * into single larger request. As the requests are moved from a per-task list to
-- 
1.8.1
