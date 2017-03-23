From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 18/23] rsxx: remove the discard_zeroes_data flag
Date: Thu, 23 Mar 2017 10:33:36 -0400
Message-ID: <20170323143341.31549-19-hch@lst.de>
References: <20170323143341.31549-1-hch@lst.de>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170323143341.31549-1-hch@lst.de>
Sender: linux-block-owner@vger.kernel.org
To: axboe@kernel.dk, martin.petersen@oracle.com, agk@redhat.com, snitzer@redhat.com, shli@kernel.org, philipp.reisner@linbit.com, lars.ellenberg@linbit.com
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, drbd-dev@lists.linbit.com, dm-devel@redhat.com, linux-raid@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

rsxx only supports discarding on large alignments, so the zeroing code
would always fall back to explicit writings of zeroes.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/block/rsxx/dev.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/block/rsxx/dev.c b/drivers/block/rsxx/dev.c
index f81d70b39d10..9c566364ac9c 100644
--- a/drivers/block/rsxx/dev.c
+++ b/drivers/block/rsxx/dev.c
@@ -300,7 +300,6 @@ int rsxx_setup_dev(struct rsxx_cardinfo *card)
 						RSXX_HW_BLK_SIZE >> 9);
 		card->queue->limits.discard_granularity = RSXX_HW_BLK_SIZE;
 		card->queue->limits.discard_alignment   = RSXX_HW_BLK_SIZE;
-		card->queue->limits.discard_zeroes_data = 1;
 	}
 
 	card->queue->queuedata = card;
-- 
2.11.0
