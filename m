From: Ming Lei <ming.lei@redhat.com>
Subject: [PATCH V4 02/10] block: tracking request allocation with q_usage_counter
Date: Mon, 11 Sep 2017 19:10:13 +0800
Message-ID: <20170911111021.25810-3-ming.lei@redhat.com>
References: <20170911111021.25810-1-ming.lei@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58544 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751351AbdIKLLU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 11 Sep 2017 07:11:20 -0400
In-Reply-To: <20170911111021.25810-1-ming.lei@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@fb.com>, linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc: Bart Van Assche <bart.vanassche@sandisk.com>, Oleksandr Natalenko <oleksandr@natalenko.name>, Johannes Thumshirn <jthumshirn@suse.de>, Cathy Avery <cavery@redhat.com>, Ming Lei <ming.lei@redhat.com>

This usage is basically same with blk-mq, so that we can
support to freeze legacy queue easily.

Also 'wake_up_all(&q->mq_freeze_wq)' has to be moved
into blk_set_queue_dying() since both legacy and blk-mq
may wait on the wait queue of .mq_freeze_wq.

Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 block/blk-core.c | 14 ++++++++++++++
 block/blk-mq.c   |  7 -------
 2 files changed, 14 insertions(+), 7 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index d709c0e3a2ac..7e436ee04e08 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -610,6 +610,12 @@ void blk_set_queue_dying(struct request_queue *q)
 		}
 		spin_unlock_irq(q->queue_lock);
 	}
+
+	/*
+	 * We need to ensure that processes currently waiting on
+	 * the queue are notified as well.
+	 */
+	wake_up_all(&q->mq_freeze_wq);
 }
 EXPORT_SYMBOL_GPL(blk_set_queue_dying);
 
@@ -1392,16 +1398,21 @@ static struct request *blk_old_get_request(struct request_queue *q,
 					   unsigned int op, gfp_t gfp_mask)
 {
 	struct request *rq;
+	int ret = 0;
 
 	WARN_ON_ONCE(q->mq_ops);
 
 	/* create ioc upfront */
 	create_io_context(gfp_mask, q->node);
 
+	ret = blk_queue_enter(q, !(gfp_mask & __GFP_DIRECT_RECLAIM));
+	if (ret)
+		return ERR_PTR(ret);
 	spin_lock_irq(q->queue_lock);
 	rq = get_request(q, op, NULL, gfp_mask);
 	if (IS_ERR(rq)) {
 		spin_unlock_irq(q->queue_lock);
+		blk_queue_exit(q);
 		return rq;
 	}
 
@@ -1573,6 +1584,7 @@ void __blk_put_request(struct request_queue *q, struct request *req)
 		blk_free_request(rl, req);
 		freed_request(rl, sync, rq_flags);
 		blk_put_rl(rl);
+		blk_queue_exit(q);
 	}
 }
 EXPORT_SYMBOL_GPL(__blk_put_request);
@@ -1854,8 +1866,10 @@ static blk_qc_t blk_queue_bio(struct request_queue *q, struct bio *bio)
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
index 9c364497cc44..eee86adc0f53 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -256,13 +256,6 @@ void blk_mq_wake_waiters(struct request_queue *q)
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
2.9.5
