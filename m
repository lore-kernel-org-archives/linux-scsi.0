From: damien.lemoal@wdc.com
Subject: [PATCH v2 5/7] sd_zbc: Rename sd_zbc_setup_write_cmnd
Date: Mon, 24 Apr 2017 16:51:13 +0900
Message-ID: <20170424075115.30337-6-damien.lemoal@wdc.com>
References: <20170424075115.30337-1-damien.lemoal@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:8132 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1166215AbdDXHvn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 24 Apr 2017 03:51:43 -0400
In-Reply-To: <20170424075115.30337-1-damien.lemoal@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Bart Van Assche <Bart.VanAssche@sandisk.com>, Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>, Damien Le Moal <damien.lemoal@wdc.com>

From: Damien Le Moal <damien.lemoal@wdc.com>

Rename sd_zbc_setup_write_cmnd() to sd_zbc_write_lock_zone() to be
clear about what the function actually does. To be consistent, also
rename sd_zbc_cancel_write_cmnd() to sd_zbc_write_unlock_zone().

No functional change is introduced by this patch.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
Reviewed-by: Bart Van Assche <Bart.VanAssche@sandisk.com>
---
 drivers/scsi/sd.c     |  6 +++---
 drivers/scsi/sd.h     |  8 ++++----
 drivers/scsi/sd_zbc.c | 12 ++++--------
 3 files changed, 11 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 2d1ac5c..25a4ab1 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -846,7 +846,7 @@ static int sd_setup_write_same_cmnd(struct scsi_cmnd *cmd)
 	BUG_ON(bio_offset(bio) || bio_iovec(bio).bv_len != sdp->sector_size);
 
 	if (sd_is_zoned(sdkp)) {
-		ret = sd_zbc_setup_write_cmnd(cmd);
+		ret = sd_zbc_write_lock_zone(cmd);
 		if (ret != BLKPREP_OK)
 			return ret;
 	}
@@ -918,7 +918,7 @@ static int sd_setup_read_write_cmnd(struct scsi_cmnd *SCpnt)
 	unsigned char protect;
 
 	if (zoned_write) {
-		ret = sd_zbc_setup_write_cmnd(SCpnt);
+		ret = sd_zbc_write_lock_zone(SCpnt);
 		if (ret != BLKPREP_OK)
 			return ret;
 	}
@@ -1145,7 +1145,7 @@ static int sd_setup_read_write_cmnd(struct scsi_cmnd *SCpnt)
 	ret = BLKPREP_OK;
  out:
 	if (zoned_write && ret != BLKPREP_OK)
-		sd_zbc_cancel_write_cmnd(SCpnt);
+		sd_zbc_write_unlock_zone(SCpnt);
 
 	return ret;
 }
diff --git a/drivers/scsi/sd.h b/drivers/scsi/sd.h
index 0cf9680..2044e07a 100644
--- a/drivers/scsi/sd.h
+++ b/drivers/scsi/sd.h
@@ -267,8 +267,8 @@ static inline int sd_is_zoned(struct scsi_disk *sdkp)
 extern int sd_zbc_read_zones(struct scsi_disk *sdkp, unsigned char *buffer);
 extern void sd_zbc_remove(struct scsi_disk *sdkp);
 extern void sd_zbc_print_zones(struct scsi_disk *sdkp);
-extern int sd_zbc_setup_write_cmnd(struct scsi_cmnd *cmd);
-extern void sd_zbc_cancel_write_cmnd(struct scsi_cmnd *cmd);
+extern int sd_zbc_write_lock_zone(struct scsi_cmnd *cmd);
+extern void sd_zbc_write_unlock_zone(struct scsi_cmnd *cmd);
 extern int sd_zbc_setup_report_cmnd(struct scsi_cmnd *cmd);
 extern int sd_zbc_setup_reset_cmnd(struct scsi_cmnd *cmd);
 extern void sd_zbc_complete(struct scsi_cmnd *cmd, unsigned int good_bytes,
@@ -286,13 +286,13 @@ static inline void sd_zbc_remove(struct scsi_disk *sdkp) {}
 
 static inline void sd_zbc_print_zones(struct scsi_disk *sdkp) {}
 
-static inline int sd_zbc_setup_write_cmnd(struct scsi_cmnd *cmd)
+static inline int sd_zbc_write_lock_zone(struct scsi_cmnd *cmd)
 {
 	/* Let the drive fail requests */
 	return BLKPREP_OK;
 }
 
-static inline void sd_zbc_cancel_write_cmnd(struct scsi_cmnd *cmd) {}
+static inline void sd_zbc_write_unlock_zone(struct scsi_cmnd *cmd) {}
 
 static inline int sd_zbc_setup_report_cmnd(struct scsi_cmnd *cmd)
 {
diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
index 92620c8..a792682 100644
--- a/drivers/scsi/sd_zbc.c
+++ b/drivers/scsi/sd_zbc.c
@@ -269,7 +269,7 @@ int sd_zbc_setup_reset_cmnd(struct scsi_cmnd *cmd)
 	return BLKPREP_OK;
 }
 
-int sd_zbc_setup_write_cmnd(struct scsi_cmnd *cmd)
+int sd_zbc_write_lock_zone(struct scsi_cmnd *cmd)
 {
 	struct request *rq = cmd->request;
 	struct scsi_disk *sdkp = scsi_disk(rq->rq_disk);
@@ -303,8 +303,9 @@ int sd_zbc_setup_write_cmnd(struct scsi_cmnd *cmd)
 	return BLKPREP_OK;
 }
 
-static void sd_zbc_unlock_zone(struct request *rq)
+void sd_zbc_write_unlock_zone(struct scsi_cmnd *cmd)
 {
+	struct request *rq = cmd->request;
 	struct scsi_disk *sdkp = scsi_disk(rq->rq_disk);
 
 	if (sdkp->zones_wlock) {
@@ -315,11 +316,6 @@ static void sd_zbc_unlock_zone(struct request *rq)
 	}
 }
 
-void sd_zbc_cancel_write_cmnd(struct scsi_cmnd *cmd)
-{
-	sd_zbc_unlock_zone(cmd->request);
-}
-
 void sd_zbc_complete(struct scsi_cmnd *cmd,
 		     unsigned int good_bytes,
 		     struct scsi_sense_hdr *sshdr)
@@ -333,7 +329,7 @@ void sd_zbc_complete(struct scsi_cmnd *cmd,
 	case REQ_OP_ZONE_RESET:
 
 		/* Unlock the zone */
-		sd_zbc_unlock_zone(rq);
+		sd_zbc_write_unlock_zone(cmd);
 
 		if (!result ||
 		    sshdr->sense_key != ILLEGAL_REQUEST)
-- 
2.9.3
