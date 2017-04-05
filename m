From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 16/27] zram: implement REQ_OP_WRITE_ZEROES
Date: Wed,  5 Apr 2017 16:21:54 +0200
Message-ID: <20170405142205.6477-17-hch@lst.de>
References: <20170405142205.6477-1-hch@lst.de>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170405142205.6477-1-hch@lst.de>
Sender: linux-block-owner@vger.kernel.org
To: axboe@kernel.dk, martin.petersen@oracle.com, agk@redhat.com, snitzer@redhat.com, shli@kernel.org, philipp.reisner@linbit.com, lars.ellenberg@linbit.com
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, drbd-dev@lists.linbit.com, dm-devel@redhat.com, linux-raid@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Just the same as discard if the block size equals the system page size.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Hannes Reinecke <hare@suse.com>
---
 drivers/block/zram/zram_drv.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index dceb5edd1e54..1710b06f04a7 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -829,10 +829,14 @@ static void __zram_make_request(struct zram *zram, struct bio *bio)
 	offset = (bio->bi_iter.bi_sector &
 		  (SECTORS_PER_PAGE - 1)) << SECTOR_SHIFT;
 
-	if (unlikely(bio_op(bio) == REQ_OP_DISCARD)) {
+	switch (bio_op(bio)) {
+	case REQ_OP_DISCARD:
+	case REQ_OP_WRITE_ZEROES:
 		zram_bio_discard(zram, index, offset, bio);
 		bio_endio(bio);
 		return;
+	default:
+		break;
 	}
 
 	bio_for_each_segment(bvec, bio, iter) {
@@ -1192,6 +1196,8 @@ static int zram_add(void)
 	zram->disk->queue->limits.max_sectors = SECTORS_PER_PAGE;
 	zram->disk->queue->limits.chunk_sectors = 0;
 	blk_queue_max_discard_sectors(zram->disk->queue, UINT_MAX);
+	queue_flag_set_unlocked(QUEUE_FLAG_DISCARD, zram->disk->queue);
+
 	/*
 	 * zram_bio_discard() will clear all logical blocks if logical block
 	 * size is identical with physical block size(PAGE_SIZE). But if it is
@@ -1201,10 +1207,7 @@ static int zram_add(void)
 	 * zeroed.
 	 */
 	if (ZRAM_LOGICAL_BLOCK_SIZE == PAGE_SIZE)
-		zram->disk->queue->limits.discard_zeroes_data = 1;
-	else
-		zram->disk->queue->limits.discard_zeroes_data = 0;
-	queue_flag_set_unlocked(QUEUE_FLAG_DISCARD, zram->disk->queue);
+		blk_queue_max_write_zeroes_sectors(zram->disk->queue, UINT_MAX);
 
 	add_disk(zram->disk);
 
-- 
2.11.0
