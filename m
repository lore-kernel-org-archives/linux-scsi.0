From: Damien Le Moal <damien.lemoal@hgst.com>
Subject: [PATCH 9/9] blk-zoned: Add ioctl interface for zone operations
Date: Tue, 20 Sep 2016 06:27:34 +0900
Message-ID: <1474320454-5264-10-git-send-email-damien.lemoal@hgst.com>
References: <1474320454-5264-1-git-send-email-damien.lemoal@hgst.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <1474320454-5264-1-git-send-email-damien.lemoal@hgst.com>
Sender: linux-block-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-block@vger.kernel.org
Cc: martin.petersen@oracle.com, axboe@kernel.dk, hare@suse.de, shaun.tancheff@seagate.com, Damien Le Moal <damien.lemoal@hgst.com>
List-Id: linux-scsi@vger.kernel.org

From: Shaun Tancheff <shaun.tancheff@seagate.com>

Adds the new BLKUPDATEZONES, BLKREPORTZONE, BLKRESETZONE,
BLKOPENZONE, BLKCLOSEZONE and BLKFINISHZONE ioctls.

BLKREPORTZONE implementation uses the device queue zone RB-tree by
default and no actual command is issued to the device. If the
application needs access to the untracked zone attributes (non-seq
flag or reset recommended flag, offline or read-only zone condition,
etc), BLKUPDATEZONES must be issued first to force an update of the
cached zone information.

Changelog (Damien):
* Simplified blkzone descriptor (removed bit-fields and use CPU
  endianness)
* Changed report ioctl to operate on single zone instead of an
  array of blkzone structures.

Signed-off-by: Shaun Tancheff <shaun.tancheff@seagate.com>
Signed-off-by: Damien Le Moal <damien.lemoal@hgst.com>
---
 block/blk-zoned.c             | 115 ++++++++++++++++++++++++++++++++++++++++++
 block/ioctl.c                 |   8 +++
 include/linux/blkdev.h        |   7 +++
 include/uapi/linux/Kbuild     |   1 +
 include/uapi/linux/blkzoned.h |  91 +++++++++++++++++++++++++++++++++
 include/uapi/linux/fs.h       |   1 +
 6 files changed, 223 insertions(+)
 create mode 100644 include/uapi/linux/blkzoned.h

diff --git a/block/blk-zoned.c b/block/blk-zoned.c
index a107940..71205c8 100644
--- a/block/blk-zoned.c
+++ b/block/blk-zoned.c
@@ -12,6 +12,7 @@
 #include <linux/module.h>
 #include <linux/rbtree.h>
 #include <linux/blkdev.h>
+#include <linux/blkzoned.h>
 
 void blk_init_zones(struct request_queue *q)
 {
@@ -336,3 +337,117 @@ int blkdev_finish_zone(struct block_device *bdev,
 	return blkdev_issue_zone_action(bdev, sector, REQ_OP_ZONE_FINISH,
 					gfp_mask);
 }
+
+static int blkdev_report_zone_ioctl(struct block_device *bdev,
+				    void __user *argp)
+{
+	struct blk_zone *zone;
+	struct blkzone z;
+
+	if (copy_from_user(&z, argp, sizeof(struct blkzone)))
+		return -EFAULT;
+
+	zone = blk_lookup_zone(bdev_get_queue(bdev), z.start);
+	if (!zone)
+		return -EINVAL;
+
+	memset(&z, 0, sizeof(struct blkzone));
+
+	blk_lock_zone(zone);
+
+	blk_wait_for_zone_update(zone);
+
+	z.len = zone->len;
+	z.start = zone->start;
+	z.wp = zone->wp;
+	z.type = zone->type;
+	z.cond = zone->cond;
+	z.non_seq = zone->non_seq;
+	z.reset = zone->reset;
+
+	blk_unlock_zone(zone);
+
+	if (copy_to_user(argp, &z, sizeof(struct blkzone)))
+		return -EFAULT;
+
+	return 0;
+}
+
+static int blkdev_zone_action_ioctl(struct block_device *bdev,
+				    unsigned cmd, void __user *argp)
+{
+	unsigned int op;
+	u64 sector;
+
+	if (get_user(sector, (u64 __user *)argp))
+		return -EFAULT;
+
+	switch (cmd) {
+	case BLKRESETZONE:
+		op = REQ_OP_ZONE_RESET;
+		break;
+	case BLKOPENZONE:
+		op = REQ_OP_ZONE_OPEN;
+		break;
+	case BLKCLOSEZONE:
+		op = REQ_OP_ZONE_CLOSE;
+		break;
+	case BLKFINISHZONE:
+		op = REQ_OP_ZONE_FINISH;
+		break;
+	}
+
+	return blkdev_issue_zone_action(bdev, sector, op, GFP_KERNEL);
+}
+
+/**
+ * Called from blkdev_ioctl.
+ */
+int blkdev_zone_ioctl(struct block_device *bdev, fmode_t mode,
+		      unsigned cmd, unsigned long arg)
+{
+	void __user *argp = (void __user *)arg;
+	struct request_queue *q;
+	int ret;
+
+	if (!argp)
+		return -EINVAL;
+
+	q = bdev_get_queue(bdev);
+	if (!q)
+		return -ENXIO;
+
+	if (!blk_queue_zoned(q))
+		return -ENOTTY;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EACCES;
+
+	switch (cmd) {
+	case BLKREPORTZONE:
+		ret = blkdev_report_zone_ioctl(bdev, argp);
+		break;
+	case BLKUPDATEZONES:
+		if (!(mode & FMODE_WRITE)) {
+			ret = -EBADF;
+			break;
+		}
+		ret = blkdev_update_zones(bdev, GFP_KERNEL);
+		break;
+	case BLKRESETZONE:
+	case BLKOPENZONE:
+	case BLKCLOSEZONE:
+	case BLKFINISHZONE:
+		if (!(mode & FMODE_WRITE)) {
+			ret = -EBADF;
+			break;
+		}
+		ret = blkdev_zone_action_ioctl(bdev, cmd, argp);
+		break;
+	default:
+		ret = -ENOTTY;
+		break;
+	}
+
+	return ret;
+}
diff --git a/block/ioctl.c b/block/ioctl.c
index ed2397f..f09679a 100644
--- a/block/ioctl.c
+++ b/block/ioctl.c
@@ -3,6 +3,7 @@
 #include <linux/export.h>
 #include <linux/gfp.h>
 #include <linux/blkpg.h>
+#include <linux/blkzoned.h>
 #include <linux/hdreg.h>
 #include <linux/backing-dev.h>
 #include <linux/fs.h>
@@ -513,6 +514,13 @@ int blkdev_ioctl(struct block_device *bdev, fmode_t mode, unsigned cmd,
 				BLKDEV_DISCARD_SECURE);
 	case BLKZEROOUT:
 		return blk_ioctl_zeroout(bdev, mode, arg);
+	case BLKUPDATEZONES:
+	case BLKREPORTZONE:
+	case BLKRESETZONE:
+	case BLKOPENZONE:
+	case BLKCLOSEZONE:
+	case BLKFINISHZONE:
+		return blkdev_zone_ioctl(bdev, mode, cmd, arg);
 	case HDIO_GETGEO:
 		return blkdev_getgeo(bdev, argp);
 	case BLKRAGET:
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index a85f95b..0299d41 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -405,9 +405,16 @@ extern int blkdev_reset_zone(struct block_device *, sector_t, gfp_t);
 extern int blkdev_open_zone(struct block_device *, sector_t, gfp_t);
 extern int blkdev_close_zone(struct block_device *, sector_t, gfp_t);
 extern int blkdev_finish_zone(struct block_device *, sector_t, gfp_t);
+extern int blkdev_zone_ioctl(struct block_device *, fmode_t, unsigned int,
+			     unsigned long);
 #else /* CONFIG_BLK_DEV_ZONED */
 static inline void blk_init_zones(struct request_queue *q) { };
 static inline void blk_drop_zones(struct request_queue *q) { };
+static inline int blkdev_zone_ioctl(struct block_device *bdev, fmode_t mode,
+				    unsigned cmd, unsigned long arg)
+{
+	return -ENOTTY;
+}
 #endif /* CONFIG_BLK_DEV_ZONED */
 
 struct request_queue {
diff --git a/include/uapi/linux/Kbuild b/include/uapi/linux/Kbuild
index 185f8ea..a2a7522 100644
--- a/include/uapi/linux/Kbuild
+++ b/include/uapi/linux/Kbuild
@@ -70,6 +70,7 @@ header-y += bfs_fs.h
 header-y += binfmts.h
 header-y += blkpg.h
 header-y += blktrace_api.h
+header-y += blkzoned.h
 header-y += bpf_common.h
 header-y += bpf.h
 header-y += bpqether.h
diff --git a/include/uapi/linux/blkzoned.h b/include/uapi/linux/blkzoned.h
new file mode 100644
index 0000000..23a2702
--- /dev/null
+++ b/include/uapi/linux/blkzoned.h
@@ -0,0 +1,91 @@
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
+/*
+ * Zone type.
+ */
+enum blkzone_type {
+	BLKZONE_TYPE_UNKNOWN,
+	BLKZONE_TYPE_CONVENTIONAL,
+	BLKZONE_TYPE_SEQWRITE_REQ,
+	BLKZONE_TYPE_SEQWRITE_PREF,
+};
+
+/*
+ * Zone condition.
+ */
+enum blkzone_cond {
+	BLKZONE_COND_NO_WP,
+	BLKZONE_COND_EMPTY,
+	BLKZONE_COND_IMP_OPEN,
+	BLKZONE_COND_EXP_OPEN,
+	BLKZONE_COND_CLOSED,
+	BLKZONE_COND_READONLY = 0xd,
+	BLKZONE_COND_FULL,
+	BLKZONE_COND_OFFLINE,
+};
+
+/*
+ * Zone descriptor for BLKREPORTZONE.
+ * start, len and wp use the regulare 512 B sector unit,
+ * regardless of the device logical block size. The overall
+ * structure size is 64 B to match the ZBC/ZAC defined zone descriptor
+ * and allow support for future additional zone information.
+ */
+struct blkzone {
+       __u64 	start;	 	/* Zone start sector */
+       __u64 	len;	 	/* Zone length in number of sectors */
+       __u64 	wp;	 	/* Zone write pointer position */
+       __u8	type;		/* Zone type */
+       __u8	cond;		/* Zone condition */
+       __u8	non_seq;	/* Non-sequential write resources active */
+       __u8	reset;		/* Reset write pointer recommended */
+       __u8 	reserved[36];
+};
+
+/*
+ * Zone ioctl's:
+ *
+ * BLKUPDATEZONES	: Force update of all zones information
+ * BLKREPORTZONE	: Get a zone descriptor. Takes a zone descriptor as
+ *                        argument. The zone to report is the one
+ *                        containing the sector initially specified in the
+ *                        descriptor start field.
+ * BLKRESETZONE		: Reset the write pointer of the zone containing the
+ *                        specified sector, or of all written zones if the
+ *                        sector is ~0ull.
+ * BLKOPENZONE		: Explicitely open the zone containing the
+ *                        specified sector, or all possible zones if the
+ *                        sector is ~0ull (the drive determines which zone
+ *                        to open in this case).
+ * BLKCLOSEZONE		: Close the zone containing the specified sector, or
+ *                        all open zones if the sector is ~0ull.
+ * BLKFINISHZONE	: Finish the zone (make it full) containing the
+ *                        specified sector, or all open and closed zones if
+ *                        the sector is ~0ull.
+ */
+#define BLKUPDATEZONES	_IO(0x12,130)
+#define BLKREPORTZONE 	_IOWR(0x12,131,struct blkzone)
+#define BLKRESETZONE 	_IOW(0x12,132,unsigned long long)
+#define BLKOPENZONE 	_IOW(0x12,133,unsigned long long)
+#define BLKCLOSEZONE 	_IOW(0x12,134,unsigned long long)
+#define BLKFINISHZONE 	_IOW(0x12,135,unsigned long long)
+
+#endif /* _UAPI_BLKZONED_H */
diff --git a/include/uapi/linux/fs.h b/include/uapi/linux/fs.h
index 3b00f7c..1db6d66 100644
--- a/include/uapi/linux/fs.h
+++ b/include/uapi/linux/fs.h
@@ -222,6 +222,7 @@ struct fsxattr {
 #define BLKSECDISCARD _IO(0x12,125)
 #define BLKROTATIONAL _IO(0x12,126)
 #define BLKZEROOUT _IO(0x12,127)
+/* A jump here: 130-135 are used for zoned block devices (see uapi/linux/blkzoned.h) */
 
 #define BMAP_IOCTL 1		/* obsolete - kept for compatibility */
 #define FIBMAP	   _IO(0x00,1)	/* bmap access */
-- 
2.7.4

