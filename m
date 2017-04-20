From: jsmart2021@gmail.com
Subject: [PATCH-v1 20/22] Update ABORT processing for NVMET.
Date: Wed, 19 Apr 2017 21:46:39 -0700
Message-ID: <20170420044641.10657-21-jsmart2021@gmail.com>
References: <20170420044641.10657-1-jsmart2021@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:33975 "EHLO
        mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S941179AbdDTErf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 20 Apr 2017 00:47:35 -0400
Received: by mail-oi0-f68.google.com with SMTP id y11so3468367oie.1
        for <linux-scsi@vger.kernel.org>; Wed, 19 Apr 2017 21:47:35 -0700 (PDT)
In-Reply-To: <20170420044641.10657-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org, sagi@grimberg.me, martin.petersen@oracle.com
Cc: James Smart <jsmart2021@gmail.com>, Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

From: James Smart <jsmart2021@gmail.com>

The driver with nvme had this routine stubbed.

Right now XRI_ABORTED_CQE is not handled and the FC NVMET
Transport has a new API for the driver.

Missing code path, new NVME abort API
Update ABORT processing for NVMET

There are 3 new FC NVMET Transport API/ template routines for NVMET:

lpfc_nvmet_xmt_fcp_release
This NVMET template callback routine called to release context
associated with an IO This routine is ALWAYS called last, even
if the IO was aborted or completed in error.

lpfc_nvmet_xmt_fcp_abort
This NVMET template callback routine called to abort an exchange that
has an IO in progress

nvmet_fc_rcv_fcp_req
When the lpfc driver receives an ABTS, this NVME FC transport layer
callback routine is called. For this case there are 2 paths thru the
driver: the driver either has an outstanding exchange / context for the
XRI to be aborted or not.  If not, a BA_RJT is issued otherwise a BA_ACC

NVMET Driver abort paths:

There are 2 paths for aborting an IO. The first one is we receive an IO and
decide not to process it because of lack of resources. An unsolicated ABTS
is immediately sent back to the initiator as a response.
lpfc_nvmet_unsol_fcp_buffer
            lpfc_nvmet_unsol_issue_abort  (XMIT_SEQUENCE_WQE)

The second one is we sent the IO up to the NVMET transport layer to
process, and for some reason the NVME Transport layer decided to abort the
IO before it completes all its phases. For this case there are 2 paths
thru the driver:
the driver either has an outstanding TSEND/TRECEIVE/TRSP WQE or no
outstanding WQEs are present for the exchange / context.
lpfc_nvmet_xmt_fcp_abort
    if (LPFC_NVMET_IO_INP)
        lpfc_nvmet_sol_fcp_issue_abort  (ABORT_WQE)
                lpfc_nvmet_sol_fcp_abort_cmp
    else
        lpfc_nvmet_unsol_fcp_issue_abort
                lpfc_nvmet_unsol_issue_abort  (XMIT_SEQUENCE_WQE)
                        lpfc_nvmet_unsol_fcp_abort_cmp

Context flags:
LPFC_NVMET_IOP - his flag signifies an IO is in progress on the exchange.
LPFC_NVMET_XBUSY  - this flag indicates the IO completed but the firmware
is still busy with the corresponding exchange. The exchange should not be
reused until after a XRI_ABORTED_CQE is received for that exchange.
LPFC_NVMET_ABORT_OP - this flag signifies an ABORT_WQE was issued on the
exchange.
LPFC_NVMET_CTX_RLS  - this flag signifies a context free was requested,
but we are deferring it due to an XBUSY or ABORT in progress.

A ctxlock is added to the context structure that is used whenever these
flags are set/read  within the context of an IO.
The LPFC_NVMET_CTX_RLS flag is only set in the defer_relase routine when
the transport has resolved all IO associated with the buffer. The flag is
cleared when the CTX is associated with a new IO.

An exchange can has both an LPFC_NVMET_XBUSY and a LPFC_NVMET_ABORT_OP
condition active simultaneously. Both conditions must complete before the
exchange is freed.
When the abort callback (lpfc_nvmet_xmt_fcp_abort) is envoked:
If there is an outstanding IO, the driver will issue an ABORT_WQE. This
should result in 3 completions for the exchange:
1) IO cmpl with XB bit set
2) Abort WQE cmpl
3) XRI_ABORTED_CQE cmpl
For this scenerio, after completion #1, the NVMET Transport IO rsp
callback is called.  After completion #2, no action is taken with respect
to the exchange / context.  After completion #3, the exchange context is
free for re-use on another IO.

If there is no outstanding activity on the exchange, the driver will send a
ABTS to the Initiator. Upon completion of this WQE, the exchange / context
is freed for re-use on another IO.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_crtn.h    |   7 +
 drivers/scsi/lpfc/lpfc_debugfs.c |  55 ++++--
 drivers/scsi/lpfc/lpfc_hw4.h     |   3 +
 drivers/scsi/lpfc/lpfc_init.c    |  52 +++---
 drivers/scsi/lpfc/lpfc_mbox.c    |   7 +-
 drivers/scsi/lpfc/lpfc_nvme.c    |  45 +++--
 drivers/scsi/lpfc/lpfc_nvmet.c   | 349 +++++++++++++++++++++++++++++++--------
 drivers/scsi/lpfc/lpfc_nvmet.h   |  10 +-
 drivers/scsi/lpfc/lpfc_sli.c     |   7 +-
 drivers/scsi/lpfc/lpfc_sli4.h    |   2 +-
 10 files changed, 412 insertions(+), 125 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_crtn.h b/drivers/scsi/lpfc/lpfc_crtn.h
index d859aff..24da922 100644
--- a/drivers/scsi/lpfc/lpfc_crtn.h
+++ b/drivers/scsi/lpfc/lpfc_crtn.h
@@ -24,6 +24,7 @@ typedef int (*node_filter)(struct lpfc_nodelist *, void *);
 
 struct fc_rport;
 struct fc_frame_header;
+struct lpfc_nvmet_rcv_ctx;
 void lpfc_down_link(struct lpfc_hba *, LPFC_MBOXQ_t *);
 void lpfc_sli_read_link_ste(struct lpfc_hba *);
 void lpfc_dump_mem(struct lpfc_hba *, LPFC_MBOXQ_t *, uint16_t, uint16_t);
@@ -245,6 +246,10 @@ struct hbq_dmabuf *lpfc_sli4_rb_alloc(struct lpfc_hba *);
 void lpfc_sli4_rb_free(struct lpfc_hba *, struct hbq_dmabuf *);
 struct rqb_dmabuf *lpfc_sli4_nvmet_alloc(struct lpfc_hba *phba);
 void lpfc_sli4_nvmet_free(struct lpfc_hba *phba, struct rqb_dmabuf *dmab);
+void lpfc_nvmet_rq_post(struct lpfc_hba *phba, struct lpfc_nvmet_rcv_ctx *ctxp,
+			struct lpfc_dmabuf *mp);
+int lpfc_nvmet_rcv_unsol_abort(struct lpfc_vport *vport,
+			       struct fc_frame_header *fc_hdr);
 void lpfc_sli4_build_dflt_fcf_record(struct lpfc_hba *, struct fcf_record *,
 			uint16_t);
 int lpfc_sli4_rq_put(struct lpfc_queue *hq, struct lpfc_queue *dq,
@@ -302,6 +307,8 @@ int lpfc_sli_check_eratt(struct lpfc_hba *);
 void lpfc_sli_handle_slow_ring_event(struct lpfc_hba *,
 				    struct lpfc_sli_ring *, uint32_t);
 void lpfc_sli4_handle_received_buffer(struct lpfc_hba *, struct hbq_dmabuf *);
+void lpfc_sli4_seq_abort_rsp(struct lpfc_vport *vport,
+			     struct fc_frame_header *fc_hdr, bool aborted);
 void lpfc_sli_def_mbox_cmpl(struct lpfc_hba *, LPFC_MBOXQ_t *);
 void lpfc_sli4_unreg_rpi_cmpl_clr(struct lpfc_hba *, LPFC_MBOXQ_t *);
 int lpfc_sli_issue_iocb(struct lpfc_hba *, uint32_t,
diff --git a/drivers/scsi/lpfc/lpfc_debugfs.c b/drivers/scsi/lpfc/lpfc_debugfs.c
index 55a8d8f..4d6cd7a 100644
--- a/drivers/scsi/lpfc/lpfc_debugfs.c
+++ b/drivers/scsi/lpfc/lpfc_debugfs.c
@@ -745,73 +745,102 @@ lpfc_debugfs_nvmestat_data(struct lpfc_vport *vport, char *buf, int size)
 {
 	struct lpfc_hba   *phba = vport->phba;
 	struct lpfc_nvmet_tgtport *tgtp;
+	struct lpfc_nvmet_rcv_ctx *ctxp, *next_ctxp;
 	int len = 0;
+	int cnt;
 
 	if (phba->nvmet_support) {
 		if (!phba->targetport)
 			return len;
 		tgtp = (struct lpfc_nvmet_tgtport *)phba->targetport->private;
-		len += snprintf(buf+len, size-len,
+		len += snprintf(buf + len, size - len,
 				"\nNVME Targetport Statistics\n");
 
-		len += snprintf(buf+len, size-len,
+		len += snprintf(buf + len, size - len,
 				"LS: Rcv %08x Drop %08x Abort %08x\n",
 				atomic_read(&tgtp->rcv_ls_req_in),
 				atomic_read(&tgtp->rcv_ls_req_drop),
 				atomic_read(&tgtp->xmt_ls_abort));
 		if (atomic_read(&tgtp->rcv_ls_req_in) !=
 		    atomic_read(&tgtp->rcv_ls_req_out)) {
-			len += snprintf(buf+len, size-len,
+			len += snprintf(buf + len, size - len,
 					"Rcv LS: in %08x != out %08x\n",
 					atomic_read(&tgtp->rcv_ls_req_in),
 					atomic_read(&tgtp->rcv_ls_req_out));
 		}
 
-		len += snprintf(buf+len, size-len,
+		len += snprintf(buf + len, size - len,
 				"LS: Xmt %08x Drop %08x Cmpl %08x Err %08x\n",
 				atomic_read(&tgtp->xmt_ls_rsp),
 				atomic_read(&tgtp->xmt_ls_drop),
 				atomic_read(&tgtp->xmt_ls_rsp_cmpl),
 				atomic_read(&tgtp->xmt_ls_rsp_error));
 
-		len += snprintf(buf+len, size-len,
+		len += snprintf(buf + len, size - len,
 				"FCP: Rcv %08x Drop %08x\n",
 				atomic_read(&tgtp->rcv_fcp_cmd_in),
 				atomic_read(&tgtp->rcv_fcp_cmd_drop));
 
 		if (atomic_read(&tgtp->rcv_fcp_cmd_in) !=
 		    atomic_read(&tgtp->rcv_fcp_cmd_out)) {
-			len += snprintf(buf+len, size-len,
+			len += snprintf(buf + len, size - len,
 					"Rcv FCP: in %08x != out %08x\n",
 					atomic_read(&tgtp->rcv_fcp_cmd_in),
 					atomic_read(&tgtp->rcv_fcp_cmd_out));
 		}
 
-		len += snprintf(buf+len, size-len,
-				"FCP Rsp: read %08x readrsp %08x write %08x rsp %08x\n",
+		len += snprintf(buf + len, size - len,
+				"FCP Rsp: read %08x readrsp %08x "
+				"write %08x rsp %08x\n",
 				atomic_read(&tgtp->xmt_fcp_read),
 				atomic_read(&tgtp->xmt_fcp_read_rsp),
 				atomic_read(&tgtp->xmt_fcp_write),
 				atomic_read(&tgtp->xmt_fcp_rsp));
 
-		len += snprintf(buf+len, size-len,
+		len += snprintf(buf + len, size - len,
 				"FCP Rsp: abort %08x drop %08x\n",
 				atomic_read(&tgtp->xmt_fcp_abort),
 				atomic_read(&tgtp->xmt_fcp_drop));
 
-		len += snprintf(buf+len, size-len,
+		len += snprintf(buf + len, size - len,
 				"FCP Rsp Cmpl: %08x err %08x drop %08x\n",
 				atomic_read(&tgtp->xmt_fcp_rsp_cmpl),
 				atomic_read(&tgtp->xmt_fcp_rsp_error),
 				atomic_read(&tgtp->xmt_fcp_rsp_drop));
 
-		len += snprintf(buf+len, size-len,
+		len += snprintf(buf + len, size - len,
 				"ABORT: Xmt %08x Err %08x Cmpl %08x",
 				atomic_read(&tgtp->xmt_abort_rsp),
 				atomic_read(&tgtp->xmt_abort_rsp_error),
 				atomic_read(&tgtp->xmt_abort_cmpl));
 
-		len +=  snprintf(buf+len, size-len, "\n");
+		len +=  snprintf(buf + len, size - len, "\n");
+
+		cnt = 0;
+		spin_lock(&phba->sli4_hba.abts_nvme_buf_list_lock);
+		list_for_each_entry_safe(ctxp, next_ctxp,
+				&phba->sli4_hba.lpfc_abts_nvmet_ctx_list,
+				list) {
+			cnt++;
+		}
+		spin_unlock(&phba->sli4_hba.abts_nvme_buf_list_lock);
+		if (cnt) {
+			len += snprintf(buf + len, size - len,
+					"ABORT: %d ctx entries\n", cnt);
+			spin_lock(&phba->sli4_hba.abts_nvme_buf_list_lock);
+			list_for_each_entry_safe(ctxp, next_ctxp,
+				    &phba->sli4_hba.lpfc_abts_nvmet_ctx_list,
+				    list) {
+				if (len >= (size - LPFC_DEBUG_OUT_LINE_SZ))
+					break;
+				len += snprintf(buf + len, size - len,
+						"Entry: oxid %x state %x "
+						"flag %x\n",
+						ctxp->oxid, ctxp->state,
+						ctxp->flag);
+			}
+			spin_unlock(&phba->sli4_hba.abts_nvme_buf_list_lock);
+		}
 	} else {
 		if (!(phba->cfg_enable_fc4_type & LPFC_ENABLE_NVME))
 			return len;
diff --git a/drivers/scsi/lpfc/lpfc_hw4.h b/drivers/scsi/lpfc/lpfc_hw4.h
index 90499f9..1d12f2b 100644
--- a/drivers/scsi/lpfc/lpfc_hw4.h
+++ b/drivers/scsi/lpfc/lpfc_hw4.h
@@ -2720,6 +2720,9 @@ struct lpfc_mbx_request_features {
 #define lpfc_mbx_rq_ftr_rq_ifip_SHIFT		7
 #define lpfc_mbx_rq_ftr_rq_ifip_MASK		0x00000001
 #define lpfc_mbx_rq_ftr_rq_ifip_WORD		word2
+#define lpfc_mbx_rq_ftr_rq_iaar_SHIFT		9
+#define lpfc_mbx_rq_ftr_rq_iaar_MASK		0x00000001
+#define lpfc_mbx_rq_ftr_rq_iaar_WORD		word2
 #define lpfc_mbx_rq_ftr_rq_perfh_SHIFT		11
 #define lpfc_mbx_rq_ftr_rq_perfh_MASK		0x00000001
 #define lpfc_mbx_rq_ftr_rq_perfh_WORD		word2
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 8acacdf..e084a66 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -42,6 +42,10 @@
 #include <scsi/scsi_device.h>
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_transport_fc.h>
+#include <scsi/scsi_tcq.h>
+#include <scsi/fc/fc_fs.h>
+
+#include <linux/nvme-fc-driver.h>
 
 #include "lpfc_hw4.h"
 #include "lpfc_hw.h"
@@ -52,6 +56,7 @@
 #include "lpfc.h"
 #include "lpfc_scsi.h"
 #include "lpfc_nvme.h"
+#include "lpfc_nvmet.h"
 #include "lpfc_logmsg.h"
 #include "lpfc_crtn.h"
 #include "lpfc_vport.h"
@@ -1022,8 +1027,10 @@ static int
 lpfc_hba_down_post_s4(struct lpfc_hba *phba)
 {
 	struct lpfc_scsi_buf *psb, *psb_next;
+	struct lpfc_nvmet_rcv_ctx *ctxp, *ctxp_next;
 	LIST_HEAD(aborts);
 	LIST_HEAD(nvme_aborts);
+	LIST_HEAD(nvmet_aborts);
 	unsigned long iflag = 0;
 	struct lpfc_sglq *sglq_entry = NULL;
 
@@ -1046,16 +1053,10 @@ lpfc_hba_down_post_s4(struct lpfc_hba *phba)
 	list_for_each_entry(sglq_entry,
 		&phba->sli4_hba.lpfc_abts_els_sgl_list, list)
 		sglq_entry->state = SGL_FREED;
-	list_for_each_entry(sglq_entry,
-		&phba->sli4_hba.lpfc_abts_nvmet_sgl_list, list)
-		sglq_entry->state = SGL_FREED;
 
 	list_splice_init(&phba->sli4_hba.lpfc_abts_els_sgl_list,
 			&phba->sli4_hba.lpfc_els_sgl_list);
 
-	if (phba->sli4_hba.nvme_wq)
-		list_splice_init(&phba->sli4_hba.lpfc_abts_nvmet_sgl_list,
-				 &phba->sli4_hba.lpfc_nvmet_sgl_list);
 
 	spin_unlock(&phba->sli4_hba.sgl_list_lock);
 	/* abts_scsi_buf_list_lock required because worker thread uses this
@@ -1072,6 +1073,8 @@ lpfc_hba_down_post_s4(struct lpfc_hba *phba)
 		spin_lock(&phba->sli4_hba.abts_nvme_buf_list_lock);
 		list_splice_init(&phba->sli4_hba.lpfc_abts_nvme_buf_list,
 				 &nvme_aborts);
+		list_splice_init(&phba->sli4_hba.lpfc_abts_nvmet_ctx_list,
+				 &nvmet_aborts);
 		spin_unlock(&phba->sli4_hba.abts_nvme_buf_list_lock);
 	}
 
@@ -1085,13 +1088,20 @@ lpfc_hba_down_post_s4(struct lpfc_hba *phba)
 	list_splice(&aborts, &phba->lpfc_scsi_buf_list_put);
 	spin_unlock_irqrestore(&phba->scsi_buf_list_put_lock, iflag);
 
-	list_for_each_entry_safe(psb, psb_next, &nvme_aborts, list) {
-		psb->pCmd = NULL;
-		psb->status = IOSTAT_SUCCESS;
+	if (phba->cfg_enable_fc4_type & LPFC_ENABLE_NVME) {
+		list_for_each_entry_safe(psb, psb_next, &nvme_aborts, list) {
+			psb->pCmd = NULL;
+			psb->status = IOSTAT_SUCCESS;
+		}
+		spin_lock_irqsave(&phba->nvme_buf_list_put_lock, iflag);
+		list_splice(&nvme_aborts, &phba->lpfc_nvme_buf_list_put);
+		spin_unlock_irqrestore(&phba->nvme_buf_list_put_lock, iflag);
+
+		list_for_each_entry_safe(ctxp, ctxp_next, &nvmet_aborts, list) {
+			ctxp->flag &= ~(LPFC_NVMET_XBUSY | LPFC_NVMET_ABORT_OP);
+			lpfc_nvmet_rq_post(phba, ctxp, &ctxp->rqb_buffer->hbuf);
+		}
 	}
-	spin_lock_irqsave(&phba->nvme_buf_list_put_lock, iflag);
-	list_splice(&nvme_aborts, &phba->lpfc_nvme_buf_list_put);
-	spin_unlock_irqrestore(&phba->nvme_buf_list_put_lock, iflag);
 
 	lpfc_sli4_free_sp_events(phba);
 	return 0;
@@ -5812,6 +5822,7 @@ lpfc_sli4_driver_resource_setup(struct lpfc_hba *phba)
 		/* Initialize the Abort nvme buffer list used by driver */
 		spin_lock_init(&phba->sli4_hba.abts_nvme_buf_list_lock);
 		INIT_LIST_HEAD(&phba->sli4_hba.lpfc_abts_nvme_buf_list);
+		INIT_LIST_HEAD(&phba->sli4_hba.lpfc_abts_nvmet_ctx_list);
 		/* Fast-path XRI aborted CQ Event work queue list */
 		INIT_LIST_HEAD(&phba->sli4_hba.sp_nvme_xri_aborted_work_queue);
 	}
@@ -6439,7 +6450,7 @@ lpfc_init_sgl_list(struct lpfc_hba *phba)
 	INIT_LIST_HEAD(&phba->sli4_hba.lpfc_els_sgl_list);
 	INIT_LIST_HEAD(&phba->sli4_hba.lpfc_abts_els_sgl_list);
 	INIT_LIST_HEAD(&phba->sli4_hba.lpfc_nvmet_sgl_list);
-	INIT_LIST_HEAD(&phba->sli4_hba.lpfc_abts_nvmet_sgl_list);
+	INIT_LIST_HEAD(&phba->sli4_hba.lpfc_abts_nvmet_ctx_list);
 
 	/* els xri-sgl book keeping */
 	phba->sli4_hba.els_xri_cnt = 0;
@@ -9966,17 +9977,19 @@ lpfc_sli4_xri_exchange_busy_wait(struct lpfc_hba *phba)
 {
 	int wait_time = 0;
 	int nvme_xri_cmpl = 1;
+	int nvmet_xri_cmpl = 1;
 	int fcp_xri_cmpl = 1;
 	int els_xri_cmpl = list_empty(&phba->sli4_hba.lpfc_abts_els_sgl_list);
-	int nvmet_xri_cmpl =
-			list_empty(&phba->sli4_hba.lpfc_abts_nvmet_sgl_list);
 
 	if (phba->cfg_enable_fc4_type & LPFC_ENABLE_FCP)
 		fcp_xri_cmpl =
 			list_empty(&phba->sli4_hba.lpfc_abts_scsi_buf_list);
-	if (phba->cfg_enable_fc4_type & LPFC_ENABLE_NVME)
+	if (phba->cfg_enable_fc4_type & LPFC_ENABLE_NVME) {
 		nvme_xri_cmpl =
 			list_empty(&phba->sli4_hba.lpfc_abts_nvme_buf_list);
+		nvmet_xri_cmpl =
+			list_empty(&phba->sli4_hba.lpfc_abts_nvmet_ctx_list);
+	}
 
 	while (!fcp_xri_cmpl || !els_xri_cmpl || !nvme_xri_cmpl ||
 	       !nvmet_xri_cmpl) {
@@ -10002,9 +10015,12 @@ lpfc_sli4_xri_exchange_busy_wait(struct lpfc_hba *phba)
 			msleep(LPFC_XRI_EXCH_BUSY_WAIT_T1);
 			wait_time += LPFC_XRI_EXCH_BUSY_WAIT_T1;
 		}
-		if (phba->cfg_enable_fc4_type & LPFC_ENABLE_NVME)
+		if (phba->cfg_enable_fc4_type & LPFC_ENABLE_NVME) {
 			nvme_xri_cmpl = list_empty(
 				&phba->sli4_hba.lpfc_abts_nvme_buf_list);
+			nvmet_xri_cmpl = list_empty(
+				&phba->sli4_hba.lpfc_abts_nvmet_ctx_list);
+		}
 
 		if (phba->cfg_enable_fc4_type & LPFC_ENABLE_FCP)
 			fcp_xri_cmpl = list_empty(
@@ -10013,8 +10029,6 @@ lpfc_sli4_xri_exchange_busy_wait(struct lpfc_hba *phba)
 		els_xri_cmpl =
 			list_empty(&phba->sli4_hba.lpfc_abts_els_sgl_list);
 
-		nvmet_xri_cmpl =
-			list_empty(&phba->sli4_hba.lpfc_abts_nvmet_sgl_list);
 	}
 }
 
diff --git a/drivers/scsi/lpfc/lpfc_mbox.c b/drivers/scsi/lpfc/lpfc_mbox.c
index a928f51..ce25a18 100644
--- a/drivers/scsi/lpfc/lpfc_mbox.c
+++ b/drivers/scsi/lpfc/lpfc_mbox.c
@@ -2083,9 +2083,12 @@ lpfc_request_features(struct lpfc_hba *phba, struct lpfcMboxq *mboxq)
 	if (phba->max_vpi && phba->cfg_enable_npiv)
 		bf_set(lpfc_mbx_rq_ftr_rq_npiv, &mboxq->u.mqe.un.req_ftrs, 1);
 
-	if (phba->nvmet_support)
+	if (phba->nvmet_support) {
 		bf_set(lpfc_mbx_rq_ftr_rq_mrqp, &mboxq->u.mqe.un.req_ftrs, 1);
-
+		/* iaab/iaar NOT set for now */
+		 bf_set(lpfc_mbx_rq_ftr_rq_iaab, &mboxq->u.mqe.un.req_ftrs, 0);
+		 bf_set(lpfc_mbx_rq_ftr_rq_iaar, &mboxq->u.mqe.un.req_ftrs, 0);
+	}
 	return;
 }
 
diff --git a/drivers/scsi/lpfc/lpfc_nvme.c b/drivers/scsi/lpfc/lpfc_nvme.c
index 1a83ade..a439a50 100644
--- a/drivers/scsi/lpfc/lpfc_nvme.c
+++ b/drivers/scsi/lpfc/lpfc_nvme.c
@@ -867,15 +867,18 @@ lpfc_nvme_io_cmd_wqe_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *pwqeIn,
 				break;
 			lpfc_printf_vlog(vport, KERN_ERR, LOG_NVME_IOERR,
 					 "6081 NVME Completion Protocol Error: "
-					 "status x%x result x%x placed x%x\n",
+					 "xri %x status x%x result x%x "
+					 "placed x%x\n",
+					 lpfc_ncmd->cur_iocbq.sli4_xritag,
 					 lpfc_ncmd->status, lpfc_ncmd->result,
 					 wcqe->total_data_placed);
 			break;
 		default:
 out_err:
 			lpfc_printf_vlog(vport, KERN_ERR, LOG_NVME_IOERR,
-					 "6072 NVME Completion Error: "
+					 "6072 NVME Completion Error: xri %x "
 					 "status x%x result x%x placed x%x\n",
+					 lpfc_ncmd->cur_iocbq.sli4_xritag,
 					 lpfc_ncmd->status, lpfc_ncmd->result,
 					 wcqe->total_data_placed);
 			nCmd->transferred_length = 0;
@@ -1428,7 +1431,7 @@ lpfc_nvme_fcp_abort(struct nvme_fc_local_port *pnvme_lport,
 	phba = vport->phba;
 
 	/* Announce entry to new IO submit field. */
-	lpfc_printf_vlog(vport, KERN_ERR, LOG_NVME_ABTS,
+	lpfc_printf_vlog(vport, KERN_INFO, LOG_NVME_ABTS,
 			 "6002 Abort Request to rport DID x%06x "
 			 "for nvme_fc_req %p\n",
 			 pnvme_rport->port_id,
@@ -1458,7 +1461,7 @@ lpfc_nvme_fcp_abort(struct nvme_fc_local_port *pnvme_lport,
 	/* The remote node has to be ready to send an abort. */
 	if ((ndlp->nlp_state != NLP_STE_MAPPED_NODE) &&
 	    !(ndlp->nlp_type & NLP_NVME_TARGET)) {
-		lpfc_printf_vlog(vport, KERN_ERR, LOG_NODE | LOG_NVME_ABTS,
+		lpfc_printf_vlog(vport, KERN_ERR, LOG_NVME_ABTS,
 				 "6048 rport %p, DID x%06x not ready for "
 				 "IO. State x%x, Type x%x\n",
 				 rport, pnvme_rport->port_id,
@@ -1473,7 +1476,7 @@ lpfc_nvme_fcp_abort(struct nvme_fc_local_port *pnvme_lport,
 	/* driver queued commands are in process of being flushed */
 	if (phba->hba_flag & HBA_NVME_IOQ_FLUSH) {
 		spin_unlock_irqrestore(&phba->hbalock, flags);
-		lpfc_printf_vlog(vport, KERN_ERR, LOG_NVME,
+		lpfc_printf_vlog(vport, KERN_ERR, LOG_NVME_ABTS,
 				 "6139 Driver in reset cleanup - flushing "
 				 "NVME Req now.  hba_flag x%x\n",
 				 phba->hba_flag);
@@ -1483,13 +1486,13 @@ lpfc_nvme_fcp_abort(struct nvme_fc_local_port *pnvme_lport,
 	lpfc_nbuf = (struct lpfc_nvme_buf *)pnvme_fcreq->private;
 	if (!lpfc_nbuf) {
 		spin_unlock_irqrestore(&phba->hbalock, flags);
-		lpfc_printf_vlog(vport, KERN_ERR, LOG_NVME,
+		lpfc_printf_vlog(vport, KERN_ERR, LOG_NVME_ABTS,
 				 "6140 NVME IO req has no matching lpfc nvme "
 				 "io buffer.  Skipping abort req.\n");
 		return;
 	} else if (!lpfc_nbuf->nvmeCmd) {
 		spin_unlock_irqrestore(&phba->hbalock, flags);
-		lpfc_printf_vlog(vport, KERN_ERR, LOG_NVME,
+		lpfc_printf_vlog(vport, KERN_ERR, LOG_NVME_ABTS,
 				 "6141 lpfc NVME IO req has no nvme_fcreq "
 				 "io buffer.  Skipping abort req.\n");
 		return;
@@ -1505,7 +1508,7 @@ lpfc_nvme_fcp_abort(struct nvme_fc_local_port *pnvme_lport,
 	 */
 	if (lpfc_nbuf->nvmeCmd != pnvme_fcreq) {
 		spin_unlock_irqrestore(&phba->hbalock, flags);
-		lpfc_printf_vlog(vport, KERN_ERR, LOG_NVME,
+		lpfc_printf_vlog(vport, KERN_ERR, LOG_NVME_ABTS,
 				 "6143 NVME req mismatch: "
 				 "lpfc_nbuf %p nvmeCmd %p, "
 				 "pnvme_fcreq %p.  Skipping Abort xri x%x\n",
@@ -1517,7 +1520,7 @@ lpfc_nvme_fcp_abort(struct nvme_fc_local_port *pnvme_lport,
 	/* Don't abort IOs no longer on the pending queue. */
 	if (!(nvmereq_wqe->iocb_flag & LPFC_IO_ON_TXCMPLQ)) {
 		spin_unlock_irqrestore(&phba->hbalock, flags);
-		lpfc_printf_vlog(vport, KERN_ERR, LOG_NVME,
+		lpfc_printf_vlog(vport, KERN_ERR, LOG_NVME_ABTS,
 				 "6142 NVME IO req %p not queued - skipping "
 				 "abort req xri x%x\n",
 				 pnvme_fcreq, nvmereq_wqe->sli4_xritag);
@@ -1531,7 +1534,7 @@ lpfc_nvme_fcp_abort(struct nvme_fc_local_port *pnvme_lport,
 	/* Outstanding abort is in progress */
 	if (nvmereq_wqe->iocb_flag & LPFC_DRIVER_ABORTED) {
 		spin_unlock_irqrestore(&phba->hbalock, flags);
-		lpfc_printf_vlog(vport, KERN_ERR, LOG_NVME,
+		lpfc_printf_vlog(vport, KERN_ERR, LOG_NVME_ABTS,
 				 "6144 Outstanding NVME I/O Abort Request "
 				 "still pending on nvme_fcreq %p, "
 				 "lpfc_ncmd %p xri x%x\n",
@@ -1543,7 +1546,7 @@ lpfc_nvme_fcp_abort(struct nvme_fc_local_port *pnvme_lport,
 	abts_buf = __lpfc_sli_get_iocbq(phba);
 	if (!abts_buf) {
 		spin_unlock_irqrestore(&phba->hbalock, flags);
-		lpfc_printf_vlog(vport, KERN_ERR, LOG_NVME,
+		lpfc_printf_vlog(vport, KERN_ERR, LOG_NVME_ABTS,
 				 "6136 No available abort wqes. Skipping "
 				 "Abts req for nvme_fcreq %p xri x%x\n",
 				 pnvme_fcreq, nvmereq_wqe->sli4_xritag);
@@ -1595,7 +1598,7 @@ lpfc_nvme_fcp_abort(struct nvme_fc_local_port *pnvme_lport,
 	ret_val = lpfc_sli4_issue_wqe(phba, LPFC_FCP_RING, abts_buf);
 	spin_unlock_irqrestore(&phba->hbalock, flags);
 	if (ret_val == IOCB_ERROR) {
-		lpfc_printf_vlog(vport, KERN_ERR, LOG_NVME,
+		lpfc_printf_vlog(vport, KERN_ERR, LOG_NVME_ABTS,
 				 "6137 Failed abts issue_wqe with status x%x "
 				 "for nvme_fcreq %p.\n",
 				 ret_val, pnvme_fcreq);
@@ -1603,7 +1606,7 @@ lpfc_nvme_fcp_abort(struct nvme_fc_local_port *pnvme_lport,
 		return;
 	}
 
-	lpfc_printf_vlog(vport, KERN_ERR, LOG_NVME,
+	lpfc_printf_vlog(vport, KERN_INFO, LOG_NVME_ABTS,
 			 "6138 Transport Abort NVME Request Issued for "
 			 "ox_id x%x on reqtag x%x\n",
 			 nvmereq_wqe->sli4_xritag,
@@ -2107,6 +2110,12 @@ lpfc_release_nvme_buf(struct lpfc_hba *phba, struct lpfc_nvme_buf *lpfc_ncmd)
 
 	lpfc_ncmd->nonsg_phys = 0;
 	if (lpfc_ncmd->flags & LPFC_SBUF_XBUSY) {
+		lpfc_printf_log(phba, KERN_INFO, LOG_NVME_ABTS,
+				"6310 XB release deferred for "
+				"ox_id x%x on reqtag x%x\n",
+				lpfc_ncmd->cur_iocbq.sli4_xritag,
+				lpfc_ncmd->cur_iocbq.iotag);
+
 		spin_lock_irqsave(&phba->sli4_hba.abts_nvme_buf_list_lock,
 					iflag);
 		lpfc_ncmd->nvmeCmd = NULL;
@@ -2548,6 +2557,12 @@ lpfc_sli4_nvme_xri_aborted(struct lpfc_hba *phba,
 					rxid, 1);
 				lpfc_sli4_abts_err_handler(phba, ndlp, axri);
 			}
+
+			lpfc_printf_log(phba, KERN_INFO, LOG_NVME_ABTS,
+					"6311 XRI Aborted xri x%x tag x%x "
+					"released\n",
+					xri, lpfc_ncmd->cur_iocbq.iotag);
+
 			lpfc_release_nvme_buf(phba, lpfc_ncmd);
 			if (rrq_empty)
 				lpfc_worker_wake_up(phba);
@@ -2556,4 +2571,8 @@ lpfc_sli4_nvme_xri_aborted(struct lpfc_hba *phba,
 	}
 	spin_unlock(&phba->sli4_hba.abts_nvme_buf_list_lock);
 	spin_unlock_irqrestore(&phba->hbalock, iflag);
+
+	lpfc_printf_log(phba, KERN_INFO, LOG_NVME_ABTS,
+			"6312 XRI Aborted xri x%x not found\n", xri);
+
 }
diff --git a/drivers/scsi/lpfc/lpfc_nvmet.c b/drivers/scsi/lpfc/lpfc_nvmet.c
index d0dda42..fe939e8 100644
--- a/drivers/scsi/lpfc/lpfc_nvmet.c
+++ b/drivers/scsi/lpfc/lpfc_nvmet.c
@@ -71,6 +71,26 @@ static int lpfc_nvmet_unsol_ls_issue_abort(struct lpfc_hba *,
 					   struct lpfc_nvmet_rcv_ctx *,
 					   uint32_t, uint16_t);
 
+void
+lpfc_nvmet_defer_release(struct lpfc_hba *phba, struct lpfc_nvmet_rcv_ctx *ctxp)
+{
+	unsigned long iflag;
+
+	lpfc_printf_log(phba, KERN_ERR, LOG_NVME_ABTS,
+			"6313 NVMET Defer ctx release xri x%x flg x%x\n",
+			ctxp->oxid, ctxp->flag);
+
+	spin_lock_irqsave(&phba->sli4_hba.abts_nvme_buf_list_lock, iflag);
+	if (ctxp->flag & LPFC_NVMET_CTX_RLS) {
+		spin_unlock_irqrestore(&phba->sli4_hba.abts_nvme_buf_list_lock,
+				       iflag);
+		return;
+	}
+	ctxp->flag |= LPFC_NVMET_CTX_RLS;
+	list_add_tail(&ctxp->list, &phba->sli4_hba.lpfc_abts_nvmet_ctx_list);
+	spin_unlock_irqrestore(&phba->sli4_hba.abts_nvme_buf_list_lock, iflag);
+}
+
 /**
  * lpfc_nvmet_xmt_ls_rsp_cmp - Completion handler for LS Response
  * @phba: Pointer to HBA context object.
@@ -139,6 +159,11 @@ lpfc_nvmet_rq_post(struct lpfc_hba *phba, struct lpfc_nvmet_rcv_ctx *ctxp,
 		   struct lpfc_dmabuf *mp)
 {
 	if (ctxp) {
+		if (ctxp->flag)
+			lpfc_printf_log(phba, KERN_INFO, LOG_NVME_ABTS,
+			"6314 rq_post ctx xri x%x flag x%x\n",
+			ctxp->oxid, ctxp->flag);
+
 		if (ctxp->txrdy) {
 			pci_pool_free(phba->txrdy_payload_pool, ctxp->txrdy,
 				      ctxp->txrdy_phys);
@@ -337,39 +362,55 @@ lpfc_nvmet_xmt_fcp_op_cmp(struct lpfc_hba *phba, struct lpfc_iocbq *cmdwqe,
 #endif
 
 	ctxp = cmdwqe->context2;
+	ctxp->flag &= ~LPFC_NVMET_IO_INP;
+
 	rsp = &ctxp->ctx.fcp_req;
 	op = rsp->op;
-	ctxp->flag &= ~LPFC_NVMET_IO_INP;
 
 	status = bf_get(lpfc_wcqe_c_status, wcqe);
 	result = wcqe->parameter;
 
-	if (!phba->targetport)
-		goto out;
+	if (phba->targetport)
+		tgtp = (struct lpfc_nvmet_tgtport *)phba->targetport->private;
+	else
+		tgtp = NULL;
 
 	lpfc_nvmeio_data(phba, "NVMET FCP CMPL: xri x%x op x%x status x%x\n",
 			 ctxp->oxid, op, status);
 
-	tgtp = (struct lpfc_nvmet_tgtport *)phba->targetport->private;
 	if (status) {
 		rsp->fcp_error = NVME_SC_DATA_XFER_ERROR;
 		rsp->transferred_length = 0;
-		atomic_inc(&tgtp->xmt_fcp_rsp_error);
+		if (tgtp)
+			atomic_inc(&tgtp->xmt_fcp_rsp_error);
+
+		/* pick up SLI4 exhange busy condition */
+		if (bf_get(lpfc_wcqe_c_xb, wcqe)) {
+			ctxp->flag |= LPFC_NVMET_XBUSY;
+
+			lpfc_printf_log(phba, KERN_INFO, LOG_NVME_ABTS,
+					"6315 IO Cmpl XBUSY: xri x%x: %x/%x\n",
+					ctxp->oxid, status, result);
+		} else {
+			ctxp->flag &= ~LPFC_NVMET_XBUSY;
+		}
+
 	} else {
 		rsp->fcp_error = NVME_SC_SUCCESS;
 		if (op == NVMET_FCOP_RSP)
 			rsp->transferred_length = rsp->rsplen;
 		else
 			rsp->transferred_length = rsp->transfer_length;
-		atomic_inc(&tgtp->xmt_fcp_rsp_cmpl);
+		if (tgtp)
+			atomic_inc(&tgtp->xmt_fcp_rsp_cmpl);
 	}
 
-out:
 	if ((op == NVMET_FCOP_READDATA_RSP) ||
 	    (op == NVMET_FCOP_RSP)) {
 		/* Sanity check */
 		ctxp->state = LPFC_NVMET_STE_DONE;
 		ctxp->entry_cnt++;
+
 #ifdef CONFIG_SCSI_LPFC_DEBUG_FS
 		if (phba->ktime_on) {
 			if (rsp->op == NVMET_FCOP_READDATA_RSP) {
@@ -542,10 +583,11 @@ lpfc_nvmet_xmt_fcp_op(struct nvmet_fc_target_port *tgtport,
 #endif
 
 	/* Sanity check */
-	if (ctxp->state == LPFC_NVMET_STE_ABORT) {
+	if ((ctxp->flag & LPFC_NVMET_ABTS_RCV) ||
+	    (ctxp->state == LPFC_NVMET_STE_ABORT)) {
 		atomic_inc(&lpfc_nvmep->xmt_fcp_drop);
 		lpfc_printf_log(phba, KERN_ERR, LOG_NVME_IOERR,
-				"6102 Bad state IO x%x aborted\n",
+				"6102 IO xri x%x aborted\n",
 				ctxp->oxid);
 		rc = -ENXIO;
 		goto aerr;
@@ -615,16 +657,27 @@ lpfc_nvmet_xmt_fcp_abort(struct nvmet_fc_target_port *tgtport,
 	struct lpfc_nvmet_rcv_ctx *ctxp =
 		container_of(req, struct lpfc_nvmet_rcv_ctx, ctx.fcp_req);
 	struct lpfc_hba *phba = ctxp->phba;
+	unsigned long flags;
 
 	lpfc_printf_log(phba, KERN_INFO, LOG_NVME_ABTS,
-			"6103 Abort op: oxri x%x %d cnt %d\n",
-			ctxp->oxid, ctxp->state, ctxp->entry_cnt);
+			"6103 Abort op: oxri x%x flg x%x cnt %d\n",
+			ctxp->oxid, ctxp->flag, ctxp->entry_cnt);
 
-	lpfc_nvmeio_data(phba, "NVMET FCP ABRT: xri x%x state x%x cnt x%x\n",
-			 ctxp->oxid, ctxp->state, ctxp->entry_cnt);
+	lpfc_nvmeio_data(phba, "NVMET FCP ABRT: "
+			 "xri x%x flg x%x cnt x%x\n",
+			 ctxp->oxid, ctxp->flag, ctxp->entry_cnt);
 
 	atomic_inc(&lpfc_nvmep->xmt_fcp_abort);
 	ctxp->entry_cnt++;
+	spin_lock_irqsave(&ctxp->ctxlock, flags);
+
+	/* Since iaab/iaar are NOT set, we need to check
+	 * if the firmware is in process of aborting IO
+	 */
+	if (ctxp->flag & LPFC_NVMET_XBUSY) {
+		spin_unlock_irqrestore(&ctxp->ctxlock, flags);
+		return;
+	}
 	ctxp->flag |= LPFC_NVMET_ABORT_OP;
 	if (ctxp->flag & LPFC_NVMET_IO_INP)
 		lpfc_nvmet_sol_fcp_issue_abort(phba, ctxp, ctxp->sid,
@@ -632,13 +685,13 @@ lpfc_nvmet_xmt_fcp_abort(struct nvmet_fc_target_port *tgtport,
 	else
 		lpfc_nvmet_unsol_fcp_issue_abort(phba, ctxp, ctxp->sid,
 						 ctxp->oxid);
+	spin_unlock_irqrestore(&ctxp->ctxlock, flags);
 }
 
 static void
 lpfc_nvmet_xmt_fcp_release(struct nvmet_fc_target_port *tgtport,
 			   struct nvmefc_tgt_fcp_req *rsp)
 {
-	struct lpfc_nvmet_tgtport *lpfc_nvmep = tgtport->private;
 	struct lpfc_nvmet_rcv_ctx *ctxp =
 		container_of(rsp, struct lpfc_nvmet_rcv_ctx, ctx.fcp_req);
 	struct lpfc_hba *phba = ctxp->phba;
@@ -646,27 +699,20 @@ lpfc_nvmet_xmt_fcp_release(struct nvmet_fc_target_port *tgtport,
 	bool aborting = false;
 
 	spin_lock_irqsave(&ctxp->ctxlock, flags);
-	if (ctxp->flag & LPFC_NVMET_ABORT_OP) {
+	if ((ctxp->flag & LPFC_NVMET_ABORT_OP) ||
+	    (ctxp->flag & LPFC_NVMET_XBUSY)) {
 		aborting = true;
-		ctxp->flag |= LPFC_NVMET_CTX_RLS;
-	}
-	spin_unlock_irqrestore(&ctxp->ctxlock, flags);
-
-	if (aborting)
 		/* let the abort path do the real release */
-		return;
-
-	/* Sanity check */
-	if (ctxp->state != LPFC_NVMET_STE_DONE) {
-		atomic_inc(&lpfc_nvmep->xmt_fcp_drop);
-		lpfc_printf_log(phba, KERN_ERR, LOG_NVME_IOERR,
-				"6117 Bad state IO x%x aborted\n",
-				ctxp->oxid);
+		lpfc_nvmet_defer_release(phba, ctxp);
 	}
+	spin_unlock_irqrestore(&ctxp->ctxlock, flags);
 
 	lpfc_nvmeio_data(phba, "NVMET FCP FREE: xri x%x ste %d\n", ctxp->oxid,
 			 ctxp->state, 0);
 
+	if (aborting)
+		return;
+
 	lpfc_nvmet_rq_post(phba, ctxp, &ctxp->rqb_buffer->hbuf);
 }
 
@@ -801,7 +847,122 @@ void
 lpfc_sli4_nvmet_xri_aborted(struct lpfc_hba *phba,
 			    struct sli4_wcqe_xri_aborted *axri)
 {
-	/* TODO: work in progress */
+	uint16_t xri = bf_get(lpfc_wcqe_xa_xri, axri);
+	uint16_t rxid = bf_get(lpfc_wcqe_xa_remote_xid, axri);
+	struct lpfc_nvmet_rcv_ctx *ctxp, *next_ctxp;
+	struct lpfc_nodelist *ndlp;
+	unsigned long iflag = 0;
+	int rrq_empty = 0;
+	bool released = false;
+
+	lpfc_printf_log(phba, KERN_INFO, LOG_NVME_ABTS,
+			"6317 XB aborted xri x%x rxid x%x\n", xri, rxid);
+
+	if (!(phba->cfg_enable_fc4_type & LPFC_ENABLE_NVME))
+		return;
+	spin_lock_irqsave(&phba->hbalock, iflag);
+	spin_lock(&phba->sli4_hba.abts_nvme_buf_list_lock);
+	list_for_each_entry_safe(ctxp, next_ctxp,
+				 &phba->sli4_hba.lpfc_abts_nvmet_ctx_list,
+				 list) {
+		if (ctxp->rqb_buffer->sglq->sli4_xritag == xri) {
+			/* Check if we already received a free context call
+			 * and we have completed processing an abort situation.
+			 */
+			if ((ctxp->flag & LPFC_NVMET_CTX_RLS) &&
+			    !(ctxp->flag & LPFC_NVMET_ABORT_OP)) {
+				list_del(&ctxp->list);
+				released = true;
+			}
+			ctxp->flag &= ~LPFC_NVMET_XBUSY;
+			spin_unlock(
+				&phba->sli4_hba.abts_nvme_buf_list_lock);
+
+			rrq_empty = list_empty(&phba->active_rrq_list);
+			spin_unlock_irqrestore(&phba->hbalock, iflag);
+			ndlp = lpfc_findnode_did(phba->pport, ctxp->sid);
+			if (ndlp && NLP_CHK_NODE_ACT(ndlp) &&
+			    ((ndlp->nlp_state == NLP_STE_UNMAPPED_NODE) ||
+			    (ndlp->nlp_state == NLP_STE_MAPPED_NODE))) {
+				lpfc_set_rrq_active(
+					phba, ndlp,
+					ctxp->rqb_buffer->sglq->sli4_lxritag,
+					rxid, 1);
+				lpfc_sli4_abts_err_handler(phba, ndlp, axri);
+			}
+
+			lpfc_printf_log(phba, KERN_INFO, LOG_NVME_ABTS,
+					"6318 XB aborted %x flg x%x (%x)\n",
+					ctxp->oxid, ctxp->flag, released);
+			if (released)
+				lpfc_nvmet_rq_post(phba, ctxp,
+						   &ctxp->rqb_buffer->hbuf);
+			if (rrq_empty)
+				lpfc_worker_wake_up(phba);
+			return;
+		}
+	}
+	spin_unlock(&phba->sli4_hba.abts_nvme_buf_list_lock);
+	spin_unlock_irqrestore(&phba->hbalock, iflag);
+}
+
+int
+lpfc_nvmet_rcv_unsol_abort(struct lpfc_vport *vport,
+			   struct fc_frame_header *fc_hdr)
+
+{
+#if (IS_ENABLED(CONFIG_NVME_TARGET_FC))
+	struct lpfc_hba *phba = vport->phba;
+	struct lpfc_nvmet_rcv_ctx *ctxp, *next_ctxp;
+	struct nvmefc_tgt_fcp_req *rsp;
+	uint16_t xri;
+	unsigned long iflag = 0;
+
+	xri = be16_to_cpu(fc_hdr->fh_ox_id);
+
+	spin_lock_irqsave(&phba->hbalock, iflag);
+	spin_lock(&phba->sli4_hba.abts_nvme_buf_list_lock);
+	list_for_each_entry_safe(ctxp, next_ctxp,
+				 &phba->sli4_hba.lpfc_abts_nvmet_ctx_list,
+				 list) {
+		if (ctxp->rqb_buffer->sglq->sli4_xritag == xri) {
+			spin_unlock(&phba->sli4_hba.abts_nvme_buf_list_lock);
+			spin_unlock_irqrestore(&phba->hbalock, iflag);
+
+			spin_lock_irqsave(&ctxp->ctxlock, iflag);
+			ctxp->flag |= LPFC_NVMET_ABTS_RCV;
+			spin_unlock_irqrestore(&ctxp->ctxlock, iflag);
+
+			lpfc_nvmeio_data(phba,
+					 "NVMET ABTS RCV: "
+					 "xri x%x CPU %02x rjt %d\n",
+					 xri, smp_processor_id(), 0);
+
+			lpfc_printf_log(phba, KERN_INFO, LOG_NVME_ABTS,
+					"6319 NVMET Rcv ABTS:acc xri x%x\n",
+					xri);
+
+			rsp = &ctxp->ctx.fcp_req;
+			nvmet_fc_rcv_fcp_abort(phba->targetport, rsp);
+
+			/* Respond with BA_ACC accordingly */
+			lpfc_sli4_seq_abort_rsp(vport, fc_hdr, 1);
+			return 0;
+		}
+	}
+	spin_unlock(&phba->sli4_hba.abts_nvme_buf_list_lock);
+	spin_unlock_irqrestore(&phba->hbalock, iflag);
+
+	lpfc_nvmeio_data(phba, "NVMET ABTS RCV: xri x%x CPU %02x rjt %d\n",
+			 xri, smp_processor_id(), 1);
+
+	lpfc_printf_log(phba, KERN_INFO, LOG_NVME_ABTS,
+			"6320 NVMET Rcv ABTS:rjt xri x%x\n", xri);
+
+	/* Respond with BA_RJT accordingly */
+	lpfc_sli4_seq_abort_rsp(vport, fc_hdr, 0);
+	return 0;
+#endif
 }
 
 void
@@ -1655,18 +1816,27 @@ lpfc_nvmet_sol_fcp_abort_cmp(struct lpfc_hba *phba, struct lpfc_iocbq *cmdwqe,
 	tgtp = (struct lpfc_nvmet_tgtport *)phba->targetport->private;
 	atomic_inc(&tgtp->xmt_abort_cmpl);
 
-	lpfc_printf_log(phba, KERN_ERR, LOG_NVME_ABTS,
-			"6165 Abort cmpl: xri x%x WCQE: %08x %08x %08x %08x\n",
-			ctxp->oxid, wcqe->word0, wcqe->total_data_placed,
-			result, wcqe->word3);
-
 	ctxp->state = LPFC_NVMET_STE_DONE;
+
+	/* Check if we already received a free context call
+	 * and we have completed processing an abort situation.
+	 */
 	spin_lock_irqsave(&ctxp->ctxlock, flags);
-	if (ctxp->flag & LPFC_NVMET_CTX_RLS)
+	if ((ctxp->flag & LPFC_NVMET_CTX_RLS) &&
+	    !(ctxp->flag & LPFC_NVMET_XBUSY)) {
+		list_del(&ctxp->list);
 		released = true;
+	}
 	ctxp->flag &= ~LPFC_NVMET_ABORT_OP;
 	spin_unlock_irqrestore(&ctxp->ctxlock, flags);
 
+	lpfc_printf_log(phba, KERN_ERR, LOG_NVME_ABTS,
+			"6165 ABORT cmpl: xri x%x flg x%x (%d) "
+			"WCQE: %08x %08x %08x %08x\n",
+			ctxp->oxid, ctxp->flag, released,
+			wcqe->word0, wcqe->total_data_placed,
+			result, wcqe->word3);
+
 	/*
 	 * if transport has released ctx, then can reuse it. Otherwise,
 	 * will be recycled by transport release call.
@@ -1677,10 +1847,15 @@ lpfc_nvmet_sol_fcp_abort_cmp(struct lpfc_hba *phba, struct lpfc_iocbq *cmdwqe,
 	cmdwqe->context2 = NULL;
 	cmdwqe->context3 = NULL;
 	lpfc_sli_release_iocbq(phba, cmdwqe);
+
+	/* Since iaab/iaar are NOT set, there is no work left.
+	 * For LPFC_NVMET_XBUSY, lpfc_sli4_nvmet_xri_aborted
+	 * should have been called already.
+	 */
 }
 
 /**
- * lpfc_nvmet_xmt_fcp_abort_cmp - Completion handler for ABTS
+ * lpfc_nvmet_unsol_fcp_abort_cmp - Completion handler for ABTS
  * @phba: Pointer to HBA context object.
  * @cmdwqe: Pointer to driver command WQE object.
  * @wcqe: Pointer to driver response CQE object.
@@ -1690,8 +1865,8 @@ lpfc_nvmet_sol_fcp_abort_cmp(struct lpfc_hba *phba, struct lpfc_iocbq *cmdwqe,
  * The function frees memory resources used for the NVME commands.
  **/
 static void
-lpfc_nvmet_xmt_fcp_abort_cmp(struct lpfc_hba *phba, struct lpfc_iocbq *cmdwqe,
-			     struct lpfc_wcqe_complete *wcqe)
+lpfc_nvmet_unsol_fcp_abort_cmp(struct lpfc_hba *phba, struct lpfc_iocbq *cmdwqe,
+			       struct lpfc_wcqe_complete *wcqe)
 {
 	struct lpfc_nvmet_rcv_ctx *ctxp;
 	struct lpfc_nvmet_tgtport *tgtp;
@@ -1706,35 +1881,54 @@ lpfc_nvmet_xmt_fcp_abort_cmp(struct lpfc_hba *phba, struct lpfc_iocbq *cmdwqe,
 	tgtp = (struct lpfc_nvmet_tgtport *)phba->targetport->private;
 	atomic_inc(&tgtp->xmt_abort_cmpl);
 
+	if (!ctxp) {
+		lpfc_printf_log(phba, KERN_INFO, LOG_NVME_ABTS,
+				"6070 ABTS cmpl: WCQE: %08x %08x %08x %08x\n",
+				wcqe->word0, wcqe->total_data_placed,
+				result, wcqe->word3);
+		return;
+	}
+
+	/* Sanity check */
+	if (ctxp->state != LPFC_NVMET_STE_ABORT) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_NVME_ABTS,
+				"6112 ABTS Wrong state:%d oxid x%x\n",
+				ctxp->state, ctxp->oxid);
+	}
+
+	/* Check if we already received a free context call
+	 * and we have completed processing an abort situation.
+	 */
+	ctxp->state = LPFC_NVMET_STE_DONE;
+	spin_lock_irqsave(&ctxp->ctxlock, flags);
+	if ((ctxp->flag & LPFC_NVMET_CTX_RLS) &&
+	    !(ctxp->flag & LPFC_NVMET_XBUSY)) {
+		list_del(&ctxp->list);
+		released = true;
+	}
+	ctxp->flag &= ~LPFC_NVMET_ABORT_OP;
+	spin_unlock_irqrestore(&ctxp->ctxlock, flags);
+
 	lpfc_printf_log(phba, KERN_INFO, LOG_NVME_ABTS,
-			"6070 Abort cmpl: ctx %p WCQE: %08x %08x %08x %08x\n",
-			ctxp, wcqe->word0, wcqe->total_data_placed,
+			"6316 ABTS cmpl xri x%x flg x%x (%x) "
+			"WCQE: %08x %08x %08x %08x\n",
+			ctxp->oxid, ctxp->flag, released,
+			wcqe->word0, wcqe->total_data_placed,
 			result, wcqe->word3);
+	/*
+	 * if transport has released ctx, then can reuse it. Otherwise,
+	 * will be recycled by transport release call.
+	 */
+	if (released)
+		lpfc_nvmet_rq_post(phba, ctxp, &ctxp->rqb_buffer->hbuf);
 
-	if (ctxp) {
-		/* Sanity check */
-		if (ctxp->state != LPFC_NVMET_STE_ABORT) {
-			lpfc_printf_log(phba, KERN_ERR, LOG_NVME_ABTS,
-					"6112 ABORT Wrong state:%d oxid x%x\n",
-					ctxp->state, ctxp->oxid);
-		}
-		ctxp->state = LPFC_NVMET_STE_DONE;
-		spin_lock_irqsave(&ctxp->ctxlock, flags);
-		if (ctxp->flag & LPFC_NVMET_CTX_RLS)
-			released = true;
-		ctxp->flag &= ~LPFC_NVMET_ABORT_OP;
-		spin_unlock_irqrestore(&ctxp->ctxlock, flags);
-
-		/*
-		 * if transport has released ctx, then can reuse it. Otherwise,
-		 * will be recycled by transport release call.
-		 */
-		if (released)
-			lpfc_nvmet_rq_post(phba, ctxp, &ctxp->rqb_buffer->hbuf);
+	cmdwqe->context2 = NULL;
+	cmdwqe->context3 = NULL;
 
-		cmdwqe->context2 = NULL;
-		cmdwqe->context3 = NULL;
-	}
+	/* Since iaab/iaar are NOT set, there is no work left.
+	 * For LPFC_NVMET_XBUSY, lpfc_sli4_nvmet_xri_aborted
+	 * should have been called already.
+	 */
 }
 
 /**
@@ -1787,10 +1981,14 @@ lpfc_nvmet_unsol_issue_abort(struct lpfc_hba *phba,
 	struct lpfc_nodelist *ndlp;
 
 	lpfc_printf_log(phba, KERN_INFO, LOG_NVME_ABTS,
-			"6067 Abort: sid %x xri x%x/x%x\n",
+			"6067 ABTS: sid %x xri x%x/x%x\n",
 			sid, xri, ctxp->wqeq->sli4_xritag);
 
 	tgtp = (struct lpfc_nvmet_tgtport *)phba->targetport->private;
+	if (!ctxp->wqeq) {
+		ctxp->wqeq = ctxp->rqb_buffer->iocbq;
+		ctxp->wqeq->hba_wqidx = 0;
+	}
 
 	ndlp = lpfc_findnode_did(phba->pport, sid);
 	if (!ndlp || !NLP_CHK_NODE_ACT(ndlp) ||
@@ -1896,10 +2094,11 @@ lpfc_nvmet_sol_fcp_issue_abort(struct lpfc_hba *phba,
 	    (ndlp->nlp_state != NLP_STE_MAPPED_NODE))) {
 		atomic_inc(&tgtp->xmt_abort_rsp_error);
 		lpfc_printf_log(phba, KERN_WARNING, LOG_NVME_ABTS,
-				"6160 Drop ABTS - wrong NDLP state x%x.\n",
+				"6160 Drop ABORT - wrong NDLP state x%x.\n",
 				(ndlp) ? ndlp->nlp_state : NLP_STE_MAX_STATE);
 
 		/* No failure to an ABTS request. */
+		ctxp->flag &= ~LPFC_NVMET_ABORT_OP;
 		return 0;
 	}
 
@@ -1907,9 +2106,10 @@ lpfc_nvmet_sol_fcp_issue_abort(struct lpfc_hba *phba,
 	ctxp->abort_wqeq = lpfc_sli_get_iocbq(phba);
 	if (!ctxp->abort_wqeq) {
 		lpfc_printf_log(phba, KERN_WARNING, LOG_NVME_ABTS,
-				"6161 Abort failed: No wqeqs: "
+				"6161 ABORT failed: No wqeqs: "
 				"xri: x%x\n", ctxp->oxid);
 		/* No failure to an ABTS request. */
+		ctxp->flag &= ~LPFC_NVMET_ABORT_OP;
 		return 0;
 	}
 	abts_wqeq = ctxp->abort_wqeq;
@@ -1917,8 +2117,8 @@ lpfc_nvmet_sol_fcp_issue_abort(struct lpfc_hba *phba,
 	ctxp->state = LPFC_NVMET_STE_ABORT;
 
 	/* Announce entry to new IO submit field. */
-	lpfc_printf_log(phba, KERN_ERR, LOG_NVME_ABTS,
-			"6162 Abort Request to rport DID x%06x "
+	lpfc_printf_log(phba, KERN_INFO, LOG_NVME_ABTS,
+			"6162 ABORT Request to rport DID x%06x "
 			"for xri x%x x%x\n",
 			ctxp->sid, ctxp->oxid, ctxp->wqeq->sli4_xritag);
 
@@ -1934,6 +2134,7 @@ lpfc_nvmet_sol_fcp_issue_abort(struct lpfc_hba *phba,
 				"NVME Req now. hba_flag x%x oxid x%x\n",
 				phba->hba_flag, ctxp->oxid);
 		lpfc_sli_release_iocbq(phba, abts_wqeq);
+		ctxp->flag &= ~LPFC_NVMET_ABORT_OP;
 		return 0;
 	}
 
@@ -1945,6 +2146,7 @@ lpfc_nvmet_sol_fcp_issue_abort(struct lpfc_hba *phba,
 				"still pending on oxid x%x\n",
 				ctxp->oxid);
 		lpfc_sli_release_iocbq(phba, abts_wqeq);
+		ctxp->flag &= ~LPFC_NVMET_ABORT_OP;
 		return 0;
 	}
 
@@ -1992,9 +2194,10 @@ lpfc_nvmet_sol_fcp_issue_abort(struct lpfc_hba *phba,
 	if (rc == WQE_SUCCESS)
 		return 0;
 
+	ctxp->flag &= ~LPFC_NVMET_ABORT_OP;
 	lpfc_sli_release_iocbq(phba, abts_wqeq);
-	lpfc_printf_log(phba, KERN_ERR, LOG_NVME,
-			"6166 Failed abts issue_wqe with status x%x "
+	lpfc_printf_log(phba, KERN_ERR, LOG_NVME_ABTS,
+			"6166 Failed ABORT issue_wqe with status x%x "
 			"for oxid x%x.\n",
 			rc, ctxp->oxid);
 	return 1;
@@ -2023,8 +2226,8 @@ lpfc_nvmet_unsol_fcp_issue_abort(struct lpfc_hba *phba,
 
 	spin_lock_irqsave(&phba->hbalock, flags);
 	abts_wqeq = ctxp->wqeq;
-	abts_wqeq->wqe_cmpl = lpfc_nvmet_xmt_fcp_abort_cmp;
-	abts_wqeq->iocb_cmpl = 0;
+	abts_wqeq->wqe_cmpl = lpfc_nvmet_unsol_fcp_abort_cmp;
+	abts_wqeq->iocb_cmpl = NULL;
 	abts_wqeq->iocb_flag |= LPFC_IO_NVMET;
 	rc = lpfc_sli4_issue_wqe(phba, LPFC_FCP_RING, abts_wqeq);
 	spin_unlock_irqrestore(&phba->hbalock, flags);
@@ -2034,7 +2237,7 @@ lpfc_nvmet_unsol_fcp_issue_abort(struct lpfc_hba *phba,
 	}
 
 aerr:
-	lpfc_nvmet_rq_post(phba, ctxp, &ctxp->rqb_buffer->hbuf);
+	ctxp->flag &= ~LPFC_NVMET_ABORT_OP;
 	atomic_inc(&tgtp->xmt_abort_rsp_error);
 	lpfc_printf_log(phba, KERN_WARNING, LOG_NVME_ABTS,
 			"6135 Failed to Issue ABTS for oxid x%x. Status x%x\n",
diff --git a/drivers/scsi/lpfc/lpfc_nvmet.h b/drivers/scsi/lpfc/lpfc_nvmet.h
index d8bac4c..128759f 100644
--- a/drivers/scsi/lpfc/lpfc_nvmet.h
+++ b/drivers/scsi/lpfc/lpfc_nvmet.h
@@ -75,6 +75,7 @@ struct lpfc_nvmet_rcv_ctx {
 		struct nvmefc_tgt_ls_req ls_req;
 		struct nvmefc_tgt_fcp_req fcp_req;
 	} ctx;
+	struct list_head list;
 	struct lpfc_hba *phba;
 	struct lpfc_iocbq *wqeq;
 	struct lpfc_iocbq *abort_wqeq;
@@ -96,10 +97,11 @@ struct lpfc_nvmet_rcv_ctx {
 #define LPFC_NVMET_STE_RSP		4
 #define LPFC_NVMET_STE_DONE		5
 	uint16_t flag;
-#define LPFC_NVMET_IO_INP		0x1
-#define LPFC_NVMET_ABORT_OP		0x2
-#define LPFC_NVMET_CTX_RLS		0x4
-
+#define LPFC_NVMET_IO_INP		0x1  /* IO is in progress on exchange */
+#define LPFC_NVMET_ABORT_OP		0x2  /* Abort WQE issued on exchange */
+#define LPFC_NVMET_XBUSY		0x4  /* XB bit set on IO cmpl */
+#define LPFC_NVMET_CTX_RLS		0x8  /* ctx free requested */
+#define LPFC_NVMET_ABTS_RCV		0x10  /* ABTS received on exchange */
 	struct rqb_dmabuf *rqb_buffer;
 
 #ifdef CONFIG_SCSI_LPFC_DEBUG_FS
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index a6adc2b..cf19f49 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -16521,7 +16521,7 @@ lpfc_sli4_xri_inrange(struct lpfc_hba *phba,
  * This function sends a basic response to a previous unsol sequence abort
  * event after aborting the sequence handling.
  **/
-static void
+void
 lpfc_sli4_seq_abort_rsp(struct lpfc_vport *vport,
 			struct fc_frame_header *fc_hdr, bool aborted)
 {
@@ -16697,6 +16697,11 @@ lpfc_sli4_handle_unsol_abort(struct lpfc_vport *vport,
 	}
 	lpfc_in_buf_free(phba, &dmabuf->dbuf);
 
+	if (phba->nvmet_support) {
+		lpfc_nvmet_rcv_unsol_abort(vport, &fc_hdr);
+		return;
+	}
+
 	/* Respond with BA_ACC or BA_RJT accordingly */
 	lpfc_sli4_seq_abort_rsp(vport, &fc_hdr, aborted);
 }
diff --git a/drivers/scsi/lpfc/lpfc_sli4.h b/drivers/scsi/lpfc/lpfc_sli4.h
index 710458c..da46471 100644
--- a/drivers/scsi/lpfc/lpfc_sli4.h
+++ b/drivers/scsi/lpfc/lpfc_sli4.h
@@ -620,7 +620,7 @@ struct lpfc_sli4_hba {
 	struct list_head lpfc_els_sgl_list;
 	struct list_head lpfc_abts_els_sgl_list;
 	struct list_head lpfc_nvmet_sgl_list;
-	struct list_head lpfc_abts_nvmet_sgl_list;
+	struct list_head lpfc_abts_nvmet_ctx_list;
 	struct list_head lpfc_abts_scsi_buf_list;
 	struct list_head lpfc_abts_nvme_buf_list;
 	struct lpfc_sglq **lpfc_sglq_active_list;
-- 
2.1.0
