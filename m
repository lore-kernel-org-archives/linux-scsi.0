From: Damien Le Moal <damien.lemoal@hgst.com>
Subject: [PATCH v2 7/7] blk-zoned: implement ioctls
Date: Mon, 26 Sep 2016 20:14:43 +0900
Message-ID: <1474888483-29762-8-git-send-email-damien.lemoal@hgst.com>
References: <1474888483-29762-1-git-send-email-damien.lemoal@hgst.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:54467 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S938318AbcIZLPY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 26 Sep 2016 07:15:24 -0400
In-Reply-To: <1474888483-29762-1-git-send-email-damien.lemoal@hgst.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, "Martin K . Petersen" <martin.petersen@oracle.com>, Shaun Tancheff <shaun.tancheff@seagate.com>, Damien Le Moal <damien.lemoal@hgst.com>

From: Shaun Tancheff <shaun.tancheff@seagate.com>

Adds the new BLKREPORTZONE and BLKRESETZONE ioctls for respectively
obtaining the zone configuration of a zoned block device and resetting
the write pointer of sequential zones of a zoned block device.

The BLKREPORTZONE ioctl maps directly to a single call of the function
blkdev_report_zones. The zone information result is passed as an array
of struct blk_zone identical to the structure used internally for
processing the REQ_OP_ZONE_REPORT operation.  The BLKRESETZONE ioctl
maps to a single call of the blkdev_reset_zones function.

Signed-off-by: Shaun Tancheff <shaun.tancheff@seagate.com>
Signed-off-by: Damien Le Moal <damien.lemoal@hgst.com>
---
 block/blk-zoned.c             |  95 ++++++++++++++++++++++++++++
 block/ioctl.c                 |   4 ++
 include/linux/blkdev.h        |  65 +++++++------------
 include/uapi/linux/Kbuild     |   1 +
 include/uapi/linux/blkzoned.h | 143 ++++++++++++++++++++++++++++++++++++++++++
 include/uapi/linux/fs.h       |   4 ++
 6 files changed, 270 insertions(+), 42 deletions(-)
 create mode 100644 include/uapi/linux/blkzoned.h

diff --git a/block/blk-zoned.c b/block/blk-zoned.c
index 473cb0a..8c70bd6 100644
--- a/block/blk-zoned.c
+++ b/block/blk-zoned.c
@@ -12,6 +12,7 @@
 #include <linux/module.h>
 #include <linux/rbtree.h>
 #include <linux/blkdev.h>
+#include <linux/blkzoned.h>
 
 static inline sector_t blk_zone_start(struct request_queue *q,
 				      sector_t sector)
@@ -238,3 +239,97 @@ int blkdev_reset_zones(struct block_device *bdev,
 
 	return 0;
 }
+
+/**
+ * BLKREPORTZONE ioctl processing.
+ * Called from blkdev_ioctl.
+ */
+int blkdev_report_zones_ioctl(struct block_device *bdev, fmode_t mode,
+			      unsigned int cmd, unsigned long arg)
+{
+	void __user *argp = (void __user *)arg;
+	struct request_queue *q;
+	struct blk_zone_report rep;
+	struct blk_zone *zones;
+	int ret;
+
+	if (!argp)
+		return -EINVAL;
+
+	q = bdev_get_queue(bdev);
+	if (!q)
+		return -ENXIO;
+
+	if (!blk_queue_is_zoned(q))
+		return -ENOTTY;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EACCES;
+
+	if (copy_from_user(&rep, argp, sizeof(struct blk_zone_report)))
+		return -EFAULT;
+
+	if (!rep.nr_zones)
+		return -EINVAL;
+
+	zones = kzalloc(sizeof(struct blk_zone) * rep.nr_zones,
+			GFP_KERNEL);
+	if (!zones)
+		return -ENOMEM;
+
+	ret = blkdev_report_zones(bdev, rep.sector,
+				  zones, &rep.nr_zones,
+				  GFP_KERNEL);
+	if (ret)
+		goto out;
+
+	if (copy_to_user(argp, &rep, sizeof(struct blk_zone_report))) {
+		ret = -EFAULT;
+		goto out;
+	}
+
+	if (rep.nr_zones) {
+		if (copy_to_user(argp + sizeof(struct blk_zone_report), zones,
+				 sizeof(struct blk_zone) * rep.nr_zones))
+			ret = -EFAULT;
+	}
+
+ out:
+	kfree(zones);
+
+	return ret;
+}
+
+/**
+ * BLKRESETZONE ioctl processing.
+ * Called from blkdev_ioctl.
+ */
+int blkdev_reset_zones_ioctl(struct block_device *bdev, fmode_t mode,
+			     unsigned int cmd, unsigned long arg)
+{
+	void __user *argp = (void __user *)arg;
+	struct request_queue *q;
+	struct blk_zone_range zrange;
+
+	if (!argp)
+		return -EINVAL;
+
+	q = bdev_get_queue(bdev);
+	if (!q)
+		return -ENXIO;
+
+	if (!blk_queue_is_zoned(q))
+		return -ENOTTY;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EACCES;
+
+	if (!(mode & FMODE_WRITE))
+		return -EBADF;
+
+	if (copy_from_user(&zrange, argp, sizeof(struct blk_zone_range)))
+		return -EFAULT;
+
+	return blkdev_reset_zones(bdev, zrange.sector, zrange.nr_sectors,
+				  GFP_KERNEL);
+}
diff --git a/block/ioctl.c b/block/ioctl.c
index ed2397f..448f78a 100644
--- a/block/ioctl.c
+++ b/block/ioctl.c
@@ -513,6 +513,10 @@ int blkdev_ioctl(struct block_device *bdev, fmode_t mode, unsigned cmd,
 				BLKDEV_DISCARD_SECURE);
 	case BLKZEROOUT:
 		return blk_ioctl_zeroout(bdev, mode, arg);
+	case BLKREPORTZONE:
+		return blkdev_report_zones_ioctl(bdev, mode, cmd, arg);
+	case BLKRESETZONE:
+		return blkdev_reset_zones_ioctl(bdev, mode, cmd, arg);
 	case HDIO_GETGEO:
 		return blkdev_getgeo(bdev, argp);
 	case BLKRAGET:
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 6034f38..0a75285 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -24,6 +24,7 @@
 #include <linux/rcupdate.h>
 #include <linux/percpu-refcount.h>
 #include <linux/scatterlist.h>
+#include <linux/blkzoned.h>
 
 struct module;
 struct scsi_ioctl_command;
@@ -304,48 +305,6 @@ struct queue_limits {
 
 #ifdef CONFIG_BLK_DEV_ZONED
 
-/*
- * Zone type.
- */
-enum blk_zone_type {
-	BLK_ZONE_TYPE_UNKNOWN,
-	BLK_ZONE_TYPE_CONVENTIONAL,
-	BLK_ZONE_TYPE_SEQWRITE_REQ,
-	BLK_ZONE_TYPE_SEQWRITE_PREF,
-};
-
-/*
- * Zone condition.
- */
-enum blk_zone_cond {
-	BLK_ZONE_COND_NO_WP,
-	BLK_ZONE_COND_EMPTY,
-	BLK_ZONE_COND_IMP_OPEN,
-	BLK_ZONE_COND_EXP_OPEN,
-	BLK_ZONE_COND_CLOSED,
-	BLK_ZONE_COND_READONLY = 0xd,
-	BLK_ZONE_COND_FULL,
-	BLK_ZONE_COND_OFFLINE,
-};
-
-/*
- * Zone descriptor for BLKREPORTZONE.
- * start, len and wp use the regulare 512 B sector unit,
- * regardless of the device logical block size. The overall
- * structure size is 64 B to match the ZBC/ZAC defined zone descriptor
- * and allow support for future additional zone information.
- */
-struct blk_zone {
-	u64	start;		/* Zone start sector */
-	u64	len;		/* Zone length in number of sectors */
-	u64	wp;		/* Zone write pointer position */
-	u8	type;		/* Zone type */
-	u8	cond;		/* Zone condition */
-	u8	non_seq;	/* Non-sequential write resources active */
-	u8	reset;		/* Reset write pointer recommended */
-	u8	reserved[36];
-};
-
 struct blk_zone_report_hdr {
 	unsigned int	nr_zones;
 	u8		padding[60];
@@ -356,6 +315,28 @@ extern int blkdev_report_zones(struct block_device *,
 				unsigned int *, gfp_t);
 extern int blkdev_reset_zones(struct block_device *, sector_t,
 				sector_t, gfp_t);
+
+extern int blkdev_report_zones_ioctl(struct block_device *, fmode_t,
+				     unsigned int, unsigned long);
+extern int blkdev_reset_zones_ioctl(struct block_device *, fmode_t,
+				    unsigned int, unsigned long);
+
+#else /* CONFIG_BLK_DEV_ZONED */
+
+static inline int blkdev_report_zones_ioctl(struct block_device *bdev,
+					    fmode_t mode, unsigned int cmd,
+					    unsigned long arg)
+{
+	return -ENOTTY;
+}
+
+static inline int blkdev_reset_zones_ioctl(struct block_device *bdev,
+					   fmode_t mode, unsigned int cmd,
+					   unsigned long arg)
+{
+	return -ENOTTY;
+}
+
 #endif /* CONFIG_BLK_DEV_ZONED */
 
 struct request_queue {
diff --git a/include/uapi/linux/Kbuild b/include/uapi/linux/Kbuild
index dd60439..92466a6 100644
--- a/include/uapi/linux/Kbuild
+++ b/include/uapi/linux/Kbuild
@@ -70,6 +70,7 @@ header-y += bfs_fs.h
 header-y += binfmts.h
 header-y += blkpg.h
 header-y += blktrace_api.h
+header-y += blkzoned.h
 header-y += bpf_common.h
 header-y += bpf_perf_event.h
 header-y += bpf.h
diff --git a/include/uapi/linux/blkzoned.h b/include/uapi/linux/blkzoned.h
new file mode 100644
index 0000000..40d1d7b
--- /dev/null
+++ b/include/uapi/linux/blkzoned.h
@@ -0,0 +1,143 @@
+/*
+ * Zoned block devices handling.
+ *
+ * Copyright (C) 2015 Seagate Technology PLC
+ *
+ * Written by: Shaun Tancheff <shaun.tancheff@seagate.com>
+ *
+ * Modified by: Damien Le Moal <damien.lemoal@hgst.com>
+ * Copyright (C) 2016 Western Digital
+ *
+ * This file is licensed under  the terms of the GNU General Public
+ * License version 2. This program is licensed "as is" without any
+ * warranty of any kind, whether express or implied.
+ */
+#ifndef _UAPI_BLKZONED_H
+#define _UAPI_BLKZONED_H
+
+#include <linux/types.h>
+#include <linux/ioctl.h>
+
+/**
+ * enum blk_zone_type - Types of zones allowed in a zoned device.
+ *
+ * @BLK_ZONE_TYPE_CONVENTIONAL: The zone has no write pointer and can be writen
+ *                              randomly. Zone reset has no effect on the zone.
+ * @BLK_ZONE_TYPE_SEQWRITE_REQ: The zone must be written sequentially
+ * @BLK_ZONE_TYPE_SEQWRITE_PREF: The zone can be written non-sequentially
+ *
+ * Any other value not defined is reserved and must be considered as invalid.
+ */
+enum blk_zone_type {
+	BLK_ZONE_TYPE_CONVENTIONAL	= 0x1,
+	BLK_ZONE_TYPE_SEQWRITE_REQ	= 0x2,
+	BLK_ZONE_TYPE_SEQWRITE_PREF	= 0x3,
+};
+
+/**
+ * enum blk_zone_cond - Condition [state] of a zone in a zoned device.
+ *
+ * @BLK_ZONE_COND_NOT_WP: The zone has no write pointer, it is conventional.
+ * @BLK_ZONE_COND_EMPTY: The zone is empty.
+ * @BLK_ZONE_COND_IMP_OPEN: The zone is open, but not explicitly opened.
+ * @BLK_ZONE_COND_EXP_OPEN: The zones was explicitly opened by an
+ *                          OPEN ZONE command.
+ * @BLK_ZONE_COND_CLOSED: The zone was [explicitly] closed after writing.
+ * @BLK_ZONE_COND_FULL: The zone is marked as full, possibly by a zone
+ *                      FINISH ZONE command.
+ * @BLK_ZONE_COND_READONLY: The zone is read-only.
+ * @BLK_ZONE_COND_OFFLINE: The zone is offline (sectors cannot be read/written).
+ *
+ * The Zone Condition state machine in the ZBC/ZAC standards maps the above
+ * deinitions as:
+ *   - ZC1: Empty         | BLK_ZONE_EMPTY
+ *   - ZC2: Implicit Open | BLK_ZONE_COND_IMP_OPEN
+ *   - ZC3: Explicit Open | BLK_ZONE_COND_EXP_OPEN
+ *   - ZC4: Closed        | BLK_ZONE_CLOSED
+ *   - ZC5: Full          | BLK_ZONE_FULL
+ *   - ZC6: Read Only     | BLK_ZONE_READONLY
+ *   - ZC7: Offline       | BLK_ZONE_OFFLINE
+ *
+ * Conditions 0x5 to 0xC are reserved by the current ZBC/ZAC spec and should
+ * be considered invalid.
+ */
+enum blk_zone_cond {
+	BLK_ZONE_COND_NOT_WP	= 0x0,
+	BLK_ZONE_COND_EMPTY	= 0x1,
+	BLK_ZONE_COND_IMP_OPEN	= 0x2,
+	BLK_ZONE_COND_EXP_OPEN	= 0x3,
+	BLK_ZONE_COND_CLOSED	= 0x4,
+	BLK_ZONE_COND_READONLY	= 0xD,
+	BLK_ZONE_COND_FULL	= 0xE,
+	BLK_ZONE_COND_OFFLINE	= 0xF,
+};
+
+/**
+ * struct blk_zone - Zone descriptor for BLKREPORTZONE ioctl.
+ *
+ * @start: Zone start in 512 B sector units
+ * @len: Zone length in 512 B sector units
+ * @wp: Zone write pointer location in 512 B sector units
+ * @type: see enum blk_zone_type for possible values
+ * @cond: see enum blk_zone_cond for possible values
+ * @non_seq: Flag indicating that the zone is using non-sequential resources
+ *           (for host-aware zoned block devices only).
+ * @reset: Flag indicating that a zone reset is recommended.
+ * @reserved: Padding to 64 B to match the ZBC/ZAC defined zone descriptor size.
+ *
+ * start, len and wp use the regular 512 B sector unit, regardless of the
+ * device logical block size. The overall structure size is 64 B to match the
+ * ZBC/ZAC defined zone descriptor and allow support for future additional
+ * zone information.
+ */
+struct blk_zone {
+	__u64	start;		/* Zone start sector */
+	__u64	len;		/* Zone length in number of sectors */
+	__u64	wp;		/* Zone write pointer position */
+	__u8	type;		/* Zone type */
+	__u8	cond;		/* Zone condition */
+	__u8	non_seq;	/* Non-sequential write resources active */
+	__u8	reset;		/* Reset write pointer recommended */
+	__u8	reserved[36];
+};
+
+/**
+ * struct blk_zone_report - BLKREPORTZONE ioctl request/reply
+ *
+ * @sector: starting sector of report
+ * @nr_zones: IN maximum / OUT actual
+ * @reserved: padding to 16 byte alignment
+ * @zones: Space to hold @nr_zones @zones entries on reply.
+ *
+ * The array of at most @nr_zones must follow this structure in memory.
+ */
+struct blk_zone_report {
+	__u64		sector;
+	__u32		nr_zones;
+	__u8		reserved[4];
+	struct blk_zone zones[0];
+} __packed;
+
+/**
+ * struct blk_zone_range - BLKRESETZONE ioctl request
+ * @sector: starting sector of the first zone to issue reset write pointer
+ * @nr_sectors: Total number of sectors of 1 or more zones to reset
+ */
+struct blk_zone_range {
+	__u64		sector;
+	__u64		nr_sectors;
+};
+
+/**
+ * Zoned block device ioctl's:
+ *
+ * @BLKREPORTZONE: Get zone information. Takes a zone report as argument.
+ *                 The zone report will start from the zone containing the
+ *                 sector specified in the report request structure.
+ * @BLKRESETZONE: Reset the write pointer of the zones in the specified
+ *                sector range. The sector range must be zone aligned.
+ */
+#define BLKREPORTZONE	_IOWR(0x12, 130, struct blk_zone_report)
+#define BLKRESETZONE	_IOW(0x12, 131, struct blk_zone_range)
+
+#endif /* _UAPI_BLKZONED_H */
diff --git a/include/uapi/linux/fs.h b/include/uapi/linux/fs.h
index 3b00f7c..e0fc7f0 100644
--- a/include/uapi/linux/fs.h
+++ b/include/uapi/linux/fs.h
@@ -222,6 +222,10 @@ struct fsxattr {
 #define BLKSECDISCARD _IO(0x12,125)
 #define BLKROTATIONAL _IO(0x12,126)
 #define BLKZEROOUT _IO(0x12,127)
+/*
+ * A jump here: 130-131 are reserved for zoned block devices
+ * (see uapi/linux/blkzoned.h)
+ */
 
 #define BMAP_IOCTL 1		/* obsolete - kept for compatibility */
 #define FIBMAP	   _IO(0x00,1)	/* bmap access */
-- 
2.7.4

