From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 4/4] blk-mq: initialize sg_reserved_size
Date: Fri, 07 Feb 2014 10:22:39 -0800
Message-ID: <20140207182320.061227817@bombadil.infradead.org>
References: <20140207182235.659185141@bombadil.infradead.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline; filename=0004-blk-mq-initialize-sg_reserved_size.patch
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

To behave the same way as the old request path.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-mq.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 35800e1..f5fcd9a 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -1373,6 +1373,8 @@ struct request_queue *blk_mq_init_queue(struct blk_mq_reg *reg,
 	q->mq_ops = reg->ops;
 	q->queue_flags |= QUEUE_FLAG_MQ_DEFAULT;
 
+	q->sg_reserved_size = INT_MAX;
+
 	blk_queue_make_request(q, blk_mq_make_request);
 	blk_queue_rq_timed_out(q, reg->ops->timeout);
 	if (reg->timeout)
-- 
1.7.10.4
