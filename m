From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 06/10] block: drop underbars from __{disk|part|all}_stat_*()
Date: Mon, 14 Jul 2008 16:12:10 +0900
Message-ID: <1216019534-29977-7-git-send-email-tj@kernel.org>
References: <1216019534-29977-1-git-send-email-tj@kernel.org>
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1216019534-29977-1-git-send-email-tj@kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: jens.axboe@oracle.com, James.Bottomley@HansenPartnership.com, bharrosh@panasas.com, greg.freemyer@gmail.com, linux-scsi@vger.kernel.org, brking@linux.vnet.ibm.com, liml@rtr.ca, viro@f
Cc: Tejun Heo <tj@kernel.org>
List-Id: linux-scsi@vger.kernel.org

Now that the not-underbarred versions are gone, there's no reason to
keep the ugly underbars.  Drop and add comments explaining that users
of these macros and funcitons need to turn off preemption.

While at it, add comments for stat macros and functions.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 block/blk-core.c           |   36 ++++++++++++++++--------
 drivers/block/aoe/aoecmd.c |    8 +++---
 drivers/md/dm.c            |    6 ++--
 drivers/md/linear.c        |    4 +-
 drivers/md/multipath.c     |    4 +-
 drivers/md/raid0.c         |    4 +-
 drivers/md/raid1.c         |    4 +-
 drivers/md/raid10.c        |    4 +-
 drivers/md/raid5.c         |    4 +-
 include/linux/genhd.h      |   63 +++++++++++++++++++++++++------------------
 10 files changed, 80 insertions(+), 57 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 3238ffe..1da936f 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -64,7 +64,7 @@ static void drive_stat_acct(struct request *rq, int new_io)
 
 	part = disk_map_sector_rcu(rq->rq_disk, rq->sector);
 	if (!new_io)
-		__all_stat_inc(rq->rq_disk, part, merges[rw], rq->sector);
+		all_stat_inc(rq->rq_disk, part, merges[rw], rq->sector);
 	else {
 		disk_round_stats(rq->rq_disk);
 		rq->rq_disk->in_flight++;
@@ -966,7 +966,7 @@ static inline void add_request(struct request_queue *q, struct request *req)
 	__elv_add_request(q, req, ELEVATOR_INSERT_SORT, 0);
 }
 
-/*
+/**
  * disk_round_stats()	- Round off the performance stats on a struct
  * disk_stats.
  *
@@ -980,6 +980,9 @@ static inline void add_request(struct request_queue *q, struct request *req)
  * function to do a round-off before returning the results when reading
  * /proc/diskstats.  This accounts immediately for all queue usage up to
  * the current jiffies and restarts the counters again.
+ *
+ * CONTEXT:
+ * Preemption disabled.
  */
 void disk_round_stats(struct gendisk *disk)
 {
@@ -989,14 +992,23 @@ void disk_round_stats(struct gendisk *disk)
 		return;
 
 	if (disk->in_flight) {
-		__disk_stat_add(disk, time_in_queue,
-				disk->in_flight * (now - disk->stamp));
-		__disk_stat_add(disk, io_ticks, (now - disk->stamp));
+		disk_stat_add(disk, time_in_queue,
+			      disk->in_flight * (now - disk->stamp));
+		disk_stat_add(disk, io_ticks, (now - disk->stamp));
 	}
 	disk->stamp = now;
 }
 EXPORT_SYMBOL_GPL(disk_round_stats);
 
+/**
+ * part_round_stats()	- Round off the performance stats on a struct
+ * disk_stats.
+ *
+ * Please see disk_round_stats() for more information.
+ *
+ * CONTEXT:
+ * Preemption disabled.
+ */
 void part_round_stats(struct hd_struct *part)
 {
 	unsigned long now = jiffies;
@@ -1005,9 +1017,9 @@ void part_round_stats(struct hd_struct *part)
 		return;
 
 	if (part->in_flight) {
-		__part_stat_add(part, time_in_queue,
-				part->in_flight * (now - part->stamp));
-		__part_stat_add(part, io_ticks, (now - part->stamp));
+		part_stat_add(part, time_in_queue,
+			      part->in_flight * (now - part->stamp));
+		part_stat_add(part, io_ticks, (now - part->stamp));
 	}
 	part->stamp = now;
 }
@@ -1544,8 +1556,8 @@ static int __end_that_request_first(struct request *req, int error,
 
 		rcu_read_lock_preempt();
 		part = disk_map_sector_rcu(req->rq_disk, req->sector);
-		__all_stat_add(req->rq_disk, part, sectors[rw],
-			       nr_bytes >> 9, req->sector);
+		all_stat_add(req->rq_disk, part, sectors[rw],
+			     nr_bytes >> 9, req->sector);
 		rcu_read_unlock_preempt();
 	}
 
@@ -1736,8 +1748,8 @@ static void end_that_request_last(struct request *req, int error)
 
 		part = disk_map_sector_rcu(disk, req->sector);
 
-		__all_stat_inc(disk, part, ios[rw], req->sector);
-		__all_stat_add(disk, part, ticks[rw], duration, req->sector);
+		all_stat_inc(disk, part, ios[rw], req->sector);
+		all_stat_add(disk, part, ticks[rw], duration, req->sector);
 		disk_round_stats(disk);
 		disk->in_flight--;
 		if (part) {
diff --git a/drivers/block/aoe/aoecmd.c b/drivers/block/aoe/aoecmd.c
index 7bd8c98..6710df3 100644
--- a/drivers/block/aoe/aoecmd.c
+++ b/drivers/block/aoe/aoecmd.c
@@ -760,10 +760,10 @@ diskstats(struct gendisk *disk, struct bio *bio, ulong duration, sector_t sector
 	rcu_read_lock_preempt();
 
 	part = disk_map_sector_rcu(disk, sector);
-	__all_stat_inc(disk, part, ios[rw], sector);
-	__all_stat_add(disk, part, ticks[rw], duration, sector);
-	__all_stat_add(disk, part, sectors[rw], n_sect, sector);
-	__all_stat_add(disk, part, io_ticks, duration, sector);
+	all_stat_inc(disk, part, ios[rw], sector);
+	all_stat_add(disk, part, ticks[rw], duration, sector);
+	all_stat_add(disk, part, sectors[rw], n_sect, sector);
+	all_stat_add(disk, part, io_ticks, duration, sector);
 
 	rcu_read_unlock_preempt();
 }
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 6918bb7..f76fb06 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -396,7 +396,7 @@ static int end_io_acct(struct dm_io *io)
 
 	preempt_disable();
 	disk_round_stats(dm_disk(md));
-	__disk_stat_add(dm_disk(md), ticks[rw], duration);
+	disk_stat_add(dm_disk(md), ticks[rw], duration);
 	preempt_enable();
 
 	dm_disk(md)->in_flight = pending = atomic_dec_return(&md->pending);
@@ -851,8 +851,8 @@ static int dm_request(struct request_queue *q, struct bio *bio)
 	down_read(&md->io_lock);
 
 	preempt_disable();
-	__disk_stat_inc(dm_disk(md), ios[rw]);
-	__disk_stat_add(dm_disk(md), sectors[rw], bio_sectors(bio));
+	disk_stat_inc(dm_disk(md), ios[rw]);
+	disk_stat_add(dm_disk(md), sectors[rw], bio_sectors(bio));
 	preempt_enable();
 
 	/*
diff --git a/drivers/md/linear.c b/drivers/md/linear.c
index ec35b8b..7341196 100644
--- a/drivers/md/linear.c
+++ b/drivers/md/linear.c
@@ -323,8 +323,8 @@ static int linear_make_request (struct request_queue *q, struct bio *bio)
 	}
 
 	preempt_disable();
-	__disk_stat_inc(mddev->gendisk, ios[rw]);
-	__disk_stat_add(mddev->gendisk, sectors[rw], bio_sectors(bio));
+	disk_stat_inc(mddev->gendisk, ios[rw]);
+	disk_stat_add(mddev->gendisk, sectors[rw], bio_sectors(bio));
 	preempt_enable();
 
 	tmp_dev = which_dev(mddev, bio->bi_sector);
diff --git a/drivers/md/multipath.c b/drivers/md/multipath.c
index aed8ea9..5db0a45 100644
--- a/drivers/md/multipath.c
+++ b/drivers/md/multipath.c
@@ -159,8 +159,8 @@ static int multipath_make_request (struct request_queue *q, struct bio * bio)
 	mp_bh->mddev = mddev;
 
 	preempt_disable();
-	__disk_stat_inc(mddev->gendisk, ios[rw]);
-	__disk_stat_add(mddev->gendisk, sectors[rw], bio_sectors(bio));
+	disk_stat_inc(mddev->gendisk, ios[rw]);
+	disk_stat_add(mddev->gendisk, sectors[rw], bio_sectors(bio));
 	preempt_enable();
 
 	mp_bh->path = multipath_map(conf);
diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index d0cdfe1..2602b05 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -404,8 +404,8 @@ static int raid0_make_request (struct request_queue *q, struct bio *bio)
 	}
 
 	preempt_disable();
-	__disk_stat_inc(mddev->gendisk, ios[rw]);
-	__disk_stat_add(mddev->gendisk, sectors[rw], bio_sectors(bio));
+	disk_stat_inc(mddev->gendisk, ios[rw]);
+	disk_stat_add(mddev->gendisk, sectors[rw], bio_sectors(bio));
 	preempt_enable();
 
 	chunk_size = mddev->chunk_size >> 10;
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 6687ffe..1fd2c3d 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -805,8 +805,8 @@ static int make_request(struct request_queue *q, struct bio * bio)
 	bitmap = mddev->bitmap;
 
 	preempt_disable();
-	__disk_stat_inc(mddev->gendisk, ios[rw]);
-	__disk_stat_add(mddev->gendisk, sectors[rw], bio_sectors(bio));
+	disk_stat_inc(mddev->gendisk, ios[rw]);
+	disk_stat_add(mddev->gendisk, sectors[rw], bio_sectors(bio));
 	preempt_enable();
 
 	/*
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 1d644dc..2521b73 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -839,8 +839,8 @@ static int make_request(struct request_queue *q, struct bio * bio)
 	wait_barrier(conf);
 
 	preempt_disable();
-	__disk_stat_inc(mddev->gendisk, ios[rw]);
-	__disk_stat_add(mddev->gendisk, sectors[rw], bio_sectors(bio));
+	disk_stat_inc(mddev->gendisk, ios[rw]);
+	disk_stat_add(mddev->gendisk, sectors[rw], bio_sectors(bio));
 	preempt_enable();
 
 	r10_bio = mempool_alloc(conf->r10bio_pool, GFP_NOIO);
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index a869e58..bfd8b6c 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -3581,8 +3581,8 @@ static int make_request(struct request_queue *q, struct bio * bi)
 	md_write_start(mddev, bi);
 
 	preempt_disable();
-	__disk_stat_inc(mddev->gendisk, ios[rw]);
-	__disk_stat_add(mddev->gendisk, sectors[rw], bio_sectors(bi));
+	disk_stat_inc(mddev->gendisk, ios[rw]);
+	disk_stat_add(mddev->gendisk, sectors[rw], bio_sectors(bi));
 	preempt_enable();
 
 	if (rw == READ &&
diff --git a/include/linux/genhd.h b/include/linux/genhd.h
index 87a338b..7737468 100644
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -207,8 +207,18 @@ extern void disk_part_iter_stop(struct disk_part_iter *piter);
 extern struct hd_struct *disk_map_sector_rcu(struct gendisk *disk,
 					     sector_t sector);
 
+/*
+ * Macros to to operate on disk statistics:
+ *
+ * {disk|part|all}_stat_{add|sub|inc|dec}() modify the stat counters
+ * and should be called with preemption disabled.
+ *
+ * {part|disk}_stat_read() can be called with preemption enabled.
+ *
+ * {part|disk}_stat_set_all() are for internal use only.
+ */
 #ifdef	CONFIG_SMP
-#define __disk_stat_add(gendiskp, field, addnd) 	\
+#define disk_stat_add(gendiskp, field, addnd)				\
 	(per_cpu_ptr(gendiskp->dkstats, smp_processor_id())->field += addnd)
 
 #define disk_stat_read(gendiskp, field)					\
@@ -220,7 +230,8 @@ extern struct hd_struct *disk_map_sector_rcu(struct gendisk *disk,
 	res;								\
 })
 
-static inline void disk_stat_set_all(struct gendisk *gendiskp, int value)	{
+static inline void disk_stat_set_all(struct gendisk *gendiskp, int value)
+{
 	int i;
 
 	for_each_possible_cpu(i)
@@ -228,14 +239,14 @@ static inline void disk_stat_set_all(struct gendisk *gendiskp, int value)	{
 				sizeof(struct disk_stats));
 }		
 
-#define __part_stat_add(part, field, addnd)				\
+#define part_stat_add(part, field, addnd)				\
 	(per_cpu_ptr(part->dkstats, smp_processor_id())->field += addnd)
 
-#define __all_stat_add(gendiskp, part, field, addnd, sector)	\
+#define all_stat_add(gendiskp, part, field, addnd, sector)	\
 ({								\
 	if (part)						\
-		__part_stat_add(part, field, addnd);		\
-	__disk_stat_add(gendiskp, field, addnd);		\
+		part_stat_add(part, field, addnd);		\
+	disk_stat_add(gendiskp, field, addnd);			\
 })
 
 #define part_stat_read(part, field)					\
@@ -257,7 +268,7 @@ static inline void part_stat_set_all(struct hd_struct *part, int value)
 }
 				
 #else /* !CONFIG_SMP */
-#define __disk_stat_add(gendiskp, field, addnd) \
+#define disk_stat_add(gendiskp, field, addnd) \
 				(gendiskp->dkstats.field += addnd)
 #define disk_stat_read(gendiskp, field)	(gendiskp->dkstats.field)
 
@@ -266,14 +277,14 @@ static inline void disk_stat_set_all(struct gendisk *gendiskp, int value)
 	memset(&gendiskp->dkstats, value, sizeof (struct disk_stats));
 }
 
-#define __part_stat_add(part, field, addnd) \
+#define part_stat_add(part, field, addnd) \
 	(part->dkstats.field += addnd)
 
-#define __all_stat_add(gendiskp, part, field, addnd, sector)	\
+#define all_stat_add(gendiskp, part, field, addnd, sector)	\
 ({								\
 	if (part)						\
 		part->dkstats.field += addnd;			\
-	__disk_stat_add(gendiskp, field, addnd);		\
+	disk_stat_add(gendiskp, field, addnd);			\
 })
 
 #define part_stat_read(part, field)	(part->dkstats.field)
@@ -285,22 +296,22 @@ static inline void part_stat_set_all(struct hd_struct *part, int value)
 
 #endif /* CONFIG_SMP */
 
-#define __disk_stat_dec(gendiskp, field) __disk_stat_add(gendiskp, field, -1)
-#define __disk_stat_inc(gendiskp, field) __disk_stat_add(gendiskp, field, 1)
-#define __disk_stat_sub(gendiskp, field, subnd) \
-		__disk_stat_add(gendiskp, field, -subnd)
-
-#define __part_stat_dec(gendiskp, field) __part_stat_add(gendiskp, field, -1)
-#define __part_stat_inc(gendiskp, field) __part_stat_add(gendiskp, field, 1)
-#define __part_stat_sub(gendiskp, field, subnd) \
-		__part_stat_add(gendiskp, field, -subnd)
-
-#define __all_stat_dec(gendiskp, field, sector) \
-		__all_stat_add(gendiskp, field, -1, sector)
-#define __all_stat_inc(gendiskp, part, field, sector) \
-		__all_stat_add(gendiskp, part, field, 1, sector)
-#define __all_stat_sub(gendiskp, part, field, subnd, sector) \
-		__all_stat_add(gendiskp, part, field, -subnd, sector)
+#define disk_stat_dec(gendiskp, field) disk_stat_add(gendiskp, field, -1)
+#define disk_stat_inc(gendiskp, field) disk_stat_add(gendiskp, field, 1)
+#define disk_stat_sub(gendiskp, field, subnd) \
+		disk_stat_add(gendiskp, field, -subnd)
+
+#define part_stat_dec(gendiskp, field) part_stat_add(gendiskp, field, -1)
+#define part_stat_inc(gendiskp, field) part_stat_add(gendiskp, field, 1)
+#define part_stat_sub(gendiskp, field, subnd) \
+		part_stat_add(gendiskp, field, -subnd)
+
+#define all_stat_dec(gendiskp, field, sector) \
+		all_stat_add(gendiskp, field, -1, sector)
+#define all_stat_inc(gendiskp, part, field, sector) \
+		all_stat_add(gendiskp, part, field, 1, sector)
+#define all_stat_sub(gendiskp, part, field, subnd, sector) \
+		all_stat_add(gendiskp, part, field, -subnd, sector)
 
 /* Inlines to alloc and free disk stats in struct gendisk */
 #ifdef  CONFIG_SMP
-- 
1.5.4.5

