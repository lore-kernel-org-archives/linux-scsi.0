From: James Smart <james.smart@emulex.com>
Subject: [PATCH 1/13] lpfc 8.3.41: Fixed freeing of iocb when internal
 loopback times out
Date: Mon, 15 Jul 2013 18:31:42 -0400
Message-ID: <1373927502.15647.18.camel@myfc17>
Reply-To: <james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge2.ext.emulex.com ([138.239.224.100]:19202 "EHLO
	CMEXEDGE2.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758309Ab3GOWbp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Jul 2013 18:31:45 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Fixed freeing of iocb when internal loopback times out


Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_bsg.c  |    8 +++++---
 lpfc_scsi.c |    2 +-
 lpfc_sli.c  |   51 +++++++++++++++++++++++++++++++++++++++++++++------
 lpfc_sli.h  |    5 ++++-
 4 files changed, 55 insertions(+), 11 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_bsg.c b/drivers/scsi/lpfc/lpfc_bsg.c
--- a/drivers/scsi/lpfc/lpfc_bsg.c	2013-07-15 06:56:23.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_bsg.c	2013-07-15 07:15:01.938055472 -0400
@@ -2498,7 +2498,7 @@ static int lpfcdiag_loop_get_xri(struct
 	struct lpfc_sli_ct_request *ctreq = NULL;
 	int ret_val = 0;
 	int time_left;
-	int iocb_stat = 0;
+	int iocb_stat = IOCB_SUCCESS;
 	unsigned long flags;
 
 	*txxri = 0;
@@ -2574,6 +2574,7 @@ static int lpfcdiag_loop_get_xri(struct
 
 	cmdiocbq->iocb_flag |= LPFC_IO_LIBDFC;
 	cmdiocbq->vport = phba->pport;
+	cmdiocbq->iocb_cmpl = NULL;
 
 	iocb_stat = lpfc_sli_issue_iocb_wait(phba, LPFC_ELS_RING, cmdiocbq,
 				rspiocbq,
@@ -2963,7 +2964,7 @@ lpfc_bsg_diag_loopback_run(struct fc_bsg
 	uint8_t *ptr = NULL, *rx_databuf = NULL;
 	int rc = 0;
 	int time_left;
-	int iocb_stat;
+	int iocb_stat = IOCB_SUCCESS;
 	unsigned long flags;
 	void *dataout = NULL;
 	uint32_t total_mem;
@@ -3149,6 +3150,7 @@ lpfc_bsg_diag_loopback_run(struct fc_bsg
 	}
 	cmdiocbq->iocb_flag |= LPFC_IO_LIBDFC;
 	cmdiocbq->vport = phba->pport;
+	cmdiocbq->iocb_cmpl = NULL;
 	iocb_stat = lpfc_sli_issue_iocb_wait(phba, LPFC_ELS_RING, cmdiocbq,
 					     rspiocbq, (phba->fc_ratov * 2) +
 					     LPFC_DRVR_TIMEOUT);
@@ -3209,7 +3211,7 @@ err_loopback_test_exit:
 	lpfc_bsg_event_unref(evt); /* delete */
 	spin_unlock_irqrestore(&phba->ct_ev_lock, flags);
 
-	if (cmdiocbq != NULL)
+	if ((cmdiocbq != NULL) && (iocb_stat != IOCB_TIMEDOUT))
 		lpfc_sli_release_iocbq(phba, cmdiocbq);
 
 	if (rspiocbq != NULL)
diff -upNr a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
--- a/drivers/scsi/lpfc/lpfc_scsi.c	2013-07-15 06:56:23.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_scsi.c	2013-07-15 07:15:01.946055472 -0400
@@ -5022,6 +5022,7 @@ lpfc_send_taskmgmt(struct lpfc_vport *vp
 		lpfc_release_scsi_buf(phba, lpfc_cmd);
 		return FAILED;
 	}
+	iocbq->iocb_cmpl = lpfc_tskmgmt_def_cmpl;
 
 	lpfc_printf_vlog(vport, KERN_INFO, LOG_FCP,
 			 "0702 Issue %s to TGT %d LUN %d "
@@ -5034,7 +5035,6 @@ lpfc_send_taskmgmt(struct lpfc_vport *vp
 					  iocbq, iocbqrsp, lpfc_cmd->timeout);
 	if (status != IOCB_SUCCESS) {
 		if (status == IOCB_TIMEDOUT) {
-			iocbq->iocb_cmpl = lpfc_tskmgmt_def_cmpl;
 			ret = TIMEOUT_ERROR;
 		} else
 			ret = FAILED;
diff -upNr a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
--- a/drivers/scsi/lpfc/lpfc_sli.c	2013-07-15 06:56:23.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_sli.c	2013-07-15 07:15:01.997055473 -0400
@@ -9889,6 +9889,24 @@ lpfc_sli_wake_iocb_wait(struct lpfc_hba
 	struct lpfc_scsi_buf *lpfc_cmd;
 
 	spin_lock_irqsave(&phba->hbalock, iflags);
+	if (cmdiocbq->iocb_flag & LPFC_IO_WAKE_TMO) {
+
+		/*
+		 * A time out has occurred for the iocb.  If a time out
+		 * completion handler has been supplied, call it.  Otherwise,
+		 * just free the iocbq.
+		 */
+
+		spin_unlock_irqrestore(&phba->hbalock, iflags);
+		cmdiocbq->iocb_cmpl = cmdiocbq->wait_iocb_cmpl;
+		cmdiocbq->wait_iocb_cmpl = NULL;
+		if (cmdiocbq->iocb_cmpl)
+			(cmdiocbq->iocb_cmpl)(phba, cmdiocbq, NULL);
+		else
+			lpfc_sli_release_iocbq(phba, cmdiocbq);
+		return;
+	}
+
 	cmdiocbq->iocb_flag |= LPFC_IO_WAKE;
 	if (cmdiocbq->context2 && rspiocbq)
 		memcpy(&((struct lpfc_iocbq *)cmdiocbq->context2)->iocb,
@@ -9944,10 +9962,16 @@ lpfc_chk_iocb_flg(struct lpfc_hba *phba,
  * @timeout: Timeout in number of seconds.
  *
  * This function issues the iocb to firmware and waits for the
- * iocb to complete. If the iocb command is not
- * completed within timeout seconds, it returns IOCB_TIMEDOUT.
- * Caller should not free the iocb resources if this function
- * returns IOCB_TIMEDOUT.
+ * iocb to complete. The iocb_cmpl field of the shall be used
+ * to handle iocbs which time out. If the field is NULL, the
+ * function shall free the iocbq structure.  If more clean up is
+ * needed, the caller is expected to provide a completion function
+ * that will provide the needed clean up.  If the iocb command is
+ * not completed within timeout seconds, the function will either
+ * free the iocbq structure (if iocb_cmpl == NULL) or execute the
+ * completion function set in the iocb_cmpl field and then return
+ * a status of IOCB_TIMEDOUT.  The caller should not free the iocb
+ * resources if this function returns IOCB_TIMEDOUT.
  * The function waits for the iocb completion using an
  * non-interruptible wait.
  * This function will sleep while waiting for iocb completion.
@@ -9980,6 +10004,9 @@ lpfc_sli_issue_iocb_wait(struct lpfc_hba
 	int txq_cnt = 0;
 	int txcmplq_cnt = 0;
 	struct lpfc_sli_ring *pring = &phba->sli.ring[LPFC_ELS_RING];
+	unsigned long iflags;
+	bool iocb_completed = true;
+
 	/*
 	 * If the caller has provided a response iocbq buffer, then context2
 	 * is NULL or its an error.
@@ -9990,9 +10017,10 @@ lpfc_sli_issue_iocb_wait(struct lpfc_hba
 		piocb->context2 = prspiocbq;
 	}
 
+	piocb->wait_iocb_cmpl = piocb->iocb_cmpl;
 	piocb->iocb_cmpl = lpfc_sli_wake_iocb_wait;
 	piocb->context_un.wait_queue = &done_q;
-	piocb->iocb_flag &= ~LPFC_IO_WAKE;
+	piocb->iocb_flag &= ~(LPFC_IO_WAKE | LPFC_IO_WAKE_TMO);
 
 	if (phba->cfg_poll & DISABLE_FCP_RING_INT) {
 		if (lpfc_readl(phba->HCregaddr, &creg_val))
@@ -10009,8 +10037,19 @@ lpfc_sli_issue_iocb_wait(struct lpfc_hba
 		timeleft = wait_event_timeout(done_q,
 				lpfc_chk_iocb_flg(phba, piocb, LPFC_IO_WAKE),
 				timeout_req);
+		spin_lock_irqsave(&phba->hbalock, iflags);
+		if (!(piocb->iocb_flag & LPFC_IO_WAKE)) {
 
-		if (piocb->iocb_flag & LPFC_IO_WAKE) {
+			/*
+			 * IOCB timed out.  Inform the wake iocb wait
+			 * completion function and set local status
+			 */
+
+			iocb_completed = false;
+			piocb->iocb_flag |= LPFC_IO_WAKE_TMO;
+		}
+		spin_unlock_irqrestore(&phba->hbalock, iflags);
+		if (iocb_completed) {
 			lpfc_printf_log(phba, KERN_INFO, LOG_SLI,
 					"0331 IOCB wake signaled\n");
 		} else if (timeleft == 0) {
diff -upNr a/drivers/scsi/lpfc/lpfc_sli.h b/drivers/scsi/lpfc/lpfc_sli.h
--- a/drivers/scsi/lpfc/lpfc_sli.h	2013-04-10 16:46:40.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_sli.h	2013-07-15 07:15:01.998055473 -0400
@@ -60,7 +60,8 @@ struct lpfc_iocbq {
 	uint8_t retry;		/* retry counter for IOCB cmd - if needed */
 	uint16_t iocb_flag;
 #define LPFC_IO_LIBDFC		1	/* libdfc iocb */
-#define LPFC_IO_WAKE		2	/* High Priority Queue signal flag */
+#define LPFC_IO_WAKE		2	/* Synchronous I/O completed */
+#define LPFC_IO_WAKE_TMO	LPFC_IO_WAKE /* Synchronous I/O timed out */
 #define LPFC_IO_FCP		4	/* FCP command -- iocbq in scsi_buf */
 #define LPFC_DRIVER_ABORTED	8	/* driver aborted this request */
 #define LPFC_IO_FABRIC		0x10	/* Iocb send using fabric scheduler */
@@ -93,6 +94,8 @@ struct lpfc_iocbq {
 
 	void (*fabric_iocb_cmpl) (struct lpfc_hba *, struct lpfc_iocbq *,
 			   struct lpfc_iocbq *);
+	void (*wait_iocb_cmpl) (struct lpfc_hba *, struct lpfc_iocbq *,
+			   struct lpfc_iocbq *);
 	void (*iocb_cmpl) (struct lpfc_hba *, struct lpfc_iocbq *,
 			   struct lpfc_iocbq *);
 };







