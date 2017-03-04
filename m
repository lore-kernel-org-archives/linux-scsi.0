From: jsmart2021@gmail.com
Subject: [PATCH 10/20] lpfc: add NVME exchange aborts
Date: Sat,  4 Mar 2017 09:30:30 -0800
Message-ID: <1488648640-5170-11-git-send-email-jsmart2021@gmail.com>
References: <1488648640-5170-1-git-send-email-jsmart2021@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qk0-f193.google.com ([209.85.220.193]:36527 "EHLO
        mail-qk0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752159AbdCDRbB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 4 Mar 2017 12:31:01 -0500
Received: by mail-qk0-f193.google.com with SMTP id n141so10940579qke.3
        for <linux-scsi@vger.kernel.org>; Sat, 04 Mar 2017 09:31:01 -0800 (PST)
In-Reply-To: <1488648640-5170-1-git-send-email-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org
Cc: James Smart <jsmart2021@gmail.com>, Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

From: James Smart <jsmart2021@gmail.com>

previous code did little more than log a message.

This patch adds abort path support, modeled after the SCSI code paths.
Currently addresses only the initiator path. Target path under
development, but stubbed out.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
---
 drivers/scsi/lpfc/lpfc.h         |  1 +
 drivers/scsi/lpfc/lpfc_hbadisc.c |  2 ++
 drivers/scsi/lpfc/lpfc_init.c    |  7 +++++
 drivers/scsi/lpfc/lpfc_nvme.c    | 64 ++++++++++++++++++++++++++++++++++++----
 drivers/scsi/lpfc/lpfc_nvme.h    |  1 +
 drivers/scsi/lpfc/lpfc_nvmet.c   | 21 +++++++++++--
 drivers/scsi/lpfc/lpfc_sli.c     | 51 ++++++++++++++++++++++++++++++--
 drivers/scsi/lpfc/lpfc_sli4.h    |  6 ++++
 8 files changed, 143 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
index 0bba2e3..de6cd57 100644
--- a/drivers/scsi/lpfc/lpfc.h
+++ b/drivers/scsi/lpfc/lpfc.h
@@ -692,6 +692,7 @@ struct lpfc_hba {
 					 * capability
 					 */
 #define HBA_NVME_IOQ_FLUSH      0x80000 /* NVME IO queues flushed. */
+#define NVME_XRI_ABORT_EVENT	0x100000
 
 	uint32_t fcp_ring_in_use; /* When polling test if intr-hndlr active*/
 	struct lpfc_dmabuf slim2p;
diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index 194a14d..b940092 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -641,6 +641,8 @@ lpfc_work_done(struct lpfc_hba *phba)
 			lpfc_handle_rrq_active(phba);
 		if (phba->hba_flag & FCP_XRI_ABORT_EVENT)
 			lpfc_sli4_fcp_xri_abort_event_proc(phba);
+		if (phba->hba_flag & NVME_XRI_ABORT_EVENT)
+			lpfc_sli4_nvme_xri_abort_event_proc(phba);
 		if (phba->hba_flag & ELS_XRI_ABORT_EVENT)
 			lpfc_sli4_els_xri_abort_event_proc(phba);
 		if (phba->hba_flag & ASYNC_EVENT)
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 0ee429d..b754887 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -5736,6 +5736,8 @@ lpfc_sli4_driver_resource_setup(struct lpfc_hba *phba)
 		/* Initialize the Abort nvme buffer list used by driver */
 		spin_lock_init(&phba->sli4_hba.abts_nvme_buf_list_lock);
 		INIT_LIST_HEAD(&phba->sli4_hba.lpfc_abts_nvme_buf_list);
+		/* Fast-path XRI aborted CQ Event work queue list */
+		INIT_LIST_HEAD(&phba->sli4_hba.sp_nvme_xri_aborted_work_queue);
 	}
 
 	/* This abort list used by worker thread */
@@ -8973,6 +8975,11 @@ lpfc_sli4_cq_event_release_all(struct lpfc_hba *phba)
 	/* Pending ELS XRI abort events */
 	list_splice_init(&phba->sli4_hba.sp_els_xri_aborted_work_queue,
 			 &cqelist);
+	if (phba->cfg_enable_fc4_type & LPFC_ENABLE_NVME) {
+		/* Pending NVME XRI abort events */
+		list_splice_init(&phba->sli4_hba.sp_nvme_xri_aborted_work_queue,
+				 &cqelist);
+	}
 	/* Pending asynnc events */
 	list_splice_init(&phba->sli4_hba.sp_asynce_work_queue,
 			 &cqelist);
diff --git a/drivers/scsi/lpfc/lpfc_nvme.c b/drivers/scsi/lpfc/lpfc_nvme.c
index 26cde7c..b9012fe 100644
--- a/drivers/scsi/lpfc/lpfc_nvme.c
+++ b/drivers/scsi/lpfc/lpfc_nvme.c
@@ -1277,6 +1277,7 @@ lpfc_nvme_fcp_io_submit(struct nvme_fc_local_port *pnvme_lport,
 	pnvme_fcreq->private = (void *)lpfc_ncmd;
 	lpfc_ncmd->nvmeCmd = pnvme_fcreq;
 	lpfc_ncmd->nrport = rport;
+	lpfc_ncmd->ndlp = ndlp;
 	lpfc_ncmd->start_time = jiffies;
 
 	lpfc_nvme_prep_io_cmd(vport, lpfc_ncmd, ndlp);
@@ -1812,10 +1813,10 @@ lpfc_post_nvme_sgl_list(struct lpfc_hba *phba,
 						pdma_phys_sgl1, cur_xritag);
 				if (status) {
 					/* failure, put on abort nvme list */
-					lpfc_ncmd->exch_busy = 1;
+					lpfc_ncmd->flags |= LPFC_SBUF_XBUSY;
 				} else {
 					/* success, put on NVME buffer list */
-					lpfc_ncmd->exch_busy = 0;
+					lpfc_ncmd->flags &= ~LPFC_SBUF_XBUSY;
 					lpfc_ncmd->status = IOSTAT_SUCCESS;
 					num_posted++;
 				}
@@ -1845,10 +1846,10 @@ lpfc_post_nvme_sgl_list(struct lpfc_hba *phba,
 					 struct lpfc_nvme_buf, list);
 			if (status) {
 				/* failure, put on abort nvme list */
-				lpfc_ncmd->exch_busy = 1;
+				lpfc_ncmd->flags |= LPFC_SBUF_XBUSY;
 			} else {
 				/* success, put on NVME buffer list */
-				lpfc_ncmd->exch_busy = 0;
+				lpfc_ncmd->flags &= ~LPFC_SBUF_XBUSY;
 				lpfc_ncmd->status = IOSTAT_SUCCESS;
 				num_posted++;
 			}
@@ -2090,7 +2091,7 @@ lpfc_release_nvme_buf(struct lpfc_hba *phba, struct lpfc_nvme_buf *lpfc_ncmd)
 	unsigned long iflag = 0;
 
 	lpfc_ncmd->nonsg_phys = 0;
-	if (lpfc_ncmd->exch_busy) {
+	if (lpfc_ncmd->flags & LPFC_SBUF_XBUSY) {
 		spin_lock_irqsave(&phba->sli4_hba.abts_nvme_buf_list_lock,
 					iflag);
 		lpfc_ncmd->nvmeCmd = NULL;
@@ -2453,3 +2454,56 @@ lpfc_nvme_unregister_port(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
 			 "6168: State error: lport %p, rport%p FCID x%06x\n",
 			 vport->localport, ndlp->rport, ndlp->nlp_DID);
 }
+
+/**
+ * lpfc_sli4_nvme_xri_aborted - Fast-path process of NVME xri abort
+ * @phba: pointer to lpfc hba data structure.
+ * @axri: pointer to the fcp xri abort wcqe structure.
+ *
+ * This routine is invoked by the worker thread to process a SLI4 fast-path
+ * FCP aborted xri.
+ **/
+void
+lpfc_sli4_nvme_xri_aborted(struct lpfc_hba *phba,
+			   struct sli4_wcqe_xri_aborted *axri)
+{
+	uint16_t xri = bf_get(lpfc_wcqe_xa_xri, axri);
+	uint16_t rxid = bf_get(lpfc_wcqe_xa_remote_xid, axri);
+	struct lpfc_nvme_buf *lpfc_ncmd, *next_lpfc_ncmd;
+	struct lpfc_nodelist *ndlp;
+	unsigned long iflag = 0;
+	int rrq_empty = 0;
+
+	if (!(phba->cfg_enable_fc4_type & LPFC_ENABLE_NVME))
+		return;
+	spin_lock_irqsave(&phba->hbalock, iflag);
+	spin_lock(&phba->sli4_hba.abts_nvme_buf_list_lock);
+	list_for_each_entry_safe(lpfc_ncmd, next_lpfc_ncmd,
+				 &phba->sli4_hba.lpfc_abts_nvme_buf_list,
+				 list) {
+		if (lpfc_ncmd->cur_iocbq.sli4_xritag == xri) {
+			list_del(&lpfc_ncmd->list);
+			lpfc_ncmd->flags &= ~LPFC_SBUF_XBUSY;
+			lpfc_ncmd->status = IOSTAT_SUCCESS;
+			spin_unlock(
+				&phba->sli4_hba.abts_nvme_buf_list_lock);
+
+			rrq_empty = list_empty(&phba->active_rrq_list);
+			spin_unlock_irqrestore(&phba->hbalock, iflag);
+			ndlp = lpfc_ncmd->ndlp;
+			if (ndlp) {
+				lpfc_set_rrq_active(
+					phba, ndlp,
+					lpfc_ncmd->cur_iocbq.sli4_lxritag,
+					rxid, 1);
+				lpfc_sli4_abts_err_handler(phba, ndlp, axri);
+			}
+			lpfc_release_nvme_buf(phba, lpfc_ncmd);
+			if (rrq_empty)
+				lpfc_worker_wake_up(phba);
+			return;
+		}
+	}
+	spin_unlock(&phba->sli4_hba.abts_nvme_buf_list_lock);
+	spin_unlock_irqrestore(&phba->hbalock, iflag);
+}
diff --git a/drivers/scsi/lpfc/lpfc_nvme.h b/drivers/scsi/lpfc/lpfc_nvme.h
index b2fae5e..1347deb 100644
--- a/drivers/scsi/lpfc/lpfc_nvme.h
+++ b/drivers/scsi/lpfc/lpfc_nvme.h
@@ -57,6 +57,7 @@ struct lpfc_nvme_buf {
 	struct list_head list;
 	struct nvmefc_fcp_req *nvmeCmd;
 	struct lpfc_nvme_rport *nrport;
+	struct lpfc_nodelist *ndlp;
 
 	uint32_t timeout;
 
diff --git a/drivers/scsi/lpfc/lpfc_nvmet.c b/drivers/scsi/lpfc/lpfc_nvmet.c
index 735e2ba..48ce985 100644
--- a/drivers/scsi/lpfc/lpfc_nvmet.c
+++ b/drivers/scsi/lpfc/lpfc_nvmet.c
@@ -734,6 +734,21 @@ lpfc_nvmet_update_targetport(struct lpfc_hba *phba)
 	return 0;
 }
 
+/**
+ * lpfc_sli4_nvmet_xri_aborted - Fast-path process of nvmet xri abort
+ * @phba: pointer to lpfc hba data structure.
+ * @axri: pointer to the nvmet xri abort wcqe structure.
+ *
+ * This routine is invoked by the worker thread to process a SLI4 fast-path
+ * NVMET aborted xri.
+ **/
+void
+lpfc_sli4_nvmet_xri_aborted(struct lpfc_hba *phba,
+			    struct sli4_wcqe_xri_aborted *axri)
+{
+	/* TODO: work in progress */
+}
+
 void
 lpfc_nvmet_destroy_targetport(struct lpfc_hba *phba)
 {
@@ -958,7 +973,7 @@ lpfc_nvmet_unsol_fcp_buffer(struct lpfc_hba *phba,
 
 	atomic_inc(&tgtp->rcv_fcp_cmd_drop);
 	lpfc_printf_log(phba, KERN_ERR, LOG_NVME_IOERR,
-			"6159 FCP Drop IO x%x: nvmet_fc_rcv_fcp_req x%x\n",
+			"6159 FCP Drop IO x%x: err x%x\n",
 			ctxp->oxid, rc);
 dropit:
 	lpfc_nvmeio_data(phba, "NVMET FCP DROP: xri x%x sz %d from %06x\n",
@@ -1683,8 +1698,8 @@ lpfc_nvmet_unsol_issue_abort(struct lpfc_hba *phba,
 	struct lpfc_nodelist *ndlp;
 
 	lpfc_printf_log(phba, KERN_INFO, LOG_NVME_ABTS,
-			"6067 %s: Entrypoint: sid %x xri %x\n", __func__,
-			sid, xri);
+			"6067 Abort: sid %x xri x%x/x%x\n",
+			sid, xri, ctxp->wqeq->sli4_xritag);
 
 	tgtp = (struct lpfc_nvmet_tgtport *)phba->targetport->private;
 
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 7389c13..8a606d0 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -12213,6 +12213,41 @@ void lpfc_sli4_fcp_xri_abort_event_proc(struct lpfc_hba *phba)
 }
 
 /**
+ * lpfc_sli4_nvme_xri_abort_event_proc - Process nvme xri abort event
+ * @phba: pointer to lpfc hba data structure.
+ *
+ * This routine is invoked by the worker thread to process all the pending
+ * SLI4 NVME abort XRI events.
+ **/
+void lpfc_sli4_nvme_xri_abort_event_proc(struct lpfc_hba *phba)
+{
+	struct lpfc_cq_event *cq_event;
+
+	/* First, declare the fcp xri abort event has been handled */
+	spin_lock_irq(&phba->hbalock);
+	phba->hba_flag &= ~NVME_XRI_ABORT_EVENT;
+	spin_unlock_irq(&phba->hbalock);
+	/* Now, handle all the fcp xri abort events */
+	while (!list_empty(&phba->sli4_hba.sp_nvme_xri_aborted_work_queue)) {
+		/* Get the first event from the head of the event queue */
+		spin_lock_irq(&phba->hbalock);
+		list_remove_head(&phba->sli4_hba.sp_nvme_xri_aborted_work_queue,
+				 cq_event, struct lpfc_cq_event, list);
+		spin_unlock_irq(&phba->hbalock);
+		/* Notify aborted XRI for NVME work queue */
+		if (phba->nvmet_support) {
+			lpfc_sli4_nvmet_xri_aborted(phba,
+						    &cq_event->cqe.wcqe_axri);
+		} else {
+			lpfc_sli4_nvme_xri_aborted(phba,
+						   &cq_event->cqe.wcqe_axri);
+		}
+		/* Free the event processed back to the free pool */
+		lpfc_sli4_cq_event_release(phba, cq_event);
+	}
+}
+
+/**
  * lpfc_sli4_els_xri_abort_event_proc - Process els xri abort event
  * @phba: pointer to lpfc hba data structure.
  *
@@ -12709,10 +12744,22 @@ lpfc_sli4_sp_handle_abort_xri_wcqe(struct lpfc_hba *phba,
 		spin_unlock_irqrestore(&phba->hbalock, iflags);
 		workposted = true;
 		break;
+	case LPFC_NVME:
+		spin_lock_irqsave(&phba->hbalock, iflags);
+		list_add_tail(&cq_event->list,
+			      &phba->sli4_hba.sp_nvme_xri_aborted_work_queue);
+		/* Set the nvme xri abort event flag */
+		phba->hba_flag |= NVME_XRI_ABORT_EVENT;
+		spin_unlock_irqrestore(&phba->hbalock, iflags);
+		workposted = true;
+		break;
 	default:
 		lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
-				"0603 Invalid work queue CQE subtype (x%x)\n",
-				cq->subtype);
+				"0603 Invalid CQ subtype %d: "
+				"%08x %08x %08x %08x\n",
+				cq->subtype, wcqe->word0, wcqe->parameter,
+				wcqe->word2, wcqe->word3);
+		lpfc_sli4_cq_event_release(phba, cq_event);
 		workposted = false;
 		break;
 	}
diff --git a/drivers/scsi/lpfc/lpfc_sli4.h b/drivers/scsi/lpfc/lpfc_sli4.h
index 91153c9..710458c 100644
--- a/drivers/scsi/lpfc/lpfc_sli4.h
+++ b/drivers/scsi/lpfc/lpfc_sli4.h
@@ -642,6 +642,7 @@ struct lpfc_sli4_hba {
 	struct list_head sp_asynce_work_queue;
 	struct list_head sp_fcp_xri_aborted_work_queue;
 	struct list_head sp_els_xri_aborted_work_queue;
+	struct list_head sp_nvme_xri_aborted_work_queue;
 	struct list_head sp_unsol_work_queue;
 	struct lpfc_sli4_link link_state;
 	struct lpfc_sli4_lnk_info lnk_info;
@@ -794,9 +795,14 @@ void lpfc_sli4_fcf_redisc_event_proc(struct lpfc_hba *);
 int lpfc_sli4_resume_rpi(struct lpfc_nodelist *,
 			void (*)(struct lpfc_hba *, LPFC_MBOXQ_t *), void *);
 void lpfc_sli4_fcp_xri_abort_event_proc(struct lpfc_hba *);
+void lpfc_sli4_nvme_xri_abort_event_proc(struct lpfc_hba *phba);
 void lpfc_sli4_els_xri_abort_event_proc(struct lpfc_hba *);
 void lpfc_sli4_fcp_xri_aborted(struct lpfc_hba *,
 			       struct sli4_wcqe_xri_aborted *);
+void lpfc_sli4_nvme_xri_aborted(struct lpfc_hba *phba,
+				struct sli4_wcqe_xri_aborted *axri);
+void lpfc_sli4_nvmet_xri_aborted(struct lpfc_hba *phba,
+				 struct sli4_wcqe_xri_aborted *axri);
 void lpfc_sli4_els_xri_aborted(struct lpfc_hba *,
 			       struct sli4_wcqe_xri_aborted *);
 void lpfc_sli4_vport_delete_els_xri_aborted(struct lpfc_vport *);
-- 
2.5.0
