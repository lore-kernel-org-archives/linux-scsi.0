From: James Smart <james.smart@emulex.com>
Subject: [PATCH V2 1/5] lpfc 10.2.8001.0: Fix for cleaning up stale ring
 flag and sp_queue_event entries.
Date: Wed, 21 May 2014 08:04:59 -0400
Message-ID: <1400673899.16422.7.camel@myfc17>
Reply-To: <james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge1.ext.emulex.com ([138.239.224.99]:4915 "EHLO
	CMEXEDGE1.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751972AbaEUMFF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 21 May 2014 08:05:05 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Fix for cleaning up stale ring flag and sp_queue_event entries.


Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_init.c |   48 ++++++++++++++++++++++++++++++++++++++++++++++++
 lpfc_sli.c  |    1 +
 2 files changed, 49 insertions(+)


diff -upNr a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
--- a/drivers/scsi/lpfc/lpfc_init.c	2014-05-12 09:45:19.964082859 -0400
+++ b/drivers/scsi/lpfc/lpfc_init.c	2014-05-12 09:49:26.738095288 -0400
@@ -820,6 +820,52 @@ lpfc_hba_down_prep(struct lpfc_hba *phba
 }
 
 /**
+ * lpfc_sli4_free_sp_events - Cleanup sp_queue_events to free
+ * rspiocb which got deferred
+ *
+ * @phba: pointer to lpfc HBA data structure.
+ *
+ * This routine will cleanup completed slow path events after HBA is reset
+ * when bringing down the SLI Layer.
+ *
+ *
+ * Return codes
+ *   void.
+ **/
+static void
+lpfc_sli4_free_sp_events(struct lpfc_hba *phba)
+{
+	struct lpfc_iocbq *rspiocbq;
+	struct hbq_dmabuf *dmabuf;
+	struct lpfc_cq_event *cq_event;
+
+	spin_lock_irq(&phba->hbalock);
+	phba->hba_flag &= ~HBA_SP_QUEUE_EVT;
+	spin_unlock_irq(&phba->hbalock);
+
+	while (!list_empty(&phba->sli4_hba.sp_queue_event)) {
+		/* Get the response iocb from the head of work queue */
+		spin_lock_irq(&phba->hbalock);
+		list_remove_head(&phba->sli4_hba.sp_queue_event,
+				 cq_event, struct lpfc_cq_event, list);
+		spin_unlock_irq(&phba->hbalock);
+
+		switch (bf_get(lpfc_wcqe_c_code, &cq_event->cqe.wcqe_cmpl)) {
+		case CQE_CODE_COMPL_WQE:
+			rspiocbq = container_of(cq_event, struct lpfc_iocbq,
+						 cq_event);
+			lpfc_sli_release_iocbq(phba, rspiocbq);
+			break;
+		case CQE_CODE_RECEIVE:
+		case CQE_CODE_RECEIVE_V1:
+			dmabuf = container_of(cq_event, struct hbq_dmabuf,
+					      cq_event);
+			lpfc_in_buf_free(phba, &dmabuf->dbuf);
+		}
+	}
+}
+
+/**
  * lpfc_hba_free_post_buf - Perform lpfc uninitialization after HBA reset
  * @phba: pointer to lpfc HBA data structure.
  *
@@ -981,6 +1027,8 @@ lpfc_hba_down_post_s4(struct lpfc_hba *p
 	spin_lock_irqsave(&phba->scsi_buf_list_put_lock, iflag);
 	list_splice(&aborts, &phba->lpfc_scsi_buf_list_put);
 	spin_unlock_irqrestore(&phba->scsi_buf_list_put_lock, iflag);
+
+	lpfc_sli4_free_sp_events(phba);
 	return 0;
 }
 
diff -upNr a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
--- a/drivers/scsi/lpfc/lpfc_sli.c	2014-05-12 09:45:19.986082860 -0400
+++ b/drivers/scsi/lpfc/lpfc_sli.c	2014-05-12 09:49:26.785095291 -0400
@@ -9223,6 +9223,7 @@ lpfc_sli_queue_setup(struct lpfc_hba *ph
 		pring->sli.sli3.next_cmdidx  = 0;
 		pring->sli.sli3.local_getidx = 0;
 		pring->sli.sli3.cmdidx = 0;
+		pring->flag = 0;
 		INIT_LIST_HEAD(&pring->txq);
 		INIT_LIST_HEAD(&pring->txcmplq);
 		INIT_LIST_HEAD(&pring->iocb_continueq);


