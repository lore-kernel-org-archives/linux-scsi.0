From: James Smart <james.smart@emulex.com>
Subject: [PATCH 5/7] lpfc 8.3.12: BSG Fixes and enhancements
Date: Tue, 6 Apr 2010 15:05:28 -0400
Message-ID: <1270580748.28785.2.camel@wookie>
Reply-To: james.smart@emulex.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exht1.emulex.com ([138.239.113.183]:15926 "EHLO
	exht1.ad.emulex.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757084Ab0DFTGL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Apr 2010 15:06:11 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


- Add memcpy to mailbox completion to transfer reply correctly.
- Add support for BSG mailbox commands (dump, update_cfg, and
   event_log_status).
- Add warning message and refuse mailbox command while mgmt is blocked.
- Add checks for memory allocation failure.
- Add check for sli4 dump zero BDE size.
- Only copy data if mailbox commands succeed.
- Add support for Read Event Log mailbox command.

 Signed-off-by: Alex Iannicelli <alex.iannicelli@emulex.com>
 Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_bsg.c |  274 ++++++++++++++++++++++++++++++++++++++++++++++++++++---------
 lpfc_bsg.h |    2 
 lpfc_hw.h  |   14 +++
 lpfc_sli.c |    2 
 4 files changed, 253 insertions(+), 39 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_bsg.c b/drivers/scsi/lpfc/lpfc_bsg.c
--- a/drivers/scsi/lpfc/lpfc_bsg.c	2010-04-06 12:58:02.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_bsg.c	2010-04-06 12:58:41.000000000 -0400
@@ -83,7 +83,7 @@ struct lpfc_bsg_mbox {
 	uint8_t *ext; /* extended mailbox data */
 	uint32_t mbOffset; /* from app */
 	uint32_t inExtWLen; /* from app */
-	uint32_t outWxtWLen; /* from app */
+	uint32_t outExtWLen; /* from app */
 
 	/* job waiting for this mbox command to finish */
 	struct fc_bsg_job *set_job;
@@ -1713,21 +1713,26 @@ static int lpfcdiag_loop_get_xri(struct 
 	dmabuf = kmalloc(sizeof(struct lpfc_dmabuf), GFP_KERNEL);
 	if (dmabuf) {
 		dmabuf->virt = lpfc_mbuf_alloc(phba, 0, &dmabuf->phys);
-		INIT_LIST_HEAD(&dmabuf->list);
-		bpl = (struct ulp_bde64 *) dmabuf->virt;
-		memset(bpl, 0, sizeof(*bpl));
-		ctreq = (struct lpfc_sli_ct_request *)(bpl + 1);
-		bpl->addrHigh =
-			le32_to_cpu(putPaddrHigh(dmabuf->phys + sizeof(*bpl)));
-		bpl->addrLow =
-			le32_to_cpu(putPaddrLow(dmabuf->phys + sizeof(*bpl)));
-		bpl->tus.f.bdeFlags = 0;
-		bpl->tus.f.bdeSize = ELX_LOOPBACK_HEADER_SZ;
-		bpl->tus.w = le32_to_cpu(bpl->tus.w);
+		if (dmabuf->virt) {
+			INIT_LIST_HEAD(&dmabuf->list);
+			bpl = (struct ulp_bde64 *) dmabuf->virt;
+			memset(bpl, 0, sizeof(*bpl));
+			ctreq = (struct lpfc_sli_ct_request *)(bpl + 1);
+			bpl->addrHigh =
+				le32_to_cpu(putPaddrHigh(dmabuf->phys +
+					sizeof(*bpl)));
+			bpl->addrLow =
+				le32_to_cpu(putPaddrLow(dmabuf->phys +
+					sizeof(*bpl)));
+			bpl->tus.f.bdeFlags = 0;
+			bpl->tus.f.bdeSize = ELX_LOOPBACK_HEADER_SZ;
+			bpl->tus.w = le32_to_cpu(bpl->tus.w);
+		}
 	}
 
 	if (cmdiocbq == NULL || rspiocbq == NULL ||
-	    dmabuf == NULL || bpl == NULL || ctreq == NULL) {
+	    dmabuf == NULL || bpl == NULL || ctreq == NULL ||
+		dmabuf->virt == NULL) {
 		ret_val = ENOMEM;
 		goto err_get_xri_exit;
 	}
@@ -1923,9 +1928,11 @@ static int lpfcdiag_loop_post_rxbufs(str
 	rxbmp = kmalloc(sizeof(struct lpfc_dmabuf), GFP_KERNEL);
 	if (rxbmp != NULL) {
 		rxbmp->virt = lpfc_mbuf_alloc(phba, 0, &rxbmp->phys);
-		INIT_LIST_HEAD(&rxbmp->list);
-		rxbpl = (struct ulp_bde64 *) rxbmp->virt;
-		rxbuffer = diag_cmd_data_alloc(phba, rxbpl, len, 0);
+		if (rxbmp->virt) {
+			INIT_LIST_HEAD(&rxbmp->list);
+			rxbpl = (struct ulp_bde64 *) rxbmp->virt;
+			rxbuffer = diag_cmd_data_alloc(phba, rxbpl, len, 0);
+		}
 	}
 
 	if (!cmdiocbq || !rxbmp || !rxbpl || !rxbuffer) {
@@ -2179,14 +2186,16 @@ lpfc_bsg_diag_test(struct fc_bsg_job *jo
 
 	if (txbmp) {
 		txbmp->virt = lpfc_mbuf_alloc(phba, 0, &txbmp->phys);
-		INIT_LIST_HEAD(&txbmp->list);
-		txbpl = (struct ulp_bde64 *) txbmp->virt;
-		if (txbpl)
+		if (txbmp->virt) {
+			INIT_LIST_HEAD(&txbmp->list);
+			txbpl = (struct ulp_bde64 *) txbmp->virt;
 			txbuffer = diag_cmd_data_alloc(phba,
 							txbpl, full_size, 0);
+		}
 	}
 
-	if (!cmdiocbq || !rspiocbq || !txbmp || !txbpl || !txbuffer) {
+	if (!cmdiocbq || !rspiocbq || !txbmp || !txbpl || !txbuffer ||
+		!txbmp->virt) {
 		rc = -ENOMEM;
 		goto err_loopback_test_exit;
 	}
@@ -2403,12 +2412,34 @@ lpfc_bsg_wake_mbox_wait(struct lpfc_hba 
 	from = (uint8_t *)&pmboxq->u.mb;
 	to = (uint8_t *)dd_data->context_un.mbox.mb;
 	memcpy(to, from, sizeof(MAILBOX_t));
-	/* copy the extended data if any, count is in words */
-	if (dd_data->context_un.mbox.outWxtWLen) {
-		from = (uint8_t *)dd_data->context_un.mbox.ext;
-		to += sizeof(MAILBOX_t);
-		memcpy(to, from,
-		dd_data->context_un.mbox.outWxtWLen * sizeof(uint32_t));
+	if (pmboxq->u.mb.mbxStatus == MBX_SUCCESS) {
+		/* copy the extended data if any, count is in words */
+		if (dd_data->context_un.mbox.outExtWLen) {
+			from = (uint8_t *)dd_data->context_un.mbox.ext;
+			to += sizeof(MAILBOX_t);
+			size = dd_data->context_un.mbox.outExtWLen *
+					sizeof(uint32_t);
+			memcpy(to, from, size);
+		} else if (pmboxq->u.mb.mbxCommand == MBX_RUN_BIU_DIAG64) {
+			from = (uint8_t *)dd_data->context_un.mbox.
+						dmp->dma.virt;
+			to += sizeof(MAILBOX_t);
+			size = dd_data->context_un.mbox.dmp->size;
+			memcpy(to, from, size);
+		} else if ((phba->sli_rev == LPFC_SLI_REV4) &&
+			(pmboxq->u.mb.mbxCommand == MBX_DUMP_MEMORY)) {
+			from = (uint8_t *)dd_data->context_un.mbox.dmp->dma.
+						virt;
+			to += sizeof(MAILBOX_t);
+			size = pmboxq->u.mb.un.varWords[5];
+			memcpy(to, from, size);
+		} else if (pmboxq->u.mb.mbxCommand == MBX_READ_EVENT_LOG) {
+			from = (uint8_t *)dd_data->context_un.
+						mbox.dmp->dma.virt;
+			to += sizeof(MAILBOX_t);
+			size = dd_data->context_un.mbox.dmp->size;
+			memcpy(to, from, size);
+		}
 	}
 
 	from = (uint8_t *)dd_data->context_un.mbox.mb;
@@ -2502,6 +2533,7 @@ static int lpfc_bsg_check_cmd_access(str
 	case MBX_SET_DEBUG:
 	case MBX_WRITE_WWN:
 	case MBX_SLI4_CONFIG:
+	case MBX_READ_EVENT_LOG:
 	case MBX_READ_EVENT_LOG_STATUS:
 	case MBX_WRITE_EVENT_LOG:
 	case MBX_PORT_CAPABILITIES:
@@ -2521,7 +2553,6 @@ static int lpfc_bsg_check_cmd_access(str
 			phba->fc_topology = TOPOLOGY_PT_PT;
 		}
 		break;
-	case MBX_READ_EVENT_LOG:
 	case MBX_READ_SPARM64:
 	case MBX_READ_LA:
 	case MBX_READ_LA64:
@@ -2576,7 +2607,7 @@ lpfc_bsg_issue_mbox(struct lpfc_hba *phb
 
 	/* check if requested extended data lengths are valid */
 	if ((mbox_req->inExtWLen > MAILBOX_EXT_SIZE) ||
-		(mbox_req->outWxtWLen > MAILBOX_EXT_SIZE)) {
+		(mbox_req->outExtWLen > MAILBOX_EXT_SIZE)) {
 		rc = -ERANGE;
 		goto job_done;
 	}
@@ -2617,8 +2648,29 @@ lpfc_bsg_issue_mbox(struct lpfc_hba *phb
 	pmb->mbxOwner = OWN_HOST;
 	pmboxq->vport = vport;
 
+	/* If HBA encountered an error attention, allow only DUMP
+	 * or RESTART mailbox commands until the HBA is restarted.
+	 */
+	if (phba->pport->stopped &&
+	    pmb->mbxCommand != MBX_DUMP_MEMORY &&
+	    pmb->mbxCommand != MBX_RESTART &&
+	    pmb->mbxCommand != MBX_WRITE_VPARMS &&
+	    pmb->mbxCommand != MBX_WRITE_WWN)
+		lpfc_printf_log(phba, KERN_WARNING, LOG_MBOX,
+				"2797 mbox: Issued mailbox cmd "
+				"0x%x while in stopped state.\n",
+				pmb->mbxCommand);
+
+	/* Don't allow mailbox commands to be sent when blocked
+	 * or when in the middle of discovery
+	 */
+	if (phba->sli.sli_flag & LPFC_BLOCK_MGMT_IO) {
+		rc = -EAGAIN;
+		goto job_done;
+	}
+
 	/* extended mailbox commands will need an extended buffer */
-	if (mbox_req->inExtWLen || mbox_req->outWxtWLen) {
+	if (mbox_req->inExtWLen || mbox_req->outExtWLen) {
 		ext = kzalloc(MAILBOX_EXT_SIZE, GFP_KERNEL);
 		if (!ext) {
 			rc = -ENOMEM;
@@ -2638,7 +2690,7 @@ lpfc_bsg_issue_mbox(struct lpfc_hba *phb
 			mbox_req->inExtWLen *
 			sizeof(uint32_t);
 		pmboxq->out_ext_byte_len =
-			mbox_req->outWxtWLen *
+			mbox_req->outExtWLen *
 			sizeof(uint32_t);
 		pmboxq->mbox_offset_word =
 			mbox_req->mbOffset;
@@ -2646,7 +2698,7 @@ lpfc_bsg_issue_mbox(struct lpfc_hba *phb
 		pmboxq->in_ext_byte_len =
 			mbox_req->inExtWLen * sizeof(uint32_t);
 		pmboxq->out_ext_byte_len =
-			mbox_req->outWxtWLen * sizeof(uint32_t);
+			mbox_req->outExtWLen * sizeof(uint32_t);
 		pmboxq->mbox_offset_word = mbox_req->mbOffset;
 	}
 
@@ -2655,6 +2707,17 @@ lpfc_bsg_issue_mbox(struct lpfc_hba *phb
 	 * use ours
 	 */
 	if (pmb->mbxCommand == MBX_RUN_BIU_DIAG64) {
+		uint32_t transmit_length = pmb->un.varWords[1];
+		uint32_t receive_length = pmb->un.varWords[4];
+		/* transmit length cannot be greater than receive length or
+		 * mailbox extension size
+		 */
+		if ((transmit_length > receive_length) ||
+			(transmit_length > MAILBOX_EXT_SIZE)) {
+			rc = -ERANGE;
+			goto job_done;
+		}
+
 		rxbmp = kmalloc(sizeof(struct lpfc_dmabuf), GFP_KERNEL);
 		if (!rxbmp) {
 			rc = -ENOMEM;
@@ -2662,9 +2725,14 @@ lpfc_bsg_issue_mbox(struct lpfc_hba *phb
 		}
 
 		rxbmp->virt = lpfc_mbuf_alloc(phba, 0, &rxbmp->phys);
+		if (!rxbmp->virt) {
+			rc = -ENOMEM;
+			goto job_done;
+		}
+
 		INIT_LIST_HEAD(&rxbmp->list);
 		rxbpl = (struct ulp_bde64 *) rxbmp->virt;
-		dmp = diag_cmd_data_alloc(phba, rxbpl, BSG_MBOX_SIZE, 0);
+		dmp = diag_cmd_data_alloc(phba, rxbpl, transmit_length, 0);
 		if (!dmp) {
 			rc = -ENOMEM;
 			goto job_done;
@@ -2684,13 +2752,143 @@ lpfc_bsg_issue_mbox(struct lpfc_hba *phb
 			putPaddrLow(dmp->dma.phys +
 				pmb->un.varBIUdiag.un.s2.
 					xmit_bde64.tus.f.bdeSize);
-		dd_data->context_un.mbox.rxbmp = rxbmp;
-		dd_data->context_un.mbox.dmp = dmp;
-	} else {
-		dd_data->context_un.mbox.rxbmp = NULL;
-		dd_data->context_un.mbox.dmp = NULL;
+
+		/* copy the transmit data found in the mailbox extension area */
+		from = (uint8_t *)mb;
+		from += sizeof(MAILBOX_t);
+		memcpy((uint8_t *)dmp->dma.virt, from, transmit_length);
+	} else if (pmb->mbxCommand == MBX_READ_EVENT_LOG) {
+		struct READ_EVENT_LOG_VAR *rdEventLog =
+			&pmb->un.varRdEventLog ;
+		uint32_t receive_length = rdEventLog->rcv_bde64.tus.f.bdeSize;
+		uint32_t mode =	 bf_get(lpfc_event_log, rdEventLog);
+
+		/* receive length cannot be greater than mailbox
+		 * extension size
+		 */
+		if (receive_length > MAILBOX_EXT_SIZE) {
+			rc = -ERANGE;
+			goto job_done;
+		}
+
+		/* mode zero uses a bde like biu diags command */
+		if (mode == 0) {
+
+			/* rebuild the command for sli4 using our own buffers
+			* like we do for biu diags
+			*/
+
+			rxbmp = kmalloc(sizeof(struct lpfc_dmabuf), GFP_KERNEL);
+			if (!rxbmp) {
+				rc = -ENOMEM;
+				goto job_done;
+			}
+
+			rxbmp->virt = lpfc_mbuf_alloc(phba, 0, &rxbmp->phys);
+			rxbpl = (struct ulp_bde64 *) rxbmp->virt;
+			if (rxbpl) {
+				INIT_LIST_HEAD(&rxbmp->list);
+				dmp = diag_cmd_data_alloc(phba, rxbpl,
+					receive_length, 0);
+			}
+
+			if (!dmp) {
+				rc = -ENOMEM;
+				goto job_done;
+			}
+
+			INIT_LIST_HEAD(&dmp->dma.list);
+			pmb->un.varWords[3] = putPaddrLow(dmp->dma.phys);
+			pmb->un.varWords[4] = putPaddrHigh(dmp->dma.phys);
+		}
+	} else if (phba->sli_rev == LPFC_SLI_REV4) {
+		if (pmb->mbxCommand == MBX_DUMP_MEMORY) {
+			/* rebuild the command for sli4 using our own buffers
+			* like we do for biu diags
+			*/
+			uint32_t receive_length = pmb->un.varWords[2];
+			/* receive length cannot be greater than mailbox
+			 * extension size
+			 */
+			if ((receive_length == 0) ||
+				(receive_length > MAILBOX_EXT_SIZE)) {
+				rc = -ERANGE;
+				goto job_done;
+			}
+
+			rxbmp = kmalloc(sizeof(struct lpfc_dmabuf), GFP_KERNEL);
+			if (!rxbmp) {
+				rc = -ENOMEM;
+				goto job_done;
+			}
+
+			rxbmp->virt = lpfc_mbuf_alloc(phba, 0, &rxbmp->phys);
+			if (!rxbmp->virt) {
+				rc = -ENOMEM;
+				goto job_done;
+			}
+
+			INIT_LIST_HEAD(&rxbmp->list);
+			rxbpl = (struct ulp_bde64 *) rxbmp->virt;
+			dmp = diag_cmd_data_alloc(phba, rxbpl, receive_length,
+						0);
+			if (!dmp) {
+				rc = -ENOMEM;
+				goto job_done;
+			}
+
+			INIT_LIST_HEAD(&dmp->dma.list);
+			pmb->un.varWords[3] = putPaddrLow(dmp->dma.phys);
+			pmb->un.varWords[4] = putPaddrHigh(dmp->dma.phys);
+		} else if ((pmb->mbxCommand == MBX_UPDATE_CFG) &&
+			pmb->un.varUpdateCfg.co) {
+			struct ulp_bde64 *bde =
+				(struct ulp_bde64 *)&pmb->un.varWords[4];
+
+			/* bde size cannot be greater than mailbox ext size */
+			if (bde->tus.f.bdeSize > MAILBOX_EXT_SIZE) {
+				rc = -ERANGE;
+				goto job_done;
+			}
+
+			rxbmp = kmalloc(sizeof(struct lpfc_dmabuf), GFP_KERNEL);
+			if (!rxbmp) {
+				rc = -ENOMEM;
+				goto job_done;
+			}
+
+			rxbmp->virt = lpfc_mbuf_alloc(phba, 0, &rxbmp->phys);
+			if (!rxbmp->virt) {
+				rc = -ENOMEM;
+				goto job_done;
+			}
+
+			INIT_LIST_HEAD(&rxbmp->list);
+			rxbpl = (struct ulp_bde64 *) rxbmp->virt;
+			dmp = diag_cmd_data_alloc(phba, rxbpl,
+					bde->tus.f.bdeSize, 0);
+			if (!dmp) {
+				rc = -ENOMEM;
+				goto job_done;
+			}
+
+			INIT_LIST_HEAD(&dmp->dma.list);
+			bde->addrHigh = putPaddrHigh(dmp->dma.phys);
+			bde->addrLow = putPaddrLow(dmp->dma.phys);
+
+			/* copy the transmit data found in the mailbox
+			 * extension area
+			 */
+			from = (uint8_t *)mb;
+			from += sizeof(MAILBOX_t);
+			memcpy((uint8_t *)dmp->dma.virt, from,
+				bde->tus.f.bdeSize);
+		}
 	}
 
+	dd_data->context_un.mbox.rxbmp = rxbmp;
+	dd_data->context_un.mbox.dmp = dmp;
+
 	/* setup wake call as IOCB callback */
 	pmboxq->mbox_cmpl = lpfc_bsg_wake_mbox_wait;
 
@@ -2703,7 +2901,7 @@ lpfc_bsg_issue_mbox(struct lpfc_hba *phb
 	dd_data->context_un.mbox.ext = ext;
 	dd_data->context_un.mbox.mbOffset = mbox_req->mbOffset;
 	dd_data->context_un.mbox.inExtWLen = mbox_req->inExtWLen;
-	dd_data->context_un.mbox.outWxtWLen = mbox_req->outWxtWLen;
+	dd_data->context_un.mbox.outExtWLen = mbox_req->outExtWLen;
 	job->dd_data = dd_data;
 
 	if ((vport->fc_flag & FC_OFFLINE_MODE) ||
diff -upNr a/drivers/scsi/lpfc/lpfc_bsg.h b/drivers/scsi/lpfc/lpfc_bsg.h
--- a/drivers/scsi/lpfc/lpfc_bsg.h	2010-04-06 12:58:02.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_bsg.h	2010-04-06 12:58:41.000000000 -0400
@@ -96,7 +96,7 @@ struct dfc_mbox_req {
 	uint32_t command;
 	uint32_t mbOffset;
 	uint32_t inExtWLen;
-	uint32_t outWxtWLen;
+	uint32_t outExtWLen;
 };
 
 /* Used for menlo command or menlo data. The xri is only used for menlo data */
diff -upNr a/drivers/scsi/lpfc/lpfc_hw.h b/drivers/scsi/lpfc/lpfc_hw.h
--- a/drivers/scsi/lpfc/lpfc_hw.h	2010-04-06 12:57:42.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_hw.h	2010-04-06 12:58:41.000000000 -0400
@@ -1732,6 +1732,17 @@ typedef struct {
 	} un;
 } BIU_DIAG_VAR;
 
+/* Structure for MB command READ_EVENT_LOG (0x38) */
+struct READ_EVENT_LOG_VAR {
+	uint32_t word1;
+#define lpfc_event_log_SHIFT	29
+#define lpfc_event_log_MASK	0x00000001
+#define lpfc_event_log_WORD	word1
+#define USE_MAILBOX_RESPONSE	1
+	uint32_t offset;
+	struct ulp_bde64 rcv_bde64;
+};
+
 /* Structure for MB Command INIT_LINK (05) */
 
 typedef struct {
@@ -2966,6 +2977,9 @@ typedef union {
 	REG_VPI_VAR varRegVpi;		/* cmd = 0x96 (REG_VPI) */
 	UNREG_VPI_VAR varUnregVpi;	/* cmd = 0x97 (UNREG_VPI) */
 	ASYNCEVT_ENABLE_VAR varCfgAsyncEvent; /*cmd = x33 (CONFIG_ASYNC) */
+	struct READ_EVENT_LOG_VAR varRdEventLog;	/* cmd = 0x38
+							 * (READ_EVENT_LOG)
+							 */
 	struct config_msi_var varCfgMSI;/* cmd = x30 (CONFIG_MSI)     */
 } MAILVARIANTS;
 
diff -upNr a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
--- a/drivers/scsi/lpfc/lpfc_sli.c	2010-04-06 12:58:02.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_sli.c	2010-04-06 12:58:41.000000000 -0400
@@ -1658,6 +1658,8 @@ lpfc_sli_chk_mbx_command(uint8_t mbxComm
 	case MBX_INIT_VPI:
 	case MBX_INIT_VFI:
 	case MBX_RESUME_RPI:
+	case MBX_READ_EVENT_LOG_STATUS:
+	case MBX_READ_EVENT_LOG:
 		ret = mbxCommand;
 		break;
 	default:


