From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 10/13] block: move stats from disk to part0
Date: Mon, 14 Jul 2008 16:48:10 +0900
Message-ID: <1216021693-483-11-git-send-email-tj@kernel.org>
References: <1216021693-483-1-git-send-email-tj@kernel.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hera.kernel.org ([140.211.167.34]:38039 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756881AbYGNHuK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 14 Jul 2008 03:50:10 -0400
In-Reply-To: <1216021693-483-1-git-send-email-tj@kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jens.axboe@oracle.com, James.Bottomley@HansenPartnership.com, bharrosh@panasas.com, greg.freemyer@gmail.com, linux-scsi@vger.kernel.org, brking@linux.vnet.ibm.com, liml@rtr.ca, viro@f
Cc: Tejun Heo <tj@kernel.org>

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

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 block/blk-core.c           |   79 ++++++++----------------
 block/blk-merge.c          |    8 +--
 block/genhd.c              |   90 ++++++--------------------
 drivers/block/aoe/aoecmd.c |    8 +-
 drivers/md/dm.c            |   15 +++--
 drivers/md/linear.c        |    4 +-
 drivers/md/md.c            |    4 +-
 drivers/md/multipath.c     |    4 +-
 drivers/md/raid0.c         |    4 +-
 drivers/md/raid1.c         |    4 +-
 drivers/md/raid10.c        |    4 +-
 drivers/md/raid5.c         |    4 +-
 fs/partitions/check.c      |    8 +-
 include/linux/genhd.h      |  150 ++++++++++++-------------------------------
 14 files changed, 121 insertions(+), 265 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 332d695..d4186f3 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -64,14 +64,10 @@ static void drive_stat_acct(struct request *rq, int new_io)
 
 	part = disk_map_sector_rcu(rq->rq_disk, rq->sector);
 	if (!new_io)
-		all_stat_inc(rq->rq_disk, part, merges[rw], rq->sector);
+		part_stat_inc(part, merges[rw]);
 	else {
-		disk_round_stats(rq->rq_disk);
-		rq->rq_disk->in_flight++;
-		if (part) {
-			part_round_stats(part);
-			part->in_flight++;
-		}
+		part_round_stats(part);
+		part_inc_in_flight(part);
 	}
 
 	rcu_read_unlock_preempt();
@@ -966,8 +962,21 @@ static inline void add_request(struct request_queue *q, struct request *req)
 	__elv_add_request(q, req, ELEVATOR_INSERT_SORT, 0);
 }
 
+static void part_round_stats_single(struct hd_struct *part, unsigned long now)
+{
+	if (now == part->stamp)
+		return;
+
+	if (part->in_flight) {
+		__part_stat_add(part, time_in_queue,
+				part->in_flight * (now - part->stamp));
+		__part_stat_add(part, io_ticks, (now - part->stamp));
+	}
+	part->stamp = now;
+}
+
 /**
- * disk_round_stats()	- Round off the performance stats on a struct
+ * part_round_stats()	- Round off the performance stats on a struct
  * disk_stats.
  *
  * The average IO queue length and utilisation statistics are maintained
@@ -984,45 +993,15 @@ static inline void add_request(struct request_queue *q, struct request *req)
  * CONTEXT:
  * Preemption disabled.
  */
-void disk_round_stats(struct gendisk *disk)
-{
-	unsigned long now = jiffies;
-
-	if (now == disk->stamp)
-		return;
-
-	if (disk->in_flight) {
-		disk_stat_add(disk, time_in_queue,
-			      disk->in_flight * (now - disk->stamp));
-		disk_stat_add(disk, io_ticks, (now - disk->stamp));
-	}
-	disk->stamp = now;
-}
-EXPORT_SYMBOL_GPL(disk_round_stats);
-
-/**
- * part_round_stats()	- Round off the performance stats on a struct
- * disk_stats.
- *
- * Please see disk_round_stats() for more information.
- *
- * CONTEXT:
- * Preemption disabled.
- */
 void part_round_stats(struct hd_struct *part)
 {
 	unsigned long now = jiffies;
 
-	if (now == part->stamp)
-		return;
-
-	if (part->in_flight) {
-		part_stat_add(part, time_in_queue,
-			      part->in_flight * (now - part->stamp));
-		part_stat_add(part, io_ticks, (now - part->stamp));
-	}
-	part->stamp = now;
+	if (part->partno)
+		part_round_stats_single(&part_to_disk(part)->part0, now);
+	part_round_stats_single(part, now);
 }
+EXPORT_SYMBOL_GPL(part_round_stats);
 
 /*
  * queue lock must be held
@@ -1557,8 +1536,7 @@ static int __end_that_request_first(struct request *req, int error,
 
 		rcu_read_lock_preempt();
 		part = disk_map_sector_rcu(req->rq_disk, req->sector);
-		all_stat_add(req->rq_disk, part, sectors[rw],
-			     nr_bytes >> 9, req->sector);
+		part_stat_add(part, sectors[rw], nr_bytes >> 9);
 		rcu_read_unlock_preempt();
 	}
 
@@ -1748,15 +1726,10 @@ static void end_that_request_last(struct request *req, int error)
 		rcu_read_lock_preempt();
 
 		part = disk_map_sector_rcu(disk, req->sector);
-
-		all_stat_inc(disk, part, ios[rw], req->sector);
-		all_stat_add(disk, part, ticks[rw], duration, req->sector);
-		disk_round_stats(disk);
-		disk->in_flight--;
-		if (part) {
-			part_round_stats(part);
-			part->in_flight--;
-		}
+		part_stat_inc(part, ios[rw]);
+		part_stat_add(part, ticks[rw], duration);
+		part_round_stats(part);
+		part_dec_in_flight(part);
 
 		rcu_read_unlock_preempt();
 	}
diff --git a/block/blk-merge.c b/block/blk-merge.c
index 55456c8..a25a9f7 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -472,12 +472,8 @@ static int attempt_merge(struct request_queue *q, struct request *req,
 		rcu_read_lock_preempt();
 
 		part = disk_map_sector_rcu(req->rq_disk, req->sector);
-		disk_round_stats(req->rq_disk);
-		req->rq_disk->in_flight--;
-		if (part) {
-			part_round_stats(part);
-			part->in_flight--;
-		}
+		part_round_stats(part);
+		part_dec_in_flight(part);
 
 		rcu_read_unlock_preempt();
 	}
diff --git a/block/genhd.c b/block/genhd.c
index 21b8535..5d0f5d1 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -176,7 +176,7 @@ EXPORT_SYMBOL_GPL(disk_part_iter_stop);
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
 
@@ -575,24 +575,23 @@ void __init printk_all_partitions(void)
 		 * Note, unlike /proc/partitions, I am showing the numbers in
 		 * hex - the same format as the root= option takes.
 		 */
-		printk("%s %10llu %s",
-			bdevt_str(disk_devt(sgp), devt_buf),
-			(unsigned long long)get_capacity(sgp) >> 1,
-			disk_name(sgp, 0, name_buf));
-		if (sgp->driverfs_dev != NULL &&
-		    sgp->driverfs_dev->driver != NULL)
-			printk(" driver: %s\n",
-				sgp->driverfs_dev->driver->name);
-		else
-			printk(" (driver?)\n");
-
-		/* now show the partitions */
 		disk_part_iter_start(&piter, sgp, 0);
-		while ((part = disk_part_iter_next(&piter)))
-			printk("  %s %10llu %s\n",
+		while ((part = disk_part_iter_next(&piter))) {
+			bool is_part0 = part == &sgp->part0;
+
+			printk("%s%s %10llu %s\n", is_part0 ? "" : "  ",
 			       bdevt_str(part_devt(part), devt_buf),
 			       (unsigned long long)part->nr_sects >> 1,
 			       disk_name(sgp, part->partno, name_buf));
+			if (is_part0) {
+				if (sgp->driverfs_dev != NULL &&
+				    sgp->driverfs_dev->driver != NULL)
+					printk(" driver: %s\n",
+					       sgp->driverfs_dev->driver->name);
+				else
+					printk(" (driver?)\n");
+			}
+		}
 		disk_part_iter_stop(&piter);
 	}
 
@@ -653,12 +652,7 @@ static int show_partition(struct seq_file *seqf, void *v)
 		return 0;
 
 	/* show the full disk and all non-0 size partitions of it */
-	seq_printf(seqf, "%4d  %7d %10llu %s\n",
-		MAJOR(disk_devt(sgp)), MINOR(disk_devt(sgp)),
-		(unsigned long long)get_capacity(sgp) >> 1,
-		disk_name(sgp, 0, buf));
-
-	disk_part_iter_start(&piter, sgp, 0);
+	disk_part_iter_start(&piter, sgp, DISK_PITER_INCL_PART0);
 	while ((part = disk_part_iter_next(&piter)))
 		seq_printf(seqf, "%4d  %7d %10llu %s\n",
 			   MAJOR(part_devt(part)), MINOR(part_devt(part)),
@@ -736,38 +730,12 @@ static ssize_t disk_capability_show(struct device *dev,
 	return sprintf(buf, "%x\n", disk->flags);
 }
 
-static ssize_t disk_stat_show(struct device *dev,
-			      struct device_attribute *attr, char *buf)
-{
-	struct gendisk *disk = dev_to_disk(dev);
-
-	preempt_disable();
-	disk_round_stats(disk);
-	preempt_enable();
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
 static DEVICE_ATTR(size, S_IRUGO, part_size_show, NULL);
 static DEVICE_ATTR(capability, S_IRUGO, disk_capability_show, NULL);
-static DEVICE_ATTR(stat, S_IRUGO, disk_stat_show, NULL);
+static DEVICE_ATTR(stat, S_IRUGO, part_stat_show, NULL);
 #ifdef CONFIG_FAIL_MAKE_REQUEST
 static struct device_attribute dev_attr_fail =
 	__ATTR(make-it-fail, S_IRUGO|S_IWUSR, part_fail_show, part_fail_store);
@@ -801,7 +769,7 @@ static void disk_release(struct device *dev)
 
 	kfree(disk->random);
 	kfree(disk->__part);
-	free_disk_stats(disk);
+	free_part_stats(&disk->part0);
 	kfree(disk);
 }
 struct class block_class = {
@@ -872,24 +840,8 @@ static int diskstats_show(struct seq_file *seqf, void *v)
 				"\n\n");
 	*/
  
-	preempt_disable();
-	disk_round_stats(gp);
-	preempt_enable();
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
 	/* now show all non-0 size partitions of it */
-	disk_part_iter_start(&piter, gp, 0);
+	disk_part_iter_start(&piter, gp, DISK_PITER_INCL_PART0);
 	while ((hd = disk_part_iter_next(&piter))) {
 		preempt_disable();
 		part_round_stats(hd);
@@ -1000,7 +952,7 @@ struct gendisk *alloc_disk_ext_node(int minors, int ext_minors, int node_id)
 		int tot_minors = minors + ext_minors;
 		int size = tot_minors * sizeof(struct hd_struct *);
 
-		if (!init_disk_stats(disk)) {
+		if (!init_part_stats(&disk->part0)) {
 			kfree(disk);
 			return NULL;
 		}
@@ -1008,7 +960,7 @@ struct gendisk *alloc_disk_ext_node(int minors, int ext_minors, int node_id)
 		disk->__part = kmalloc_node(size, GFP_KERNEL | __GFP_ZERO,
 					    node_id);
 		if (!disk->__part) {
-			free_disk_stats(disk);
+				free_part_stats(&disk->part0);
 			kfree(disk);
 			return NULL;
 		}
diff --git a/drivers/block/aoe/aoecmd.c b/drivers/block/aoe/aoecmd.c
index b13e0b7..5dac67c 100644
--- a/drivers/block/aoe/aoecmd.c
+++ b/drivers/block/aoe/aoecmd.c
@@ -760,10 +760,10 @@ diskstats(struct gendisk *disk, struct bio *bio, ulong duration, sector_t sector
 	rcu_read_lock_preempt();
 
 	part = disk_map_sector_rcu(disk, sector);
-	all_stat_inc(disk, part, ios[rw], sector);
-	all_stat_add(disk, part, ticks[rw], duration, sector);
-	all_stat_add(disk, part, sectors[rw], n_sect, sector);
-	all_stat_add(disk, part, io_ticks, duration, sector);
+	part_stat_inc(part, ios[rw]);
+	part_stat_add(part, ticks[rw], duration);
+	part_stat_add(part, sectors[rw], n_sect);
+	part_stat_add(part, io_ticks, duration);
 
 	rcu_read_unlock_preempt();
 }
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 47d92be..75751ac 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -381,9 +381,9 @@ static void start_io_acct(struct dm_io *io)
 	io->start_time = jiffies;
 
 	preempt_disable();
-	disk_round_stats(dm_disk(md));
+	part_round_stats(&dm_disk(md)->part0);
 	preempt_enable();
-	dm_disk(md)->in_flight = atomic_inc_return(&md->pending);
+	dm_disk(md)->part0.in_flight = atomic_inc_return(&md->pending);
 }
 
 static int end_io_acct(struct dm_io *io)
@@ -395,11 +395,12 @@ static int end_io_acct(struct dm_io *io)
 	int rw = bio_data_dir(bio);
 
 	preempt_disable();
-	disk_round_stats(dm_disk(md));
-	disk_stat_add(dm_disk(md), ticks[rw], duration);
+	part_round_stats(&dm_disk(md)->part0);
+	part_stat_add(&dm_disk(md)->part0, ticks[rw], duration);
 	preempt_enable();
 
-	dm_disk(md)->in_flight = pending = atomic_dec_return(&md->pending);
+	dm_disk(md)->part0.in_flight = pending =
+		atomic_dec_return(&md->pending);
 
 	return !pending;
 }
@@ -851,8 +852,8 @@ static int dm_request(struct request_queue *q, struct bio *bio)
 	down_read(&md->io_lock);
 
 	preempt_disable();
-	disk_stat_inc(dm_disk(md), ios[rw]);
-	disk_stat_add(dm_disk(md), sectors[rw], bio_sectors(bio));
+	part_stat_inc(&dm_disk(md)->part0, ios[rw]);
+	part_stat_add(&dm_disk(md)->part0, sectors[rw], bio_sectors(bio));
 	preempt_enable();
 
 	/*
diff --git a/drivers/md/linear.c b/drivers/md/linear.c
index 7341196..0c01f5a 100644
--- a/drivers/md/linear.c
+++ b/drivers/md/linear.c
@@ -323,8 +323,8 @@ static int linear_make_request (struct request_queue *q, struct bio *bio)
 	}
 
 	preempt_disable();
-	disk_stat_inc(mddev->gendisk, ios[rw]);
-	disk_stat_add(mddev->gendisk, sectors[rw], bio_sectors(bio));
+	part_stat_inc(&mddev->gendisk->part0, ios[rw]);
+	part_stat_add(&mddev->gendisk->part0, sectors[rw], bio_sectors(bio));
 	preempt_enable();
 
 	tmp_dev = which_dev(mddev, bio->bi_sector);
diff --git a/drivers/md/md.c b/drivers/md/md.c
index cff446f..ac85e47 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -5395,8 +5395,8 @@ static int is_mddev_idle(mddev_t *mddev)
 	idle = 1;
 	rdev_for_each(rdev, tmp, mddev) {
 		struct gendisk *disk = rdev->bdev->bd_contains->bd_disk;
-		curr_events = disk_stat_read(disk, sectors[0]) + 
-				disk_stat_read(disk, sectors[1]) - 
+		curr_events = part_stat_read(&disk->part0, sectors[0]) +
+				part_stat_read(&disk->part0, sectors[1]) -
 				atomic_read(&disk->sync_io);
 		/* sync IO will cause sync_io to increase before the disk_stats
 		 * as sync_io is counted when a request starts, and
diff --git a/drivers/md/multipath.c b/drivers/md/multipath.c
index 5db0a45..30d1c20 100644
--- a/drivers/md/multipath.c
+++ b/drivers/md/multipath.c
@@ -159,8 +159,8 @@ static int multipath_make_request (struct request_queue *q, struct bio * bio)
 	mp_bh->mddev = mddev;
 
 	preempt_disable();
-	disk_stat_inc(mddev->gendisk, ios[rw]);
-	disk_stat_add(mddev->gendisk, sectors[rw], bio_sectors(bio));
+	part_stat_inc(&mddev->gendisk->part0, ios[rw]);
+	part_stat_add(&mddev->gendisk->part0, sectors[rw], bio_sectors(bio));
 	preempt_enable();
 
 	mp_bh->path = multipath_map(conf);
diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index 2602b05..f7e08bc 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -404,8 +404,8 @@ static int raid0_make_request (struct request_queue *q, struct bio *bio)
 	}
 
 	preempt_disable();
-	disk_stat_inc(mddev->gendisk, ios[rw]);
-	disk_stat_add(mddev->gendisk, sectors[rw], bio_sectors(bio));
+	part_stat_inc(&mddev->gendisk->part0, ios[rw]);
+	part_stat_add(&mddev->gendisk->part0, sectors[rw], bio_sectors(bio));
 	preempt_enable();
 
 	chunk_size = mddev->chunk_size >> 10;
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 1fd2c3d..8ff3aaa 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -805,8 +805,8 @@ static int make_request(struct request_queue *q, struct bio * bio)
 	bitmap = mddev->bitmap;
 
 	preempt_disable();
-	disk_stat_inc(mddev->gendisk, ios[rw]);
-	disk_stat_add(mddev->gendisk, sectors[rw], bio_sectors(bio));
+	part_stat_inc(&mddev->gendisk->part0, ios[rw]);
+	part_stat_add(&mddev->gendisk->part0, sectors[rw], bio_sectors(bio));
 	preempt_enable();
 
 	/*
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 2521b73..735c167 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -839,8 +839,8 @@ static int make_request(struct request_queue *q, struct bio * bio)
 	wait_barrier(conf);
 
 	preempt_disable();
-	disk_stat_inc(mddev->gendisk, ios[rw]);
-	disk_stat_add(mddev->gendisk, sectors[rw], bio_sectors(bio));
+	part_stat_inc(&mddev->gendisk->part0, ios[rw]);
+	part_stat_add(&mddev->gendisk->part0, sectors[rw], bio_sectors(bio));
 	preempt_enable();
 
 	r10_bio = mempool_alloc(conf->r10bio_pool, GFP_NOIO);
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index bfd8b6c..8131245 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -3581,8 +3581,8 @@ static int make_request(struct request_queue *q, struct bio * bi)
 	md_write_start(mddev, bi);
 
 	preempt_disable();
-	disk_stat_inc(mddev->gendisk, ios[rw]);
-	disk_stat_add(mddev->gendisk, sectors[rw], bio_sectors(bi));
+	part_stat_inc(&mddev->gendisk->part0, ios[rw]);
+	part_stat_add(&mddev->gendisk->part0, sectors[rw], bio_sectors(bi));
 	preempt_enable();
 
 	if (rw == READ &&
diff --git a/fs/partitions/check.c b/fs/partitions/check.c
index ddd0258..e4d4d5c 100644
--- a/fs/partitions/check.c
+++ b/fs/partitions/check.c
@@ -210,8 +210,8 @@ ssize_t part_size_show(struct device *dev,
 	return sprintf(buf, "%llu\n",(unsigned long long)p->nr_sects);
 }
 
-static ssize_t part_stat_show(struct device *dev,
-			      struct device_attribute *attr, char *buf)
+ssize_t part_stat_show(struct device *dev,
+		       struct device_attribute *attr, char *buf)
 {
 	struct hd_struct *p = dev_to_part(dev);
 
@@ -574,8 +574,8 @@ void del_gendisk(struct gendisk *disk)
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
index 61448a9..d5d2ef9 100644
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -145,13 +145,6 @@ struct gendisk {
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
 };
 
@@ -220,50 +213,23 @@ extern struct hd_struct *disk_map_sector_rcu(struct gendisk *disk,
  * Macros to to operate on disk statistics:
  *
  * {disk|part|all}_stat_{add|sub|inc|dec}() modify the stat counters
- * and should be called with preemption disabled.
+ * {part|all}_stat_{add|sub|inc|dec}() modify the stat counters
  *
- * {part|disk}_stat_read() can be called with preemption enabled.
+ * part_stat_read() can be called with preemption enabled.
  *
- * {part|disk}_stat_set_all() are for internal use only.
+ * part_stat_{add|set_all}() and {init|free}_part_stats are for
+ * internal use only.
  */
 #ifdef	CONFIG_SMP
-#define disk_stat_add(gendiskp, field, addnd)				\
-	(per_cpu_ptr(gendiskp->dkstats, smp_processor_id())->field += addnd)
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
-
-#define part_stat_add(part, field, addnd)				\
-	(per_cpu_ptr(part->dkstats, smp_processor_id())->field += addnd)
-
-#define all_stat_add(gendiskp, part, field, addnd, sector)	\
-({								\
-	if (part)						\
-		part_stat_add(part, field, addnd);		\
-	disk_stat_add(gendiskp, field, addnd);			\
-})
+#define __part_stat_add(part, field, addnd)				\
+	(per_cpu_ptr((part)->dkstats, smp_processor_id())->field += (addnd))
 
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
 
@@ -276,102 +242,68 @@ static inline void part_stat_set_all(struct hd_struct *part, int value)
 				sizeof(struct disk_stats));
 }
 				
-#else /* !CONFIG_SMP */
-#define disk_stat_add(gendiskp, field, addnd) \
-				(gendiskp->dkstats.field += addnd)
-#define disk_stat_read(gendiskp, field)	(gendiskp->dkstats.field)
+static inline int init_part_stats(struct hd_struct *part)
+{
+	part->dkstats = alloc_percpu(struct disk_stats);
+	if (!part->dkstats)
+		return 0;
+	return 1;
+}
 
-static inline void disk_stat_set_all(struct gendisk *gendiskp, int value)
+static inline void free_part_stats(struct hd_struct *part)
 {
-	memset(&gendiskp->dkstats, value, sizeof (struct disk_stats));
+	free_percpu(part->dkstats);
 }
 
-#define part_stat_add(part, field, addnd) \
-	(part->dkstats.field += addnd)
+#else /* !CONFIG_SMP */
 
-#define all_stat_add(gendiskp, part, field, addnd, sector)	\
-({								\
-	if (part)						\
-		part->dkstats.field += addnd;			\
-	disk_stat_add(gendiskp, field, addnd);			\
-})
+#define __part_stat_add(part, field, addnd)				\
+	((part)->dkstats.field += (addnd))
 
-#define part_stat_read(part, field)	(part->dkstats.field)
+#define part_stat_read(part, field)	((part)->dkstats.field)
 
 static inline void part_stat_set_all(struct hd_struct *part, int value)
 {
 	memset(&part->dkstats, value, sizeof(struct disk_stats));
 }
 
-#endif /* CONFIG_SMP */
-
-#define disk_stat_dec(gendiskp, field) disk_stat_add(gendiskp, field, -1)
-#define disk_stat_inc(gendiskp, field) disk_stat_add(gendiskp, field, 1)
-#define disk_stat_sub(gendiskp, field, subnd) \
-		disk_stat_add(gendiskp, field, -subnd)
-
-#define part_stat_dec(gendiskp, field) part_stat_add(gendiskp, field, -1)
-#define part_stat_inc(gendiskp, field) part_stat_add(gendiskp, field, 1)
-#define part_stat_sub(gendiskp, field, subnd) \
-		part_stat_add(gendiskp, field, -subnd)
-
-#define all_stat_dec(gendiskp, field, sector) \
-		all_stat_add(gendiskp, field, -1, sector)
-#define all_stat_inc(gendiskp, part, field, sector) \
-		all_stat_add(gendiskp, part, field, 1, sector)
-#define all_stat_sub(gendiskp, part, field, subnd, sector) \
-		all_stat_add(gendiskp, part, field, -subnd, sector)
-
-/* Inlines to alloc and free disk stats in struct gendisk */
-#ifdef  CONFIG_SMP
-static inline int init_disk_stats(struct gendisk *disk)
-{
-	disk->dkstats = alloc_percpu(struct disk_stats);
-	if (!disk->dkstats)
-		return 0;
-	return 1;
-}
-
-static inline void free_disk_stats(struct gendisk *disk)
-{
-	free_percpu(disk->dkstats);
-}
-
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
+#define part_stat_add(part, field, addnd)				\
+({									\
+	__part_stat_add((part), field, addnd);				\
+	if ((part)->partno)						\
+		__part_stat_add(&part_to_disk((part))->part0, field, addnd); \
+})
 
-static inline int init_part_stats(struct hd_struct *part)
+#define part_stat_dec(part, field) part_stat_add((part), field, -1)
+#define part_stat_inc(part, field) part_stat_add((part), field, 1)
+#define part_stat_sub(part, field, subnd) part_stat_add((part), field, -subnd)
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
-extern void disk_round_stats(struct gendisk *disk);
 extern void part_round_stats(struct hd_struct *part);
 
 /* drivers/block/genhd.c */
@@ -580,6 +512,8 @@ extern void blk_unregister_region(dev_t devt, unsigned long range);
 
 extern ssize_t part_size_show(struct device *dev,
 			      struct device_attribute *attr, char *buf);
+extern ssize_t part_stat_show(struct device *dev,
+			      struct device_attribute *attr, char *buf);
 #ifdef CONFIG_FAIL_MAKE_REQUEST
 extern ssize_t part_fail_show(struct device *dev,
 			      struct device_attribute *attr, char *buf);
-- 
1.5.4.5

