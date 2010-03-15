From: James Smart <james.smart@emulex.com>
Subject: [PATCH 3/6] lpfc 8.3.11: Driver management improvements via BSG
Date: Mon, 15 Mar 2010 11:25:20 -0400
Message-ID: <1268666720.31367.15.camel@wookie>
Reply-To: james.smart@emulex.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exht1.emulex.com ([138.239.113.183]:57388 "EHLO
	exht1.ad.emulex.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S965193Ab0COPZ0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Mar 2010 11:25:26 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Driver management improvements via BSG

- Add BSG support for PCI loopback testing.
- Add BSG support for extended mailbox commands.


 Signed-off-by: Alex Iannicelli <alex.iannicelli@emulex.com>
 Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc.h      |    2 
 lpfc_bsg.c  |  257 +++++++++++++++++++++++++++++++++++++++++++++++-------------
 lpfc_bsg.h  |    4 
 lpfc_hw.h   |   10 ++
 lpfc_init.c |    2 
 lpfc_mbox.c |   51 +++++++----
 lpfc_sli.c  |   50 ++++++++++-
 lpfc_sli.h  |    3 
 8 files changed, 296 insertions(+), 83 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_bsg.c b/drivers/scsi/lpfc/lpfc_bsg.c
--- a/drivers/scsi/lpfc/lpfc_bsg.c	2010-03-05 10:42:37.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_bsg.c	2010-03-15 10:32:12.000000000 -0400
@@ -78,6 +78,12 @@ struct lpfc_bsg_iocb {
 struct lpfc_bsg_mbox {
 	LPFC_MBOXQ_t *pmboxq;
 	MAILBOX_t *mb;
+	struct lpfc_dmabuf *rxbmp; /* for BIU diags */
+	struct lpfc_dmabufext *dmp; /* for BIU diags */
+	uint8_t *ext; /* extended mailbox data */
+	uint32_t mbOffset; /* from app */
+	uint32_t inExtWLen; /* from app */
+	uint32_t outWxtWLen; /* from app */
 
 	/* job waiting for this mbox command to finish */
 	struct fc_bsg_job *set_job;
@@ -2376,35 +2382,68 @@ void
 lpfc_bsg_wake_mbox_wait(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmboxq)
 {
 	struct bsg_job_data *dd_data;
-	MAILBOX_t *pmb;
-	MAILBOX_t *mb;
 	struct fc_bsg_job *job;
 	uint32_t size;
 	unsigned long flags;
+	uint8_t *to;
+	uint8_t *from;
 
 	spin_lock_irqsave(&phba->ct_ev_lock, flags);
 	dd_data = pmboxq->context1;
+	/* job already timed out? */
 	if (!dd_data) {
 		spin_unlock_irqrestore(&phba->ct_ev_lock, flags);
 		return;
 	}
 
-	pmb = &dd_data->context_un.mbox.pmboxq->u.mb;
-	mb = dd_data->context_un.mbox.mb;
+	/* build the outgoing buffer to do an sg copy
+	 * the format is the response mailbox followed by any extended
+	 * mailbox data
+	 */
+	from = (uint8_t *)&pmboxq->u.mb;
+	to = (uint8_t *)dd_data->context_un.mbox.mb;
+	memcpy(to, from, sizeof(MAILBOX_t));
+	/* copy the extended data if any, count is in words */
+	if (dd_data->context_un.mbox.outWxtWLen) {
+		from = (uint8_t *)dd_data->context_un.mbox.ext;
+		to += sizeof(MAILBOX_t);
+		memcpy(to, from,
+		dd_data->context_un.mbox.outWxtWLen * sizeof(uint32_t));
+	}
+
+	from = (uint8_t *)dd_data->context_un.mbox.mb;
 	job = dd_data->context_un.mbox.set_job;
-	memcpy(mb, pmb, sizeof(*pmb));
-	size = job->request_payload.payload_len;
+	size = job->reply_payload.payload_len;
 	job->reply->reply_payload_rcv_len =
 		sg_copy_from_buffer(job->reply_payload.sg_list,
 				job->reply_payload.sg_cnt,
-				mb, size);
+				from, size);
 	job->reply->result = 0;
+
 	dd_data->context_un.mbox.set_job = NULL;
 	job->dd_data = NULL;
 	job->job_done(job);
+	/* need to hold the lock until we call job done to hold off
+	 * the timeout handler returning to the midlayer while
+	 * we are stillprocessing the job
+	 */
 	spin_unlock_irqrestore(&phba->ct_ev_lock, flags);
+
+	kfree(dd_data->context_un.mbox.mb);
 	mempool_free(dd_data->context_un.mbox.pmboxq, phba->mbox_mem_pool);
-	kfree(mb);
+	kfree(dd_data->context_un.mbox.ext);
+	if (dd_data->context_un.mbox.dmp) {
+		dma_free_coherent(&phba->pcidev->dev,
+			dd_data->context_un.mbox.dmp->size,
+			dd_data->context_un.mbox.dmp->dma.virt,
+			dd_data->context_un.mbox.dmp->dma.phys);
+		kfree(dd_data->context_un.mbox.dmp);
+	}
+	if (dd_data->context_un.mbox.rxbmp) {
+		lpfc_mbuf_free(phba, dd_data->context_un.mbox.rxbmp->virt,
+			dd_data->context_un.mbox.rxbmp->phys);
+		kfree(dd_data->context_un.mbox.rxbmp);
+	}
 	kfree(dd_data);
 	return;
 }
@@ -2467,6 +2506,7 @@ static int lpfc_bsg_check_cmd_access(str
 	case MBX_WRITE_EVENT_LOG:
 	case MBX_PORT_CAPABILITIES:
 	case MBX_PORT_IOV_CONTROL:
+	case MBX_RUN_BIU_DIAG64:
 		break;
 	case MBX_SET_VARIABLE:
 		lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
@@ -2481,7 +2521,6 @@ static int lpfc_bsg_check_cmd_access(str
 			phba->fc_topology = TOPOLOGY_PT_PT;
 		}
 		break;
-	case MBX_RUN_BIU_DIAG64:
 	case MBX_READ_EVENT_LOG:
 	case MBX_READ_SPARM64:
 	case MBX_READ_LA:
@@ -2517,97 +2556,199 @@ static uint32_t
 lpfc_bsg_issue_mbox(struct lpfc_hba *phba, struct fc_bsg_job *job,
 	struct lpfc_vport *vport)
 {
-	LPFC_MBOXQ_t *pmboxq;
-	MAILBOX_t *pmb;
-	MAILBOX_t *mb;
-	struct bsg_job_data *dd_data;
+	LPFC_MBOXQ_t *pmboxq = NULL; /* internal mailbox queue */
+	MAILBOX_t *pmb; /* shortcut to the pmboxq mailbox */
+	/* a 4k buffer to hold the mb and extended data from/to the bsg */
+	MAILBOX_t *mb = NULL;
+	struct bsg_job_data *dd_data = NULL; /* bsg data tracking structure */
 	uint32_t size;
+	struct lpfc_dmabuf *rxbmp = NULL; /* for biu diag */
+	struct lpfc_dmabufext *dmp = NULL; /* for biu diag */
+	struct ulp_bde64 *rxbpl = NULL;
+	struct dfc_mbox_req *mbox_req = (struct dfc_mbox_req *)
+		job->request->rqst_data.h_vendor.vendor_cmd;
+	uint8_t *ext = NULL;
 	int rc = 0;
+	uint8_t *from;
+
+	/* in case no data is transferred */
+	job->reply->reply_payload_rcv_len = 0;
+
+	/* check if requested extended data lengths are valid */
+	if ((mbox_req->inExtWLen > MAILBOX_EXT_SIZE) ||
+		(mbox_req->outWxtWLen > MAILBOX_EXT_SIZE)) {
+		rc = -ERANGE;
+		goto job_done;
+	}
 
 	/* allocate our bsg tracking structure */
 	dd_data = kmalloc(sizeof(struct bsg_job_data), GFP_KERNEL);
 	if (!dd_data) {
 		lpfc_printf_log(phba, KERN_WARNING, LOG_LIBDFC,
 				"2727 Failed allocation of dd_data\n");
-		return -ENOMEM;
+		rc = -ENOMEM;
+		goto job_done;
 	}
 
 	mb = kzalloc(PAGE_SIZE, GFP_KERNEL);
 	if (!mb) {
-		kfree(dd_data);
-		return -ENOMEM;
+		rc = -ENOMEM;
+		goto job_done;
 	}
 
 	pmboxq = mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
 	if (!pmboxq) {
-		kfree(dd_data);
-		kfree(mb);
-		return -ENOMEM;
+		rc = -ENOMEM;
+		goto job_done;
 	}
+	memset(pmboxq, 0, sizeof(LPFC_MBOXQ_t));
 
 	size = job->request_payload.payload_len;
-	job->reply->reply_payload_rcv_len =
-		sg_copy_to_buffer(job->request_payload.sg_list,
-				job->request_payload.sg_cnt,
-				mb, size);
+	sg_copy_to_buffer(job->request_payload.sg_list,
+			job->request_payload.sg_cnt,
+			mb, size);
 
 	rc = lpfc_bsg_check_cmd_access(phba, mb, vport);
-	if (rc != 0) {
-		kfree(dd_data);
-		kfree(mb);
-		mempool_free(pmboxq, phba->mbox_mem_pool);
-		return rc; /* must be negative */
-	}
+	if (rc != 0)
+		goto job_done; /* must be negative */
 
-	memset(pmboxq, 0, sizeof(LPFC_MBOXQ_t));
 	pmb = &pmboxq->u.mb;
 	memcpy(pmb, mb, sizeof(*pmb));
 	pmb->mbxOwner = OWN_HOST;
-	pmboxq->context1 = NULL;
 	pmboxq->vport = vport;
 
+	/* extended mailbox commands will need an extended buffer */
+	if (mbox_req->inExtWLen || mbox_req->outWxtWLen) {
+		ext = kzalloc(MAILBOX_EXT_SIZE, GFP_KERNEL);
+		if (!ext) {
+			rc = -ENOMEM;
+			goto job_done;
+		}
+
+		/* any data for the device? */
+		if (mbox_req->inExtWLen) {
+			from = (uint8_t *)mb;
+			from += sizeof(MAILBOX_t);
+			memcpy((uint8_t *)ext, from,
+				mbox_req->inExtWLen * sizeof(uint32_t));
+		}
+
+		pmboxq->context2 = ext;
+		pmboxq->in_ext_byte_len =
+			mbox_req->inExtWLen *
+			sizeof(uint32_t);
+		pmboxq->out_ext_byte_len =
+			mbox_req->outWxtWLen *
+			sizeof(uint32_t);
+		pmboxq->mbox_offset_word =
+			mbox_req->mbOffset;
+		pmboxq->context2 = ext;
+		pmboxq->in_ext_byte_len =
+			mbox_req->inExtWLen * sizeof(uint32_t);
+		pmboxq->out_ext_byte_len =
+			mbox_req->outWxtWLen * sizeof(uint32_t);
+		pmboxq->mbox_offset_word = mbox_req->mbOffset;
+	}
+
+	/* biu diag will need a kernel buffer to transfer the data
+	 * allocate our own buffer and setup the mailbox command to
+	 * use ours
+	 */
+	if (pmb->mbxCommand == MBX_RUN_BIU_DIAG64) {
+		rxbmp = kmalloc(sizeof(struct lpfc_dmabuf), GFP_KERNEL);
+		if (!rxbmp) {
+			rc = -ENOMEM;
+			goto job_done;
+		}
+
+		rxbmp->virt = lpfc_mbuf_alloc(phba, 0, &rxbmp->phys);
+		INIT_LIST_HEAD(&rxbmp->list);
+		rxbpl = (struct ulp_bde64 *) rxbmp->virt;
+		dmp = diag_cmd_data_alloc(phba, rxbpl, PAGE_SIZE, 0);
+		if (!dmp) {
+			rc = -ENOMEM;
+			goto job_done;
+		}
+
+		dmp->size = PAGE_SIZE;
+		INIT_LIST_HEAD(&dmp->dma.list);
+		pmb->un.varBIUdiag.un.s2.xmit_bde64.addrHigh =
+			putPaddrHigh(dmp->dma.phys);
+		pmb->un.varBIUdiag.un.s2.xmit_bde64.addrLow =
+			putPaddrLow(dmp->dma.phys);
+
+		pmb->un.varBIUdiag.un.s2.rcv_bde64.addrHigh =
+			putPaddrHigh(dmp->dma.phys +
+				pmb->un.varBIUdiag.un.s2.
+					xmit_bde64.tus.f.bdeSize);
+		pmb->un.varBIUdiag.un.s2.rcv_bde64.addrLow =
+			putPaddrLow(dmp->dma.phys +
+				pmb->un.varBIUdiag.un.s2.
+					xmit_bde64.tus.f.bdeSize);
+		dd_data->context_un.mbox.rxbmp = rxbmp;
+		dd_data->context_un.mbox.dmp = dmp;
+	} else {
+		dd_data->context_un.mbox.rxbmp = NULL;
+		dd_data->context_un.mbox.dmp = NULL;
+	}
+
+	/* setup wake call as IOCB callback */
+	pmboxq->mbox_cmpl = lpfc_bsg_wake_mbox_wait;
+
+	/* setup context field to pass wait_queue pointer to wake function */
+	pmboxq->context1 = dd_data;
+	dd_data->type = TYPE_MBOX;
+	dd_data->context_un.mbox.pmboxq = pmboxq;
+	dd_data->context_un.mbox.mb = mb;
+	dd_data->context_un.mbox.set_job = job;
+	dd_data->context_un.mbox.ext = ext;
+	dd_data->context_un.mbox.mbOffset = mbox_req->mbOffset;
+	dd_data->context_un.mbox.inExtWLen = mbox_req->inExtWLen;
+	dd_data->context_un.mbox.outWxtWLen = mbox_req->outWxtWLen;
+	job->dd_data = dd_data;
+
 	if ((vport->fc_flag & FC_OFFLINE_MODE) ||
 	    (!(phba->sli.sli_flag & LPFC_SLI_ACTIVE))) {
 		rc = lpfc_sli_issue_mbox(phba, pmboxq, MBX_POLL);
 		if (rc != MBX_SUCCESS) {
-			if (rc != MBX_TIMEOUT) {
-				kfree(dd_data);
-				kfree(mb);
-				mempool_free(pmboxq, phba->mbox_mem_pool);
-			}
-			return  (rc == MBX_TIMEOUT) ? -ETIME : -ENODEV;
+			rc = (rc == MBX_TIMEOUT) ? -ETIME : -ENODEV;
+			goto job_done;
 		}
 
+		/* job finished, copy the data */
 		memcpy(mb, pmb, sizeof(*pmb));
 		job->reply->reply_payload_rcv_len =
 			sg_copy_from_buffer(job->reply_payload.sg_list,
 					job->reply_payload.sg_cnt,
 					mb, size);
-		kfree(dd_data);
-		kfree(mb);
-		mempool_free(pmboxq, phba->mbox_mem_pool);
 		/* not waiting mbox already done */
-		return 0;
+		rc = 0;
+		goto job_done;
 	}
 
-	/* setup wake call as IOCB callback */
-	pmboxq->mbox_cmpl = lpfc_bsg_wake_mbox_wait;
-	/* setup context field to pass wait_queue pointer to wake function */
-	pmboxq->context1 = dd_data;
-	dd_data->type = TYPE_MBOX;
-	dd_data->context_un.mbox.pmboxq = pmboxq;
-	dd_data->context_un.mbox.mb = mb;
-	dd_data->context_un.mbox.set_job = job;
-	job->dd_data = dd_data;
 	rc = lpfc_sli_issue_mbox(phba, pmboxq, MBX_NOWAIT);
-	if ((rc != MBX_SUCCESS) && (rc != MBX_BUSY)) {
-		kfree(dd_data);
-		kfree(mb);
+	if ((rc == MBX_SUCCESS) || (rc == MBX_BUSY))
+		return 1; /* job started */
+
+job_done:
+	/* common exit for error or job completed inline */
+	kfree(mb);
+	if (pmboxq)
 		mempool_free(pmboxq, phba->mbox_mem_pool);
-		return -EIO;
+	kfree(ext);
+	if (dmp) {
+		dma_free_coherent(&phba->pcidev->dev,
+			dmp->size, dmp->dma.virt,
+				dmp->dma.phys);
+		kfree(dmp);
+	}
+	if (rxbmp) {
+		lpfc_mbuf_free(phba, rxbmp->virt, rxbmp->phys);
+		kfree(rxbmp);
 	}
+	kfree(dd_data);
 
-	return 1;
+	return rc;
 }
 
 /**
@@ -2637,6 +2778,11 @@ lpfc_bsg_mbox_cmd(struct fc_bsg_job *job
 		goto job_error;
 	}
 
+	if (job->reply_payload.payload_len != PAGE_SIZE) {
+		rc = -EINVAL;
+		goto job_error;
+	}
+
 	if (phba->sli.sli_flag & LPFC_BLOCK_MGMT_IO) {
 		rc = -EAGAIN;
 		goto job_error;
@@ -3093,6 +3239,7 @@ lpfc_bsg_timeout(struct fc_bsg_job *job)
 		job->dd_data = NULL;
 		job->reply->reply_payload_rcv_len = 0;
 		job->reply->result = -EAGAIN;
+		/* the mbox completion handler can now be run */
 		spin_unlock_irqrestore(&phba->ct_ev_lock, flags);
 		job->job_done(job);
 		break;
diff -upNr a/drivers/scsi/lpfc/lpfc_bsg.h b/drivers/scsi/lpfc/lpfc_bsg.h
--- a/drivers/scsi/lpfc/lpfc_bsg.h	2010-03-05 10:42:37.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_bsg.h	2010-03-15 10:32:12.000000000 -0400
@@ -93,9 +93,9 @@ struct get_mgmt_rev_reply {
 
 struct dfc_mbox_req {
 	uint32_t command;
+	uint32_t mbOffset;
 	uint32_t inExtWLen;
-	uint32_t outExtWLen;
-	uint8_t mbOffset;
+	uint32_t outWxtWLen;
 };
 
 /* Used for menlo command or menlo data. The xri is only used for menlo data */
diff -upNr a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
--- a/drivers/scsi/lpfc/lpfc.h	2010-03-05 10:42:37.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc.h	2010-03-15 10:32:12.000000000 -0400
@@ -554,6 +554,7 @@ struct lpfc_hba {
 	struct lpfc_dmabuf slim2p;
 
 	MAILBOX_t *mbox;
+	uint32_t *mbox_ext;
 	uint32_t *inb_ha_copy;
 	uint32_t *inb_counter;
 	uint32_t inb_last_counter;
@@ -622,6 +623,7 @@ struct lpfc_hba {
 	uint32_t cfg_enable_hba_reset;
 	uint32_t cfg_enable_hba_heartbeat;
 	uint32_t cfg_enable_bg;
+	uint32_t cfg_hostmem_hgp;
 	uint32_t cfg_log_verbose;
 	uint32_t cfg_aer_support;
 	uint32_t cfg_suppress_link_up;
diff -upNr a/drivers/scsi/lpfc/lpfc_hw.h b/drivers/scsi/lpfc/lpfc_hw.h
--- a/drivers/scsi/lpfc/lpfc_hw.h	2010-02-11 17:26:54.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_hw.h	2010-03-15 10:32:12.000000000 -0400
@@ -2934,6 +2934,12 @@ typedef struct {
 /* Union of all Mailbox Command types */
 #define MAILBOX_CMD_WSIZE	32
 #define MAILBOX_CMD_SIZE	(MAILBOX_CMD_WSIZE * sizeof(uint32_t))
+/* ext_wsize times 4 bytes should not be greater than max xmit size */
+#define MAILBOX_EXT_WSIZE	512
+#define MAILBOX_EXT_SIZE	(MAILBOX_EXT_WSIZE * sizeof(uint32_t))
+#define MAILBOX_HBA_EXT_OFFSET  0x100
+/* max mbox xmit size is a page size for sysfs IO operations */
+#define MAILBOX_MAX_XMIT_SIZE   PAGE_SIZE
 
 typedef union {
 	uint32_t varWords[MAILBOX_CMD_WSIZE - 1]; /* first word is type/
@@ -3652,7 +3658,8 @@ typedef struct _IOCB {	/* IOCB structure
 /* Maximum IOCBs that will fit in SLI2 slim */
 #define MAX_SLI2_IOCB    498
 #define MAX_SLIM_IOCB_SIZE (SLI2_SLIM_SIZE - \
-			    (sizeof(MAILBOX_t) + sizeof(PCB_t)))
+			    (sizeof(MAILBOX_t) + sizeof(PCB_t) + \
+			    sizeof(uint32_t) * MAILBOX_EXT_WSIZE))
 
 /* HBQ entries are 4 words each = 4k */
 #define LPFC_TOTAL_HBQ_SIZE (sizeof(struct lpfc_hbq_entry) *  \
@@ -3660,6 +3667,7 @@ typedef struct _IOCB {	/* IOCB structure
 
 struct lpfc_sli2_slim {
 	MAILBOX_t mbx;
+	uint32_t  mbx_ext_words[MAILBOX_EXT_WSIZE];
 	PCB_t pcb;
 	IOCB_t IOCBs[MAX_SLIM_IOCB_SIZE];
 };
diff -upNr a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
--- a/drivers/scsi/lpfc/lpfc_init.c	2010-03-15 10:31:09.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_init.c	2010-03-15 10:32:12.000000000 -0400
@@ -5058,6 +5058,8 @@ lpfc_sli_pci_mem_setup(struct lpfc_hba *
 
 	memset(phba->slim2p.virt, 0, SLI2_SLIM_SIZE);
 	phba->mbox = phba->slim2p.virt + offsetof(struct lpfc_sli2_slim, mbx);
+	phba->mbox_ext = (phba->slim2p.virt +
+		offsetof(struct lpfc_sli2_slim, mbx_ext_words));
 	phba->pcb = (phba->slim2p.virt + offsetof(struct lpfc_sli2_slim, pcb));
 	phba->IOCBs = (phba->slim2p.virt +
 		       offsetof(struct lpfc_sli2_slim, IOCBs));
diff -upNr a/drivers/scsi/lpfc/lpfc_mbox.c b/drivers/scsi/lpfc/lpfc_mbox.c
--- a/drivers/scsi/lpfc/lpfc_mbox.c	2010-03-05 10:42:37.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_mbox.c	2010-03-15 10:32:12.000000000 -0400
@@ -1215,7 +1215,7 @@ lpfc_config_port(struct lpfc_hba *phba, 
 	phba->pcb->feature = FEATURE_INITIAL_SLI2;
 
 	/* Setup Mailbox pointers */
-	phba->pcb->mailBoxSize = sizeof(MAILBOX_t);
+	phba->pcb->mailBoxSize = sizeof(MAILBOX_t) + MAILBOX_EXT_SIZE;
 	offset = (uint8_t *)phba->mbox - (uint8_t *)phba->slim2p.virt;
 	pdma_addr = phba->slim2p.phys + offset;
 	phba->pcb->mbAddrHigh = putPaddrHigh(pdma_addr);
@@ -1271,28 +1271,41 @@ lpfc_config_port(struct lpfc_hba *phba, 
 	 *
 	 */
 
-	if (phba->sli_rev == 3) {
-		phba->host_gp = &mb_slim->us.s3.host[0];
-		phba->hbq_put = &mb_slim->us.s3.hbq_put[0];
-	} else {
-		phba->host_gp = &mb_slim->us.s2.host[0];
+	if (phba->cfg_hostmem_hgp && phba->sli_rev != 3) {
+		phba->host_gp = &phba->mbox->us.s2.host[0];
 		phba->hbq_put = NULL;
-	}
+		offset = (uint8_t *)&phba->mbox->us.s2.host -
+			(uint8_t *)phba->slim2p.virt;
+		pdma_addr = phba->slim2p.phys + offset;
+		phba->pcb->hgpAddrHigh = putPaddrHigh(pdma_addr);
+		phba->pcb->hgpAddrLow = putPaddrLow(pdma_addr);
+	} else {
+		/* Always Host Group Pointer is in SLIM */
+		mb->un.varCfgPort.hps = 1;
 
-	/* mask off BAR0's flag bits 0 - 3 */
-	phba->pcb->hgpAddrLow = (bar_low & PCI_BASE_ADDRESS_MEM_MASK) +
-		(void __iomem *)phba->host_gp -
-		(void __iomem *)phba->MBslimaddr;
-	if (bar_low & PCI_BASE_ADDRESS_MEM_TYPE_64)
-		phba->pcb->hgpAddrHigh = bar_high;
-	else
-		phba->pcb->hgpAddrHigh = 0;
-	/* write HGP data to SLIM at the required longword offset */
-	memset(&hgp, 0, sizeof(struct lpfc_hgp));
+		if (phba->sli_rev == 3) {
+			phba->host_gp = &mb_slim->us.s3.host[0];
+			phba->hbq_put = &mb_slim->us.s3.hbq_put[0];
+		} else {
+			phba->host_gp = &mb_slim->us.s2.host[0];
+			phba->hbq_put = NULL;
+		}
 
-	for (i=0; i < phba->sli.num_rings; i++) {
-		lpfc_memcpy_to_slim(phba->host_gp + i, &hgp,
+		/* mask off BAR0's flag bits 0 - 3 */
+		phba->pcb->hgpAddrLow = (bar_low & PCI_BASE_ADDRESS_MEM_MASK) +
+			(void __iomem *)phba->host_gp -
+			(void __iomem *)phba->MBslimaddr;
+		if (bar_low & PCI_BASE_ADDRESS_MEM_TYPE_64)
+			phba->pcb->hgpAddrHigh = bar_high;
+		else
+			phba->pcb->hgpAddrHigh = 0;
+		/* write HGP data to SLIM at the required longword offset */
+		memset(&hgp, 0, sizeof(struct lpfc_hgp));
+
+		for (i = 0; i < phba->sli.num_rings; i++) {
+			lpfc_memcpy_to_slim(phba->host_gp + i, &hgp,
 				    sizeof(*phba->host_gp));
+		}
 	}
 
 	/* Setup Port Group offset */
diff -upNr a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
--- a/drivers/scsi/lpfc/lpfc_sli.c	2010-03-15 10:31:09.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_sli.c	2010-03-15 10:32:12.000000000 -0400
@@ -4890,9 +4890,34 @@ lpfc_sli_issue_mbox_s3(struct lpfc_hba *
 	mb->mbxOwner = OWN_CHIP;
 
 	if (psli->sli_flag & LPFC_SLI_ACTIVE) {
-		/* First copy command data to host SLIM area */
+		/* Populate mbox extension offset word. */
+		if (pmbox->in_ext_byte_len || pmbox->out_ext_byte_len) {
+			*(((uint32_t *)mb) + pmbox->mbox_offset_word)
+				= (uint8_t *)phba->mbox_ext
+				  - (uint8_t *)phba->mbox;
+		}
+
+		/* Copy the mailbox extension data */
+		if (pmbox->in_ext_byte_len && pmbox->context2) {
+			lpfc_sli_pcimem_bcopy(pmbox->context2,
+				(uint8_t *)phba->mbox_ext,
+				pmbox->in_ext_byte_len);
+		}
+		/* Copy command data to host SLIM area */
 		lpfc_sli_pcimem_bcopy(mb, phba->mbox, MAILBOX_CMD_SIZE);
 	} else {
+		/* Populate mbox extension offset word. */
+		if (pmbox->in_ext_byte_len || pmbox->out_ext_byte_len)
+			*(((uint32_t *)mb) + pmbox->mbox_offset_word)
+				= MAILBOX_HBA_EXT_OFFSET;
+
+		/* Copy the mailbox extension data */
+		if (pmbox->in_ext_byte_len && pmbox->context2) {
+			lpfc_memcpy_to_slim(phba->MBslimaddr +
+				MAILBOX_HBA_EXT_OFFSET,
+				pmbox->context2, pmbox->in_ext_byte_len);
+
+		}
 		if (mb->mbxCommand == MBX_CONFIG_PORT) {
 			/* copy command data into host mbox for cmpl */
 			lpfc_sli_pcimem_bcopy(mb, phba->mbox, MAILBOX_CMD_SIZE);
@@ -5002,15 +5027,22 @@ lpfc_sli_issue_mbox_s3(struct lpfc_hba *
 		if (psli->sli_flag & LPFC_SLI_ACTIVE) {
 			/* copy results back to user */
 			lpfc_sli_pcimem_bcopy(phba->mbox, mb, MAILBOX_CMD_SIZE);
+			/* Copy the mailbox extension data */
+			if (pmbox->out_ext_byte_len && pmbox->context2) {
+				lpfc_sli_pcimem_bcopy(phba->mbox_ext,
+						      pmbox->context2,
+						      pmbox->out_ext_byte_len);
+			}
 		} else {
 			/* First copy command data */
 			lpfc_memcpy_from_slim(mb, phba->MBslimaddr,
 							MAILBOX_CMD_SIZE);
-			if ((mb->mbxCommand == MBX_DUMP_MEMORY) &&
-				pmbox->context2) {
-				lpfc_memcpy_from_slim((void *)pmbox->context2,
-				      phba->MBslimaddr + DMP_RSP_OFFSET,
-						      mb->un.varDmp.word_cnt);
+			/* Copy the mailbox extension data */
+			if (pmbox->out_ext_byte_len && pmbox->context2) {
+				lpfc_memcpy_from_slim(pmbox->context2,
+					phba->MBslimaddr +
+					MAILBOX_HBA_EXT_OFFSET,
+					pmbox->out_ext_byte_len);
 			}
 		}
 
@@ -8132,6 +8164,12 @@ lpfc_sli_sp_intr_handler(int irq, void *
 				if (pmb->mbox_cmpl) {
 					lpfc_sli_pcimem_bcopy(mbox, pmbox,
 							MAILBOX_CMD_SIZE);
+					if (pmb->out_ext_byte_len &&
+						pmb->context2)
+						lpfc_sli_pcimem_bcopy(
+						phba->mbox_ext,
+						pmb->context2,
+						pmb->out_ext_byte_len);
 				}
 				if (pmb->mbox_flag & LPFC_MBX_IMED_UNREG) {
 					pmb->mbox_flag &= ~LPFC_MBX_IMED_UNREG;
diff -upNr a/drivers/scsi/lpfc/lpfc_sli.h b/drivers/scsi/lpfc/lpfc_sli.h
--- a/drivers/scsi/lpfc/lpfc_sli.h	2010-03-05 10:42:37.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_sli.h	2010-03-15 10:32:12.000000000 -0400
@@ -110,6 +110,9 @@ typedef struct lpfcMboxq {
 
 	void (*mbox_cmpl) (struct lpfc_hba *, struct lpfcMboxq *);
 	uint8_t mbox_flag;
+	uint16_t in_ext_byte_len;
+	uint16_t out_ext_byte_len;
+	uint8_t  mbox_offset_word;
 	struct lpfc_mcqe mcqe;
 	struct lpfc_mbx_nembed_sge_virt *sge_array;
 } LPFC_MBOXQ_t;


