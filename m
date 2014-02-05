From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 04/15] blk-mq: handle dma_drain_size
Date: Wed, 05 Feb 2014 04:41:22 -0800
Message-ID: <20140205124152.867676966@bombadil.infradead.org>
References: <20140205124118.332902571@bombadil.infradead.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:53222 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751423AbaBEMly (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Feb 2014 07:41:54 -0500
Content-Disposition: inline; filename=0004-blk-mq-handle-dma_drain_size.patch
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>, James Bottomley <JBottomley@Parallels.com>, Nicholas Bellinger <nab@linux-iscsi.org>
Cc: linux-scsi@vger.kernel.org

Make blk-mq handle the dma_drain_size field the same way as the old request
path.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-mq.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 6838fe8..0b72927 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -560,6 +560,16 @@ static void __blk_mq_run_hw_queue(struct blk_mq_hw_ctx *hctx)
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


