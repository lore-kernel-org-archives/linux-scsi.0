From: Matthew Wilcox <matthew@wil.cx>
Subject: [PATCH 11/22] advansys: Support 16-byte commands properly
Date: Sun,  9 Sep 2007 08:56:36 -0600
Message-ID: <11893498073679-git-send-email-matthew@wil.cx>
References: <20070909145358.GG6809@parisc-linux.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.tor.primus.ca ([216.254.136.21]:44561 "EHLO
	mail-09.primus.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757316AbXIIO4v (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 9 Sep 2007 10:56:51 -0400
In-Reply-To: <20070909145358.GG6809@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Matthew Wilcox <matthew@wil.cx>

The SCSI midlayer won't send commands greater than ->max_cmd_len.
So the checks on length in asc_build_req and adv_build_req are obsolete
and can be deleted, but also we have to set the max_cmd_len in
advansys_board_found().  Also move the length definitions together, and
write a helpful comment.

Signed-off-by: Matthew Wilcox <matthew@wil.cx>
---
 drivers/scsi/advansys.c |   39 ++++++++++-----------------------------
 1 files changed, 10 insertions(+), 29 deletions(-)

diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
index d7bc0cf..ef4f679 100644
--- a/drivers/scsi/advansys.c
+++ b/drivers/scsi/advansys.c
@@ -210,10 +210,16 @@ typedef unsigned char uchar;
 #define ASC_SCSI_WIDTH_BIT_SET  0xFF
 #define ASC_MAX_SENSE_LEN   32
 #define ASC_MIN_SENSE_LEN   14
-#define ASC_MAX_CDB_LEN     12
 #define ASC_SCSI_RESET_HOLD_TIME_US  60
 
 /*
+ * Narrow boards only support 12-byte commands, while wide boards
+ * extend to 16-byte commands.
+ */
+#define ASC_MAX_CDB_LEN     12
+#define ADV_MAX_CDB_LEN     16
+
+/*
  * Inquiry SPC-2 SPI Byte 1 EVPD (Enable Vital Product Data)
  * and CmdDt (Command Support Data) field bit definitions.
  */
@@ -1190,12 +1196,6 @@ static const char *advansys_info(struct Scsi_Host *shost);
 #define ADV_CARRIER_COUNT (ASC_DEF_MAX_HOST_QNG + 15)
 
 /*
- * For wide  boards a CDB length maximum of 16 bytes
- * is supported.
- */
-#define ADV_MAX_CDB_LEN     16
-
-/*
  * Define total number of simultaneous maximum element scatter-gather
  * request blocks per wide adapter. ASC_DEF_MAX_HOST_QNG (253) is the
  * maximum number of outstanding commands per wide host adapter. Each
@@ -3856,17 +3856,7 @@ static int asc_build_req(asc_board_t *boardp, struct scsi_cmnd *scp)
 
 	/*
 	 * Build the ASC_SCSI_Q request.
-	 *
-	 * For narrow boards a CDB length maximum of 12 bytes
-	 * is supported.
 	 */
-	if (scp->cmd_len > ASC_MAX_CDB_LEN) {
-		ASC_PRINT3("asc_build_req: board %d: cmd_len %d > "
-			"ASC_MAX_CDB_LEN %d\n", boardp->id, scp->cmd_len,
-			ASC_MAX_CDB_LEN);
-		scp->result = HOST_BYTE(DID_ERROR);
-		return ASC_ERROR;
-	}
 	asc_scsi_q.cdbptr = &scp->cmnd[0];
 	asc_scsi_q.q2.cdb_len = scp->cmd_len;
 	asc_scsi_q.q1.target_id = ASC_TID_TO_TARGET_ID(scp->device->id);
@@ -4029,18 +4019,7 @@ adv_build_req(asc_board_t *boardp, struct scsi_cmnd *scp,
 	 * Build the ADV_SCSI_REQ_Q request.
 	 */
 
-	/*
-	 * Set CDB length and copy it to the request structure.
-	 * For wide  boards a CDB length maximum of 16 bytes
-	 * is supported.
-	 */
-	if (scp->cmd_len > ADV_MAX_CDB_LEN) {
-		ASC_PRINT3
-		    ("adv_build_req: board %d: cmd_len %d > ADV_MAX_CDB_LEN  %d\n",
-		     boardp->id, scp->cmd_len, ADV_MAX_CDB_LEN);
-		scp->result = HOST_BYTE(DID_ERROR);
-		return ASC_ERROR;
-	}
+	/* Set CDB length and copy it to the request structure.  */
 	scsiqp->cdb_len = scp->cmd_len;
 	/* Copy first 12 CDB bytes to cdb[]. */
 	for (i = 0; i < scp->cmd_len && i < 12; i++) {
@@ -14834,6 +14813,7 @@ advansys_board_found(int iop, struct device *dev, int bus_type)
 	if (ASC_NARROW_BOARD(boardp)) {
 		shost->max_id = ASC_MAX_TID + 1;
 		shost->max_lun = ASC_MAX_LUN + 1;
+		shost->max_cmd_len = ASC_MAX_CDB_LEN;
 
 		shost->io_port = asc_dvc_varp->iop_base;
 		boardp->asc_n_io_port = ASC_IOADR_GAP;
@@ -14844,6 +14824,7 @@ advansys_board_found(int iop, struct device *dev, int bus_type)
 	} else {
 		shost->max_id = ADV_MAX_TID + 1;
 		shost->max_lun = ADV_MAX_LUN + 1;
+		shost->max_cmd_len = ADV_MAX_CDB_LEN;
 
 		/*
 		 * Save the I/O Port address and length even though
-- 
1.5.2.4

