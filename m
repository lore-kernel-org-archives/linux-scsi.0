Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCF1846AA80;
	Mon,  5 Oct 2026 09:46:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791193604; cv=none; b=taW4dZIAH+18Co/Qke250hr5PkZAG8lIwMJBddxvZWgeDK3ovai4n9d6DBacWtH7p6Hnqb9c51BbmjMXYOniMpJXWsOxTfFVcIKI3CIh8xvkkMk4yEJAEgI+o4gkPYtip5rg2VbPUemIFpJ80eOwOWGLD7nuiZF2iJ+hZWiePUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791193604; c=relaxed/simple;
	bh=5HiFmXupAgh4SSqEDs9Ic98aARyJc2G6GqT4GFtZW6c=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H2JesBAhEyLR6QjMIIx6mvUNgynYrIokxZQMyKmRXKU4BLavYbChHaNAXRkmurblDiViDcOR5lNfVKfgMEhOlU9404q5wOPtXylyloItDlW916bOr0SLuFNGf+IL/fnZ/EUHANF8L7fR5UC3wgBmoM/b8odylZZCHLqAL0Tv7rY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NuP823n8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NuP823n8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BB401F00899;
	Mon,  5 Oct 2026 09:46:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791193596;
	bh=n4vliGVCaORgoLmBAkq5E6ew7bAd/WKKg0cluWJRS8o=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=NuP823n8evFRu4NWIW3j+Ht6+qqLZLTdaSSPcP0eRgf/xA6V+kMu8xxiQ+6l4ujJ0
	 N8lj8h0saJQCCXc88uoRmrqsteG2kjdBEP4672oAfE0A2g4FvHFs5Ybz74pcL5P7SQ
	 I++e3+a+rsKGydxcvxJvZDEE3oRqZwzKnYx1O/S0KajzKpE6dYpUPnX7c5Go/l4cBW
	 nBBWkgDIvza0IcV4me7PLGYw58QE3So2oSkEDdH0vZzG4kyy2NofD6NnTuM/sX6Huj
	 gyt4yZqWGSgikWEHt7xw5MjOatz/17VONiOjhI7l3OY3zGHLG4pPASo6WUDSc3a4wX
	 NSSev0sSj8YwA==
From: Damien Le Moal <dlemoal@kernel.org>
To: Jens Axboe <axboe@kernel.dk>,
	linux-block@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 2/7] block: introduce storage element management
Date: Mon,  5 Oct 2026 18:46:27 +0900
Message-ID: <20261005094632.580753-3-dlemoal@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261005094632.580753-1-dlemoal@kernel.org>
References: <20261005094632.580753-1-dlemoal@kernel.org>
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

The set of operations is defined with struct blk_storage_elements_ops and
includes three operations:
 - report_elements: get information on a device storage elements state
 - remove_element: depopulate a defective storage element
 - restore_elements: restore depopulated storage elements

Each operation is called from the functions
bdev_report_storage_elements(), bdev_remove_storage_element() and
bdev_restore_storage_elements().

Removing a healthy storage element from a device is possible and useful
for testing. The storage element restoration operation restore_elements
allows repopulating such healthy element. Repopulating defective storage
elements is generally not allowed by devices.

The device drivers of zoned block devices can indicate support for the
storage element depopulation feature by specifying the storage element
management operations with the se_ops field of struct
block_device_operations.

Co-developed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
---
 block/blk-zoned.c             | 168 +++++++++++++++++++++++++++++++++-
 include/linux/blkdev.h        |  16 ++++
 include/uapi/linux/blkzoned.h |  67 ++++++++++++++
 3 files changed, 250 insertions(+), 1 deletion(-)

diff --git a/block/blk-zoned.c b/block/blk-zoned.c
index 131c9f50b3da..b713512f7d48 100644
--- a/block/blk-zoned.c
+++ b/block/blk-zoned.c
@@ -18,6 +18,7 @@
 #include <linux/mempool.h>
 #include <linux/kthread.h>
 #include <linux/freezer.h>
+#include <linux/delay.h>
 
 #include <trace/events/block.h>
 
@@ -2718,5 +2719,170 @@ int queue_zone_wplugs_show(void *data, struct seq_file *m)
 
 	return 0;
 }
-
 #endif
+
+static void disk_wait_for_se_mgmt_completion(struct gendisk *disk)
+{
+	struct blk_storage_element *elements, *e;
+	unsigned int i, nr_se, nr_elements = 0;
+	int ret;
+
+	ret = (disk->fops->se_ops->report_elements)(disk, &nr_elements, NULL);
+	if (ret) {
+		pr_err("Failed to get number of storage elements\n");
+		return;
+	}
+
+	elements = kzalloc_objs(struct blk_storage_element, nr_elements);
+	if (!elements)
+		return;
+
+	while (1) {
+		/*
+		 * Check if we have storage elements being removed or restored.
+		 */
+		nr_se = nr_elements;
+		ret = (disk->fops->se_ops->report_elements)(disk,
+						&nr_elements, elements);
+		if (ret) {
+			pr_err("Failed to get storage elements\n");
+			break;
+		}
+
+		e = elements;
+		for (i = 0; i < nr_se; i++, e++) {
+			if (e->status == BLK_SE_STS_REMOVE_IN_PROGRESS ||
+			    e->status == BLK_SE_STS_RESTORE_IN_PROGRESS)
+				break;
+		}
+		if (i >= nr_se)
+			break;
+
+		/* Not done yet: wait and retry. */
+		msleep(500);
+	}
+
+	kfree(elements);
+}
+
+/**
+ * bdev_report_storage_elements - report the storage elements of a block device
+ *
+ * Fill at most @nr_elements storage element descriptors in the array @elements.
+ * The number of storage elements filled in the array is returned using
+ * @nr_elements. If @elements is NULL, only @nr_elements is returned.
+ *
+ * Returns 0 on success and a negative error code on failure.
+ */
+int bdev_report_storage_elements(struct block_device *bdev,
+				 unsigned int *nr_elements,
+				 struct blk_storage_element *elements)
+{
+	struct gendisk *disk = bdev->bd_disk;
+
+	if (!bdev_is_zoned(bdev) || !disk->fops->se_ops)
+		return -EOPNOTSUPP;
+
+	if (!nr_elements)
+		return -EINVAL;
+
+	if (*nr_elements && !elements)
+		return -EINVAL;
+
+	return (disk->fops->se_ops->report_elements)(disk, nr_elements,
+						     elements);
+}
+EXPORT_SYMBOL_GPL(bdev_report_storage_elements);
+
+/**
+ * bdev_remove_storage_element - Remove (depopulate) a storage element of a
+ *				 block device
+ *
+ * Remove (depopulate) the storage element identified by @element_id from the
+ * block device @bdev.
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
+	if (!bdev_is_zoned(bdev) || !disk->fops->se_ops)
+		return -EOPNOTSUPP;
+
+	/* Zero is not a valid storage element ID. */
+	if (!element_id)
+		return -EINVAL;
+
+	/*
+	 * Freeze and unfreeze the queue to flush any outstanding command.
+	 * The caller is responsible for not queuing up more I/Os by higher
+	 * level means.
+	 */
+	memflags = blk_mq_freeze_queue(disk->queue);
+	blk_mq_unfreeze_queue(disk->queue, memflags);
+
+	/*
+	 * Flush the volatile write cache if there is any. Note that this may
+	 * lead to errors if degraded storage elements are used. So ignore
+	 * errors here.
+	 */
+	blkdev_issue_flush(disk->part0);
+
+	/* Invalidate all cached data. */
+	invalidate_inode_pages2_range(bdev->bd_mapping, 0,
+				      get_capacity(disk) << SECTOR_SHIFT);
+
+	ret = (disk->fops->se_ops->remove_element)(disk, element_id);
+	if (ret)
+		return ret;
+
+	/* Revalidate the device zones once the opration completes. */
+	disk_wait_for_se_mgmt_completion(disk);
+
+	return blk_revalidate_disk_zones(disk);
+}
+EXPORT_SYMBOL_GPL(bdev_remove_storage_element);
+
+/**
+ * bdev_restore_storage_elements - Restore all depopulated storage elements of a
+ *				   block device
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
+	if (!bdev_is_zoned(bdev) || !disk->fops->se_ops)
+		return -EOPNOTSUPP;
+
+	/*
+	 * Freeze and unfreeze the queue to flush any outstanding commands.
+	 * The caller is responsible for not queuing up more I/O by higher
+	 * level means.
+	 */
+	memflags = blk_mq_freeze_queue(disk->queue);
+	blk_mq_unfreeze_queue(disk->queue, memflags);
+
+	/* Invalidate all cached data. */
+	invalidate_inode_pages2_range(bdev->bd_mapping, 0,
+				      get_capacity(disk) << SECTOR_SHIFT);
+
+	ret = (disk->fops->se_ops->restore_elements)(disk);
+	if (ret)
+		return ret;
+
+	disk_wait_for_se_mgmt_completion(disk);
+
+	return blk_revalidate_disk_zones(disk);
+}
+EXPORT_SYMBOL_GPL(bdev_restore_storage_elements);
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index d003a9d2d1f6..0b2013c96cad 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1574,6 +1574,21 @@ enum blk_unique_id {
 	BLK_UID_NAA	= 3,
 };
 
+struct blk_storage_elements_ops {
+	int (*report_elements)(struct gendisk *disk,
+			       unsigned int *nr_elements,
+			       struct blk_storage_element *elements);
+	int (*remove_element)(struct gendisk *disk, unsigned int element_id);
+	int (*restore_elements)(struct gendisk *disk);
+};
+
+int bdev_report_storage_elements(struct block_device *bdev,
+				 unsigned int *nr_elements,
+				 struct blk_storage_element *elements);
+int bdev_remove_storage_element(struct block_device *bdev,
+				unsigned int element_id);
+int bdev_restore_storage_elements(struct block_device *bdev);
+
 struct block_device_operations {
 	void (*submit_bio)(struct bio *bio);
 	int (*poll_bio)(struct bio *bio, struct io_comp_batch *iob,
@@ -1601,6 +1616,7 @@ struct block_device_operations {
 			enum blk_unique_id id_type);
 	struct module *owner;
 	const struct pr_ops *pr_ops;
+	const struct blk_storage_elements_ops	*se_ops;
 
 	/*
 	 * Special callback for probing GPT entry at a given sector.
diff --git a/include/uapi/linux/blkzoned.h b/include/uapi/linux/blkzoned.h
index 663836120966..3a4bacfe7979 100644
--- a/include/uapi/linux/blkzoned.h
+++ b/include/uapi/linux/blkzoned.h
@@ -208,4 +208,71 @@ struct blk_zone_range {
 #define BLKFINISHZONE	_IOW(0x12, 136, struct blk_zone_range)
 #define BLKREPORTZONEV2	_IOWR(0x12, 142, struct blk_zone_report)
 
+/**
+ * enum blk_storage_element_status - Statuc of a zoned device storage elements.
+ *
+ * @BLK_SE_RDWR: The storage element handles both reads and writes.
+ * @BLK_SE_READ: The storage element handles reads only.
+ * @BLK_SE_WRITE: The storage element handles writes only.
+ * @BLK_SE_WRITE: The storage element type is unknown.
+ */
+enum blk_storage_element_type {
+	BLK_SE_TYPE_RDWR		= 0x01,
+	BLK_SE_TYPE_READ		= 0x02,
+	BLK_SE_TYPE_WRITE		= 0x03,
+	BLK_SE_TYPE_UNKNOWN		= 0xFF,
+};
+
+/**
+ * enum blk_storage_element_status - Status of a zoned device storage elements.
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
+enum blk_storage_element_status {
+	BLK_SE_STS_OK			= 0x01,
+	BLK_SE_STS_DEGRADED		= 0x02,
+	BLK_SE_STS_REMOVE_IN_PROGRESS	= 0x03,
+	BLK_SE_STS_REMOVE_ERROR		= 0x04,
+	BLK_SE_STS_RESTORE_IN_PROGRESS	= 0x05,
+	BLK_SE_STS_RESTORE_ERROR	= 0x06,
+	BLK_SE_STS_REMOVED		= 0x07,
+	BLK_SE_STS_UNKOWN		= 0xFF,
+};
+
+/**
+ * struct blk_storage_element - Zoned device storage element descriptor.
+ *
+ * @id: The ID of the element (cannot be 0).
+ * @paired_id: The ID of the paired element for an element that is not
+ *	       of type BLK_SE_TYPE_RDWR.
+ * @type: The type of the storage element (enum blk_storage_element_type).
+ * @status: The health status of the storage element
+ *	    (enum blk_storage_element_status).
+ * @restore_allowed: Indicate if the storage element can be restored.
+ * @nr_zones: The number of zones that the storage element handles.
+ */
+struct blk_storage_element {
+	__u32	id;
+	__u32	paired_id;
+	__u64	nr_zones;
+	__u8	type;
+	__u8	status;
+	__u8	restore_allowed;
+	__u8	reserved[5];
+};
+
+struct blk_storage_elements_report {
+	__u32				nr_elements;
+	__u32				reserved;
+	struct blk_storage_element	elements[];
+};
+
 #endif /* _UAPI_BLKZONED_H */
-- 
2.55.0

