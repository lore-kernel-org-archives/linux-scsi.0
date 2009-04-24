From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 3 of 9] MD: Use new topology calls to indicate alignment and
	I/O sizes
Date: Fri, 24 Apr 2009 01:32:24 -0400
Message-ID: <f737aa805b2b269a6269.1240551144@sermon.lab.mkp.net>
References: <patchbomb.1240551141@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from jaguar.mkp.net ([192.139.46.146]:42223 "EHLO jaguar.mkp.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752659AbZDXFgK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 24 Apr 2009 01:36:10 -0400
In-Reply-To: <patchbomb.1240551141@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: rwheeler@redhat.com, snitzer@redhat.com, jeff@garzik.org, neilb@suse.de, James.Bottomley@hansenpartnership.com, dgilbert@interlog.com, jens.axboe@oracle.com, matthew@wil.cx, linux-ide

Switch MD over to the new blk_queue_stack_topology() function which
checks for aligment and adjusts preferred I/O sizes when stacking.

Also warn if an MD device contains misaligned components.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

---
6 files changed, 73 insertions(+), 15 deletions(-)
drivers/md/linear.c    |   10 ++++++++--
drivers/md/multipath.c |    5 ++---
drivers/md/raid0.c     |   14 ++++++++++++--
drivers/md/raid1.c     |   19 +++++++++++++++----
drivers/md/raid10.c    |   23 +++++++++++++++++++----
drivers/md/raid5.c     |   17 +++++++++++++++++



diff --git a/drivers/md/linear.c b/drivers/md/linear.c
--- a/drivers/md/linear.c
+++ b/drivers/md/linear.c
@@ -139,8 +139,8 @@ static linear_conf_t *linear_conf(mddev_
 
 		disk->rdev = rdev;
 
-		blk_queue_stack_limits(mddev->queue,
-				       rdev->bdev->bd_disk->queue);
+		blk_queue_stack_topology(mddev->queue, rdev->bdev,
+					 rdev->data_offset);
 		/* as we don't honour merge_bvec_fn, we must never risk
 		 * violating it, so limit ->max_sector to one PAGE, as
 		 * a one page request is never in violation.
@@ -154,6 +154,12 @@ static linear_conf_t *linear_conf(mddev_
 
 		cnt++;
 	}
+
+	if (queue_io_alignment(mddev->queue) < 0)
+		printk(KERN_NOTICE
+		       "Warning: %s has one or more misaligned components\n",
+		       mdname(mddev));
+
 	if (cnt != raid_disks) {
 		printk("linear: not enough drives present. Aborting!\n");
 		goto out;
diff --git a/drivers/md/multipath.c b/drivers/md/multipath.c
--- a/drivers/md/multipath.c
+++ b/drivers/md/multipath.c
@@ -294,7 +294,7 @@ static int multipath_add_disk(mddev_t *m
 	for (path = first; path <= last; path++)
 		if ((p=conf->multipaths+path)->rdev == NULL) {
 			q = rdev->bdev->bd_disk->queue;
-			blk_queue_stack_limits(mddev->queue, q);
+			blk_queue_stack_topology(mddev->queue, rdev->bdev, 0);
 
 		/* as we don't honour merge_bvec_fn, we must never risk
 		 * violating it, so limit ->max_sector to one PAGE, as
@@ -461,8 +461,7 @@ static int multipath_run (mddev_t *mddev
 		disk = conf->multipaths + disk_idx;
 		disk->rdev = rdev;
 
-		blk_queue_stack_limits(mddev->queue,
-				       rdev->bdev->bd_disk->queue);
+		blk_queue_stack_topology(mddev->queue, rdev->bdev, 0);
 		/* as we don't honour merge_bvec_fn, we must never risk
 		 * violating it, not that we ever expect a device with
 		 * a merge_bvec_fn to be involved in multipath */
diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -120,6 +120,10 @@ static int create_strip_zones (mddev_t *
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
@@ -136,8 +140,8 @@ static int create_strip_zones (mddev_t *
 		}
 		zone->dev[j] = rdev1;
 
-		blk_queue_stack_limits(mddev->queue,
-				       rdev1->bdev->bd_disk->queue);
+		blk_queue_stack_topology(mddev->queue, rdev1->bdev,
+					 rdev1->data_offset);
 		/* as we don't honour merge_bvec_fn, we must never risk
 		 * violating it, so limit ->max_sector to one PAGE, as
 		 * a one page request is never in violation.
@@ -151,6 +155,12 @@ static int create_strip_zones (mddev_t *
 			smallest = rdev1;
 		cnt++;
 	}
+
+	if (queue_io_alignment(mddev->queue) < 0)
+		printk(KERN_NOTICE
+		       "Warning: %s has one or more misaligned components\n",
+		       mdname(mddev));
+
 	if (cnt != mddev->raid_disks) {
 		printk(KERN_ERR "raid0: too few disks (%d of %d) - "
 			"aborting!\n", cnt, mddev->raid_disks);
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1123,8 +1123,8 @@ static int raid1_add_disk(mddev_t *mddev
 	for (mirror = first; mirror <= last; mirror++)
 		if ( !(p=conf->mirrors+mirror)->rdev) {
 
-			blk_queue_stack_limits(mddev->queue,
-					       rdev->bdev->bd_disk->queue);
+			blk_queue_stack_topology(mddev->queue, rdev->bdev,
+						 rdev->data_offset);
 			/* as we don't honour merge_bvec_fn, we must never risk
 			 * violating it, so limit ->max_sector to one PAGE, as
 			 * a one page request is never in violation.
@@ -1145,6 +1145,11 @@ static int raid1_add_disk(mddev_t *mddev
 			break;
 		}
 
+	if (queue_io_alignment(mddev->queue) < 0)
+		printk(KERN_NOTICE
+		       "Warning: %s has one or more misaligned components\n",
+		       mdname(mddev));
+
 	print_conf(conf);
 	return err;
 }
@@ -1989,8 +1994,8 @@ static int run(mddev_t *mddev)
 
 		disk->rdev = rdev;
 
-		blk_queue_stack_limits(mddev->queue,
-				       rdev->bdev->bd_disk->queue);
+		blk_queue_stack_topology(mddev->queue, rdev->bdev,
+					 rdev->data_offset);
 		/* as we don't honour merge_bvec_fn, we must never risk
 		 * violating it, so limit ->max_sector to one PAGE, as
 		 * a one page request is never in violation.
@@ -2001,6 +2006,12 @@ static int run(mddev_t *mddev)
 
 		disk->head_position = 0;
 	}
+
+	if (queue_io_alignment(mddev->queue) < 0)
+		printk(KERN_NOTICE
+		       "Warning: %s has one or more misaligned components\n",
+		       mdname(mddev));
+
 	conf->raid_disks = mddev->raid_disks;
 	conf->mddev = mddev;
 	INIT_LIST_HEAD(&conf->retry_list);
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1151,8 +1151,8 @@ static int raid10_add_disk(mddev_t *mdde
 	for ( ; mirror <= last ; mirror++)
 		if ( !(p=conf->mirrors+mirror)->rdev) {
 
-			blk_queue_stack_limits(mddev->queue,
-					       rdev->bdev->bd_disk->queue);
+			blk_queue_stack_topology(mddev->queue, rdev->bdev,
+						 rdev->data_offset);
 			/* as we don't honour merge_bvec_fn, we must never risk
 			 * violating it, so limit ->max_sector to one PAGE, as
 			 * a one page request is never in violation.
@@ -1170,6 +1170,11 @@ static int raid10_add_disk(mddev_t *mdde
 			break;
 		}
 
+	if (queue_io_alignment(mddev->queue) < 0)
+		printk(KERN_NOTICE
+		       "Warning: %s has one or more misaligned components\n",
+		       mdname(mddev));
+
 	print_conf(conf);
 	return err;
 }
@@ -2129,6 +2134,10 @@ static int run(mddev_t *mddev)
 	spin_lock_init(&conf->device_lock);
 	mddev->queue->queue_lock = &conf->device_lock;
 
+	blk_queue_io_min(mddev->queue, mddev->chunk_size);
+	blk_queue_io_opt(mddev->queue,
+			 (mddev->chunk_size * mddev->raid_disks) >> 1);
+
 	list_for_each_entry(rdev, &mddev->disks, same_set) {
 		disk_idx = rdev->raid_disk;
 		if (disk_idx >= mddev->raid_disks
@@ -2138,8 +2147,8 @@ static int run(mddev_t *mddev)
 
 		disk->rdev = rdev;
 
-		blk_queue_stack_limits(mddev->queue,
-				       rdev->bdev->bd_disk->queue);
+		blk_queue_stack_topology(mddev->queue, rdev->bdev,
+					 rdev->data_offset);
 		/* as we don't honour merge_bvec_fn, we must never risk
 		 * violating it, so limit ->max_sector to one PAGE, as
 		 * a one page request is never in violation.
@@ -2150,6 +2159,12 @@ static int run(mddev_t *mddev)
 
 		disk->head_position = 0;
 	}
+
+	if (queue_io_alignment(mddev->queue) < 0)
+		printk(KERN_NOTICE
+		       "Warning: %s has one or more misaligned components\n",
+		       mdname(mddev));
+
 	INIT_LIST_HEAD(&conf->retry_list);
 
 	spin_lock_init(&conf->resync_lock);
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -4601,6 +4601,23 @@ static int run(mddev_t *mddev)
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
+		blk_queue_stack_topology(mddev->queue, rdev->bdev,
+					 rdev->data_offset);
+
+	if (queue_io_alignment(mddev->queue) < 0)
+		printk(KERN_NOTICE
+		       "Warning: %s has one or more misaligned components\n",
+		       mdname(mddev));
 
 	return 0;
 abort:


