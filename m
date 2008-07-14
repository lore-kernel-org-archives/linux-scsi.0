From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 04/10] block: fix disk->part[] dereferencing race
Date: Mon, 14 Jul 2008 16:12:08 +0900
Message-ID: <1216019534-29977-5-git-send-email-tj@kernel.org>
References: <1216019534-29977-1-git-send-email-tj@kernel.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hera.kernel.org ([140.211.167.34]:60090 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755760AbYGNHNi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 14 Jul 2008 03:13:38 -0400
In-Reply-To: <1216019534-29977-1-git-send-email-tj@kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jens.axboe@oracle.com, James.Bottomley@HansenPartnership.com, bharrosh@panasas.com, greg.freemyer@gmail.com, linux-scsi@vger.kernel.org, brking@linux.vnet.ibm.com, liml@rtr.ca, viro@f
Cc: Tejun Heo <tj@kernel.org>

disk->part[] is protected by its matching bdev's lock.  However,
non-critical accesses like collecting stats and printing out sysfs and
proc information used to be performed without any locking.  As
partitions can come and go dynamically, partitions can go away
underneath those non-critical accesses.  As some of those accesses are
writes, this theoretically can lead to silent corruption.

This patch fixes the race by using RCU for the partition array and dev
reference counter to hold partitions.

* Rename disk->part[] to disk->__part[] to make sure no one outside
  genhd layer proper accesses it directly.

* Use RCU for disk->__part[] dereferencing.

* Implement disk_{get|put}_part() which can be used to get and put
  partitions from gendisk respectively.

* Iterators are implemented to help iterate through all partitions
  safely.

* Functions which require RCU readlock are marked with _rcu suffix.

* Use disk_put_part() in __blkdev_put() instead of directly putting
  the contained kobject.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 block/blk-core.c           |   20 +++-
 block/blk-merge.c          |    9 ++-
 block/genhd.c              |  219 +++++++++++++++++++++++++++++++++++++-------
 block/ioctl.c              |   26 +++--
 drivers/block/aoe/aoecmd.c |    6 +-
 fs/block_dev.c             |   15 ++--
 fs/partitions/check.c      |   69 +++++++++-----
 include/linux/genhd.h      |   53 ++++++++---
 8 files changed, 322 insertions(+), 95 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index bc832aa..84292e1 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -60,7 +60,9 @@ static void drive_stat_acct(struct request *rq, int new_io)
 	if (!blk_fs_request(rq) || !rq->rq_disk)
 		return;
 
-	part = disk_map_sector(rq->rq_disk, rq->sector);
+	rcu_read_lock();
+
+	part = disk_map_sector_rcu(rq->rq_disk, rq->sector);
 	if (!new_io)
 		__all_stat_inc(rq->rq_disk, part, merges[rw], rq->sector);
 	else {
@@ -71,6 +73,8 @@ static void drive_stat_acct(struct request *rq, int new_io)
 			part->in_flight++;
 		}
 	}
+
+	rcu_read_unlock();
 }
 
 void blk_queue_congestion_threshold(struct request_queue *q)
@@ -1535,12 +1539,14 @@ static int __end_that_request_first(struct request *req, int error,
 	}
 
 	if (blk_fs_request(req) && req->rq_disk) {
-		struct hd_struct *part =
-			disk_map_sector(req->rq_disk, req->sector);
 		const int rw = rq_data_dir(req);
+		struct hd_struct *part;
 
+		rcu_read_lock();
+		part = disk_map_sector_rcu(req->rq_disk, req->sector);
 		all_stat_add(req->rq_disk, part, sectors[rw],
 				nr_bytes >> 9, req->sector);
+		rcu_read_unlock();
 	}
 
 	total_bytes = bio_nbytes = 0;
@@ -1724,7 +1730,11 @@ static void end_that_request_last(struct request *req, int error)
 	if (disk && blk_fs_request(req) && req != &req->q->bar_rq) {
 		unsigned long duration = jiffies - req->start_time;
 		const int rw = rq_data_dir(req);
-		struct hd_struct *part = disk_map_sector(disk, req->sector);
+		struct hd_struct *part;
+
+		rcu_read_lock();
+
+		part = disk_map_sector_rcu(disk, req->sector);
 
 		__all_stat_inc(disk, part, ios[rw], req->sector);
 		__all_stat_add(disk, part, ticks[rw], duration, req->sector);
@@ -1734,6 +1744,8 @@ static void end_that_request_last(struct request *req, int error)
 			part_round_stats(part);
 			part->in_flight--;
 		}
+
+		rcu_read_unlock();
 	}
 
 	if (req->end_io)
diff --git a/block/blk-merge.c b/block/blk-merge.c
index e96d87d..9be9b2f 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -467,14 +467,19 @@ static int attempt_merge(struct request_queue *q, struct request *req,
 	elv_merge_requests(q, req, next);
 
 	if (req->rq_disk) {
-		struct hd_struct *part =
-			disk_map_sector(req->rq_disk, req->sector);
+		struct hd_struct *part;
+
+		rcu_read_lock();
+
+		part = disk_map_sector_rcu(req->rq_disk, req->sector);
 		disk_round_stats(req->rq_disk);
 		req->rq_disk->in_flight--;
 		if (part) {
 			part_round_stats(part);
 			part->in_flight--;
 		}
+
+		rcu_read_unlock();
 	}
 
 	req->ioprio = ioprio_best(req->ioprio, next->ioprio);
diff --git a/block/genhd.c b/block/genhd.c
index 1212acd..76961be 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -26,6 +26,158 @@ struct kobject *block_depr;
 
 static struct device_type disk_type;
 
+/**
+ * disk_get_part - get partition
+ * @disk: disk to look partition from
+ * @partno: partition number
+ *
+ * Look for partition @partno from @disk.  If found, increment
+ * reference count and return it.
+ *
+ * CONTEXT:
+ * Don't care.
+ *
+ * RETURNS:
+ * Pointer to the found partition on success, NULL if not found.
+ */
+struct hd_struct *disk_get_part(struct gendisk *disk, int partno)
+{
+	struct hd_struct *part;
+
+	if (unlikely(partno < 1 || partno > disk_max_parts(disk)))
+		return NULL;
+	rcu_read_lock();
+	part = rcu_dereference(disk->__part[partno - 1]);
+	if (part)
+		get_device(&part->dev);
+	rcu_read_unlock();
+
+	return part;
+}
+EXPORT_SYMBOL_GPL(disk_get_part);
+
+/**
+ * disk_part_iter_start - initialize partition iterator
+ * @piter: iterator to initialize
+ * @disk: disk to iterate over
+ * @flags: DISK_PITER_* flags
+ *
+ * Initialize @piter so that it iterates over partitions of @disk.
+ *
+ * CONTEXT:
+ * Don't care.
+ */
+void disk_part_iter_start(struct disk_part_iter *piter, struct gendisk *disk,
+			  unsigned int flags)
+{
+	piter->disk = disk;
+	piter->part = NULL;
+
+	if (flags & DISK_PITER_REVERSE)
+		piter->idx = disk_max_parts(piter->disk) - 1;
+	else
+		piter->idx = 0;
+
+	piter->flags = flags;
+}
+EXPORT_SYMBOL_GPL(disk_part_iter_start);
+
+/**
+ * disk_part_iter_next - proceed iterator to the next partition and return it
+ * @piter: iterator of interest
+ *
+ * Proceed @piter to the next partition and return it.
+ *
+ * CONTEXT:
+ * Don't care.
+ */
+struct hd_struct *disk_part_iter_next(struct disk_part_iter *piter)
+{
+	int inc, end;
+
+	/* put the last partition */
+	disk_put_part(piter->part);
+	piter->part = NULL;
+
+	rcu_read_lock();
+
+	/* determine iteration parameters */
+	if (piter->flags & DISK_PITER_REVERSE) {
+		inc = -1;
+		end = -1;
+	} else {
+		inc = 1;
+		end = disk_max_parts(piter->disk);
+	}
+
+	/* iterate to the next partition */
+	for (; piter->idx != end; piter->idx += inc) {
+		struct hd_struct *part;
+
+		part = rcu_dereference(piter->disk->__part[piter->idx]);
+		if (!part)
+			continue;
+		if (!(piter->flags & DISK_PITER_INCL_EMPTY) && !part->nr_sects)
+			continue;
+
+		get_device(&part->dev);
+		piter->part = part;
+		piter->idx++;
+		break;
+	}
+
+	rcu_read_unlock();
+
+	return piter->part;
+}
+EXPORT_SYMBOL_GPL(disk_part_iter_next);
+
+/**
+ * disk_part_iter_stop - finish up partition iteration
+ * @piter: iter of interest
+ *
+ * Called when iteration is over.  Cleans up @piter.
+ *
+ * CONTEXT:
+ * Don't care.
+ */
+void disk_part_iter_stop(struct disk_part_iter *piter)
+{
+	disk_put_part(piter->part);
+	piter->part = NULL;
+}
+EXPORT_SYMBOL_GPL(disk_part_iter_stop);
+
+/**
+ * disk_map_sector_rcu - map sector to partition
+ * @disk: gendisk of interest
+ * @sector: sector to map
+ *
+ * Find out which partition @sector maps to on @disk.  This is
+ * primarily used for stats accounting.
+ *
+ * CONTEXT:
+ * RCU read locked.  The returned partition pointer is valid only
+ * while preemption is disabled.
+ *
+ * RETURNS:
+ * Found partition on success, NULL if there's no matching partition.
+ */
+struct hd_struct *disk_map_sector_rcu(struct gendisk *disk, sector_t sector)
+{
+	int i;
+
+	for (i = 0; i < disk_max_parts(disk); i++) {
+		struct hd_struct *part = rcu_dereference(disk->__part[i]);
+
+		if (part && part->start_sect <= sector &&
+		    sector < part->start_sect + part->nr_sects)
+			return part;
+	}
+	return NULL;
+}
+EXPORT_SYMBOL_GPL(disk_map_sector_rcu);
+
 /*
  * Can be deleted altogether. Later.
  *
@@ -242,10 +394,12 @@ extern struct block_device *bdget_disk(struct gendisk *disk, int partno)
 	if (partno == 0)
 		devt = disk_devt(disk);
 	else {
-		struct hd_struct *part = disk->part[partno - 1];
+		struct hd_struct *part;
 
+		part = disk_get_part(disk, partno);
 		if (part && part->nr_sects)
 			devt = part_devt(part);
+		disk_put_part(part);
 	}
 
 	if (likely(devt != MKDEV(0, 0)))
@@ -263,8 +417,9 @@ void __init printk_all_partitions(void)
 {
 	struct device *dev;
 	struct gendisk *sgp;
+	struct disk_part_iter piter;
+	struct hd_struct *part;
 	char buf[BDEVNAME_SIZE];
-	int n;
 
 	down(&block_class.sem);
 	/* For each block device... */
@@ -295,17 +450,13 @@ void __init printk_all_partitions(void)
 			printk(" (driver?)\n");
 
 		/* now show the partitions */
-		for (n = 0; n < disk_max_parts(sgp); ++n) {
-			struct hd_struct *part = sgp->part[n];
-
-			if (!part || !part->nr_sects)
-				continue;
-
+		disk_part_iter_start(&piter, sgp, 0);
+		while ((part = disk_part_iter_next(&piter)))
 			printk("  %02x%02x %10llu %s\n",
 			       MAJOR(part_devt(part)), MINOR(part_devt(part)),
 			       (unsigned long long)part->nr_sects >> 1,
 			       disk_name(sgp, part->partno, buf));
-		}
+		disk_part_iter_stop(&piter);
 	}
 
 	up(&block_class.sem);
@@ -350,7 +501,8 @@ static void part_stop(struct seq_file *seqf, void *v)
 static int show_partition(struct seq_file *seqf, void *v)
 {
 	struct gendisk *sgp = v;
-	int n;
+	struct disk_part_iter piter;
+	struct hd_struct *part;
 	char buf[BDEVNAME_SIZE];
 
 	if (&sgp->dev.node == block_class.devices.next)
@@ -368,17 +520,14 @@ static int show_partition(struct seq_file *seqf, void *v)
 		MAJOR(disk_devt(sgp)), MINOR(disk_devt(sgp)),
 		(unsigned long long)get_capacity(sgp) >> 1,
 		disk_name(sgp, 0, buf));
-	for (n = 0; n < disk_max_parts(sgp); n++) {
-		struct hd_struct *part = sgp->part[n];
-		if (!part)
-			continue;
-		if (part->nr_sects == 0)
-			continue;
+
+	disk_part_iter_start(&piter, sgp, 0);
+	while ((part = disk_part_iter_next(&piter)))
 		seq_printf(seqf, "%4d  %4d %10llu %s\n",
 			   MAJOR(part_devt(part)), MINOR(part_devt(part)),
 			   (unsigned long long)part->nr_sects >> 1,
 			   disk_name(sgp, part->partno, buf));
-	}
+	disk_part_iter_stop(&piter);
 
 	return 0;
 }
@@ -540,7 +689,7 @@ static void disk_release(struct device *dev)
 	struct gendisk *disk = dev_to_disk(dev);
 
 	kfree(disk->random);
-	kfree(disk->part);
+	kfree(disk->__part);
 	free_disk_stats(disk);
 	kfree(disk);
 }
@@ -600,8 +749,9 @@ static void diskstats_stop(struct seq_file *seqf, void *v)
 static int diskstats_show(struct seq_file *seqf, void *v)
 {
 	struct gendisk *gp = v;
+	struct disk_part_iter piter;
+	struct hd_struct *hd;
 	char buf[BDEVNAME_SIZE];
-	int n;
 
 	/*
 	if (&gp->dev.kobj.entry == block_class.devices.next)
@@ -628,12 +778,8 @@ static int diskstats_show(struct seq_file *seqf, void *v)
 		jiffies_to_msecs(disk_stat_read(gp, time_in_queue)));
 
 	/* now show all non-0 size partitions of it */
-	for (n = 0; n < disk_max_parts(gp); n++) {
-		struct hd_struct *hd = gp->part[n];
-
-		if (!hd || !hd->nr_sects)
-			continue;
-
+	disk_part_iter_start(&piter, gp, 0);
+	while ((hd = disk_part_iter_next(&piter))) {
 		preempt_disable();
 		part_round_stats(hd);
 		preempt_enable();
@@ -654,6 +800,7 @@ static int diskstats_show(struct seq_file *seqf, void *v)
 			   jiffies_to_msecs(part_stat_read(hd, time_in_queue))
 			);
 	}
+	disk_part_iter_stop(&piter);
  
 	return 0;
 }
@@ -707,12 +854,16 @@ dev_t blk_lookup_devt(const char *name, int partno)
 		if (partno == 0)
 			devt = disk_devt(disk);
 		else {
-			struct hd_struct *part = disk->part[partno - 1];
+			struct hd_struct *part;
 
-			if (!part || !part->nr_sects)
+			part = disk_get_part(disk, partno);
+			if (!part || !part->nr_sects) {
+				disk_put_part(part);
 				continue;
+			}
 
 			devt = part_devt(part);
+			disk_put_part(part);
 		}
 		break;
 	}
@@ -740,9 +891,9 @@ struct gendisk *alloc_disk_node(int minors, int node_id)
 		}
 		if (minors > 1) {
 			int size = (minors - 1) * sizeof(struct hd_struct *);
-			disk->part = kmalloc_node(size,
+			disk->__part = kmalloc_node(size,
 				GFP_KERNEL | __GFP_ZERO, node_id);
-			if (!disk->part) {
+			if (!disk->__part) {
 				free_disk_stats(disk);
 				kfree(disk);
 				return NULL;
@@ -803,10 +954,14 @@ EXPORT_SYMBOL(set_device_ro);
 
 void set_disk_ro(struct gendisk *disk, int flag)
 {
-	int i;
+	struct disk_part_iter piter;
+	struct hd_struct *part;
+
 	disk->policy = flag;
-	for (i = 0; i < disk_max_parts(disk); i++)
-		if (disk->part[i]) disk->part[i]->policy = flag;
+	disk_part_iter_start(&piter, disk, DISK_PITER_INCL_EMPTY);
+	while ((part = disk_part_iter_next(&piter)))
+		part->policy = flag;
+	disk_part_iter_stop(&piter);
 }
 
 EXPORT_SYMBOL(set_disk_ro);
diff --git a/block/ioctl.c b/block/ioctl.c
index e922895..75aeead 100644
--- a/block/ioctl.c
+++ b/block/ioctl.c
@@ -12,11 +12,13 @@ static int blkpg_ioctl(struct block_device *bdev, struct blkpg_ioctl_arg __user
 {
 	struct block_device *bdevp;
 	struct gendisk *disk;
+	struct hd_struct *part;
 	struct blkpg_ioctl_arg a;
 	struct blkpg_partition p;
+	struct disk_part_iter piter;
 	long long start, length;
 	int partno;
-	int i, rc;
+	int rc;
 
 	if (!capable(CAP_SYS_ADMIN))
 		return -EACCES;
@@ -46,17 +48,17 @@ static int blkpg_ioctl(struct block_device *bdev, struct blkpg_ioctl_arg __user
 			mutex_lock(&bdev->bd_mutex);
 
 			/* overlap? */
-			for (i = 0; i < disk_max_parts(disk); i++) {
-				struct hd_struct *s = disk->part[i];
-
-				if (!s)
-					continue;
-				if (!(start+length <= s->start_sect ||
-				      start >= s->start_sect + s->nr_sects)) {
+			disk_part_iter_start(&piter, disk,
+					     DISK_PITER_INCL_EMPTY);
+			while ((part = disk_part_iter_next(&piter))) {
+				if (!(start + length <= part->start_sect ||
+				      start >= part->start_sect + part->nr_sects)) {
+					disk_part_iter_stop(&piter);
 					mutex_unlock(&bdev->bd_mutex);
 					return -EBUSY;
 				}
 			}
+			disk_part_iter_stop(&piter);
 
 			/* all seems OK */
 			rc = add_partition(disk, partno, start, length,
@@ -66,11 +68,15 @@ static int blkpg_ioctl(struct block_device *bdev, struct blkpg_ioctl_arg __user
 			return rc;
 
 		case BLKPG_DEL_PARTITION:
-			if (!disk->part[partno - 1])
+			part = disk_get_part(disk, partno);
+			if (!part)
 				return -ENXIO;
-			bdevp = bdget_disk(disk, partno);
+
+			bdevp = bdget(part_devt(part));
+			disk_put_part(part);
 			if (!bdevp)
 				return -ENOMEM;
+
 			mutex_lock(&bdevp->bd_mutex);
 			if (bdevp->bd_openers) {
 				mutex_unlock(&bdevp->bd_mutex);
diff --git a/drivers/block/aoe/aoecmd.c b/drivers/block/aoe/aoecmd.c
index ba40473..50ef9ea 100644
--- a/drivers/block/aoe/aoecmd.c
+++ b/drivers/block/aoe/aoecmd.c
@@ -757,11 +757,15 @@ diskstats(struct gendisk *disk, struct bio *bio, ulong duration, sector_t sector
 	const int rw = bio_data_dir(bio);
 	struct hd_struct *part;
 
-	part = disk_map_sector(disk, sector);
+	rcu_read_lock();
+
+	part = disk_map_sector_rcu(disk, sector);
 	all_stat_inc(disk, part, ios[rw], sector);
 	all_stat_add(disk, part, ticks[rw], duration, sector);
 	all_stat_add(disk, part, sectors[rw], n_sect, sector);
 	all_stat_add(disk, part, io_ticks, duration, sector);
+
+	rcu_read_unlock();
 }
 
 void
diff --git a/fs/block_dev.c b/fs/block_dev.c
index 7d00b22..5d38203 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -929,6 +929,7 @@ static int do_open(struct block_device *bdev, struct file *file, int for_part)
 {
 	struct module *owner = NULL;
 	struct gendisk *disk;
+	struct hd_struct *part = NULL;
 	int ret;
 	int partno;
 	int perm = 0;
@@ -976,7 +977,6 @@ static int do_open(struct block_device *bdev, struct file *file, int for_part)
 			if (bdev->bd_invalidated)
 				rescan_partitions(disk, bdev);
 		} else {
-			struct hd_struct *p;
 			struct block_device *whole;
 			whole = bdget_disk(disk, 0);
 			ret = -ENOMEM;
@@ -987,16 +987,16 @@ static int do_open(struct block_device *bdev, struct file *file, int for_part)
 			if (ret)
 				goto out_first;
 			bdev->bd_contains = whole;
-			p = disk->part[partno - 1];
+			part = disk_get_part(disk, partno);
 			bdev->bd_inode->i_data.backing_dev_info =
 			   whole->bd_inode->i_data.backing_dev_info;
-			if (!(disk->flags & GENHD_FL_UP) || !p || !p->nr_sects) {
+			if (!(disk->flags & GENHD_FL_UP) ||
+			    !part || !part->nr_sects) {
 				ret = -ENXIO;
 				goto out_first;
 			}
-			kobject_get(&p->dev.kobj);
-			bdev->bd_part = p;
-			bd_set_size(bdev, (loff_t) p->nr_sects << 9);
+			bdev->bd_part = part;
+			bd_set_size(bdev, (loff_t)part->nr_sects << 9);
 		}
 	} else {
 		put_disk(disk);
@@ -1025,6 +1025,7 @@ out_first:
 		__blkdev_put(bdev->bd_contains, 1);
 	bdev->bd_contains = NULL;
 	put_disk(disk);
+	disk_put_part(part);
 	module_put(owner);
 out:
 	mutex_unlock(&bdev->bd_mutex);
@@ -1117,7 +1118,7 @@ static int __blkdev_put(struct block_device *bdev, int for_part)
 		module_put(owner);
 
 		if (bdev->bd_contains != bdev) {
-			kobject_put(&bdev->bd_part->dev.kobj);
+			disk_put_part(bdev->bd_part);
 			bdev->bd_part = NULL;
 		}
 		bdev->bd_disk = NULL;
diff --git a/fs/partitions/check.c b/fs/partitions/check.c
index 32024f7..87c23e3 100644
--- a/fs/partitions/check.c
+++ b/fs/partitions/check.c
@@ -323,19 +323,30 @@ static inline void disk_sysfs_add_subdirs(struct gendisk *disk)
 	kobject_put(k);
 }
 
+static void delete_partition_rcu_cb(struct rcu_head *head)
+{
+	struct hd_struct *part = container_of(head, struct hd_struct, rcu_head);
+
+	part->start_sect = 0;
+	part->nr_sects = 0;
+	part_stat_set_all(part, 0);
+	put_device(&part->dev);
+}
+
+
 void delete_partition(struct gendisk *disk, int partno)
 {
-	struct hd_struct *p = disk->part[partno-1];
+	struct hd_struct *part;
 
-	if (!p)
+	part = disk->__part[partno-1];
+	if (!part)
 		return;
-	disk->part[partno-1] = NULL;
-	p->start_sect = 0;
-	p->nr_sects = 0;
-	part_stat_set_all(p, 0);
-	kobject_put(p->holder_dir);
-	device_del(&p->dev);
-	put_device(&p->dev);
+
+	rcu_assign_pointer(disk->__part[partno-1], NULL);
+	kobject_put(part->holder_dir);
+	device_del(&part->dev);
+
+	call_rcu(&part->rcu_head, delete_partition_rcu_cb);
 }
 
 static ssize_t whole_disk_show(struct device *dev,
@@ -352,7 +363,7 @@ int add_partition(struct gendisk *disk, int partno,
 	struct hd_struct *p = NULL;
 	int err;
 
-	if (disk->part[partno - 1]) {
+	if (disk->__part[partno - 1]) {
 		err = -EBUSY;
 		goto fail;
 	}
@@ -381,7 +392,8 @@ int add_partition(struct gendisk *disk, int partno,
 	p->dev.class = &block_class;
 	p->dev.type = &part_type;
 	p->dev.parent = &disk->dev;
-	disk->part[partno-1] = p;
+	INIT_RCU_HEAD(&p->rcu_head);
+	rcu_assign_pointer(disk->__part[partno-1], p);
 
 	/* delay uevent until 'holders' subdir is created */
 	p->dev.uevent_suppress = 1;
@@ -414,9 +426,9 @@ int add_partition(struct gendisk *disk, int partno,
 void register_disk(struct gendisk *disk)
 {
 	struct block_device *bdev;
+	struct disk_part_iter piter;
+	struct hd_struct *part;
 	char *s;
-	int i;
-	struct hd_struct *p;
 	int err;
 
 	disk->dev.parent = disk->driverfs_dev;
@@ -466,16 +478,16 @@ exit:
 	kobject_uevent(&disk->dev.kobj, KOBJ_ADD);
 
 	/* announce possible partitions */
-	for (i = 0; i < disk_max_parts(disk); i++) {
-		p = disk->part[i];
-		if (!p || !p->nr_sects)
-			continue;
-		kobject_uevent(&p->dev.kobj, KOBJ_ADD);
-	}
+	disk_part_iter_start(&piter, disk, 0);
+	while ((part = disk_part_iter_next(&piter)))
+		kobject_uevent(&part->dev.kobj, KOBJ_ADD);
+	disk_part_iter_stop(&piter);
 }
 
 int rescan_partitions(struct gendisk *disk, struct block_device *bdev)
 {
+	struct disk_part_iter piter;
+	struct hd_struct *part;
 	struct parsed_partitions *state;
 	int p, res;
 
@@ -485,8 +497,12 @@ int rescan_partitions(struct gendisk *disk, struct block_device *bdev)
 	if (res)
 		return res;
 	bdev->bd_invalidated = 0;
-	for (p = 1; p <= disk_max_parts(disk); p++)
-		delete_partition(disk, p);
+
+	disk_part_iter_start(&piter, disk, DISK_PITER_INCL_EMPTY);
+	while ((part = disk_part_iter_next(&piter)))
+		delete_partition(disk, part->partno);
+	disk_part_iter_stop(&piter);
+
 	if (disk->fops->revalidate_disk)
 		disk->fops->revalidate_disk(disk);
 	if (!get_capacity(disk) || !(state = check_partition(disk, bdev)))
@@ -544,12 +560,15 @@ EXPORT_SYMBOL(read_dev_sector);
 
 void del_gendisk(struct gendisk *disk)
 {
-	int p;
+	struct disk_part_iter piter;
+	struct hd_struct *part;
 
 	/* invalidate stuff */
-	for (p = disk_max_parts(disk); p > 0; p--) {
-		invalidate_partition(disk, p);
-		delete_partition(disk, p);
+	disk_part_iter_start(&piter, disk,
+			     DISK_PITER_INCL_EMPTY | DISK_PITER_REVERSE);
+	while ((part = disk_part_iter_next(&piter))) {
+		invalidate_partition(disk, part->partno);
+		delete_partition(disk, part->partno);
 	}
 	invalidate_partition(disk, 0);
 	disk->capacity = 0;
diff --git a/include/linux/genhd.h b/include/linux/genhd.h
index 0b102c1..3e35945 100644
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -11,6 +11,7 @@
 
 #include <linux/types.h>
 #include <linux/kdev_t.h>
+#include <linux/rcupdate.h>
 
 #ifdef CONFIG_BLOCK
 
@@ -100,6 +101,7 @@ struct hd_struct {
 #else
 	struct disk_stats dkstats;
 #endif
+	struct rcu_head rcu_head;
 };
 
 #define GENHD_FL_REMOVABLE			1
@@ -121,7 +123,14 @@ struct gendisk {
                                          * disks that can't be partitioned. */
 
 	char disk_name[32];		/* name of major driver */
-	struct hd_struct **part;	/* [indexed by minor - 1] */
+
+	/* Array of pointers to partitions indexed by partno - 1.
+	 * Protected with matching bdev lock but stat and other
+	 * non-critical accesses use RCU.  Always access through
+	 * helpers.
+	 */
+	struct hd_struct **__part;
+
 	struct block_device_operations *fops;
 	struct request_queue *queue;
 	void *private_data;
@@ -169,25 +178,41 @@ static inline dev_t part_devt(struct hd_struct *part)
 	return part->dev.devt;
 }
 
+extern struct hd_struct *disk_get_part(struct gendisk *disk, int partno);
+
+static inline void disk_put_part(struct hd_struct *part)
+{
+	if (likely(part))
+		put_device(&part->dev);
+}
+
+/*
+ * Smarter partition iterator without context limits.
+ */
+#define DISK_PITER_REVERSE	(1 << 0) /* iterate in the reverse direction */
+#define DISK_PITER_INCL_EMPTY	(1 << 1) /* include 0-sized parts */
+
+struct disk_part_iter {
+	struct gendisk		*disk;
+	struct hd_struct	*part;
+	int			idx;
+	unsigned int		flags;
+};
+
+extern void disk_part_iter_start(struct disk_part_iter *piter,
+				 struct gendisk *disk, unsigned int flags);
+extern struct hd_struct *disk_part_iter_next(struct disk_part_iter *piter);
+extern void disk_part_iter_stop(struct disk_part_iter *piter);
+
+extern struct hd_struct *disk_map_sector_rcu(struct gendisk *disk,
+					     sector_t sector);
+
 /* 
  * Macros to operate on percpu disk statistics:
  *
  * The __ variants should only be called in critical sections. The full
  * variants disable/enable preemption.
  */
-static inline struct hd_struct *disk_map_sector(struct gendisk *gendiskp,
-						sector_t sector)
-{
-	struct hd_struct *part;
-	int i;
-	for (i = 0; i < disk_max_parts(gendiskp); i++) {
-		part = gendiskp->part[i];
-		if (part && part->start_sect <= sector
-		    && sector < part->start_sect + part->nr_sects)
-			return part;
-	}
-	return NULL;
-}
 
 #ifdef	CONFIG_SMP
 #define __disk_stat_add(gendiskp, field, addnd) 	\
-- 
1.5.4.5

