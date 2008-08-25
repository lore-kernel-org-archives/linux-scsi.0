From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 05/09] block: fix diskstats access
Date: Mon, 25 Aug 2008 19:47:21 +0900
Message-ID: <1219661245-16055-6-git-send-email-tj@kernel.org>
References: <1219661245-16055-1-git-send-email-tj@kernel.org>
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1219661245-16055-1-git-send-email-tj@kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: James.Bottomley@HansenPartnership.com, bzolnier@gmail.com, bharrosh@panasas.com, greg.freemyer@gmail.com, linux-scsi@vger.kernel.org, brking@linux.vnet.ibm.com, liml@rtr.ca, viro@ftp.linux.org.uk, linux-ide@vger.kernel.org, neilb@suse.de, linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>, Peter Zijlstra <peterz@infradead.org>
List-Id: linux-scsi@vger.kernel.org

There are two variants of stat functions - ones prefixed with double
underbars which don't care about preemption and ones without which
disable preemption before manipulating per-cpu counters.  It's unclear
whether the underbarred ones assume that preemtion is disabled on
entry as some callers don't do that.

This patch unifies diskstats access by implementing disk_stat_lock()
and disk_stat_unlock() which take care of both RCU (for partition
access) and preemption (for per-cpu counter access).  diskstats access
should always be enclosed between the two functions.  As such, there's
no need for the versions which disables preemption.  They're removed
and double underbars ones are renamed to drop the underbars.  As an
extra argument is added, there's no danger of using the old version
unconverted.

disk_stat_lock() uses get_cpu() and returns the cpu index and all
diskstat functions which access per-cpu counters now has @cpu
argument to help RT.

This change adds RCU or preemption operations at some places but also
collapses several preemption ops into one at others.  Overall, the
performance difference should be negligible as all involved ops are
very lightweight per-cpu ones.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
---
 block/blk-core.c           |   52 +++++++++--------
 block/blk-merge.c          |   11 ++--
 block/genhd.c              |   20 ++++---
 drivers/block/aoe/aoecmd.c |   15 +++--
 drivers/md/dm.c            |   26 +++++----
 drivers/md/linear.c        |    7 ++-
 drivers/md/multipath.c     |    7 ++-
 drivers/md/raid0.c         |    7 ++-
 drivers/md/raid1.c         |    8 ++-
 drivers/md/raid10.c        |    7 ++-
 drivers/md/raid5.c         |    8 ++-
 fs/partitions/check.c      |    7 +-
 include/linux/genhd.h      |  139 ++++++++++++++++++--------------------------
 13 files changed, 158 insertions(+), 156 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index a8cfa5e..3de5610 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -56,25 +56,26 @@ static void drive_stat_acct(struct request *rq, int new_io)
 {
 	struct hd_struct *part;
 	int rw = rq_data_dir(rq);
+	int cpu;
 
 	if (!blk_fs_request(rq) || !rq->rq_disk)
 		return;
 
-	rcu_read_lock();
-
+	cpu = disk_stat_lock();
 	part = disk_map_sector_rcu(rq->rq_disk, rq->sector);
+
 	if (!new_io)
-		__all_stat_inc(rq->rq_disk, part, merges[rw], rq->sector);
+		all_stat_inc(cpu, rq->rq_disk, part, merges[rw], rq->sector);
 	else {
-		disk_round_stats(rq->rq_disk);
+		disk_round_stats(cpu, rq->rq_disk);
 		rq->rq_disk->in_flight++;
 		if (part) {
-			part_round_stats(part);
+			part_round_stats(cpu, part);
 			part->in_flight++;
 		}
 	}
 
-	rcu_read_unlock();
+	disk_stat_unlock();
 }
 
 void blk_queue_congestion_threshold(struct request_queue *q)
@@ -995,7 +996,7 @@ static inline void add_request(struct request_queue *q, struct request *req)
  * /proc/diskstats.  This accounts immediately for all queue usage up to
  * the current jiffies and restarts the counters again.
  */
-void disk_round_stats(struct gendisk *disk)
+void disk_round_stats(int cpu, struct gendisk *disk)
 {
 	unsigned long now = jiffies;
 
@@ -1003,15 +1004,15 @@ void disk_round_stats(struct gendisk *disk)
 		return;
 
 	if (disk->in_flight) {
-		__disk_stat_add(disk, time_in_queue,
-				disk->in_flight * (now - disk->stamp));
-		__disk_stat_add(disk, io_ticks, (now - disk->stamp));
+		disk_stat_add(cpu, disk, time_in_queue,
+			      disk->in_flight * (now - disk->stamp));
+		disk_stat_add(cpu, disk, io_ticks, (now - disk->stamp));
 	}
 	disk->stamp = now;
 }
 EXPORT_SYMBOL_GPL(disk_round_stats);
 
-void part_round_stats(struct hd_struct *part)
+void part_round_stats(int cpu, struct hd_struct *part)
 {
 	unsigned long now = jiffies;
 
@@ -1019,9 +1020,9 @@ void part_round_stats(struct hd_struct *part)
 		return;
 
 	if (part->in_flight) {
-		__part_stat_add(part, time_in_queue,
-				part->in_flight * (now - part->stamp));
-		__part_stat_add(part, io_ticks, (now - part->stamp));
+		part_stat_add(cpu, part, time_in_queue,
+			      part->in_flight * (now - part->stamp));
+		part_stat_add(cpu, part, io_ticks, (now - part->stamp));
 	}
 	part->stamp = now;
 }
@@ -1561,12 +1562,13 @@ static int __end_that_request_first(struct request *req, int error,
 	if (blk_fs_request(req) && req->rq_disk) {
 		const int rw = rq_data_dir(req);
 		struct hd_struct *part;
+		int cpu;
 
-		rcu_read_lock();
+		cpu = disk_stat_lock();
 		part = disk_map_sector_rcu(req->rq_disk, req->sector);
-		all_stat_add(req->rq_disk, part, sectors[rw],
-				nr_bytes >> 9, req->sector);
-		rcu_read_unlock();
+		all_stat_add(cpu, req->rq_disk, part, sectors[rw],
+			     nr_bytes >> 9, req->sector);
+		disk_stat_unlock();
 	}
 
 	total_bytes = bio_nbytes = 0;
@@ -1751,21 +1753,21 @@ static void end_that_request_last(struct request *req, int error)
 		unsigned long duration = jiffies - req->start_time;
 		const int rw = rq_data_dir(req);
 		struct hd_struct *part;
+		int cpu;
 
-		rcu_read_lock();
-
+		cpu = disk_stat_lock();
 		part = disk_map_sector_rcu(disk, req->sector);
 
-		__all_stat_inc(disk, part, ios[rw], req->sector);
-		__all_stat_add(disk, part, ticks[rw], duration, req->sector);
-		disk_round_stats(disk);
+		all_stat_inc(cpu, disk, part, ios[rw], req->sector);
+		all_stat_add(cpu, disk, part, ticks[rw], duration, req->sector);
+		disk_round_stats(cpu, disk);
 		disk->in_flight--;
 		if (part) {
-			part_round_stats(part);
+			part_round_stats(cpu, part);
 			part->in_flight--;
 		}
 
-		rcu_read_unlock();
+		disk_stat_unlock();
 	}
 
 	if (req->end_io)
diff --git a/block/blk-merge.c b/block/blk-merge.c
index eb2a3ca..d926a24 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -388,18 +388,19 @@ static int attempt_merge(struct request_queue *q, struct request *req,
 
 	if (req->rq_disk) {
 		struct hd_struct *part;
+		int cpu;
 
-		rcu_read_lock();
-
+		cpu = disk_stat_lock();
 		part = disk_map_sector_rcu(req->rq_disk, req->sector);
-		disk_round_stats(req->rq_disk);
+
+		disk_round_stats(cpu, req->rq_disk);
 		req->rq_disk->in_flight--;
 		if (part) {
-			part_round_stats(part);
+			part_round_stats(cpu, part);
 			part->in_flight--;
 		}
 
-		rcu_read_unlock();
+		disk_stat_unlock();
 	}
 
 	req->ioprio = ioprio_best(req->ioprio, next->ioprio);
diff --git a/block/genhd.c b/block/genhd.c
index 5e234b1..7dbf2cc 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -634,10 +634,11 @@ static ssize_t disk_stat_show(struct device *dev,
 			      struct device_attribute *attr, char *buf)
 {
 	struct gendisk *disk = dev_to_disk(dev);
+	int cpu;
 
-	preempt_disable();
-	disk_round_stats(disk);
-	preempt_enable();
+	cpu = disk_stat_lock();
+	disk_round_stats(cpu, disk);
+	disk_stat_unlock();
 	return sprintf(buf,
 		"%8lu %8lu %8llu %8u "
 		"%8lu %8lu %8llu %8u "
@@ -750,6 +751,7 @@ static int diskstats_show(struct seq_file *seqf, void *v)
 	struct disk_part_iter piter;
 	struct hd_struct *hd;
 	char buf[BDEVNAME_SIZE];
+	int cpu;
 
 	/*
 	if (&gp->dev.kobj.entry == block_class.devices.next)
@@ -759,9 +761,9 @@ static int diskstats_show(struct seq_file *seqf, void *v)
 				"\n\n");
 	*/
  
-	preempt_disable();
-	disk_round_stats(gp);
-	preempt_enable();
+	cpu = disk_stat_lock();
+	disk_round_stats(cpu, gp);
+	disk_stat_unlock();
 	seq_printf(seqf, "%4d %4d %s %lu %lu %llu %u %lu %lu %llu %u %u %u %u\n",
 		MAJOR(disk_devt(gp)), MINOR(disk_devt(gp)),
 		disk_name(gp, 0, buf),
@@ -778,9 +780,9 @@ static int diskstats_show(struct seq_file *seqf, void *v)
 	/* now show all non-0 size partitions of it */
 	disk_part_iter_init(&piter, gp, 0);
 	while ((hd = disk_part_iter_next(&piter))) {
-		preempt_disable();
-		part_round_stats(hd);
-		preempt_enable();
+		cpu = disk_stat_lock();
+		part_round_stats(cpu, hd);
+		disk_stat_unlock();
 		seq_printf(seqf, "%4d %4d %s %lu %lu %llu "
 			   "%u %lu %lu %llu %u %u %u %u\n",
 			   MAJOR(part_devt(hd)), MINOR(part_devt(hd)),
diff --git a/drivers/block/aoe/aoecmd.c b/drivers/block/aoe/aoecmd.c
index 84c03d6..17eed8c 100644
--- a/drivers/block/aoe/aoecmd.c
+++ b/drivers/block/aoe/aoecmd.c
@@ -756,16 +756,17 @@ diskstats(struct gendisk *disk, struct bio *bio, ulong duration, sector_t sector
 	unsigned long n_sect = bio->bi_size >> 9;
 	const int rw = bio_data_dir(bio);
 	struct hd_struct *part;
+	int cpu;
 
-	rcu_read_lock();
-
+	cpu = disk_stat_lock();
 	part = disk_map_sector_rcu(disk, sector);
-	all_stat_inc(disk, part, ios[rw], sector);
-	all_stat_add(disk, part, ticks[rw], duration, sector);
-	all_stat_add(disk, part, sectors[rw], n_sect, sector);
-	all_stat_add(disk, part, io_ticks, duration, sector);
 
-	rcu_read_unlock();
+	all_stat_inc(cpu, disk, part, ios[rw], sector);
+	all_stat_add(cpu, disk, part, ticks[rw], duration, sector);
+	all_stat_add(cpu, disk, part, sectors[rw], n_sect, sector);
+	all_stat_add(cpu, disk, part, io_ticks, duration, sector);
+
+	disk_stat_unlock();
 }
 
 void
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index b4ddb96..d087435 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -377,12 +377,13 @@ static void free_tio(struct mapped_device *md, struct dm_target_io *tio)
 static void start_io_acct(struct dm_io *io)
 {
 	struct mapped_device *md = io->md;
+	int cpu;
 
 	io->start_time = jiffies;
 
-	preempt_disable();
-	disk_round_stats(dm_disk(md));
-	preempt_enable();
+	cpu = disk_stat_lock();
+	disk_round_stats(cpu, dm_disk(md));
+	disk_stat_unlock();
 	dm_disk(md)->in_flight = atomic_inc_return(&md->pending);
 }
 
@@ -391,15 +392,15 @@ static int end_io_acct(struct dm_io *io)
 	struct mapped_device *md = io->md;
 	struct bio *bio = io->bio;
 	unsigned long duration = jiffies - io->start_time;
-	int pending;
+	int pending, cpu;
 	int rw = bio_data_dir(bio);
 
-	preempt_disable();
-	disk_round_stats(dm_disk(md));
-	preempt_enable();
-	dm_disk(md)->in_flight = pending = atomic_dec_return(&md->pending);
+	cpu = disk_stat_lock();
+	disk_round_stats(cpu, dm_disk(md));
+	disk_stat_add(cpu, dm_disk(md), ticks[rw], duration);
+	disk_stat_unlock();
 
-	disk_stat_add(dm_disk(md), ticks[rw], duration);
+	dm_disk(md)->in_flight = pending = atomic_dec_return(&md->pending);
 
 	return !pending;
 }
@@ -881,6 +882,7 @@ static int dm_request(struct request_queue *q, struct bio *bio)
 	int r = -EIO;
 	int rw = bio_data_dir(bio);
 	struct mapped_device *md = q->queuedata;
+	int cpu;
 
 	/*
 	 * There is no use in forwarding any barrier request since we can't
@@ -893,8 +895,10 @@ static int dm_request(struct request_queue *q, struct bio *bio)
 
 	down_read(&md->io_lock);
 
-	disk_stat_inc(dm_disk(md), ios[rw]);
-	disk_stat_add(dm_disk(md), sectors[rw], bio_sectors(bio));
+	cpu = disk_stat_lock();
+	disk_stat_inc(cpu, dm_disk(md), ios[rw]);
+	disk_stat_add(cpu, dm_disk(md), sectors[rw], bio_sectors(bio));
+	disk_stat_unlock();
 
 	/*
 	 * If we're suspended we have to queue
diff --git a/drivers/md/linear.c b/drivers/md/linear.c
index b1eebf8..00cbc8e 100644
--- a/drivers/md/linear.c
+++ b/drivers/md/linear.c
@@ -318,14 +318,17 @@ static int linear_make_request (struct request_queue *q, struct bio *bio)
 	mddev_t *mddev = q->queuedata;
 	dev_info_t *tmp_dev;
 	sector_t block;
+	int cpu;
 
 	if (unlikely(bio_barrier(bio))) {
 		bio_endio(bio, -EOPNOTSUPP);
 		return 0;
 	}
 
-	disk_stat_inc(mddev->gendisk, ios[rw]);
-	disk_stat_add(mddev->gendisk, sectors[rw], bio_sectors(bio));
+	cpu = disk_stat_lock();
+	disk_stat_inc(cpu, mddev->gendisk, ios[rw]);
+	disk_stat_add(cpu, mddev->gendisk, sectors[rw], bio_sectors(bio));
+	disk_stat_unlock();
 
 	tmp_dev = which_dev(mddev, bio->bi_sector);
 	block = bio->bi_sector >> 1;
diff --git a/drivers/md/multipath.c b/drivers/md/multipath.c
index c4779cc..182f5a9 100644
--- a/drivers/md/multipath.c
+++ b/drivers/md/multipath.c
@@ -147,6 +147,7 @@ static int multipath_make_request (struct request_queue *q, struct bio * bio)
 	struct multipath_bh * mp_bh;
 	struct multipath_info *multipath;
 	const int rw = bio_data_dir(bio);
+	int cpu;
 
 	if (unlikely(bio_barrier(bio))) {
 		bio_endio(bio, -EOPNOTSUPP);
@@ -158,8 +159,10 @@ static int multipath_make_request (struct request_queue *q, struct bio * bio)
 	mp_bh->master_bio = bio;
 	mp_bh->mddev = mddev;
 
-	disk_stat_inc(mddev->gendisk, ios[rw]);
-	disk_stat_add(mddev->gendisk, sectors[rw], bio_sectors(bio));
+	cpu = disk_stat_lock();
+	disk_stat_inc(cpu, mddev->gendisk, ios[rw]);
+	disk_stat_add(cpu, mddev->gendisk, sectors[rw], bio_sectors(bio));
+	disk_stat_unlock();
 
 	mp_bh->path = multipath_map(conf);
 	if (mp_bh->path < 0) {
diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index 1836106..e26030f 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -399,14 +399,17 @@ static int raid0_make_request (struct request_queue *q, struct bio *bio)
 	sector_t chunk;
 	sector_t block, rsect;
 	const int rw = bio_data_dir(bio);
+	int cpu;
 
 	if (unlikely(bio_barrier(bio))) {
 		bio_endio(bio, -EOPNOTSUPP);
 		return 0;
 	}
 
-	disk_stat_inc(mddev->gendisk, ios[rw]);
-	disk_stat_add(mddev->gendisk, sectors[rw], bio_sectors(bio));
+	cpu = disk_stat_lock();
+	disk_stat_inc(cpu, mddev->gendisk, ios[rw]);
+	disk_stat_add(cpu, mddev->gendisk, sectors[rw], bio_sectors(bio));
+	disk_stat_unlock();
 
 	chunk_size = mddev->chunk_size >> 10;
 	chunk_sects = mddev->chunk_size >> 9;
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 0b82030..babb130 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -779,7 +779,7 @@ static int make_request(struct request_queue *q, struct bio * bio)
 	struct page **behind_pages = NULL;
 	const int rw = bio_data_dir(bio);
 	const int do_sync = bio_sync(bio);
-	int do_barriers;
+	int cpu, do_barriers;
 	mdk_rdev_t *blocked_rdev;
 
 	/*
@@ -804,8 +804,10 @@ static int make_request(struct request_queue *q, struct bio * bio)
 
 	bitmap = mddev->bitmap;
 
-	disk_stat_inc(mddev->gendisk, ios[rw]);
-	disk_stat_add(mddev->gendisk, sectors[rw], bio_sectors(bio));
+	cpu = disk_stat_lock();
+	disk_stat_inc(cpu, mddev->gendisk, ios[rw]);
+	disk_stat_add(cpu, mddev->gendisk, sectors[rw], bio_sectors(bio));
+	disk_stat_unlock();
 
 	/*
 	 * make_request() can abort the operation when READA is being
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index d3b9aa0..5ec80da 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -789,6 +789,7 @@ static int make_request(struct request_queue *q, struct bio * bio)
 	mirror_info_t *mirror;
 	r10bio_t *r10_bio;
 	struct bio *read_bio;
+	int cpu;
 	int i;
 	int chunk_sects = conf->chunk_mask + 1;
 	const int rw = bio_data_dir(bio);
@@ -843,8 +844,10 @@ static int make_request(struct request_queue *q, struct bio * bio)
 	 */
 	wait_barrier(conf);
 
-	disk_stat_inc(mddev->gendisk, ios[rw]);
-	disk_stat_add(mddev->gendisk, sectors[rw], bio_sectors(bio));
+	cpu = disk_stat_lock();
+	disk_stat_inc(cpu, mddev->gendisk, ios[rw]);
+	disk_stat_add(cpu, mddev->gendisk, sectors[rw], bio_sectors(bio));
+	disk_stat_unlock();
 
 	r10_bio = mempool_alloc(conf->r10bio_pool, GFP_NOIO);
 
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 37e5465..5899f21 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -3387,7 +3387,7 @@ static int make_request(struct request_queue *q, struct bio * bi)
 	sector_t logical_sector, last_sector;
 	struct stripe_head *sh;
 	const int rw = bio_data_dir(bi);
-	int remaining;
+	int cpu, remaining;
 
 	if (unlikely(bio_barrier(bi))) {
 		bio_endio(bi, -EOPNOTSUPP);
@@ -3396,8 +3396,10 @@ static int make_request(struct request_queue *q, struct bio * bi)
 
 	md_write_start(mddev, bi);
 
-	disk_stat_inc(mddev->gendisk, ios[rw]);
-	disk_stat_add(mddev->gendisk, sectors[rw], bio_sectors(bi));
+	cpu = disk_stat_lock();
+	disk_stat_inc(cpu, mddev->gendisk, ios[rw]);
+	disk_stat_add(cpu, mddev->gendisk, sectors[rw], bio_sectors(bi));
+	disk_stat_unlock();
 
 	if (rw == READ &&
 	     mddev->reshape_position == MaxSector &&
diff --git a/fs/partitions/check.c b/fs/partitions/check.c
index aa2f5f7..36e0641 100644
--- a/fs/partitions/check.c
+++ b/fs/partitions/check.c
@@ -219,10 +219,11 @@ static ssize_t part_stat_show(struct device *dev,
 			      struct device_attribute *attr, char *buf)
 {
 	struct hd_struct *p = dev_to_part(dev);
+	int cpu;
 
-	preempt_disable();
-	part_round_stats(p);
-	preempt_enable();
+	cpu = disk_stat_lock();
+	part_round_stats(cpu, p);
+	disk_stat_unlock();
 	return sprintf(buf,
 		"%8lu %8lu %8llu %8u "
 		"%8lu %8lu %8llu %8u "
diff --git a/include/linux/genhd.h b/include/linux/genhd.h
index aeaf59c..09420c3 100644
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -219,16 +219,24 @@ extern void disk_part_iter_exit(struct disk_part_iter *piter);
 extern struct hd_struct *disk_map_sector_rcu(struct gendisk *disk,
 					     sector_t sector);
 
-/* 
+/*
  * Macros to operate on percpu disk statistics:
  *
- * The __ variants should only be called in critical sections. The full
- * variants disable/enable preemption.
+ * {disk|part|all}_stat_{add|sub|inc|dec}() modify the stat counters
+ * and should be called between disk_stat_lock() and
+ * disk_stat_unlock().
+ *
+ * part_stat_read() can be called at any time.
+ *
+ * part_stat_{add|set_all}() and {init|free}_part_stats are for
+ * internal use only.
  */
-
 #ifdef	CONFIG_SMP
-#define __disk_stat_add(gendiskp, field, addnd) 	\
-	(per_cpu_ptr(gendiskp->dkstats, smp_processor_id())->field += addnd)
+#define disk_stat_lock()	({ rcu_read_lock(); get_cpu(); })
+#define disk_stat_unlock()	do { put_cpu(); rcu_read_unlock(); } while (0)
+
+#define disk_stat_add(cpu, gendiskp, field, addnd)			\
+	(per_cpu_ptr(gendiskp->dkstats, cpu)->field += addnd)
 
 #define disk_stat_read(gendiskp, field)					\
 ({									\
@@ -239,7 +247,8 @@ extern struct hd_struct *disk_map_sector_rcu(struct gendisk *disk,
 	res;								\
 })
 
-static inline void disk_stat_set_all(struct gendisk *gendiskp, int value)	{
+static inline void disk_stat_set_all(struct gendisk *gendiskp, int value)
+{
 	int i;
 
 	for_each_possible_cpu(i)
@@ -247,14 +256,14 @@ static inline void disk_stat_set_all(struct gendisk *gendiskp, int value)	{
 				sizeof(struct disk_stats));
 }		
 
-#define __part_stat_add(part, field, addnd)				\
-	(per_cpu_ptr(part->dkstats, smp_processor_id())->field += addnd)
+#define part_stat_add(cpu, part, field, addnd)				\
+	(per_cpu_ptr(part->dkstats, cpu)->field += addnd)
 
-#define __all_stat_add(gendiskp, part, field, addnd, sector)	\
-({								\
-	if (part)						\
-		__part_stat_add(part, field, addnd);		\
-	__disk_stat_add(gendiskp, field, addnd);		\
+#define all_stat_add(cpu, gendiskp, part, field, addnd, sector)		\
+({									\
+	if (part)							\
+		part_stat_add(cpu, part, field, addnd);			\
+	disk_stat_add(cpu, gendiskp, field, addnd);			\
 })
 
 #define part_stat_read(part, field)					\
@@ -274,10 +283,13 @@ static inline void part_stat_set_all(struct hd_struct *part, int value)
 		memset(per_cpu_ptr(part->dkstats, i), value,
 				sizeof(struct disk_stats));
 }
-				
+
 #else /* !CONFIG_SMP */
-#define __disk_stat_add(gendiskp, field, addnd) \
-				(gendiskp->dkstats.field += addnd)
+#define disk_stat_lock()	({ rcu_read_lock(); 0; })
+#define disk_stat_unlock()	rcu_read_unlock()
+
+#define disk_stat_add(cpu, gendiskp, field, addnd)			\
+	(gendiskp->dkstats.field += addnd)
 #define disk_stat_read(gendiskp, field)	(gendiskp->dkstats.field)
 
 static inline void disk_stat_set_all(struct gendisk *gendiskp, int value)
@@ -285,14 +297,14 @@ static inline void disk_stat_set_all(struct gendisk *gendiskp, int value)
 	memset(&gendiskp->dkstats, value, sizeof (struct disk_stats));
 }
 
-#define __part_stat_add(part, field, addnd) \
+#define part_stat_add(cpu, part, field, addnd)				\
 	(part->dkstats.field += addnd)
 
-#define __all_stat_add(gendiskp, part, field, addnd, sector)	\
-({								\
-	if (part)						\
-		part->dkstats.field += addnd;			\
-	__disk_stat_add(gendiskp, field, addnd);		\
+#define all_stat_add(cpu, gendiskp, part, field, addnd, sector)		\
+({									\
+	if (part)							\
+		part_stat_add(cpu, part, field, addnd);			\
+	disk_stat_add(cpu, gendiskp, field, addnd);			\
 })
 
 #define part_stat_read(part, field)	(part->dkstats.field)
@@ -304,63 +316,26 @@ static inline void part_stat_set_all(struct hd_struct *part, int value)
 
 #endif /* CONFIG_SMP */
 
-#define disk_stat_add(gendiskp, field, addnd)			\
-	do {							\
-		preempt_disable();				\
-		__disk_stat_add(gendiskp, field, addnd);	\
-		preempt_enable();				\
-	} while (0)
-
-#define __disk_stat_dec(gendiskp, field) __disk_stat_add(gendiskp, field, -1)
-#define disk_stat_dec(gendiskp, field) disk_stat_add(gendiskp, field, -1)
-
-#define __disk_stat_inc(gendiskp, field) __disk_stat_add(gendiskp, field, 1)
-#define disk_stat_inc(gendiskp, field) disk_stat_add(gendiskp, field, 1)
-
-#define __disk_stat_sub(gendiskp, field, subnd) \
-		__disk_stat_add(gendiskp, field, -subnd)
-#define disk_stat_sub(gendiskp, field, subnd) \
-		disk_stat_add(gendiskp, field, -subnd)
-
-#define part_stat_add(gendiskp, field, addnd)		\
-	do {						\
-		preempt_disable();			\
-		__part_stat_add(gendiskp, field, addnd);\
-		preempt_enable();			\
-	} while (0)
-
-#define __part_stat_dec(gendiskp, field) __part_stat_add(gendiskp, field, -1)
-#define part_stat_dec(gendiskp, field) part_stat_add(gendiskp, field, -1)
-
-#define __part_stat_inc(gendiskp, field) __part_stat_add(gendiskp, field, 1)
-#define part_stat_inc(gendiskp, field) part_stat_add(gendiskp, field, 1)
-
-#define __part_stat_sub(gendiskp, field, subnd) \
-		__part_stat_add(gendiskp, field, -subnd)
-#define part_stat_sub(gendiskp, field, subnd) \
-		part_stat_add(gendiskp, field, -subnd)
-
-#define all_stat_add(gendiskp, part, field, addnd, sector)	\
-	do {							\
-		preempt_disable();				\
-		__all_stat_add(gendiskp, part, field, addnd, sector);	\
-		preempt_enable();				\
-	} while (0)
-
-#define __all_stat_dec(gendiskp, field, sector) \
-		__all_stat_add(gendiskp, field, -1, sector)
-#define all_stat_dec(gendiskp, field, sector) \
-		all_stat_add(gendiskp, field, -1, sector)
-
-#define __all_stat_inc(gendiskp, part, field, sector) \
-		__all_stat_add(gendiskp, part, field, 1, sector)
-#define all_stat_inc(gendiskp, part, field, sector) \
-		all_stat_add(gendiskp, part, field, 1, sector)
-
-#define __all_stat_sub(gendiskp, part, field, subnd, sector) \
-		__all_stat_add(gendiskp, part, field, -subnd, sector)
-#define all_stat_sub(gendiskp, part, field, subnd, sector) \
-		all_stat_add(gendiskp, part, field, -subnd, sector)
+#define disk_stat_dec(cpu, gendiskp, field)				\
+	disk_stat_add(cpu, gendiskp, field, -1)
+#define disk_stat_inc(cpu, gendiskp, field)				\
+	disk_stat_add(cpu, gendiskp, field, 1)
+#define disk_stat_sub(cpu, gendiskp, field, subnd)			\
+	disk_stat_add(cpu, gendiskp, field, -subnd)
+
+#define part_stat_dec(cpu, gendiskp, field)				\
+	part_stat_add(cpu, gendiskp, field, -1)
+#define part_stat_inc(cpu, gendiskp, field)				\
+	part_stat_add(cpu, gendiskp, field, 1)
+#define part_stat_sub(cpu, gendiskp, field, subnd)			\
+	part_stat_add(cpu, gendiskp, field, -subnd)
+
+#define all_stat_dec(cpu, gendiskp, field, sector)			\
+	all_stat_add(cpu, gendiskp, field, -1, sector)
+#define all_stat_inc(cpu, gendiskp, part, field, sector)		\
+	all_stat_add(cpu, gendiskp, part, field, 1, sector)
+#define all_stat_sub(cpu, gendiskp, part, field, subnd, sector)		\
+	all_stat_add(cpu, gendiskp, part, field, -subnd, sector)
 
 /* Inlines to alloc and free disk stats in struct gendisk */
 #ifdef  CONFIG_SMP
@@ -411,8 +386,8 @@ static inline void free_part_stats(struct hd_struct *part)
 #endif	/* CONFIG_SMP */
 
 /* drivers/block/ll_rw_blk.c */
-extern void disk_round_stats(struct gendisk *disk);
-extern void part_round_stats(struct hd_struct *part);
+extern void disk_round_stats(int cpu, struct gendisk *disk);
+extern void part_round_stats(int cpu, struct hd_struct *part);
 
 /* drivers/block/genhd.c */
 extern int get_blkdev_list(char *, int);
-- 
1.5.4.5

