From: Ming Lei <ming.lei@redhat.com>
Subject: [PATCH V2 5/8] block: tracking request allocation with q_usage_counter
Date: Sat,  2 Sep 2017 02:49:55 +0800
Message-ID: <20170901184958.19452-7-ming.lei@redhat.com>
References: <20170901184958.19452-1-ming.lei@redhat.com>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170901184958.19452-1-ming.lei@redhat.com>
Sender: linux-block-owner@vger.kernel.org
To: Jens Axboe <axboe@fb.com>, linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Bart Van Assche <bart.vanassche@sandisk.com>, linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc: Oleksandr Natalenko <oleksandr@natalenko.name>, Johannes Thumshirn <jthumshirn@suse.de>, Tejun Heo <tj@kernel.org>, Ming Lei <ming.lei@redhat.com>
List-Id: linux-scsi@vger.kernel.org

This usage is basically same with blk-mq, so that we can
support to freeze queue easily.

Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 block/blk-core.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/block/blk-core.c b/block/blk-core.c
index ce2d3b6f6c62..85b15833a7a5 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1405,16 +1405,21 @@ static struct request *blk_old_get_request(struct request_queue *q,
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
 
@@ -1586,6 +1591,7 @@ void __blk_put_request(struct request_queue *q, struct request *req)
 		blk_free_request(rl, req);
 		freed_request(rl, sync, rq_flags);
 		blk_put_rl(rl);
+		blk_queue_exit(q);
 	}
 }
 EXPORT_SYMBOL_GPL(__blk_put_request);
@@ -1867,8 +1873,10 @@ static blk_qc_t blk_queue_bio(struct request_queue *q, struct bio *bio)
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
-- 
2.9.5
