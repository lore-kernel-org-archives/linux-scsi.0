From: Jamie Wellnitz <Jamie.Wellnitz@emulex.com>
Subject: [PATCH 18/22] lpfc 8.1.2: Code cleanup of lpfc_mbx_cmpl_config_link
Date: Tue, 28 Feb 2006 19:25:34 -0500
Message-ID: <20060301002534.GA15558@shrimp.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from shrimp.ma.emulex.com ([138.239.78.42]:62400 "EHLO
	shrimp.ma.emulex.com") by vger.kernel.org with ESMTP
	id S964851AbWCAAZf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Feb 2006 19:25:35 -0500
Received: from shrimp.ma.emulex.com (localhost.localdomain [127.0.0.1])
	by shrimp.ma.emulex.com (8.13.4/8.13.4) with ESMTP id k210PYWK015564
	for <linux-scsi@vger.kernel.org>; Tue, 28 Feb 2006 19:25:34 -0500
Received: (from jamesw@localhost)
	by shrimp.ma.emulex.com (8.13.4/8.13.4/Submit) id k210PY3N015563
	for linux-scsi@vger.kernel.org; Tue, 28 Feb 2006 19:25:34 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Code cleanup of lpfc_mbx_cmpl_config_link

Signed-off-by: Jamie Wellnitz <Jamie.Wellnitz@emulex.com>

--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -538,80 +538,59 @@ out:
 }
 
 static void
-lpfc_mbx_cmpl_config_link(struct lpfc_hba * phba, LPFC_MBOXQ_t * pmb)
+lpfc_mbx_cmpl_local_config_link(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 {
-	struct lpfc_sli *psli;
-	MAILBOX_t *mb;
-
-	psli = &phba->sli;
-	mb = &pmb->mb;
-	/* Check for error */
-	if (mb->mbxStatus) {
-		/* CONFIG_LINK mbox error <mbxStatus> state <hba_state> */
-		lpfc_printf_log(phba, KERN_ERR, LOG_MBOX,
-				"%d:0306 CONFIG_LINK mbxStatus error x%x "
-				"HBA state x%x\n",
-				phba->brd_no, mb->mbxStatus, phba->hba_state);
+	struct lpfc_sli *psli = &phba->sli;
+	int rc;
 
-		lpfc_linkdown(phba);
-		phba->hba_state = LPFC_HBA_ERROR;
+	if (pmb->mb.mbxStatus)
 		goto out;
-	}
 
-	if (phba->hba_state == LPFC_LOCAL_CFG_LINK) {
-		if (phba->fc_topology == TOPOLOGY_LOOP) {
-			/* If we are public loop and L bit was set */
-			if ((phba->fc_flag & FC_PUBLIC_LOOP) &&
-			    !(phba->fc_flag & FC_LBIT)) {
-				/* Need to wait for FAN - use discovery timer
-				 * for timeout.  hba_state is identically
-				 * LPFC_LOCAL_CFG_LINK while waiting for FAN
-				 */
-				lpfc_set_disctmo(phba);
-				mempool_free( pmb, phba->mbox_mem_pool);
-				return;
-			}
+	mempool_free(pmb, phba->mbox_mem_pool);
+
+	if (phba->fc_topology == TOPOLOGY_LOOP &&
+		phba->fc_flag & FC_PUBLIC_LOOP &&
+		 !(phba->fc_flag & FC_LBIT)) {
+			/* Need to wait for FAN - use discovery timer
+			 * for timeout.  hba_state is identically
+			 * LPFC_LOCAL_CFG_LINK while waiting for FAN
+			 */
+			lpfc_set_disctmo(phba);
+			return;
 		}
 
-		/* Start discovery by sending a FLOGI hba_state is identically
-		 * LPFC_FLOGI while waiting for FLOGI cmpl
-		 */
-		phba->hba_state = LPFC_FLOGI;
-		lpfc_set_disctmo(phba);
-		lpfc_initial_flogi(phba);
-		mempool_free( pmb, phba->mbox_mem_pool);
-		return;
-	}
-	if (phba->hba_state == LPFC_FABRIC_CFG_LINK) {
-		mempool_free( pmb, phba->mbox_mem_pool);
-		return;
-	}
+	/* Start discovery by sending a FLOGI. hba_state is identically
+	 * LPFC_FLOGI while waiting for FLOGI cmpl
+	 */
+	phba->hba_state = LPFC_FLOGI;
+	lpfc_set_disctmo(phba);
+	lpfc_initial_flogi(phba);
+	return;
 
 out:
-	/* CONFIG_LINK bad hba state <hba_state> */
-	lpfc_printf_log(phba,
-			KERN_ERR,
-			LOG_DISCOVERY,
+	lpfc_printf_log(phba, KERN_ERR, LOG_MBOX,
+			"%d:0306 CONFIG_LINK mbxStatus error x%x "
+			"HBA state x%x\n",
+			phba->brd_no, pmb->mb.mbxStatus, phba->hba_state);
+
+	lpfc_linkdown(phba);
+
+	phba->hba_state = LPFC_HBA_ERROR;
+
+	lpfc_printf_log(phba, KERN_ERR, LOG_DISCOVERY,
 			"%d:0200 CONFIG_LINK bad hba state x%x\n",
 			phba->brd_no, phba->hba_state);
 
-	if (phba->hba_state != LPFC_CLEAR_LA) {
-		lpfc_clear_la(phba, pmb);
-		pmb->mbox_cmpl = lpfc_mbx_cmpl_clear_la;
-		if (lpfc_sli_issue_mbox(phba, pmb, (MBX_NOWAIT | MBX_STOP_IOCB))
-		    == MBX_NOT_FINISHED) {
-			mempool_free( pmb, phba->mbox_mem_pool);
-			lpfc_disc_flush_list(phba);
-			psli->ring[(psli->ip_ring)].flag &=
-				~LPFC_STOP_IOCB_EVENT;
-			psli->ring[(psli->fcp_ring)].flag &=
-				~LPFC_STOP_IOCB_EVENT;
-			psli->ring[(psli->next_ring)].flag &=
-				~LPFC_STOP_IOCB_EVENT;
-			phba->hba_state = LPFC_HBA_READY;
-		}
-	} else {
-		mempool_free( pmb, phba->mbox_mem_pool);
+	lpfc_clear_la(phba, pmb);
+	pmb->mbox_cmpl = lpfc_mbx_cmpl_clear_la;
+	rc = lpfc_sli_issue_mbox(phba, pmb, (MBX_NOWAIT | MBX_STOP_IOCB));
+	if (rc == MBX_NOT_FINISHED) {
+		mempool_free(pmb, phba->mbox_mem_pool);
+		lpfc_disc_flush_list(phba);
+		psli->ring[(psli->ip_ring)].flag &= ~LPFC_STOP_IOCB_EVENT;
+		psli->ring[(psli->fcp_ring)].flag &= ~LPFC_STOP_IOCB_EVENT;
+		psli->ring[(psli->next_ring)].flag &= ~LPFC_STOP_IOCB_EVENT;
+		phba->hba_state = LPFC_HBA_READY;
 	}
 	return;
 }
@@ -765,7 +744,7 @@ lpfc_mbx_process_link_up(struct lpfc_hba
 	if (cfglink_mbox) {
 		phba->hba_state = LPFC_LOCAL_CFG_LINK;
 		lpfc_config_link(phba, cfglink_mbox);
-		cfglink_mbox->mbox_cmpl = lpfc_mbx_cmpl_config_link;
+		cfglink_mbox->mbox_cmpl = lpfc_mbx_cmpl_local_config_link;
 		lpfc_sli_issue_mbox(phba, cfglink_mbox,
 						(MBX_NOWAIT | MBX_STOP_IOCB));
 	}
