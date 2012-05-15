From: Lin Ming <ming.m.lin@intel.com>
Subject: [RFC PATCH 3/3] block: add queue idle timer
Date: Tue, 15 May 2012 16:48:17 +0800
Message-ID: <1337071697-30920-4-git-send-email-ming.m.lin@intel.com>
References: <1337071697-30920-1-git-send-email-ming.m.lin@intel.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:23506 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758355Ab2EOIsd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 15 May 2012 04:48:33 -0400
In-Reply-To: <1337071697-30920-1-git-send-email-ming.m.lin@intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>, Alan Stern <stern@rowland.harvard.edu>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org

Add an idle timer that is set to some suitable timeout and would be
added when the queue first goes empty. If nothing has happened during
the timeout interval, then the queue is suspended.

Queueing a new request could check the state and resume queue if it is
supended.

Signed-off-by: Lin Ming <ming.m.lin@intel.com>
---
 block/blk-core.c       |   25 +++++++++++++++++++++++++
 block/elevator.c       |   10 ++++++++++
 include/linux/blkdev.h |    3 +++
 3 files changed, 38 insertions(+), 0 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 1f61b74..01b4e14 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -473,6 +473,17 @@ struct request_queue *blk_alloc_queue(gfp_t gfp_mask)
 }
 EXPORT_SYMBOL(blk_alloc_queue);
 
+static void blk_rq_idle_timer(unsigned long data)
+{
+	struct request_queue *q = (struct request_queue *) data;
+	unsigned long flags;
+
+	spin_lock_irqsave(q->queue_lock, flags);
+	if (!q->nr_pending && q->runtime_pm)
+		q->runtime_pm(q, PMSG_SUSPEND);
+	spin_unlock_irqrestore(q->queue_lock, flags);
+}
+
 struct request_queue *blk_alloc_queue_node(gfp_t gfp_mask, int node_id)
 {
 	struct request_queue *q;
@@ -504,6 +515,7 @@ struct request_queue *blk_alloc_queue_node(gfp_t gfp_mask, int node_id)
 	setup_timer(&q->backing_dev_info.laptop_mode_wb_timer,
 		    laptop_mode_timer_fn, (unsigned long) q);
 	setup_timer(&q->timeout, blk_rq_timed_out_timer, (unsigned long) q);
+	setup_timer(&q->idle, blk_rq_idle_timer, (unsigned long) q);
 	INIT_LIST_HEAD(&q->timeout_list);
 	INIT_LIST_HEAD(&q->icq_list);
 	INIT_LIST_HEAD(&q->flush_queue[0]);
@@ -1129,6 +1141,13 @@ void __blk_put_request(struct request_queue *q, struct request *req)
 	if (unlikely(--req->ref_count))
 		return;
 
+	/* PM request is not accounted */
+	if (!(req->cmd_flags & REQ_PM)) {
+		if (!(--q->nr_pending))
+			/* Hard code to 20secs, will move to sysfs */
+			mod_timer(&q->idle, jiffies + 20*HZ);
+	}
+
 	elv_completed_request(q, req);
 
 	/* this is a bio leak */
@@ -1917,6 +1936,12 @@ struct request *blk_peek_request(struct request_queue *q)
 	int ret;
 
 	while ((rq = __elv_next_request(q)) != NULL) {
+		/* Only PM request is allowed to go if the queue is suspended */
+		if (q->pm_status != RPM_ACTIVE && !(rq->cmd_flags & REQ_PM)) {
+			rq = NULL;
+			break;
+		}
+
 		if (!(rq->cmd_flags & REQ_STARTED)) {
 			/*
 			 * This is the first time the device driver
diff --git a/block/elevator.c b/block/elevator.c
index f016855..7e68994 100644
--- a/block/elevator.c
+++ b/block/elevator.c
@@ -546,6 +546,9 @@ void elv_requeue_request(struct request_queue *q, struct request *rq)
 
 	rq->cmd_flags &= ~REQ_STARTED;
 
+	/* __elv_add_request will increment the count */
+	if (!(rq->cmd_flags & REQ_PM))
+		q->nr_pending--;
 	__elv_add_request(q, rq, ELEVATOR_INSERT_REQUEUE);
 }
 
@@ -587,6 +590,13 @@ void __elv_add_request(struct request_queue *q, struct request *rq, int where)
 {
 	trace_block_rq_insert(q, rq);
 
+	if (!(rq->cmd_flags & REQ_PM)) {
+		if (!(q->pm_status != RPM_ACTIVE) &&
+				q->nr_pending++ == 0 && q->runtime_pm)
+			/* async resume */
+			q->runtime_pm(q, PMSG_RESUME);
+	}
+
 	rq->q = q;
 
 	if (rq->cmd_flags & REQ_SOFTBARRIER) {
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index b5b212c..f6bc96b 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -347,6 +347,7 @@ struct request_queue {
 	unsigned int		nr_congestion_on;
 	unsigned int		nr_congestion_off;
 	unsigned int		nr_batching;
+	unsigned int		nr_pending;
 
 	int			pm_status;
 
@@ -365,6 +366,8 @@ struct request_queue {
 	struct timer_list	timeout;
 	struct list_head	timeout_list;
 
+	struct timer_list	idle;
+
 	struct list_head	icq_list;
 
 	struct queue_limits	limits;
-- 
1.7.2.5

