From: James Smart <james.smart@emulex.com>
Subject: [PATCH 6/8] lpfc 8.3.8: (BSG3) Modify BSG commands to operate
 asynchronously
Date: Tue, 26 Jan 2010 23:09:48 -0500
Message-ID: <1264565408.2972.6.camel@wookie>
Reply-To: james.smart@emulex.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exht1.emulex.com ([138.239.113.183]:39332 "EHLO
	exht1.ad.emulex.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753137Ab0A0EK2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Jan 2010 23:10:28 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Modify the following BSG commands to operate asynchronously.
- FC_BSG_RPT_ELS
- FC_BSG_RPT_CT
- LPFC_BSG_VENDOR_GET_CT_EVENT
- LPFC_BSG_VENDOR_SET_CT_EVENT


 Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_bsg.c |  863 +++++++++++++++++++++++++++++++++++++++++--------------------
 1 file changed, 592 insertions(+), 271 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_bsg.c b/drivers/scsi/lpfc/lpfc_bsg.c
--- a/drivers/scsi/lpfc/lpfc_bsg.c	2010-01-22 21:38:34.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_bsg.c	2010-01-22 21:39:33.000000000 -0500
@@ -42,14 +42,169 @@
 #include "lpfc_vport.h"
 #include "lpfc_version.h"
 
+struct lpfc_bsg_event {
+	struct list_head node;
+	struct kref kref;
+	wait_queue_head_t wq;
+
+	/* Event type and waiter identifiers */
+	uint32_t type_mask;
+	uint32_t req_id;
+	uint32_t reg_id;
+
+	/* next two flags are here for the auto-delete logic */
+	unsigned long wait_time_stamp;
+	int waiting;
+
+	/* seen and not seen events */
+	struct list_head events_to_get;
+	struct list_head events_to_see;
+
+	/* job waiting for this event to finish */
+	struct fc_bsg_job *set_job;
+};
+
+struct lpfc_bsg_iocb {
+	struct lpfc_iocbq *cmdiocbq;
+	struct lpfc_iocbq *rspiocbq;
+	struct lpfc_dmabuf *bmp;
+	struct lpfc_nodelist *ndlp;
+
+	/* job waiting for this iocb to finish */
+	struct fc_bsg_job *set_job;
+};
+
+#define TYPE_EVT 	1
+#define TYPE_IOCB	2
+struct bsg_job_data {
+	uint32_t type;
+	union {
+		struct lpfc_bsg_event *evt;
+		struct lpfc_bsg_iocb iocb;
+	} context_un;
+};
+
+struct event_data {
+	struct list_head node;
+	uint32_t type;
+	uint32_t immed_dat;
+	void *data;
+	uint32_t len;
+};
+
+#define SLI_CT_ELX_LOOPBACK 0x10
+
+enum ELX_LOOPBACK_CMD {
+	ELX_LOOPBACK_XRI_SETUP,
+	ELX_LOOPBACK_DATA,
+};
+
+struct lpfc_dmabufext {
+	struct lpfc_dmabuf dma;
+	uint32_t size;
+	uint32_t flag;
+};
+
+/**
+ * lpfc_bsg_send_mgmt_cmd_cmp - lpfc_bsg_send_mgmt_cmd's completion handler
+ * @phba: Pointer to HBA context object.
+ * @cmdiocbq: Pointer to command iocb.
+ * @rspiocbq: Pointer to response iocb.
+ *
+ * This function is the completion handler for iocbs issued using
+ * lpfc_bsg_send_mgmt_cmd function. This function is called by the
+ * ring event handler function without any lock held. This function
+ * can be called from both worker thread context and interrupt
+ * context. This function also can be called from another thread which
+ * cleans up the SLI layer objects.
+ * This function copies the contents of the response iocb to the
+ * response iocb memory object provided by the caller of
+ * lpfc_sli_issue_iocb_wait and then wakes up the thread which
+ * sleeps for the iocb completion.
+ **/
+static void
+lpfc_bsg_send_mgmt_cmd_cmp(struct lpfc_hba *phba,
+			struct lpfc_iocbq *cmdiocbq,
+			struct lpfc_iocbq *rspiocbq)
+{
+	unsigned long iflags;
+	struct bsg_job_data *dd_data;
+	struct fc_bsg_job *job;
+	IOCB_t *rsp;
+	struct lpfc_dmabuf *bmp;
+	struct lpfc_nodelist *ndlp;
+	struct lpfc_bsg_iocb *iocb;
+	unsigned long flags;
+	int rc = 0;
+
+	spin_lock_irqsave(&phba->ct_ev_lock, flags);
+	dd_data = cmdiocbq->context1;
+	if (!dd_data) {
+		spin_unlock_irqrestore(&phba->ct_ev_lock, flags);
+		return;
+	}
+
+	iocb = &dd_data->context_un.iocb;
+	job = iocb->set_job;
+	job->dd_data = NULL; /* so timeout handler does not reply */
+
+	spin_lock_irqsave(&phba->hbalock, iflags);
+	cmdiocbq->iocb_flag |= LPFC_IO_WAKE;
+	if (cmdiocbq->context2 && rspiocbq)
+		memcpy(&((struct lpfc_iocbq *)cmdiocbq->context2)->iocb,
+		       &rspiocbq->iocb, sizeof(IOCB_t));
+	spin_unlock_irqrestore(&phba->hbalock, iflags);
+
+	bmp = iocb->bmp;
+	rspiocbq = iocb->rspiocbq;
+	rsp = &rspiocbq->iocb;
+	ndlp = iocb->ndlp;
+
+	pci_unmap_sg(phba->pcidev, job->request_payload.sg_list,
+		     job->request_payload.sg_cnt, DMA_TO_DEVICE);
+	pci_unmap_sg(phba->pcidev, job->reply_payload.sg_list,
+		     job->reply_payload.sg_cnt, DMA_FROM_DEVICE);
+
+	if (rsp->ulpStatus) {
+		if (rsp->ulpStatus == IOSTAT_LOCAL_REJECT) {
+			switch (rsp->un.ulpWord[4] & 0xff) {
+			case IOERR_SEQUENCE_TIMEOUT:
+				rc = -ETIMEDOUT;
+				break;
+			case IOERR_INVALID_RPI:
+				rc = -EFAULT;
+				break;
+			default:
+				rc = -EACCES;
+				break;
+			}
+		} else
+			rc = -EACCES;
+	} else
+		job->reply->reply_payload_rcv_len =
+			rsp->un.genreq64.bdl.bdeSize;
+
+	lpfc_mbuf_free(phba, bmp->virt, bmp->phys);
+	lpfc_sli_release_iocbq(phba, rspiocbq);
+	lpfc_sli_release_iocbq(phba, cmdiocbq);
+	lpfc_nlp_put(ndlp);
+	kfree(bmp);
+	kfree(dd_data);
+	/* make error code available to userspace */
+	job->reply->result = rc;
+	/* complete the job back to userspace */
+	job->job_done(job);
+	spin_unlock_irqrestore(&phba->ct_ev_lock, flags);
+	return;
+}
+
 /**
- * lpfc_bsg_rport_ct - send a CT command from a bsg request
+ * lpfc_bsg_send_mgmt_cmd - send a CT command from a bsg request
  * @job: fc_bsg_job to handle
  */
 static int
-lpfc_bsg_rport_ct(struct fc_bsg_job *job)
+lpfc_bsg_send_mgmt_cmd(struct fc_bsg_job *job)
 {
-	struct Scsi_Host *shost = job->shost;
 	struct lpfc_vport *vport = (struct lpfc_vport *)job->shost->hostdata;
 	struct lpfc_hba *phba = vport->phba;
 	struct lpfc_rport_data *rdata = job->rport->dd_data;
@@ -66,57 +221,60 @@ lpfc_bsg_rport_ct(struct fc_bsg_job *job
 	struct scatterlist *sgel = NULL;
 	int numbde;
 	dma_addr_t busaddr;
+	struct bsg_job_data *dd_data;
+	uint32_t creg_val;
 	int rc = 0;
 
 	/* in case no data is transferred */
 	job->reply->reply_payload_rcv_len = 0;
 
+	/* allocate our bsg tracking structure */
+	dd_data = kmalloc(sizeof(struct bsg_job_data), GFP_KERNEL);
+	if (!dd_data) {
+		lpfc_printf_log(phba, KERN_WARNING, LOG_LIBDFC,
+				"2733 Failed allocation of dd_data\n");
+		rc = -ENOMEM;
+		goto no_dd_data;
+	}
+
 	if (!lpfc_nlp_get(ndlp)) {
-		job->reply->result = -ENODEV;
-		return 0;
+		rc = -ENODEV;
+		goto no_ndlp;
+	}
+
+	bmp = kmalloc(sizeof(struct lpfc_dmabuf), GFP_KERNEL);
+	if (!bmp) {
+		rc = -ENOMEM;
+		goto free_ndlp;
 	}
 
 	if (ndlp->nlp_flag & NLP_ELS_SND_MASK) {
 		rc = -ENODEV;
-		goto free_ndlp_exit;
+		goto free_bmp;
 	}
 
-	spin_lock_irq(shost->host_lock);
 	cmdiocbq = lpfc_sli_get_iocbq(phba);
 	if (!cmdiocbq) {
 		rc = -ENOMEM;
-		spin_unlock_irq(shost->host_lock);
-		goto free_ndlp_exit;
+		goto free_bmp;
 	}
-	cmd = &cmdiocbq->iocb;
 
+	cmd = &cmdiocbq->iocb;
 	rspiocbq = lpfc_sli_get_iocbq(phba);
 	if (!rspiocbq) {
 		rc = -ENOMEM;
 		goto free_cmdiocbq;
 	}
-	spin_unlock_irq(shost->host_lock);
 
 	rsp = &rspiocbq->iocb;
-
-	bmp = kmalloc(sizeof(struct lpfc_dmabuf), GFP_KERNEL);
-	if (!bmp) {
-		rc = -ENOMEM;
-		spin_lock_irq(shost->host_lock);
-		goto free_rspiocbq;
-	}
-
-	spin_lock_irq(shost->host_lock);
 	bmp->virt = lpfc_mbuf_alloc(phba, 0, &bmp->phys);
 	if (!bmp->virt) {
 		rc = -ENOMEM;
-		goto free_bmp;
+		goto free_rspiocbq;
 	}
-	spin_unlock_irq(shost->host_lock);
 
 	INIT_LIST_HEAD(&bmp->list);
 	bpl = (struct ulp_bde64 *) bmp->virt;
-
 	request_nseg = pci_map_sg(phba->pcidev, job->request_payload.sg_list,
 				  job->request_payload.sg_cnt, DMA_TO_DEVICE);
 	for_each_sg(job->request_payload.sg_list, sgel, request_nseg, numbde) {
@@ -158,72 +316,146 @@ lpfc_bsg_rport_ct(struct fc_bsg_job *job
 	cmd->ulpContext = ndlp->nlp_rpi;
 	cmd->ulpOwner = OWN_CHIP;
 	cmdiocbq->vport = phba->pport;
-	cmdiocbq->context1 = NULL;
-	cmdiocbq->context2 = NULL;
+	cmdiocbq->context3 = bmp;
 	cmdiocbq->iocb_flag |= LPFC_IO_LIBDFC;
-
 	timeout = phba->fc_ratov * 2;
-	job->dd_data = cmdiocbq;
+	cmd->ulpTimeout = timeout;
 
-	rc = lpfc_sli_issue_iocb_wait(phba, LPFC_ELS_RING, cmdiocbq, rspiocbq,
-					timeout + LPFC_DRVR_TIMEOUT);
+	cmdiocbq->iocb_cmpl = lpfc_bsg_send_mgmt_cmd_cmp;
+	cmdiocbq->context1 = dd_data;
+	cmdiocbq->context2 = rspiocbq;
+	dd_data->type = TYPE_IOCB;
+	dd_data->context_un.iocb.cmdiocbq = cmdiocbq;
+	dd_data->context_un.iocb.rspiocbq = rspiocbq;
+	dd_data->context_un.iocb.set_job = job;
+	dd_data->context_un.iocb.bmp = bmp;
+	dd_data->context_un.iocb.ndlp = ndlp;
+
+	if (phba->cfg_poll & DISABLE_FCP_RING_INT) {
+		creg_val = readl(phba->HCregaddr);
+		creg_val |= (HC_R0INT_ENA << LPFC_FCP_RING);
+		writel(creg_val, phba->HCregaddr);
+		readl(phba->HCregaddr); /* flush */
+	}
+
+	rc = lpfc_sli_issue_iocb(phba, LPFC_ELS_RING, cmdiocbq, 0);
+
+	if (rc == IOCB_SUCCESS)
+		return 0; /* done for now */
+
+	/* iocb failed so cleanup */
+	pci_unmap_sg(phba->pcidev, job->request_payload.sg_list,
+		     job->request_payload.sg_cnt, DMA_TO_DEVICE);
+	pci_unmap_sg(phba->pcidev, job->reply_payload.sg_list,
+		     job->reply_payload.sg_cnt, DMA_FROM_DEVICE);
 
-	if (rc != IOCB_TIMEDOUT) {
-		pci_unmap_sg(phba->pcidev, job->request_payload.sg_list,
-			     job->request_payload.sg_cnt, DMA_TO_DEVICE);
-		pci_unmap_sg(phba->pcidev, job->reply_payload.sg_list,
-			     job->reply_payload.sg_cnt, DMA_FROM_DEVICE);
-	}
+	lpfc_mbuf_free(phba, bmp->virt, bmp->phys);
 
-	if (rc == IOCB_TIMEDOUT) {
-		lpfc_sli_release_iocbq(phba, rspiocbq);
-		rc = -EACCES;
-		goto free_ndlp_exit;
-	}
+free_rspiocbq:
+	lpfc_sli_release_iocbq(phba, rspiocbq);
+free_cmdiocbq:
+	lpfc_sli_release_iocbq(phba, cmdiocbq);
+free_bmp:
+	kfree(bmp);
+free_ndlp:
+	lpfc_nlp_put(ndlp);
+no_ndlp:
+	kfree(dd_data);
+no_dd_data:
+	/* make error code available to userspace */
+	job->reply->result = rc;
+	job->dd_data = NULL;
+	return rc;
+}
 
-	if (rc != IOCB_SUCCESS) {
-		rc = -EACCES;
-		goto free_outdmp;
+/**
+ * lpfc_bsg_rport_els_cmp - lpfc_bsg_rport_els's completion handler
+ * @phba: Pointer to HBA context object.
+ * @cmdiocbq: Pointer to command iocb.
+ * @rspiocbq: Pointer to response iocb.
+ *
+ * This function is the completion handler for iocbs issued using
+ * lpfc_bsg_rport_els_cmp function. This function is called by the
+ * ring event handler function without any lock held. This function
+ * can be called from both worker thread context and interrupt
+ * context. This function also can be called from other thread which
+ * cleans up the SLI layer objects.
+ * This function copy the contents of the response iocb to the
+ * response iocb memory object provided by the caller of
+ * lpfc_sli_issue_iocb_wait and then wakes up the thread which
+ * sleeps for the iocb completion.
+ **/
+static void
+lpfc_bsg_rport_els_cmp(struct lpfc_hba *phba,
+			struct lpfc_iocbq *cmdiocbq,
+			struct lpfc_iocbq *rspiocbq)
+{
+	struct bsg_job_data *dd_data;
+	struct fc_bsg_job *job;
+	IOCB_t *rsp;
+	struct lpfc_nodelist *ndlp;
+	struct lpfc_dmabuf *pbuflist = NULL;
+	struct fc_bsg_ctels_reply *els_reply;
+	uint8_t *rjt_data;
+	unsigned long flags;
+	int rc = 0;
+
+	spin_lock_irqsave(&phba->ct_ev_lock, flags);
+	dd_data = cmdiocbq->context1;
+	/* normal completion and timeout crossed paths, already done */
+	if (!dd_data) {
+		spin_unlock_irqrestore(&phba->hbalock, flags);
+		return;
 	}
 
-	if (rsp->ulpStatus) {
-		if (rsp->ulpStatus == IOSTAT_LOCAL_REJECT) {
-			switch (rsp->un.ulpWord[4] & 0xff) {
-			case IOERR_SEQUENCE_TIMEOUT:
-				rc = -ETIMEDOUT;
-				break;
-			case IOERR_INVALID_RPI:
-				rc = -EFAULT;
-				break;
-			default:
-				rc = -EACCES;
-				break;
-			}
-			goto free_outdmp;
-		}
-	} else
+	cmdiocbq->iocb_flag |= LPFC_IO_WAKE;
+	if (cmdiocbq->context2 && rspiocbq)
+		memcpy(&((struct lpfc_iocbq *)cmdiocbq->context2)->iocb,
+		       &rspiocbq->iocb, sizeof(IOCB_t));
+
+	job = dd_data->context_un.iocb.set_job;
+	cmdiocbq = dd_data->context_un.iocb.cmdiocbq;
+	rspiocbq = dd_data->context_un.iocb.rspiocbq;
+	rsp = &rspiocbq->iocb;
+	ndlp = dd_data->context_un.iocb.ndlp;
+
+	pci_unmap_sg(phba->pcidev, job->request_payload.sg_list,
+		     job->request_payload.sg_cnt, DMA_TO_DEVICE);
+	pci_unmap_sg(phba->pcidev, job->reply_payload.sg_list,
+		     job->reply_payload.sg_cnt, DMA_FROM_DEVICE);
+
+	if (job->reply->result == -EAGAIN)
+		rc = -EAGAIN;
+	else if (rsp->ulpStatus == IOSTAT_SUCCESS)
 		job->reply->reply_payload_rcv_len =
-			rsp->un.genreq64.bdl.bdeSize;
+			rsp->un.elsreq64.bdl.bdeSize;
+	else if (rsp->ulpStatus == IOSTAT_LS_RJT) {
+		job->reply->reply_payload_rcv_len =
+			sizeof(struct fc_bsg_ctels_reply);
+		/* LS_RJT data returned in word 4 */
+		rjt_data = (uint8_t *)&rsp->un.ulpWord[4];
+		els_reply = &job->reply->reply_data.ctels_reply;
+		els_reply->status = FC_CTELS_STATUS_REJECT;
+		els_reply->rjt_data.action = rjt_data[3];
+		els_reply->rjt_data.reason_code = rjt_data[2];
+		els_reply->rjt_data.reason_explanation = rjt_data[1];
+		els_reply->rjt_data.vendor_unique = rjt_data[0];
+	} else
+		rc = -EIO;
 
-free_outdmp:
-	spin_lock_irq(shost->host_lock);
-	lpfc_mbuf_free(phba, bmp->virt, bmp->phys);
-free_bmp:
-	kfree(bmp);
-free_rspiocbq:
+	pbuflist = (struct lpfc_dmabuf *) cmdiocbq->context3;
+	lpfc_mbuf_free(phba, pbuflist->virt, pbuflist->phys);
 	lpfc_sli_release_iocbq(phba, rspiocbq);
-free_cmdiocbq:
 	lpfc_sli_release_iocbq(phba, cmdiocbq);
-	spin_unlock_irq(shost->host_lock);
-free_ndlp_exit:
 	lpfc_nlp_put(ndlp);
-
+	kfree(dd_data);
 	/* make error code available to userspace */
 	job->reply->result = rc;
+	job->dd_data = NULL;
 	/* complete the job back to userspace */
 	job->job_done(job);
-
-	return 0;
+	spin_unlock_irqrestore(&phba->ct_ev_lock, flags);
+	return;
 }
 
 /**
@@ -237,7 +469,6 @@ lpfc_bsg_rport_els(struct fc_bsg_job *jo
 	struct lpfc_hba *phba = vport->phba;
 	struct lpfc_rport_data *rdata = job->rport->dd_data;
 	struct lpfc_nodelist *ndlp = rdata->pnode;
-
 	uint32_t elscmd;
 	uint32_t cmdsize;
 	uint32_t rspsize;
@@ -249,20 +480,30 @@ lpfc_bsg_rport_els(struct fc_bsg_job *jo
 	struct lpfc_dmabuf *prsp;
 	struct lpfc_dmabuf *pbuflist = NULL;
 	struct ulp_bde64 *bpl;
-	int iocb_status;
 	int request_nseg;
 	int reply_nseg;
 	struct scatterlist *sgel = NULL;
 	int numbde;
 	dma_addr_t busaddr;
+	struct bsg_job_data *dd_data;
+	uint32_t creg_val;
 	int rc = 0;
 
 	/* in case no data is transferred */
 	job->reply->reply_payload_rcv_len = 0;
 
+	/* allocate our bsg tracking structure */
+	dd_data = kmalloc(sizeof(struct bsg_job_data), GFP_KERNEL);
+	if (!dd_data) {
+		lpfc_printf_log(phba, KERN_WARNING, LOG_LIBDFC,
+				"2735 Failed allocation of dd_data\n");
+		rc = -ENOMEM;
+		goto no_dd_data;
+	}
+
 	if (!lpfc_nlp_get(ndlp)) {
 		rc = -ENODEV;
-		goto out;
+		goto free_dd_data;
 	}
 
 	elscmd = job->request->rqst_data.r_els.els_code;
@@ -272,24 +513,24 @@ lpfc_bsg_rport_els(struct fc_bsg_job *jo
 	if (!rspiocbq) {
 		lpfc_nlp_put(ndlp);
 		rc = -ENOMEM;
-		goto out;
+		goto free_dd_data;
 	}
 
 	rsp = &rspiocbq->iocb;
 	rpi = ndlp->nlp_rpi;
 
-	cmdiocbq = lpfc_prep_els_iocb(phba->pport, 1, cmdsize, 0, ndlp,
+	cmdiocbq = lpfc_prep_els_iocb(vport, 1, cmdsize, 0, ndlp,
 				      ndlp->nlp_DID, elscmd);
-
 	if (!cmdiocbq) {
-		lpfc_sli_release_iocbq(phba, rspiocbq);
-		return -EIO;
+		rc = -EIO;
+		goto free_rspiocbq;
 	}
 
-	job->dd_data = cmdiocbq;
+	/* prep els iocb set context1 to the ndlp, context2 to the command
+	* dmabuf, context3 holds the data dmabuf
+	*/
 	pcmd = (struct lpfc_dmabuf *) cmdiocbq->context2;
 	prsp = (struct lpfc_dmabuf *) pcmd->list.next;
-
 	lpfc_mbuf_free(phba, pcmd->virt, pcmd->phys);
 	kfree(pcmd);
 	lpfc_mbuf_free(phba, prsp->virt, prsp->phys);
@@ -301,7 +542,6 @@ lpfc_bsg_rport_els(struct fc_bsg_job *jo
 
 	request_nseg = pci_map_sg(phba->pcidev, job->request_payload.sg_list,
 				  job->request_payload.sg_cnt, DMA_TO_DEVICE);
-
 	for_each_sg(job->request_payload.sg_list, sgel, request_nseg, numbde) {
 		busaddr = sg_dma_address(sgel);
 		bpl->tus.f.bdeFlags = BUFF_TYPE_BDE_64;
@@ -323,7 +563,6 @@ lpfc_bsg_rport_els(struct fc_bsg_job *jo
 		bpl->addrHigh = cpu_to_le32(putPaddrHigh(busaddr));
 		bpl++;
 	}
-
 	cmdiocbq->iocb.un.elsreq64.bdl.bdeSize =
 		(request_nseg + reply_nseg) * sizeof(struct ulp_bde64);
 	cmdiocbq->iocb.ulpContext = rpi;
@@ -331,102 +570,54 @@ lpfc_bsg_rport_els(struct fc_bsg_job *jo
 	cmdiocbq->context1 = NULL;
 	cmdiocbq->context2 = NULL;
 
-	iocb_status = lpfc_sli_issue_iocb_wait(phba, LPFC_ELS_RING, cmdiocbq,
-					rspiocbq, (phba->fc_ratov * 2)
-					       + LPFC_DRVR_TIMEOUT);
-
-	/* release the new ndlp once the iocb completes */
+	cmdiocbq->iocb_cmpl = lpfc_bsg_rport_els_cmp;
+	cmdiocbq->context1 = dd_data;
+	cmdiocbq->context2 = rspiocbq;
+	dd_data->type = TYPE_IOCB;
+	dd_data->context_un.iocb.cmdiocbq = cmdiocbq;
+	dd_data->context_un.iocb.rspiocbq = rspiocbq;
+	dd_data->context_un.iocb.set_job = job;
+	dd_data->context_un.iocb.bmp = NULL;;
+	dd_data->context_un.iocb.ndlp = ndlp;
+
+	if (phba->cfg_poll & DISABLE_FCP_RING_INT) {
+		creg_val = readl(phba->HCregaddr);
+		creg_val |= (HC_R0INT_ENA << LPFC_FCP_RING);
+		writel(creg_val, phba->HCregaddr);
+		readl(phba->HCregaddr); /* flush */
+	}
+	rc = lpfc_sli_issue_iocb(phba, LPFC_ELS_RING, cmdiocbq, 0);
 	lpfc_nlp_put(ndlp);
-	if (iocb_status != IOCB_TIMEDOUT) {
-		pci_unmap_sg(phba->pcidev, job->request_payload.sg_list,
-			     job->request_payload.sg_cnt, DMA_TO_DEVICE);
-		pci_unmap_sg(phba->pcidev, job->reply_payload.sg_list,
-			     job->reply_payload.sg_cnt, DMA_FROM_DEVICE);
-	}
-
-	if (iocb_status == IOCB_SUCCESS) {
-		if (rsp->ulpStatus == IOSTAT_SUCCESS) {
-			job->reply->reply_payload_rcv_len =
-				rsp->un.elsreq64.bdl.bdeSize;
-			rc = 0;
-		} else if (rsp->ulpStatus == IOSTAT_LS_RJT) {
-			struct fc_bsg_ctels_reply *els_reply;
-			/* LS_RJT data returned in word 4 */
-			uint8_t *rjt_data = (uint8_t *)&rsp->un.ulpWord[4];
+	if (rc == IOCB_SUCCESS)
+		return 0; /* done for now */
 
-			els_reply = &job->reply->reply_data.ctels_reply;
-			job->reply->result = 0;
-			els_reply->status = FC_CTELS_STATUS_REJECT;
-			els_reply->rjt_data.action = rjt_data[0];
-			els_reply->rjt_data.reason_code = rjt_data[1];
-			els_reply->rjt_data.reason_explanation = rjt_data[2];
-			els_reply->rjt_data.vendor_unique = rjt_data[3];
-		} else
-			rc = -EIO;
-	} else
-		rc = -EIO;
+	pci_unmap_sg(phba->pcidev, job->request_payload.sg_list,
+		     job->request_payload.sg_cnt, DMA_TO_DEVICE);
+	pci_unmap_sg(phba->pcidev, job->reply_payload.sg_list,
+		     job->reply_payload.sg_cnt, DMA_FROM_DEVICE);
+
+	lpfc_mbuf_free(phba, pbuflist->virt, pbuflist->phys);
 
-	if (iocb_status != IOCB_TIMEDOUT)
-		lpfc_els_free_iocb(phba, cmdiocbq);
+	lpfc_sli_release_iocbq(phba, cmdiocbq);
 
+free_rspiocbq:
 	lpfc_sli_release_iocbq(phba, rspiocbq);
 
-out:
+free_dd_data:
+	kfree(dd_data);
+
+no_dd_data:
 	/* make error code available to userspace */
 	job->reply->result = rc;
-	/* complete the job back to userspace */
-	job->job_done(job);
-
-	return 0;
-}
-
-struct lpfc_ct_event {
-	struct list_head node;
-	int ref;
-	wait_queue_head_t wq;
-
-	/* Event type and waiter identifiers */
-	uint32_t type_mask;
-	uint32_t req_id;
-	uint32_t reg_id;
-
-	/* next two flags are here for the auto-delete logic */
-	unsigned long wait_time_stamp;
-	int waiting;
-
-	/* seen and not seen events */
-	struct list_head events_to_get;
-	struct list_head events_to_see;
-};
-
-struct event_data {
-	struct list_head node;
-	uint32_t type;
-	uint32_t immed_dat;
-	void *data;
-	uint32_t len;
-};
-
-static struct lpfc_ct_event *
-lpfc_ct_event_new(int ev_reg_id, uint32_t ev_req_id)
-{
-	struct lpfc_ct_event *evt = kzalloc(sizeof(*evt), GFP_KERNEL);
-	if (!evt)
-		return NULL;
-
-	INIT_LIST_HEAD(&evt->events_to_get);
-	INIT_LIST_HEAD(&evt->events_to_see);
-	evt->req_id = ev_req_id;
-	evt->reg_id = ev_reg_id;
-	evt->wait_time_stamp = jiffies;
-	init_waitqueue_head(&evt->wq);
-
-	return evt;
+	job->dd_data = NULL;
+	return rc;
 }
 
 static void
-lpfc_ct_event_free(struct lpfc_ct_event *evt)
+lpfc_bsg_event_free(struct kref *kref)
 {
+	struct lpfc_bsg_event *evt = container_of(kref, struct lpfc_bsg_event,
+						  kref);
 	struct event_data *ed;
 
 	list_del(&evt->node);
@@ -449,24 +640,62 @@ lpfc_ct_event_free(struct lpfc_ct_event 
 }
 
 static inline void
-lpfc_ct_event_ref(struct lpfc_ct_event *evt)
+lpfc_bsg_event_ref(struct lpfc_bsg_event *evt)
 {
-	evt->ref++;
+	kref_get(&evt->kref);
 }
 
 static inline void
-lpfc_ct_event_unref(struct lpfc_ct_event *evt)
+lpfc_bsg_event_unref(struct lpfc_bsg_event *evt)
 {
-	if (--evt->ref < 0)
-		lpfc_ct_event_free(evt);
+	kref_put(&evt->kref, lpfc_bsg_event_free);
 }
 
-#define SLI_CT_ELX_LOOPBACK 0x10
+static struct lpfc_bsg_event *
+lpfc_bsg_event_new(uint32_t ev_mask, int ev_reg_id, uint32_t ev_req_id)
+{
+	struct lpfc_bsg_event *evt = kzalloc(sizeof(*evt), GFP_KERNEL);
 
-enum ELX_LOOPBACK_CMD {
-	ELX_LOOPBACK_XRI_SETUP,
-	ELX_LOOPBACK_DATA,
-};
+	if (!evt)
+		return NULL;
+
+	INIT_LIST_HEAD(&evt->events_to_get);
+	INIT_LIST_HEAD(&evt->events_to_see);
+	evt->type_mask = ev_mask;
+	evt->req_id = ev_req_id;
+	evt->reg_id = ev_reg_id;
+	evt->wait_time_stamp = jiffies;
+	init_waitqueue_head(&evt->wq);
+	kref_init(&evt->kref);
+	return evt;
+}
+
+static int
+dfc_cmd_data_free(struct lpfc_hba *phba, struct lpfc_dmabufext *mlist)
+{
+	struct lpfc_dmabufext *mlast;
+	struct pci_dev *pcidev;
+	struct list_head head, *curr, *next;
+
+	if ((!mlist) || (!lpfc_is_link_up(phba) &&
+		(phba->link_flag & LS_LOOPBACK_MODE))) {
+		return 0;
+	}
+
+	pcidev = phba->pcidev;
+	list_add_tail(&head, &mlist->dma.list);
+
+	list_for_each_safe(curr, next, &head) {
+		mlast = list_entry(curr, struct lpfc_dmabufext , dma.list);
+		if (mlast->dma.virt)
+			dma_free_coherent(&pcidev->dev,
+					  mlast->size,
+					  mlast->dma.virt,
+					  mlast->dma.phys);
+		kfree(mlast);
+	}
+	return 0;
+}
 
 /**
  * lpfc_bsg_ct_unsol_event - process an unsolicited CT command
@@ -475,7 +704,7 @@ enum ELX_LOOPBACK_CMD {
  * @piocbq:
  *
  * This function is called when an unsolicited CT command is received.  It
- * forwards the event to any processes registerd to receive CT events.
+ * forwards the event to any processes registered to receive CT events.
  */
 int
 lpfc_bsg_ct_unsol_event(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
@@ -485,7 +714,7 @@ lpfc_bsg_ct_unsol_event(struct lpfc_hba 
 	uint32_t cmd;
 	uint32_t len;
 	struct lpfc_dmabuf *dmabuf = NULL;
-	struct lpfc_ct_event *evt;
+	struct lpfc_bsg_event *evt;
 	struct event_data *evt_dat = NULL;
 	struct lpfc_iocbq *iocbq;
 	size_t offset = 0;
@@ -497,7 +726,9 @@ lpfc_bsg_ct_unsol_event(struct lpfc_hba 
 	struct lpfc_dmabuf *bdeBuf2 = piocbq->context3;
 	struct lpfc_hbq_entry *hbqe;
 	struct lpfc_sli_ct_request *ct_req;
+	struct fc_bsg_job *job = NULL;
 	unsigned long flags;
+	int size = 0;
 
 	INIT_LIST_HEAD(&head);
 	list_add_tail(&head, &piocbq->list);
@@ -506,6 +737,10 @@ lpfc_bsg_ct_unsol_event(struct lpfc_hba 
 	    piocbq->iocb.un.cont64[0].tus.f.bdeSize == 0)
 		goto error_ct_unsol_exit;
 
+	if (phba->link_state == LPFC_HBA_ERROR ||
+		(!(phba->sli.sli_flag & LPFC_SLI_ACTIVE)))
+		goto error_ct_unsol_exit;
+
 	if (phba->sli3_options & LPFC_SLI3_HBQ_ENABLED)
 		dmabuf = bdeBuf1;
 	else {
@@ -513,7 +748,8 @@ lpfc_bsg_ct_unsol_event(struct lpfc_hba 
 				    piocbq->iocb.un.cont64[0].addrLow);
 		dmabuf = lpfc_sli_ringpostbuf_get(phba, pring, dma_addr);
 	}
-
+	if (dmabuf == NULL)
+		goto error_ct_unsol_exit;
 	ct_req = (struct lpfc_sli_ct_request *)dmabuf->virt;
 	evt_req_id = ct_req->FsType;
 	cmd = ct_req->CommandResponse.bits.CmdRsp;
@@ -523,22 +759,22 @@ lpfc_bsg_ct_unsol_event(struct lpfc_hba 
 
 	spin_lock_irqsave(&phba->ct_ev_lock, flags);
 	list_for_each_entry(evt, &phba->ct_ev_waiters, node) {
-		if (evt->req_id != evt_req_id)
+		if (!(evt->type_mask & FC_REG_CT_EVENT) ||
+			evt->req_id != evt_req_id)
 			continue;
 
-		lpfc_ct_event_ref(evt);
-
+		lpfc_bsg_event_ref(evt);
+		spin_unlock_irqrestore(&phba->ct_ev_lock, flags);
 		evt_dat = kzalloc(sizeof(*evt_dat), GFP_KERNEL);
-		if (!evt_dat) {
-			lpfc_ct_event_unref(evt);
+		if (evt_dat == NULL) {
+			spin_lock_irqsave(&phba->ct_ev_lock, flags);
+			lpfc_bsg_event_unref(evt);
 			lpfc_printf_log(phba, KERN_WARNING, LOG_LIBDFC,
 					"2614 Memory allocation failed for "
 					"CT event\n");
 			break;
 		}
 
-		spin_unlock_irqrestore(&phba->ct_ev_lock, flags);
-
 		if (phba->sli3_options & LPFC_SLI3_HBQ_ENABLED) {
 			/* take accumulated byte count from the last iocbq */
 			iocbq = list_entry(head.prev, typeof(*iocbq), list);
@@ -552,25 +788,25 @@ lpfc_bsg_ct_unsol_event(struct lpfc_hba 
 		}
 
 		evt_dat->data = kzalloc(evt_dat->len, GFP_KERNEL);
-		if (!evt_dat->data) {
+		if (evt_dat->data == NULL) {
 			lpfc_printf_log(phba, KERN_WARNING, LOG_LIBDFC,
 					"2615 Memory allocation failed for "
 					"CT event data, size %d\n",
 					evt_dat->len);
 			kfree(evt_dat);
 			spin_lock_irqsave(&phba->ct_ev_lock, flags);
-			lpfc_ct_event_unref(evt);
+			lpfc_bsg_event_unref(evt);
 			spin_unlock_irqrestore(&phba->ct_ev_lock, flags);
 			goto error_ct_unsol_exit;
 		}
 
 		list_for_each_entry(iocbq, &head, list) {
+			size = 0;
 			if (phba->sli3_options & LPFC_SLI3_HBQ_ENABLED) {
 				bdeBuf1 = iocbq->context2;
 				bdeBuf2 = iocbq->context3;
 			}
 			for (i = 0; i < iocbq->iocb.ulpBdeCount; i++) {
-				int size = 0;
 				if (phba->sli3_options &
 				    LPFC_SLI3_HBQ_ENABLED) {
 					if (i == 0) {
@@ -605,7 +841,7 @@ lpfc_bsg_ct_unsol_event(struct lpfc_hba 
 					kfree(evt_dat);
 					spin_lock_irqsave(&phba->ct_ev_lock,
 						flags);
-					lpfc_ct_event_unref(evt);
+					lpfc_bsg_event_unref(evt);
 					spin_unlock_irqrestore(
 						&phba->ct_ev_lock, flags);
 					goto error_ct_unsol_exit;
@@ -620,15 +856,24 @@ lpfc_bsg_ct_unsol_event(struct lpfc_hba 
 								 dmabuf);
 				} else {
 					switch (cmd) {
+					case ELX_LOOPBACK_DATA:
+						dfc_cmd_data_free(phba,
+						(struct lpfc_dmabufext *)
+							dmabuf);
+						break;
 					case ELX_LOOPBACK_XRI_SETUP:
-						if (!(phba->sli3_options &
-						      LPFC_SLI3_HBQ_ENABLED))
+						if ((phba->sli_rev ==
+							LPFC_SLI_REV2) ||
+							(phba->sli3_options &
+							LPFC_SLI3_HBQ_ENABLED
+							)) {
+							lpfc_in_buf_free(phba,
+									dmabuf);
+						} else {
 							lpfc_post_buffer(phba,
 									 pring,
 									 1);
-						else
-							lpfc_in_buf_free(phba,
-									dmabuf);
+						}
 						break;
 					default:
 						if (!(phba->sli3_options &
@@ -655,49 +900,79 @@ lpfc_bsg_ct_unsol_event(struct lpfc_hba 
 
 		evt_dat->type = FC_REG_CT_EVENT;
 		list_add(&evt_dat->node, &evt->events_to_see);
-		wake_up_interruptible(&evt->wq);
-		lpfc_ct_event_unref(evt);
-		if (evt_req_id == SLI_CT_ELX_LOOPBACK)
+		if (evt_req_id == SLI_CT_ELX_LOOPBACK) {
+			wake_up_interruptible(&evt->wq);
+			lpfc_bsg_event_unref(evt);
 			break;
+		}
+
+		list_move(evt->events_to_see.prev, &evt->events_to_get);
+		lpfc_bsg_event_unref(evt);
+
+		job = evt->set_job;
+		evt->set_job = NULL;
+		if (job) {
+			job->reply->reply_payload_rcv_len = size;
+			/* make error code available to userspace */
+			job->reply->result = 0;
+			job->dd_data = NULL;
+			/* complete the job back to userspace */
+			spin_unlock_irqrestore(&phba->ct_ev_lock, flags);
+			job->job_done(job);
+			spin_lock_irqsave(&phba->ct_ev_lock, flags);
+		}
 	}
 	spin_unlock_irqrestore(&phba->ct_ev_lock, flags);
 
 error_ct_unsol_exit:
 	if (!list_empty(&head))
 		list_del(&head);
-
+	if (evt_req_id == SLI_CT_ELX_LOOPBACK)
+		return 0;
 	return 1;
 }
 
 /**
- * lpfc_bsg_set_event - process a SET_EVENT bsg vendor command
+ * lpfc_bsg_hba_set_event - process a SET_EVENT bsg vendor command
  * @job: SET_EVENT fc_bsg_job
  */
 static int
-lpfc_bsg_set_event(struct fc_bsg_job *job)
+lpfc_bsg_hba_set_event(struct fc_bsg_job *job)
 {
 	struct lpfc_vport *vport = (struct lpfc_vport *)job->shost->hostdata;
 	struct lpfc_hba *phba = vport->phba;
 	struct set_ct_event *event_req;
-	struct lpfc_ct_event *evt;
-	unsigned long flags;
+	struct lpfc_bsg_event *evt;
 	int rc = 0;
+	struct bsg_job_data *dd_data = NULL;
+	uint32_t ev_mask;
+	unsigned long flags;
 
 	if (job->request_len <
 	    sizeof(struct fc_bsg_request) + sizeof(struct set_ct_event)) {
 		lpfc_printf_log(phba, KERN_WARNING, LOG_LIBDFC,
 				"2612 Received SET_CT_EVENT below minimum "
 				"size\n");
-		return -EINVAL;
+		rc = -EINVAL;
+		goto job_error;
+	}
+
+	dd_data = kmalloc(sizeof(struct bsg_job_data), GFP_KERNEL);
+	if (dd_data == NULL) {
+		lpfc_printf_log(phba, KERN_WARNING, LOG_LIBDFC,
+				"2734 Failed allocation of dd_data\n");
+		rc = -ENOMEM;
+		goto job_error;
 	}
 
 	event_req = (struct set_ct_event *)
 		job->request->rqst_data.h_vendor.vendor_cmd;
-
+	ev_mask = ((uint32_t)(unsigned long)event_req->type_mask &
+				FC_REG_EVENT_MASK);
 	spin_lock_irqsave(&phba->ct_ev_lock, flags);
 	list_for_each_entry(evt, &phba->ct_ev_waiters, node) {
 		if (evt->reg_id == event_req->ev_reg_id) {
-			lpfc_ct_event_ref(evt);
+			lpfc_bsg_event_ref(evt);
 			evt->wait_time_stamp = jiffies;
 			break;
 		}
@@ -706,73 +981,63 @@ lpfc_bsg_set_event(struct fc_bsg_job *jo
 
 	if (&evt->node == &phba->ct_ev_waiters) {
 		/* no event waiting struct yet - first call */
-		evt = lpfc_ct_event_new(event_req->ev_reg_id,
+		evt = lpfc_bsg_event_new(ev_mask, event_req->ev_reg_id,
 					event_req->ev_req_id);
 		if (!evt) {
 			lpfc_printf_log(phba, KERN_WARNING, LOG_LIBDFC,
 					"2617 Failed allocation of event "
 					"waiter\n");
-			return -ENOMEM;
+			rc = -ENOMEM;
+			goto job_error;
 		}
 
 		spin_lock_irqsave(&phba->ct_ev_lock, flags);
 		list_add(&evt->node, &phba->ct_ev_waiters);
-		lpfc_ct_event_ref(evt);
-		spin_unlock_irqrestore(&phba->ct_ev_lock, flags);
-	}
-
-	evt->waiting = 1;
-	if (wait_event_interruptible(evt->wq,
-				     !list_empty(&evt->events_to_see))) {
-		spin_lock_irqsave(&phba->ct_ev_lock, flags);
-		lpfc_ct_event_unref(evt); /* release ref */
-		lpfc_ct_event_unref(evt); /* delete */
+		lpfc_bsg_event_ref(evt);
+		evt->wait_time_stamp = jiffies;
 		spin_unlock_irqrestore(&phba->ct_ev_lock, flags);
-		rc = -EINTR;
-		goto set_event_out;
 	}
 
-	evt->wait_time_stamp = jiffies;
-	evt->waiting = 0;
-
 	spin_lock_irqsave(&phba->ct_ev_lock, flags);
-	list_move(evt->events_to_see.prev, &evt->events_to_get);
-	lpfc_ct_event_unref(evt); /* release ref */
+	evt->waiting = 1;
+	dd_data->type = TYPE_EVT;
+	dd_data->context_un.evt = evt;
+	evt->set_job = job; /* for unsolicited command */
+	job->dd_data = dd_data; /* for fc transport timeout callback*/
 	spin_unlock_irqrestore(&phba->ct_ev_lock, flags);
+	return 0; /* call job done later */
 
-set_event_out:
-	/* set_event carries no reply payload */
-	job->reply->reply_payload_rcv_len = 0;
-	/* make error code available to userspace */
-	job->reply->result = rc;
-	/* complete the job back to userspace */
-	job->job_done(job);
+job_error:
+	if (dd_data != NULL)
+		kfree(dd_data);
 
-	return 0;
+	job->dd_data = NULL;
+	return rc;
 }
 
 /**
- * lpfc_bsg_get_event - process a GET_EVENT bsg vendor command
+ * lpfc_bsg_hba_get_event - process a GET_EVENT bsg vendor command
  * @job: GET_EVENT fc_bsg_job
  */
 static int
-lpfc_bsg_get_event(struct fc_bsg_job *job)
+lpfc_bsg_hba_get_event(struct fc_bsg_job *job)
 {
 	struct lpfc_vport *vport = (struct lpfc_vport *)job->shost->hostdata;
 	struct lpfc_hba *phba = vport->phba;
 	struct get_ct_event *event_req;
 	struct get_ct_event_reply *event_reply;
-	struct lpfc_ct_event *evt;
+	struct lpfc_bsg_event *evt;
 	struct event_data *evt_dat = NULL;
 	unsigned long flags;
-	int rc = 0;
+	uint32_t rc = 0;
 
 	if (job->request_len <
 	    sizeof(struct fc_bsg_request) + sizeof(struct get_ct_event)) {
 		lpfc_printf_log(phba, KERN_WARNING, LOG_LIBDFC,
 				"2613 Received GET_CT_EVENT request below "
 				"minimum size\n");
-		return -EINVAL;
+		rc = -EINVAL;
+		goto job_error;
 	}
 
 	event_req = (struct get_ct_event *)
@@ -780,13 +1045,12 @@ lpfc_bsg_get_event(struct fc_bsg_job *jo
 
 	event_reply = (struct get_ct_event_reply *)
 		job->reply->reply_data.vendor_reply.vendor_rsp;
-
 	spin_lock_irqsave(&phba->ct_ev_lock, flags);
 	list_for_each_entry(evt, &phba->ct_ev_waiters, node) {
 		if (evt->reg_id == event_req->ev_reg_id) {
 			if (list_empty(&evt->events_to_get))
 				break;
-			lpfc_ct_event_ref(evt);
+			lpfc_bsg_event_ref(evt);
 			evt->wait_time_stamp = jiffies;
 			evt_dat = list_entry(evt->events_to_get.prev,
 					     struct event_data, node);
@@ -796,44 +1060,49 @@ lpfc_bsg_get_event(struct fc_bsg_job *jo
 	}
 	spin_unlock_irqrestore(&phba->ct_ev_lock, flags);
 
-	if (!evt_dat) {
+	/* The app may continue to ask for event data until it gets
+	 * an error indicating that there isn't anymore
+	 */
+	if (evt_dat == NULL) {
 		job->reply->reply_payload_rcv_len = 0;
 		rc = -ENOENT;
-		goto error_get_event_exit;
+		goto job_error;
 	}
 
-	if (evt_dat->len > job->reply_payload.payload_len) {
-		evt_dat->len = job->reply_payload.payload_len;
-			lpfc_printf_log(phba, KERN_WARNING, LOG_LIBDFC,
-					"2618 Truncated event data at %d "
-					"bytes\n",
-					job->reply_payload.payload_len);
+	if (evt_dat->len > job->request_payload.payload_len) {
+		evt_dat->len = job->request_payload.payload_len;
+		lpfc_printf_log(phba, KERN_WARNING, LOG_LIBDFC,
+				"2618 Truncated event data at %d "
+				"bytes\n",
+				job->request_payload.payload_len);
 	}
 
+	event_reply->type = evt_dat->type;
 	event_reply->immed_data = evt_dat->immed_dat;
-
 	if (evt_dat->len > 0)
 		job->reply->reply_payload_rcv_len =
-			sg_copy_from_buffer(job->reply_payload.sg_list,
-					    job->reply_payload.sg_cnt,
+			sg_copy_from_buffer(job->request_payload.sg_list,
+					    job->request_payload.sg_cnt,
 					    evt_dat->data, evt_dat->len);
 	else
 		job->reply->reply_payload_rcv_len = 0;
-	rc = 0;
 
-	if (evt_dat)
+	if (evt_dat) {
 		kfree(evt_dat->data);
-	kfree(evt_dat);
+		kfree(evt_dat);
+	}
+
 	spin_lock_irqsave(&phba->ct_ev_lock, flags);
-	lpfc_ct_event_unref(evt);
+	lpfc_bsg_event_unref(evt);
 	spin_unlock_irqrestore(&phba->ct_ev_lock, flags);
-
-error_get_event_exit:
-	/* make error code available to userspace */
-	job->reply->result = rc;
-	/* complete the job back to userspace */
+	job->dd_data = NULL;
+	job->reply->result = 0;
 	job->job_done(job);
+	return 0;
 
+job_error:
+	job->dd_data = NULL;
+	job->reply->result = rc;
 	return rc;
 }
 
@@ -845,19 +1114,25 @@ static int
 lpfc_bsg_hst_vendor(struct fc_bsg_job *job)
 {
 	int command = job->request->rqst_data.h_vendor.vendor_cmd[0];
+	int rc;
 
 	switch (command) {
 	case LPFC_BSG_VENDOR_SET_CT_EVENT:
-		return lpfc_bsg_set_event(job);
+		rc = lpfc_bsg_hba_set_event(job);
 		break;
 
 	case LPFC_BSG_VENDOR_GET_CT_EVENT:
-		return lpfc_bsg_get_event(job);
+		rc = lpfc_bsg_hba_get_event(job);
 		break;
-
 	default:
-		return -EINVAL;
+		rc = -EINVAL;
+		job->reply->reply_payload_rcv_len = 0;
+		/* make error code available to userspace */
+		job->reply->result = rc;
+		break;
 	}
+
+	return rc;
 }
 
 /**
@@ -868,10 +1143,9 @@ int
 lpfc_bsg_request(struct fc_bsg_job *job)
 {
 	uint32_t msgcode;
-	int rc = -EINVAL;
+	int rc;
 
 	msgcode = job->request->msgcode;
-
 	switch (msgcode) {
 	case FC_BSG_HST_VENDOR:
 		rc = lpfc_bsg_hst_vendor(job);
@@ -880,9 +1154,13 @@ lpfc_bsg_request(struct fc_bsg_job *job)
 		rc = lpfc_bsg_rport_els(job);
 		break;
 	case FC_BSG_RPT_CT:
-		rc = lpfc_bsg_rport_ct(job);
+		rc = lpfc_bsg_send_mgmt_cmd(job);
 		break;
 	default:
+		rc = -EINVAL;
+		job->reply->reply_payload_rcv_len = 0;
+		/* make error code available to userspace */
+		job->reply->result = rc;
 		break;
 	}
 
@@ -901,11 +1179,54 @@ lpfc_bsg_timeout(struct fc_bsg_job *job)
 {
 	struct lpfc_vport *vport = (struct lpfc_vport *)job->shost->hostdata;
 	struct lpfc_hba *phba = vport->phba;
-	struct lpfc_iocbq *cmdiocb = (struct lpfc_iocbq *)job->dd_data;
+	struct lpfc_iocbq *cmdiocb;
+	struct lpfc_bsg_event *evt;
+	struct lpfc_bsg_iocb *iocb;
 	struct lpfc_sli_ring *pring = &phba->sli.ring[LPFC_ELS_RING];
+	struct bsg_job_data *dd_data;
+	unsigned long flags;
 
-	if (cmdiocb)
+	spin_lock_irqsave(&phba->ct_ev_lock, flags);
+	dd_data = (struct bsg_job_data *)job->dd_data;
+	/* timeout and completion crossed paths if no dd_data */
+	if (!dd_data) {
+		spin_unlock_irqrestore(&phba->ct_ev_lock, flags);
+		return 0;
+	}
+
+	switch (dd_data->type) {
+	case TYPE_IOCB:
+		iocb = &dd_data->context_un.iocb;
+		cmdiocb = iocb->cmdiocbq;
+		/* hint to completion handler that the job timed out */
+		job->reply->result = -EAGAIN;
+		spin_unlock_irqrestore(&phba->ct_ev_lock, flags);
+		/* this will call our completion handler */
+		spin_lock_irq(&phba->hbalock);
 		lpfc_sli_issue_abort_iotag(phba, pring, cmdiocb);
+		spin_unlock_irq(&phba->hbalock);
+		break;
+	case TYPE_EVT:
+		evt = dd_data->context_un.evt;
+		/* this event has no job anymore */
+		evt->set_job = NULL;
+		job->dd_data = NULL;
+		job->reply->reply_payload_rcv_len = 0;
+		/* Return -EAGAIN which is our way of signallying the
+		 * app to retry.
+		 */
+		job->reply->result = -EAGAIN;
+		spin_unlock_irqrestore(&phba->ct_ev_lock, flags);
+		job->job_done(job);
+		break;
+	default:
+		spin_unlock_irqrestore(&phba->ct_ev_lock, flags);
+		break;
+	}
 
+	/* scsi transport fc fc_bsg_job_timeout expects a zero return code,
+	 * otherwise an error message will be displayed on the console
+	 * so always return success (zero)
+	 */
 	return 0;
 }


