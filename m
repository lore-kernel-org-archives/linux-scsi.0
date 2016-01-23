From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH-v2 1/3] target: Fix LUN_RESET active I/O handling for ACK_KREF
Date: Sat, 23 Jan 2016 01:37:45 +0000
Message-ID: <1453513067-23169-2-git-send-email-nab@daterainc.com>
References: <1453513067-23169-1-git-send-email-nab@daterainc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ob0-f178.google.com ([209.85.214.178]:34684 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754948AbcAWBkY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 22 Jan 2016 20:40:24 -0500
Received: by mail-ob0-f178.google.com with SMTP id vt7so77200662obb.1
        for <linux-scsi@vger.kernel.org>; Fri, 22 Jan 2016 17:40:23 -0800 (PST)
In-Reply-To: <1453513067-23169-1-git-send-email-nab@daterainc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Quinn Tran <quinn.tran@qlogic.com>, Himanshu Madhani <himanshu.madhani@qlogic.com>, Sagi Grimberg <sagig@mellanox.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Andy Grover <agrover@redhat.com>, Mike Christie <mchristi@redhat.com>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch fixes a NULL pointer se_cmd->cmd_kref < 0
refcount bug during TMR LUN_RESET with active se_cmd
I/O, that can be triggered during se_cmd descriptor
shutdown + release via core_tmr_drain_state_list() code.

To address this bug, add common __target_check_io_state()
helper for ABORT_TASK + LUN_RESET w/ CMD_T_COMPLETE
checking, and set CMD_T_ABORTED + obtain ->cmd_kref for
both cases ahead of last target_put_sess_cmd() after
TFO->aborted_task() -> transport_cmd_finish_abort()
callback has completed.

It also introduces SCF_ACK_KREF to determine when
transport_cmd_finish_abort() needs to drop the second
extra reference, ahead of calling target_put_sess_cmd()
for the final kref_put(&se_cmd->cmd_kref).

It also updates transport_cmd_check_stop() to avoid
holding se_cmd->t_state_lock while dropping se_cmd
device state via target_remove_from_state_list(), now
that core_tmr_drain_state_list() is holding the
se_device lock while checking se_cmd state from
within TMR logic.

Finally, move transport_put_cmd() release of SGL +
TMR + extended CDB memory into target_free_cmd_mem()
in order to avoid potential resource leaks in TMR
ABORT_TASK + LUN_RESET code-paths.  Also update
target_release_cmd_kref() accordingly.

Cc: Quinn Tran <quinn.tran@qlogic.com>
Cc: Himanshu Madhani <himanshu.madhani@qlogic.com>
Cc: Sagi Grimberg <sagig@mellanox.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Andy Grover <agrover@redhat.com>
Cc: Mike Christie <mchristi@redhat.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_tmr.c       | 66 ++++++++++++++++++++++++----------
 drivers/target/target_core_transport.c | 56 ++++++++++++++---------------
 include/target/target_core_base.h      |  1 +
 3 files changed, 75 insertions(+), 48 deletions(-)

diff --git a/drivers/target/target_core_tmr.c b/drivers/target/target_core_tmr.c
index 7137042..5f315b4 100644
--- a/drivers/target/target_core_tmr.c
+++ b/drivers/target/target_core_tmr.c
@@ -107,6 +107,34 @@ static int target_check_cdb_and_preempt(struct list_head *list,
 	return 1;
 }
 
+static bool __target_check_io_state(struct se_cmd *se_cmd)
+{
+	struct se_session *sess = se_cmd->se_sess;
+
+	assert_spin_locked(&se_session->sess_cmd_lock);
+	WARN_ON_ONCE(!irqs_disabled());
+	/*
+	 * If command already reached CMD_T_COMPLETE state within
+	 * target_complete_cmd(), this se_cmd has been passed to
+	 * fabric driver and will not be aborted.
+	 *
+	 * Otherwise, obtain a local se_cmd->cmd_kref now for TMR
+	 * ABORT_TASK + LUN_RESET for CMD_T_ABORTED processing as
+	 * long as se_cmd->cmd_kref is still active unless zero.
+	 */
+	spin_lock(&se_cmd->t_state_lock);
+	if (se_cmd->transport_state & CMD_T_COMPLETE) {
+		pr_debug("Attempted to abort io tag: %llu already complete,"
+			" skipping\n", se_cmd->tag);
+		spin_unlock(&se_cmd->t_state_lock);
+		return false;
+	}
+	se_cmd->transport_state |= CMD_T_ABORTED;
+	spin_unlock(&se_cmd->t_state_lock);
+
+	return kref_get_unless_zero(&se_cmd->cmd_kref);
+}
+
 void core_tmr_abort_task(
 	struct se_device *dev,
 	struct se_tmr_req *tmr,
@@ -133,26 +161,18 @@ void core_tmr_abort_task(
 		printk("ABORT_TASK: Found referenced %s task_tag: %llu\n",
 			se_cmd->se_tfo->get_fabric_name(), ref_tag);
 
-		spin_lock(&se_cmd->t_state_lock);
-		if (se_cmd->transport_state & CMD_T_COMPLETE) {
-			printk("ABORT_TASK: ref_tag: %llu already complete,"
-			       " skipping\n", ref_tag);
-			spin_unlock(&se_cmd->t_state_lock);
+		if (!__target_check_io_state(se_cmd)) {
 			spin_unlock_irqrestore(&se_sess->sess_cmd_lock, flags);
 			goto out;
 		}
-		se_cmd->transport_state |= CMD_T_ABORTED;
-		spin_unlock(&se_cmd->t_state_lock);
-
 		list_del_init(&se_cmd->se_cmd_list);
-		kref_get(&se_cmd->cmd_kref);
 		spin_unlock_irqrestore(&se_sess->sess_cmd_lock, flags);
 
 		cancel_work_sync(&se_cmd->work);
 		transport_wait_for_tasks(se_cmd);
 
-		target_put_sess_cmd(se_cmd);
 		transport_cmd_finish_abort(se_cmd, true);
+		target_put_sess_cmd(se_cmd);
 
 		printk("ABORT_TASK: Sending TMR_FUNCTION_COMPLETE for"
 				" ref_tag: %llu\n", ref_tag);
@@ -237,8 +257,10 @@ static void core_tmr_drain_state_list(
 	struct list_head *preempt_and_abort_list)
 {
 	LIST_HEAD(drain_task_list);
+	struct se_session *sess;
 	struct se_cmd *cmd, *next;
 	unsigned long flags;
+	int rc;
 
 	/*
 	 * Complete outstanding commands with TASK_ABORTED SAM status.
@@ -277,6 +299,17 @@ static void core_tmr_drain_state_list(
 		if (prout_cmd == cmd)
 			continue;
 
+		sess = cmd->se_sess;
+		if (WARN_ON_ONCE(!sess))
+			continue;
+
+		spin_lock(&sess->sess_cmd_lock);
+		rc = __target_check_io_state(cmd);
+		spin_unlock(&sess->sess_cmd_lock);
+		if (!rc) {
+			printk("LUN_RESET I/O: non-zero kref_get_unless_zero\n");
+			continue;
+		}
 		list_move_tail(&cmd->state_list, &drain_task_list);
 		cmd->state_active = false;
 	}
@@ -284,7 +317,7 @@ static void core_tmr_drain_state_list(
 
 	while (!list_empty(&drain_task_list)) {
 		cmd = list_entry(drain_task_list.next, struct se_cmd, state_list);
-		list_del(&cmd->state_list);
+		list_del_init(&cmd->state_list);
 
 		pr_debug("LUN_RESET: %s cmd: %p"
 			" ITT/CmdSN: 0x%08llx/0x%08x, i_state: %d, t_state: %d"
@@ -308,16 +341,11 @@ static void core_tmr_drain_state_list(
 		 * loop above, but we do it down here given that
 		 * cancel_work_sync may block.
 		 */
-		if (cmd->t_state == TRANSPORT_COMPLETE)
-			cancel_work_sync(&cmd->work);
-
-		spin_lock_irqsave(&cmd->t_state_lock, flags);
-		target_stop_cmd(cmd, &flags);
-
-		cmd->transport_state |= CMD_T_ABORTED;
-		spin_unlock_irqrestore(&cmd->t_state_lock, flags);
+		cancel_work_sync(&cmd->work);
+		transport_wait_for_tasks(cmd);
 
 		core_tmr_handle_tas_abort(tmr_nacl, cmd, tas);
+		target_put_sess_cmd(cmd);
 	}
 }
 
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index a7c1bb5..19500e3 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -561,10 +561,6 @@ static int transport_cmd_check_stop(struct se_cmd *cmd, bool remove_from_lists,
 {
 	unsigned long flags;
 
-	spin_lock_irqsave(&cmd->t_state_lock, flags);
-	if (write_pending)
-		cmd->t_state = TRANSPORT_WRITE_PENDING;
-
 	if (remove_from_lists) {
 		target_remove_from_state_list(cmd);
 
@@ -574,6 +570,10 @@ static int transport_cmd_check_stop(struct se_cmd *cmd, bool remove_from_lists,
 		cmd->se_lun = NULL;
 	}
 
+	spin_lock_irqsave(&cmd->t_state_lock, flags);
+	if (write_pending)
+		cmd->t_state = TRANSPORT_WRITE_PENDING;
+
 	/*
 	 * Determine if frontend context caller is requesting the stopping of
 	 * this command for frontend exceptions.
@@ -627,6 +627,8 @@ static void transport_lun_remove_cmd(struct se_cmd *cmd)
 
 void transport_cmd_finish_abort(struct se_cmd *cmd, int remove)
 {
+	bool ack_kref = (cmd->se_cmd_flags & SCF_ACK_KREF);
+
 	if (cmd->se_cmd_flags & SCF_SE_LUN_CMD)
 		transport_lun_remove_cmd(cmd);
 	/*
@@ -638,7 +640,7 @@ void transport_cmd_finish_abort(struct se_cmd *cmd, int remove)
 
 	if (transport_cmd_check_stop_to_fabric(cmd))
 		return;
-	if (remove)
+	if (remove && ack_kref)
 		transport_put_cmd(cmd);
 }
 
@@ -706,7 +708,7 @@ void target_complete_cmd(struct se_cmd *cmd, u8 scsi_status)
 	 * Check for case where an explicit ABORT_TASK has been received
 	 * and transport_wait_for_tasks() will be waiting for completion..
 	 */
-	if (cmd->transport_state & CMD_T_ABORTED &&
+	if (cmd->transport_state & CMD_T_ABORTED ||
 	    cmd->transport_state & CMD_T_STOP) {
 		spin_unlock_irqrestore(&cmd->t_state_lock, flags);
 		complete_all(&cmd->t_transport_stop_comp);
@@ -2220,20 +2222,14 @@ static inline void transport_free_pages(struct se_cmd *cmd)
 }
 
 /**
- * transport_release_cmd - free a command
- * @cmd:       command to free
+ * transport_put_cmd - release a reference to a command
+ * @cmd:       command to release
  *
- * This routine unconditionally frees a command, and reference counting
- * or list removal must be done in the caller.
+ * This routine releases our reference to the command and frees it if possible.
  */
-static int transport_release_cmd(struct se_cmd *cmd)
+static int transport_put_cmd(struct se_cmd *cmd)
 {
 	BUG_ON(!cmd->se_tfo);
-
-	if (cmd->se_cmd_flags & SCF_SCSI_TMR_CDB)
-		core_tmr_release_req(cmd->se_tmr_req);
-	if (cmd->t_task_cdb != cmd->__t_task_cdb)
-		kfree(cmd->t_task_cdb);
 	/*
 	 * If this cmd has been setup with target_get_sess_cmd(), drop
 	 * the kref and call ->release_cmd() in kref callback.
@@ -2241,18 +2237,6 @@ static int transport_release_cmd(struct se_cmd *cmd)
 	return target_put_sess_cmd(cmd);
 }
 
-/**
- * transport_put_cmd - release a reference to a command
- * @cmd:       command to release
- *
- * This routine releases our reference to the command and frees it if possible.
- */
-static int transport_put_cmd(struct se_cmd *cmd)
-{
-	transport_free_pages(cmd);
-	return transport_release_cmd(cmd);
-}
-
 void *transport_kmap_data_sg(struct se_cmd *cmd)
 {
 	struct scatterlist *sg = cmd->t_data_sg;
@@ -2457,7 +2441,7 @@ int transport_generic_free_cmd(struct se_cmd *cmd, int wait_for_tasks)
 		if (wait_for_tasks && (cmd->se_cmd_flags & SCF_SCSI_TMR_CDB))
 			 transport_wait_for_tasks(cmd);
 
-		ret = transport_release_cmd(cmd);
+		ret = transport_put_cmd(cmd);
 	} else {
 		if (wait_for_tasks)
 			transport_wait_for_tasks(cmd);
@@ -2515,6 +2499,16 @@ out:
 }
 EXPORT_SYMBOL(target_get_sess_cmd);
 
+static void target_free_cmd_mem(struct se_cmd *cmd)
+{
+	transport_free_pages(cmd);
+
+	if (cmd->se_cmd_flags & SCF_SCSI_TMR_CDB)
+		core_tmr_release_req(cmd->se_tmr_req);
+	if (cmd->t_task_cdb != cmd->__t_task_cdb)
+		kfree(cmd->t_task_cdb);
+}
+
 static void target_release_cmd_kref(struct kref *kref)
 		__releases(&se_cmd->se_sess->sess_cmd_lock)
 {
@@ -2523,17 +2517,20 @@ static void target_release_cmd_kref(struct kref *kref)
 
 	if (list_empty(&se_cmd->se_cmd_list)) {
 		spin_unlock(&se_sess->sess_cmd_lock);
+		target_free_cmd_mem(se_cmd);
 		se_cmd->se_tfo->release_cmd(se_cmd);
 		return;
 	}
 	if (se_sess->sess_tearing_down && se_cmd->cmd_wait_set) {
 		spin_unlock(&se_sess->sess_cmd_lock);
+		target_free_cmd_mem(se_cmd);
 		complete(&se_cmd->cmd_wait_comp);
 		return;
 	}
 	list_del(&se_cmd->se_cmd_list);
 	spin_unlock(&se_sess->sess_cmd_lock);
 
+	target_free_cmd_mem(se_cmd);
 	se_cmd->se_tfo->release_cmd(se_cmd);
 }
 
@@ -2545,6 +2542,7 @@ int target_put_sess_cmd(struct se_cmd *se_cmd)
 	struct se_session *se_sess = se_cmd->se_sess;
 
 	if (!se_sess) {
+		target_free_cmd_mem(se_cmd);
 		se_cmd->se_tfo->release_cmd(se_cmd);
 		return 1;
 	}
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index a4bed07..1060c52 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -140,6 +140,7 @@ enum se_cmd_flags_table {
 	SCF_COMPARE_AND_WRITE		= 0x00080000,
 	SCF_COMPARE_AND_WRITE_POST	= 0x00100000,
 	SCF_PASSTHROUGH_PROT_SG_TO_MEM_NOALLOC = 0x00200000,
+	SCF_ACK_KREF			= 0x00400000,
 };
 
 /* struct se_dev_entry->lun_flags and struct se_lun->lun_access */
-- 
1.9.1

