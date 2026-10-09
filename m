Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC94949B1E2;
	Fri,  9 Oct 2026 09:09:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791536993; cv=none; b=nRC/mYIZCmhHEFEk6Lr7MPyZcMRwZn4baqc9KpVJO+C5VRKWVhdKQh5e8J7JDJFy/x78vvUXrzNmpos4um6iA1kYVe4zWif0yactAA+XO7xqFcJCCOl+NBqfoFG1G7l2JR6mrvyY97C9KOXdsIdqVipQhUEFbJ2Z43m+J0i+5tI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791536993; c=relaxed/simple;
	bh=itIatVxLtZKOpVxSCkyz/0rSLfB+xAVSNj5VLdfH/i4=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BwFmZ1Y71uPTom3kAj40h7ymaf6JDxqIq63BsjM/OK+/tHDuUzOUwKVHNQeU728X1/eTeD3NheZwUP1CsFSoUGSFdmh+6P6d+N7XBuYqmR6u5yAVpVHvfQdYvaVH85cxY9Q0iHwI9VMRkx2VNkqe+9RG2xYjGKCd/6uj/bO4tzo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cPjWYoxx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cPjWYoxx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7DC91F00893;
	Fri,  9 Oct 2026 09:09:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791536991;
	bh=M5YE52WGkYl+xw0D8MeUTYjUkK0/bznxDd7aDyjZWrQ=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=cPjWYoxx6sfOs3XPoqvTdjR72ygHprZ5DBXyPmzGqtsLg2ZDxjFRbtYCzm/FMm6ng
	 hq0fGtBRzwPKZMy5Owr9hE3HA7so9nc+P5u2A2uU596aEOOz5yXsLE8mKRPC83DVkc
	 74kTIWBwuGW5jNFmeylzcEc0hhqgDha9TqWBOX+AYIBqPewcJDq76IrKXF5GNiP519
	 LlxjtNUd4S7Pu6rqxnCsYwgD6YycKvtJ3A/F28xK30jDPJoE0KEoZv3eBzD3V0Psq/
	 2WS+VIWz2t/UdMqEAiNGruOuutNb2vVnde422CUUE0od6aUggiOsAzspQvV6kdGOQ8
	 tXsU2ZJiypvGA==
From: Damien Le Moal <dlemoal@kernel.org>
To: Jens Axboe <axboe@kernel.dk>,
	linux-block@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Subject: [PATCH v4 4/9] block: add storage element management ioctls
Date: Fri,  9 Oct 2026 18:09:40 +0900
Message-ID: <20261009090945.1504194-5-dlemoal@kernel.org>
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

Define the new ioctl commands BLKGETNRSTORELEMS, BLKREPORTSTORELEMS,
BLKREMOVESTORELEM, and BLKRESTORESTORELEMS to provide users accessing
zoned block devices directly with an interface to the storage elements
management operations of the block layer.

The ioctls BLKGETNRSTORELEMS and BLKREPORTSTORELEMS are defined to
respectively get the number of storage elements of a zoned device and to
get an array of struct blk_storage_element describing the current state of
the device storage elements.

The ioctl BLKREMOVESTORELEM can be used to remove (depopulate) a storage
element that has a degraded status (i.e. BLK_SE_STS_DEGRADED).

Finally, the BLKRESTORESTORELEMS ioctl interfaces with
bdev_restore_storage_elements() to restore the depopulated storage
elements of a zoned device.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
---
 block/blk-zoned.c             | 150 ++++++++++++++++++++++++++++++++++
 block/blk.h                   |   9 ++
 block/ioctl.c                 |   5 ++
 include/uapi/linux/blkzoned.h |  20 +++++
 include/uapi/linux/fs.h       |   1 +
 5 files changed, 185 insertions(+)

diff --git a/block/blk-zoned.c b/block/blk-zoned.c
index 8ca5470d6517..10fb3ca5adcd 100644
--- a/block/blk-zoned.c
+++ b/block/blk-zoned.c
@@ -19,6 +19,7 @@
 #include <linux/kthread.h>
 #include <linux/freezer.h>
 #include <linux/delay.h>
+#include <linux/uaccess.h>
 
 #include <trace/events/block.h>
 
@@ -2835,6 +2836,56 @@ int bdev_report_storage_elements(struct block_device *bdev,
 }
 EXPORT_SYMBOL_GPL(bdev_report_storage_elements);
 
+static int blkdev_get_nr_storage_elements_ioctl(struct block_device *bdev,
+						void __user *argp)
+{
+	struct gendisk *disk = bdev->bd_disk;
+
+	if (put_user(disk->nr_storage_elements, (unsigned int __user *)argp))
+		return -EFAULT;
+
+	return 0;
+}
+
+static int blkdev_report_storage_elements_ioctl(struct block_device *bdev,
+						void __user *argp)
+{
+	struct gendisk *disk = bdev->bd_disk;
+	struct blk_se_report *rep;
+	int ret;
+
+	if (!argp)
+		return -EINVAL;
+
+	rep = kzalloc_flex(*rep, elements, disk->nr_storage_elements);
+	if (!rep)
+		return -ENOMEM;
+
+	if (copy_from_user(rep, argp, sizeof(struct blk_se_report))) {
+		ret = -EFAULT;
+		goto free_rep;
+	}
+
+	rep->nr_elements = min(rep->nr_elements, disk->nr_storage_elements);
+	if (!rep->nr_elements) {
+		ret = -EINVAL;
+		goto free_rep;
+	}
+
+	ret = bdev_report_storage_elements(bdev, rep->elements,
+					   &rep->nr_elements);
+	if (ret)
+		goto free_rep;
+
+	if (copy_to_user(argp, rep, struct_size_t(struct blk_se_report,
+						  elements, rep->nr_elements)))
+		ret = -EFAULT;
+
+free_rep:
+	kfree(rep);
+	return ret;
+}
+
 /**
  * bdev_remove_storage_element - Remove (depopulate) a storage element of a
  *				 zoned block device
@@ -2895,6 +2946,54 @@ int bdev_remove_storage_element(struct block_device *bdev,
 }
 EXPORT_SYMBOL_GPL(bdev_remove_storage_element);
 
+static int blkdev_flush_and_truncate(struct block_device *bdev,
+				     blk_mode_t mode)
+{
+	int ret;
+
+	filemap_invalidate_lock(bdev->bd_mapping);
+	ret = blkdev_issue_flush(bdev->bd_disk->part0);
+	if (!ret)
+		ret = truncate_bdev_range(bdev, mode, 0,
+					  bdev_nr_bytes(bdev) - 1);
+	filemap_invalidate_unlock(bdev->bd_mapping);
+
+	return ret;
+}
+
+static int blkdev_remove_storage_element_ioctl(struct block_device *bdev,
+					blk_mode_t mode, void __user *argp)
+{
+	unsigned int element_id;
+	int ret;
+
+	if (!(mode & BLK_OPEN_WRITE))
+		return -EBADF;
+	if (bdev_read_only(bdev))
+		return -EPERM;
+
+	if (get_user(element_id, (unsigned int __user *)argp))
+		return -EFAULT;
+
+	inode_lock(bdev->bd_mapping->host);
+
+	/*
+	 * Flush the device volatile write cache and invalidate all cached data
+	 * so that reads do not return old data for zones that went offline.
+	 * Since a user can only write to zoned devices using direct IOs, we
+	 * should never have any dirty page invalidated and so no data loss as
+	 * long as the device cache flush succeeds, that is, as long as the
+	 * flush does not use degraded storage elements.
+	 */
+	ret = blkdev_flush_and_truncate(bdev, mode);
+	if (!ret)
+		ret = bdev_remove_storage_element(bdev, element_id);
+
+	inode_unlock(bdev->bd_mapping->host);
+
+	return ret;
+}
+
 /**
  * bdev_restore_storage_elements - Restore all depopulated storage elements of
  *				   a zoned block device
@@ -2946,6 +3045,32 @@ int bdev_restore_storage_elements(struct block_device *bdev)
 }
 EXPORT_SYMBOL_GPL(bdev_restore_storage_elements);
 
+static int blkdev_restore_storage_elements_ioctl(struct block_device *bdev,
+						 blk_mode_t mode)
+{
+	int ret;
+
+	if (!(mode & BLK_OPEN_WRITE))
+		return -EBADF;
+	if (bdev_read_only(bdev))
+		return -EPERM;
+
+	inode_lock(bdev->bd_mapping->host);
+
+	/*
+	 * Storage element restoration is a destructive operation that will
+	 * reset all zones. So fflush the device volatile write cache and
+	 * invalidate all cached data that we may have.
+	 */
+	ret = blkdev_flush_and_truncate(bdev, mode);
+	if (!ret)
+		ret = bdev_restore_storage_elements(bdev);
+
+	inode_unlock(bdev->bd_mapping->host);
+
+	return ret;
+}
+
 int disk_init_storage_element_mgmt(struct gendisk *disk)
 {
 	int ret;
@@ -2978,3 +3103,28 @@ int disk_init_storage_element_mgmt(struct gendisk *disk)
 
 	return 0;
 }
+
+int blkdev_zone_storage_elements_ioctl(struct block_device *bdev,
+				       blk_mode_t mode, unsigned int cmd,
+				       void __user *argp)
+{
+	struct gendisk *disk = bdev->bd_disk;
+
+	if (!disk->nr_storage_elements)
+		return -ENOTTY;
+
+	switch (cmd) {
+	case BLKGETNRSTORELEMS:
+		return blkdev_get_nr_storage_elements_ioctl(bdev, argp);
+	case BLKREPORTSTORELEMS:
+		return blkdev_report_storage_elements_ioctl(bdev, argp);
+	case BLKREMOVESTORELEM:
+		return blkdev_remove_storage_element_ioctl(bdev, mode, argp);
+	case BLKRESTORESTORELEMS:
+		return blkdev_restore_storage_elements_ioctl(bdev, mode);
+	default:
+		break;
+	}
+
+	return -ENOTTY;
+}
diff --git a/block/blk.h b/block/blk.h
index 39d90747b40f..bbf523c9579c 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -579,6 +579,9 @@ int blkdev_report_zones_ioctl(struct block_device *bdev, unsigned int cmd,
 int blkdev_zone_mgmt_ioctl(struct block_device *bdev, blk_mode_t mode,
 		unsigned int cmd, unsigned long arg);
 bool bdev_zone_mgmt_allowed(struct block_device *bdev, sector_t sector);
+int blkdev_zone_storage_elements_ioctl(struct block_device *bdev,
+				       blk_mode_t mode, unsigned int cmd,
+				       void __user *argp);
 #else /* CONFIG_BLK_DEV_ZONED */
 static inline int disk_init_storage_element_mgmt(struct gendisk *disk)
 {
@@ -630,6 +633,12 @@ static inline bool bdev_zone_mgmt_allowed(struct block_device *bdev,
 {
 	return false;
 }
+static inline int blkdev_zone_storage_elements_ioctl(struct block_device *bdev,
+					blk_mode_t mode, unsigned int cmd,
+					void __user *argp)
+{
+	return -ENOTTY;
+}
 #endif /* CONFIG_BLK_DEV_ZONED */
 
 struct block_device *bdev_alloc(struct gendisk *disk, u8 partno);
diff --git a/block/ioctl.c b/block/ioctl.c
index 64b4e6c0f696..ccf806c2e37d 100644
--- a/block/ioctl.c
+++ b/block/ioctl.c
@@ -679,6 +679,11 @@ static int blkdev_common_ioctl(struct block_device *bdev, blk_mode_t mode,
 		return put_uint(argp, bdev_zone_sectors(bdev));
 	case BLKGETNRZONES:
 		return put_uint(argp, bdev_nr_zones(bdev));
+	case BLKGETNRSTORELEMS:
+	case BLKREPORTSTORELEMS:
+	case BLKREMOVESTORELEM:
+	case BLKRESTORESTORELEMS:
+		return blkdev_zone_storage_elements_ioctl(bdev, mode, cmd, argp);
 	case BLKROGET:
 		return put_int(argp, bdev_read_only(bdev) != 0);
 	case BLKSSZGET: /* get block device logical block size */
diff --git a/include/uapi/linux/blkzoned.h b/include/uapi/linux/blkzoned.h
index f9ecd54210d0..e6c60fba6ac9 100644
--- a/include/uapi/linux/blkzoned.h
+++ b/include/uapi/linux/blkzoned.h
@@ -270,4 +270,24 @@ struct blk_se {
 	__u8	reserved[13];
 };
 
+struct blk_se_report {
+	__u32		nr_elements;
+	__u32		reserved;
+	struct blk_se	elements[];
+};
+
+/**
+ * Zoned block device storage element management ioctl's:
+ *
+ * @BLKGETNRSTORELEMS: Get the number of storage elements of the device.
+ * @BLKREPORTSTORELEMS: Get the device storage elements.
+ * @BLKREMOVESTORELEM: Remove (depopulate) one storage element of a device.
+ * @BLKRESTORESTORELEM: Restore (repopulate if possible) all storage elements
+ *			that have been removed.
+ */
+#define BLKGETNRSTORELEMS   _IOR(0x12, 143, __u32)
+#define BLKREPORTSTORELEMS  _IOWR(0x12, 144, struct blk_se_report)
+#define BLKREMOVESTORELEM   _IOW(0x12, 145, __u32)
+#define BLKRESTORESTORELEMS _IO(0x12, 146)
+
 #endif /* _UAPI_BLKZONED_H */
diff --git a/include/uapi/linux/fs.h b/include/uapi/linux/fs.h
index 34c6f219462a..8a979326aa7f 100644
--- a/include/uapi/linux/fs.h
+++ b/include/uapi/linux/fs.h
@@ -309,6 +309,7 @@ struct file_attr {
 /* 130-136 and 142 are used by zoned block device ioctls (uapi/linux/blkzoned.h) */
 /* 137-141 are used by blk-crypto ioctls (uapi/linux/blk-crypto.h) */
 #define BLKTRACESETUP2 _IOWR(0x12, 142, struct blk_user_trace_setup2)
+/* 143-146 are used by storage element management for zoned block devices. */
 
 #define BMAP_IOCTL 1		/* obsolete - kept for compatibility */
 #define FIBMAP	   _IO(0x00,1)	/* bmap access */
-- 
2.55.0

