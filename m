Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794217912;
	b=ZFmkPrKiyE1Pzxs9THBgvTf2kx0XZT2ICOzVSNuwkQULB5Xa4ehG3CQKGWz+TOXe/Bgd
	 ZZ9Dk0q9AdCIiaGfWVRAd/LoKeRrq8Q472lFjTXTi51c8CEo4u7g9oWpC7QO5GrSC5PuE
	 HmHj19LXmsyCkxlm5vSEY4rYiBg/mNKeo3zgT6uJkMYtzyFVadbEhudPpS6Ct1b+OYtno
	 KalgcJFhMuaQTf5lPcQiZUvqiJmFF/NF9cIlU5LfkxoMLIbBrfOZJR/vRxO3oSVw0R3eI
	 fq9/61G0lfMoz5nRthnQUUPFfxwEOiOy8nkzq3jV8liMslPItldbfaqYfk6SWpILDoA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794217912;
	h=Received:DKIM-Signature:From:To:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=AVv+Um4kLF0uXrWHTXIMyVzhzrqjEMQn//6pbbz+jes=;
	b=gdKS6TumngwWJsZQ8HnLIoNGy79Cbuot2YoiElNROEIWMH5FhPvT1lgJWY26y1QSVYbl
	 3UWhTC/y4zXM6x0faAk6KXwhZbJn02Z0RpY/BV6Ky6MZN3NXSLQKxkwNMAkOvwPCj+jDj
	 Cd2tsoK+Vvs1KH1EL8C8CjZBLgFg7d8zpBjiEfBNAlAswxCAWutO7fZ/3R/buSlaXRwa1
	 kpI6V/C4DLs+RMJ2XShSGV1KCryKt0Q26Jz9Q6ZNd7NA7DYdXxogU8DlVZQOv7uJbcUUe
	 6y5dhbyKBAgQkqIbWeDcaHdJyQBBjWv3zrKW2PE+4FL8FRIKpfB86/YSZb5EAEntvUA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gYotT4OP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FBA8606A330;
	Mon,  9 Nov 2026 09:51:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gYotT4OP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D0681F008A6;
	Mon,  9 Nov 2026 09:51:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794217911;
	bh=AVv+Um4kLF0uXrWHTXIMyVzhzrqjEMQn//6pbbz+jes=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=gYotT4OPic/wN9ZiXcfZmYn2CzRMKzhDCREsKZLuVbZNMMzxOrbhVJ+nEUIKDuk8p
	 Q1GtSrAHv811fsiy9MsWBbYB7AjsTst/o9VUOLdJtt6fLyRa8RCDu2YLecMK4Ecwvz
	 3VQ28rgKFLwMczkrdVWtkSR0N/FPJcN0dwfZilaBBxYKsGUrNb2QOhyQL9K8YLiXVe
	 ZAVpbSIKZX+mqKM3qcnqmIUIN1YjVoyfKXt7NyHgzWZPmZVMQv5XQ0aulhe3DSEjl3
	 AkfF/gH3xGpLw0TzjVrf0oBsv8F1+R6X6cWWV5/bgEGbHFkAw55SqDNuZa43cj4iUx
	 TIBBhbOTguCEw==
From: Damien Le Moal <dlemoal@kernel.org>
To: Jens Axboe <axboe@kernel.dk>,
	linux-block@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Subject: [PATCH v8 04/12] block: introduce storage element management
Date: Mon,  9 Nov 2026 18:51:36 +0900
Message-ID: <20261109095144.819709-5-dlemoal@kernel.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261109095144.819709-1-dlemoal@kernel.org>
References: <20261109095144.819709-1-dlemoal@kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Recent SCSI (SBC) and ATA (ACS) standards define the storage element
depopulation feature. This feature is intended for managing hard-disks
heads, either combined read-write heads or pairs of read and write heads,
allowing to keep disks with defective heads longer in production by
allowing "depopulating" (removing) defective heads.

This feature comes in two different flavors:
 - A destructive version which removes a head and reformats the disk at a
   lower capacity point, restoring a fully functional contiguous LBA
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
 - remove_element: depopulate a defective storage element, blocking until
   the operation completes.
 - restore_elements: restore depopulated storage elements, blocking until
   the operation completes.

Each operation is called from the functions
bdev_report_storage_elements(), bdev_remove_storage_element() and
bdev_restore_storage_elements() respectively.

Removing a healthy storage element from a device is possible and useful
for testing. The storage element restoration operation restore_elements
allows repopulating such healthy element. Repopulating defective storage
elements is generally not allowed by devices.

The remove_element and restore_elements operations are executed under the
zone revalidation lock so that they are serialized against each other and
also serialized against user initiated device revalidation, thus allowing
to always have a consistent view of the device zone conditions after
executing these operations. In case of failure, zone revalidation is still
executed, which may give an unstable view of the zone states. In such
case, stable zone states will be recovered with zone access error handling
or later zone revalidation.

The device drivers of zoned block devices can indicate support for the
storage element depopulation feature by specifying the storage element
management operations with the se_ops field of struct
block_device_operations.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
---
 block/blk-zoned.c             | 205 ++++++++++++++++++++++++++++++++++
 block/blk.h                   |   5 +
 block/genhd.c                 |   4 +
 include/linux/blkdev.h        |  55 +++++++++
 include/uapi/linux/blkzoned.h |  65 +++++++++++
 5 files changed, 334 insertions(+)

diff --git a/block/blk-zoned.c b/block/blk-zoned.c
index 3761e634650e..30e61dbd89d6 100644
--- a/block/blk-zoned.c
+++ b/block/blk-zoned.c
@@ -2736,3 +2736,208 @@ int queue_zone_wplugs_show(void *data, struct seq_file *m)
 }
 
 #endif
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
+ * indicate the maximum number of storage elements of @bdev. This function may
+ * sleep.
+ *
+ * Returns 0 on success and a negative error code on failure.
+ */
+int bdev_report_storage_elements(struct block_device *bdev,
+				 struct blk_se *elements,
+				 unsigned int *nr_elements)
+{
+	struct gendisk *disk = bdev->bd_disk;
+
+	if (test_bit(GD_DEAD, &disk->state))
+		return -ENODEV;
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
+ * necessary dirty page and device write cache flush and invalidation of cached
+ * data. This function will block until the storage element is removed or an
+ * error occurs.
+ *
+ * Returns 0 on success and a negative error code on failure.
+ */
+int bdev_remove_storage_element(struct block_device *bdev,
+				unsigned int element_id)
+{
+	struct gendisk *disk = bdev->bd_disk;
+	unsigned int memflags;
+	int ret, err;
+
+	if (test_bit(GD_DEAD, &disk->state))
+		return -ENODEV;
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
+	/* Initiate the storage element removal and wait for its completion. */
+	ret = disk->fops->se_ops->remove_element(disk, element_id);
+
+	/*
+	 * Always revalidate zones, even in the case of an error as we do not
+	 * know what condition the zones of the block device are in.
+	 */
+	err = disk_revalidate_zones(disk, false);
+	if (err && !ret)
+		ret = err;
+
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
+ * elements may be restored by this operation. This operation is destructive and
+ * will result in all sequential zones to be transitioned to the empty condition.
+ * The caller is responsible for taking care of any necessary invalidation of
+ * cached data. This function will block until the storage elements are restored
+ * or an error occurs.
+ *
+ * Returns 0 on success and a negative error code on failure.
+ */
+int bdev_restore_storage_elements(struct block_device *bdev)
+{
+	struct gendisk *disk = bdev->bd_disk;
+	unsigned int memflags;
+	int ret, err;
+
+	if (test_bit(GD_DEAD, &disk->state))
+		return -ENODEV;
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
+	/*
+	 * Initiate the storage elements restoration and wait for its
+	 * completion.
+	 */
+	ret = disk->fops->se_ops->restore_elements(disk);
+
+	/*
+	 * Always revalidate zones, even in the case of an error as we do not
+	 * know what condition the zones of the block device are in. Note that
+	 * since all sequential zones should have been transitioned to the empty
+	 * condition, we can drop all zone write plugs. If an error occured and
+	 * not all sequential zones are empty, the revalidation will reinstate
+	 * the write plugs for these zones.
+	 */
+	err = disk_revalidate_zones(disk, true);
+	if (err && !ret)
+		ret = err;
+
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
+	 * Storage element operations are for zoned disks only and are
+	 * optional...
+	 */
+	if (!blk_queue_is_zoned(disk->queue) || !disk->fops->se_ops)
+		return 0;
+
+	/* ...but if defined, all operation callbacks must be defined. */
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
index 0e38e4b88cf5..05e2692b80d5 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -543,6 +543,7 @@ static inline void ioc_clear_queue(struct request_queue *q)
 #endif /* CONFIG_BLK_ICQ */
 
 #ifdef CONFIG_BLK_DEV_ZONED
+int disk_init_storage_element_mgmt(struct gendisk *disk);
 void disk_init_zone_resources(struct gendisk *disk);
 void disk_release_zone_resources(struct gendisk *disk);
 static inline bool bio_zone_write_plugging(struct bio *bio)
@@ -595,6 +596,10 @@ int blkdev_zone_mgmt_ioctl(struct block_device *bdev, blk_mode_t mode,
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
index 69204d44adae..251a5b07baff 100644
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
index a2c36b4e6308..63c6e43ecdda 100644
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
@@ -951,6 +956,13 @@ static inline unsigned int bdev_zone_capacity(struct block_device *bdev,
 
 bool bdev_zone_is_seq(struct block_device *bdev, sector_t sector);
 
+int bdev_report_storage_elements(struct block_device *bdev,
+				 struct blk_se *elements,
+				 unsigned int *nr_elements);
+int bdev_remove_storage_element(struct block_device *bdev,
+				unsigned int element_id);
+int bdev_restore_storage_elements(struct block_device *bdev);
+
 #else /* CONFIG_BLK_DEV_ZONED */
 static inline unsigned int disk_nr_zones(struct gendisk *disk)
 {
@@ -977,6 +989,25 @@ static inline bool blk_zone_plug_bio(struct bio *bio, unsigned int nr_segs)
 {
 	return false;
 }
+
+static inline int bdev_report_storage_elements(struct block_device *bdev,
+					       struct blk_se *elements,
+					       unsigned int *nr_elements)
+{
+	return -EOPNOTSUPP;
+}
+
+static inline int bdev_remove_storage_element(struct block_device *bdev,
+					      unsigned int element_id)
+{
+	return -EOPNOTSUPP;
+}
+
+static inline int bdev_restore_storage_elements(struct block_device *bdev)
+{
+	return -EOPNOTSUPP;
+}
+
 #endif /* CONFIG_BLK_DEV_ZONED */
 
 static inline unsigned int bdev_nr_zones(struct block_device *bdev)
@@ -1581,6 +1612,29 @@ enum blk_unique_id {
 	BLK_UID_NAA	= 3,
 };
 
+/**
+ * struct blk_se_ops - Storage element management operations.
+ * @report_elements: Report at most nr_elements storage elements of the
+ *		     specified disk. If the elements argument is NULL, only
+ *		     report the number of storage elements of the target disk.
+ * @remove_element: Remove (depopulate) the specified storage element from the
+ *		    target disk. This is a blocking operation called with
+ *		    zone_revalidate_mutex held. This callback must return only
+ *		    after the remove operation completes or an error occurs.
+ * @restore_elements: Restore (re-populate), if possible, all removed storage
+ *		      elements of the target disk. This operation is called with
+ *		      zone_revalidate_mutex held. This callback must return only
+ *		      after the restoration operation completes or an error
+ *		      occurs.
+ */
+struct blk_se_ops {
+	int (*report_elements)(struct gendisk *disk,
+			       struct blk_se *elements,
+			       unsigned int *nr_elements);
+	int (*remove_element)(struct gendisk *disk, unsigned int element_id);
+	int (*restore_elements)(struct gendisk *disk);
+};
+
 struct block_device_operations {
 	void (*submit_bio)(struct bio *bio);
 	int (*poll_bio)(struct bio *bio, struct io_comp_batch *iob,
@@ -1610,6 +1664,7 @@ struct block_device_operations {
 				   struct dma_buf_io_ctx *);
 	struct module *owner;
 	const struct pr_ops *pr_ops;
+	const struct blk_se_ops	*se_ops;
 
 	/*
 	 * Special callback for probing GPT entry at a given sector.
diff --git a/include/uapi/linux/blkzoned.h b/include/uapi/linux/blkzoned.h
index 663836120966..9d7f59da3efc 100644
--- a/include/uapi/linux/blkzoned.h
+++ b/include/uapi/linux/blkzoned.h
@@ -208,4 +208,69 @@ struct blk_zone_range {
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
+ * @BLK_SE_STS_OK_LIMIT: The storage element is operating at the manufacturer
+ *			 specifications limit.
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
+	BLK_SE_STS_OK_LIMIT		= 0x02,
+	BLK_SE_STS_DEGRADED		= 0x03,
+	BLK_SE_STS_REMOVE_IN_PROGRESS	= 0x04,
+	BLK_SE_STS_REMOVE_ERROR		= 0x05,
+	BLK_SE_STS_RESTORE_IN_PROGRESS	= 0x06,
+	BLK_SE_STS_RESTORE_ERROR	= 0x07,
+	BLK_SE_STS_REMOVED		= 0x08,
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
2.56.0

