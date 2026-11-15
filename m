Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794754224;
	b=Z8y3IIJsLNtOF4H1rlxIzplf/q01AzBrCBXHbjQYVx281ddEXoym3lA4fM8dsAlkP+NJ
	 9agwYc0vhsKmu8x4co29v4kWMa3SnqmHNM3f0ozNuBtURK0cAsD26fvmaynnHejJZNXQv
	 e4Xc7W54UuZ1WkeBzqFPLUwMJ0W6ZTJrKh4ELXp4PJWHSvl7yYWxlUK8EGxEkWMlMuc5y
	 tLNTM43XLodF610dG5iARY6MusBhe3X2mVn1keH/yZL32q3RmO3skBrxg+U6VQjhhQRVv
	 nxuerufG3oIMPyer0CfhtDHZn1VvQqki24f3gAGKUpHoSQ4P2qbpxyDxIptZUK2rvlw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794754224;
	h=Received:DKIM-Signature:From:To:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=3z+i8ny1ORLYaYN7vDbWwckk5wGCLStyonSbq1kxsKk=;
	b=nFK68A5ht3FnVDlWHngCkmzGy2Um5C0Ztd0mOc7k5wVsXZa81xTLPfJkJIkuM6Ck+Uwi
	 Igt8RQ0V2D3KapU/VUF+WQHdJ356VJqdwuMtlpeC2KALrwq2celHA6gpDPoGogvbuW4eY
	 VIn4m52ZZUMoyCwjy8tNs8QNEOLfNeExJAkYdyA86jcSsKHy5qgdPiyO52DbBGk/cNvWH
	 kINZPP0cD2SwtK0QDbonwWMciHL9Q7+qHytS/tiO2PB6QHkeLowtUIlr+U7ypQYeuxtfK
	 bdyA15zIX1l+rCkDPqAMUViqT1A5ymaVexFX+dJFqpaJ7B5LU5UnTeD7BYbkgIDoXsQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Rl6s+krg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7794C606A336;
	Sun, 15 Nov 2026 14:50:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Rl6s+krg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A8F41F000C4;
	Sun, 15 Nov 2026 14:50:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794754224;
	bh=3z+i8ny1ORLYaYN7vDbWwckk5wGCLStyonSbq1kxsKk=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=Rl6s+krgsvahDnmOebL+evL2kWfJ4SC0KEwpNaXeS5FLEiWEmW2wIVooZd9OP+vrt
	 3gJI+oA74T2CFEIdym8ccdEsDF+YHvt+qOFxrqOEsHw/5vw34DpMRYEZnC2Sfp6aHo
	 UlfxfdxhZhARWD5waszBwbe31OXt09snhwU3oyNqu1NOyTP0TEIwvaOennb5vf+gD2
	 8LMPVCZRe3CRbwEGlSHMRcoQigFEDL/KrBOHL9p/wc4TGvEnRGcJrKX2kG91c7m1Ix
	 wNXzHdSMqd7ErIdaM0/rHE+UcrdVGMlebSN1SiW0eN+HFrRNMl9vEjNVqO7iprcOYG
	 YtRYZFynFS2ZA==
From: Damien Le Moal <dlemoal@kernel.org>
To: Jens Axboe <axboe@kernel.dk>,
	linux-block@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Subject: [PATCH v9 05/13] block: add storage element management ioctls
Date: Sun, 15 Nov 2026 23:50:07 +0900
Message-ID: <20261115145015.938426-6-dlemoal@kernel.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261115145015.938426-1-dlemoal@kernel.org>
References: <20261115145015.938426-1-dlemoal@kernel.org>
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

Define the new ioctl commands BLKREPORTSTORELEMS, BLKREMOVESTORELEM, and
BLKRESTORESTORELEMS to provide users accessing zoned block devices
directly with an interface to the storage elements management operations
of the block layer.

The ioctl BLKREPORTSTORELEMS allows to get the total number of storage
elements of a zoned block device and to get an array of storage element
descriptors (struct blk_se) describing the current state of the device
storage elements.

The ioctl BLKREMOVESTORELEM can be used to remove (depopulate) a storage
element, in particular storage elements that have a degraded status
(i.e. BLK_SE_STS_DEGRADED). But healthy elements (BLK_SE_STS_OK) can also
be removed, and later restored.

Finally, the BLKRESTORESTORELEMS ioctl interfaces with
bdev_restore_storage_elements() to restore the depopulated storage
elements of a zoned device.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Hannes Reinecke <hare@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-zoned.c             | 163 ++++++++++++++++++++++++++++++++++
 block/blk.h                   |   9 ++
 block/ioctl.c                 |   4 +
 include/uapi/linux/blkzoned.h |  41 +++++++++
 include/uapi/linux/fs.h       |   1 +
 5 files changed, 218 insertions(+)

diff --git a/block/blk-zoned.c b/block/blk-zoned.c
index 30e61dbd89d6..d56afbeb436a 100644
--- a/block/blk-zoned.c
+++ b/block/blk-zoned.c
@@ -18,6 +18,7 @@
 #include <linux/mempool.h>
 #include <linux/kthread.h>
 #include <linux/freezer.h>
+#include <linux/uaccess.h>
 
 #include <trace/events/block.h>
 
@@ -2781,6 +2782,53 @@ int bdev_report_storage_elements(struct block_device *bdev,
 }
 EXPORT_SYMBOL_GPL(bdev_report_storage_elements);
 
+static int blkdev_ioctl_report_storage_elements(struct block_device *bdev,
+						void __user *argp)
+{
+	struct gendisk *disk = bdev->bd_disk;
+	struct blk_se_report *rep;
+	int ret = 0;
+
+	/*
+	 * Allocate the report header with an array of elements, assuming that
+	 * we need the maximum number of storage elements. In practice, we may
+	 * need less than that, but this potentially unnecessary preallocation
+	 * simplifies the code.
+	 */
+	rep = kzalloc_flex(*rep, elements, disk->nr_storage_elements);
+	if (!rep)
+		return -ENOMEM;
+
+	if (copy_from_user(rep, argp, sizeof(struct blk_se_report))) {
+		ret = -EFAULT;
+		goto free_rep;
+	}
+
+	if (rep->reserved) {
+		ret = -EINVAL;
+		goto free_rep;
+	}
+
+	rep->nr_reported_elements =
+		min(rep->nr_elements, disk->nr_storage_elements);
+	rep->nr_elements = disk->nr_storage_elements;
+
+	if (rep->nr_reported_elements) {
+		ret = bdev_report_storage_elements(bdev, rep->elements,
+						   &rep->nr_reported_elements);
+		if (ret)
+			goto free_rep;
+	}
+
+	if (copy_to_user(argp, rep,
+			struct_size(rep, elements, rep->nr_reported_elements)))
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
@@ -2844,6 +2892,62 @@ int bdev_remove_storage_element(struct block_device *bdev,
 }
 EXPORT_SYMBOL_GPL(bdev_remove_storage_element);
 
+static int blkdev_ioctl_remove_storage_element(struct block_device *bdev,
+					       blk_mode_t mode,
+					       unsigned int __user *argp)
+{
+	unsigned int element_id;
+	int ret;
+
+	/*
+	 * Note: we require an O_EXCL open here so that a user cannot trigger
+	 * a storage element removal from user space under a mounted file system.
+	 * An FS that wants to manage storage element can do so using the
+	 * function bdev_remove_storage_element() from kernel context.
+	 */
+	if (!(mode & BLK_OPEN_EXCL))
+		return -EBADF;
+	if (!(mode & BLK_OPEN_WRITE))
+		return -EBADF;
+	if (bdev_read_only(bdev))
+		return -EPERM;
+
+	if (get_user(element_id, argp))
+		return -EFAULT;
+
+	/*
+	 * Sync the device dirty data, flush the volatile write cache, and
+	 * invalidate all cached data so that reads do not return old data for
+	 * zones that went offline.
+	 * Since a user can only successfully write to sequential zones of a
+	 * zoned devices using direct IOs, the sync should only handle dirty
+	 * data from buffered writes to conventional zones, for devices that
+	 * have such zones.
+	 */
+	ret = sync_blockdev(bdev);
+	if (ret)
+		return ret;
+
+	inode_lock(bdev->bd_mapping->host);
+	filemap_invalidate_lock(bdev->bd_mapping);
+
+	ret = blkdev_issue_flush(bdev->bd_disk->part0);
+	if (ret)
+		goto unlock;
+
+	ret = truncate_bdev_range(bdev, mode, 0, bdev_nr_bytes(bdev) - 1);
+	if (ret)
+		goto unlock;
+
+	ret = bdev_remove_storage_element(bdev, element_id);
+
+unlock:
+	filemap_invalidate_unlock(bdev->bd_mapping);
+	inode_unlock(bdev->bd_mapping->host);
+
+	return ret;
+}
+
 /**
  * bdev_restore_storage_elements - Restore all depopulated storage elements of
  *				   a zoned block device
@@ -2909,6 +3013,42 @@ int bdev_restore_storage_elements(struct block_device *bdev)
 }
 EXPORT_SYMBOL_GPL(bdev_restore_storage_elements);
 
+static int blkdev_ioctl_restore_storage_elements(struct block_device *bdev,
+						 blk_mode_t mode)
+{
+	int ret;
+
+	/*
+	 * Note: because restoring storage elements is a destructive operation
+	 * equivalent to reformatting the device, we require an O_EXCL open here
+	 * so that a user cannot trigger with another active user (e.g. a
+	 * mounted file system).
+	 */
+	if (!(mode & BLK_OPEN_EXCL))
+		return -EBADF;
+	if (!(mode & BLK_OPEN_WRITE))
+		return -EBADF;
+	if (bdev_read_only(bdev))
+		return -EPERM;
+
+	inode_lock(bdev->bd_mapping->host);
+	filemap_invalidate_lock(bdev->bd_mapping);
+
+	/*
+	 * Storage element restoration is a destructive operation that will
+	 * reset all zones. So invalidate all cached data that we may have so
+	 * that old data cannot be read once the operation completes.
+	 */
+	ret = truncate_bdev_range(bdev, mode, 0, bdev_nr_bytes(bdev) - 1);
+	if (!ret)
+		ret = bdev_restore_storage_elements(bdev);
+
+	filemap_invalidate_unlock(bdev->bd_mapping);
+	inode_unlock(bdev->bd_mapping->host);
+
+	return ret;
+}
+
 int disk_init_storage_element_mgmt(struct gendisk *disk)
 {
 	int ret;
@@ -2941,3 +3081,26 @@ int disk_init_storage_element_mgmt(struct gendisk *disk)
 
 	return 0;
 }
+
+int blk_ioctl_zone_storage_elements(struct block_device *bdev,
+				    blk_mode_t mode, unsigned int cmd,
+				    void __user *argp)
+{
+	struct gendisk *disk = bdev->bd_disk;
+
+	if (!disk->nr_storage_elements)
+		return -ENOTTY;
+
+	switch (cmd) {
+	case BLKREPORTSTORELEMS:
+		return blkdev_ioctl_report_storage_elements(bdev, argp);
+	case BLKREMOVESTORELEM:
+		return blkdev_ioctl_remove_storage_element(bdev, mode, argp);
+	case BLKRESTORESTORELEMS:
+		return blkdev_ioctl_restore_storage_elements(bdev, mode);
+	default:
+		break;
+	}
+
+	return -ENOTTY;
+}
diff --git a/block/blk.h b/block/blk.h
index 05e2692b80d5..44876b148237 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -595,6 +595,9 @@ int blkdev_report_zones_ioctl(struct block_device *bdev, unsigned int cmd,
 int blkdev_zone_mgmt_ioctl(struct block_device *bdev, blk_mode_t mode,
 		unsigned int cmd, unsigned long arg);
 bool bdev_zone_mgmt_allowed(struct block_device *bdev, sector_t sector);
+int blk_ioctl_zone_storage_elements(struct block_device *bdev,
+				    blk_mode_t mode, unsigned int cmd,
+				    void __user *argp);
 #else /* CONFIG_BLK_DEV_ZONED */
 static inline int disk_init_storage_element_mgmt(struct gendisk *disk)
 {
@@ -646,6 +649,12 @@ static inline bool bdev_zone_mgmt_allowed(struct block_device *bdev,
 {
 	return false;
 }
+static inline int blk_ioctl_zone_storage_elements(struct block_device *bdev,
+					blk_mode_t mode, unsigned int cmd,
+					void __user *argp)
+{
+	return -ENOTTY;
+}
 #endif /* CONFIG_BLK_DEV_ZONED */
 
 struct block_device *bdev_alloc(struct gendisk *disk, u8 partno);
diff --git a/block/ioctl.c b/block/ioctl.c
index fb2f4b4d2505..0f043363048c 100644
--- a/block/ioctl.c
+++ b/block/ioctl.c
@@ -679,6 +679,10 @@ static int blkdev_common_ioctl(struct block_device *bdev, blk_mode_t mode,
 		return put_uint(argp, bdev_zone_sectors(bdev));
 	case BLKGETNRZONES:
 		return put_uint(argp, bdev_nr_zones(bdev));
+	case BLKREPORTSTORELEMS:
+	case BLKREMOVESTORELEM:
+	case BLKRESTORESTORELEMS:
+		return blk_ioctl_zone_storage_elements(bdev, mode, cmd, argp);
 	case BLKROGET:
 		return put_int(argp, bdev_read_only(bdev) != 0);
 	case BLKSSZGET: /* get block device logical block size */
diff --git a/include/uapi/linux/blkzoned.h b/include/uapi/linux/blkzoned.h
index 9d7f59da3efc..6463cdec8e86 100644
--- a/include/uapi/linux/blkzoned.h
+++ b/include/uapi/linux/blkzoned.h
@@ -273,4 +273,45 @@ struct blk_se {
 	__u8	reserved[13];
 };
 
+/**
+ * struct blk_se_report - Zoned device storage element descriptor report for the
+ *			  BLKREPORTSTORELEMS ioctl.
+ *
+ * @nr_elements: on input, this indicates the size of the @elements array. On
+ *		 output, this indicates the maximum number of storage elements
+ *		 of the device. If this field specifies 0 on input, the array
+ *		 @elements is not filled and the maximum number of storage
+ *		 elements of the device returned.
+ * @nr_reported_elements: output only to indicate the number of storage element
+ *			  descriptors filled in the array @elements.
+ * @reserved: reserved space for future use and structure field alignment.
+ * @elements: array of storage element descriptors with a maximum number of
+ *	      entries specified by @nr_elements on input and by
+ *	      @nr_reported_elements on output.
+ */
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
+ * @BLKREPORTSTORELEMS: Get the number of storage elements of a device and
+ *			the device storage element descriptors.
+ * @BLKREMOVESTORELEM: Remove (depopulate) one storage element of a device. This
+ *		       operation will flush the target device write cache and
+ *		       invalidate all cached data. So the caller must ensure
+ *		       that all dirty data written with buffered IOs are written
+ *		       back first to avoid any data loss.
+ * @BLKRESTORESTORELEMS: Restore (repopulate if possible) all storage elements
+ *			 that have been removed. This is a destructive operation
+ *			 equivalent to reformatting the target device.
+ */
+#define BLKREPORTSTORELEMS  _IOWR(0x12, 143, struct blk_se_report)
+#define BLKREMOVESTORELEM   _IOW(0x12, 144, __u32)
+#define BLKRESTORESTORELEMS _IO(0x12, 145)
+
 #endif /* _UAPI_BLKZONED_H */
diff --git a/include/uapi/linux/fs.h b/include/uapi/linux/fs.h
index a46c33692aa2..5b6f8248a479 100644
--- a/include/uapi/linux/fs.h
+++ b/include/uapi/linux/fs.h
@@ -309,6 +309,7 @@ struct file_attr {
 /* 130-136 and 142 are used by zoned block device ioctls (uapi/linux/blkzoned.h) */
 /* 137-141 are used by blk-crypto ioctls (uapi/linux/blk-crypto.h) */
 #define BLKTRACESETUP2 _IOWR(0x12, 142, struct blk_user_trace_setup2)
+/* 143-145 are used by storage element management for zoned block devices. */
 
 #define BMAP_IOCTL 1		/* obsolete - kept for compatibility */
 #define FIBMAP	   _IO(0x00,1)	/* bmap access */
-- 
2.56.0

