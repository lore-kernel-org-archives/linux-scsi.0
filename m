From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 18/25] brd: remove discard support
Date: Fri, 31 Mar 2017 18:33:06 +0200
Message-ID: <20170331163313.31821-19-hch@lst.de>
References: <20170331163313.31821-1-hch@lst.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:49999 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933291AbdCaQeK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 31 Mar 2017 12:34:10 -0400
In-Reply-To: <20170331163313.31821-1-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: axboe@kernel.dk, martin.petersen@oracle.com, agk@redhat.com, snitzer@redhat.com, shli@kernel.org, philipp.reisner@linbit.com, lars.ellenberg@linbit.com
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, drbd-dev@lists.linbit.com, dm-devel@redhat.com, linux-raid@vger.kernel.org

It's just a in-driver reimplementation of writing zeroes to the pages,
which fails if the discards aren't page aligned.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/block/brd.c | 54 -----------------------------------------------------
 1 file changed, 54 deletions(-)

diff --git a/drivers/block/brd.c b/drivers/block/brd.c
index 3adc32a3153b..4ec84d504780 100644
--- a/drivers/block/brd.c
+++ b/drivers/block/brd.c
@@ -134,28 +134,6 @@ static struct page *brd_insert_page(struct brd_device *brd, sector_t sector)
 	return page;
 }
 
-static void brd_free_page(struct brd_device *brd, sector_t sector)
-{
-	struct page *page;
-	pgoff_t idx;
-
-	spin_lock(&brd->brd_lock);
-	idx = sector >> PAGE_SECTORS_SHIFT;
-	page = radix_tree_delete(&brd->brd_pages, idx);
-	spin_unlock(&brd->brd_lock);
-	if (page)
-		__free_page(page);
-}
-
-static void brd_zero_page(struct brd_device *brd, sector_t sector)
-{
-	struct page *page;
-
-	page = brd_lookup_page(brd, sector);
-	if (page)
-		clear_highpage(page);
-}
-
 /*
  * Free all backing store pages and radix tree. This must only be called when
  * there are no other users of the device.
@@ -212,24 +190,6 @@ static int copy_to_brd_setup(struct brd_device *brd, sector_t sector, size_t n)
 	return 0;
 }
 
-static void discard_from_brd(struct brd_device *brd,
-			sector_t sector, size_t n)
-{
-	while (n >= PAGE_SIZE) {
-		/*
-		 * Don't want to actually discard pages here because
-		 * re-allocating the pages can result in writeback
-		 * deadlocks under heavy load.
-		 */
-		if (0)
-			brd_free_page(brd, sector);
-		else
-			brd_zero_page(brd, sector);
-		sector += PAGE_SIZE >> SECTOR_SHIFT;
-		n -= PAGE_SIZE;
-	}
-}
-
 /*
  * Copy n bytes from src to the brd starting at sector. Does not sleep.
  */
@@ -338,14 +298,6 @@ static blk_qc_t brd_make_request(struct request_queue *q, struct bio *bio)
 	if (bio_end_sector(bio) > get_capacity(bdev->bd_disk))
 		goto io_error;
 
-	if (unlikely(bio_op(bio) == REQ_OP_DISCARD)) {
-		if (sector & ((PAGE_SIZE >> SECTOR_SHIFT) - 1) ||
-		    bio->bi_iter.bi_size & ~PAGE_MASK)
-			goto io_error;
-		discard_from_brd(brd, sector, bio->bi_iter.bi_size);
-		goto out;
-	}
-
 	bio_for_each_segment(bvec, bio, iter) {
 		unsigned int len = bvec.bv_len;
 		int err;
@@ -357,7 +309,6 @@ static blk_qc_t brd_make_request(struct request_queue *q, struct bio *bio)
 		sector += len >> SECTOR_SHIFT;
 	}
 
-out:
 	bio_endio(bio);
 	return BLK_QC_T_NONE;
 io_error:
@@ -464,11 +415,6 @@ static struct brd_device *brd_alloc(int i)
 	 *  is harmless)
 	 */
 	blk_queue_physical_block_size(brd->brd_queue, PAGE_SIZE);
-
-	brd->brd_queue->limits.discard_granularity = PAGE_SIZE;
-	blk_queue_max_discard_sectors(brd->brd_queue, UINT_MAX);
-	brd->brd_queue->limits.discard_zeroes_data = 1;
-	queue_flag_set_unlocked(QUEUE_FLAG_DISCARD, brd->brd_queue);
 #ifdef CONFIG_BLK_DEV_RAM_DAX
 	queue_flag_set_unlocked(QUEUE_FLAG_DAX, brd->brd_queue);
 #endif
-- 
2.11.0
