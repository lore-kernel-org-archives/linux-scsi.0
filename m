From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 4/8] md: drop WRITE_SAME support
Date: Wed, 12 Apr 2017 10:48:05 +0200
Message-ID: <20170412084809.8245-5-hch@lst.de>
References: <20170412084809.8245-1-hch@lst.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:42276 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753627AbdDLIsZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 12 Apr 2017 04:48:25 -0400
In-Reply-To: <20170412084809.8245-1-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: axboe@kernel.dk, martin.petersen@oracle.com, philipp.reisner@linbit.com, lars.ellenberg@linbit.com, target-devel@vger.kernel.org
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, drbd-dev@lists.linbit.com, dm-devel@redhat.com

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/md/linear.c    | 1 -
 drivers/md/md.h        | 7 -------
 drivers/md/multipath.c | 1 -
 drivers/md/raid0.c     | 2 --
 drivers/md/raid1.c     | 4 +---
 drivers/md/raid10.c    | 1 -
 drivers/md/raid5.c     | 1 -
 7 files changed, 1 insertion(+), 16 deletions(-)

diff --git a/drivers/md/linear.c b/drivers/md/linear.c
index 377a8a3672e3..da363f5d54b0 100644
--- a/drivers/md/linear.c
+++ b/drivers/md/linear.c
@@ -292,7 +292,6 @@ static void linear_make_request(struct mddev *mddev, struct bio *bio)
 				trace_block_bio_remap(bdev_get_queue(split->bi_bdev),
 						      split, disk_devt(mddev->gendisk),
 						      bio_sector);
-			mddev_check_writesame(mddev, split);
 			mddev_check_write_zeroes(mddev, split);
 			generic_make_request(split);
 		}
diff --git a/drivers/md/md.h b/drivers/md/md.h
index 1e76d64ce180..d82b11b5ae5a 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -703,13 +703,6 @@ static inline void mddev_clear_unsupported_flags(struct mddev *mddev,
 	mddev->flags &= ~unsupported_flags;
 }
 
-static inline void mddev_check_writesame(struct mddev *mddev, struct bio *bio)
-{
-	if (bio_op(bio) == REQ_OP_WRITE_SAME &&
-	    !bdev_get_queue(bio->bi_bdev)->limits.max_write_same_sectors)
-		mddev->queue->limits.max_write_same_sectors = 0;
-}
-
 static inline void mddev_check_write_zeroes(struct mddev *mddev, struct bio *bio)
 {
 	if (bio_op(bio) == REQ_OP_WRITE_ZEROES &&
diff --git a/drivers/md/multipath.c b/drivers/md/multipath.c
index e95d521d93e9..68d67a404aab 100644
--- a/drivers/md/multipath.c
+++ b/drivers/md/multipath.c
@@ -138,7 +138,6 @@ static void multipath_make_request(struct mddev *mddev, struct bio * bio)
 	mp_bh->bio.bi_opf |= REQ_FAILFAST_TRANSPORT;
 	mp_bh->bio.bi_end_io = multipath_end_request;
 	mp_bh->bio.bi_private = mp_bh;
-	mddev_check_writesame(mddev, &mp_bh->bio);
 	mddev_check_write_zeroes(mddev, &mp_bh->bio);
 	generic_make_request(&mp_bh->bio);
 	return;
diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index ce7a6a56cf73..c094749c11e5 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -382,7 +382,6 @@ static int raid0_run(struct mddev *mddev)
 		bool discard_supported = false;
 
 		blk_queue_max_hw_sectors(mddev->queue, mddev->chunk_sectors);
-		blk_queue_max_write_same_sectors(mddev->queue, mddev->chunk_sectors);
 		blk_queue_max_write_zeroes_sectors(mddev->queue, mddev->chunk_sectors);
 		blk_queue_max_discard_sectors(mddev->queue, mddev->chunk_sectors);
 
@@ -504,7 +503,6 @@ static void raid0_make_request(struct mddev *mddev, struct bio *bio)
 				trace_block_bio_remap(bdev_get_queue(split->bi_bdev),
 						      split, disk_devt(mddev->gendisk),
 						      bio_sector);
-			mddev_check_writesame(mddev, split);
 			mddev_check_write_zeroes(mddev, split);
 			generic_make_request(split);
 		}
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index b59cc100320a..ac9ef686e625 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -3177,10 +3177,8 @@ static int raid1_run(struct mddev *mddev)
 	if (IS_ERR(conf))
 		return PTR_ERR(conf);
 
-	if (mddev->queue) {
-		blk_queue_max_write_same_sectors(mddev->queue, 0);
+	if (mddev->queue)
 		blk_queue_max_write_zeroes_sectors(mddev->queue, 0);
-	}
 
 	rdev_for_each(rdev, mddev) {
 		if (!mddev->gendisk)
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 28ec3a93acee..79988908f862 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -3748,7 +3748,6 @@ static int raid10_run(struct mddev *mddev)
 	if (mddev->queue) {
 		blk_queue_max_discard_sectors(mddev->queue,
 					      mddev->chunk_sectors);
-		blk_queue_max_write_same_sectors(mddev->queue, 0);
 		blk_queue_max_write_zeroes_sectors(mddev->queue, 0);
 		blk_queue_io_min(mddev->queue, chunk_size);
 		if (conf->geo.raid_disks % conf->geo.near_copies)
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 2efdb0d67460..04fd6a946825 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -7262,7 +7262,6 @@ static int raid5_run(struct mddev *mddev)
 		blk_queue_max_discard_sectors(mddev->queue,
 					      0xfffe * STRIPE_SECTORS);
 
-		blk_queue_max_write_same_sectors(mddev->queue, 0);
 		blk_queue_max_write_zeroes_sectors(mddev->queue, 0);
 
 		rdev_for_each(rdev, mddev) {
-- 
2.11.0
