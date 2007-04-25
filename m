From: James Smart <James.Smart@Emulex.Com>
Subject: [PATCH 8/16] lpfc 8.1.12 : Improve diagnostic messages and change
	local loopback message to KERN_INFO
Date: Wed, 25 Apr 2007 09:52:49 -0400
Message-ID: <1177509169.23155.15.camel@localhost.localdomain>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:51677 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031017AbXDYNwl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 25 Apr 2007 09:52:41 -0400
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.13.6/8.13.6) with ESMTP id l3PDqdl9006611
	for <linux-scsi@vger.kernel.org>; Wed, 25 Apr 2007 06:52:40 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Improve diagnostic messages and change local loopback message to KERN_INFO

Signed-off-by: James Smart <James.Smart@emulex.com>


diff -upNr a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
--- a/drivers/scsi/lpfc/lpfc_attr.c	2007-04-24 11:12:41.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_attr.c	2007-04-24 11:12:42.000000000 -0400
@@ -237,6 +237,7 @@ lpfc_issue_lip(struct Scsi_Host *host)
 						     phba->fc_ratov * 2);
 	}
 
+	lpfc_set_loopback_flag(phba);
 	if (mbxstatus == MBX_TIMEOUT)
 		pmboxq->mbox_cmpl = lpfc_sli_def_mbox_cmpl;
 	else
diff -upNr a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
--- a/drivers/scsi/lpfc/lpfc_els.c	2007-04-24 11:12:41.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_els.c	2007-04-24 11:12:42.000000000 -0400
@@ -2046,10 +2046,9 @@ lpfc_els_rsp_reject(struct lpfc_hba * ph
 
 	/* Xmit ELS RJT <err> response tag <ulpIoTag> */
 	lpfc_printf_log(phba, KERN_INFO, LOG_ELS,
-			"%d:0129 Xmit ELS RJT x%x response tag x%x "
-			"Data: x%x x%x x%x x%x x%x\n",
-			phba->brd_no,
-			rejectError, elsiocb->iocb.ulpIoTag,
+			"%d:0129 Xmit ELS RJT x%x response tag x%x xri x%x, "
+			"did x%x, nlp_flag x%x, nlp_state x%x, rpi x%x\n",
+			phba->brd_no, rejectError, elsiocb->iotag,
 			elsiocb->iocb.ulpContext, ndlp->nlp_DID,
 			ndlp->nlp_flag, ndlp->nlp_state, ndlp->nlp_rpi);
 
@@ -2088,18 +2087,18 @@ lpfc_els_rsp_adisc_acc(struct lpfc_hba *
 	if (!elsiocb)
 		return 1;
 
+	icmd = &elsiocb->iocb;
+	oldcmd = &oldiocb->iocb;
+	icmd->ulpContext = oldcmd->ulpContext;	/* Xri */
+
 	/* Xmit ADISC ACC response tag <ulpIoTag> */
 	lpfc_printf_log(phba, KERN_INFO, LOG_ELS,
-			"%d:0130 Xmit ADISC ACC response tag x%x "
-			"Data: x%x x%x x%x x%x x%x\n",
-			phba->brd_no,
-			elsiocb->iocb.ulpIoTag,
+			"%d:0130 Xmit ADISC ACC response iotag x%x xri: "
+			"x%x, did x%x, nlp_flag x%x, nlp_state x%x rpi x%x\n",
+			phba->brd_no, elsiocb->iotag,
 			elsiocb->iocb.ulpContext, ndlp->nlp_DID,
 			ndlp->nlp_flag, ndlp->nlp_state, ndlp->nlp_rpi);
 
-	icmd = &elsiocb->iocb;
-	oldcmd = &oldiocb->iocb;
-	icmd->ulpContext = oldcmd->ulpContext;	/* Xri */
 	pcmd = (uint8_t *) (((struct lpfc_dmabuf *) elsiocb->context2)->virt);
 
 	*((uint32_t *) (pcmd)) = ELS_CMD_ACC;
@@ -2124,8 +2123,8 @@ lpfc_els_rsp_adisc_acc(struct lpfc_hba *
 }
 
 int
-lpfc_els_rsp_prli_acc(struct lpfc_hba * phba,
-		      struct lpfc_iocbq * oldiocb, struct lpfc_nodelist * ndlp)
+lpfc_els_rsp_prli_acc(struct lpfc_hba *phba, struct lpfc_iocbq *oldiocb,
+		      struct lpfc_nodelist *ndlp)
 {
 	PRLI *npr;
 	lpfc_vpd_t *vpd;
@@ -2147,18 +2146,18 @@ lpfc_els_rsp_prli_acc(struct lpfc_hba * 
 	if (!elsiocb)
 		return 1;
 
+	icmd = &elsiocb->iocb;
+	oldcmd = &oldiocb->iocb;
+	icmd->ulpContext = oldcmd->ulpContext;	/* Xri */
+
 	/* Xmit PRLI ACC response tag <ulpIoTag> */
 	lpfc_printf_log(phba, KERN_INFO, LOG_ELS,
-			"%d:0131 Xmit PRLI ACC response tag x%x "
-			"Data: x%x x%x x%x x%x x%x\n",
-			phba->brd_no,
-			elsiocb->iocb.ulpIoTag,
+			"%d:0131 Xmit PRLI ACC response tag x%x xri x%x, "
+			"did x%x, nlp_flag x%x, nlp_state x%x, rpi x%x\n",
+			phba->brd_no, elsiocb->iotag,
 			elsiocb->iocb.ulpContext, ndlp->nlp_DID,
 			ndlp->nlp_flag, ndlp->nlp_state, ndlp->nlp_rpi);
 
-	icmd = &elsiocb->iocb;
-	oldcmd = &oldiocb->iocb;
-	icmd->ulpContext = oldcmd->ulpContext;	/* Xri */
 	pcmd = (uint8_t *) (((struct lpfc_dmabuf *) elsiocb->context2)->virt);
 
 	*((uint32_t *) (pcmd)) = (ELS_CMD_ACC | (ELS_CMD_PRLI & ~ELS_RSP_MASK));
@@ -2228,17 +2227,17 @@ lpfc_els_rsp_rnid_acc(struct lpfc_hba * 
 	if (!elsiocb)
 		return 1;
 
+	icmd = &elsiocb->iocb;
+	oldcmd = &oldiocb->iocb;
+	icmd->ulpContext = oldcmd->ulpContext;	/* Xri */
+
 	/* Xmit RNID ACC response tag <ulpIoTag> */
 	lpfc_printf_log(phba, KERN_INFO, LOG_ELS,
 			"%d:0132 Xmit RNID ACC response tag x%x "
-			"Data: x%x\n",
-			phba->brd_no,
-			elsiocb->iocb.ulpIoTag,
+			"xri x%x\n",
+			phba->brd_no, elsiocb->iotag,
 			elsiocb->iocb.ulpContext);
 
-	icmd = &elsiocb->iocb;
-	oldcmd = &oldiocb->iocb;
-	icmd->ulpContext = oldcmd->ulpContext;	/* Xri */
 	pcmd = (uint8_t *) (((struct lpfc_dmabuf *) elsiocb->context2)->virt);
 
 	*((uint32_t *) (pcmd)) = ELS_CMD_ACC;
@@ -2701,6 +2700,7 @@ lpfc_els_rcv_flogi(struct lpfc_hba * phb
 			mbox->mbox_cmpl = lpfc_sli_def_mbox_cmpl;
 			rc = lpfc_sli_issue_mbox
 				(phba, mbox, (MBX_NOWAIT | MBX_STOP_IOCB));
+			lpfc_set_loopback_flag(phba);
 			if (rc == MBX_NOT_FINISHED) {
 				mempool_free( mbox, phba->mbox_mem_pool);
 			}
@@ -2842,10 +2842,9 @@ lpfc_els_rsp_rps_acc(struct lpfc_hba * p
 
 	/* Xmit ELS RPS ACC response tag <ulpIoTag> */
 	lpfc_printf_log(phba, KERN_INFO, LOG_ELS,
-			"%d:0118 Xmit ELS RPS ACC response tag x%x "
-			"Data: x%x x%x x%x x%x x%x\n",
-			phba->brd_no,
-			elsiocb->iocb.ulpIoTag,
+			"%d:0118 Xmit ELS RPS ACC response tag x%x xri x%x, "
+			"did x%x, nlp_flag x%x, nlp_state x%x, rpi x%x\n",
+			phba->brd_no, elsiocb->iotag,
 			elsiocb->iocb.ulpContext, ndlp->nlp_DID,
 			ndlp->nlp_flag, ndlp->nlp_state, ndlp->nlp_rpi);
 
@@ -2951,10 +2950,9 @@ lpfc_els_rsp_rpl_acc(struct lpfc_hba * p
 
 	/* Xmit ELS RPL ACC response tag <ulpIoTag> */
 	lpfc_printf_log(phba, KERN_INFO, LOG_ELS,
-			"%d:0120 Xmit ELS RPL ACC response tag x%x "
-			"Data: x%x x%x x%x x%x x%x\n",
-			phba->brd_no,
-			elsiocb->iocb.ulpIoTag,
+			"%d:0120 Xmit ELS RPL ACC response tag x%x xri x%x, "
+			"did x%x, nlp_flag x%x, nlp_state x%x, rpi x%x\n",
+			phba->brd_no, elsiocb->iotag,
 			elsiocb->iocb.ulpContext, ndlp->nlp_DID,
 			ndlp->nlp_flag, ndlp->nlp_state, ndlp->nlp_rpi);
 
diff -upNr a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
--- a/drivers/scsi/lpfc/lpfc.h	2007-04-24 11:12:41.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc.h	2007-04-24 11:12:42.000000000 -0400
@@ -247,6 +247,9 @@ struct lpfc_hba {
 #define FC_ABORT_DISCOVERY      0x8000	/* we want to abort discovery */
 #define FC_NDISC_ACTIVE         0x10000	/* NPort discovery active */
 #define FC_BYPASSED_MODE        0x20000	/* NPort is in bypassed mode */
+#define FC_LOOPBACK_MODE        0x40000	/* NPort is in Loopback mode */
+					/* This flag is set while issuing */
+					/* INIT_LINK mailbox command */
 
 	uint32_t fc_topology;	/* link topology, from LINK INIT */
 
@@ -388,6 +391,13 @@ struct lpfc_hba {
 	struct fc_host_statistics link_stats;
 };
 
+static inline void
+lpfc_set_loopback_flag(struct lpfc_hba *phba) {
+	if (phba->cfg_topology == FLAGS_LOCAL_LB)
+		phba->fc_flag |= FC_LOOPBACK_MODE;
+	else
+		phba->fc_flag &= ~FC_LOOPBACK_MODE;
+}
 
 struct rnidrsp {
 	void *buf;
diff -upNr a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c	2007-04-24 11:12:42.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c	2007-04-24 11:12:42.000000000 -0400
@@ -900,12 +900,21 @@ lpfc_mbx_cmpl_read_la(struct lpfc_hba * 
 
 	if (la->attType == AT_LINK_UP) {
 		phba->fc_stat.LinkUp++;
-		lpfc_printf_log(phba, KERN_ERR, LOG_LINK_EVENT,
+		if (phba->fc_flag & FC_LOOPBACK_MODE) {
+			lpfc_printf_log(phba, KERN_INFO, LOG_LINK_EVENT,
+				"%d:1306 Link Up Event in loop back mode "
+				"x%x received Data: x%x x%x x%x x%x\n",
+				phba->brd_no, la->eventTag, phba->fc_eventTag,
+				la->granted_AL_PA, la->UlnkSpeed,
+				phba->alpa_map[0]);
+		} else {
+			lpfc_printf_log(phba, KERN_ERR, LOG_LINK_EVENT,
 				"%d:1303 Link Up Event x%x received "
 				"Data: x%x x%x x%x x%x\n",
 				phba->brd_no, la->eventTag, phba->fc_eventTag,
 				la->granted_AL_PA, la->UlnkSpeed,
 				phba->alpa_map[0]);
+		}
 		lpfc_mbx_process_link_up(phba, la);
 	} else {
 		phba->fc_stat.LinkDown++;
@@ -2251,6 +2260,7 @@ lpfc_disc_timeout_handler(struct lpfc_hb
 		initlinkmbox->mb.un.varInitLnk.lipsr_AL_PA = 0;
 		rc = lpfc_sli_issue_mbox(phba, initlinkmbox,
 					 (MBX_NOWAIT | MBX_STOP_IOCB));
+		lpfc_set_loopback_flag(phba);
 		if (rc == MBX_NOT_FINISHED)
 			mempool_free(initlinkmbox, phba->mbox_mem_pool);
 
diff -upNr a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
--- a/drivers/scsi/lpfc/lpfc_init.c	2007-04-24 11:12:41.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_init.c	2007-04-24 11:12:42.000000000 -0400
@@ -391,6 +391,7 @@ lpfc_config_port_post(struct lpfc_hba * 
 	lpfc_init_link(phba, pmb, phba->cfg_topology, phba->cfg_link_speed);
 	pmb->mbox_cmpl = lpfc_sli_def_mbox_cmpl;
 	rc = lpfc_sli_issue_mbox(phba, pmb, MBX_NOWAIT);
+	lpfc_set_loopback_flag(phba);
 	if (rc != MBX_SUCCESS) {
 		lpfc_printf_log(phba,
 				KERN_ERR,
diff -upNr a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
--- a/drivers/scsi/lpfc/lpfc_sli.c	2007-04-24 11:12:41.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_sli.c	2007-04-24 11:12:42.000000000 -0400
@@ -2794,6 +2794,12 @@ lpfc_sli_issue_abort_iotag(struct lpfc_h
 		iabt->ulpCommand = CMD_CLOSE_XRI_CN;
 
 	abtsiocbp->iocb_cmpl = lpfc_sli_abort_els_cmpl;
+
+	lpfc_printf_log(phba, KERN_INFO, LOG_SLI,
+			"%d:0339 Abort xri x%x, original iotag x%x, abort "
+			"cmd iotag x%x\n",
+			phba->brd_no, iabt->un.acxri.abortContextTag,
+			iabt->un.acxri.abortIoTag, abtsiocbp->iotag);
 	retval = lpfc_sli_issue_iocb(phba, pring, abtsiocbp, 0);
 
 abort_iotag_exit:


