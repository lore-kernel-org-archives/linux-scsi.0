From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 11/13] block: make partition array dynamic
Date: Mon, 25 Aug 2008 19:56:15 +0900
Message-ID: <1219661777-17648-12-git-send-email-tj@kernel.org>
References: <1219661777-17648-1-git-send-email-tj@kernel.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hera.kernel.org ([140.211.167.34]:51925 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757652AbYHYK7t (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Aug 2008 06:59:49 -0400
In-Reply-To: <1219661777-17648-1-git-send-email-tj@kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: James.Bottomley@HansenPartnership.com, bzolnier@gmail.com, bharrosh@panasas.com, greg.freemyer@gmail.com, linux-scsi@vger.kernel.org, brking@linux.vnet.ibm.com, liml@rtr.ca, viro@ftp.linux.org.uk, linux-ide@vger.kernel.org, neilb@suse.de, linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>

disk->__part used to be statically allocated to the maximum possible
number of partitions.  This patch makes partition array allocation
dynamic.  The added overhead is minimal as only real change is one
memory dereference changed to RCU one.  This saves both a bit of
memory and cpu cycles iterating through unoccupied slots and makes
increasing partition limit easier.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 block/genhd.c         |  129 +++++++++++++++++++++++++++++++++++++++++--------
 block/ioctl.c         |    2 +-
 fs/partitions/check.c |   31 ++++++++++--
 include/linux/genhd.h |   10 ++++-
 4 files changed, 145 insertions(+), 27 deletions(-)

diff --git a/block/genhd.c b/block/genhd.c
index cf8d55e..c84a021 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -52,14 +52,21 @@ static struct device_type disk_type;
  */
 struct hd_struct *disk_get_part(struct gendisk *disk, int partno)
 {
-	struct hd_struct *part;
+	struct hd_struct *part = NULL;
+	struct disk_part_tbl *ptbl;
 
-	if (unlikely(partno < 0 || partno >= disk_max_parts(disk)))
+	if (unlikely(partno < 0))
 		return NULL;
+
 	rcu_read_lock();
-	part = rcu_dereference(disk->__part[partno]);
-	if (part)
-		get_device(part_to_dev(part));
+
+	ptbl = rcu_dereference(disk->part_tbl);
+	if (likely(partno < ptbl->len)) {
+		part = rcu_dereference(ptbl->part[partno]);
+		if (part)
+			get_device(part_to_dev(part));
+	}
+
 	rcu_read_unlock();
 
 	return part;
@@ -80,17 +87,24 @@ EXPORT_SYMBOL_GPL(disk_get_part);
 void disk_part_iter_init(struct disk_part_iter *piter, struct gendisk *disk,
 			  unsigned int flags)
 {
+	struct disk_part_tbl *ptbl;
+
+	rcu_read_lock();
+	ptbl = rcu_dereference(disk->part_tbl);
+
 	piter->disk = disk;
 	piter->part = NULL;
 
 	if (flags & DISK_PITER_REVERSE)
-		piter->idx = disk_max_parts(piter->disk) - 1;
+		piter->idx = ptbl->len - 1;
 	else if (flags & DISK_PITER_INCL_PART0)
 		piter->idx = 0;
 	else
 		piter->idx = 1;
 
 	piter->flags = flags;
+
+	rcu_read_unlock();
 }
 EXPORT_SYMBOL_GPL(disk_part_iter_init);
 
@@ -105,13 +119,16 @@ EXPORT_SYMBOL_GPL(disk_part_iter_init);
  */
 struct hd_struct *disk_part_iter_next(struct disk_part_iter *piter)
 {
+	struct disk_part_tbl *ptbl;
 	int inc, end;
 
 	/* put the last partition */
 	disk_put_part(piter->part);
 	piter->part = NULL;
 
+	/* get part_tbl */
 	rcu_read_lock();
+	ptbl = rcu_dereference(piter->disk->part_tbl);
 
 	/* determine iteration parameters */
 	if (piter->flags & DISK_PITER_REVERSE) {
@@ -122,14 +139,14 @@ struct hd_struct *disk_part_iter_next(struct disk_part_iter *piter)
 			end = 0;
 	} else {
 		inc = 1;
-		end = disk_max_parts(piter->disk);
+		end = ptbl->len;
 	}
 
 	/* iterate to the next partition */
 	for (; piter->idx != end; piter->idx += inc) {
 		struct hd_struct *part;
 
-		part = rcu_dereference(piter->disk->__part[piter->idx]);
+		part = rcu_dereference(ptbl->part[piter->idx]);
 		if (!part)
 			continue;
 		if (!(piter->flags & DISK_PITER_INCL_EMPTY) && !part->nr_sects)
@@ -180,10 +197,13 @@ EXPORT_SYMBOL_GPL(disk_part_iter_exit);
  */
 struct hd_struct *disk_map_sector_rcu(struct gendisk *disk, sector_t sector)
 {
+	struct disk_part_tbl *ptbl;
 	int i;
 
-	for (i = 1; i < disk_max_parts(disk); i++) {
-		struct hd_struct *part = rcu_dereference(disk->__part[i]);
+	ptbl = rcu_dereference(disk->part_tbl);
+
+	for (i = 1; i < ptbl->len; i++) {
+		struct hd_struct *part = rcu_dereference(ptbl->part[i]);
 
 		if (part && part->start_sect <= sector &&
 		    sector < part->start_sect + part->nr_sects)
@@ -799,12 +819,86 @@ static struct attribute_group *disk_attr_groups[] = {
 	NULL
 };
 
+static void disk_free_ptbl_rcu_cb(struct rcu_head *head)
+{
+	struct disk_part_tbl *ptbl =
+		container_of(head, struct disk_part_tbl, rcu_head);
+
+	kfree(ptbl);
+}
+
+/**
+ * disk_replace_part_tbl - replace disk->part_tbl in RCU-safe way
+ * @disk: disk to replace part_tbl for
+ * @new_ptbl: new part_tbl to install
+ *
+ * Replace disk->part_tbl with @new_ptbl in RCU-safe way.  The
+ * original ptbl is freed using RCU callback.
+ *
+ * LOCKING:
+ * Matching bd_mutx locked.
+ */
+static void disk_replace_part_tbl(struct gendisk *disk,
+				  struct disk_part_tbl *new_ptbl)
+{
+	struct disk_part_tbl *old_ptbl = disk->part_tbl;
+
+	rcu_assign_pointer(disk->part_tbl, new_ptbl);
+	if (old_ptbl)
+		call_rcu(&old_ptbl->rcu_head, disk_free_ptbl_rcu_cb);
+}
+
+/**
+ * disk_expand_part_tbl - expand disk->part_tbl
+ * @disk: disk to expand part_tbl for
+ * @partno: expand such that this partno can fit in
+ *
+ * Expand disk->part_tbl such that @partno can fit in.  disk->part_tbl
+ * uses RCU to allow unlocked dereferencing for stats and other stuff.
+ *
+ * LOCKING:
+ * Matching bd_mutex locked, might sleep.
+ *
+ * RETURNS:
+ * 0 on success, -errno on failure.
+ */
+int disk_expand_part_tbl(struct gendisk *disk, int partno)
+{
+	struct disk_part_tbl *old_ptbl = disk->part_tbl;
+	struct disk_part_tbl *new_ptbl;
+	int len = old_ptbl ? old_ptbl->len : 0;
+	int target = partno + 1;
+	size_t size;
+	int i;
+
+	/* disk_max_parts() is zero during initialization, ignore if so */
+	if (disk_max_parts(disk) && target > disk_max_parts(disk))
+		return -EINVAL;
+
+	if (target <= len)
+		return 0;
+
+	size = sizeof(*new_ptbl) + target * sizeof(new_ptbl->part[0]);
+	new_ptbl = kzalloc_node(size, GFP_KERNEL, disk->node_id);
+	if (!new_ptbl)
+		return -ENOMEM;
+
+	INIT_RCU_HEAD(&new_ptbl->rcu_head);
+	new_ptbl->len = target;
+
+	for (i = 0; i < len; i++)
+		rcu_assign_pointer(new_ptbl->part[i], old_ptbl->part[i]);
+
+	disk_replace_part_tbl(disk, new_ptbl);
+	return 0;
+}
+
 static void disk_release(struct device *dev)
 {
 	struct gendisk *disk = dev_to_disk(dev);
 
 	kfree(disk->random);
-	kfree(disk->__part);
+	disk_replace_part_tbl(disk, NULL);
 	free_part_stats(&disk->part0);
 	kfree(disk);
 }
@@ -949,22 +1043,16 @@ struct gendisk *alloc_disk_ext_node(int minors, int ext_minors, int node_id)
 	disk = kmalloc_node(sizeof(struct gendisk),
 				GFP_KERNEL | __GFP_ZERO, node_id);
 	if (disk) {
-		int tot_minors = minors + ext_minors;
-		int size = tot_minors * sizeof(struct hd_struct *);
-
 		if (!init_part_stats(&disk->part0)) {
 			kfree(disk);
 			return NULL;
 		}
-
-		disk->__part = kmalloc_node(size, GFP_KERNEL | __GFP_ZERO,
-					    node_id);
-		if (!disk->__part) {
-				free_part_stats(&disk->part0);
+		if (disk_expand_part_tbl(disk, 0)) {
+			free_part_stats(&disk->part0);
 			kfree(disk);
 			return NULL;
 		}
-		disk->__part[0] = &disk->part0;
+		disk->part_tbl->part[0] = &disk->part0;
 
 		disk->minors = minors;
 		disk->ext_minors = ext_minors;
@@ -974,6 +1062,7 @@ struct gendisk *alloc_disk_ext_node(int minors, int ext_minors, int node_id)
 		device_initialize(disk_to_dev(disk));
 		INIT_WORK(&disk->async_notify,
 			media_change_notify_thread);
+		disk->node_id = node_id;
 	}
 	return disk;
 }
diff --git a/block/ioctl.c b/block/ioctl.c
index 64e7c67..38bee32 100644
--- a/block/ioctl.c
+++ b/block/ioctl.c
@@ -30,7 +30,7 @@ static int blkpg_ioctl(struct block_device *bdev, struct blkpg_ioctl_arg __user
 	if (bdev != bdev->bd_contains)
 		return -EINVAL;
 	partno = p.pno;
-	if (partno <= 0 || partno >= disk_max_parts(disk))
+	if (partno <= 0)
 		return -EINVAL;
 	switch (a.op) {
 		case BLKPG_ADD_PARTITION:
diff --git a/fs/partitions/check.c b/fs/partitions/check.c
index 787dcd1..6b7ac10 100644
--- a/fs/partitions/check.c
+++ b/fs/partitions/check.c
@@ -312,14 +312,18 @@ static void delete_partition_rcu_cb(struct rcu_head *head)
 
 void delete_partition(struct gendisk *disk, int partno)
 {
+	struct disk_part_tbl *ptbl = disk->part_tbl;
 	struct hd_struct *part;
 
-	part = disk->__part[partno];
+	if (partno >= ptbl->len)
+		return;
+
+	part = ptbl->part[partno];
 	if (!part)
 		return;
 
 	blk_free_devt(part_devt(part));
-	rcu_assign_pointer(disk->__part[partno], NULL);
+	rcu_assign_pointer(ptbl->part[partno], NULL);
 	kobject_put(part->holder_dir);
 	device_del(part_to_dev(part));
 
@@ -341,10 +345,16 @@ int add_partition(struct gendisk *disk, int partno,
 	dev_t devt = MKDEV(0, 0);
 	struct device *ddev = disk_to_dev(disk);
 	struct device *pdev;
+	struct disk_part_tbl *ptbl;
 	const char *dname;
 	int err;
 
-	if (disk->__part[partno])
+	err = disk_expand_part_tbl(disk, partno);
+	if (err)
+		return err;
+	ptbl = disk->part_tbl;
+
+	if (ptbl->part[partno])
 		return -EBUSY;
 
 	p = kzalloc(sizeof(*p), GFP_KERNEL);
@@ -398,7 +408,7 @@ int add_partition(struct gendisk *disk, int partno,
 
 	/* everything is up and running, commence */
 	INIT_RCU_HEAD(&p->rcu_head);
-	rcu_assign_pointer(disk->__part[partno], p);
+	rcu_assign_pointer(ptbl->part[partno], p);
 
 	/* suppress uevent if the disk supresses it */
 	if (!ddev->uevent_suppress)
@@ -487,7 +497,7 @@ int rescan_partitions(struct gendisk *disk, struct block_device *bdev)
 	struct disk_part_iter piter;
 	struct hd_struct *part;
 	struct parsed_partitions *state;
-	int p, res;
+	int p, highest, res;
 
 	if (bdev->bd_part_count)
 		return -EBUSY;
@@ -511,6 +521,17 @@ int rescan_partitions(struct gendisk *disk, struct block_device *bdev)
 	/* tell userspace that the media / partition table may have changed */
 	kobject_uevent(&disk_to_dev(disk)->kobj, KOBJ_CHANGE);
 
+	/* Detect the highest partition number and preallocate
+	 * disk->part_tbl.  This is an optimization and not strictly
+	 * necessary.
+	 */
+	for (p = 1, highest = 0; p < state->limit; p++)
+		if (state->parts[p].size)
+			highest = p;
+
+	disk_expand_part_tbl(disk, highest);
+
+	/* add partitions */
 	for (p = 1; p < state->limit; p++) {
 		sector_t size = state->parts[p].size;
 		sector_t from = state->parts[p].from;
diff --git a/include/linux/genhd.h b/include/linux/genhd.h
index e02b09d..bf87b77 100644
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -122,6 +122,12 @@ struct blk_scsi_cmd_filter {
 	struct kobject kobj;
 };
 
+struct disk_part_tbl {
+	struct rcu_head rcu_head;
+	int len;
+	struct hd_struct *part[];
+};
+
 struct gendisk {
 	/* major, first_minor, minors and ext_minors are input
 	 * parameters only, don't use directly.  Use disk_devt() and
@@ -140,7 +146,7 @@ struct gendisk {
 	 * non-critical accesses use RCU.  Always access through
 	 * helpers.
 	 */
-	struct hd_struct **__part;
+	struct disk_part_tbl *part_tbl;
 	struct hd_struct part0;
 
 	struct block_device_operations *fops;
@@ -159,6 +165,7 @@ struct gendisk {
 #ifdef  CONFIG_BLK_DEV_INTEGRITY
 	struct blk_integrity *integrity;
 #endif
+	int node_id;
 };
 
 static inline struct gendisk *part_to_disk(struct hd_struct *part)
@@ -513,6 +520,7 @@ extern void blk_free_devt(dev_t devt);
 extern dev_t blk_lookup_devt(const char *name, int partno);
 extern char *disk_name (struct gendisk *hd, int partno, char *buf);
 
+extern int disk_expand_part_tbl(struct gendisk *disk, int target);
 extern int rescan_partitions(struct gendisk *disk, struct block_device *bdev);
 extern int __must_check add_partition(struct gendisk *, int, sector_t, sector_t, int);
 extern void delete_partition(struct gendisk *, int);
-- 
1.5.4.5

