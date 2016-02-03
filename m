From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH-v3 4/5] target: Fix remote-port TMR ABORT + se_cmd
 fabric stop
Date: Tue, 02 Feb 2016 19:13:26 -0800
Message-ID: <1454469206.25549.66.camel@haakon3.risingtidesystems.com>
References: <1454132222-29009-1-git-send-email-nab@daterainc.com>
	 <1454132222-29009-5-git-send-email-nab@daterainc.com>
	 <20160202105437.GA28143@lst.de>
	 <1454463207.25549.61.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1454463207.25549.61.camel@haakon3.risingtidesystems.com>
Sender: target-devel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Quinn Tran <quinn.tran@qlogic.com>, Himanshu Madhani <himanshu.madhani@qlogic.com>, Sagi Grimberg <sagig@mellanox.com>, Hannes Reinecke <hare@suse.de>, Andy Grover <agrover@redhat.com>, Mike Christie <mchristi@redhat.com>
List-Id: linux-scsi@vger.kernel.org

Btw, here's the updated patch:

>From 731b9981fc49d9b11e93b5c2f0a56e27862b4335 Mon Sep 17 00:00:00 2001
From: Nicholas Bellinger <nab@daterainc.com>
Date: Tue, 19 Jan 2016 15:23:02 -0800
Subject: [PATCH] target: Fix remote-port TMR ABORT + se_cmd fabric stop

To address the bug where fabric driver level shutdown
of se_cmd occurs at the same time when TMR CMD_T_ABORTED
is happening resulting in a -1 ->cmd_kref, this patch
adds a target_tmr_put_cmd() wrapper + CMD_T_FABRIC_STOP
bit that is used to determine when TMR + driver I_T
nexus shutdown is happening concurrently.

It changes target_sess_cmd_list_set_waiting() to obtain
se_cmd->cmd_kref + set CMD_T_FABRIC_STOP, and drop local
reference in target_wait_for_sess_cmds() and invoke extra
target_put_sess_cmd() during Task Aborted Status (TAS)
when necessary.

Also, it adds a new target_wait_free_cmd() wrapper around
transport_wait_for_tasks() for the special case within
transport_generic_free_cmd() to set CMD_T_FABRIC_STOP,
and is now aware of CMD_T_ABORTED + CMD_T_TAS status
bits to know when an extra transport_put_cmd() during
TAS is required.

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
 drivers/target/target_core_tmr.c       |  39 +++++++++-
 drivers/target/target_core_transport.c | 132 ++++++++++++++++++++++++---------
 include/target/target_core_base.h      |   2 +
 3 files changed, 136 insertions(+), 37 deletions(-)

diff --git a/drivers/target/target_core_tmr.c b/drivers/target/target_core_tmr.c
index 9d67d16..2ac3228 100644
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
@@ -178,7 +205,7 @@ void core_tmr_abort_task(
 		transport_wait_for_tasks(se_cmd);
 
 		transport_cmd_finish_abort(se_cmd, true);
-		target_put_sess_cmd(se_cmd);
+		target_tmr_put_cmd(se_cmd);
 
 		printk("ABORT_TASK: Sending TMR_FUNCTION_COMPLETE for"
 				" ref_tag: %llu\n", ref_tag);
@@ -252,8 +279,12 @@ static void core_tmr_drain_tmr_list(
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
@@ -271,7 +302,7 @@ static void core_tmr_drain_tmr_list(
 		transport_wait_for_tasks(cmd);
 
 		transport_cmd_finish_abort(cmd, 1);
-		target_put_sess_cmd(cmd);
+		target_tmr_put_cmd(cmd);
 	}
 }
 
@@ -370,7 +401,7 @@ static void core_tmr_drain_state_list(
 		transport_wait_for_tasks(cmd);
 
 		core_tmr_handle_tas_abort(tmr_sess, cmd, tas);
-		target_put_sess_cmd(cmd);
+		target_tmr_put_cmd(cmd);
 	}
 }
 
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 94e372a..a0c6e2e 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -2431,18 +2431,33 @@ static void transport_write_pending_qf(struct se_cmd *cmd)
 	}
 }
 
+static bool
+__transport_wait_for_tasks(struct se_cmd *, bool, bool *, bool *,
+			   unsigned long *flags);
+
+static void target_wait_free_cmd(struct se_cmd *cmd, bool *aborted, bool *tas)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&cmd->t_state_lock, flags);
+	__transport_wait_for_tasks(cmd, true, aborted, tas, &flags);
+	spin_unlock_irqrestore(&cmd->t_state_lock, flags);
+}
+
 int transport_generic_free_cmd(struct se_cmd *cmd, int wait_for_tasks)
 {
 	int ret = 0;
+	bool aborted = false, tas = false;
 
 	if (!(cmd->se_cmd_flags & SCF_SE_LUN_CMD)) {
 		if (wait_for_tasks && (cmd->se_cmd_flags & SCF_SCSI_TMR_CDB))
-			transport_wait_for_tasks(cmd);
+			target_wait_free_cmd(cmd, &aborted, &tas);
 
-		ret = transport_put_cmd(cmd);
+		if (!aborted || tas)
+			ret = transport_put_cmd(cmd);
 	} else {
 		if (wait_for_tasks)
-			transport_wait_for_tasks(cmd);
+			target_wait_free_cmd(cmd, &aborted, &tas);
 		/*
 		 * Handle WRITE failure case where transport_generic_new_cmd()
 		 * has already added se_cmd to state_list, but fabric has
@@ -2454,7 +2469,20 @@ int transport_generic_free_cmd(struct se_cmd *cmd, int wait_for_tasks)
 		if (cmd->se_lun)
 			transport_lun_remove_cmd(cmd);
 
-		ret = transport_put_cmd(cmd);
+		if (!aborted || tas)
+			ret = transport_put_cmd(cmd);
+	}
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
+		ret = 1;
 	}
 	return ret;
 }
@@ -2517,7 +2545,7 @@ static void target_release_cmd_kref(struct kref *kref)
 		se_cmd->se_tfo->release_cmd(se_cmd);
 		return;
 	}
-	if (se_sess->sess_tearing_down && se_cmd->cmd_wait_set) {
+	if (se_cmd->cmd_wait_set) {
 		spin_unlock_irqrestore(&se_sess->sess_cmd_lock, flags);
 		target_free_cmd_mem(se_cmd);
 		complete(&se_cmd->cmd_wait_comp);
@@ -2555,6 +2583,7 @@ void target_sess_cmd_list_set_waiting(struct se_session *se_sess)
 {
 	struct se_cmd *se_cmd;
 	unsigned long flags;
+	int rc;
 
 	spin_lock_irqsave(&se_sess->sess_cmd_lock, flags);
 	if (se_sess->sess_tearing_down) {
@@ -2564,8 +2593,15 @@ void target_sess_cmd_list_set_waiting(struct se_session *se_sess)
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
@@ -2578,6 +2614,7 @@ void target_wait_for_sess_cmds(struct se_session *se_sess)
 {
 	struct se_cmd *se_cmd, *tmp_cmd;
 	unsigned long flags;
+	bool tas;
 
 	list_for_each_entry_safe(se_cmd, tmp_cmd,
 				&se_sess->sess_wait_list, se_cmd_list) {
@@ -2587,6 +2624,15 @@ void target_wait_for_sess_cmds(struct se_session *se_sess)
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
@@ -2608,53 +2654,72 @@ void transport_clear_lun_ref(struct se_lun *lun)
 	wait_for_completion(&lun->lun_ref_comp);
 }
 
-/**
- * transport_wait_for_tasks - wait for completion to occur
- * @cmd:	command to wait
- *
- * Called from frontend fabric context to wait for storage engine
- * to pause and/or release frontend generated struct se_cmd.
- */
-bool transport_wait_for_tasks(struct se_cmd *cmd)
+static bool
+__transport_wait_for_tasks(struct se_cmd *cmd, bool fabric_stop,
+			   bool *aborted, bool *tas, unsigned long *flags)
+	__releases(&cmd->t_state_lock)
+	__acquires(&cmd->t_state_lock)
 {
-	unsigned long flags;
 
-	spin_lock_irqsave(&cmd->t_state_lock, flags);
+	assert_spin_locked(&cmd->t_state_lock);
+	WARN_ON_ONCE(!irqs_disabled());
+
+	if (fabric_stop)
+		cmd->transport_state |= CMD_T_FABRIC_STOP;
+
+	if (cmd->transport_state & CMD_T_ABORTED)
+		*aborted = true;
+
+	if (cmd->transport_state & CMD_T_TAS)
+		*tas = true;
+
 	if (!(cmd->se_cmd_flags & SCF_SE_LUN_CMD) &&
-	    !(cmd->se_cmd_flags & SCF_SCSI_TMR_CDB)) {
-		spin_unlock_irqrestore(&cmd->t_state_lock, flags);
+	    !(cmd->se_cmd_flags & SCF_SCSI_TMR_CDB))
 		return false;
-	}
 
 	if (!(cmd->se_cmd_flags & SCF_SUPPORTED_SAM_OPCODE) &&
-	    !(cmd->se_cmd_flags & SCF_SCSI_TMR_CDB)) {
-		spin_unlock_irqrestore(&cmd->t_state_lock, flags);
+	    !(cmd->se_cmd_flags & SCF_SCSI_TMR_CDB))
 		return false;
-	}
 
-	if (!(cmd->transport_state & CMD_T_ACTIVE)) {
-		spin_unlock_irqrestore(&cmd->t_state_lock, flags);
+	if (!(cmd->transport_state & CMD_T_ACTIVE))
 		return false;
-	}
 
 	cmd->transport_state |= CMD_T_STOP;
 
-	pr_debug("wait_for_tasks: Stopping %p ITT: 0x%08llx i_state: %d, t_state: %d, CMD_T_STOP\n",
-		cmd, cmd->tag, cmd->se_tfo->get_cmd_state(cmd), cmd->t_state);
+	pr_debug("wait_for_tasks: Stopping %p ITT: 0x%08llx i_state: %d,"
+		 " t_state: %d, CMD_T_STOP\n", cmd, cmd->tag,
+		 cmd->se_tfo->get_cmd_state(cmd), cmd->t_state);
 
-	spin_unlock_irqrestore(&cmd->t_state_lock, flags);
+	spin_unlock_irqrestore(&cmd->t_state_lock, *flags);
 
 	wait_for_completion(&cmd->t_transport_stop_comp);
 
-	spin_lock_irqsave(&cmd->t_state_lock, flags);
+	spin_lock_irqsave(&cmd->t_state_lock, *flags);
 	cmd->transport_state &= ~(CMD_T_ACTIVE | CMD_T_STOP);
 
-	pr_debug("wait_for_tasks: Stopped wait_for_completion(&cmd->t_transport_stop_comp) for ITT: 0x%08llx\n",
-		cmd->tag);
+	pr_debug("wait_for_tasks: Stopped wait_for_completion(&cmd->"
+		 "t_transport_stop_comp) for ITT: 0x%08llx\n", cmd->tag);
+
+	return true;
+}
 
+/**
+ * transport_wait_for_tasks - wait for completion to occur
+ * @cmd:	command to wait
+ *
+ * Called from frontend fabric context to wait for storage engine
+ * to pause and/or release frontend generated struct se_cmd.
+ */
+bool transport_wait_for_tasks(struct se_cmd *cmd)
+{
+	unsigned long flags;
+	bool ret, aborted = false, tas = false;
+
+	spin_lock_irqsave(&cmd->t_state_lock, flags);
+	ret = __transport_wait_for_tasks(cmd, false, &aborted, &tas, &flags);
 	spin_unlock_irqrestore(&cmd->t_state_lock, flags);
 
-	return true;
+	return ret;
 }
 EXPORT_SYMBOL(transport_wait_for_tasks);
 
@@ -2869,6 +2934,7 @@ void transport_send_task_abort(struct se_cmd *cmd)
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
