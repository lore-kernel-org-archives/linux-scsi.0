From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH v2 07/12] qla2xxx: Track I-T nexus as single fc_port struct.
Date: Mon, 16 Jan 2017 12:35:19 -0800
Message-ID: <1484598924-29066-8-git-send-email-himanshu.madhani@cavium.com>
References: <1484598924-29066-1-git-send-email-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1484598924-29066-1-git-send-email-himanshu.madhani@cavium.com>
Sender: target-devel-owner@vger.kernel.org
To: target-devel@vger.kernel.org, bart.vanassche@gmail.com, hch@infradead.org, nab@linux-iscsi.org
Cc: giridhar.malavali@cavium.com, linux-scsi@vger.kernel.org, himanshu.madhani@cavium.com
List-Id: linux-scsi@vger.kernel.org

From: Quinn Tran <quinn.tran@cavium.com>

Current code merges qla_tgt_sess and fc_port structure
into single fc_port structure represeting same I-T nexus.

Signed-off-by: Quinn Tran <quinn.tran@cavium.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
---
 drivers/scsi/qla2xxx/qla_def.h     | 112 ++++++++++++-
 drivers/scsi/qla2xxx/qla_dfs.c     |   4 +-
 drivers/scsi/qla2xxx/qla_init.c    |  12 --
 drivers/scsi/qla2xxx/qla_iocb.c    |   2 +-
 drivers/scsi/qla2xxx/qla_target.c  | 326 ++++++++++++-------------------------
 drivers/scsi/qla2xxx/qla_target.h  | 150 ++---------------
 drivers/scsi/qla2xxx/tcm_qla2xxx.c | 130 ++++++++-------
 drivers/scsi/qla2xxx/tcm_qla2xxx.h |   4 +-
 8 files changed, 310 insertions(+), 430 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 1196150..11d5288 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -1976,6 +1976,84 @@ struct mbx_entry {
 	uint8_t port_name[WWN_SIZE];
 };
 
+#ifndef IMMED_NOTIFY_TYPE
+#define IMMED_NOTIFY_TYPE 0x0D		/* Immediate notify entry. */
+/*
+ * ISP queue -	immediate notify entry structure definition.
+ *		This is sent by the ISP to the Target driver.
+ *		This IOCB would have report of events sent by the
+ *		initiator, that needs to be handled by the target
+ *		driver immediately.
+ */
+struct imm_ntfy_from_isp {
+	uint8_t	 entry_type;		    /* Entry type. */
+	uint8_t	 entry_count;		    /* Entry count. */
+	uint8_t	 sys_define;		    /* System defined. */
+	uint8_t	 entry_status;		    /* Entry Status. */
+	union {
+		struct {
+			uint32_t sys_define_2; /* System defined. */
+			target_id_t target;
+			uint16_t lun;
+			uint8_t  target_id;
+			uint8_t  reserved_1;
+			uint16_t status_modifier;
+			uint16_t status;
+			uint16_t task_flags;
+			uint16_t seq_id;
+			uint16_t srr_rx_id;
+			uint32_t srr_rel_offs;
+			uint16_t srr_ui;
+#define SRR_IU_DATA_IN	0x1
+#define SRR_IU_DATA_OUT	0x5
+#define SRR_IU_STATUS	0x7
+			uint16_t srr_ox_id;
+			uint8_t reserved_2[28];
+		} isp2x;
+		struct {
+			uint32_t reserved;
+			uint16_t nport_handle;
+			uint16_t reserved_2;
+			uint16_t flags;
+#define NOTIFY24XX_FLAGS_GLOBAL_TPRLO   BIT_1
+#define NOTIFY24XX_FLAGS_PUREX_IOCB     BIT_0
+			uint16_t srr_rx_id;
+			uint16_t status;
+			uint8_t  status_subcode;
+			uint8_t  fw_handle;
+			uint32_t exchange_address;
+			uint32_t srr_rel_offs;
+			uint16_t srr_ui;
+			uint16_t srr_ox_id;
+			union {
+				struct {
+					uint8_t node_name[8];
+				} plogi; /* PLOGI/ADISC/PDISC */
+				struct {
+					/* PRLI word 3 bit 0-15 */
+					uint16_t wd3_lo;
+					uint8_t resv0[6];
+				} prli;
+				struct {
+					uint8_t port_id[3];
+					uint8_t resv1;
+					uint16_t nport_handle;
+					uint16_t resv2;
+				} req_els;
+			} u;
+			uint8_t port_name[8];
+			uint8_t resv3[3];
+			uint8_t  vp_index;
+			uint32_t reserved_5;
+			uint8_t  port_id[3];
+			uint8_t  reserved_6;
+		} isp24;
+	} u;
+	uint16_t reserved_7;
+	uint16_t ox_id;
+} __packed;
+#endif
+
 /*
  * ISP request and response queue entry sizes
  */
@@ -2026,7 +2104,7 @@ struct mbx_entry {
 /*
  * Fibre channel port type.
  */
- typedef enum {
+typedef enum {
 	FCT_UNKNOWN,
 	FCT_RSCN,
 	FCT_SWITCH,
@@ -2035,6 +2113,19 @@ struct mbx_entry {
 	FCT_TARGET
 } fc_port_type_t;
 
+enum qlt_plogi_link_t {
+	QLT_PLOGI_LINK_SAME_WWN,
+	QLT_PLOGI_LINK_CONFLICT,
+	QLT_PLOGI_LINK_MAX
+};
+
+struct qlt_plogi_ack_t {
+	struct list_head	list;
+	struct imm_ntfy_from_isp iocb;
+	port_id_t	id;
+	int		ref_count;
+};
+
 /*
  * Fibre channel port structure.
  */
@@ -2048,6 +2139,25 @@ struct mbx_entry {
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
+	struct se_session *se_sess;
+	struct kref sess_kref;
+	struct qla_tgt *tgt;
+	unsigned long expires;
+	struct list_head del_list_entry;
+	struct work_struct free_work;
+
+	struct qlt_plogi_ack_t *plogi_link[QLT_PLOGI_LINK_MAX];
+
 	uint16_t tgt_id;
 	uint16_t old_tgt_id;
 
diff --git a/drivers/scsi/qla2xxx/qla_dfs.c b/drivers/scsi/qla2xxx/qla_dfs.c
index 98550c9..b48cce6 100644
--- a/drivers/scsi/qla2xxx/qla_dfs.c
+++ b/drivers/scsi/qla2xxx/qla_dfs.c
@@ -18,7 +18,7 @@
 	scsi_qla_host_t *vha = s->private;
 	struct qla_hw_data *ha = vha->hw;
 	unsigned long flags;
-	struct qla_tgt_sess *sess = NULL;
+	struct fc_port *sess = NULL;
 	struct qla_tgt *tgt= vha->vha_tgt.qla_tgt;
 
 	seq_printf(s, "%s\n",vha->host_str);
@@ -26,7 +26,7 @@
 		seq_printf(s, "Port ID   Port Name                Handle\n");
 
 		spin_lock_irqsave(&ha->tgt.sess_lock, flags);
-		list_for_each_entry(sess, &tgt->sess_list, sess_list_entry)
+		list_for_each_entry(sess, &vha->vp_fcports, list)
 			seq_printf(s, "%02x:%02x:%02x  %8phC  %d\n",
 			    sess->d_id.b.domain, sess->d_id.b.area,
 			    sess->d_id.b.al_pa, sess->port_name,
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 7b6317c..5978b79 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -3352,12 +3352,6 @@ static void qla2xxx_nvram_wwn_from_ofw(scsi_qla_host_t *vha, nvram_t *nv)
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
@@ -3407,12 +3401,6 @@ static void qla2xxx_nvram_wwn_from_ofw(scsi_qla_host_t *vha, nvram_t *nv)
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
diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index 58e49a3..834e221 100644
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
diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index c977337..99ed753 100644
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
@@ -138,21 +138,6 @@ void qlt_do_generation_tick(struct scsi_qla_host *vha, int *dest)
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
@@ -399,16 +384,16 @@ void qlt_response_pkt_all_vps(struct scsi_qla_host *vha, response_t *pkt)
  * guarantees that ref_count is not modified concurrently.
  * Upon successful return content of iocb is undefined
  */
-static qlt_plogi_ack_t *
+static struct qlt_plogi_ack_t *
 qlt_plogi_ack_find_add(struct scsi_qla_host *vha, port_id_t *id,
 		       struct imm_ntfy_from_isp *iocb)
 {
-	qlt_plogi_ack_t *pla;
+	struct qlt_plogi_ack_t *pla;
 
 	list_for_each_entry(pla, &vha->plogi_ack_list, list) {
 		if (pla->id.b24 == id->b24) {
 			qlt_send_term_imm_notif(vha, &pla->iocb, 1);
-			pla->iocb = *iocb;
+			memcpy(&pla->iocb, iocb, sizeof(pla->iocb));
 			return pla;
 		}
 	}
@@ -421,15 +406,17 @@ void qlt_response_pkt_all_vps(struct scsi_qla_host *vha, response_t *pkt)
 		return NULL;
 	}
 
-	pla->iocb = *iocb;
+	memcpy(&pla->iocb, iocb, sizeof(pla->iocb));
 	pla->id = *id;
 	list_add_tail(&pla->list, &vha->plogi_ack_list);
 
 	return pla;
 }
 
-static void qlt_plogi_ack_unref(struct scsi_qla_host *vha, qlt_plogi_ack_t *pla)
+static void qlt_plogi_ack_unref(struct scsi_qla_host *vha,
+    struct qlt_plogi_ack_t *pla)
 {
+	struct imm_ntfy_from_isp *iocb = &pla->iocb;
 	BUG_ON(!pla->ref_count);
 	pla->ref_count--;
 
@@ -438,21 +425,22 @@ static void qlt_plogi_ack_unref(struct scsi_qla_host *vha, qlt_plogi_ack_t *pla)
 
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
 }
 
 static void
-qlt_plogi_ack_link(struct scsi_qla_host *vha, qlt_plogi_ack_t *pla,
-    struct qla_tgt_sess *sess, qlt_plogi_link_t link)
+qlt_plogi_ack_link(struct scsi_qla_host *vha, struct qlt_plogi_ack_t *pla,
+    struct fc_port *sess, enum qlt_plogi_link_t link)
 {
+	struct imm_ntfy_from_isp *iocb = &pla->iocb;
 	/* Inc ref_count first because link might already be pointing at pla */
 	pla->ref_count++;
 
@@ -462,8 +450,8 @@ static void qlt_plogi_ack_unref(struct scsi_qla_host *vha, qlt_plogi_ack_t *pla)
 	ql_dbg(ql_dbg_tgt_mgt, vha, 0xf097,
 	    "Linking sess %p [%d] wwn %8phC with PLOGI ACK to wwn %8phC"
 	    " s_id %02x:%02x:%02x, ref=%d\n", sess, link, sess->port_name,
-	    pla->iocb.u.isp24.port_name, pla->iocb.u.isp24.port_id[2],
-	    pla->iocb.u.isp24.port_id[1], pla->iocb.u.isp24.port_id[0],
+	    iocb->u.isp24.port_name, iocb->u.isp24.port_id[2],
+	    iocb->u.isp24.port_id[1], iocb->u.isp24.port_id[0],
 	    pla->ref_count);
 
 	sess->plogi_link[link] = pla;
@@ -517,7 +505,7 @@ static void qlt_plogi_ack_unref(struct scsi_qla_host *vha, qlt_plogi_ack_t *pla)
 
 static void qlt_free_session_done(struct work_struct *work)
 {
-	struct qla_tgt_sess *sess = container_of(work, struct qla_tgt_sess,
+	struct fc_port *sess = container_of(work, struct fc_port,
 	    free_work);
 	struct qla_tgt *tgt = sess->tgt;
 	struct scsi_qla_host *vha = sess->vha;
@@ -551,7 +539,6 @@ static void qlt_free_session_done(struct work_struct *work)
 		fcport.d_id = sess->d_id;
 		memcpy(fcport.port_name, sess->port_name, WWN_SIZE);
 		fcport.vha = vha;
-		fcport.tgt_session = sess;
 
 		rc = qla2x00_post_async_logout_work(vha, &fcport, NULL);
 		if (rc != QLA_SUCCESS)
@@ -587,22 +574,22 @@ static void qlt_free_session_done(struct work_struct *work)
 	}
 
 	spin_lock_irqsave(&ha->hardware_lock, flags);
-
 	{
-		qlt_plogi_ack_t *own =
+		struct qlt_plogi_ack_t *own =
 		    sess->plogi_link[QLT_PLOGI_LINK_SAME_WWN];
-		qlt_plogi_ack_t *con =
+		struct qlt_plogi_ack_t *con =
 		    sess->plogi_link[QLT_PLOGI_LINK_CONFLICT];
+		struct imm_ntfy_from_isp *iocb;
 
 		if (con) {
+			iocb = &con->iocb;
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
@@ -616,15 +603,15 @@ static void qlt_free_session_done(struct work_struct *work)
 		if (own)
 			qlt_plogi_ack_unref(vha, own);
 	}
-
-	list_del(&sess->sess_list_entry);
-
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 
+	spin_lock_irqsave(&ha->tgt.sess_lock, flags);
+	sess->se_sess = NULL;
+	spin_unlock_irqrestore(&ha->tgt.sess_lock, flags);
+
 	ql_dbg(ql_dbg_tgt_mgt, vha, 0xf001,
 	    "Unregistration of sess %p finished\n", sess);
 
-	kfree(sess);
 	/*
 	 * We need to protect against race, when tgt is freed before or
 	 * inside wake_up()
@@ -635,37 +622,30 @@ static void qlt_free_session_done(struct work_struct *work)
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
+	struct fc_port *sess = NULL;
 	uint16_t loop_id;
 	int res = 0;
 	struct imm_ntfy_from_isp *n = (struct imm_ntfy_from_isp *)iocb;
@@ -678,31 +658,6 @@ static int qlt_reset(struct scsi_qla_host *vha, void *iocb, int mcmd)
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
@@ -725,7 +680,7 @@ static int qlt_reset(struct scsi_qla_host *vha, void *iocb, int mcmd)
 }
 
 /* ha->tgt.sess_lock supposed to be held on entry */
-static void qlt_schedule_sess_for_deletion(struct qla_tgt_sess *sess,
+static void qlt_schedule_sess_for_deletion(struct fc_port *sess,
 	bool immediate)
 {
 	struct qla_tgt *tgt = sess->tgt;
@@ -771,10 +726,13 @@ static void qlt_schedule_sess_for_deletion(struct qla_tgt_sess *sess,
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
@@ -829,7 +787,7 @@ static int qla24xx_get_loop_id(struct scsi_qla_host *vha, const uint8_t *s_id,
 }
 
 /* ha->tgt.sess_lock supposed to be held on entry */
-static void qlt_undelete_sess(struct qla_tgt_sess *sess)
+static void qlt_undelete_sess(struct fc_port *sess)
 {
 	BUG_ON(sess->deleted != QLA_SESS_DELETION_PENDING);
 
@@ -843,7 +801,7 @@ static void qlt_del_sess_work_fn(struct delayed_work *work)
 	    sess_del_work);
 	struct scsi_qla_host *vha = tgt->vha;
 	struct qla_hw_data *ha = vha->hw;
-	struct qla_tgt_sess *sess;
+	struct fc_port *sess;
 	unsigned long flags, elapsed;
 
 	spin_lock_irqsave(&ha->tgt.sess_lock, flags);
@@ -861,7 +819,7 @@ static void qlt_del_sess_work_fn(struct delayed_work *work)
 			    sess);
 			if (sess->se_sess)
 				ha->tgt.tgt_ops->shutdown_sess(sess);
-			qlt_put_sess(sess);
+			ha->tgt.tgt_ops->put_sess(sess);
 		} else {
 			schedule_delayed_work(&tgt->sess_del_work,
 			    sess->expires - elapsed);
@@ -875,19 +833,18 @@ static void qlt_del_sess_work_fn(struct delayed_work *work)
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
@@ -965,7 +922,7 @@ static struct qla_tgt_sess *qlt_create_sess(
 	memcpy(sess->port_name, fcport->port_name, sizeof(sess->port_name));
 
 	spin_lock_irqsave(&ha->tgt.sess_lock, flags);
-	list_add_tail(&sess->sess_list_entry, &vha->vha_tgt.qla_tgt->sess_list);
+	list_add_tail(&sess->list, &vha->vp_fcports);
 	vha->vha_tgt.qla_tgt->sess_count++;
 	qlt_do_generation_tick(vha, &sess->generation);
 	spin_unlock_irqrestore(&ha->tgt.sess_lock, flags);
@@ -988,7 +945,7 @@ static struct qla_tgt_sess *qlt_create_sess(
 		return NULL;
 	} else {
 		/*
-		 * Take an extra reference to ->sess_kref here to handle qla_tgt_sess
+		 * Take an extra reference to ->sess_kref here to handle fc_port
 		 * access across ->tgt.sess_lock reaquire.
 		 */
 		kref_get(&sess->sess_kref);
@@ -998,73 +955,6 @@ static struct qla_tgt_sess *qlt_create_sess(
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
@@ -1072,7 +962,7 @@ void qlt_fc_port_added(struct scsi_qla_host *vha, fc_port_t *fcport)
 qlt_fc_port_deleted(struct scsi_qla_host *vha, fc_port_t *fcport, int max_gen)
 {
 	struct qla_tgt *tgt = vha->vha_tgt.qla_tgt;
-	struct qla_tgt_sess *sess;
+	struct fc_port *sess = fcport;
 	unsigned long flags;
 
 	if (!vha->hw->tgt.tgt_ops)
@@ -1086,8 +976,7 @@ void qlt_fc_port_added(struct scsi_qla_host *vha, fc_port_t *fcport)
 		spin_unlock_irqrestore(&vha->hw->tgt.sess_lock, flags);
 		return;
 	}
-	sess = qlt_find_sess_by_port_name(tgt, fcport->port_name);
-	if (!sess) {
+	if (!sess->se_sess) {
 		spin_unlock_irqrestore(&vha->hw->tgt.sess_lock, flags);
 		return;
 	}
@@ -1120,8 +1009,8 @@ static inline int test_tgt_sess_count(struct qla_tgt *tgt)
 	 */
 	spin_lock_irqsave(&ha->hardware_lock, flags);
 	ql_dbg(ql_dbg_tgt, tgt->vha, 0xe002,
-	    "tgt %p, empty(sess_list)=%d sess_count=%d\n",
-	    tgt, list_empty(&tgt->sess_list), tgt->sess_count);
+	    "tgt %p, sess_count=%d\n",
+	    tgt, tgt->sess_count);
 	res = (tgt->sess_count == 0);
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 
@@ -1184,9 +1073,7 @@ int qlt_stop_phase1(struct qla_tgt *tgt)
 	spin_unlock_irqrestore(&tgt->sess_work_lock, flags);
 
 	ql_dbg(ql_dbg_tgt_mgt, vha, 0xf00a,
-	    "Waiting for tgt %p: list_empty(sess_list)=%d "
-	    "sess_count=%d\n", tgt, list_empty(&tgt->sess_list),
-	    tgt->sess_count);
+	    "Waiting for tgt %p: sess_count=%d\n", tgt, tgt->sess_count);
 
 	wait_event(tgt->waitQ, test_tgt_sess_count(tgt));
 
@@ -1538,7 +1425,7 @@ static void abort_cmds_for_lun(struct scsi_qla_host *vha,
 
 /* ha->hardware_lock supposed to be held on entry */
 static int __qlt_24xx_handle_abts(struct scsi_qla_host *vha,
-	struct abts_recv_from_24xx *abts, struct qla_tgt_sess *sess)
+	struct abts_recv_from_24xx *abts, struct fc_port *sess)
 {
 	struct qla_hw_data *ha = vha->hw;
 	struct se_session *se_sess = sess->se_sess;
@@ -1547,8 +1434,9 @@ static int __qlt_24xx_handle_abts(struct scsi_qla_host *vha,
 	u32 lun = 0;
 	int rc;
 	bool found_lun = false;
+	unsigned long flags;
 
-	spin_lock(&se_sess->sess_cmd_lock);
+	spin_lock_irqsave(&se_sess->sess_cmd_lock, flags);
 	list_for_each_entry(se_cmd, &se_sess->sess_cmd_list, se_cmd_list) {
 		struct qla_tgt_cmd *cmd =
 			container_of(se_cmd, struct qla_tgt_cmd, se_cmd);
@@ -1558,7 +1446,7 @@ static int __qlt_24xx_handle_abts(struct scsi_qla_host *vha,
 			break;
 		}
 	}
-	spin_unlock(&se_sess->sess_cmd_lock);
+	spin_unlock_irqrestore(&se_sess->sess_cmd_lock, flags);
 
 	/* cmd not in LIO lists, look in qla list */
 	if (!found_lun) {
@@ -1612,7 +1500,7 @@ static void qlt_24xx_handle_abts(struct scsi_qla_host *vha,
 	struct abts_recv_from_24xx *abts)
 {
 	struct qla_hw_data *ha = vha->hw;
-	struct qla_tgt_sess *sess;
+	struct fc_port *sess;
 	uint32_t tag = abts->exchange_addr_to_abort;
 	uint8_t s_id[3];
 	int rc;
@@ -3212,7 +3100,7 @@ int qlt_abort_cmd(struct qla_tgt_cmd *cmd)
 
 void qlt_free_cmd(struct qla_tgt_cmd *cmd)
 {
-	struct qla_tgt_sess *sess = cmd->sess;
+	struct fc_port *sess = cmd->sess;
 
 	ql_dbg(ql_dbg_tgt, cmd->vha, 0xe074,
 	    "%s: se_cmd[%p] ox_id %04x\n",
@@ -3574,7 +3462,7 @@ static inline int qlt_get_fcp_task_attr(struct scsi_qla_host *vha,
 	return fcp_task_attr;
 }
 
-static struct qla_tgt_sess *qlt_make_local_sess(struct scsi_qla_host *,
+static struct fc_port *qlt_make_local_sess(struct scsi_qla_host *,
 					uint8_t *);
 /*
  * Process context for I/O path into tcm_qla2xxx code
@@ -3584,7 +3472,7 @@ static void __qlt_do_work(struct qla_tgt_cmd *cmd)
 	scsi_qla_host_t *vha = cmd->vha;
 	struct qla_hw_data *ha = vha->hw;
 	struct qla_tgt *tgt = vha->vha_tgt.qla_tgt;
-	struct qla_tgt_sess *sess = cmd->sess;
+	struct fc_port *sess = cmd->sess;
 	struct atio_from_isp *atio = &cmd->atio;
 	unsigned char *cdb;
 	unsigned long flags;
@@ -3634,7 +3522,7 @@ static void __qlt_do_work(struct qla_tgt_cmd *cmd)
 	 * Drop extra session reference from qla_tgt_handle_cmd_for_atio*(
 	 */
 	spin_lock_irqsave(&ha->tgt.sess_lock, flags);
-	qlt_put_sess(sess);
+	ha->tgt.tgt_ops->put_sess(sess);
 	spin_unlock_irqrestore(&ha->tgt.sess_lock, flags);
 	return;
 
@@ -3653,7 +3541,7 @@ static void __qlt_do_work(struct qla_tgt_cmd *cmd)
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 
 	spin_lock_irqsave(&ha->tgt.sess_lock, flags);
-	qlt_put_sess(sess);
+	ha->tgt.tgt_ops->put_sess(sess);
 	spin_unlock_irqrestore(&ha->tgt.sess_lock, flags);
 }
 
@@ -3671,7 +3559,7 @@ static void qlt_do_work(struct work_struct *work)
 }
 
 static struct qla_tgt_cmd *qlt_get_tag(scsi_qla_host_t *vha,
-				       struct qla_tgt_sess *sess,
+				       struct fc_port *sess,
 				       struct atio_from_isp *atio)
 {
 	struct se_session *se_sess = sess->se_sess;
@@ -3712,7 +3600,7 @@ static void qlt_create_sess_from_atio(struct work_struct *work)
 					struct qla_tgt_sess_op, work);
 	scsi_qla_host_t *vha = op->vha;
 	struct qla_hw_data *ha = vha->hw;
-	struct qla_tgt_sess *sess;
+	struct fc_port *sess;
 	struct qla_tgt_cmd *cmd;
 	unsigned long flags;
 	uint8_t *s_id = op->atio.u.isp24.fcp_hdr.s_id;
@@ -3753,7 +3641,7 @@ static void qlt_create_sess_from_atio(struct work_struct *work)
 	if (!cmd) {
 		spin_lock_irqsave(&ha->hardware_lock, flags);
 		qlt_send_busy(vha, &op->atio, SAM_STAT_BUSY);
-		qlt_put_sess(sess);
+		ha->tgt.tgt_ops->put_sess(sess);
 		spin_unlock_irqrestore(&ha->hardware_lock, flags);
 		kfree(op);
 		return;
@@ -3780,8 +3668,9 @@ static int qlt_handle_cmd_for_atio(struct scsi_qla_host *vha,
 {
 	struct qla_hw_data *ha = vha->hw;
 	struct qla_tgt *tgt = vha->vha_tgt.qla_tgt;
-	struct qla_tgt_sess *sess;
+	struct fc_port *sess;
 	struct qla_tgt_cmd *cmd;
+	unsigned long flags;
 
 	if (unlikely(tgt->tgt_stop)) {
 		ql_dbg(ql_dbg_io, vha, 0x3061,
@@ -3826,7 +3715,9 @@ static int qlt_handle_cmd_for_atio(struct scsi_qla_host *vha,
 	if (!cmd) {
 		ql_dbg(ql_dbg_io, vha, 0x3062,
 		    "qla_target(%d): Allocation of cmd failed\n", vha->vp_idx);
-		qlt_put_sess(sess);
+		spin_lock_irqsave(&ha->tgt.sess_lock, flags);
+		ha->tgt.tgt_ops->put_sess(sess);
+		spin_unlock_irqrestore(&ha->tgt.sess_lock, flags);
 		return -ENOMEM;
 	}
 
@@ -3855,7 +3746,7 @@ static int qlt_handle_cmd_for_atio(struct scsi_qla_host *vha,
 }
 
 /* ha->hardware_lock supposed to be held on entry */
-static int qlt_issue_task_mgmt(struct qla_tgt_sess *sess, uint32_t lun,
+static int qlt_issue_task_mgmt(struct fc_port *sess, u64 lun,
 	int fn, void *iocb, int flags)
 {
 	struct scsi_qla_host *vha = sess->vha;
@@ -3907,7 +3798,7 @@ static int qlt_handle_task_mgmt(struct scsi_qla_host *vha, void *iocb)
 	struct atio_from_isp *a = (struct atio_from_isp *)iocb;
 	struct qla_hw_data *ha = vha->hw;
 	struct qla_tgt *tgt;
-	struct qla_tgt_sess *sess;
+	struct fc_port *sess;
 	uint32_t lun, unpacked_lun;
 	int fn;
 	unsigned long flags;
@@ -3940,7 +3831,7 @@ static int qlt_handle_task_mgmt(struct scsi_qla_host *vha, void *iocb)
 
 /* ha->hardware_lock supposed to be held on entry */
 static int __qlt_abort_task(struct scsi_qla_host *vha,
-	struct imm_ntfy_from_isp *iocb, struct qla_tgt_sess *sess)
+	struct imm_ntfy_from_isp *iocb, struct fc_port *sess)
 {
 	struct atio_from_isp *a = (struct atio_from_isp *)iocb;
 	struct qla_hw_data *ha = vha->hw;
@@ -3984,7 +3875,7 @@ static int qlt_abort_task(struct scsi_qla_host *vha,
 	struct imm_ntfy_from_isp *iocb)
 {
 	struct qla_hw_data *ha = vha->hw;
-	struct qla_tgt_sess *sess;
+	struct fc_port *sess;
 	int loop_id;
 	unsigned long flags;
 
@@ -4014,14 +3905,14 @@ void qlt_logo_completion_handler(fc_port_t *fcport, int rc)
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
 
@@ -4032,16 +3923,17 @@ void qlt_logo_completion_handler(fc_port_t *fcport, int rc)
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
 
@@ -4133,13 +4025,13 @@ static int qlt_24xx_handle_els(struct scsi_qla_host *vha,
 {
 	struct qla_tgt *tgt = vha->vha_tgt.qla_tgt;
 	struct qla_hw_data *ha = vha->hw;
-	struct qla_tgt_sess *sess = NULL, *conflict_sess = NULL;
+	struct fc_port *sess = NULL, *conflict_sess = NULL;
 	uint64_t wwn;
 	port_id_t port_id;
 	uint16_t loop_id;
 	uint16_t wd3_lo;
 	int res = 0;
-	qlt_plogi_ack_t *pla;
+	struct qlt_plogi_ack_t *pla;
 	unsigned long flags;
 
 	wwn = wwn_to_u64(iocb->u.isp24.port_name);
@@ -4452,7 +4344,7 @@ static int __qlt_send_busy(struct scsi_qla_host *vha,
 	struct ctio7_to_24xx *ctio24;
 	struct qla_hw_data *ha = vha->hw;
 	request_t *pkt;
-	struct qla_tgt_sess *sess = NULL;
+	struct fc_port *sess = NULL;
 	unsigned long flags;
 
 	spin_lock_irqsave(&ha->tgt.sess_lock, flags);
@@ -4513,7 +4405,7 @@ static int __qlt_send_busy(struct scsi_qla_host *vha,
 {
 	struct qla_tgt *tgt = vha->vha_tgt.qla_tgt;
 	struct qla_hw_data *ha = vha->hw;
-	struct qla_tgt_sess *sess;
+	struct fc_port *sess;
 	struct se_session *se_sess;
 	struct qla_tgt_cmd *cmd;
 	int tag;
@@ -5109,10 +5001,10 @@ static fc_port_t *qlt_get_port_database(struct scsi_qla_host *vha,
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
@@ -5174,7 +5066,6 @@ static struct qla_tgt_sess *qlt_make_local_sess(struct scsi_qla_host *vha,
 
 	mutex_unlock(&vha->vha_tgt.tgt_mutex);
 
-	kfree(fcport);
 	return sess;
 }
 
@@ -5183,7 +5074,7 @@ static void qlt_abort_work(struct qla_tgt *tgt,
 {
 	struct scsi_qla_host *vha = tgt->vha;
 	struct qla_hw_data *ha = vha->hw;
-	struct qla_tgt_sess *sess = NULL;
+	struct fc_port *sess = NULL;
 	unsigned long flags = 0, flags2 = 0;
 	uint32_t be_s_id;
 	uint8_t s_id[3];
@@ -5227,8 +5118,8 @@ static void qlt_abort_work(struct qla_tgt *tgt,
 	if (rc != 0)
 		goto out_term;
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
-
-	qlt_put_sess(sess);
+	if (sess)
+		ha->tgt.tgt_ops->put_sess(sess);
 	spin_unlock_irqrestore(&ha->tgt.sess_lock, flags2);
 	return;
 
@@ -5239,7 +5130,7 @@ static void qlt_abort_work(struct qla_tgt *tgt,
 	qlt_24xx_send_abts_resp(vha, &prm->abts, FCP_TMF_REJECTED, false);
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 
-	qlt_put_sess(sess);
+	ha->tgt.tgt_ops->put_sess(sess);
 	spin_unlock_irqrestore(&ha->tgt.sess_lock, flags2);
 }
 
@@ -5249,7 +5140,7 @@ static void qlt_tmr_work(struct qla_tgt *tgt,
 	struct atio_from_isp *a = &prm->tm_iocb2;
 	struct scsi_qla_host *vha = tgt->vha;
 	struct qla_hw_data *ha = vha->hw;
-	struct qla_tgt_sess *sess = NULL;
+	struct fc_port *sess = NULL;
 	unsigned long flags;
 	uint8_t *s_id = NULL; /* to hide compiler warnings */
 	int rc;
@@ -5291,13 +5182,14 @@ static void qlt_tmr_work(struct qla_tgt *tgt,
 	if (rc != 0)
 		goto out_term;
 
-	qlt_put_sess(sess);
+	ha->tgt.tgt_ops->put_sess(sess);
 	spin_unlock_irqrestore(&ha->tgt.sess_lock, flags);
 	return;
 
 out_term:
 	qlt_send_term_exchange(vha, NULL, &prm->tm_iocb2, 1, 0);
-	qlt_put_sess(sess);
+	if (sess)
+		ha->tgt.tgt_ops->put_sess(sess);
 	spin_unlock_irqrestore(&ha->tgt.sess_lock, flags);
 }
 
@@ -5374,7 +5266,6 @@ int qlt_add_target(struct qla_hw_data *ha, struct scsi_qla_host *base_vha)
 	tgt->ha = ha;
 	tgt->vha = base_vha;
 	init_waitqueue_head(&tgt->waitQ);
-	INIT_LIST_HEAD(&tgt->sess_list);
 	INIT_LIST_HEAD(&tgt->del_sess_list);
 	INIT_DELAYED_WORK(&tgt->sess_del_work,
 		(void (*)(struct work_struct *))qlt_del_sess_work_fn);
@@ -6230,9 +6121,8 @@ int __init qlt_init(void)
 	}
 
 	qla_tgt_plogi_cachep = kmem_cache_create("qla_tgt_plogi_cachep",
-						 sizeof(qlt_plogi_ack_t),
-						 __alignof__(qlt_plogi_ack_t),
-						 0, NULL);
+	    sizeof(struct qlt_plogi_ack_t), __alignof__(struct qlt_plogi_ack_t),
+	    0, NULL);
 
 	if (!qla_tgt_plogi_cachep) {
 		ql_log(ql_log_fatal, NULL, 0xe06d,
diff --git a/drivers/scsi/qla2xxx/qla_target.h b/drivers/scsi/qla2xxx/qla_target.h
index 07ccf81..9c35ba1 100644
--- a/drivers/scsi/qla2xxx/qla_target.h
+++ b/drivers/scsi/qla2xxx/qla_target.h
@@ -118,84 +118,6 @@
 			 ? le16_to_cpu((iocb)->u.isp2x.target.extended)	\
 			 : (uint16_t)(iocb)->u.isp2x.target.id.standard)
 
-#ifndef IMMED_NOTIFY_TYPE
-#define IMMED_NOTIFY_TYPE 0x0D		/* Immediate notify entry. */
-/*
- * ISP queue -	immediate notify entry structure definition.
- *		This is sent by the ISP to the Target driver.
- *		This IOCB would have report of events sent by the
- *		initiator, that needs to be handled by the target
- *		driver immediately.
- */
-struct imm_ntfy_from_isp {
-	uint8_t	 entry_type;		    /* Entry type. */
-	uint8_t	 entry_count;		    /* Entry count. */
-	uint8_t	 sys_define;		    /* System defined. */
-	uint8_t	 entry_status;		    /* Entry Status. */
-	union {
-		struct {
-			uint32_t sys_define_2; /* System defined. */
-			target_id_t target;
-			uint16_t lun;
-			uint8_t  target_id;
-			uint8_t  reserved_1;
-			uint16_t status_modifier;
-			uint16_t status;
-			uint16_t task_flags;
-			uint16_t seq_id;
-			uint16_t srr_rx_id;
-			uint32_t srr_rel_offs;
-			uint16_t srr_ui;
-#define SRR_IU_DATA_IN	0x1
-#define SRR_IU_DATA_OUT	0x5
-#define SRR_IU_STATUS	0x7
-			uint16_t srr_ox_id;
-			uint8_t reserved_2[28];
-		} isp2x;
-		struct {
-			uint32_t reserved;
-			uint16_t nport_handle;
-			uint16_t reserved_2;
-			uint16_t flags;
-#define NOTIFY24XX_FLAGS_GLOBAL_TPRLO   BIT_1
-#define NOTIFY24XX_FLAGS_PUREX_IOCB     BIT_0
-			uint16_t srr_rx_id;
-			uint16_t status;
-			uint8_t  status_subcode;
-			uint8_t  fw_handle;
-			uint32_t exchange_address;
-			uint32_t srr_rel_offs;
-			uint16_t srr_ui;
-			uint16_t srr_ox_id;
-			union {
-				struct {
-					uint8_t node_name[8];
-				} plogi; /* PLOGI/ADISC/PDISC */
-				struct {
-					/* PRLI word 3 bit 0-15 */
-					uint16_t wd3_lo;
-					uint8_t resv0[6];
-				} prli;
-				struct {
-					uint8_t port_id[3];
-					uint8_t resv1;
-					uint16_t nport_handle;
-					uint16_t resv2;
-				} req_els;
-			} u;
-			uint8_t port_name[8];
-			uint8_t resv3[3];
-			uint8_t  vp_index;
-			uint32_t reserved_5;
-			uint8_t  port_id[3];
-			uint8_t  reserved_6;
-		} isp24;
-	} u;
-	uint16_t reserved_7;
-	uint16_t ox_id;
-} __packed;
-#endif
-
 #ifndef NOTIFY_ACK_TYPE
 #define NOTIFY_ACK_TYPE 0x0E	  /* Notify acknowledge entry. */
 /*
@@ -731,7 +653,7 @@ struct abts_resp_from_24xx_fw {
 \********************************************************************/
 
 struct qla_tgt_mgmt_cmd;
-struct qla_tgt_sess;
+struct fc_port;
 
 /*
  * This structure provides a template of function calls that the
@@ -748,17 +670,18 @@ struct qla_tgt_func_tmpl {
 			uint32_t);
 	void (*free_cmd)(struct qla_tgt_cmd *);
 	void (*free_mcmd)(struct qla_tgt_mgmt_cmd *);
-	void (*free_session)(struct qla_tgt_sess *);
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
+	void (*put_sess)(struct fc_port *);
+	void (*shutdown_sess)(struct fc_port *);
 };
 
 int qla2x00_wait_for_hba_online(struct scsi_qla_host *);
@@ -874,9 +797,6 @@ struct qla_tgt {
 	/* Count of sessions refering qla_tgt. Protected by hardware_lock. */
 	int sess_count;
 
-	/* Protected by hardware_lock. Addition also protected by tgt_mutex. */
-	struct list_head sess_list;
-
 	/* Protected by hardware_lock */
 	struct list_head del_sess_list;
 	struct delayed_work sess_del_work;
@@ -910,52 +830,6 @@ enum qla_sess_deletion {
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
-	port_id_t d_id;
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
-};
-
 enum trace_flags {
 	TRC_NEW_CMD = BIT_0,
 	TRC_DO_WORK = BIT_1,
@@ -981,7 +855,7 @@ enum trace_flags {
 
 struct qla_tgt_cmd {
 	struct se_cmd se_cmd;
-	struct qla_tgt_sess *sess;
+	struct fc_port *sess;
 	int state;
 	struct work_struct free_work;
 	struct work_struct work;
@@ -1046,7 +920,7 @@ struct qla_tgt_sess_work_param {
 struct qla_tgt_mgmt_cmd {
 	uint16_t tmr_func;
 	uint8_t fc_tm_rsp;
-	struct qla_tgt_sess *sess;
+	struct fc_port *sess;
 	struct se_cmd se_cmd;
 	struct work_struct free_work;
 	unsigned int flags;
@@ -1097,7 +971,7 @@ struct qla_tgt_prm {
 extern int qlt_lport_register(void *, u64, u64, u64,
 			int (*callback)(struct scsi_qla_host *, void *, u64, u64));
 extern void qlt_lport_deregister(struct scsi_qla_host *);
-void qlt_put_sess(struct qla_tgt_sess *sess);
+extern void qlt_unreg_sess(struct fc_port *);
 extern void qlt_fc_port_added(struct scsi_qla_host *, fc_port_t *);
 extern void qlt_fc_port_deleted(struct scsi_qla_host *, fc_port_t *, int);
 extern int __init qlt_init(void);
diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.c b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
index c96de1c..e37d7ee 100644
--- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
+++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
@@ -339,9 +339,26 @@ static void tcm_qla2xxx_release_cmd(struct se_cmd *se_cmd)
 	qlt_free_cmd(cmd);
 }
 
+static void tcm_qla2xxx_release_session(struct kref *kref)
+{
+	struct fc_port  *sess = container_of(kref,
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
 static void tcm_qla2xxx_close_session(struct se_session *se_sess)
 {
-	struct qla_tgt_sess *sess = se_sess->fabric_sess_ptr;
+	struct fc_port *sess = se_sess->fabric_sess_ptr;
 	struct scsi_qla_host *vha;
 	unsigned long flags;
 
@@ -350,7 +367,7 @@ static void tcm_qla2xxx_close_session(struct se_session *se_sess)
 
 	spin_lock_irqsave(&vha->hw->tgt.sess_lock, flags);
 	target_sess_cmd_list_set_waiting(se_sess);
-	qlt_put_sess(sess);
+	tcm_qla2xxx_put_sess(sess);
 	spin_unlock_irqrestore(&vha->hw->tgt.sess_lock, flags);
 }
 
@@ -441,7 +458,7 @@ static int tcm_qla2xxx_handle_cmd(scsi_qla_host_t *vha, struct qla_tgt_cmd *cmd,
 {
 	struct se_cmd *se_cmd = &cmd->se_cmd;
 	struct se_session *se_sess;
-	struct qla_tgt_sess *sess;
+	struct fc_port *sess;
 #ifdef CONFIG_TCM_QLA2XXX_DEBUG
 	struct se_portal_group *se_tpg;
 	struct tcm_qla2xxx_tpg *tpg;
@@ -456,7 +473,7 @@ static int tcm_qla2xxx_handle_cmd(scsi_qla_host_t *vha, struct qla_tgt_cmd *cmd,
 
 	sess = cmd->sess;
 	if (!sess) {
-		pr_err("Unable to locate struct qla_tgt_sess from qla_tgt_cmd\n");
+		pr_err("Unable to locate struct fc_port from qla_tgt_cmd\n");
 		return -EINVAL;
 	}
 
@@ -565,7 +582,7 @@ static void tcm_qla2xxx_handle_dif_err(struct qla_tgt_cmd *cmd)
 static int tcm_qla2xxx_handle_tmr(struct qla_tgt_mgmt_cmd *mcmd, uint32_t lun,
 	uint16_t tmr_func, uint32_t tag)
 {
-	struct qla_tgt_sess *sess = mcmd->sess;
+	struct fc_port *sess = mcmd->sess;
 	struct se_cmd *se_cmd = &mcmd->se_cmd;
 	int transl_tmr_func = 0;
 
@@ -746,11 +763,11 @@ static void tcm_qla2xxx_aborted_task(struct se_cmd *se_cmd)
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
 	struct se_node_acl *se_nacl = sess->se_sess->se_node_acl;
 	struct se_portal_group *se_tpg = se_nacl->se_tpg;
@@ -789,7 +806,7 @@ static void tcm_qla2xxx_clear_nacl_from_fcport_map(struct qla_tgt_sess *sess)
 	tcm_qla2xxx_clear_sess_lookup(lport, nacl, sess);
 }
 
-static void tcm_qla2xxx_shutdown_sess(struct qla_tgt_sess *sess)
+static void tcm_qla2xxx_shutdown_sess(struct fc_port *sess)
 {
 	assert_spin_locked(&sess->vha->hw->tgt.sess_lock);
 	target_sess_cmd_list_set_waiting(sess->se_sess);
@@ -1174,7 +1191,7 @@ static struct se_portal_group *tcm_qla2xxx_npiv_make_tpg(
 /*
  * Expected to be called with struct qla_hw_data->tgt.sess_lock held
  */
-static struct qla_tgt_sess *tcm_qla2xxx_find_sess_by_s_id(
+static struct fc_port *tcm_qla2xxx_find_sess_by_s_id(
 	scsi_qla_host_t *vha,
 	const uint8_t *s_id)
 {
@@ -1202,12 +1219,12 @@ static struct qla_tgt_sess *tcm_qla2xxx_find_sess_by_s_id(
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
@@ -1218,7 +1235,7 @@ static void tcm_qla2xxx_set_sess_by_s_id(
 	struct se_node_acl *new_se_nacl,
 	struct tcm_qla2xxx_nacl *nacl,
 	struct se_session *se_sess,
-	struct qla_tgt_sess *qla_tgt_sess,
+	struct fc_port *fc_port,
 	uint8_t *s_id)
 {
 	u32 key;
@@ -1242,22 +1259,22 @@ static void tcm_qla2xxx_set_sess_by_s_id(
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
 
@@ -1267,19 +1284,19 @@ static void tcm_qla2xxx_set_sess_by_s_id(
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
@@ -1307,12 +1324,12 @@ static struct qla_tgt_sess *tcm_qla2xxx_find_sess_by_loop_id(
 
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
@@ -1323,7 +1340,7 @@ static void tcm_qla2xxx_set_sess_by_loop_id(
 	struct se_node_acl *new_se_nacl,
 	struct tcm_qla2xxx_nacl *nacl,
 	struct se_session *se_sess,
-	struct qla_tgt_sess *qla_tgt_sess,
+	struct fc_port *fc_port,
 	uint16_t loop_id)
 {
 	struct se_node_acl *saved_nacl;
@@ -1338,27 +1355,27 @@ static void tcm_qla2xxx_set_sess_by_loop_id(
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
 
@@ -1368,22 +1385,22 @@ static void tcm_qla2xxx_set_sess_by_loop_id(
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
@@ -1398,7 +1415,7 @@ static void tcm_qla2xxx_clear_sess_lookup(struct tcm_qla2xxx_lport *lport,
 				sess, sess->loop_id);
 }
 
-static void tcm_qla2xxx_free_session(struct qla_tgt_sess *sess)
+static void tcm_qla2xxx_free_session(struct fc_port *sess)
 {
 	struct qla_tgt *tgt = sess->tgt;
 	struct qla_hw_data *ha = tgt->ha;
@@ -1410,7 +1427,7 @@ static void tcm_qla2xxx_free_session(struct qla_tgt_sess *sess)
 
 	se_sess = sess->se_sess;
 	if (!se_sess) {
-		pr_err("struct qla_tgt_sess->se_sess is NULL\n");
+		pr_err("struct fc_port->se_sess is NULL\n");
 		dump_stack();
 		return;
 	}
@@ -1437,7 +1454,7 @@ static int tcm_qla2xxx_session_cb(struct se_portal_group *se_tpg,
 	struct se_node_acl *se_nacl = se_sess->se_node_acl;
 	struct tcm_qla2xxx_nacl *nacl = container_of(se_nacl,
 				struct tcm_qla2xxx_nacl, se_node_acl);
-	struct qla_tgt_sess *qlat_sess = p;
+	struct fc_port *qlat_sess = p;
 	uint16_t loop_id = qlat_sess->loop_id;
 	unsigned long flags;
 	unsigned char be_sid[3];
@@ -1467,7 +1484,7 @@ static int tcm_qla2xxx_session_cb(struct se_portal_group *se_tpg,
 static int tcm_qla2xxx_check_initiator_node_acl(
 	scsi_qla_host_t *vha,
 	unsigned char *fc_wwpn,
-	struct qla_tgt_sess *qlat_sess)
+	struct fc_port *qlat_sess)
 {
 	struct qla_hw_data *ha = vha->hw;
 	struct tcm_qla2xxx_lport *lport;
@@ -1511,7 +1528,7 @@ static int tcm_qla2xxx_check_initiator_node_acl(
 	return 0;
 }
 
-static void tcm_qla2xxx_update_sess(struct qla_tgt_sess *sess, port_id_t s_id,
+static void tcm_qla2xxx_update_sess(struct fc_port *sess, port_id_t s_id,
 				    uint16_t loop_id, bool conf_compl_supported)
 {
 	struct qla_tgt *tgt = sess->tgt;
@@ -1603,6 +1620,7 @@ static void tcm_qla2xxx_update_sess(struct qla_tgt_sess *sess, port_id_t s_id,
 	.find_sess_by_s_id	= tcm_qla2xxx_find_sess_by_s_id,
 	.find_sess_by_loop_id	= tcm_qla2xxx_find_sess_by_loop_id,
 	.clear_nacl_from_fcport_map = tcm_qla2xxx_clear_nacl_from_fcport_map,
+	.put_sess		= tcm_qla2xxx_put_sess,
 	.shutdown_sess		= tcm_qla2xxx_shutdown_sess,
 };
 
diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.h b/drivers/scsi/qla2xxx/tcm_qla2xxx.h
index cf8430b..071035d 100644
--- a/drivers/scsi/qla2xxx/tcm_qla2xxx.h
+++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.h
@@ -20,8 +20,8 @@ struct tcm_qla2xxx_nacl {
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
-- 
1.8.3.1
