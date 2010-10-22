From: James Smart <james.smart@emulex.com>
Subject: [PATCH 4/7] lpfc 8.3.18: Adapter Shutdown and Unregistration
 cleanup
Date: Fri, 22 Oct 2010 11:06:38 -0400
Message-ID: <1287760011.11844.22.camel@wookie>
Reply-To: james.smart@emulex.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exht1.emulex.com ([138.239.113.183]:56066 "EHLO
	exht1.ad.emulex.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756270Ab0JVPHP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 22 Oct 2010 11:07:15 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Adapter Shutdown and Unregistration cleanup

- Correct the logic around hba shutdown. Prior to final reset, the
  driver must wait for all XRIs to return from the adapter. Added logic
  to poll, progressively slowing the poll rate as delay gets longer.
- Correct behavior around the rsvd1 field in UNREG_RPI_ALL mailbox
  completion and final rpi cleanup.
- Updated logic to move pending VPI registrations to their completion
  in cases where a CVL may be received while registration in progress.
- Added unreg all rpi mailbox command before unreg vpi.


 Signed-off-by: Alex Iannicelli <alex.iannicelli@emulex.com>
 Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_crtn.h    |    3 +
 lpfc_els.c     |   10 +++
 lpfc_hbadisc.c |    9 +++
 lpfc_init.c    |   52 ++++++++++++++++++
 lpfc_mbox.c    |   28 ++++++++++
 lpfc_sli.c     |  158 ++++++++++++++++++++++++++++++++++++++++++++++-----------
 lpfc_sli4.h    |    3 +
 7 files changed, 235 insertions(+), 28 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_crtn.h b/drivers/scsi/lpfc/lpfc_crtn.h
--- a/drivers/scsi/lpfc/lpfc_crtn.h	2010-10-21 22:38:39.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_crtn.h	2010-10-21 22:39:01.000000000 -0400
@@ -44,6 +44,8 @@ int lpfc_reg_rpi(struct lpfc_hba *, uint
 void lpfc_set_var(struct lpfc_hba *, LPFC_MBOXQ_t *, uint32_t, uint32_t);
 void lpfc_unreg_login(struct lpfc_hba *, uint16_t, uint32_t, LPFC_MBOXQ_t *);
 void lpfc_unreg_did(struct lpfc_hba *, uint16_t, uint32_t, LPFC_MBOXQ_t *);
+void lpfc_sli4_unreg_all_rpis(struct lpfc_vport *);
+
 void lpfc_reg_vpi(struct lpfc_vport *, LPFC_MBOXQ_t *);
 void lpfc_register_new_vport(struct lpfc_hba *, struct lpfc_vport *,
 			struct lpfc_nodelist *);
@@ -272,6 +274,7 @@ int lpfc_sli_issue_iocb(struct lpfc_hba 
 void lpfc_sli_pcimem_bcopy(void *, void *, uint32_t);
 void lpfc_sli_bemem_bcopy(void *, void *, uint32_t);
 void lpfc_sli_abort_iocb_ring(struct lpfc_hba *, struct lpfc_sli_ring *);
+void lpfc_sli_hba_iocb_abort(struct lpfc_hba *);
 void lpfc_sli_flush_fcp_rings(struct lpfc_hba *);
 int lpfc_sli_ringpostbuf_put(struct lpfc_hba *, struct lpfc_sli_ring *,
 			     struct lpfc_dmabuf *);
diff -upNr a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
--- a/drivers/scsi/lpfc/lpfc_els.c	2010-10-21 22:38:39.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_els.c	2010-10-21 22:39:01.000000000 -0400
@@ -580,6 +580,10 @@ lpfc_cmpl_els_flogi_fabric(struct lpfc_v
 			lpfc_unreg_rpi(vport, np);
 		}
 		lpfc_cleanup_pending_mbox(vport);
+
+		if (phba->sli_rev == LPFC_SLI_REV4)
+			lpfc_sli4_unreg_all_rpis(vport);
+
 		if (phba->sli3_options & LPFC_SLI3_NPIV_ENABLED) {
 			lpfc_mbx_unreg_vpi(vport);
 			spin_lock_irq(shost->host_lock);
@@ -6482,6 +6486,8 @@ lpfc_cmpl_reg_new_vport(struct lpfc_hba 
 
 		default:
 			/* Try to recover from this error */
+			if (phba->sli_rev == LPFC_SLI_REV4)
+				lpfc_sli4_unreg_all_rpis(vport);
 			lpfc_mbx_unreg_vpi(vport);
 			spin_lock_irq(shost->host_lock);
 			vport->fc_flag |= FC_VPORT_NEEDS_REG_VPI;
@@ -6749,6 +6755,10 @@ lpfc_cmpl_els_fdisc(struct lpfc_hba *phb
 			lpfc_unreg_rpi(vport, np);
 		}
 		lpfc_cleanup_pending_mbox(vport);
+
+		if (phba->sli_rev == LPFC_SLI_REV4)
+			lpfc_sli4_unreg_all_rpis(vport);
+
 		lpfc_mbx_unreg_vpi(vport);
 		spin_lock_irq(shost->host_lock);
 		vport->fc_flag |= FC_VPORT_NEEDS_REG_VPI;
diff -upNr a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c	2010-10-21 22:38:39.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c	2010-10-21 22:39:01.000000000 -0400
@@ -793,6 +793,8 @@ lpfc_cleanup_rpis(struct lpfc_vport *vpo
 					     : NLP_EVT_DEVICE_RECOVERY);
 	}
 	if (phba->sli3_options & LPFC_SLI3_VPORT_TEARDOWN) {
+		if (phba->sli_rev == LPFC_SLI_REV4)
+			lpfc_sli4_unreg_all_rpis(vport);
 		lpfc_mbx_unreg_vpi(vport);
 		spin_lock_irq(shost->host_lock);
 		vport->fc_flag |= FC_VPORT_NEEDS_REG_VPI;
@@ -4079,6 +4081,11 @@ lpfc_unreg_all_rpis(struct lpfc_vport *v
 	LPFC_MBOXQ_t     *mbox;
 	int rc;
 
+	if (phba->sli_rev == LPFC_SLI_REV4) {
+		lpfc_sli4_unreg_all_rpis(vport);
+		return;
+	}
+
 	mbox = mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
 	if (mbox) {
 		lpfc_unreg_login(phba, vport->vpi, 0xffff, mbox);
@@ -5353,6 +5360,8 @@ lpfc_unregister_fcf_prep(struct lpfc_hba
 			if (ndlp)
 				lpfc_cancel_retry_delay_tmo(vports[i], ndlp);
 			lpfc_cleanup_pending_mbox(vports[i]);
+			if (phba->sli_rev == LPFC_SLI_REV4)
+				lpfc_sli4_unreg_all_rpis(vports[i]);
 			lpfc_mbx_unreg_vpi(vports[i]);
 			shost = lpfc_shost_from_vport(vports[i]);
 			spin_lock_irq(shost->host_lock);
diff -upNr a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
--- a/drivers/scsi/lpfc/lpfc_init.c	2010-10-21 22:38:39.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_init.c	2010-10-21 22:39:01.000000000 -0400
@@ -813,6 +813,7 @@ lpfc_hba_down_post_s3(struct lpfc_hba *p
 
 	return 0;
 }
+
 /**
  * lpfc_hba_down_post_s4 - Perform lpfc uninitialization after HBA reset
  * @phba: pointer to lpfc HBA data structure.
@@ -7267,6 +7268,51 @@ lpfc_sli4_unset_hba(struct lpfc_hba *phb
 }
 
 /**
+ * lpfc_sli4_xri_exchange_busy_wait - Wait for device XRI exchange busy
+ * @phba: Pointer to HBA context object.
+ *
+ * This function is called in the SLI4 code path to wait for completion
+ * of device's XRIs exchange busy. It will check the XRI exchange busy
+ * on outstanding FCP and ELS I/Os every 10ms for up to 10 seconds; after
+ * that, it will check the XRI exchange busy on outstanding FCP and ELS
+ * I/Os every 30 seconds, log error message, and wait forever. Only when
+ * all XRI exchange busy complete, the driver unload shall proceed with
+ * invoking the function reset ioctl mailbox command to the CNA and the
+ * the rest of the driver unload resource release.
+ **/
+static void
+lpfc_sli4_xri_exchange_busy_wait(struct lpfc_hba *phba)
+{
+	int wait_time = 0;
+	int fcp_xri_cmpl = list_empty(&phba->sli4_hba.lpfc_abts_scsi_buf_list);
+	int els_xri_cmpl = list_empty(&phba->sli4_hba.lpfc_abts_els_sgl_list);
+
+	while (!fcp_xri_cmpl || !els_xri_cmpl) {
+		if (wait_time > LPFC_XRI_EXCH_BUSY_WAIT_TMO) {
+			if (!fcp_xri_cmpl)
+				lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+						"2877 FCP XRI exchange busy "
+						"wait time: %d seconds.\n",
+						wait_time/1000);
+			if (!els_xri_cmpl)
+				lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+						"2878 ELS XRI exchange busy "
+						"wait time: %d seconds.\n",
+						wait_time/1000);
+			msleep(LPFC_XRI_EXCH_BUSY_WAIT_T2);
+			wait_time += LPFC_XRI_EXCH_BUSY_WAIT_T2;
+		} else {
+			msleep(LPFC_XRI_EXCH_BUSY_WAIT_T1);
+			wait_time += LPFC_XRI_EXCH_BUSY_WAIT_T1;
+		}
+		fcp_xri_cmpl =
+			list_empty(&phba->sli4_hba.lpfc_abts_scsi_buf_list);
+		els_xri_cmpl =
+			list_empty(&phba->sli4_hba.lpfc_abts_els_sgl_list);
+	}
+}
+
+/**
  * lpfc_sli4_hba_unset - Unset the fcoe hba
  * @phba: Pointer to HBA context object.
  *
@@ -7311,6 +7357,12 @@ lpfc_sli4_hba_unset(struct lpfc_hba *phb
 		spin_unlock_irq(&phba->hbalock);
 	}
 
+	/* Abort all iocbs associated with the hba */
+	lpfc_sli_hba_iocb_abort(phba);
+
+	/* Wait for completion of device XRI exchange busy */
+	lpfc_sli4_xri_exchange_busy_wait(phba);
+
 	/* Disable PCI subsystem interrupt */
 	lpfc_sli4_disable_intr(phba);
 
diff -upNr a/drivers/scsi/lpfc/lpfc_mbox.c b/drivers/scsi/lpfc/lpfc_mbox.c
--- a/drivers/scsi/lpfc/lpfc_mbox.c	2010-08-09 09:30:14.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_mbox.c	2010-10-21 22:39:01.000000000 -0400
@@ -797,6 +797,34 @@ lpfc_unreg_login(struct lpfc_hba *phba, 
 }
 
 /**
+ * lpfc_sli4_unreg_all_rpis - unregister all RPIs for a vport on SLI4 HBA.
+ * @vport: pointer to a vport object.
+ *
+ * This routine sends mailbox command to unregister all active RPIs for
+ * a vport.
+ **/
+void
+lpfc_sli4_unreg_all_rpis(struct lpfc_vport *vport)
+{
+	struct lpfc_hba  *phba  = vport->phba;
+	LPFC_MBOXQ_t     *mbox;
+	int rc;
+
+	mbox = mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
+	if (mbox) {
+		lpfc_unreg_login(phba, vport->vpi,
+			vport->vpi + phba->vpi_base, mbox);
+		mbox->u.mb.un.varUnregLogin.rsvd1 = 0x4000 ;
+		mbox->vport = vport;
+		mbox->mbox_cmpl = lpfc_sli_def_mbox_cmpl;
+		mbox->context1 = NULL;
+		rc = lpfc_sli_issue_mbox(phba, mbox, MBX_NOWAIT);
+		if (rc == MBX_NOT_FINISHED)
+			mempool_free(mbox, phba->mbox_mem_pool);
+	}
+}
+
+/**
  * lpfc_reg_vpi - Prepare a mailbox command for registering vport identifier
  * @phba: pointer to lpfc hba data structure.
  * @vpi: virtual N_Port identifier.
diff -upNr a/drivers/scsi/lpfc/lpfc_sli4.h b/drivers/scsi/lpfc/lpfc_sli4.h
--- a/drivers/scsi/lpfc/lpfc_sli4.h	2010-10-21 22:38:39.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_sli4.h	2010-10-21 22:39:01.000000000 -0400
@@ -19,6 +19,9 @@
  *******************************************************************/
 
 #define LPFC_ACTIVE_MBOX_WAIT_CNT               100
+#define LPFC_XRI_EXCH_BUSY_WAIT_TMO		10000
+#define LPFC_XRI_EXCH_BUSY_WAIT_T1   		10
+#define LPFC_XRI_EXCH_BUSY_WAIT_T2              30000
 #define LPFC_RELEASE_NOTIFICATION_INTERVAL	32
 #define LPFC_GET_QE_REL_INT			32
 #define LPFC_RPI_LOW_WATER_MARK			10
diff -upNr a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
--- a/drivers/scsi/lpfc/lpfc_sli.c	2010-10-21 22:38:39.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_sli.c	2010-10-21 22:39:01.000000000 -0400
@@ -1735,6 +1735,7 @@ lpfc_sli_def_mbox_cmpl(struct lpfc_hba *
 	struct lpfc_vport  *vport = pmb->vport;
 	struct lpfc_dmabuf *mp;
 	struct lpfc_nodelist *ndlp;
+	struct Scsi_Host *shost;
 	uint16_t rpi, vpi;
 	int rc;
 
@@ -1746,7 +1747,8 @@ lpfc_sli_def_mbox_cmpl(struct lpfc_hba *
 	}
 
 	if ((pmb->u.mb.mbxCommand == MBX_UNREG_LOGIN) &&
-	    (phba->sli_rev == LPFC_SLI_REV4))
+	    (phba->sli_rev == LPFC_SLI_REV4) &&
+	    (pmb->u.mb.un.varUnregLogin.rsvd1 == 0x0))
 		lpfc_sli4_free_rpi(phba, pmb->u.mb.un.varUnregLogin.rpi);
 
 	/*
@@ -1765,16 +1767,14 @@ lpfc_sli_def_mbox_cmpl(struct lpfc_hba *
 			return;
 	}
 
-	/* Unreg VPI, if the REG_VPI succeed after VLink failure */
 	if ((pmb->u.mb.mbxCommand == MBX_REG_VPI) &&
 		!(phba->pport->load_flag & FC_UNLOADING) &&
 		!pmb->u.mb.mbxStatus) {
-		lpfc_unreg_vpi(phba, pmb->u.mb.un.varRegVpi.vpi, pmb);
-		pmb->vport = vport;
-		pmb->mbox_cmpl = lpfc_sli_def_mbox_cmpl;
-		rc = lpfc_sli_issue_mbox(phba, pmb, MBX_NOWAIT);
-		if (rc != MBX_NOT_FINISHED)
-			return;
+		shost = lpfc_shost_from_vport(vport);
+		spin_lock_irq(shost->host_lock);
+		vport->vpi_state |= LPFC_VPI_REGISTERED;
+		vport->fc_flag &= ~FC_VPORT_NEEDS_REG_VPI;
+		spin_unlock_irq(shost->host_lock);
 	}
 
 	if (pmb->u.mb.mbxCommand == MBX_REG_LOGIN64) {
@@ -7257,25 +7257,26 @@ lpfc_ignore_els_cmpl(struct lpfc_hba *ph
 }
 
 /**
- * lpfc_sli_issue_abort_iotag - Abort function for a command iocb
+ * lpfc_sli_abort_iotag_issue - Issue abort for a command iocb
  * @phba: Pointer to HBA context object.
  * @pring: Pointer to driver SLI ring object.
  * @cmdiocb: Pointer to driver command iocb object.
  *
- * This function issues an abort iocb for the provided command
- * iocb. This function is called with hbalock held.
- * The function returns 0 when it fails due to memory allocation
- * failure or when the command iocb is an abort request.
+ * This function issues an abort iocb for the provided command iocb down to
+ * the port. Other than the case the outstanding command iocb is an abort
+ * request, this function issues abort out unconditionally. This function is
+ * called with hbalock held. The function returns 0 when it fails due to
+ * memory allocation failure or when the command iocb is an abort request.
  **/
-int
-lpfc_sli_issue_abort_iotag(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
+static int
+lpfc_sli_abort_iotag_issue(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 			   struct lpfc_iocbq *cmdiocb)
 {
 	struct lpfc_vport *vport = cmdiocb->vport;
 	struct lpfc_iocbq *abtsiocbp;
 	IOCB_t *icmd = NULL;
 	IOCB_t *iabt = NULL;
-	int retval = IOCB_ERROR;
+	int retval;
 
 	/*
 	 * There are certain command types we don't want to abort.  And we
@@ -7288,18 +7289,6 @@ lpfc_sli_issue_abort_iotag(struct lpfc_h
 	    (cmdiocb->iocb_flag & LPFC_DRIVER_ABORTED) != 0)
 		return 0;
 
-	/* If we're unloading, don't abort iocb on the ELS ring, but change the
-	 * callback so that nothing happens when it finishes.
-	 */
-	if ((vport->load_flag & FC_UNLOADING) &&
-	    (pring->ringno == LPFC_ELS_RING)) {
-		if (cmdiocb->iocb_flag & LPFC_IO_FABRIC)
-			cmdiocb->fabric_iocb_cmpl = lpfc_ignore_els_cmpl;
-		else
-			cmdiocb->iocb_cmpl = lpfc_ignore_els_cmpl;
-		goto abort_iotag_exit;
-	}
-
 	/* issue ABTS for this IOCB based on iotag */
 	abtsiocbp = __lpfc_sli_get_iocbq(phba);
 	if (abtsiocbp == NULL)
@@ -7344,6 +7333,63 @@ lpfc_sli_issue_abort_iotag(struct lpfc_h
 
 	if (retval)
 		__lpfc_sli_release_iocbq(phba, abtsiocbp);
+
+	/*
+	 * Caller to this routine should check for IOCB_ERROR
+	 * and handle it properly.  This routine no longer removes
+	 * iocb off txcmplq and call compl in case of IOCB_ERROR.
+	 */
+	return retval;
+}
+
+/**
+ * lpfc_sli_issue_abort_iotag - Abort function for a command iocb
+ * @phba: Pointer to HBA context object.
+ * @pring: Pointer to driver SLI ring object.
+ * @cmdiocb: Pointer to driver command iocb object.
+ *
+ * This function issues an abort iocb for the provided command iocb. In case
+ * of unloading, the abort iocb will not be issued to commands on the ELS
+ * ring. Instead, the callback function shall be changed to those commands
+ * so that nothing happens when them finishes. This function is called with
+ * hbalock held. The function returns 0 when the command iocb is an abort
+ * request.
+ **/
+int
+lpfc_sli_issue_abort_iotag(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
+			   struct lpfc_iocbq *cmdiocb)
+{
+	struct lpfc_vport *vport = cmdiocb->vport;
+	int retval = IOCB_ERROR;
+	IOCB_t *icmd = NULL;
+
+	/*
+	 * There are certain command types we don't want to abort.  And we
+	 * don't want to abort commands that are already in the process of
+	 * being aborted.
+	 */
+	icmd = &cmdiocb->iocb;
+	if (icmd->ulpCommand == CMD_ABORT_XRI_CN ||
+	    icmd->ulpCommand == CMD_CLOSE_XRI_CN ||
+	    (cmdiocb->iocb_flag & LPFC_DRIVER_ABORTED) != 0)
+		return 0;
+
+	/*
+	 * If we're unloading, don't abort iocb on the ELS ring, but change
+	 * the callback so that nothing happens when it finishes.
+	 */
+	if ((vport->load_flag & FC_UNLOADING) &&
+	    (pring->ringno == LPFC_ELS_RING)) {
+		if (cmdiocb->iocb_flag & LPFC_IO_FABRIC)
+			cmdiocb->fabric_iocb_cmpl = lpfc_ignore_els_cmpl;
+		else
+			cmdiocb->iocb_cmpl = lpfc_ignore_els_cmpl;
+		goto abort_iotag_exit;
+	}
+
+	/* Now, we try to issue the abort to the cmdiocb out */
+	retval = lpfc_sli_abort_iotag_issue(phba, pring, cmdiocb);
+
 abort_iotag_exit:
 	/*
 	 * Caller to this routine should check for IOCB_ERROR
@@ -7354,6 +7400,62 @@ abort_iotag_exit:
 }
 
 /**
+ * lpfc_sli_iocb_ring_abort - Unconditionally abort all iocbs on an iocb ring
+ * @phba: Pointer to HBA context object.
+ * @pring: Pointer to driver SLI ring object.
+ *
+ * This function aborts all iocbs in the given ring and frees all the iocb
+ * objects in txq. This function issues abort iocbs unconditionally for all
+ * the iocb commands in txcmplq. The iocbs in the txcmplq is not guaranteed
+ * to complete before the return of this function. The caller is not required
+ * to hold any locks.
+ **/
+static void
+lpfc_sli_iocb_ring_abort(struct lpfc_hba *phba, struct lpfc_sli_ring *pring)
+{
+	LIST_HEAD(completions);
+	struct lpfc_iocbq *iocb, *next_iocb;
+
+	if (pring->ringno == LPFC_ELS_RING)
+		lpfc_fabric_abort_hba(phba);
+
+	spin_lock_irq(&phba->hbalock);
+
+	/* Take off all the iocbs on txq for cancelling */
+	list_splice_init(&pring->txq, &completions);
+	pring->txq_cnt = 0;
+
+	/* Next issue ABTS for everything on the txcmplq */
+	list_for_each_entry_safe(iocb, next_iocb, &pring->txcmplq, list)
+		lpfc_sli_abort_iotag_issue(phba, pring, iocb);
+
+	spin_unlock_irq(&phba->hbalock);
+
+	/* Cancel all the IOCBs from the completions list */
+	lpfc_sli_cancel_iocbs(phba, &completions, IOSTAT_LOCAL_REJECT,
+			      IOERR_SLI_ABORTED);
+}
+
+/**
+ * lpfc_sli_hba_iocb_abort - Abort all iocbs to an hba.
+ * @phba: pointer to lpfc HBA data structure.
+ *
+ * This routine will abort all pending and outstanding iocbs to an HBA.
+ **/
+void
+lpfc_sli_hba_iocb_abort(struct lpfc_hba *phba)
+{
+	struct lpfc_sli *psli = &phba->sli;
+	struct lpfc_sli_ring *pring;
+	int i;
+
+	for (i = 0; i < psli->num_rings; i++) {
+		pring = &psli->ring[i];
+		lpfc_sli_iocb_ring_abort(phba, pring);
+	}
+}
+
+/**
  * lpfc_sli_validate_fcp_iocb - find commands associated with a vport or LUN
  * @iocbq: Pointer to driver iocb object.
  * @vport: Pointer to driver virtual port object.


