Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAF76453A39;
	Fri,  9 Oct 2026 09:09:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791536993; cv=none; b=BgNUqNkcVjOfqVTqbh6xmNqhJ8uz1f1L3NWZcCJSMN8s0LPxLgQpq9hEV0nubaYQlzhnNqtQu6Xp1c7PGLuFHXNGyWt0dB8kKDlf121NBcfjJAU0ynrp4TKO7sC2TeJwJmGbkgtQZ1pvkyrNwDvwbxBFMTsc1bYrz+wp7rd9VNA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791536993; c=relaxed/simple;
	bh=T9Sbl3zQ55TRXZOJQkjaIIR1WpqVvScZOlKM40eJprU=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lBt3qUk1+4DA4OBma4muCxvYV06j4EvIKC4RFCWhm1jk0ps6Dxbor/pszLO+D785YxiYjRgbDGz0gNAdEGwRV+cwJYdZB8IaQ5J4A8i3F6YQ1p1ABdlv8/PLfKI08N7CvrijboHcGQ2V1bZO67+bNbRisPM1Q6Sg3iDsB4yqxOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Y0ZGjsNP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Y0ZGjsNP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6C7D1F000FF;
	Fri,  9 Oct 2026 09:09:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791536990;
	bh=Gyd0I5wa+SDiUf8+5CMOdy6JbdbTBjfJ0qOQHRz8c+w=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=Y0ZGjsNPk1FN3T6RYitT6fkdDyVYO1D8iHRt4TID06lQkROhYmW1gHQQZNm2Rjbcv
	 wbfY/a9SUwKBffJ6Ji12/WkMIQrAtOI9ONav2YM+CRlknsCDb05phR6RajNSqaEzf8
	 1r0T+PVdPJiW6DQTKxw6z+VeQKgJTISHTkdThXWwQTMWfR6AH68sUiakyRbJmCzBYA
	 /xp+P1/+dkkZOkXSUhp+yj8RwHTt5Y2VzXDvxfIFMAJKBvpDQw57x9pxSJCTpfeOrN
	 tVa2JreR9L62Zceh8Cjq880E+oqY21wMmWd3eDzUhIdBOP8p3rWqcmcIXD5QI/8mUv
	 bSymGcX9PPM5Q==
From: Damien Le Moal <dlemoal@kernel.org>
To: Jens Axboe <axboe@kernel.dk>,
	linux-block@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Subject: [PATCH v4 3/9] block: introduce storage element management
Date: Fri,  9 Oct 2026 18:09:39 +0900
Message-ID: <20261009090945.1504194-4-dlemoal@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261009090945.1504194-1-dlemoal@kernel.org>
References: <20261009090945.1504194-1-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Recent SCSI (SBC) and ATA (ACS) standards define the storage element
depopulation feature. This feature is intended for managing hard-disks
heads, either combined read-write heads or pairs of read and write heads,
allowing to keep disks with defective heads longer in production by
allowing "depopulating" (removing) defective heads.

This feature comes in two different flavors:
 - A destructive version which removes a head and reformats the disk at a
   lower capacity point, restoaring a fully functional contiguous LBA
   address space.
 - A data preserving version restricted to host-managed zoned disks, which
   marks the zones served by a removed head as offline or read-only.

In preparation for using the data-preserving flavor of the depopulation
feature in file systems natively supporting zoned block devices, introduce
a set of storage element management operations and functions to define
generic calls into block device drivers for managing storage elements.

The set of operations is defined with struct blk_se_ops and includes three
operations:
 - report_elements: get information on a device storage elements state
   reported with the new struct blk_se.
 - remove_element: depopulate a defective storage element
 - restore_elements: restore depopulated storage elements

Each operation is called from the functions
bdev_report_storage_elements(), bdev_remove_storage_element() and
bdev_restore_storage_elements().

Removing a healthy storage element from a device is possible and useful
for testing. The storage element restoration operation restore_elements
allows repopulating such healthy element. Repopulating defective storage
elements is generally not allowed by devices. The remove_element and
restore_elements operations are executed under the zone revalidation lock
so that they are serialized iand also serialized against user initiated
device revalidation, thus allowing to always have a consistent view of the
device zone conditions.

The device drivers of zoned block devices can indicate support for the
storage element depopulation feature by specifying the storage element
management operations with the se_ops field of struct
block_device_operations.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
---
 block/blk-zoned.c             | 257 +++++++++++++++++++++++++++++++++-
 block/blk.h                   |   5 +
 block/genhd.c                 |   4 +
 include/linux/blkdev.h        |  22 +++
 include/uapi/linux/blkzoned.h |  62 ++++++++
 5 files changed, 349 insertions(+), 1 deletion(-)

diff --git a/block/blk-zoned.c b/block/blk-zoned.c
index e7f48774ae17..8ca5470d6517 100644
--- a/block/blk-zoned.c
+++ b/block/blk-zoned.c
@@ -18,6 +18,7 @@
 #include <linux/mempool.h>
 #include <linux/kthread.h>
 #include <linux/freezer.h>
+#include <linux/delay.h>
 
 #include <trace/events/block.h>
 
@@ -2721,5 +2722,259 @@ int queue_zone_wplugs_show(void *data, struct seq_file *m)
 
 	return 0;
 }
-
 #endif
+
+static int disk_se_mgmt_in_progress(struct gendisk *disk,
+				     struct blk_se *elements,
+				     bool *in_progress)
+{
+	unsigned int i, nr_se = disk->nr_storage_elements;
+	int ret;
+
+	/*
+	 * Check if we have storage elements being removed or restored.
+	 */
+	ret = disk->fops->se_ops->report_elements(disk, elements, &nr_se);
+	if (ret) {
+		pr_err("Failed to get storage elements\n");
+		return ret;
+	}
+
+	for (i = 0; i < nr_se; i++) {
+		switch (elements[i].status) {
+		case BLK_SE_STS_REMOVE_IN_PROGRESS:
+		case BLK_SE_STS_RESTORE_IN_PROGRESS:
+			*in_progress = true;
+			return 0;
+		default:
+			break;
+		}
+	}
+
+	*in_progress = false;
+
+	return 0;
+}
+
+static int disk_wait_for_se_mgmt_completion(struct gendisk *disk)
+{
+	struct blk_se *elements;
+	unsigned int noio_flag;
+	bool in_progress;
+	int ret;
+
+	noio_flag = memalloc_noio_save();
+	elements = kzalloc_objs(struct blk_se, disk->nr_storage_elements);
+	memalloc_noio_restore(noio_flag);
+	if (!elements)
+		return -ENOMEM;
+
+	/*
+	 * Poll the storage elements heath state to detect the end of a
+	 * removal or restoration operation. Since we do not know how long the
+	 * operation may take, we cannot have a timeout on this loop. So check
+	 * for fatal signals so that the user can terminate this retry loop if
+	 * the device misbehaves.
+	 */
+	while (1) {
+		ret = disk_se_mgmt_in_progress(disk, elements, &in_progress);
+		if (ret || !in_progress)
+			break;
+
+		if (fatal_signal_pending(current)) {
+			ret = -EINTR;
+			break;
+		}
+
+		/* Not done yet: wait and retry. */
+		msleep(1000);
+	}
+
+	kfree(elements);
+
+	return ret;
+}
+
+/**
+ * bdev_report_storage_elements - report the storage elements of a zoned
+ *				  block device
+ * @bdev:	the zoned block device to check
+ * @elements:	array of storage element descriptors to fill
+ * @nr_elements: maximum size of @elements
+ *
+ * Fill at most @nr_elements storage element descriptors in the array
+ * @elements. The number of storage elements filled in the array is returned
+ * using @nr_elements. If @elements is NULL, only @nr_elements is returned to
+ * indicate the maximum number of storage elements of @bdev.
+ *
+ * Returns 0 on success and a negative error code on failure.
+ */
+int bdev_report_storage_elements(struct block_device *bdev,
+				 struct blk_se *elements,
+				 unsigned int *nr_elements)
+{
+	struct gendisk *disk = bdev->bd_disk;
+
+	if (!blk_queue_is_zoned(disk->queue) || !disk->nr_storage_elements)
+		return -EOPNOTSUPP;
+
+	if (!nr_elements)
+		return -EINVAL;
+
+	if (!elements) {
+		*nr_elements = disk->nr_storage_elements;
+		return 0;
+	}
+
+	*nr_elements = min(*nr_elements, disk->nr_storage_elements);
+	if (!*nr_elements)
+		return -EINVAL;
+
+	return disk->fops->se_ops->report_elements(disk, elements,
+						   nr_elements);
+}
+EXPORT_SYMBOL_GPL(bdev_report_storage_elements);
+
+/**
+ * bdev_remove_storage_element - Remove (depopulate) a storage element of a
+ *				 zoned block device
+ * @bdev:	block device to operate on
+ * @element_id:	ID of the storage element to remove
+ *
+ * Remove (depopulate) the storage element identified by @element_id from the
+ * block device @bdev. The caller is responsible for taking care of any
+ * necessary device write cache flush and invalidation of cached data for the
+ * zones that will be offlined.
+ *
+ * Returns 0 on success and a negative error code on failure.
+ */
+int bdev_remove_storage_element(struct block_device *bdev,
+				unsigned int element_id)
+{
+	struct gendisk *disk = bdev->bd_disk;
+	unsigned int memflags;
+	int ret;
+
+	if (!blk_queue_is_zoned(disk->queue) || !disk->nr_storage_elements)
+		return -EOPNOTSUPP;
+
+	/* Zero is not a valid storage element ID. */
+	if (!element_id)
+		return -EINVAL;
+
+	/*
+	 * Serialize against concurrent revalidation and concurrent storage
+	 * element management operations so that we can see consistent zone
+	 * condition changes.
+	 */
+	mutex_lock(&disk->zone_revalidate_mutex);
+
+	/*
+	 * Freeze and unfreeze the queue to flush any outstanding command.
+	 * The caller is responsible for not queuing up more I/Os by higher
+	 * level means.
+	 */
+	memflags = blk_mq_freeze_queue(disk->queue);
+	blk_mq_unfreeze_queue(disk->queue, memflags);
+
+	ret = disk->fops->se_ops->remove_element(disk, element_id);
+	if (ret)
+		goto unlock;
+
+	/* Revalidate the device zones once the opration completes. */
+	ret = disk_wait_for_se_mgmt_completion(disk);
+	if (ret)
+		goto unlock;
+
+	ret = disk_revalidate_zones(disk);
+
+unlock:
+	mutex_unlock(&disk->zone_revalidate_mutex);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(bdev_remove_storage_element);
+
+/**
+ * bdev_restore_storage_elements - Restore all depopulated storage elements of
+ *				   a zoned block device
+ * @bdev:	block device to operate on
+ *
+ * Restore all storage elements of @bdev that have been depopulated. Not all
+ * elements may be restored by this operation.
+ *
+ * Returns 0 on success and a negative error code on failure.
+ */
+int bdev_restore_storage_elements(struct block_device *bdev)
+{
+	struct gendisk *disk = bdev->bd_disk;
+	unsigned int memflags;
+	int ret;
+
+	if (!blk_queue_is_zoned(disk->queue) || !disk->nr_storage_elements)
+		return -EOPNOTSUPP;
+
+	/*
+	 * Serialize against concurrent revalidation and concurrent storage
+	 * element management operations so that we can see consistent zone
+	 * condition changes.
+	 */
+	mutex_lock(&disk->zone_revalidate_mutex);
+
+	/*
+	 * Freeze and unfreeze the queue to flush any outstanding commands.
+	 * The caller is responsible for not queuing up more I/O by higher
+	 * level means.
+	 */
+	memflags = blk_mq_freeze_queue(disk->queue);
+	blk_mq_unfreeze_queue(disk->queue, memflags);
+
+	ret = disk->fops->se_ops->restore_elements(disk);
+	if (ret)
+		goto unlock;
+
+	ret = disk_wait_for_se_mgmt_completion(disk);
+	if (ret)
+		goto unlock;
+
+	ret = disk_revalidate_zones(disk);
+
+unlock:
+	mutex_unlock(&disk->zone_revalidate_mutex);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(bdev_restore_storage_elements);
+
+int disk_init_storage_element_mgmt(struct gendisk *disk)
+{
+	int ret;
+
+	/*
+	 * Storage element operations are for zoned disks only and
+	 * optional...
+	 */
+	if (!blk_queue_is_zoned(disk->queue) || !disk->fops->se_ops)
+		return 0;
+
+	/* ...but if supported, all operations must be defined. */
+	if (!disk->fops->se_ops->report_elements ||
+	    !disk->fops->se_ops->remove_element ||
+	    !disk->fops->se_ops->restore_elements) {
+		pr_err("%s: invalid storage element operations\n",
+		       disk->disk_name);
+		return -EINVAL;
+	}
+
+	/*
+	 * Get the number of storage elements of the disk. If this fails,
+	 * do not report an error as the failure may be because the zoned disk
+	 * does not support storage element management.
+	 */
+	ret = disk->fops->se_ops->report_elements(disk, NULL,
+						  &disk->nr_storage_elements);
+	if (ret)
+		disk->nr_storage_elements = 0;
+
+	return 0;
+}
diff --git a/block/blk.h b/block/blk.h
index 2cc03aa54c53..39d90747b40f 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -527,6 +527,7 @@ static inline void ioc_clear_queue(struct request_queue *q)
 #endif /* CONFIG_BLK_ICQ */
 
 #ifdef CONFIG_BLK_DEV_ZONED
+int disk_init_storage_element_mgmt(struct gendisk *disk);
 void disk_init_zone_resources(struct gendisk *disk);
 void disk_release_zone_resources(struct gendisk *disk);
 static inline bool bio_zone_write_plugging(struct bio *bio)
@@ -579,6 +580,10 @@ int blkdev_zone_mgmt_ioctl(struct block_device *bdev, blk_mode_t mode,
 		unsigned int cmd, unsigned long arg);
 bool bdev_zone_mgmt_allowed(struct block_device *bdev, sector_t sector);
 #else /* CONFIG_BLK_DEV_ZONED */
+static inline int disk_init_storage_element_mgmt(struct gendisk *disk)
+{
+	return 0;
+}
 static inline void disk_init_zone_resources(struct gendisk *disk)
 {
 }
diff --git a/block/genhd.c b/block/genhd.c
index 10ca8b4d6eea..e2cef791ac91 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -435,6 +435,10 @@ static int __add_disk(struct device *parent, struct gendisk *disk,
 	if (WARN_ON_ONCE(bdev_nr_sectors(disk->part0) > BLK_DEV_MAX_SECTORS))
 		return -EINVAL;
 
+	ret = disk_init_storage_element_mgmt(disk);
+	if (ret)
+		return ret;
+
 	if (queue_is_mq(disk->queue)) {
 		/*
 		 * ->submit_bio and ->poll_bio are bypassed for blk-mq drivers.
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 83d88dfe59f5..20b77c6b451f 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -189,6 +189,11 @@ struct gendisk {
 	struct disk_events *ev;
 
 #ifdef CONFIG_BLK_DEV_ZONED
+	/*
+	 * Total number of storage elements of the disk. This is always 0 for
+	 * disks that do not support storage element management.
+	 */
+	unsigned int		nr_storage_elements;
 	/*
 	 * Zoned block device information. Reads of this information must be
 	 * protected with blk_queue_enter() / blk_queue_exit() or by holding a
@@ -1583,6 +1588,22 @@ enum blk_unique_id {
 	BLK_UID_NAA	= 3,
 };
 
+/* Storage element management operations. */
+struct blk_se_ops {
+	int (*report_elements)(struct gendisk *disk,
+			       struct blk_se *elements,
+			       unsigned int *nr_elements);
+	int (*remove_element)(struct gendisk *disk, unsigned int element_id);
+	int (*restore_elements)(struct gendisk *disk);
+};
+
+int bdev_report_storage_elements(struct block_device *bdev,
+				 struct blk_se *elements,
+				 unsigned int *nr_elements);
+int bdev_remove_storage_element(struct block_device *bdev,
+				unsigned int element_id);
+int bdev_restore_storage_elements(struct block_device *bdev);
+
 struct block_device_operations {
 	void (*submit_bio)(struct bio *bio);
 	int (*poll_bio)(struct bio *bio, struct io_comp_batch *iob,
@@ -1610,6 +1631,7 @@ struct block_device_operations {
 			enum blk_unique_id id_type);
 	struct module *owner;
 	const struct pr_ops *pr_ops;
+	const struct blk_se_ops	*se_ops;
 
 	/*
 	 * Special callback for probing GPT entry at a given sector.
diff --git a/include/uapi/linux/blkzoned.h b/include/uapi/linux/blkzoned.h
index 663836120966..f9ecd54210d0 100644
--- a/include/uapi/linux/blkzoned.h
+++ b/include/uapi/linux/blkzoned.h
@@ -208,4 +208,66 @@ struct blk_zone_range {
 #define BLKFINISHZONE	_IOW(0x12, 136, struct blk_zone_range)
 #define BLKREPORTZONEV2	_IOWR(0x12, 142, struct blk_zone_report)
 
+/**
+ * enum blk_se_type - Type of a zoned device storage element.
+ *
+ * @BLK_SE_TYPE_RDWR: The storage element handles both reads and writes.
+ * @BLK_SE_TYPE_READ: The storage element handles reads only.
+ * @BLK_SE_TYPE_WRITE: The storage element handles writes only.
+ * @BLK_SE_TYPE_UNKNOWN: The storage element type is not known.
+ */
+enum blk_se_type {
+	BLK_SE_TYPE_RDWR		= 0x01,
+	BLK_SE_TYPE_READ		= 0x02,
+	BLK_SE_TYPE_WRITE		= 0x03,
+	BLK_SE_TYPE_UNKNOWN		= 0xFF,
+};
+
+/**
+ * enum blk_se_status - Status of a zoned device storage element.
+ *
+ * @BLK_SE_STS_OK: The storage element is operating normally.
+ * @BLK_SE_STS_DEGRADED: The storage element has degraded and is not operating
+ *			 normally.
+ * @BLK_SE_STS_REMOVE_IN_PROGRESS: The storage element is being removed.
+ * @BLK_SE_STS_REMOVE_ERROR: The storage element removal failed.
+ * @BLK_SE_STS_RESTORE_IN_PROGRESS: The storage element is being restored.
+ * @BLK_SE_STS_RESTORE_ERROR: The storage element restoration failed.
+ * @BLK_SE_STS_REMOVED: The storage element was removed.
+ * @BLK_SE_STS_UNKNOWN: The storage element status is unknown.
+ */
+enum blk_se_status {
+	BLK_SE_STS_OK			= 0x01,
+	BLK_SE_STS_DEGRADED		= 0x02,
+	BLK_SE_STS_REMOVE_IN_PROGRESS	= 0x03,
+	BLK_SE_STS_REMOVE_ERROR		= 0x04,
+	BLK_SE_STS_RESTORE_IN_PROGRESS	= 0x05,
+	BLK_SE_STS_RESTORE_ERROR	= 0x06,
+	BLK_SE_STS_REMOVED		= 0x07,
+	BLK_SE_STS_UNKNOWN		= 0xFF,
+};
+
+/**
+ * struct blk_se - Zoned device storage element descriptor.
+ *
+ * @id: The ID of the element (cannot be 0).
+ * @paired_id: The ID of the paired element for an element that is not
+ *	       of type BLK_SE_TYPE_RDWR.
+ * @nr_zones: The number of zones that the storage element handles.
+ * @type: The type of the storage element (enum blk_se_type).
+ * @status: The health status of the storage element
+ *	    (enum blk_se_status).
+ * @restore_allowed: Indicate if the storage element can be restored.
+ * @reserved: unused field to align this structure size to 32B
+ */
+struct blk_se {
+	__u32	id;
+	__u32	paired_id;
+	__u64	nr_zones;
+	__u8	type;
+	__u8	status;
+	__u8	restore_allowed;
+	__u8	reserved[13];
+};
+
 #endif /* _UAPI_BLKZONED_H */
-- 
2.55.0

