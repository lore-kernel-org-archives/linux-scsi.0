From: James Smart <james.smart@emulex.com>
Subject: [PATCH 1/4] lpfc 8.3.15: BSG, Discovery, and Misc fixes:
Date: Wed, 14 Jul 2010 15:30:54 -0400
Message-ID: <1279135874.32010.1.camel@wookie>
Reply-To: james.smart@emulex.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exht1.emulex.com ([138.239.113.183]:37772 "EHLO
	exht1.ad.emulex.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754105Ab0GNTgs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Jul 2010 15:36:48 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


- BSG interface related:
  - Fix node reference count if node is active
  - Warn if we're overwriting an active CT context

- Discovery related:
  - Clear "Ignore Reg Login" flag when purging mailbox queue
  - Pay attention to return code for fc_block_scsi_eh()
  - Stall device loss code if we're almost done when it fires
    (we're logged in, but PRLI is outstanding)

- Bugs
  - Correct DIF code for endianness issues
  - Correct where we had missed points to check txq on i/o
    completion/cleanup


 Signed-off-by: Alex Iannicelli <alex.iannicelli@emulex.com>
 Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_bsg.c     |   27 +++++++++++++++++++++++++++
 lpfc_els.c     |    5 +++++
 lpfc_hbadisc.c |    5 +++--
 lpfc_scsi.c    |   38 +++++++++++++++++++++++++++++++++-----
 lpfc_sli.c     |   20 ++++++++------------
 5 files changed, 76 insertions(+), 19 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_bsg.c b/drivers/scsi/lpfc/lpfc_bsg.c
--- a/drivers/scsi/lpfc/lpfc_bsg.c	2010-07-09 00:49:14.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_bsg.c	2010-07-14 13:46:33.000000000 -0400
@@ -962,10 +962,22 @@ lpfc_bsg_ct_unsol_event(struct lpfc_hba 
 		if (phba->sli_rev == LPFC_SLI_REV4) {
 			evt_dat->immed_dat = phba->ctx_idx;
 			phba->ctx_idx = (phba->ctx_idx + 1) % 64;
+			/* Provide warning for over-run of the ct_ctx array */
+			if (phba->ct_ctx[evt_dat->immed_dat].flags &
+			    UNSOL_VALID)
+				lpfc_printf_log(phba, KERN_WARNING, LOG_ELS,
+						"2717 CT context array entry "
+						"[%d] over-run: oxid:x%x, "
+						"sid:x%x\n", phba->ctx_idx,
+						phba->ct_ctx[
+						    evt_dat->immed_dat].oxid,
+						phba->ct_ctx[
+						    evt_dat->immed_dat].SID);
 			phba->ct_ctx[evt_dat->immed_dat].oxid =
 						piocbq->iocb.ulpContext;
 			phba->ct_ctx[evt_dat->immed_dat].SID =
 				piocbq->iocb.un.rcvels.remoteID;
+			phba->ct_ctx[evt_dat->immed_dat].flags = UNSOL_VALID;
 		} else
 			evt_dat->immed_dat = piocbq->iocb.ulpContext;
 
@@ -1323,6 +1335,21 @@ lpfc_issue_ct_rsp(struct lpfc_hba *phba,
 			rc = IOCB_ERROR;
 			goto issue_ct_rsp_exit;
 		}
+
+		/* Check if the ndlp is active */
+		if (!ndlp || !NLP_CHK_NODE_ACT(ndlp)) {
+			rc = -IOCB_ERROR;
+			goto issue_ct_rsp_exit;
+		}
+
+		/* get a refernece count so the ndlp doesn't go away while
+		 * we respond
+		 */
+		if (!lpfc_nlp_get(ndlp)) {
+			rc = -IOCB_ERROR;
+			goto issue_ct_rsp_exit;
+		}
+
 		icmd->un.ulpWord[3] = ndlp->nlp_rpi;
 		/* The exchange is done, mark the entry as invalid */
 		phba->ct_ctx[tag].flags &= ~UNSOL_VALID;
diff -upNr a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
--- a/drivers/scsi/lpfc/lpfc_els.c	2010-07-09 00:49:14.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_els.c	2010-07-14 13:46:49.000000000 -0400
@@ -6962,6 +6962,7 @@ lpfc_sli4_els_xri_aborted(struct lpfc_hb
 	uint16_t xri = bf_get(lpfc_wcqe_xa_xri, axri);
 	struct lpfc_sglq *sglq_entry = NULL, *sglq_next = NULL;
 	unsigned long iflag = 0;
+	struct lpfc_sli_ring *pring = &phba->sli.ring[LPFC_ELS_RING];
 
 	spin_lock_irqsave(&phba->hbalock, iflag);
 	spin_lock(&phba->sli4_hba.abts_sgl_list_lock);
@@ -6974,6 +6975,10 @@ lpfc_sli4_els_xri_aborted(struct lpfc_hb
 			sglq_entry->state = SGL_FREED;
 			spin_unlock(&phba->sli4_hba.abts_sgl_list_lock);
 			spin_unlock_irqrestore(&phba->hbalock, iflag);
+
+			/* Check if TXQ queue needs to be serviced */
+			if (pring->txq_cnt)
+				lpfc_worker_wake_up(phba);
 			return;
 		}
 	}
diff -upNr a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c	2010-07-09 00:49:14.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c	2010-07-14 13:46:49.000000000 -0400
@@ -276,7 +276,8 @@ lpfc_dev_loss_tmo_handler(struct lpfc_no
 	    !(ndlp->nlp_flag & NLP_DELAY_TMO) &&
 	    !(ndlp->nlp_flag & NLP_NPR_2B_DISC) &&
 	    (ndlp->nlp_state != NLP_STE_UNMAPPED_NODE) &&
-	    (ndlp->nlp_state != NLP_STE_REG_LOGIN_ISSUE))
+	    (ndlp->nlp_state != NLP_STE_REG_LOGIN_ISSUE) &&
+	    (ndlp->nlp_state != NLP_STE_PRLI_ISSUE))
 		lpfc_disc_state_machine(vport, ndlp, NULL, NLP_EVT_DEVICE_RM);
 
 	lpfc_unregister_unused_fcf(phba);
@@ -587,7 +588,7 @@ lpfc_work_done(struct lpfc_hba *phba)
 							(status &
 							 HA_RXMASK));
 		}
-		if (phba->pport->work_port_events & WORKER_SERVICE_TXQ)
+		if (pring->txq_cnt)
 			lpfc_drain_txq(phba);
 		/*
 		 * Turn on Ring interrupts
diff -upNr a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
--- a/drivers/scsi/lpfc/lpfc_scsi.c	2010-07-09 00:49:14.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_scsi.c	2010-07-14 13:46:49.000000000 -0400
@@ -623,6 +623,7 @@ lpfc_sli4_fcp_xri_aborted(struct lpfc_hb
 	unsigned long iflag = 0;
 	struct lpfc_iocbq *iocbq;
 	int i;
+	struct lpfc_sli_ring *pring = &phba->sli.ring[LPFC_ELS_RING];
 
 	spin_lock_irqsave(&phba->hbalock, iflag);
 	spin_lock(&phba->sli4_hba.abts_scsi_buf_list_lock);
@@ -651,6 +652,8 @@ lpfc_sli4_fcp_xri_aborted(struct lpfc_hb
 		psb = container_of(iocbq, struct lpfc_scsi_buf, cur_iocbq);
 		psb->exch_busy = 0;
 		spin_unlock_irqrestore(&phba->hbalock, iflag);
+		if (pring->txq_cnt)
+			lpfc_worker_wake_up(phba);
 		return;
 
 	}
@@ -1322,6 +1325,10 @@ lpfc_bg_setup_bpl(struct lpfc_hba *phba,
 	bf_set(pde5_type, pde5, LPFC_PDE5_DESCRIPTOR);
 	pde5->reftag = reftag;
 
+	/* Endian convertion if necessary for PDE5 */
+	pde5->word0 = cpu_to_le32(pde5->word0);
+	pde5->reftag = cpu_to_le32(pde5->reftag);
+
 	/* advance bpl and increment bde count */
 	num_bde++;
 	bpl++;
@@ -1340,6 +1347,11 @@ lpfc_bg_setup_bpl(struct lpfc_hba *phba,
 	bf_set(pde6_ai, pde6, 1);
 	bf_set(pde6_apptagval, pde6, apptagval);
 
+	/* Endian convertion if necessary for PDE6 */
+	pde6->word0 = cpu_to_le32(pde6->word0);
+	pde6->word1 = cpu_to_le32(pde6->word1);
+	pde6->word2 = cpu_to_le32(pde6->word2);
+
 	/* advance bpl and increment bde count */
 	num_bde++;
 	bpl++;
@@ -1447,6 +1459,10 @@ lpfc_bg_setup_bpl_prot(struct lpfc_hba *
 		bf_set(pde5_type, pde5, LPFC_PDE5_DESCRIPTOR);
 		pde5->reftag = reftag;
 
+		/* Endian convertion if necessary for PDE5 */
+		pde5->word0 = cpu_to_le32(pde5->word0);
+		pde5->reftag = cpu_to_le32(pde5->reftag);
+
 		/* advance bpl and increment bde count */
 		num_bde++;
 		bpl++;
@@ -1463,6 +1479,11 @@ lpfc_bg_setup_bpl_prot(struct lpfc_hba *
 		bf_set(pde6_ai, pde6, 1);
 		bf_set(pde6_apptagval, pde6, apptagval);
 
+		/* Endian convertion if necessary for PDE6 */
+		pde6->word0 = cpu_to_le32(pde6->word0);
+		pde6->word1 = cpu_to_le32(pde6->word1);
+		pde6->word2 = cpu_to_le32(pde6->word2);
+
 		/* advance bpl and increment bde count */
 		num_bde++;
 		bpl++;
@@ -1474,7 +1495,6 @@ lpfc_bg_setup_bpl_prot(struct lpfc_hba *
 		prot_bde->addrLow = le32_to_cpu(putPaddrHigh(protphysaddr));
 		protgroup_len = sg_dma_len(sgpe);
 
-
 		/* must be integer multiple of the DIF block length */
 		BUG_ON(protgroup_len % 8);
 
@@ -3047,7 +3067,9 @@ lpfc_abort_handler(struct scsi_cmnd *cmn
 	int ret = SUCCESS;
 	DECLARE_WAIT_QUEUE_HEAD_ONSTACK(waitq);
 
-	fc_block_scsi_eh(cmnd);
+	ret = fc_block_scsi_eh(cmnd);
+	if (ret)
+		return ret;
 	lpfc_cmd = (struct lpfc_scsi_buf *)cmnd->host_scribble;
 	BUG_ON(!lpfc_cmd);
 
@@ -3365,7 +3387,9 @@ lpfc_device_reset_handler(struct scsi_cm
 		return FAILED;
 	}
 	pnode = rdata->pnode;
-	fc_block_scsi_eh(cmnd);
+	status = fc_block_scsi_eh(cmnd);
+	if (status)
+		return status;
 
 	status = lpfc_chk_tgt_mapped(vport, cmnd);
 	if (status == FAILED) {
@@ -3430,7 +3454,9 @@ lpfc_target_reset_handler(struct scsi_cm
 		return FAILED;
 	}
 	pnode = rdata->pnode;
-	fc_block_scsi_eh(cmnd);
+	status = fc_block_scsi_eh(cmnd);
+	if (status)
+		return status;
 
 	status = lpfc_chk_tgt_mapped(vport, cmnd);
 	if (status == FAILED) {
@@ -3496,7 +3522,9 @@ lpfc_bus_reset_handler(struct scsi_cmnd 
 	fc_host_post_vendor_event(shost, fc_get_event_number(),
 		sizeof(scsi_event), (char *)&scsi_event, LPFC_NL_VENDOR_ID);
 
-	fc_block_scsi_eh(cmnd);
+	ret = fc_block_scsi_eh(cmnd);
+	if (ret)
+		return ret;
 
 	/*
 	 * Since the driver manages a single bus device, reset all
diff -upNr a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
--- a/drivers/scsi/lpfc/lpfc_sli.c	2010-07-09 00:49:14.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_sli.c	2010-07-14 13:46:49.000000000 -0400
@@ -601,15 +601,8 @@ __lpfc_sli_release_iocbq_s4(struct lpfc_
 			list_add(&sglq->list, &phba->sli4_hba.lpfc_sgl_list);
 
 			/* Check if TXQ queue needs to be serviced */
-			if (pring->txq_cnt) {
-				spin_lock_irqsave(
-					&phba->pport->work_port_lock, iflag);
-				phba->pport->work_port_events |=
-					WORKER_SERVICE_TXQ;
+			if (pring->txq_cnt)
 				lpfc_worker_wake_up(phba);
-				spin_unlock_irqrestore(
-					&phba->pport->work_port_lock, iflag);
-			}
 		}
 	}
 
@@ -12757,6 +12750,7 @@ lpfc_cleanup_pending_mbox(struct lpfc_vp
 	LPFC_MBOXQ_t *mb, *nextmb;
 	struct lpfc_dmabuf *mp;
 	struct lpfc_nodelist *ndlp;
+	struct Scsi_Host  *shost = lpfc_shost_from_vport(vport);
 
 	spin_lock_irq(&phba->hbalock);
 	list_for_each_entry_safe(mb, nextmb, &phba->sli.mboxq, list) {
@@ -12778,6 +12772,9 @@ lpfc_cleanup_pending_mbox(struct lpfc_vp
 			}
 			ndlp = (struct lpfc_nodelist *) mb->context2;
 			if (ndlp) {
+				spin_lock_irq(shost->host_lock);
+				ndlp->nlp_flag &= ~NLP_IGNR_REG_CMPL;
+				spin_unlock_irq(shost->host_lock);
 				lpfc_nlp_put(ndlp);
 				mb->context2 = NULL;
 			}
@@ -12793,6 +12790,9 @@ lpfc_cleanup_pending_mbox(struct lpfc_vp
 		if (mb->u.mb.mbxCommand == MBX_REG_LOGIN64) {
 			ndlp = (struct lpfc_nodelist *) mb->context2;
 			if (ndlp) {
+				spin_lock_irq(shost->host_lock);
+				ndlp->nlp_flag &= ~NLP_IGNR_REG_CMPL;
+				spin_unlock_irq(shost->host_lock);
 				lpfc_nlp_put(ndlp);
 				mb->context2 = NULL;
 			}
@@ -12879,10 +12879,6 @@ lpfc_drain_txq(struct lpfc_hba *phba)
 		spin_unlock_irqrestore(&phba->hbalock, iflags);
 	}
 
-	spin_lock_irqsave(&phba->pport->work_port_lock, iflags);
-	phba->pport->work_port_events &= ~WORKER_SERVICE_TXQ;
-	spin_unlock_irqrestore(&phba->pport->work_port_lock, iflags);
-
 	/* Cancel all the IOCBs that cannot be issued */
 	lpfc_sli_cancel_iocbs(phba, &completions, IOSTAT_LOCAL_REJECT,
 				IOERR_SLI_ABORTED);


