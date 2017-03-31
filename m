From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 05/25] md: support REQ_OP_WRITE_ZEROES
Date: Fri, 31 Mar 2017 18:32:53 +0200
Message-ID: <20170331163313.31821-6-hch@lst.de>
References: <20170331163313.31821-1-hch@lst.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:38927 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933380AbdCaQdk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 31 Mar 2017 12:33:40 -0400
In-Reply-To: <20170331163313.31821-1-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: axboe@kernel.dk, martin.petersen@oracle.com, agk@redhat.com, snitzer@redhat.com, shli@kernel.org, philipp.reisner@linbit.com, lars.ellenberg@linbit.com
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, drbd-dev@lists.linbit.com, dm-devel@redhat.com, linux-raid@vger.kernel.org

Copy & paste from the REQ_OP_WRITE_SAME code.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/md/linear.c    | 1 +
 drivers/md/md.h        | 7 +++++++
 drivers/md/multipath.c | 1 +
 drivers/md/raid0.c     | 2 ++
 drivers/md/raid1.c     | 4 +++-
 drivers/md/raid10.c    | 1 +
 drivers/md/raid5.c     | 1 +
 7 files changed, 16 insertions(+), 1 deletion(-)

diff --git a/drivers/md/linear.c b/drivers/md/linear.c
index 3e38e0207a3e..377a8a3672e3 100644
--- a/drivers/md/linear.c
+++ b/drivers/md/linear.c
@@ -293,6 +293,7 @@ static void linear_make_request(struct mddev *mddev, struct bio *bio)
 						      split, disk_devt(mddev->gendisk),
 						      bio_sector);
 			mddev_check_writesame(mddev, split);
+			mddev_check_write_zeroes(mddev, split);
 			generic_make_request(split);
 		}
 	} while (split != bio);
diff --git a/drivers/md/md.h b/drivers/md/md.h
index dde8ecb760c8..1e76d64ce180 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -709,4 +709,11 @@ static inline void mddev_check_writesame(struct mddev *mddev, struct bio *bio)
 	    !bdev_get_queue(bio->bi_bdev)->limits.max_write_same_sectors)
 		mddev->queue->limits.max_write_same_sectors = 0;
 }
+
+static inline void mddev_check_write_zeroes(struct mddev *mddev, struct bio *bio)
+{
+	if (bio_op(bio) == REQ_OP_WRITE_ZEROES &&
+	    !bdev_get_queue(bio->bi_bdev)->limits.max_write_zeroes_sectors)
+		mddev->queue->limits.max_write_zeroes_sectors = 0;
+}
 #endif /* _MD_MD_H */
diff --git a/drivers/md/multipath.c b/drivers/md/multipath.c
index 79a12b59250b..e95d521d93e9 100644
--- a/drivers/md/multipath.c
+++ b/drivers/md/multipath.c
@@ -139,6 +139,7 @@ static void multipath_make_request(struct mddev *mddev, struct bio * bio)
 	mp_bh->bio.bi_end_io = multipath_end_request;
 	mp_bh->bio.bi_private = mp_bh;
 	mddev_check_writesame(mddev, &mp_bh->bio);
+	mddev_check_write_zeroes(mddev, &mp_bh->bio);
 	generic_make_request(&mp_bh->bio);
 	return;
 }
diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index 93347ca7c7a6..ce7a6a56cf73 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -383,6 +383,7 @@ static int raid0_run(struct mddev *mddev)
 
 		blk_queue_max_hw_sectors(mddev->queue, mddev->chunk_sectors);
 		blk_queue_max_write_same_sectors(mddev->queue, mddev->chunk_sectors);
+		blk_queue_max_write_zeroes_sectors(mddev->queue, mddev->chunk_sectors);
 		blk_queue_max_discard_sectors(mddev->queue, mddev->chunk_sectors);
 
 		blk_queue_io_min(mddev->queue, mddev->chunk_sectors << 9);
@@ -504,6 +505,7 @@ static void raid0_make_request(struct mddev *mddev, struct bio *bio)
 						      split, disk_devt(mddev->gendisk),
 						      bio_sector);
 			mddev_check_writesame(mddev, split);
+			mddev_check_write_zeroes(mddev, split);
 			generic_make_request(split);
 		}
 	} while (split != bio);
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index a34f58772022..b59cc100320a 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -3177,8 +3177,10 @@ static int raid1_run(struct mddev *mddev)
 	if (IS_ERR(conf))
 		return PTR_ERR(conf);
 
-	if (mddev->queue)
+	if (mddev->queue) {
 		blk_queue_max_write_same_sectors(mddev->queue, 0);
+		blk_queue_max_write_zeroes_sectors(mddev->queue, 0);
+	}
 
 	rdev_for_each(rdev, mddev) {
 		if (!mddev->gendisk)
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index e89a8d78a9ed..28ec3a93acee 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -3749,6 +3749,7 @@ static int raid10_run(struct mddev *mddev)
 		blk_queue_max_discard_sectors(mddev->queue,
 					      mddev->chunk_sectors);
 		blk_queue_max_write_same_sectors(mddev->queue, 0);
+		blk_queue_max_write_zeroes_sectors(mddev->queue, 0);
 		blk_queue_io_min(mddev->queue, chunk_size);
 		if (conf->geo.raid_disks % conf->geo.near_copies)
 			blk_queue_io_opt(mddev->queue, chunk_size * conf->geo.raid_disks);
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index ed5cd705b985..8cf1f86dcd05 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -7272,6 +7272,7 @@ static int raid5_run(struct mddev *mddev)
 		mddev->queue->limits.discard_zeroes_data = 0;
 
 		blk_queue_max_write_same_sectors(mddev->queue, 0);
+		blk_queue_max_write_zeroes_sectors(mddev->queue, 0);
 
 		rdev_for_each(rdev, mddev) {
 			disk_stack_limits(mddev->gendisk, rdev->bdev,
-- 
2.11.0
