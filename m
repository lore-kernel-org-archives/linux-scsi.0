From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH] qla_target/tcm_qla2xxx: Make qla_tgt_mgmt_cmd use TARGET_SCF_ACK_KREF
Date: Sat, 10 Mar 2012 05:19:52 +0000
Message-ID: <1331356792-8432-1-git-send-email-nab@linux-iscsi.org>
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Giridhar Malavali <giridhar.malavali@qlogic.com>, Arun Easi <arun.easi@qlogic.com>, Christoph Hellwig <hch@lst.de>, Roland Dreier <roland@purestorage.com>, Madhuranath Iyengar <mni@risingtidesystems.com>, Nicholas Bellinger <nab@linux-iscsi.org>, Joern Engel <joern@logfs.org>, Andy Grover <agrover@redhat.com>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch addresses an bug in recent qla_target/tcm_qla2xxx code where
transport_generic_free_cmd() is not being called for TMR ops and associated
qla_tgt_mgmt_cmd->se_cmd.  This results in core_tmr_release_req() not being
called and tmr->tmr_list being leaked after TMR response completion.

To address this issue, this patch changes tcm_qla2xxx_handle_tmr() ->
target_submit_tmr() to use TARGET_SCF_ACK_KREF flags, and adds a new
qla_tgt_ops->free_mcmd() callback to invoke the extra ACK ->cmd_kref put
from process context in the TFO->queue_tm_rsp() -> tcm_qla2xxx_queue_tm_rsp()
-> qla_tgt_xmit_tm_rsp() codepath.

Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: Arun Easi <arun.easi@qlogic.com>
Cc: Giridhar Malavali <giridhar.malavali@qlogic.com>
Cc: Roland Dreier <roland@purestorage.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Joern Engel <joern@logfs.org>
Cc: Andy Grover <agrover@redhat.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/scsi/qla2xxx/qla_target.c  |    9 +++++++++
 drivers/scsi/qla2xxx/qla_target.h  |    2 ++
 drivers/scsi/qla2xxx/tcm_qla2xxx.c |   22 +++++++++++++++++++++-
 3 files changed, 32 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index b6db377..b03393a 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -1409,6 +1409,15 @@ void qla_tgt_xmit_tm_rsp(struct qla_tgt_mgmt_cmd *mcmd)
 		else
 			qla_tgt_24xx_send_task_mgmt_ctio(vha, mcmd, mcmd->fc_tm_rsp);
 	}
+	/*
+	 * Make the callback for ->free_mcmd() to queue_work() and invoke
+	 * target_put_sess_cmd() to drop cmd_kref to 1.  The final
+	 * target_put_sess_cmd() call will be made from TFO->check_stop_free()
+	 * -> tcm_qla2xxx_check_stop_free() to release the TMR associated se_cmd
+	 * descriptor after TFO->queue_tm_rsp() -> tcm_qla2xxx_queue_tm_rsp() ->
+	 * qla_tgt_xmit_tm_rsp() returns here..
+	 */
+	ha->tgt_ops->free_mcmd(mcmd);
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 }
 EXPORT_SYMBOL(qla_tgt_xmit_tm_rsp);
diff --git a/drivers/scsi/qla2xxx/qla_target.h b/drivers/scsi/qla2xxx/qla_target.h
index 6930d58..d643f27 100644
--- a/drivers/scsi/qla2xxx/qla_target.h
+++ b/drivers/scsi/qla2xxx/qla_target.h
@@ -636,6 +636,7 @@ struct qla_tgt_func_tmpl {
 	int (*handle_data)(struct qla_tgt_cmd *);
 	int (*handle_tmr)(struct qla_tgt_mgmt_cmd *, uint32_t, uint8_t, uint32_t);
 	void (*free_cmd)(struct qla_tgt_cmd *);
+	void (*free_mcmd)(struct qla_tgt_mgmt_cmd *);
 	void (*free_session)(struct qla_tgt_sess *);
 
 	int (*check_initiator_node_acl)(struct scsi_qla_host *, unsigned char *,
@@ -870,6 +871,7 @@ struct qla_tgt_mgmt_cmd {
 	uint8_t fc_tm_rsp;
 	struct qla_tgt_sess *sess;
 	struct se_cmd se_cmd;
+	struct work_struct free_work;
 	unsigned int flags;
 #define QLA24XX_MGMT_SEND_NACK	1
 	union {
diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.c b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
index 85eec3e..c6acb80 100644
--- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
+++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
@@ -387,6 +387,25 @@ u32 tcm_qla2xxx_tpg_get_inst_index(struct se_portal_group *se_tpg)
 	return tpg->lport_tpgt;
 }
 
+static void tcm_qla2xxx_complete_mcmd(struct work_struct *work)
+{
+	struct qla_tgt_mgmt_cmd *mcmd = container_of(work,
+			struct qla_tgt_mgmt_cmd, free_work);
+
+	transport_generic_free_cmd(&mcmd->se_cmd, 0);
+}
+
+/*
+ * Called from qla_target_template->free_mcmd(), and will call
+ * tcm_qla2xxx_release_cmd() via normal struct target_core_fabric_ops
+ * release callback.  qla_hw_data->hardware_lock is expected to be held
+ */
+static void tcm_qla2xxx_free_mcmd(struct qla_tgt_mgmt_cmd *mcmd)
+{
+	INIT_WORK(&mcmd->free_work, tcm_qla2xxx_complete_mcmd);
+	queue_work(tcm_qla2xxx_free_wq, &mcmd->free_work);
+}
+
 static void tcm_qla2xxx_complete_free(struct work_struct *work)
 {
 	struct qla_tgt_cmd *cmd = container_of(work, struct qla_tgt_cmd, work);
@@ -637,7 +656,7 @@ int tcm_qla2xxx_handle_tmr(struct qla_tgt_mgmt_cmd *mcmd, uint32_t lun,
 	struct se_cmd *se_cmd = &mcmd->se_cmd;
 
 	return target_submit_tmr(se_cmd, sess->se_sess, NULL, lun, mcmd,
-			tmr_func, GFP_ATOMIC, tag, 0);
+			tmr_func, GFP_ATOMIC, tag, TARGET_SCF_ACK_KREF);
 }
 
 int tcm_qla2xxx_queue_data_in(struct se_cmd *se_cmd)
@@ -1536,6 +1555,7 @@ static struct qla_tgt_func_tmpl tcm_qla2xxx_template = {
 	.handle_data		= tcm_qla2xxx_handle_data,
 	.handle_tmr		= tcm_qla2xxx_handle_tmr,
 	.free_cmd		= tcm_qla2xxx_free_cmd,
+	.free_mcmd		= tcm_qla2xxx_free_mcmd,
 	.free_session		= tcm_qla2xxx_free_session,
 	.check_initiator_node_acl = tcm_qla2xxx_check_initiator_node_acl,
 	.find_sess_by_s_id	= tcm_qla2xxx_find_sess_by_s_id,
-- 
1.7.2.5
