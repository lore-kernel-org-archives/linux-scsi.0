From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 06/13] MD: Use new topology calls to indicate alignment and I/O sizes
Date: Fri, 15 May 2009 00:40:28 -0400
Message-ID: <1242362435-11953-7-git-send-email-martin.petersen@oracle.com>
References: <1242362435-11953-1-git-send-email-martin.petersen@oracle.com>
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1242362435-11953-1-git-send-email-martin.petersen@oracle.com>
Sender: linux-ide-owner@vger.kernel.org
To: rwheeler@redhat.com, snitzer@redhat.com, jeff@garzik.org, neilb@suse.de, James.Bottomley@hansenpartnership.com, jens.axboe@oracle.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
List-Id: linux-scsi@vger.kernel.org

From: Martin K. Petersen <martin.petersen@oracle.com>

Switch MD over to the new disk_stack_limits() function which checks for
aligment and adjusts preferred I/O sizes when stacking.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
---
 drivers/md/linear.c    |    3 +--
 drivers/md/multipath.c |    5 ++---
 drivers/md/raid0.c     |    8 ++++++--
 drivers/md/raid1.c     |    9 ++++-----
 drivers/md/raid10.c    |   13 ++++++++-----
 drivers/md/raid5.c     |   11 +++++++++++
 6 files changed, 32 insertions(+), 17 deletions(-)

diff --git a/drivers/md/linear.c b/drivers/md/linear.c
index 64f1f3e..cc92e07 100644
--- a/drivers/md/linear.c
+++ b/drivers/md/linear.c
@@ -138,9 +138,8 @@ static linear_conf_t *linear_conf(mddev_t *mddev, int raid_disks)
 		}
 
 		disk->rdev = rdev;
+		disk_stack_limits(mddev->gendisk, rdev->bdev, rdev->data_offset);
 
-		blk_queue_stack_limits(mddev->queue,
-				       rdev->bdev->bd_disk->queue);
 		/* as we don't honour merge_bvec_fn, we must never risk
 		 * violating it, so limit ->max_sector to one PAGE, as
 		 * a one page request is never in violation.
diff --git a/drivers/md/multipath.c b/drivers/md/multipath.c
index 4ee31aa..90e160d 100644
--- a/drivers/md/multipath.c
+++ b/drivers/md/multipath.c
@@ -294,7 +294,7 @@ static int multipath_add_disk(mddev_t *mddev, mdk_rdev_t *rdev)
 	for (path = first; path <= last; path++)
 		if ((p=conf->multipaths+path)->rdev == NULL) {
 			q = rdev->bdev->bd_disk->queue;
-			blk_queue_stack_limits(mddev->queue, q);
+			disk_stack_limits(mddev->gendisk, rdev->bdev, 0);
 
 		/* as we don't honour merge_bvec_fn, we must never risk
 		 * violating it, so limit ->max_sector to one PAGE, as
@@ -460,9 +460,8 @@ static int multipath_run (mddev_t *mddev)
 
 		disk = conf->multipaths + disk_idx;
 		disk->rdev = rdev;
+		disk_stack_limits(mddev->gendisk, rdev->bdev, 0);
 
-		blk_queue_stack_limits(mddev->queue,
-				       rdev->bdev->bd_disk->queue);
 		/* as we don't honour merge_bvec_fn, we must never risk
 		 * violating it, not that we ever expect a device with
 		 * a merge_bvec_fn to be involved in multipath */
diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index 925507e..02885fc 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -120,6 +120,10 @@ static int create_strip_zones (mddev_t *mddev)
 	zone = &conf->strip_zone[0];
 	cnt = 0;
 	smallest = NULL;
+
+	blk_queue_io_min(mddev->queue, mddev->chunk_size);
+	blk_queue_io_opt(mddev->queue, mddev->chunk_size * mddev->raid_disks);
+
 	zone->dev = conf->devlist;
 	list_for_each_entry(rdev1, &mddev->disks, same_set) {
 		int j = rdev1->raid_disk;
@@ -136,8 +140,8 @@ static int create_strip_zones (mddev_t *mddev)
 		}
 		zone->dev[j] = rdev1;
 
-		blk_queue_stack_limits(mddev->queue,
-				       rdev1->bdev->bd_disk->queue);
+		disk_stack_limits(mddev->gendisk, rdev1->bdev,
+				  rdev1->data_offset);
 		/* as we don't honour merge_bvec_fn, we must never risk
 		 * violating it, so limit ->max_sector to one PAGE, as
 		 * a one page request is never in violation.
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index e23758b..ac50039 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1123,8 +1123,8 @@ static int raid1_add_disk(mddev_t *mddev, mdk_rdev_t *rdev)
 	for (mirror = first; mirror <= last; mirror++)
 		if ( !(p=conf->mirrors+mirror)->rdev) {
 
-			blk_queue_stack_limits(mddev->queue,
-					       rdev->bdev->bd_disk->queue);
+			disk_stack_limits(mddev->gendisk, rdev->bdev,
+						 rdev->data_offset);
 			/* as we don't honour merge_bvec_fn, we must never risk
 			 * violating it, so limit ->max_sector to one PAGE, as
 			 * a one page request is never in violation.
@@ -1988,9 +1988,8 @@ static int run(mddev_t *mddev)
 		disk = conf->mirrors + disk_idx;
 
 		disk->rdev = rdev;
-
-		blk_queue_stack_limits(mddev->queue,
-				       rdev->bdev->bd_disk->queue);
+		disk_stack_limits(mddev->gendisk, rdev->bdev,
+				  rdev->data_offset);
 		/* as we don't honour merge_bvec_fn, we must never risk
 		 * violating it, so limit ->max_sector to one PAGE, as
 		 * a one page request is never in violation.
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 1a41aea..bf19876 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1151,8 +1151,8 @@ static int raid10_add_disk(mddev_t *mddev, mdk_rdev_t *rdev)
 	for ( ; mirror <= last ; mirror++)
 		if ( !(p=conf->mirrors+mirror)->rdev) {
 
-			blk_queue_stack_limits(mddev->queue,
-					       rdev->bdev->bd_disk->queue);
+			disk_stack_limits(mddev->gendisk, rdev->bdev,
+					  rdev->data_offset);
 			/* as we don't honour merge_bvec_fn, we must never risk
 			 * violating it, so limit ->max_sector to one PAGE, as
 			 * a one page request is never in violation.
@@ -2129,6 +2129,10 @@ static int run(mddev_t *mddev)
 	spin_lock_init(&conf->device_lock);
 	mddev->queue->queue_lock = &conf->device_lock;
 
+	blk_queue_io_min(mddev->queue, mddev->chunk_size);
+	blk_queue_io_opt(mddev->queue,
+			 (mddev->chunk_size * mddev->raid_disks) >> 1);
+
 	list_for_each_entry(rdev, &mddev->disks, same_set) {
 		disk_idx = rdev->raid_disk;
 		if (disk_idx >= mddev->raid_disks
@@ -2137,9 +2141,8 @@ static int run(mddev_t *mddev)
 		disk = conf->mirrors + disk_idx;
 
 		disk->rdev = rdev;
-
-		blk_queue_stack_limits(mddev->queue,
-				       rdev->bdev->bd_disk->queue);
+		disk_stack_limits(mddev->gendisk, rdev->bdev,
+				  rdev->data_offset);
 		/* as we don't honour merge_bvec_fn, we must never risk
 		 * violating it, so limit ->max_sector to one PAGE, as
 		 * a one page request is never in violation.
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 7970dc8..a389c11 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -4601,6 +4601,17 @@ static int run(mddev_t *mddev)
 	md_set_array_sectors(mddev, raid5_size(mddev, 0, 0));
 
 	blk_queue_merge_bvec(mddev->queue, raid5_mergeable_bvec);
+	blk_queue_io_min(mddev->queue, mddev->chunk_size);
+
+	if (mddev->level == 5)
+		blk_queue_io_opt(mddev->queue,
+				 mddev->chunk_size * (mddev->raid_disks - 1));
+	else
+		blk_queue_io_opt(mddev->queue,
+				 mddev->chunk_size * (mddev->raid_disks - 2));
+
+	list_for_each_entry(rdev, &mddev->disks, same_set)
+		disk_stack_limits(mddev->gendisk, rdev->bdev, rdev->data_offset);
 
 	return 0;
 abort:
-- 
1.6.0.6

