Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62344468C06;
	Mon,  5 Oct 2026 09:46:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791193608; cv=none; b=JSVvZaRu7uPMnHIbcCYJxtgJ+vdcknfh4j8Sag9WhnBv/QsEG/U22dxJ2fLh0YwT4vbyqcsdU+lTNCywr8j4Vr9ZzrOawohgmZEaO39TqZYxEosz+4L+cJQQDyqTr1PRYKX6WZJ2SPP7xPYJOqqwO5ADrE24JIdS28EieK+YjXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791193608; c=relaxed/simple;
	bh=GSs3MfkL6+I95Bz27WeCneYgtTvErKskcIJHxFSfJck=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d7aIo3UEmsajXwJBptNa6fBblhwyaXZPyM2xXNq9Kg/pfbUl42ZLujFgAw2jDjuICzPc/6olXBtb551mheIZSuLDfbytwPzjDrDulcMSyacDcjMvg0L0nvrfdx2ALdrZc2wxGpyVe4g0BPYwnM6MzNU3R70i66v78FrycZZzRUU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RDny/MrZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RDny/MrZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 188C01F0089A;
	Mon,  5 Oct 2026 09:46:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791193597;
	bh=+Ocwk4uCc8wwg0CorUpaibx+TUu+PqJuzl4C7dlcOcg=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=RDny/MrZ3AAhI6SJASLo8oLY7MBjEO2yKca1ly2H/2e2qyoApPWVTYqaEibebZPCB
	 OCWVY7MW89SCj2B2A8SIpW4KOutCgih1QzPAtHl4yUuyGpLzXIcjZTC6iSGvXqdVfL
	 GsKkwPcbHxrefe2E6lAgNvieYpV5i/jaoNsvwMGBFw/9iVGAHcDZv4Zp9dORCH5YUt
	 SJ7/r+OayXUu2Qv0rTRrmS949FxfyFhUiF6fL4Y8kfQ26dBKOfaorzZGrQtrvTWIQ5
	 REgNYryH4lvoMLt3Sv5lBtYsIRf4yjLwYrjbrq1/xj1cpTtE608HFuholtbug1W+bj
	 M3NTnPBZ9T7OQ==
From: Damien Le Moal <dlemoal@kernel.org>
To: Jens Axboe <axboe@kernel.dk>,
	linux-block@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 3/7] block: add storage element management ioctls
Date: Mon,  5 Oct 2026 18:46:28 +0900
Message-ID: <20261005094632.580753-4-dlemoal@kernel.org>
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
 block/blk-zoned.c             | 114 ++++++++++++++++++++++++++++++++++
 block/blk.h                   |   9 +++
 block/ioctl.c                 |   5 ++
 include/uapi/linux/blkzoned.h |  14 +++++
 include/uapi/linux/fs.h       |   1 +
 5 files changed, 143 insertions(+)

diff --git a/block/blk-zoned.c b/block/blk-zoned.c
index b713512f7d48..62b9cf21e9ad 100644
--- a/block/blk-zoned.c
+++ b/block/blk-zoned.c
@@ -19,6 +19,7 @@
 #include <linux/kthread.h>
 #include <linux/freezer.h>
 #include <linux/delay.h>
+#include <linux/uaccess.h>
 
 #include <trace/events/block.h>
 
@@ -2794,6 +2795,69 @@ int bdev_report_storage_elements(struct block_device *bdev,
 }
 EXPORT_SYMBOL_GPL(bdev_report_storage_elements);
 
+static int blkdev_get_nr_storage_elements_ioctl(struct block_device *bdev,
+						void __user *argp)
+{
+	unsigned int nr_elements = 0;
+	int ret;
+
+	ret = bdev_report_storage_elements(bdev, &nr_elements, NULL);
+	if (ret)
+		return ret;
+
+	if (put_user(nr_elements, (unsigned int __user *)argp))
+		return -EFAULT;
+
+	return 0;
+}
+
+static int blkdev_report_storage_elements_ioctl(struct block_device *bdev,
+						void __user *argp)
+{
+	struct blk_storage_elements_report rep;
+	struct blk_storage_element *elements;
+	unsigned int nr_elements;
+	unsigned long retc;
+	int ret;
+
+	if (!argp)
+		return -EINVAL;
+
+	if (copy_from_user(&rep, argp,
+			   sizeof(struct blk_storage_elements_report)))
+		return -EFAULT;
+
+	if (!rep.nr_elements)
+		return -EINVAL;
+
+	nr_elements = rep.nr_elements;
+	elements = kzalloc_objs(struct blk_storage_element, nr_elements);
+	if (!elements)
+		return -ENOMEM;
+
+	ret = bdev_report_storage_elements(bdev, &nr_elements, elements);
+	if (ret)
+		goto free_elements;
+
+	retc = copy_to_user(argp + sizeof(struct blk_storage_elements_report),
+			    elements,
+			    sizeof(struct blk_storage_element) * nr_elements);
+	if (retc) {
+		ret = -EFAULT;
+		goto free_elements;
+	}
+
+	rep.nr_elements = nr_elements;
+	retc = copy_to_user(argp, &rep,
+			    sizeof(struct blk_storage_elements_report));
+	if (retc)
+		ret = -EFAULT;
+
+free_elements:
+	kfree(elements);
+	return ret;
+}
+
 /**
  * bdev_remove_storage_element - Remove (depopulate) a storage element of a
  *				 block device
@@ -2847,6 +2911,22 @@ int bdev_remove_storage_element(struct block_device *bdev,
 }
 EXPORT_SYMBOL_GPL(bdev_remove_storage_element);
 
+static int blkdev_remove_storage_element_ioctl(struct block_device *bdev,
+					blk_mode_t mode, void __user *argp)
+{
+	unsigned int element_id;
+
+	if (!(mode & BLK_OPEN_WRITE))
+		return -EBADF;
+	if (bdev_read_only(bdev))
+		return -EPERM;
+
+	if (get_user(element_id, (unsigned int __user *)argp))
+		return -EFAULT;
+
+	return bdev_remove_storage_element(bdev, element_id);
+}
+
 /**
  * bdev_restore_storage_elements - Restore all depopulated storage elements of a
  *				   block device
@@ -2886,3 +2966,37 @@ int bdev_restore_storage_elements(struct block_device *bdev)
 	return blk_revalidate_disk_zones(disk);
 }
 EXPORT_SYMBOL_GPL(bdev_restore_storage_elements);
+
+static int blkdev_restore_storage_elements_ioctl(struct block_device *bdev,
+						 blk_mode_t mode)
+{
+	if (!(mode & BLK_OPEN_WRITE))
+		return -EBADF;
+	if (bdev_read_only(bdev))
+		return -EPERM;
+
+	return bdev_restore_storage_elements(bdev);
+}
+
+int blkdev_zone_storage_elements_ioctl(struct block_device *bdev,
+				       blk_mode_t mode, unsigned int cmd,
+				       void __user *argp)
+{
+	if (!bdev_is_zoned(bdev) || !bdev->bd_disk->fops->se_ops)
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
index c2d07347a3ad..274afb46a809 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -579,6 +579,9 @@ int blkdev_zone_mgmt_ioctl(struct block_device *bdev, blk_mode_t mode,
 		unsigned int cmd, unsigned long arg);
 bool bdev_zone_mgmt_allowed(struct block_device *bdev, sector_t sector);
 bool bdev_zone_is_offline(struct block_device *bdev, sector_t sector);
+int blkdev_zone_storage_elements_ioctl(struct block_device *bdev,
+				       blk_mode_t mode, unsigned int cmd,
+				       void __user *argp);
 #else /* CONFIG_BLK_DEV_ZONED */
 static inline void disk_init_zone_resources(struct gendisk *disk)
 {
@@ -631,6 +634,12 @@ static inline bool bdev_zone_is_offline(struct block_device *bdev,
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
index 3a4bacfe7979..bd2c55d1a0d2 100644
--- a/include/uapi/linux/blkzoned.h
+++ b/include/uapi/linux/blkzoned.h
@@ -275,4 +275,18 @@ struct blk_storage_elements_report {
 	struct blk_storage_element	elements[];
 };
 
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
+#define BLKREPORTSTORELEMS  _IOWR(0x12, 144, struct blk_storage_elements_report)
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

