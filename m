Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 369B14195C8;
	Tue,  6 Oct 2026 12:45:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791290725; cv=none; b=da+/im7Qo1L+SQLkfs7wRof6Qmm4NMV34QSFqAksvkfV+QHGhLHtYLjhzDemzSPPNcWwN/kqNzfkuHRPTR9IHZUObNIiMQNLSYCm8qzRC3fkXS5FSNKBjd49q6doUK5VJrK0ytjqPNHlzaqpDdAPIA7VLeigOtBbyXzfei2XTlk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791290725; c=relaxed/simple;
	bh=uiqc7HquSo53Nw2piSkuuuY99A0WL1nFoGz9P5MoKb4=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=thBi8+6y68D9mwHeqfPTlRVvkXUkDYuF8+MqvG7BRm4fYs0TsynhC5k+jhUiCZwqsuAe+ppeQyp4iV7gWPwO6+HjQR5QabbS6HQRwoRRz0iziiDf8IL0zGYWyRdFIWwvMj0aBg/u+h2+p/hSO4L501D2i6RFE/ru6BFPp+DDG+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=A0KRoIn9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="A0KRoIn9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 642641F00898;
	Tue,  6 Oct 2026 12:45:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791290714;
	bh=PrA/mzFRXAdmg83JQ4SDV6iZyN98NtuRuOG6A+dpQi4=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=A0KRoIn9Zk7YP3R8NPzGnFqXlHznbNDVRyfuCKkG7meYcm59l4aHgllBvpp+rxD3u
	 IdHVd8qXTswEn3TTUL1SifSF3aJmAprSALAIjMnKktCdhwdCsW3Mfw/iq7GZZ5df8a
	 nUqyL/W6S+CEai8+OuzFDH+KbdrEvWYSj2zROZpWurtmZZa04BwrXVa3v9G/8fTpjY
	 h1OssdJiCmxUJWNUu0F1iYY9FTPW+PDEInpAzoR6u9TqKbriMFIbberrK7tX9L0N9V
	 CSjwc1H/2ot5eDDTriW6XVUbxZaRtnJPY1G7klN3Gej66BiIvJUc4QnvbxNw/txGYn
	 xq85PjsN/p8MQ==
From: Damien Le Moal <dlemoal@kernel.org>
To: Jens Axboe <axboe@kernel.dk>,
	linux-block@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Subject: [PATCH v2 2/7] block: introduce storage element management
Date: Tue,  6 Oct 2026 21:45:05 +0900
Message-ID: <20261006124510.882017-3-dlemoal@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261006124510.882017-1-dlemoal@kernel.org>
References: <20261006124510.882017-1-dlemoal@kernel.org>
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
 block/blk-zoned.c             | 160 +++++++++++++++++++++++++++++++++-
 include/linux/blkdev.h        |  16 ++++
 include/uapi/linux/blkzoned.h |  67 ++++++++++++++
 3 files changed, 242 insertions(+), 1 deletion(-)

diff --git a/block/blk-zoned.c b/block/blk-zoned.c
index 131c9f50b3da..be57644ee266 100644
--- a/block/blk-zoned.c
+++ b/block/blk-zoned.c
@@ -18,6 +18,7 @@
 #include <linux/mempool.h>
 #include <linux/kthread.h>
 #include <linux/freezer.h>
+#include <linux/delay.h>
 
 #include <trace/events/block.h>
 
@@ -2718,5 +2719,162 @@ int queue_zone_wplugs_show(void *data, struct seq_file *m)
 
 	return 0;
 }
-
 #endif
+
+static int disk_wait_for_se_mgmt_completion(struct gendisk *disk)
+{
+	struct blk_storage_element *elements, *e;
+	unsigned int i, nr_se, nr_elements = 0;
+	int ret;
+
+	ret = disk->fops->se_ops->report_elements(disk, NULL, &nr_elements);
+	if (ret) {
+		pr_err("Failed to get number of storage elements\n");
+		return ret;
+	}
+
+	elements = kzalloc_objs(struct blk_storage_element, nr_elements);
+	if (!elements)
+		return -ENOMEM;
+
+	while (1) {
+		/*
+		 * Check if we have storage elements being removed or restored.
+		 */
+		nr_se = nr_elements;
+		ret = disk->fops->se_ops->report_elements(disk, elements,
+							  &nr_se);
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
+
+	return ret;
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
+				 struct blk_storage_element *elements,
+				 unsigned int *nr_elements)
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
+	return disk->fops->se_ops->report_elements(disk, elements, nr_elements);
+}
+EXPORT_SYMBOL_GPL(bdev_report_storage_elements);
+
+/**
+ * bdev_remove_storage_element - Remove (depopulate) a storage element of a
+ *				 block device
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
+	ret = disk->fops->se_ops->remove_element(disk, element_id);
+	if (ret)
+		return ret;
+
+	/* Revalidate the device zones once the opration completes. */
+	ret = disk_wait_for_se_mgmt_completion(disk);
+	if (ret)
+		return ret;
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
+	ret = disk->fops->se_ops->restore_elements(disk);
+	if (ret)
+		return ret;
+
+	ret = disk_wait_for_se_mgmt_completion(disk);
+	if (ret)
+		return ret;
+
+	return blk_revalidate_disk_zones(disk);
+}
+EXPORT_SYMBOL_GPL(bdev_restore_storage_elements);
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index d003a9d2d1f6..859917b3b256 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1574,6 +1574,21 @@ enum blk_unique_id {
 	BLK_UID_NAA	= 3,
 };
 
+struct blk_storage_elements_ops {
+	int (*report_elements)(struct gendisk *disk,
+			       struct blk_storage_element *elements,
+			       unsigned int *nr_elements);
+	int (*remove_element)(struct gendisk *disk, unsigned int element_id);
+	int (*restore_elements)(struct gendisk *disk);
+};
+
+int bdev_report_storage_elements(struct block_device *bdev,
+				 struct blk_storage_element *elements,
+				 unsigned int *nr_elements);
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
index 663836120966..f8f2c2651dff 100644
--- a/include/uapi/linux/blkzoned.h
+++ b/include/uapi/linux/blkzoned.h
@@ -208,4 +208,71 @@ struct blk_zone_range {
 #define BLKFINISHZONE	_IOW(0x12, 136, struct blk_zone_range)
 #define BLKREPORTZONEV2	_IOWR(0x12, 142, struct blk_zone_report)
 
+/**
+ * enum blk_storage_element_status - Status of a zoned device storage elements.
+ *
+ * @BLK_SE_TYPE_RDWR: The storage element handles both reads and writes.
+ * @BLK_SE_TYPE_READ: The storage element handles reads only.
+ * @BLK_SE_TYPE_WRITE: The storage element handles writes only.
+ * @BLK_SE_TYPE_UNKNOWN: The storage element type is not known.
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
+	BLK_SE_STS_UNKNOWN		= 0xFF,
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

