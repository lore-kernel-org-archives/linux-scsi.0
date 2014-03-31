From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 2/4] blk-mq: initialize request on allocation
Date: Mon, 31 Mar 2014 16:46:13 +0200
Message-ID: <1396277175-21382-3-git-send-email-hch@lst.de>
References: <1396277175-21382-1-git-send-email-hch@lst.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1396277175-21382-1-git-send-email-hch@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@fb.com>
Cc: Matias Bjorling <m@bjorling.me>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

If we want to share tag and request allocation between queues we cannot
initialize the request at init/free time, but need to initialize it
at allocation time as it might get used for different queues over its
lifetime.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-mq.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 871acd6..ec0c276 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -82,6 +82,7 @@ static struct request *__blk_mq_alloc_request(struct blk_mq_hw_ctx *hctx,
 	tag = blk_mq_get_tag(hctx->tags, gfp, reserved);
 	if (tag != BLK_MQ_TAG_FAIL) {
 		rq = hctx->rqs[tag];
+		blk_rq_init(hctx->queue, rq);
 		rq->tag = tag;
 
 		return rq;
@@ -254,9 +255,7 @@ static void __blk_mq_free_request(struct blk_mq_hw_ctx *hctx,
 	const int tag = rq->tag;
 	struct request_queue *q = rq->q;
 
-	blk_rq_init(hctx->queue, rq);
 	blk_mq_put_tag(hctx->tags, tag);
-
 	blk_mq_queue_exit(q);
 }
 
@@ -1128,7 +1127,6 @@ static int blk_mq_init_rq_map(struct blk_mq_hw_ctx *hctx,
 		left -= to_do * rq_size;
 		for (j = 0; j < to_do; j++) {
 			hctx->rqs[i] = p;
-			blk_rq_init(hctx->queue, hctx->rqs[i]);
 			p += rq_size;
 			i++;
 		}
-- 
1.7.10.4
