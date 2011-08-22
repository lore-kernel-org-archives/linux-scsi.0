From: James Smart <james.smart@emulex.com>
Subject: [PATCH 1/4] lpfc 8.3.26: Fix issues pertaining to SCSI/FC protocol.
Date: Sun, 21 Aug 2011 21:48:13 -0400
Message-ID: <1313977695.21906.4.camel@ogier>
Reply-To: james.smart@emulex.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exht1.emulex.com ([138.239.113.183]:6392 "EHLO
	exht1.ad.emulex.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756367Ab1HVBsq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 21 Aug 2011 21:48:46 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Fix issues pertaining to SCSI/FC protocol.

- Allow frames destined to 0xFFFFFE to be processed by the driver by matching
  that DID with the physical port.
- Call lpfc_sli_issue_iocb with context1 set to ndlp
- In echo command accept function, adjust memcpy to limit memcpy to 1K
- Set LPFC_SLI3_BG_ENABLED properly upon completion.
- Skip the INIT_VFI call in lpfc_register_fcf if the FCF is already
  registered and go immediately to initial flogi.
- use "status" variable instead of "ret" variable to hold the return of the
  fc_block_scsi_eh.


 Signed-off-by: Alex Iannicelli <alex.iannicelli@emulex.com>
 Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_els.c     |   11 +++++------
 lpfc_hbadisc.c |    2 +-
 lpfc_scsi.c    |   11 ++++++-----
 lpfc_sli.c     |   13 +++++++++----
 4 files changed, 21 insertions(+), 16 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
--- a/drivers/scsi/lpfc/lpfc_els.c	2011-08-10 14:34:51.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_els.c	2011-08-19 23:23:33.000000000 -0400
@@ -4082,9 +4082,6 @@ lpfc_els_rsp_rnid_acc(struct lpfc_vport 
 
 	phba->fc_stat.elsXmitACC++;
 	elsiocb->iocb_cmpl = lpfc_cmpl_els_rsp;
-	lpfc_nlp_put(ndlp);
-	elsiocb->context1 = NULL;  /* Don't need ndlp for cmpl,
-				    * it could be freed */
 
 	rc = lpfc_sli_issue_iocb(phba, LPFC_ELS_RING, elsiocb, 0);
 	if (rc == IOCB_ERROR) {
@@ -4166,6 +4163,11 @@ lpfc_els_rsp_echo_acc(struct lpfc_vport 
 	psli = &phba->sli;
 	cmdsize = oldiocb->iocb.unsli3.rcvsli3.acc_len;
 
+	/* The accumulated length can exceed the BPL_SIZE.  For
+	 * now, use this as the limit
+	 */
+	if (cmdsize > LPFC_BPL_SIZE)
+		cmdsize = LPFC_BPL_SIZE;
 	elsiocb = lpfc_prep_els_iocb(vport, 0, cmdsize, oldiocb->retry, ndlp,
 				     ndlp->nlp_DID, ELS_CMD_ACC);
 	if (!elsiocb)
@@ -4189,9 +4191,6 @@ lpfc_els_rsp_echo_acc(struct lpfc_vport 
 
 	phba->fc_stat.elsXmitACC++;
 	elsiocb->iocb_cmpl = lpfc_cmpl_els_rsp;
-	lpfc_nlp_put(ndlp);
-	elsiocb->context1 = NULL;  /* Don't need ndlp for cmpl,
-				    * it could be freed */
 
 	rc = lpfc_sli_issue_iocb(phba, LPFC_ELS_RING, elsiocb, 0);
 	if (rc == IOCB_ERROR) {
diff -upNr a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c	2011-08-10 14:34:51.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c	2011-08-19 23:23:33.000000000 -0400
@@ -1412,7 +1412,7 @@ lpfc_register_fcf(struct lpfc_hba *phba)
 		if (phba->pport->port_state != LPFC_FLOGI) {
 			phba->hba_flag |= FCF_RR_INPROG;
 			spin_unlock_irq(&phba->hbalock);
-			lpfc_issue_init_vfi(phba->pport);
+			lpfc_initial_flogi(phba->pport);
 			return;
 		}
 		spin_unlock_irq(&phba->hbalock);
diff -upNr a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
--- a/drivers/scsi/lpfc/lpfc_scsi.c	2011-08-10 14:34:51.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_scsi.c	2011-08-19 23:23:33.000000000 -0400
@@ -3056,8 +3056,9 @@ lpfc_queuecommand_lck(struct scsi_cmnd *
 	}
 	ndlp = rdata->pnode;
 
-	if (!(phba->sli3_options & LPFC_SLI3_BG_ENABLED) &&
-		scsi_get_prot_op(cmnd) != SCSI_PROT_NORMAL) {
+	if ((scsi_get_prot_op(cmnd) != SCSI_PROT_NORMAL) &&
+		(!(phba->sli3_options & LPFC_SLI3_BG_ENABLED) ||
+		(phba->sli_rev == LPFC_SLI_REV4))) {
 
 		lpfc_printf_log(phba, KERN_ERR, LOG_BG,
 				"9058 BLKGRD: ERROR: rcvd protected cmd:%02x"
@@ -3691,9 +3692,9 @@ lpfc_bus_reset_handler(struct scsi_cmnd 
 	fc_host_post_vendor_event(shost, fc_get_event_number(),
 		sizeof(scsi_event), (char *)&scsi_event, LPFC_NL_VENDOR_ID);
 
-	ret = fc_block_scsi_eh(cmnd);
-	if (ret)
-		return ret;
+	status = fc_block_scsi_eh(cmnd);
+	if (status)
+		return status;
 
 	/*
 	 * Since the driver manages a single bus device, reset all
diff -upNr a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
--- a/drivers/scsi/lpfc/lpfc_sli.c	2011-08-10 14:34:51.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_sli.c	2011-08-19 23:23:33.000000000 -0400
@@ -5818,9 +5818,13 @@ lpfc_sli4_hba_setup(struct lpfc_hba *phb
 	 * then turn off the global config parameters to disable the
 	 * feature in the driver.  This is not a fatal error.
 	 */
-	if ((phba->cfg_enable_bg) &&
-	    !(bf_get(lpfc_mbx_rq_ftr_rsp_dif, &mqe->un.req_ftrs)))
-		ftr_rsp++;
+	phba->sli3_options &= ~LPFC_SLI3_BG_ENABLED;
+	if (phba->cfg_enable_bg) {
+		if (bf_get(lpfc_mbx_rq_ftr_rsp_dif, &mqe->un.req_ftrs))
+			phba->sli3_options |= LPFC_SLI3_BG_ENABLED;
+		else
+			ftr_rsp++;
+	}
 
 	if (phba->max_vpi && phba->cfg_enable_npiv &&
 	    !(bf_get(lpfc_mbx_rq_ftr_rsp_npiv, &mqe->un.req_ftrs)))
@@ -13296,7 +13300,8 @@ lpfc_fc_frame_to_vport(struct lpfc_hba *
 	uint32_t did = (fc_hdr->fh_d_id[0] << 16 |
 			fc_hdr->fh_d_id[1] << 8 |
 			fc_hdr->fh_d_id[2]);
-
+	if (did == Fabric_DID)
+		return phba->pport;
 	vports = lpfc_create_vport_work_array(phba);
 	if (vports != NULL)
 		for (i = 0; i <= phba->max_vpi && vports[i] != NULL; i++) {



