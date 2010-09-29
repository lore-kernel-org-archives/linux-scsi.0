From: James Smart <james.smart@emulex.com>
Subject: [PATCH 1/6] lpfc 8.3.17: Code Cleanup and Locking fixes
Date: Wed, 29 Sep 2010 11:18:45 -0400
Message-ID: <1285773525.25110.9.camel@wookie>
Reply-To: james.smart@emulex.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exht1.emulex.com ([138.239.113.183]:16092 "EHLO
	exht1.ad.emulex.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752505Ab0I2PSz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Sep 2010 11:18:55 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


- Move Unload flag earlier in vport deletei to stop ELS traffic
- Replaced some unnecessary spin_lock_irqsave with spin_lock_irq
- Fixed circular spinlock dependency between low-level driver and SCSI midlayer
- Remove duplicate code from lpfc_els_retry routine
- Make all error values negative

 Signed-off-by: Alex Iannicelli <alex.iannicelli@emulex.com>
 Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_bsg.c     |   81 +++++++++++++++++++++++-----------------------
 lpfc_els.c     |    2 +
 lpfc_hbadisc.c |   34 ++++++++++---------
 lpfc_init.c    |   34 +++++++++----------
 lpfc_sli.c     |  100 ++++++++++++++++++++++++++++++++++-----------------------
 lpfc_vport.c   |    8 +---
 6 files changed, 142 insertions(+), 117 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_bsg.c b/drivers/scsi/lpfc/lpfc_bsg.c
--- a/drivers/scsi/lpfc/lpfc_bsg.c	2010-08-09 09:30:13.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_bsg.c	2010-09-29 10:07:22.000000000 -0400
@@ -259,6 +259,7 @@ lpfc_bsg_send_mgmt_cmd(struct fc_bsg_job
 	struct bsg_job_data *dd_data;
 	uint32_t creg_val;
 	int rc = 0;
+	int iocb_stat;
 
 	/* in case no data is transferred */
 	job->reply->reply_payload_rcv_len = 0;
@@ -373,14 +374,13 @@ lpfc_bsg_send_mgmt_cmd(struct fc_bsg_job
 		readl(phba->HCregaddr); /* flush */
 	}
 
-	rc = lpfc_sli_issue_iocb(phba, LPFC_ELS_RING, cmdiocbq, 0);
-
-	if (rc == IOCB_SUCCESS)
+	iocb_stat = lpfc_sli_issue_iocb(phba, LPFC_ELS_RING, cmdiocbq, 0);
+	if (iocb_stat == IOCB_SUCCESS)
 		return 0; /* done for now */
-	else if (rc == IOCB_BUSY)
-		rc = EAGAIN;
+	else if (iocb_stat == IOCB_BUSY)
+		rc = -EAGAIN;
 	else
-		rc = EIO;
+		rc = -EIO;
 

 	/* iocb failed so cleanup */
@@ -631,9 +631,9 @@ lpfc_bsg_rport_els(struct fc_bsg_job *jo
 	if (rc == IOCB_SUCCESS)
 		return 0; /* done for now */
 	else if (rc == IOCB_BUSY)
-		rc = EAGAIN;
+		rc = -EAGAIN;
 	else
-		rc = EIO;
+		rc = -EIO;
 
 	pci_unmap_sg(phba->pcidev, job->request_payload.sg_list,
 		     job->request_payload.sg_cnt, DMA_TO_DEVICE);
@@ -1299,7 +1299,7 @@ lpfc_issue_ct_rsp(struct lpfc_hba *phba,
 	/* Allocate buffer for  command iocb */
 	ctiocb = lpfc_sli_get_iocbq(phba);
 	if (!ctiocb) {
-		rc = ENOMEM;
+		rc = -ENOMEM;
 		goto no_ctiocb;
 	}
 
@@ -1649,17 +1649,18 @@ static int lpfcdiag_loop_self_reg(struct
 
 	mbox = mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
 	if (!mbox)
-		return ENOMEM;
+		return -ENOMEM;
 
 	status = lpfc_reg_rpi(phba, 0, phba->pport->fc_myDID,
 				(uint8_t *)&phba->pport->fc_sparam, mbox, 0);
 	if (status) {
 		mempool_free(mbox, phba->mbox_mem_pool);
-		return ENOMEM;
+		return -ENOMEM;
 	}
 
 	dmabuff = (struct lpfc_dmabuf *) mbox->context1;
 	mbox->context1 = NULL;
+	mbox->context2 = NULL;
 	status = lpfc_sli_issue_mbox_wait(phba, mbox, LPFC_MBOX_TMO);
 
 	if ((status != MBX_SUCCESS) || (mbox->u.mb.mbxStatus)) {
@@ -1667,7 +1668,7 @@ static int lpfcdiag_loop_self_reg(struct
 		kfree(dmabuff);
 		if (status != MBX_TIMEOUT)
 			mempool_free(mbox, phba->mbox_mem_pool);
-		return ENODEV;
+		return -ENODEV;
 	}
 
 	*rpi = mbox->u.mb.un.varWords[0];
@@ -1693,7 +1694,7 @@ static int lpfcdiag_loop_self_unreg(stru
 	/* Allocate mboxq structure */
 	mbox = mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
 	if (mbox == NULL)
-		return ENOMEM;
+		return -ENOMEM;
 
 	lpfc_unreg_login(phba, 0, rpi, mbox);
 	status = lpfc_sli_issue_mbox_wait(phba, mbox, LPFC_MBOX_TMO);
@@ -1701,7 +1702,7 @@ static int lpfcdiag_loop_self_unreg(stru
 	if ((status != MBX_SUCCESS) || (mbox->u.mb.mbxStatus)) {
 		if (status != MBX_TIMEOUT)
 			mempool_free(mbox, phba->mbox_mem_pool);
-		return EIO;
+		return -EIO;
 	}
 
 	mempool_free(mbox, phba->mbox_mem_pool);
@@ -1730,6 +1731,8 @@ static int lpfcdiag_loop_get_xri(struct 
 	struct ulp_bde64 *bpl = NULL;
 	struct lpfc_sli_ct_request *ctreq = NULL;
 	int ret_val = 0;
+	int time_left;
+	int iocb_stat;
 	unsigned long flags;
 
 	*txxri = 0;
@@ -1737,7 +1740,7 @@ static int lpfcdiag_loop_get_xri(struct 
 	evt = lpfc_bsg_event_new(FC_REG_CT_EVENT, current->pid,
 				SLI_CT_ELX_LOOPBACK);
 	if (!evt)
-		return ENOMEM;
+		return -ENOMEM;
 
 	spin_lock_irqsave(&phba->ct_ev_lock, flags);
 	list_add(&evt->node, &phba->ct_ev_waiters);
@@ -1770,7 +1773,7 @@ static int lpfcdiag_loop_get_xri(struct 
 	if (cmdiocbq == NULL || rspiocbq == NULL ||
 	    dmabuf == NULL || bpl == NULL || ctreq == NULL ||
 		dmabuf->virt == NULL) {
-		ret_val = ENOMEM;
+		ret_val = -ENOMEM;
 		goto err_get_xri_exit;
 	}
 
@@ -1806,24 +1809,24 @@ static int lpfcdiag_loop_get_xri(struct 
 	cmdiocbq->iocb_flag |= LPFC_IO_LIBDFC;
 	cmdiocbq->vport = phba->pport;
 
-	ret_val = lpfc_sli_issue_iocb_wait(phba, LPFC_ELS_RING, cmdiocbq,
+	iocb_stat = lpfc_sli_issue_iocb_wait(phba, LPFC_ELS_RING, cmdiocbq,
 				rspiocbq,
 				(phba->fc_ratov * 2)
 				+ LPFC_DRVR_TIMEOUT);
-	if (ret_val)
+	if (iocb_stat) {
+		ret_val = -EIO;
 		goto err_get_xri_exit;
-
+	}
 	*txxri =  rsp->ulpContext;
 
 	evt->waiting = 1;
 	evt->wait_time_stamp = jiffies;
-	ret_val = wait_event_interruptible_timeout(
+	time_left = wait_event_interruptible_timeout(
 		evt->wq, !list_empty(&evt->events_to_see),
 		((phba->fc_ratov * 2) + LPFC_DRVR_TIMEOUT) * HZ);
 	if (list_empty(&evt->events_to_see))
-		ret_val = (ret_val) ? EINTR : ETIMEDOUT;
+		ret_val = (time_left) ? -EINTR : -ETIMEDOUT;
 	else {
-		ret_val = IOCB_SUCCESS;
 		spin_lock_irqsave(&phba->ct_ev_lock, flags);
 		list_move(evt->events_to_see.prev, &evt->events_to_get);
 		spin_unlock_irqrestore(&phba->ct_ev_lock, flags);
@@ -1845,7 +1848,7 @@ err_get_xri_exit:
 		kfree(dmabuf);
 	}
 
-	if (cmdiocbq && (ret_val != IOCB_TIMEDOUT))
+	if (cmdiocbq && (iocb_stat != IOCB_TIMEDOUT))
 		lpfc_sli_release_iocbq(phba, cmdiocbq);
 	if (rspiocbq)
 		lpfc_sli_release_iocbq(phba, rspiocbq);
@@ -1959,6 +1962,7 @@ static int lpfcdiag_loop_post_rxbufs(str
 	uint32_t num_bde;
 	struct lpfc_dmabufext *rxbuffer = NULL;
 	int ret_val = 0;
+	int iocb_stat;
 	int i = 0;
 
 	cmdiocbq = lpfc_sli_get_iocbq(phba);
@@ -1973,7 +1977,7 @@ static int lpfcdiag_loop_post_rxbufs(str
 	}
 
 	if (!cmdiocbq || !rxbmp || !rxbpl || !rxbuffer) {
-		ret_val = ENOMEM;
+		ret_val = -ENOMEM;
 		goto err_post_rxbufs_exit;
 	}
 
@@ -2022,16 +2026,16 @@ static int lpfcdiag_loop_post_rxbufs(str
 		cmd->ulpClass = CLASS3;
 		cmd->ulpContext = rxxri;
 
-		ret_val = lpfc_sli_issue_iocb(phba, LPFC_ELS_RING, cmdiocbq, 0);
-
-		if (ret_val == IOCB_ERROR) {
+		iocb_stat = lpfc_sli_issue_iocb(phba, LPFC_ELS_RING, cmdiocbq,
+						0);
+		if (iocb_stat == IOCB_ERROR) {
 			diag_cmd_data_free(phba,
 				(struct lpfc_dmabufext *)mp[0]);
 			if (mp[1])
 				diag_cmd_data_free(phba,
 					  (struct lpfc_dmabufext *)mp[1]);
 			dmp = list_entry(next, struct lpfc_dmabuf, list);
-			ret_val = EIO;
+			ret_val = -EIO;
 			goto err_post_rxbufs_exit;
 		}
 
@@ -2045,7 +2049,7 @@ static int lpfcdiag_loop_post_rxbufs(str
 		cmdiocbq = lpfc_sli_get_iocbq(phba);
 		if (!cmdiocbq) {
 			dmp = list_entry(next, struct lpfc_dmabuf, list);
-			ret_val = EIO;
+			ret_val = -EIO;
 			goto err_post_rxbufs_exit;
 		}
 
@@ -2111,6 +2115,8 @@ lpfc_bsg_diag_test(struct fc_bsg_job *jo
 	uint32_t num_bde;
 	uint8_t *ptr = NULL, *rx_databuf = NULL;
 	int rc = 0;
+	int time_left;
+	int iocb_stat;
 	unsigned long flags;
 	void *dataout = NULL;
 	uint32_t total_mem;
@@ -2185,22 +2191,18 @@ lpfc_bsg_diag_test(struct fc_bsg_job *jo
 				ptr, size);
 
 	rc = lpfcdiag_loop_self_reg(phba, &rpi);
-	if (rc) {
-		rc = -ENOMEM;
+	if (rc)
 		goto loopback_test_exit;
-	}
 
 	rc = lpfcdiag_loop_get_xri(phba, rpi, &txxri, &rxxri);
 	if (rc) {
 		lpfcdiag_loop_self_unreg(phba, rpi);
-		rc = -ENOMEM;
 		goto loopback_test_exit;
 	}
 
 	rc = lpfcdiag_loop_post_rxbufs(phba, rxxri, full_size);
 	if (rc) {
 		lpfcdiag_loop_self_unreg(phba, rpi);
-		rc = -ENOMEM;
 		goto loopback_test_exit;
 	}
 
@@ -2290,21 +2292,22 @@ lpfc_bsg_diag_test(struct fc_bsg_job *jo
 	cmdiocbq->iocb_flag |= LPFC_IO_LIBDFC;
 	cmdiocbq->vport = phba->pport;
 
-	rc = lpfc_sli_issue_iocb_wait(phba, LPFC_ELS_RING, cmdiocbq, rspiocbq,
-				      (phba->fc_ratov * 2) + LPFC_DRVR_TIMEOUT);
+	iocb_stat = lpfc_sli_issue_iocb_wait(phba, LPFC_ELS_RING, cmdiocbq,
+					     rspiocbq, (phba->fc_ratov * 2) +
+					     LPFC_DRVR_TIMEOUT);
 
-	if ((rc != IOCB_SUCCESS) || (rsp->ulpStatus != IOCB_SUCCESS)) {
+	if ((iocb_stat != IOCB_SUCCESS) || (rsp->ulpStatus != IOCB_SUCCESS)) {
 		rc = -EIO;
 		goto err_loopback_test_exit;
 	}
 
 	evt->waiting = 1;
-	rc = wait_event_interruptible_timeout(
+	time_left = wait_event_interruptible_timeout(
 		evt->wq, !list_empty(&evt->events_to_see),
 		((phba->fc_ratov * 2) + LPFC_DRVR_TIMEOUT) * HZ);
 	evt->waiting = 0;
 	if (list_empty(&evt->events_to_see))
-		rc = (rc) ? -EINTR : -ETIMEDOUT;
+		rc = (time_left) ? -EINTR : -ETIMEDOUT;
 	else {
 		spin_lock_irqsave(&phba->ct_ev_lock, flags);
 		list_move(evt->events_to_see.prev, &evt->events_to_get);
diff -upNr a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
--- a/drivers/scsi/lpfc/lpfc_els.c	2010-08-09 09:30:14.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_els.c	2010-09-29 10:07:22.000000000 -0400
@@ -3250,6 +3250,8 @@ lpfc_mbx_cmpl_dflt_rpi(struct lpfc_hba *
 		lpfc_sli4_free_rpi(phba, pmb->u.mb.un.varUnregLogin.rpi);
 
 	pmb->context1 = NULL;
+	pmb->context2 = NULL;
+
 	lpfc_mbuf_free(phba, mp->virt, mp->phys);
 	kfree(mp);
 	mempool_free(pmb, phba->mbox_mem_pool);
diff -upNr a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c	2010-08-09 09:30:14.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c	2010-09-29 10:07:22.000000000 -0400
@@ -1015,7 +1015,6 @@ static void
 lpfc_mbx_cmpl_reg_fcfi(struct lpfc_hba *phba, LPFC_MBOXQ_t *mboxq)
 {
 	struct lpfc_vport *vport = mboxq->vport;
-	unsigned long flags;
 
 	if (mboxq->u.mb.mbxStatus) {
 		lpfc_printf_vlog(vport, KERN_ERR, LOG_MBOX,
@@ -1029,18 +1028,18 @@ lpfc_mbx_cmpl_reg_fcfi(struct lpfc_hba *
 	/* Start FCoE discovery by sending a FLOGI. */
 	phba->fcf.fcfi = bf_get(lpfc_reg_fcfi_fcfi, &mboxq->u.mqe.un.reg_fcfi);
 	/* Set the FCFI registered flag */
-	spin_lock_irqsave(&phba->hbalock, flags);
+	spin_lock_irq(&phba->hbalock);
 	phba->fcf.fcf_flag |= FCF_REGISTERED;
-	spin_unlock_irqrestore(&phba->hbalock, flags);
+	spin_unlock_irq(&phba->hbalock);
 	/* If there is a pending FCoE event, restart FCF table scan. */
 	if (lpfc_check_pending_fcoe_event(phba, 1)) {
 		mempool_free(mboxq, phba->mbox_mem_pool);
 		return;
 	}
-	spin_lock_irqsave(&phba->hbalock, flags);
+	spin_lock_irq(&phba->hbalock);
 	phba->fcf.fcf_flag |= (FCF_SCAN_DONE | FCF_IN_USE);
 	phba->hba_flag &= ~FCF_DISC_INPROGRESS;
-	spin_unlock_irqrestore(&phba->hbalock, flags);
+	spin_unlock_irq(&phba->hbalock);
 	if (vport->port_state != LPFC_FLOGI)
 		lpfc_initial_flogi(vport);
 
@@ -1240,14 +1239,13 @@ lpfc_register_fcf(struct lpfc_hba *phba)
 {
 	LPFC_MBOXQ_t *fcf_mbxq;
 	int rc;
-	unsigned long flags;
 
-	spin_lock_irqsave(&phba->hbalock, flags);
+	spin_lock_irq(&phba->hbalock);
 
 	/* If the FCF is not availabe do nothing. */
 	if (!(phba->fcf.fcf_flag & FCF_AVAILABLE)) {
 		phba->hba_flag &= ~FCF_DISC_INPROGRESS;
-		spin_unlock_irqrestore(&phba->hbalock, flags);
+		spin_unlock_irq(&phba->hbalock);
 		return;
 	}
 
@@ -1255,19 +1253,19 @@ lpfc_register_fcf(struct lpfc_hba *phba)
 	if (phba->fcf.fcf_flag & FCF_REGISTERED) {
 		phba->fcf.fcf_flag |= (FCF_SCAN_DONE | FCF_IN_USE);
 		phba->hba_flag &= ~FCF_DISC_INPROGRESS;
-		spin_unlock_irqrestore(&phba->hbalock, flags);
+		spin_unlock_irq(&phba->hbalock);
 		if (phba->pport->port_state != LPFC_FLOGI)
 			lpfc_initial_flogi(phba->pport);
 		return;
 	}
-	spin_unlock_irqrestore(&phba->hbalock, flags);
+	spin_unlock_irq(&phba->hbalock);
 
 	fcf_mbxq = mempool_alloc(phba->mbox_mem_pool,
 		GFP_KERNEL);
 	if (!fcf_mbxq) {
-		spin_lock_irqsave(&phba->hbalock, flags);
+		spin_lock_irq(&phba->hbalock);
 		phba->hba_flag &= ~FCF_DISC_INPROGRESS;
-		spin_unlock_irqrestore(&phba->hbalock, flags);
+		spin_unlock_irq(&phba->hbalock);
 		return;
 	}
 
@@ -1276,9 +1274,9 @@ lpfc_register_fcf(struct lpfc_hba *phba)
 	fcf_mbxq->mbox_cmpl = lpfc_mbx_cmpl_reg_fcfi;
 	rc = lpfc_sli_issue_mbox(phba, fcf_mbxq, MBX_NOWAIT);
 	if (rc == MBX_NOT_FINISHED) {
-		spin_lock_irqsave(&phba->hbalock, flags);
+		spin_lock_irq(&phba->hbalock);
 		phba->hba_flag &= ~FCF_DISC_INPROGRESS;
-		spin_unlock_irqrestore(&phba->hbalock, flags);
+		spin_unlock_irq(&phba->hbalock);
 		mempool_free(fcf_mbxq, phba->mbox_mem_pool);
 	}
 
@@ -2851,6 +2849,7 @@ lpfc_mbx_cmpl_reg_login(struct lpfc_hba 
 	struct Scsi_Host  *shost = lpfc_shost_from_vport(vport);
 
 	pmb->context1 = NULL;
+	pmb->context2 = NULL;
 
 	if (ndlp->nlp_flag & NLP_REG_LOGIN_SEND)
 		ndlp->nlp_flag &= ~NLP_REG_LOGIN_SEND;
@@ -3149,6 +3148,7 @@ lpfc_mbx_cmpl_fabric_reg_login(struct lp
 	ndlp = (struct lpfc_nodelist *) pmb->context2;
 	pmb->context1 = NULL;
 	pmb->context2 = NULL;
+
 	if (mb->mbxStatus) {
 		lpfc_printf_vlog(vport, KERN_ERR, LOG_MBOX,
 				 "0258 Register Fabric login error: 0x%x\n",
@@ -3218,6 +3218,9 @@ lpfc_mbx_cmpl_ns_reg_login(struct lpfc_h
 	struct lpfc_nodelist *ndlp = (struct lpfc_nodelist *) pmb->context2;
 	struct lpfc_vport *vport = pmb->vport;
 
+	pmb->context1 = NULL;
+	pmb->context2 = NULL;
+
 	if (mb->mbxStatus) {
 out:
 		lpfc_printf_vlog(vport, KERN_ERR, LOG_ELS,
@@ -3249,8 +3252,6 @@ out:
 		return;
 	}
 
-	pmb->context1 = NULL;
-
 	ndlp->nlp_rpi = mb->un.varWords[0];
 	ndlp->nlp_flag |= NLP_RPI_VALID;
 	ndlp->nlp_type |= NLP_FABRIC;
@@ -4784,6 +4785,7 @@ lpfc_mbx_cmpl_fdmi_reg_login(struct lpfc
 	struct lpfc_vport    *vport = pmb->vport;
 
 	pmb->context1 = NULL;
+	pmb->context2 = NULL;
 
 	ndlp->nlp_rpi = mb->un.varWords[0];
 	ndlp->nlp_flag |= NLP_RPI_VALID;
diff -upNr a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
--- a/drivers/scsi/lpfc/lpfc_init.c	2010-08-09 09:30:14.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_init.c	2010-09-29 10:07:23.000000000 -0400
@@ -4725,8 +4725,8 @@ out_free_mem:
  *
  * Return codes
  * 	0 - successful
- * 	ENOMEM - No availble memory
- *      EIO - The mailbox failed to complete successfully.
+ * 	-ENOMEM - No availble memory
+ *      -EIO - The mailbox failed to complete successfully.
  **/
 int
 lpfc_sli4_init_rpi_hdrs(struct lpfc_hba *phba)
@@ -5419,7 +5419,7 @@ lpfc_sli4_bar2_register_memmap(struct lp
  *
  * Return codes
  * 	0 - successful
- * 	ENOMEM - could not allocated memory.
+ * 	-ENOMEM - could not allocated memory.
  **/
 static int
 lpfc_create_bootstrap_mbox(struct lpfc_hba *phba)
@@ -5518,8 +5518,8 @@ lpfc_destroy_bootstrap_mbox(struct lpfc_
  *
  * Return codes
  * 	0 - successful
- * 	ENOMEM - No availble memory
- *      EIO - The mailbox failed to complete successfully.
+ * 	-ENOMEM - No availble memory
+ *      -EIO - The mailbox failed to complete successfully.
  **/
 static int
 lpfc_sli4_read_config(struct lpfc_hba *phba)
@@ -5622,8 +5622,8 @@ lpfc_sli4_read_config(struct lpfc_hba *p
  *
  * Return codes
  * 	0 - successful
- * 	ENOMEM - No availble memory
- *      EIO - The mailbox failed to complete successfully.
+ * 	-ENOMEM - No availble memory
+ *      -EIO - The mailbox failed to complete successfully.
  **/
 static int
 lpfc_setup_endian_order(struct lpfc_hba *phba)
@@ -5671,8 +5671,8 @@ lpfc_setup_endian_order(struct lpfc_hba 
  *
  * Return codes
  *      0 - successful
- *      ENOMEM - No availble memory
- *      EIO - The mailbox failed to complete successfully.
+ *      -ENOMEM - No availble memory
+ *      -EIO - The mailbox failed to complete successfully.
  **/
 static int
 lpfc_sli4_queue_create(struct lpfc_hba *phba)
@@ -5966,8 +5966,8 @@ out_error:
  *
  * Return codes
  *      0 - successful
- *      ENOMEM - No availble memory
- *      EIO - The mailbox failed to complete successfully.
+ *      -ENOMEM - No availble memory
+ *      -EIO - The mailbox failed to complete successfully.
  **/
 static void
 lpfc_sli4_queue_destroy(struct lpfc_hba *phba)
@@ -6030,8 +6030,8 @@ lpfc_sli4_queue_destroy(struct lpfc_hba 
  *
  * Return codes
  *      0 - successful
- *      ENOMEM - No availble memory
- *      EIO - The mailbox failed to complete successfully.
+ *      -ENOMEM - No availble memory
+ *      -EIO - The mailbox failed to complete successfully.
  **/
 int
 lpfc_sli4_queue_setup(struct lpfc_hba *phba)
@@ -6275,8 +6275,8 @@ out_error:
  *
  * Return codes
  *      0 - successful
- *      ENOMEM - No availble memory
- *      EIO - The mailbox failed to complete successfully.
+ *      -ENOMEM - No availble memory
+ *      -EIO - The mailbox failed to complete successfully.
  **/
 void
 lpfc_sli4_queue_unset(struct lpfc_hba *phba)
@@ -6481,8 +6481,8 @@ lpfc_sli4_cq_event_release_all(struct lp
  *
  * Return codes
  *      0 - successful
- *      ENOMEM - No availble memory
- *      EIO - The mailbox failed to complete successfully.
+ *      -ENOMEM - No availble memory
+ *      -EIO - The mailbox failed to complete successfully.
  **/
 int
 lpfc_pci_function_reset(struct lpfc_hba *phba)
diff -upNr a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
--- a/drivers/scsi/lpfc/lpfc_sli.c	2010-09-08 12:08:03.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_sli.c	2010-09-29 10:07:23.000000000 -0400
@@ -1730,10 +1730,11 @@ lpfc_sli_wake_mbox_wait(struct lpfc_hba 
 void
 lpfc_sli_def_mbox_cmpl(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 {
+	struct lpfc_vport  *vport = pmb->vport;
 	struct lpfc_dmabuf *mp;
+	struct lpfc_nodelist *ndlp;
 	uint16_t rpi, vpi;
 	int rc;
-	struct lpfc_vport  *vport = pmb->vport;
 
 	mp = (struct lpfc_dmabuf *) (pmb->context1);
 
@@ -1774,6 +1775,12 @@ lpfc_sli_def_mbox_cmpl(struct lpfc_hba *
 			return;
 	}
 
+	if (pmb->u.mb.mbxCommand == MBX_REG_LOGIN64) {
+		ndlp = (struct lpfc_nodelist *)pmb->context2;
+		lpfc_nlp_put(ndlp);
+		pmb->context2 = NULL;
+	}
+
 	if (bf_get(lpfc_mqe_command, &pmb->u.mqe) == MBX_SLI4_CONFIG)
 		lpfc_sli4_mbox_cmd_free(phba, pmb);
 	else
@@ -4186,7 +4193,7 @@ lpfc_sli4_read_fcoe_params(struct lpfc_h
  *
  * Return codes
  * 	0 - successful
- * 	ENOMEM - could not allocated memory.
+ * 	-ENOMEM - could not allocated memory.
  **/
 static int
 lpfc_sli4_read_rev(struct lpfc_hba *phba, LPFC_MBOXQ_t *mboxq,
@@ -9724,8 +9731,8 @@ out_fail:
  * command to finish before continuing.
  *
  * On success this function will return a zero. If unable to allocate enough
- * memory this function will return ENOMEM. If the queue create mailbox command
- * fails this function will return ENXIO.
+ * memory this function will return -ENOMEM. If the queue create mailbox command
+ * fails this function will return -ENXIO.
  **/
 uint32_t
 lpfc_eq_create(struct lpfc_hba *phba, struct lpfc_queue *eq, uint16_t imax)
@@ -9840,8 +9847,8 @@ lpfc_eq_create(struct lpfc_hba *phba, st
  * command to finish before continuing.
  *
  * On success this function will return a zero. If unable to allocate enough
- * memory this function will return ENOMEM. If the queue create mailbox command
- * fails this function will return ENXIO.
+ * memory this function will return -ENOMEM. If the queue create mailbox command
+ * fails this function will return -ENXIO.
  **/
 uint32_t
 lpfc_cq_create(struct lpfc_hba *phba, struct lpfc_queue *cq,
@@ -10011,8 +10018,8 @@ lpfc_mq_create_fb_init(struct lpfc_hba *
  * command to finish before continuing.
  *
  * On success this function will return a zero. If unable to allocate enough
- * memory this function will return ENOMEM. If the queue create mailbox command
- * fails this function will return ENXIO.
+ * memory this function will return -ENOMEM. If the queue create mailbox command
+ * fails this function will return -ENXIO.
  **/
 int32_t
 lpfc_mq_create(struct lpfc_hba *phba, struct lpfc_queue *mq,
@@ -10146,8 +10153,8 @@ out:
  * command to finish before continuing.
  *
  * On success this function will return a zero. If unable to allocate enough
- * memory this function will return ENOMEM. If the queue create mailbox command
- * fails this function will return ENXIO.
+ * memory this function will return -ENOMEM. If the queue create mailbox command
+ * fails this function will return -ENXIO.
  **/
 uint32_t
 lpfc_wq_create(struct lpfc_hba *phba, struct lpfc_queue *wq,
@@ -10234,8 +10241,8 @@ out:
  * mailbox command to finish before continuing.
  *
  * On success this function will return a zero. If unable to allocate enough
- * memory this function will return ENOMEM. If the queue create mailbox command
- * fails this function will return ENXIO.
+ * memory this function will return -ENOMEM. If the queue create mailbox command
+ * fails this function will return -ENXIO.
  **/
 uint32_t
 lpfc_rq_create(struct lpfc_hba *phba, struct lpfc_queue *hrq,
@@ -10403,7 +10410,7 @@ out:
  * The @eq struct is used to get the queue ID of the queue to destroy.
  *
  * On success this function will return a zero. If the queue destroy mailbox
- * command fails this function will return ENXIO.
+ * command fails this function will return -ENXIO.
  **/
 uint32_t
 lpfc_eq_destroy(struct lpfc_hba *phba, struct lpfc_queue *eq)
@@ -10458,7 +10465,7 @@ lpfc_eq_destroy(struct lpfc_hba *phba, s
  * The @cq struct is used to get the queue ID of the queue to destroy.
  *
  * On success this function will return a zero. If the queue destroy mailbox
- * command fails this function will return ENXIO.
+ * command fails this function will return -ENXIO.
  **/
 uint32_t
 lpfc_cq_destroy(struct lpfc_hba *phba, struct lpfc_queue *cq)
@@ -10511,7 +10518,7 @@ lpfc_cq_destroy(struct lpfc_hba *phba, s
  * The @mq struct is used to get the queue ID of the queue to destroy.
  *
  * On success this function will return a zero. If the queue destroy mailbox
- * command fails this function will return ENXIO.
+ * command fails this function will return -ENXIO.
  **/
 uint32_t
 lpfc_mq_destroy(struct lpfc_hba *phba, struct lpfc_queue *mq)
@@ -10564,7 +10571,7 @@ lpfc_mq_destroy(struct lpfc_hba *phba, s
  * The @wq struct is used to get the queue ID of the queue to destroy.
  *
  * On success this function will return a zero. If the queue destroy mailbox
- * command fails this function will return ENXIO.
+ * command fails this function will return -ENXIO.
  **/
 uint32_t
 lpfc_wq_destroy(struct lpfc_hba *phba, struct lpfc_queue *wq)
@@ -10616,7 +10623,7 @@ lpfc_wq_destroy(struct lpfc_hba *phba, s
  * The @rq struct is used to get the queue ID of the queue to destroy.
  *
  * On success this function will return a zero. If the queue destroy mailbox
- * command fails this function will return ENXIO.
+ * command fails this function will return -ENXIO.
  **/
 uint32_t
 lpfc_rq_destroy(struct lpfc_hba *phba, struct lpfc_queue *hrq,
@@ -11819,7 +11826,7 @@ lpfc_sli4_handle_received_buffer(struct 
  *
  * Return codes
  * 	0 - successful
- *      EIO - The mailbox failed to complete successfully.
+ *      -EIO - The mailbox failed to complete successfully.
  * 	When this error occurs, the driver is not guaranteed
  *	to have any rpi regions posted to the device and
  *	must either attempt to repost the regions or take a
@@ -11857,8 +11864,8 @@ lpfc_sli4_post_all_rpi_hdrs(struct lpfc_
  *
  * Return codes
  * 	0 - successful
- * 	ENOMEM - No available memory
- *      EIO - The mailbox failed to complete successfully.
+ * 	-ENOMEM - No available memory
+ *      -EIO - The mailbox failed to complete successfully.
  **/
 int
 lpfc_sli4_post_rpi_hdr(struct lpfc_hba *phba, struct lpfc_rpi_hdr *rpi_page)
@@ -12805,8 +12812,11 @@ lpfc_cleanup_pending_mbox(struct lpfc_vp
 	LPFC_MBOXQ_t *mb, *nextmb;
 	struct lpfc_dmabuf *mp;
 	struct lpfc_nodelist *ndlp;
+	struct lpfc_nodelist *act_mbx_ndlp = NULL;
 	struct Scsi_Host  *shost = lpfc_shost_from_vport(vport);
+	LIST_HEAD(mbox_cmd_list);
 
+	/* Clean up internally queued mailbox commands with the vport */
 	spin_lock_irq(&phba->hbalock);
 	list_for_each_entry_safe(mb, nextmb, &phba->sli.mboxq, list) {
 		if (mb->vport != vport)
@@ -12816,6 +12826,28 @@ lpfc_cleanup_pending_mbox(struct lpfc_vp
 			(mb->u.mb.mbxCommand != MBX_REG_VPI))
 			continue;
 
+		list_del(&mb->list);
+		list_add_tail(&mb->list, &mbox_cmd_list);
+	}
+	/* Clean up active mailbox command with the vport */
+	mb = phba->sli.mbox_active;
+	if (mb && (mb->vport == vport)) {
+		if ((mb->u.mb.mbxCommand == MBX_REG_LOGIN64) ||
+			(mb->u.mb.mbxCommand == MBX_REG_VPI))
+			mb->mbox_cmpl = lpfc_sli_def_mbox_cmpl;
+		if (mb->u.mb.mbxCommand == MBX_REG_LOGIN64) {
+			act_mbx_ndlp = (struct lpfc_nodelist *)mb->context2;
+			/* Put reference count for delayed processing */
+			act_mbx_ndlp = lpfc_nlp_get(act_mbx_ndlp);
+			/* Unregister the RPI when mailbox complete */
+			mb->mbox_flag |= LPFC_MBX_IMED_UNREG;
+		}
+	}
+	spin_unlock_irq(&phba->hbalock);
+
+	/* Release the cleaned-up mailbox commands */
+	while (!list_empty(&mbox_cmd_list)) {
+		list_remove_head(&mbox_cmd_list, mb, LPFC_MBOXQ_t, list);
 		if (mb->u.mb.mbxCommand == MBX_REG_LOGIN64) {
 			if (phba->sli_rev == LPFC_SLI_REV4)
 				__lpfc_sli4_free_rpi(phba,
@@ -12826,36 +12858,24 @@ lpfc_cleanup_pending_mbox(struct lpfc_vp
 				kfree(mp);
 			}
 			ndlp = (struct lpfc_nodelist *) mb->context2;
+			mb->context2 = NULL;
 			if (ndlp) {
 				spin_lock(shost->host_lock);
 				ndlp->nlp_flag &= ~NLP_IGNR_REG_CMPL;
 				spin_unlock(shost->host_lock);
 				lpfc_nlp_put(ndlp);
-				mb->context2 = NULL;
 			}
 		}
-		list_del(&mb->list);
 		mempool_free(mb, phba->mbox_mem_pool);
 	}
-	mb = phba->sli.mbox_active;
-	if (mb && (mb->vport == vport)) {
-		if ((mb->u.mb.mbxCommand == MBX_REG_LOGIN64) ||
-			(mb->u.mb.mbxCommand == MBX_REG_VPI))
-			mb->mbox_cmpl = lpfc_sli_def_mbox_cmpl;
-		if (mb->u.mb.mbxCommand == MBX_REG_LOGIN64) {
-			ndlp = (struct lpfc_nodelist *) mb->context2;
-			if (ndlp) {
-				spin_lock(shost->host_lock);
-				ndlp->nlp_flag &= ~NLP_IGNR_REG_CMPL;
-				spin_unlock(shost->host_lock);
-				lpfc_nlp_put(ndlp);
-				mb->context2 = NULL;
-			}
-			/* Unregister the RPI when mailbox complete */
-			mb->mbox_flag |= LPFC_MBX_IMED_UNREG;
-		}
+
+	/* Release the ndlp with the cleaned-up active mailbox command */
+	if (act_mbx_ndlp) {
+		spin_lock(shost->host_lock);
+		act_mbx_ndlp->nlp_flag &= ~NLP_IGNR_REG_CMPL;
+		spin_unlock(shost->host_lock);
+		lpfc_nlp_put(act_mbx_ndlp);
 	}
-	spin_unlock_irq(&phba->hbalock);
 }
 
 /**
diff -upNr a/drivers/scsi/lpfc/lpfc_vport.c b/drivers/scsi/lpfc/lpfc_vport.c
--- a/drivers/scsi/lpfc/lpfc_vport.c	2010-08-04 10:31:45.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_vport.c	2010-09-29 10:07:23.000000000 -0400
@@ -580,7 +580,9 @@ lpfc_vport_delete(struct fc_vport *fc_vp
 				 "static vport.\n");
 		return VPORT_ERROR;
 	}
-
+	spin_lock_irq(&phba->hbalock);
+	vport->load_flag |= FC_UNLOADING;
+	spin_unlock_irq(&phba->hbalock);
 	/*
 	 * If we are not unloading the driver then prevent the vport_delete
 	 * from happening until after this vport's discovery is finished.
@@ -618,10 +620,6 @@ lpfc_vport_delete(struct fc_vport *fc_vp
 		scsi_host_put(shost);
 		return VPORT_INVAL;
 	}
-	spin_lock_irq(&phba->hbalock);
-	vport->load_flag |= FC_UNLOADING;
-	spin_unlock_irq(&phba->hbalock);
-
 	lpfc_free_sysfs_attr(vport);
 
 	lpfc_debugfs_terminate(vport);


