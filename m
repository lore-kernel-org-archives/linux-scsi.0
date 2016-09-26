From: Damien Le Moal <damien.lemoal@hgst.com>
Subject: [PATCH v2 5/7] block: Implement support for zoned block devices
Date: Mon, 26 Sep 2016 20:14:41 +0900
Message-ID: <1474888483-29762-6-git-send-email-damien.lemoal@hgst.com>
References: <1474888483-29762-1-git-send-email-damien.lemoal@hgst.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:54467 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934759AbcIZLPS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 26 Sep 2016 07:15:18 -0400
In-Reply-To: <1474888483-29762-1-git-send-email-damien.lemoal@hgst.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, "Martin K . Petersen" <martin.petersen@oracle.com>, Hannes Reinecke <hare@suse.de>, Damien Le Moal <damien.lemoal@hgst.com>

From: Hannes Reinecke <hare@suse.de>

Implement zoned block device zone information reporting and reset.
Zone information are reported as struct blk_zone. This implementation
does not differentiate between host-aware and host-managed device
models and is valid for both. Two functions are provided:
blkdev_report_zones for discovering the zone configuration of a
zoned block device, and blkdev_reset_zones for resetting the write
pointer of sequential zones. The helper function blk_queue_zone_size
and bdev_zone_size are also provided for, as the name suggest,
obtaining the zone size (in 512B sectors) of the zones of the device.

Signed-off-by: Hannes Reinecke <hare@suse.de>

[Damien: * Removed the zone cache
         * Implement report zones operation based on earlier proposal
           by Shaun Tancheff <shaun.tancheff@seagate.com>]
Signed-off-by: Damien Le Moal <damien.lemoal@hgst.com>
---
 block/Kconfig          |   8 ++
 block/Makefile         |   1 +
 block/blk-zoned.c      | 240 +++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/blkdev.h |  71 +++++++++++++++
 4 files changed, 320 insertions(+)
 create mode 100644 block/blk-zoned.c

diff --git a/block/Kconfig b/block/Kconfig
index 1d4d624..6b0ad08 100644
--- a/block/Kconfig
+++ b/block/Kconfig
@@ -89,6 +89,14 @@ config BLK_DEV_INTEGRITY
 	T10/SCSI Data Integrity Field or the T13/ATA External Path
 	Protection.  If in doubt, say N.
 
+config BLK_DEV_ZONED
+	bool "Zoned block device support"
+	---help---
+	Block layer zoned block device support. This option enables
+	support for ZAC/ZBC host-managed and host-aware zoned block devices.
+
+	Say yes here if you have a ZAC or ZBC storage device.
+
 config BLK_DEV_THROTTLING
 	bool "Block layer bio throttling support"
 	depends on BLK_CGROUP=y
diff --git a/block/Makefile b/block/Makefile
index 36acdd7..9371bc7 100644
--- a/block/Makefile
+++ b/block/Makefile
@@ -22,4 +22,5 @@ obj-$(CONFIG_IOSCHED_CFQ)	+= cfq-iosched.o
 obj-$(CONFIG_BLOCK_COMPAT)	+= compat_ioctl.o
 obj-$(CONFIG_BLK_CMDLINE_PARSER)	+= cmdline-parser.o
 obj-$(CONFIG_BLK_DEV_INTEGRITY) += bio-integrity.o blk-integrity.o t10-pi.o
+obj-$(CONFIG_BLK_DEV_ZONED)	+= blk-zoned.o
 obj-$(CONFIG_BLK_MQ_PCI)	+= blk-mq-pci.o
diff --git a/block/blk-zoned.c b/block/blk-zoned.c
new file mode 100644
index 0000000..473cb0a
--- /dev/null
+++ b/block/blk-zoned.c
@@ -0,0 +1,240 @@
+/*
+ * Zoned block device handling
+ *
+ * Copyright (c) 2015, Hannes Reinecke
+ * Copyright (c) 2015, SUSE Linux GmbH
+ *
+ * Copyright (c) 2016, Damien Le Moal
+ * Copyright (c) 2016, Western Digital
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/rbtree.h>
+#include <linux/blkdev.h>
+
+static inline sector_t blk_zone_start(struct request_queue *q,
+				      sector_t sector)
+{
+	sector_t zone_mask = blk_queue_zone_size(q) - 1;
+
+	return sector & ~zone_mask;
+}
+
+static inline void blkdev_report_to_zone(struct block_device *bdev,
+					 void *rep,
+					 struct blk_zone *zone)
+{
+	sector_t offset = get_start_sect(bdev);
+
+	memcpy(zone, rep, sizeof(struct blk_zone));
+	zone->start -= offset;
+	if (zone->type == BLK_ZONE_TYPE_CONVENTIONAL)
+		zone->wp = zone->start + zone->len;
+	else
+		zone->wp -= offset;
+}
+
+/**
+ * blkdev_report_zones - Get zones information
+ * @bdev:	Target block device
+ * @sector:	Sector from which to report zones
+ * @zones:      Array of zone structures where to return the zones information
+ * @nr_zones:   Number of zone structures in the zone array
+ * @gfp_mask:	Memory allocation flags (for bio_alloc)
+ *
+ * Description:
+ *    Get zone information starting from the zone containing @sector.
+ *    The number of zone information reported may be less than the number
+ *    requested by @nr_zones. The number of zones actually reported is
+ *    returned in @nr_zones.
+ */
+int blkdev_report_zones(struct block_device *bdev,
+			sector_t sector,
+			struct blk_zone *zones,
+			unsigned int *nr_zones,
+			gfp_t gfp_mask)
+{
+	struct request_queue *q = bdev_get_queue(bdev);
+	struct blk_zone_report_hdr *hdr;
+	unsigned int nrz = *nr_zones;
+	struct page *page;
+	unsigned int nr_rep;
+	size_t rep_bytes;
+	unsigned int nr_pages;
+	struct bio *bio;
+	struct bio_vec *bv;
+	unsigned int i, nz;
+	unsigned int ofst;
+	void *addr;
+	int ret = 0;
+
+	if (!q)
+		return -ENXIO;
+
+	if (!blk_queue_is_zoned(q))
+		return -EOPNOTSUPP;
+
+	if (!nrz)
+		return 0;
+
+	if (sector > bdev->bd_part->nr_sects) {
+		*nr_zones = 0;
+		return 0;
+	}
+
+	/*
+	 * The zone report has a header. So make room for it in the
+	 * payload. Also make sure that the report fits in a single BIO
+	 * that will not be split down the stack.
+	 */
+	rep_bytes = sizeof(struct blk_zone_report_hdr) +
+		sizeof(struct blk_zone) * nrz;
+	rep_bytes = (rep_bytes + PAGE_SIZE - 1) & PAGE_MASK;
+	if (rep_bytes > (queue_max_sectors(q) << 9))
+		rep_bytes = queue_max_sectors(q) << 9;
+
+	nr_pages = min_t(unsigned int, BIO_MAX_PAGES,
+			 rep_bytes >> PAGE_SHIFT);
+	nr_pages = min_t(unsigned int, nr_pages,
+			 queue_max_segments(q));
+
+	bio = bio_alloc(gfp_mask, nr_pages);
+	if (!bio)
+		return -ENOMEM;
+
+	bio->bi_bdev = bdev;
+	bio->bi_iter.bi_sector = blk_zone_start(q, sector);
+	bio_set_op_attrs(bio, REQ_OP_ZONE_REPORT, 0);
+
+	for (i = 0; i < nr_pages; i++) {
+		page = alloc_page(gfp_mask);
+		if (!page) {
+			ret = -ENOMEM;
+			goto out;
+		}
+		if (!bio_add_page(bio, page, PAGE_SIZE, 0)) {
+			__free_page(page);
+			break;
+		}
+	}
+
+	if (i == 0)
+		ret = -ENOMEM;
+	else
+		ret = submit_bio_wait(bio);
+	if (ret)
+		goto out;
+
+	/*
+	 * Process the report resukt: skip the header and go through the
+	 * reported zones to fixup and fixup the zone information for
+	 * partitions. At the same time, return the zone information into
+	 * the zone array.
+	 */
+	nz = 0;
+	nr_rep = 0;
+	bio_for_each_segment_all(bv, bio, i) {
+
+		if (!bv->bv_page)
+			break;
+
+		addr = kmap_atomic(bv->bv_page);
+
+		/* Get header in the first page */
+		ofst = 0;
+		if (!nr_rep) {
+			hdr = (struct blk_zone_report_hdr *) addr;
+			nr_rep = hdr->nr_zones;
+			ofst = sizeof(struct blk_zone_report_hdr);
+		}
+
+		/* Fixup and report zones */
+		while (ofst < bv->bv_len &&
+		       nz < min_t(unsigned int, nr_rep, nrz)) {
+			blkdev_report_to_zone(bdev, addr + ofst, &zones[nz]);
+			ofst += sizeof(struct blk_zone);
+			nz++;
+		}
+
+		kunmap_atomic(addr);
+
+		if (!nr_rep)
+			break;
+
+	}
+
+out:
+	bio_for_each_segment_all(bv, bio, i)
+		__free_page(bv->bv_page);
+	bio_put(bio);
+
+	if (ret == 0)
+		*nr_zones = nz;
+
+	return ret;
+}
+
+/**
+ * blkdev_reset_zones - Reset zones write pointer
+ * @bdev:       Target block device
+ * @sector:     Start sector of the first zone to reset
+ * @nr_sectors: Number of sectors, at least the length of one zone
+ * @gfp_mask:   Memory allocation flags (for bio_alloc)
+ *
+ * Description:
+ *    Reset the write pointer of the zones contained in the range
+ *    @sector..@sector+@nr_sectors. Specifying the entire disk sector range
+ *    is valid, but the specified range should not contain conventional zones.
+ */
+int blkdev_reset_zones(struct block_device *bdev,
+		       sector_t sector, sector_t nr_sectors,
+		       gfp_t gfp_mask)
+{
+	struct request_queue *q = bdev_get_queue(bdev);
+	sector_t zone_sectors;
+	sector_t end_sector = sector + nr_sectors;
+	struct bio *bio;
+	int ret;
+
+	if (!q)
+		return -ENXIO;
+
+	if (!blk_queue_is_zoned(q))
+		return -EOPNOTSUPP;
+
+	if (end_sector > bdev->bd_part->nr_sects)
+		/* Out of range */
+		return -EINVAL;
+
+	/* Check alignement (handle eventual smaller last zone) */
+	zone_sectors = blk_queue_zone_size(q);
+	if (sector & (zone_sectors - 1))
+		return -EINVAL;
+
+	if ((nr_sectors & (zone_sectors - 1)) &&
+	    end_sector != bdev->bd_part->nr_sects)
+		return -EINVAL;
+
+	while (sector < end_sector) {
+
+		bio = bio_alloc(gfp_mask, 0);
+		bio->bi_iter.bi_sector = sector;
+		bio->bi_bdev = bdev;
+		bio_set_op_attrs(bio, REQ_OP_ZONE_RESET, 0);
+
+		ret = submit_bio_wait(bio);
+		bio_put(bio);
+
+		if (ret)
+			return ret;
+
+		sector += zone_sectors;
+
+		/* This may take a while, so be nice to others */
+		cond_resched();
+
+	}
+
+	return 0;
+}
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index f19e16b..6034f38 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -302,6 +302,62 @@ struct queue_limits {
 	enum blk_zoned_model	zoned;
 };
 
+#ifdef CONFIG_BLK_DEV_ZONED
+
+/*
+ * Zone type.
+ */
+enum blk_zone_type {
+	BLK_ZONE_TYPE_UNKNOWN,
+	BLK_ZONE_TYPE_CONVENTIONAL,
+	BLK_ZONE_TYPE_SEQWRITE_REQ,
+	BLK_ZONE_TYPE_SEQWRITE_PREF,
+};
+
+/*
+ * Zone condition.
+ */
+enum blk_zone_cond {
+	BLK_ZONE_COND_NO_WP,
+	BLK_ZONE_COND_EMPTY,
+	BLK_ZONE_COND_IMP_OPEN,
+	BLK_ZONE_COND_EXP_OPEN,
+	BLK_ZONE_COND_CLOSED,
+	BLK_ZONE_COND_READONLY = 0xd,
+	BLK_ZONE_COND_FULL,
+	BLK_ZONE_COND_OFFLINE,
+};
+
+/*
+ * Zone descriptor for BLKREPORTZONE.
+ * start, len and wp use the regulare 512 B sector unit,
+ * regardless of the device logical block size. The overall
+ * structure size is 64 B to match the ZBC/ZAC defined zone descriptor
+ * and allow support for future additional zone information.
+ */
+struct blk_zone {
+	u64	start;		/* Zone start sector */
+	u64	len;		/* Zone length in number of sectors */
+	u64	wp;		/* Zone write pointer position */
+	u8	type;		/* Zone type */
+	u8	cond;		/* Zone condition */
+	u8	non_seq;	/* Non-sequential write resources active */
+	u8	reset;		/* Reset write pointer recommended */
+	u8	reserved[36];
+};
+
+struct blk_zone_report_hdr {
+	unsigned int	nr_zones;
+	u8		padding[60];
+};
+
+extern int blkdev_report_zones(struct block_device *,
+				sector_t, struct blk_zone *,
+				unsigned int *, gfp_t);
+extern int blkdev_reset_zones(struct block_device *, sector_t,
+				sector_t, gfp_t);
+#endif /* CONFIG_BLK_DEV_ZONED */
+
 struct request_queue {
 	/*
 	 * Together with queue_head for cacheline sharing
@@ -654,6 +710,11 @@ static inline bool blk_queue_is_zoned(struct request_queue *q)
 	}
 }
 
+static inline unsigned int blk_queue_zone_size(struct request_queue *q)
+{
+	return blk_queue_is_zoned(q) ? q->limits.chunk_sectors : 0;
+}
+
 /*
  * We regard a request as sync, if either a read or a sync write
  */
@@ -1401,6 +1462,16 @@ static inline bool bdev_is_zoned(struct block_device *bdev)
 	return false;
 }
 
+static inline unsigned int bdev_zone_size(struct block_device *bdev)
+{
+	struct request_queue *q = bdev_get_queue(bdev);
+
+	if (q)
+		return blk_queue_zone_size(q);
+
+	return 0;
+}
+
 static inline int queue_dma_alignment(struct request_queue *q)
 {
 	return q ? q->dma_alignment : 511;
-- 
2.7.4

