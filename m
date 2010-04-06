From: James Smart <james.smart@emulex.com>
Subject: [PATCH 4/7] lpfc 8.3.12: Critical fixes
Date: Tue, 6 Apr 2010 15:04:33 -0400
Message-ID: <1270580693.28785.0.camel@wookie>
Reply-To: james.smart@emulex.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exht1.emulex.com ([138.239.113.183]:15914 "EHLO
	exht1.ad.emulex.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757539Ab0DFTFQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Apr 2010 15:05:16 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


- Move the code to increase the sg seg count for LP21000 adapters.
- Check pcmd on command completion before dereferencing it.
- Clear queue memory when creating firmware queues to prevent stale entries.
- Replace the use of PAGE_SIZE in many areas that assumed it was always 4k.
- Add an else clause to a conditional that needed to unlock the hba_lock.

 Signed-off-by: Alex Iannicelli <alex.iannicelli@emulex.com>
 Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_bsg.c  |    9 ++++-----
 lpfc_bsg.h  |    1 +
 lpfc_els.c  |    2 +-
 lpfc_init.c |   16 +++++++---------
 lpfc_mbox.c |   16 ++++++++--------
 lpfc_sli.c  |   47 +++++++++++++++++++++++++++++++++++------------
 6 files changed, 56 insertions(+), 35 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_bsg.c b/drivers/scsi/lpfc/lpfc_bsg.c
--- a/drivers/scsi/lpfc/lpfc_bsg.c	2010-04-06 12:46:53.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_bsg.c	2010-04-06 12:58:02.000000000 -0400
@@ -2590,7 +2590,7 @@ lpfc_bsg_issue_mbox(struct lpfc_hba *phb
 		goto job_done;
 	}
 
-	mb = kzalloc(PAGE_SIZE, GFP_KERNEL);
+	mb = kzalloc(BSG_MBOX_SIZE, GFP_KERNEL);
 	if (!mb) {
 		rc = -ENOMEM;
 		goto job_done;
@@ -2664,13 +2664,12 @@ lpfc_bsg_issue_mbox(struct lpfc_hba *phb
 		rxbmp->virt = lpfc_mbuf_alloc(phba, 0, &rxbmp->phys);
 		INIT_LIST_HEAD(&rxbmp->list);
 		rxbpl = (struct ulp_bde64 *) rxbmp->virt;
-		dmp = diag_cmd_data_alloc(phba, rxbpl, PAGE_SIZE, 0);
+		dmp = diag_cmd_data_alloc(phba, rxbpl, BSG_MBOX_SIZE, 0);
 		if (!dmp) {
 			rc = -ENOMEM;
 			goto job_done;
 		}
 
-		dmp->size = PAGE_SIZE;
 		INIT_LIST_HEAD(&dmp->dma.list);
 		pmb->un.varBIUdiag.un.s2.xmit_bde64.addrHigh =
 			putPaddrHigh(dmp->dma.phys);
@@ -2773,12 +2772,12 @@ lpfc_bsg_mbox_cmd(struct fc_bsg_job *job
 		goto job_error;
 	}
 
-	if (job->request_payload.payload_len != PAGE_SIZE) {
+	if (job->request_payload.payload_len != BSG_MBOX_SIZE) {
 		rc = -EINVAL;
 		goto job_error;
 	}
 
-	if (job->reply_payload.payload_len != PAGE_SIZE) {
+	if (job->reply_payload.payload_len != BSG_MBOX_SIZE) {
 		rc = -EINVAL;
 		goto job_error;
 	}
diff -upNr a/drivers/scsi/lpfc/lpfc_bsg.h b/drivers/scsi/lpfc/lpfc_bsg.h
--- a/drivers/scsi/lpfc/lpfc_bsg.h	2010-04-06 12:46:53.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_bsg.h	2010-04-06 12:58:02.000000000 -0400
@@ -91,6 +91,7 @@ struct get_mgmt_rev_reply {
 	struct MgmtRevInfo info;
 };
 
+#define BSG_MBOX_SIZE 4096 /* mailbox command plus extended data */
 struct dfc_mbox_req {
 	uint32_t command;
 	uint32_t mbOffset;
diff -upNr a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
--- a/drivers/scsi/lpfc/lpfc_els.c	2010-04-06 12:46:53.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_els.c	2010-04-06 12:58:02.000000000 -0400
@@ -5369,7 +5369,7 @@ lpfc_send_els_failure_event(struct lpfc_
 			sizeof(struct lpfc_name));
 		pcmd = (uint32_t *) (((struct lpfc_dmabuf *)
 			cmdiocbp->context2)->virt);
-		lsrjt_event.command = *pcmd;
+		lsrjt_event.command = (pcmd != NULL) ? *pcmd : 0;
 		stat.un.lsRjtError = be32_to_cpu(rspiocbp->iocb.un.ulpWord[4]);
 		lsrjt_event.reason_code = stat.un.b.lsRjtRsnCode;
 		lsrjt_event.explanation = stat.un.b.lsRjtRsnCodeExp;
diff -upNr a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
--- a/drivers/scsi/lpfc/lpfc_init.c	2010-04-06 12:56:53.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_init.c	2010-04-06 12:58:02.000000000 -0400
@@ -2599,15 +2599,6 @@ lpfc_create_port(struct lpfc_hba *phba, 
 	init_timer(&vport->els_tmofunc);
 	vport->els_tmofunc.function = lpfc_els_timeout;
 	vport->els_tmofunc.data = (unsigned long)vport;
-	if (phba->pcidev->device == PCI_DEVICE_ID_HORNET) {
-		phba->menlo_flag |= HBA_MENLO_SUPPORT;
-		/* check for menlo minimum sg count */
-		if (phba->cfg_sg_seg_cnt < LPFC_DEFAULT_MENLO_SG_SEG_CNT) {
-			phba->cfg_sg_seg_cnt = LPFC_DEFAULT_MENLO_SG_SEG_CNT;
-			shost->sg_tablesize = phba->cfg_sg_seg_cnt;
-		}
-	}
-
 	error = scsi_add_host_with_dma(shost, dev, &phba->pcidev->dev);
 	if (error)
 		goto out_put_shost;
@@ -3851,6 +3842,13 @@ lpfc_sli_driver_resource_setup(struct lp
 
 	/* Get all the module params for configuring this host */
 	lpfc_get_cfgparam(phba);
+	if (phba->pcidev->device == PCI_DEVICE_ID_HORNET) {
+		phba->menlo_flag |= HBA_MENLO_SUPPORT;
+		/* check for menlo minimum sg count */
+		if (phba->cfg_sg_seg_cnt < LPFC_DEFAULT_MENLO_SG_SEG_CNT)
+			phba->cfg_sg_seg_cnt = LPFC_DEFAULT_MENLO_SG_SEG_CNT;
+	}
+
 	/*
 	 * Since the sg_tablesize is module parameter, the sg_dma_buf_size
 	 * used to create the sg_dma_buf_pool must be dynamically calculated.
diff -upNr a/drivers/scsi/lpfc/lpfc_mbox.c b/drivers/scsi/lpfc/lpfc_mbox.c
--- a/drivers/scsi/lpfc/lpfc_mbox.c	2010-04-06 12:56:53.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_mbox.c	2010-04-06 12:58:02.000000000 -0400
@@ -1610,7 +1610,7 @@ lpfc_sli4_mbox_cmd_free(struct lpfc_hba 
 	for (sgentry = 0; sgentry < sgecount; sgentry++) {
 		lpfc_sli4_mbx_sge_get(mbox, sgentry, &sge);
 		phyaddr = getPaddr(sge.pa_hi, sge.pa_lo);
-		dma_free_coherent(&phba->pcidev->dev, PAGE_SIZE,
+		dma_free_coherent(&phba->pcidev->dev, SLI4_PAGE_SIZE,
 				  mbox->sge_array->addr[sgentry], phyaddr);
 	}
 	/* Free the sge address array memory */
@@ -1668,7 +1668,7 @@ lpfc_sli4_config(struct lpfc_hba *phba, 
 	}
 
 	/* Setup for the none-embedded mbox command */
-	pcount = (PAGE_ALIGN(length))/PAGE_SIZE;
+	pcount = (PAGE_ALIGN(length))/SLI4_PAGE_SIZE;
 	pcount = (pcount > LPFC_SLI4_MBX_SGE_MAX_PAGES) ?
 				LPFC_SLI4_MBX_SGE_MAX_PAGES : pcount;
 	/* Allocate record for keeping SGE virtual addresses */
@@ -1683,24 +1683,24 @@ lpfc_sli4_config(struct lpfc_hba *phba, 
 	for (pagen = 0, alloc_len = 0; pagen < pcount; pagen++) {
 		/* The DMA memory is always allocated in the length of a
 		 * page even though the last SGE might not fill up to a
-		 * page, this is used as a priori size of PAGE_SIZE for
+		 * page, this is used as a priori size of SLI4_PAGE_SIZE for
 		 * the later DMA memory free.
 		 */
-		viraddr = dma_alloc_coherent(&phba->pcidev->dev, PAGE_SIZE,
+		viraddr = dma_alloc_coherent(&phba->pcidev->dev, SLI4_PAGE_SIZE,
 					     &phyaddr, GFP_KERNEL);
 		/* In case of malloc fails, proceed with whatever we have */
 		if (!viraddr)
 			break;
-		memset(viraddr, 0, PAGE_SIZE);
+		memset(viraddr, 0, SLI4_PAGE_SIZE);
 		mbox->sge_array->addr[pagen] = viraddr;
 		/* Keep the first page for later sub-header construction */
 		if (pagen == 0)
 			cfg_shdr = (union lpfc_sli4_cfg_shdr *)viraddr;
 		resid_len = length - alloc_len;
-		if (resid_len > PAGE_SIZE) {
+		if (resid_len > SLI4_PAGE_SIZE) {
 			lpfc_sli4_mbx_sge_set(mbox, pagen, phyaddr,
-					      PAGE_SIZE);
-			alloc_len += PAGE_SIZE;
+					      SLI4_PAGE_SIZE);
+			alloc_len += SLI4_PAGE_SIZE;
 		} else {
 			lpfc_sli4_mbx_sge_set(mbox, pagen, phyaddr,
 					      resid_len);
diff -upNr a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
--- a/drivers/scsi/lpfc/lpfc_sli.c	2010-04-06 12:56:53.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_sli.c	2010-04-06 12:58:02.000000000 -0400
@@ -4295,7 +4295,7 @@ lpfc_sli4_hba_setup(struct lpfc_hba *phb
 			"2570 Failed to read FCoE parameters\n");
 
 	/* Issue READ_REV to collect vpd and FW information. */
-	vpd_size = PAGE_SIZE;
+	vpd_size = SLI4_PAGE_SIZE;
 	vpd = kzalloc(vpd_size, GFP_KERNEL);
 	if (!vpd) {
 		rc = -ENOMEM;
@@ -7135,13 +7135,11 @@ lpfc_sli_abort_els_cmpl(struct lpfc_hba 
 			 */
 			list_del_init(&abort_iocb->list);
 			pring->txcmplq_cnt--;
-			spin_unlock_irq(&phba->hbalock);
 
 			/* Firmware could still be in progress of DMAing
 			 * payload, so don't free data buffer till after
 			 * a hbeat.
 			 */
-			spin_lock_irq(&phba->hbalock);
 			abort_iocb->iocb_flag |= LPFC_DELAY_MEM_FREE;
 			abort_iocb->iocb_flag &= ~LPFC_DRIVER_ABORTED;
 			spin_unlock_irq(&phba->hbalock);
@@ -7149,7 +7147,8 @@ lpfc_sli_abort_els_cmpl(struct lpfc_hba 
 			abort_iocb->iocb.ulpStatus = IOSTAT_LOCAL_REJECT;
 			abort_iocb->iocb.un.ulpWord[4] = IOERR_ABORT_REQUESTED;
 			(abort_iocb->iocb_cmpl)(phba, abort_iocb, abort_iocb);
-		}
+		} else
+			spin_unlock_irq(&phba->hbalock);
 	}
 
 	lpfc_sli_release_iocbq(phba, cmdiocb);
@@ -9543,7 +9542,7 @@ lpfc_sli4_queue_free(struct lpfc_queue *
 	while (!list_empty(&queue->page_list)) {
 		list_remove_head(&queue->page_list, dmabuf, struct lpfc_dmabuf,
 				 list);
-		dma_free_coherent(&queue->phba->pcidev->dev, PAGE_SIZE,
+		dma_free_coherent(&queue->phba->pcidev->dev, SLI4_PAGE_SIZE,
 				  dmabuf->virt, dmabuf->phys);
 		kfree(dmabuf);
 	}
@@ -9571,7 +9570,6 @@ lpfc_sli4_queue_alloc(struct lpfc_hba *p
 	void *dma_pointer;
 	uint32_t hw_page_size = phba->sli4_hba.pc_sli4_params.if_page_sz;
 
-
 	if (!phba->sli4_hba.pc_sli4_params.supported)
 		hw_page_size = SLI4_PAGE_SIZE;
 
@@ -9646,6 +9644,10 @@ lpfc_eq_create(struct lpfc_hba *phba, st
 	uint32_t shdr_status, shdr_add_status;
 	union lpfc_sli4_cfg_shdr *shdr;
 	uint16_t dmult;
+	uint32_t hw_page_size = phba->sli4_hba.pc_sli4_params.if_page_sz;
+
+	if (!phba->sli4_hba.pc_sli4_params.supported)
+		hw_page_size = SLI4_PAGE_SIZE;
 
 	mbox = mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
 	if (!mbox)
@@ -9695,6 +9697,7 @@ lpfc_eq_create(struct lpfc_hba *phba, st
 		break;
 	}
 	list_for_each_entry(dmabuf, &eq->page_list, list) {
+		memset(dmabuf->virt, 0, hw_page_size);
 		eq_create->u.request.page[dmabuf->buffer_tag].addr_lo =
 					putPaddrLow(dmabuf->phys);
 		eq_create->u.request.page[dmabuf->buffer_tag].addr_hi =
@@ -9757,6 +9760,11 @@ lpfc_cq_create(struct lpfc_hba *phba, st
 	int rc, length, status = 0;
 	uint32_t shdr_status, shdr_add_status;
 	union lpfc_sli4_cfg_shdr *shdr;
+	uint32_t hw_page_size = phba->sli4_hba.pc_sli4_params.if_page_sz;
+
+	if (!phba->sli4_hba.pc_sli4_params.supported)
+		hw_page_size = SLI4_PAGE_SIZE;
+
 
 	mbox = mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
 	if (!mbox)
@@ -9794,6 +9802,7 @@ lpfc_cq_create(struct lpfc_hba *phba, st
 		break;
 	}
 	list_for_each_entry(dmabuf, &cq->page_list, list) {
+		memset(dmabuf->virt, 0, hw_page_size);
 		cq_create->u.request.page[dmabuf->buffer_tag].addr_lo =
 					putPaddrLow(dmabuf->phys);
 		cq_create->u.request.page[dmabuf->buffer_tag].addr_hi =
@@ -9923,7 +9932,10 @@ lpfc_mq_create(struct lpfc_hba *phba, st
 	int rc, length, status = 0;
 	uint32_t shdr_status, shdr_add_status;
 	union lpfc_sli4_cfg_shdr *shdr;
+	uint32_t hw_page_size = phba->sli4_hba.pc_sli4_params.if_page_sz;
 
+	if (!phba->sli4_hba.pc_sli4_params.supported)
+		hw_page_size = SLI4_PAGE_SIZE;
 
 	mbox = mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
 	if (!mbox)
@@ -9972,6 +9984,7 @@ lpfc_mq_create(struct lpfc_hba *phba, st
 		break;
 	}
 	list_for_each_entry(dmabuf, &mq->page_list, list) {
+		memset(dmabuf->virt, 0, hw_page_size);
 		mq_create_ext->u.request.page[dmabuf->buffer_tag].addr_lo =
 					putPaddrLow(dmabuf->phys);
 		mq_create_ext->u.request.page[dmabuf->buffer_tag].addr_hi =
@@ -10053,6 +10066,10 @@ lpfc_wq_create(struct lpfc_hba *phba, st
 	int rc, length, status = 0;
 	uint32_t shdr_status, shdr_add_status;
 	union lpfc_sli4_cfg_shdr *shdr;
+	uint32_t hw_page_size = phba->sli4_hba.pc_sli4_params.if_page_sz;
+
+	if (!phba->sli4_hba.pc_sli4_params.supported)
+		hw_page_size = SLI4_PAGE_SIZE;
 
 	mbox = mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
 	if (!mbox)
@@ -10068,6 +10085,7 @@ lpfc_wq_create(struct lpfc_hba *phba, st
 	bf_set(lpfc_mbx_wq_create_cq_id, &wq_create->u.request,
 		    cq->queue_id);
 	list_for_each_entry(dmabuf, &wq->page_list, list) {
+		memset(dmabuf->virt, 0, hw_page_size);
 		wq_create->u.request.page[dmabuf->buffer_tag].addr_lo =
 					putPaddrLow(dmabuf->phys);
 		wq_create->u.request.page[dmabuf->buffer_tag].addr_hi =
@@ -10136,6 +10154,10 @@ lpfc_rq_create(struct lpfc_hba *phba, st
 	int rc, length, status = 0;
 	uint32_t shdr_status, shdr_add_status;
 	union lpfc_sli4_cfg_shdr *shdr;
+	uint32_t hw_page_size = phba->sli4_hba.pc_sli4_params.if_page_sz;
+
+	if (!phba->sli4_hba.pc_sli4_params.supported)
+		hw_page_size = SLI4_PAGE_SIZE;
 
 	if (hrq->entry_count != drq->entry_count)
 		return -EINVAL;
@@ -10180,6 +10202,7 @@ lpfc_rq_create(struct lpfc_hba *phba, st
 	bf_set(lpfc_rq_context_buf_size, &rq_create->u.request.context,
 	       LPFC_HDR_BUF_SIZE);
 	list_for_each_entry(dmabuf, &hrq->page_list, list) {
+		memset(dmabuf->virt, 0, hw_page_size);
 		rq_create->u.request.page[dmabuf->buffer_tag].addr_lo =
 					putPaddrLow(dmabuf->phys);
 		rq_create->u.request.page[dmabuf->buffer_tag].addr_hi =
@@ -10752,7 +10775,7 @@ lpfc_sli4_post_sgl_list(struct lpfc_hba 
 
 	reqlen = els_xri_cnt * sizeof(struct sgl_page_pairs) +
 		 sizeof(union lpfc_sli4_cfg_shdr) + sizeof(uint32_t);
-	if (reqlen > PAGE_SIZE) {
+	if (reqlen > SLI4_PAGE_SIZE) {
 		lpfc_printf_log(phba, KERN_WARNING, LOG_INIT,
 				"2559 Block sgl registration required DMA "
 				"size (%d) great than a page\n", reqlen);
@@ -10858,7 +10881,7 @@ lpfc_sli4_post_scsi_sgl_block(struct lpf
 	/* Calculate the requested length of the dma memory */
 	reqlen = cnt * sizeof(struct sgl_page_pairs) +
 		 sizeof(union lpfc_sli4_cfg_shdr) + sizeof(uint32_t);
-	if (reqlen > PAGE_SIZE) {
+	if (reqlen > SLI4_PAGE_SIZE) {
 		lpfc_printf_log(phba, KERN_WARNING, LOG_INIT,
 				"0217 Block sgl registration required DMA "
 				"size (%d) great than a page\n", reqlen);
@@ -11694,8 +11717,8 @@ lpfc_sli4_handle_received_buffer(struct 
  *
  * This routine is invoked to post rpi header templates to the
  * HBA consistent with the SLI-4 interface spec.  This routine
- * posts a PAGE_SIZE memory region to the port to hold up to
- * PAGE_SIZE modulo 64 rpi context headers.
+ * posts a SLI4_PAGE_SIZE memory region to the port to hold up to
+ * SLI4_PAGE_SIZE modulo 64 rpi context headers.
  *
  * This routine does not require any locks.  It's usage is expected
  * to be driver load or reset recovery when the driver is
@@ -11798,8 +11821,8 @@ lpfc_sli4_post_rpi_hdr(struct lpfc_hba *
  *
  * This routine is invoked to post rpi header templates to the
  * HBA consistent with the SLI-4 interface spec.  This routine
- * posts a PAGE_SIZE memory region to the port to hold up to
- * PAGE_SIZE modulo 64 rpi context headers.
+ * posts a SLI4_PAGE_SIZE memory region to the port to hold up to
+ * SLI4_PAGE_SIZE modulo 64 rpi context headers.
  *
  * Returns
  * 	A nonzero rpi defined as rpi_base <= rpi < max_rpi if successful


