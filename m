From: Jianchao Wang <jianchao.w.wang@oracle.com>
Subject: [PATCH 1/5] blk-mq: prevent normal completion from entering a timeout request
Date: Wed, 20 Jun 2018 21:22:40 +0800
Message-ID: <1529500964-28429-2-git-send-email-jianchao.w.wang@oracle.com>
References: <1529500964-28429-1-git-send-email-jianchao.w.wang@oracle.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1529500964-28429-1-git-send-email-jianchao.w.wang@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: axboe@kernel.dk, hch@lst.de, martin.petersen@oracle.com, keith.busch@intel.com, josef@toxicpanda.com, ulf.hansson@linaro.org
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

scsi time out and error handler are based on an assumption that
normal completion mustn't do anything on an timeout request.
After 12f5b931 (blk-mq: Remove generation seqeunce), we lost this.
To regain it, introduce blk_mq_mark_rq_complete which change state
from IN-FLIGHT to COMPLETE atomically. It will be added to
blk_mq_complete_request and blk_mq_check_expired to avoid the race
between timeout and normal io completion path.

Because we have hand over the task to complete a timeout request to
LLDD timeout path by invoking blk_mq_complete_request, export
__blk_mq_complete_request for LLDD to complete the timeout request.

Signed-off-by: Jianchao Wang <jianchao.w.wang@oracle.com>
---
 block/blk-mq.c         | 22 +++++++++++++++-------
 include/linux/blk-mq.h |  1 +
 include/linux/blkdev.h |  6 ++++++
 3 files changed, 22 insertions(+), 7 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 70c65bb..a73acbd 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -473,6 +473,7 @@ static void __blk_mq_free_request(struct request *rq)
 	struct blk_mq_hw_ctx *hctx = blk_mq_map_queue(q, ctx->cpu);
 	const int sched_tag = rq->internal_tag;
 
+	WRITE_ONCE(rq->state, MQ_RQ_IDLE);
 	if (rq->tag != -1)
 		blk_mq_put_tag(hctx, hctx->tags, ctx, rq->tag);
 	if (sched_tag != -1)
@@ -509,7 +510,6 @@ void blk_mq_free_request(struct request *rq)
 	if (blk_rq_rl(rq))
 		blk_put_rl(blk_rq_rl(rq));
 
-	WRITE_ONCE(rq->state, MQ_RQ_IDLE);
 	if (refcount_dec_and_test(&rq->ref))
 		__blk_mq_free_request(rq);
 }
@@ -552,15 +552,17 @@ static void __blk_mq_complete_request_remote(void *data)
 	rq->q->softirq_done_fn(rq);
 }
 
-static void __blk_mq_complete_request(struct request *rq)
+/*
+ * The LLDD timeout path must invoke this interface to complete
+ * the request.
+ */
+void __blk_mq_complete_request(struct request *rq)
 {
 	struct blk_mq_ctx *ctx = rq->mq_ctx;
 	bool shared = false;
 	int cpu;
 
-	if (cmpxchg(&rq->state, MQ_RQ_IN_FLIGHT, MQ_RQ_COMPLETE) !=
-			MQ_RQ_IN_FLIGHT)
-		return;
+	WARN_ON(blk_mq_rq_state(rq) != MQ_RQ_COMPLETE);
 
 	if (rq->internal_tag != -1)
 		blk_mq_sched_completed_request(rq);
@@ -584,6 +586,7 @@ static void __blk_mq_complete_request(struct request *rq)
 	}
 	put_cpu();
 }
+EXPORT_SYMBOL(__blk_mq_complete_request);
 
 static void hctx_unlock(struct blk_mq_hw_ctx *hctx, int srcu_idx)
 	__releases(hctx->srcu)
@@ -617,7 +620,9 @@ void blk_mq_complete_request(struct request *rq)
 {
 	if (unlikely(blk_should_fake_timeout(rq->q)))
 		return;
-	__blk_mq_complete_request(rq);
+
+	if (blk_mq_mark_rq_complete(rq))
+		__blk_mq_complete_request(rq);
 }
 EXPORT_SYMBOL(blk_mq_complete_request);
 
@@ -783,6 +788,7 @@ static void blk_mq_rq_timed_out(struct request *req, bool reserved)
 
 	req->rq_flags &= ~RQF_TIMED_OUT;
 	blk_add_timer(req);
+	WRITE_ONCE(req->state, MQ_RQ_IN_FLIGHT);
 }
 
 static bool blk_mq_req_expired(struct request *rq, unsigned long *next)
@@ -835,8 +841,10 @@ static void blk_mq_check_expired(struct blk_mq_hw_ctx *hctx,
 	 * expired; if it is not expired, then the request was completed and
 	 * reallocated as a new request.
 	 */
-	if (blk_mq_req_expired(rq, next))
+	if (blk_mq_req_expired(rq, next) &&
+		blk_mq_mark_rq_complete(rq)) {
 		blk_mq_rq_timed_out(rq, reserved);
+	}
 	if (refcount_dec_and_test(&rq->ref))
 		__blk_mq_free_request(rq);
 }
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index e3147eb..0a509ae 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -259,6 +259,7 @@ void blk_mq_add_to_requeue_list(struct request *rq, bool at_head,
 void blk_mq_kick_requeue_list(struct request_queue *q);
 void blk_mq_delay_kick_requeue_list(struct request_queue *q, unsigned long msecs);
 void blk_mq_complete_request(struct request *rq);
+void __blk_mq_complete_request(struct request *rq);
 bool blk_mq_bio_list_merge(struct request_queue *q, struct list_head *list,
 			   struct bio *bio);
 bool blk_mq_queue_stopped(struct request_queue *q);
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 9154570..37511c4 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -272,6 +272,12 @@ struct request {
 #endif
 };
 
+static inline bool blk_mq_mark_rq_complete(struct request *rq)
+{
+	return (cmpxchg(&rq->state, MQ_RQ_IN_FLIGHT, MQ_RQ_COMPLETE) ==
+			MQ_RQ_IN_FLIGHT);
+}
+
 static inline bool blk_op_is_scsi(unsigned int op)
 {
 	return op == REQ_OP_SCSI_IN || op == REQ_OP_SCSI_OUT;
-- 
2.7.4
