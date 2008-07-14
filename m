From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 05/10] block: always use __{disk|part|all}_stat_*() and kill non-underbarred versions
Date: Mon, 14 Jul 2008 16:12:09 +0900
Message-ID: <1216019534-29977-6-git-send-email-tj@kernel.org>
References: <1216019534-29977-1-git-send-email-tj@kernel.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hera.kernel.org ([140.211.167.34]:60100 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756375AbYGNHNq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 14 Jul 2008 03:13:46 -0400
In-Reply-To: <1216019534-29977-1-git-send-email-tj@kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jens.axboe@oracle.com, James.Bottomley@HansenPartnership.com, bharrosh@panasas.com, greg.freemyer@gmail.com, linux-scsi@vger.kernel.org, brking@linux.vnet.ibm.com, liml@rtr.ca, viro@f
Cc: Tejun Heo <tj@kernel.org>

There are two variants of stat functions - ones prefixed with double
underbars which don't care about preemption and ones without which
disable preemption before manipulating per-cpu counters.  It's unclear
whether the underbarred ones assume that preemtion is disabled on
entry as some callers don't do that.  In any case, stats are not
critical data and errors don't lead to critical failures.

However, consistently using the underbarred version and ensuring that
they are called with preemption disabled doesn't incur noticeable
overhead or even reduces overhead in some cases.

* part stat manipulations need disk_map_sector_rcu() which involves
  read locking RCU anyway.  Using rcu_read_lock_preempt() instead
  solves the problem nicely.  On rcuclassic, this means no extra
  overhead.

* Calls to the non-underbarred versions are converted to explicit
  preemtion disable and calls to respective underbarrded versions.  As
  all such users had more than one consecutive stat ops, this reduces
  extra preemption disable/enables.

* In drivers/md/dm.c::end_io_acct(), __disk_stat_add() call is moved
  into neighboring preemption disabled block.

The conversion makes the stats usage more consistent and IMHO the
added few preemption calls are well justified for that.

As this change makes non-underbarred versions useless, non-underbarred
stat functions and macros are killed.  The next patch will drop
underbars from the underbarred versions as it's superflous now.  This
is done as a separate step so that compile fails between this and the
next patch if someone's left behind.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 block/blk-core.c           |   16 +++++++-------
 block/blk-merge.c          |    4 +-
 drivers/block/aoe/aoecmd.c |   12 +++++-----
 drivers/md/dm.c            |   10 +++++---
 drivers/md/linear.c        |    6 +++-
 drivers/md/multipath.c     |    6 +++-
 drivers/md/raid0.c         |    6 +++-
 drivers/md/raid1.c         |    6 +++-
 drivers/md/raid10.c        |    6 +++-
 drivers/md/raid5.c         |    6 +++-
 include/linux/genhd.h      |   48 --------------------------------------------
 11 files changed, 46 insertions(+), 80 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 84292e1..3238ffe 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -60,7 +60,7 @@ static void drive_stat_acct(struct request *rq, int new_io)
 	if (!blk_fs_request(rq) || !rq->rq_disk)
 		return;
 
-	rcu_read_lock();
+	rcu_read_lock_preempt();
 
 	part = disk_map_sector_rcu(rq->rq_disk, rq->sector);
 	if (!new_io)
@@ -74,7 +74,7 @@ static void drive_stat_acct(struct request *rq, int new_io)
 		}
 	}
 
-	rcu_read_unlock();
+	rcu_read_unlock_preempt();
 }
 
 void blk_queue_congestion_threshold(struct request_queue *q)
@@ -1542,11 +1542,11 @@ static int __end_that_request_first(struct request *req, int error,
 		const int rw = rq_data_dir(req);
 		struct hd_struct *part;
 
-		rcu_read_lock();
+		rcu_read_lock_preempt();
 		part = disk_map_sector_rcu(req->rq_disk, req->sector);
-		all_stat_add(req->rq_disk, part, sectors[rw],
-				nr_bytes >> 9, req->sector);
-		rcu_read_unlock();
+		__all_stat_add(req->rq_disk, part, sectors[rw],
+			       nr_bytes >> 9, req->sector);
+		rcu_read_unlock_preempt();
 	}
 
 	total_bytes = bio_nbytes = 0;
@@ -1732,7 +1732,7 @@ static void end_that_request_last(struct request *req, int error)
 		const int rw = rq_data_dir(req);
 		struct hd_struct *part;
 
-		rcu_read_lock();
+		rcu_read_lock_preempt();
 
 		part = disk_map_sector_rcu(disk, req->sector);
 
@@ -1745,7 +1745,7 @@ static void end_that_request_last(struct request *req, int error)
 			part->in_flight--;
 		}
 
-		rcu_read_unlock();
+		rcu_read_unlock_preempt();
 	}
 
 	if (req->end_io)
diff --git a/block/blk-merge.c b/block/blk-merge.c
index 9be9b2f..55456c8 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -469,7 +469,7 @@ static int attempt_merge(struct request_queue *q, struct request *req,
 	if (req->rq_disk) {
 		struct hd_struct *part;
 
-		rcu_read_lock();
+		rcu_read_lock_preempt();
 
 		part = disk_map_sector_rcu(req->rq_disk, req->sector);
 		disk_round_stats(req->rq_disk);
@@ -479,7 +479,7 @@ static int attempt_merge(struct request_queue *q, struct request *req,
 			part->in_flight--;
 		}
 
-		rcu_read_unlock();
+		rcu_read_unlock_preempt();
 	}
 
 	req->ioprio = ioprio_best(req->ioprio, next->ioprio);
diff --git a/drivers/block/aoe/aoecmd.c b/drivers/block/aoe/aoecmd.c
index 50ef9ea..7bd8c98 100644
--- a/drivers/block/aoe/aoecmd.c
+++ b/drivers/block/aoe/aoecmd.c
@@ -757,15 +757,15 @@ diskstats(struct gendisk *disk, struct bio *bio, ulong duration, sector_t sector
 	const int rw = bio_data_dir(bio);
 	struct hd_struct *part;
 
-	rcu_read_lock();
+	rcu_read_lock_preempt();
 
 	part = disk_map_sector_rcu(disk, sector);
-	all_stat_inc(disk, part, ios[rw], sector);
-	all_stat_add(disk, part, ticks[rw], duration, sector);
-	all_stat_add(disk, part, sectors[rw], n_sect, sector);
-	all_stat_add(disk, part, io_ticks, duration, sector);
+	__all_stat_inc(disk, part, ios[rw], sector);
+	__all_stat_add(disk, part, ticks[rw], duration, sector);
+	__all_stat_add(disk, part, sectors[rw], n_sect, sector);
+	__all_stat_add(disk, part, io_ticks, duration, sector);
 
-	rcu_read_unlock();
+	rcu_read_unlock_preempt();
 }
 
 void
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 923fea4..6918bb7 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -396,10 +396,10 @@ static int end_io_acct(struct dm_io *io)
 
 	preempt_disable();
 	disk_round_stats(dm_disk(md));
+	__disk_stat_add(dm_disk(md), ticks[rw], duration);
 	preempt_enable();
-	dm_disk(md)->in_flight = pending = atomic_dec_return(&md->pending);
 
-	disk_stat_add(dm_disk(md), ticks[rw], duration);
+	dm_disk(md)->in_flight = pending = atomic_dec_return(&md->pending);
 
 	return !pending;
 }
@@ -850,8 +850,10 @@ static int dm_request(struct request_queue *q, struct bio *bio)
 
 	down_read(&md->io_lock);
 
-	disk_stat_inc(dm_disk(md), ios[rw]);
-	disk_stat_add(dm_disk(md), sectors[rw], bio_sectors(bio));
+	preempt_disable();
+	__disk_stat_inc(dm_disk(md), ios[rw]);
+	__disk_stat_add(dm_disk(md), sectors[rw], bio_sectors(bio));
+	preempt_enable();
 
 	/*
 	 * If we're suspended we have to queue
diff --git a/drivers/md/linear.c b/drivers/md/linear.c
index 1074824..ec35b8b 100644
--- a/drivers/md/linear.c
+++ b/drivers/md/linear.c
@@ -322,8 +322,10 @@ static int linear_make_request (struct request_queue *q, struct bio *bio)
 		return 0;
 	}
 
-	disk_stat_inc(mddev->gendisk, ios[rw]);
-	disk_stat_add(mddev->gendisk, sectors[rw], bio_sectors(bio));
+	preempt_disable();
+	__disk_stat_inc(mddev->gendisk, ios[rw]);
+	__disk_stat_add(mddev->gendisk, sectors[rw], bio_sectors(bio));
+	preempt_enable();
 
 	tmp_dev = which_dev(mddev, bio->bi_sector);
 	block = bio->bi_sector >> 1;
diff --git a/drivers/md/multipath.c b/drivers/md/multipath.c
index e968116..aed8ea9 100644
--- a/drivers/md/multipath.c
+++ b/drivers/md/multipath.c
@@ -158,8 +158,10 @@ static int multipath_make_request (struct request_queue *q, struct bio * bio)
 	mp_bh->master_bio = bio;
 	mp_bh->mddev = mddev;
 
-	disk_stat_inc(mddev->gendisk, ios[rw]);
-	disk_stat_add(mddev->gendisk, sectors[rw], bio_sectors(bio));
+	preempt_disable();
+	__disk_stat_inc(mddev->gendisk, ios[rw]);
+	__disk_stat_add(mddev->gendisk, sectors[rw], bio_sectors(bio));
+	preempt_enable();
 
 	mp_bh->path = multipath_map(conf);
 	if (mp_bh->path < 0) {
diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index 914c04d..d0cdfe1 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -403,8 +403,10 @@ static int raid0_make_request (struct request_queue *q, struct bio *bio)
 		return 0;
 	}
 
-	disk_stat_inc(mddev->gendisk, ios[rw]);
-	disk_stat_add(mddev->gendisk, sectors[rw], bio_sectors(bio));
+	preempt_disable();
+	__disk_stat_inc(mddev->gendisk, ios[rw]);
+	__disk_stat_add(mddev->gendisk, sectors[rw], bio_sectors(bio));
+	preempt_enable();
 
 	chunk_size = mddev->chunk_size >> 10;
 	chunk_sects = mddev->chunk_size >> 9;
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index c610b94..6687ffe 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -804,8 +804,10 @@ static int make_request(struct request_queue *q, struct bio * bio)
 
 	bitmap = mddev->bitmap;
 
-	disk_stat_inc(mddev->gendisk, ios[rw]);
-	disk_stat_add(mddev->gendisk, sectors[rw], bio_sectors(bio));
+	preempt_disable();
+	__disk_stat_inc(mddev->gendisk, ios[rw]);
+	__disk_stat_add(mddev->gendisk, sectors[rw], bio_sectors(bio));
+	preempt_enable();
 
 	/*
 	 * make_request() can abort the operation when READA is being
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index a71277b..1d644dc 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -838,8 +838,10 @@ static int make_request(struct request_queue *q, struct bio * bio)
 	 */
 	wait_barrier(conf);
 
-	disk_stat_inc(mddev->gendisk, ios[rw]);
-	disk_stat_add(mddev->gendisk, sectors[rw], bio_sectors(bio));
+	preempt_disable();
+	__disk_stat_inc(mddev->gendisk, ios[rw]);
+	__disk_stat_add(mddev->gendisk, sectors[rw], bio_sectors(bio));
+	preempt_enable();
 
 	r10_bio = mempool_alloc(conf->r10bio_pool, GFP_NOIO);
 
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 3b27df5..a869e58 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -3580,8 +3580,10 @@ static int make_request(struct request_queue *q, struct bio * bi)
 
 	md_write_start(mddev, bi);
 
-	disk_stat_inc(mddev->gendisk, ios[rw]);
-	disk_stat_add(mddev->gendisk, sectors[rw], bio_sectors(bi));
+	preempt_disable();
+	__disk_stat_inc(mddev->gendisk, ios[rw]);
+	__disk_stat_add(mddev->gendisk, sectors[rw], bio_sectors(bi));
+	preempt_enable();
 
 	if (rw == READ &&
 	     mddev->reshape_position == MaxSector &&
diff --git a/include/linux/genhd.h b/include/linux/genhd.h
index 3e35945..87a338b 100644
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -207,13 +207,6 @@ extern void disk_part_iter_stop(struct disk_part_iter *piter);
 extern struct hd_struct *disk_map_sector_rcu(struct gendisk *disk,
 					     sector_t sector);
 
-/* 
- * Macros to operate on percpu disk statistics:
- *
- * The __ variants should only be called in critical sections. The full
- * variants disable/enable preemption.
- */
-
 #ifdef	CONFIG_SMP
 #define __disk_stat_add(gendiskp, field, addnd) 	\
 	(per_cpu_ptr(gendiskp->dkstats, smp_processor_id())->field += addnd)
@@ -292,63 +285,22 @@ static inline void part_stat_set_all(struct hd_struct *part, int value)
 
 #endif /* CONFIG_SMP */
 
-#define disk_stat_add(gendiskp, field, addnd)			\
-	do {							\
-		preempt_disable();				\
-		__disk_stat_add(gendiskp, field, addnd);	\
-		preempt_enable();				\
-	} while (0)
-
 #define __disk_stat_dec(gendiskp, field) __disk_stat_add(gendiskp, field, -1)
-#define disk_stat_dec(gendiskp, field) disk_stat_add(gendiskp, field, -1)
-
 #define __disk_stat_inc(gendiskp, field) __disk_stat_add(gendiskp, field, 1)
-#define disk_stat_inc(gendiskp, field) disk_stat_add(gendiskp, field, 1)
-
 #define __disk_stat_sub(gendiskp, field, subnd) \
 		__disk_stat_add(gendiskp, field, -subnd)
-#define disk_stat_sub(gendiskp, field, subnd) \
-		disk_stat_add(gendiskp, field, -subnd)
-
-#define part_stat_add(gendiskp, field, addnd)		\
-	do {						\
-		preempt_disable();			\
-		__part_stat_add(gendiskp, field, addnd);\
-		preempt_enable();			\
-	} while (0)
 
 #define __part_stat_dec(gendiskp, field) __part_stat_add(gendiskp, field, -1)
-#define part_stat_dec(gendiskp, field) part_stat_add(gendiskp, field, -1)
-
 #define __part_stat_inc(gendiskp, field) __part_stat_add(gendiskp, field, 1)
-#define part_stat_inc(gendiskp, field) part_stat_add(gendiskp, field, 1)
-
 #define __part_stat_sub(gendiskp, field, subnd) \
 		__part_stat_add(gendiskp, field, -subnd)
-#define part_stat_sub(gendiskp, field, subnd) \
-		part_stat_add(gendiskp, field, -subnd)
-
-#define all_stat_add(gendiskp, part, field, addnd, sector)	\
-	do {							\
-		preempt_disable();				\
-		__all_stat_add(gendiskp, part, field, addnd, sector);	\
-		preempt_enable();				\
-	} while (0)
 
 #define __all_stat_dec(gendiskp, field, sector) \
 		__all_stat_add(gendiskp, field, -1, sector)
-#define all_stat_dec(gendiskp, field, sector) \
-		all_stat_add(gendiskp, field, -1, sector)
-
 #define __all_stat_inc(gendiskp, part, field, sector) \
 		__all_stat_add(gendiskp, part, field, 1, sector)
-#define all_stat_inc(gendiskp, part, field, sector) \
-		all_stat_add(gendiskp, part, field, 1, sector)
-
 #define __all_stat_sub(gendiskp, part, field, subnd, sector) \
 		__all_stat_add(gendiskp, part, field, -subnd, sector)
-#define all_stat_sub(gendiskp, part, field, subnd, sector) \
-		all_stat_add(gendiskp, part, field, -subnd, sector)
 
 /* Inlines to alloc and free disk stats in struct gendisk */
 #ifdef  CONFIG_SMP
-- 
1.5.4.5

