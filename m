From: Bart Van Assche <bart.vanassche@wdc.com>
Subject: [PATCH v11 1/7] block: Make q_usage_counter also track legacy requests
Date: Mon, 30 Oct 2017 15:41:59 -0700
Message-ID: <20171030224205.25212-2-bart.vanassche@wdc.com>
References: <20171030224205.25212-1-bart.vanassche@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:25300 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752492AbdJ3WmJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 30 Oct 2017 18:42:09 -0400
In-Reply-To: <20171030224205.25212-1-bart.vanassche@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, "Martin K . Petersen" <martin.petersen@oracle.com>, Oleksandr Natalenko <oleksandr@natalenko.name>, Ming Lei <ming.lei@redhat.com>, Martin Steigerwald <martin@lichtvoll.de>, Bart Van Assche <bart.vanassche@wdc.com>

From: Ming Lei <ming.lei@redhat.com>

This patch makes it possible to pause request allocation for
the legacy block layer by calling blk_mq_freeze_queue() and
blk_mq_unfreeze_queue().

Signed-off-by: Ming Lei <ming.lei@redhat.com>
[ bvanassche: Combined two patches into one, edited a comment and made sure
  REQ_NOWAIT is handled properly in blk_old_get_request() ]
Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
Reviewed-by: Hannes Reinecke <hare@suse.com>
Tested-by: Martin Steigerwald <martin@lichtvoll.de>
Cc: Ming Lei <ming.lei@redhat.com>
---
 block/blk-core.c | 12 ++++++++++++
 block/blk-mq.c   | 10 ++--------
 2 files changed, 14 insertions(+), 8 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index bb4fce694a60..ec4eafb5af9f 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -611,6 +611,9 @@ void blk_set_queue_dying(struct request_queue *q)
 		}
 		spin_unlock_irq(q->queue_lock);
 	}
+
+	/* Make blk_queue_enter() reexamine the DYING flag. */
+	wake_up_all(&q->mq_freeze_wq);
 }
 EXPORT_SYMBOL_GPL(blk_set_queue_dying);
 
@@ -1397,16 +1400,22 @@ static struct request *blk_old_get_request(struct request_queue *q,
 					   unsigned int op, gfp_t gfp_mask)
 {
 	struct request *rq;
+	int ret = 0;
 
 	WARN_ON_ONCE(q->mq_ops);
 
 	/* create ioc upfront */
 	create_io_context(gfp_mask, q->node);
 
+	ret = blk_queue_enter(q, !(gfp_mask & __GFP_DIRECT_RECLAIM) ||
+			      (op & REQ_NOWAIT));
+	if (ret)
+		return ERR_PTR(ret);
 	spin_lock_irq(q->queue_lock);
 	rq = get_request(q, op, NULL, gfp_mask);
 	if (IS_ERR(rq)) {
 		spin_unlock_irq(q->queue_lock);
+		blk_queue_exit(q);
 		return rq;
 	}
 
@@ -1578,6 +1587,7 @@ void __blk_put_request(struct request_queue *q, struct request *req)
 		blk_free_request(rl, req);
 		freed_request(rl, sync, rq_flags);
 		blk_put_rl(rl);
+		blk_queue_exit(q);
 	}
 }
 EXPORT_SYMBOL_GPL(__blk_put_request);
@@ -1859,8 +1869,10 @@ static blk_qc_t blk_queue_bio(struct request_queue *q, struct bio *bio)
 	 * Grab a free request. This is might sleep but can not fail.
 	 * Returns with the queue unlocked.
 	 */
+	blk_queue_enter_live(q);
 	req = get_request(q, bio->bi_opf, bio, GFP_NOIO);
 	if (IS_ERR(req)) {
+		blk_queue_exit(q);
 		__wbt_done(q->rq_wb, wb_acct);
 		if (PTR_ERR(req) == -ENOMEM)
 			bio->bi_status = BLK_STS_RESOURCE;
diff --git a/block/blk-mq.c b/block/blk-mq.c
index 097ca3ece716..59b7de6b616b 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -125,7 +125,8 @@ void blk_freeze_queue_start(struct request_queue *q)
 	freeze_depth = atomic_inc_return(&q->mq_freeze_depth);
 	if (freeze_depth == 1) {
 		percpu_ref_kill(&q->q_usage_counter);
-		blk_mq_run_hw_queues(q, false);
+		if (q->mq_ops)
+			blk_mq_run_hw_queues(q, false);
 	}
 }
 EXPORT_SYMBOL_GPL(blk_freeze_queue_start);
@@ -255,13 +256,6 @@ void blk_mq_wake_waiters(struct request_queue *q)
 	queue_for_each_hw_ctx(q, hctx, i)
 		if (blk_mq_hw_queue_mapped(hctx))
 			blk_mq_tag_wakeup_all(hctx->tags, true);
-
-	/*
-	 * If we are called because the queue has now been marked as
-	 * dying, we need to ensure that processes currently waiting on
-	 * the queue are notified as well.
-	 */
-	wake_up_all(&q->mq_freeze_wq);
 }
 
 bool blk_mq_can_queue(struct blk_mq_hw_ctx *hctx)
-- 
2.14.2
