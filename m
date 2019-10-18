Return-Path: <SRS0=K+7G=YL=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2E07CA9EA1
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Oct 2019 07:50:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9D5D021897
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Oct 2019 07:50:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2504696AbfJRHuS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Oct 2019 03:50:18 -0400
Received: from mx2.suse.de ([195.135.220.15]:36796 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2504670AbfJRHuS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 18 Oct 2019 03:50:18 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 54422B825;
        Fri, 18 Oct 2019 07:50:12 +0000 (UTC)
From:   Hannes Reinecke <hare@suse.de>
To:     James Smart <james.smart@broadcom.com>
Cc:     Dick Kennedy <dick.kennedy@broadcom.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        Hannes Reinecke <hare@suse.com>
Subject: [PATCH 1/3] lpfc: use named structure for combined I/O buffer
Date:   Fri, 18 Oct 2019 09:50:08 +0200
Message-Id: <20191018075010.55653-2-hare@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20191018075010.55653-1-hare@suse.de>
References: <20191018075010.55653-1-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Use named structures in the combined I/O buffer to annotate the
fields with the intended protocol usage.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/lpfc/lpfc_init.c |   2 +-
 drivers/scsi/lpfc/lpfc_nvme.c |  42 +++++-----
 drivers/scsi/lpfc/lpfc_scsi.c | 190 +++++++++++++++++++++---------------------
 drivers/scsi/lpfc/lpfc_sli.c  |  26 +++---
 drivers/scsi/lpfc/lpfc_sli.h  |   4 +-
 5 files changed, 132 insertions(+), 132 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 6e6bb8da97d6..f3caeb0d1151 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -1081,7 +1081,7 @@ lpfc_hba_down_post_s4(struct lpfc_hba *phba)
 				 &aborts);
 
 		list_for_each_entry_safe(psb, psb_next, &aborts, list) {
-			psb->pCmd = NULL;
+			psb->scsi.pCmd = NULL;
 			psb->status = IOSTAT_SUCCESS;
 			cnt++;
 		}
diff --git a/drivers/scsi/lpfc/lpfc_nvme.c b/drivers/scsi/lpfc/lpfc_nvme.c
index 5af944b97c4c..defb19cdc7fe 100644
--- a/drivers/scsi/lpfc/lpfc_nvme.c
+++ b/drivers/scsi/lpfc/lpfc_nvme.c
@@ -1023,18 +1023,18 @@ lpfc_nvme_io_cmd_wqe_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *pwqeIn,
 	/* Guard against abort handler being called at same time */
 	spin_lock(&lpfc_ncmd->buf_lock);
 
-	if (!lpfc_ncmd->nvmeCmd) {
+	if (!lpfc_ncmd->nvme.nvmeCmd) {
 		spin_unlock(&lpfc_ncmd->buf_lock);
 		lpfc_printf_vlog(vport, KERN_ERR, LOG_NODE | LOG_NVME_IOERR,
 				 "6066 Missing cmpl ptrs: lpfc_ncmd x%px, "
 				 "nvmeCmd x%px\n",
-				 lpfc_ncmd, lpfc_ncmd->nvmeCmd);
+				 lpfc_ncmd, lpfc_ncmd->nvme.nvmeCmd);
 
 		/* Release the lpfc_ncmd regardless of the missing elements. */
 		lpfc_release_nvme_buf(phba, lpfc_ncmd);
 		return;
 	}
-	nCmd = lpfc_ncmd->nvmeCmd;
+	nCmd = lpfc_ncmd->nvme.nvmeCmd;
 	status = bf_get(lpfc_wcqe_c_status, wcqe);
 
 	idx = lpfc_ncmd->cur_iocbq.hba_wqidx;
@@ -1205,7 +1205,7 @@ lpfc_nvme_io_cmd_wqe_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *pwqeIn,
 	if (!(lpfc_ncmd->flags & LPFC_SBUF_XBUSY)) {
 		freqpriv = nCmd->private;
 		freqpriv->nvme_buf = NULL;
-		lpfc_ncmd->nvmeCmd = NULL;
+		lpfc_ncmd->nvme.nvmeCmd = NULL;
 		spin_unlock(&lpfc_ncmd->buf_lock);
 		nCmd->done(nCmd);
 	} else
@@ -1239,7 +1239,7 @@ lpfc_nvme_prep_io_cmd(struct lpfc_vport *vport,
 		      struct lpfc_fc4_ctrl_stat *cstat)
 {
 	struct lpfc_hba *phba = vport->phba;
-	struct nvmefc_fcp_req *nCmd = lpfc_ncmd->nvmeCmd;
+	struct nvmefc_fcp_req *nCmd = lpfc_ncmd->nvme.nvmeCmd;
 	struct lpfc_iocbq *pwqeq = &(lpfc_ncmd->cur_iocbq);
 	union lpfc_wqe128 *wqe = &pwqeq->wqe;
 	uint32_t req_len;
@@ -1264,7 +1264,7 @@ lpfc_nvme_prep_io_cmd(struct lpfc_vport *vport,
 			/* Word 5 */
 			if ((phba->cfg_nvme_enable_fb) &&
 			    (pnode->nlp_flag & NLP_FIRSTBURST)) {
-				req_len = lpfc_ncmd->nvmeCmd->payload_length;
+				req_len = lpfc_ncmd->nvme.nvmeCmd->payload_length;
 				if (req_len < pnode->nvme_fb_size)
 					wqe->fcp_iwrite.initial_xfer_len =
 						req_len;
@@ -1346,7 +1346,7 @@ lpfc_nvme_prep_io_dma(struct lpfc_vport *vport,
 		      struct lpfc_io_buf *lpfc_ncmd)
 {
 	struct lpfc_hba *phba = vport->phba;
-	struct nvmefc_fcp_req *nCmd = lpfc_ncmd->nvmeCmd;
+	struct nvmefc_fcp_req *nCmd = lpfc_ncmd->nvme.nvmeCmd;
 	union lpfc_wqe128 *wqe = &lpfc_ncmd->cur_iocbq.wqe;
 	struct sli4_sge *sgl = lpfc_ncmd->dma_sgl;
 	struct sli4_hybrid_sgl *sgl_xtra = NULL;
@@ -1694,9 +1694,9 @@ lpfc_nvme_fcp_io_submit(struct nvme_fc_local_port *pnvme_lport,
 	 * an abort so inform the FW of the maximum IO pending time.
 	 */
 	freqpriv->nvme_buf = lpfc_ncmd;
-	lpfc_ncmd->nvmeCmd = pnvme_fcreq;
+	lpfc_ncmd->nvme.nvmeCmd = pnvme_fcreq;
 	lpfc_ncmd->ndlp = ndlp;
-	lpfc_ncmd->qidx = lpfc_queue_info->qidx;
+	lpfc_ncmd->nvme.qidx = lpfc_queue_info->qidx;
 
 	/*
 	 * Issue the IO on the WQ indicated by index in the hw_queue_handle.
@@ -1761,8 +1761,8 @@ lpfc_nvme_fcp_io_submit(struct nvme_fc_local_port *pnvme_lport,
 	return 0;
 
  out_free_nvme_buf:
-	if (lpfc_ncmd->nvmeCmd->sg_cnt) {
-		if (lpfc_ncmd->nvmeCmd->io_dir == NVMEFC_FCP_WRITE)
+	if (lpfc_ncmd->nvme.nvmeCmd->sg_cnt) {
+		if (lpfc_ncmd->nvme.nvmeCmd->io_dir == NVMEFC_FCP_WRITE)
 			cstat->output_requests--;
 		else
 			cstat->input_requests--;
@@ -1885,7 +1885,7 @@ lpfc_nvme_fcp_abort(struct nvme_fc_local_port *pnvme_lport,
 				 "6140 NVME IO req has no matching lpfc nvme "
 				 "io buffer.  Skipping abort req.\n");
 		return;
-	} else if (!lpfc_nbuf->nvmeCmd) {
+	} else if (!lpfc_nbuf->nvme.nvmeCmd) {
 		spin_unlock_irqrestore(&phba->hbalock, flags);
 		lpfc_printf_vlog(vport, KERN_ERR, LOG_NVME_ABTS,
 				 "6141 lpfc NVME IO req has no nvme_fcreq "
@@ -1904,12 +1904,12 @@ lpfc_nvme_fcp_abort(struct nvme_fc_local_port *pnvme_lport,
 	 * has already completed the NVME IO and the nvme transport
 	 * has not seen it yet.
 	 */
-	if (lpfc_nbuf->nvmeCmd != pnvme_fcreq) {
+	if (lpfc_nbuf->nvme.nvmeCmd != pnvme_fcreq) {
 		lpfc_printf_vlog(vport, KERN_ERR, LOG_NVME_ABTS,
 				 "6143 NVME req mismatch: "
 				 "lpfc_nbuf x%px nvmeCmd x%px, "
 				 "pnvme_fcreq x%px.  Skipping Abort xri x%x\n",
-				 lpfc_nbuf, lpfc_nbuf->nvmeCmd,
+				 lpfc_nbuf, lpfc_nbuf->nvme.nvmeCmd,
 				 pnvme_fcreq, nvmereq_wqe->sli4_xritag);
 		goto out_unlock;
 	}
@@ -2655,17 +2655,17 @@ lpfc_sli4_nvme_xri_aborted(struct lpfc_hba *phba,
 	lpfc_printf_log(phba, KERN_INFO, LOG_NVME_ABTS,
 			"6311 nvme_cmd %p xri x%x tag x%x abort complete and "
 			"xri released\n",
-			lpfc_ncmd->nvmeCmd, xri,
+			lpfc_ncmd->nvme.nvmeCmd, xri,
 			lpfc_ncmd->cur_iocbq.iotag);
 
 	/* Aborted NVME commands are required to not complete
 	 * before the abort exchange command fully completes.
 	 * Once completed, it is available via the put list.
 	 */
-	if (lpfc_ncmd->nvmeCmd) {
-		nvme_cmd = lpfc_ncmd->nvmeCmd;
+	if (lpfc_ncmd->nvme.nvmeCmd) {
+		nvme_cmd = lpfc_ncmd->nvme.nvmeCmd;
 		nvme_cmd->done(nvme_cmd);
-		lpfc_ncmd->nvmeCmd = NULL;
+		lpfc_ncmd->nvme.nvmeCmd = NULL;
 	}
 	lpfc_release_nvme_buf(phba, lpfc_ncmd);
 }
@@ -2738,13 +2738,13 @@ lpfc_nvme_cancel_iocb(struct lpfc_hba *phba, struct lpfc_iocbq *pwqeIn)
 	lpfc_ncmd = (struct lpfc_io_buf *)pwqeIn->context1;
 
 	spin_lock(&lpfc_ncmd->buf_lock);
-	if (!lpfc_ncmd->nvmeCmd) {
+	if (!lpfc_ncmd->nvme.nvmeCmd) {
 		spin_unlock(&lpfc_ncmd->buf_lock);
 		lpfc_release_nvme_buf(phba, lpfc_ncmd);
 		return;
 	}
 
-	nCmd = lpfc_ncmd->nvmeCmd;
+	nCmd = lpfc_ncmd->nvme.nvmeCmd;
 	lpfc_printf_log(phba, KERN_INFO, LOG_NVME_IOERR,
 			"6194 NVME Cancel xri %x\n",
 			lpfc_ncmd->cur_iocbq.sli4_xritag);
@@ -2754,7 +2754,7 @@ lpfc_nvme_cancel_iocb(struct lpfc_hba *phba, struct lpfc_iocbq *pwqeIn)
 	nCmd->status = NVME_SC_INTERNAL;
 	freqpriv = nCmd->private;
 	freqpriv->nvme_buf = NULL;
-	lpfc_ncmd->nvmeCmd = NULL;
+	lpfc_ncmd->nvme.nvmeCmd = NULL;
 
 	spin_unlock(&lpfc_ncmd->buf_lock);
 	nCmd->done(nCmd);
diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index 67b7a1aed45c..bb66dfb8dd71 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -146,7 +146,7 @@ lpfc_update_stats(struct lpfc_vport *vport, struct lpfc_io_buf *lpfc_cmd)
 	struct lpfc_hba *phba = vport->phba;
 	struct lpfc_rport_data *rdata;
 	struct lpfc_nodelist *pnode;
-	struct scsi_cmnd *cmd = lpfc_cmd->pCmd;
+	struct scsi_cmnd *cmd = lpfc_cmd->scsi.pCmd;
 	unsigned long flags;
 	struct Scsi_Host *shost = lpfc_shost_from_vport(vport);
 	unsigned long latency;
@@ -158,7 +158,7 @@ lpfc_update_stats(struct lpfc_vport *vport, struct lpfc_io_buf *lpfc_cmd)
 		return;
 
 	latency = jiffies_to_msecs((long)jiffies - (long)lpfc_cmd->start_time);
-	rdata = lpfc_cmd->rdata;
+	rdata = lpfc_cmd->scsi.rdata;
 	pnode = rdata->pnode;
 
 	spin_lock_irqsave(shost->host_lock, flags);
@@ -377,8 +377,8 @@ lpfc_new_scsi_buf_s3(struct lpfc_vport *vport, int num_to_alloc)
 		}
 		psb->cur_iocbq.iocb_flag |= LPFC_IO_FCP;
 
-		psb->fcp_cmnd = psb->data;
-		psb->fcp_rsp = psb->data + sizeof(struct fcp_cmnd);
+		psb->scsi.fcp_cmnd = psb->data;
+		psb->scsi.fcp_rsp = psb->data + sizeof(struct fcp_cmnd);
 		psb->dma_sgl = psb->data + sizeof(struct fcp_cmnd) +
 			sizeof(struct fcp_rsp);
 
@@ -484,9 +484,9 @@ lpfc_sli4_vport_delete_fcp_xri_aborted(struct lpfc_vport *vport)
 			if (psb->cur_iocbq.iocb_flag == LPFC_IO_NVME)
 				continue;
 
-			if (psb->rdata && psb->rdata->pnode &&
-			    psb->rdata->pnode->vport == vport)
-				psb->rdata = NULL;
+			if (psb->scsi.rdata && psb->scsi.rdata->pnode &&
+			    psb->scsi.rdata->pnode->vport == vport)
+				psb->scsi.rdata = NULL;
 		}
 		spin_unlock(&qp->abts_io_buf_list_lock);
 	}
@@ -538,8 +538,8 @@ lpfc_sli4_io_xri_aborted(struct lpfc_hba *phba,
 			qp->abts_scsi_io_bufs--;
 			spin_unlock(&qp->abts_io_buf_list_lock);
 
-			if (psb->rdata && psb->rdata->pnode)
-				ndlp = psb->rdata->pnode;
+			if (psb->scsi.rdata && psb->scsi.rdata->pnode)
+				ndlp = psb->scsi.rdata->pnode;
 			else
 				ndlp = NULL;
 
@@ -660,22 +660,22 @@ lpfc_get_scsi_buf_s4(struct lpfc_hba *phba, struct lpfc_nodelist *ndlp,
 	 * if other protocols used this buffer.
 	 */
 	lpfc_cmd->cur_iocbq.iocb_flag = LPFC_IO_FCP;
-	lpfc_cmd->prot_seg_cnt = 0;
+	lpfc_cmd->scsi.prot_seg_cnt = 0;
 	lpfc_cmd->seg_cnt = 0;
 	lpfc_cmd->timeout = 0;
 	lpfc_cmd->flags = 0;
 	lpfc_cmd->start_time = jiffies;
-	lpfc_cmd->waitq = NULL;
+	lpfc_cmd->scsi.waitq = NULL;
 	lpfc_cmd->cpu = cpu;
 #ifdef CONFIG_SCSI_LPFC_DEBUG_FS
-	lpfc_cmd->prot_data_type = 0;
+	lpfc_cmd->scsi.prot_data_type = 0;
 #endif
 	tmp = lpfc_get_cmd_rsp_buf_per_hdwq(phba, lpfc_cmd);
 	if (!tmp)
 		return NULL;
 
-	lpfc_cmd->fcp_cmnd = tmp->fcp_cmnd;
-	lpfc_cmd->fcp_rsp = tmp->fcp_rsp;
+	lpfc_cmd->scsi.fcp_cmnd = tmp->fcp_cmnd;
+	lpfc_cmd->scsi.fcp_rsp = tmp->fcp_rsp;
 
 	/*
 	 * The first two SGEs are the FCP_CMD and FCP_RSP.
@@ -757,10 +757,10 @@ lpfc_release_scsi_buf_s3(struct lpfc_hba *phba, struct lpfc_io_buf *psb)
 	unsigned long iflag = 0;
 
 	psb->seg_cnt = 0;
-	psb->prot_seg_cnt = 0;
+	psb->scsi.prot_seg_cnt = 0;
 
 	spin_lock_irqsave(&phba->scsi_buf_list_put_lock, iflag);
-	psb->pCmd = NULL;
+	psb->scsi.pCmd = NULL;
 	psb->cur_iocbq.iocb_flag = LPFC_IO_FCP;
 	list_add_tail(&psb->list, &phba->lpfc_scsi_buf_list_put);
 	spin_unlock_irqrestore(&phba->scsi_buf_list_put_lock, iflag);
@@ -783,12 +783,12 @@ lpfc_release_scsi_buf_s4(struct lpfc_hba *phba, struct lpfc_io_buf *psb)
 	unsigned long iflag = 0;
 
 	psb->seg_cnt = 0;
-	psb->prot_seg_cnt = 0;
+	psb->scsi.prot_seg_cnt = 0;
 
 	qp = psb->hdwq;
 	if (psb->exch_busy) {
 		spin_lock_irqsave(&qp->abts_io_buf_list_lock, iflag);
-		psb->pCmd = NULL;
+		psb->scsi.pCmd = NULL;
 		list_add_tail(&psb->list, &qp->lpfc_abts_io_buf_list);
 		qp->abts_scsi_io_bufs++;
 		spin_unlock_irqrestore(&qp->abts_io_buf_list_lock, iflag);
@@ -832,9 +832,9 @@ lpfc_release_scsi_buf(struct lpfc_hba *phba, struct lpfc_io_buf *psb)
 static int
 lpfc_scsi_prep_dma_buf_s3(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd)
 {
-	struct scsi_cmnd *scsi_cmnd = lpfc_cmd->pCmd;
+	struct scsi_cmnd *scsi_cmnd = lpfc_cmd->scsi.pCmd;
 	struct scatterlist *sgel = NULL;
-	struct fcp_cmnd *fcp_cmnd = lpfc_cmd->fcp_cmnd;
+	struct fcp_cmnd *fcp_cmnd = lpfc_cmd->scsi.fcp_cmnd;
 	struct ulp_bde64 *bpl = (struct ulp_bde64 *)lpfc_cmd->dma_sgl;
 	struct lpfc_iocbq *iocbq = &lpfc_cmd->cur_iocbq;
 	IOCB_t *iocb_cmd = &lpfc_cmd->cur_iocbq.iocb;
@@ -1070,11 +1070,11 @@ lpfc_bg_err_inject(struct lpfc_hba *phba, struct scsi_cmnd *sc,
 					 * restore it on completion.
 					 */
 					if (lpfc_cmd) {
-						lpfc_cmd->prot_data_type =
+						lpfc_cmd->scsi.prot_data_type =
 							LPFC_INJERR_REFTAG;
-						lpfc_cmd->prot_data_segment =
+						lpfc_cmd->scsi.prot_data_segment =
 							src;
-						lpfc_cmd->prot_data =
+						lpfc_cmd->scsi.prot_data =
 							src->ref_tag;
 					}
 					src->ref_tag = cpu_to_be32(0xDEADBEEF);
@@ -1190,11 +1190,11 @@ lpfc_bg_err_inject(struct lpfc_hba *phba, struct scsi_cmnd *sc,
 					 * restore it on completion.
 					 */
 					if (lpfc_cmd) {
-						lpfc_cmd->prot_data_type =
+						lpfc_cmd->scsi.prot_data_type =
 							LPFC_INJERR_APPTAG;
-						lpfc_cmd->prot_data_segment =
+						lpfc_cmd->scsi.prot_data_segment =
 							src;
-						lpfc_cmd->prot_data =
+						lpfc_cmd->scsi.prot_data =
 							src->app_tag;
 					}
 					src->app_tag = cpu_to_be16(0xDEAD);
@@ -2473,7 +2473,7 @@ static int
 lpfc_bg_scsi_adjust_dl(struct lpfc_hba *phba,
 		       struct lpfc_io_buf *lpfc_cmd)
 {
-	struct scsi_cmnd *sc = lpfc_cmd->pCmd;
+	struct scsi_cmnd *sc = lpfc_cmd->scsi.pCmd;
 	int fcpdl;
 
 	fcpdl = scsi_bufflen(sc);
@@ -2516,8 +2516,8 @@ static int
 lpfc_bg_scsi_prep_dma_buf_s3(struct lpfc_hba *phba,
 		struct lpfc_io_buf *lpfc_cmd)
 {
-	struct scsi_cmnd *scsi_cmnd = lpfc_cmd->pCmd;
-	struct fcp_cmnd *fcp_cmnd = lpfc_cmd->fcp_cmnd;
+	struct scsi_cmnd *scsi_cmnd = lpfc_cmd->scsi.pCmd;
+	struct fcp_cmnd *fcp_cmnd = lpfc_cmd->scsi.fcp_cmnd;
 	struct ulp_bde64 *bpl = (struct ulp_bde64 *)lpfc_cmd->dma_sgl;
 	IOCB_t *iocb_cmd = &lpfc_cmd->cur_iocbq.iocb;
 	uint32_t num_bde = 0;
@@ -2588,13 +2588,13 @@ lpfc_bg_scsi_prep_dma_buf_s3(struct lpfc_hba *phba,
 				return 1;
 			}
 
-			lpfc_cmd->prot_seg_cnt = protsegcnt;
+			lpfc_cmd->scsi.prot_seg_cnt = protsegcnt;
 
 			/*
 			 * There is a minimun of 4 BPLs used for every
 			 * protection data segment.
 			 */
-			if ((lpfc_cmd->prot_seg_cnt * 4) >
+			if ((lpfc_cmd->scsi.prot_seg_cnt * 4) >
 			    (phba->cfg_total_seg_cnt - 2)) {
 				ret = 2;
 				goto err;
@@ -2654,7 +2654,7 @@ lpfc_bg_scsi_prep_dma_buf_s3(struct lpfc_hba *phba,
 err:
 	if (lpfc_cmd->seg_cnt)
 		scsi_dma_unmap(scsi_cmnd);
-	if (lpfc_cmd->prot_seg_cnt)
+	if (lpfc_cmd->scsi.prot_seg_cnt)
 		dma_unmap_sg(&phba->pcidev->dev, scsi_prot_sglist(scsi_cmnd),
 			     scsi_prot_sg_count(scsi_cmnd),
 			     scsi_cmnd->sc_data_direction);
@@ -2662,12 +2662,12 @@ lpfc_bg_scsi_prep_dma_buf_s3(struct lpfc_hba *phba,
 	lpfc_printf_log(phba, KERN_ERR, LOG_FCP,
 			"9023 Cannot setup S/G List for HBA"
 			"IO segs %d/%d BPL %d SCSI %d: %d %d\n",
-			lpfc_cmd->seg_cnt, lpfc_cmd->prot_seg_cnt,
+			lpfc_cmd->seg_cnt, lpfc_cmd->scsi.prot_seg_cnt,
 			phba->cfg_total_seg_cnt, phba->cfg_sg_seg_cnt,
 			prot_group_type, num_bde);
 
 	lpfc_cmd->seg_cnt = 0;
-	lpfc_cmd->prot_seg_cnt = 0;
+	lpfc_cmd->scsi.prot_seg_cnt = 0;
 	return ret;
 }
 
@@ -2710,7 +2710,7 @@ lpfc_calc_bg_err(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd)
 {
 	struct scatterlist *sgpe; /* s/g prot entry */
 	struct scatterlist *sgde; /* s/g data entry */
-	struct scsi_cmnd *cmd = lpfc_cmd->pCmd;
+	struct scsi_cmnd *cmd = lpfc_cmd->scsi.pCmd;
 	struct scsi_dif_tuple *src = NULL;
 	uint8_t *data_src = NULL;
 	uint16_t guard_tag;
@@ -2740,7 +2740,7 @@ lpfc_calc_bg_err(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd)
 
 	/* Setup a ptr to the protection data provided by the SCSI host */
 	sgpe = scsi_prot_sglist(cmd);
-	protsegcnt = lpfc_cmd->prot_seg_cnt;
+	protsegcnt = lpfc_cmd->scsi.prot_seg_cnt;
 
 	if (sgpe && protsegcnt) {
 
@@ -2894,7 +2894,7 @@ static int
 lpfc_parse_bg_err(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd,
 		  struct lpfc_iocbq *pIocbOut)
 {
-	struct scsi_cmnd *cmd = lpfc_cmd->pCmd;
+	struct scsi_cmnd *cmd = lpfc_cmd->scsi.pCmd;
 	struct sli3_bg_fields *bgf = &pIocbOut->iocb.unsli3.sli3_bg;
 	int ret = 0;
 	uint32_t bghm = bgf->bghm;
@@ -3041,9 +3041,9 @@ lpfc_parse_bg_err(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd,
 static int
 lpfc_scsi_prep_dma_buf_s4(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd)
 {
-	struct scsi_cmnd *scsi_cmnd = lpfc_cmd->pCmd;
+	struct scsi_cmnd *scsi_cmnd = lpfc_cmd->scsi.pCmd;
 	struct scatterlist *sgel = NULL;
-	struct fcp_cmnd *fcp_cmnd = lpfc_cmd->fcp_cmnd;
+	struct fcp_cmnd *fcp_cmnd = lpfc_cmd->scsi.fcp_cmnd;
 	struct sli4_sge *sgl = (struct sli4_sge *)lpfc_cmd->dma_sgl;
 	struct sli4_sge *first_data_sgl;
 	IOCB_t *iocb_cmd = &lpfc_cmd->cur_iocbq.iocb;
@@ -3254,8 +3254,8 @@ static int
 lpfc_bg_scsi_prep_dma_buf_s4(struct lpfc_hba *phba,
 		struct lpfc_io_buf *lpfc_cmd)
 {
-	struct scsi_cmnd *scsi_cmnd = lpfc_cmd->pCmd;
-	struct fcp_cmnd *fcp_cmnd = lpfc_cmd->fcp_cmnd;
+	struct scsi_cmnd *scsi_cmnd = lpfc_cmd->scsi.pCmd;
+	struct fcp_cmnd *fcp_cmnd = lpfc_cmd->scsi.fcp_cmnd;
 	struct sli4_sge *sgl = (struct sli4_sge *)(lpfc_cmd->dma_sgl);
 	IOCB_t *iocb_cmd = &lpfc_cmd->cur_iocbq.iocb;
 	uint32_t num_sge = 0;
@@ -3335,12 +3335,12 @@ lpfc_bg_scsi_prep_dma_buf_s4(struct lpfc_hba *phba,
 				return 1;
 			}
 
-			lpfc_cmd->prot_seg_cnt = protsegcnt;
+			lpfc_cmd->scsi.prot_seg_cnt = protsegcnt;
 			/*
 			 * There is a minimun of 3 SGEs used for every
 			 * protection data segment.
 			 */
-			if (((lpfc_cmd->prot_seg_cnt * 3) >
+			if (((lpfc_cmd->scsi.prot_seg_cnt * 3) >
 					(phba->cfg_total_seg_cnt - 2)) &&
 			    !phba->cfg_xpsgl) {
 				ret = 2;
@@ -3415,7 +3415,7 @@ lpfc_bg_scsi_prep_dma_buf_s4(struct lpfc_hba *phba,
 err:
 	if (lpfc_cmd->seg_cnt)
 		scsi_dma_unmap(scsi_cmnd);
-	if (lpfc_cmd->prot_seg_cnt)
+	if (lpfc_cmd->scsi.prot_seg_cnt)
 		dma_unmap_sg(&phba->pcidev->dev, scsi_prot_sglist(scsi_cmnd),
 			     scsi_prot_sg_count(scsi_cmnd),
 			     scsi_cmnd->sc_data_direction);
@@ -3423,12 +3423,12 @@ lpfc_bg_scsi_prep_dma_buf_s4(struct lpfc_hba *phba,
 	lpfc_printf_log(phba, KERN_ERR, LOG_FCP,
 			"9084 Cannot setup S/G List for HBA"
 			"IO segs %d/%d SGL %d SCSI %d: %d %d\n",
-			lpfc_cmd->seg_cnt, lpfc_cmd->prot_seg_cnt,
+			lpfc_cmd->seg_cnt, lpfc_cmd->scsi.prot_seg_cnt,
 			phba->cfg_total_seg_cnt, phba->cfg_sg_seg_cnt,
 			prot_group_type, num_sge);
 
 	lpfc_cmd->seg_cnt = 0;
-	lpfc_cmd->prot_seg_cnt = 0;
+	lpfc_cmd->scsi.prot_seg_cnt = 0;
 	return ret;
 }
 
@@ -3482,13 +3482,13 @@ lpfc_bg_scsi_prep_dma_buf(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd)
 static void
 lpfc_send_scsi_error_event(struct lpfc_hba *phba, struct lpfc_vport *vport,
 		struct lpfc_io_buf *lpfc_cmd, struct lpfc_iocbq *rsp_iocb) {
-	struct scsi_cmnd *cmnd = lpfc_cmd->pCmd;
-	struct fcp_rsp *fcprsp = lpfc_cmd->fcp_rsp;
+	struct scsi_cmnd *cmnd = lpfc_cmd->scsi.pCmd;
+	struct fcp_rsp *fcprsp = lpfc_cmd->scsi.fcp_rsp;
 	uint32_t resp_info = fcprsp->rspStatus2;
 	uint32_t scsi_status = fcprsp->rspStatus3;
 	uint32_t fcpi_parm = rsp_iocb->iocb.un.fcpi.fcpi_parm;
 	struct lpfc_fast_path_event *fast_path_evt = NULL;
-	struct lpfc_nodelist *pnode = lpfc_cmd->rdata->pnode;
+	struct lpfc_nodelist *pnode = lpfc_cmd->scsi.rdata->pnode;
 	unsigned long flags;
 
 	if (!pnode || !NLP_CHK_NODE_ACT(pnode))
@@ -3582,11 +3582,11 @@ lpfc_scsi_unprep_dma_buf(struct lpfc_hba *phba, struct lpfc_io_buf *psb)
 	 * case, but it does not require resource deallocation.
 	 */
 	if (psb->seg_cnt > 0)
-		scsi_dma_unmap(psb->pCmd);
-	if (psb->prot_seg_cnt > 0)
-		dma_unmap_sg(&phba->pcidev->dev, scsi_prot_sglist(psb->pCmd),
-				scsi_prot_sg_count(psb->pCmd),
-				psb->pCmd->sc_data_direction);
+		scsi_dma_unmap(psb->scsi.pCmd);
+	if (psb->scsi.prot_seg_cnt > 0)
+		dma_unmap_sg(&phba->pcidev->dev, scsi_prot_sglist(psb->scsi.pCmd),
+				scsi_prot_sg_count(psb->scsi.pCmd),
+				psb->scsi.pCmd->sc_data_direction);
 }
 
 /**
@@ -3604,9 +3604,9 @@ lpfc_handle_fcp_err(struct lpfc_vport *vport, struct lpfc_io_buf *lpfc_cmd,
 		    struct lpfc_iocbq *rsp_iocb)
 {
 	struct lpfc_hba *phba = vport->phba;
-	struct scsi_cmnd *cmnd = lpfc_cmd->pCmd;
-	struct fcp_cmnd *fcpcmd = lpfc_cmd->fcp_cmnd;
-	struct fcp_rsp *fcprsp = lpfc_cmd->fcp_rsp;
+	struct scsi_cmnd *cmnd = lpfc_cmd->scsi.pCmd;
+	struct fcp_cmnd *fcpcmd = lpfc_cmd->scsi.fcp_cmnd;
+	struct fcp_rsp *fcprsp = lpfc_cmd->scsi.fcp_rsp;
 	uint32_t fcpi_parm = rsp_iocb->iocb.un.fcpi.fcpi_parm;
 	uint32_t resp_info = fcprsp->rspStatus2;
 	uint32_t scsi_status = fcprsp->rspStatus3;
@@ -3795,7 +3795,7 @@ lpfc_scsi_cmd_iocb_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *pIocbIn,
 	struct lpfc_io_buf *lpfc_cmd =
 		(struct lpfc_io_buf *) pIocbIn->context1;
 	struct lpfc_vport      *vport = pIocbIn->vport;
-	struct lpfc_rport_data *rdata = lpfc_cmd->rdata;
+	struct lpfc_rport_data *rdata = lpfc_cmd->scsi.rdata;
 	struct lpfc_nodelist *pnode = rdata->pnode;
 	struct scsi_cmnd *cmd;
 	unsigned long flags;
@@ -3811,7 +3811,7 @@ lpfc_scsi_cmd_iocb_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *pIocbIn,
 	spin_lock(&lpfc_cmd->buf_lock);
 
 	/* Sanity check on return of outstanding command */
-	cmd = lpfc_cmd->pCmd;
+	cmd = lpfc_cmd->scsi.pCmd;
 	if (!cmd || !phba) {
 		lpfc_printf_vlog(vport, KERN_ERR, LOG_INIT,
 				 "2621 IO completion: Not an active IO\n");
@@ -3838,34 +3838,34 @@ lpfc_scsi_cmd_iocb_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *pIocbIn,
 	lpfc_cmd->exch_busy = pIocbOut->iocb_flag & LPFC_EXCHANGE_BUSY;
 
 #ifdef CONFIG_SCSI_LPFC_DEBUG_FS
-	if (lpfc_cmd->prot_data_type) {
+	if (lpfc_cmd->scsi.prot_data_type) {
 		struct scsi_dif_tuple *src = NULL;
 
-		src =  (struct scsi_dif_tuple *)lpfc_cmd->prot_data_segment;
+		src =  (struct scsi_dif_tuple *)lpfc_cmd->scsi.prot_data_segment;
 		/*
 		 * Used to restore any changes to protection
 		 * data for error injection.
 		 */
-		switch (lpfc_cmd->prot_data_type) {
+		switch (lpfc_cmd->scsi.prot_data_type) {
 		case LPFC_INJERR_REFTAG:
 			src->ref_tag =
-				lpfc_cmd->prot_data;
+				lpfc_cmd->scsi.prot_data;
 			break;
 		case LPFC_INJERR_APPTAG:
 			src->app_tag =
-				(uint16_t)lpfc_cmd->prot_data;
+				(uint16_t)lpfc_cmd->scsi.prot_data;
 			break;
 		case LPFC_INJERR_GUARD:
 			src->guard_tag =
-				(uint16_t)lpfc_cmd->prot_data;
+				(uint16_t)lpfc_cmd->scsi.prot_data;
 			break;
 		default:
 			break;
 		}
 
-		lpfc_cmd->prot_data = 0;
-		lpfc_cmd->prot_data_type = 0;
-		lpfc_cmd->prot_data_segment = NULL;
+		lpfc_cmd->scsi.prot_data = 0;
+		lpfc_cmd->scsi.prot_data_type = 0;
+		lpfc_cmd->scsi.prot_data_segment = NULL;
 	}
 #endif
 
@@ -3876,8 +3876,8 @@ lpfc_scsi_cmd_iocb_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *pIocbIn,
 		else if (lpfc_cmd->status >= IOSTAT_CNT)
 			lpfc_cmd->status = IOSTAT_DEFAULT;
 		if (lpfc_cmd->status == IOSTAT_FCP_RSP_ERROR &&
-		    !lpfc_cmd->fcp_rsp->rspStatus3 &&
-		    (lpfc_cmd->fcp_rsp->rspStatus2 & RESID_UNDER) &&
+		    !lpfc_cmd->scsi.fcp_rsp->rspStatus3 &&
+		    (lpfc_cmd->scsi.fcp_rsp->rspStatus2 & RESID_UNDER) &&
 		    !(vport->cfg_log_verbose & LOG_FCP_UNDER))
 			logit = 0;
 		else
@@ -3991,7 +3991,7 @@ lpfc_scsi_cmd_iocb_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *pIocbIn,
 	} else
 		cmd->result = DID_OK << 16;
 
-	if (cmd->result || lpfc_cmd->fcp_rsp->rspSnsLen) {
+	if (cmd->result || lpfc_cmd->scsi.fcp_rsp->rspSnsLen) {
 		uint32_t *lp = (uint32_t *)cmd->sense_buffer;
 
 		lpfc_printf_vlog(vport, KERN_INFO, LOG_FCP,
@@ -4023,7 +4023,7 @@ lpfc_scsi_cmd_iocb_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *pIocbIn,
 	}
 	lpfc_scsi_unprep_dma_buf(phba, lpfc_cmd);
 
-	lpfc_cmd->pCmd = NULL;
+	lpfc_cmd->scsi.pCmd = NULL;
 	spin_unlock(&lpfc_cmd->buf_lock);
 
 	/* The sdev is not guaranteed to be valid post scsi_done upcall. */
@@ -4035,8 +4035,8 @@ lpfc_scsi_cmd_iocb_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *pIocbIn,
 	 */
 	spin_lock(&lpfc_cmd->buf_lock);
 	lpfc_cmd->cur_iocbq.iocb_flag &= ~LPFC_DRIVER_ABORTED;
-	if (lpfc_cmd->waitq)
-		wake_up(lpfc_cmd->waitq);
+	if (lpfc_cmd->scsi.waitq)
+		wake_up(lpfc_cmd->scsi.waitq);
 	spin_unlock(&lpfc_cmd->buf_lock);
 
 	lpfc_release_scsi_buf(phba, lpfc_cmd);
@@ -4074,8 +4074,8 @@ lpfc_scsi_prep_cmnd(struct lpfc_vport *vport, struct lpfc_io_buf *lpfc_cmd,
 		    struct lpfc_nodelist *pnode)
 {
 	struct lpfc_hba *phba = vport->phba;
-	struct scsi_cmnd *scsi_cmnd = lpfc_cmd->pCmd;
-	struct fcp_cmnd *fcp_cmnd = lpfc_cmd->fcp_cmnd;
+	struct scsi_cmnd *scsi_cmnd = lpfc_cmd->scsi.pCmd;
+	struct fcp_cmnd *fcp_cmnd = lpfc_cmd->scsi.fcp_cmnd;
 	IOCB_t *iocb_cmd = &lpfc_cmd->cur_iocbq.iocb;
 	struct lpfc_iocbq *piocbq = &(lpfc_cmd->cur_iocbq);
 	struct lpfc_sli4_hdw_queue *hdwq = NULL;
@@ -4088,12 +4088,12 @@ lpfc_scsi_prep_cmnd(struct lpfc_vport *vport, struct lpfc_io_buf *lpfc_cmd,
 	if (!pnode || !NLP_CHK_NODE_ACT(pnode))
 		return;
 
-	lpfc_cmd->fcp_rsp->rspSnsLen = 0;
+	lpfc_cmd->scsi.fcp_rsp->rspSnsLen = 0;
 	/* clear task management bits */
-	lpfc_cmd->fcp_cmnd->fcpCntl2 = 0;
+	lpfc_cmd->scsi.fcp_cmnd->fcpCntl2 = 0;
 
-	int_to_scsilun(lpfc_cmd->pCmd->device->lun,
-			&lpfc_cmd->fcp_cmnd->fcp_lun);
+	int_to_scsilun(lpfc_cmd->scsi.pCmd->device->lun,
+			&lpfc_cmd->scsi.fcp_cmnd->fcp_lun);
 
 	ptr = &fcp_cmnd->fcpCdb[0];
 	memcpy(ptr, scsi_cmnd->cmnd, scsi_cmnd->cmd_len);
@@ -4193,7 +4193,7 @@ lpfc_scsi_prep_task_mgmt_cmd(struct lpfc_vport *vport,
 	struct lpfc_iocbq *piocbq;
 	IOCB_t *piocb;
 	struct fcp_cmnd *fcp_cmnd;
-	struct lpfc_rport_data *rdata = lpfc_cmd->rdata;
+	struct lpfc_rport_data *rdata = lpfc_cmd->scsi.rdata;
 	struct lpfc_nodelist *ndlp = rdata->pnode;
 
 	if (!ndlp || !NLP_CHK_NODE_ACT(ndlp) ||
@@ -4205,7 +4205,7 @@ lpfc_scsi_prep_task_mgmt_cmd(struct lpfc_vport *vport,
 
 	piocb = &piocbq->iocb;
 
-	fcp_cmnd = lpfc_cmd->fcp_cmnd;
+	fcp_cmnd = lpfc_cmd->scsi.fcp_cmnd;
 	/* Clear out any old data in the FCP command area */
 	memset(fcp_cmnd, 0, sizeof(struct fcp_cmnd));
 	int_to_scsilun(lun, &fcp_cmnd->fcp_lun);
@@ -4578,8 +4578,8 @@ lpfc_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *cmnd)
 	 * Store the midlayer's command structure for the completion phase
 	 * and complete the command initialization.
 	 */
-	lpfc_cmd->pCmd  = cmnd;
-	lpfc_cmd->rdata = rdata;
+	lpfc_cmd->scsi.pCmd  = cmnd;
+	lpfc_cmd->scsi.rdata = rdata;
 	lpfc_cmd->ndlp = ndlp;
 	cmnd->host_scribble = (unsigned char *)lpfc_cmd;
 
@@ -4668,7 +4668,7 @@ lpfc_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *cmnd)
 	idx = lpfc_cmd->hdwq_no;
 	lpfc_scsi_unprep_dma_buf(phba, lpfc_cmd);
 	if (phba->sli4_hba.hdwq) {
-		switch (lpfc_cmd->fcp_cmnd->fcpCntl3) {
+		switch (lpfc_cmd->scsi.fcp_cmnd->fcpCntl3) {
 		case WRITE_DATA:
 			phba->sli4_hba.hdwq[idx].scsi_cstat.output_requests--;
 			break;
@@ -4742,7 +4742,7 @@ lpfc_abort_handler(struct scsi_cmnd *cmnd)
 	/* Guard against IO completion being called at same time */
 	spin_lock(&lpfc_cmd->buf_lock);
 
-	if (!lpfc_cmd->pCmd) {
+	if (!lpfc_cmd->scsi.pCmd) {
 		lpfc_printf_vlog(vport, KERN_WARNING, LOG_FCP,
 			 "2873 SCSI Layer I/O Abort Request IO CMPL Status "
 			 "x%x ID %d LUN %llu\n",
@@ -4773,7 +4773,7 @@ lpfc_abort_handler(struct scsi_cmnd *cmnd)
 	 * already completed this command, but the midlayer did not
 	 * see the completion before the eh fired. Just return SUCCESS.
 	 */
-	if (lpfc_cmd->pCmd != cmnd) {
+	if (lpfc_cmd->scsi.pCmd != cmnd) {
 		lpfc_printf_vlog(vport, KERN_WARNING, LOG_FCP,
 			"3170 SCSI Layer abort requested I/O has been "
 			"completed by LLD.\n");
@@ -4833,7 +4833,7 @@ lpfc_abort_handler(struct scsi_cmnd *cmnd)
 
 	abtsiocb->iocb_cmpl = lpfc_sli_abort_fcp_cmpl;
 	abtsiocb->vport = vport;
-	lpfc_cmd->waitq = &waitq;
+	lpfc_cmd->scsi.waitq = &waitq;
 	if (phba->sli_rev == LPFC_SLI_REV4) {
 		/* Note: both hbalock and ring_lock must be set here */
 		ret_val = __lpfc_sli_issue_iocb(phba, pring_s4->ringno,
@@ -4849,7 +4849,7 @@ lpfc_abort_handler(struct scsi_cmnd *cmnd)
 	if (ret_val == IOCB_ERROR) {
 		/* Indicate the IO is not being aborted by the driver. */
 		iocb->iocb_flag &= ~LPFC_DRIVER_ABORTED;
-		lpfc_cmd->waitq = NULL;
+		lpfc_cmd->scsi.waitq = NULL;
 		spin_unlock(&lpfc_cmd->buf_lock);
 		lpfc_sli_release_iocbq(phba, abtsiocb);
 		ret = FAILED;
@@ -4865,12 +4865,12 @@ lpfc_abort_handler(struct scsi_cmnd *cmnd)
 wait_for_cmpl:
 	/* Wait for abort to complete */
 	wait_event_timeout(waitq,
-			  (lpfc_cmd->pCmd != cmnd),
+			  (lpfc_cmd->scsi.pCmd != cmnd),
 			   msecs_to_jiffies(2*vport->cfg_devloss_tmo*1000));
 
 	spin_lock(&lpfc_cmd->buf_lock);
 
-	if (lpfc_cmd->pCmd == cmnd) {
+	if (lpfc_cmd->scsi.pCmd == cmnd) {
 		ret = FAILED;
 		lpfc_printf_vlog(vport, KERN_ERR, LOG_FCP,
 				 "0748 abort handler timed out waiting "
@@ -4880,7 +4880,7 @@ lpfc_abort_handler(struct scsi_cmnd *cmnd)
 				 cmnd->device->id, cmnd->device->lun);
 	}
 
-	lpfc_cmd->waitq = NULL;
+	lpfc_cmd->scsi.waitq = NULL;
 
 	spin_unlock(&lpfc_cmd->buf_lock);
 	goto out;
@@ -4938,7 +4938,7 @@ lpfc_taskmgmt_name(uint8_t task_mgmt_cmd)
 static int
 lpfc_check_fcp_rsp(struct lpfc_vport *vport, struct lpfc_io_buf *lpfc_cmd)
 {
-	struct fcp_rsp *fcprsp = lpfc_cmd->fcp_rsp;
+	struct fcp_rsp *fcprsp = lpfc_cmd->scsi.fcp_rsp;
 	uint32_t rsp_info;
 	uint32_t rsp_len;
 	uint8_t  rsp_info_code;
@@ -5033,8 +5033,8 @@ lpfc_send_taskmgmt(struct lpfc_vport *vport, struct scsi_cmnd *cmnd,
 	if (lpfc_cmd == NULL)
 		return FAILED;
 	lpfc_cmd->timeout = phba->cfg_task_mgmt_tmo;
-	lpfc_cmd->rdata = rdata;
-	lpfc_cmd->pCmd = cmnd;
+	lpfc_cmd->scsi.rdata = rdata;
+	lpfc_cmd->scsi.pCmd = cmnd;
 	lpfc_cmd->ndlp = pnode;
 
 	status = lpfc_scsi_prep_task_mgmt_cmd(vport, lpfc_cmd, lun_id,
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 379c37451645..e5a3c8c7702c 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -1157,7 +1157,7 @@ __lpfc_sli_get_els_sglq(struct lpfc_hba *phba, struct lpfc_iocbq *piocbq)
 
 	if (piocbq->iocb_flag &  LPFC_IO_FCP) {
 		lpfc_cmd = (struct lpfc_io_buf *) piocbq->context1;
-		ndlp = lpfc_cmd->rdata->pnode;
+		ndlp = lpfc_cmd->scsi.rdata->pnode;
 	} else  if ((piocbq->iocb.ulpCommand == CMD_GEN_REQUEST64_CR) &&
 			!(piocbq->iocb_flag & LPFC_IO_LIBDFC)) {
 		ndlp = piocbq->context_un.ndlp;
@@ -9531,7 +9531,7 @@ lpfc_sli4_iocb2wqe(struct lpfc_hba *phba, struct lpfc_iocbq *iocbq,
 
 			lpfc_cmd = iocbq->context1;
 			sgl = (struct sli4_sge *)lpfc_cmd->dma_sgl;
-			fcp_cmnd = lpfc_cmd->fcp_cmnd;
+			fcp_cmnd = lpfc_cmd->scsi.fcp_cmnd;
 
 			/* Word 0-2 - FCP_CMND */
 			wqe->generic.bde.tus.f.bdeFlags =
@@ -9595,7 +9595,7 @@ lpfc_sli4_iocb2wqe(struct lpfc_hba *phba, struct lpfc_iocbq *iocbq,
 
 			lpfc_cmd = iocbq->context1;
 			sgl = (struct sli4_sge *)lpfc_cmd->dma_sgl;
-			fcp_cmnd = lpfc_cmd->fcp_cmnd;
+			fcp_cmnd = lpfc_cmd->scsi.fcp_cmnd;
 
 			/* Word 0-2 - FCP_CMND */
 			wqe->generic.bde.tus.f.bdeFlags =
@@ -9652,7 +9652,7 @@ lpfc_sli4_iocb2wqe(struct lpfc_hba *phba, struct lpfc_iocbq *iocbq,
 
 			lpfc_cmd = iocbq->context1;
 			sgl = (struct sli4_sge *)lpfc_cmd->dma_sgl;
-			fcp_cmnd = lpfc_cmd->fcp_cmnd;
+			fcp_cmnd = lpfc_cmd->scsi.fcp_cmnd;
 
 			/* Word 0-2 - FCP_CMND */
 			wqe->generic.bde.tus.f.bdeFlags =
@@ -11371,19 +11371,19 @@ lpfc_sli_validate_fcp_iocb(struct lpfc_iocbq *iocbq, struct lpfc_vport *vport,
 
 	lpfc_cmd = container_of(iocbq, struct lpfc_io_buf, cur_iocbq);
 
-	if (lpfc_cmd->pCmd == NULL)
+	if (lpfc_cmd->scsi.pCmd == NULL)
 		return rc;
 
 	switch (ctx_cmd) {
 	case LPFC_CTX_LUN:
-		if ((lpfc_cmd->rdata) && (lpfc_cmd->rdata->pnode) &&
-		    (lpfc_cmd->rdata->pnode->nlp_sid == tgt_id) &&
-		    (scsilun_to_int(&lpfc_cmd->fcp_cmnd->fcp_lun) == lun_id))
+		if ((lpfc_cmd->scsi.rdata) && (lpfc_cmd->scsi.rdata->pnode) &&
+		    (lpfc_cmd->scsi.rdata->pnode->nlp_sid == tgt_id) &&
+		    (scsilun_to_int(&lpfc_cmd->scsi.fcp_cmnd->fcp_lun) == lun_id))
 			rc = 0;
 		break;
 	case LPFC_CTX_TGT:
-		if ((lpfc_cmd->rdata) && (lpfc_cmd->rdata->pnode) &&
-		    (lpfc_cmd->rdata->pnode->nlp_sid == tgt_id))
+		if ((lpfc_cmd->scsi.rdata) && (lpfc_cmd->scsi.rdata->pnode) &&
+		    (lpfc_cmd->scsi.rdata->pnode->nlp_sid == tgt_id))
 			rc = 0;
 		break;
 	case LPFC_CTX_HOST:
@@ -11625,7 +11625,7 @@ lpfc_sli_abort_taskmgmt(struct lpfc_vport *vport, struct lpfc_sli_ring *pring,
 		lpfc_cmd = container_of(iocbq, struct lpfc_io_buf, cur_iocbq);
 		spin_lock(&lpfc_cmd->buf_lock);
 
-		if (!lpfc_cmd->pCmd) {
+		if (!lpfc_cmd->scsi.pCmd) {
 			spin_unlock(&lpfc_cmd->buf_lock);
 			continue;
 		}
@@ -11681,7 +11681,7 @@ lpfc_sli_abort_taskmgmt(struct lpfc_vport *vport, struct lpfc_sli_ring *pring,
 		if (iocbq->iocb_flag & LPFC_IO_FOF)
 			abtsiocbq->iocb_flag |= LPFC_IO_FOF;
 
-		ndlp = lpfc_cmd->rdata->pnode;
+		ndlp = lpfc_cmd->scsi.rdata->pnode;
 
 		if (lpfc_is_link_up(phba) &&
 		    (ndlp && ndlp->nlp_state == NLP_STE_MAPPED_NODE))
@@ -20132,7 +20132,7 @@ void lpfc_release_io_buf(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_ncmd,
 	u32 abts_io_bufs;
 
 	/* MUST zero fields if buffer is reused by another protocol */
-	lpfc_ncmd->nvmeCmd = NULL;
+	lpfc_ncmd->nvme.nvmeCmd = NULL;
 	lpfc_ncmd->cur_iocbq.wqe_cmpl = NULL;
 	lpfc_ncmd->cur_iocbq.iocb_cmpl = NULL;
 
diff --git a/drivers/scsi/lpfc/lpfc_sli.h b/drivers/scsi/lpfc/lpfc_sli.h
index 37fbcb46387e..f0c51288b10a 100644
--- a/drivers/scsi/lpfc/lpfc_sli.h
+++ b/drivers/scsi/lpfc/lpfc_sli.h
@@ -434,13 +434,13 @@ struct lpfc_io_buf {
 #define	LPFC_INJERR_APPTAG	2
 #define	LPFC_INJERR_GUARD	3
 #endif
-		};
+		} scsi;
 
 		/* NVME specific fields */
 		struct {
 			struct nvmefc_fcp_req *nvmeCmd;
 			uint16_t qidx;
-		};
+		} nvme;
 	};
 #ifdef CONFIG_SCSI_LPFC_DEBUG_FS
 	uint64_t ts_cmd_start;
-- 
2.16.4

