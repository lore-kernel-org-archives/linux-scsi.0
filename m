From: Matthew Wilcox <matthew@wil.cx>
Subject: [PATCH 18/21] advansys: convert to use the data buffer accessors
Date: Tue,  2 Oct 2007 21:55:39 -0400
Message-ID: <11913765432414-git-send-email-matthew@wil.cx>
References: <11913765421743-git-send-email-matthew@wil.cx>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.tor.primus.ca ([216.254.136.21]:57921 "EHLO
	mail-08.primus.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754454AbXJCBzt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Oct 2007 21:55:49 -0400
In-Reply-To: <11913765421743-git-send-email-matthew@wil.cx>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Matthew Wilcox <matthew@wil.cx>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Matthew Wilcox <willy@linux.intel.com>

- remove the unnecessary map_single path.
- convert to use the new accessors for the sg lists and the parameters.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

- convert the statistics to not distinguish between single and sg xfers
- replace ASC_CEILING with DIV_ROUND_UP
- remove an obsolete comment

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
---
 drivers/scsi/advansys.c |  236 ++++++++++------------------------------------
 1 files changed, 52 insertions(+), 184 deletions(-)

diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
index 4cc60e4..7d334f8 100644
--- a/drivers/scsi/advansys.c
+++ b/drivers/scsi/advansys.c
@@ -2223,8 +2223,6 @@ do { \
 	(((struct asc_board *) shost_priv(shost))->asc_stats.counter += (count))
 #endif /* ADVANSYS_STATS */
 
-#define ASC_CEILING(val, unit) (((val) + ((unit) - 1))/(unit))
-
 /* If the result wraps when calculating tenths, return 0. */
 #define ASC_TENTHS(num, den) \
     (((10 * ((num)/(den))) > (((num) * 10)/(den))) ? \
@@ -2356,11 +2354,9 @@ struct asc_stats {
 	ADV_DCNT exe_error;	/* # ASC_ERROR returns. */
 	ADV_DCNT exe_unknown;	/* # unknown returns. */
 	/* Data Transfer Statistics */
-	ADV_DCNT cont_cnt;	/* # non-scatter-gather I/O requests received */
-	ADV_DCNT cont_xfer;	/* # contiguous transfer 512-bytes */
-	ADV_DCNT sg_cnt;	/* # scatter-gather I/O requests received */
-	ADV_DCNT sg_elem;	/* # scatter-gather elements */
-	ADV_DCNT sg_xfer;	/* # scatter-gather transfer 512-bytes */
+	ADV_DCNT xfer_cnt;	/* # I/O requests received */
+	ADV_DCNT xfer_elem;	/* # scatter-gather elements */
+	ADV_DCNT xfer_sect;	/* # 512-byte blocks */
 };
 #endif /* ADVANSYS_STATS */
 
@@ -4057,57 +4053,32 @@ static int asc_prt_board_stats(struct Scsi_Host *shost, char *cp, int cplen)
 	/*
 	 * Display data transfer statistics.
 	 */
-	if (s->cont_cnt > 0) {
-		len = asc_prt_line(cp, leftlen, " cont_cnt %lu, ", s->cont_cnt);
-		ASC_PRT_NEXT();
-
-		len = asc_prt_line(cp, leftlen, "cont_xfer %lu.%01lu kb ",
-				   s->cont_xfer / 2,
-				   ASC_TENTHS(s->cont_xfer, 2));
-		ASC_PRT_NEXT();
-
-		/* Contiguous transfer average size */
-		len = asc_prt_line(cp, leftlen, "avg_xfer %lu.%01lu kb\n",
-				   (s->cont_xfer / 2) / s->cont_cnt,
-				   ASC_TENTHS((s->cont_xfer / 2), s->cont_cnt));
-		ASC_PRT_NEXT();
-	}
-
-	if (s->sg_cnt > 0) {
-
-		len = asc_prt_line(cp, leftlen, " sg_cnt %lu, sg_elem %lu, ",
-				   s->sg_cnt, s->sg_elem);
+	if (s->xfer_cnt > 0) {
+		len = asc_prt_line(cp, leftlen, " xfer_cnt %lu, xfer_elem %lu, ",
+				   s->xfer_cnt, s->xfer_elem);
 		ASC_PRT_NEXT();
 
-		len = asc_prt_line(cp, leftlen, "sg_xfer %lu.%01lu kb\n",
-				   s->sg_xfer / 2, ASC_TENTHS(s->sg_xfer, 2));
+		len = asc_prt_line(cp, leftlen, "xfer_bytes %lu.%01lu kb\n",
+				   s->xfer_sect / 2, ASC_TENTHS(s->xfer_sect, 2));
 		ASC_PRT_NEXT();
 
 		/* Scatter gather transfer statistics */
 		len = asc_prt_line(cp, leftlen, " avg_num_elem %lu.%01lu, ",
-				   s->sg_elem / s->sg_cnt,
-				   ASC_TENTHS(s->sg_elem, s->sg_cnt));
+				   s->xfer_elem / s->xfer_cnt,
+				   ASC_TENTHS(s->xfer_elem, s->xfer_cnt));
 		ASC_PRT_NEXT();
 
 		len = asc_prt_line(cp, leftlen, "avg_elem_size %lu.%01lu kb, ",
-				   (s->sg_xfer / 2) / s->sg_elem,
-				   ASC_TENTHS((s->sg_xfer / 2), s->sg_elem));
+				   (s->xfer_sect / 2) / s->xfer_elem,
+				   ASC_TENTHS((s->xfer_sect / 2), s->xfer_elem));
 		ASC_PRT_NEXT();
 
 		len = asc_prt_line(cp, leftlen, "avg_xfer_size %lu.%01lu kb\n",
-				   (s->sg_xfer / 2) / s->sg_cnt,
-				   ASC_TENTHS((s->sg_xfer / 2), s->sg_cnt));
+				   (s->xfer_sect / 2) / s->xfer_cnt,
+				   ASC_TENTHS((s->xfer_sect / 2), s->xfer_cnt));
 		ASC_PRT_NEXT();
 	}
 
-	/*
-	 * Display request queuing statistics.
-	 */
-	len = asc_prt_line(cp, leftlen,
-			   " Active and Waiting Request Queues (Time Unit: %d HZ):\n",
-			   HZ);
-	ASC_PRT_NEXT();
-
 	return totlen;
 }
 #endif /* ADVANSYS_STATS */
@@ -4301,18 +4272,8 @@ advansys_proc_info(struct Scsi_Host *shost, char *buffer, char **start,
 
 static void asc_scsi_done(struct scsi_cmnd *scp)
 {
-	struct asc_board *boardp = shost_priv(scp->device->host);
-
-	if (scp->use_sg)
-		dma_unmap_sg(boardp->dev,
-			     (struct scatterlist *)scp->request_buffer,
-			     scp->use_sg, scp->sc_data_direction);
-	else if (scp->request_bufflen)
-		dma_unmap_single(boardp->dev, scp->SCp.dma_handle,
-				 scp->request_bufflen, scp->sc_data_direction);
-
+	scsi_dma_unmap(scp);
 	ASC_STATS(scp->device->host, done);
-
 	scp->scsi_done(scp);
 }
 
@@ -8210,11 +8171,11 @@ static void adv_isr_callback(ADV_DVC_VAR *adv_dvc_varp, ADV_SCSI_REQ_Q *scsiqp)
 		 * then return the number of underrun bytes.
 		 */
 		resid_cnt = le32_to_cpu(scsiqp->data_cnt);
-		if (scp->request_bufflen != 0 && resid_cnt != 0 &&
-		    resid_cnt <= scp->request_bufflen) {
+		if (scsi_bufflen(scp) != 0 && resid_cnt != 0 &&
+		    resid_cnt <= scsi_bufflen(scp)) {
 			ASC_DBG(1, "underrun condition %lu bytes\n",
 				 (ulong)resid_cnt);
-			scp->resid = resid_cnt;
+			scsi_set_resid(scp, resid_cnt);
 		}
 		break;
 
@@ -9148,11 +9109,11 @@ static void asc_isr_callback(ASC_DVC_VAR *asc_dvc_varp, ASC_QDONE_INFO *qdonep)
 		 * If there was no error and an underrun condition, then
 		 * return the number of underrun bytes.
 		 */
-		if (scp->request_bufflen != 0 && qdonep->remain_bytes != 0 &&
-		    qdonep->remain_bytes <= scp->request_bufflen) {
+		if (scsi_bufflen(scp) != 0 && qdonep->remain_bytes != 0 &&
+		    qdonep->remain_bytes <= scsi_bufflen(scp)) {
 			ASC_DBG(1, "underrun condition %u bytes\n",
 				 (unsigned)qdonep->remain_bytes);
-			scp->resid = qdonep->remain_bytes;
+			scsi_set_resid(scp, qdonep->remain_bytes);
 		}
 		break;
 
@@ -9877,6 +9838,8 @@ static int advansys_slave_configure(struct scsi_device *sdev)
 static int asc_build_req(struct asc_board *boardp, struct scsi_cmnd *scp,
 			struct asc_scsi_q *asc_scsi_q)
 {
+	int use_sg;
+
 	memset(asc_scsi_q, 0, sizeof(*asc_scsi_q));
 
 	/*
@@ -9915,55 +9878,26 @@ static int asc_build_req(struct asc_board *boardp, struct scsi_cmnd *scp,
 		asc_scsi_q->q2.tag_code = MSG_SIMPLE_TAG;
 	}
 
-	/*
-	 * Build ASC_SCSI_Q for a contiguous buffer or a scatter-gather
-	 * buffer command.
-	 */
-	if (scp->use_sg == 0) {
-		/*
-		 * CDB request of single contiguous buffer.
-		 */
-		ASC_STATS(scp->device->host, cont_cnt);
-		scp->SCp.dma_handle = scp->request_bufflen ?
-		    dma_map_single(boardp->dev, scp->request_buffer,
-				   scp->request_bufflen,
-				   scp->sc_data_direction) : 0;
-		asc_scsi_q->q1.data_addr = cpu_to_le32(scp->SCp.dma_handle);
-		asc_scsi_q->q1.data_cnt = cpu_to_le32(scp->request_bufflen);
-		ASC_STATS_ADD(scp->device->host, cont_xfer,
-			      ASC_CEILING(scp->request_bufflen, 512));
-		asc_scsi_q->q1.sg_queue_cnt = 0;
-		asc_scsi_q->sg_head = NULL;
-	} else {
-		/*
-		 * CDB scatter-gather request list.
-		 */
+	/* Build ASC_SCSI_Q */
+	use_sg = scsi_dma_map(scp);
+	if (use_sg != 0) {
 		int sgcnt;
-		int use_sg;
 		struct scatterlist *slp;
 		struct asc_sg_head *asc_sg_head;
 
-		slp = (struct scatterlist *)scp->request_buffer;
-		use_sg = dma_map_sg(boardp->dev, slp, scp->use_sg,
-				    scp->sc_data_direction);
-
 		if (use_sg > scp->device->host->sg_tablesize) {
 			scmd_printk(KERN_ERR, scp, "use_sg %d > "
 				"sg_tablesize %d\n", use_sg,
 				scp->device->host->sg_tablesize);
-			dma_unmap_sg(boardp->dev, slp, scp->use_sg,
-				     scp->sc_data_direction);
+			scsi_dma_unmap(scp);
 			scp->result = HOST_BYTE(DID_ERROR);
 			return ASC_ERROR;
 		}
 
-		ASC_STATS(scp->device->host, sg_cnt);
-
 		asc_sg_head = kzalloc(sizeof(asc_scsi_q->sg_head) +
 			use_sg * sizeof(struct asc_sg_list), GFP_ATOMIC);
 		if (!asc_sg_head) {
-			dma_unmap_sg(boardp->dev, slp, scp->use_sg,
-				     scp->sc_data_direction);
+			scsi_dma_unmap(scp);
 			scp->result = HOST_BYTE(DID_SOFT_ERROR);
 			return ASC_ERROR;
 		}
@@ -9974,22 +9908,24 @@ static int asc_build_req(struct asc_board *boardp, struct scsi_cmnd *scp,
 		asc_scsi_q->q1.data_addr = 0;
 		/* This is a byte value, otherwise it would need to be swapped. */
 		asc_sg_head->entry_cnt = asc_scsi_q->q1.sg_queue_cnt = use_sg;
-		ASC_STATS_ADD(scp->device->host, sg_elem,
+		ASC_STATS_ADD(scp->device->host, xfer_elem,
 			      asc_sg_head->entry_cnt);
 
 		/*
 		 * Convert scatter-gather list into ASC_SG_HEAD list.
 		 */
-		for (sgcnt = 0; sgcnt < use_sg; sgcnt++, slp++) {
+		scsi_for_each_sg(scp, slp, use_sg, sgcnt) {
 			asc_sg_head->sg_list[sgcnt].addr =
 			    cpu_to_le32(sg_dma_address(slp));
 			asc_sg_head->sg_list[sgcnt].bytes =
 			    cpu_to_le32(sg_dma_len(slp));
-			ASC_STATS_ADD(scp->device->host, sg_xfer,
-				      ASC_CEILING(sg_dma_len(slp), 512));
+			ASC_STATS_ADD(scp->device->host, xfer_sect,
+				      DIV_ROUND_UP(sg_dma_len(slp), 512));
 		}
 	}
 
+	ASC_STATS(scp->device->host, xfer_cnt);
+
 	ASC_DBG_PRT_ASC_SCSI_Q(2, asc_scsi_q);
 	ASC_DBG_PRT_CDB(1, scp->cmnd, scp->cmd_len);
 
@@ -10021,7 +9957,7 @@ adv_get_sglist(struct asc_board *boardp, adv_req_t *reqp, struct scsi_cmnd *scp,
 	int i;
 
 	scsiqp = (ADV_SCSI_REQ_Q *)ADV_32BALIGN(&reqp->scsi_req_q);
-	slp = (struct scatterlist *)scp->request_buffer;
+	slp = scsi_sglist(scp);
 	sg_elem_cnt = use_sg;
 	prev_sg_block = NULL;
 	reqp->sgblkp = NULL;
@@ -10093,8 +10029,8 @@ adv_get_sglist(struct asc_board *boardp, adv_req_t *reqp, struct scsi_cmnd *scp,
 					cpu_to_le32(sg_dma_address(slp));
 			sg_block->sg_list[i].sg_count =
 					cpu_to_le32(sg_dma_len(slp));
-			ASC_STATS_ADD(scp->device->host, sg_xfer,
-				      ASC_CEILING(sg_dma_len(slp), 512));
+			ASC_STATS_ADD(scp->device->host, xfer_sect,
+				      DIV_ROUND_UP(sg_dma_len(slp), 512));
 
 			if (--sg_elem_cnt == 0) {	/* Last ADV_SG_BLOCK and scatter-gather entry. */
 				sg_block->sg_cnt = i + 1;
@@ -10126,6 +10062,7 @@ adv_build_req(struct asc_board *boardp, struct scsi_cmnd *scp,
 	ADV_SCSI_REQ_Q *scsiqp;
 	int i;
 	int ret;
+	int use_sg;
 
 	/*
 	 * Allocate an adv_req_t structure from the board to execute
@@ -10182,54 +10119,24 @@ adv_build_req(struct asc_board *boardp, struct scsi_cmnd *scp,
 	scsiqp->sense_addr = cpu_to_le32(virt_to_bus(&scp->sense_buffer[0]));
 	scsiqp->sense_len = sizeof(scp->sense_buffer);
 
-	/*
-	 * Build ADV_SCSI_REQ_Q for a contiguous buffer or a scatter-gather
-	 * buffer command.
-	 */
+	/* Build ADV_SCSI_REQ_Q */
 
-	scsiqp->data_cnt = cpu_to_le32(scp->request_bufflen);
-	scsiqp->vdata_addr = scp->request_buffer;
-	scsiqp->data_addr = cpu_to_le32(virt_to_bus(scp->request_buffer));
-
-	if (scp->use_sg == 0) {
-		/*
-		 * CDB request of single contiguous buffer.
-		 */
+	use_sg = scsi_dma_map(scp);
+	if (use_sg == 0) {
+		/* Zero-length transfer */
 		reqp->sgblkp = NULL;
-		scsiqp->data_cnt = cpu_to_le32(scp->request_bufflen);
-		if (scp->request_bufflen) {
-			scsiqp->vdata_addr = scp->request_buffer;
-			scp->SCp.dma_handle =
-			    dma_map_single(boardp->dev, scp->request_buffer,
-					   scp->request_bufflen,
-					   scp->sc_data_direction);
-		} else {
-			scsiqp->vdata_addr = NULL;
-			scp->SCp.dma_handle = 0;
-		}
-		scsiqp->data_addr = cpu_to_le32(scp->SCp.dma_handle);
+		scsiqp->data_cnt = 0;
+		scsiqp->vdata_addr = NULL;
+
+		scsiqp->data_addr = 0;
 		scsiqp->sg_list_ptr = NULL;
 		scsiqp->sg_real_addr = 0;
-		ASC_STATS(scp->device->host, cont_cnt);
-		ASC_STATS_ADD(scp->device->host, cont_xfer,
-			      ASC_CEILING(scp->request_bufflen, 512));
 	} else {
-		/*
-		 * CDB scatter-gather request list.
-		 */
-		struct scatterlist *slp;
-		int use_sg;
-
-		slp = (struct scatterlist *)scp->request_buffer;
-		use_sg = dma_map_sg(boardp->dev, slp, scp->use_sg,
-				    scp->sc_data_direction);
-
 		if (use_sg > ADV_MAX_SG_LIST) {
 			scmd_printk(KERN_ERR, scp, "use_sg %d > "
 				   "ADV_MAX_SG_LIST %d\n", use_sg,
 				   scp->device->host->sg_tablesize);
-			dma_unmap_sg(boardp->dev, slp, scp->use_sg,
-				     scp->sc_data_direction);
+			scsi_dma_unmap(scp);
 			scp->result = HOST_BYTE(DID_ERROR);
 
 			/*
@@ -10242,6 +10149,8 @@ adv_build_req(struct asc_board *boardp, struct scsi_cmnd *scp,
 			return ASC_ERROR;
 		}
 
+		scsiqp->data_cnt = cpu_to_le32(scsi_bufflen(scp));
+
 		ret = adv_get_sglist(boardp, reqp, scp, use_sg);
 		if (ret != ADV_SUCCESS) {
 			/*
@@ -10254,10 +10163,11 @@ adv_build_req(struct asc_board *boardp, struct scsi_cmnd *scp,
 			return ret;
 		}
 
-		ASC_STATS(scp->device->host, sg_cnt);
-		ASC_STATS_ADD(scp->device->host, sg_elem, use_sg);
+		ASC_STATS_ADD(scp->device->host, xfer_elem, use_sg);
 	}
 
+	ASC_STATS(scp->device->host, xfer_cnt);
+
 	ASC_DBG_PRT_ADV_SCSI_REQ_Q(2, scsiqp);
 	ASC_DBG_PRT_CDB(1, scp->cmnd, scp->cmd_len);
 
@@ -10955,48 +10865,6 @@ static int AdvExeScsiQueue(ADV_DVC_VAR *asc_dvc, ADV_SCSI_REQ_Q *scsiq)
 
 /*
  * Execute a single 'Scsi_Cmnd'.
- *
- * The function 'done' is called when the request has been completed.
- *
- * Scsi_Cmnd:
- *
- *  host - board controlling device
- *  device - device to send command
- *  target - target of device
- *  lun - lun of device
- *  cmd_len - length of SCSI CDB
- *  cmnd - buffer for SCSI 8, 10, or 12 byte CDB
- *  use_sg - if non-zero indicates scatter-gather request with use_sg elements
- *
- *  if (use_sg == 0) {
- *    request_buffer - buffer address for request
- *    request_bufflen - length of request buffer
- *  } else {
- *    request_buffer - pointer to scatterlist structure
- *  }
- *
- *  sense_buffer - sense command buffer
- *
- *  result (4 bytes of an int):
- *    Byte Meaning
- *    0 SCSI Status Byte Code
- *    1 SCSI One Byte Message Code
- *    2 Host Error Code
- *    3 Mid-Level Error Code
- *
- *  host driver fields:
- *    SCp - Scsi_Pointer used for command processing status
- *    scsi_done - used to save caller's done function
- *    host_scribble - used for pointer to another struct scsi_cmnd
- *
- * If this function returns ASC_NOERROR the request will be completed
- * from the interrupt handler.
- *
- * If this function returns ASC_ERROR the host error code has been set,
- * and the called must call asc_scsi_done.
- *
- * If ASC_BUSY is returned the request will be returned to the midlayer
- * and re-tried later.
  */
 static int asc_execute_scsi_cmnd(struct scsi_cmnd *scp)
 {
-- 
1.5.3.1

