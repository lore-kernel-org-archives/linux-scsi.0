From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 10/13] block: move stats from disk to part0
Date: Mon, 25 Aug 2008 19:56:14 +0900
Message-ID: <1219661777-17648-11-git-send-email-tj@kernel.org>
References: <1219661777-17648-1-git-send-email-tj@kernel.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hera.kernel.org ([140.211.167.34]:51902 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757324AbYHYK7X (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Aug 2008 06:59:23 -0400
In-Reply-To: <1219661777-17648-1-git-send-email-tj@kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: James.Bottomley@HansenPartnership.com, bzolnier@gmail.com, bharrosh@panasas.com, greg.freemyer@gmail.com, linux-scsi@vger.kernel.org, brking@linux.vnet.ibm.com, liml@rtr.ca, viro@ftp.linux.org.uk, linux-ide@vger.kernel.org, neilb@suse.de, linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>

Move stats related fields - stamp, in_flight, dkstats - from disk to
part0 and unify stat handling such that...

* part_stat_*() now updates part0 together if the specified partition
  is not part0.  ie. part_stat_*() are now essentially all_stat_*().

* {disk|all}_stat_*() are gone.

* part_round_stats() is updated similary.  It handles part0 stats
  automatically and disk_round_stats() is killed.

* part_{inc|dec}_in_fligh() is implemented which automatically updates
  part0 stats for parts other than part0.

* disk_map_sector_rcu() is updated to return part0 if no part matches.
  Combined with the above changes, this makes NULL special case
  handling in callers unnecessary.

* Separate stats show code paths for disk are collapsed into part
  stats show code paths.

* Rename disk_stat_lock/unlock() to part_stat_lock/unlock()

While at it, reposition stat handling macros a bit and add missing
parentheses around macro parameters.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 block/blk-core.c           |   84 +++++++++--------------
 block/blk-merge.c          |   12 +--
 block/genhd.c              |   97 +++++++--------------------
 drivers/block/aoe/aoecmd.c |   12 ++--
 drivers/md/dm.c            |   27 ++++----
 drivers/md/linear.c        |    9 ++-
 drivers/md/md.c            |    4 +-
 drivers/md/multipath.c     |    9 ++-
 drivers/md/raid0.c         |    9 ++-
 drivers/md/raid1.c         |    9 ++-
 drivers/md/raid10.c        |    9 ++-
 drivers/md/raid5.c         |    9 ++-
 fs/partitions/check.c      |   12 ++--
 include/linux/genhd.h      |  159 ++++++++++++-------------------------------
 14 files changed, 165 insertions(+), 296 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 3a059cf..0f339ff 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -61,21 +61,17 @@ static void drive_stat_acct(struct request *rq, int new_io)
 	if (!blk_fs_request(rq) || !rq->rq_disk)
 		return;
 
-	cpu = disk_stat_lock();
+	cpu = part_stat_lock();
 	part = disk_map_sector_rcu(rq->rq_disk, rq->sector);
 
 	if (!new_io)
-		all_stat_inc(cpu, rq->rq_disk, part, merges[rw], rq->sector);
+		part_stat_inc(cpu, part, merges[rw]);
 	else {
-		disk_round_stats(cpu, rq->rq_disk);
-		rq->rq_disk->in_flight++;
-		if (part) {
-			part_round_stats(cpu, part);
-			part->in_flight++;
-		}
+		part_round_stats(cpu, part);
+		part_inc_in_flight(part);
 	}
 
-	disk_stat_unlock();
+	part_stat_unlock();
 }
 
 void blk_queue_congestion_threshold(struct request_queue *q)
@@ -981,8 +977,22 @@ static inline void add_request(struct request_queue *q, struct request *req)
 	__elv_add_request(q, req, ELEVATOR_INSERT_SORT, 0);
 }
 
-/*
- * disk_round_stats()	- Round off the performance stats on a struct
+static void part_round_stats_single(int cpu, struct hd_struct *part,
+				    unsigned long now)
+{
+	if (now == part->stamp)
+		return;
+
+	if (part->in_flight) {
+		__part_stat_add(cpu, part, time_in_queue,
+				part->in_flight * (now - part->stamp));
+		__part_stat_add(cpu, part, io_ticks, (now - part->stamp));
+	}
+	part->stamp = now;
+}
+
+/**
+ * part_round_stats()	- Round off the performance stats on a struct
  * disk_stats.
  *
  * The average IO queue length and utilisation statistics are maintained
@@ -996,36 +1006,15 @@ static inline void add_request(struct request_queue *q, struct request *req)
  * /proc/diskstats.  This accounts immediately for all queue usage up to
  * the current jiffies and restarts the counters again.
  */
-void disk_round_stats(int cpu, struct gendisk *disk)
-{
-	unsigned long now = jiffies;
-
-	if (now == disk->stamp)
-		return;
-
-	if (disk->in_flight) {
-		disk_stat_add(cpu, disk, time_in_queue,
-			      disk->in_flight * (now - disk->stamp));
-		disk_stat_add(cpu, disk, io_ticks, (now - disk->stamp));
-	}
-	disk->stamp = now;
-}
-EXPORT_SYMBOL_GPL(disk_round_stats);
-
 void part_round_stats(int cpu, struct hd_struct *part)
 {
 	unsigned long now = jiffies;
 
-	if (now == part->stamp)
-		return;
-
-	if (part->in_flight) {
-		part_stat_add(cpu, part, time_in_queue,
-			      part->in_flight * (now - part->stamp));
-		part_stat_add(cpu, part, io_ticks, (now - part->stamp));
-	}
-	part->stamp = now;
+	if (part->partno)
+		part_round_stats_single(cpu, &part_to_disk(part)->part0, now);
+	part_round_stats_single(cpu, part, now);
 }
+EXPORT_SYMBOL_GPL(part_round_stats);
 
 /*
  * queue lock must be held
@@ -1565,11 +1554,10 @@ static int __end_that_request_first(struct request *req, int error,
 		struct hd_struct *part;
 		int cpu;
 
-		cpu = disk_stat_lock();
+		cpu = part_stat_lock();
 		part = disk_map_sector_rcu(req->rq_disk, req->sector);
-		all_stat_add(cpu, req->rq_disk, part, sectors[rw],
-			     nr_bytes >> 9, req->sector);
-		disk_stat_unlock();
+		part_stat_add(cpu, part, sectors[rw], nr_bytes >> 9);
+		part_stat_unlock();
 	}
 
 	total_bytes = bio_nbytes = 0;
@@ -1756,19 +1744,15 @@ static void end_that_request_last(struct request *req, int error)
 		struct hd_struct *part;
 		int cpu;
 
-		cpu = disk_stat_lock();
+		cpu = part_stat_lock();
 		part = disk_map_sector_rcu(disk, req->sector);
 
-		all_stat_inc(cpu, disk, part, ios[rw], req->sector);
-		all_stat_add(cpu, disk, part, ticks[rw], duration, req->sector);
-		disk_round_stats(cpu, disk);
-		disk->in_flight--;
-		if (part) {
-			part_round_stats(cpu, part);
-			part->in_flight--;
-		}
+		part_stat_inc(cpu, part, ios[rw]);
+		part_stat_add(cpu, part, ticks[rw], duration);
+		part_round_stats(cpu, part);
+		part_dec_in_flight(part);
 
-		disk_stat_unlock();
+		part_stat_unlock();
 	}
 
 	if (req->end_io)
diff --git a/block/blk-merge.c b/block/blk-merge.c
index d926a24..c77196d 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -390,17 +390,13 @@ static int attempt_merge(struct request_queue *q, struct request *req,
 		struct hd_struct *part;
 		int cpu;
 
-		cpu = disk_stat_lock();
+		cpu = part_stat_lock();
 		part = disk_map_sector_rcu(req->rq_disk, req->sector);
 
-		disk_round_stats(cpu, req->rq_disk);
-		req->rq_disk->in_flight--;
-		if (part) {
-			part_round_stats(cpu, part);
-			part->in_flight--;
-		}
+		part_round_stats(cpu, part);
+		part_dec_in_flight(part);
 
-		disk_stat_unlock();
+		part_stat_unlock();
 	}
 
 	req->ioprio = ioprio_best(req->ioprio, next->ioprio);
diff --git a/block/genhd.c b/block/genhd.c
index b0a11c7..cf8d55e 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -176,7 +176,7 @@ EXPORT_SYMBOL_GPL(disk_part_iter_exit);
  * while preemption is disabled.
  *
  * RETURNS:
- * Found partition on success, NULL if there's no matching partition.
+ * Found partition on success, part0 is returned if no partition matches
  */
 struct hd_struct *disk_map_sector_rcu(struct gendisk *disk, sector_t sector)
 {
@@ -189,7 +189,7 @@ struct hd_struct *disk_map_sector_rcu(struct gendisk *disk, sector_t sector)
 		    sector < part->start_sect + part->nr_sects)
 			return part;
 	}
-	return NULL;
+	return &disk->part0;
 }
 EXPORT_SYMBOL_GPL(disk_map_sector_rcu);
 
@@ -582,24 +582,24 @@ void __init printk_all_partitions(void)
 		 * numbers in hex - the same format as the root=
 		 * option takes.
 		 */
-		printk("%s %10llu %s",
-		       bdevt_str(disk_devt(disk), devt_buf),
-		       (unsigned long long)get_capacity(disk) >> 1,
-		       disk_name(disk, 0, name_buf));
-		if (disk->driverfs_dev != NULL &&
-		    disk->driverfs_dev->driver != NULL)
-			printk(" driver: %s\n",
-			       disk->driverfs_dev->driver->name);
-		else
-			printk(" (driver?)\n");
+		disk_part_iter_init(&piter, disk, DISK_PITER_INCL_PART0);
+		while ((part = disk_part_iter_next(&piter))) {
+			bool is_part0 = part == &disk->part0;
 
-		/* now show the partitions */
-		disk_part_iter_init(&piter, disk, 0);
-		while ((part = disk_part_iter_next(&piter)))
-			printk("  %s %10llu %s\n",
+			printk("%s%s %10llu %s", is_part0 ? "" : "  ",
 			       bdevt_str(part_devt(part), devt_buf),
 			       (unsigned long long)part->nr_sects >> 1,
 			       disk_name(disk, part->partno, name_buf));
+			if (is_part0) {
+				if (disk->driverfs_dev != NULL &&
+				    disk->driverfs_dev->driver != NULL)
+					printk(" driver: %s\n",
+					      disk->driverfs_dev->driver->name);
+				else
+					printk(" (driver?)\n");
+			} else
+				printk("\n");
+		}
 		disk_part_iter_exit(&piter);
 	}
 	class_dev_iter_exit(&iter);
@@ -675,12 +675,7 @@ static int show_partition(struct seq_file *seqf, void *v)
 		return 0;
 
 	/* show the full disk and all non-0 size partitions of it */
-	seq_printf(seqf, "%4d  %7d %10llu %s\n",
-		MAJOR(disk_devt(sgp)), MINOR(disk_devt(sgp)),
-		(unsigned long long)get_capacity(sgp) >> 1,
-		disk_name(sgp, 0, buf));
-
-	disk_part_iter_init(&piter, sgp, 0);
+	disk_part_iter_init(&piter, sgp, DISK_PITER_INCL_PART0);
 	while ((part = disk_part_iter_next(&piter)))
 		seq_printf(seqf, "%4d  %7d %10llu %s\n",
 			   MAJOR(part_devt(part)), MINOR(part_devt(part)),
@@ -769,40 +764,13 @@ static ssize_t disk_capability_show(struct device *dev,
 	return sprintf(buf, "%x\n", disk->flags);
 }
 
-static ssize_t disk_stat_show(struct device *dev,
-			      struct device_attribute *attr, char *buf)
-{
-	struct gendisk *disk = dev_to_disk(dev);
-	int cpu;
-
-	cpu = disk_stat_lock();
-	disk_round_stats(cpu, disk);
-	disk_stat_unlock();
-	return sprintf(buf,
-		"%8lu %8lu %8llu %8u "
-		"%8lu %8lu %8llu %8u "
-		"%8u %8u %8u"
-		"\n",
-		disk_stat_read(disk, ios[READ]),
-		disk_stat_read(disk, merges[READ]),
-		(unsigned long long)disk_stat_read(disk, sectors[READ]),
-		jiffies_to_msecs(disk_stat_read(disk, ticks[READ])),
-		disk_stat_read(disk, ios[WRITE]),
-		disk_stat_read(disk, merges[WRITE]),
-		(unsigned long long)disk_stat_read(disk, sectors[WRITE]),
-		jiffies_to_msecs(disk_stat_read(disk, ticks[WRITE])),
-		disk->in_flight,
-		jiffies_to_msecs(disk_stat_read(disk, io_ticks)),
-		jiffies_to_msecs(disk_stat_read(disk, time_in_queue)));
-}
-
 static DEVICE_ATTR(range, S_IRUGO, disk_range_show, NULL);
 static DEVICE_ATTR(ext_range, S_IRUGO, disk_ext_range_show, NULL);
 static DEVICE_ATTR(removable, S_IRUGO, disk_removable_show, NULL);
 static DEVICE_ATTR(ro, S_IRUGO, disk_ro_show, NULL);
 static DEVICE_ATTR(size, S_IRUGO, part_size_show, NULL);
 static DEVICE_ATTR(capability, S_IRUGO, disk_capability_show, NULL);
-static DEVICE_ATTR(stat, S_IRUGO, disk_stat_show, NULL);
+static DEVICE_ATTR(stat, S_IRUGO, part_stat_show, NULL);
 #ifdef CONFIG_FAIL_MAKE_REQUEST
 static struct device_attribute dev_attr_fail =
 	__ATTR(make-it-fail, S_IRUGO|S_IWUSR, part_fail_show, part_fail_store);
@@ -837,7 +805,7 @@ static void disk_release(struct device *dev)
 
 	kfree(disk->random);
 	kfree(disk->__part);
-	free_disk_stats(disk);
+	free_part_stats(&disk->part0);
 	kfree(disk);
 }
 struct class block_class = {
@@ -874,28 +842,11 @@ static int diskstats_show(struct seq_file *seqf, void *v)
 				"\n\n");
 	*/
  
-	cpu = disk_stat_lock();
-	disk_round_stats(cpu, gp);
-	disk_stat_unlock();
-	seq_printf(seqf, "%4d %7d %s %lu %lu %llu %u %lu %lu %llu %u %u %u %u\n",
-		MAJOR(disk_devt(gp)), MINOR(disk_devt(gp)),
-		disk_name(gp, 0, buf),
-		disk_stat_read(gp, ios[0]), disk_stat_read(gp, merges[0]),
-		(unsigned long long)disk_stat_read(gp, sectors[0]),
-		jiffies_to_msecs(disk_stat_read(gp, ticks[0])),
-		disk_stat_read(gp, ios[1]), disk_stat_read(gp, merges[1]),
-		(unsigned long long)disk_stat_read(gp, sectors[1]),
-		jiffies_to_msecs(disk_stat_read(gp, ticks[1])),
-		gp->in_flight,
-		jiffies_to_msecs(disk_stat_read(gp, io_ticks)),
-		jiffies_to_msecs(disk_stat_read(gp, time_in_queue)));
-
-	/* now show all non-0 size partitions of it */
-	disk_part_iter_init(&piter, gp, 0);
+	disk_part_iter_init(&piter, gp, DISK_PITER_INCL_PART0);
 	while ((hd = disk_part_iter_next(&piter))) {
-		cpu = disk_stat_lock();
+		cpu = part_stat_lock();
 		part_round_stats(cpu, hd);
-		disk_stat_unlock();
+		part_stat_unlock();
 		seq_printf(seqf, "%4d %7d %s %lu %lu %llu "
 			   "%u %lu %lu %llu %u %u %u %u\n",
 			   MAJOR(part_devt(hd)), MINOR(part_devt(hd)),
@@ -1001,7 +952,7 @@ struct gendisk *alloc_disk_ext_node(int minors, int ext_minors, int node_id)
 		int tot_minors = minors + ext_minors;
 		int size = tot_minors * sizeof(struct hd_struct *);
 
-		if (!init_disk_stats(disk)) {
+		if (!init_part_stats(&disk->part0)) {
 			kfree(disk);
 			return NULL;
 		}
@@ -1009,7 +960,7 @@ struct gendisk *alloc_disk_ext_node(int minors, int ext_minors, int node_id)
 		disk->__part = kmalloc_node(size, GFP_KERNEL | __GFP_ZERO,
 					    node_id);
 		if (!disk->__part) {
-			free_disk_stats(disk);
+				free_part_stats(&disk->part0);
 			kfree(disk);
 			return NULL;
 		}
diff --git a/drivers/block/aoe/aoecmd.c b/drivers/block/aoe/aoecmd.c
index 934800f..961d29a 100644
--- a/drivers/block/aoe/aoecmd.c
+++ b/drivers/block/aoe/aoecmd.c
@@ -758,15 +758,15 @@ diskstats(struct gendisk *disk, struct bio *bio, ulong duration, sector_t sector
 	struct hd_struct *part;
 	int cpu;
 
-	cpu = disk_stat_lock();
+	cpu = part_stat_lock();
 	part = disk_map_sector_rcu(disk, sector);
 
-	all_stat_inc(cpu, disk, part, ios[rw], sector);
-	all_stat_add(cpu, disk, part, ticks[rw], duration, sector);
-	all_stat_add(cpu, disk, part, sectors[rw], n_sect, sector);
-	all_stat_add(cpu, disk, part, io_ticks, duration, sector);
+	part_stat_inc(cpu, part, ios[rw]);
+	part_stat_add(cpu, part, ticks[rw], duration);
+	part_stat_add(cpu, part, sectors[rw], n_sect);
+	part_stat_add(cpu, part, io_ticks, duration);
 
-	disk_stat_unlock();
+	part_stat_unlock();
 }
 
 void
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 7f8d6ff..8d40369 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -381,10 +381,10 @@ static void start_io_acct(struct dm_io *io)
 
 	io->start_time = jiffies;
 
-	cpu = disk_stat_lock();
-	disk_round_stats(cpu, dm_disk(md));
-	disk_stat_unlock();
-	dm_disk(md)->in_flight = atomic_inc_return(&md->pending);
+	cpu = part_stat_lock();
+	part_round_stats(cpu, &dm_disk(md)->part0);
+	part_stat_unlock();
+	dm_disk(md)->part0.in_flight = atomic_inc_return(&md->pending);
 }
 
 static int end_io_acct(struct dm_io *io)
@@ -395,12 +395,13 @@ static int end_io_acct(struct dm_io *io)
 	int pending, cpu;
 	int rw = bio_data_dir(bio);
 
-	cpu = disk_stat_lock();
-	disk_round_stats(cpu, dm_disk(md));
-	disk_stat_add(cpu, dm_disk(md), ticks[rw], duration);
-	disk_stat_unlock();
+	cpu = part_stat_lock();
+	part_round_stats(cpu, &dm_disk(md)->part0);
+	part_stat_add(cpu, &dm_disk(md)->part0, ticks[rw], duration);
+	part_stat_unlock();
 
-	dm_disk(md)->in_flight = pending = atomic_dec_return(&md->pending);
+	dm_disk(md)->part0.in_flight = pending =
+		atomic_dec_return(&md->pending);
 
 	return !pending;
 }
@@ -895,10 +896,10 @@ static int dm_request(struct request_queue *q, struct bio *bio)
 
 	down_read(&md->io_lock);
 
-	cpu = disk_stat_lock();
-	disk_stat_inc(cpu, dm_disk(md), ios[rw]);
-	disk_stat_add(cpu, dm_disk(md), sectors[rw], bio_sectors(bio));
-	disk_stat_unlock();
+	cpu = part_stat_lock();
+	part_stat_inc(cpu, &dm_disk(md)->part0, ios[rw]);
+	part_stat_add(cpu, &dm_disk(md)->part0, sectors[rw], bio_sectors(bio));
+	part_stat_unlock();
 
 	/*
 	 * If we're suspended we have to queue
diff --git a/drivers/md/linear.c b/drivers/md/linear.c
index 00cbc8e..c80ea90 100644
--- a/drivers/md/linear.c
+++ b/drivers/md/linear.c
@@ -325,10 +325,11 @@ static int linear_make_request (struct request_queue *q, struct bio *bio)
 		return 0;
 	}
 
-	cpu = disk_stat_lock();
-	disk_stat_inc(cpu, mddev->gendisk, ios[rw]);
-	disk_stat_add(cpu, mddev->gendisk, sectors[rw], bio_sectors(bio));
-	disk_stat_unlock();
+	cpu = part_stat_lock();
+	part_stat_inc(cpu, &mddev->gendisk->part0, ios[rw]);
+	part_stat_add(cpu, &mddev->gendisk->part0, sectors[rw],
+		      bio_sectors(bio));
+	part_stat_unlock();
 
 	tmp_dev = which_dev(mddev, bio->bi_sector);
 	block = bio->bi_sector >> 1;
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 5d0cf63..607c302 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -5548,8 +5548,8 @@ static int is_mddev_idle(mddev_t *mddev)
 	rcu_read_lock();
 	rdev_for_each_rcu(rdev, mddev) {
 		struct gendisk *disk = rdev->bdev->bd_contains->bd_disk;
-		curr_events = disk_stat_read(disk, sectors[0]) + 
-				disk_stat_read(disk, sectors[1]) - 
+		curr_events = part_stat_read(&disk->part0, sectors[0]) +
+				part_stat_read(&disk->part0, sectors[1]) -
 				atomic_read(&disk->sync_io);
 		/* sync IO will cause sync_io to increase before the disk_stats
 		 * as sync_io is counted when a request starts, and
diff --git a/drivers/md/multipath.c b/drivers/md/multipath.c
index 182f5a9..8bb8794 100644
--- a/drivers/md/multipath.c
+++ b/drivers/md/multipath.c
@@ -159,10 +159,11 @@ static int multipath_make_request (struct request_queue *q, struct bio * bio)
 	mp_bh->master_bio = bio;
 	mp_bh->mddev = mddev;
 
-	cpu = disk_stat_lock();
-	disk_stat_inc(cpu, mddev->gendisk, ios[rw]);
-	disk_stat_add(cpu, mddev->gendisk, sectors[rw], bio_sectors(bio));
-	disk_stat_unlock();
+	cpu = part_stat_lock();
+	part_stat_inc(cpu, &mddev->gendisk->part0, ios[rw]);
+	part_stat_add(cpu, &mddev->gendisk->part0, sectors[rw],
+		      bio_sectors(bio));
+	part_stat_unlock();
 
 	mp_bh->path = multipath_map(conf);
 	if (mp_bh->path < 0) {
diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index e26030f..f52f442 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -406,10 +406,11 @@ static int raid0_make_request (struct request_queue *q, struct bio *bio)
 		return 0;
 	}
 
-	cpu = disk_stat_lock();
-	disk_stat_inc(cpu, mddev->gendisk, ios[rw]);
-	disk_stat_add(cpu, mddev->gendisk, sectors[rw], bio_sectors(bio));
-	disk_stat_unlock();
+	cpu = part_stat_lock();
+	part_stat_inc(cpu, &mddev->gendisk->part0, ios[rw]);
+	part_stat_add(cpu, &mddev->gendisk->part0, sectors[rw],
+		      bio_sectors(bio));
+	part_stat_unlock();
 
 	chunk_size = mddev->chunk_size >> 10;
 	chunk_sects = mddev->chunk_size >> 9;
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index babb130..b976442 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -804,10 +804,11 @@ static int make_request(struct request_queue *q, struct bio * bio)
 
 	bitmap = mddev->bitmap;
 
-	cpu = disk_stat_lock();
-	disk_stat_inc(cpu, mddev->gendisk, ios[rw]);
-	disk_stat_add(cpu, mddev->gendisk, sectors[rw], bio_sectors(bio));
-	disk_stat_unlock();
+	cpu = part_stat_lock();
+	part_stat_inc(cpu, &mddev->gendisk->part0, ios[rw]);
+	part_stat_add(cpu, &mddev->gendisk->part0, sectors[rw],
+		      bio_sectors(bio));
+	part_stat_unlock();
 
 	/*
 	 * make_request() can abort the operation when READA is being
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 5ec80da..5f99013 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -844,10 +844,11 @@ static int make_request(struct request_queue *q, struct bio * bio)
 	 */
 	wait_barrier(conf);
 
-	cpu = disk_stat_lock();
-	disk_stat_inc(cpu, mddev->gendisk, ios[rw]);
-	disk_stat_add(cpu, mddev->gendisk, sectors[rw], bio_sectors(bio));
-	disk_stat_unlock();
+	cpu = part_stat_lock();
+	part_stat_inc(cpu, &mddev->gendisk->part0, ios[rw]);
+	part_stat_add(cpu, &mddev->gendisk->part0, sectors[rw],
+		      bio_sectors(bio));
+	part_stat_unlock();
 
 	r10_bio = mempool_alloc(conf->r10bio_pool, GFP_NOIO);
 
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 5899f21..ae16794 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -3396,10 +3396,11 @@ static int make_request(struct request_queue *q, struct bio * bi)
 
 	md_write_start(mddev, bi);
 
-	cpu = disk_stat_lock();
-	disk_stat_inc(cpu, mddev->gendisk, ios[rw]);
-	disk_stat_add(cpu, mddev->gendisk, sectors[rw], bio_sectors(bi));
-	disk_stat_unlock();
+	cpu = part_stat_lock();
+	part_stat_inc(cpu, &mddev->gendisk->part0, ios[rw]);
+	part_stat_add(cpu, &mddev->gendisk->part0, sectors[rw],
+		      bio_sectors(bi));
+	part_stat_unlock();
 
 	if (rw == READ &&
 	     mddev->reshape_position == MaxSector &&
diff --git a/fs/partitions/check.c b/fs/partitions/check.c
index 88fcf5a..787dcd1 100644
--- a/fs/partitions/check.c
+++ b/fs/partitions/check.c
@@ -210,15 +210,15 @@ ssize_t part_size_show(struct device *dev,
 	return sprintf(buf, "%llu\n",(unsigned long long)p->nr_sects);
 }
 
-static ssize_t part_stat_show(struct device *dev,
-			      struct device_attribute *attr, char *buf)
+ssize_t part_stat_show(struct device *dev,
+		       struct device_attribute *attr, char *buf)
 {
 	struct hd_struct *p = dev_to_part(dev);
 	int cpu;
 
-	cpu = disk_stat_lock();
+	cpu = part_stat_lock();
 	part_round_stats(cpu, p);
-	disk_stat_unlock();
+	part_stat_unlock();
 	return sprintf(buf,
 		"%8lu %8lu %8llu %8u "
 		"%8lu %8lu %8llu %8u "
@@ -575,8 +575,8 @@ void del_gendisk(struct gendisk *disk)
 	set_capacity(disk, 0);
 	disk->flags &= ~GENHD_FL_UP;
 	unlink_gendisk(disk);
-	disk_stat_set_all(disk, 0);
-	disk->stamp = 0;
+	part_stat_set_all(&disk->part0, 0);
+	disk->part0.stamp = 0;
 
 	kobject_put(disk->part0.holder_dir);
 	kobject_put(disk->slave_dir);
diff --git a/include/linux/genhd.h b/include/linux/genhd.h
index 46d2a6f..e02b09d 100644
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -155,13 +155,6 @@ struct gendisk {
 	struct timer_rand_state *random;
 
 	atomic_t sync_io;		/* RAID */
-	unsigned long stamp;
-	int in_flight;
-#ifdef	CONFIG_SMP
-	struct disk_stats *dkstats;
-#else
-	struct disk_stats dkstats;
-#endif
 	struct work_struct async_notify;
 #ifdef  CONFIG_BLK_DEV_INTEGRITY
 	struct blk_integrity *integrity;
@@ -242,46 +235,18 @@ extern struct hd_struct *disk_map_sector_rcu(struct gendisk *disk,
  * internal use only.
  */
 #ifdef	CONFIG_SMP
-#define disk_stat_lock()	({ rcu_read_lock(); get_cpu(); })
-#define disk_stat_unlock()	do { put_cpu(); rcu_read_unlock(); } while (0)
-
-#define disk_stat_add(cpu, gendiskp, field, addnd)			\
-	(per_cpu_ptr(gendiskp->dkstats, cpu)->field += addnd)
-
-#define disk_stat_read(gendiskp, field)					\
-({									\
-	typeof(gendiskp->dkstats->field) res = 0;			\
-	int i;								\
-	for_each_possible_cpu(i)					\
-		res += per_cpu_ptr(gendiskp->dkstats, i)->field;	\
-	res;								\
-})
-
-static inline void disk_stat_set_all(struct gendisk *gendiskp, int value)
-{
-	int i;
-
-	for_each_possible_cpu(i)
-		memset(per_cpu_ptr(gendiskp->dkstats, i), value,
-				sizeof(struct disk_stats));
-}		
+#define part_stat_lock()	({ rcu_read_lock(); get_cpu(); })
+#define part_stat_unlock()	do { put_cpu(); rcu_read_unlock(); } while (0)
 
-#define part_stat_add(cpu, part, field, addnd)				\
-	(per_cpu_ptr(part->dkstats, cpu)->field += addnd)
-
-#define all_stat_add(cpu, gendiskp, part, field, addnd, sector)		\
-({									\
-	if (part)							\
-		part_stat_add(cpu, part, field, addnd);			\
-	disk_stat_add(cpu, gendiskp, field, addnd);			\
-})
+#define __part_stat_add(cpu, part, field, addnd)			\
+	(per_cpu_ptr((part)->dkstats, (cpu))->field += (addnd))
 
 #define part_stat_read(part, field)					\
 ({									\
-	typeof(part->dkstats->field) res = 0;				\
+	typeof((part)->dkstats->field) res = 0;				\
 	int i;								\
 	for_each_possible_cpu(i)					\
-		res += per_cpu_ptr(part->dkstats, i)->field;		\
+		res += per_cpu_ptr((part)->dkstats, i)->field;		\
 	res;								\
 })
 
@@ -294,109 +259,73 @@ static inline void part_stat_set_all(struct hd_struct *part, int value)
 				sizeof(struct disk_stats));
 }
 
-#else /* !CONFIG_SMP */
-#define disk_stat_lock()	({ rcu_read_lock(); 0; })
-#define disk_stat_unlock()	rcu_read_unlock()
-
-#define disk_stat_add(cpu, gendiskp, field, addnd)			\
-	(gendiskp->dkstats.field += addnd)
-#define disk_stat_read(gendiskp, field)	(gendiskp->dkstats.field)
-
-static inline void disk_stat_set_all(struct gendisk *gendiskp, int value)
+static inline int init_part_stats(struct hd_struct *part)
 {
-	memset(&gendiskp->dkstats, value, sizeof (struct disk_stats));
+	part->dkstats = alloc_percpu(struct disk_stats);
+	if (!part->dkstats)
+		return 0;
+	return 1;
 }
 
-#define part_stat_add(cpu, part, field, addnd)				\
-	(part->dkstats.field += addnd)
-
-#define all_stat_add(cpu, gendiskp, part, field, addnd, sector)		\
-({									\
-	if (part)							\
-		part_stat_add(cpu, part, field, addnd);			\
-	disk_stat_add(cpu, gendiskp, field, addnd);			\
-})
-
-#define part_stat_read(part, field)	(part->dkstats.field)
-
-static inline void part_stat_set_all(struct hd_struct *part, int value)
+static inline void free_part_stats(struct hd_struct *part)
 {
-	memset(&part->dkstats, value, sizeof(struct disk_stats));
+	free_percpu(part->dkstats);
 }
 
-#endif /* CONFIG_SMP */
-
-#define disk_stat_dec(cpu, gendiskp, field)				\
-	disk_stat_add(cpu, gendiskp, field, -1)
-#define disk_stat_inc(cpu, gendiskp, field)				\
-	disk_stat_add(cpu, gendiskp, field, 1)
-#define disk_stat_sub(cpu, gendiskp, field, subnd)			\
-	disk_stat_add(cpu, gendiskp, field, -subnd)
-
-#define part_stat_dec(cpu, gendiskp, field)				\
-	part_stat_add(cpu, gendiskp, field, -1)
-#define part_stat_inc(cpu, gendiskp, field)				\
-	part_stat_add(cpu, gendiskp, field, 1)
-#define part_stat_sub(cpu, gendiskp, field, subnd)			\
-	part_stat_add(cpu, gendiskp, field, -subnd)
+#else /* !CONFIG_SMP */
+#define part_stat_lock()	({ rcu_read_lock(); 0; })
+#define part_stat_unlock()	rcu_read_unlock()
 
-#define all_stat_dec(cpu, gendiskp, field, sector)			\
-	all_stat_add(cpu, gendiskp, field, -1, sector)
-#define all_stat_inc(cpu, gendiskp, part, field, sector)		\
-	all_stat_add(cpu, gendiskp, part, field, 1, sector)
-#define all_stat_sub(cpu, gendiskp, part, field, subnd, sector)		\
-	all_stat_add(cpu, gendiskp, part, field, -subnd, sector)
+#define __part_stat_add(cpu, part, field, addnd)				\
+	((part)->dkstats.field += addnd)
 
-/* Inlines to alloc and free disk stats in struct gendisk */
-#ifdef  CONFIG_SMP
-static inline int init_disk_stats(struct gendisk *disk)
-{
-	disk->dkstats = alloc_percpu(struct disk_stats);
-	if (!disk->dkstats)
-		return 0;
-	return 1;
-}
+#define part_stat_read(part, field)	((part)->dkstats.field)
 
-static inline void free_disk_stats(struct gendisk *disk)
+static inline void part_stat_set_all(struct hd_struct *part, int value)
 {
-	free_percpu(disk->dkstats);
+	memset(&part->dkstats, value, sizeof(struct disk_stats));
 }
 
 static inline int init_part_stats(struct hd_struct *part)
 {
-	part->dkstats = alloc_percpu(struct disk_stats);
-	if (!part->dkstats)
-		return 0;
 	return 1;
 }
 
 static inline void free_part_stats(struct hd_struct *part)
 {
-	free_percpu(part->dkstats);
 }
 
-#else	/* CONFIG_SMP */
-static inline int init_disk_stats(struct gendisk *disk)
-{
-	return 1;
-}
+#endif /* CONFIG_SMP */
 
-static inline void free_disk_stats(struct gendisk *disk)
-{
-}
+#define part_stat_add(cpu, part, field, addnd)	do {			\
+	__part_stat_add((cpu), (part), field, addnd);			\
+	if ((part)->partno)						\
+		__part_stat_add((cpu), &part_to_disk((part))->part0,	\
+				field, addnd);				\
+} while (0)
 
-static inline int init_part_stats(struct hd_struct *part)
+#define part_stat_dec(cpu, gendiskp, field)				\
+	part_stat_add(cpu, gendiskp, field, -1)
+#define part_stat_inc(cpu, gendiskp, field)				\
+	part_stat_add(cpu, gendiskp, field, 1)
+#define part_stat_sub(cpu, gendiskp, field, subnd)			\
+	part_stat_add(cpu, gendiskp, field, -subnd)
+
+static inline void part_inc_in_flight(struct hd_struct *part)
 {
-	return 1;
+	part->in_flight++;
+	if (part->partno)
+		part_to_disk(part)->part0.in_flight++;
 }
 
-static inline void free_part_stats(struct hd_struct *part)
+static inline void part_dec_in_flight(struct hd_struct *part)
 {
+	part->in_flight--;
+	if (part->partno)
+		part_to_disk(part)->part0.in_flight--;
 }
-#endif	/* CONFIG_SMP */
 
 /* drivers/block/ll_rw_blk.c */
-extern void disk_round_stats(int cpu, struct gendisk *disk);
 extern void part_round_stats(int cpu, struct hd_struct *part);
 
 /* drivers/block/genhd.c */
@@ -605,6 +534,8 @@ extern void blk_unregister_region(dev_t devt, unsigned long range);
 
 extern ssize_t part_size_show(struct device *dev,
 			      struct device_attribute *attr, char *buf);
+extern ssize_t part_stat_show(struct device *dev,
+			      struct device_attribute *attr, char *buf);
 #ifdef CONFIG_FAIL_MAKE_REQUEST
 extern ssize_t part_fail_show(struct device *dev,
 			      struct device_attribute *attr, char *buf);
-- 
1.5.4.5

