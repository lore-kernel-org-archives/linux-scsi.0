From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 02/13] block: introduce partition 0
Date: Mon, 14 Jul 2008 16:48:02 +0900
Message-ID: <1216021693-483-3-git-send-email-tj@kernel.org>
References: <1216021693-483-1-git-send-email-tj@kernel.org>
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1216021693-483-1-git-send-email-tj@kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: jens.axboe@oracle.com, James.Bottomley@HansenPartnership.com, bharrosh@panasas.com, greg.freemyer@gmail.com, linux-scsi@vger.kernel.org, brking@linux.vnet.ibm.com, liml@rtr.ca, viro@f
Cc: Tejun Heo <tj@kernel.org>
List-Id: linux-scsi@vger.kernel.org

genhd and partition code handled disk and partitions separately.  All
information about the whole disk was in struct genhd and partitions in
struct hd_struct.  However, the whole disk (part0) and other
partitions have a lot in common and the data structures end up having
good number of common fields and separate code paths doing the same
thing.  Also, the partition array was indexed by partno - 1 which gets
pretty confusing at times.

This patch introduces partition 0 and makes the partition array
indexed by partno.  Following patches will unify the handling of disk
and parts piece-by-piece.

This patch also implements disk_partitionable() which tests whether a
disk is partitionable.  With coming dynamic partition array change,
the most common usage of disk_max_parts() will be testing whether a
disk is partitionable and the number of max partitions will become
much less important.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 block/genhd.c         |   40 +++++++++++++++++++++++-----------------
 block/ioctl.c         |    4 ++--
 fs/block_dev.c        |    2 +-
 fs/partitions/check.c |   12 ++++++------
 include/linux/genhd.h |   11 +++++++++--
 5 files changed, 41 insertions(+), 28 deletions(-)

diff --git a/block/genhd.c b/block/genhd.c
index c54f694..07f1597 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -54,10 +54,10 @@ struct hd_struct *disk_get_part(struct gendisk *disk, int partno)
 {
 	struct hd_struct *part;
 
-	if (unlikely(partno < 1 || partno > disk_max_parts(disk)))
+	if (unlikely(partno < 0 || partno >= disk_max_parts(disk)))
 		return NULL;
 	rcu_read_lock();
-	part = rcu_dereference(disk->__part[partno - 1]);
+	part = rcu_dereference(disk->__part[partno]);
 	if (part)
 		get_device(part_to_dev(part));
 	rcu_read_unlock();
@@ -85,8 +85,10 @@ void disk_part_iter_start(struct disk_part_iter *piter, struct gendisk *disk,
 
 	if (flags & DISK_PITER_REVERSE)
 		piter->idx = disk_max_parts(piter->disk) - 1;
-	else
+	else if (flags & DISK_PITER_INCL_PART0)
 		piter->idx = 0;
+	else
+		piter->idx = 1;
 
 	piter->flags = flags;
 }
@@ -114,7 +116,10 @@ struct hd_struct *disk_part_iter_next(struct disk_part_iter *piter)
 	/* determine iteration parameters */
 	if (piter->flags & DISK_PITER_REVERSE) {
 		inc = -1;
-		end = -1;
+		if (piter->flags & DISK_PITER_INCL_PART0)
+			end = -1;
+		else
+			end = 0;
 	} else {
 		inc = 1;
 		end = disk_max_parts(piter->disk);
@@ -177,7 +182,7 @@ struct hd_struct *disk_map_sector_rcu(struct gendisk *disk, sector_t sector)
 {
 	int i;
 
-	for (i = 0; i < disk_max_parts(disk); i++) {
+	for (i = 1; i < disk_max_parts(disk); i++) {
 		struct hd_struct *part = rcu_dereference(disk->__part[i]);
 
 		if (part && part->start_sect <= sector &&
@@ -648,7 +653,7 @@ static int show_partition(struct seq_file *seqf, void *v)
 		seq_puts(seqf, "major   minor   #blocks  name\n\n");
 
 	/* Don't show non-partitionable removeable devices or empty devices */
-	if (!get_capacity(sgp) || (!disk_max_parts(sgp) &&
+	if (!get_capacity(sgp) || (!disk_partitionable(sgp) &&
 				   (sgp->flags & GENHD_FL_REMOVABLE)))
 		return 0;
 	if (sgp->flags & GENHD_FL_SUPPRESS_PARTITION_INFO)
@@ -718,7 +723,7 @@ static ssize_t disk_ext_range_show(struct device *dev,
 {
 	struct gendisk *disk = dev_to_disk(dev);
 
-	return sprintf(buf, "%d\n", disk_max_parts(disk) + 1);
+	return sprintf(buf, "%d\n", disk_max_parts(disk));
 }
 
 static ssize_t disk_removable_show(struct device *dev,
@@ -997,7 +1002,7 @@ dev_t blk_lookup_devt(const char *name, int partno)
 			continue;
 		if (strcmp(dev->bus_id, name))
 			continue;
-		if (partno < 0 || partno > disk_max_parts(disk))
+		if (partno < 0 || partno >= disk_max_parts(disk))
 			continue;
 
 		if (partno == 0)
@@ -1045,21 +1050,22 @@ struct gendisk *alloc_disk_ext_node(int minors, int ext_minors, int node_id)
 				GFP_KERNEL | __GFP_ZERO, node_id);
 	if (disk) {
 		int tot_minors = minors + ext_minors;
+		int size = tot_minors * sizeof(struct hd_struct *);
 
 		if (!init_disk_stats(disk)) {
 			kfree(disk);
 			return NULL;
 		}
-		if (tot_minors > 1) {
-			int size = (tot_minors - 1) * sizeof(struct hd_struct *);
-			disk->__part = kmalloc_node(size,
-				GFP_KERNEL | __GFP_ZERO, node_id);
-			if (!disk->__part) {
-				free_disk_stats(disk);
-				kfree(disk);
-				return NULL;
-			}
+
+		disk->__part = kmalloc_node(size, GFP_KERNEL | __GFP_ZERO,
+					    node_id);
+		if (!disk->__part) {
+			free_disk_stats(disk);
+			kfree(disk);
+			return NULL;
 		}
+		disk->__part[0] = &disk->part0;
+
 		disk->minors = minors;
 		disk->ext_minors = ext_minors;
 		rand_initialize_disk(disk);
diff --git a/block/ioctl.c b/block/ioctl.c
index 75aeead..67d2813 100644
--- a/block/ioctl.c
+++ b/block/ioctl.c
@@ -30,7 +30,7 @@ static int blkpg_ioctl(struct block_device *bdev, struct blkpg_ioctl_arg __user
 	if (bdev != bdev->bd_contains)
 		return -EINVAL;
 	partno = p.pno;
-	if (partno <= 0 || partno > disk_max_parts(disk))
+	if (partno <= 0 || partno >= disk_max_parts(disk))
 		return -EINVAL;
 	switch (a.op) {
 		case BLKPG_ADD_PARTITION:
@@ -104,7 +104,7 @@ static int blkdev_reread_part(struct block_device *bdev)
 	struct gendisk *disk = bdev->bd_disk;
 	int res;
 
-	if (!disk_max_parts(disk) || bdev != bdev->bd_contains)
+	if (!disk_partitionable(disk) || bdev != bdev->bd_contains)
 		return -EINVAL;
 	if (!capable(CAP_SYS_ADMIN))
 		return -EACCES;
diff --git a/fs/block_dev.c b/fs/block_dev.c
index 5f177bd..4fd822d 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -892,7 +892,7 @@ int check_disk_change(struct block_device *bdev)
 
 	if (bdops->revalidate_disk)
 		bdops->revalidate_disk(bdev->bd_disk);
-	if (disk_max_parts(bdev->bd_disk))
+	if (disk_partitionable(bdev->bd_disk))
 		bdev->bd_invalidated = 1;
 	return 1;
 }
diff --git a/fs/partitions/check.c b/fs/partitions/check.c
index d12ac7d..d4e677d 100644
--- a/fs/partitions/check.c
+++ b/fs/partitions/check.c
@@ -173,7 +173,7 @@ check_partition(struct gendisk *hd, struct block_device *bdev)
 	if (isdigit(state->name[strlen(state->name)-1]))
 		sprintf(state->name, "p");
 
-	state->limit = disk_max_parts(hd) + 1;
+	state->limit = disk_max_parts(hd);
 	i = res = err = 0;
 	while (!res && check_part[i]) {
 		memset(&state->parts, 0, sizeof(state->parts));
@@ -338,12 +338,12 @@ void delete_partition(struct gendisk *disk, int partno)
 {
 	struct hd_struct *part;
 
-	part = disk->__part[partno-1];
+	part = disk->__part[partno];
 	if (!part)
 		return;
 
 	blk_free_devt(part_devt(part));
-	rcu_assign_pointer(disk->__part[partno-1], NULL);
+	rcu_assign_pointer(disk->__part[partno], NULL);
 	kobject_put(part->holder_dir);
 	device_del(part_to_dev(part));
 
@@ -368,7 +368,7 @@ int add_partition(struct gendisk *disk, int partno,
 	const char *dname;
 	int err;
 
-	if (disk->__part[partno - 1]) {
+	if (disk->__part[partno]) {
 		err = -EBUSY;
 		goto fail;
 	}
@@ -403,7 +403,7 @@ int add_partition(struct gendisk *disk, int partno,
 	pdev->devt = devt;
 
 	INIT_RCU_HEAD(&p->rcu_head);
-	rcu_assign_pointer(disk->__part[partno-1], p);
+	rcu_assign_pointer(disk->__part[partno], p);
 
 	/* delay uevent until 'holders' subdir is created */
 	pdev->uevent_suppress = 1;
@@ -466,7 +466,7 @@ void register_disk(struct gendisk *disk)
 	disk_sysfs_add_subdirs(disk);
 
 	/* No minors to use for partitions */
-	if (!disk_max_parts(disk))
+	if (!disk_partitionable(disk))
 		goto exit;
 
 	/* No such device (e.g., media were just removed) */
diff --git a/include/linux/genhd.h b/include/linux/genhd.h
index 96d7ac5..9018b11 100644
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -128,12 +128,13 @@ struct gendisk {
 
 	char disk_name[32];		/* name of major driver */
 
-	/* Array of pointers to partitions indexed by partno - 1.
+	/* Array of pointers to partitions indexed by partno.
 	 * Protected with matching bdev lock but stat and other
 	 * non-critical accesses use RCU.  Always access through
 	 * helpers.
 	 */
 	struct hd_struct **__part;
+	struct hd_struct part0;
 
 	struct block_device_operations *fops;
 	struct request_queue *queue;
@@ -169,7 +170,12 @@ static inline struct gendisk *part_to_disk(struct hd_struct *part)
 
 static inline int disk_max_parts(struct gendisk *disk)
 {
-	return disk->minors + disk->ext_minors - 1;
+	return disk->minors + disk->ext_minors;
+}
+
+static inline bool disk_partitionable(struct gendisk *disk)
+{
+	return disk_max_parts(disk) > 1;
 }
 
 static inline dev_t disk_devt(struct gendisk *disk)
@@ -195,6 +201,7 @@ static inline void disk_put_part(struct hd_struct *part)
  */
 #define DISK_PITER_REVERSE	(1 << 0) /* iterate in the reverse direction */
 #define DISK_PITER_INCL_EMPTY	(1 << 1) /* include 0-sized parts */
+#define DISK_PITER_INCL_PART0	(1 << 2) /* include partition 0 */
 
 struct disk_part_iter {
 	struct gendisk		*disk;
-- 
1.5.4.5

