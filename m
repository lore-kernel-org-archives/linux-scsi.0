From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH 4/8] scsi: sd_zbc: Reorganize and cleanup
Date: Fri,  1 Sep 2017 20:36:27 +0900
Message-ID: <20170901113631.12323-5-damien.lemoal@wdc.com>
References: <20170901113631.12323-1-damien.lemoal@wdc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:23872 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751566AbdIALi0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Sep 2017 07:38:26 -0400
In-Reply-To: <20170901113631.12323-1-damien.lemoal@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@lst.de>, Bart Van Assche <Bart.VanAssche@wdc.com>

Introduce sd_zbc.h for zbc related declarations (avoid cluttering sd.h).

Fix comments style in sd_zbc.c (do not use documentation format) and
add/fix comments to enhance explanations. Also remove a useless blank
line in sd_zbc_read_zones().

Rearrange sd_zbc_setup() to include use_16_for_rw and use_10_for_rw
assignment and simplify nr_zones calculation.

Finally, use the min() macro sd_zbc_check_zone_size() to get a report
zone reply size instead of the open coded version.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 drivers/scsi/sd.c     |  1 +
 drivers/scsi/sd.h     | 53 --------------------------------
 drivers/scsi/sd_zbc.c | 85 +++++++++++++++++++++++++--------------------------
 drivers/scsi/sd_zbc.h | 75 +++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 117 insertions(+), 97 deletions(-)
 create mode 100644 drivers/scsi/sd_zbc.h

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 962cef13d406..6711d49fde79 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -68,6 +68,7 @@
 #include <scsi/scsicam.h>
 
 #include "sd.h"
+#include "sd_zbc.h"
 #include "scsi_priv.h"
 #include "scsi_logging.h"
 
diff --git a/drivers/scsi/sd.h b/drivers/scsi/sd.h
index 99c4dde9b6bf..5940390d30f3 100644
--- a/drivers/scsi/sd.h
+++ b/drivers/scsi/sd.h
@@ -272,57 +272,4 @@ static inline void sd_dif_complete(struct scsi_cmnd *cmd, unsigned int a)
 
 #endif /* CONFIG_BLK_DEV_INTEGRITY */
 
-static inline int sd_is_zoned(struct scsi_disk *sdkp)
-{
-	return sdkp->zoned == 1 || sdkp->device->type == TYPE_ZBC;
-}
-
-#ifdef CONFIG_BLK_DEV_ZONED
-
-extern int sd_zbc_read_zones(struct scsi_disk *sdkp, unsigned char *buffer);
-extern void sd_zbc_remove(struct scsi_disk *sdkp);
-extern void sd_zbc_print_zones(struct scsi_disk *sdkp);
-extern int sd_zbc_write_lock_zone(struct scsi_cmnd *cmd);
-extern void sd_zbc_write_unlock_zone(struct scsi_cmnd *cmd);
-extern int sd_zbc_setup_report_cmnd(struct scsi_cmnd *cmd);
-extern int sd_zbc_setup_reset_cmnd(struct scsi_cmnd *cmd);
-extern void sd_zbc_complete(struct scsi_cmnd *cmd, unsigned int good_bytes,
-			    struct scsi_sense_hdr *sshdr);
-
-#else /* CONFIG_BLK_DEV_ZONED */
-
-static inline int sd_zbc_read_zones(struct scsi_disk *sdkp,
-				    unsigned char *buf)
-{
-	return 0;
-}
-
-static inline void sd_zbc_remove(struct scsi_disk *sdkp) {}
-
-static inline void sd_zbc_print_zones(struct scsi_disk *sdkp) {}
-
-static inline int sd_zbc_write_lock_zone(struct scsi_cmnd *cmd)
-{
-	/* Let the drive fail requests */
-	return BLKPREP_OK;
-}
-
-static inline void sd_zbc_write_unlock_zone(struct scsi_cmnd *cmd) {}
-
-static inline int sd_zbc_setup_report_cmnd(struct scsi_cmnd *cmd)
-{
-	return BLKPREP_INVALID;
-}
-
-static inline int sd_zbc_setup_reset_cmnd(struct scsi_cmnd *cmd)
-{
-	return BLKPREP_INVALID;
-}
-
-static inline void sd_zbc_complete(struct scsi_cmnd *cmd,
-				   unsigned int good_bytes,
-				   struct scsi_sense_hdr *sshdr) {}
-
-#endif /* CONFIG_BLK_DEV_ZONED */
-
 #endif /* _SCSI_DISK_H */
diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
index d445a57f99bd..810377007665 100644
--- a/drivers/scsi/sd_zbc.c
+++ b/drivers/scsi/sd_zbc.c
@@ -26,22 +26,12 @@
 
 #include <asm/unaligned.h>
 
-#include <scsi/scsi.h>
-#include <scsi/scsi_cmnd.h>
-#include <scsi/scsi_dbg.h>
-#include <scsi/scsi_device.h>
-#include <scsi/scsi_driver.h>
-#include <scsi/scsi_host.h>
-#include <scsi/scsi_eh.h>
-
-#include "sd.h"
-#include "scsi_priv.h"
-
-/**
+#include "sd_zbc.h"
+
+/*
  * Convert a zone descriptor to a zone struct.
  */
-static void sd_zbc_parse_report(struct scsi_disk *sdkp,
-				u8 *buf,
+static void sd_zbc_parse_report(struct scsi_disk *sdkp, u8 *buf,
 				struct blk_zone *zone)
 {
 	struct scsi_device *sdp = sdkp->device;
@@ -63,8 +53,9 @@ static void sd_zbc_parse_report(struct scsi_disk *sdkp,
 		zone->wp = zone->start + zone->len;
 }
 
-/**
+/*
  * Issue a REPORT ZONES scsi command.
+ * For internal use.
  */
 static int sd_zbc_report_zones(struct scsi_disk *sdkp, unsigned char *buf,
 			       unsigned int buflen, sector_t lba)
@@ -105,6 +96,9 @@ static int sd_zbc_report_zones(struct scsi_disk *sdkp, unsigned char *buf,
 	return 0;
 }
 
+/*
+ * Prepare a REPORT ZONES scsi command for a REQ_OP_ZONE_REPORT request.
+ */
 int sd_zbc_setup_report_cmnd(struct scsi_cmnd *cmd)
 {
 	struct request *rq = cmd->request;
@@ -147,6 +141,10 @@ int sd_zbc_setup_report_cmnd(struct scsi_cmnd *cmd)
 	return BLKPREP_OK;
 }
 
+/*
+ * Process a REPORT ZONES scsi command reply, converting all reported
+ * zone descriptors to blk_zone structures.
+ */
 static void sd_zbc_report_zones_complete(struct scsi_cmnd *scmd,
 					 unsigned int good_bytes)
 {
@@ -202,17 +200,9 @@ static void sd_zbc_report_zones_complete(struct scsi_cmnd *scmd,
 	local_irq_restore(flags);
 }
 
-static inline sector_t sd_zbc_zone_sectors(struct scsi_disk *sdkp)
-{
-	return logical_to_sectors(sdkp->device, sdkp->zone_blocks);
-}
-
-static inline unsigned int sd_zbc_zone_no(struct scsi_disk *sdkp,
-					  sector_t sector)
-{
-	return sectors_to_logical(sdkp->device, sector) >> sdkp->zone_shift;
-}
-
+/*
+ * Prepare a RESET WRITE POINTER scsi command for a REQ_OP_ZONE_RESET request.
+ */
 int sd_zbc_setup_reset_cmnd(struct scsi_cmnd *cmd)
 {
 	struct request *rq = cmd->request;
@@ -245,6 +235,11 @@ int sd_zbc_setup_reset_cmnd(struct scsi_cmnd *cmd)
 	return BLKPREP_OK;
 }
 
+/*
+ * Write lock a sequential zone.
+ * Called from sd_init_cmd() for write requests
+ * (standard write, write same or write zeroes operations).
+ */
 int sd_zbc_write_lock_zone(struct scsi_cmnd *cmd)
 {
 	struct request *rq = cmd->request;
@@ -282,6 +277,10 @@ int sd_zbc_write_lock_zone(struct scsi_cmnd *cmd)
 	return BLKPREP_OK;
 }
 
+/*
+ * Write unlock a sequential zone.
+ * Called from sd_uninit_cmd().
+ */
 void sd_zbc_write_unlock_zone(struct scsi_cmnd *cmd)
 {
 	struct request *rq = cmd->request;
@@ -341,7 +340,7 @@ void sd_zbc_complete(struct scsi_cmnd *cmd,
 	}
 }
 
-/**
+/*
  * Read zoned block device characteristics (VPD page B6).
  */
 static int sd_zbc_read_zoned_characteristics(struct scsi_disk *sdkp,
@@ -371,7 +370,7 @@ static int sd_zbc_read_zoned_characteristics(struct scsi_disk *sdkp,
 	return 0;
 }
 
-/**
+/*
  * Check reported capacity.
  */
 static int sd_zbc_check_capacity(struct scsi_disk *sdkp,
@@ -403,8 +402,12 @@ static int sd_zbc_check_capacity(struct scsi_disk *sdkp,
 	return 0;
 }
 
-#define SD_ZBC_BUF_SIZE 131072
+#define SD_ZBC_BUF_SIZE 131072U
 
+/*
+ * Check that all zones of the device have the same size, with eventually
+ * the exception of the last zone which is allowed to have a smaller size.
+ */
 static int sd_zbc_check_zone_size(struct scsi_disk *sdkp)
 {
 	u64 zone_blocks;
@@ -447,10 +450,7 @@ static int sd_zbc_check_zone_size(struct scsi_disk *sdkp)
 		/* Parse REPORT ZONES header */
 		list_length = get_unaligned_be32(&buf[0]) + 64;
 		rec = buf + 64;
-		if (list_length < SD_ZBC_BUF_SIZE)
-			buf_len = list_length;
-		else
-			buf_len = SD_ZBC_BUF_SIZE;
+		buf_len = min(list_length, SD_ZBC_BUF_SIZE);
 
 		/* Parse zone descriptors */
 		while (rec < buf + buf_len) {
@@ -505,6 +505,7 @@ static int sd_zbc_check_zone_size(struct scsi_disk *sdkp)
 	}
 
 	sdkp->zone_blocks = zone_blocks;
+	sdkp->zone_shift = ilog2(zone_blocks);
 
 	return 0;
 }
@@ -512,13 +513,15 @@ static int sd_zbc_check_zone_size(struct scsi_disk *sdkp)
 static int sd_zbc_setup(struct scsi_disk *sdkp)
 {
 
+	/* READ16/WRITE16 is mandatory for ZBC disks */
+	sdkp->device->use_16_for_rw = 1;
+	sdkp->device->use_10_for_rw = 0;
+
 	/* chunk_sectors indicates the zone size */
 	blk_queue_chunk_sectors(sdkp->disk->queue,
 			logical_to_sectors(sdkp->device, sdkp->zone_blocks));
-	sdkp->zone_shift = ilog2(sdkp->zone_blocks);
-	sdkp->nr_zones = sdkp->capacity >> sdkp->zone_shift;
-	if (sdkp->capacity & (sdkp->zone_blocks - 1))
-		sdkp->nr_zones++;
+	sdkp->nr_zones =
+		round_up(sdkp->capacity, sdkp->zone_blocks) >> sdkp->zone_shift;
 
 	if (!sdkp->zones_wlock) {
 		sdkp->zones_wlock = kcalloc(BITS_TO_LONGS(sdkp->nr_zones),
@@ -531,8 +534,7 @@ static int sd_zbc_setup(struct scsi_disk *sdkp)
 	return 0;
 }
 
-int sd_zbc_read_zones(struct scsi_disk *sdkp,
-		      unsigned char *buf)
+int sd_zbc_read_zones(struct scsi_disk *sdkp, unsigned char *buf)
 {
 	int ret;
 
@@ -543,7 +545,6 @@ int sd_zbc_read_zones(struct scsi_disk *sdkp,
 		 */
 		return 0;
 
-
 	/* Get zoned block device characteristics */
 	ret = sd_zbc_read_zoned_characteristics(sdkp, buf);
 	if (ret)
@@ -580,10 +581,6 @@ int sd_zbc_read_zones(struct scsi_disk *sdkp,
 	if (ret)
 		goto err;
 
-	/* READ16/WRITE16 is mandatory for ZBC disks */
-	sdkp->device->use_16_for_rw = 1;
-	sdkp->device->use_10_for_rw = 0;
-
 	return 0;
 
 err:
diff --git a/drivers/scsi/sd_zbc.h b/drivers/scsi/sd_zbc.h
new file mode 100644
index 000000000000..c120672d56d6
--- /dev/null
+++ b/drivers/scsi/sd_zbc.h
@@ -0,0 +1,75 @@
+#ifndef _SCSI_DISK_ZBC_H
+#define _SCSI_DISK_ZBC_H
+
+#include <scsi/scsi.h>
+#include <scsi/scsi_cmnd.h>
+#include <scsi/scsi_device.h>
+#include "sd.h"
+
+static inline int sd_is_zoned(struct scsi_disk *sdkp)
+{
+	return sdkp->zoned == 1 || sdkp->device->type == TYPE_ZBC;
+}
+
+#ifdef CONFIG_BLK_DEV_ZONED
+
+static inline sector_t sd_zbc_zone_sectors(struct scsi_disk *sdkp)
+{
+	return logical_to_sectors(sdkp->device, sdkp->zone_blocks);
+}
+
+static inline unsigned int sd_zbc_zone_no(struct scsi_disk *sdkp,
+					  sector_t sector)
+{
+	return sectors_to_logical(sdkp->device, sector) >> sdkp->zone_shift;
+}
+
+extern int sd_zbc_read_zones(struct scsi_disk *sdkp, unsigned char *buffer);
+extern void sd_zbc_remove(struct scsi_disk *sdkp);
+extern void sd_zbc_print_zones(struct scsi_disk *sdkp);
+
+extern int sd_zbc_write_lock_zone(struct scsi_cmnd *cmd);
+extern void sd_zbc_write_unlock_zone(struct scsi_cmnd *cmd);
+
+extern int sd_zbc_setup_report_cmnd(struct scsi_cmnd *cmd);
+extern int sd_zbc_setup_reset_cmnd(struct scsi_cmnd *cmd);
+extern void sd_zbc_complete(struct scsi_cmnd *cmd, unsigned int good_bytes,
+			    struct scsi_sense_hdr *sshdr);
+
+#else /* CONFIG_BLK_DEV_ZONED */
+
+static inline int sd_zbc_read_zones(struct scsi_disk *sdkp,
+				    unsigned char *buf)
+{
+	return 0;
+}
+
+static inline void sd_zbc_remove(struct scsi_disk *sdkp) {}
+
+static inline void sd_zbc_print_zones(struct scsi_disk *sdkp) {}
+
+static inline int sd_zbc_write_lock_zone(struct scsi_cmnd *cmd)
+{
+	/* Let the drive fail requests */
+	return BLKPREP_OK;
+}
+
+static inline void sd_zbc_write_unlock_zone(struct scsi_cmnd *cmd) {}
+
+static inline int sd_zbc_setup_report_cmnd(struct scsi_cmnd *cmd)
+{
+	return BLKPREP_INVALID;
+}
+
+static inline int sd_zbc_setup_reset_cmnd(struct scsi_cmnd *cmd)
+{
+	return BLKPREP_INVALID;
+}
+
+static inline void sd_zbc_complete(struct scsi_cmnd *cmd,
+				   unsigned int good_bytes,
+				   struct scsi_sense_hdr *sshdr) {}
+
+#endif /* CONFIG_BLK_DEV_ZONED */
+
+#endif /* _SCSI_DISK_ZBC_H */
-- 
2.13.5
