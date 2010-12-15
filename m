From: James Smart <james.smart@emulex.com>
Subject: [PATCH 1/5] lpfc 8.3.20: Critical fixes
Date: Wed, 15 Dec 2010 17:57:20 -0500
Message-ID: <1292453854.32478.25.camel@wookie>
Reply-To: james.smart@emulex.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exht1.emulex.com ([138.239.113.183]:15429 "EHLO
	exht1.ad.emulex.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755645Ab0LOW6M (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Dec 2010 17:58:12 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


- Use for iocbq->context1 to hold the ndlp pointer.
- Set ndlp in all iocbs generated from ioctl functions.
- Turn parity and serr bits back on after performing sli4 board reset.


 Signed-off-by: Alex Iannicelli <alex.iannicelli@emulex.com>
 Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_bsg.c |   40 +++++++++-------------------------------
 lpfc_sli.c |   22 ++++++++++++----------
 2 files changed, 21 insertions(+), 41 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_bsg.c b/drivers/scsi/lpfc/lpfc_bsg.c
--- a/drivers/scsi/lpfc/lpfc_bsg.c	2010-12-11 21:56:16.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_bsg.c	2010-12-15 13:03:21.000000000 -0500
@@ -162,7 +162,6 @@ lpfc_bsg_send_mgmt_cmd_cmp(struct lpfc_h
 			struct lpfc_iocbq *cmdiocbq,
 			struct lpfc_iocbq *rspiocbq)
 {
-	unsigned long iflags;
 	struct bsg_job_data *dd_data;
 	struct fc_bsg_job *job;
 	IOCB_t *rsp;
@@ -173,9 +172,10 @@ lpfc_bsg_send_mgmt_cmd_cmp(struct lpfc_h
 	int rc = 0;
 
 	spin_lock_irqsave(&phba->ct_ev_lock, flags);
-	dd_data = cmdiocbq->context1;
+	dd_data = cmdiocbq->context2;
 	if (!dd_data) {
 		spin_unlock_irqrestore(&phba->ct_ev_lock, flags);
+		lpfc_sli_release_iocbq(phba, cmdiocbq);
 		return;
 	}
 
@@ -183,17 +183,9 @@ lpfc_bsg_send_mgmt_cmd_cmp(struct lpfc_h
 	job = iocb->set_job;
 	job->dd_data = NULL; /* so timeout handler does not reply */
 
-	spin_lock_irqsave(&phba->hbalock, iflags);
-	cmdiocbq->iocb_flag |= LPFC_IO_WAKE;
-	if (cmdiocbq->context2 && rspiocbq)
-		memcpy(&((struct lpfc_iocbq *)cmdiocbq->context2)->iocb,
-		       &rspiocbq->iocb, sizeof(IOCB_t));
-	spin_unlock_irqrestore(&phba->hbalock, iflags);
-
 	bmp = iocb->bmp;
-	rspiocbq = iocb->rspiocbq;
 	rsp = &rspiocbq->iocb;
-	ndlp = iocb->ndlp;
+	ndlp = cmdiocbq->context1;
 
 	pci_unmap_sg(phba->pcidev, job->request_payload.sg_list,
 		     job->request_payload.sg_cnt, DMA_TO_DEVICE);
@@ -220,7 +212,6 @@ lpfc_bsg_send_mgmt_cmd_cmp(struct lpfc_h
 			rsp->un.genreq64.bdl.bdeSize;
 
 	lpfc_mbuf_free(phba, bmp->virt, bmp->phys);
-	lpfc_sli_release_iocbq(phba, rspiocbq);
 	lpfc_sli_release_iocbq(phba, cmdiocbq);
 	lpfc_nlp_put(ndlp);
 	kfree(bmp);
@@ -247,9 +238,7 @@ lpfc_bsg_send_mgmt_cmd(struct fc_bsg_job
 	struct ulp_bde64 *bpl = NULL;
 	uint32_t timeout;
 	struct lpfc_iocbq *cmdiocbq = NULL;
-	struct lpfc_iocbq *rspiocbq = NULL;
 	IOCB_t *cmd;
-	IOCB_t *rsp;
 	struct lpfc_dmabuf *bmp = NULL;
 	int request_nseg;
 	int reply_nseg;
@@ -296,17 +285,10 @@ lpfc_bsg_send_mgmt_cmd(struct fc_bsg_job
 	}
 
 	cmd = &cmdiocbq->iocb;
-	rspiocbq = lpfc_sli_get_iocbq(phba);
-	if (!rspiocbq) {
-		rc = -ENOMEM;
-		goto free_cmdiocbq;
-	}
-
-	rsp = &rspiocbq->iocb;
 	bmp->virt = lpfc_mbuf_alloc(phba, 0, &bmp->phys);
 	if (!bmp->virt) {
 		rc = -ENOMEM;
-		goto free_rspiocbq;
+		goto free_cmdiocbq;
 	}
 
 	INIT_LIST_HEAD(&bmp->list);
@@ -358,14 +340,12 @@ lpfc_bsg_send_mgmt_cmd(struct fc_bsg_job
 	cmd->ulpTimeout = timeout;
 
 	cmdiocbq->iocb_cmpl = lpfc_bsg_send_mgmt_cmd_cmp;
-	cmdiocbq->context1 = dd_data;
-	cmdiocbq->context2 = rspiocbq;
+	cmdiocbq->context1 = ndlp;
+	cmdiocbq->context2 = dd_data;
 	dd_data->type = TYPE_IOCB;
 	dd_data->context_un.iocb.cmdiocbq = cmdiocbq;
-	dd_data->context_un.iocb.rspiocbq = rspiocbq;
 	dd_data->context_un.iocb.set_job = job;
 	dd_data->context_un.iocb.bmp = bmp;
-	dd_data->context_un.iocb.ndlp = ndlp;
 
 	if (phba->cfg_poll & DISABLE_FCP_RING_INT) {
 		creg_val = readl(phba->HCregaddr);
@@ -391,8 +371,6 @@ lpfc_bsg_send_mgmt_cmd(struct fc_bsg_job
 
 	lpfc_mbuf_free(phba, bmp->virt, bmp->phys);
 
-free_rspiocbq:
-	lpfc_sli_release_iocbq(phba, rspiocbq);
 free_cmdiocbq:
 	lpfc_sli_release_iocbq(phba, cmdiocbq);
 free_bmp:
@@ -1220,7 +1198,7 @@ lpfc_issue_ct_rsp_cmp(struct lpfc_hba *p
 	int rc = 0;
 
 	spin_lock_irqsave(&phba->ct_ev_lock, flags);
-	dd_data = cmdiocbq->context1;
+	dd_data = cmdiocbq->context2;
 	/* normal completion and timeout crossed paths, already done */
 	if (!dd_data) {
 		spin_unlock_irqrestore(&phba->ct_ev_lock, flags);
@@ -1369,8 +1347,8 @@ lpfc_issue_ct_rsp(struct lpfc_hba *phba,
 	ctiocb->context3 = bmp;
 
 	ctiocb->iocb_cmpl = lpfc_issue_ct_rsp_cmp;
-	ctiocb->context1 = dd_data;
-	ctiocb->context2 = NULL;
+	ctiocb->context2 = dd_data;
+	ctiocb->context1 = ndlp;
 	dd_data->type = TYPE_IOCB;
 	dd_data->context_un.iocb.cmdiocbq = ctiocb;
 	dd_data->context_un.iocb.rspiocbq = NULL;
diff -upNr a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
--- a/drivers/scsi/lpfc/lpfc_sli.c	2010-12-11 21:56:16.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_sli.c	2010-12-15 13:03:21.000000000 -0500
@@ -871,11 +871,9 @@ __lpfc_sli_get_sglq(struct lpfc_hba *phb
 	if (piocbq->iocb_flag &  LPFC_IO_FCP) {
 		lpfc_cmd = (struct lpfc_scsi_buf *) piocbq->context1;
 		ndlp = lpfc_cmd->rdata->pnode;
-	} else  if (piocbq->iocb.ulpCommand == CMD_GEN_REQUEST64_CR)
+	} else  if ((piocbq->iocb.ulpCommand == CMD_GEN_REQUEST64_CR) &&
+			!(piocbq->iocb_flag & LPFC_IO_LIBDFC))
 		ndlp = piocbq->context_un.ndlp;
-	else if (piocbq->iocb.ulpCommand == CMD_XMIT_BLS_RSP64_CX)
-		ndlp = lpfc_findnode_did(piocbq->vport,
-					piocbq->iocb.ulpContext);
 	else
 		ndlp = piocbq->context1;
 
@@ -3855,12 +3853,6 @@ lpfc_sli4_brdreset(struct lpfc_hba *phba
 	phba->pport->fc_myDID = 0;
 	phba->pport->fc_prevDID = 0;
 
-	/* Turn off parity checking and serr during the physical reset */
-	pci_read_config_word(phba->pcidev, PCI_COMMAND, &cfg_value);
-	pci_write_config_word(phba->pcidev, PCI_COMMAND,
-			      (cfg_value &
-			      ~(PCI_COMMAND_PARITY | PCI_COMMAND_SERR)));
-
 	spin_lock_irq(&phba->hbalock);
 	psli->sli_flag &= ~(LPFC_PROCESS_LA);
 	phba->fcf.fcf_flag = 0;
@@ -3880,9 +3872,18 @@ lpfc_sli4_brdreset(struct lpfc_hba *phba
 	/* Now physically reset the device */
 	lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
 			"0389 Performing PCI function reset!\n");
+
+	/* Turn off parity checking and serr during the physical reset */
+	pci_read_config_word(phba->pcidev, PCI_COMMAND, &cfg_value);
+	pci_write_config_word(phba->pcidev, PCI_COMMAND, (cfg_value &
+			      ~(PCI_COMMAND_PARITY | PCI_COMMAND_SERR)));
+
 	/* Perform FCoE PCI function reset */
 	lpfc_pci_function_reset(phba);
 
+	/* Restore PCI cmd register */
+	pci_write_config_word(phba->pcidev, PCI_COMMAND, cfg_value);
+
 	return 0;
 }
 
@@ -11969,6 +11970,7 @@ lpfc_sli4_seq_abort_acc(struct lpfc_hba 
 	icmd->ulpLe = 1;
 	icmd->ulpClass = CLASS3;
 	icmd->ulpContext = ndlp->nlp_rpi;
+	ctiocb->context1 = ndlp;
 
 	ctiocb->iocb_cmpl = NULL;
 	ctiocb->vport = phba->pport;


