From: Shaun Tancheff <shaun@tancheff.com>
Subject: [PATCH v5 1/2] Add bio/request flags for using ZBC/ZAC commands
Date: Mon, 20 Jun 2016 16:18:35 -0500
Message-ID: <1466457516-21843-2-git-send-email-shaun@tancheff.com>
References: <1466457516-21843-1-git-send-email-shaun@tancheff.com>
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1466457516-21843-1-git-send-email-shaun@tancheff.com>
Sender: linux-ide-owner@vger.kernel.org
To: linux-ide@vger.kernel.org, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: Shaun Tancheff <shaun@tancheff.com>, Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Jeff Layton <jlayton@poochiereds.net>, "J . Bruce Fields" <bfields@fieldses.org>, Shaun Tancheff <shaun.tancheff@seagate.com>
List-Id: linux-scsi@vger.kernel.org

T10 ZBC and T13 ZAC specify operations for Zoned devices.

To be able to access the zone information and open and close zones
adding op's for:
  - Report zones command: REQ_OP_ZONE_REPORT
  - Open zone: REQ_OP_ZONE_OPEN
  - Close zone: REQ_OP_ZONE_CLOSE
  - Reset Write Pointer: REQ_OP_ZONE_RESET
to be used to create struct bio / struct request to issue
ZBC commands.

Report zones is a device read that requires a buffer.
Open, Close and Reset are device commands that have no associated
data transfer.

The Finish zone command is intentionally not implimented as there is no
current use case for that operation.

Report zones currently defaults to reporting on all zones. It expected
that support for the zone option flag will piggy back on streamid
support. The report option flag is useful as it can reduce the number
of zones in each report, but not critical.

Signed-off-by: Shaun Tancheff <shaun.tancheff@seagate.com>
---
v5:
 - In sd_setup_zone_action_cmnd, remove unused vars and fix switch indent
 - In blk-lib fix documentation
v4:
 - Rebase on linux-next tag next-20160617.
 - Change bio flags to bio op's
V3:
 - Rebase on Mike Cristie's separate bio operations
 - Update blkzoned_api.h to include report zones PARTIAL bit.
V2:
 - Changed bi_rw to op_flags clarify sepeartion of bio op from flags.
 - Fixed memory leak in blkdev_issue_zone_report failing to put_bio().
 - Documented opt in blkdev_issue_zone_report.
 - Removed include/uapi/linux/fs.h from this patch.
---
 MAINTAINERS                       |   9 ++
 block/blk-lib.c                   |  98 +++++++++++++++++
 drivers/scsi/sd.c                 | 118 +++++++++++++++++++++
 drivers/scsi/sd.h                 |   1 +
 include/linux/bio.h               |   7 +-
 include/linux/blk_types.h         |   6 +-
 include/linux/blkzoned_api.h      |  25 +++++
 include/uapi/linux/Kbuild         |   1 +
 include/uapi/linux/blkzoned_api.h | 214 ++++++++++++++++++++++++++++++++++++++
 9 files changed, 477 insertions(+), 2 deletions(-)
 create mode 100644 include/linux/blkzoned_api.h
 create mode 100644 include/uapi/linux/blkzoned_api.h

diff --git a/MAINTAINERS b/MAINTAINERS
index d174e34..280f87b 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -12815,6 +12815,15 @@ F:	Documentation/networking/z8530drv.txt
 F:	drivers/net/hamradio/*scc.c
 F:	drivers/net/hamradio/z8530.h
 
+ZBC AND ZBC BLOCK DEVICES
+M:	Shaun Tancheff <shaun.tancheff@seagate.com>
+W:	http://seagate.com
+W:	https://github.com/Seagate/ZDM-Device-Mapper
+L:	linux-block@vger.kernel.org
+S:	Maintained
+F:	include/linux/blkzoned_api.h
+F:	include/uapi/linux/blkzoned_api.h
+
 ZBUD COMPRESSED PAGE ALLOCATOR
 M:	Seth Jennings <sjenning@redhat.com>
 L:	linux-mm@kvack.org
diff --git a/block/blk-lib.c b/block/blk-lib.c
index 8e24f5e..913ac00 100644
--- a/block/blk-lib.c
+++ b/block/blk-lib.c
@@ -6,6 +6,7 @@
 #include <linux/bio.h>
 #include <linux/blkdev.h>
 #include <linux/scatterlist.h>
+#include <linux/blkzoned_api.h>
 
 #include "blk.h"
 
@@ -261,3 +262,100 @@ int blkdev_issue_zeroout(struct block_device *bdev, sector_t sector,
 	return __blkdev_issue_zeroout(bdev, sector, nr_sects, gfp_mask);
 }
 EXPORT_SYMBOL(blkdev_issue_zeroout);
+
+/**
+ * blkdev_issue_zone_report - queue a report zones operation
+ * @bdev:	target blockdev
+ * @op_flags:	extra bio rw flags. If unsure, use 0.
+ * @sector:	starting sector (report will include this sector).
+ * @opt:	See: zone_report_option, default is 0 (all zones).
+ * @page:	one or more contiguous pages.
+ * @pgsz:	up to size of page in bytes, size of report.
+ * @gfp_mask:	memory allocation flags (for bio_alloc)
+ *
+ * Description:
+ *    Issue a zone report request for the sectors in question.
+ */
+int blkdev_issue_zone_report(struct block_device *bdev, unsigned int op_flags,
+			     sector_t sector, u8 opt, struct page *page,
+			     size_t pgsz, gfp_t gfp_mask)
+{
+	struct bdev_zone_report *conv = page_address(page);
+	struct bio *bio;
+	unsigned int nr_iovecs = 1;
+	int ret = 0;
+
+	if (pgsz < (sizeof(struct bdev_zone_report) +
+		    sizeof(struct bdev_zone_descriptor)))
+		return -EINVAL;
+
+	bio = bio_alloc(gfp_mask, nr_iovecs);
+	if (!bio)
+		return -ENOMEM;
+
+	conv->descriptor_count = 0;
+	bio->bi_iter.bi_sector = sector;
+	bio->bi_bdev = bdev;
+	bio->bi_vcnt = 0;
+	bio->bi_iter.bi_size = 0;
+
+	/* FUTURE ... when streamid is available: */
+	/* bio_set_streamid(bio, opt); */
+
+	bio_add_page(bio, page, pgsz, 0);
+	bio_set_op_attrs(bio, REQ_OP_ZONE_REPORT, op_flags);
+	ret = submit_bio_wait(bio);
+
+	/*
+	 * When our request it nak'd the underlying device maybe conventional
+	 * so ... report a single conventional zone the size of the device.
+	 */
+	if (ret == -EIO && conv->descriptor_count) {
+		/* Adjust the conventional to the size of the partition ... */
+		__be64 blksz = cpu_to_be64(bdev->bd_part->nr_sects);
+
+		conv->maximum_lba = blksz;
+		conv->descriptors[0].type = ZTYP_CONVENTIONAL;
+		conv->descriptors[0].flags = ZCOND_CONVENTIONAL << 4;
+		conv->descriptors[0].length = blksz;
+		conv->descriptors[0].lba_start = 0;
+		conv->descriptors[0].lba_wptr = blksz;
+		ret = 0;
+	}
+	bio_put(bio);
+	return ret;
+}
+EXPORT_SYMBOL(blkdev_issue_zone_report);
+
+/**
+ * blkdev_issue_zone_action - queue a report zones operation
+ * @bdev:	target blockdev
+ * @op:		One of REQ_OP_ZONE_OPEN, REQ_OP_ZONE_CLOSE, REQ_OP_ZONE_RESET
+ * @op_flags:	extra bio rw flags. If unsure, use 0.
+ * @sector:	starting lba of sector
+ * @gfp_mask:	memory allocation flags (for bio_alloc)
+ *
+ * Description:
+ *    Issue a zone report request for the sectors in question.
+ */
+int blkdev_issue_zone_action(struct block_device *bdev, unsigned int op,
+			     unsigned int op_flags, sector_t sector,
+			     gfp_t gfp_mask)
+{
+	int ret;
+	struct bio *bio;
+
+	bio = bio_alloc(gfp_mask, 1);
+	if (!bio)
+		return -ENOMEM;
+
+	bio->bi_iter.bi_sector = sector;
+	bio->bi_bdev = bdev;
+	bio->bi_vcnt = 0;
+	bio->bi_iter.bi_size = 0;
+	bio_set_op_attrs(bio, op, op_flags);
+	ret = submit_bio_wait(bio);
+	bio_put(bio);
+	return ret;
+}
+EXPORT_SYMBOL(blkdev_issue_zone_action);
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 0609d68..8aca4f3 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -52,6 +52,7 @@
 #include <linux/slab.h>
 #include <linux/pm_runtime.h>
 #include <linux/pr.h>
+#include <linux/blkzoned_api.h>
 #include <asm/uaccess.h>
 #include <asm/unaligned.h>
 
@@ -1134,6 +1135,115 @@ static int sd_setup_read_write_cmnd(struct scsi_cmnd *SCpnt)
 	return ret;
 }
 
+static int sd_setup_zone_report_cmnd(struct scsi_cmnd *cmd)
+{
+	struct request *rq = cmd->request;
+	struct scsi_device *sdp = cmd->device;
+	struct scsi_disk *sdkp = scsi_disk(rq->rq_disk);
+	struct bio *bio = rq->bio;
+	sector_t sector = blk_rq_pos(rq);
+	struct gendisk *disk = rq->rq_disk;
+	unsigned int nr_bytes = blk_rq_bytes(rq);
+	int ret = BLKPREP_KILL;
+
+	WARN_ON(nr_bytes == 0);
+
+	/*
+	 * For conventional drives generate a report that shows a
+	 * large single convetional zone the size of the block device
+	 */
+	if (sdkp->zoned != 1 && sdkp->device->type != TYPE_ZBC) {
+		void *src;
+		struct bdev_zone_report *conv;
+
+		if (nr_bytes < sizeof(struct bdev_zone_report))
+			goto out;
+
+		src = kmap_atomic(bio->bi_io_vec->bv_page);
+		conv = src + bio->bi_io_vec->bv_offset;
+		conv->descriptor_count = cpu_to_be32(1);
+		conv->same_field = ZS_ALL_SAME;
+		conv->maximum_lba = cpu_to_be64(disk->part0.nr_sects);
+		kunmap_atomic(src);
+		goto out;
+	}
+
+	ret = scsi_init_io(cmd);
+	if (ret != BLKPREP_OK)
+		goto out;
+
+	cmd = rq->special;
+	if (sdp->changed) {
+		pr_err("SCSI disk has been changed or is not present.");
+		ret = BLKPREP_KILL;
+		goto out;
+	}
+
+	cmd->cmd_len = 16;
+	memset(cmd->cmnd, 0, cmd->cmd_len);
+	cmd->cmnd[0] = ZBC_IN;
+	cmd->cmnd[1] = ZI_REPORT_ZONES;
+	put_unaligned_be64(sector, &cmd->cmnd[2]);
+	put_unaligned_be32(nr_bytes, &cmd->cmnd[10]);
+	/* FUTURE ... when streamid is available */
+	/* cmd->cmnd[14] = bio_get_streamid(bio); */
+
+	cmd->sc_data_direction = DMA_FROM_DEVICE;
+	cmd->sdb.length = nr_bytes;
+	cmd->transfersize = sdp->sector_size;
+	cmd->underflow = 0;
+	cmd->allowed = SD_MAX_RETRIES;
+	ret = BLKPREP_OK;
+out:
+	return ret;
+}
+
+static int sd_setup_zone_action_cmnd(struct scsi_cmnd *cmd)
+{
+	struct request *rq = cmd->request;
+	struct scsi_disk *sdkp = scsi_disk(rq->rq_disk);
+	sector_t sector = blk_rq_pos(rq);
+	int ret = BLKPREP_KILL;
+	u8 allbit = 0;
+
+	if (sdkp->zoned != 1 && sdkp->device->type != TYPE_ZBC)
+		goto out;
+
+	if (sector == ~0ul) {
+		allbit = 1;
+		sector = 0;
+	}
+
+	cmd->cmd_len = 16;
+	memset(cmd->cmnd, 0, cmd->cmd_len);
+	memset(&cmd->sdb, 0, sizeof(cmd->sdb));
+	cmd->cmnd[0] = ZBC_OUT;
+	switch (req_op(rq)) {
+	case REQ_OP_ZONE_OPEN:
+		cmd->cmnd[1] = ZO_OPEN_ZONE;
+		break;
+	case REQ_OP_ZONE_CLOSE:
+		cmd->cmnd[1] = ZO_CLOSE_ZONE;
+		break;
+	case REQ_OP_ZONE_RESET:
+		cmd->cmnd[1] = ZO_RESET_WRITE_POINTER;
+		break;
+	default:
+		goto out;
+	}
+	cmd->cmnd[14] = allbit;
+	put_unaligned_be64(sector, &cmd->cmnd[2]);
+
+	cmd->transfersize = 0;
+	cmd->underflow = 0;
+	cmd->allowed = SD_MAX_RETRIES;
+	cmd->sc_data_direction = DMA_NONE;
+
+	ret = BLKPREP_OK;
+out:
+	return ret;
+}
+
 static int sd_init_command(struct scsi_cmnd *cmd)
 {
 	struct request *rq = cmd->request;
@@ -1148,6 +1258,12 @@ static int sd_init_command(struct scsi_cmnd *cmd)
 	case REQ_OP_READ:
 	case REQ_OP_WRITE:
 		return sd_setup_read_write_cmnd(cmd);
+	case REQ_OP_ZONE_REPORT:
+		return sd_setup_zone_report_cmnd(cmd);
+	case REQ_OP_ZONE_OPEN:
+	case REQ_OP_ZONE_CLOSE:
+	case REQ_OP_ZONE_RESET:
+		return sd_setup_zone_action_cmnd(cmd);
 	default:
 		BUG();
 	}
@@ -2738,6 +2854,8 @@ static void sd_read_block_characteristics(struct scsi_disk *sdkp)
 		queue_flag_clear_unlocked(QUEUE_FLAG_ADD_RANDOM, sdkp->disk->queue);
 	}
 
+	sdkp->zoned = (buffer[8] >> 4) & 3;
+
  out:
 	kfree(buffer);
 }
diff --git a/drivers/scsi/sd.h b/drivers/scsi/sd.h
index 765a6f1..f782990 100644
--- a/drivers/scsi/sd.h
+++ b/drivers/scsi/sd.h
@@ -94,6 +94,7 @@ struct scsi_disk {
 	unsigned	lbpvpd : 1;
 	unsigned	ws10 : 1;
 	unsigned	ws16 : 1;
+	unsigned	zoned: 2;
 };
 #define to_scsi_disk(obj) container_of(obj,struct scsi_disk,dev)
 
diff --git a/include/linux/bio.h b/include/linux/bio.h
index b7e1a008..b63a281 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -79,7 +79,12 @@ static inline bool bio_has_data(struct bio *bio)
 
 static inline bool bio_no_advance_iter(struct bio *bio)
 {
-	return bio_op(bio) == REQ_OP_DISCARD || bio_op(bio) == REQ_OP_WRITE_SAME;
+	return bio_op(bio) == REQ_OP_DISCARD ||
+	       bio_op(bio) == REQ_OP_WRITE_SAME ||
+	       bio_op(bio) == REQ_OP_ZONE_REPORT ||
+	       bio_op(bio) == REQ_OP_ZONE_OPEN ||
+	       bio_op(bio) == REQ_OP_ZONE_CLOSE ||
+	       bio_op(bio) == REQ_OP_ZONE_RESET;
 }
 
 static inline bool bio_is_rw(struct bio *bio)
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index c92f7f8..b2e0e25 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -225,13 +225,17 @@ enum rq_flag_bits {
 enum req_op {
 	REQ_OP_READ,
 	REQ_OP_WRITE,
+	REQ_OP_ZONE_REPORT,
+	REQ_OP_ZONE_OPEN,
+	REQ_OP_ZONE_CLOSE,
+	REQ_OP_ZONE_RESET,
 	REQ_OP_DISCARD,		/* request to discard sectors */
 	REQ_OP_SECURE_ERASE,	/* request to securely erase sectors */
 	REQ_OP_WRITE_SAME,	/* write same block many times */
 	REQ_OP_FLUSH,		/* request for cache flush */
 };
 
-#define REQ_OP_BITS 3
+#define REQ_OP_BITS 4
 
 typedef unsigned int blk_qc_t;
 #define BLK_QC_T_NONE	-1U
diff --git a/include/linux/blkzoned_api.h b/include/linux/blkzoned_api.h
new file mode 100644
index 0000000..47c091a
--- /dev/null
+++ b/include/linux/blkzoned_api.h
@@ -0,0 +1,25 @@
+/*
+ * Functions for zone based SMR devices.
+ *
+ * Copyright (C) 2015 Seagate Technology PLC
+ *
+ * Written by:
+ * Shaun Tancheff <shaun.tancheff@seagate.com>
+ *
+ * This file is licensed under  the terms of the GNU General Public
+ * License version 2. This program is licensed "as is" without any
+ * warranty of any kind, whether express or implied.
+ */
+
+#ifndef _BLKZONED_API_H
+#define _BLKZONED_API_H
+
+#include <uapi/linux/blkzoned_api.h>
+
+extern int blkdev_issue_zone_action(struct block_device *, unsigned int op,
+				    unsigned int op_flags, sector_t, gfp_t);
+extern int blkdev_issue_zone_report(struct block_device *, unsigned int op_flgs,
+				    sector_t, u8 opt, struct page *, size_t,
+				    gfp_t);
+
+#endif /* _BLKZONED_API_H */
diff --git a/include/uapi/linux/Kbuild b/include/uapi/linux/Kbuild
index ad821a3..86d9efe 100644
--- a/include/uapi/linux/Kbuild
+++ b/include/uapi/linux/Kbuild
@@ -70,6 +70,7 @@ header-y += bfs_fs.h
 header-y += binfmts.h
 header-y += blkpg.h
 header-y += blktrace_api.h
+header-y += blkzoned_api.h
 header-y += bpf_common.h
 header-y += bpf.h
 header-y += bpqether.h
diff --git a/include/uapi/linux/blkzoned_api.h b/include/uapi/linux/blkzoned_api.h
new file mode 100644
index 0000000..48c17ad
--- /dev/null
+++ b/include/uapi/linux/blkzoned_api.h
@@ -0,0 +1,214 @@
+/*
+ * Functions for zone based SMR devices.
+ *
+ * Copyright (C) 2015 Seagate Technology PLC
+ *
+ * Written by:
+ * Shaun Tancheff <shaun.tancheff@seagate.com>
+ *
+ * This file is licensed under  the terms of the GNU General Public
+ * License version 2. This program is licensed "as is" without any
+ * warranty of any kind, whether express or implied.
+ */
+
+#ifndef _UAPI_BLKZONED_API_H
+#define _UAPI_BLKZONED_API_H
+
+#include <linux/types.h>
+
+/**
+ * enum zone_report_option - Report Zones types to be included.
+ *
+ * @ZOPT_NON_SEQ_AND_RESET: Default (all zones).
+ * @ZOPT_ZC1_EMPTY: Zones which are empty.
+ * @ZOPT_ZC2_OPEN_IMPLICIT: Zones open but not explicitly opened
+ * @ZOPT_ZC3_OPEN_EXPLICIT: Zones opened explicitly
+ * @ZOPT_ZC4_CLOSED: Zones closed for writing.
+ * @ZOPT_ZC5_FULL: Zones that are full.
+ * @ZOPT_ZC6_READ_ONLY: Zones that are read-only
+ * @ZOPT_ZC7_OFFLINE: Zones that are offline
+ * @ZOPT_RESET: Zones that are empty
+ * @ZOPT_NON_SEQ: Zones that have HA media-cache writes pending
+ * @ZOPT_NON_WP_ZONES: Zones that do not have Write Pointers (conventional)
+ * @ZOPT_PARTIAL_FLAG: Modifies the definition of the Zone List Length field.
+ *
+ * Used by Report Zones in bdev_zone_get_report: report_option
+ */
+enum zone_report_option {
+	ZOPT_NON_SEQ_AND_RESET   = 0x00,
+	ZOPT_ZC1_EMPTY,
+	ZOPT_ZC2_OPEN_IMPLICIT,
+	ZOPT_ZC3_OPEN_EXPLICIT,
+	ZOPT_ZC4_CLOSED,
+	ZOPT_ZC5_FULL,
+	ZOPT_ZC6_READ_ONLY,
+	ZOPT_ZC7_OFFLINE,
+	ZOPT_RESET               = 0x10,
+	ZOPT_NON_SEQ             = 0x11,
+	ZOPT_NON_WP_ZONES        = 0x3f,
+	ZOPT_PARTIAL_FLAG        = 0x80,
+};
+
+/**
+ * enum bdev_zone_type - Type of zone in descriptor
+ *
+ * @ZTYP_RESERVED: Reserved
+ * @ZTYP_CONVENTIONAL: Conventional random write zone (No Write Pointer)
+ * @ZTYP_SEQ_WRITE_REQUIRED: Non-sequential writes are rejected.
+ * @ZTYP_SEQ_WRITE_PREFERRED: Non-sequential writes allowed but discouraged.
+ *
+ * Returned from Report Zones. See bdev_zone_descriptor* type.
+ */
+enum bdev_zone_type {
+	ZTYP_RESERVED            = 0,
+	ZTYP_CONVENTIONAL        = 1,
+	ZTYP_SEQ_WRITE_REQUIRED  = 2,
+	ZTYP_SEQ_WRITE_PREFERRED = 3,
+};
+
+
+/**
+ * enum bdev_zone_condition - Condition of zone in descriptor
+ *
+ * @ZCOND_CONVENTIONAL: N/A
+ * @ZCOND_ZC1_EMPTY: Empty
+ * @ZCOND_ZC2_OPEN_IMPLICIT: Opened via write to zone.
+ * @ZCOND_ZC3_OPEN_EXPLICIT: Opened via open zone command.
+ * @ZCOND_ZC4_CLOSED: Closed
+ * @ZCOND_ZC6_READ_ONLY:
+ * @ZCOND_ZC5_FULL: No remaining space in zone.
+ * @ZCOND_ZC7_OFFLINE: Offline
+ *
+ * Returned from Report Zones. See bdev_zone_descriptor* flags.
+ */
+enum bdev_zone_condition {
+	ZCOND_CONVENTIONAL       = 0,
+	ZCOND_ZC1_EMPTY          = 1,
+	ZCOND_ZC2_OPEN_IMPLICIT  = 2,
+	ZCOND_ZC3_OPEN_EXPLICIT  = 3,
+	ZCOND_ZC4_CLOSED         = 4,
+	/* 0x5 to 0xC are reserved */
+	ZCOND_ZC6_READ_ONLY      = 0xd,
+	ZCOND_ZC5_FULL           = 0xe,
+	ZCOND_ZC7_OFFLINE        = 0xf,
+};
+
+
+/**
+ * enum bdev_zone_same - Report Zones same code.
+ *
+ * @ZS_ALL_DIFFERENT: All zones differ in type and size.
+ * @ZS_ALL_SAME: All zones are the same size and type.
+ * @ZS_LAST_DIFFERS: All zones are the same size and type except the last zone.
+ * @ZS_SAME_LEN_DIFF_TYPES: All zones are the same length but types differ.
+ *
+ * Returned from Report Zones. See bdev_zone_report* same_field.
+ */
+enum bdev_zone_same {
+	ZS_ALL_DIFFERENT        = 0,
+	ZS_ALL_SAME             = 1,
+	ZS_LAST_DIFFERS         = 2,
+	ZS_SAME_LEN_DIFF_TYPES  = 3,
+};
+
+
+/**
+ * struct bdev_zone_get_report - ioctl: Report Zones request
+ *
+ * @zone_locator_lba: starting lba for first [reported] zone
+ * @return_page_count: number of *bytes* allocated for result
+ * @report_option: see: zone_report_option enum
+ *
+ * Used to issue report zones command to connected device
+ */
+struct bdev_zone_get_report {
+	__u64 zone_locator_lba;
+	__u32 return_page_count;
+	__u8  report_option;
+} __packed;
+
+/**
+ * struct bdev_zone_descriptor_le - See: bdev_zone_descriptor
+ */
+struct bdev_zone_descriptor_le {
+	__u8 type;
+	__u8 flags;
+	__u8 reserved1[6];
+	__le64 length;
+	__le64 lba_start;
+	__le64 lba_wptr;
+	__u8 reserved[32];
+} __packed;
+
+
+/**
+ * struct bdev_zone_report_le - See: bdev_zone_report
+ */
+struct bdev_zone_report_le {
+	__le32 descriptor_count;
+	__u8 same_field;
+	__u8 reserved1[3];
+	__le64 maximum_lba;
+	__u8 reserved2[48];
+	struct bdev_zone_descriptor_le descriptors[0];
+} __packed;
+
+
+/**
+ * struct bdev_zone_descriptor - A Zone descriptor entry from report zones
+ *
+ * @type: see zone_type enum
+ * @flags: Bits 0:reset, 1:non-seq, 2-3: resv, 4-7: see zone_condition enum
+ * @reserved1: padding
+ * @length: length of zone in sectors
+ * @lba_start: lba where the zone starts.
+ * @lba_wptr: lba of the current write pointer.
+ * @reserved: padding
+ *
+ */
+struct bdev_zone_descriptor {
+	__u8 type;
+	__u8 flags;
+	__u8  reserved1[6];
+	__be64 length;
+	__be64 lba_start;
+	__be64 lba_wptr;
+	__u8 reserved[32];
+} __packed;
+
+
+/**
+ * struct bdev_zone_report - Report Zones result
+ *
+ * @descriptor_count: Number of descriptor entries that follow
+ * @same_field: bits 0-3: enum zone_same (MASK: 0x0F)
+ * @reserved1: padding
+ * @maximum_lba: LBA of the last logical sector on the device, inclusive
+ *               of all logical sectors in all zones.
+ * @reserved2: padding
+ * @descriptors: array of descriptors follows.
+ */
+struct bdev_zone_report {
+	__be32 descriptor_count;
+	__u8 same_field;
+	__u8 reserved1[3];
+	__be64 maximum_lba;
+	__u8 reserved2[48];
+	struct bdev_zone_descriptor descriptors[0];
+} __packed;
+
+
+/**
+ * struct bdev_zone_report_io - Report Zones ioctl argument.
+ *
+ * @in: Report Zones inputs
+ * @out: Report Zones output
+ */
+struct bdev_zone_report_io {
+	union {
+		struct bdev_zone_get_report in;
+		struct bdev_zone_report out;
+	} data;
+} __packed;
+
+#endif /* _UAPI_BLKZONED_API_H */
-- 
2.8.1

