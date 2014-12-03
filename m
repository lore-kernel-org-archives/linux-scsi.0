From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 05/12] advansys: Use DMA-API for mapping request blocks
Date: Wed,  3 Dec 2014 12:44:58 +0100
Message-ID: <1417607105-85455-6-git-send-email-hare@suse.de>
References: <1417607105-85455-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:55201 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752120AbaLCLpN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 3 Dec 2014 06:45:13 -0500
In-Reply-To: <1417607105-85455-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@lst.de>, Matthew Wilcox <matthew@wil.cx>, Doug Gilbert <dgilbert@interlog.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/advansys.c | 104 +++++++++++++++++++++++++-----------------------
 1 file changed, 55 insertions(+), 49 deletions(-)

diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
index ec8f122..c5395b5 100644
--- a/drivers/scsi/advansys.c
+++ b/drivers/scsi/advansys.c
@@ -1894,11 +1894,11 @@ typedef struct adv_sgblk {
 
 typedef struct adv_req {
 	ADV_SCSI_REQ_Q scsi_req_q;	/* Adv Library request structure. */
-	uchar align[32];	/* Request structure padding. */
+	uchar align[24];	/* Request structure padding. */
 	struct scsi_cmnd *cmndp;	/* Mid-Level SCSI command pointer. */
+	dma_addr_t req_addr;
 	adv_sgblk_t *sgblkp;	/* Adv Library scatter-gather pointer. */
-	struct adv_req *next_reqp;	/* Next Request Structure. */
-} adv_req_t;
+} adv_req_t __aligned(32);
 
 /*
  * Adapter operation variable structure.
@@ -2380,6 +2380,8 @@ struct asc_board {
 	void __iomem *ioremap_addr;	/* I/O Memory remap address. */
 	ushort ioport;		/* I/O Port address. */
 	adv_req_t *adv_reqp;	/* Request structures. */
+	dma_addr_t adv_reqp_addr;
+	size_t adv_reqp_size;
 	adv_sgblk_t *adv_sgblkp;	/* Scatter-gather structures. */
 	ushort bios_signature;	/* BIOS Signature. */
 	ushort bios_version;	/* BIOS Version. */
@@ -4403,6 +4405,17 @@ static ADV_CARR_T *adv_get_next_carrier(struct adv_dvc_var *adv_dvc)
 }
 
 /*
+ * 'offset' is the index in the request pointer array
+ */
+static adv_req_t * adv_get_reqp(struct adv_dvc_var *adv_dvc, u32 offset)
+{
+	struct asc_board *boardp = adv_dvc->drv_ptr;
+
+	BUG_ON(offset > adv_dvc->max_host_qng);
+	return &boardp->adv_reqp[offset];
+}
+
+/*
  * Send an idle command to the chip and wait for completion.
  *
  * Command completion is polled for once per microsecond.
@@ -6178,6 +6191,10 @@ static void adv_isr_callback(ADV_DVC_VAR *adv_dvc_varp, ADV_SCSI_REQ_Q *scsiqp)
 				scp->result = STATUS_BYTE(scsiqp->scsi_status);
 			}
 			break;
+		case QHSTA_M_SEL_TIMEOUT:
+			ASC_DBG(1, "Selection timeout\n");
+			scp->result = HOST_BYTE(DID_NO_CONNECT);
+			break;
 
 		default:
 			/* Some other QHSTA error occurred. */
@@ -6255,6 +6272,7 @@ static int AdvISR(ADV_DVC_VAR *asc_dvc)
 	ADV_CARR_T *free_carrp;
 	ADV_VADDR irq_next_vpa;
 	ADV_SCSI_REQ_Q *scsiq;
+	adv_req_t *reqp;
 
 	iop_base = asc_dvc->iop_base;
 
@@ -6307,8 +6325,11 @@ static int AdvISR(ADV_DVC_VAR *asc_dvc)
 		 * below complements the conversion of ASC_SCSI_REQ_Q.scsiq_ptr'
 		 * in AdvExeScsiQueue().
 		 */
-		scsiq = (ADV_SCSI_REQ_Q *)
-		    ADV_U32_TO_VADDR(le32_to_cpu(asc_dvc->irq_sp->areq_vpa));
+		u32 pa_offset = le32_to_cpu(asc_dvc->irq_sp->areq_vpa);
+		ASC_DBG(1, "irq_sp %p areq_vpa %u\n",
+			asc_dvc->irq_sp, pa_offset);
+		reqp = adv_get_reqp(asc_dvc, pa_offset);
+		scsiq = &reqp->scsi_req_q;
 
 		/*
 		 * Request finished with good status and the queue was not
@@ -8020,7 +8041,7 @@ adv_get_sglist(struct asc_board *boardp, adv_req_t *reqp,
  */
 static int
 adv_build_req(struct asc_board *boardp, struct scsi_cmnd *scp,
-	      ADV_SCSI_REQ_Q **adv_scsiqpp)
+	      adv_req_t **adv_reqpp)
 {
 	u32 srb_tag = scp->request->tag;
 	adv_req_t *reqp;
@@ -8040,10 +8061,9 @@ adv_build_req(struct asc_board *boardp, struct scsi_cmnd *scp,
 		return ASC_BUSY;
 	}
 
-	/*
-	 * Get 32-byte aligned ADV_SCSI_REQ_Q and ADV_SG_BLOCK pointers.
-	 */
-	scsiqp = (ADV_SCSI_REQ_Q *)ADV_32BALIGN(&reqp->scsi_req_q);
+	reqp->req_addr = boardp->adv_reqp_addr + (srb_tag * sizeof(adv_req_t));
+
+	scsiqp = &reqp->scsi_req_q;
 
 	/*
 	 * Initialize the structure.
@@ -8058,7 +8078,7 @@ adv_build_req(struct asc_board *boardp, struct scsi_cmnd *scp,
 	scsiqp->srb_tag = cpu_to_le32(scp->request->tag);
 
 	/*
-	 * Set the adv_req_t 'cmndp' to point to the struct scsi_cmnd structure.
+	 * Set 'host_scribble' to point to the adv_req_t structure.
 	 */
 	reqp->cmndp = scp;
 	scp->host_scribble = (void *)reqp;
@@ -8132,7 +8152,7 @@ adv_build_req(struct asc_board *boardp, struct scsi_cmnd *scp,
 	ASC_DBG_PRT_ADV_SCSI_REQ_Q(2, scsiqp);
 	ASC_DBG_PRT_CDB(1, scp->cmnd, scp->cmd_len);
 
-	*adv_scsiqpp = scsiqp;
+	*adv_reqpp = reqp;
 
 	return ASC_NOERROR;
 }
@@ -8722,11 +8742,11 @@ static int AscExeScsiQueue(ASC_DVC_VAR *asc_dvc, ASC_SCSI_Q *scsiq)
  *      ADV_ERROR(-1) -  Invalid ADV_SCSI_REQ_Q request structure
  *                       host IC error.
  */
-static int AdvExeScsiQueue(ADV_DVC_VAR *asc_dvc, ADV_SCSI_REQ_Q *scsiq)
+static int AdvExeScsiQueue(ADV_DVC_VAR *asc_dvc, adv_req_t *reqp)
 {
 	AdvPortAddr iop_base;
-	ADV_PADDR req_paddr;
 	ADV_CARR_T *new_carrp;
+	ADV_SCSI_REQ_Q *scsiq = &reqp->scsi_req_q;
 
 	/*
 	 * The ADV_SCSI_REQ_Q 'target_id' field should never exceed ADV_MAX_TID.
@@ -8756,14 +8776,9 @@ static int AdvExeScsiQueue(ADV_DVC_VAR *asc_dvc, ADV_SCSI_REQ_Q *scsiq)
 	 */
 	scsiq->a_flag &= ~ADV_SCSIQ_DONE;
 
-	req_paddr = virt_to_bus(scsiq);
-	BUG_ON(req_paddr & 31);
-	/* Wait for assertion before making little-endian */
-	req_paddr = cpu_to_le32(req_paddr);
-
 	/* Save virtual and physical address of ADV_SCSI_REQ_Q and carrier. */
-	scsiq->scsiq_ptr = cpu_to_le32(ADV_VADDR_TO_U32(scsiq));
-	scsiq->scsiq_rptr = req_paddr;
+	scsiq->scsiq_ptr = cpu_to_le32(scsiq->srb_tag);
+	scsiq->scsiq_rptr = cpu_to_le32(reqp->req_addr);
 
 	scsiq->carr_va = asc_dvc->icq_sp->carr_va;
 	scsiq->carr_pa = asc_dvc->icq_sp->carr_pa;
@@ -8773,7 +8788,7 @@ static int AdvExeScsiQueue(ADV_DVC_VAR *asc_dvc, ADV_SCSI_REQ_Q *scsiq)
 	 * the microcode. The newly allocated stopper will become the new
 	 * stopper.
 	 */
-	asc_dvc->icq_sp->areq_vpa = req_paddr;
+	asc_dvc->icq_sp->areq_vpa = scsiq->scsiq_rptr;
 
 	/*
 	 * Set the 'next_vpa' pointer for the old stopper to be the
@@ -8840,9 +8855,9 @@ static int asc_execute_scsi_cmnd(struct scsi_cmnd *scp)
 		err_code = asc_dvc->err_code;
 	} else {
 		ADV_DVC_VAR *adv_dvc = &boardp->dvc_var.adv_dvc_var;
-		ADV_SCSI_REQ_Q *adv_scsiqp;
+		adv_req_t *adv_reqp;
 
-		switch (adv_build_req(boardp, scp, &adv_scsiqp)) {
+		switch (adv_build_req(boardp, scp, &adv_reqp)) {
 		case ASC_NOERROR:
 			ASC_DBG(3, "adv_build_req ASC_NOERROR\n");
 			break;
@@ -8862,7 +8877,7 @@ static int asc_execute_scsi_cmnd(struct scsi_cmnd *scp)
 			return ASC_ERROR;
 		}
 
-		ret = AdvExeScsiQueue(adv_dvc, adv_scsiqp);
+		ret = AdvExeScsiQueue(adv_dvc, adv_reqp);
 		err_code = adv_dvc->err_code;
 	}
 
@@ -8877,6 +8892,7 @@ static int asc_execute_scsi_cmnd(struct scsi_cmnd *scp)
 		ASC_DBG(1, "ExeScsiQueue() ASC_NOERROR\n");
 		break;
 	case ASC_BUSY:
+		ASC_DBG(1, "ExeScsiQueue() ASC_BUSY\n");
 		ASC_STATS(scp->device->host, exe_busy);
 		break;
 	case ASC_ERROR:
@@ -11177,8 +11193,6 @@ static int advansys_wide_init_chip(struct Scsi_Host *shost)
 {
 	struct asc_board *board = shost_priv(shost);
 	struct adv_dvc_var *adv_dvc = &board->dvc_var.adv_dvc_var;
-	int req_cnt = 0;
-	adv_req_t *reqp = NULL;
 	int sg_cnt = 0;
 	adv_sgblk_t *sgp;
 	int warn_code, err_code;
@@ -11199,20 +11213,19 @@ static int advansys_wide_init_chip(struct Scsi_Host *shost)
 	 * board. The total size is about 16 KB, so allocate all at once.
 	 * If the allocation fails decrement and try again.
 	 */
-	for (req_cnt = adv_dvc->max_host_qng; req_cnt > 0; req_cnt--) {
-		reqp = kzalloc(sizeof(adv_req_t) * req_cnt, GFP_KERNEL);
-
-		ASC_DBG(1, "reqp 0x%p, req_cnt %d, bytes %lu\n", reqp, req_cnt,
-			 (ulong)sizeof(adv_req_t) * req_cnt);
-
-		if (reqp)
-			break;
+	board->adv_reqp_size = adv_dvc->max_host_qng * sizeof(adv_req_t);
+	if (board->adv_reqp_size & 0x1f) {
+		ASC_DBG(1, "unaligned reqp %lu bytes\n", sizeof(adv_req_t));
+		board->adv_reqp_size = ADV_32BALIGN(board->adv_reqp_size);
 	}
+	board->adv_reqp = dma_alloc_coherent(board->dev, board->adv_reqp_size,
+		&board->adv_reqp_addr, GFP_KERNEL);
 
-	if (!reqp)
+	if (!board->adv_reqp)
 		goto kmalloc_failed;
 
-	board->adv_reqp = reqp;
+	ASC_DBG(1, "reqp 0x%p, req_cnt %d, bytes %lu\n", board->adv_reqp,
+		adv_dvc->max_host_qng, board->adv_reqp_size);
 
 	/*
 	 * Allocate up to ADV_TOT_SG_BLOCK request structures for
@@ -11236,16 +11249,6 @@ static int advansys_wide_init_chip(struct Scsi_Host *shost)
 	if (!board->adv_sgblkp)
 		goto kmalloc_failed;
 
-	/*
-	 * Point 'adv_reqp' to the request structures and
-	 * link them together.
-	 */
-	req_cnt--;
-	reqp[req_cnt].next_reqp = NULL;
-	for (; req_cnt > 0; req_cnt--) {
-		reqp[req_cnt - 1].next_reqp = &reqp[req_cnt];
-	}
-
 	if (adv_dvc->chip_type == ADV_CHIP_ASC3550) {
 		ASC_DBG(2, "AdvInitAsc3550Driver()\n");
 		warn_code = AdvInitAsc3550Driver(adv_dvc);
@@ -11281,8 +11284,11 @@ static void advansys_wide_free_mem(struct asc_board *board)
 				  adv_dvc->carrier, adv_dvc->carrier_addr);
 		adv_dvc->carrier = NULL;
 	}
-	kfree(board->adv_reqp);
-	board->adv_reqp = NULL;
+	if (board->adv_reqp) {
+		dma_free_coherent(board->dev, board->adv_reqp_size,
+				  board->adv_reqp, board->adv_reqp_addr);
+		board->adv_reqp = NULL;
+	}
 	while (board->adv_sgblkp) {
 		adv_sgblk_t *sgp = board->adv_sgblkp;
 		board->adv_sgblkp = sgp->next_sgblkp;
-- 
1.8.5.2

