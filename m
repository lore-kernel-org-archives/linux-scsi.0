From: James Smart <James.Smart@Emulex.Com>
Subject: [PATCH 3/17] lpfc 8.3.2 : Reorganization for SLI4 - Part 3 of 3
Date: Fri, 22 May 2009 14:51:30 -0400
Message-ID: <1243018290.7729.43.camel@ogier>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:41954 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754170AbZEVSvc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 22 May 2009 14:51:32 -0400
Received: from xcm.ad.emulex.com (xcm.emulex.com [138.239.112.69])
	by emulex.emulex.com (8.13.6/8.13.6) with ESMTP id n4MIpYfZ029672
	for <linux-scsi@vger.kernel.org>; Fri, 22 May 2009 11:51:34 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

Reorganization for SLI4 - Part 3 of 3

Preps the organization of the driver so that the bottom half, which
interacts with the hardware, can share common code sequences for
attachment, detachment, initialization, teardown, etc with new hardware.

This patch genericizes the sections that were specific to the sli3
interface and ring handling.


 Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_ct.c   |    4 ---
 lpfc_els.c  |   76 ++++++++++++++++++------------------------------------------
 lpfc_scsi.c |   15 ++++-------
 3 files changed, 30 insertions(+), 65 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_ct.c b/drivers/scsi/lpfc/lpfc_ct.c
--- a/drivers/scsi/lpfc/lpfc_ct.c	2008-12-16 09:34:12.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_ct.c	2009-05-22 13:15:18.000000000 -0400
@@ -267,8 +267,6 @@ lpfc_gen_req(struct lpfc_vport *vport, s
 	     uint32_t tmo, uint8_t retry)
 {
 	struct lpfc_hba  *phba = vport->phba;
-	struct lpfc_sli  *psli = &phba->sli;
-	struct lpfc_sli_ring *pring = &psli->ring[LPFC_ELS_RING];
 	IOCB_t *icmd;
 	struct lpfc_iocbq *geniocb;
 	int rc;
@@ -331,7 +329,7 @@ lpfc_gen_req(struct lpfc_vport *vport, s
 	geniocb->drvrTimeout = icmd->ulpTimeout + LPFC_DRVR_TIMEOUT;
 	geniocb->vport = vport;
 	geniocb->retry = retry;
-	rc = lpfc_sli_issue_iocb(phba, pring, geniocb, 0);
+	rc = lpfc_sli_issue_iocb(phba, LPFC_ELS_RING, geniocb, 0);
 
 	if (rc == IOCB_ERROR) {
 		lpfc_sli_release_iocbq(phba, geniocb);
diff -upNr a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
--- a/drivers/scsi/lpfc/lpfc_els.c	2009-05-22 13:14:13.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_els.c	2009-05-22 13:15:18.000000000 -0400
@@ -1350,14 +1350,12 @@ lpfc_issue_els_plogi(struct lpfc_vport *
 	IOCB_t *icmd;
 	struct lpfc_nodelist *ndlp;
 	struct lpfc_iocbq *elsiocb;
-	struct lpfc_sli_ring *pring;
 	struct lpfc_sli *psli;
 	uint8_t *pcmd;
 	uint16_t cmdsize;
 	int ret;
 
 	psli = &phba->sli;
-	pring = &psli->ring[LPFC_ELS_RING];	/* ELS ring */
 
 	ndlp = lpfc_findnode_did(vport, did);
 	if (ndlp && !NLP_CHK_NODE_ACT(ndlp))
@@ -1391,7 +1389,7 @@ lpfc_issue_els_plogi(struct lpfc_vport *
 
 	phba->fc_stat.elsXmitPLOGI++;
 	elsiocb->iocb_cmpl = lpfc_cmpl_els_plogi;
-	ret = lpfc_sli_issue_iocb(phba, pring, elsiocb, 0);
+	ret = lpfc_sli_issue_iocb(phba, LPFC_ELS_RING, elsiocb, 0);
 
 	if (ret == IOCB_ERROR) {
 		lpfc_els_free_iocb(phba, elsiocb);
@@ -1501,14 +1499,9 @@ lpfc_issue_els_prli(struct lpfc_vport *v
 	PRLI *npr;
 	IOCB_t *icmd;
 	struct lpfc_iocbq *elsiocb;
-	struct lpfc_sli_ring *pring;
-	struct lpfc_sli *psli;
 	uint8_t *pcmd;
 	uint16_t cmdsize;
 
-	psli = &phba->sli;
-	pring = &psli->ring[LPFC_ELS_RING];	/* ELS ring */
-
 	cmdsize = (sizeof(uint32_t) + sizeof(PRLI));
 	elsiocb = lpfc_prep_els_iocb(vport, 1, cmdsize, retry, ndlp,
 				     ndlp->nlp_DID, ELS_CMD_PRLI);
@@ -1550,7 +1543,8 @@ lpfc_issue_els_prli(struct lpfc_vport *v
 	spin_lock_irq(shost->host_lock);
 	ndlp->nlp_flag |= NLP_PRLI_SND;
 	spin_unlock_irq(shost->host_lock);
-	if (lpfc_sli_issue_iocb(phba, pring, elsiocb, 0) == IOCB_ERROR) {
+	if (lpfc_sli_issue_iocb(phba, LPFC_ELS_RING, elsiocb, 0) ==
+	    IOCB_ERROR) {
 		spin_lock_irq(shost->host_lock);
 		ndlp->nlp_flag &= ~NLP_PRLI_SND;
 		spin_unlock_irq(shost->host_lock);
@@ -1788,8 +1782,6 @@ lpfc_issue_els_adisc(struct lpfc_vport *
 	ADISC *ap;
 	IOCB_t *icmd;
 	struct lpfc_iocbq *elsiocb;
-	struct lpfc_sli *psli = &phba->sli;
-	struct lpfc_sli_ring *pring = &psli->ring[LPFC_ELS_RING];
 	uint8_t *pcmd;
 	uint16_t cmdsize;
 
@@ -1822,7 +1814,8 @@ lpfc_issue_els_adisc(struct lpfc_vport *
 	spin_lock_irq(shost->host_lock);
 	ndlp->nlp_flag |= NLP_ADISC_SND;
 	spin_unlock_irq(shost->host_lock);
-	if (lpfc_sli_issue_iocb(phba, pring, elsiocb, 0) == IOCB_ERROR) {
+	if (lpfc_sli_issue_iocb(phba, LPFC_ELS_RING, elsiocb, 0) ==
+	    IOCB_ERROR) {
 		spin_lock_irq(shost->host_lock);
 		ndlp->nlp_flag &= ~NLP_ADISC_SND;
 		spin_unlock_irq(shost->host_lock);
@@ -1937,15 +1930,10 @@ lpfc_issue_els_logo(struct lpfc_vport *v
 	struct lpfc_hba  *phba = vport->phba;
 	IOCB_t *icmd;
 	struct lpfc_iocbq *elsiocb;
-	struct lpfc_sli_ring *pring;
-	struct lpfc_sli *psli;
 	uint8_t *pcmd;
 	uint16_t cmdsize;
 	int rc;
 
-	psli = &phba->sli;
-	pring = &psli->ring[LPFC_ELS_RING];
-
 	spin_lock_irq(shost->host_lock);
 	if (ndlp->nlp_flag & NLP_LOGO_SND) {
 		spin_unlock_irq(shost->host_lock);
@@ -1978,7 +1966,7 @@ lpfc_issue_els_logo(struct lpfc_vport *v
 	spin_lock_irq(shost->host_lock);
 	ndlp->nlp_flag |= NLP_LOGO_SND;
 	spin_unlock_irq(shost->host_lock);
-	rc = lpfc_sli_issue_iocb(phba, pring, elsiocb, 0);
+	rc = lpfc_sli_issue_iocb(phba, LPFC_ELS_RING, elsiocb, 0);
 
 	if (rc == IOCB_ERROR) {
 		spin_lock_irq(shost->host_lock);
@@ -2058,14 +2046,12 @@ lpfc_issue_els_scr(struct lpfc_vport *vp
 	struct lpfc_hba  *phba = vport->phba;
 	IOCB_t *icmd;
 	struct lpfc_iocbq *elsiocb;
-	struct lpfc_sli_ring *pring;
 	struct lpfc_sli *psli;
 	uint8_t *pcmd;
 	uint16_t cmdsize;
 	struct lpfc_nodelist *ndlp;
 
 	psli = &phba->sli;
-	pring = &psli->ring[LPFC_ELS_RING];	/* ELS ring */
 	cmdsize = (sizeof(uint32_t) + sizeof(SCR));
 
 	ndlp = lpfc_findnode_did(vport, nportid);
@@ -2108,7 +2094,8 @@ lpfc_issue_els_scr(struct lpfc_vport *vp
 
 	phba->fc_stat.elsXmitSCR++;
 	elsiocb->iocb_cmpl = lpfc_cmpl_els_cmd;
-	if (lpfc_sli_issue_iocb(phba, pring, elsiocb, 0) == IOCB_ERROR) {
+	if (lpfc_sli_issue_iocb(phba, LPFC_ELS_RING, elsiocb, 0) ==
+	    IOCB_ERROR) {
 		/* The additional lpfc_nlp_put will cause the following
 		 * lpfc_els_free_iocb routine to trigger the rlease of
 		 * the node.
@@ -2152,7 +2139,6 @@ lpfc_issue_els_farpr(struct lpfc_vport *
 	struct lpfc_hba  *phba = vport->phba;
 	IOCB_t *icmd;
 	struct lpfc_iocbq *elsiocb;
-	struct lpfc_sli_ring *pring;
 	struct lpfc_sli *psli;
 	FARP *fp;
 	uint8_t *pcmd;
@@ -2162,7 +2148,6 @@ lpfc_issue_els_farpr(struct lpfc_vport *
 	struct lpfc_nodelist *ndlp;
 
 	psli = &phba->sli;
-	pring = &psli->ring[LPFC_ELS_RING];	/* ELS ring */
 	cmdsize = (sizeof(uint32_t) + sizeof(FARP));
 
 	ndlp = lpfc_findnode_did(vport, nportid);
@@ -2219,7 +2204,8 @@ lpfc_issue_els_farpr(struct lpfc_vport *
 
 	phba->fc_stat.elsXmitFARPR++;
 	elsiocb->iocb_cmpl = lpfc_cmpl_els_cmd;
-	if (lpfc_sli_issue_iocb(phba, pring, elsiocb, 0) == IOCB_ERROR) {
+	if (lpfc_sli_issue_iocb(phba, LPFC_ELS_RING, elsiocb, 0) ==
+	    IOCB_ERROR) {
 		/* The additional lpfc_nlp_put will cause the following
 		 * lpfc_els_free_iocb routine to trigger the release of
 		 * the node.
@@ -2961,6 +2947,7 @@ lpfc_mbx_cmpl_dflt_rpi(struct lpfc_hba *
 		 */
 		lpfc_nlp_not_used(ndlp);
 	}
+
 	return;
 }
 
@@ -3170,7 +3157,6 @@ lpfc_els_rsp_acc(struct lpfc_vport *vpor
 	IOCB_t *icmd;
 	IOCB_t *oldcmd;
 	struct lpfc_iocbq *elsiocb;
-	struct lpfc_sli_ring *pring;
 	struct lpfc_sli *psli;
 	uint8_t *pcmd;
 	uint16_t cmdsize;
@@ -3178,7 +3164,6 @@ lpfc_els_rsp_acc(struct lpfc_vport *vpor
 	ELS_PKT *els_pkt_ptr;
 
 	psli = &phba->sli;
-	pring = &psli->ring[LPFC_ELS_RING];	/* ELS ring */
 	oldcmd = &oldiocb->iocb;
 
 	switch (flag) {
@@ -3266,7 +3251,7 @@ lpfc_els_rsp_acc(struct lpfc_vport *vpor
 	}
 
 	phba->fc_stat.elsXmitACC++;
-	rc = lpfc_sli_issue_iocb(phba, pring, elsiocb, 0);
+	rc = lpfc_sli_issue_iocb(phba, LPFC_ELS_RING, elsiocb, 0);
 	if (rc == IOCB_ERROR) {
 		lpfc_els_free_iocb(phba, elsiocb);
 		return 1;
@@ -3305,15 +3290,12 @@ lpfc_els_rsp_reject(struct lpfc_vport *v
 	IOCB_t *icmd;
 	IOCB_t *oldcmd;
 	struct lpfc_iocbq *elsiocb;
-	struct lpfc_sli_ring *pring;
 	struct lpfc_sli *psli;
 	uint8_t *pcmd;
 	uint16_t cmdsize;
 	int rc;
 
 	psli = &phba->sli;
-	pring = &psli->ring[LPFC_ELS_RING];	/* ELS ring */
-
 	cmdsize = 2 * sizeof(uint32_t);
 	elsiocb = lpfc_prep_els_iocb(vport, 0, cmdsize, oldiocb->retry, ndlp,
 				     ndlp->nlp_DID, ELS_CMD_LS_RJT);
@@ -3346,7 +3328,7 @@ lpfc_els_rsp_reject(struct lpfc_vport *v
 
 	phba->fc_stat.elsXmitLSRJT++;
 	elsiocb->iocb_cmpl = lpfc_cmpl_els_rsp;
-	rc = lpfc_sli_issue_iocb(phba, pring, elsiocb, 0);
+	rc = lpfc_sli_issue_iocb(phba, LPFC_ELS_RING, elsiocb, 0);
 
 	if (rc == IOCB_ERROR) {
 		lpfc_els_free_iocb(phba, elsiocb);
@@ -3379,8 +3361,6 @@ lpfc_els_rsp_adisc_acc(struct lpfc_vport
 		       struct lpfc_nodelist *ndlp)
 {
 	struct lpfc_hba  *phba = vport->phba;
-	struct lpfc_sli  *psli = &phba->sli;
-	struct lpfc_sli_ring *pring = &psli->ring[LPFC_ELS_RING];
 	ADISC *ap;
 	IOCB_t *icmd, *oldcmd;
 	struct lpfc_iocbq *elsiocb;
@@ -3422,7 +3402,7 @@ lpfc_els_rsp_adisc_acc(struct lpfc_vport
 
 	phba->fc_stat.elsXmitACC++;
 	elsiocb->iocb_cmpl = lpfc_cmpl_els_rsp;
-	rc = lpfc_sli_issue_iocb(phba, pring, elsiocb, 0);
+	rc = lpfc_sli_issue_iocb(phba, LPFC_ELS_RING, elsiocb, 0);
 	if (rc == IOCB_ERROR) {
 		lpfc_els_free_iocb(phba, elsiocb);
 		return 1;
@@ -3459,14 +3439,12 @@ lpfc_els_rsp_prli_acc(struct lpfc_vport 
 	IOCB_t *icmd;
 	IOCB_t *oldcmd;
 	struct lpfc_iocbq *elsiocb;
-	struct lpfc_sli_ring *pring;
 	struct lpfc_sli *psli;
 	uint8_t *pcmd;
 	uint16_t cmdsize;
 	int rc;
 
 	psli = &phba->sli;
-	pring = &psli->ring[LPFC_ELS_RING];	/* ELS ring */
 
 	cmdsize = sizeof(uint32_t) + sizeof(PRLI);
 	elsiocb = lpfc_prep_els_iocb(vport, 0, cmdsize, oldiocb->retry, ndlp,
@@ -3520,7 +3498,7 @@ lpfc_els_rsp_prli_acc(struct lpfc_vport 
 	phba->fc_stat.elsXmitACC++;
 	elsiocb->iocb_cmpl = lpfc_cmpl_els_rsp;
 
-	rc = lpfc_sli_issue_iocb(phba, pring, elsiocb, 0);
+	rc = lpfc_sli_issue_iocb(phba, LPFC_ELS_RING, elsiocb, 0);
 	if (rc == IOCB_ERROR) {
 		lpfc_els_free_iocb(phba, elsiocb);
 		return 1;
@@ -3562,15 +3540,12 @@ lpfc_els_rsp_rnid_acc(struct lpfc_vport 
 	RNID *rn;
 	IOCB_t *icmd, *oldcmd;
 	struct lpfc_iocbq *elsiocb;
-	struct lpfc_sli_ring *pring;
 	struct lpfc_sli *psli;
 	uint8_t *pcmd;
 	uint16_t cmdsize;
 	int rc;
 
 	psli = &phba->sli;
-	pring = &psli->ring[LPFC_ELS_RING];
-
 	cmdsize = sizeof(uint32_t) + sizeof(uint32_t)
 					+ (2 * sizeof(struct lpfc_name));
 	if (format)
@@ -3626,7 +3601,7 @@ lpfc_els_rsp_rnid_acc(struct lpfc_vport 
 	elsiocb->context1 = NULL;  /* Don't need ndlp for cmpl,
 				    * it could be freed */
 
-	rc = lpfc_sli_issue_iocb(phba, pring, elsiocb, 0);
+	rc = lpfc_sli_issue_iocb(phba, LPFC_ELS_RING, elsiocb, 0);
 	if (rc == IOCB_ERROR) {
 		lpfc_els_free_iocb(phba, elsiocb);
 		return 1;
@@ -4440,8 +4415,6 @@ lpfc_els_rcv_lirr(struct lpfc_vport *vpo
 static void
 lpfc_els_rsp_rps_acc(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 {
-	struct lpfc_sli *psli = &phba->sli;
-	struct lpfc_sli_ring *pring = &psli->ring[LPFC_ELS_RING];
 	MAILBOX_t *mb;
 	IOCB_t *icmd;
 	RPS_RSP *rps_rsp;
@@ -4507,7 +4480,7 @@ lpfc_els_rsp_rps_acc(struct lpfc_hba *ph
 			 ndlp->nlp_rpi);
 	elsiocb->iocb_cmpl = lpfc_cmpl_els_rsp;
 	phba->fc_stat.elsXmitACC++;
-	if (lpfc_sli_issue_iocb(phba, pring, elsiocb, 0) == IOCB_ERROR)
+	if (lpfc_sli_issue_iocb(phba, LPFC_ELS_RING, elsiocb, 0) == IOCB_ERROR)
 		lpfc_els_free_iocb(phba, elsiocb);
 	return;
 }
@@ -4616,8 +4589,6 @@ lpfc_els_rsp_rpl_acc(struct lpfc_vport *
 	IOCB_t *icmd, *oldcmd;
 	RPL_RSP rpl_rsp;
 	struct lpfc_iocbq *elsiocb;
-	struct lpfc_sli *psli = &phba->sli;
-	struct lpfc_sli_ring *pring = &psli->ring[LPFC_ELS_RING];
 	uint8_t *pcmd;
 
 	elsiocb = lpfc_prep_els_iocb(vport, 0, cmdsize, oldiocb->retry, ndlp,
@@ -4654,7 +4625,8 @@ lpfc_els_rsp_rpl_acc(struct lpfc_vport *
 			 ndlp->nlp_rpi);
 	elsiocb->iocb_cmpl = lpfc_cmpl_els_rsp;
 	phba->fc_stat.elsXmitACC++;
-	if (lpfc_sli_issue_iocb(phba, pring, elsiocb, 0) == IOCB_ERROR) {
+	if (lpfc_sli_issue_iocb(phba, LPFC_ELS_RING, elsiocb, 0) ==
+	    IOCB_ERROR) {
 		lpfc_els_free_iocb(phba, elsiocb);
 		return 1;
 	}
@@ -6139,7 +6111,6 @@ lpfc_issue_els_npiv_logo(struct lpfc_vpo
 {
 	struct Scsi_Host *shost = lpfc_shost_from_vport(vport);
 	struct lpfc_hba  *phba = vport->phba;
-	struct lpfc_sli_ring *pring = &phba->sli.ring[LPFC_ELS_RING];
 	IOCB_t *icmd;
 	struct lpfc_iocbq *elsiocb;
 	uint8_t *pcmd;
@@ -6169,7 +6140,8 @@ lpfc_issue_els_npiv_logo(struct lpfc_vpo
 	spin_lock_irq(shost->host_lock);
 	ndlp->nlp_flag |= NLP_LOGO_SND;
 	spin_unlock_irq(shost->host_lock);
-	if (lpfc_sli_issue_iocb(phba, pring, elsiocb, 0) == IOCB_ERROR) {
+	if (lpfc_sli_issue_iocb(phba, LPFC_ELS_RING, elsiocb, 0) ==
+	    IOCB_ERROR) {
 		spin_lock_irq(shost->host_lock);
 		ndlp->nlp_flag &= ~NLP_LOGO_SND;
 		spin_unlock_irq(shost->host_lock);
@@ -6224,7 +6196,6 @@ lpfc_resume_fabric_iocbs(struct lpfc_hba
 	struct lpfc_iocbq *iocb;
 	unsigned long iflags;
 	int ret;
-	struct lpfc_sli_ring *pring = &phba->sli.ring[LPFC_ELS_RING];
 	IOCB_t *cmd;
 
 repeat:
@@ -6248,7 +6219,7 @@ repeat:
 			"Fabric sched1:   ste:x%x",
 			iocb->vport->port_state, 0, 0);
 
-		ret = lpfc_sli_issue_iocb(phba, pring, iocb, 0);
+		ret = lpfc_sli_issue_iocb(phba, LPFC_ELS_RING, iocb, 0);
 
 		if (ret == IOCB_ERROR) {
 			iocb->iocb_cmpl = iocb->fabric_iocb_cmpl;
@@ -6394,7 +6365,6 @@ static int
 lpfc_issue_fabric_iocb(struct lpfc_hba *phba, struct lpfc_iocbq *iocb)
 {
 	unsigned long iflags;
-	struct lpfc_sli_ring *pring = &phba->sli.ring[LPFC_ELS_RING];
 	int ready;
 	int ret;
 
@@ -6418,7 +6388,7 @@ lpfc_issue_fabric_iocb(struct lpfc_hba *
 			"Fabric sched2:   ste:x%x",
 			iocb->vport->port_state, 0, 0);
 
-		ret = lpfc_sli_issue_iocb(phba, pring, iocb, 0);
+		ret = lpfc_sli_issue_iocb(phba, LPFC_ELS_RING, iocb, 0);
 
 		if (ret == IOCB_ERROR) {
 			iocb->iocb_cmpl = iocb->fabric_iocb_cmpl;
diff -upNr a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
--- a/drivers/scsi/lpfc/lpfc_scsi.c	2009-05-22 13:14:55.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_scsi.c	2009-05-22 13:15:18.000000000 -0400
@@ -2334,9 +2334,8 @@ lpfc_scsi_tgt_reset(struct lpfc_scsi_buf
 	lpfc_printf_vlog(vport, KERN_INFO, LOG_FCP,
 			 "0702 Issue Target Reset to TGT %d Data: x%x x%x\n",
 			 tgt_id, rdata->pnode->nlp_rpi, rdata->pnode->nlp_flag);
-	status = lpfc_sli_issue_iocb_wait(phba,
-				       &phba->sli.ring[phba->sli.fcp_ring],
-				       iocbq, iocbqrsp, lpfc_cmd->timeout);
+	status = lpfc_sli_issue_iocb_wait(phba, LPFC_FCP_RING,
+					  iocbq, iocbqrsp, lpfc_cmd->timeout);
 	if (status != IOCB_SUCCESS) {
 		if (status == IOCB_TIMEDOUT) {
 			iocbq->iocb_cmpl = lpfc_tskmgmt_def_cmpl;
@@ -2461,7 +2460,6 @@ lpfc_queuecommand(struct scsi_cmnd *cmnd
 	struct Scsi_Host  *shost = cmnd->device->host;
 	struct lpfc_vport *vport = (struct lpfc_vport *) shost->hostdata;
 	struct lpfc_hba   *phba = vport->phba;
-	struct lpfc_sli   *psli = &phba->sli;
 	struct lpfc_rport_data *rdata = cmnd->device->hostdata;
 	struct lpfc_nodelist *ndlp = rdata->pnode;
 	struct lpfc_scsi_buf *lpfc_cmd;
@@ -2583,7 +2581,7 @@ lpfc_queuecommand(struct scsi_cmnd *cmnd
 	lpfc_scsi_prep_cmnd(vport, lpfc_cmd, ndlp);
 
 	atomic_inc(&ndlp->cmd_pending);
-	err = lpfc_sli_issue_iocb(phba, &phba->sli.ring[psli->fcp_ring],
+	err = lpfc_sli_issue_iocb(phba, LPFC_FCP_RING,
 				  &lpfc_cmd->cur_iocbq, SLI_IOCB_RET_IOCB);
 	if (err) {
 		atomic_dec(&ndlp->cmd_pending);
@@ -2646,7 +2644,6 @@ lpfc_abort_handler(struct scsi_cmnd *cmn
 	struct Scsi_Host  *shost = cmnd->device->host;
 	struct lpfc_vport *vport = (struct lpfc_vport *) shost->hostdata;
 	struct lpfc_hba   *phba = vport->phba;
-	struct lpfc_sli_ring *pring = &phba->sli.ring[phba->sli.fcp_ring];
 	struct lpfc_iocbq *iocb;
 	struct lpfc_iocbq *abtsiocb;
 	struct lpfc_scsi_buf *lpfc_cmd;
@@ -2701,7 +2698,8 @@ lpfc_abort_handler(struct scsi_cmnd *cmn
 
 	abtsiocb->iocb_cmpl = lpfc_sli_abort_fcp_cmpl;
 	abtsiocb->vport = vport;
-	if (lpfc_sli_issue_iocb(phba, pring, abtsiocb, 0) == IOCB_ERROR) {
+	if (lpfc_sli_issue_iocb(phba, LPFC_FCP_RING, abtsiocb, 0) ==
+	    IOCB_ERROR) {
 		lpfc_sli_release_iocbq(phba, abtsiocb);
 		ret = FAILED;
 		goto out;
@@ -2827,8 +2825,7 @@ lpfc_device_reset_handler(struct scsi_cm
 			 "0703 Issue target reset to TGT %d LUN %d "
 			 "rpi x%x nlp_flag x%x\n", cmnd->device->id,
 			 cmnd->device->lun, pnode->nlp_rpi, pnode->nlp_flag);
-	status = lpfc_sli_issue_iocb_wait(phba,
-					  &phba->sli.ring[phba->sli.fcp_ring],
+	status = lpfc_sli_issue_iocb_wait(phba, LPFC_FCP_RING,
 					  iocbq, iocbqrsp, lpfc_cmd->timeout);
 	if (status == IOCB_TIMEDOUT) {
 		iocbq->iocb_cmpl = lpfc_tskmgmt_def_cmpl;


