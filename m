From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH 08/22] qla2xxx: Refactore target code to remove symbol dependency
Date: Tue, 6 Dec 2016 12:30:37 -0800
Message-ID: <1481056251-2310-9-git-send-email-himanshu.madhani@cavium.com>
References: <1481056251-2310-1-git-send-email-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-dm3nam03on0065.outbound.protection.outlook.com ([104.47.41.65]:3181
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752316AbcLFUbP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 6 Dec 2016 15:31:15 -0500
In-Reply-To: <1481056251-2310-1-git-send-email-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel@vger.kernel.org, nab@linux-iscsi.org
Cc: giridhar.malavali@cavium.com, linux-scsi@vger.kernel.org, himanshu.madhani@cavium.com

From: Quinn Tran <quinn.tran@cavium.com>

Following changes are done for target code

- Move cmd search out of qla to remove symbol dependency. The
  command list is held in se_session struct. This knowledege
  should be in tcm_qla2xxx.
- Move code that "convert Task Mgmt Command flags fr ATIO
  to TCM #define" from qla2xx driver to tcm_qla2xxx driver.
- Move percpu_ida_alloc/free to tcm_qla2xxx
- Refactor sess_kref handling as driver does not access se_session
  often. Remove se_session internal knowledge from qla2xxx as
  tcm_qla2xxx is the only one that have this knowledge.
- Move Command residual check from qla2xxx to tcm_qla2xxx
- qla2xxx currently access t_task_cdb/t_task_lba field in
  se_cmd struct. Remove access of TCM's private data struct.
- Remove direct access of scsi_status field in se_cmd
- Remove se_cmd from qlt_do_ctio_completion
- Remove se_cmd access in srr code section
- Move se_cmd struct outside of qla_tgt_cmd/qla_tgt_mgmt_cmd.
- To convert the pointer from one struct to another, new inline
  functions was added to take care of the convertion.
- Allow target driver to handle MBA_REJECTED_FCP_CMD AEN 8049. This
  will allow driver to gracefully handle reaching the exchange
  limit if desired. Ideally, we could track each NPORT
  that we are caching by LRU time and logout the oldest handle.
- Moves allocation/free mechanism for task management commands
  to TCM shim driver layer.
- Merge qla_tgt_sess into struct fc_port structures

Signed-off-by: Quinn Tran <quinn.tran@cavium.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
---
 drivers/scsi/qla2xxx/qla_bsg.c     |   8 +-
 drivers/scsi/qla2xxx/qla_def.h     |  34 ++
 drivers/scsi/qla2xxx/qla_dfs.c     |  10 +-
 drivers/scsi/qla2xxx/qla_gbl.h     |   1 +
 drivers/scsi/qla2xxx/qla_init.c    |  26 +-
 drivers/scsi/qla2xxx/qla_iocb.c    |   7 +-
 drivers/scsi/qla2xxx/qla_isr.c     |   8 +-
 drivers/scsi/qla2xxx/qla_mid.c     |   3 +
 drivers/scsi/qla2xxx/qla_mr.c      |  12 +-
 drivers/scsi/qla2xxx/qla_os.c      |  10 +-
 drivers/scsi/qla2xxx/qla_target.c  | 793 ++++++++++++-------------------------
 drivers/scsi/qla2xxx/qla_target.h  | 157 +++-----
 drivers/scsi/qla2xxx/tcm_qla2xxx.c | 588 ++++++++++++++++++++-------
 drivers/scsi/qla2xxx/tcm_qla2xxx.h |  14 +-
 14 files changed, 855 insertions(+), 816 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/qla_bsg.c
index 1bf8061..cdf0dce 100644
--- a/drivers/scsi/qla2xxx/qla_bsg.c
+++ b/drivers/scsi/qla2xxx/qla_bsg.c
@@ -61,7 +61,7 @@
 	if (sp->type == SRB_CT_CMD ||
 	    sp->type == SRB_FXIOCB_BCMD ||
 	    sp->type == SRB_ELS_CMD_HST)
-		kfree(sp->fcport);
+		qla2x00_free_fcport(sp->fcport);
 	qla2x00_rel_sp(vha, sp);
 }
 
@@ -409,7 +409,7 @@
 
 done_free_fcport:
 	if (bsg_request->msgcode == FC_BSG_RPT_ELS)
-		kfree(fcport);
+		qla2x00_free_fcport(fcport);
 done:
 	return rval;
 }
@@ -549,7 +549,7 @@
 	return rval;
 
 done_free_fcport:
-	kfree(fcport);
+	qla2x00_free_fcport(fcport);
 done_unmap_sg:
 	dma_unmap_sg(&ha->pdev->dev, bsg_job->request_payload.sg_list,
 		bsg_job->request_payload.sg_cnt, DMA_TO_DEVICE);
@@ -2052,7 +2052,7 @@
 	return rval;
 
 done_free_fcport:
-	kfree(fcport);
+	qla2x00_free_fcport(fcport);
 
 done_unmap_rsp_sg:
 	if (piocb_rqst->flags & SRB_FXDISC_RESP_DMA_VALID)
diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 1e3a3fa..07cda5a 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -1793,6 +1793,7 @@ struct crc_context {
 #define SS_RESIDUAL_OVER		BIT_10
 #define SS_SENSE_LEN_VALID		BIT_9
 #define SS_RESPONSE_INFO_LEN_VALID	BIT_8
+#define SS_SCSI_STATUS_BYTE	0xff
 
 #define SS_RESERVE_CONFLICT		(BIT_4 | BIT_3)
 #define SS_BUSY_CONDITION		BIT_3
@@ -2033,6 +2034,20 @@ struct mbx_entry {
 	FCT_TARGET
 } fc_port_type_t;
 
+typedef enum {
+	QLT_PLOGI_LINK_SAME_WWN,
+	QLT_PLOGI_LINK_CONFLICT,
+	QLT_PLOGI_LINK_MAX
+} qlt_plogi_link_t;
+
+typedef struct {
+	struct list_head	list;
+	u8		iocb[64];	/* imm_ntfy_from_isp */
+	port_id_t	id;
+	int		ref_count;
+} qlt_plogi_ack_t;
+
+
 /*
  * Fibre channel port structure.
  */
@@ -2046,6 +2061,25 @@ struct mbx_entry {
 	uint16_t loop_id;
 	uint16_t old_loop_id;
 
+	unsigned int conf_compl_supported:1;
+	unsigned int deleted:2;
+	unsigned int local:1;
+	unsigned int logout_on_delete:1;
+	unsigned int keep_nport_handle:1;
+	unsigned int send_els_logo:1;
+
+	unsigned char logout_completed;
+	int generation;
+
+	void *se_sess;
+	struct kref sess_kref;
+	struct qla_tgt *tgt;
+	unsigned long expires;
+	struct list_head del_list_entry;
+	struct work_struct free_work;
+
+	qlt_plogi_ack_t *plogi_link[QLT_PLOGI_LINK_MAX];
+
 	uint16_t tgt_id;
 	uint16_t old_tgt_id;
 
diff --git a/drivers/scsi/qla2xxx/qla_dfs.c b/drivers/scsi/qla2xxx/qla_dfs.c
index 08d7a05..6aa24ee 100644
--- a/drivers/scsi/qla2xxx/qla_dfs.c
+++ b/drivers/scsi/qla2xxx/qla_dfs.c
@@ -54,7 +54,7 @@
 	scsi_qla_host_t *vha = s->private;
 	struct qla_hw_data *ha = vha->hw;
 	unsigned long flags;
-	struct qla_tgt_sess *sess = NULL;
+	struct fc_port *sess = NULL;
 	struct qla_tgt *tgt= vha->vha_tgt.qla_tgt;
 
 	seq_printf(s, "%s\n",vha->host_str);
@@ -62,11 +62,11 @@
 		seq_printf(s, "Port ID   Port Name                Handle\n");
 
 		spin_lock_irqsave(&ha->tgt.sess_lock, flags);
-		list_for_each_entry(sess, &tgt->sess_list, sess_list_entry) {
+		list_for_each_entry(sess, &vha->vp_fcports, list) {
 			seq_printf(s, "%02x:%02x:%02x  %8phC  %d\n",
-					   sess->s_id.b.domain,sess->s_id.b.area,
-					   sess->s_id.b.al_pa,	sess->port_name,
-					   sess->loop_id);
+				sess->d_id.b.domain, sess->d_id.b.area,
+				sess->d_id.b.al_pa, sess->port_name,
+				sess->loop_id);
 		}
 		spin_unlock_irqrestore(&ha->tgt.sess_lock, flags);
 	}
diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index afa0116..13c4d51 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -158,6 +158,7 @@ extern struct scsi_qla_host *qla2x00_create_host(struct scsi_host_template *,
 extern void qla2x00_relogin(struct scsi_qla_host *);
 extern void qla2x00_do_work(struct scsi_qla_host *);
 extern void qla2x00_free_fcports(struct scsi_qla_host *);
+extern void qla2x00_free_fcport(fc_port_t *);
 
 extern void qla83xx_schedule_work(scsi_qla_host_t *, int);
 extern void qla83xx_service_idc_aen(struct work_struct *);
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 632d5f3..f3ea6b6 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -2998,6 +2998,12 @@ static void qla2xxx_nvram_wwn_from_ofw(scsi_qla_host_t *vha, nvram_t *nv)
 	return fcport;
 }
 
+void
+qla2x00_free_fcport(fc_port_t *fcport)
+{
+	kfree(fcport);
+}
+
 /*
  * qla2x00_configure_loop
  *      Updates Fibre Channel Device Database with what is actually on loop.
@@ -3293,7 +3299,7 @@ static void qla2xxx_nvram_wwn_from_ofw(scsi_qla_host_t *vha, nvram_t *nv)
 	}
 
 cleanup_allocation:
-	kfree(new_fcport);
+	qla2x00_free_fcport(new_fcport);
 
 	if (rval != QLA_SUCCESS) {
 		ql_dbg(ql_dbg_disc, vha, 0x201d,
@@ -3352,12 +3358,6 @@ static void qla2xxx_nvram_wwn_from_ofw(scsi_qla_host_t *vha, nvram_t *nv)
 		    "Unable to allocate fc remote port.\n");
 		return;
 	}
-	/*
-	 * Create target mode FC NEXUS in qla_target.c if target mode is
-	 * enabled..
-	 */
-
-	qlt_fc_port_added(vha, fcport);
 
 	spin_lock_irqsave(fcport->vha->host->host_lock, flags);
 	*((fc_port_t **)rport->dd_data) = fcport;
@@ -3407,12 +3407,6 @@ static void qla2xxx_nvram_wwn_from_ofw(scsi_qla_host_t *vha, nvram_t *nv)
 reg_port:
 	if (qla_ini_mode_enabled(vha))
 		qla2x00_reg_remote_port(vha, fcport);
-	else {
-		/*
-		 * Create target mode FC NEXUS in qla_target.c
-		 */
-		qlt_fc_port_added(vha, fcport);
-	}
 }
 
 /*
@@ -3677,7 +3671,7 @@ static void qla2xxx_nvram_wwn_from_ofw(scsi_qla_host_t *vha, nvram_t *nv)
 	/* Free all new device structures not processed. */
 	list_for_each_entry_safe(fcport, fcptemp, &new_fcports, list) {
 		list_del(&fcport->list);
-		kfree(fcport);
+		qla2x00_free_fcport(fcport);
 	}
 
 	if (rval) {
@@ -3803,7 +3797,7 @@ static void qla2xxx_nvram_wwn_from_ofw(scsi_qla_host_t *vha, nvram_t *nv)
 				list_for_each_entry_safe(fcport, fcptemp,
 				    new_fcports, list) {
 					list_del(&fcport->list);
-					kfree(fcport);
+					qla2x00_free_fcport(fcport);
 				}
 				rval = QLA_SUCCESS;
 				break;
@@ -3939,7 +3933,7 @@ static void qla2xxx_nvram_wwn_from_ofw(scsi_qla_host_t *vha, nvram_t *nv)
 		new_fcport->d_id.b24 = nxt_d_id.b24;
 	}
 
-	kfree(new_fcport);
+	qla2x00_free_fcport(new_fcport);
 
 	return (rval);
 }
diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index 58e49a3..61f4d21 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -2248,7 +2248,7 @@ struct fw_dif_context {
 	logio->control_flags =
 	    cpu_to_le16(LCF_COMMAND_LOGO|LCF_IMPL_LOGO);
 	if (!sp->fcport->tgt_session ||
-	    !sp->fcport->tgt_session->keep_nport_handle)
+	    !sp->fcport->keep_nport_handle)
 		logio->control_flags |= cpu_to_le16(LCF_FREE_NPORT);
 	logio->nport_handle = cpu_to_le16(sp->fcport->loop_id);
 	logio->port_id[0] = sp->fcport->d_id.b.al_pa;
@@ -2345,7 +2345,8 @@ struct fw_dif_context {
 	srb_t *sp = (srb_t *)data;
 	struct srb_iocb *elsio = &sp->u.iocb_cmd;
 
-	kfree(sp->fcport);
+	if (sp->fcport)
+		qla2x00_free_fcport(sp->fcport);
 
 	if (elsio->u.els_logo.els_logo_pyld)
 		dma_free_coherent(&ha->pdev->dev, DMA_POOL_SIZE,
@@ -2421,7 +2422,7 @@ struct fw_dif_context {
 	/* Alloc SRB structure */
 	sp = qla2x00_get_sp(vha, fcport, GFP_KERNEL);
 	if (!sp) {
-		kfree(fcport);
+		qla2x00_free_fcport(fcport);
 		ql_log(ql_log_info, vha, 0x70e6,
 		 "SRB allocation failed\n");
 		return -ENOMEM;
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index dec4b37..5fd3b07 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -1215,7 +1215,7 @@ static void qla_irq_affinity_notify(struct irq_affinity_notify *,
 		req->outstanding_cmds[index] = NULL;
 
 		/* Save ISP completion status */
-		sp->done(ha, sp, DID_OK << 16);
+		sp->done(vha, sp, DID_OK << 16);
 	} else {
 		ql_log(ql_log_warn, vha, 0x3016, "Invalid SCSI SRB.\n");
 
@@ -2408,7 +2408,7 @@ struct scsi_dif_tuple {
 		    resid_len, fw_resid_len, sp, cp);
 
 	if (rsp->status_srb == NULL)
-		sp->done(ha, sp, res);
+		sp->done(vha, sp, res);
 }
 
 /**
@@ -2465,7 +2465,7 @@ struct scsi_dif_tuple {
 	/* Place command on done queue. */
 	if (sense_len == 0) {
 		rsp->status_srb = NULL;
-		sp->done(ha, sp, cp->result);
+		sp->done(vha, sp, cp->result);
 	}
 }
 
@@ -2497,7 +2497,7 @@ struct scsi_dif_tuple {
 
 	sp = qla2x00_get_sp_from_handle(vha, func, req, pkt);
 	if (sp) {
-		sp->done(ha, sp, res);
+		sp->done(vha, sp, res);
 		return;
 	}
 fatal:
diff --git a/drivers/scsi/qla2xxx/qla_mid.c b/drivers/scsi/qla2xxx/qla_mid.c
index c6d6f0d..544aff1 100644
--- a/drivers/scsi/qla2xxx/qla_mid.c
+++ b/drivers/scsi/qla2xxx/qla_mid.c
@@ -599,6 +599,9 @@
 	struct qla_hw_data *ha = vha->hw;
 	struct qla_qpair *qpair, *tqpair;
 
+	if (!vha->hw)
+		return 0;
+
 	if (ql2xmqsupport) {
 		list_for_each_entry_safe(qpair, tqpair, &vha->qp_list,
 		    qp_list_elem)
diff --git a/drivers/scsi/qla2xxx/qla_mr.c b/drivers/scsi/qla2xxx/qla_mr.c
index 02f1de1..4eac33e 100644
--- a/drivers/scsi/qla2xxx/qla_mr.c
+++ b/drivers/scsi/qla2xxx/qla_mr.c
@@ -1211,7 +1211,7 @@
 				    fcport->old_tgt_id);
 				qla2x00_mark_device_lost(vha, fcport, 0, 0);
 				set_bit(LOOP_RESYNC_NEEDED, &vha->dpc_flags);
-				kfree(new_fcport);
+				qla2x00_free_fcport(new_fcport);
 				return rval;
 			}
 			break;
@@ -1229,7 +1229,7 @@
 			return QLA_MEMORY_ALLOC_FAILED;
 	}
 
-	kfree(new_fcport);
+	qla2x00_free_fcport(new_fcport);
 	return rval;
 }
 
@@ -1297,7 +1297,7 @@
 	/* Free all new device structures not processed. */
 	list_for_each_entry_safe(fcport, rmptemp, &new_fcports, list) {
 		list_del(&fcport->list);
-		kfree(fcport);
+		qla2x00_free_fcport(fcport);
 	}
 
 	return rval;
@@ -2537,7 +2537,7 @@
 		    par_sense_len, rsp_info_len);
 
 	if (rsp->status_srb == NULL)
-		sp->done(ha, sp, res);
+		sp->done(vha, sp, res);
 }
 
 /**
@@ -2614,7 +2614,7 @@
 	/* Place command on done queue. */
 	if (sense_len == 0) {
 		rsp->status_srb = NULL;
-		sp->done(ha, sp, cp->result);
+		sp->done(vha, sp, cp->result);
 	}
 }
 
@@ -2695,7 +2695,7 @@
 
 	sp = qla2x00_get_sp_from_handle(vha, func, req, pkt);
 	if (sp) {
-		sp->done(ha, sp, res);
+		sp->done(vha, sp, res);
 		return;
 	}
 
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index ce8c1dd..d6f4ce7 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -1200,7 +1200,7 @@ uint32_t qla2x00_isp_reg_stat(struct qla_hw_data *ha)
 	}
 
 	spin_lock_irqsave(&ha->hardware_lock, flags);
-	sp->done(ha, sp, 0);
+	sp->done(vha, sp, 0);
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 
 	/* Did the command return during mailbox execution? */
@@ -1598,7 +1598,8 @@ uint32_t qla2x00_isp_reg_stat(struct qla_hw_data *ha)
 	struct qla_hw_data *ha = vha->hw;
 	struct req_que *req;
 
-	qlt_host_reset_handler(ha);
+	if (ha->tgt.tgt_ops)
+		qlt_host_reset_handler(ha);
 
 	spin_lock_irqsave(&ha->hardware_lock, flags);
 	for (que = 0; que < ha->max_req_queues; que++) {
@@ -3476,6 +3477,9 @@ static void qla2x00_destroy_mbx_wq(struct qla_hw_data *ha)
 {
 	struct qla_hw_data *ha = vha->hw;
 
+	if (!ha)
+		return;
+
 	qla2x00_abort_all_cmds(vha, DID_NO_CONNECT << 16);
 
 	/* Disable timer */
@@ -3527,7 +3531,7 @@ void qla2x00_free_fcports(struct scsi_qla_host *vha)
 	list_for_each_entry_safe(fcport, tfcport, &vha->vp_fcports, list) {
 		list_del(&fcport->list);
 		qla2x00_clear_loop_id(fcport);
-		kfree(fcport);
+		qla2x00_free_fcport(fcport);
 		fcport = NULL;
 	}
 }
diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index adb3b93..cf4f86d 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -102,7 +102,7 @@ enum fcp_resp_rsp_codes {
 static void qlt_24xx_atio_pkt(struct scsi_qla_host *ha,
 	struct atio_from_isp *pkt, uint8_t);
 static void qlt_response_pkt(struct scsi_qla_host *ha, response_t *pkt);
-static int qlt_issue_task_mgmt(struct qla_tgt_sess *sess, uint32_t lun,
+static int qlt_issue_task_mgmt(struct fc_port *sess, u64 lun,
 	int fn, void *iocb, int flags);
 static void qlt_send_term_exchange(struct scsi_qla_host *ha, struct qla_tgt_cmd
 	*cmd, struct atio_from_isp *atio, int ha_locked, int ul_abort);
@@ -123,12 +123,11 @@ static void qlt_send_term_imm_notif(struct scsi_qla_host *vha,
 /*
  * Global Variables
  */
-static struct kmem_cache *qla_tgt_mgmt_cmd_cachep;
 static struct kmem_cache *qla_tgt_plogi_cachep;
-static mempool_t *qla_tgt_mgmt_cmd_mempool;
 static struct workqueue_struct *qla_tgt_wq;
 static DEFINE_MUTEX(qla_tgt_mutex);
-static LIST_HEAD(qla_tgt_glist);
+LIST_HEAD(qla_tgt_glist);
+EXPORT_SYMBOL(qla_tgt_glist);
 
 /* This API intentionally takes dest as a parameter, rather than returning
  * int value to avoid caller forgetting to issue wmb() after the store */
@@ -140,21 +139,6 @@ void qlt_do_generation_tick(struct scsi_qla_host *vha, int *dest)
 	wmb();
 }
 
-/* ha->hardware_lock supposed to be held on entry (to protect tgt->sess_list) */
-static struct qla_tgt_sess *qlt_find_sess_by_port_name(
-	struct qla_tgt *tgt,
-	const uint8_t *port_name)
-{
-	struct qla_tgt_sess *sess;
-
-	list_for_each_entry(sess, &tgt->sess_list, sess_list_entry) {
-		if (!memcmp(sess->port_name, port_name, WWN_SIZE))
-			return sess;
-	}
-
-	return NULL;
-}
-
 /* Might release hw lock, then reaquire!! */
 static inline int qlt_issue_marker(struct scsi_qla_host *vha, int vha_locked)
 {
@@ -409,8 +393,9 @@ void qlt_response_pkt_all_vps(struct scsi_qla_host *vha, response_t *pkt)
 
 	list_for_each_entry(pla, &vha->plogi_ack_list, list) {
 		if (pla->id.b24 == id->b24) {
-			qlt_send_term_imm_notif(vha, &pla->iocb, 1);
-			pla->iocb = *iocb;
+			qlt_send_term_imm_notif(vha,
+				(struct imm_ntfy_from_isp *)&pla->iocb, 1);
+			memcpy(pla->iocb, iocb, sizeof(pla->iocb));
 			return pla;
 		}
 	}
@@ -423,7 +408,7 @@ void qlt_response_pkt_all_vps(struct scsi_qla_host *vha, response_t *pkt)
 		return NULL;
 	}
 
-	pla->iocb = *iocb;
+	memcpy(pla->iocb, iocb, sizeof(pla->iocb));
 	pla->id = *id;
 	list_add_tail(&pla->list, &vha->plogi_ack_list);
 
@@ -432,6 +417,7 @@ void qlt_response_pkt_all_vps(struct scsi_qla_host *vha, response_t *pkt)
 
 static void qlt_plogi_ack_unref(struct scsi_qla_host *vha, qlt_plogi_ack_t *pla)
 {
+	struct imm_ntfy_from_isp *iocb = (struct imm_ntfy_from_isp *)&pla->iocb;
 	BUG_ON(!pla->ref_count);
 	pla->ref_count--;
 
@@ -440,12 +426,12 @@ static void qlt_plogi_ack_unref(struct scsi_qla_host *vha, qlt_plogi_ack_t *pla)
 
 	ql_dbg(ql_dbg_async, vha, 0x5089,
 	    "Sending PLOGI ACK to wwn %8phC s_id %02x:%02x:%02x loop_id %#04x"
-	    " exch %#x ox_id %#x\n", pla->iocb.u.isp24.port_name,
-	    pla->iocb.u.isp24.port_id[2], pla->iocb.u.isp24.port_id[1],
-	    pla->iocb.u.isp24.port_id[0],
-	    le16_to_cpu(pla->iocb.u.isp24.nport_handle),
-	    pla->iocb.u.isp24.exchange_address, pla->iocb.ox_id);
-	qlt_send_notify_ack(vha, &pla->iocb, 0, 0, 0, 0, 0, 0);
+	    " exch %#x ox_id %#x\n", iocb->u.isp24.port_name,
+	    iocb->u.isp24.port_id[2], iocb->u.isp24.port_id[1],
+	    iocb->u.isp24.port_id[0],
+	    le16_to_cpu(iocb->u.isp24.nport_handle),
+	    iocb->u.isp24.exchange_address, iocb->ox_id);
+	qlt_send_notify_ack(vha, iocb, 0, 0, 0, 0, 0, 0);
 
 	list_del(&pla->list);
 	kmem_cache_free(qla_tgt_plogi_cachep, pla);
@@ -453,8 +439,9 @@ static void qlt_plogi_ack_unref(struct scsi_qla_host *vha, qlt_plogi_ack_t *pla)
 
 static void
 qlt_plogi_ack_link(struct scsi_qla_host *vha, qlt_plogi_ack_t *pla,
-    struct qla_tgt_sess *sess, qlt_plogi_link_t link)
+    struct fc_port *sess, qlt_plogi_link_t link)
 {
+	struct imm_ntfy_from_isp *iocb = (struct imm_ntfy_from_isp *)&pla->iocb;
 	/* Inc ref_count first because link might already be pointing at pla */
 	pla->ref_count++;
 
@@ -464,8 +451,8 @@ static void qlt_plogi_ack_unref(struct scsi_qla_host *vha, qlt_plogi_ack_t *pla)
 	ql_dbg(ql_dbg_tgt_mgt, vha, 0xf097,
 	    "Linking sess %p [%d] wwn %8phC with PLOGI ACK to wwn %8phC"
 	    " s_id %02x:%02x:%02x, ref=%d\n", sess, link, sess->port_name,
-	    pla->iocb.u.isp24.port_name, pla->iocb.u.isp24.port_id[2],
-	    pla->iocb.u.isp24.port_id[1], pla->iocb.u.isp24.port_id[0],
+	    iocb->u.isp24.port_name, iocb->u.isp24.port_id[2],
+	    iocb->u.isp24.port_id[1], iocb->u.isp24.port_id[0],
 	    pla->ref_count);
 
 	sess->plogi_link[link] = pla;
@@ -519,7 +506,7 @@ static void qlt_plogi_ack_unref(struct scsi_qla_host *vha, qlt_plogi_ack_t *pla)
 
 static void qlt_free_session_done(struct work_struct *work)
 {
-	struct qla_tgt_sess *sess = container_of(work, struct qla_tgt_sess,
+	struct fc_port *sess = container_of(work, struct fc_port,
 	    free_work);
 	struct qla_tgt *tgt = sess->tgt;
 	struct scsi_qla_host *vha = sess->vha;
@@ -532,7 +519,7 @@ static void qlt_free_session_done(struct work_struct *work)
 		"%s: se_sess %p / sess %p from port %8phC loop_id %#04x"
 		" s_id %02x:%02x:%02x logout %d keep %d els_logo %d\n",
 		__func__, sess->se_sess, sess, sess->port_name, sess->loop_id,
-		sess->s_id.b.domain, sess->s_id.b.area, sess->s_id.b.al_pa,
+		sess->d_id.b.domain, sess->d_id.b.area, sess->d_id.b.al_pa,
 		sess->logout_on_delete, sess->keep_nport_handle,
 		sess->send_els_logo);
 
@@ -540,7 +527,7 @@ static void qlt_free_session_done(struct work_struct *work)
 
 	if (sess->send_els_logo) {
 		qlt_port_logo_t logo;
-		logo.id = sess->s_id;
+		logo.id = sess->d_id;
 		logo.cmd_count = 0;
 		qlt_send_first_logo(vha, &logo);
 	}
@@ -550,10 +537,9 @@ static void qlt_free_session_done(struct work_struct *work)
 
 		memset(&fcport, 0, sizeof(fcport));
 		fcport.loop_id = sess->loop_id;
-		fcport.d_id = sess->s_id;
+		fcport.d_id = sess->d_id;
 		memcpy(fcport.port_name, sess->port_name, WWN_SIZE);
 		fcport.vha = vha;
-		fcport.tgt_session = sess;
 
 		rc = qla2x00_post_async_logout_work(vha, &fcport, NULL);
 		if (rc != QLA_SUCCESS)
@@ -591,20 +577,18 @@ static void qlt_free_session_done(struct work_struct *work)
 	spin_lock_irqsave(&ha->hardware_lock, flags);
 
 	{
-		qlt_plogi_ack_t *own =
-		    sess->plogi_link[QLT_PLOGI_LINK_SAME_WWN];
-		qlt_plogi_ack_t *con =
-		    sess->plogi_link[QLT_PLOGI_LINK_CONFLICT];
-
+		qlt_plogi_ack_t *own = sess->plogi_link[QLT_PLOGI_LINK_SAME_WWN];
+		qlt_plogi_ack_t *con = sess->plogi_link[QLT_PLOGI_LINK_CONFLICT];
+		struct imm_ntfy_from_isp *iocb;
 		if (con) {
+			iocb = (struct imm_ntfy_from_isp *)&con->iocb;
 			ql_dbg(ql_dbg_tgt_mgt, vha, 0xf099,
-			    "se_sess %p / sess %p port %8phC is gone,"
-			    " %s (ref=%d), releasing PLOGI for %8phC (ref=%d)\n",
-			    sess->se_sess, sess, sess->port_name,
-			    own ? "releasing own PLOGI" :
-			    "no own PLOGI pending",
-			    own ? own->ref_count : -1,
-			    con->iocb.u.isp24.port_name, con->ref_count);
+				 "se_sess %p / sess %p port %8phC is gone,"
+				 " %s (ref=%d), releasing PLOGI for %8phC (ref=%d)\n",
+				 sess->se_sess, sess, sess->port_name,
+				 own ? "releasing own PLOGI" : "no own PLOGI pending",
+				 own ? own->ref_count : -1,
+				 iocb->u.isp24.port_name, con->ref_count);
 			qlt_plogi_ack_unref(vha, con);
 		} else {
 			ql_dbg(ql_dbg_tgt_mgt, vha, 0xf09a,
@@ -619,14 +603,13 @@ static void qlt_free_session_done(struct work_struct *work)
 			qlt_plogi_ack_unref(vha, own);
 	}
 
-	list_del(&sess->sess_list_entry);
-
-	spin_unlock_irqrestore(&ha->hardware_lock, flags);
+	spin_lock_irqsave(&ha->tgt.sess_lock, flags);
+	sess->se_sess = NULL;
+	spin_unlock_irqrestore(&ha->tgt.sess_lock, flags);
 
 	ql_dbg(ql_dbg_tgt_mgt, vha, 0xf001,
 	    "Unregistration of sess %p finished\n", sess);
 
-	kfree(sess);
 	/*
 	 * We need to protect against race, when tgt is freed before or
 	 * inside wake_up()
@@ -637,38 +620,31 @@ static void qlt_free_session_done(struct work_struct *work)
 }
 
 /* ha->tgt.sess_lock supposed to be held on entry */
-static void qlt_release_session(struct kref *kref)
+void qlt_unreg_sess(struct fc_port *sess)
 {
-	struct qla_tgt_sess *sess =
-		container_of(kref, struct qla_tgt_sess, sess_kref);
 	struct scsi_qla_host *vha = sess->vha;
 
+	ql_dbg(ql_dbg_disc, sess->vha, 0xffff,
+	    "%s sess %p for deletion %8phC\n",
+	    __func__, sess, sess->port_name);
+
 	if (sess->se_sess)
 		vha->hw->tgt.tgt_ops->clear_nacl_from_fcport_map(sess);
 
-	if (!list_empty(&sess->del_list_entry))
-		list_del_init(&sess->del_list_entry);
+	qla2x00_mark_device_lost(vha, sess, 1, 1);
+
 	sess->deleted = QLA_SESS_DELETION_IN_PROGRESS;
 
 	INIT_WORK(&sess->free_work, qlt_free_session_done);
 	schedule_work(&sess->free_work);
 }
-
-void qlt_put_sess(struct qla_tgt_sess *sess)
-{
-	if (!sess)
-		return;
-
-	assert_spin_locked(&sess->vha->hw->tgt.sess_lock);
-	kref_put(&sess->sess_kref, qlt_release_session);
-}
-EXPORT_SYMBOL(qlt_put_sess);
+EXPORT_SYMBOL(qlt_unreg_sess);
 
 static int qlt_reset(struct scsi_qla_host *vha, void *iocb, int mcmd)
 {
 	struct qla_hw_data *ha = vha->hw;
-	struct qla_tgt_sess *sess = NULL;
-	uint32_t unpacked_lun = 0;
+	struct fc_port *sess = NULL;
+	u64 unpacked_lun = 0;
 	uint16_t loop_id;
 	int res = 0;
 	struct imm_ntfy_from_isp *n = (struct imm_ntfy_from_isp *)iocb;
@@ -681,31 +657,6 @@ static int qlt_reset(struct scsi_qla_host *vha, void *iocb, int mcmd)
 		spin_lock_irqsave(&ha->tgt.sess_lock, flags);
 		qlt_clear_tgt_db(vha->vha_tgt.qla_tgt);
 		spin_unlock_irqrestore(&ha->tgt.sess_lock, flags);
-#if 0 /* FIXME: do we need to choose a session here? */
-		if (!list_empty(&ha->tgt.qla_tgt->sess_list)) {
-			sess = list_entry(ha->tgt.qla_tgt->sess_list.next,
-			    typeof(*sess), sess_list_entry);
-			switch (mcmd) {
-			case QLA_TGT_NEXUS_LOSS_SESS:
-				mcmd = QLA_TGT_NEXUS_LOSS;
-				break;
-			case QLA_TGT_ABORT_ALL_SESS:
-				mcmd = QLA_TGT_ABORT_ALL;
-				break;
-			case QLA_TGT_NEXUS_LOSS:
-			case QLA_TGT_ABORT_ALL:
-				break;
-			default:
-				ql_dbg(ql_dbg_tgt, vha, 0xe046,
-				    "qla_target(%d): Not allowed "
-				    "command %x in %s", vha->vp_idx,
-				    mcmd, __func__);
-				sess = NULL;
-				break;
-			}
-		} else
-			sess = NULL;
-#endif
 	} else {
 		spin_lock_irqsave(&ha->tgt.sess_lock, flags);
 		sess = ha->tgt.tgt_ops->find_sess_by_loop_id(vha, loop_id);
@@ -729,7 +680,7 @@ static int qlt_reset(struct scsi_qla_host *vha, void *iocb, int mcmd)
 }
 
 /* ha->tgt.sess_lock supposed to be held on entry */
-static void qlt_schedule_sess_for_deletion(struct qla_tgt_sess *sess,
+static void qlt_schedule_sess_for_deletion(struct fc_port *sess,
 	bool immediate)
 {
 	struct qla_tgt *tgt = sess->tgt;
@@ -761,7 +712,7 @@ static void qlt_schedule_sess_for_deletion(struct qla_tgt_sess *sess,
 	    "qla_target(%d): session for port %8phC (loop ID %d s_id %02x:%02x:%02x)"
 	    " scheduled for deletion in %u secs (expires: %lu) immed: %d, logout: %d, gen: %#x\n",
 	    sess->vha->vp_idx, sess->port_name, sess->loop_id,
-	    sess->s_id.b.domain, sess->s_id.b.area, sess->s_id.b.al_pa,
+	    sess->d_id.b.domain, sess->d_id.b.area, sess->d_id.b.al_pa,
 	    dev_loss_tmo, sess->expires, immediate, sess->logout_on_delete,
 	    sess->generation);
 
@@ -775,10 +726,13 @@ static void qlt_schedule_sess_for_deletion(struct qla_tgt_sess *sess,
 /* ha->tgt.sess_lock supposed to be held on entry */
 static void qlt_clear_tgt_db(struct qla_tgt *tgt)
 {
-	struct qla_tgt_sess *sess;
+	struct fc_port *sess;
+	scsi_qla_host_t *vha = tgt->vha;
 
-	list_for_each_entry(sess, &tgt->sess_list, sess_list_entry)
-		qlt_schedule_sess_for_deletion(sess, true);
+	list_for_each_entry(sess, &vha->vp_fcports, list) {
+		if (sess->se_sess)
+			qlt_schedule_sess_for_deletion(sess, true);
+	}
 
 	/* At this point tgt could be already dead */
 }
@@ -833,7 +787,7 @@ static int qla24xx_get_loop_id(struct scsi_qla_host *vha, const uint8_t *s_id,
 }
 
 /* ha->tgt.sess_lock supposed to be held on entry */
-static void qlt_undelete_sess(struct qla_tgt_sess *sess)
+static void qlt_undelete_sess(struct fc_port *sess)
 {
 	BUG_ON(sess->deleted != QLA_SESS_DELETION_PENDING);
 
@@ -847,7 +801,7 @@ static void qlt_del_sess_work_fn(struct delayed_work *work)
 	    sess_del_work);
 	struct scsi_qla_host *vha = tgt->vha;
 	struct qla_hw_data *ha = vha->hw;
-	struct qla_tgt_sess *sess;
+	struct fc_port *sess;
 	unsigned long flags, elapsed;
 
 	spin_lock_irqsave(&ha->tgt.sess_lock, flags);
@@ -865,7 +819,7 @@ static void qlt_del_sess_work_fn(struct delayed_work *work)
 			    sess);
 			if (sess->se_sess)
 				ha->tgt.tgt_ops->shutdown_sess(sess);
-			qlt_put_sess(sess);
+			ha->tgt.tgt_ops->put_sess(sess);
 		} else {
 			schedule_delayed_work(&tgt->sess_del_work,
 			    sess->expires - elapsed);
@@ -879,25 +833,24 @@ static void qlt_del_sess_work_fn(struct delayed_work *work)
  * Adds an extra ref to allow to drop hw lock after adding sess to the list.
  * Caller must put it.
  */
-static struct qla_tgt_sess *qlt_create_sess(
+static struct fc_port *qlt_create_sess(
 	struct scsi_qla_host *vha,
 	fc_port_t *fcport,
 	bool local)
 {
 	struct qla_hw_data *ha = vha->hw;
-	struct qla_tgt_sess *sess;
+	struct fc_port *sess;
 	unsigned long flags;
 
 	/* Check to avoid double sessions */
 	spin_lock_irqsave(&ha->tgt.sess_lock, flags);
-	list_for_each_entry(sess, &vha->vha_tgt.qla_tgt->sess_list,
-				sess_list_entry) {
+	list_for_each_entry(sess, &vha->vp_fcports, list) {
 		if (!memcmp(sess->port_name, fcport->port_name, WWN_SIZE)) {
 			ql_dbg(ql_dbg_tgt_mgt, vha, 0xf005,
 			    "Double sess %p found (s_id %x:%x:%x, "
 			    "loop_id %d), updating to d_id %x:%x:%x, "
-			    "loop_id %d", sess, sess->s_id.b.domain,
-			    sess->s_id.b.al_pa, sess->s_id.b.area,
+			    "loop_id %d", sess, sess->d_id.b.domain,
+			    sess->d_id.b.al_pa, sess->d_id.b.area,
 			    sess->loop_id, fcport->d_id.b.domain,
 			    fcport->d_id.b.al_pa, fcport->d_id.b.area,
 			    fcport->loop_id);
@@ -920,7 +873,8 @@ static struct qla_tgt_sess *qlt_create_sess(
 				}
 			}
 
-			kref_get(&sess->sess_kref);
+			ha->tgt.tgt_ops->get_sess(sess);
+
 			ha->tgt.tgt_ops->update_sess(sess, fcport->d_id, fcport->loop_id,
 						(fcport->flags & FCF_CONF_COMP_SUPPORTED));
 
@@ -947,7 +901,7 @@ static struct qla_tgt_sess *qlt_create_sess(
 	}
 	sess->tgt = vha->vha_tgt.qla_tgt;
 	sess->vha = vha;
-	sess->s_id = fcport->d_id;
+	sess->d_id = fcport->d_id;
 	sess->loop_id = fcport->loop_id;
 	sess->local = local;
 	kref_init(&sess->sess_kref);
@@ -959,6 +913,7 @@ static struct qla_tgt_sess *qlt_create_sess(
 	 * code will adjust these flags as necessary. */
 	sess->logout_on_delete = 1;
 	sess->keep_nport_handle = 0;
+	memcpy(sess->port_name, fcport->port_name, sizeof(sess->port_name));
 
 	ql_dbg(ql_dbg_tgt_mgt, vha, 0xf006,
 	    "Adding sess %p to tgt %p via ->check_initiator_node_acl()\n",
@@ -966,10 +921,10 @@ static struct qla_tgt_sess *qlt_create_sess(
 
 	sess->conf_compl_supported = (fcport->flags & FCF_CONF_COMP_SUPPORTED);
 	BUILD_BUG_ON(sizeof(sess->port_name) != sizeof(fcport->port_name));
-	memcpy(sess->port_name, fcport->port_name, sizeof(sess->port_name));
 
 	spin_lock_irqsave(&ha->tgt.sess_lock, flags);
-	list_add_tail(&sess->sess_list_entry, &vha->vha_tgt.qla_tgt->sess_list);
+	list_add_tail(&sess->list, &vha->vp_fcports);
+
 	vha->vha_tgt.qla_tgt->sess_count++;
 	qlt_do_generation_tick(vha, &sess->generation);
 	spin_unlock_irqrestore(&ha->tgt.sess_lock, flags);
@@ -978,8 +933,8 @@ static struct qla_tgt_sess *qlt_create_sess(
 	    "qla_target(%d): %ssession for wwn %8phC (loop_id %d, "
 	    "s_id %x:%x:%x, confirmed completion %ssupported) added\n",
 	    vha->vp_idx, local ?  "local " : "", fcport->port_name,
-	    fcport->loop_id, sess->s_id.b.domain, sess->s_id.b.area,
-	    sess->s_id.b.al_pa, sess->conf_compl_supported ?  "" : "not ");
+	    fcport->loop_id, sess->d_id.b.domain, sess->d_id.b.area,
+	    sess->d_id.b.al_pa, sess->conf_compl_supported ?  "" : "not ");
 
 	/*
 	 * Determine if this fc_port->port_name is allowed to access
@@ -992,83 +947,16 @@ static struct qla_tgt_sess *qlt_create_sess(
 		return NULL;
 	} else {
 		/*
-		 * Take an extra reference to ->sess_kref here to handle qla_tgt_sess
+		 * Take an extra reference to ->sess_kref here to handle fc_port
 		 * access across ->tgt.sess_lock reaquire.
 		 */
-		kref_get(&sess->sess_kref);
+		ha->tgt.tgt_ops->get_sess(sess);
 	}
 
 	return sess;
 }
 
 /*
- * Called from qla2x00_reg_remote_port()
- */
-void qlt_fc_port_added(struct scsi_qla_host *vha, fc_port_t *fcport)
-{
-	struct qla_hw_data *ha = vha->hw;
-	struct qla_tgt *tgt = vha->vha_tgt.qla_tgt;
-	struct qla_tgt_sess *sess;
-	unsigned long flags;
-
-	if (!vha->hw->tgt.tgt_ops)
-		return;
-
-	if (!tgt || (fcport->port_type != FCT_INITIATOR))
-		return;
-
-	if (qla_ini_mode_enabled(vha))
-		return;
-
-	spin_lock_irqsave(&ha->tgt.sess_lock, flags);
-	if (tgt->tgt_stop) {
-		spin_unlock_irqrestore(&ha->tgt.sess_lock, flags);
-		return;
-	}
-	sess = qlt_find_sess_by_port_name(tgt, fcport->port_name);
-	if (!sess) {
-		spin_unlock_irqrestore(&ha->tgt.sess_lock, flags);
-
-		mutex_lock(&vha->vha_tgt.tgt_mutex);
-		sess = qlt_create_sess(vha, fcport, false);
-		mutex_unlock(&vha->vha_tgt.tgt_mutex);
-
-		spin_lock_irqsave(&ha->tgt.sess_lock, flags);
-	} else if (sess->deleted == QLA_SESS_DELETION_IN_PROGRESS) {
-		/* Point of no return */
-		spin_unlock_irqrestore(&ha->tgt.sess_lock, flags);
-		return;
-	} else {
-		kref_get(&sess->sess_kref);
-
-		if (sess->deleted) {
-			qlt_undelete_sess(sess);
-
-			ql_dbg(ql_dbg_tgt_mgt, vha, 0xf04c,
-			    "qla_target(%u): %ssession for port %8phC "
-			    "(loop ID %d) reappeared\n", vha->vp_idx,
-			    sess->local ? "local " : "", sess->port_name,
-			    sess->loop_id);
-
-			ql_dbg(ql_dbg_tgt_mgt, vha, 0xf007,
-			    "Reappeared sess %p\n", sess);
-		}
-		ha->tgt.tgt_ops->update_sess(sess, fcport->d_id, fcport->loop_id,
-					(fcport->flags & FCF_CONF_COMP_SUPPORTED));
-	}
-
-	if (sess && sess->local) {
-		ql_dbg(ql_dbg_tgt_mgt, vha, 0xf04d,
-		    "qla_target(%u): local session for "
-		    "port %8phC (loop ID %d) became global\n", vha->vp_idx,
-		    fcport->port_name, sess->loop_id);
-		sess->local = 0;
-	}
-	qlt_put_sess(sess);
-	spin_unlock_irqrestore(&ha->tgt.sess_lock, flags);
-}
-
-/*
  * max_gen - specifies maximum session generation
  * at which this deletion requestion is still valid
  */
@@ -1076,7 +964,7 @@ void qlt_fc_port_added(struct scsi_qla_host *vha, fc_port_t *fcport)
 qlt_fc_port_deleted(struct scsi_qla_host *vha, fc_port_t *fcport, int max_gen)
 {
 	struct qla_tgt *tgt = vha->vha_tgt.qla_tgt;
-	struct qla_tgt_sess *sess;
+	struct fc_port *sess = fcport;
 	unsigned long flags;
 
 	if (!vha->hw->tgt.tgt_ops)
@@ -1090,8 +978,7 @@ void qlt_fc_port_added(struct scsi_qla_host *vha, fc_port_t *fcport)
 		spin_unlock_irqrestore(&vha->hw->tgt.sess_lock, flags);
 		return;
 	}
-	sess = qlt_find_sess_by_port_name(tgt, fcport->port_name);
-	if (!sess) {
+	if (!sess->se_sess) {
 		spin_unlock_irqrestore(&vha->hw->tgt.sess_lock, flags);
 		return;
 	}
@@ -1124,8 +1011,8 @@ static inline int test_tgt_sess_count(struct qla_tgt *tgt)
 	 */
 	spin_lock_irqsave(&ha->hardware_lock, flags);
 	ql_dbg(ql_dbg_tgt, tgt->vha, 0xe002,
-	    "tgt %p, empty(sess_list)=%d sess_count=%d\n",
-	    tgt, list_empty(&tgt->sess_list), tgt->sess_count);
+	    "tgt %p, sess_count=%d\n",
+	    tgt, tgt->sess_count);
 	res = (tgt->sess_count == 0);
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 
@@ -1188,8 +1075,8 @@ int qlt_stop_phase1(struct qla_tgt *tgt)
 	spin_unlock_irqrestore(&tgt->sess_work_lock, flags);
 
 	ql_dbg(ql_dbg_tgt_mgt, vha, 0xf00a,
-	    "Waiting for tgt %p: list_empty(sess_list)=%d "
-	    "sess_count=%d\n", tgt, list_empty(&tgt->sess_list),
+	    "Waiting for tgt %p: "
+	    "sess_count=%d\n", tgt,
 	    tgt->sess_count);
 
 	wait_event(tgt->waitQ, test_tgt_sess_count(tgt));
@@ -1299,6 +1186,9 @@ static void qlt_send_notify_ack(struct scsi_qla_host *vha,
 	request_t *pkt;
 	struct nack_to_isp *nack;
 
+	if (qla2x00_reset_active(vha))
+		return;
+
 	ql_dbg(ql_dbg_tgt, vha, 0xe004, "Sending NOTIFY_ACK (ha=%p)\n", ha);
 
 	/* Send marker if required */
@@ -1509,7 +1399,7 @@ static int abort_cmd_for_tag(struct scsi_qla_host *vha, uint32_t tag)
  *     for the same lun)
  */
 static void abort_cmds_for_lun(struct scsi_qla_host *vha,
-				uint32_t lun, uint8_t *s_id)
+				u64 lun, uint8_t *s_id)
 {
 	struct qla_tgt_sess_op *op;
 	struct qla_tgt_cmd *cmd;
@@ -1519,7 +1409,7 @@ static void abort_cmds_for_lun(struct scsi_qla_host *vha,
 	spin_lock(&vha->cmd_list_lock);
 	list_for_each_entry(op, &vha->qla_sess_op_cmd_list, cmd_list) {
 		uint32_t op_key;
-		uint32_t op_lun;
+		u64 op_lun;
 
 		op_key = sid_to_key(op->atio.u.isp24.fcp_hdr.s_id);
 		op_lun = scsilun_to_int(
@@ -1529,7 +1419,7 @@ static void abort_cmds_for_lun(struct scsi_qla_host *vha,
 	}
 	list_for_each_entry(cmd, &vha->qla_cmd_list, cmd_list) {
 		uint32_t cmd_key;
-		uint32_t cmd_lun;
+		u64 cmd_lun;
 
 		cmd_key = sid_to_key(cmd->atio.u.isp24.fcp_hdr.s_id);
 		cmd_lun = scsilun_to_int(
@@ -1542,67 +1432,48 @@ static void abort_cmds_for_lun(struct scsi_qla_host *vha,
 
 /* ha->hardware_lock supposed to be held on entry */
 static int __qlt_24xx_handle_abts(struct scsi_qla_host *vha,
-	struct abts_recv_from_24xx *abts, struct qla_tgt_sess *sess)
+	struct abts_recv_from_24xx *abts, struct fc_port *sess)
 {
 	struct qla_hw_data *ha = vha->hw;
-	struct se_session *se_sess = sess->se_sess;
 	struct qla_tgt_mgmt_cmd *mcmd;
-	struct se_cmd *se_cmd;
-	u32 lun = 0;
 	int rc;
-	bool found_lun = false;
-
-	spin_lock(&se_sess->sess_cmd_lock);
-	list_for_each_entry(se_cmd, &se_sess->sess_cmd_list, se_cmd_list) {
-		struct qla_tgt_cmd *cmd =
-			container_of(se_cmd, struct qla_tgt_cmd, se_cmd);
-		if (se_cmd->tag == abts->exchange_addr_to_abort) {
-			lun = cmd->unpacked_lun;
-			found_lun = true;
-			break;
-		}
-	}
-	spin_unlock(&se_sess->sess_cmd_lock);
-
-	/* cmd not in LIO lists, look in qla list */
-	if (!found_lun) {
-		if (abort_cmd_for_tag(vha, abts->exchange_addr_to_abort)) {
-			/* send TASK_ABORT response immediately */
-			qlt_24xx_send_abts_resp(vha, abts, FCP_TMF_CMPL, false);
-			return 0;
-		} else {
-			ql_dbg(ql_dbg_tgt_mgt, vha, 0xf081,
-			    "unable to find cmd in driver or LIO for tag 0x%x\n",
-			    abts->exchange_addr_to_abort);
-			return -ENOENT;
-		}
-	}
 
 	ql_dbg(ql_dbg_tgt_mgt, vha, 0xf00f,
 	    "qla_target(%d): task abort (tag=%d)\n",
 	    vha->vp_idx, abts->exchange_addr_to_abort);
 
-	mcmd = mempool_alloc(qla_tgt_mgmt_cmd_mempool, GFP_ATOMIC);
+	mcmd = ha->tgt.tgt_ops->alloc_mgmt_cmd();
 	if (mcmd == NULL) {
 		ql_dbg(ql_dbg_tgt_mgt, vha, 0xf051,
 		    "qla_target(%d): %s: Allocation of ABORT cmd failed",
 		    vha->vp_idx, __func__);
 		return -ENOMEM;
 	}
-	memset(mcmd, 0, sizeof(*mcmd));
 
 	mcmd->sess = sess;
 	memcpy(&mcmd->orig_iocb.abts, abts, sizeof(mcmd->orig_iocb.abts));
 	mcmd->reset_count = vha->hw->chip_reset;
+	mcmd->tmr_func = QLA_TGT_ABTS;
 
-	rc = ha->tgt.tgt_ops->handle_tmr(mcmd, lun, TMR_ABORT_TASK,
+	/* handle_tmr will search for LUN id based on exchange addr*/
+	rc = ha->tgt.tgt_ops->handle_tmr(mcmd, 0, mcmd->tmr_func,
 	    abts->exchange_addr_to_abort);
 	if (rc != 0) {
 		ql_dbg(ql_dbg_tgt_mgt, vha, 0xf052,
 		    "qla_target(%d):  tgt_ops->handle_tmr()"
 		    " failed: %d", vha->vp_idx, rc);
-		mempool_free(mcmd, qla_tgt_mgmt_cmd_mempool);
-		return -EFAULT;
+		ha->tgt.tgt_ops->free_mgmt_cmd(mcmd);
+
+		if (abort_cmd_for_tag(vha, abts->exchange_addr_to_abort)) {
+			/* send TASK_ABORT response immediately */
+			qlt_24xx_send_abts_resp(vha, abts, FCP_TMF_CMPL, false);
+			return 0;
+		} else {
+			ql_dbg(ql_dbg_tgt_mgt, vha, 0xf081,
+			    "unable to find cmd in driver or LIO for tag 0x%x\n",
+			    abts->exchange_addr_to_abort);
+			return -ENOENT;
+		}
 	}
 
 	return 0;
@@ -1615,7 +1486,7 @@ static void qlt_24xx_handle_abts(struct scsi_qla_host *vha,
 	struct abts_recv_from_24xx *abts)
 {
 	struct qla_hw_data *ha = vha->hw;
-	struct qla_tgt_sess *sess;
+	struct fc_port *sess;
 	uint32_t tag = abts->exchange_addr_to_abort;
 	uint8_t s_id[3];
 	int rc;
@@ -1732,12 +1603,6 @@ static void qlt_24xx_send_task_mgmt_ctio(struct scsi_qla_host *ha,
 	qla2x00_start_iocbs(ha, ha->req);
 }
 
-void qlt_free_mcmd(struct qla_tgt_mgmt_cmd *mcmd)
-{
-	mempool_free(mcmd, qla_tgt_mgmt_cmd_mempool);
-}
-EXPORT_SYMBOL(qlt_free_mcmd);
-
 /* callback from target fabric module code */
 void qlt_xmit_tm_rsp(struct qla_tgt_mgmt_cmd *mcmd)
 {
@@ -2113,7 +1978,6 @@ static int qlt_pre_xmit_response(struct qla_tgt_cmd *cmd,
 	struct qla_tgt *tgt = cmd->tgt;
 	struct scsi_qla_host *vha = tgt->vha;
 	struct qla_hw_data *ha = vha->hw;
-	struct se_cmd *se_cmd = &cmd->se_cmd;
 
 	prm->cmd = cmd;
 	prm->tgt = tgt;
@@ -2136,20 +2000,23 @@ static int qlt_pre_xmit_response(struct qla_tgt_cmd *cmd,
 
 	*full_req_cnt = prm->req_cnt;
 
-	if (se_cmd->se_cmd_flags & SCF_UNDERFLOW_BIT) {
-		prm->residual = se_cmd->residual_count;
+	if (cmd->residual < 0) {
+		prm->residual = -(cmd->residual);
 		ql_dbg(ql_dbg_io + ql_dbg_verbose, vha, 0x305c,
-		    "Residual underflow: %d (tag %lld, op %x, bufflen %d, rq_result %x)\n",
-		       prm->residual, se_cmd->tag,
-		       se_cmd->t_task_cdb ? se_cmd->t_task_cdb[0] : 0,
-		       cmd->bufflen, prm->rq_result);
+		    "Residual underflow: %d (tag %d, "
+		    "op %x, bufflen %d, rq_result %x)\n",
+			prm->residual, cmd->atio.u.isp24.exchange_addr,
+			cmd->cdb ? cmd->cdb[0] : 0,
+		    cmd->bufflen, prm->rq_result);
 		prm->rq_result |= SS_RESIDUAL_UNDER;
-	} else if (se_cmd->se_cmd_flags & SCF_OVERFLOW_BIT) {
-		prm->residual = se_cmd->residual_count;
+	} else if (cmd->residual > 0) {
+		prm->residual = cmd->residual;
 		ql_dbg(ql_dbg_io, vha, 0x305d,
-		    "Residual overflow: %d (tag %lld, op %x, bufflen %d, rq_result %x)\n",
-		       prm->residual, se_cmd->tag, se_cmd->t_task_cdb ?
-		       se_cmd->t_task_cdb[0] : 0, cmd->bufflen, prm->rq_result);
+		    "Residual overflow: %d (tag %d, "
+		    "op %x, bufflen %d, rq_result %x)\n",
+			prm->residual, cmd->atio.u.isp24.exchange_addr,
+			cmd->cdb ? cmd->cdb[0] : 0,
+		    cmd->bufflen, prm->rq_result);
 		prm->rq_result |= SS_RESIDUAL_OVER;
 	}
 
@@ -2222,7 +2089,8 @@ static void qlt_check_srr_debug(struct qla_tgt_cmd *cmd, int *xmit_type)
 	    == 50) {
 		*xmit_type &= ~QLA_TGT_XMIT_STATUS;
 		ql_dbg(ql_dbg_tgt_mgt, cmd->vha, 0xf015,
-		    "Dropping cmd %p (tag %d) status", cmd, se_cmd->tag);
+		    "Dropping cmd %p (tag %d) status", cmd,
+			 cmd->atio.u.isp24.exchange_addr);
 	}
 #endif
 	/*
@@ -2246,8 +2114,8 @@ static void qlt_check_srr_debug(struct qla_tgt_cmd *cmd, int *xmit_type)
 		ql_dbg(ql_dbg_tgt_mgt, cmd->vha, 0xf016,
 		    "Cutting cmd %p (tag %d) buffer"
 		    " tail to len %d, sg_cnt %d (cmd->bufflen %d,"
-		    " cmd->sg_cnt %d)", cmd, se_cmd->tag, tot_len, leave,
-		    cmd->bufflen, cmd->sg_cnt);
+		    " cmd->sg_cnt %d)", cmd, cmd->atio.u.isp24.exchange_addr,
+			tot_len, leave, cmd->bufflen, cmd->sg_cnt);
 
 		cmd->bufflen = tot_len;
 		cmd->sg_cnt = leave;
@@ -2258,13 +2126,15 @@ static void qlt_check_srr_debug(struct qla_tgt_cmd *cmd, int *xmit_type)
 
 		ql_dbg(ql_dbg_tgt_mgt, cmd->vha, 0xf017,
 		    "Cutting cmd %p (tag %d) buffer head "
-		    "to offset %d (cmd->bufflen %d)", cmd, se_cmd->tag, offset,
+		    "to offset %d (cmd->bufflen %d)", cmd,
+			 cmd->atio.u.isp24.exchange_addr, offset,
 		    cmd->bufflen);
 		if (offset == 0)
 			*xmit_type &= ~QLA_TGT_XMIT_DATA;
 		else if (qlt_set_data_offset(cmd, offset)) {
 			ql_dbg(ql_dbg_tgt_mgt, cmd->vha, 0xf018,
-			    "qlt_set_data_offset() failed (tag %d)", se_cmd->tag);
+			    "qlt_set_data_offset() failed (tag %d)",
+				cmd->atio.u.isp24.exchange_addr);
 		}
 	}
 }
@@ -2290,7 +2160,7 @@ static void qlt_24xx_init_ctio_to_isp(struct ctio7_to_24xx *ctio,
 		int i;
 
 		if (qlt_need_explicit_conf(prm->tgt->ha, prm->cmd, 1)) {
-			if (prm->cmd->se_cmd.scsi_status != 0) {
+			if ((prm->rq_result & SS_SCSI_STATUS_BYTE)  != 0) {
 				ql_dbg(ql_dbg_tgt, prm->cmd->vha, 0xe017,
 				    "Skipping EXPLICIT_CONFORM and "
 				    "CTIO7_FLAGS_CONFORM_REQ for FCP READ w/ "
@@ -2474,9 +2344,9 @@ static void qlt_24xx_init_ctio_to_isp(struct ctio7_to_24xx *ctio,
 	memset(pkt, 0, sizeof(*pkt));
 
 	ql_dbg(ql_dbg_tgt, vha, 0xe071,
-		"qla_target(%d):%s: se_cmd[%p] CRC2 prot_op[0x%x] cmd prot sg:cnt[%p:%x] lba[%llu]\n",
-		vha->vp_idx, __func__, se_cmd, se_cmd->prot_op,
-		prm->prot_sg, prm->prot_seg_cnt, se_cmd->t_task_lba);
+	    "qla_target(%d):%s: ulp_cmd[%p] CRC2 prot_op[0x%x] cmd prot sg:cnt[%p:%x] lba[%llu]\n",
+	    vha->vp_idx, __func__, se_cmd, se_cmd->prot_op,
+	    prm->prot_sg, prm->prot_seg_cnt, cmd->lba);
 
 	if ((se_cmd->prot_op == TARGET_PROT_DIN_INSERT) ||
 	    (se_cmd->prot_op == TARGET_PROT_DOUT_STRIP))
@@ -2690,10 +2560,10 @@ int qlt_xmit_response(struct qla_tgt_cmd *cmd, int xmit_type,
 	qlt_check_srr_debug(cmd, &xmit_type);
 
 	ql_dbg(ql_dbg_tgt, cmd->vha, 0xe018,
-	    "is_send_status=%d, cmd->bufflen=%d, cmd->sg_cnt=%d, cmd->dma_data_direction=%d se_cmd[%p]\n",
+	    "is_send_status=%d, cmd->bufflen=%d, cmd->sg_cnt=%d, cmd->dma_data_direction=%d ulp_cmd[%p]\n",
 	    (xmit_type & QLA_TGT_XMIT_STATUS) ?
 	    1 : 0, cmd->bufflen, cmd->sg_cnt, cmd->dma_data_direction,
-	    &cmd->se_cmd);
+	    cmd->ulp_cmd);
 
 	res = qlt_pre_xmit_response(cmd, &prm, xmit_type, scsi_status,
 	    &full_req_cnt);
@@ -2918,7 +2788,7 @@ int qlt_rdy_to_xfer(struct qla_tgt_cmd *cmd)
 	uint32_t	e_ref_tag, a_ref_tag;
 	uint16_t	e_app_tag, a_app_tag;
 	uint16_t	e_guard, a_guard;
-	uint64_t	lba = cmd->se_cmd.t_task_lba;
+	uint64_t	lba = cmd->lba;
 
 	a_guard   = be16_to_cpu(*(uint16_t *)(ap + 0));
 	a_app_tag = be16_to_cpu(*(uint16_t *)(ap + 2));
@@ -3000,7 +2870,7 @@ int qlt_rdy_to_xfer(struct qla_tgt_cmd *cmd)
 	/* check guard */
 	if (e_guard != a_guard) {
 		cmd->se_cmd.pi_err = TCM_LOGICAL_BLOCK_GUARD_CHECK_FAILED;
-		cmd->se_cmd.bad_sector = cmd->se_cmd.t_task_lba;
+		cmd->se_cmd.bad_sector = cmd->lba;
 
 		ql_log(ql_log_warn, vha, 0xe076,
 		    "Guard ERR: cdb 0x%x lba 0x%llx: [Actual|Expected] Ref Tag[0x%x|0x%x], App Tag [0x%x|0x%x], Guard [0x%x|0x%x] cmd=%p\n",
@@ -3026,7 +2896,7 @@ int qlt_rdy_to_xfer(struct qla_tgt_cmd *cmd)
 	/* check appl tag */
 	if (e_app_tag != a_app_tag) {
 		cmd->se_cmd.pi_err = TCM_LOGICAL_BLOCK_APP_TAG_CHECK_FAILED;
-		cmd->se_cmd.bad_sector = cmd->se_cmd.t_task_lba;
+		cmd->se_cmd.bad_sector = cmd->lba;
 
 		ql_log(ql_log_warn, vha, 0xe078,
 			"App Tag ERR: cdb 0x%x lba 0x%llx: [Actual|Expected] Ref Tag[0x%x|0x%x], App Tag [0x%x|0x%x], Guard [0x%x|0x%x] cmd=%p\n",
@@ -3239,7 +3109,7 @@ static void qlt_init_term_exchange(struct scsi_qla_host *vha)
 			/* This cmd was never sent to TCM.  There is no need
 			 * to schedule free or call free_cmd
 			 */
-			qlt_free_cmd(cmd);
+			vha->hw->tgt.tgt_ops->release_cmd(cmd);
 			vha->hw->tgt.num_qfull_cmds_alloc--;
 		}
 	}
@@ -3272,13 +3142,12 @@ int qlt_abort_cmd(struct qla_tgt_cmd *cmd)
 {
 	struct qla_tgt *tgt = cmd->tgt;
 	struct scsi_qla_host *vha = tgt->vha;
-	struct se_cmd *se_cmd = &cmd->se_cmd;
 	unsigned long flags;
 
 	ql_dbg(ql_dbg_tgt_mgt, vha, 0xf014,
 	    "qla_target(%d): terminating exchange for aborted cmd=%p "
-	    "(se_cmd=%p, tag=%llu)", vha->vp_idx, cmd, &cmd->se_cmd,
-	    se_cmd->tag);
+	    "(ulp_cmd=%p, tag=%d)", vha->vp_idx, cmd, cmd->ulp_cmd,
+	    cmd->atio.u.isp24.exchange_addr);
 
 	spin_lock_irqsave(&cmd->cmd_lock, flags);
 	if (cmd->aborted) {
@@ -3288,14 +3157,9 @@ int qlt_abort_cmd(struct qla_tgt_cmd *cmd)
 		 *  1) XFER Rdy completion + CMD_T_ABORT
 		 *  2) TCM TMR - drain_state_list
 		 */
-	        ql_dbg(ql_dbg_tgt_mgt, vha, 0xffff,
-			"multiple abort. %p transport_state %x, t_state %x,"
-			" se_cmd_flags %x \n", cmd, cmd->se_cmd.transport_state,
-			cmd->se_cmd.t_state,cmd->se_cmd.se_cmd_flags);
 		return EIO;
 	}
 	cmd->aborted = 1;
-	cmd->cmd_flags |= BIT_6;
 	spin_unlock_irqrestore(&cmd->cmd_lock, flags);
 
 	qlt_send_term_exchange(vha, cmd, &cmd->atio, 0, 1);
@@ -3305,11 +3169,9 @@ int qlt_abort_cmd(struct qla_tgt_cmd *cmd)
 
 void qlt_free_cmd(struct qla_tgt_cmd *cmd)
 {
-	struct qla_tgt_sess *sess = cmd->sess;
-
 	ql_dbg(ql_dbg_tgt, cmd->vha, 0xe074,
-	    "%s: se_cmd[%p] ox_id %04x\n",
-	    __func__, &cmd->se_cmd,
+	    "%s: ulp_cmd[%p] ox_id %04x\n",
+	    __func__, cmd->ulp_cmd,
 	    be16_to_cpu(cmd->atio.u.isp24.fcp_hdr.ox_id));
 
 	BUG_ON(cmd->cmd_in_wq);
@@ -3324,13 +3186,6 @@ void qlt_free_cmd(struct qla_tgt_cmd *cmd)
 	cmd->jiffies_at_free = get_jiffies_64();
 	if (unlikely(cmd->free_sg))
 		kfree(cmd->sg);
-
-	if (!sess || !sess->se_sess) {
-		WARN_ON(1);
-		return;
-	}
-	cmd->jiffies_at_free = get_jiffies_64();
-	percpu_ida_free(&sess->se_sess->sess_tag_pool, cmd->se_cmd.map_tag);
 }
 EXPORT_SYMBOL(qlt_free_cmd);
 
@@ -3343,7 +3198,7 @@ static int qlt_prepare_srr_ctio(struct scsi_qla_host *vha,
 	struct qla_tgt_srr_imm *imm;
 
 	tgt->ctio_srr_id++;
-	cmd->cmd_flags |= BIT_15;
+	cmd->trc_flags |= TRC_SRR_CTIO;
 
 	ql_dbg(ql_dbg_tgt_mgt, vha, 0xf019,
 	    "qla_target(%d): CTIO with SRR status received\n", vha->vp_idx);
@@ -3526,7 +3381,7 @@ static struct qla_tgt_cmd *qlt_ctio_to_cmd(struct scsi_qla_host *vha,
 		dump_stack();
 	}
 
-	cmd->cmd_flags |= BIT_17;
+	cmd->trc_flags |= TRC_FLUSH;
 	ha->tgt.tgt_ops->free_cmd(cmd);
 }
 
@@ -3573,7 +3428,7 @@ static void qlt_do_ctio_completion(struct scsi_qla_host *vha, uint32_t handle,
 	uint32_t status, void *ctio)
 {
 	struct qla_hw_data *ha = vha->hw;
-	struct se_cmd *se_cmd;
+	void *ulp_cmd;
 	struct qla_tgt_cmd *cmd;
 
 	if (handle & CTIO_INTERMEDIATE_HANDLE_MARK) {
@@ -3590,7 +3445,7 @@ static void qlt_do_ctio_completion(struct scsi_qla_host *vha, uint32_t handle,
 	if (cmd == NULL)
 		return;
 
-	se_cmd = &cmd->se_cmd;
+	ulp_cmd = (void *)cmd->ulp_cmd;
 	cmd->cmd_sent_to_fw = 0;
 
 	qlt_unmap_sg(vha, cmd);
@@ -3606,10 +3461,10 @@ static void qlt_do_ctio_completion(struct scsi_qla_host *vha, uint32_t handle,
 			/* They are OK */
 			ql_dbg(ql_dbg_tgt_mgt, vha, 0xf058,
 			    "qla_target(%d): CTIO with "
-			    "status %#x received, state %x, se_cmd %p, "
+			    "status %#x received, state %x, ulp_cmd %p, "
 			    "(LIP_RESET=e, ABORTED=2, TARGET_RESET=17, "
 			    "TIMEOUT=b, INVALID_RX_ID=8)\n", vha->vp_idx,
-			    status, cmd->state, se_cmd);
+			    status, cmd->state, ulp_cmd);
 			break;
 
 		case CTIO_PORT_LOGGED_OUT:
@@ -3619,10 +3474,11 @@ static void qlt_do_ctio_completion(struct scsi_qla_host *vha, uint32_t handle,
 				(status & 0xFFFF) == CTIO_PORT_LOGGED_OUT;
 
 			ql_dbg(ql_dbg_tgt_mgt, vha, 0xf059,
-			    "qla_target(%d): CTIO with %s status %x "
-			    "received (state %x, se_cmd %p)\n", vha->vp_idx,
-			    logged_out ? "PORT LOGGED OUT" : "PORT UNAVAILABLE",
-			    status, cmd->state, se_cmd);
+			    "qla_target(%d): CTIO with PORT LOGGED "
+			    "OUT (29) or PORT UNAVAILABLE (28) status %x "
+			    "received (state %x, ulp_cmd %p)\n", vha->vp_idx,
+			    status, cmd->state, ulp_cmd);
+			break;
 
 			if (logged_out && cmd->sess) {
 				/*
@@ -3638,8 +3494,8 @@ static void qlt_do_ctio_completion(struct scsi_qla_host *vha, uint32_t handle,
 		case CTIO_SRR_RECEIVED:
 			ql_dbg(ql_dbg_tgt_mgt, vha, 0xf05a,
 			    "qla_target(%d): CTIO with SRR_RECEIVED"
-			    " status %x received (state %x, se_cmd %p)\n",
-			    vha->vp_idx, status, cmd->state, se_cmd);
+			    " status %x received (state %x, ulp_cmd %p)\n",
+			    vha->vp_idx, status, cmd->state, ulp_cmd);
 			if (qlt_prepare_srr_ctio(vha, cmd, ctio) != 0)
 				break;
 			else
@@ -3649,8 +3505,8 @@ static void qlt_do_ctio_completion(struct scsi_qla_host *vha, uint32_t handle,
 			struct ctio_crc_from_fw *crc =
 				(struct ctio_crc_from_fw *)ctio;
 			ql_dbg(ql_dbg_tgt_mgt, vha, 0xf073,
-			    "qla_target(%d): CTIO with DIF_ERROR status %x received (state %x, se_cmd %p) actual_dif[0x%llx] expect_dif[0x%llx]\n",
-			    vha->vp_idx, status, cmd->state, se_cmd,
+			    "qla_target(%d): CTIO with DIF_ERROR status %x received (state %x, ulp_cmd %p) actual_dif[0x%llx] expect_dif[0x%llx]\n",
+			    vha->vp_idx, status, cmd->state, ulp_cmd,
 			    *((u64 *)&crc->actual_dif[0]),
 			    *((u64 *)&crc->expected_dif[0]));
 
@@ -3678,8 +3534,9 @@ static void qlt_do_ctio_completion(struct scsi_qla_host *vha, uint32_t handle,
 		}
 		default:
 			ql_dbg(ql_dbg_tgt_mgt, vha, 0xf05b,
-			    "qla_target(%d): CTIO with error status 0x%x received (state %x, se_cmd %p\n",
-			    vha->vp_idx, status, cmd->state, se_cmd);
+			    "qla_target(%d): CTIO with error status 0x%x received "
+				"(state %x, ulp_cmd %p\n",
+			    vha->vp_idx, status, cmd->state, ulp_cmd);
 			break;
 		}
 
@@ -3692,7 +3549,7 @@ static void qlt_do_ctio_completion(struct scsi_qla_host *vha, uint32_t handle,
 		 */
 		if ((cmd->state != QLA_TGT_STATE_NEED_DATA) &&
 		    (!cmd->aborted)) {
-			cmd->cmd_flags |= BIT_13;
+			cmd->trc_flags |= TRC_CTIO_ERR;
 			if (qlt_term_ctio_exchange(vha, ctio, cmd, status))
 				return;
 		}
@@ -3700,7 +3557,7 @@ static void qlt_do_ctio_completion(struct scsi_qla_host *vha, uint32_t handle,
 skip_term:
 
 	if (cmd->state == QLA_TGT_STATE_PROCESSED) {
-		cmd->cmd_flags |= BIT_12;
+		cmd->trc_flags |= TRC_CTIO_DONE;
 	} else if (cmd->state == QLA_TGT_STATE_NEED_DATA) {
 		cmd->state = QLA_TGT_STATE_DATA_IN;
 
@@ -3710,11 +3567,12 @@ static void qlt_do_ctio_completion(struct scsi_qla_host *vha, uint32_t handle,
 		ha->tgt.tgt_ops->handle_data(cmd);
 		return;
 	} else if (cmd->aborted) {
-		cmd->cmd_flags |= BIT_18;
+		cmd->trc_flags |= TRC_CTIO_ABORTED;
 		ql_dbg(ql_dbg_tgt_mgt, vha, 0xf01e,
-		  "Aborted command %p (tag %lld) finished\n", cmd, se_cmd->tag);
+		  "Aborted command %p (tag %d) finished\n",
+			cmd, cmd->atio.u.isp24.exchange_addr);
 	} else {
-		cmd->cmd_flags |= BIT_19;
+		cmd->trc_flags |= TRC_CTIO_STRANGE;
 		ql_dbg(ql_dbg_tgt_mgt, vha, 0xf05c,
 		    "qla_target(%d): A command in state (%d) should "
 		    "not return a CTIO complete\n", vha->vp_idx, cmd->state);
@@ -3729,39 +3587,8 @@ static void qlt_do_ctio_completion(struct scsi_qla_host *vha, uint32_t handle,
 	ha->tgt.tgt_ops->free_cmd(cmd);
 }
 
-static inline int qlt_get_fcp_task_attr(struct scsi_qla_host *vha,
-	uint8_t task_codes)
-{
-	int fcp_task_attr;
-
-	switch (task_codes) {
-	case ATIO_SIMPLE_QUEUE:
-		fcp_task_attr = TCM_SIMPLE_TAG;
-		break;
-	case ATIO_HEAD_OF_QUEUE:
-		fcp_task_attr = TCM_HEAD_TAG;
-		break;
-	case ATIO_ORDERED_QUEUE:
-		fcp_task_attr = TCM_ORDERED_TAG;
-		break;
-	case ATIO_ACA_QUEUE:
-		fcp_task_attr = TCM_ACA_TAG;
-		break;
-	case ATIO_UNTAGGED:
-		fcp_task_attr = TCM_SIMPLE_TAG;
-		break;
-	default:
-		ql_dbg(ql_dbg_tgt_mgt, vha, 0xf05d,
-		    "qla_target: unknown task code %x, use ORDERED instead\n",
-		    task_codes);
-		fcp_task_attr = TCM_ORDERED_TAG;
-		break;
-	}
 
-	return fcp_task_attr;
-}
-
-static struct qla_tgt_sess *qlt_make_local_sess(struct scsi_qla_host *,
+static struct fc_port *qlt_make_local_sess(struct scsi_qla_host *,
 					uint8_t *);
 /*
  * Process context for I/O path into tcm_qla2xxx code
@@ -3771,15 +3598,15 @@ static void __qlt_do_work(struct qla_tgt_cmd *cmd)
 	scsi_qla_host_t *vha = cmd->vha;
 	struct qla_hw_data *ha = vha->hw;
 	struct qla_tgt *tgt = vha->vha_tgt.qla_tgt;
-	struct qla_tgt_sess *sess = cmd->sess;
+	struct fc_port *sess = cmd->sess;
 	struct atio_from_isp *atio = &cmd->atio;
 	unsigned char *cdb;
 	unsigned long flags;
 	uint32_t data_length;
-	int ret, fcp_task_attr, data_dir, bidi = 0;
+	int ret, data_dir, bidi = 0;
 
 	cmd->cmd_in_wq = 0;
-	cmd->cmd_flags |= BIT_1;
+	cmd->trc_flags |= TRC_DO_WORK;
 	if (tgt->tgt_stop)
 		goto out_term;
 
@@ -3792,7 +3619,6 @@ static void __qlt_do_work(struct qla_tgt_cmd *cmd)
 
 	spin_lock_init(&cmd->cmd_lock);
 	cdb = &atio->u.isp24.fcp_cmnd.cdb[0];
-	cmd->se_cmd.tag = atio->u.isp24.exchange_addr;
 	cmd->unpacked_lun = scsilun_to_int(
 	    (struct scsi_lun *)&atio->u.isp24.fcp_cmnd.lun);
 
@@ -3807,21 +3633,20 @@ static void __qlt_do_work(struct qla_tgt_cmd *cmd)
 	else
 		data_dir = DMA_NONE;
 
-	fcp_task_attr = qlt_get_fcp_task_attr(vha,
-	    atio->u.isp24.fcp_cmnd.task_attr);
+
 	data_length = be32_to_cpu(get_unaligned((uint32_t *)
 	    &atio->u.isp24.fcp_cmnd.add_cdb[
 	    atio->u.isp24.fcp_cmnd.add_cdb_len]));
 
 	ret = ha->tgt.tgt_ops->handle_cmd(vha, cmd, cdb, data_length,
-				          fcp_task_attr, data_dir, bidi);
+		atio->u.isp24.fcp_cmnd.task_attr, data_dir, bidi);
 	if (ret != 0)
 		goto out_term;
 	/*
 	 * Drop extra session reference from qla_tgt_handle_cmd_for_atio*(
 	 */
 	spin_lock_irqsave(&ha->tgt.sess_lock, flags);
-	qlt_put_sess(sess);
+	ha->tgt.tgt_ops->put_sess(sess);
 	spin_unlock_irqrestore(&ha->tgt.sess_lock, flags);
 	return;
 
@@ -3831,16 +3656,16 @@ static void __qlt_do_work(struct qla_tgt_cmd *cmd)
 	 * cmd has not sent to target yet, so pass NULL as the second
 	 * argument to qlt_send_term_exchange() and free the memory here.
 	 */
-	cmd->cmd_flags |= BIT_2;
+	cmd->trc_flags |= TRC_DO_WORK_ERR;
 	spin_lock_irqsave(&ha->hardware_lock, flags);
 	qlt_send_term_exchange(vha, NULL, &cmd->atio, 1, 0);
 
 	qlt_decr_num_pend_cmds(vha);
-	percpu_ida_free(&sess->se_sess->sess_tag_pool, cmd->se_cmd.map_tag);
+	ha->tgt.tgt_ops->release_cmd(cmd);
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 
 	spin_lock_irqsave(&ha->tgt.sess_lock, flags);
-	qlt_put_sess(sess);
+	ha->tgt.tgt_ops->put_sess(sess);
 	spin_unlock_irqrestore(&ha->tgt.sess_lock, flags);
 }
 
@@ -3858,31 +3683,25 @@ static void qlt_do_work(struct work_struct *work)
 }
 
 static struct qla_tgt_cmd *qlt_get_tag(scsi_qla_host_t *vha,
-				       struct qla_tgt_sess *sess,
+				       struct fc_port *sess,
 				       struct atio_from_isp *atio)
 {
-	struct se_session *se_sess = sess->se_sess;
 	struct qla_tgt_cmd *cmd;
-	int tag;
 
-	tag = percpu_ida_alloc(&se_sess->sess_tag_pool, TASK_RUNNING);
-	if (tag < 0)
+	cmd = vha->hw->tgt.tgt_ops->alloc_cmd(sess);
+	if (!cmd)
 		return NULL;
 
-	cmd = &((struct qla_tgt_cmd *)se_sess->sess_cmd_map)[tag];
-	memset(cmd, 0, sizeof(struct qla_tgt_cmd));
-
 	memcpy(&cmd->atio, atio, sizeof(*atio));
 	cmd->state = QLA_TGT_STATE_NEW;
 	cmd->tgt = vha->vha_tgt.qla_tgt;
 	qlt_incr_num_pend_cmds(vha);
 	cmd->vha = vha;
-	cmd->se_cmd.map_tag = tag;
 	cmd->sess = sess;
 	cmd->loop_id = sess->loop_id;
 	cmd->conf_compl_supported = sess->conf_compl_supported;
 
-	cmd->cmd_flags = 0;
+	cmd->trc_flags = 0;
 	cmd->jiffies_at_alloc = get_jiffies_64();
 
 	cmd->reset_count = vha->hw->chip_reset;
@@ -3899,7 +3718,7 @@ static void qlt_create_sess_from_atio(struct work_struct *work)
 					struct qla_tgt_sess_op, work);
 	scsi_qla_host_t *vha = op->vha;
 	struct qla_hw_data *ha = vha->hw;
-	struct qla_tgt_sess *sess;
+	struct fc_port *sess;
 	struct qla_tgt_cmd *cmd;
 	unsigned long flags;
 	uint8_t *s_id = op->atio.u.isp24.fcp_hdr.s_id;
@@ -3940,7 +3759,7 @@ static void qlt_create_sess_from_atio(struct work_struct *work)
 	if (!cmd) {
 		spin_lock_irqsave(&ha->hardware_lock, flags);
 		qlt_send_busy(vha, &op->atio, SAM_STAT_BUSY);
-		qlt_put_sess(sess);
+		ha->tgt.tgt_ops->put_sess(sess);
 		spin_unlock_irqrestore(&ha->hardware_lock, flags);
 		kfree(op);
 		return;
@@ -3967,7 +3786,7 @@ static int qlt_handle_cmd_for_atio(struct scsi_qla_host *vha,
 {
 	struct qla_hw_data *ha = vha->hw;
 	struct qla_tgt *tgt = vha->vha_tgt.qla_tgt;
-	struct qla_tgt_sess *sess;
+	struct fc_port *sess;
 	struct qla_tgt_cmd *cmd;
 
 	if (unlikely(tgt->tgt_stop)) {
@@ -4007,20 +3826,18 @@ static int qlt_handle_cmd_for_atio(struct scsi_qla_host *vha,
 	/*
 	 * Do kref_get() before returning + dropping qla_hw_data->hardware_lock.
 	 */
-	kref_get(&sess->sess_kref);
+	ha->tgt.tgt_ops->get_sess(sess);
 
 	cmd = qlt_get_tag(vha, sess, atio);
 	if (!cmd) {
 		ql_dbg(ql_dbg_io, vha, 0x3062,
 		    "qla_target(%d): Allocation of cmd failed\n", vha->vp_idx);
-		qlt_put_sess(sess);
+		ha->tgt.tgt_ops->put_sess(sess);
 		return -ENOMEM;
 	}
 
 	cmd->cmd_in_wq = 1;
-	cmd->cmd_flags |= BIT_0;
-	cmd->se_cmd.cpuid = ha->msix_count ?
-		ha->tgt.rspq_vector_cpuid : WORK_CPU_UNBOUND;
+	cmd->trc_flags |= TRC_NEW_CMD;
 
 	spin_lock(&vha->cmd_list_lock);
 	list_add_tail(&cmd->cmd_list, &vha->qla_cmd_list);
@@ -4032,7 +3849,7 @@ static int qlt_handle_cmd_for_atio(struct scsi_qla_host *vha,
 			queue_work_on(smp_processor_id(), qla_tgt_wq,
 			    &cmd->work);
 		else
-			queue_work_on(cmd->se_cmd.cpuid, qla_tgt_wq,
+			queue_work_on(ha->tgt.rspq_vector_cpuid, qla_tgt_wq,
 			    &cmd->work);
 	} else {
 		queue_work(qla_tgt_wq, &cmd->work);
@@ -4042,7 +3859,7 @@ static int qlt_handle_cmd_for_atio(struct scsi_qla_host *vha,
 }
 
 /* ha->hardware_lock supposed to be held on entry */
-static int qlt_issue_task_mgmt(struct qla_tgt_sess *sess, uint32_t lun,
+static int qlt_issue_task_mgmt(struct fc_port *sess, u64 lun,
 	int fn, void *iocb, int flags)
 {
 	struct scsi_qla_host *vha = sess->vha;
@@ -4050,9 +3867,8 @@ static int qlt_issue_task_mgmt(struct qla_tgt_sess *sess, uint32_t lun,
 	struct qla_tgt_mgmt_cmd *mcmd;
 	struct atio_from_isp *a = (struct atio_from_isp *)iocb;
 	int res;
-	uint8_t tmr_func;
 
-	mcmd = mempool_alloc(qla_tgt_mgmt_cmd_mempool, GFP_ATOMIC);
+	mcmd = ha->tgt.tgt_ops->alloc_mgmt_cmd();
 	if (!mcmd) {
 		ql_dbg(ql_dbg_tgt_tmr, vha, 0x10009,
 		    "qla_target(%d): Allocation of management "
@@ -4060,7 +3876,6 @@ static int qlt_issue_task_mgmt(struct qla_tgt_sess *sess, uint32_t lun,
 		    "leak\n", vha->vp_idx);
 		return -ENOMEM;
 	}
-	memset(mcmd, 0, sizeof(*mcmd));
 	mcmd->sess = sess;
 
 	if (iocb) {
@@ -4072,79 +3887,17 @@ static int qlt_issue_task_mgmt(struct qla_tgt_sess *sess, uint32_t lun,
 	mcmd->reset_count = vha->hw->chip_reset;
 
 	switch (fn) {
-	case QLA_TGT_CLEAR_ACA:
-		ql_dbg(ql_dbg_tgt_tmr, vha, 0x10000,
-		    "qla_target(%d): CLEAR_ACA received\n", sess->vha->vp_idx);
-		tmr_func = TMR_CLEAR_ACA;
-		break;
-
-	case QLA_TGT_TARGET_RESET:
-		ql_dbg(ql_dbg_tgt_tmr, vha, 0x10001,
-		    "qla_target(%d): TARGET_RESET received\n",
-		    sess->vha->vp_idx);
-		tmr_func = TMR_TARGET_WARM_RESET;
-		break;
-
 	case QLA_TGT_LUN_RESET:
-		ql_dbg(ql_dbg_tgt_tmr, vha, 0x10002,
-		    "qla_target(%d): LUN_RESET received\n", sess->vha->vp_idx);
-		tmr_func = TMR_LUN_RESET;
 		abort_cmds_for_lun(vha, lun, a->u.isp24.fcp_hdr.s_id);
 		break;
-
-	case QLA_TGT_CLEAR_TS:
-		ql_dbg(ql_dbg_tgt_tmr, vha, 0x10003,
-		    "qla_target(%d): CLEAR_TS received\n", sess->vha->vp_idx);
-		tmr_func = TMR_CLEAR_TASK_SET;
-		break;
-
-	case QLA_TGT_ABORT_TS:
-		ql_dbg(ql_dbg_tgt_tmr, vha, 0x10004,
-		    "qla_target(%d): ABORT_TS received\n", sess->vha->vp_idx);
-		tmr_func = TMR_ABORT_TASK_SET;
-		break;
-#if 0
-	case QLA_TGT_ABORT_ALL:
-		ql_dbg(ql_dbg_tgt_tmr, vha, 0x10005,
-		    "qla_target(%d): Doing ABORT_ALL_TASKS\n",
-		    sess->vha->vp_idx);
-		tmr_func = 0;
-		break;
-
-	case QLA_TGT_ABORT_ALL_SESS:
-		ql_dbg(ql_dbg_tgt_tmr, vha, 0x10006,
-		    "qla_target(%d): Doing ABORT_ALL_TASKS_SESS\n",
-		    sess->vha->vp_idx);
-		tmr_func = 0;
-		break;
-
-	case QLA_TGT_NEXUS_LOSS_SESS:
-		ql_dbg(ql_dbg_tgt_tmr, vha, 0x10007,
-		    "qla_target(%d): Doing NEXUS_LOSS_SESS\n",
-		    sess->vha->vp_idx);
-		tmr_func = 0;
-		break;
-
-	case QLA_TGT_NEXUS_LOSS:
-		ql_dbg(ql_dbg_tgt_tmr, vha, 0x10008,
-		    "qla_target(%d): Doing NEXUS_LOSS\n", sess->vha->vp_idx);
-		tmr_func = 0;
-		break;
-#endif
-	default:
-		ql_dbg(ql_dbg_tgt_tmr, vha, 0x1000a,
-		    "qla_target(%d): Unknown task mgmt fn 0x%x\n",
-		    sess->vha->vp_idx, fn);
-		mempool_free(mcmd, qla_tgt_mgmt_cmd_mempool);
-		return -ENOSYS;
 	}
 
-	res = ha->tgt.tgt_ops->handle_tmr(mcmd, lun, tmr_func, 0);
+	res = ha->tgt.tgt_ops->handle_tmr(mcmd, lun, mcmd->tmr_func, 0);
 	if (res != 0) {
 		ql_dbg(ql_dbg_tgt_tmr, vha, 0x1000b,
 		    "qla_target(%d): tgt.tgt_ops->handle_tmr() failed: %d\n",
 		    sess->vha->vp_idx, res);
-		mempool_free(mcmd, qla_tgt_mgmt_cmd_mempool);
+		ha->tgt.tgt_ops->free_mgmt_cmd(mcmd);
 		return -EFAULT;
 	}
 
@@ -4157,14 +3910,13 @@ static int qlt_handle_task_mgmt(struct scsi_qla_host *vha, void *iocb)
 	struct atio_from_isp *a = (struct atio_from_isp *)iocb;
 	struct qla_hw_data *ha = vha->hw;
 	struct qla_tgt *tgt;
-	struct qla_tgt_sess *sess;
-	uint32_t lun, unpacked_lun;
+	struct fc_port *sess;
+	u64 unpacked_lun;
 	int fn;
 	unsigned long flags;
 
 	tgt = vha->vha_tgt.qla_tgt;
 
-	lun = a->u.isp24.fcp_cmnd.lun;
 	fn = a->u.isp24.fcp_cmnd.task_mgmt_flags;
 
 	spin_lock_irqsave(&ha->tgt.sess_lock, flags);
@@ -4172,7 +3924,7 @@ static int qlt_handle_task_mgmt(struct scsi_qla_host *vha, void *iocb)
 	    a->u.isp24.fcp_hdr.s_id);
 	spin_unlock_irqrestore(&ha->tgt.sess_lock, flags);
 
-	unpacked_lun = scsilun_to_int((struct scsi_lun *)&lun);
+	unpacked_lun = scsilun_to_int((struct scsi_lun *)&a->u.isp24.fcp_cmnd.lun);
 
 	if (!sess) {
 		ql_dbg(ql_dbg_tgt_mgt, vha, 0xf024,
@@ -4190,38 +3942,37 @@ static int qlt_handle_task_mgmt(struct scsi_qla_host *vha, void *iocb)
 
 /* ha->hardware_lock supposed to be held on entry */
 static int __qlt_abort_task(struct scsi_qla_host *vha,
-	struct imm_ntfy_from_isp *iocb, struct qla_tgt_sess *sess)
+	struct imm_ntfy_from_isp *iocb, struct fc_port *sess)
 {
 	struct atio_from_isp *a = (struct atio_from_isp *)iocb;
 	struct qla_hw_data *ha = vha->hw;
 	struct qla_tgt_mgmt_cmd *mcmd;
-	uint32_t lun, unpacked_lun;
+	u64 unpacked_lun;
 	int rc;
 
-	mcmd = mempool_alloc(qla_tgt_mgmt_cmd_mempool, GFP_ATOMIC);
+	mcmd = ha->tgt.tgt_ops->alloc_mgmt_cmd();
 	if (mcmd == NULL) {
 		ql_dbg(ql_dbg_tgt_mgt, vha, 0xf05f,
 		    "qla_target(%d): %s: Allocation of ABORT cmd failed\n",
 		    vha->vp_idx, __func__);
 		return -ENOMEM;
 	}
-	memset(mcmd, 0, sizeof(*mcmd));
 
 	mcmd->sess = sess;
 	memcpy(&mcmd->orig_iocb.imm_ntfy, iocb,
 	    sizeof(mcmd->orig_iocb.imm_ntfy));
 
-	lun = a->u.isp24.fcp_cmnd.lun;
-	unpacked_lun = scsilun_to_int((struct scsi_lun *)&lun);
+	unpacked_lun = scsilun_to_int((struct scsi_lun *)&a->u.isp24.fcp_cmnd.lun);
 	mcmd->reset_count = vha->hw->chip_reset;
+	mcmd->tmr_func = QLA_TGT_2G_ABORT_TASK;
 
-	rc = ha->tgt.tgt_ops->handle_tmr(mcmd, unpacked_lun, TMR_ABORT_TASK,
+	rc = ha->tgt.tgt_ops->handle_tmr(mcmd, unpacked_lun, mcmd->tmr_func,
 	    le16_to_cpu(iocb->u.isp2x.seq_id));
 	if (rc != 0) {
 		ql_dbg(ql_dbg_tgt_mgt, vha, 0xf060,
 		    "qla_target(%d): tgt_ops->handle_tmr() failed: %d\n",
 		    vha->vp_idx, rc);
-		mempool_free(mcmd, qla_tgt_mgmt_cmd_mempool);
+		ha->tgt.tgt_ops->free_mgmt_cmd(mcmd);
 		return -EFAULT;
 	}
 
@@ -4233,7 +3984,7 @@ static int qlt_abort_task(struct scsi_qla_host *vha,
 	struct imm_ntfy_from_isp *iocb)
 {
 	struct qla_hw_data *ha = vha->hw;
-	struct qla_tgt_sess *sess;
+	struct fc_port *sess;
 	int loop_id;
 	unsigned long flags;
 
@@ -4263,14 +4014,14 @@ void qlt_logo_completion_handler(fc_port_t *fcport, int rc)
 				" port %8phC loop_id %#04x s_id %02x:%02x:%02x"
 				" LOGO failed: %#x\n",
 				__func__,
-				fcport->tgt_session->se_sess,
+				fcport->se_sess,
 				fcport->tgt_session,
 				fcport->port_name, fcport->loop_id,
 				fcport->d_id.b.domain, fcport->d_id.b.area,
 				fcport->d_id.b.al_pa, rc);
 		}
 
-		fcport->tgt_session->logout_completed = 1;
+		fcport->logout_completed = 1;
 	}
 }
 
@@ -4281,16 +4032,17 @@ void qlt_logo_completion_handler(fc_port_t *fcport, int rc)
 * deletion. Returns existing session with matching wwn if present.
 * Null otherwise.
 */
-static struct qla_tgt_sess *
+static struct fc_port *
 qlt_find_sess_invalidate_other(struct qla_tgt *tgt, uint64_t wwn,
-    port_id_t port_id, uint16_t loop_id, struct qla_tgt_sess **conflict_sess)
+    port_id_t port_id, uint16_t loop_id, struct fc_port **conflict_sess)
 {
-	struct qla_tgt_sess *sess = NULL, *other_sess;
+	struct fc_port *sess = NULL, *other_sess;
 	uint64_t other_wwn;
+	scsi_qla_host_t *vha = tgt->vha;
 
 	*conflict_sess = NULL;
 
-	list_for_each_entry(other_sess, &tgt->sess_list, sess_list_entry) {
+	list_for_each_entry(other_sess, &vha->vp_fcports, list) {
 
 		other_wwn = wwn_to_u64(other_sess->port_name);
 
@@ -4301,7 +4053,7 @@ void qlt_logo_completion_handler(fc_port_t *fcport, int rc)
 		}
 
 		/* find other sess with nport_id collision */
-		if (port_id.b24 == other_sess->s_id.b24) {
+		if (port_id.b24 == other_sess->d_id.b24) {
 			if (loop_id != other_sess->loop_id) {
 				ql_dbg(ql_dbg_tgt_tmr, tgt->vha, 0x1000c,
 				    "Invalidating sess %p loop_id %d wwn %llx.\n",
@@ -4382,7 +4134,7 @@ static int qlt_24xx_handle_els(struct scsi_qla_host *vha,
 {
 	struct qla_tgt *tgt = vha->vha_tgt.qla_tgt;
 	struct qla_hw_data *ha = vha->hw;
-	struct qla_tgt_sess *sess = NULL, *conflict_sess = NULL;
+	struct fc_port *sess = NULL, *conflict_sess = NULL;
 	uint64_t wwn;
 	port_id_t port_id;
 	uint16_t loop_id;
@@ -4462,7 +4214,7 @@ static int qlt_24xx_handle_els(struct scsi_qla_host *vha,
 		  *    PLOGI and situation will correct itself.
 		  */
 		sess->keep_nport_handle = ((sess->loop_id == loop_id) &&
-					   (sess->s_id.b24 == port_id.b24));
+					   (sess->d_id.b24 == port_id.b24));
 		qlt_schedule_sess_for_deletion(sess, true);
 		break;
 
@@ -4510,7 +4262,7 @@ static int qlt_24xx_handle_els(struct scsi_qla_host *vha,
 
 			sess->local = 0;
 			sess->loop_id = loop_id;
-			sess->s_id = port_id;
+			sess->d_id = port_id;
 
 			if (wd3_lo & BIT_7)
 				sess->conf_compl_supported = 1;
@@ -4695,7 +4447,6 @@ static void qlt_handle_srr(struct scsi_qla_host *vha,
 	    (struct imm_ntfy_from_isp *)&imm->imm_ntfy;
 	struct qla_hw_data *ha = vha->hw;
 	struct qla_tgt_cmd *cmd = sctio->cmd;
-	struct se_cmd *se_cmd = &cmd->se_cmd;
 	unsigned long flags;
 	int xmit_type = 0, resp = 0;
 	uint32_t offset;
@@ -4707,6 +4458,8 @@ static void qlt_handle_srr(struct scsi_qla_host *vha,
 	ql_dbg(ql_dbg_tgt_mgt, vha, 0xf028, "SRR cmd %p, srr_ui %x\n",
 	    cmd, srr_ui);
 
+	ha->tgt.tgt_ops->srr_get_cur_state(cmd, SRR_STATUS);
+
 	switch (srr_ui) {
 	case SRR_IU_STATUS:
 		spin_lock_irqsave(&ha->hardware_lock, flags);
@@ -4724,13 +4477,13 @@ static void qlt_handle_srr(struct scsi_qla_host *vha,
 			dump_stack();
 			goto out_reject;
 		}
-		if (se_cmd->scsi_status != 0) {
+
+		if (cmd->scsi_status != 0) {
 			ql_dbg(ql_dbg_tgt, vha, 0xe02a,
 			    "Rejecting SRR_IU_DATA_IN with non GOOD "
 			    "scsi_status\n");
 			goto out_reject;
 		}
-		cmd->bufflen = se_cmd->data_length;
 
 		if (qlt_has_data(cmd)) {
 			if (qlt_srr_adjust_data(cmd, offset, &xmit_type) != 0)
@@ -4742,9 +4495,10 @@ static void qlt_handle_srr(struct scsi_qla_host *vha,
 			resp = 1;
 		} else {
 			ql_dbg(ql_dbg_tgt_mgt, vha, 0xf064,
-			       "qla_target(%d): SRR for in data for cmd without them (tag %lld, SCSI status %d), reject",
-			       vha->vp_idx, se_cmd->tag,
-			    cmd->se_cmd.scsi_status);
+			    "qla_target(%d): SRR for in data for cmd "
+			    "without them (tag %d, SCSI status %d), "
+			    "reject", vha->vp_idx, cmd->atio.u.isp24.exchange_addr,
+			    cmd->scsi_status);
 			goto out_reject;
 		}
 		break;
@@ -4756,13 +4510,13 @@ static void qlt_handle_srr(struct scsi_qla_host *vha,
 			dump_stack();
 			goto out_reject;
 		}
-		if (se_cmd->scsi_status != 0) {
+
+		if (cmd->scsi_status != 0) {
 			ql_dbg(ql_dbg_tgt, vha, 0xe02b,
 			    "Rejecting SRR_IU_DATA_OUT"
 			    " with non GOOD scsi_status\n");
 			goto out_reject;
 		}
-		cmd->bufflen = se_cmd->data_length;
 
 		if (qlt_has_data(cmd)) {
 			if (qlt_srr_adjust_data(cmd, offset, &xmit_type) != 0)
@@ -4772,13 +4526,15 @@ static void qlt_handle_srr(struct scsi_qla_host *vha,
 			    0, 0, 0, NOTIFY_ACK_SRR_FLAGS_ACCEPT, 0, 0);
 			spin_unlock_irqrestore(&ha->hardware_lock, flags);
 			if (xmit_type & QLA_TGT_XMIT_DATA) {
-				cmd->cmd_flags |= BIT_8;
+				cmd->trc_flags |= TRC_SRR_XRDY;
 				qlt_rdy_to_xfer(cmd);
 			}
 		} else {
 			ql_dbg(ql_dbg_tgt_mgt, vha, 0xf066,
-			    "qla_target(%d): SRR for out data for cmd without them (tag %lld, SCSI status %d), reject",
-			       vha->vp_idx, se_cmd->tag, cmd->se_cmd.scsi_status);
+			    "qla_target(%d): SRR for out data for cmd "
+			    "without them (tag %d, SCSI status %d), "
+			    "reject", vha->vp_idx, cmd->atio.u.isp24.exchange_addr,
+			    cmd->scsi_status);
 			goto out_reject;
 		}
 		break;
@@ -4791,8 +4547,8 @@ static void qlt_handle_srr(struct scsi_qla_host *vha,
 
 	/* Transmit response in case of status and data-in cases */
 	if (resp) {
-		cmd->cmd_flags |= BIT_7;
-		qlt_xmit_response(cmd, xmit_type, se_cmd->scsi_status);
+		cmd->trc_flags |= TRC_SRR_RSP;
+		qlt_xmit_response(cmd, xmit_type, cmd->scsi_status);
 	}
 
 	return;
@@ -4807,7 +4563,7 @@ static void qlt_handle_srr(struct scsi_qla_host *vha,
 		cmd->state = QLA_TGT_STATE_DATA_IN;
 		dump_stack();
 	} else {
-		cmd->cmd_flags |= BIT_9;
+		cmd->trc_flags |= TRC_SRR_TERM;
 		qlt_send_term_exchange(vha, cmd, &cmd->atio, 1, 0);
 	}
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
@@ -4852,7 +4608,6 @@ static void qlt_handle_srr_work(struct work_struct *work)
 	list_for_each_entry(sctio, &tgt->srr_ctio_list, srr_list_entry) {
 		struct qla_tgt_srr_imm *imm, *i, *ti;
 		struct qla_tgt_cmd *cmd;
-		struct se_cmd *se_cmd;
 
 		imm = NULL;
 		list_for_each_entry_safe(i, ti, &tgt->srr_imm_list,
@@ -4897,15 +4652,15 @@ static void qlt_handle_srr_work(struct work_struct *work)
 			cmd->sg = NULL;
 			cmd->free_sg = 0;
 		}
-		se_cmd = &cmd->se_cmd;
 
-		cmd->sg_cnt = se_cmd->t_data_nents;
-		cmd->sg = se_cmd->t_data_sg;
+		tgt->ha->tgt.tgt_ops->srr_get_cur_state(cmd, SRR_SG);
 
 		ql_dbg(ql_dbg_tgt_mgt, vha, 0xf02c,
-		       "SRR cmd %p (se_cmd %p, tag %lld, op %x), sg_cnt=%d, offset=%d",
-		       cmd, &cmd->se_cmd, se_cmd->tag, se_cmd->t_task_cdb ?
-		       se_cmd->t_task_cdb[0] : 0, cmd->sg_cnt, cmd->offset);
+		    "SRR cmd %p (ulp_cmd %p, tag %d, op %x), "
+		    "sg_cnt=%d, offset=%d",
+			cmd, cmd->ulp_cmd, cmd->atio.u.isp24.exchange_addr,
+			cmd->cdb ? cmd->cdb[0] : 0,
+		    cmd->sg_cnt, cmd->offset);
 
 		qlt_handle_srr(vha, sctio, imm);
 
@@ -5152,7 +4907,7 @@ static int __qlt_send_busy(struct scsi_qla_host *vha,
 	struct ctio7_to_24xx *ctio24;
 	struct qla_hw_data *ha = vha->hw;
 	request_t *pkt;
-	struct qla_tgt_sess *sess = NULL;
+	struct fc_port *sess = NULL;
 	unsigned long flags;
 
 	spin_lock_irqsave(&ha->tgt.sess_lock, flags);
@@ -5213,10 +4968,8 @@ static int __qlt_send_busy(struct scsi_qla_host *vha,
 {
 	struct qla_tgt *tgt = vha->vha_tgt.qla_tgt;
 	struct qla_hw_data *ha = vha->hw;
-	struct qla_tgt_sess *sess;
-	struct se_session *se_sess;
+	struct fc_port *sess;
 	struct qla_tgt_cmd *cmd;
-	int tag;
 
 	if (unlikely(tgt->tgt_stop)) {
 		ql_dbg(ql_dbg_io, vha, 0x300a,
@@ -5245,13 +4998,7 @@ static int __qlt_send_busy(struct scsi_qla_host *vha,
 	if (!sess)
 		return;
 
-	se_sess = sess->se_sess;
-
-	tag = percpu_ida_alloc(&se_sess->sess_tag_pool, TASK_RUNNING);
-	if (tag < 0)
-		return;
-
-	cmd = &((struct qla_tgt_cmd *)se_sess->sess_cmd_map)[tag];
+	cmd = ha->tgt.tgt_ops->alloc_cmd(sess);
 	if (!cmd) {
 		ql_dbg(ql_dbg_io, vha, 0x3009,
 			"qla_target(%d): %s: Allocation of cmd failed\n",
@@ -5267,8 +5014,6 @@ static int __qlt_send_busy(struct scsi_qla_host *vha,
 		return;
 	}
 
-	memset(cmd, 0, sizeof(struct qla_tgt_cmd));
-
 	qlt_incr_num_pend_cmds(vha);
 	INIT_LIST_HEAD(&cmd->cmd_list);
 	memcpy(&cmd->atio, atio, sizeof(*atio));
@@ -5353,7 +5098,7 @@ static int __qlt_send_busy(struct scsi_qla_host *vha,
 		/* This cmd was never sent to TCM.  There is no need
 		 * to schedule free or call free_cmd
 		 */
-		qlt_free_cmd(cmd);
+		ha->tgt.tgt_ops->release_cmd(cmd);
 	}
 	return rc;
 }
@@ -5748,6 +5493,7 @@ void qlt_async_event(uint16_t code, struct scsi_qla_host *vha,
 	case MBA_LOOP_DOWN:
 	case MBA_LIP_RESET:
 	case MBA_RSCN_UPDATE:
+	case MBA_REJECTED_FCP_CMD:
 		ql_dbg(ql_dbg_tgt_mgt, vha, 0xf03c,
 		    "qla_target(%d): Async event %#x occurred "
 		    "(m[0]=%x, m[1]=%x, m[2]=%x, m[3]=%x)", vha->vp_idx, code,
@@ -5785,7 +5531,7 @@ static fc_port_t *qlt_get_port_database(struct scsi_qla_host *vha,
 	fc_port_t *fcport;
 	int rc;
 
-	fcport = kzalloc(sizeof(*fcport), GFP_KERNEL);
+	fcport = qla2x00_alloc_fcport(vha, GFP_KERNEL);
 	if (!fcport) {
 		ql_dbg(ql_dbg_tgt_mgt, vha, 0xf06f,
 		    "qla_target(%d): Allocation of tmp FC port failed",
@@ -5801,7 +5547,7 @@ static fc_port_t *qlt_get_port_database(struct scsi_qla_host *vha,
 		    "qla_target(%d): Failed to retrieve fcport "
 		    "information -- get_port_database() returned %x "
 		    "(loop_id=0x%04x)", vha->vp_idx, rc, loop_id);
-		kfree(fcport);
+		qla2x00_free_fcport(fcport);
 		return NULL;
 	}
 
@@ -5809,10 +5555,10 @@ static fc_port_t *qlt_get_port_database(struct scsi_qla_host *vha,
 }
 
 /* Must be called under tgt_mutex */
-static struct qla_tgt_sess *qlt_make_local_sess(struct scsi_qla_host *vha,
+static struct fc_port *qlt_make_local_sess(struct scsi_qla_host *vha,
 	uint8_t *s_id)
 {
-	struct qla_tgt_sess *sess = NULL;
+	struct fc_port *sess = NULL;
 	fc_port_t *fcport = NULL;
 	int rc, global_resets;
 	uint16_t loop_id = 0;
@@ -5874,7 +5620,7 @@ static struct qla_tgt_sess *qlt_make_local_sess(struct scsi_qla_host *vha,
 
 	mutex_unlock(&vha->vha_tgt.tgt_mutex);
 
-	kfree(fcport);
+	qla2x00_free_fcport(fcport);
 	return sess;
 }
 
@@ -5883,7 +5629,7 @@ static void qlt_abort_work(struct qla_tgt *tgt,
 {
 	struct scsi_qla_host *vha = tgt->vha;
 	struct qla_hw_data *ha = vha->hw;
-	struct qla_tgt_sess *sess = NULL;
+	struct fc_port *sess = NULL;
 	unsigned long flags = 0, flags2 = 0;
 	uint32_t be_s_id;
 	uint8_t s_id[3];
@@ -5915,7 +5661,7 @@ static void qlt_abort_work(struct qla_tgt *tgt,
 			goto out_term2;
 		}
 
-		kref_get(&sess->sess_kref);
+		ha->tgt.tgt_ops->get_sess(sess);
 	}
 
 	spin_lock_irqsave(&ha->hardware_lock, flags);
@@ -5928,7 +5674,7 @@ static void qlt_abort_work(struct qla_tgt *tgt,
 		goto out_term;
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 
-	qlt_put_sess(sess);
+	ha->tgt.tgt_ops->put_sess(sess);
 	spin_unlock_irqrestore(&ha->tgt.sess_lock, flags2);
 	return;
 
@@ -5939,7 +5685,7 @@ static void qlt_abort_work(struct qla_tgt *tgt,
 	qlt_24xx_send_abts_resp(vha, &prm->abts, FCP_TMF_REJECTED, false);
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 
-	qlt_put_sess(sess);
+	ha->tgt.tgt_ops->put_sess(sess);
 	spin_unlock_irqrestore(&ha->tgt.sess_lock, flags2);
 }
 
@@ -5949,11 +5695,11 @@ static void qlt_tmr_work(struct qla_tgt *tgt,
 	struct atio_from_isp *a = &prm->tm_iocb2;
 	struct scsi_qla_host *vha = tgt->vha;
 	struct qla_hw_data *ha = vha->hw;
-	struct qla_tgt_sess *sess = NULL;
+	struct fc_port *sess = NULL;
 	unsigned long flags;
 	uint8_t *s_id = NULL; /* to hide compiler warnings */
 	int rc;
-	uint32_t lun, unpacked_lun;
+	u64 unpacked_lun;
 	int fn;
 	void *iocb;
 
@@ -5979,25 +5725,24 @@ static void qlt_tmr_work(struct qla_tgt *tgt,
 			goto out_term;
 		}
 
-		kref_get(&sess->sess_kref);
+		ha->tgt.tgt_ops->get_sess(sess);
 	}
 
 	iocb = a;
-	lun = a->u.isp24.fcp_cmnd.lun;
 	fn = a->u.isp24.fcp_cmnd.task_mgmt_flags;
-	unpacked_lun = scsilun_to_int((struct scsi_lun *)&lun);
+	unpacked_lun = scsilun_to_int((struct scsi_lun *)&a->u.isp24.fcp_cmnd.lun);
 
 	rc = qlt_issue_task_mgmt(sess, unpacked_lun, fn, iocb, 0);
 	if (rc != 0)
 		goto out_term;
 
-	qlt_put_sess(sess);
+	ha->tgt.tgt_ops->put_sess(sess);
 	spin_unlock_irqrestore(&ha->tgt.sess_lock, flags);
 	return;
 
 out_term:
 	qlt_send_term_exchange(vha, NULL, &prm->tm_iocb2, 1, 0);
-	qlt_put_sess(sess);
+	ha->tgt.tgt_ops->put_sess(sess);
 	spin_unlock_irqrestore(&ha->tgt.sess_lock, flags);
 }
 
@@ -6074,7 +5819,6 @@ int qlt_add_target(struct qla_hw_data *ha, struct scsi_qla_host *base_vha)
 	tgt->ha = ha;
 	tgt->vha = base_vha;
 	init_waitqueue_head(&tgt->waitQ);
-	INIT_LIST_HEAD(&tgt->sess_list);
 	INIT_LIST_HEAD(&tgt->del_sess_list);
 	INIT_DELAYED_WORK(&tgt->sess_del_work,
 		(void (*)(struct work_struct *))qlt_del_sess_work_fn);
@@ -6234,16 +5978,11 @@ int qlt_lport_register(void *target_lport_ptr, u64 phys_wwpn,
 void qlt_lport_deregister(struct scsi_qla_host *vha)
 {
 	struct qla_hw_data *ha = vha->hw;
-	struct Scsi_Host *sh = vha->host;
 	/*
 	 * Clear the target_lport_ptr qla_target_template pointer in qla_hw_data
 	 */
 	vha->vha_tgt.target_lport_ptr = NULL;
 	ha->tgt.tgt_ops = NULL;
-	/*
-	 * Release the Scsi_Host reference for the underlying qla2xxx host
-	 */
-	scsi_host_put(sh);
 }
 EXPORT_SYMBOL(qlt_lport_deregister);
 
@@ -6913,15 +6652,6 @@ int __init qlt_init(void)
 	if (!QLA_TGT_MODE_ENABLED())
 		return 0;
 
-	qla_tgt_mgmt_cmd_cachep = kmem_cache_create("qla_tgt_mgmt_cmd_cachep",
-	    sizeof(struct qla_tgt_mgmt_cmd), __alignof__(struct
-	    qla_tgt_mgmt_cmd), 0, NULL);
-	if (!qla_tgt_mgmt_cmd_cachep) {
-		ql_log(ql_log_fatal, NULL, 0xe06d,
-		    "kmem_cache_create for qla_tgt_mgmt_cmd_cachep failed\n");
-		return -ENOMEM;
-	}
-
 	qla_tgt_plogi_cachep = kmem_cache_create("qla_tgt_plogi_cachep",
 						 sizeof(qlt_plogi_ack_t),
 						 __alignof__(qlt_plogi_ack_t),
@@ -6931,16 +6661,7 @@ int __init qlt_init(void)
 		ql_log(ql_log_fatal, NULL, 0xe06d,
 		    "kmem_cache_create for qla_tgt_plogi_cachep failed\n");
 		ret = -ENOMEM;
-		goto out_mgmt_cmd_cachep;
-	}
-
-	qla_tgt_mgmt_cmd_mempool = mempool_create(25, mempool_alloc_slab,
-	    mempool_free_slab, qla_tgt_mgmt_cmd_cachep);
-	if (!qla_tgt_mgmt_cmd_mempool) {
-		ql_log(ql_log_fatal, NULL, 0xe06e,
-		    "mempool_create for qla_tgt_mgmt_cmd_mempool failed\n");
-		ret = -ENOMEM;
-		goto out_plogi_cachep;
+		return ret;
 	}
 
 	qla_tgt_wq = alloc_workqueue("qla_tgt_wq", 0, 0);
@@ -6948,19 +6669,15 @@ int __init qlt_init(void)
 		ql_log(ql_log_fatal, NULL, 0xe06f,
 		    "alloc_workqueue for qla_tgt_wq failed\n");
 		ret = -ENOMEM;
-		goto out_cmd_mempool;
+		goto out_plogi_cachep;
 	}
 	/*
 	 * Return 1 to signal that initiator-mode is being disabled
 	 */
 	return (ql2x_ini_mode == QLA2XXX_INI_MODE_DISABLED) ? 1 : 0;
 
-out_cmd_mempool:
-	mempool_destroy(qla_tgt_mgmt_cmd_mempool);
 out_plogi_cachep:
 	kmem_cache_destroy(qla_tgt_plogi_cachep);
-out_mgmt_cmd_cachep:
-	kmem_cache_destroy(qla_tgt_mgmt_cmd_cachep);
 	return ret;
 }
 
@@ -6970,7 +6687,5 @@ void qlt_exit(void)
 		return;
 
 	destroy_workqueue(qla_tgt_wq);
-	mempool_destroy(qla_tgt_mgmt_cmd_mempool);
 	kmem_cache_destroy(qla_tgt_plogi_cachep);
-	kmem_cache_destroy(qla_tgt_mgmt_cmd_cachep);
 }
diff --git a/drivers/scsi/qla2xxx/qla_target.h b/drivers/scsi/qla2xxx/qla_target.h
index f26c5f6..b09445d 100644
--- a/drivers/scsi/qla2xxx/qla_target.h
+++ b/drivers/scsi/qla2xxx/qla_target.h
@@ -709,36 +709,47 @@ struct abts_resp_from_24xx_fw {
 /********************************************************************\
  * Type Definitions used by initiator & target halves
 \********************************************************************/
+typedef enum {
+	SRR_STATUS,
+	SRR_SG,
+} srr_state_op_t;
 
 struct qla_tgt_mgmt_cmd;
-struct qla_tgt_sess;
-
+struct fc_port;
 /*
  * This structure provides a template of function calls that the
  * target driver (from within qla_target.c) can issue to the
  * target module (tcm_qla2xxx).
  */
 struct qla_tgt_func_tmpl {
-
 	int (*handle_cmd)(struct scsi_qla_host *, struct qla_tgt_cmd *,
-			unsigned char *, uint32_t, int, int, int);
+			unsigned char *, uint32_t, uint8_t, int, int);
 	void (*handle_data)(struct qla_tgt_cmd *);
 	void (*handle_dif_err)(struct qla_tgt_cmd *);
-	int (*handle_tmr)(struct qla_tgt_mgmt_cmd *, uint32_t, uint8_t,
+	int (*handle_tmr)(struct qla_tgt_mgmt_cmd *, u64, uint16_t,
 			uint32_t);
 	void (*free_cmd)(struct qla_tgt_cmd *);
 	void (*free_mcmd)(struct qla_tgt_mgmt_cmd *);
-	void (*free_session)(struct qla_tgt_sess *);
+	void (*free_mgmt_cmd)(struct qla_tgt_mgmt_cmd *);
+	void (*free_session)(struct fc_port *);
 
 	int (*check_initiator_node_acl)(struct scsi_qla_host *, unsigned char *,
-					struct qla_tgt_sess *);
-	void (*update_sess)(struct qla_tgt_sess *, port_id_t, uint16_t, bool);
-	struct qla_tgt_sess *(*find_sess_by_loop_id)(struct scsi_qla_host *,
+					struct fc_port *);
+	void (*update_sess)(struct fc_port *, port_id_t, uint16_t, bool);
+	struct fc_port *(*find_sess_by_loop_id)(struct scsi_qla_host *,
 						const uint16_t);
-	struct qla_tgt_sess *(*find_sess_by_s_id)(struct scsi_qla_host *,
+	struct fc_port *(*find_sess_by_s_id)(struct scsi_qla_host *,
 						const uint8_t *);
-	void (*clear_nacl_from_fcport_map)(struct qla_tgt_sess *);
-	void (*shutdown_sess)(struct qla_tgt_sess *);
+	void (*clear_nacl_from_fcport_map)(struct fc_port *);
+	void (*get_sess)(struct fc_port *);
+	void (*put_sess)(struct fc_port *);
+	void (*shutdown_sess)(struct fc_port *);
+	void (*release_cmd)(struct qla_tgt_cmd *);
+	struct qla_tgt_cmd * (*alloc_cmd)(struct fc_port *);
+	struct qla_tgt_mgmt_cmd * (*alloc_mgmt_cmd)(void);
+
+	/* support routine */
+	void (*srr_get_cur_state)(struct qla_tgt_cmd *, srr_state_op_t op);
 };
 
 int qla2x00_wait_for_hba_online(struct scsi_qla_host *);
@@ -775,6 +786,8 @@ struct qla_tgt_func_tmpl {
 #define QLA_TGT_ABORT_ALL               0xFFFE
 #define QLA_TGT_NEXUS_LOSS_SESS         0xFFFD
 #define QLA_TGT_NEXUS_LOSS              0xFFFC
+#define QLA_TGT_ABTS					0xFFFB
+#define QLA_TGT_2G_ABORT_TASK			0xFFFA
 
 /* Notify Acknowledge flags */
 #define NOTIFY_ACK_RES_COUNT        BIT_8
@@ -852,9 +865,6 @@ struct qla_tgt {
 	/* Count of sessions refering qla_tgt. Protected by hardware_lock. */
 	int sess_count;
 
-	/* Protected by hardware_lock. Addition also protected by tgt_mutex. */
-	struct list_head sess_list;
-
 	/* Protected by hardware_lock */
 	struct list_head del_sess_list;
 	struct delayed_work sess_del_work;
@@ -897,85 +907,31 @@ enum qla_sess_deletion {
 	QLA_SESS_DELETION_IN_PROGRESS	= 2,
 };
 
-typedef enum {
-	QLT_PLOGI_LINK_SAME_WWN,
-	QLT_PLOGI_LINK_CONFLICT,
-	QLT_PLOGI_LINK_MAX
-} qlt_plogi_link_t;
-
-typedef struct {
-	struct list_head		list;
-	struct imm_ntfy_from_isp	iocb;
-	port_id_t			id;
-	int				ref_count;
-} qlt_plogi_ack_t;
-
-/*
- * Equivilant to IT Nexus (Initiator-Target)
- */
-struct qla_tgt_sess {
-	uint16_t loop_id;
-	port_id_t s_id;
-
-	unsigned int conf_compl_supported:1;
-	unsigned int deleted:2;
-	unsigned int local:1;
-	unsigned int logout_on_delete:1;
-	unsigned int keep_nport_handle:1;
-	unsigned int send_els_logo:1;
-
-	unsigned char logout_completed;
-
-	int generation;
-
-	struct se_session *se_sess;
-	struct kref sess_kref;
-	struct scsi_qla_host *vha;
-	struct qla_tgt *tgt;
-
-	struct list_head sess_list_entry;
-	unsigned long expires;
-	struct list_head del_list_entry;
-
-	uint8_t port_name[WWN_SIZE];
-	struct work_struct free_work;
-
-	qlt_plogi_ack_t *plogi_link[QLT_PLOGI_LINK_MAX];
+enum trace_flags {
+	TRC_NEW_CMD = BIT_0,
+	TRC_DO_WORK = BIT_1,
+	TRC_DO_WORK_ERR = BIT_2,
+	TRC_XFR_RDY = BIT_3,
+	TRC_XMIT_DATA = BIT_4,
+	TRC_XMIT_STATUS = BIT_5,
+	TRC_SRR_RSP =  BIT_6,
+	TRC_SRR_XRDY = BIT_7,
+	TRC_SRR_TERM = BIT_8,
+	TRC_SRR_CTIO = BIT_9,
+	TRC_FLUSH = BIT_10,
+	TRC_CTIO_ERR = BIT_11,
+	TRC_CTIO_DONE = BIT_12,
+	TRC_CTIO_ABORTED =  BIT_13,
+	TRC_CTIO_STRANGE = BIT_14,
+	TRC_CMD_DONE = BIT_15,
+	TRC_CMD_CHK_STOP = BIT_16,
+	TRC_CMD_FREE = BIT_17,
+	TRC_DATA_IN = BIT_18,
 };
 
-typedef enum {
-	/*
-	 * BIT_0 - Atio Arrival / schedule to work
-	 * BIT_1 - qlt_do_work
-	 * BIT_2 - qlt_do work failed
-	 * BIT_3 - xfer rdy/tcm_qla2xxx_write_pending
-	 * BIT_4 - read respond/tcm_qla2xx_queue_data_in
-	 * BIT_5 - status respond / tcm_qla2xx_queue_status
-	 * BIT_6 - tcm request to abort/Term exchange.
-	 *	pre_xmit_response->qlt_send_term_exchange
-	 * BIT_7 - SRR received (qlt_handle_srr->qlt_xmit_response)
-	 * BIT_8 - SRR received (qlt_handle_srr->qlt_rdy_to_xfer)
-	 * BIT_9 - SRR received (qla_handle_srr->qlt_send_term_exchange)
-	 * BIT_10 - Data in - hanlde_data->tcm_qla2xxx_handle_data
-
-	 * BIT_12 - good completion - qlt_ctio_do_completion -->free_cmd
-	 * BIT_13 - Bad completion -
-	 *	qlt_ctio_do_completion --> qlt_term_ctio_exchange
-	 * BIT_14 - Back end data received/sent.
-	 * BIT_15 - SRR prepare ctio
-	 * BIT_16 - complete free
-	 * BIT_17 - flush - qlt_abort_cmd_on_host_reset
-	 * BIT_18 - completion w/abort status
-	 * BIT_19 - completion w/unknown status
-	 * BIT_20 - tcm_qla2xxx_free_cmd
-	 */
-	CMD_FLAG_DATA_WORK = BIT_11,
-	CMD_FLAG_DATA_WORK_FREE = BIT_21,
-} cmd_flags_t;
-
 struct qla_tgt_cmd {
-	struct se_cmd se_cmd;
-	struct qla_tgt_sess *sess;
+	void *ulp_cmd;
+	struct fc_port *sess;
 	int state;
 	struct work_struct free_work;
 	struct work_struct work;
@@ -994,14 +950,18 @@ struct qla_tgt_cmd {
 	unsigned int cmd_sent_to_fw:1;
 	unsigned int cmd_in_wq:1;
 	unsigned int aborted:1;
+	unsigned int data_work:1;
+	unsigned int data_work_free:1;
 
 	struct scatterlist *sg;	/* cmd data buffer SG vector */
 	int sg_cnt;		/* SG segments count */
 	int bufflen;		/* cmd buffer length */
 	int offset;
-	uint32_t unpacked_lun;
+	u64 unpacked_lun;
 	enum dma_data_direction dma_data_direction;
 	uint32_t reset_count;
+	int residual;				/* + = over, - = under */
+	int8_t scsi_status;
 
 	uint16_t loop_id;	/* to save extra sess dereferences */
 	struct qla_tgt *tgt;	/* to save extra sess dereferences */
@@ -1014,11 +974,13 @@ struct qla_tgt_cmd {
 	uint32_t prot_sg_cnt;
 	uint32_t blk_sz;
 	struct crc_context *ctx;
+	uint8_t  *cdb;
+	uint64_t lba;
 
 	uint64_t jiffies_at_alloc;
 	uint64_t jiffies_at_free;
 
-	cmd_flags_t cmd_flags;
+	enum trace_flags trc_flags;
 };
 
 struct qla_tgt_sess_work_param {
@@ -1036,10 +998,10 @@ struct qla_tgt_sess_work_param {
 };
 
 struct qla_tgt_mgmt_cmd {
-	uint8_t tmr_func;
+	uint16_t tmr_func;
 	uint8_t fc_tm_rsp;
-	struct qla_tgt_sess *sess;
-	struct se_cmd se_cmd;
+	struct fc_port *sess;
+	void *ulp_cmd;
 	struct work_struct free_work;
 	unsigned int flags;
 	uint32_t reset_count;
@@ -1101,7 +1063,7 @@ struct qla_tgt_srr_ctio {
 extern int qlt_lport_register(void *, u64, u64, u64,
 			int (*callback)(struct scsi_qla_host *, void *, u64, u64));
 extern void qlt_lport_deregister(struct scsi_qla_host *);
-void qlt_put_sess(struct qla_tgt_sess *sess);
+extern void qlt_unreg_sess(struct fc_port *);
 extern void qlt_fc_port_added(struct scsi_qla_host *, fc_port_t *);
 extern void qlt_fc_port_deleted(struct scsi_qla_host *, fc_port_t *, int);
 extern int __init qlt_init(void);
@@ -1159,7 +1121,6 @@ static inline void sid_to_portid(const uint8_t *s_id, port_id_t *p)
 extern int qlt_xmit_response(struct qla_tgt_cmd *, int, uint8_t);
 extern int qlt_abort_cmd(struct qla_tgt_cmd *);
 extern void qlt_xmit_tm_rsp(struct qla_tgt_mgmt_cmd *);
-extern void qlt_free_mcmd(struct qla_tgt_mgmt_cmd *);
 extern void qlt_free_cmd(struct qla_tgt_cmd *cmd);
 extern void qlt_async_event(uint16_t, struct scsi_qla_host *, uint16_t *);
 extern void qlt_enable_vha(struct scsi_qla_host *);
diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.c b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
index 6643f6f..3fef40b 100644
--- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
+++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
@@ -51,6 +51,50 @@
 static struct workqueue_struct *tcm_qla2xxx_free_wq;
 static struct workqueue_struct *tcm_qla2xxx_cmd_wq;
 
+static struct kmem_cache *tcm_qla_tgt_mgmt_cmd_cachep;
+static mempool_t *tcm_qla_tgt_mgmt_cmd_mempool;
+
+inline struct se_cmd *Q_TO_SE_CMD(struct qla_tgt_cmd *qcmd)
+{
+	struct tcm_qla_tgt_cmd *tc =
+		container_of(qcmd, struct tcm_qla_tgt_cmd, qcmd);
+
+	return &tc->se_cmd;
+}
+
+inline struct qla_tgt_cmd *SE_TO_Q_CMD(struct se_cmd *se_cmd)
+{
+	struct tcm_qla_tgt_cmd *tc =
+		container_of(se_cmd, struct tcm_qla_tgt_cmd, se_cmd);
+
+	return &tc->qcmd;
+}
+
+inline struct se_cmd *QMGT_TO_SE_CMD(struct qla_tgt_mgmt_cmd *qcmd)
+{
+	struct tcm_qla_tgt_mgmt_cmd *tc =
+		container_of(qcmd, struct tcm_qla_tgt_mgmt_cmd, mgt_cmd);
+
+	return &tc->se_cmd;
+}
+
+inline struct qla_tgt_mgmt_cmd *SE_TO_QMGT_CMD(struct se_cmd *se_cmd)
+{
+	struct tcm_qla_tgt_mgmt_cmd *tc =
+		container_of(se_cmd, struct tcm_qla_tgt_mgmt_cmd, se_cmd);
+
+	return &tc->mgt_cmd;
+}
+
+inline struct
+tcm_qla_tgt_mgmt_cmd *QMGT_TO_TMGT_CMD(struct qla_tgt_mgmt_cmd * qcmd)
+{
+	struct tcm_qla_tgt_mgmt_cmd *tc =
+		container_of(qcmd, struct tcm_qla_tgt_mgmt_cmd, mgt_cmd);
+
+	return tc;
+}
+
 /*
  * Parse WWN.
  * If strict, we require lower-case hex and colon separators to be sure
@@ -262,7 +306,7 @@ static void tcm_qla2xxx_complete_mcmd(struct work_struct *work)
 	struct qla_tgt_mgmt_cmd *mcmd = container_of(work,
 			struct qla_tgt_mgmt_cmd, free_work);
 
-	transport_generic_free_cmd(&mcmd->se_cmd, 0);
+	transport_generic_free_cmd(QMGT_TO_SE_CMD(mcmd), 0);
 }
 
 /*
@@ -276,17 +320,37 @@ static void tcm_qla2xxx_free_mcmd(struct qla_tgt_mgmt_cmd *mcmd)
 	queue_work(tcm_qla2xxx_free_wq, &mcmd->free_work);
 }
 
+static void tcm_qla2xxx_free_mgmt_cmd(struct qla_tgt_mgmt_cmd *qcmd)
+{
+	struct tcm_qla_tgt_mgmt_cmd *mcmd = QMGT_TO_TMGT_CMD(qcmd);
+	mempool_free(mcmd, tcm_qla_tgt_mgmt_cmd_mempool);
+}
+
+static struct qla_tgt_mgmt_cmd *tcm_qla2xxx_alloc_mgmt_cmd(void)
+{
+	struct tcm_qla_tgt_mgmt_cmd *tmcmd = NULL;
+	struct qla_tgt_mgmt_cmd *mcmd = NULL;
+
+	tmcmd = mempool_alloc(tcm_qla_tgt_mgmt_cmd_mempool, GFP_ATOMIC);
+	if (tmcmd) {
+		memset(tmcmd, 0, sizeof(struct tcm_qla_tgt_mgmt_cmd));
+		mcmd = &tmcmd->mgt_cmd;
+	}
+
+	return mcmd;
+}
+
 static void tcm_qla2xxx_complete_free(struct work_struct *work)
 {
 	struct qla_tgt_cmd *cmd = container_of(work, struct qla_tgt_cmd, work);
 
 	cmd->cmd_in_wq = 0;
 
-	WARN_ON(cmd->cmd_flags &  BIT_16);
+	WARN_ON(cmd->trc_flags & TRC_CMD_FREE);
 
 	cmd->vha->tgt_counters.qla_core_ret_sta_ctio++;
-	cmd->cmd_flags |= BIT_16;
-	transport_generic_free_cmd(&cmd->se_cmd, 0);
+	cmd->trc_flags |= TRC_CMD_FREE;
+	transport_generic_free_cmd(Q_TO_SE_CMD(cmd), 0);
 }
 
 /*
@@ -299,8 +363,8 @@ static void tcm_qla2xxx_free_cmd(struct qla_tgt_cmd *cmd)
 	cmd->vha->tgt_counters.core_qla_free_cmd++;
 	cmd->cmd_in_wq = 1;
 
-	BUG_ON(cmd->cmd_flags & BIT_20);
-	cmd->cmd_flags |= BIT_20;
+	BUG_ON(cmd->trc_flags & TRC_CMD_DONE);
+	cmd->trc_flags |= TRC_CMD_DONE;
 
 	INIT_WORK(&cmd->work, tcm_qla2xxx_complete_free);
 	queue_work_on(smp_processor_id(), tcm_qla2xxx_free_wq, &cmd->work);
@@ -314,34 +378,101 @@ static int tcm_qla2xxx_check_stop_free(struct se_cmd *se_cmd)
 	struct qla_tgt_cmd *cmd;
 
 	if ((se_cmd->se_cmd_flags & SCF_SCSI_TMR_CDB) == 0) {
-		cmd = container_of(se_cmd, struct qla_tgt_cmd, se_cmd);
-		cmd->cmd_flags |= BIT_14;
+		cmd = SE_TO_Q_CMD(se_cmd);
+		cmd->trc_flags |= TRC_CMD_CHK_STOP;
 	}
 
 	return target_put_sess_cmd(se_cmd);
 }
 
+static void tcm_qla2xxx_release_session(struct kref *kref)
+{
+	struct fc_port *sess = container_of(kref,
+	    struct fc_port, sess_kref);
+
+	qlt_unreg_sess(sess);
+}
+
+static void tcm_qla2xxx_put_sess(struct fc_port *sess)
+{
+	if (!sess)
+		return;
+
+	assert_spin_locked(&sess->vha->hw->tgt.sess_lock);
+	kref_put(&sess->sess_kref, tcm_qla2xxx_release_session);
+}
+
+static void tcm_qla2xxx_get_sess(struct fc_port *sess)
+{
+	if (!sess)
+		return;
+
+	kref_get(&sess->sess_kref);
+}
+
 /* tcm_qla2xxx_release_cmd - Callback from TCM Core to release underlying
  * fabric descriptor @se_cmd command to release
  */
 static void tcm_qla2xxx_release_cmd(struct se_cmd *se_cmd)
 {
 	struct qla_tgt_cmd *cmd;
+	struct se_session *se_sess;
 
 	if (se_cmd->se_cmd_flags & SCF_SCSI_TMR_CDB) {
-		struct qla_tgt_mgmt_cmd *mcmd = container_of(se_cmd,
-				struct qla_tgt_mgmt_cmd, se_cmd);
-		qlt_free_mcmd(mcmd);
+		tcm_qla2xxx_free_mgmt_cmd(SE_TO_QMGT_CMD(se_cmd));
 		return;
 	}
 
-	cmd = container_of(se_cmd, struct qla_tgt_cmd, se_cmd);
+	cmd = SE_TO_Q_CMD(se_cmd);
 	qlt_free_cmd(cmd);
+
+	if (!cmd->sess || !cmd->sess->se_sess) {
+		WARN_ON(1);
+		return;
+	}
+
+	se_sess = (struct se_session *)cmd->sess->se_sess;
+
+	cmd->jiffies_at_free = get_jiffies_64();
+	percpu_ida_free(&se_sess->sess_tag_pool, se_cmd->map_tag);
+}
+
+static void tcm_qla2xxx_rel_cmd(struct qla_tgt_cmd *cmd)
+{
+	tcm_qla2xxx_release_cmd(Q_TO_SE_CMD(cmd));
+}
+
+static struct qla_tgt_cmd *tcm_qla2xxx_alloc_cmd(struct fc_port *sess)
+{
+	struct se_session *se_sess = (struct se_session *)sess->se_sess;
+	int tag;
+	struct qla_tgt_cmd *cmd = NULL;
+	struct tcm_qla_tgt_cmd *tc = NULL;
+	struct qla_hw_data *ha = sess->vha->hw;
+
+	tag = percpu_ida_alloc(&se_sess->sess_tag_pool, TASK_RUNNING);
+	if (tag < 0)
+		return NULL;
+
+	tc = &((struct tcm_qla_tgt_cmd *)se_sess->sess_cmd_map)[tag];
+	if (tc) {
+		memset(tc, 0, sizeof(struct tcm_qla_tgt_cmd));
+		tc->se_cmd.map_tag = tag;
+		tc->se_cmd.cpuid = -1;
+
+		if (ha->msix_count)
+			tc->se_cmd.cpuid = ha->tgt.rspq_vector_cpuid;
+
+		tc->qcmd.ulp_cmd = (void *)&tc->se_cmd;
+		cmd = &tc->qcmd;
+	}
+
+	return cmd;
 }
 
 static void tcm_qla2xxx_close_session(struct se_session *se_sess)
 {
-	struct qla_tgt_sess *sess = se_sess->fabric_sess_ptr;
+	struct fc_port *sess = se_sess->fabric_sess_ptr;
 	struct scsi_qla_host *vha;
 	unsigned long flags;
 
@@ -350,7 +481,7 @@ static void tcm_qla2xxx_close_session(struct se_session *se_sess)
 
 	spin_lock_irqsave(&vha->hw->tgt.sess_lock, flags);
 	target_sess_cmd_list_set_waiting(se_sess);
-	qlt_put_sess(sess);
+	tcm_qla2xxx_put_sess(sess);
 	spin_unlock_irqrestore(&vha->hw->tgt.sess_lock, flags);
 }
 
@@ -371,13 +502,13 @@ static int tcm_qla2xxx_write_pending(struct se_cmd *se_cmd)
 		 */
 		pr_debug("write_pending aborted cmd[%p] refcount %d "
 			"transport_state %x, t_state %x, se_cmd_flags %x\n",
-			cmd,cmd->se_cmd.cmd_kref.refcount.counter,
-			cmd->se_cmd.transport_state,
-			cmd->se_cmd.t_state,
-			cmd->se_cmd.se_cmd_flags);
+			cmd, se_cmd->cmd_kref.refcount.counter,
+			se_cmd->transport_state,
+			se_cmd->t_state,
+			se_cmd->se_cmd_flags);
 		return 0;
 	}
-	cmd->cmd_flags |= BIT_3;
+	cmd->trc_flags |= TRC_XFR_RDY;
 	cmd->bufflen = se_cmd->data_length;
 	cmd->dma_data_direction = target_reverse_dma_direction(se_cmd);
 
@@ -388,6 +519,8 @@ static int tcm_qla2xxx_write_pending(struct se_cmd *se_cmd)
 	cmd->prot_sg = se_cmd->t_prot_sg;
 	cmd->blk_sz  = se_cmd->se_dev->dev_attrib.block_size;
 	se_cmd->pi_err = 0;
+	cmd->cdb = se_cmd->t_task_cdb;
+	cmd->lba = se_cmd->t_task_lba;
 
 	/*
 	 * qla_target.c:qlt_rdy_to_xfer() will call pci_map_sg() to setup
@@ -424,8 +557,7 @@ static void tcm_qla2xxx_set_default_node_attrs(struct se_node_acl *nacl)
 static int tcm_qla2xxx_get_cmd_state(struct se_cmd *se_cmd)
 {
 	if (!(se_cmd->se_cmd_flags & SCF_SCSI_TMR_CDB)) {
-		struct qla_tgt_cmd *cmd = container_of(se_cmd,
-				struct qla_tgt_cmd, se_cmd);
+		struct qla_tgt_cmd *cmd = SE_TO_Q_CMD(se_cmd);
 		return cmd->state;
 	}
 
@@ -436,18 +568,43 @@ static int tcm_qla2xxx_get_cmd_state(struct se_cmd *se_cmd)
  * Called from process context in qla_target.c:qlt_do_work() code
  */
 static int tcm_qla2xxx_handle_cmd(scsi_qla_host_t *vha, struct qla_tgt_cmd *cmd,
-	unsigned char *cdb, uint32_t data_length, int fcp_task_attr,
+	unsigned char *cdb, uint32_t data_length, uint8_t task_codes,
 	int data_dir, int bidi)
 {
-	struct se_cmd *se_cmd = &cmd->se_cmd;
+	struct se_cmd *se_cmd =  Q_TO_SE_CMD(cmd);
 	struct se_session *se_sess;
-	struct qla_tgt_sess *sess;
+	struct fc_port *sess;
 #ifdef CONFIG_TCM_QLA2XXX_DEBUG
 	struct se_portal_group *se_tpg;
 	struct tcm_qla2xxx_tpg *tpg;
 #endif
+	int fcp_task_attr;
 	int flags = TARGET_SCF_ACK_KREF;
 
+
+	switch (task_codes) {
+	case ATIO_SIMPLE_QUEUE:
+		fcp_task_attr = TCM_SIMPLE_TAG;
+		break;
+	case ATIO_HEAD_OF_QUEUE:
+		fcp_task_attr = TCM_HEAD_TAG;
+		break;
+	case ATIO_ORDERED_QUEUE:
+		fcp_task_attr = TCM_ORDERED_TAG;
+		break;
+	case ATIO_ACA_QUEUE:
+		fcp_task_attr = TCM_ACA_TAG;
+		break;
+	case ATIO_UNTAGGED:
+		fcp_task_attr = TCM_SIMPLE_TAG;
+		break;
+	default:
+		pr_err("qla_target: unknown task code %x, use ORDERED instead\n",
+		    task_codes);
+		fcp_task_attr = TCM_ORDERED_TAG;
+		break;
+	}
+
 	if (bidi)
 		flags |= TARGET_SCF_BIDI_OP;
 
@@ -456,10 +613,11 @@ static int tcm_qla2xxx_handle_cmd(scsi_qla_host_t *vha, struct qla_tgt_cmd *cmd,
 
 	sess = cmd->sess;
 	if (!sess) {
-		pr_err("Unable to locate struct qla_tgt_sess from qla_tgt_cmd\n");
+		pr_err("Unable to locate struct fc_port from qla_tgt_cmd\n");
 		return -EINVAL;
 	}
 
+	se_cmd->tag = cmd->atio.u.isp24.exchange_addr;
 	se_sess = sess->se_sess;
 	if (!se_sess) {
 		pr_err("Unable to locate active struct se_session\n");
@@ -485,6 +643,7 @@ static void tcm_qla2xxx_handle_data_work(struct work_struct *work)
 {
 	struct qla_tgt_cmd *cmd = container_of(work, struct qla_tgt_cmd, work);
 	unsigned long flags;
+	struct se_cmd *se_cmd = Q_TO_SE_CMD(cmd);
 
 	/*
 	 * Ensure that the complete FCP WRITE payload has been received.
@@ -493,9 +652,9 @@ static void tcm_qla2xxx_handle_data_work(struct work_struct *work)
 	cmd->cmd_in_wq = 0;
 
 	spin_lock_irqsave(&cmd->cmd_lock, flags);
-	cmd->cmd_flags |= CMD_FLAG_DATA_WORK;
+	cmd->data_work = 1;
 	if (cmd->aborted) {
-		cmd->cmd_flags |= CMD_FLAG_DATA_WORK_FREE;
+		cmd->data_work_free = 1;
 		spin_unlock_irqrestore(&cmd->cmd_lock, flags);
 
 		tcm_qla2xxx_free_cmd(cmd);
@@ -509,22 +668,22 @@ static void tcm_qla2xxx_handle_data_work(struct work_struct *work)
 		 * Check if se_cmd has already been aborted via LUN_RESET, and
 		 * waiting upon completion in tcm_qla2xxx_write_pending_status()
 		 */
-		if (cmd->se_cmd.transport_state & CMD_T_ABORTED) {
-			complete(&cmd->se_cmd.t_transport_stop_comp);
+		if (se_cmd->transport_state & CMD_T_ABORTED) {
+			complete(&se_cmd->t_transport_stop_comp);
 			return;
 		}
 
-		if (cmd->se_cmd.pi_err)
-			transport_generic_request_failure(&cmd->se_cmd,
-				cmd->se_cmd.pi_err);
+		if (se_cmd->pi_err)
+			transport_generic_request_failure(se_cmd,
+				se_cmd->pi_err);
 		else
-			transport_generic_request_failure(&cmd->se_cmd,
+			transport_generic_request_failure(se_cmd,
 				TCM_CHECK_CONDITION_ABORT_CMD);
 
 		return;
 	}
 
-	return target_execute_cmd(&cmd->se_cmd);
+	return target_execute_cmd(se_cmd);
 }
 
 /*
@@ -532,7 +691,7 @@ static void tcm_qla2xxx_handle_data_work(struct work_struct *work)
  */
 static void tcm_qla2xxx_handle_data(struct qla_tgt_cmd *cmd)
 {
-	cmd->cmd_flags |= BIT_10;
+	cmd->trc_flags |= TRC_DATA_IN;
 	cmd->cmd_in_wq = 1;
 	INIT_WORK(&cmd->work, tcm_qla2xxx_handle_data_work);
 	queue_work_on(smp_processor_id(), tcm_qla2xxx_free_wq, &cmd->work);
@@ -546,8 +705,8 @@ static void tcm_qla2xxx_handle_dif_work(struct work_struct *work)
 	 * need to wait for SCSI status/check condition to
 	 * finish responding generate by transport_generic_request_failure.
 	 */
-	kref_get(&cmd->se_cmd.cmd_kref);
-	transport_generic_request_failure(&cmd->se_cmd, cmd->se_cmd.pi_err);
+	kref_get(&se_cmd->cmd_kref);
+	transport_generic_request_failure(se_cmd, se_cmd->pi_err);
 }
 
 /*
@@ -562,20 +721,113 @@ static void tcm_qla2xxx_handle_dif_err(struct qla_tgt_cmd *cmd)
 /*
  * Called from qla_target.c:qlt_issue_task_mgmt()
  */
-static int tcm_qla2xxx_handle_tmr(struct qla_tgt_mgmt_cmd *mcmd, uint32_t lun,
-	uint8_t tmr_func, uint32_t tag)
+static int tcm_qla2xxx_handle_tmr(struct qla_tgt_mgmt_cmd *mcmd, u64 lun,
+	uint16_t tmr_func, uint32_t tag)
 {
-	struct qla_tgt_sess *sess = mcmd->sess;
-	struct se_cmd *se_cmd = &mcmd->se_cmd;
+	struct fc_port *sess = mcmd->sess;
+	struct se_cmd *se_cmd = QMGT_TO_SE_CMD(mcmd);
+	struct se_session *se_sess = sess->se_sess;
+	bool found_lun = false;
+	unsigned long flags;
+	int transl_tmr_func;
+
+	switch (tmr_func) {
+	case QLA_TGT_ABTS:
+		spin_lock_irqsave(&se_sess->sess_cmd_lock, flags);
+		list_for_each_entry(se_cmd, &se_sess->sess_cmd_list, se_cmd_list) {
+			struct qla_tgt_cmd *cmd = SE_TO_Q_CMD(se_cmd);
+			struct abts_recv_from_24xx *abts = &mcmd->orig_iocb.abts;
+
+			if (se_cmd->tag == abts->exchange_addr_to_abort) {
+				lun = cmd->unpacked_lun;
+				found_lun = true;
+				break;
+			}
+		}
+		spin_unlock_irqrestore(&se_sess->sess_cmd_lock, flags);
+		if (!found_lun)
+			return -ENOBUFS;
+
+		pr_debug("%ld: ABTS received\n",
+			sess->vha->host_no);
+
+		transl_tmr_func = TMR_ABORT_TASK;
+		break;
+
+	case QLA_TGT_2G_ABORT_TASK:
+		pr_debug("%ld: 2G Abort Task received\n",
+			sess->vha->host_no);
+		transl_tmr_func = TMR_ABORT_TASK;
+		break;
+
+	case QLA_TGT_CLEAR_ACA:
+		pr_debug("%ld: CLEAR_ACA received\n",
+			sess->vha->host_no);
+		transl_tmr_func = TMR_CLEAR_ACA;
+		break;
+
+	case QLA_TGT_TARGET_RESET:
+		pr_debug("%ld: TARGET_RESET received\n",
+		    sess->vha->host_no);
+		transl_tmr_func = TMR_TARGET_WARM_RESET;
+		break;
+
+	case QLA_TGT_LUN_RESET:
+		pr_debug("%ld: LUN_RESET received\n",
+			sess->vha->host_no);
+		transl_tmr_func = TMR_LUN_RESET;
+		break;
+
+	case QLA_TGT_CLEAR_TS:
+		pr_debug("%ld: CLEAR_TS received\n",
+			sess->vha->host_no);
+		transl_tmr_func = TMR_CLEAR_TASK_SET;
+		break;
+
+	case QLA_TGT_ABORT_TS:
+		pr_debug("%ld: ABORT_TS received\n",
+			sess->vha->host_no);
+		transl_tmr_func = TMR_ABORT_TASK_SET;
+		break;
+#if 0
+	case QLA_TGT_ABORT_ALL:
+		pr_debug("%d: Doing ABORT_ALL_TASKS\n",
+		    sess->vha->vp_idx);
+		transl_tmr_func = 0;
+		break;
+
+	case QLA_TGT_ABORT_ALL_SESS:
+		pr_debug("%d: Doing ABORT_ALL_TASKS_SESS\n",
+		    sess->vha->vp_idx);
+		transl_tmr_func = 0;
+		break;
+
+	case QLA_TGT_NEXUS_LOSS_SESS:
+		pr_debug("%d: Doing NEXUS_LOSS_SESS\n",
+		    sess->vha->vp_idx);
+		transl_tmr_func = 0;
+		break;
+
+	case QLA_TGT_NEXUS_LOSS:
+		pr_debug("%d: Doing NEXUS_LOSS\n", sess->vha->vp_idx);
+		transl_tmr_func = 0;
+		break;
+#endif
+
+	default:
+		pr_debug("%ld: Unknown task mgmt fn 0x%x\n",
+		    sess->vha->host_no, tmr_func);
+		return -ENOSYS;
+		break;
+	}
 
 	return target_submit_tmr(se_cmd, sess->se_sess, NULL, lun, mcmd,
-			tmr_func, GFP_ATOMIC, tag, TARGET_SCF_ACK_KREF);
+			transl_tmr_func, GFP_ATOMIC, tag, TARGET_SCF_ACK_KREF);
 }
 
 static int tcm_qla2xxx_queue_data_in(struct se_cmd *se_cmd)
 {
-	struct qla_tgt_cmd *cmd = container_of(se_cmd,
-				struct qla_tgt_cmd, se_cmd);
+	struct qla_tgt_cmd *cmd = SE_TO_Q_CMD(se_cmd);
 
 	if (cmd->aborted) {
 		/* Cmd can loop during Q-full.  tcm_qla2xxx_aborted_task
@@ -584,14 +836,14 @@ static int tcm_qla2xxx_queue_data_in(struct se_cmd *se_cmd)
 		 */
 		pr_debug("queue_data_in aborted cmd[%p] refcount %d "
 			"transport_state %x, t_state %x, se_cmd_flags %x\n",
-			cmd,cmd->se_cmd.cmd_kref.refcount.counter,
-			cmd->se_cmd.transport_state,
-			cmd->se_cmd.t_state,
-			cmd->se_cmd.se_cmd_flags);
+			cmd, se_cmd->cmd_kref.refcount.counter,
+			se_cmd->transport_state,
+			se_cmd->t_state,
+			se_cmd->se_cmd_flags);
 		return 0;
 	}
 
-	cmd->cmd_flags |= BIT_4;
+	cmd->trc_flags |= TRC_XMIT_DATA;
 	cmd->bufflen = se_cmd->data_length;
 	cmd->dma_data_direction = target_reverse_dma_direction(se_cmd);
 
@@ -603,6 +855,13 @@ static int tcm_qla2xxx_queue_data_in(struct se_cmd *se_cmd)
 	cmd->prot_sg = se_cmd->t_prot_sg;
 	cmd->blk_sz  = se_cmd->se_dev->dev_attrib.block_size;
 	se_cmd->pi_err = 0;
+	cmd->cdb = se_cmd->t_task_cdb;
+	cmd->lba = se_cmd->t_task_lba;
+
+	if (se_cmd->se_cmd_flags & SCF_UNDERFLOW_BIT)
+		cmd->residual = -(se_cmd->residual_count);
+	else if (se_cmd->se_cmd_flags & SCF_OVERFLOW_BIT)
+		cmd->residual = se_cmd->residual_count;
 
 	/*
 	 * Now queue completed DATA_IN the qla2xxx LLD and response ring
@@ -613,8 +872,8 @@ static int tcm_qla2xxx_queue_data_in(struct se_cmd *se_cmd)
 
 static int tcm_qla2xxx_queue_status(struct se_cmd *se_cmd)
 {
-	struct qla_tgt_cmd *cmd = container_of(se_cmd,
-				struct qla_tgt_cmd, se_cmd);
+	struct qla_tgt_cmd *cmd = SE_TO_Q_CMD(se_cmd);
+
 	int xmit_type = QLA_TGT_XMIT_STATUS;
 
 	cmd->bufflen = se_cmd->data_length;
@@ -622,11 +881,11 @@ static int tcm_qla2xxx_queue_status(struct se_cmd *se_cmd)
 	cmd->sg_cnt = 0;
 	cmd->offset = 0;
 	cmd->dma_data_direction = target_reverse_dma_direction(se_cmd);
-	if (cmd->cmd_flags &  BIT_5) {
-		pr_crit("Bit_5 already set for cmd = %p.\n", cmd);
+	if (cmd->trc_flags & TRC_XMIT_STATUS) {
+		pr_crit("Multiple calls for status = %p.\n", cmd);
 		dump_stack();
 	}
-	cmd->cmd_flags |= BIT_5;
+	cmd->trc_flags |= TRC_XMIT_STATUS;
 
 	if (se_cmd->data_direction == DMA_FROM_DEVICE) {
 		/*
@@ -642,6 +901,12 @@ static int tcm_qla2xxx_queue_status(struct se_cmd *se_cmd)
 
 		cmd->bufflen = 0;
 	}
+
+	if (se_cmd->se_cmd_flags & SCF_UNDERFLOW_BIT)
+		cmd->residual = -(se_cmd->residual_count);
+	else if (se_cmd->se_cmd_flags & SCF_OVERFLOW_BIT)
+		cmd->residual = se_cmd->residual_count;
+
 	/*
 	 * Now queue status response to qla2xxx LLD code and response ring
 	 */
@@ -651,8 +916,8 @@ static int tcm_qla2xxx_queue_status(struct se_cmd *se_cmd)
 static void tcm_qla2xxx_queue_tm_rsp(struct se_cmd *se_cmd)
 {
 	struct se_tmr_req *se_tmr = se_cmd->se_tmr_req;
-	struct qla_tgt_mgmt_cmd *mcmd = container_of(se_cmd,
-				struct qla_tgt_mgmt_cmd, se_cmd);
+	struct qla_tgt_mgmt_cmd *mcmd = SE_TO_QMGT_CMD(se_cmd);
+
 
 	pr_debug("queue_tm_rsp: mcmd: %p func: 0x%02x response: 0x%02x\n",
 			mcmd, se_tmr->function, se_tmr->response);
@@ -683,24 +948,22 @@ static void tcm_qla2xxx_queue_tm_rsp(struct se_cmd *se_cmd)
 }
 
 
-#define DATA_WORK_NOT_FREE(_flags) \
-	(( _flags & (CMD_FLAG_DATA_WORK|CMD_FLAG_DATA_WORK_FREE)) == \
-	 CMD_FLAG_DATA_WORK)
+#define DATA_WORK_NOT_FREE(_cmd) (_cmd->data_work && !_cmd->data_work_free)
+
 static void tcm_qla2xxx_aborted_task(struct se_cmd *se_cmd)
 {
-	struct qla_tgt_cmd *cmd = container_of(se_cmd,
-				struct qla_tgt_cmd, se_cmd);
+	struct qla_tgt_cmd *cmd = SE_TO_Q_CMD(se_cmd);
 	unsigned long flags;
 
 	if (qlt_abort_cmd(cmd))
 		return;
 
 	spin_lock_irqsave(&cmd->cmd_lock, flags);
-	if ((cmd->state == QLA_TGT_STATE_NEW)||
+	if ((cmd->state == QLA_TGT_STATE_NEW) ||
 		((cmd->state == QLA_TGT_STATE_DATA_IN) &&
-		 DATA_WORK_NOT_FREE(cmd->cmd_flags)) ) {
+		 DATA_WORK_NOT_FREE(cmd))) {
 
-		cmd->cmd_flags |= CMD_FLAG_DATA_WORK_FREE;
+		cmd->data_work_free = 1;
 		spin_unlock_irqrestore(&cmd->cmd_lock, flags);
 		/* Cmd have not reached firmware.
 		 * Use this trigger to free it. */
@@ -713,13 +976,14 @@ static void tcm_qla2xxx_aborted_task(struct se_cmd *se_cmd)
 }
 
 static void tcm_qla2xxx_clear_sess_lookup(struct tcm_qla2xxx_lport *,
-			struct tcm_qla2xxx_nacl *, struct qla_tgt_sess *);
+			struct tcm_qla2xxx_nacl *, struct fc_port *);
 /*
  * Expected to be called with struct qla_hw_data->tgt.sess_lock held
  */
-static void tcm_qla2xxx_clear_nacl_from_fcport_map(struct qla_tgt_sess *sess)
+static void tcm_qla2xxx_clear_nacl_from_fcport_map(struct fc_port *sess)
 {
-	struct se_node_acl *se_nacl = sess->se_sess->se_node_acl;
+	struct se_node_acl *se_nacl =
+	    ((struct se_session *)sess->se_sess)->se_node_acl;
 	struct se_portal_group *se_tpg = se_nacl->se_tpg;
 	struct se_wwn *se_wwn = se_tpg->se_tpg_wwn;
 	struct tcm_qla2xxx_lport *lport = container_of(se_wwn,
@@ -756,7 +1020,7 @@ static void tcm_qla2xxx_clear_nacl_from_fcport_map(struct qla_tgt_sess *sess)
 	tcm_qla2xxx_clear_sess_lookup(lport, nacl, sess);
 }
 
-static void tcm_qla2xxx_shutdown_sess(struct qla_tgt_sess *sess)
+static void tcm_qla2xxx_shutdown_sess(struct fc_port *sess)
 {
 	assert_spin_locked(&sess->vha->hw->tgt.sess_lock);
 	target_sess_cmd_list_set_waiting(sess->se_sess);
@@ -1141,7 +1405,7 @@ static struct se_portal_group *tcm_qla2xxx_npiv_make_tpg(
 /*
  * Expected to be called with struct qla_hw_data->tgt.sess_lock held
  */
-static struct qla_tgt_sess *tcm_qla2xxx_find_sess_by_s_id(
+static struct fc_port *tcm_qla2xxx_find_sess_by_s_id(
 	scsi_qla_host_t *vha,
 	const uint8_t *s_id)
 {
@@ -1169,12 +1433,12 @@ static struct qla_tgt_sess *tcm_qla2xxx_find_sess_by_s_id(
 	    se_nacl, se_nacl->initiatorname);
 
 	nacl = container_of(se_nacl, struct tcm_qla2xxx_nacl, se_node_acl);
-	if (!nacl->qla_tgt_sess) {
-		pr_err("Unable to locate struct qla_tgt_sess\n");
+	if (!nacl->fc_port) {
+		pr_err("Unable to locate struct fc_port\n");
 		return NULL;
 	}
 
-	return nacl->qla_tgt_sess;
+	return nacl->fc_port;
 }
 
 /*
@@ -1185,7 +1449,7 @@ static void tcm_qla2xxx_set_sess_by_s_id(
 	struct se_node_acl *new_se_nacl,
 	struct tcm_qla2xxx_nacl *nacl,
 	struct se_session *se_sess,
-	struct qla_tgt_sess *qla_tgt_sess,
+	struct fc_port *fc_port,
 	uint8_t *s_id)
 {
 	u32 key;
@@ -1209,22 +1473,22 @@ static void tcm_qla2xxx_set_sess_by_s_id(
 			pr_debug("Wiping nonexisting fc_port entry\n");
 		}
 
-		qla_tgt_sess->se_sess = se_sess;
-		nacl->qla_tgt_sess = qla_tgt_sess;
+		fc_port->se_sess = se_sess;
+		nacl->fc_port = fc_port;
 		return;
 	}
 
-	if (nacl->qla_tgt_sess) {
+	if (nacl->fc_port) {
 		if (new_se_nacl == NULL) {
-			pr_debug("Clearing existing nacl->qla_tgt_sess and fc_port entry\n");
+			pr_debug("Clearing existing nacl->fc_port and fc_port entry\n");
 			btree_remove32(&lport->lport_fcport_map, key);
-			nacl->qla_tgt_sess = NULL;
+			nacl->fc_port = NULL;
 			return;
 		}
-		pr_debug("Replacing existing nacl->qla_tgt_sess and fc_port entry\n");
+		pr_debug("Replacing existing nacl->fc_port and fc_port entry\n");
 		btree_update32(&lport->lport_fcport_map, key, new_se_nacl);
-		qla_tgt_sess->se_sess = se_sess;
-		nacl->qla_tgt_sess = qla_tgt_sess;
+		fc_port->se_sess = se_sess;
+		nacl->fc_port = fc_port;
 		return;
 	}
 
@@ -1234,19 +1498,19 @@ static void tcm_qla2xxx_set_sess_by_s_id(
 		return;
 	}
 
-	pr_debug("Replacing existing fc_port entry w/o active nacl->qla_tgt_sess\n");
+	pr_debug("Replacing existing fc_port entry w/o active nacl->fc_port\n");
 	btree_update32(&lport->lport_fcport_map, key, new_se_nacl);
-	qla_tgt_sess->se_sess = se_sess;
-	nacl->qla_tgt_sess = qla_tgt_sess;
+	fc_port->se_sess = se_sess;
+	nacl->fc_port = fc_port;
 
-	pr_debug("Setup nacl->qla_tgt_sess %p by s_id for se_nacl: %p, initiatorname: %s\n",
-	    nacl->qla_tgt_sess, new_se_nacl, new_se_nacl->initiatorname);
+	pr_debug("Setup nacl->fc_port %p by s_id for se_nacl: %p, initiatorname: %s\n",
+	    nacl->fc_port, new_se_nacl, new_se_nacl->initiatorname);
 }
 
 /*
  * Expected to be called with struct qla_hw_data->tgt.sess_lock held
  */
-static struct qla_tgt_sess *tcm_qla2xxx_find_sess_by_loop_id(
+static struct fc_port *tcm_qla2xxx_find_sess_by_loop_id(
 	scsi_qla_host_t *vha,
 	const uint16_t loop_id)
 {
@@ -1274,12 +1538,12 @@ static struct qla_tgt_sess *tcm_qla2xxx_find_sess_by_loop_id(
 
 	nacl = container_of(se_nacl, struct tcm_qla2xxx_nacl, se_node_acl);
 
-	if (!nacl->qla_tgt_sess) {
-		pr_err("Unable to locate struct qla_tgt_sess\n");
+	if (!nacl->fc_port) {
+		pr_err("Unable to locate struct fc_port\n");
 		return NULL;
 	}
 
-	return nacl->qla_tgt_sess;
+	return nacl->fc_port;
 }
 
 /*
@@ -1290,7 +1554,7 @@ static void tcm_qla2xxx_set_sess_by_loop_id(
 	struct se_node_acl *new_se_nacl,
 	struct tcm_qla2xxx_nacl *nacl,
 	struct se_session *se_sess,
-	struct qla_tgt_sess *qla_tgt_sess,
+	struct fc_port *fc_port,
 	uint16_t loop_id)
 {
 	struct se_node_acl *saved_nacl;
@@ -1305,27 +1569,27 @@ static void tcm_qla2xxx_set_sess_by_loop_id(
 	if (!saved_nacl) {
 		pr_debug("Setting up new fc_loopid->se_nacl to new_se_nacl\n");
 		fc_loopid->se_nacl = new_se_nacl;
-		if (qla_tgt_sess->se_sess != se_sess)
-			qla_tgt_sess->se_sess = se_sess;
-		if (nacl->qla_tgt_sess != qla_tgt_sess)
-			nacl->qla_tgt_sess = qla_tgt_sess;
+		if (fc_port->se_sess != se_sess)
+			fc_port->se_sess = se_sess;
+		if (nacl->fc_port != fc_port)
+			nacl->fc_port = fc_port;
 		return;
 	}
 
-	if (nacl->qla_tgt_sess) {
+	if (nacl->fc_port) {
 		if (new_se_nacl == NULL) {
-			pr_debug("Clearing nacl->qla_tgt_sess and fc_loopid->se_nacl\n");
+			pr_debug("Clearing nacl->fc_port and fc_loopid->se_nacl\n");
 			fc_loopid->se_nacl = NULL;
-			nacl->qla_tgt_sess = NULL;
+			nacl->fc_port = NULL;
 			return;
 		}
 
-		pr_debug("Replacing existing nacl->qla_tgt_sess and fc_loopid->se_nacl\n");
+		pr_debug("Replacing existing nacl->fc_port and fc_loopid->se_nacl\n");
 		fc_loopid->se_nacl = new_se_nacl;
-		if (qla_tgt_sess->se_sess != se_sess)
-			qla_tgt_sess->se_sess = se_sess;
-		if (nacl->qla_tgt_sess != qla_tgt_sess)
-			nacl->qla_tgt_sess = qla_tgt_sess;
+		if (fc_port->se_sess != se_sess)
+			fc_port->se_sess = se_sess;
+		if (nacl->fc_port != fc_port)
+			nacl->fc_port = fc_port;
 		return;
 	}
 
@@ -1335,29 +1599,29 @@ static void tcm_qla2xxx_set_sess_by_loop_id(
 		return;
 	}
 
-	pr_debug("Replacing existing fc_loopid->se_nacl w/o active nacl->qla_tgt_sess\n");
+	pr_debug("Replacing existing fc_loopid->se_nacl w/o active nacl->fc_port\n");
 	fc_loopid->se_nacl = new_se_nacl;
-	if (qla_tgt_sess->se_sess != se_sess)
-		qla_tgt_sess->se_sess = se_sess;
-	if (nacl->qla_tgt_sess != qla_tgt_sess)
-		nacl->qla_tgt_sess = qla_tgt_sess;
+	if (fc_port->se_sess != se_sess)
+		fc_port->se_sess = se_sess;
+	if (nacl->fc_port != fc_port)
+		nacl->fc_port = fc_port;
 
-	pr_debug("Setup nacl->qla_tgt_sess %p by loop_id for se_nacl: %p, initiatorname: %s\n",
-	    nacl->qla_tgt_sess, new_se_nacl, new_se_nacl->initiatorname);
+	pr_debug("Setup nacl->fc_port %p by loop_id for se_nacl: %p, initiatorname: %s\n",
+	    nacl->fc_port, new_se_nacl, new_se_nacl->initiatorname);
 }
 
 /*
  * Should always be called with qla_hw_data->tgt.sess_lock held.
  */
 static void tcm_qla2xxx_clear_sess_lookup(struct tcm_qla2xxx_lport *lport,
-		struct tcm_qla2xxx_nacl *nacl, struct qla_tgt_sess *sess)
+		struct tcm_qla2xxx_nacl *nacl, struct fc_port *sess)
 {
 	struct se_session *se_sess = sess->se_sess;
 	unsigned char be_sid[3];
 
-	be_sid[0] = sess->s_id.b.domain;
-	be_sid[1] = sess->s_id.b.area;
-	be_sid[2] = sess->s_id.b.al_pa;
+	be_sid[0] = sess->d_id.b.domain;
+	be_sid[1] = sess->d_id.b.area;
+	be_sid[2] = sess->d_id.b.al_pa;
 
 	tcm_qla2xxx_set_sess_by_s_id(lport, NULL, nacl, se_sess,
 				sess, be_sid);
@@ -1365,7 +1629,7 @@ static void tcm_qla2xxx_clear_sess_lookup(struct tcm_qla2xxx_lport *lport,
 				sess, sess->loop_id);
 }
 
-static void tcm_qla2xxx_free_session(struct qla_tgt_sess *sess)
+static void tcm_qla2xxx_free_session(struct fc_port *sess)
 {
 	struct qla_tgt *tgt = sess->tgt;
 	struct qla_hw_data *ha = tgt->ha;
@@ -1377,7 +1641,7 @@ static void tcm_qla2xxx_free_session(struct qla_tgt_sess *sess)
 
 	se_sess = sess->se_sess;
 	if (!se_sess) {
-		pr_err("struct qla_tgt_sess->se_sess is NULL\n");
+		pr_err("struct fc_port->se_sess is NULL\n");
 		dump_stack();
 		return;
 	}
@@ -1404,14 +1668,14 @@ static int tcm_qla2xxx_session_cb(struct se_portal_group *se_tpg,
 	struct se_node_acl *se_nacl = se_sess->se_node_acl;
 	struct tcm_qla2xxx_nacl *nacl = container_of(se_nacl,
 				struct tcm_qla2xxx_nacl, se_node_acl);
-	struct qla_tgt_sess *qlat_sess = p;
+	struct fc_port *qlat_sess = p;
 	uint16_t loop_id = qlat_sess->loop_id;
 	unsigned long flags;
 	unsigned char be_sid[3];
 
-	be_sid[0] = qlat_sess->s_id.b.domain;
-	be_sid[1] = qlat_sess->s_id.b.area;
-	be_sid[2] = qlat_sess->s_id.b.al_pa;
+	be_sid[0] = qlat_sess->d_id.b.domain;
+	be_sid[1] = qlat_sess->d_id.b.area;
+	be_sid[2] = qlat_sess->d_id.b.al_pa;
 
 	/*
 	 * And now setup se_nacl and session pointers into HW lport internal
@@ -1434,7 +1698,7 @@ static int tcm_qla2xxx_session_cb(struct se_portal_group *se_tpg,
 static int tcm_qla2xxx_check_initiator_node_acl(
 	scsi_qla_host_t *vha,
 	unsigned char *fc_wwpn,
-	struct qla_tgt_sess *qlat_sess)
+	struct fc_port *qlat_sess)
 {
 	struct qla_hw_data *ha = vha->hw;
 	struct tcm_qla2xxx_lport *lport;
@@ -1469,33 +1733,34 @@ static int tcm_qla2xxx_check_initiator_node_acl(
 	 * via ConfigFS, or via running in TPG demo mode.
 	 */
 	se_sess = target_alloc_session(&tpg->se_tpg, num_tags,
-				       sizeof(struct qla_tgt_cmd),
-				       TARGET_PROT_ALL, port_name,
-				       qlat_sess, tcm_qla2xxx_session_cb);
+	    sizeof(struct tcm_qla_tgt_cmd), TARGET_PROT_ALL, port_name,
+	    qlat_sess, tcm_qla2xxx_session_cb);
+
 	if (IS_ERR(se_sess))
 		return PTR_ERR(se_sess);
 
 	return 0;
 }
 
-static void tcm_qla2xxx_update_sess(struct qla_tgt_sess *sess, port_id_t s_id,
+static void tcm_qla2xxx_update_sess(struct fc_port *sess, port_id_t s_id,
 				    uint16_t loop_id, bool conf_compl_supported)
 {
 	struct qla_tgt *tgt = sess->tgt;
 	struct qla_hw_data *ha = tgt->ha;
 	scsi_qla_host_t *vha = pci_get_drvdata(ha->pdev);
 	struct tcm_qla2xxx_lport *lport = vha->vha_tgt.target_lport_ptr;
-	struct se_node_acl *se_nacl = sess->se_sess->se_node_acl;
+	struct se_node_acl *se_nacl =
+	    ((struct se_session *)sess->se_sess)->se_node_acl;
 	struct tcm_qla2xxx_nacl *nacl = container_of(se_nacl,
 			struct tcm_qla2xxx_nacl, se_node_acl);
 	u32 key;
 
 
-	if (sess->loop_id != loop_id || sess->s_id.b24 != s_id.b24)
+	if (sess->loop_id != loop_id || sess->d_id.b24 != s_id.b24)
 		pr_info("Updating session %p from port %8phC loop_id %d -> %d s_id %x:%x:%x -> %x:%x:%x\n",
 		    sess, sess->port_name,
-		    sess->loop_id, loop_id, sess->s_id.b.domain,
-		    sess->s_id.b.area, sess->s_id.b.al_pa, s_id.b.domain,
+		    sess->loop_id, loop_id, sess->d_id.b.domain,
+		    sess->d_id.b.area, sess->d_id.b.al_pa, s_id.b.domain,
 		    s_id.b.area, s_id.b.al_pa);
 
 	if (sess->loop_id != loop_id) {
@@ -1515,18 +1780,18 @@ static void tcm_qla2xxx_update_sess(struct qla_tgt_sess *sess, port_id_t s_id,
 		sess->loop_id = loop_id;
 	}
 
-	if (sess->s_id.b24 != s_id.b24) {
-		key = (((u32) sess->s_id.b.domain << 16) |
-		       ((u32) sess->s_id.b.area   <<  8) |
-		       ((u32) sess->s_id.b.al_pa));
+	if (sess->d_id.b24 != s_id.b24) {
+		key = (((u32) sess->d_id.b.domain << 16) |
+		       ((u32) sess->d_id.b.area   <<  8) |
+		       ((u32) sess->d_id.b.al_pa));
 
 		if (btree_lookup32(&lport->lport_fcport_map, key))
 			WARN(btree_remove32(&lport->lport_fcport_map, key) != se_nacl,
 			     "Found wrong se_nacl when updating s_id %x:%x:%x\n",
-			     sess->s_id.b.domain, sess->s_id.b.area, sess->s_id.b.al_pa);
+			     sess->d_id.b.domain, sess->d_id.b.area, sess->d_id.b.al_pa);
 		else
 			WARN(1, "No lport_fcport_map entry for s_id %x:%x:%x\n",
-			     sess->s_id.b.domain, sess->s_id.b.area, sess->s_id.b.al_pa);
+			     sess->d_id.b.domain, sess->d_id.b.area, sess->d_id.b.al_pa);
 
 		key = (((u32) s_id.b.domain << 16) |
 		       ((u32) s_id.b.area   <<  8) |
@@ -1540,7 +1805,7 @@ static void tcm_qla2xxx_update_sess(struct qla_tgt_sess *sess, port_id_t s_id,
 			btree_insert32(&lport->lport_fcport_map, key, se_nacl, GFP_ATOMIC);
 		}
 
-		sess->s_id = s_id;
+		sess->d_id = s_id;
 		nacl->nport_id = key;
 	}
 
@@ -1551,6 +1816,28 @@ static void tcm_qla2xxx_update_sess(struct qla_tgt_sess *sess, port_id_t s_id,
 	sess->keep_nport_handle = 0;
 }
 
+static void tcm_qla2xxx_srr_get_cur_state(struct qla_tgt_cmd *cmd,
+	srr_state_op_t op)
+{
+	struct se_cmd *se_cmd = Q_TO_SE_CMD(cmd);
+
+	switch (op) {
+	case SRR_SG:
+		cmd->sg_cnt = se_cmd->t_data_nents;
+		cmd->sg = se_cmd->t_data_sg;
+		break;
+
+	case SRR_STATUS:
+		cmd->scsi_status = se_cmd->scsi_status;
+		cmd->bufflen = se_cmd->data_length;
+		break;
+
+	default:
+		BUG_ON(1);
+		break;
+	}
+}
+
 /*
  * Calls into tcm_qla2xxx used by qla2xxx LLD I/O path.
  */
@@ -1561,13 +1848,19 @@ static void tcm_qla2xxx_update_sess(struct qla_tgt_sess *sess, port_id_t s_id,
 	.handle_tmr		= tcm_qla2xxx_handle_tmr,
 	.free_cmd		= tcm_qla2xxx_free_cmd,
 	.free_mcmd		= tcm_qla2xxx_free_mcmd,
+	.free_mgmt_cmd		= tcm_qla2xxx_free_mgmt_cmd,
 	.free_session		= tcm_qla2xxx_free_session,
 	.update_sess		= tcm_qla2xxx_update_sess,
+	.get_sess		= tcm_qla2xxx_get_sess,
 	.check_initiator_node_acl = tcm_qla2xxx_check_initiator_node_acl,
 	.find_sess_by_s_id	= tcm_qla2xxx_find_sess_by_s_id,
 	.find_sess_by_loop_id	= tcm_qla2xxx_find_sess_by_loop_id,
 	.clear_nacl_from_fcport_map = tcm_qla2xxx_clear_nacl_from_fcport_map,
 	.shutdown_sess		= tcm_qla2xxx_shutdown_sess,
+	.release_cmd		= tcm_qla2xxx_rel_cmd,
+	.alloc_cmd		= tcm_qla2xxx_alloc_cmd,
+	.alloc_mgmt_cmd		= tcm_qla2xxx_alloc_mgmt_cmd,
+	.srr_get_cur_state 	= tcm_qla2xxx_srr_get_cur_state,
 };
 
 static int tcm_qla2xxx_init_lport(struct tcm_qla2xxx_lport *lport)
@@ -1930,8 +2223,29 @@ static int tcm_qla2xxx_register_configfs(void)
 		goto out_free_wq;
 	}
 
+	tcm_qla_tgt_mgmt_cmd_cachep = kmem_cache_create("tcm_qla_tgt_mgmt_cmd_cachep",
+	    sizeof(struct tcm_qla_tgt_mgmt_cmd),
+	    __alignof__(struct tcm_qla_tgt_mgmt_cmd), 0, NULL);
+	if (!tcm_qla_tgt_mgmt_cmd_cachep) {
+		pr_debug("kmem_cache_create for qla_tgt_mgmt_cmd_cachep failed\n");
+		ret = -ENOMEM;
+		goto out_free_cmd_wq;
+	}
+
+	tcm_qla_tgt_mgmt_cmd_mempool = mempool_create(25, mempool_alloc_slab,
+	    mempool_free_slab, tcm_qla_tgt_mgmt_cmd_cachep);
+	if (!tcm_qla_tgt_mgmt_cmd_mempool) {
+		pr_debug("mempool_create for tcm_qla_tgt_mgmt_cmd_mempool failed\n");
+		ret = -ENOMEM;
+		goto out_free_cmd_cachep;
+	}
+
 	return 0;
 
+out_free_cmd_cachep:
+	kmem_cache_destroy(tcm_qla_tgt_mgmt_cmd_cachep);
+out_free_cmd_wq:
+	destroy_workqueue(tcm_qla2xxx_cmd_wq);
 out_free_wq:
 	destroy_workqueue(tcm_qla2xxx_free_wq);
 out_fabric_npiv:
@@ -1943,6 +2257,8 @@ static int tcm_qla2xxx_register_configfs(void)
 
 static void tcm_qla2xxx_deregister_configfs(void)
 {
+	mempool_destroy(tcm_qla_tgt_mgmt_cmd_mempool);
+	kmem_cache_destroy(tcm_qla_tgt_mgmt_cmd_cachep);
 	destroy_workqueue(tcm_qla2xxx_cmd_wq);
 	destroy_workqueue(tcm_qla2xxx_free_wq);
 
diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.h b/drivers/scsi/qla2xxx/tcm_qla2xxx.h
index 37e9f57..911c3d9 100644
--- a/drivers/scsi/qla2xxx/tcm_qla2xxx.h
+++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.h
@@ -21,8 +21,8 @@ struct tcm_qla2xxx_nacl {
 	u64 nport_wwnn;
 	/* ASCII formatted WWPN for FC Initiator Nport */
 	char nport_name[TCM_QLA2XXX_NAMELEN];
-	/* Pointer to qla_tgt_sess */
-	struct qla_tgt_sess *qla_tgt_sess;
+	/* Pointer to fc_port */
+	struct fc_port *fc_port;
 	/* Pointer to TCM FC nexus */
 	struct se_session *nport_nexus;
 };
@@ -81,3 +81,13 @@ struct tcm_qla2xxx_lport {
 	/* Returned by tcm_qla2xxx_make_lport() */
 	struct se_wwn lport_wwn;
 };
+
+struct tcm_qla_tgt_cmd {
+	struct se_cmd se_cmd;
+	struct qla_tgt_cmd qcmd;
+};
+
+struct tcm_qla_tgt_mgmt_cmd {
+	struct se_cmd se_cmd;
+	struct qla_tgt_mgmt_cmd mgt_cmd;
+};
-- 
1.8.3.1

