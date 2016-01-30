From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH-v3 4/5] target: Fix remote-port TMR ABORT + se_cmd fabric stop
Date: Sat, 30 Jan 2016 05:37:01 +0000
Message-ID: <1454132222-29009-5-git-send-email-nab@daterainc.com>
References: <1454132222-29009-1-git-send-email-nab@daterainc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ob0-f175.google.com ([209.85.214.175]:33058 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752215AbcA3FkI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 30 Jan 2016 00:40:08 -0500
Received: by mail-ob0-f175.google.com with SMTP id is5so80504044obc.0
        for <linux-scsi@vger.kernel.org>; Fri, 29 Jan 2016 21:40:07 -0800 (PST)
In-Reply-To: <1454132222-29009-1-git-send-email-nab@daterainc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Quinn Tran <quinn.tran@qlogic.com>, Himanshu Madhani <himanshu.madhani@qlogic.com>, Sagi Grimberg <sagig@mellanox.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Andy Grover <agrover@redhat.com>, Mike Christie <mchristi@redhat.com>, Nicholas Bellinger <nab@daterainc.com>

From: Nicholas Bellinger <nab@daterainc.com>

To address a bug where se_cmd fabric driver level shutdown
occurs while TMR CMD_T_ABORTED is happening, resulting in
potential -1 ->cmd_kref, this patch adds target_tmr_put_cmd()
wrapper and CMD_T_FABRIC_STOP bit used to determine when
TMR + front-end driver I_T nexus shutdown is occuring.

It changes target_sess_cmd_list_set_waiting() to obtain
se_cmd->cmd_kref + set CMD_T_FABRIC_STOP, and drop local
reference in target_wait_for_sess_cmds() + invoke extra
target_put_sess_cmd() during Task Aborted Status (TAS)
when necessary.

Also, allow transport_wait_for_tasks() callers to set
CMD_T_FABRIC_STOP, and aware of CMD_T_ABORTED + CMD_T_TAS
status bits.

Note transport_generic_free_cmd() is expected to block on
cmd->cmd_wait_comp in order to follow what iscsi-target
expects during iscsi_conn context se_cmd shutdown.

Cc: Quinn Tran <quinn.tran@qlogic.com>
Cc: Himanshu Madhani <himanshu.madhani@qlogic.com>
Cc: Sagi Grimberg <sagig@mellanox.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Andy Grover <agrover@redhat.com>
Cc: Mike Christie <mchristi@redhat.com>
Cc: stable@vger.kernel.org # 3.10+
Signed-off-by: Nicholas Bellinger <nab@daterainc.com>
---
 drivers/target/iscsi/iscsi_target_erl2.c |  3 +-
 drivers/target/target_core_tmr.c         | 49 +++++++++++++++++++----
 drivers/target/target_core_transport.c   | 69 +++++++++++++++++++++++++++-----
 include/target/target_core_base.h        |  2 +
 include/target/target_core_fabric.h      |  2 +-
 5 files changed, 106 insertions(+), 19 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target_erl2.c b/drivers/target/iscsi/iscsi_target_erl2.c
index e24f1c7..1e79acd 100644
--- a/drivers/target/iscsi/iscsi_target_erl2.c
+++ b/drivers/target/iscsi/iscsi_target_erl2.c
@@ -316,6 +316,7 @@ int iscsit_prepare_cmds_for_realligance(struct iscsi_conn *conn)
 	u32 cmd_count = 0;
 	struct iscsi_cmd *cmd, *cmd_tmp;
 	struct iscsi_conn_recovery *cr;
+	bool aborted = false, tas = false;
 
 	/*
 	 * Allocate an struct iscsi_conn_recovery for this connection.
@@ -398,7 +399,7 @@ int iscsit_prepare_cmds_for_realligance(struct iscsi_conn *conn)
 
 		iscsit_free_all_datain_reqs(cmd);
 
-		transport_wait_for_tasks(&cmd->se_cmd);
+		transport_wait_for_tasks(&cmd->se_cmd, false, &aborted, &tas);
 		/*
 		 * Add the struct iscsi_cmd to the connection recovery cmd list
 		 */
diff --git a/drivers/target/target_core_tmr.c b/drivers/target/target_core_tmr.c
index 9d67d16..3f86f22 100644
--- a/drivers/target/target_core_tmr.c
+++ b/drivers/target/target_core_tmr.c
@@ -110,6 +110,7 @@ static int target_check_cdb_and_preempt(struct list_head *list,
 static bool __target_check_io_state(struct se_cmd *se_cmd)
 {
 	struct se_session *sess = se_cmd->se_sess;
+	bool ret;
 
 	assert_spin_locked(&sess->sess_cmd_lock);
 	WARN_ON_ONCE(!irqs_disabled());
@@ -129,10 +130,36 @@ static bool __target_check_io_state(struct se_cmd *se_cmd)
 		spin_unlock(&se_cmd->t_state_lock);
 		return false;
 	}
+	if (sess->sess_tearing_down || se_cmd->cmd_wait_set) {
+		pr_debug("Attempted to abort io tag: %llu already shutdown,"
+			" skipping\n", se_cmd->tag);
+		spin_unlock(&se_cmd->t_state_lock);
+		return false;
+	}
 	se_cmd->transport_state |= CMD_T_ABORTED;
 	spin_unlock(&se_cmd->t_state_lock);
 
-	return kref_get_unless_zero(&se_cmd->cmd_kref);
+	ret = kref_get_unless_zero(&se_cmd->cmd_kref);
+	if (ret)
+		se_cmd->cmd_wait_set = 1;
+	return ret;
+}
+
+static void target_tmr_put_cmd(struct se_cmd *se_cmd)
+{
+	unsigned long flags;
+	bool fabric_stop;
+
+	spin_lock_irqsave(&se_cmd->t_state_lock, flags);
+	fabric_stop = (se_cmd->transport_state & CMD_T_FABRIC_STOP);
+	spin_unlock_irqrestore(&se_cmd->t_state_lock, flags);
+
+	target_put_sess_cmd(se_cmd);
+
+	if (!fabric_stop) {
+		wait_for_completion(&se_cmd->cmd_wait_comp);
+		se_cmd->se_tfo->release_cmd(se_cmd);
+	}
 }
 
 void core_tmr_abort_task(
@@ -143,6 +170,7 @@ void core_tmr_abort_task(
 	struct se_cmd *se_cmd;
 	unsigned long flags;
 	u64 ref_tag;
+	bool aborted = false, tas = false;
 
 	spin_lock_irqsave(&se_sess->sess_cmd_lock, flags);
 	list_for_each_entry(se_cmd, &se_sess->sess_cmd_list, se_cmd_list) {
@@ -175,10 +203,10 @@ void core_tmr_abort_task(
 		spin_unlock_irqrestore(&se_sess->sess_cmd_lock, flags);
 
 		cancel_work_sync(&se_cmd->work);
-		transport_wait_for_tasks(se_cmd);
+		transport_wait_for_tasks(se_cmd, false, &aborted, &tas);
 
 		transport_cmd_finish_abort(se_cmd, true);
-		target_put_sess_cmd(se_cmd);
+		target_tmr_put_cmd(se_cmd);
 
 		printk("ABORT_TASK: Sending TMR_FUNCTION_COMPLETE for"
 				" ref_tag: %llu\n", ref_tag);
@@ -203,7 +231,7 @@ static void core_tmr_drain_tmr_list(
 	struct se_tmr_req *tmr_p, *tmr_pp;
 	struct se_cmd *cmd;
 	unsigned long flags;
-	bool rc;
+	bool rc, aborted = false, tas = false;
 	/*
 	 * Release all pending and outgoing TMRs aside from the received
 	 * LUN_RESET tmr..
@@ -252,8 +280,12 @@ static void core_tmr_drain_tmr_list(
 		spin_unlock(&sess->sess_cmd_lock);
 		if (!rc) {
 			printk("LUN_RESET TMR: non-zero kref_get_unless_zero\n");
+			spin_unlock(&sess->sess_cmd_lock);
 			continue;
 		}
+		cmd->cmd_wait_set = true;
+		spin_unlock(&sess->sess_cmd_lock);
+
 		list_move_tail(&tmr_p->tmr_list, &drain_tmr_list);
 	}
 	spin_unlock_irqrestore(&dev->se_tmr_lock, flags);
@@ -268,10 +300,10 @@ static void core_tmr_drain_tmr_list(
 			tmr_p->function, tmr_p->response, cmd->t_state);
 
 		cancel_work_sync(&cmd->work);
-		transport_wait_for_tasks(cmd);
+		transport_wait_for_tasks(cmd, false, &aborted, &tas);
 
 		transport_cmd_finish_abort(cmd, 1);
-		target_put_sess_cmd(cmd);
+		target_tmr_put_cmd(cmd);
 	}
 }
 
@@ -287,6 +319,7 @@ static void core_tmr_drain_state_list(
 	struct se_cmd *cmd, *next;
 	unsigned long flags;
 	int rc;
+	bool aborted = false, tas_set = false;
 
 	/*
 	 * Complete outstanding commands with TASK_ABORTED SAM status.
@@ -367,10 +400,10 @@ static void core_tmr_drain_state_list(
 		 * cancel_work_sync may block.
 		 */
 		cancel_work_sync(&cmd->work);
-		transport_wait_for_tasks(cmd);
+		transport_wait_for_tasks(cmd, false, &aborted, &tas_set);
 
 		core_tmr_handle_tas_abort(tmr_sess, cmd, tas);
-		target_put_sess_cmd(cmd);
+		target_tmr_put_cmd(cmd);
 	}
 }
 
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 94e372a..36a70e0 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -2434,15 +2434,17 @@ static void transport_write_pending_qf(struct se_cmd *cmd)
 int transport_generic_free_cmd(struct se_cmd *cmd, int wait_for_tasks)
 {
 	int ret = 0;
+	bool aborted = false, tas = false;
 
 	if (!(cmd->se_cmd_flags & SCF_SE_LUN_CMD)) {
 		if (wait_for_tasks && (cmd->se_cmd_flags & SCF_SCSI_TMR_CDB))
-			transport_wait_for_tasks(cmd);
+			transport_wait_for_tasks(cmd, true, &aborted, &tas);
 
-		ret = transport_put_cmd(cmd);
+		if (!aborted || tas)
+			ret = transport_put_cmd(cmd);
 	} else {
 		if (wait_for_tasks)
-			transport_wait_for_tasks(cmd);
+			transport_wait_for_tasks(cmd, true, &aborted, &tas);
 		/*
 		 * Handle WRITE failure case where transport_generic_new_cmd()
 		 * has already added se_cmd to state_list, but fabric has
@@ -2454,9 +2456,21 @@ int transport_generic_free_cmd(struct se_cmd *cmd, int wait_for_tasks)
 		if (cmd->se_lun)
 			transport_lun_remove_cmd(cmd);
 
-		ret = transport_put_cmd(cmd);
+		if (!aborted || tas)
+			ret = transport_put_cmd(cmd);
 	}
-	return ret;
+	/*
+	 * If the task has been internally aborted due to TMR ABORT_TASK
+	 * or LUN_RESET, target_core_tmr.c is responsible for performing
+	 * the remaining calls to target_put_sess_cmd(), and not the
+	 * callers of this function.
+	 */
+	if (aborted) {
+		pr_debug("Detected CMD_T_ABORTED for ITT: %llu\n", cmd->tag);
+		wait_for_completion(&cmd->cmd_wait_comp);
+		cmd->se_tfo->release_cmd(cmd);
+	}
+	return (aborted) ? 1 : ret;
 }
 EXPORT_SYMBOL(transport_generic_free_cmd);
 
@@ -2517,7 +2531,7 @@ static void target_release_cmd_kref(struct kref *kref)
 		se_cmd->se_tfo->release_cmd(se_cmd);
 		return;
 	}
-	if (se_sess->sess_tearing_down && se_cmd->cmd_wait_set) {
+	if (se_cmd->cmd_wait_set) {
 		spin_unlock_irqrestore(&se_sess->sess_cmd_lock, flags);
 		target_free_cmd_mem(se_cmd);
 		complete(&se_cmd->cmd_wait_comp);
@@ -2555,6 +2569,7 @@ void target_sess_cmd_list_set_waiting(struct se_session *se_sess)
 {
 	struct se_cmd *se_cmd;
 	unsigned long flags;
+	int rc;
 
 	spin_lock_irqsave(&se_sess->sess_cmd_lock, flags);
 	if (se_sess->sess_tearing_down) {
@@ -2564,8 +2579,15 @@ void target_sess_cmd_list_set_waiting(struct se_session *se_sess)
 	se_sess->sess_tearing_down = 1;
 	list_splice_init(&se_sess->sess_cmd_list, &se_sess->sess_wait_list);
 
-	list_for_each_entry(se_cmd, &se_sess->sess_wait_list, se_cmd_list)
-		se_cmd->cmd_wait_set = 1;
+	list_for_each_entry(se_cmd, &se_sess->sess_wait_list, se_cmd_list) {
+		rc = kref_get_unless_zero(&se_cmd->cmd_kref);
+		if (rc) {
+			se_cmd->cmd_wait_set = 1;
+			spin_lock(&se_cmd->t_state_lock);
+			se_cmd->transport_state |= CMD_T_FABRIC_STOP;
+			spin_unlock(&se_cmd->t_state_lock);
+		}
+	}
 
 	spin_unlock_irqrestore(&se_sess->sess_cmd_lock, flags);
 }
@@ -2578,6 +2600,7 @@ void target_wait_for_sess_cmds(struct se_session *se_sess)
 {
 	struct se_cmd *se_cmd, *tmp_cmd;
 	unsigned long flags;
+	bool tas;
 
 	list_for_each_entry_safe(se_cmd, tmp_cmd,
 				&se_sess->sess_wait_list, se_cmd_list) {
@@ -2587,6 +2610,15 @@ void target_wait_for_sess_cmds(struct se_session *se_sess)
 			" %d\n", se_cmd, se_cmd->t_state,
 			se_cmd->se_tfo->get_cmd_state(se_cmd));
 
+		spin_lock_irqsave(&se_cmd->t_state_lock, flags);
+		tas = (se_cmd->transport_state & CMD_T_TAS);
+		spin_unlock_irqrestore(&se_cmd->t_state_lock, flags);
+
+		if (!target_put_sess_cmd(se_cmd)) {
+			if (tas)
+				target_put_sess_cmd(se_cmd);
+		}
+
 		wait_for_completion(&se_cmd->cmd_wait_comp);
 		pr_debug("After cmd_wait_comp: se_cmd: %p t_state: %d"
 			" fabric state: %d\n", se_cmd, se_cmd->t_state,
@@ -2611,15 +2643,33 @@ void transport_clear_lun_ref(struct se_lun *lun)
 /**
  * transport_wait_for_tasks - wait for completion to occur
  * @cmd:	command to wait
+ * @fabric_stop: set if command is being stopped + shutdown from
+ * 		 fabric driver
+ * @aborted:	set if command has been internally aborted
+ * @tas:	set if command is has task aborted status
  *
  * Called from frontend fabric context to wait for storage engine
  * to pause and/or release frontend generated struct se_cmd.
  */
-bool transport_wait_for_tasks(struct se_cmd *cmd)
+bool transport_wait_for_tasks(struct se_cmd *cmd, bool fabric_stop,
+			      bool *aborted, bool *tas)
 {
 	unsigned long flags;
 
 	spin_lock_irqsave(&cmd->t_state_lock, flags);
+	if (fabric_stop)
+		cmd->transport_state |= CMD_T_FABRIC_STOP;
+
+	if (cmd->transport_state & CMD_T_ABORTED)
+		*aborted = true;
+	else
+		*aborted = false;
+
+	if (cmd->transport_state & CMD_T_TAS)
+		*tas = true;
+	else
+		*tas = false;
+
 	if (!(cmd->se_cmd_flags & SCF_SE_LUN_CMD) &&
 	    !(cmd->se_cmd_flags & SCF_SCSI_TMR_CDB)) {
 		spin_unlock_irqrestore(&cmd->t_state_lock, flags);
@@ -2869,6 +2919,7 @@ void transport_send_task_abort(struct se_cmd *cmd)
 		spin_unlock_irqrestore(&cmd->t_state_lock, flags);
 		return;
 	}
+	cmd->transport_state |= CMD_T_TAS;
 	spin_unlock_irqrestore(&cmd->t_state_lock, flags);
 
 	/*
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index 1a76726..1579539e 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -493,6 +493,8 @@ struct se_cmd {
 #define CMD_T_DEV_ACTIVE	(1 << 7)
 #define CMD_T_REQUEST_STOP	(1 << 8)
 #define CMD_T_BUSY		(1 << 9)
+#define CMD_T_TAS		(1 << 10)
+#define CMD_T_FABRIC_STOP	(1 << 11)
 	spinlock_t		t_state_lock;
 	struct kref		cmd_kref;
 	struct completion	t_transport_stop_comp;
diff --git a/include/target/target_core_fabric.h b/include/target/target_core_fabric.h
index 5665340..240ea10 100644
--- a/include/target/target_core_fabric.h
+++ b/include/target/target_core_fabric.h
@@ -148,7 +148,7 @@ void	target_execute_cmd(struct se_cmd *cmd);
 
 int	transport_generic_free_cmd(struct se_cmd *, int);
 
-bool	transport_wait_for_tasks(struct se_cmd *);
+bool	transport_wait_for_tasks(struct se_cmd *, bool, bool *, bool *);
 int	transport_check_aborted_status(struct se_cmd *, int);
 int	transport_send_check_condition_and_sense(struct se_cmd *,
 		sense_reason_t, int);
-- 
1.9.1

