From: James Smart <James.Smart@Emulex.Com>
Subject: [PATCH 9/16] lpfc 8.1.12 : Improve handling of failed ELS aborts
Date: Wed, 25 Apr 2007 09:52:55 -0400
Message-ID: <1177509175.23155.16.camel@localhost.localdomain>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:51691 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031024AbXDYNwr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 25 Apr 2007 09:52:47 -0400
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.13.6/8.13.6) with ESMTP id l3PDqkLF006628
	for <linux-scsi@vger.kernel.org>; Wed, 25 Apr 2007 06:52:46 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Improve handling of failed ELS aborts.

Signed-off-by: James Smart <James.Smart@emulex.com>


diff -upNr a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
--- a/drivers/scsi/lpfc/lpfc_els.c	2007-04-24 11:12:42.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_els.c	2007-04-24 11:12:42.000000000 -0400
@@ -182,6 +182,7 @@ lpfc_prep_els_iocb(struct lpfc_hba * phb
 		icmd->un.elsreq64.bdl.bdeSize = (2 * sizeof (struct ulp_bde64));
 		icmd->un.elsreq64.remoteID = did;	/* DID */
 		icmd->ulpCommand = CMD_ELS_REQUEST64_CR;
+		icmd->ulpTimeout = phba->fc_ratov * 2; 
 	} else {
 		icmd->un.elsreq64.bdl.bdeSize = sizeof (struct ulp_bde64);
 		icmd->ulpCommand = CMD_XMIT_ELS_RSP64_CX;
diff -upNr a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
--- a/drivers/scsi/lpfc/lpfc_sli.c	2007-04-24 11:12:42.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_sli.c	2007-04-24 11:12:42.000000000 -0400
@@ -2403,7 +2403,7 @@ lpfc_sli_issue_iocb(struct lpfc_hba *phb
 
 	if (unlikely(phba->hba_state == LPFC_LINK_DOWN)) {
 		/*
-		 * Only CREATE_XRI, CLOSE_XRI, ABORT_XRI, and QUE_RING_BUF
+		 * Only CREATE_XRI, CLOSE_XRI, and QUE_RING_BUF
 		 * can be issued if the link is not up.
 		 */
 		switch (piocb->iocb.ulpCommand) {
@@ -2417,6 +2417,8 @@ lpfc_sli_issue_iocb(struct lpfc_hba *phb
 				piocb->iocb_cmpl = NULL;
 			/*FALLTHROUGH*/
 		case CMD_CREATE_XRI_CR:
+		case CMD_CLOSE_XRI_CN:
+		case CMD_CLOSE_XRI_CX:
 			break;
 		default:
 			goto iocb_busy;
@@ -2741,7 +2743,58 @@ static void
 lpfc_sli_abort_els_cmpl(struct lpfc_hba * phba, struct lpfc_iocbq * cmdiocb,
 			struct lpfc_iocbq * rspiocb)
 {
+	IOCB_t *irsp;
+	uint16_t abort_iotag, abort_context;
+	struct lpfc_iocbq *abort_iocb, *rsp_ab_iocb;
+	struct lpfc_sli_ring *pring = &phba->sli.ring[LPFC_ELS_RING];
+
+	abort_iocb = NULL;
+	irsp = &rspiocb->iocb;
+
 	spin_lock_irq(phba->host->host_lock);
+
+	if (irsp->ulpStatus) {
+		abort_context = cmdiocb->iocb.un.acxri.abortContextTag;
+		abort_iotag = cmdiocb->iocb.un.acxri.abortIoTag;
+
+		if (abort_iotag != 0 && abort_iotag <= phba->sli.last_iotag)
+			abort_iocb = phba->sli.iocbq_lookup[abort_iotag];
+
+		lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
+				"%d:0327 Cannot abort els iocb %p"
+				" with tag %x context %x\n",
+				phba->brd_no, abort_iocb,
+				abort_iotag, abort_context);
+
+		/*
+		 * make sure we have the right iocbq before taking it
+		 * off the txcmplq and try to call completion routine.
+		 */
+		if (abort_iocb &&
+		    abort_iocb->iocb.ulpContext == abort_context &&
+		    abort_iocb->iocb_flag & LPFC_DRIVER_ABORTED) {
+			list_del(&abort_iocb->list);
+			pring->txcmplq_cnt--;
+
+			rsp_ab_iocb = lpfc_sli_get_iocbq(phba);
+			if (rsp_ab_iocb == NULL)
+				lpfc_sli_release_iocbq(phba, abort_iocb);
+			else {
+				abort_iocb->iocb_flag &=
+					~LPFC_DRIVER_ABORTED;
+				rsp_ab_iocb->iocb.ulpStatus =
+					IOSTAT_LOCAL_REJECT;
+				rsp_ab_iocb->iocb.un.ulpWord[4] =
+					IOERR_SLI_ABORTED;
+				spin_unlock_irq(phba->host->host_lock);
+				(abort_iocb->iocb_cmpl)
+					(phba, abort_iocb, rsp_ab_iocb);
+				spin_lock_irq(phba->host->host_lock);
+				lpfc_sli_release_iocbq(phba, rsp_ab_iocb);
+			}
+		}
+	}
+
 	lpfc_sli_release_iocbq(phba, cmdiocb);
 	spin_unlock_irq(phba->host->host_lock);
 	return;


