From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 5/8] block: improve automatic native capacity unlocking
Date: Sat, 15 May 2010 20:09:31 +0200
Message-ID: <1273946974-29131-6-git-send-email-tj@kernel.org>
References: <1273946974-29131-1-git-send-email-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1273946974-29131-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: jeff@garzik.org, linux-ide@vger.kernel.org, jens.axboe@oracle.com, linux-scsi@vger.kernel.org, James.Bottomley@suse.de, linux-kernel@vger.kernel.org, ben@decadent.org.uk, davem@daveml
Cc: Tejun Heo <tj@kernel.org>
List-Id: linux-scsi@vger.kernel.org

Currently, native capacity unlocking is initiated only when a
recognized partition extends beyond the end of the disk.  However,
there are several other unhandled cases where truncated capacity can
lead to misdetection of partitions.

* Partition table is fully beyond EOD.

* Partition table is partially beyond EOD (daisy chained ones).

* Recognized partition starts beyond EOD.

This patch updates generic partition check code such that all the
above three cases are handled too.  For the first two, @state tracks
whether low level partition check code tried to read beyond EOD during
partition scan and triggers native capacity unlocking accordingly.
The third is now handled similarly to the original unlocking case.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Ben Hutchings <ben@decadent.org.uk>
---
 fs/partitions/check.c |   69 +++++++++++++++++++++++++++++++++++++++----------
 fs/partitions/check.h |    5 +++
 2 files changed, 60 insertions(+), 14 deletions(-)

diff --git a/fs/partitions/check.c b/fs/partitions/check.c
index a19995c..5dcd4b0 100644
--- a/fs/partitions/check.c
+++ b/fs/partitions/check.c
@@ -161,7 +161,7 @@ check_partition(struct gendisk *hd, struct block_device *bdev)
 	struct parsed_partitions *state;
 	int i, res, err;
 
-	state = kmalloc(sizeof(struct parsed_partitions), GFP_KERNEL);
+	state = kzalloc(sizeof(struct parsed_partitions), GFP_KERNEL);
 	if (!state)
 		return NULL;
 
@@ -187,6 +187,8 @@ check_partition(struct gendisk *hd, struct block_device *bdev)
 	}
 	if (res > 0)
 		return state;
+	if (state->access_beyond_eod)
+		err = -ENOSPC;
 	if (err)
 	/* The partition is unrecognized. So report I/O errors if there were any */
 		res = err;
@@ -539,13 +541,34 @@ exit:
 	disk_part_iter_exit(&piter);
 }
 
+static bool disk_unlock_native_capacity(struct gendisk *disk)
+{
+	const struct block_device_operations *bdops = disk->fops;
+
+	if (bdops->unlock_native_capacity &&
+	    !(disk->flags & GENHD_FL_NATIVE_CAPACITY)) {
+		printk(KERN_CONT "enabling native capacity\n");
+		bdops->unlock_native_capacity(disk);
+		disk->flags |= GENHD_FL_NATIVE_CAPACITY;
+		return true;
+	} else {
+		printk(KERN_CONT "truncated\n");
+		return false;
+	}
+}
+
 int rescan_partitions(struct gendisk *disk, struct block_device *bdev)
 {
+	struct parsed_partitions *state = NULL;
 	struct disk_part_iter piter;
 	struct hd_struct *part;
-	struct parsed_partitions *state;
 	int p, highest, res;
 rescan:
+	if (state && !IS_ERR(state)) {
+		kfree(state);
+		state = NULL;
+	}
+
 	if (bdev->bd_part_count)
 		return -EBUSY;
 	res = invalidate_partition(disk, 0);
@@ -563,8 +586,32 @@ rescan:
 	bdev->bd_invalidated = 0;
 	if (!get_capacity(disk) || !(state = check_partition(disk, bdev)))
 		return 0;
-	if (IS_ERR(state))	/* I/O error reading the partition table */
+	if (IS_ERR(state)) {
+		/*
+		 * I/O error reading the partition table.  If any
+		 * partition code tried to read beyond EOD, retry
+		 * after unlocking native capacity.
+		 */
+		if (PTR_ERR(state) == -ENOSPC) {
+			printk(KERN_WARNING "%s: partition table beyond EOD, ",
+			       disk->disk_name);
+			if (disk_unlock_native_capacity(disk))
+				goto rescan;
+		}
 		return -EIO;
+	}
+	/*
+	 * If any partition code tried to read beyond EOD, try
+	 * unlocking native capacity even if partition table is
+	 * sucessfully read as we could be missing some partitions.
+	 */
+	if (state->access_beyond_eod) {
+		printk(KERN_WARNING
+		       "%s: partition table partially beyond EOD, ",
+		       disk->disk_name);
+		if (disk_unlock_native_capacity(disk))
+			goto rescan;
+	}
 
 	/* tell userspace that the media / partition table may have changed */
 	kobject_uevent(&disk_to_dev(disk)->kobj, KOBJ_CHANGE);
@@ -590,25 +637,20 @@ rescan:
 		from = state->parts[p].from;
 		if (from >= get_capacity(disk)) {
 			printk(KERN_WARNING
-			       "%s: p%d ignored, start %llu is behind the end of the disk\n",
+			       "%s: p%d start %llu is beyond EOD, ",
 			       disk->disk_name, p, (unsigned long long) from);
+			if (disk_unlock_native_capacity(disk))
+				goto rescan;
 			continue;
 		}
 
 		if (from + size > get_capacity(disk)) {
-			const struct block_device_operations *bdops = disk->fops;
-
 			printk(KERN_WARNING
-			       "%s: p%d size %llu exceeds device capacity, ",
+			       "%s: p%d size %llu extends beyond EOD, ",
 			       disk->disk_name, p, (unsigned long long) size);
 
-			if (bdops->unlock_native_capacity &&
-			    (disk->flags & GENHD_FL_NATIVE_CAPACITY) == 0) {
-				printk(KERN_CONT "enabling native capacity\n");
-				bdops->unlock_native_capacity(disk);
-				disk->flags |= GENHD_FL_NATIVE_CAPACITY;
+			if (disk_unlock_native_capacity(disk)) {
 				/* free state and restart */
-				kfree(state);
 				goto rescan;
 			} else {
 				/*
@@ -617,7 +659,6 @@ rescan:
 				 * we limit them to the end of the disk to avoid
 				 * creating invalid block devices
 				 */
-				printk(KERN_CONT "limited to end of disk\n");
 				size = get_capacity(disk) - from;
 			}
 		}
diff --git a/fs/partitions/check.h b/fs/partitions/check.h
index 4b31a97..52f8bd3 100644
--- a/fs/partitions/check.h
+++ b/fs/partitions/check.h
@@ -15,11 +15,16 @@ struct parsed_partitions {
 	} parts[DISK_MAX_PARTS];
 	int next;
 	int limit;
+	bool access_beyond_eod;
 };
 
 static inline void *read_part_sector(struct parsed_partitions *state,
 				     sector_t n, Sector *p)
 {
+	if (n >= get_capacity(state->bdev->bd_disk)) {
+		state->access_beyond_eod = true;
+		return NULL;
+	}
 	return read_dev_sector(state->bdev, n, p);
 }
 
-- 
1.6.4.2
