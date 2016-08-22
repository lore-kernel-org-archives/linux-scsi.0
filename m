From: Shaun Tancheff <shaun@tancheff.com>
Subject: [PATCH v2 3/4] Merge ZBC constants
Date: Sun, 21 Aug 2016 23:31:15 -0500
Message-ID: <20160822043116.21168-4-shaun@tancheff.com>
References: <20160822043116.21168-1-shaun@tancheff.com>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20160822043116.21168-1-shaun@tancheff.com>
Sender: linux-block-owner@vger.kernel.org
To: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Shaun Tancheff <shaun@tancheff.com>, Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Damien Le Moal <damien.lemoal@hgst.com>, Hannes Reinecke <hare@suse.de>, Josh Bingaman <josh.bingaman@seagate.com>, Dan Williams <dan.j.williams@intel.com>, Sagi Grimberg <sagig@mellanox.com>, Mike Christie <mchristi@redhat.com>, Toshi Kani <toshi.kani@hpe.com>, Ming Lei <ming.lei@canonical.com>, Shaun Tancheff <shaun.tancheff@seagate.com>
List-Id: linux-scsi@vger.kernel.org

Dedupe ZBC/ZAC constants used for reporting options, same code,
zone condition and zone type.

These are all useful to programs consuming zone information from
user space as well so include them in a uapi header.

Signed-off-by: Shaun Tancheff <shaun.tancheff@seagate.com>
---
 block/blk-lib.c                   |   4 +-
 drivers/scsi/sd.c                 |   2 +-
 include/linux/blkdev.h            |  20 -----
 include/scsi/scsi_proto.h         |  17 ----
 include/uapi/linux/blkzoned_api.h | 167 +++++++++++++++++++++++---------------
 5 files changed, 103 insertions(+), 107 deletions(-)

diff --git a/block/blk-lib.c b/block/blk-lib.c
index e92bd56..67b9258 100644
--- a/block/blk-lib.c
+++ b/block/blk-lib.c
@@ -316,8 +316,8 @@ int blkdev_issue_zone_report(struct block_device *bdev, unsigned int op_flags,
 		__be64 blksz = cpu_to_be64(bdev->bd_part->nr_sects);
 
 		conv->maximum_lba = blksz;
-		conv->descriptors[0].type = ZTYP_CONVENTIONAL;
-		conv->descriptors[0].flags = ZCOND_CONVENTIONAL << 4;
+		conv->descriptors[0].type = BLK_ZONE_TYPE_CONVENTIONAL;
+		conv->descriptors[0].flags = BLK_ZONE_NO_WP << 4;
 		conv->descriptors[0].length = blksz;
 		conv->descriptors[0].lba_start = 0;
 		conv->descriptors[0].lba_wptr = blksz;
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index d5ef6d8..b76ffbb 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1201,7 +1201,7 @@ static int sd_setup_zone_report_cmnd(struct scsi_cmnd *cmd)
 		src = kmap_atomic(bio->bi_io_vec->bv_page);
 		conv = src + bio->bi_io_vec->bv_offset;
 		conv->descriptor_count = cpu_to_be32(1);
-		conv->same_field = ZS_ALL_SAME;
+		conv->same_field = BLK_ZONE_SAME_ALL;
 		conv->maximum_lba = cpu_to_be64(disk->part0.nr_sects);
 		kunmap_atomic(src);
 		goto out;
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 68198eb..d5cdb5d 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -263,26 +263,6 @@ struct blk_queue_tag {
 #define BLK_SCSI_CMD_PER_LONG	(BLK_SCSI_MAX_CMDS / (sizeof(long) * 8))
 
 #ifdef CONFIG_BLK_DEV_ZONED
-enum blk_zone_type {
-	BLK_ZONE_TYPE_UNKNOWN,
-	BLK_ZONE_TYPE_CONVENTIONAL,
-	BLK_ZONE_TYPE_SEQWRITE_REQ,
-	BLK_ZONE_TYPE_SEQWRITE_PREF,
-	BLK_ZONE_TYPE_RESERVED,
-};
-
-enum blk_zone_state {
-	BLK_ZONE_NO_WP,
-	BLK_ZONE_EMPTY,
-	BLK_ZONE_OPEN,
-	BLK_ZONE_OPEN_EXPLICIT,
-	BLK_ZONE_CLOSED,
-	BLK_ZONE_UNKNOWN = 5,
-	BLK_ZONE_READONLY = 0xd,
-	BLK_ZONE_FULL,
-	BLK_ZONE_OFFLINE,
-	BLK_ZONE_BUSY = 0x20,
-};
 
 struct blk_zone {
 	struct rb_node node;
diff --git a/include/scsi/scsi_proto.h b/include/scsi/scsi_proto.h
index 6ba66e0..d1defd1 100644
--- a/include/scsi/scsi_proto.h
+++ b/include/scsi/scsi_proto.h
@@ -299,21 +299,4 @@ struct scsi_lun {
 #define SCSI_ACCESS_STATE_MASK        0x0f
 #define SCSI_ACCESS_STATE_PREFERRED   0x80
 
-/* Reporting options for REPORT ZONES */
-enum zbc_zone_reporting_options {
-	ZBC_ZONE_REPORTING_OPTION_ALL = 0,
-	ZBC_ZONE_REPORTING_OPTION_EMPTY,
-	ZBC_ZONE_REPORTING_OPTION_IMPLICIT_OPEN,
-	ZBC_ZONE_REPORTING_OPTION_EXPLICIT_OPEN,
-	ZBC_ZONE_REPORTING_OPTION_CLOSED,
-	ZBC_ZONE_REPORTING_OPTION_FULL,
-	ZBC_ZONE_REPORTING_OPTION_READONLY,
-	ZBC_ZONE_REPORTING_OPTION_OFFLINE,
-	ZBC_ZONE_REPORTING_OPTION_NEED_RESET_WP = 0x10,
-	ZBC_ZONE_REPORTING_OPTION_NON_SEQWRITE,
-	ZBC_ZONE_REPORTING_OPTION_NON_WP = 0x3f,
-};
-
-#define ZBC_REPORT_ZONE_PARTIAL 0x80
-
 #endif /* _SCSI_PROTO_H_ */
diff --git a/include/uapi/linux/blkzoned_api.h b/include/uapi/linux/blkzoned_api.h
index cd81a9f..fa12976 100644
--- a/include/uapi/linux/blkzoned_api.h
+++ b/include/uapi/linux/blkzoned_api.h
@@ -16,97 +16,123 @@
 
 #include <linux/types.h>
 
+#define ZBC_REPORT_OPTION_MASK  0x3f
+#define ZBC_REPORT_ZONE_PARTIAL 0x80
+
 /**
  * enum zone_report_option - Report Zones types to be included.
  *
- * @ZOPT_NON_SEQ_AND_RESET: Default (all zones).
- * @ZOPT_ZC1_EMPTY: Zones which are empty.
- * @ZOPT_ZC2_OPEN_IMPLICIT: Zones open but not explicitly opened
- * @ZOPT_ZC3_OPEN_EXPLICIT: Zones opened explicitly
- * @ZOPT_ZC4_CLOSED: Zones closed for writing.
- * @ZOPT_ZC5_FULL: Zones that are full.
- * @ZOPT_ZC6_READ_ONLY: Zones that are read-only
- * @ZOPT_ZC7_OFFLINE: Zones that are offline
- * @ZOPT_RESET: Zones that are empty
- * @ZOPT_NON_SEQ: Zones that have HA media-cache writes pending
- * @ZOPT_NON_WP_ZONES: Zones that do not have Write Pointers (conventional)
- * @ZOPT_PARTIAL_FLAG: Modifies the definition of the Zone List Length field.
+ * @ZBC_ZONE_REPORTING_OPTION_ALL: Default (all zones).
+ * @ZBC_ZONE_REPORTING_OPTION_EMPTY: Zones which are empty.
+ * @ZBC_ZONE_REPORTING_OPTION_IMPLICIT_OPEN:
+ *	Zones open but not explicitly opened
+ * @ZBC_ZONE_REPORTING_OPTION_EXPLICIT_OPEN: Zones opened explicitly
+ * @ZBC_ZONE_REPORTING_OPTION_CLOSED: Zones closed for writing.
+ * @ZBC_ZONE_REPORTING_OPTION_FULL: Zones that are full.
+ * @ZBC_ZONE_REPORTING_OPTION_READONLY: Zones that are read-only
+ * @ZBC_ZONE_REPORTING_OPTION_OFFLINE: Zones that are offline
+ * @ZBC_ZONE_REPORTING_OPTION_NEED_RESET_WP: Zones with Reset WP Recommended
+ * @ZBC_ZONE_REPORTING_OPTION_RESERVED: Zones that with Non-Sequential
+ *	Write Resources Active
+ * @ZBC_ZONE_REPORTING_OPTION_NON_WP: Zones that do not have Write Pointers
+ *	(conventional)
+ * @ZBC_ZONE_REPORTING_OPTION_RESERVED: Undefined
+ * @ZBC_ZONE_REPORTING_OPTION_PARTIAL: Modifies the definition of the Zone List
+ *	Length field.
  *
  * Used by Report Zones in bdev_zone_get_report: report_option
  */
-enum bdev_zone_report_option {
-	ZOPT_NON_SEQ_AND_RESET   = 0x00,
-	ZOPT_ZC1_EMPTY,
-	ZOPT_ZC2_OPEN_IMPLICIT,
-	ZOPT_ZC3_OPEN_EXPLICIT,
-	ZOPT_ZC4_CLOSED,
-	ZOPT_ZC5_FULL,
-	ZOPT_ZC6_READ_ONLY,
-	ZOPT_ZC7_OFFLINE,
-	ZOPT_RESET               = 0x10,
-	ZOPT_NON_SEQ             = 0x11,
-	ZOPT_NON_WP_ZONES        = 0x3f,
-	ZOPT_PARTIAL_FLAG        = 0x80,
+enum zbc_zone_reporting_options {
+	ZBC_ZONE_REPORTING_OPTION_ALL = 0,
+	ZBC_ZONE_REPORTING_OPTION_EMPTY,
+	ZBC_ZONE_REPORTING_OPTION_IMPLICIT_OPEN,
+	ZBC_ZONE_REPORTING_OPTION_EXPLICIT_OPEN,
+	ZBC_ZONE_REPORTING_OPTION_CLOSED,
+	ZBC_ZONE_REPORTING_OPTION_FULL,
+	ZBC_ZONE_REPORTING_OPTION_READONLY,
+	ZBC_ZONE_REPORTING_OPTION_OFFLINE,
+	ZBC_ZONE_REPORTING_OPTION_NEED_RESET_WP = 0x10,
+	ZBC_ZONE_REPORTING_OPTION_NON_SEQWRITE,
+	ZBC_ZONE_REPORTING_OPTION_NON_WP = 0x3f,
+	ZBC_ZONE_REPORTING_OPTION_RESERVED = 0x40,
+	ZBC_ZONE_REPORTING_OPTION_PARTIAL = ZBC_REPORT_ZONE_PARTIAL
 };
 
 /**
- * enum bdev_zone_type - Type of zone in descriptor
+ * enum blk_zone_type - Types of zones allowed in a zoned device.
  *
- * @ZTYP_RESERVED: Reserved
- * @ZTYP_CONVENTIONAL: Conventional random write zone (No Write Pointer)
- * @ZTYP_SEQ_WRITE_REQUIRED: Non-sequential writes are rejected.
- * @ZTYP_SEQ_WRITE_PREFERRED: Non-sequential writes allowed but discouraged.
+ * @BLK_ZONE_TYPE_RESERVED: Reserved.
+ * @BLK_ZONE_TYPE_CONVENTIONAL: Zone has no WP. Zone commands are not available.
+ * @BLK_ZONE_TYPE_SEQWRITE_REQ: Zone must be written sequentially
+ * @BLK_ZONE_TYPE_SEQWRITE_PREF: Zone may be written non-sequentially
  *
- * Returned from Report Zones. See bdev_zone_descriptor* type.
+ * TBD: Move to blkzoned_api - we don't need pointless duplication
+ * and user space needs to handle the same information in the
+ * same format -- so lets make it easy
  */
-enum bdev_zone_type {
-	ZTYP_RESERVED            = 0,
-	ZTYP_CONVENTIONAL        = 1,
-	ZTYP_SEQ_WRITE_REQUIRED  = 2,
-	ZTYP_SEQ_WRITE_PREFERRED = 3,
+enum blk_zone_type {
+	BLK_ZONE_TYPE_RESERVED,
+	BLK_ZONE_TYPE_CONVENTIONAL,
+	BLK_ZONE_TYPE_SEQWRITE_REQ,
+	BLK_ZONE_TYPE_SEQWRITE_PREF,
+	BLK_ZONE_TYPE_UNKNOWN,
 };
 
 /**
- * enum bdev_zone_condition - Condition of zone in descriptor
- *
- * @ZCOND_CONVENTIONAL: N/A
- * @ZCOND_ZC1_EMPTY: Empty
- * @ZCOND_ZC2_OPEN_IMPLICIT: Opened via write to zone.
- * @ZCOND_ZC3_OPEN_EXPLICIT: Opened via open zone command.
- * @ZCOND_ZC4_CLOSED: Closed
- * @ZCOND_ZC6_READ_ONLY:
- * @ZCOND_ZC5_FULL: No remaining space in zone.
- * @ZCOND_ZC7_OFFLINE: Offline
- *
- * Returned from Report Zones. See bdev_zone_descriptor* flags.
+ * enum blk_zone_state - State [condition] of a zone in a zoned device.
+ *
+ * @BLK_ZONE_NO_WP: Zone has not write pointer it is CMR/Conventional
+ * @BLK_ZONE_EMPTY: Zone is empty. Write pointer is at the start of the zone.
+ * @BLK_ZONE_OPEN: Zone is open, but not explicitly opened by a zone open cmd.
+ * @BLK_ZONE_OPEN_EXPLICIT: Zones was explicitly opened by a zone open cmd.
+ * @BLK_ZONE_CLOSED: Zone was [explicitly] closed for writing.
+ * @BLK_ZONE_UNKNOWN: Zone states 0x5 through 0xc are reserved by standard.
+ * @BLK_ZONE_FULL: Zone was [explicitly] marked full by a zone finish cmd.
+ * @BLK_ZONE_READONLY: Zone is read-only.
+ * @BLK_ZONE_OFFLINE: Zone is offline.
+ * @BLK_ZONE_BUSY: [INTERNAL] Kernel zone cache for this zone is being updated.
+ *
+ * The Zone Condition state machine also maps the above deinitions as:
+ *   - ZC1: Empty         | BLK_ZONE_EMPTY
+ *   - ZC2: Implicit Open | BLK_ZONE_OPEN
+ *   - ZC3: Explicit Open | BLK_ZONE_OPEN_EXPLICIT
+ *   - ZC4: Closed        | BLK_ZONE_CLOSED
+ *   - ZC5: Full          | BLK_ZONE_FULL
+ *   - ZC6: Read Only     | BLK_ZONE_READONLY
+ *   - ZC7: Offline       | BLK_ZONE_OFFLINE
+ *
+ * States 0x5 to 0xC are reserved by the current ZBC/ZAC spec.
  */
-enum bdev_zone_condition {
-	ZCOND_CONVENTIONAL       = 0,
-	ZCOND_ZC1_EMPTY          = 1,
-	ZCOND_ZC2_OPEN_IMPLICIT  = 2,
-	ZCOND_ZC3_OPEN_EXPLICIT  = 3,
-	ZCOND_ZC4_CLOSED         = 4,
-	/* 0x5 to 0xC are reserved */
-	ZCOND_ZC6_READ_ONLY      = 0xd,
-	ZCOND_ZC5_FULL           = 0xe,
-	ZCOND_ZC7_OFFLINE        = 0xf,
+enum blk_zone_state {
+	BLK_ZONE_NO_WP,
+	BLK_ZONE_EMPTY,
+	BLK_ZONE_OPEN,
+	BLK_ZONE_OPEN_EXPLICIT,
+	BLK_ZONE_CLOSED,
+	BLK_ZONE_UNKNOWN = 0x5,
+	BLK_ZONE_READONLY = 0xd,
+	BLK_ZONE_FULL = 0xe,
+	BLK_ZONE_OFFLINE = 0xf,
+	BLK_ZONE_BUSY = 0x10,
 };
 
 /**
  * enum bdev_zone_same - Report Zones same code.
  *
- * @ZS_ALL_DIFFERENT: All zones differ in type and size.
- * @ZS_ALL_SAME: All zones are the same size and type.
- * @ZS_LAST_DIFFERS: All zones are the same size and type except the last zone.
- * @ZS_SAME_LEN_DIFF_TYPES: All zones are the same length but types differ.
+ * @BLK_ZONE_SAME_ALL_DIFFERENT: All zones differ in type and size.
+ * @BLK_ZONE_SAME_ALL: All zones are the same size and type.
+ * @BLK_ZONE_SAME_LAST_DIFFERS: All zones are the same size and type
+ *    except the last zone which differs by size.
+ * @BLK_ZONE_SAME_LEN_TYPES_DIFFER: All zones are the same length
+ *    but zone types differ.
  *
  * Returned from Report Zones. See bdev_zone_report* same_field.
  */
-enum bdev_zone_same {
-	ZS_ALL_DIFFERENT        = 0,
-	ZS_ALL_SAME             = 1,
-	ZS_LAST_DIFFERS         = 2,
-	ZS_SAME_LEN_DIFF_TYPES  = 3,
+enum blk_zone_same {
+	BLK_ZONE_SAME_ALL_DIFFERENT     = 0,
+	BLK_ZONE_SAME_ALL               = 1,
+	BLK_ZONE_SAME_LAST_DIFFERS      = 2,
+	BLK_ZONE_SAME_LEN_TYPES_DIFFER  = 3,
 };
 
 /**
@@ -198,6 +224,13 @@ struct bdev_zone_report_io {
 	} data;
 } __packed;
 
+
+static inline u32 max_report_entries(size_t bytes)
+{
+	bytes -= sizeof(struct bdev_zone_report);
+	return bytes / sizeof(struct bdev_zone_descriptor);
+}
+
 /* continuing from uapi/linux/fs.h: */
 #define BLKREPORT	_IOWR(0x12, 130, struct bdev_zone_report_io)
 #define BLKZONEACTION	_IOW(0x12, 131, struct bdev_zone_action)
-- 
2.9.3

