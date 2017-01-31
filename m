From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 03/10] mmc: remove pointless request type check in mmc_prep_request
Date: Tue, 31 Jan 2017 16:57:24 +0100
Message-ID: <1485878251-6107-4-git-send-email-hch@lst.de>
References: <1485878251-6107-1-git-send-email-hch@lst.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:58284 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751057AbdAaQTb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 31 Jan 2017 11:19:31 -0500
In-Reply-To: <1485878251-6107-1-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: axboe@kernel.dk
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org

The block layer won't send requests the driver isn't asking for,
so remove this check.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/mmc/core/queue.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/drivers/mmc/core/queue.c b/drivers/mmc/core/queue.c
index a6496d8..033f641 100644
--- a/drivers/mmc/core/queue.c
+++ b/drivers/mmc/core/queue.c
@@ -30,15 +30,6 @@ static int mmc_prep_request(struct request_queue *q, struct request *req)
 {
 	struct mmc_queue *mq = q->queuedata;
 
-	/*
-	 * We only like normal block requests and discards.
-	 */
-	if (req->cmd_type != REQ_TYPE_FS && req_op(req) != REQ_OP_DISCARD &&
-	    req_op(req) != REQ_OP_SECURE_ERASE) {
-		blk_dump_rq_flags(req, "MMC bad request");
-		return BLKPREP_KILL;
-	}
-
 	if (mq && (mmc_card_removed(mq->card) || mmc_access_rpmb(mq)))
 		return BLKPREP_KILL;
 
-- 
2.1.4

