From: Himanshu Madhani <himanshu.madhani@qlogic.com>
Subject: [PATCH 19/20] qla2xxx: Add bulk send for atio & ctio completion paths.
Date: Mon, 7 Dec 2015 19:49:06 -0500
Message-ID: <1449535747-2850-20-git-send-email-himanshu.madhani@qlogic.com>
References: <1449535747-2850-1-git-send-email-himanshu.madhani@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-0016ce01.pphosted.com ([67.231.148.157]:44693 "EHLO
	mx0a-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932607AbbLHB3d (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Dec 2015 20:29:33 -0500
In-Reply-To: <1449535747-2850-1-git-send-email-himanshu.madhani@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel@vger.kernel.org, nab@linux-iscsi.org
Cc: giridhar.malavali@qlogic.com, linux-scsi@vger.kernel.org, himanshu.madhani@qlogic.com

From: Quinn Tran <quinn.tran@qlogic.com>

At high traffic, the work queue can become a bottle neck.
Instead of putting each command on the work queue as 1 work
element, the fix would daisy chain a list of commands that came
from FW/interrupt under 1 work element to reduce lock contention.

Signed-off-by: Quinn Tran <quinn.tran@qlogic.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_def.h     |    3 +
 drivers/scsi/qla2xxx/qla_isr.c     |    3 +
 drivers/scsi/qla2xxx/qla_target.c  |   65 ++++++++++++++++++++++++++-----
 drivers/scsi/qla2xxx/qla_target.h  |    2 +
 drivers/scsi/qla2xxx/tcm_qla2xxx.c |   75 +++++++++++++++++++++++++++++++++--
 5 files changed, 133 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 141a6ba..b731eef 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -2937,6 +2937,9 @@ struct qlt_hw_data {
 	uint32_t leak_exchg_thresh_hold;
 	spinlock_t sess_lock;
 	int rspq_vector_cpuid;
+
+	void *ctio_for_bulk_process;
+	void *atio_for_bulk_process;
 	spinlock_t atio_lock ____cacheline_aligned;
 };
 
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 72d1cdc..d2bbcbb 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -2646,6 +2646,9 @@ process_err:
 		WRT_REG_DWORD(&reg->rsp_q_out[0], rsp->ring_index);
 	} else
 		WRT_REG_DWORD(rsp->rsp_q_out, rsp->ring_index);
+
+	if (ha->tgt.ctio_for_bulk_process)
+		vha->hw->tgt.tgt_ops->handle_bulk(vha);
 }
 
 static void
diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index f8f2b8a..9cf812f 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -3834,12 +3834,23 @@ static void qlt_do_work(struct work_struct *work)
 	struct qla_tgt_cmd *cmd = container_of(work, struct qla_tgt_cmd, work);
 	scsi_qla_host_t *vha = cmd->vha;
 	unsigned long flags;
+	struct list_head h;
+	struct qla_tgt_cmd *c = NULL, *tc = NULL;
 
 	spin_lock_irqsave(&vha->cmd_list_lock, flags);
 	list_del(&cmd->cmd_list);
 	spin_unlock_irqrestore(&vha->cmd_list_lock, flags);
 
+	INIT_LIST_HEAD(&h);
+	if (!list_empty(&cmd->bulk_process_list))
+		list_splice_init(&cmd->bulk_process_list, &h);
+
 	__qlt_do_work(cmd);
+
+	list_for_each_entry_safe(c, tc, &h, bulk_process_list) {
+		list_del_init(&c->bulk_process_list);
+		c->work.func(&c->work);
+	}
 }
 
 static struct qla_tgt_cmd *qlt_get_tag(scsi_qla_host_t *vha,
@@ -3871,6 +3882,7 @@ static struct qla_tgt_cmd *qlt_get_tag(scsi_qla_host_t *vha,
 	cmd->jiffies_at_alloc = get_jiffies_64();
 
 	cmd->reset_count = vha->hw->chip_reset;
+	INIT_LIST_HEAD(&cmd->bulk_process_list);
 
 	return cmd;
 }
@@ -3930,6 +3942,7 @@ static void qlt_create_sess_from_atio(struct work_struct *work)
 		kfree(op);
 		return;
 	}
+
 	/*
 	 * __qlt_do_work() will call ha->tgt.tgt_ops->put_sess() to release
 	 * the extra reference taken above by qlt_make_local_sess()
@@ -3946,6 +3959,40 @@ out_term:
 
 }
 
+static void qlt_add_cmd_to_bulk_list(struct qla_tgt_cmd *cmd)
+{
+	struct qla_hw_data *ha = cmd->tgt->ha;
+	struct qla_tgt_cmd *hc = (struct qla_tgt_cmd *)
+		ha->tgt.atio_for_bulk_process;
+
+	if (IS_QLA27XX(ha) || IS_QLA83XX(ha))
+		/* We are running under atio_lock protection here. */
+		assert_spin_locked(&ha->tgt.atio_lock);
+	else
+		assert_spin_locked(&ha->hardware_lock);
+
+	if (hc)
+		list_add_tail(&cmd->bulk_process_list, &hc->bulk_process_list);
+	else
+		ha->tgt.atio_for_bulk_process = (void *)cmd;
+}
+
+static void qlt_send_atio_bulk(struct qla_hw_data *ha)
+{
+	struct qla_tgt_cmd *cmd =
+		(struct qla_tgt_cmd *)ha->tgt.atio_for_bulk_process;
+
+	if (IS_QLA27XX(ha) || IS_QLA83XX(ha))
+		/*We are running under atio_lock protection here */
+		assert_spin_locked(&ha->tgt.atio_lock);
+	else
+		assert_spin_locked(&ha->hardware_lock);
+
+	ha->tgt.atio_for_bulk_process = NULL;
+	queue_work_on(smp_processor_id(), qla_tgt_wq, &cmd->work);
+}
+
+
 /* ha->hardware_lock supposed to be held on entry */
 static int qlt_handle_cmd_for_atio(struct scsi_qla_host *vha,
 	struct atio_from_isp *atio)
@@ -4011,17 +4058,11 @@ static int qlt_handle_cmd_for_atio(struct scsi_qla_host *vha,
 	spin_unlock(&vha->cmd_list_lock);
 
 	INIT_WORK(&cmd->work, qlt_do_work);
-	if (ha->msix_count) {
+	if (ha->msix_count)
 		cmd->se_cmd.cpuid = ha->tgt.rspq_vector_cpuid;
-		if (cmd->atio.u.isp24.fcp_cmnd.rddata)
-			queue_work_on(smp_processor_id(), qla_tgt_wq,
-			    &cmd->work);
-		else
-			queue_work_on(cmd->se_cmd.cpuid, qla_tgt_wq,
-			    &cmd->work);
-	} else {
-		queue_work(qla_tgt_wq, &cmd->work);
-	}
+
+	qlt_add_cmd_to_bulk_list(cmd);
+
 	return 0;
 
 }
@@ -5256,6 +5297,7 @@ qlt_alloc_qfull_cmd(struct scsi_qla_host *vha,
 
 	qlt_incr_num_pend_cmds(vha);
 	INIT_LIST_HEAD(&cmd->cmd_list);
+	INIT_LIST_HEAD(&cmd->bulk_process_list);
 	memcpy(&cmd->atio, atio, sizeof(*atio));
 
 	cmd->tgt = vha->vha_tgt.qla_tgt;
@@ -6461,6 +6503,9 @@ qlt_24xx_process_atio_queue(struct scsi_qla_host *vha, uint8_t ha_locked)
 	/* Adjust ring index */
 	WRT_REG_DWORD(ISP_ATIO_Q_OUT(vha), ha->tgt.atio_ring_index);
 	RD_REG_DWORD_RELAXED(ISP_ATIO_Q_OUT(vha));
+
+	if (ha->tgt.atio_for_bulk_process)
+		qlt_send_atio_bulk(ha);
 }
 
 void
diff --git a/drivers/scsi/qla2xxx/qla_target.h b/drivers/scsi/qla2xxx/qla_target.h
index 22a6a76..66c3ede 100644
--- a/drivers/scsi/qla2xxx/qla_target.h
+++ b/drivers/scsi/qla2xxx/qla_target.h
@@ -740,6 +740,7 @@ struct qla_tgt_func_tmpl {
 	void (*clear_nacl_from_fcport_map)(struct qla_tgt_sess *);
 	void (*put_sess)(struct qla_tgt_sess *);
 	void (*shutdown_sess)(struct qla_tgt_sess *);
+	void (*handle_bulk)(struct scsi_qla_host *);
 };
 
 int qla2x00_wait_for_hba_online(struct scsi_qla_host *);
@@ -1007,6 +1008,7 @@ struct qla_tgt_cmd {
 	struct qla_tgt *tgt;	/* to save extra sess dereferences */
 	struct scsi_qla_host *vha;
 	struct list_head cmd_list;
+	struct list_head bulk_process_list;
 
 	struct atio_from_isp atio;
 	/* t10dif */
diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.c b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
index d7a34d1..2594341 100644
--- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
+++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
@@ -279,6 +279,12 @@ static void tcm_qla2xxx_free_mcmd(struct qla_tgt_mgmt_cmd *mcmd)
 static void tcm_qla2xxx_complete_free(struct work_struct *work)
 {
 	struct qla_tgt_cmd *cmd = container_of(work, struct qla_tgt_cmd, work);
+	struct list_head h;
+	struct qla_tgt_cmd *c = NULL, *tc = NULL;
+
+	INIT_LIST_HEAD(&h);
+	if (!list_empty(&cmd->bulk_process_list))
+		list_splice_init(&cmd->bulk_process_list, &h);
 
 	cmd->cmd_in_wq = 0;
 
@@ -287,6 +293,45 @@ static void tcm_qla2xxx_complete_free(struct work_struct *work)
 	cmd->vha->tgt_counters.qla_core_ret_sta_ctio++;
 	cmd->cmd_flags |= BIT_16;
 	transport_generic_free_cmd(&cmd->se_cmd, 0);
+
+	list_for_each_entry_safe(c, tc, &h, bulk_process_list) {
+		list_del_init(&c->bulk_process_list);
+		c->work.func(&c->work);
+	}
+}
+
+static void tcm_qla2xxx_add_cmd_to_bulk_list(struct qla_tgt_cmd *cmd)
+{
+	struct qla_hw_data *ha = cmd->tgt->ha;
+	struct qla_tgt_cmd *hc;
+	unsigned long flags;
+
+	/* borrowing q_full_lock.  it's not being used very often. */
+	spin_lock_irqsave(&ha->tgt.q_full_lock, flags);
+	hc = (struct qla_tgt_cmd *)ha->tgt.ctio_for_bulk_process;
+
+	if (hc)
+		list_add_tail(&cmd->bulk_process_list, &hc->bulk_process_list);
+	else
+		ha->tgt.ctio_for_bulk_process = (void *)cmd;
+	spin_unlock_irqrestore(&ha->tgt.q_full_lock, flags);
+}
+
+static void tcm_qla2xxx_handle_bulk(struct scsi_qla_host *vha)
+{
+	struct qla_hw_data *ha = vha->hw;
+	struct qla_tgt_cmd *cmd;
+	unsigned long flags;
+
+	/* borrowing q_full_lock.  it's not being used very often. */
+	spin_lock_irqsave(&ha->tgt.q_full_lock, flags);
+	cmd = (struct qla_tgt_cmd *)ha->tgt.ctio_for_bulk_process;
+	ha->tgt.ctio_for_bulk_process = NULL;
+	spin_unlock_irqrestore(&ha->tgt.q_full_lock, flags);
+
+	if (cmd)
+		queue_work_on(smp_processor_id(), tcm_qla2xxx_free_wq,
+		    &cmd->work);
 }
 
 /*
@@ -485,6 +530,13 @@ static void tcm_qla2xxx_handle_data_work(struct work_struct *work)
 {
 	struct qla_tgt_cmd *cmd = container_of(work, struct qla_tgt_cmd, work);
 	unsigned long flags;
+	struct list_head h;
+	struct qla_tgt_cmd *c = NULL, *tc = NULL;
+	struct scsi_qla_host *vha = cmd->vha;
+
+	INIT_LIST_HEAD(&h);
+	if (!list_empty(&cmd->bulk_process_list))
+		list_splice_init(&cmd->bulk_process_list, &h);
 
 	/*
 	 * Ensure that the complete FCP WRITE payload has been received.
@@ -499,7 +551,8 @@ static void tcm_qla2xxx_handle_data_work(struct work_struct *work)
 		spin_unlock_irqrestore(&cmd->cmd_lock, flags);
 
 		tcm_qla2xxx_free_cmd(cmd);
-		return;
+		tcm_qla2xxx_handle_bulk(vha);
+		goto process_bulk;
 	}
 	spin_unlock_irqrestore(&cmd->cmd_lock, flags);
 
@@ -511,7 +564,7 @@ static void tcm_qla2xxx_handle_data_work(struct work_struct *work)
 		 */
 		if (cmd->se_cmd.transport_state & CMD_T_ABORTED) {
 			complete(&cmd->se_cmd.t_transport_stop_comp);
-			return;
+			goto process_bulk;
 		}
 
 		if (cmd->se_cmd.pi_err)
@@ -521,10 +574,18 @@ static void tcm_qla2xxx_handle_data_work(struct work_struct *work)
 			transport_generic_request_failure(&cmd->se_cmd,
 				TCM_CHECK_CONDITION_ABORT_CMD);
 
-		return;
+		goto process_bulk;
 	}
 
-	return target_execute_cmd(&cmd->se_cmd);
+	target_execute_cmd(&cmd->se_cmd);
+
+process_bulk:
+	list_for_each_entry_safe(c, tc, &h, bulk_process_list) {
+		list_del_init(&c->bulk_process_list);
+		c->work.func(&c->work);
+	}
+
+	return;
 }
 
 /*
@@ -535,7 +596,7 @@ static void tcm_qla2xxx_handle_data(struct qla_tgt_cmd *cmd)
 	cmd->cmd_flags |= BIT_10;
 	cmd->cmd_in_wq = 1;
 	INIT_WORK(&cmd->work, tcm_qla2xxx_handle_data_work);
-	queue_work_on(smp_processor_id(), tcm_qla2xxx_free_wq, &cmd->work);
+	tcm_qla2xxx_add_cmd_to_bulk_list(cmd);
 }
 
 static void tcm_qla2xxx_handle_dif_work(struct work_struct *work)
@@ -611,6 +672,7 @@ static int tcm_qla2xxx_queue_data_in(struct se_cmd *se_cmd)
 				se_cmd->scsi_status);
 }
 
+
 static int tcm_qla2xxx_queue_status(struct se_cmd *se_cmd)
 {
 	struct qla_tgt_cmd *cmd = container_of(se_cmd,
@@ -711,6 +773,7 @@ static void tcm_qla2xxx_aborted_task(struct se_cmd *se_cmd)
 	struct qla_tgt_cmd *cmd = container_of(se_cmd,
 				struct qla_tgt_cmd, se_cmd);
 	unsigned long flags;
+	struct scsi_qla_host *vha = cmd->vha;
 
 	if (qlt_abort_cmd(cmd))
 		return;
@@ -725,6 +788,7 @@ static void tcm_qla2xxx_aborted_task(struct se_cmd *se_cmd)
 		/* Cmd have not reached firmware.
 		 * Use this trigger to free it. */
 		tcm_qla2xxx_free_cmd(cmd);
+		tcm_qla2xxx_handle_bulk(vha);
 		return;
 	}
 	spin_unlock_irqrestore(&cmd->cmd_lock, flags);
@@ -1598,6 +1662,7 @@ static struct qla_tgt_func_tmpl tcm_qla2xxx_template = {
 	.clear_nacl_from_fcport_map = tcm_qla2xxx_clear_nacl_from_fcport_map,
 	.put_sess		= tcm_qla2xxx_put_sess,
 	.shutdown_sess		= tcm_qla2xxx_shutdown_sess,
+	.handle_bulk	= tcm_qla2xxx_handle_bulk,
 };
 
 static int tcm_qla2xxx_init_lport(struct tcm_qla2xxx_lport *lport)
-- 
1.7.7

