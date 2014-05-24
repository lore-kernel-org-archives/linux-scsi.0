From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH] qla2xxx: Convert to percpu_ida session tag pre-allocation
Date: Sat, 24 May 2014 00:43:36 +0000
Message-ID: <1400892216-9784-1-git-send-email-nab@daterainc.com>
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Nicholas Bellinger <nab@linux-iscsi.org>, Saurav Kashyap <saurav.kashyap@qlogic.com>, Quinn Tran <quinn.tran@qlogic.com>, Giridhar Malavali <giridhar.malavali@qlogic.com>, Chad Dupuis <chad.dupuis@qlogic.com>, Roland Dreier <roland@kernel.org>, Christoph Hellwig <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch converts qla2xxx target code to use generic percpu_ida
tag allocation provided by target-core, thus removing the original
kmem_cache_zalloc() for each struct qla_tgt_cmd descriptor in the
incoming ATIO packet fast-path.

This includes the conversion of qlt_handle_cmd_for_atio() to perform
qla_tgt_sess lookup before dispatching a command descriptor into
qla_tgt_wq process context, along with handling the case where no
active session exists, and subsequently kicking off a seperate
process context for qlt_create_sess_from_atio() to create a new one.

It also includes moving tag allocation into generic code within
qlt_get_tag(), so that the same logic can be shared between
qlt_handle_cmd_for_atio() + qlt_create_sess_from_atio() contexts.
Also, __qlt_do_work() has been made generic between both normal
process context in qlt_do_work() + qlt_create_sess_from_atio().

Next, update qlt_free_cmd() to release the percpu-ida tags, and
drop the now-unused global qla_tgt_cmd_cachep.

Finally in tcm_qla2xxx code, tcm_qla2xxx_check_initiator_node_acl()
has been updated to use transport_init_session_tags() along with a
hardcoded TCM_QLA2XXX_DEFAULT_TAGS=512 as the number of qla_tgt_cmd
descriptors to pre-allocate per qla_tgt_sess instance.

Cc: Saurav Kashyap <saurav.kashyap@qlogic.com>
Cc: Quinn Tran <quinn.tran@qlogic.com>
Cc: Giridhar Malavali <giridhar.malavali@qlogic.com>
Cc: Chad Dupuis <chad.dupuis@qlogic.com>
Cc: Roland Dreier <roland@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/scsi/qla2xxx/qla_target.c  |  195 ++++++++++++++++++++++++------------
 drivers/scsi/qla2xxx/qla_target.h  |    6 ++
 drivers/scsi/qla2xxx/tcm_qla2xxx.c |    4 +-
 drivers/scsi/qla2xxx/tcm_qla2xxx.h |    2 +
 4 files changed, 142 insertions(+), 65 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index 0cb7307..bd9c725 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -104,7 +104,6 @@ static void qlt_reject_free_srr_imm(struct scsi_qla_host *ha,
 /*
  * Global Variables
  */
-static struct kmem_cache *qla_tgt_cmd_cachep;
 static struct kmem_cache *qla_tgt_mgmt_cmd_cachep;
 static mempool_t *qla_tgt_mgmt_cmd_mempool;
 static struct workqueue_struct *qla_tgt_wq;
@@ -2165,11 +2164,18 @@ done:
 
 void qlt_free_cmd(struct qla_tgt_cmd *cmd)
 {
+	struct qla_tgt_sess *sess = cmd->sess;
+
 	BUG_ON(cmd->sg_mapped);
 
 	if (unlikely(cmd->free_sg))
 		kfree(cmd->sg);
-	kmem_cache_free(qla_tgt_cmd_cachep, cmd);
+
+	if (!sess || !sess->se_sess) {
+		WARN_ON(1);
+		return;
+	}
+	percpu_ida_free(&sess->se_sess->sess_tag_pool, cmd->se_cmd.map_tag);
 }
 EXPORT_SYMBOL(qlt_free_cmd);
 
@@ -2489,13 +2495,12 @@ static struct qla_tgt_sess *qlt_make_local_sess(struct scsi_qla_host *,
 /*
  * Process context for I/O path into tcm_qla2xxx code
  */
-static void qlt_do_work(struct work_struct *work)
+static void __qlt_do_work(struct qla_tgt_cmd *cmd)
 {
-	struct qla_tgt_cmd *cmd = container_of(work, struct qla_tgt_cmd, work);
 	scsi_qla_host_t *vha = cmd->vha;
 	struct qla_hw_data *ha = vha->hw;
 	struct qla_tgt *tgt = vha->vha_tgt.qla_tgt;
-	struct qla_tgt_sess *sess = NULL;
+	struct qla_tgt_sess *sess = cmd->sess;
 	struct atio_from_isp *atio = &cmd->atio;
 	unsigned char *cdb;
 	unsigned long flags;
@@ -2505,41 +2510,6 @@ static void qlt_do_work(struct work_struct *work)
 	if (tgt->tgt_stop)
 		goto out_term;
 
-	spin_lock_irqsave(&ha->hardware_lock, flags);
-	sess = ha->tgt.tgt_ops->find_sess_by_s_id(vha,
-	    atio->u.isp24.fcp_hdr.s_id);
-	/* Do kref_get() before dropping qla_hw_data->hardware_lock. */
-	if (sess)
-		kref_get(&sess->se_sess->sess_kref);
-	spin_unlock_irqrestore(&ha->hardware_lock, flags);
-
-	if (unlikely(!sess)) {
-		uint8_t *s_id =	atio->u.isp24.fcp_hdr.s_id;
-
-		ql_dbg(ql_dbg_tgt_mgt, vha, 0xf022,
-			"qla_target(%d): Unable to find wwn login"
-			" (s_id %x:%x:%x), trying to create it manually\n",
-			vha->vp_idx, s_id[0], s_id[1], s_id[2]);
-
-		if (atio->u.raw.entry_count > 1) {
-			ql_dbg(ql_dbg_tgt_mgt, vha, 0xf023,
-				"Dropping multy entry cmd %p\n", cmd);
-			goto out_term;
-		}
-
-		mutex_lock(&vha->vha_tgt.tgt_mutex);
-		sess = qlt_make_local_sess(vha, s_id);
-		/* sess has an extra creation ref. */
-		mutex_unlock(&vha->vha_tgt.tgt_mutex);
-
-		if (!sess)
-			goto out_term;
-	}
-
-	cmd->sess = sess;
-	cmd->loop_id = sess->loop_id;
-	cmd->conf_compl_supported = sess->conf_compl_supported;
-
 	cdb = &atio->u.isp24.fcp_cmnd.cdb[0];
 	cmd->tag = atio->u.isp24.exchange_addr;
 	cmd->unpacked_lun = scsilun_to_int(
@@ -2566,8 +2536,8 @@ static void qlt_do_work(struct work_struct *work)
 	    "qla_target: START qla command: %p lun: 0x%04x (tag %d)\n",
 	    cmd, cmd->unpacked_lun, cmd->tag);
 
-	ret = vha->hw->tgt.tgt_ops->handle_cmd(vha, cmd, cdb, data_length,
-	    fcp_task_attr, data_dir, bidi);
+	ret = ha->tgt.tgt_ops->handle_cmd(vha, cmd, cdb, data_length,
+				          fcp_task_attr, data_dir, bidi);
 	if (ret != 0)
 		goto out_term;
 	/*
@@ -2586,17 +2556,114 @@ out_term:
 	 */
 	spin_lock_irqsave(&ha->hardware_lock, flags);
 	qlt_send_term_exchange(vha, NULL, &cmd->atio, 1);
-	kmem_cache_free(qla_tgt_cmd_cachep, cmd);
-	if (sess)
+	percpu_ida_free(&sess->se_sess->sess_tag_pool, cmd->se_cmd.map_tag);
+	ha->tgt.tgt_ops->put_sess(sess);
+	spin_unlock_irqrestore(&ha->hardware_lock, flags);
+}
+
+static void qlt_do_work(struct work_struct *work)
+{
+	struct qla_tgt_cmd *cmd = container_of(work, struct qla_tgt_cmd, work);
+
+	__qlt_do_work(cmd);
+}
+
+static struct qla_tgt_cmd *qlt_get_tag(scsi_qla_host_t *vha,
+				       struct qla_tgt_sess *sess,
+				       struct atio_from_isp *atio)
+{
+	struct se_session *se_sess = sess->se_sess;
+	struct qla_tgt_cmd *cmd;
+	int tag;
+
+	tag = percpu_ida_alloc(&se_sess->sess_tag_pool, TASK_RUNNING);
+	if (tag < 0)
+		return NULL;
+
+	cmd = &((struct qla_tgt_cmd *)se_sess->sess_cmd_map)[tag];
+	memset(cmd, 0, sizeof(struct qla_tgt_cmd));
+
+	memcpy(&cmd->atio, atio, sizeof(*atio));
+	cmd->state = QLA_TGT_STATE_NEW;
+	cmd->tgt = vha->vha_tgt.qla_tgt;
+	cmd->vha = vha;
+	cmd->se_cmd.map_tag = tag;
+	cmd->sess = sess;
+	cmd->loop_id = sess->loop_id;
+	cmd->conf_compl_supported = sess->conf_compl_supported;
+
+	return cmd;
+}
+
+static void qlt_send_busy(struct scsi_qla_host *, struct atio_from_isp *,
+			  uint16_t);
+
+static void qlt_create_sess_from_atio(struct work_struct *work)
+{
+	struct qla_tgt_sess_op *op = container_of(work,
+					struct qla_tgt_sess_op, work);
+	scsi_qla_host_t *vha = op->vha;
+	struct qla_hw_data *ha = vha->hw;
+	struct qla_tgt_sess *sess;
+	struct qla_tgt_cmd *cmd;
+	unsigned long flags;
+	uint8_t *s_id = op->atio.u.isp24.fcp_hdr.s_id;
+
+	ql_dbg(ql_dbg_tgt_mgt, vha, 0xf022,
+		"qla_target(%d): Unable to find wwn login"
+		" (s_id %x:%x:%x), trying to create it manually\n",
+		vha->vp_idx, s_id[0], s_id[1], s_id[2]);
+
+	if (op->atio.u.raw.entry_count > 1) {
+		ql_dbg(ql_dbg_tgt_mgt, vha, 0xf023,
+		        "Dropping multy entry atio %p\n", &op->atio);
+		goto out_term;
+	}
+
+	mutex_lock(&vha->vha_tgt.tgt_mutex);
+	sess = qlt_make_local_sess(vha, s_id);
+	/* sess has an extra creation ref. */
+	mutex_unlock(&vha->vha_tgt.tgt_mutex);
+
+	if (!sess)
+		goto out_term;
+	/*
+	 * Now obtain a pre-allocated session tag using the original op->atio
+	 * packet header, and dispatch into __qlt_do_work() using the existing
+	 * process context.
+	 */
+	cmd = qlt_get_tag(vha, sess, &op->atio);
+	if (!cmd) {
+		spin_lock_irqsave(&ha->hardware_lock, flags);
+		qlt_send_busy(vha, &op->atio, SAM_STAT_BUSY);
 		ha->tgt.tgt_ops->put_sess(sess);
+		spin_unlock_irqrestore(&ha->hardware_lock, flags);
+		kfree(op);
+		return;
+	}
+	/*
+	 * __qlt_do_work() will call ha->tgt.tgt_ops->put_sess() to release
+	 * the extra reference taken above by qlt_make_local_sess()
+	 */
+	__qlt_do_work(cmd);
+	kfree(op);
+	return;
+
+out_term:
+	spin_lock_irqsave(&ha->hardware_lock, flags);
+	qlt_send_term_exchange(vha, NULL, &op->atio, 1);
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
+	kfree(op);
+
 }
 
 /* ha->hardware_lock supposed to be held on entry */
 static int qlt_handle_cmd_for_atio(struct scsi_qla_host *vha,
 	struct atio_from_isp *atio)
 {
+	struct qla_hw_data *ha = vha->hw;
 	struct qla_tgt *tgt = vha->vha_tgt.qla_tgt;
+	struct qla_tgt_sess *sess;
 	struct qla_tgt_cmd *cmd;
 
 	if (unlikely(tgt->tgt_stop)) {
@@ -2605,18 +2672,31 @@ static int qlt_handle_cmd_for_atio(struct scsi_qla_host *vha,
 		return -EFAULT;
 	}
 
-	cmd = kmem_cache_zalloc(qla_tgt_cmd_cachep, GFP_ATOMIC);
+	sess = ha->tgt.tgt_ops->find_sess_by_s_id(vha, atio->u.isp24.fcp_hdr.s_id);
+	if (unlikely(!sess)) {
+		struct qla_tgt_sess_op *op = kzalloc(sizeof(struct qla_tgt_sess_op),
+						     GFP_ATOMIC);
+		if (!op)
+			return -ENOMEM;
+
+		memcpy(&op->atio, atio, sizeof(*atio));
+		INIT_WORK(&op->work, qlt_create_sess_from_atio);
+		queue_work(qla_tgt_wq, &op->work);
+		return 0;
+	}
+	/*
+	 * Do kref_get() before returning + dropping qla_hw_data->hardware_lock.
+	 */
+	kref_get(&sess->se_sess->sess_kref);
+
+	cmd = qlt_get_tag(vha, sess, atio);
 	if (!cmd) {
 		ql_dbg(ql_dbg_tgt_mgt, vha, 0xf05e,
 		    "qla_target(%d): Allocation of cmd failed\n", vha->vp_idx);
+		ha->tgt.tgt_ops->put_sess(sess);
 		return -ENOMEM;
 	}
 
-	memcpy(&cmd->atio, atio, sizeof(*atio));
-	cmd->state = QLA_TGT_STATE_NEW;
-	cmd->tgt = vha->vha_tgt.qla_tgt;
-	cmd->vha = vha;
-
 	INIT_WORK(&cmd->work, qlt_do_work);
 	queue_work(qla_tgt_wq, &cmd->work);
 	return 0;
@@ -4911,23 +4991,13 @@ int __init qlt_init(void)
 	if (!QLA_TGT_MODE_ENABLED())
 		return 0;
 
-	qla_tgt_cmd_cachep = kmem_cache_create("qla_tgt_cmd_cachep",
-	    sizeof(struct qla_tgt_cmd), __alignof__(struct qla_tgt_cmd), 0,
-	    NULL);
-	if (!qla_tgt_cmd_cachep) {
-		ql_log(ql_log_fatal, NULL, 0xe06c,
-		    "kmem_cache_create for qla_tgt_cmd_cachep failed\n");
-		return -ENOMEM;
-	}
-
 	qla_tgt_mgmt_cmd_cachep = kmem_cache_create("qla_tgt_mgmt_cmd_cachep",
 	    sizeof(struct qla_tgt_mgmt_cmd), __alignof__(struct
 	    qla_tgt_mgmt_cmd), 0, NULL);
 	if (!qla_tgt_mgmt_cmd_cachep) {
 		ql_log(ql_log_fatal, NULL, 0xe06d,
 		    "kmem_cache_create for qla_tgt_mgmt_cmd_cachep failed\n");
-		ret = -ENOMEM;
-		goto out;
+		return -ENOMEM;
 	}
 
 	qla_tgt_mgmt_cmd_mempool = mempool_create(25, mempool_alloc_slab,
@@ -4955,8 +5025,6 @@ out_cmd_mempool:
 	mempool_destroy(qla_tgt_mgmt_cmd_mempool);
 out_mgmt_cmd_cachep:
 	kmem_cache_destroy(qla_tgt_mgmt_cmd_cachep);
-out:
-	kmem_cache_destroy(qla_tgt_cmd_cachep);
 	return ret;
 }
 
@@ -4968,5 +5036,4 @@ void qlt_exit(void)
 	destroy_workqueue(qla_tgt_wq);
 	mempool_destroy(qla_tgt_mgmt_cmd_mempool);
 	kmem_cache_destroy(qla_tgt_mgmt_cmd_cachep);
-	kmem_cache_destroy(qla_tgt_cmd_cachep);
 }
diff --git a/drivers/scsi/qla2xxx/qla_target.h b/drivers/scsi/qla2xxx/qla_target.h
index ce33d8c..63283c5 100644
--- a/drivers/scsi/qla2xxx/qla_target.h
+++ b/drivers/scsi/qla2xxx/qla_target.h
@@ -805,6 +805,12 @@ struct qla_tgt {
 	struct list_head tgt_list_entry;
 };
 
+struct qla_tgt_sess_op {
+	struct scsi_qla_host *vha;
+	struct atio_from_isp atio;
+	struct work_struct work;
+};
+
 /*
  * Equivilant to IT Nexus (Initiator-Target)
  */
diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.c b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
index 68fb66f..34db344 100644
--- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
+++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
@@ -1482,7 +1482,9 @@ static int tcm_qla2xxx_check_initiator_node_acl(
 	}
 	se_tpg = &tpg->se_tpg;
 
-	se_sess = transport_init_session(TARGET_PROT_NORMAL);
+	se_sess = transport_init_session_tags(TCM_QLA2XXX_DEFAULT_TAGS,
+					      sizeof(struct qla_tgt_cmd),
+					      TARGET_PROT_NORMAL);
 	if (IS_ERR(se_sess)) {
 		pr_err("Unable to initialize struct se_session\n");
 		return PTR_ERR(se_sess);
diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.h b/drivers/scsi/qla2xxx/tcm_qla2xxx.h
index 33aaac8..b0a3ea5 100644
--- a/drivers/scsi/qla2xxx/tcm_qla2xxx.h
+++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.h
@@ -4,6 +4,8 @@
 #define TCM_QLA2XXX_VERSION	"v0.1"
 /* length of ASCII WWPNs including pad */
 #define TCM_QLA2XXX_NAMELEN	32
+/* Number of pre-allocated per-session tags */
+#define TCM_QLA2XXX_DEFAULT_TAGS 512
 
 #include "qla_target.h"
 
-- 
1.7.10.4
