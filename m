From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 04/10] ms_block: remove pointless prep_fn
Date: Tue, 31 Jan 2017 16:57:25 +0100
Message-ID: <1485878251-6107-5-git-send-email-hch@lst.de>
References: <1485878251-6107-1-git-send-email-hch@lst.de>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <1485878251-6107-1-git-send-email-hch@lst.de>
Sender: linux-block-owner@vger.kernel.org
To: axboe@kernel.dk
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

This driver will never see non-fs requests, and doesn't do anything
else in the prep_fn.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/memstick/core/ms_block.c | 11 -----------
 1 file changed, 11 deletions(-)

diff --git a/drivers/memstick/core/ms_block.c b/drivers/memstick/core/ms_block.c
index f3512404..99e651c 100644
--- a/drivers/memstick/core/ms_block.c
+++ b/drivers/memstick/core/ms_block.c
@@ -2000,16 +2000,6 @@ static int msb_bd_getgeo(struct block_device *bdev,
 	return 0;
 }
 
-static int msb_prepare_req(struct request_queue *q, struct request *req)
-{
-	if (req->cmd_type != REQ_TYPE_FS) {
-		blk_dump_rq_flags(req, "MS unsupported request");
-		return BLKPREP_KILL;
-	}
-	req->rq_flags |= RQF_DONTPREP;
-	return BLKPREP_OK;
-}
-
 static void msb_submit_req(struct request_queue *q)
 {
 	struct memstick_dev *card = q->queuedata;
@@ -2132,7 +2122,6 @@ static int msb_init_disk(struct memstick_dev *card)
 	}
 
 	msb->queue->queuedata = card;
-	blk_queue_prep_rq(msb->queue, msb_prepare_req);
 
 	blk_queue_bounce_limit(msb->queue, limit);
 	blk_queue_max_hw_sectors(msb->queue, MS_BLOCK_MAX_PAGES);
-- 
2.1.4

