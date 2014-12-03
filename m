From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 02/12] advansys: use shared host tag map for command lookup
Date: Wed,  3 Dec 2014 12:44:55 +0100
Message-ID: <1417607105-85455-3-git-send-email-hare@suse.de>
References: <1417607105-85455-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:55200 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752986AbaLCLpN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 3 Dec 2014 06:45:13 -0500
In-Reply-To: <1417607105-85455-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@lst.de>, Matthew Wilcox <matthew@wil.cx>, Doug Gilbert <dgilbert@interlog.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

Convert to use a shared host tag map for command lookup. This
saves us having an internal structure and avoid the command
pointer abuse.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/advansys.c | 218 ++++++++++++++++++------------------------------
 1 file changed, 79 insertions(+), 139 deletions(-)

diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
index d9b27ca..6af2a52 100644
--- a/drivers/scsi/advansys.c
+++ b/drivers/scsi/advansys.c
@@ -315,7 +315,7 @@ typedef struct asc_scsiq_1 {
 } ASC_SCSIQ_1;
 
 typedef struct asc_scsiq_2 {
-	ASC_VADDR srb_ptr;
+	__le32 srb_tag;
 	uchar target_ix;
 	uchar flag;
 	uchar cdb_len;
@@ -592,8 +592,6 @@ typedef struct asc_dvc_var {
 	uchar min_sdtr_index;
 	uchar max_sdtr_index;
 	struct asc_board *drv_ptr;
-	int ptr_map_count;
-	void **ptr_map;
 	ASC_DCNT uc_break;
 } ASC_DVC_VAR;
 
@@ -1866,7 +1864,7 @@ typedef struct adv_scsi_req_q {
 	 * End of microcode structure - 60 bytes. The rest of the structure
 	 * is used by the Adv Library and ignored by the microcode.
 	 */
-	ADV_VADDR srb_ptr;
+	__le32 srb_tag;
 	ADV_SG_BLOCK *sg_list_ptr;	/* SG list virtual address. */
 	char *vdata_addr;	/* Data buffer virtual address. */
 	uchar a_flag;
@@ -1877,7 +1875,7 @@ typedef struct adv_scsi_req_q {
  * The following two structures are used to process Wide Board requests.
  *
  * The ADV_SCSI_REQ_Q structure in adv_req_t is passed to the Adv Library
- * and microcode with the ADV_SCSI_REQ_Q field 'srb_ptr' pointing to the
+ * and microcode with the ADV_SCSI_REQ_Q field 'srb_tag' pointing to the
  * adv_req_t. The adv_req_t structure 'cmndp' field in turn points to the
  * Mid-Level SCSI request structure.
  *
@@ -1942,7 +1940,6 @@ typedef struct adv_dvc_var {
 	ADV_CARR_T *icq_sp;	/* Initiator command queue stopper pointer. */
 	ADV_CARR_T *irq_sp;	/* Initiator response queue stopper pointer. */
 	ushort carr_pending_cnt;	/* Count of pending carriers. */
-	struct adv_req *orig_reqp;	/* adv_req_t memory block. */
 	/*
 	 * Note: The following fields will not be used after initialization. The
 	 * driver may discard the buffer after initialization is done.
@@ -2068,8 +2065,8 @@ do { \
     AdvReadByteRegister((iop_base), IOPB_CHIP_TYPE_REV)
 
 /*
- * Abort an SRB in the chip's RISC Memory. The 'srb_ptr' argument must
- * match the ASC_SCSI_REQ_Q 'srb_ptr' field.
+ * Abort an SRB in the chip's RISC Memory. The 'srb_tag' argument must
+ * match the ASC_SCSI_REQ_Q 'srb_tag' field.
  *
  * If the request has not yet been sent to the device it will simply be
  * aborted from RISC memory. If the request is disconnected it will be
@@ -2345,6 +2342,7 @@ struct asc_stats {
  */
 struct asc_board {
 	struct device *dev;
+	struct Scsi_Host *shost;
 	uint flags;		/* Board flags */
 	unsigned int irq;
 	union {
@@ -2600,8 +2598,8 @@ static void asc_prt_asc_scsi_q(ASC_SCSI_Q *q)
 	printk("ASC_SCSI_Q at addr 0x%lx\n", (ulong)q);
 
 	printk
-	    (" target_ix 0x%x, target_lun %u, srb_ptr 0x%lx, tag_code 0x%x,\n",
-	     q->q2.target_ix, q->q1.target_lun, (ulong)q->q2.srb_ptr,
+	    (" target_ix 0x%x, target_lun %u, srb_tag 0x%x, tag_code 0x%x,\n",
+	     q->q2.target_ix, q->q1.target_lun, q->q2.srb_tag,
 	     q->q2.tag_code);
 
 	printk
@@ -2634,8 +2632,8 @@ static void asc_prt_asc_scsi_q(ASC_SCSI_Q *q)
 static void asc_prt_asc_qdone_info(ASC_QDONE_INFO *q)
 {
 	printk("ASC_QDONE_INFO at addr 0x%lx\n", (ulong)q);
-	printk(" srb_ptr 0x%lx, target_ix %u, cdb_len %u, tag_code %u,\n",
-	       (ulong)q->d2.srb_ptr, q->d2.target_ix, q->d2.cdb_len,
+	printk(" srb_tag 0x%x, target_ix %u, cdb_len %u, tag_code %u,\n",
+	       q->d2.srb_tag, q->d2.target_ix, q->d2.cdb_len,
 	       q->d2.tag_code);
 	printk
 	    (" done_stat 0x%x, host_stat 0x%x, scsi_stat 0x%x, scsi_msg 0x%x\n",
@@ -2677,8 +2675,8 @@ static void asc_prt_adv_scsi_req_q(ADV_SCSI_REQ_Q *q)
 
 	printk("ADV_SCSI_REQ_Q at addr 0x%lx\n", (ulong)q);
 
-	printk("  target_id %u, target_lun %u, srb_ptr 0x%lx, a_flag 0x%x\n",
-	       q->target_id, q->target_lun, (ulong)q->srb_ptr, q->a_flag);
+	printk("  target_id %u, target_lun %u, srb_tag 0x%x, a_flag 0x%x\n",
+	       q->target_id, q->target_lun, q->srb_tag, q->a_flag);
 
 	printk("  cntl 0x%x, data_addr 0x%lx, vdata_addr 0x%lx\n",
 	       q->cntl, (ulong)le32_to_cpu(q->data_addr), (ulong)q->vdata_addr);
@@ -2722,59 +2720,6 @@ static void asc_prt_adv_scsi_req_q(ADV_SCSI_REQ_Q *q)
 #endif /* ADVANSYS_DEBUG */
 
 /*
- * The advansys chip/microcode contains a 32-bit identifier for each command
- * known as the 'srb'.  I don't know what it stands for.  The driver used
- * to encode the scsi_cmnd pointer by calling virt_to_bus and retrieve it
- * with bus_to_virt.  Now the driver keeps a per-host map of integers to
- * pointers.  It auto-expands when full, unless it can't allocate memory.
- * Note that an srb of 0 is treated specially by the chip/firmware, hence
- * the return of i+1 in this routine, and the corresponding subtraction in
- * the inverse routine.
- */
-#define BAD_SRB 0
-static u32 advansys_ptr_to_srb(struct asc_dvc_var *asc_dvc, void *ptr)
-{
-	int i;
-	void **new_ptr;
-
-	for (i = 0; i < asc_dvc->ptr_map_count; i++) {
-		if (!asc_dvc->ptr_map[i])
-			goto out;
-	}
-
-	if (asc_dvc->ptr_map_count == 0)
-		asc_dvc->ptr_map_count = 1;
-	else
-		asc_dvc->ptr_map_count *= 2;
-
-	new_ptr = krealloc(asc_dvc->ptr_map,
-			asc_dvc->ptr_map_count * sizeof(void *), GFP_ATOMIC);
-	if (!new_ptr)
-		return BAD_SRB;
-	asc_dvc->ptr_map = new_ptr;
- out:
-	ASC_DBG(3, "Putting ptr %p into array offset %d\n", ptr, i);
-	asc_dvc->ptr_map[i] = ptr;
-	return i + 1;
-}
-
-static void * advansys_srb_to_ptr(struct asc_dvc_var *asc_dvc, u32 srb)
-{
-	void *ptr;
-
-	srb--;
-	if (srb >= asc_dvc->ptr_map_count) {
-		printk("advansys: bad SRB %u, max %u\n", srb,
-							asc_dvc->ptr_map_count);
-		return NULL;
-	}
-	ptr = asc_dvc->ptr_map[srb];
-	asc_dvc->ptr_map[srb] = NULL;
-	ASC_DBG(3, "Returning ptr %p from array offset %d\n", ptr, srb);
-	return ptr;
-}
-
-/*
  * advansys_info()
  *
  * Return suitable for printing on the console with the argument
@@ -6132,6 +6077,13 @@ static void adv_async_callback(ADV_DVC_VAR *adv_dvc_varp, uchar code)
 		AdvResetChipAndSB(adv_dvc_varp);
 		break;
 
+	case ADV_ASYNC_CARRIER_READY_FAILURE:
+		/*
+		 * Carrier not ready; abort the command.
+		 */
+		ASC_DBG(0, "ADV_ASYNC_CARRIER_READY_FAILURE\n");
+		break;
+
 	case ADV_HOST_SCSI_BUS_RESET:
 		/*
 		 * Host generated SCSI bus reset occurred.
@@ -6152,15 +6104,15 @@ static void adv_async_callback(ADV_DVC_VAR *adv_dvc_varp, uchar code)
  */
 static void adv_isr_callback(ADV_DVC_VAR *adv_dvc_varp, ADV_SCSI_REQ_Q *scsiqp)
 {
-	struct asc_board *boardp;
+	struct asc_board *boardp = adv_dvc_varp->drv_ptr;
+	u32 srb_tag;
 	adv_req_t *reqp;
 	adv_sgblk_t *sgblkp;
 	struct scsi_cmnd *scp;
-	struct Scsi_Host *shost;
 	ADV_DCNT resid_cnt;
 
-	ASC_DBG(1, "adv_dvc_varp 0x%lx, scsiqp 0x%lx\n",
-		 (ulong)adv_dvc_varp, (ulong)scsiqp);
+	ASC_DBG(1, "adv_dvc_varp 0x%p, scsiqp 0x%p\n",
+		adv_dvc_varp, scsiqp);
 	ASC_DBG_PRT_ADV_SCSI_REQ_Q(2, scsiqp);
 
 	/*
@@ -6168,22 +6120,9 @@ static void adv_isr_callback(ADV_DVC_VAR *adv_dvc_varp, ADV_SCSI_REQ_Q *scsiqp)
 	 * completed. The adv_req_t structure actually contains the
 	 * completed ADV_SCSI_REQ_Q structure.
 	 */
-	reqp = (adv_req_t *)ADV_U32_TO_VADDR(scsiqp->srb_ptr);
-	ASC_DBG(1, "reqp 0x%lx\n", (ulong)reqp);
-	if (reqp == NULL) {
-		ASC_PRINT("adv_isr_callback: reqp is NULL\n");
-		return;
-	}
+	srb_tag = le32_to_cpu(scsiqp->srb_tag);
+	scp = scsi_host_find_tag(boardp->shost, srb_tag);
 
-	/*
-	 * Get the struct scsi_cmnd structure and Scsi_Host structure for the
-	 * command that has been completed.
-	 *
-	 * Note: The adv_req_t request structure and adv_sgblk_t structure,
-	 * if any, are dropped, because a board structure pointer can not be
-	 * determined.
-	 */
-	scp = reqp->cmndp;
 	ASC_DBG(1, "scp 0x%p\n", scp);
 	if (scp == NULL) {
 		ASC_PRINT
@@ -6192,12 +6131,21 @@ static void adv_isr_callback(ADV_DVC_VAR *adv_dvc_varp, ADV_SCSI_REQ_Q *scsiqp)
 	}
 	ASC_DBG_PRT_CDB(2, scp->cmnd, scp->cmd_len);
 
-	shost = scp->device->host;
-	ASC_STATS(shost, callback);
-	ASC_DBG(1, "shost 0x%p\n", shost);
+	reqp = (adv_req_t *)scp->host_scribble;
+	ASC_DBG(1, "reqp 0x%lx\n", (ulong)reqp);
+	if (reqp == NULL) {
+		ASC_PRINT("adv_isr_callback: reqp is NULL\n");
+		return;
+	}
+	/*
+	 * Remove backreferences to avoid duplicate
+	 * command completions.
+	 */
+	scp->host_scribble = NULL;
+	reqp->cmndp = NULL;
 
-	boardp = shost_priv(shost);
-	BUG_ON(adv_dvc_varp != &boardp->dvc_var.adv_dvc_var);
+	ASC_STATS(boardp->shost, callback);
+	ASC_DBG(1, "shost 0x%p\n", boardp->shost);
 
 	/*
 	 * 'done_status' contains the command's ending status.
@@ -6295,13 +6243,6 @@ static void adv_isr_callback(ADV_DVC_VAR *adv_dvc_varp, ADV_SCSI_REQ_Q *scsiqp)
 		boardp->adv_sgblkp = sgblkp;
 	}
 
-	/*
-	 * Free the adv_req_t structure used with the command by adding
-	 * it back to the board free list.
-	 */
-	reqp->next_reqp = boardp->adv_reqp;
-	boardp->adv_reqp = reqp;
-
 	ASC_DBG(1, "done\n");
 }
 
@@ -7111,25 +7052,21 @@ _AscCopyLramScsiDoneQ(PortAddr iop_base,
  */
 static void asc_isr_callback(ASC_DVC_VAR *asc_dvc_varp, ASC_QDONE_INFO *qdonep)
 {
-	struct asc_board *boardp;
+	struct asc_board *boardp = asc_dvc_varp->drv_ptr;
+	u32 srb_tag;
 	struct scsi_cmnd *scp;
-	struct Scsi_Host *shost;
 
 	ASC_DBG(1, "asc_dvc_varp 0x%p, qdonep 0x%p\n", asc_dvc_varp, qdonep);
 	ASC_DBG_PRT_ASC_QDONE_INFO(2, qdonep);
 
-	scp = advansys_srb_to_ptr(asc_dvc_varp, qdonep->d2.srb_ptr);
+	srb_tag = le32_to_cpu(qdonep->d2.srb_tag);
+	scp = scsi_host_find_tag(boardp->shost, srb_tag);
 	if (!scp)
 		return;
 
 	ASC_DBG_PRT_CDB(2, scp->cmnd, scp->cmd_len);
 
-	shost = scp->device->host;
-	ASC_STATS(shost, callback);
-	ASC_DBG(1, "shost 0x%p\n", shost);
-
-	boardp = shost_priv(shost);
-	BUG_ON(asc_dvc_varp != &boardp->dvc_var.asc_dvc_var);
+	ASC_STATS(boardp->shost, callback);
 
 	dma_unmap_single(boardp->dev, scp->SCp.dma_handle,
 			 SCSI_SENSE_BUFFERSIZE, DMA_FROM_DEVICE);
@@ -7312,7 +7249,11 @@ static int AscIsrQDone(ASC_DVC_VAR *asc_dvc)
 			scsiq->d3.done_stat = QD_WITH_ERROR;
 			goto FATAL_ERR_QDONE;
 		}
-		if ((scsiq->d2.srb_ptr == 0UL) ||
+		/*
+		 * Fixme: this doesn't look right.
+		 * We can easily get an srb_tag of 0.
+		 */
+		if ((scsiq->d2.srb_tag == 0UL) ||
 		    ((scsiq->q_status & QS_ABORTED) != 0)) {
 			return (0x11);
 		} else if (scsiq->q_status == QS_DONE) {
@@ -7888,13 +7829,9 @@ static int asc_build_req(struct asc_board *boardp, struct scsi_cmnd *scp,
 	memset(asc_scsi_q, 0, sizeof(*asc_scsi_q));
 
 	/*
-	 * Point the ASC_SCSI_Q to the 'struct scsi_cmnd'.
+	 * Set the srb_tag to the command tag.
 	 */
-	asc_scsi_q->q2.srb_ptr = advansys_ptr_to_srb(asc_dvc, scp);
-	if (asc_scsi_q->q2.srb_ptr == BAD_SRB) {
-		scp->result = HOST_BYTE(DID_SOFT_ERROR);
-		return ASC_ERROR;
-	}
+	asc_scsi_q->q2.srb_tag = cpu_to_le32(scp->request->tag);
 
 	/*
 	 * Build the ASC_SCSI_Q request.
@@ -8106,6 +8043,7 @@ static int
 adv_build_req(struct asc_board *boardp, struct scsi_cmnd *scp,
 	      ADV_SCSI_REQ_Q **adv_scsiqpp)
 {
+	u32 srb_tag = scp->request->tag;
 	adv_req_t *reqp;
 	ADV_SCSI_REQ_Q *scsiqp;
 	int i;
@@ -8116,14 +8054,11 @@ adv_build_req(struct asc_board *boardp, struct scsi_cmnd *scp,
 	 * Allocate an adv_req_t structure from the board to execute
 	 * the command.
 	 */
-	if (boardp->adv_reqp == NULL) {
+	reqp = &boardp->adv_reqp[srb_tag];
+	if (reqp->cmndp && reqp->cmndp != scp ) {
 		ASC_DBG(1, "no free adv_req_t\n");
 		ASC_STATS(scp->device->host, adv_build_noreq);
 		return ASC_BUSY;
-	} else {
-		reqp = boardp->adv_reqp;
-		boardp->adv_reqp = reqp->next_reqp;
-		reqp->next_reqp = NULL;
 	}
 
 	/*
@@ -8137,14 +8072,17 @@ adv_build_req(struct asc_board *boardp, struct scsi_cmnd *scp,
 	scsiqp->cntl = scsiqp->scsi_cntl = scsiqp->done_status = 0;
 
 	/*
-	 * Set the ADV_SCSI_REQ_Q 'srb_ptr' to point to the adv_req_t structure.
+	 * Set the srb_tag to the command tag.
+	 * A value of '0' is handled specially by the HBA, so
+	 * increment the value by 1.
 	 */
-	scsiqp->srb_ptr = ADV_VADDR_TO_U32(reqp);
+	scsiqp->srb_tag = cpu_to_le32(scp->request->tag);
 
 	/*
 	 * Set the adv_req_t 'cmndp' to point to the struct scsi_cmnd structure.
 	 */
 	reqp->cmndp = scp;
+	scp->host_scribble = (void *)reqp;
 
 	/*
 	 * Build the ADV_SCSI_REQ_Q request.
@@ -8186,13 +8124,8 @@ adv_build_req(struct asc_board *boardp, struct scsi_cmnd *scp,
 				   scp->device->host->sg_tablesize);
 			scsi_dma_unmap(scp);
 			scp->result = HOST_BYTE(DID_ERROR);
-
-			/*
-			 * Free the 'adv_req_t' structure by adding it back
-			 * to the board free list.
-			 */
-			reqp->next_reqp = boardp->adv_reqp;
-			boardp->adv_reqp = reqp;
+			reqp->cmndp = NULL;
+			scp->host_scribble = NULL;
 
 			return ASC_ERROR;
 		}
@@ -8201,12 +8134,10 @@ adv_build_req(struct asc_board *boardp, struct scsi_cmnd *scp,
 
 		ret = adv_get_sglist(boardp, reqp, scp, use_sg);
 		if (ret != ADV_SUCCESS) {
-			/*
-			 * Free the adv_req_t structure by adding it back to
-			 * the board free list.
-			 */
-			reqp->next_reqp = boardp->adv_reqp;
-			boardp->adv_reqp = reqp;
+			scsi_dma_unmap(scp);
+			scp->result = HOST_BYTE(DID_ERROR);
+			reqp->cmndp = NULL;
+			scp->host_scribble = NULL;
 
 			return ret;
 		}
@@ -11267,6 +11198,7 @@ static struct scsi_host_template advansys_template = {
 	 * by enabling clustering, I/O throughput increases as well.
 	 */
 	.use_clustering = ENABLE_CLUSTERING,
+	.use_blk_tags = 1,
 };
 
 static int advansys_wide_init_chip(struct Scsi_Host *shost)
@@ -11295,7 +11227,7 @@ static int advansys_wide_init_chip(struct Scsi_Host *shost)
 	 * If the allocation fails decrement and try again.
 	 */
 	for (req_cnt = adv_dvc->max_host_qng; req_cnt > 0; req_cnt--) {
-		reqp = kmalloc(sizeof(adv_req_t) * req_cnt, GFP_KERNEL);
+		reqp = kzalloc(sizeof(adv_req_t) * req_cnt, GFP_KERNEL);
 
 		ASC_DBG(1, "reqp 0x%p, req_cnt %d, bytes %lu\n", reqp, req_cnt,
 			 (ulong)sizeof(adv_req_t) * req_cnt);
@@ -11307,7 +11239,7 @@ static int advansys_wide_init_chip(struct Scsi_Host *shost)
 	if (!reqp)
 		goto kmalloc_failed;
 
-	adv_dvc->orig_reqp = reqp;
+	board->adv_reqp = reqp;
 
 	/*
 	 * Allocate up to ADV_TOT_SG_BLOCK request structures for
@@ -11340,7 +11272,6 @@ static int advansys_wide_init_chip(struct Scsi_Host *shost)
 	for (; req_cnt > 0; req_cnt--) {
 		reqp[req_cnt - 1].next_reqp = &reqp[req_cnt];
 	}
-	board->adv_reqp = &reqp[0];
 
 	if (adv_dvc->chip_type == ADV_CHIP_ASC3550) {
 		ASC_DBG(2, "AdvInitAsc3550Driver()\n");
@@ -11373,8 +11304,8 @@ static void advansys_wide_free_mem(struct asc_board *board)
 	struct adv_dvc_var *adv_dvc = &board->dvc_var.adv_dvc_var;
 	kfree(adv_dvc->carrier_buf);
 	adv_dvc->carrier_buf = NULL;
-	kfree(adv_dvc->orig_reqp);
-	adv_dvc->orig_reqp = board->adv_reqp = NULL;
+	kfree(board->adv_reqp);
+	board->adv_reqp = NULL;
 	while (board->adv_sgblkp) {
 		adv_sgblk_t *sgp = board->adv_sgblkp;
 		board->adv_sgblkp = sgp->next_sgblkp;
@@ -11674,6 +11605,11 @@ static int advansys_board_found(struct Scsi_Host *shost, unsigned int iop,
 		/* Set maximum number of queues the adapter can handle. */
 		shost->can_queue = adv_dvc_varp->max_host_qng;
 	}
+	ret = scsi_init_shared_tag_map(shost, shost->can_queue);
+	if (ret) {
+		shost_printk(KERN_ERR, shost, "init tag map failed\n");
+		goto err_free_dma;
+	}
 
 	/*
 	 * Following v1.3.89, 'cmd_per_lun' is no longer needed
@@ -11945,6 +11881,7 @@ static int advansys_isa_probe(struct device *dev, unsigned int id)
 	board = shost_priv(shost);
 	board->irq = advansys_isa_irq_no(iop_base);
 	board->dev = dev;
+	board->shost = shost;
 
 	err = advansys_board_found(shost, iop_base, ASC_IS_ISA);
 	if (err)
@@ -12027,6 +11964,7 @@ static int advansys_vlb_probe(struct device *dev, unsigned int id)
 	board = shost_priv(shost);
 	board->irq = advansys_vlb_irq_no(iop_base);
 	board->dev = dev;
+	board->shost = shost;
 
 	err = advansys_board_found(shost, iop_base, ASC_IS_VL);
 	if (err)
@@ -12134,6 +12072,7 @@ static int advansys_eisa_probe(struct device *dev)
 		board = shost_priv(shost);
 		board->irq = irq;
 		board->dev = dev;
+		board->shost = shost;
 
 		err = advansys_board_found(shost, ioport, ASC_IS_EISA);
 		if (!err) {
@@ -12250,6 +12189,7 @@ static int advansys_pci_probe(struct pci_dev *pdev,
 	board = shost_priv(shost);
 	board->irq = pdev->irq;
 	board->dev = &pdev->dev;
+	board->shost = shost;
 
 	if (pdev->device == PCI_DEVICE_ID_ASP_ABP940UW ||
 	    pdev->device == PCI_DEVICE_ID_38C0800_REV1 ||
-- 
1.8.5.2

