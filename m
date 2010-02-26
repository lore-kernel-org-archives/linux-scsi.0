From: James Smart <james.smart@emulex.com>
Subject: [PATCH 4/7] lpfc 8.3.10: Added management for LP21000 through BSG.
Date: Fri, 26 Feb 2010 14:15:00 -0500
Message-ID: <1267211720.3372.6.camel@wookie>
Reply-To: james.smart@emulex.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exht1.emulex.com ([138.239.113.183]:4854 "EHLO
	exht1.ad.emulex.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S965809Ab0BZTPn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 26 Feb 2010 14:15:43 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Added management for LP21000 through BSG.


 Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc.h      |    6 +
 lpfc_bsg.c  |  332 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 lpfc_bsg.h  |   12 ++
 lpfc_init.c |    8 +
 4 files changed, 358 insertions(+)


diff -upNr a/drivers/scsi/lpfc/lpfc_bsg.c b/drivers/scsi/lpfc/lpfc_bsg.c
--- a/drivers/scsi/lpfc/lpfc_bsg.c	2010-02-21 10:49:13.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_bsg.c	2010-02-25 16:34:10.000000000 -0500
@@ -83,15 +83,28 @@ struct lpfc_bsg_mbox {
 	struct fc_bsg_job *set_job;
 };
 
+#define MENLO_DID 0x0000FC0E
+
+struct lpfc_bsg_menlo {
+	struct lpfc_iocbq *cmdiocbq;
+	struct lpfc_iocbq *rspiocbq;
+	struct lpfc_dmabuf *bmp;
+
+	/* job waiting for this iocb to finish */
+	struct fc_bsg_job *set_job;
+};
+
 #define TYPE_EVT 	1
 #define TYPE_IOCB	2
 #define TYPE_MBOX	3
+#define TYPE_MENLO	4
 struct bsg_job_data {
 	uint32_t type;
 	union {
 		struct lpfc_bsg_event *evt;
 		struct lpfc_bsg_iocb iocb;
 		struct lpfc_bsg_mbox mbox;
+		struct lpfc_bsg_menlo menlo;
 	} context_un;
 };
 
@@ -2456,6 +2469,18 @@ static int lpfc_bsg_check_cmd_access(str
 	case MBX_PORT_IOV_CONTROL:
 		break;
 	case MBX_SET_VARIABLE:
+		lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
+			"1226 mbox: set_variable 0x%x, 0x%x\n",
+			mb->un.varWords[0],
+			mb->un.varWords[1]);
+		if ((mb->un.varWords[0] == SETVAR_MLOMNT)
+			&& (mb->un.varWords[1] == 1)) {
+			phba->wait_4_mlo_maint_flg = 1;
+		} else if (mb->un.varWords[0] == SETVAR_MLORST) {
+			phba->link_flag &= ~LS_LOOPBACK_MODE;
+			phba->fc_topology = TOPOLOGY_PT_PT;
+		}
+		break;
 	case MBX_RUN_BIU_DIAG64:
 	case MBX_READ_EVENT_LOG:
 	case MBX_READ_SPARM64:
@@ -2638,6 +2663,297 @@ job_error:
 }
 
 /**
+ * lpfc_bsg_menlo_cmd_cmp - lpfc_menlo_cmd completion handler
+ * @phba: Pointer to HBA context object.
+ * @cmdiocbq: Pointer to command iocb.
+ * @rspiocbq: Pointer to response iocb.
+ *
+ * This function is the completion handler for iocbs issued using
+ * lpfc_menlo_cmd function. This function is called by the
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
+lpfc_bsg_menlo_cmd_cmp(struct lpfc_hba *phba,
+			struct lpfc_iocbq *cmdiocbq,
+			struct lpfc_iocbq *rspiocbq)
+{
+	struct bsg_job_data *dd_data;
+	struct fc_bsg_job *job;
+	IOCB_t *rsp;
+	struct lpfc_dmabuf *bmp;
+	struct lpfc_bsg_menlo *menlo;
+	unsigned long flags;
+	struct menlo_response *menlo_resp;
+	int rc = 0;
+
+	spin_lock_irqsave(&phba->ct_ev_lock, flags);
+	dd_data = cmdiocbq->context1;
+	if (!dd_data) {
+		spin_unlock_irqrestore(&phba->ct_ev_lock, flags);
+		return;
+	}
+
+	menlo = &dd_data->context_un.menlo;
+	job = menlo->set_job;
+	job->dd_data = NULL; /* so timeout handler does not reply */
+
+	spin_lock_irqsave(&phba->hbalock, flags);
+	cmdiocbq->iocb_flag |= LPFC_IO_WAKE;
+	if (cmdiocbq->context2 && rspiocbq)
+		memcpy(&((struct lpfc_iocbq *)cmdiocbq->context2)->iocb,
+		       &rspiocbq->iocb, sizeof(IOCB_t));
+	spin_unlock_irqrestore(&phba->hbalock, flags);
+
+	bmp = menlo->bmp;
+	rspiocbq = menlo->rspiocbq;
+	rsp = &rspiocbq->iocb;
+
+	pci_unmap_sg(phba->pcidev, job->request_payload.sg_list,
+		     job->request_payload.sg_cnt, DMA_TO_DEVICE);
+	pci_unmap_sg(phba->pcidev, job->reply_payload.sg_list,
+		     job->reply_payload.sg_cnt, DMA_FROM_DEVICE);
+
+	/* always return the xri, this would be used in the case
+	 * of a menlo download to allow the data to be sent as a continuation
+	 * of the exchange.
+	 */
+	menlo_resp = (struct menlo_response *)
+		job->reply->reply_data.vendor_reply.vendor_rsp;
+	menlo_resp->xri = rsp->ulpContext;
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
+/**
+ * lpfc_menlo_cmd - send an ioctl for menlo hardware
+ * @job: fc_bsg_job to handle
+ *
+ * This function issues a gen request 64 CR ioctl for all menlo cmd requests,
+ * all the command completions will return the xri for the command.
+ * For menlo data requests a gen request 64 CX is used to continue the exchange
+ * supplied in the menlo request header xri field.
+ **/
+static int
+lpfc_menlo_cmd(struct fc_bsg_job *job)
+{
+	struct lpfc_vport *vport = (struct lpfc_vport *)job->shost->hostdata;
+	struct lpfc_hba *phba = vport->phba;
+	struct lpfc_iocbq *cmdiocbq, *rspiocbq;
+	IOCB_t *cmd, *rsp;
+	int rc = 0;
+	struct menlo_command *menlo_cmd;
+	struct menlo_response *menlo_resp;
+	struct lpfc_dmabuf *bmp = NULL;
+	int request_nseg;
+	int reply_nseg;
+	struct scatterlist *sgel = NULL;
+	int numbde;
+	dma_addr_t busaddr;
+	struct bsg_job_data *dd_data;
+	struct ulp_bde64 *bpl = NULL;
+
+	/* in case no data is returned return just the return code */
+	job->reply->reply_payload_rcv_len = 0;
+
+	if (job->request_len <
+	    sizeof(struct fc_bsg_request) +
+		sizeof(struct menlo_command)) {
+		lpfc_printf_log(phba, KERN_WARNING, LOG_LIBDFC,
+				"2784 Received MENLO_CMD request below "
+				"minimum size\n");
+		rc = -ERANGE;
+		goto no_dd_data;
+	}
+
+	if (job->reply_len <
+	    sizeof(struct fc_bsg_request) + sizeof(struct menlo_response)) {
+		lpfc_printf_log(phba, KERN_WARNING, LOG_LIBDFC,
+				"2785 Received MENLO_CMD reply below "
+				"minimum size\n");
+		rc = -ERANGE;
+		goto no_dd_data;
+	}
+
+	if (!(phba->menlo_flag & HBA_MENLO_SUPPORT)) {
+		lpfc_printf_log(phba, KERN_WARNING, LOG_LIBDFC,
+				"2786 Adapter does not support menlo "
+				"commands\n");
+		rc = -EPERM;
+		goto no_dd_data;
+	}
+
+	menlo_cmd = (struct menlo_command *)
+		job->request->rqst_data.h_vendor.vendor_cmd;
+
+	menlo_resp = (struct menlo_response *)
+		job->reply->reply_data.vendor_reply.vendor_rsp;
+
+	/* allocate our bsg tracking structure */
+	dd_data = kmalloc(sizeof(struct bsg_job_data), GFP_KERNEL);
+	if (!dd_data) {
+		lpfc_printf_log(phba, KERN_WARNING, LOG_LIBDFC,
+				"2787 Failed allocation of dd_data\n");
+		rc = -ENOMEM;
+		goto no_dd_data;
+	}
+
+	bmp = kmalloc(sizeof(struct lpfc_dmabuf), GFP_KERNEL);
+	if (!bmp) {
+		rc = -ENOMEM;
+		goto free_dd;
+	}
+
+	cmdiocbq = lpfc_sli_get_iocbq(phba);
+	if (!cmdiocbq) {
+		rc = -ENOMEM;
+		goto free_bmp;
+	}
+
+	rspiocbq = lpfc_sli_get_iocbq(phba);
+	if (!rspiocbq) {
+		rc = -ENOMEM;
+		goto free_cmdiocbq;
+	}
+
+	rsp = &rspiocbq->iocb;
+
+	bmp->virt = lpfc_mbuf_alloc(phba, 0, &bmp->phys);
+	if (!bmp->virt) {
+		rc = -ENOMEM;
+		goto free_rspiocbq;
+	}
+
+	INIT_LIST_HEAD(&bmp->list);
+	bpl = (struct ulp_bde64 *) bmp->virt;
+	request_nseg = pci_map_sg(phba->pcidev, job->request_payload.sg_list,
+				  job->request_payload.sg_cnt, DMA_TO_DEVICE);
+	for_each_sg(job->request_payload.sg_list, sgel, request_nseg, numbde) {
+		busaddr = sg_dma_address(sgel);
+		bpl->tus.f.bdeFlags = BUFF_TYPE_BDE_64;
+		bpl->tus.f.bdeSize = sg_dma_len(sgel);
+		bpl->tus.w = cpu_to_le32(bpl->tus.w);
+		bpl->addrLow = cpu_to_le32(putPaddrLow(busaddr));
+		bpl->addrHigh = cpu_to_le32(putPaddrHigh(busaddr));
+		bpl++;
+	}
+
+	reply_nseg = pci_map_sg(phba->pcidev, job->reply_payload.sg_list,
+				job->reply_payload.sg_cnt, DMA_FROM_DEVICE);
+	for_each_sg(job->reply_payload.sg_list, sgel, reply_nseg, numbde) {
+		busaddr = sg_dma_address(sgel);
+		bpl->tus.f.bdeFlags = BUFF_TYPE_BDE_64I;
+		bpl->tus.f.bdeSize = sg_dma_len(sgel);
+		bpl->tus.w = cpu_to_le32(bpl->tus.w);
+		bpl->addrLow = cpu_to_le32(putPaddrLow(busaddr));
+		bpl->addrHigh = cpu_to_le32(putPaddrHigh(busaddr));
+		bpl++;
+	}
+
+	cmd = &cmdiocbq->iocb;
+	cmd->un.genreq64.bdl.ulpIoTag32 = 0;
+	cmd->un.genreq64.bdl.addrHigh = putPaddrHigh(bmp->phys);
+	cmd->un.genreq64.bdl.addrLow = putPaddrLow(bmp->phys);
+	cmd->un.genreq64.bdl.bdeFlags = BUFF_TYPE_BLP_64;
+	cmd->un.genreq64.bdl.bdeSize =
+	    (request_nseg + reply_nseg) * sizeof(struct ulp_bde64);
+	cmd->un.genreq64.w5.hcsw.Fctl = (SI | LA);
+	cmd->un.genreq64.w5.hcsw.Dfctl = 0;
+	cmd->un.genreq64.w5.hcsw.Rctl = FC_RCTL_DD_UNSOL_CMD;
+	cmd->un.genreq64.w5.hcsw.Type = MENLO_TRANSPORT_TYPE; /* 0xfe */
+	cmd->ulpBdeCount = 1;
+	cmd->ulpClass = CLASS3;
+	cmd->ulpOwner = OWN_CHIP;
+	cmd->ulpLe = 1; /* Limited Edition */
+	cmdiocbq->iocb_flag |= LPFC_IO_LIBDFC;
+	cmdiocbq->vport = phba->pport;
+	/* We want the firmware to timeout before we do */
+	cmd->ulpTimeout = MENLO_TIMEOUT - 5;
+	cmdiocbq->context3 = bmp;
+	cmdiocbq->context2 = rspiocbq;
+	cmdiocbq->iocb_cmpl = lpfc_bsg_menlo_cmd_cmp;
+	cmdiocbq->context1 = dd_data;
+	cmdiocbq->context2 = rspiocbq;
+	if (menlo_cmd->cmd == LPFC_BSG_VENDOR_MENLO_CMD) {
+		cmd->ulpCommand = CMD_GEN_REQUEST64_CR;
+		cmd->ulpPU = MENLO_PU; /* 3 */
+		cmd->un.ulpWord[4] = MENLO_DID; /* 0x0000FC0E */
+		cmd->ulpContext = MENLO_CONTEXT; /* 0 */
+	} else {
+		cmd->ulpCommand = CMD_GEN_REQUEST64_CX;
+		cmd->ulpPU = 1;
+		cmd->un.ulpWord[4] = 0;
+		cmd->ulpContext = menlo_cmd->xri;
+	}
+
+	dd_data->type = TYPE_MENLO;
+	dd_data->context_un.menlo.cmdiocbq = cmdiocbq;
+	dd_data->context_un.menlo.rspiocbq = rspiocbq;
+	dd_data->context_un.menlo.set_job = job;
+	dd_data->context_un.menlo.bmp = bmp;
+
+	rc = lpfc_sli_issue_iocb(phba, LPFC_ELS_RING, cmdiocbq,
+		MENLO_TIMEOUT - 5);
+	if (rc == IOCB_SUCCESS)
+		return 0; /* done for now */
+
+	/* iocb failed so cleanup */
+	pci_unmap_sg(phba->pcidev, job->request_payload.sg_list,
+		     job->request_payload.sg_cnt, DMA_TO_DEVICE);
+	pci_unmap_sg(phba->pcidev, job->reply_payload.sg_list,
+		     job->reply_payload.sg_cnt, DMA_FROM_DEVICE);
+
+	lpfc_mbuf_free(phba, bmp->virt, bmp->phys);
+
+free_rspiocbq:
+	lpfc_sli_release_iocbq(phba, rspiocbq);
+free_cmdiocbq:
+	lpfc_sli_release_iocbq(phba, cmdiocbq);
+free_bmp:
+	kfree(bmp);
+free_dd:
+	kfree(dd_data);
+no_dd_data:
+	/* make error code available to userspace */
+	job->reply->result = rc;
+	job->dd_data = NULL;
+	return rc;
+}
+/**
  * lpfc_bsg_hst_vendor - process a vendor-specific fc_bsg_job
  * @job: fc_bsg_job to handle
  **/
@@ -2669,6 +2985,10 @@ lpfc_bsg_hst_vendor(struct fc_bsg_job *j
 	case LPFC_BSG_VENDOR_MBOX:
 		rc = lpfc_bsg_mbox_cmd(job);
 		break;
+	case LPFC_BSG_VENDOR_MENLO_CMD:
+	case LPFC_BSG_VENDOR_MENLO_DATA:
+		rc = lpfc_menlo_cmd(job);
+		break;
 	default:
 		rc = -EINVAL;
 		job->reply->reply_payload_rcv_len = 0;
@@ -2728,6 +3048,7 @@ lpfc_bsg_timeout(struct fc_bsg_job *job)
 	struct lpfc_bsg_event *evt;
 	struct lpfc_bsg_iocb *iocb;
 	struct lpfc_bsg_mbox *mbox;
+	struct lpfc_bsg_menlo *menlo;
 	struct lpfc_sli_ring *pring = &phba->sli.ring[LPFC_ELS_RING];
 	struct bsg_job_data *dd_data;
 	unsigned long flags;
@@ -2775,6 +3096,17 @@ lpfc_bsg_timeout(struct fc_bsg_job *job)
 		spin_unlock_irqrestore(&phba->ct_ev_lock, flags);
 		job->job_done(job);
 		break;
+	case TYPE_MENLO:
+		menlo = &dd_data->context_un.menlo;
+		cmdiocb = menlo->cmdiocbq;
+		/* hint to completion handler that the job timed out */
+		job->reply->result = -EAGAIN;
+		spin_unlock_irqrestore(&phba->ct_ev_lock, flags);
+		/* this will call our completion handler */
+		spin_lock_irq(&phba->hbalock);
+		lpfc_sli_issue_abort_iotag(phba, pring, cmdiocb);
+		spin_unlock_irq(&phba->hbalock);
+		break;
 	default:
 		spin_unlock_irqrestore(&phba->ct_ev_lock, flags);
 		break;
diff -upNr a/drivers/scsi/lpfc/lpfc_bsg.h b/drivers/scsi/lpfc/lpfc_bsg.h
--- a/drivers/scsi/lpfc/lpfc_bsg.h	2010-02-11 17:26:54.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_bsg.h	2010-02-25 16:34:10.000000000 -0500
@@ -31,6 +31,8 @@
 #define LPFC_BSG_VENDOR_DIAG_TEST	5
 #define LPFC_BSG_VENDOR_GET_MGMT_REV	6
 #define LPFC_BSG_VENDOR_MBOX		7
+#define LPFC_BSG_VENDOR_MENLO_CMD	8
+#define LPFC_BSG_VENDOR_MENLO_DATA	9
 
 struct set_ct_event {
 	uint32_t command;
@@ -96,3 +98,13 @@ struct dfc_mbox_req {
 	uint8_t mbOffset;
 };
 
+/* Used for menlo command or menlo data. The xri is only used for menlo data */
+struct menlo_command {
+	uint32_t cmd;
+	uint32_t xri;
+};
+
+struct menlo_response {
+	uint32_t xri; /* return the xri of the iocb exchange */
+};
+
diff -upNr a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
--- a/drivers/scsi/lpfc/lpfc.h	2010-02-25 16:33:47.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc.h	2010-02-25 16:34:10.000000000 -0500
@@ -37,6 +37,9 @@ struct lpfc_sli2_slim;
 					   the NameServer  before giving up. */
 #define LPFC_CMD_PER_LUN	3	/* max outstanding cmds per lun */
 #define LPFC_DEFAULT_SG_SEG_CNT 64	/* sg element count per scsi cmnd */
+#define LPFC_DEFAULT_MENLO_SG_SEG_CNT 128	/* sg element count per scsi
+		cmnd for menlo needs nearly twice as for firmware
+		downloads using bsg */
 #define LPFC_DEFAULT_PROT_SG_SEG_CNT 4096 /* sg protection elements count */
 #define LPFC_MAX_SG_SEG_CNT	4096	/* sg element count per scsi cmnd */
 #define LPFC_MAX_PROT_SG_SEG_CNT 4096	/* prot sg element count per scsi cmd*/
@@ -806,6 +809,9 @@ struct lpfc_hba {
 	struct list_head ct_ev_waiters;
 	struct unsol_rcv_ct_ctx ct_ctx[64];
 	uint32_t ctx_idx;
+
+	uint8_t menlo_flag;	/* menlo generic flags */
+#define HBA_MENLO_SUPPORT	0x1 /* HBA supports menlo commands */
 };
 
 static inline struct Scsi_Host *
diff -upNr a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
--- a/drivers/scsi/lpfc/lpfc_init.c	2010-02-25 16:33:47.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_init.c	2010-02-25 16:34:10.000000000 -0500
@@ -2597,6 +2597,14 @@ lpfc_create_port(struct lpfc_hba *phba, 
 	init_timer(&vport->els_tmofunc);
 	vport->els_tmofunc.function = lpfc_els_timeout;
 	vport->els_tmofunc.data = (unsigned long)vport;
+	if (phba->pcidev->device == PCI_DEVICE_ID_HORNET) {
+		phba->menlo_flag |= HBA_MENLO_SUPPORT;
+		/* check for menlo minimum sg count */
+		if (phba->cfg_sg_seg_cnt < LPFC_DEFAULT_MENLO_SG_SEG_CNT) {
+			phba->cfg_sg_seg_cnt = LPFC_DEFAULT_MENLO_SG_SEG_CNT;
+			shost->sg_tablesize = phba->cfg_sg_seg_cnt;
+		}
+	}
 
 	error = scsi_add_host_with_dma(shost, dev, &phba->pcidev->dev);
 	if (error)


