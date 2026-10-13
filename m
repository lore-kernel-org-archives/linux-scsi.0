Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E38E4FC320;
	Tue, 13 Oct 2026 12:27:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791894479; cv=none; b=BnzaMn7g28rfaRvDH+8qGq4TnOe4B5rKt5Fmw/zj/p+k9GASkHdZK4wY5N0c8X2lhcbQDvVRDYC2XP2UMEBlhZx1rj2cPyOnzyglfa3qx6gGnESM763bnyQlJzruQRII4lex/3MH65da7uIGbpl/YG5yokO5MuLx+VYXK4pAbvw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791894479; c=relaxed/simple;
	bh=/XjUxS79nHvSlOb8ylNi/EGZsIueyRifDo0/x7r6PZc=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LUbIlzJVHvMl9OOzkgQ/cvZMKwE+RK7V6G/6uqqyw7fec0uAsNqHhl6++yGM9DCIyYOEPCpGoWJpjpRHRk6xFng2Pek0/Vgghkpl7/sw+SIBoxCyAIbikvYwskG0ONTjHj3WpR8MxyFee67I7DgmdDkl2PcIRonE88Ujcr1MRZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CNfSYRKu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CNfSYRKu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1F871F000FF;
	Tue, 13 Oct 2026 12:27:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791894477;
	bh=K0eWOkRh0vOwdlGjsIJiEWG7KBYIcNWMheO3qZXv6WU=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=CNfSYRKuFCliZ/0+25qAH4ZpYBrYGgVGK+ecXKAbJ1lbYCCUnaXRubwxMuWNHMv2v
	 O+/cEAJiutymyMke1D/0iSfDc/EP6DnyexnPfgttJVOFapcoegehUC6bElL01g2jF0
	 lYyEOolawOQUPSR9oXnvWk3sBNHYHpnjgx7w2Ass1e+emzQRA+G8FDN2OcMo9EyADr
	 GGFf997HK3lZk5B2cAc/Yzqxjl2JuCTzrduZmmTMcIYJBU1/QgYzHMo8PSOxfiHWUT
	 F2PR6hOg/D9ncqzN8ppOkf6qmOTyRHn8SWNuffdjbqHxt+7MkpLqMy6bpONhqT0PRh
	 PQSQcWhquyygw==
From: Damien Le Moal <dlemoal@kernel.org>
To: Jens Axboe <axboe@kernel.dk>,
	linux-block@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Subject: [PATCH v6 04/10] block: add storage element management ioctls
Date: Tue, 13 Oct 2026 21:27:44 +0900
Message-ID: <20261013122750.2237843-5-dlemoal@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261013122750.2237843-1-dlemoal@kernel.org>
References: <20261013122750.2237843-1-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
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
element that has a degraded status (i.e. BLK_SE_STS_DEGRADED).

Finally, the BLKRESTORESTORELEMS ioctl interfaces with
bdev_restore_storage_elements() to restore the depopulated storage
elements of a zoned device.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
---
 block/blk-zoned.c             | 134 ++++++++++++++++++++++++++++++++++
 block/blk.h                   |   9 +++
 block/ioctl.c                 |   4 +
 include/uapi/linux/blkzoned.h |  36 +++++++++
 include/uapi/linux/fs.h       |   1 +
 5 files changed, 184 insertions(+)

diff --git a/block/blk-zoned.c b/block/blk-zoned.c
index 252d12254692..580b26ff3aa7 100644
--- a/block/blk-zoned.c
+++ b/block/blk-zoned.c
@@ -19,6 +19,7 @@
 #include <linux/kthread.h>
 #include <linux/freezer.h>
 #include <linux/delay.h>
+#include <linux/uaccess.h>
 
 #include <trace/events/block.h>
 
@@ -2846,6 +2847,46 @@ int bdev_report_storage_elements(struct block_device *bdev,
 }
 EXPORT_SYMBOL_GPL(bdev_report_storage_elements);
 
+static int blkdev_ioctl_report_storage_elements(struct block_device *bdev,
+						void __user *argp)
+{
+	struct gendisk *disk = bdev->bd_disk;
+	struct blk_se_report *rep;
+	unsigned int nr_elements;
+	int ret;
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
+	nr_elements = rep->nr_elements;
+	if (nr_elements < disk->nr_storage_elements)
+		rep->nr_reported_elements = nr_elements;
+	else
+		rep->nr_reported_elements = disk->nr_storage_elements;
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
@@ -2916,6 +2957,53 @@ int bdev_remove_storage_element(struct block_device *bdev,
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
+static int blkdev_ioctl_remove_storage_element(struct block_device *bdev,
+					       blk_mode_t mode,
+					       unsigned int __user *argp)
+{
+	unsigned int element_id;
+	int ret;
+
+	if (!(mode & BLK_OPEN_WRITE))
+		return -EBADF;
+	if (bdev_read_only(bdev))
+		return -EPERM;
+
+	if (get_user(element_id, argp))
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
@@ -2980,6 +3068,29 @@ int bdev_restore_storage_elements(struct block_device *bdev)
 }
 EXPORT_SYMBOL_GPL(bdev_restore_storage_elements);
 
+static int blkdev_ioctl_restore_storage_elements(struct block_device *bdev,
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
+	 * reset all zones. So flush the device volatile write cache and
+	 * invalidate all cached data that we may have so that old data cannot
+	 * be read once the operation completes.
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
@@ -3012,3 +3123,26 @@ int disk_init_storage_element_mgmt(struct gendisk *disk)
 
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
index 64b4e6c0f696..e886ca9f7dd1 100644
--- a/block/ioctl.c
+++ b/block/ioctl.c
@@ -679,6 +679,10 @@ static int blkdev_common_ioctl(struct block_device *bdev, blk_mode_t mode,
 		return put_uint(argp, bdev_zone_sectors(bdev));
 	case BLKGETNRZONES:
 		return put_uint(argp, bdev_nr_zones(bdev));
+	case BLKREPORTSTORELEMS:
+	case BLKREMOVESTORELEM:
+	case BLKRESTORESTORELEMS:
+		return blkdev_zone_storage_elements_ioctl(bdev, mode, cmd, argp);
 	case BLKROGET:
 		return put_int(argp, bdev_read_only(bdev) != 0);
 	case BLKSSZGET: /* get block device logical block size */
diff --git a/include/uapi/linux/blkzoned.h b/include/uapi/linux/blkzoned.h
index f9ecd54210d0..9e2b7a6de1d9 100644
--- a/include/uapi/linux/blkzoned.h
+++ b/include/uapi/linux/blkzoned.h
@@ -270,4 +270,40 @@ struct blk_se {
 	__u8	reserved[13];
 };
 
+/**
+ * struct blk_se_report - Zoned device storage element descripor report for the
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
+ * @BLKREMOVESTORELEM: Remove (depopulate) one storage element of a device.
+ * @BLKRESTORESTORELEM: Restore (repopulate if possible) all storage elements
+ *			that have been removed.
+ */
+#define BLKREPORTSTORELEMS  _IOWR(0x12, 143, struct blk_se_report)
+#define BLKREMOVESTORELEM   _IOW(0x12, 144, __u32)
+#define BLKRESTORESTORELEMS _IO(0x12, 145)
+
 #endif /* _UAPI_BLKZONED_H */
diff --git a/include/uapi/linux/fs.h b/include/uapi/linux/fs.h
index 34c6f219462a..1ec7406ec312 100644
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
2.55.0

