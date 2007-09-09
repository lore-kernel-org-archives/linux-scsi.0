From: Matthew Wilcox <matthew@wil.cx>
Subject: [PATCH 19/22] advansys: Fix simultaneous calls to ->queuecommand
Date: Sun,  9 Sep 2007 08:56:44 -0600
Message-ID: <11893498071380-git-send-email-matthew@wil.cx>
References: <20070909145358.GG6809@parisc-linux.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.tor.primus.ca ([216.254.136.21]:43200 "EHLO
	mail-05.primus.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757273AbXIIO4u (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 9 Sep 2007 10:56:50 -0400
In-Reply-To: <20070909145358.GG6809@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Matthew Wilcox <matthew@wil.cx>

The narrow board used two global structures to set up a command;
unfortunately they weren't locked, so with two boards in the machine,
one call to queuecommand could corrupt the data being used by the other
call to queuecommand.

Fix this by allocating asc_scsi_q on the stack (64 bytes) and using kmalloc
for the asc_sg_head (2k)

Signed-off-by: Matthew Wilcox <matthew@wil.cx>
---
 drivers/scsi/advansys.c |   88 +++++++++++++++++++++--------------------------
 1 files changed, 39 insertions(+), 49 deletions(-)

diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
index 36c557f..3fbeea7 100644
--- a/drivers/scsi/advansys.c
+++ b/drivers/scsi/advansys.c
@@ -380,7 +380,7 @@ typedef struct asc_sg_head {
 	ushort queue_cnt;
 	ushort entry_to_copy;
 	ushort res;
-	ASC_SG_LIST sg_list[ASC_MAX_SG_LIST];
+	ASC_SG_LIST sg_list[0];
 } ASC_SG_HEAD;
 
 typedef struct asc_scsi_q {
@@ -2559,12 +2559,6 @@ static int asc_board_count;
 /* Overrun buffer used by all narrow boards. */
 static uchar overrun_buf[ASC_OVERRUN_BSIZE] = { 0 };
 
-/*
- * Global structures required to issue a command.
- */
-static ASC_SCSI_Q asc_scsi_q = { {0} };
-static ASC_SG_HEAD asc_sg_head = { 0 };
-
 #ifdef ADVANSYS_DEBUG
 static int asc_dbglvl = 3;
 
@@ -10192,39 +10186,28 @@ static int advansys_slave_configure(struct scsi_device *sdev)
 	return 0;
 }
 
-/*
- * Build a request structure for the Asc Library (Narrow Board).
- *
- * The global structures 'asc_scsi_q' and 'asc_sg_head' are
- * used to build the request.
- *
- * If an error occurs, then return ASC_ERROR.
- */
-static int asc_build_req(asc_board_t *boardp, struct scsi_cmnd *scp)
+static int asc_build_req(asc_board_t *boardp, struct scsi_cmnd *scp,
+			struct asc_scsi_q *asc_scsi_q)
 {
-	/*
-	 * Mutually exclusive access is required to 'asc_scsi_q' and
-	 * 'asc_sg_head' until after the request is started.
-	 */
-	memset(&asc_scsi_q, 0, sizeof(ASC_SCSI_Q));
+	memset(asc_scsi_q, 0, sizeof(*asc_scsi_q));
 
 	/*
 	 * Point the ASC_SCSI_Q to the 'struct scsi_cmnd'.
 	 */
-	asc_scsi_q.q2.srb_ptr = ASC_VADDR_TO_U32(scp);
+	asc_scsi_q->q2.srb_ptr = ASC_VADDR_TO_U32(scp);
 
 	/*
 	 * Build the ASC_SCSI_Q request.
 	 */
-	asc_scsi_q.cdbptr = &scp->cmnd[0];
-	asc_scsi_q.q2.cdb_len = scp->cmd_len;
-	asc_scsi_q.q1.target_id = ASC_TID_TO_TARGET_ID(scp->device->id);
-	asc_scsi_q.q1.target_lun = scp->device->lun;
-	asc_scsi_q.q2.target_ix =
+	asc_scsi_q->cdbptr = &scp->cmnd[0];
+	asc_scsi_q->q2.cdb_len = scp->cmd_len;
+	asc_scsi_q->q1.target_id = ASC_TID_TO_TARGET_ID(scp->device->id);
+	asc_scsi_q->q1.target_lun = scp->device->lun;
+	asc_scsi_q->q2.target_ix =
 	    ASC_TIDLUN_TO_IX(scp->device->id, scp->device->lun);
-	asc_scsi_q.q1.sense_addr =
+	asc_scsi_q->q1.sense_addr =
 	    cpu_to_le32(virt_to_bus(&scp->sense_buffer[0]));
-	asc_scsi_q.q1.sense_len = sizeof(scp->sense_buffer);
+	asc_scsi_q->q1.sense_len = sizeof(scp->sense_buffer);
 
 	/*
 	 * If there are any outstanding requests for the current target,
@@ -10239,9 +10222,9 @@ static int asc_build_req(asc_board_t *boardp, struct scsi_cmnd *scp)
 	 */
 	if ((boardp->dvc_var.asc_dvc_var.cur_dvc_qng[scp->device->id] > 0) &&
 	    (boardp->reqcnt[scp->device->id] % 255) == 0) {
-		asc_scsi_q.q2.tag_code = MSG_ORDERED_TAG;
+		asc_scsi_q->q2.tag_code = MSG_ORDERED_TAG;
 	} else {
-		asc_scsi_q.q2.tag_code = MSG_SIMPLE_TAG;
+		asc_scsi_q->q2.tag_code = MSG_SIMPLE_TAG;
 	}
 
 	/*
@@ -10257,12 +10240,12 @@ static int asc_build_req(asc_board_t *boardp, struct scsi_cmnd *scp)
 		    dma_map_single(boardp->dev, scp->request_buffer,
 				   scp->request_bufflen,
 				   scp->sc_data_direction) : 0;
-		asc_scsi_q.q1.data_addr = cpu_to_le32(scp->SCp.dma_handle);
-		asc_scsi_q.q1.data_cnt = cpu_to_le32(scp->request_bufflen);
+		asc_scsi_q->q1.data_addr = cpu_to_le32(scp->SCp.dma_handle);
+		asc_scsi_q->q1.data_cnt = cpu_to_le32(scp->request_bufflen);
 		ASC_STATS_ADD(scp->device->host, cont_xfer,
 			      ASC_CEILING(scp->request_bufflen, 512));
-		asc_scsi_q.q1.sg_queue_cnt = 0;
-		asc_scsi_q.sg_head = NULL;
+		asc_scsi_q->q1.sg_queue_cnt = 0;
+		asc_scsi_q->sg_head = NULL;
 	} else {
 		/*
 		 * CDB scatter-gather request list.
@@ -10270,6 +10253,7 @@ static int asc_build_req(asc_board_t *boardp, struct scsi_cmnd *scp)
 		int sgcnt;
 		int use_sg;
 		struct scatterlist *slp;
+		struct asc_sg_head *asc_sg_head;
 
 		slp = (struct scatterlist *)scp->request_buffer;
 		use_sg = dma_map_sg(boardp->dev, slp, scp->use_sg,
@@ -10287,28 +10271,31 @@ static int asc_build_req(asc_board_t *boardp, struct scsi_cmnd *scp)
 
 		ASC_STATS(scp->device->host, sg_cnt);
 
-		/*
-		 * Use global ASC_SG_HEAD structure and set the ASC_SCSI_Q
-		 * structure to point to it.
-		 */
-		memset(&asc_sg_head, 0, sizeof(ASC_SG_HEAD));
+		asc_sg_head = kzalloc(sizeof(asc_scsi_q->sg_head) +
+			use_sg * sizeof(struct asc_sg_list), GFP_ATOMIC);
+		if (!asc_sg_head) {
+			dma_unmap_sg(boardp->dev, slp, scp->use_sg,
+				     scp->sc_data_direction);
+			scp->result = HOST_BYTE(DID_SOFT_ERROR);
+			return ASC_ERROR;
+		}
 
-		asc_scsi_q.q1.cntl |= QC_SG_HEAD;
-		asc_scsi_q.sg_head = &asc_sg_head;
-		asc_scsi_q.q1.data_cnt = 0;
-		asc_scsi_q.q1.data_addr = 0;
+		asc_scsi_q->q1.cntl |= QC_SG_HEAD;
+		asc_scsi_q->sg_head = asc_sg_head;
+		asc_scsi_q->q1.data_cnt = 0;
+		asc_scsi_q->q1.data_addr = 0;
 		/* This is a byte value, otherwise it would need to be swapped. */
-		asc_sg_head.entry_cnt = asc_scsi_q.q1.sg_queue_cnt = use_sg;
+		asc_sg_head->entry_cnt = asc_scsi_q->q1.sg_queue_cnt = use_sg;
 		ASC_STATS_ADD(scp->device->host, sg_elem,
-			      asc_sg_head.entry_cnt);
+			      asc_sg_head->entry_cnt);
 
 		/*
 		 * Convert scatter-gather list into ASC_SG_HEAD list.
 		 */
 		for (sgcnt = 0; sgcnt < use_sg; sgcnt++, slp++) {
-			asc_sg_head.sg_list[sgcnt].addr =
+			asc_sg_head->sg_list[sgcnt].addr =
 			    cpu_to_le32(sg_dma_address(slp));
-			asc_sg_head.sg_list[sgcnt].bytes =
+			asc_sg_head->sg_list[sgcnt].bytes =
 			    cpu_to_le32(sg_dma_len(slp));
 			ASC_STATS_ADD(scp->device->host, sg_xfer,
 				      ASC_CEILING(sg_dma_len(slp), 512));
@@ -11338,14 +11325,17 @@ static int asc_execute_scsi_cmnd(struct scsi_cmnd *scp)
 
 	if (ASC_NARROW_BOARD(boardp)) {
 		ASC_DVC_VAR *asc_dvc = &boardp->dvc_var.asc_dvc_var;
+		struct asc_scsi_q asc_scsi_q;
 
 		/* asc_build_req() can not return ASC_BUSY. */
-		if (asc_build_req(boardp, scp) == ASC_ERROR) {
+		ret = asc_build_req(boardp, scp, &asc_scsi_q);
+		if (ret == ASC_ERROR) {
 			ASC_STATS(scp->device->host, build_error);
 			return ASC_ERROR;
 		}
 
 		ret = AscExeScsiQueue(asc_dvc, &asc_scsi_q);
+		kfree(asc_scsi_q.sg_head);
 		err_code = asc_dvc->err_code;
 	} else {
 		ADV_DVC_VAR *adv_dvc = &boardp->dvc_var.adv_dvc_var;
-- 
1.5.2.4

