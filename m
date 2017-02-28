From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH 1/2] sd: Rework ZBC integration
Date: Tue, 28 Feb 2017 19:26:30 +0900
Message-ID: <20170228102631.16101-2-damien.lemoal@wdc.com>
References: <20170228102631.16101-1-damien.lemoal@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:16935 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751598AbdB1Kbb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 28 Feb 2017 05:31:31 -0500
In-Reply-To: <20170228102631.16101-1-damien.lemoal@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>, Bart Van Assche <bart.vanassche@sandisk.com>, Damien Le Moal <damien.lemoal@wdc.com>

Remove most of the zone request specific code from sd_done() and
move it to sd_zbc_complete(), which is called at the end of sd_done()
so that good_bytes is set for REQ_OP_ZONE_REPORT and REQ_OP_ZONE_RESET.
In sd_zbc_complete(), enhance checks on the value of good_bytes for
report zones to avoid eventual problems with bogus hardware.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 drivers/scsi/sd.c     |  36 ++++++------------
 drivers/scsi/sd.h     |  11 +++---
 drivers/scsi/sd_zbc.c | 101 +++++++++++++++++++++++++++++++++-----------------
 3 files changed, 84 insertions(+), 64 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index c7839f6..1bcd80a 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1786,15 +1786,11 @@ static int sd_done(struct scsi_cmnd *SCpnt)
 	struct scsi_sense_hdr sshdr;
 	struct scsi_disk *sdkp = scsi_disk(SCpnt->request->rq_disk);
 	struct request *req = SCpnt->request;
-	int sense_valid = 0;
-	int sense_deferred = 0;
-	unsigned char op = SCpnt->cmnd[0];
-	unsigned char unmap = SCpnt->cmnd[1] & 8;
+	bool sense_valid = false;
 
 	switch (req_op(req)) {
 	case REQ_OP_DISCARD:
 	case REQ_OP_WRITE_SAME:
-	case REQ_OP_ZONE_RESET:
 		if (!result) {
 			good_bytes = blk_rq_bytes(req);
 			scsi_set_resid(SCpnt, 0);
@@ -1803,27 +1799,15 @@ static int sd_done(struct scsi_cmnd *SCpnt)
 			scsi_set_resid(SCpnt, blk_rq_bytes(req));
 		}
 		break;
-	case REQ_OP_ZONE_REPORT:
-		if (!result) {
-			good_bytes = scsi_bufflen(SCpnt)
-				- scsi_get_resid(SCpnt);
-			scsi_set_resid(SCpnt, 0);
-		} else {
-			good_bytes = 0;
-			scsi_set_resid(SCpnt, blk_rq_bytes(req));
-		}
-		break;
 	}
 
 	if (result) {
-		sense_valid = scsi_command_normalize_sense(SCpnt, &sshdr);
-		if (sense_valid)
-			sense_deferred = scsi_sense_is_deferred(&sshdr);
+		sense_valid = scsi_command_normalize_sense(SCpnt, &sshdr) &&
+			!scsi_sense_is_deferred(&sshdr);
 	}
 	sdkp->medium_access_timed_out = 0;
 
-	if (driver_byte(result) != DRIVER_SENSE &&
-	    (!sense_valid || sense_deferred))
+	if (driver_byte(result) != DRIVER_SENSE && !sense_valid)
 		goto out;
 
 	switch (sshdr.sense_key) {
@@ -1847,10 +1831,14 @@ static int sd_done(struct scsi_cmnd *SCpnt)
 			good_bytes = sd_completed_bytes(SCpnt);
 		break;
 	case ILLEGAL_REQUEST:
-		if (sshdr.asc == 0x10)  /* DIX: Host detected corruption */
+		if (sshdr.asc == 0x10) {
+			/* DIX: Host detected corruption */
 			good_bytes = sd_completed_bytes(SCpnt);
-		/* INVALID COMMAND OPCODE or INVALID FIELD IN CDB */
-		if (sshdr.asc == 0x20 || sshdr.asc == 0x24) {
+		} else if (sshdr.asc == 0x20 || sshdr.asc == 0x24) {
+			unsigned char op = SCpnt->cmnd[0];
+			unsigned char unmap = SCpnt->cmnd[1] & 8;
+
+			/* INVALID COMMAND OPCODE or INVALID FIELD IN CDB */
 			switch (op) {
 			case UNMAP:
 				sd_config_discard(sdkp, SD_LBP_DISABLE);
@@ -1876,7 +1864,7 @@ static int sd_done(struct scsi_cmnd *SCpnt)
 
  out:
 	if (sd_is_zoned(sdkp))
-		sd_zbc_complete(SCpnt, good_bytes, &sshdr);
+		good_bytes = sd_zbc_complete(SCpnt, good_bytes, &sshdr);
 
 	SCSI_LOG_HLCOMPLETE(1, scmd_printk(KERN_INFO, SCpnt,
 					   "sd_done: completed %d of %d bytes\n",
diff --git a/drivers/scsi/sd.h b/drivers/scsi/sd.h
index 4dac35e..0fd4886 100644
--- a/drivers/scsi/sd.h
+++ b/drivers/scsi/sd.h
@@ -270,8 +270,9 @@ extern int sd_zbc_setup_write_cmnd(struct scsi_cmnd *cmd);
 extern void sd_zbc_cancel_write_cmnd(struct scsi_cmnd *cmd);
 extern int sd_zbc_setup_report_cmnd(struct scsi_cmnd *cmd);
 extern int sd_zbc_setup_reset_cmnd(struct scsi_cmnd *cmd);
-extern void sd_zbc_complete(struct scsi_cmnd *cmd, unsigned int good_bytes,
-			    struct scsi_sense_hdr *sshdr);
+extern unsigned int sd_zbc_complete(struct scsi_cmnd *cmd,
+				    unsigned int good_bytes,
+				    struct scsi_sense_hdr *sshdr);
 
 #else /* CONFIG_BLK_DEV_ZONED */
 
@@ -303,9 +304,9 @@ static inline int sd_zbc_setup_reset_cmnd(struct scsi_cmnd *cmd)
 	return BLKPREP_INVALID;
 }
 
-static inline void sd_zbc_complete(struct scsi_cmnd *cmd,
-				   unsigned int good_bytes,
-				   struct scsi_sense_hdr *sshdr) {}
+static inline unsigned int sd_zbc_complete(struct scsi_cmnd *cmd,
+					   unsigned int good_bytes,
+					   struct scsi_sense_hdr *sshdr) {}
 
 #endif /* CONFIG_BLK_DEV_ZONED */
 
diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
index 92620c8..789c970 100644
--- a/drivers/scsi/sd_zbc.c
+++ b/drivers/scsi/sd_zbc.c
@@ -177,8 +177,18 @@ static void sd_zbc_report_zones_complete(struct scsi_cmnd *scmd,
 	unsigned long flags;
 	u8 *buf;
 
-	if (good_bytes < 64)
-		return;
+	/*
+	 * Make sure good_bytes make sense and is aligned on 64 B.
+	 * If it is less than 64B, force the nr_zones field of the
+	 * report header to become 0 by setting good_bytes to 64.
+	 */
+	if (!good_bytes || good_bytes & 0x3f) {
+		sdev_printk(KERN_INFO, scmd->device,
+			"Invalid report zone result (xfer=%u, resid=%u)\n",
+			scsi_bufflen(scmd), scsi_get_resid(scmd));
+		good_bytes = max_t(unsigned int,
+				   round_down(good_bytes, 64), 64);
+	}
 
 	memset(&hdr, 0, sizeof(struct blk_zone_report_hdr));
 
@@ -320,55 +330,76 @@ void sd_zbc_cancel_write_cmnd(struct scsi_cmnd *cmd)
 	sd_zbc_unlock_zone(cmd->request);
 }
 
-void sd_zbc_complete(struct scsi_cmnd *cmd,
-		     unsigned int good_bytes,
-		     struct scsi_sense_hdr *sshdr)
+unsigned int sd_zbc_complete(struct scsi_cmnd *scmd,
+			     unsigned int good_bytes,
+			     struct scsi_sense_hdr *sshdr)
 {
-	int result = cmd->result;
-	struct request *rq = cmd->request;
+	int result = scmd->result;
+	struct request *req = scmd->request;
+
+	switch (req_op(req)) {
+
+	case REQ_OP_ZONE_REPORT:
+
+		if (result) {
+			/* Failed */
+			good_bytes = 0;
+			scsi_set_resid(scmd, blk_rq_bytes(req));
+			break;
+		}
+
+		/* Check good bytes */
+		if (good_bytes >= scsi_get_resid(scmd))
+			good_bytes -= scsi_get_resid(scmd);
+		sd_zbc_report_zones_complete(scmd, good_bytes);
+		scsi_set_resid(scmd, 0);
+
+		break;
+
+	case REQ_OP_ZONE_RESET:
+
+		if (!result) {
+			good_bytes = blk_rq_bytes(req);
+			scsi_set_resid(scmd, 0);
+		} else {
+			/* Failed */
+			good_bytes = 0;
+			scsi_set_resid(scmd, blk_rq_bytes(req));
+			if (sshdr->sense_key == ILLEGAL_REQUEST &&
+			    sshdr->asc == 0x24)
+				/*
+				 * ILLEGAL REQUEST / INVALID FIELD IN CDB
+				 * For a zone reset, this means that a reset
+				 * of a conventional zone was attempted.
+				 * Nothing to worry about, so be quiet about
+				 * the error.
+				 */
+				req->rq_flags |= RQF_QUIET;
+		}
+
+		/* Fallthru (for unlocking the zone) */
 
-	switch (req_op(rq)) {
 	case REQ_OP_WRITE:
 	case REQ_OP_WRITE_SAME:
-	case REQ_OP_ZONE_RESET:
 
 		/* Unlock the zone */
-		sd_zbc_unlock_zone(rq);
+		sd_zbc_unlock_zone(req);
 
-		if (!result ||
-		    sshdr->sense_key != ILLEGAL_REQUEST)
-			break;
-
-		switch (sshdr->asc) {
-		case 0x24:
-			/*
-			 * INVALID FIELD IN CDB error: For a zone reset,
-			 * this means that a reset of a conventional
-			 * zone was attempted. Nothing to worry about in
-			 * this case, so be quiet about the error.
-			 */
-			if (req_op(rq) == REQ_OP_ZONE_RESET)
-				rq->rq_flags |= RQF_QUIET;
-			break;
-		case 0x21:
+		if (!result &&
+		    sshdr->sense_key == ILLEGAL_REQUEST &&
+		    sshdr->asc == 0x21)
 			/*
 			 * INVALID ADDRESS FOR WRITE error: It is unlikely that
 			 * retrying write requests failed with any kind of
 			 * alignement error will result in success. So don't.
 			 */
-			cmd->allowed = 0;
-			break;
-		}
-
-		break;
-
-	case REQ_OP_ZONE_REPORT:
+			scmd->allowed = 0;
 
-		if (!result)
-			sd_zbc_report_zones_complete(cmd, good_bytes);
 		break;
 
 	}
+
+	return good_bytes;
 }
 
 /**
-- 
2.9.3
