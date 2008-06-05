From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 2 of 3] md: Export preferred I/O sizes and physical alignment
Date: Thu, 05 Jun 2008 01:22:51 -0400
Message-ID: <c7132bad88f3ffb7bde6.1212643371@sermon.lab.mkp.net>
References: <patchbomb.1212643369@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from jaguar.mkp.net ([192.139.46.146]:32910 "EHLO jaguar.mkp.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751615AbYFEFYZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 5 Jun 2008 01:24:25 -0400
In-Reply-To: <patchbomb.1212643369@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-fsdevel@vger.kernel.org

5 files changed, 49 insertions(+)
drivers/md/linear.c |    8 ++++++++
drivers/md/raid0.c  |   11 +++++++++++
drivers/md/raid1.c  |    8 ++++++++
drivers/md/raid10.c |    9 +++++++++
drivers/md/raid5.c  |   13 +++++++++++++


For each of the RAID levels set the preferred I/O hints according to
chunk size and stripe width.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

---

diff -r 3e5d8520d247 -r c7132bad88f3 drivers/md/linear.c
--- a/drivers/md/linear.c	Thu Jun 05 01:07:51 2008 -0400
+++ b/drivers/md/linear.c	Thu Jun 05 01:07:51 2008 -0400
@@ -135,6 +135,14 @@
 
 		blk_queue_stack_limits(mddev->queue,
 				       rdev->bdev->bd_disk->queue);
+
+		if (rdev->raid_disk == 0)
+			disk_set_io_hints(mddev->gendisk,
+					  bdev_phys_offset(rdev->bdev)
+					  + rdev->data_offset,
+					  bdev_optimal_io_block(rdev->bdev),
+					  bdev_optimal_io_length(rdev->bdev));
+
 		/* as we don't honour merge_bvec_fn, we must never risk
 		 * violating it, so limit ->max_sector to one PAGE, as
 		 * a one page request is never in violation.
diff -r 3e5d8520d247 -r c7132bad88f3 drivers/md/raid0.c
--- a/drivers/md/raid0.c	Thu Jun 05 01:07:51 2008 -0400
+++ b/drivers/md/raid0.c	Thu Jun 05 01:07:51 2008 -0400
@@ -140,6 +140,17 @@
 
 		blk_queue_stack_limits(mddev->queue,
 				       rdev1->bdev->bd_disk->queue);
+
+		if (rdev1->raid_disk == 0) {
+			disk_set_io_hints(mddev->gendisk,
+					  bdev_phys_offset(rdev1->bdev)
+					  + rdev1->data_offset,
+					  mddev->chunk_size,
+					  mddev->chunk_size * mddev->raid_disks);
+			printk(KERN_ERR "raid0: chunk_size=%u, disks=%u\n",
+			       mddev->chunk_size, mddev->raid_disks);
+		}
+
 		/* as we don't honour merge_bvec_fn, we must never risk
 		 * violating it, so limit ->max_sector to one PAGE, as
 		 * a one page request is never in violation.
diff -r 3e5d8520d247 -r c7132bad88f3 drivers/md/raid1.c
--- a/drivers/md/raid1.c	Thu Jun 05 01:07:51 2008 -0400
+++ b/drivers/md/raid1.c	Thu Jun 05 01:07:51 2008 -0400
@@ -1970,6 +1970,14 @@
 
 		blk_queue_stack_limits(mddev->queue,
 				       rdev->bdev->bd_disk->queue);
+
+		if (rdev->raid_disk == 0)
+			disk_set_io_hints(mddev->gendisk,
+					  bdev_phys_offset(rdev->bdev)
+					  + rdev->data_offset,
+					  bdev_optimal_io_block(rdev->bdev),
+					  bdev_optimal_io_length(rdev->bdev));
+
 		/* as we don't honour merge_bvec_fn, we must never risk
 		 * violating it, so limit ->max_sector to one PAGE, as
 		 * a one page request is never in violation.
diff -r 3e5d8520d247 -r c7132bad88f3 drivers/md/raid10.c
--- a/drivers/md/raid10.c	Thu Jun 05 01:07:51 2008 -0400
+++ b/drivers/md/raid10.c	Thu Jun 05 01:07:51 2008 -0400
@@ -2106,6 +2106,15 @@
 
 		blk_queue_stack_limits(mddev->queue,
 				       rdev->bdev->bd_disk->queue);
+
+		if (rdev->raid_disk == 0)
+			disk_set_io_hints(mddev->gendisk,
+					  bdev_phys_offset(rdev->bdev)
+					  + rdev->data_offset,
+					  mddev->chunk_size,
+					  (mddev->chunk_size * mddev->raid_disks) 
+					  >> 1);
+
 		/* as we don't honour merge_bvec_fn, we must never risk
 		 * violating it, so limit ->max_sector to one PAGE, as
 		 * a one page request is never in violation.
diff -r 3e5d8520d247 -r c7132bad88f3 drivers/md/raid5.c
--- a/drivers/md/raid5.c	Thu Jun 05 01:07:51 2008 -0400
+++ b/drivers/md/raid5.c	Thu Jun 05 01:07:51 2008 -0400
@@ -4298,6 +4298,19 @@
 				raid_disk);
 			working_disks++;
 		}
+
+		if (rdev->raid_disk == 0) {
+			int disks = mddev->raid_disks - 1;
+
+			if (mddev->level == 6)
+				disks--;
+
+			disk_set_io_hints(mddev->gendisk,
+					  bdev_phys_offset(rdev->bdev)
+					  + rdev->data_offset,
+					  mddev->chunk_size,
+					  mddev->chunk_size * disks);
+		}
 	}
 
 	/*


