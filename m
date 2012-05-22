From: Lin Ming <ming.m.lin@intel.com>
Subject: [RFC PATCH v3 2/4] block: add runtime pm helpers
Date: Tue, 22 May 2012 15:21:30 +0800
Message-ID: <1337671292-15583-3-git-send-email-ming.m.lin@intel.com>
References: <1337671292-15583-1-git-send-email-ming.m.lin@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1337671292-15583-1-git-send-email-ming.m.lin@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>, Alan Stern <stern@rowland.harvard.edu>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Add runtime pm helper functions:

blk_pm_runtime_init()
blk_pre_runtime_suspend()
blk_post_runtime_suspend()
blk_pre_runtime_resume()
blk_post_runtime_suspend()

Signed-off-by: Lin Ming <ming.m.lin@intel.com>
---
 block/blk-core.c       |   61 ++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/blkdev.h |   13 ++++++++++
 2 files changed, 74 insertions(+), 0 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 1f61b74..2d8e38e 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -29,6 +29,7 @@
 #include <linux/fault-inject.h>
 #include <linux/list_sort.h>
 #include <linux/delay.h>
+#include <linux/pm_runtime.h>
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/block.h>
@@ -2887,6 +2888,66 @@ void blk_finish_plug(struct blk_plug *plug)
 }
 EXPORT_SYMBOL(blk_finish_plug);
 
+void blk_pm_runtime_init(struct request_queue *q, struct device *dev)
+{
+	q->dev = dev;
+	q->rpm_status = RPM_ACTIVE;
+
+	pm_runtime_use_autosuspend(q->dev);
+	pm_runtime_mark_last_busy(q->dev);
+	pm_runtime_autosuspend(q->dev);
+}
+EXPORT_SYMBOL(blk_pm_runtime_init);
+
+int blk_pre_runtime_suspend(struct request_queue *q)
+{
+	int ret = 0;
+
+	spin_lock_irq(q->queue_lock);
+	if (q->nr_pending)
+		ret = -EBUSY;
+	else
+		q->rpm_status = RPM_SUSPENDING;
+	spin_unlock_irq(q->queue_lock);
+	return ret;
+}
+EXPORT_SYMBOL(blk_pre_runtime_suspend);
+
+void blk_post_runtime_suspend(struct request_queue *q, int err)
+{
+	spin_lock_irq(q->queue_lock);
+	if (!err)
+		q->rpm_status = RPM_SUSPENDED;
+	else {
+		q->rpm_status = RPM_ACTIVE;
+		pm_runtime_mark_last_busy(q->dev);
+	}
+	spin_unlock_irq(q->queue_lock);
+}
+EXPORT_SYMBOL(blk_post_runtime_suspend);
+
+void blk_pre_runtime_resume(struct request_queue *q)
+{
+	spin_lock_irq(q->queue_lock);
+	q->rpm_status = RPM_RESUMING;
+	spin_unlock_irq(q->queue_lock);
+}
+EXPORT_SYMBOL(blk_pre_runtime_resume);
+
+void blk_post_runtime_resume(struct request_queue *q, int err)
+{
+	spin_lock_irq(q->queue_lock);
+	if (!err) {
+		q->rpm_status = RPM_ACTIVE;
+		__blk_run_queue(q);
+		pm_runtime_mark_last_busy(q->dev);
+		pm_request_autosuspend(q->dev);
+	} else
+		q->rpm_status = RPM_SUSPENDED;
+	spin_unlock_irq(q->queue_lock);
+}
+EXPORT_SYMBOL(blk_post_runtime_resume);
+
 int __init blk_dev_init(void)
 {
 	BUILD_BUG_ON(__REQ_NR_BITS > 8 *
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 4d4ac24..cb0c4fc 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -339,6 +339,9 @@ struct request_queue {
 	 */
 	struct kobject kobj;
 
+	struct device		*dev;
+	int			rpm_status;
+
 	/*
 	 * queue settings
 	 */
@@ -346,6 +349,7 @@ struct request_queue {
 	unsigned int		nr_congestion_on;
 	unsigned int		nr_congestion_off;
 	unsigned int		nr_batching;
+	unsigned int		nr_pending;
 
 	unsigned int		dma_drain_size;
 	void			*dma_drain_buffer;
@@ -875,6 +879,15 @@ struct request_queue *blk_alloc_queue_node(gfp_t, int);
 extern void blk_put_queue(struct request_queue *);
 
 /*
+ * block layer runtime pm functions
+ */
+extern void blk_pm_runtime_init(struct request_queue *q, struct device *dev);
+extern int blk_pre_runtime_suspend(struct request_queue *q);
+extern void blk_post_runtime_suspend(struct request_queue *q, int err);
+extern void blk_pre_runtime_resume(struct request_queue *q);
+extern void blk_post_runtime_resume(struct request_queue *q, int err);
+
+/*
  * blk_plug permits building a queue of related requests by holding the I/O
  * fragments for a short period. This allows merging of sequential requests
  * into single larger request. As the requests are moved from a per-task list to
-- 
1.7.2.5
