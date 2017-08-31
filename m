From: Ming Lei <ming.lei@redhat.com>
Subject: [PATCH 7/9] block: tracking request allocation with q_usage_counter
Date: Fri,  1 Sep 2017 01:27:26 +0800
Message-ID: <20170831172728.15817-8-ming.lei@redhat.com>
References: <20170831172728.15817-1-ming.lei@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40204 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751566AbdHaR3Y (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 31 Aug 2017 13:29:24 -0400
In-Reply-To: <20170831172728.15817-1-ming.lei@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@fb.com>, linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Bart Van Assche <bart.vanassche@sandisk.com>, linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc: Oleksandr Natalenko <oleksandr@natalenko.name>, Ming Lei <ming.lei@redhat.com>

This usage is basically same with blk-mq, so that we can
support to freeze queue easily.

Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 block/blk-core.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/block/blk-core.c b/block/blk-core.c
index 7a9f93889669..a84672f4db32 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1406,16 +1406,21 @@ static struct request *blk_old_get_request(struct request_queue *q,
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
 
@@ -1587,6 +1592,7 @@ void __blk_put_request(struct request_queue *q, struct request *req)
 		blk_free_request(rl, req);
 		freed_request(rl, sync, rq_flags);
 		blk_put_rl(rl);
+		blk_queue_exit(q);
 	}
 }
 EXPORT_SYMBOL_GPL(__blk_put_request);
@@ -1868,8 +1874,10 @@ static blk_qc_t blk_queue_bio(struct request_queue *q, struct bio *bio)
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
