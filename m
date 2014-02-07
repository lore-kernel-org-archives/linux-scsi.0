From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 3/4] blk-mq: handle dma_drain_size
Date: Fri, 07 Feb 2014 10:22:38 -0800
Message-ID: <20140207182319.951261274@bombadil.infradead.org>
References: <20140207182235.659185141@bombadil.infradead.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline; filename=0003-blk-mq-handle-dma_drain_size.patch
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Make blk-mq handle the dma_drain_size field the same way as the old request
path.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-mq.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 40fc4dd..35800e1 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -561,6 +561,16 @@ static void __blk_mq_run_hw_queue(struct blk_mq_hw_ctx *hctx)
 		list_del_init(&rq->queuelist);
 		blk_mq_start_request(rq);
 
+		if (q->dma_drain_size && blk_rq_bytes(rq)) {
+			/*
+			 * make sure space for the drain appears we
+			 * know we can do this because max_hw_segments
+			 * has been adjusted to be one fewer than the
+			 * device can handle
+			 */
+			rq->nr_phys_segments++;
+		}
+
 		/*
 		 * Last request in the series. Flag it as such, this
 		 * enables drivers to know when IO should be kicked off,
-- 
1.7.10.4
