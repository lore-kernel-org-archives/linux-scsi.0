From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 21/25] mmc: remove the discard_zeroes_data flag
Date: Fri, 31 Mar 2017 18:33:09 +0200
Message-ID: <20170331163313.31821-22-hch@lst.de>
References: <20170331163313.31821-1-hch@lst.de>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170331163313.31821-1-hch@lst.de>
Sender: linux-raid-owner@vger.kernel.org
To: axboe@kernel.dk, martin.petersen@oracle.com, agk@redhat.com, snitzer@redhat.com, shli@kernel.org, philipp.reisner@linbit.com, lars.ellenberg@linbit.com
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, drbd-dev@lists.linbit.com, dm-devel@redhat.com, linux-raid@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

mmc only supports discarding on large alignments, so the zeroing code
would always fall back to explicit writings of zeroes.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/mmc/core/queue.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/mmc/core/queue.c b/drivers/mmc/core/queue.c
index 493eb10ce580..4c54ad34e17a 100644
--- a/drivers/mmc/core/queue.c
+++ b/drivers/mmc/core/queue.c
@@ -167,8 +167,6 @@ static void mmc_queue_setup_discard(struct request_queue *q,
 
 	queue_flag_set_unlocked(QUEUE_FLAG_DISCARD, q);
 	blk_queue_max_discard_sectors(q, max_discard);
-	if (card->erased_byte == 0 && !mmc_can_discard(card))
-		q->limits.discard_zeroes_data = 1;
 	q->limits.discard_granularity = card->pref_erase << 9;
 	/* granularity must not be greater than max. discard */
 	if (card->pref_erase > max_discard)
-- 
2.11.0

