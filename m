From: James Smart <James.Smart@Emulex.Com>
Subject: [PATCH 2/7] lpfc 8.1.5 : Use asynchronous ABTS completion to speed
	up abort completions
Date: Sat, 15 Apr 2006 11:53:00 -0400
Message-ID: <1145116381.3795.1.camel@localhost.localdomain>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:39091 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S1030275AbWDOPxD
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 15 Apr 2006 11:53:03 -0400
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.12.10/8.12.10) with ESMTP id k3FFr2rf011033
	for <linux-scsi@vger.kernel.org>; Sat, 15 Apr 2006 08:53:02 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Use asynchronous ABTS completion to speed up abort completions

Signed-off-by: James Smart <James.Smart@emulex.com>

--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -294,15 +294,6 @@ lpfc_config_port_post(struct lpfc_hba * 
 		}
 	}
 
-	/* This should turn on DELAYED ABTS for ELS timeouts */
-	lpfc_set_slim(phba, pmb, 0x052198, 0x1);
-	if (lpfc_sli_issue_mbox(phba, pmb, MBX_POLL) != MBX_SUCCESS) {
-		phba->hba_state = LPFC_HBA_ERROR;
-		mempool_free( pmb, phba->mbox_mem_pool);
-		return -EIO;
-	}
-
-
 	lpfc_read_config(phba, pmb);
 	if (lpfc_sli_issue_mbox(phba, pmb, MBX_POLL) != MBX_SUCCESS) {
 		lpfc_printf_log(phba,
--- a/drivers/scsi/lpfc/lpfc_mbox.c
+++ b/drivers/scsi/lpfc/lpfc_mbox.c
@@ -200,6 +200,9 @@ lpfc_init_link(struct lpfc_hba * phba,
 		break;
 	}
 
+	/* Enable asynchronous ABTS responses from firmware */
+	mb->un.varInitLnk.link_flags |= FLAGS_IMED_ABORT;
+
 	/* NEW_FEATURE
 	 * Setting up the link speed
 	 */
@@ -292,36 +295,6 @@ lpfc_unreg_did(struct lpfc_hba * phba, u
 	return;
 }
 
-/***********************************************/
-
-/*                  command to write slim      */
-/***********************************************/
-void
-lpfc_set_slim(struct lpfc_hba * phba, LPFC_MBOXQ_t * pmb, uint32_t addr,
-	      uint32_t value)
-{
-	MAILBOX_t *mb;
-
-	mb = &pmb->mb;
-	memset(pmb, 0, sizeof (LPFC_MBOXQ_t));
-
-	/* addr = 0x090597 is AUTO ABTS disable for ELS commands */
-	/* addr = 0x052198 is DELAYED ABTS enable for ELS commands */
-
-	/*
-	 * Always turn on DELAYED ABTS for ELS timeouts
-	 */
-	if ((addr == 0x052198) && (value == 0))
-		value = 1;
-
-	mb->un.varWords[0] = addr;
-	mb->un.varWords[1] = value;
-
-	mb->mbxCommand = MBX_SET_SLIM;
-	mb->mbxOwner = OWN_HOST;
-	return;
-}
-
 /**********************************************/
 /*  lpfc_read_nv  Issue a READ CONFIG         */
 /*                mailbox command             */
--- a/drivers/scsi/lpfc/lpfc_nportdisc.c
+++ b/drivers/scsi/lpfc/lpfc_nportdisc.c
@@ -788,10 +788,6 @@ lpfc_cmpl_plogi_plogi_issue(struct lpfc_
 	if (lpfc_reg_login
 	    (phba, irsp->un.elsreq64.remoteID,
 	     (uint8_t *) sp, mbox, 0) == 0) {
-		/* set_slim mailbox command needs to
-		 * execute first, queue this command to
-		 * be processed later.
-		 */
 		switch (ndlp->nlp_DID) {
 		case NameServer_DID:
 			mbox->mbox_cmpl =
--- a/drivers/scsi/lpfc/lpfc_crtn.h
+++ b/drivers/scsi/lpfc/lpfc_crtn.h
@@ -27,7 +27,6 @@ void lpfc_config_link(struct lpfc_hba *,
 int lpfc_read_sparam(struct lpfc_hba *, LPFC_MBOXQ_t *);
 void lpfc_read_config(struct lpfc_hba *, LPFC_MBOXQ_t *);
 void lpfc_read_lnk_stat(struct lpfc_hba *, LPFC_MBOXQ_t *);
-void lpfc_set_slim(struct lpfc_hba *, LPFC_MBOXQ_t *, uint32_t, uint32_t);
 int lpfc_reg_login(struct lpfc_hba *, uint32_t, uint8_t *, LPFC_MBOXQ_t *,
 		   uint32_t);
 void lpfc_unreg_login(struct lpfc_hba *, uint32_t, LPFC_MBOXQ_t *);
--- a/drivers/scsi/lpfc/lpfc_hw.h
+++ b/drivers/scsi/lpfc/lpfc_hw.h
@@ -1539,6 +1539,7 @@ typedef struct {
 
 #define FLAGS_TOPOLOGY_FAILOVER      0x0400	/* Bit 10 */
 #define FLAGS_LINK_SPEED             0x0800	/* Bit 11 */
+#define FLAGS_IMED_ABORT             0x04000	/* Bit 14 */
 
 	uint32_t link_speed;
 #define LINK_SPEED_AUTO 0       /* Auto selection */
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -302,10 +302,6 @@ lpfc_cmpl_els_flogi_fabric(struct lpfc_h
 	if (lpfc_reg_login(phba, Fabric_DID, (uint8_t *) sp, mbox, 0))
 		goto fail_free_mbox;
 
-	/*
-	 * set_slim mailbox command needs to execute first,
-	 * queue this command to be processed later.
-	 */
 	mbox->mbox_cmpl = lpfc_mbx_cmpl_fabric_reg_login;
 	mbox->context2 = ndlp;
 
@@ -1872,9 +1868,6 @@ lpfc_cmpl_els_acc(struct lpfc_hba * phba
 	if (mbox) {
 		if ((rspiocb->iocb.ulpStatus == 0)
 		    && (ndlp->nlp_flag & NLP_ACC_REGLOGIN)) {
-			/* set_slim mailbox command needs to execute first,
-			 * queue this command to be processed later.
-			 */
 			lpfc_unreg_rpi(phba, ndlp);
 			mbox->mbox_cmpl = lpfc_mbx_cmpl_reg_login;
 			mbox->context2 = ndlp;


