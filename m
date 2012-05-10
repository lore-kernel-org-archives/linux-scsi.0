From: James Smart <james.smart@emulex.com>
Subject: [PATCH 06/20] lpfc 8.3.31: Fixed system panic due to midlayer abort
 and driver complete race on SCSI cmd
Date: Wed, 9 May 2012 21:17:07 -0400
Message-ID: <1336612637.1996.35.camel@ogier>
Reply-To: james.smart@emulex.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exht1.emulex.com ([138.239.113.183]:27881 "EHLO
	exht1.ad.emulex.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754408Ab2EJBRf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 9 May 2012 21:17:35 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Fixed system panic due to midlayer abort and driver complete race on SCSI cmd


Signed-off-by: Alex Iannicelli <alex.iannicelli@emulex.com>
Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc.h      |    1 +
 lpfc_crtn.h |    1 +
 lpfc_scsi.c |   48 +++++++++++++++++++++++++++++++++++++-----------
 lpfc_sli.c  |   23 ++++++++++++++---------
 lpfc_sli.h  |    2 +-
 5 files changed, 54 insertions(+), 21 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_crtn.h b/drivers/scsi/lpfc/lpfc_crtn.h
--- a/drivers/scsi/lpfc/lpfc_crtn.h	2012-05-07 10:00:55.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_crtn.h	2012-05-07 10:01:08.000000000 -0400
@@ -254,6 +254,7 @@ int
 lpfc_sli_handle_fast_ring_event(struct lpfc_hba *,
 			struct lpfc_sli_ring *, uint32_t);
 
+struct lpfc_iocbq * __lpfc_sli_get_iocbq(struct lpfc_hba *);
 struct lpfc_iocbq * lpfc_sli_get_iocbq(struct lpfc_hba *);
 void lpfc_sli_release_iocbq(struct lpfc_hba *, struct lpfc_iocbq *);
 uint16_t lpfc_sli_next_iotag(struct lpfc_hba *, struct lpfc_iocbq *);
diff -upNr a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
--- a/drivers/scsi/lpfc/lpfc.h	2012-05-06 13:15:39.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc.h	2012-05-07 10:01:08.000000000 -0400
@@ -620,6 +620,7 @@ struct lpfc_hba {
 #define HBA_AER_ENABLED		0x1000 /* AER enabled with HBA */
 #define HBA_DEVLOSS_TMO         0x2000 /* HBA in devloss timeout */
 #define HBA_RRQ_ACTIVE		0x4000 /* process the rrq active list */
+#define HBA_FCP_IOQ_FLUSH	0x8000 /* FCP I/O queues being flushed */
 	uint32_t fcp_ring_in_use; /* When polling test if intr-hndlr active*/
 	struct lpfc_dmabuf slim2p;
 
diff -upNr a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
--- a/drivers/scsi/lpfc/lpfc_scsi.c	2012-05-07 10:00:55.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_scsi.c	2012-05-07 10:01:08.000000000 -0400
@@ -4396,8 +4396,20 @@ lpfc_abort_handler(struct scsi_cmnd *cmn
 	ret = fc_block_scsi_eh(cmnd);
 	if (ret)
 		return ret;
+
+	spin_lock_irq(&phba->hbalock);
+	/* driver queued commands are in process of being flushed */
+	if (phba->hba_flag & HBA_FCP_IOQ_FLUSH) {
+		spin_unlock_irq(&phba->hbalock);
+		lpfc_printf_vlog(vport, KERN_WARNING, LOG_FCP,
+			"3168 SCSI Layer abort requested I/O has been "
+			"flushed by LLD.\n");
+		return FAILED;
+	}
+
 	lpfc_cmd = (struct lpfc_scsi_buf *)cmnd->host_scribble;
 	if (!lpfc_cmd) {
+		spin_unlock_irq(&phba->hbalock);
 		lpfc_printf_vlog(vport, KERN_WARNING, LOG_FCP,
 			 "2873 SCSI Layer I/O Abort Request IO CMPL Status "
 			 "x%x ID %d LUN %d\n",
@@ -4405,23 +4417,34 @@ lpfc_abort_handler(struct scsi_cmnd *cmn
 		return SUCCESS;
 	}
 
+	iocb = &lpfc_cmd->cur_iocbq;
+	/* the command is in process of being cancelled */
+	if (!(iocb->iocb_flag & LPFC_IO_ON_TXCMPLQ)) {
+		spin_unlock_irq(&phba->hbalock);
+		lpfc_printf_vlog(vport, KERN_WARNING, LOG_FCP,
+			"3169 SCSI Layer abort requested I/O has been "
+			"cancelled by LLD.\n");
+		return FAILED;
+	}
 	/*
 	 * If pCmd field of the corresponding lpfc_scsi_buf structure
 	 * points to a different SCSI command, then the driver has
 	 * already completed this command, but the midlayer did not
-	 * see the completion before the eh fired.  Just return
-	 * SUCCESS.
+	 * see the completion before the eh fired. Just return SUCCESS.
 	 */
-	iocb = &lpfc_cmd->cur_iocbq;
-	if (lpfc_cmd->pCmd != cmnd)
-		goto out;
+	if (lpfc_cmd->pCmd != cmnd) {
+		lpfc_printf_vlog(vport, KERN_WARNING, LOG_FCP,
+			"3170 SCSI Layer abort requested I/O has been "
+			"completed by LLD.\n");
+		goto out_unlock;
+	}
 
 	BUG_ON(iocb->context1 != lpfc_cmd);
 
-	abtsiocb = lpfc_sli_get_iocbq(phba);
+	abtsiocb = __lpfc_sli_get_iocbq(phba);
 	if (abtsiocb == NULL) {
 		ret = FAILED;
-		goto out;
+		goto out_unlock;
 	}
 
 	/*
@@ -4453,6 +4476,9 @@ lpfc_abort_handler(struct scsi_cmnd *cmn
 
 	abtsiocb->iocb_cmpl = lpfc_sli_abort_fcp_cmpl;
 	abtsiocb->vport = vport;
+	/* no longer need the lock after this point */
+	spin_unlock_irq(&phba->hbalock);
+
 	if (lpfc_sli_issue_iocb(phba, LPFC_FCP_RING, abtsiocb, 0) ==
 	    IOCB_ERROR) {
 		lpfc_sli_release_iocbq(phba, abtsiocb);
@@ -4469,10 +4495,7 @@ lpfc_abort_handler(struct scsi_cmnd *cmn
 	wait_event_timeout(waitq,
 			  (lpfc_cmd->pCmd != cmnd),
 			   (2*vport->cfg_devloss_tmo*HZ));
-
-	spin_lock_irq(shost->host_lock);
 	lpfc_cmd->waitq = NULL;
-	spin_unlock_irq(shost->host_lock);
 
 	if (lpfc_cmd->pCmd == cmnd) {
 		ret = FAILED;
@@ -4482,8 +4505,11 @@ lpfc_abort_handler(struct scsi_cmnd *cmn
 				 "LUN %d\n",
 				 ret, cmnd->device->id, cmnd->device->lun);
 	}
+	goto out;
 
- out:
+out_unlock:
+	spin_unlock_irq(&phba->hbalock);
+out:
 	lpfc_printf_vlog(vport, KERN_WARNING, LOG_FCP,
 			 "0749 SCSI Layer I/O Abort Request Status x%x ID %d "
 			 "LUN %d\n", ret, cmnd->device->id,
diff -upNr a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
--- a/drivers/scsi/lpfc/lpfc_sli.c	2012-05-07 10:01:05.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_sli.c	2012-05-07 10:01:08.000000000 -0400
@@ -502,7 +502,7 @@ lpfc_resp_iocb(struct lpfc_hba *phba, st
  * allocation is successful, it returns pointer to the newly
  * allocated iocb object else it returns NULL.
  **/
-static struct lpfc_iocbq *
+struct lpfc_iocbq *
 __lpfc_sli_get_iocbq(struct lpfc_hba *phba)
 {
 	struct list_head *lpfc_iocb_list = &phba->lpfc_iocb_list;
@@ -1259,7 +1259,7 @@ lpfc_sli_ringtxcmpl_put(struct lpfc_hba 
 			struct lpfc_iocbq *piocb)
 {
 	list_add_tail(&piocb->list, &pring->txcmplq);
-	piocb->iocb_flag |= LPFC_IO_ON_Q;
+	piocb->iocb_flag |= LPFC_IO_ON_TXCMPLQ;
 	pring->txcmplq_cnt++;
 	if (pring->txcmplq_cnt > pring->txcmplq_max)
 		pring->txcmplq_max = pring->txcmplq_cnt;
@@ -2558,9 +2558,9 @@ lpfc_sli_iocbq_lookup(struct lpfc_hba *p
 	if (iotag != 0 && iotag <= phba->sli.last_iotag) {
 		cmd_iocb = phba->sli.iocbq_lookup[iotag];
 		list_del_init(&cmd_iocb->list);
-		if (cmd_iocb->iocb_flag & LPFC_IO_ON_Q) {
+		if (cmd_iocb->iocb_flag & LPFC_IO_ON_TXCMPLQ) {
 			pring->txcmplq_cnt--;
-			cmd_iocb->iocb_flag &= ~LPFC_IO_ON_Q;
+			cmd_iocb->iocb_flag &= ~LPFC_IO_ON_TXCMPLQ;
 		}
 		return cmd_iocb;
 	}
@@ -2593,14 +2593,14 @@ lpfc_sli_iocbq_lookup_by_tag(struct lpfc
 
 	if (iotag != 0 && iotag <= phba->sli.last_iotag) {
 		cmd_iocb = phba->sli.iocbq_lookup[iotag];
-		list_del_init(&cmd_iocb->list);
-		if (cmd_iocb->iocb_flag & LPFC_IO_ON_Q) {
-			cmd_iocb->iocb_flag &= ~LPFC_IO_ON_Q;
+		if (cmd_iocb->iocb_flag & LPFC_IO_ON_TXCMPLQ) {
+			/* remove from txcmpl queue list */
+			list_del_init(&cmd_iocb->list);
+			cmd_iocb->iocb_flag &= ~LPFC_IO_ON_TXCMPLQ;
 			pring->txcmplq_cnt--;
+			return cmd_iocb;
 		}
-		return cmd_iocb;
 	}
-
 	lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
 			"0372 iotag x%x is out off range: max iotag (x%x)\n",
 			iotag, phba->sli.last_iotag);
@@ -3468,6 +3468,9 @@ lpfc_sli_flush_fcp_rings(struct lpfc_hba
 	/* Retrieve everything on the txcmplq */
 	list_splice_init(&pring->txcmplq, &txcmplq);
 	pring->txcmplq_cnt = 0;
+
+	/* Indicate the I/O queues are flushed */
+	phba->hba_flag |= HBA_FCP_IOQ_FLUSH;
 	spin_unlock_irq(&phba->hbalock);
 
 	/* Flush the txq */
@@ -6069,6 +6072,8 @@ lpfc_sli4_hba_setup(struct lpfc_hba *phb
 	else
 		phba->hba_flag &= ~HBA_FIP_SUPPORT;
 
+	phba->hba_flag &= ~HBA_FCP_IOQ_FLUSH;
+
 	if (phba->sli_rev != LPFC_SLI_REV4) {
 		lpfc_printf_log(phba, KERN_ERR, LOG_MBOX | LOG_SLI,
 			"0376 READ_REV Error. SLI Level %d "
diff -upNr a/drivers/scsi/lpfc/lpfc_sli.h b/drivers/scsi/lpfc/lpfc_sli.h
--- a/drivers/scsi/lpfc/lpfc_sli.h	2012-05-06 13:15:39.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_sli.h	2012-05-07 10:01:08.000000000 -0400
@@ -68,7 +68,7 @@ struct lpfc_iocbq {
 #define LPFC_EXCHANGE_BUSY	0x40    /* SLI4 hba reported XB in response */
 #define LPFC_USE_FCPWQIDX	0x80    /* Submit to specified FCPWQ index */
 #define DSS_SECURITY_OP		0x100	/* security IO */
-#define LPFC_IO_ON_Q		0x200	/* The IO is still on the TXCMPLQ */
+#define LPFC_IO_ON_TXCMPLQ	0x200	/* The IO is still on the TXCMPLQ */
 #define LPFC_IO_DIF		0x400	/* T10 DIF IO */
 
 #define LPFC_FIP_ELS_ID_MASK	0xc000	/* ELS_ID range 0-3, non-shifted mask */



