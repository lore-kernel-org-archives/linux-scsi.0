Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C8BC3750D5;
	Mon, 12 Oct 2026 13:01:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791810092; cv=none; b=WGxVA0T9+SrScEccqob3bgI76TuplmCZZcPVI5eA4CAZE59TplY1T0mRukWLwp9tgAQwIm4SgJmXT1vDgOJTR3CZTwHHWRMMyDR5CzmhSFMEcs4kLar5z6Eg8sXaJHfzn6wyoLbkffakOjRW5S+mE7rBhulCkPbXWpSzgXQy5s8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791810092; c=relaxed/simple;
	bh=WJR+lY/+eDU/cbDm2U58aUaSIWDVspZ1QRYnJFqqnVw=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=StwlUXzxjQ/sOAM66zYPswZ4gOW3O9OQmXcTiQe1FX39LnrA9GySzcX5Dj3BSepopL3aewnKlVGrz/8/NPwZKjHLAWNk0xNwdsMwOqxpTBDU2qCXfR8pIq84P25M3cMElhag5b3GWTVCwxi/edQLpuIgrfcD1GEvHmLh8rP27cM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Mg02VsTJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Mg02VsTJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C77A31F0089C;
	Mon, 12 Oct 2026 13:01:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791810088;
	bh=WL7Rl/5dNEbl8KrjeFQkan7/8v6gfi9902IJy0CN3wY=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=Mg02VsTJnH27rm8rOrkDwKTQ5pTV6g8ACEYtfh2P35Qm6m4BIt58yFhsMDSDcT1nM
	 zbCDIjouYMFIEAlzXZMag104rEyC5/TYrkpDrGFcbtFtGjpbgXYB4K7G2ghR0831Px
	 j6rfPnhjXnF5vsPm61vTxKiPT5ZTXULr80qjYnnROVA3705K00TsjdFd5cuPCHjP3/
	 wRQdjVJaazJpneDv8i27visUgjPDFqQiuLOJhHCW52345Gvc33GDc+gX4UAo/3Ee7Y
	 8srt2BHFloi0z+VDMmQhXn9luuuqemqdPDCsPuafLdWD8DwMFicmFgQH8LHo3ty9RW
	 1focEVKZZCWOg==
From: Damien Le Moal <dlemoal@kernel.org>
To: Jens Axboe <axboe@kernel.dk>,
	linux-block@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Subject: [PATCH v5 4/9] block: add storage element management ioctls
Date: Mon, 12 Oct 2026 22:01:16 +0900
Message-ID: <20261012130121.1902634-5-dlemoal@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261012130121.1902634-1-dlemoal@kernel.org>
References: <20261012130121.1902634-1-dlemoal@kernel.org>
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
 block/blk-zoned.c             | 144 ++++++++++++++++++++++++++++++++++
 block/blk.h                   |   9 +++
 block/ioctl.c                 |   5 ++
 include/uapi/linux/blkzoned.h |  21 +++++
 include/uapi/linux/fs.h       |   1 +
 5 files changed, 180 insertions(+)

diff --git a/block/blk-zoned.c b/block/blk-zoned.c
index 46822c7a05ec..8736e80b4080 100644
--- a/block/blk-zoned.c
+++ b/block/blk-zoned.c
@@ -19,6 +19,7 @@
 #include <linux/kthread.h>
 #include <linux/freezer.h>
 #include <linux/delay.h>
+#include <linux/uaccess.h>
 
 #include <trace/events/block.h>
 
@@ -2846,6 +2847,56 @@ int bdev_report_storage_elements(struct block_device *bdev,
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
+	if (rep->nr_elements < disk->nr_storage_elements) {
+		ret = -EINVAL;
+		goto free_rep;
+	}
+
+	rep->nr_reported_elements = disk->nr_storage_elements;
+	ret = bdev_report_storage_elements(bdev, rep->elements,
+					   &rep->nr_reported_elements);
+	if (ret)
+		goto free_rep;
+
+	if (copy_to_user(argp, rep, struct_size_t(struct blk_se_report,
+					elements, rep->nr_reported_elements)))
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
@@ -2917,6 +2968,52 @@ int bdev_remove_storage_element(struct block_device *bdev,
 }
 EXPORT_SYMBOL_GPL(bdev_remove_storage_element);
 
+static int blkdev_flush_and_truncate(struct block_device *bdev,
+				     blk_mode_t mode)
+{
+	int ret;
+
+	inode_lock(bdev->bd_mapping->host);
+	filemap_invalidate_lock(bdev->bd_mapping);
+	ret = blkdev_issue_flush(bdev->bd_disk->part0);
+	if (!ret)
+		ret = truncate_bdev_range(bdev, mode, 0,
+					  bdev_nr_bytes(bdev) - 1);
+	filemap_invalidate_unlock(bdev->bd_mapping);
+	inode_unlock(bdev->bd_mapping->host);
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
+	/*
+	 * Flush the device volatile write cache and invalidate all cached data
+	 * so that reads do not return old data for zones that went offline.
+	 * Since a user can only write to zoned devices using direct IOs, we
+	 * should never have any dirty page invalidated and so no data loss as
+	 * long as the device cache flush succeeds, that is, as long as the
+	 * flush does not use degraded storage elements.
+	 */
+	ret = blkdev_flush_and_truncate(bdev, mode);
+	if (ret)
+		return ret;
+
+	return bdev_remove_storage_element(bdev, element_id);
+}
+
 /**
  * bdev_restore_storage_elements - Restore all depopulated storage elements of
  *				   a zoned block device
@@ -2982,6 +3079,28 @@ int bdev_restore_storage_elements(struct block_device *bdev)
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
+	/*
+	 * Storage element restoration is a destructive operation that will
+	 * reset all zones. So fflush the device volatile write cache and
+	 * invalidate all cached data that we may have.
+	 */
+	ret = blkdev_flush_and_truncate(bdev, mode);
+	if (ret)
+		return ret;
+
+	return bdev_restore_storage_elements(bdev);
+}
+
 int disk_init_storage_element_mgmt(struct gendisk *disk)
 {
 	int ret;
@@ -3014,3 +3133,28 @@ int disk_init_storage_element_mgmt(struct gendisk *disk)
 
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
index f9ecd54210d0..56b8ea7c6a86 100644
--- a/include/uapi/linux/blkzoned.h
+++ b/include/uapi/linux/blkzoned.h
@@ -270,4 +270,25 @@ struct blk_se {
 	__u8	reserved[13];
 };
 
+struct blk_se_report {
+	__u32		nr_elements;
+	__u32		nr_reported_elements;
+	__u64		reserved;
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

