From: Himanshu Madhani <himanshu.madhani@qlogic.com>
Subject: [PATCH v2 2/8] qla2xxx: cleanup cmd in qla workqueue before processing TMR
Date: Tue, 14 Jul 2015 16:00:43 -0400
Message-ID: <1436904049-27707-3-git-send-email-himanshu.madhani@qlogic.com>
References: <1436904049-27707-1-git-send-email-himanshu.madhani@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-0016ce01.pphosted.com ([67.231.156.153]:9778 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753595AbbGNUpz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 14 Jul 2015 16:45:55 -0400
In-Reply-To: <1436904049-27707-1-git-send-email-himanshu.madhani@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: hch@lst.de, giridhar.malavali@qlogic.com, himanshu.madhani@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org

From: Swapnil Nagle <swapnil.nagle@purestorage.com>

Since cmds go into qla_tgt_wq and TMRs don't, it's possible that TMR
like TASK_ABORT can be queued over the cmd for which it was meant.
To avoid this race, use a per-port list to keep track of cmds that
are enqueued to qla_tgt_wq but not yet processed. When a TMR arrives,
iterate through this list and remove any cmds that match the TMR.
This patch supports TASK_ABORT and LUN_RESET.

Cc: <stable@vger.kernel.org>
Signed-off-by: Swapnil Nagle <swapnil.nagle@purestorage.com>
Signed-off-by: Alexei Potashnik <alexei@purestorage.com>
Acked-by: Quinn Tran <quinn.tran@qlogic.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_dbg.c     |    2 +-
 drivers/scsi/qla2xxx/qla_def.h     |    5 ++
 drivers/scsi/qla2xxx/qla_os.c      |    3 +
 drivers/scsi/qla2xxx/qla_target.c  |  123 ++++++++++++++++++++++++++++++++++--
 drivers/scsi/qla2xxx/qla_target.h  |   12 ++++
 drivers/scsi/qla2xxx/tcm_qla2xxx.c |    8 +--
 6 files changed, 140 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_dbg.c b/drivers/scsi/qla2xxx/qla_dbg.c
index e9ae6b9..e63aa07 100644
--- a/drivers/scsi/qla2xxx/qla_dbg.c
+++ b/drivers/scsi/qla2xxx/qla_dbg.c
@@ -68,7 +68,7 @@
  * |                              |                    | 0xd101-0xd1fe	|
  * |                              |                    | 0xd214-0xd2fe	|
  * | Target Mode		  |	  0xe079       |		|
- * | Target Mode Management	  |	  0xf080       | 0xf002		|
+ * | Target Mode Management	  |	  0xf083       | 0xf002		|
  * |                              |                    | 0xf046-0xf049  |
  * | Target Mode Task Management  |	  0x1000b      |		|
  * ----------------------------------------------------------------------
diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index a47374d..2c10f1f 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -3600,6 +3600,11 @@ typedef struct scsi_qla_host {
 	uint16_t	fcoe_fcf_idx;
 	uint8_t		fcoe_vn_port_mac[6];
 
+	/* list of commands waiting on workqueue */
+	struct list_head	qla_cmd_list;
+	struct list_head	qla_sess_op_cmd_list;
+	spinlock_t		cmd_list_lock;
+
 	uint32_t	vp_abort_cnt;
 
 	struct fc_vport	*fc_vport;	/* holds fc_vport * for each vport */
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 7c7528b..7ce395a 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -3764,8 +3764,11 @@ struct scsi_qla_host *qla2x00_create_host(struct scsi_host_template *sht,
 	INIT_LIST_HEAD(&vha->vp_fcports);
 	INIT_LIST_HEAD(&vha->work_list);
 	INIT_LIST_HEAD(&vha->list);
+	INIT_LIST_HEAD(&vha->qla_cmd_list);
+	INIT_LIST_HEAD(&vha->qla_sess_op_cmd_list);
 
 	spin_lock_init(&vha->work_lock);
+	spin_lock_init(&vha->cmd_list_lock);
 
 	sprintf(vha->host_str, "%s_%ld", QLA2XXX_DRIVER_NAME, vha->host_no);
 	ql_dbg(ql_dbg_init, vha, 0x0041,
diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index 97b42c0..2c483cc 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -1170,6 +1170,70 @@ static void qlt_24xx_retry_term_exchange(struct scsi_qla_host *vha,
 	    FCP_TMF_CMPL, true);
 }
 
+static int abort_cmd_for_tag(struct scsi_qla_host *vha, uint32_t tag)
+{
+	struct qla_tgt_sess_op *op;
+	struct qla_tgt_cmd *cmd;
+
+	spin_lock(&vha->cmd_list_lock);
+
+	list_for_each_entry(op, &vha->qla_sess_op_cmd_list, cmd_list) {
+		if (tag == op->atio.u.isp24.exchange_addr) {
+			op->aborted = true;
+			spin_unlock(&vha->cmd_list_lock);
+			return 1;
+		}
+	}
+
+	list_for_each_entry(cmd, &vha->qla_cmd_list, cmd_list) {
+		if (tag == cmd->atio.u.isp24.exchange_addr) {
+			cmd->state = QLA_TGT_STATE_ABORTED;
+			spin_unlock(&vha->cmd_list_lock);
+			return 1;
+		}
+	}
+
+	spin_unlock(&vha->cmd_list_lock);
+	return 0;
+}
+
+/* drop cmds for the given lun
+ * XXX only looks for cmds on the port through which lun reset was recieved
+ * XXX does not go through the list of other port (which may have cmds
+ *     for the same lun)
+ */
+static void abort_cmds_for_lun(struct scsi_qla_host *vha,
+				uint32_t lun, uint8_t *s_id)
+{
+	struct qla_tgt_sess_op *op;
+	struct qla_tgt_cmd *cmd;
+	uint32_t key;
+
+	key = sid_to_key(s_id);
+	spin_lock(&vha->cmd_list_lock);
+	list_for_each_entry(op, &vha->qla_sess_op_cmd_list, cmd_list) {
+		uint32_t op_key;
+		uint32_t op_lun;
+
+		op_key = sid_to_key(op->atio.u.isp24.fcp_hdr.s_id);
+		op_lun = scsilun_to_int(
+			(struct scsi_lun *)&op->atio.u.isp24.fcp_cmnd.lun);
+		if (op_key == key && op_lun == lun)
+			op->aborted = true;
+	}
+	list_for_each_entry(cmd, &vha->qla_cmd_list, cmd_list) {
+		uint32_t cmd_key;
+		uint32_t cmd_lun;
+
+		cmd_key = sid_to_key(cmd->atio.u.isp24.fcp_hdr.s_id);
+		cmd_lun = scsilun_to_int(
+			(struct scsi_lun *)&cmd->atio.u.isp24.fcp_cmnd.lun);
+		if (cmd_key == key && cmd_lun == lun)
+			cmd->state = QLA_TGT_STATE_ABORTED;
+	}
+	spin_unlock(&vha->cmd_list_lock);
+}
+
 /* ha->hardware_lock supposed to be held on entry */
 static int __qlt_24xx_handle_abts(struct scsi_qla_host *vha,
 	struct abts_recv_from_24xx *abts, struct qla_tgt_sess *sess)
@@ -1194,8 +1258,19 @@ static int __qlt_24xx_handle_abts(struct scsi_qla_host *vha,
 	}
 	spin_unlock(&se_sess->sess_cmd_lock);
 
-	if (!found_lun)
-		return -ENOENT;
+	/* cmd not in LIO lists, look in qla list */
+	if (!found_lun) {
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
+	}
 
 	ql_dbg(ql_dbg_tgt_mgt, vha, 0xf00f,
 	    "qla_target(%d): task abort (tag=%d)\n",
@@ -3270,6 +3345,13 @@ static void __qlt_do_work(struct qla_tgt_cmd *cmd)
 	if (tgt->tgt_stop)
 		goto out_term;
 
+	if (cmd->state == QLA_TGT_STATE_ABORTED) {
+		ql_dbg(ql_dbg_tgt_mgt, vha, 0xf082,
+		    "cmd with tag %u is aborted\n",
+		    cmd->atio.u.isp24.exchange_addr);
+		goto out_term;
+	}
+
 	cdb = &atio->u.isp24.fcp_cmnd.cdb[0];
 	cmd->se_cmd.tag = atio->u.isp24.exchange_addr;
 	cmd->unpacked_lun = scsilun_to_int(
@@ -3323,6 +3405,12 @@ out_term:
 static void qlt_do_work(struct work_struct *work)
 {
 	struct qla_tgt_cmd *cmd = container_of(work, struct qla_tgt_cmd, work);
+	scsi_qla_host_t *vha = cmd->vha;
+	unsigned long flags;
+
+	spin_lock_irqsave(&vha->cmd_list_lock, flags);
+	list_del(&cmd->cmd_list);
+	spin_unlock_irqrestore(&vha->cmd_list_lock, flags);
 
 	__qlt_do_work(cmd);
 }
@@ -3374,14 +3462,25 @@ static void qlt_create_sess_from_atio(struct work_struct *work)
 	unsigned long flags;
 	uint8_t *s_id = op->atio.u.isp24.fcp_hdr.s_id;
 
+	spin_lock_irqsave(&vha->cmd_list_lock, flags);
+	list_del(&op->cmd_list);
+	spin_unlock_irqrestore(&vha->cmd_list_lock, flags);
+
+	if (op->aborted) {
+		ql_dbg(ql_dbg_tgt_mgt, vha, 0xf083,
+		    "sess_op with tag %u is aborted\n",
+		    op->atio.u.isp24.exchange_addr);
+		goto out_term;
+	}
+
 	ql_dbg(ql_dbg_tgt_mgt, vha, 0xf022,
-		"qla_target(%d): Unable to find wwn login"
-		" (s_id %x:%x:%x), trying to create it manually\n",
-		vha->vp_idx, s_id[0], s_id[1], s_id[2]);
+	    "qla_target(%d): Unable to find wwn login"
+	    " (s_id %x:%x:%x), trying to create it manually\n",
+	    vha->vp_idx, s_id[0], s_id[1], s_id[2]);
 
 	if (op->atio.u.raw.entry_count > 1) {
 		ql_dbg(ql_dbg_tgt_mgt, vha, 0xf023,
-		        "Dropping multy entry atio %p\n", &op->atio);
+		    "Dropping multy entry atio %p\n", &op->atio);
 		goto out_term;
 	}
 
@@ -3446,6 +3545,11 @@ static int qlt_handle_cmd_for_atio(struct scsi_qla_host *vha,
 
 		memcpy(&op->atio, atio, sizeof(*atio));
 		op->vha = vha;
+
+		spin_lock(&vha->cmd_list_lock);
+		list_add_tail(&op->cmd_list, &vha->qla_sess_op_cmd_list);
+		spin_unlock(&vha->cmd_list_lock);
+
 		INIT_WORK(&op->work, qlt_create_sess_from_atio);
 		queue_work(qla_tgt_wq, &op->work);
 		return 0;
@@ -3465,6 +3569,11 @@ static int qlt_handle_cmd_for_atio(struct scsi_qla_host *vha,
 
 	cmd->cmd_in_wq = 1;
 	cmd->cmd_flags |= BIT_0;
+
+	spin_lock(&vha->cmd_list_lock);
+	list_add_tail(&cmd->cmd_list, &vha->qla_cmd_list);
+	spin_unlock(&vha->cmd_list_lock);
+
 	INIT_WORK(&cmd->work, qlt_do_work);
 	queue_work(qla_tgt_wq, &cmd->work);
 	return 0;
@@ -3478,6 +3587,7 @@ static int qlt_issue_task_mgmt(struct qla_tgt_sess *sess, uint32_t lun,
 	struct scsi_qla_host *vha = sess->vha;
 	struct qla_hw_data *ha = vha->hw;
 	struct qla_tgt_mgmt_cmd *mcmd;
+	struct atio_from_isp *a = (struct atio_from_isp *)iocb;
 	int res;
 	uint8_t tmr_func;
 
@@ -3518,6 +3628,7 @@ static int qlt_issue_task_mgmt(struct qla_tgt_sess *sess, uint32_t lun,
 		ql_dbg(ql_dbg_tgt_tmr, vha, 0x10002,
 		    "qla_target(%d): LUN_RESET received\n", sess->vha->vp_idx);
 		tmr_func = TMR_LUN_RESET;
+		abort_cmds_for_lun(vha, lun, a->u.isp24.fcp_hdr.s_id);
 		break;
 
 	case QLA_TGT_CLEAR_TS:
diff --git a/drivers/scsi/qla2xxx/qla_target.h b/drivers/scsi/qla2xxx/qla_target.h
index dfeeadf..3104335 100644
--- a/drivers/scsi/qla2xxx/qla_target.h
+++ b/drivers/scsi/qla2xxx/qla_target.h
@@ -874,6 +874,8 @@ struct qla_tgt_sess_op {
 	struct scsi_qla_host *vha;
 	struct atio_from_isp atio;
 	struct work_struct work;
+	struct list_head cmd_list;
+	bool aborted;
 };
 
 /*
@@ -1076,6 +1078,16 @@ static inline void qla_reverse_ini_mode(struct scsi_qla_host *ha)
 		ha->host->active_mode |= MODE_INITIATOR;
 }
 
+static inline uint32_t sid_to_key(const uint8_t *s_id)
+{
+	uint32_t key;
+
+	key = (((unsigned long)s_id[0] << 16) |
+	       ((unsigned long)s_id[1] << 8) |
+	       (unsigned long)s_id[2]);
+	return key;
+}
+
 /*
  * Exported symbols from qla_target.c LLD logic used by qla2xxx code..
  */
diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.c b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
index 3c981d7..f0dd8b7 100644
--- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
+++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
@@ -1152,9 +1152,7 @@ static struct qla_tgt_sess *tcm_qla2xxx_find_sess_by_s_id(
 		return NULL;
 	}
 
-	key = (((unsigned long)s_id[0] << 16) |
-	       ((unsigned long)s_id[1] << 8) |
-	       (unsigned long)s_id[2]);
+	key = sid_to_key(s_id);
 	pr_debug("find_sess_by_s_id: 0x%06x\n", key);
 
 	se_nacl = btree_lookup32(&lport->lport_fcport_map, key);
@@ -1189,9 +1187,7 @@ static void tcm_qla2xxx_set_sess_by_s_id(
 	void *slot;
 	int rc;
 
-	key = (((unsigned long)s_id[0] << 16) |
-	       ((unsigned long)s_id[1] << 8) |
-	       (unsigned long)s_id[2]);
+	key = sid_to_key(s_id);
 	pr_debug("set_sess_by_s_id: %06x\n", key);
 
 	slot = btree_lookup32(&lport->lport_fcport_map, key);
-- 
1.7.7

