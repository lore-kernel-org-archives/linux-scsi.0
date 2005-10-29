From: James.Smart@Emulex.Com
Subject: [PATCH 10/15]  lpfc 8.1.0 : Replace lpfc_sli_issue_iocb_wait_high_priority
Date: Fri, 28 Oct 2005 20:29:47 -0400
Message-ID: <9BB4DECD4CFE6D43AA8EA8D768ED51C2276A59@xbl3.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:6097 "EHLO emulex.emulex.com")
	by vger.kernel.org with ESMTP id S1750931AbVJ2A3t convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 28 Oct 2005 20:29:49 -0400
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.12.10/8.12.10) with ESMTP id j9T0TmDp018540
	for <linux-scsi@vger.kernel.org>; Fri, 28 Oct 2005 17:29:48 -0700 (PDT)
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Replace lpfc_sli_issue_iocb_wait_high_priority with lpfc_sli_issue_iocb_wait.

Fix: Simplify code paths, as there really wasn't a "priority"


Signed-off-by: James Smart <James.Smart@emulex.com>

--- a/drivers/scsi/lpfc/lpfc_sli.h
+++ b/drivers/scsi/lpfc/lpfc_sli.h
@@ -39,10 +39,8 @@ struct lpfc_iocbq {
 	IOCB_t iocb;		/* IOCB cmd */
 	uint8_t retry;		/* retry counter for IOCB cmd - if needed */
 	uint8_t iocb_flag;
-#define LPFC_IO_POLL	1	/* Polling mode iocb */
-#define LPFC_IO_LIBDFC	2	/* libdfc iocb */
-#define LPFC_IO_WAIT	4
-#define LPFC_IO_HIPRI	8	/* High Priority Queue signal flag */
+#define LPFC_IO_LIBDFC	1	/* libdfc iocb */
+#define LPFC_IO_WAKE	2	/* High Priority Queue signal flag */
 
 	uint8_t abort_count;
 	uint8_t rsvd2;
@@ -51,8 +49,7 @@ struct lpfc_iocbq {
 	void *context2;		/* caller context information */
 	void *context3;		/* caller context information */
 	union {
-		wait_queue_head_t *hipri_wait_queue; /* High Priority Queue wait
-							queue */
+		wait_queue_head_t  *wait_queue;
 		struct lpfc_iocbq  *rsp_iocb;
 		struct lpfcMboxq   *mbox;
 	} context_un;
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -637,12 +637,9 @@ lpfc_scsi_tgt_reset(struct lpfc_scsi_buf
 	if (!iocbqrsp)
 		return FAILED;
 
-	iocbq->iocb_flag |= LPFC_IO_POLL;
-	ret = lpfc_sli_issue_iocb_wait_high_priority(phba,
-		     &phba->sli.ring[phba->sli.fcp_ring],
-		     iocbq, SLI_IOCB_HIGH_PRIORITY,
-		     iocbqrsp,
-		     lpfc_cmd->timeout);
+	ret = lpfc_sli_issue_iocb_wait(phba,
+				       &phba->sli.ring[phba->sli.fcp_ring],
+				       iocbq, iocbqrsp, lpfc_cmd->timeout);
 	if (ret != IOCB_SUCCESS) {
 		lpfc_cmd->status = IOSTAT_DRIVER_REJECT;
 		ret = FAILED;
@@ -922,7 +919,6 @@ __lpfc_reset_lun_handler(struct scsi_cmn
 {
 	struct Scsi_Host *shost = cmnd->device->host;
 	struct lpfc_hba *phba = (struct lpfc_hba *)shost->hostdata[0];
-	struct lpfc_sli *psli = &phba->sli;
 	struct lpfc_scsi_buf *lpfc_cmd = NULL;
 	struct list_head *scsi_buf_list = &phba->lpfc_scsi_buf_list;
 	struct list_head *lpfc_iocb_list = &phba->lpfc_iocb_list;
@@ -969,12 +965,9 @@ __lpfc_reset_lun_handler(struct scsi_cmn
 	if (iocbqrsp == NULL)
 		goto out_free_scsi_buf;
 
-	iocbq->iocb_flag |= LPFC_IO_POLL;
-	iocbq->iocb_cmpl = lpfc_sli_wake_iocb_high_priority;
-
-	ret = lpfc_sli_issue_iocb_wait_high_priority(phba,
-		     &phba->sli.ring[psli->fcp_ring],
-		     iocbq, 0, iocbqrsp, 60);
+	ret = lpfc_sli_issue_iocb_wait(phba,
+				       &phba->sli.ring[phba->sli.fcp_ring],
+				       iocbq, iocbqrsp, lpfc_cmd->timeout);
 	if (ret == IOCB_SUCCESS)
 		ret = SUCCESS;
 
--- a/drivers/scsi/lpfc/lpfc_crtn.h
+++ b/drivers/scsi/lpfc/lpfc_crtn.h
@@ -180,15 +180,11 @@ struct lpfc_nodelist *lpfc_findnode_did(
 int lpfc_sli_issue_mbox_wait(struct lpfc_hba * phba, LPFC_MBOXQ_t * pmboxq,
 			 uint32_t timeout);
 
-int lpfc_sli_issue_iocb_wait_high_priority(struct lpfc_hba * phba,
-					   struct lpfc_sli_ring * pring,
-					   struct lpfc_iocbq * piocb,
-					   uint32_t flag,
-					   struct lpfc_iocbq * prspiocbq,
-					   uint32_t timeout);
-void lpfc_sli_wake_iocb_high_priority(struct lpfc_hba * phba,
-				      struct lpfc_iocbq * queue1,
-				      struct lpfc_iocbq * queue2);
+int lpfc_sli_issue_iocb_wait(struct lpfc_hba * phba,
+			     struct lpfc_sli_ring * pring,
+			     struct lpfc_iocbq * piocb,
+			     struct lpfc_iocbq * prspiocbq,
+			     uint32_t timeout);
 void lpfc_sli_abort_fcp_cmpl(struct lpfc_hba * phba,
 			     struct lpfc_iocbq * cmdiocb,
 			     struct lpfc_iocbq * rspiocb);
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -839,9 +839,6 @@ lpfc_sli_process_sol_iocb(struct lpfc_hb
 				spin_lock_irqsave(phba->host->host_lock, iflag);
 			}
 			else {
-				if (cmdiocbp->iocb_flag & LPFC_IO_POLL)
-					rc = 0;
-
 				spin_unlock_irqrestore(phba->host->host_lock,
 						       iflag);
 				(cmdiocbp->iocb_cmpl) (phba, cmdiocbp, saveq);
@@ -874,6 +871,7 @@ lpfc_sli_process_sol_iocb(struct lpfc_hb
 				saveq->iocb.ulpContext);
 		}
 	}
+
 	spin_unlock_irqrestore(phba->host->host_lock, iflag);
 	return rc;
 }
@@ -2592,84 +2590,99 @@ lpfc_sli_abort_iocb(struct lpfc_hba *phb
 	return errcnt;
 }
 
-void
-lpfc_sli_wake_iocb_high_priority(struct lpfc_hba * phba,
-				 struct lpfc_iocbq * queue1,
-				 struct lpfc_iocbq * queue2)
-{
-	struct lpfc_iocbq *save_iocbq = queue1->context2;
-	if (save_iocbq && queue2)
-		memcpy(&save_iocbq->iocb, &queue2->iocb, sizeof(queue2->iocb));
-
-	/* The waiter is looking for LPFC_IO_HIPRI bit to be set
-	   as a signal to wake up */
-	queue1->iocb_flag |= LPFC_IO_HIPRI;
+static void
+lpfc_sli_wake_iocb_wait(struct lpfc_hba *phba,
+			struct lpfc_iocbq *cmdiocbq,
+			struct lpfc_iocbq *rspiocbq)
+{
+	wait_queue_head_t *pdone_q;
+	unsigned long iflags;
+
+	spin_lock_irqsave(phba->host->host_lock, iflags);
+	cmdiocbq->iocb_flag |= LPFC_IO_WAKE;
+	if (cmdiocbq->context2 && rspiocbq)
+		memcpy(&((struct lpfc_iocbq *)cmdiocbq->context2)->iocb,
+		       &rspiocbq->iocb, sizeof(IOCB_t));
+
+	pdone_q = cmdiocbq->context_un.wait_queue;
+	spin_unlock_irqrestore(phba->host->host_lock, iflags);
+	if (pdone_q)
+		wake_up(pdone_q);
 	return;
 }
 
+/*
+ * Issue the caller's iocb and wait for its completion, but no longer than the
+ * caller's timeout.  Note that iocb_flags is cleared before the
+ * lpfc_sli_issue_call since the wake routine sets a unique value and by
+ * definition this is a wait function.
+ */
 int
-lpfc_sli_issue_iocb_wait_high_priority(struct lpfc_hba * phba,
-				       struct lpfc_sli_ring * pring,
-				       struct lpfc_iocbq * piocb,
-				       uint32_t flag,
-				       struct lpfc_iocbq * prspiocbq,
-				       uint32_t timeout)
+lpfc_sli_issue_iocb_wait(struct lpfc_hba * phba,
+			 struct lpfc_sli_ring * pring,
+			 struct lpfc_iocbq * piocb,
+			 struct lpfc_iocbq * prspiocbq,
+			 uint32_t timeout)
 {
-	int j, delay_time,  retval = IOCB_ERROR;
-
-	/* The caller must left context1 empty.  */
-	if (piocb->context_un.hipri_wait_queue != 0) {
-		return IOCB_ERROR;
-	}
+	DECLARE_WAIT_QUEUE_HEAD(done_q);
+	long timeleft, timeout_req = 0;
+	int retval = IOCB_SUCCESS;
 
 	/*
-	 * If the caller has provided a response iocbq buffer, context2 must
-	 * be NULL or its an error.
+	 * If the caller has provided a response iocbq buffer, then context2
+	 * is NULL or its an error.
 	 */
-	if (prspiocbq && piocb->context2) {
-		return IOCB_ERROR;
-	}
-
-	piocb->context2 = prspiocbq;
-
-	/* Setup callback routine and issue the command. */
-	piocb->iocb_cmpl = lpfc_sli_wake_iocb_high_priority;
-	retval = lpfc_sli_issue_iocb(phba, pring, piocb,
-					flag | SLI_IOCB_HIGH_PRIORITY);
-	if (retval != IOCB_SUCCESS) {
-		piocb->context2 = NULL;
-		return IOCB_ERROR;
+	if (prspiocbq) {
+		if (piocb->context2)
+			return IOCB_ERROR;
+		piocb->context2 = prspiocbq;
 	}
 
-	/*
-	 * This high-priority iocb was sent out-of-band.  Poll for its
-	 * completion rather than wait for a signal.  Note that the host_lock
-	 * is held by the midlayer and must be released here to allow the
-	 * interrupt handlers to complete the IO and signal this routine via
-	 * the iocb_flag.
-	 * Also, the delay_time is computed to be one second longer than
-	 * the scsi command timeout to give the FW time to abort on
-	 * timeout rather than the driver just giving up.  Typically,
-	 * the midlayer does not specify a time for this command so the
-	 * driver is free to enforce its own timeout.
-	 */
+	piocb->iocb_cmpl = lpfc_sli_wake_iocb_wait;
+	piocb->context_un.wait_queue = &done_q;
+	piocb->iocb_flag &= ~LPFC_IO_WAKE;
+
+	retval = lpfc_sli_issue_iocb(phba, pring, piocb, 0);
+	if (retval == IOCB_SUCCESS) {
+		timeout_req = timeout * HZ;
+		spin_unlock_irq(phba->host->host_lock);
+		timeleft = wait_event_timeout(done_q,
+				piocb->iocb_flag & LPFC_IO_WAKE,
+				timeout_req);
+		spin_lock_irq(phba->host->host_lock);
 
-	delay_time = ((timeout + 1) * 1000) >> 6;
-	retval = IOCB_ERROR;
-	spin_unlock_irq(phba->host->host_lock);
-	for (j = 0; j < 64; j++) {
-		msleep(delay_time);
-		if (piocb->iocb_flag & LPFC_IO_HIPRI) {
-			piocb->iocb_flag &= ~LPFC_IO_HIPRI;
-			retval = IOCB_SUCCESS;
-			break;
+		if (timeleft == 0) {
+			lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
+					"%d:0329 IOCB wait timeout error - no "
+					"wake response Data x%x\n",
+					phba->brd_no, timeout);
+			retval = IOCB_TIMEDOUT;
+		} else if (!(piocb->iocb_flag & LPFC_IO_WAKE)) {
+			lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
+					"%d:0330 IOCB wake NOT set, "
+					"Data x%x x%lx\n", phba->brd_no,
+					timeout, (timeleft / jiffies));
+			retval = IOCB_TIMEDOUT;
+		} else {
+			lpfc_printf_log(phba, KERN_INFO, LOG_SLI,
+					"%d:0331 IOCB wake signaled\n",
+					phba->brd_no);
 		}
+	} else {
+		lpfc_printf_log(phba, KERN_INFO, LOG_SLI,
+				"%d:0332 IOCB wait issue failed, Data x%x\n",
+				phba->brd_no, retval);
+		retval = IOCB_ERROR;
 	}
 
-	spin_lock_irq(phba->host->host_lock);
-	piocb->context2 = NULL;
+	if (prspiocbq)
+		piocb->context2 = NULL;
+
+	piocb->context_un.wait_queue = NULL;
+	piocb->iocb_cmpl = NULL;
 	return retval;
 }
+
 int
 lpfc_sli_issue_mbox_wait(struct lpfc_hba * phba, LPFC_MBOXQ_t * pmboxq,
 			 uint32_t timeout)
