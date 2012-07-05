From: Lin Ming <ming.m.lin@intel.com>
Subject: [PATCH v4 3/4] block: implement runtime pm strategy
Date: Thu,  5 Jul 2012 15:26:38 +0800
Message-ID: <1341473199-3837-4-git-send-email-ming.m.lin@intel.com>
References: <1341473199-3837-1-git-send-email-ming.m.lin@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1341473199-3837-1-git-send-email-ming.m.lin@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>, Alan Stern <stern@rowland.harvard.edu>, Shaohua Li <shli@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

When a request is added:
    If device is suspended or is suspending and the request is not a
    PM request, resume the device.

When a request finishes:
    Call pm_runtime_mark_last_busy().

When pick a request:
    If device is resuming/suspending, then only PM request is allowed to go.
    Return NULL for other cases.

Signed-off-by: Lin Ming <ming.m.lin@intel.com>
---

v4:
- Adds CONFIG_PM_RUNTIME check

 block/blk-core.c |   16 ++++++++++++++++
 block/elevator.c |   13 +++++++++++++
 2 files changed, 29 insertions(+)

diff --git a/block/blk-core.c b/block/blk-core.c
index b94ec5f..4720bec 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1225,6 +1225,11 @@ void __blk_put_request(struct request_queue *q, struct request *req)
 	if (unlikely(--req->ref_count))
 		return;
 
+#ifdef CONFIG_PM_RUNTIME
+	if (!(--q->nr_pending) && q->dev)
+		pm_runtime_mark_last_busy(q->dev);
+#endif
+
 	elv_completed_request(q, req);
 
 	/* this is a bio leak */
@@ -2013,6 +2018,17 @@ struct request *blk_peek_request(struct request_queue *q)
 	int ret;
 
 	while ((rq = __elv_next_request(q)) != NULL) {
+
+#ifdef CONFIG_PM_RUNTIME
+		if (q->rpm_status == RPM_SUSPENDED ||
+			(q->rpm_status != RPM_ACTIVE
+			    && !(rq->cmd_flags & REQ_PM))) {
+
+			rq = NULL;
+			break;
+		}
+#endif
+
 		if (!(rq->cmd_flags & REQ_STARTED)) {
 			/*
 			 * This is the first time the device driver
diff --git a/block/elevator.c b/block/elevator.c
index 6a55d41..9f82e77 100644
--- a/block/elevator.c
+++ b/block/elevator.c
@@ -34,6 +34,7 @@
 #include <linux/blktrace_api.h>
 #include <linux/hash.h>
 #include <linux/uaccess.h>
+#include <linux/pm_runtime.h>
 
 #include <trace/events/block.h>
 
@@ -536,6 +537,11 @@ void elv_requeue_request(struct request_queue *q, struct request *rq)
 
 	rq->cmd_flags &= ~REQ_STARTED;
 
+#ifdef CONFIG_PM_RUNTIME
+	/* __elv_add_request will increment the count */
+	if (!(rq->cmd_flags & REQ_PM))
+		q->nr_pending--;
+#endif
 	__elv_add_request(q, rq, ELEVATOR_INSERT_REQUEUE);
 }
 
@@ -558,6 +564,13 @@ void __elv_add_request(struct request_queue *q, struct request *rq, int where)
 {
 	trace_block_rq_insert(q, rq);
 
+#ifdef CONFIG_PM_RUNTIME
+	if (q->nr_pending++ == 0 && !(rq->cmd_flags & REQ_PM) &&
+		    (q->rpm_status == RPM_SUSPENDED ||
+		     q->rpm_status == RPM_SUSPENDING) && q->dev)
+		pm_request_resume(q->dev);
+#endif
+
 	rq->q = q;
 
 	if (rq->cmd_flags & REQ_SOFTBARRIER) {
-- 
1.7.10
