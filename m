From: James Smart <james.smart@emulex.com>
Subject: [PATCH 2/7] lpfc 8.3.18: Add support of received ELS commands
Date: Fri, 22 Oct 2010 11:05:53 -0400
Message-ID: <1287759967.11844.19.camel@wookie>
Reply-To: james.smart@emulex.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exht1.emulex.com ([138.239.113.183]:56055 "EHLO
	exht1.ad.emulex.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756665Ab0JVPG3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 22 Oct 2010 11:06:29 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Add support of received ELS commands

- Add support for received RLS ELS command
- Add support for received ECHO ELS command
- Add support for received RTV ELS command


 Signed-off-by: Alex Iannicelli <alex.iannicelli@emulex.com>
 Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc.h     |    4 
 lpfc_els.c |  346 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 lpfc_hw.h  |   41 +++++++
 3 files changed, 389 insertions(+), 2 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
--- a/drivers/scsi/lpfc/lpfc_els.c	2010-10-21 22:37:34.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_els.c	2010-10-21 22:38:23.000000000 -0400
@@ -517,6 +517,7 @@ lpfc_cmpl_els_flogi_fabric(struct lpfc_v
 	if (sp->cmn.edtovResolution)	/* E_D_TOV ticks are in nanoseconds */
 		phba->fc_edtov = (phba->fc_edtov + 999999) / 1000000;
 
+	phba->fc_edtovResol = sp->cmn.edtovResolution;
 	phba->fc_ratov = (be32_to_cpu(sp->cmn.w2.r_a_tov) + 999) / 1000;
 
 	if (phba->fc_topology == TOPOLOGY_LOOP) {
@@ -3928,6 +3929,64 @@ lpfc_els_rsp_rnid_acc(struct lpfc_vport 
 }
 
 /**
+ * lpfc_els_rsp_echo_acc - Issue echo acc response
+ * @vport: pointer to a virtual N_Port data structure.
+ * @data: pointer to echo data to return in the accept.
+ * @oldiocb: pointer to the original lpfc command iocb data structure.
+ * @ndlp: pointer to a node-list data structure.
+ *
+ * Return code
+ *   0 - Successfully issued acc echo response
+ *   1 - Failed to issue acc echo response
+ **/
+static int
+lpfc_els_rsp_echo_acc(struct lpfc_vport *vport, uint8_t *data,
+		      struct lpfc_iocbq *oldiocb, struct lpfc_nodelist *ndlp)
+{
+	struct lpfc_hba  *phba = vport->phba;
+	struct lpfc_iocbq *elsiocb;
+	struct lpfc_sli *psli;
+	uint8_t *pcmd;
+	uint16_t cmdsize;
+	int rc;
+
+	psli = &phba->sli;
+	cmdsize = oldiocb->iocb.unsli3.rcvsli3.acc_len;
+
+	elsiocb = lpfc_prep_els_iocb(vport, 0, cmdsize, oldiocb->retry, ndlp,
+				     ndlp->nlp_DID, ELS_CMD_ACC);
+	if (!elsiocb)
+		return 1;
+
+	elsiocb->iocb.ulpContext = oldiocb->iocb.ulpContext;	/* Xri */
+	/* Xmit ECHO ACC response tag <ulpIoTag> */
+	lpfc_printf_vlog(vport, KERN_INFO, LOG_ELS,
+			 "2876 Xmit ECHO ACC response tag x%x xri x%x\n",
+			 elsiocb->iotag, elsiocb->iocb.ulpContext);
+	pcmd = (uint8_t *) (((struct lpfc_dmabuf *) elsiocb->context2)->virt);
+	*((uint32_t *) (pcmd)) = ELS_CMD_ACC;
+	pcmd += sizeof(uint32_t);
+	memcpy(pcmd, data, cmdsize - sizeof(uint32_t));
+
+	lpfc_debugfs_disc_trc(vport, LPFC_DISC_TRC_ELS_RSP,
+		"Issue ACC ECHO:  did:x%x flg:x%x",
+		ndlp->nlp_DID, ndlp->nlp_flag, 0);
+
+	phba->fc_stat.elsXmitACC++;
+	elsiocb->iocb_cmpl = lpfc_cmpl_els_rsp;
+	lpfc_nlp_put(ndlp);
+	elsiocb->context1 = NULL;  /* Don't need ndlp for cmpl,
+				    * it could be freed */
+
+	rc = lpfc_sli_issue_iocb(phba, LPFC_ELS_RING, elsiocb, 0);
+	if (rc == IOCB_ERROR) {
+		lpfc_els_free_iocb(phba, elsiocb);
+		return 1;
+	}
+	return 0;
+}
+
+/**
  * lpfc_els_disc_adisc - Issue remaining adisc iocbs to npr nodes of a vport
  * @vport: pointer to a host virtual N_Port data structure.
  *
@@ -4686,6 +4745,30 @@ lpfc_els_rcv_rnid(struct lpfc_vport *vpo
 }
 
 /**
+ * lpfc_els_rcv_echo - Process an unsolicited echo iocb
+ * @vport: pointer to a host virtual N_Port data structure.
+ * @cmdiocb: pointer to lpfc command iocb data structure.
+ * @ndlp: pointer to a node-list data structure.
+ *
+ * Return code
+ *   0 - Successfully processed echo iocb (currently always return 0)
+ **/
+static int
+lpfc_els_rcv_echo(struct lpfc_vport *vport, struct lpfc_iocbq *cmdiocb,
+		  struct lpfc_nodelist *ndlp)
+{
+	uint8_t *pcmd;
+
+	pcmd = (uint8_t *) (((struct lpfc_dmabuf *) cmdiocb->context2)->virt);
+
+	/* skip over first word of echo command to find echo data */
+	pcmd += sizeof(uint32_t);
+
+	lpfc_els_rsp_echo_acc(vport, pcmd, cmdiocb, ndlp);
+	return 0;
+}
+
+/**
  * lpfc_els_rcv_lirr - Process an unsolicited lirr iocb
  * @vport: pointer to a host virtual N_Port data structure.
  * @cmdiocb: pointer to lpfc command iocb data structure.
@@ -4737,6 +4820,89 @@ lpfc_els_rcv_rrq(struct lpfc_vport *vpor
 }
 
 /**
+ * lpfc_els_rsp_rls_acc - Completion callbk func for MBX_READ_LNK_STAT mbox cmd
+ * @phba: pointer to lpfc hba data structure.
+ * @pmb: pointer to the driver internal queue element for mailbox command.
+ *
+ * This routine is the completion callback function for the MBX_READ_LNK_STAT
+ * mailbox command. This callback function is to actually send the Accept
+ * (ACC) response to a Read Port Status (RPS) unsolicited IOCB event. It
+ * collects the link statistics from the completion of the MBX_READ_LNK_STAT
+ * mailbox command, constructs the RPS response with the link statistics
+ * collected, and then invokes the lpfc_sli_issue_iocb() routine to send ACC
+ * response to the RPS.
+ *
+ * Note that, in lpfc_prep_els_iocb() routine, the reference count of ndlp
+ * will be incremented by 1 for holding the ndlp and the reference to ndlp
+ * will be stored into the context1 field of the IOCB for the completion
+ * callback function to the RPS Accept Response ELS IOCB command.
+ *
+ **/
+static void
+lpfc_els_rsp_rls_acc(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
+{
+	MAILBOX_t *mb;
+	IOCB_t *icmd;
+	struct RLS_RSP *rls_rsp;
+	uint8_t *pcmd;
+	struct lpfc_iocbq *elsiocb;
+	struct lpfc_nodelist *ndlp;
+	uint16_t xri;
+	uint32_t cmdsize;
+
+	mb = &pmb->u.mb;
+
+	ndlp = (struct lpfc_nodelist *) pmb->context2;
+	xri = (uint16_t) ((unsigned long)(pmb->context1));
+	pmb->context1 = NULL;
+	pmb->context2 = NULL;
+
+	if (mb->mbxStatus) {
+		mempool_free(pmb, phba->mbox_mem_pool);
+		return;
+	}
+
+	cmdsize = sizeof(struct RLS_RSP) + sizeof(uint32_t);
+	mempool_free(pmb, phba->mbox_mem_pool);
+	elsiocb = lpfc_prep_els_iocb(phba->pport, 0, cmdsize,
+				     lpfc_max_els_tries, ndlp,
+				     ndlp->nlp_DID, ELS_CMD_ACC);
+
+	/* Decrement the ndlp reference count from previous mbox command */
+	lpfc_nlp_put(ndlp);
+
+	if (!elsiocb)
+		return;
+
+	icmd = &elsiocb->iocb;
+	icmd->ulpContext = xri;
+
+	pcmd = (uint8_t *) (((struct lpfc_dmabuf *) elsiocb->context2)->virt);
+	*((uint32_t *) (pcmd)) = ELS_CMD_ACC;
+	pcmd += sizeof(uint32_t); /* Skip past command */
+	rls_rsp = (struct RLS_RSP *)pcmd;
+
+	rls_rsp->linkFailureCnt = cpu_to_be32(mb->un.varRdLnk.linkFailureCnt);
+	rls_rsp->lossSyncCnt = cpu_to_be32(mb->un.varRdLnk.lossSyncCnt);
+	rls_rsp->lossSignalCnt = cpu_to_be32(mb->un.varRdLnk.lossSignalCnt);
+	rls_rsp->primSeqErrCnt = cpu_to_be32(mb->un.varRdLnk.primSeqErrCnt);
+	rls_rsp->invalidXmitWord = cpu_to_be32(mb->un.varRdLnk.invalidXmitWord);
+	rls_rsp->crcCnt = cpu_to_be32(mb->un.varRdLnk.crcCnt);
+
+	/* Xmit ELS RLS ACC response tag <ulpIoTag> */
+	lpfc_printf_vlog(ndlp->vport, KERN_INFO, LOG_ELS,
+			 "2874 Xmit ELS RLS ACC response tag x%x xri x%x, "
+			 "did x%x, nlp_flag x%x, nlp_state x%x, rpi x%x\n",
+			 elsiocb->iotag, elsiocb->iocb.ulpContext,
+			 ndlp->nlp_DID, ndlp->nlp_flag, ndlp->nlp_state,
+			 ndlp->nlp_rpi);
+	elsiocb->iocb_cmpl = lpfc_cmpl_els_rsp;
+	phba->fc_stat.elsXmitACC++;
+	if (lpfc_sli_issue_iocb(phba, LPFC_ELS_RING, elsiocb, 0) == IOCB_ERROR)
+		lpfc_els_free_iocb(phba, elsiocb);
+}
+
+/**
  * lpfc_els_rsp_rps_acc - Completion callbk func for MBX_READ_LNK_STAT mbox cmd
  * @phba: pointer to lpfc hba data structure.
  * @pmb: pointer to the driver internal queue element for mailbox command.
@@ -4829,7 +4995,155 @@ lpfc_els_rsp_rps_acc(struct lpfc_hba *ph
 }
 
 /**
- * lpfc_els_rcv_rps - Process an unsolicited rps iocb
+ * lpfc_els_rcv_rls - Process an unsolicited rls iocb
+ * @vport: pointer to a host virtual N_Port data structure.
+ * @cmdiocb: pointer to lpfc command iocb data structure.
+ * @ndlp: pointer to a node-list data structure.
+ *
+ * This routine processes Read Port Status (RPL) IOCB received as an
+ * ELS unsolicited event. It first checks the remote port state. If the
+ * remote port is not in NLP_STE_UNMAPPED_NODE state or NLP_STE_MAPPED_NODE
+ * state, it invokes the lpfc_els_rsl_reject() routine to send the reject
+ * response. Otherwise, it issue the MBX_READ_LNK_STAT mailbox command
+ * for reading the HBA link statistics. It is for the callback function,
+ * lpfc_els_rsp_rls_acc(), set to the MBX_READ_LNK_STAT mailbox command
+ * to actually sending out RPL Accept (ACC) response.
+ *
+ * Return codes
+ *   0 - Successfully processed rls iocb (currently always return 0)
+ **/
+static int
+lpfc_els_rcv_rls(struct lpfc_vport *vport, struct lpfc_iocbq *cmdiocb,
+		 struct lpfc_nodelist *ndlp)
+{
+	struct lpfc_hba *phba = vport->phba;
+	LPFC_MBOXQ_t *mbox;
+	struct lpfc_dmabuf *pcmd;
+	struct ls_rjt stat;
+
+	if ((ndlp->nlp_state != NLP_STE_UNMAPPED_NODE) &&
+	    (ndlp->nlp_state != NLP_STE_MAPPED_NODE))
+		/* reject the unsolicited RPS request and done with it */
+		goto reject_out;
+
+	pcmd = (struct lpfc_dmabuf *) cmdiocb->context2;
+
+	mbox = mempool_alloc(phba->mbox_mem_pool, GFP_ATOMIC);
+	if (mbox) {
+		lpfc_read_lnk_stat(phba, mbox);
+		mbox->context1 =
+		    (void *)((unsigned long) cmdiocb->iocb.ulpContext);
+		mbox->context2 = lpfc_nlp_get(ndlp);
+		mbox->vport = vport;
+		mbox->mbox_cmpl = lpfc_els_rsp_rls_acc;
+		if (lpfc_sli_issue_mbox(phba, mbox, MBX_NOWAIT)
+			!= MBX_NOT_FINISHED)
+			/* Mbox completion will send ELS Response */
+			return 0;
+		/* Decrement reference count used for the failed mbox
+		 * command.
+		 */
+		lpfc_nlp_put(ndlp);
+		mempool_free(mbox, phba->mbox_mem_pool);
+	}
+reject_out:
+	/* issue rejection response */
+	stat.un.b.lsRjtRsvd0 = 0;
+	stat.un.b.lsRjtRsnCode = LSRJT_UNABLE_TPC;
+	stat.un.b.lsRjtRsnCodeExp = LSEXP_CANT_GIVE_DATA;
+	stat.un.b.vendorUnique = 0;
+	lpfc_els_rsp_reject(vport, stat.un.lsRjtError, cmdiocb, ndlp, NULL);
+	return 0;
+}
+
+/**
+ * lpfc_els_rcv_rtv - Process an unsolicited rtv iocb
+ * @vport: pointer to a host virtual N_Port data structure.
+ * @cmdiocb: pointer to lpfc command iocb data structure.
+ * @ndlp: pointer to a node-list data structure.
+ *
+ * This routine processes Read Timout Value (RTV) IOCB received as an
+ * ELS unsolicited event. It first checks the remote port state. If the
+ * remote port is not in NLP_STE_UNMAPPED_NODE state or NLP_STE_MAPPED_NODE
+ * state, it invokes the lpfc_els_rsl_reject() routine to send the reject
+ * response. Otherwise, it sends the Accept(ACC) response to a Read Timeout
+ * Value (RTV) unsolicited IOCB event.
+ *
+ * Note that, in lpfc_prep_els_iocb() routine, the reference count of ndlp
+ * will be incremented by 1 for holding the ndlp and the reference to ndlp
+ * will be stored into the context1 field of the IOCB for the completion
+ * callback function to the RPS Accept Response ELS IOCB command.
+ *
+ * Return codes
+ *   0 - Successfully processed rtv iocb (currently always return 0)
+ **/
+static int
+lpfc_els_rcv_rtv(struct lpfc_vport *vport, struct lpfc_iocbq *cmdiocb,
+		 struct lpfc_nodelist *ndlp)
+{
+	struct lpfc_hba *phba = vport->phba;
+	struct ls_rjt stat;
+	struct RTV_RSP *rtv_rsp;
+	uint8_t *pcmd;
+	struct lpfc_iocbq *elsiocb;
+	uint32_t cmdsize;
+
+
+	if ((ndlp->nlp_state != NLP_STE_UNMAPPED_NODE) &&
+	    (ndlp->nlp_state != NLP_STE_MAPPED_NODE))
+		/* reject the unsolicited RPS request and done with it */
+		goto reject_out;
+
+	cmdsize = sizeof(struct RTV_RSP) + sizeof(uint32_t);
+	elsiocb = lpfc_prep_els_iocb(phba->pport, 0, cmdsize,
+				     lpfc_max_els_tries, ndlp,
+				     ndlp->nlp_DID, ELS_CMD_ACC);
+
+	if (!elsiocb)
+		return 1;
+
+	pcmd = (uint8_t *) (((struct lpfc_dmabuf *) elsiocb->context2)->virt);
+		*((uint32_t *) (pcmd)) = ELS_CMD_ACC;
+	pcmd += sizeof(uint32_t); /* Skip past command */
+
+	/* use the command's xri in the response */
+	elsiocb->iocb.ulpContext = cmdiocb->iocb.ulpContext;
+
+	rtv_rsp = (struct RTV_RSP *)pcmd;
+
+	/* populate RTV payload */
+	rtv_rsp->ratov = cpu_to_be32(phba->fc_ratov * 1000); /* report msecs */
+	rtv_rsp->edtov = cpu_to_be32(phba->fc_edtov);
+	bf_set(qtov_edtovres, rtv_rsp, phba->fc_edtovResol ? 1 : 0);
+	bf_set(qtov_rttov, rtv_rsp, 0); /* Field is for FC ONLY */
+	rtv_rsp->qtov = cpu_to_be32(rtv_rsp->qtov);
+
+	/* Xmit ELS RLS ACC response tag <ulpIoTag> */
+	lpfc_printf_vlog(ndlp->vport, KERN_INFO, LOG_ELS,
+			 "2875 Xmit ELS RTV ACC response tag x%x xri x%x, "
+			 "did x%x, nlp_flag x%x, nlp_state x%x, rpi x%x, "
+			 "Data: x%x x%x x%x\n",
+			 elsiocb->iotag, elsiocb->iocb.ulpContext,
+			 ndlp->nlp_DID, ndlp->nlp_flag, ndlp->nlp_state,
+			 ndlp->nlp_rpi,
+			rtv_rsp->ratov, rtv_rsp->edtov, rtv_rsp->qtov);
+	elsiocb->iocb_cmpl = lpfc_cmpl_els_rsp;
+	phba->fc_stat.elsXmitACC++;
+	if (lpfc_sli_issue_iocb(phba, LPFC_ELS_RING, elsiocb, 0) == IOCB_ERROR)
+		lpfc_els_free_iocb(phba, elsiocb);
+	return 0;
+
+reject_out:
+	/* issue rejection response */
+	stat.un.b.lsRjtRsvd0 = 0;
+	stat.un.b.lsRjtRsnCode = LSRJT_UNABLE_TPC;
+	stat.un.b.lsRjtRsnCodeExp = LSEXP_CANT_GIVE_DATA;
+	stat.un.b.vendorUnique = 0;
+	lpfc_els_rsp_reject(vport, stat.un.lsRjtError, cmdiocb, ndlp, NULL);
+	return 0;
+}
+
+/* lpfc_els_rcv_rps - Process an unsolicited rps iocb
  * @vport: pointer to a host virtual N_Port data structure.
  * @cmdiocb: pointer to lpfc command iocb data structure.
  * @ndlp: pointer to a node-list data structure.
@@ -5019,7 +5333,6 @@ lpfc_els_rcv_rpl(struct lpfc_vport *vpor
 	pcmd = (struct lpfc_dmabuf *) cmdiocb->context2;
 	lp = (uint32_t *) pcmd->virt;
 	rpl = (RPL *) (lp + 1);
-
 	maxsize = be32_to_cpu(rpl->maxsize);
 
 	/* We support only one port */
@@ -5838,6 +6151,16 @@ lpfc_els_unsol_buffer(struct lpfc_hba *p
 		if (newnode)
 			lpfc_nlp_put(ndlp);
 		break;
+	case ELS_CMD_RLS:
+		lpfc_debugfs_disc_trc(vport, LPFC_DISC_TRC_ELS_UNSOL,
+			"RCV RLS:         did:x%x/ste:x%x flg:x%x",
+			did, vport->port_state, ndlp->nlp_flag);
+
+		phba->fc_stat.elsRcvRLS++;
+		lpfc_els_rcv_rls(vport, elsiocb, ndlp);
+		if (newnode)
+			lpfc_nlp_put(ndlp);
+		break;
 	case ELS_CMD_RPS:
 		lpfc_debugfs_disc_trc(vport, LPFC_DISC_TRC_ELS_UNSOL,
 			"RCV RPS:         did:x%x/ste:x%x flg:x%x",
@@ -5868,6 +6191,15 @@ lpfc_els_unsol_buffer(struct lpfc_hba *p
 		if (newnode)
 			lpfc_nlp_put(ndlp);
 		break;
+	case ELS_CMD_RTV:
+		lpfc_debugfs_disc_trc(vport, LPFC_DISC_TRC_ELS_UNSOL,
+			"RCV RTV:        did:x%x/ste:x%x flg:x%x",
+			did, vport->port_state, ndlp->nlp_flag);
+		phba->fc_stat.elsRcvRTV++;
+		lpfc_els_rcv_rtv(vport, elsiocb, ndlp);
+		if (newnode)
+			lpfc_nlp_put(ndlp);
+		break;
 	case ELS_CMD_RRQ:
 		lpfc_debugfs_disc_trc(vport, LPFC_DISC_TRC_ELS_UNSOL,
 			"RCV RRQ:         did:x%x/ste:x%x flg:x%x",
@@ -5878,6 +6210,16 @@ lpfc_els_unsol_buffer(struct lpfc_hba *p
 		if (newnode)
 			lpfc_nlp_put(ndlp);
 		break;
+	case ELS_CMD_ECHO:
+		lpfc_debugfs_disc_trc(vport, LPFC_DISC_TRC_ELS_UNSOL,
+			"RCV ECHO:        did:x%x/ste:x%x flg:x%x",
+			did, vport->port_state, ndlp->nlp_flag);
+
+		phba->fc_stat.elsRcvECHO++;
+		lpfc_els_rcv_echo(vport, elsiocb, ndlp);
+		if (newnode)
+			lpfc_nlp_put(ndlp);
+		break;
 	default:
 		lpfc_debugfs_disc_trc(vport, LPFC_DISC_TRC_ELS_UNSOL,
 			"RCV ELS cmd:     cmd:x%x did:x%x/ste:x%x",
diff -upNr a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
--- a/drivers/scsi/lpfc/lpfc.h	2010-08-09 09:30:13.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc.h	2010-10-21 22:38:23.000000000 -0400
@@ -202,9 +202,12 @@ struct lpfc_stats {
 	uint32_t elsRcvPRLO;
 	uint32_t elsRcvPRLI;
 	uint32_t elsRcvLIRR;
+	uint32_t elsRcvRLS;
 	uint32_t elsRcvRPS;
 	uint32_t elsRcvRPL;
 	uint32_t elsRcvRRQ;
+	uint32_t elsRcvRTV;
+	uint32_t elsRcvECHO;
 	uint32_t elsXmitFLOGI;
 	uint32_t elsXmitFDISC;
 	uint32_t elsXmitPLOGI;
@@ -573,6 +576,7 @@ struct lpfc_hba {
 	/* These fields used to be binfo */
 	uint32_t fc_pref_DID;	/* preferred D_ID */
 	uint8_t  fc_pref_ALPA;	/* preferred AL_PA */
+	uint32_t fc_edtovResol; /* E_D_TOV timer resolution */
 	uint32_t fc_edtov;	/* E_D_TOV timer value */
 	uint32_t fc_arbtov;	/* ARB_TOV timer value */
 	uint32_t fc_ratov;	/* R_A_TOV timer value */
diff -upNr a/drivers/scsi/lpfc/lpfc_hw.h b/drivers/scsi/lpfc/lpfc_hw.h
--- a/drivers/scsi/lpfc/lpfc_hw.h	2010-10-11 12:32:22.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_hw.h	2010-10-21 22:38:23.000000000 -0400
@@ -861,6 +861,47 @@ typedef struct  _RPS_RSP {	/* Structure 
 	uint32_t crcCnt;
 } RPS_RSP;
 
+struct RLS {			/* Structure is in Big Endian format */
+	uint32_t rls;
+#define rls_rsvd_SHIFT		24
+#define rls_rsvd_MASK		0x000000ff
+#define rls_rsvd_WORD		rls
+#define rls_did_SHIFT		0
+#define rls_did_MASK		0x00ffffff
+#define rls_did_WORD		rls
+};
+
+struct  RLS_RSP {		/* Structure is in Big Endian format */
+	uint32_t linkFailureCnt;
+	uint32_t lossSyncCnt;
+	uint32_t lossSignalCnt;
+	uint32_t primSeqErrCnt;
+	uint32_t invalidXmitWord;
+	uint32_t crcCnt;
+};
+
+struct RTV_RSP {		/* Structure is in Big Endian format */
+	uint32_t ratov;
+	uint32_t edtov;
+	uint32_t qtov;
+#define qtov_rsvd0_SHIFT	28
+#define qtov_rsvd0_MASK		0x0000000f
+#define qtov_rsvd0_WORD		qtov		/* reserved */
+#define qtov_edtovres_SHIFT	27
+#define qtov_edtovres_MASK	0x00000001
+#define qtov_edtovres_WORD	qtov		/* E_D_TOV Resolution */
+#define qtov__rsvd1_SHIFT	19
+#define qtov_rsvd1_MASK		0x0000003f
+#define qtov_rsvd1_WORD		qtov		/* reserved */
+#define qtov_rttov_SHIFT	18
+#define qtov_rttov_MASK		0x00000001
+#define qtov_rttov_WORD		qtov		/* R_T_TOV value */
+#define qtov_rsvd2_SHIFT	0
+#define qtov_rsvd2_MASK		0x0003ffff
+#define qtov_rsvd2_WORD		qtov		/* reserved */
+};
+
+
 typedef struct  _RPL {		/* Structure is in Big Endian format */
 	uint32_t maxsize;
 	uint32_t index;


