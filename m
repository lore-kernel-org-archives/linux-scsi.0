From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 036/103] target: Replace embedded struct se_queue_req with a list_head
Date: Thu, 21 Jul 2011 00:07:48 -0700
Message-ID: <1311232135-6653-37-git-send-email-nab@linux-iscsi.org>
References: <1311232135-6653-32-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nm20.access.bullet.mail.sp2.yahoo.com ([98.139.44.147]:30345
	"HELO nm20.access.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752310Ab1GUHJ3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 21 Jul 2011 03:09:29 -0400
In-Reply-To: <1311232135-6653-32-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Andy Grover <agrover@redhat.com>

From: Andy Grover <agrover@redhat.com>

We don't actually need the additional members of the se_queue_req struct.
cmd can be found by container_of, and t_state is identical to cmd->t_state.

Also, rename transport_get_qr_from_queue to transport_get_cmd_from_queue,
and modify callers accordingly.

(Roland: Fix se_queue_req removal leftovers OOPs)

Signed-off-by: Andy Grover <agrover@redhat.com>
Signed-off-by: Roland Dreier <roland@purestorage.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_tmr.c       |   27 ++---------
 drivers/target/target_core_transport.c |   76 ++++++++++++--------------------
 include/target/target_core_base.h      |    2 +-
 3 files changed, 35 insertions(+), 70 deletions(-)

diff --git a/drivers/target/target_core_tmr.c b/drivers/target/target_core_tmr.c
index 50f49f2..e1f99f7 100644
--- a/drivers/target/target_core_tmr.c
+++ b/drivers/target/target_core_tmr.c
@@ -113,15 +113,14 @@ int core_tmr_lun_reset(
 	struct list_head *preempt_and_abort_list,
 	struct se_cmd *prout_cmd)
 {
-	struct se_cmd *cmd;
-	struct se_queue_req *qr, *qr_tmp;
+	struct se_cmd *cmd, *tcmd;
 	struct se_node_acl *tmr_nacl = NULL;
 	struct se_portal_group *tmr_tpg = NULL;
 	struct se_queue_obj *qobj = &dev->dev_queue_obj;
 	struct se_tmr_req *tmr_p, *tmr_pp;
 	struct se_task *task, *task_tmp;
 	unsigned long flags;
-	int fe_count, state, tas;
+	int fe_count, tas;
 	/*
 	 * TASK_ABORTED status bit, this is configurable via ConfigFS
 	 * struct se_device attributes.  spc4r17 section 7.4.6 Control mode page
@@ -331,20 +330,7 @@ int core_tmr_lun_reset(
 	 * reference, otherwise the struct se_cmd is released.
 	 */
 	spin_lock_irqsave(&qobj->cmd_queue_lock, flags);
-	list_for_each_entry_safe(qr, qr_tmp, &qobj->qobj_list, qr_list) {
-		cmd = (struct se_cmd *)qr->cmd;
-		if (!(cmd)) {
-			/*
-			 * Skip these for non PREEMPT_AND_ABORT usage..
-			 */
-			if (preempt_and_abort_list != NULL)
-				continue;
-
-			atomic_dec(&qobj->queue_cnt);
-			list_del(&qr->qr_list);
-			kfree(qr);
-			continue;
-		}
+	list_for_each_entry_safe(cmd, tcmd, &qobj->qobj_list, se_queue_node) {
 		/*
 		 * For PREEMPT_AND_ABORT usage, only process commands
 		 * with a matching reservation key.
@@ -361,15 +347,12 @@ int core_tmr_lun_reset(
 
 		atomic_dec(&cmd->t_task.t_transport_queue_active);
 		atomic_dec(&qobj->queue_cnt);
-		list_del(&qr->qr_list);
+		list_del(&cmd->se_queue_node);
 		spin_unlock_irqrestore(&qobj->cmd_queue_lock, flags);
 
-		state = qr->state;
-		kfree(qr);
-
 		DEBUG_LR("LUN_RESET: %s from Device Queue: cmd: %p t_state:"
 			" %d t_fe_count: %d\n", (preempt_and_abort_list) ?
-			"Preempt" : "", cmd, state,
+			"Preempt" : "", cmd, cmd->t_state,
 			atomic_read(&cmd->t_task.t_fe_count));
 		/*
 		 * Signal that the command has failed via cmd->se_cmd_flags,
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 969cbe2..9b76d33 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -761,10 +761,7 @@ static void transport_add_cmd_to_queue(
 	struct se_queue_obj *qobj = &dev->dev_queue_obj;
 	unsigned long flags;
 
-	INIT_LIST_HEAD(&cmd->se_qr.qr_list);
-
-	cmd->se_qr.cmd = cmd;
-	cmd->se_qr.state = t_state;
+	INIT_LIST_HEAD(&cmd->se_queue_node);
 
 	if (t_state) {
 		spin_lock_irqsave(&cmd->t_task.t_state_lock, flags);
@@ -774,7 +771,7 @@ static void transport_add_cmd_to_queue(
 	}
 
 	spin_lock_irqsave(&qobj->cmd_queue_lock, flags);
-	list_add_tail(&cmd->se_qr.qr_list, &qobj->qobj_list);
+	list_add_tail(&cmd->se_queue_node, &qobj->qobj_list);
 	atomic_inc(&cmd->t_task.t_transport_queue_active);
 	spin_unlock_irqrestore(&qobj->cmd_queue_lock, flags);
 
@@ -782,10 +779,10 @@ static void transport_add_cmd_to_queue(
 	wake_up_interruptible(&qobj->thread_wq);
 }
 
-static struct se_queue_req *
-transport_get_qr_from_queue(struct se_queue_obj *qobj)
+static struct se_cmd *
+transport_get_cmd_from_queue(struct se_queue_obj *qobj)
 {
-	struct se_queue_req *qr;
+	struct se_cmd *cmd;
 	unsigned long flags;
 
 	spin_lock_irqsave(&qobj->cmd_queue_lock, flags);
@@ -793,24 +790,21 @@ transport_get_qr_from_queue(struct se_queue_obj *qobj)
 		spin_unlock_irqrestore(&qobj->cmd_queue_lock, flags);
 		return NULL;
 	}
+	cmd = list_first_entry(&qobj->qobj_list, struct se_cmd, se_queue_node);
 
-	list_for_each_entry(qr, &qobj->qobj_list, qr_list)
-		break;
-
-	if (qr->cmd)
-		atomic_dec(&qr->cmd->t_task.t_transport_queue_active);
+	atomic_dec(&cmd->t_task.t_transport_queue_active);
 
-	list_del(&qr->qr_list);
+	list_del(&cmd->se_queue_node);
 	atomic_dec(&qobj->queue_cnt);
 	spin_unlock_irqrestore(&qobj->cmd_queue_lock, flags);
 
-	return qr;
+	return cmd;
 }
 
 static void transport_remove_cmd_from_queue(struct se_cmd *cmd,
 		struct se_queue_obj *qobj)
 {
-	struct se_queue_req *qr = NULL, *qr_p = NULL;
+	struct se_cmd *t;
 	unsigned long flags;
 
 	spin_lock_irqsave(&qobj->cmd_queue_lock, flags);
@@ -819,14 +813,13 @@ static void transport_remove_cmd_from_queue(struct se_cmd *cmd,
 		return;
 	}
 
-	list_for_each_entry_safe(qr, qr_p, &qobj->qobj_list, qr_list) {
-		if (qr->cmd != cmd)
-			continue;
-
-		atomic_dec(&qr->cmd->t_task.t_transport_queue_active);
-		atomic_dec(&qobj->queue_cnt);
-		list_del(&qr->qr_list);
-	}
+	list_for_each_entry(t, &qobj->qobj_list, se_queue_node)
+		if (t == cmd) {
+			atomic_dec(&cmd->t_task.t_transport_queue_active);
+			atomic_dec(&qobj->queue_cnt);
+			list_del(&cmd->se_queue_node);
+			break;
+		}
 	spin_unlock_irqrestore(&qobj->cmd_queue_lock, flags);
 
 	if (atomic_read(&cmd->t_task.t_transport_queue_active)) {
@@ -1169,18 +1162,15 @@ void transport_dump_dev_state(
  */
 static void transport_release_all_cmds(struct se_device *dev)
 {
-	struct se_cmd *cmd = NULL;
-	struct se_queue_req *qr = NULL, *qr_p = NULL;
+	struct se_cmd *cmd, *tcmd;
 	int bug_out = 0, t_state;
 	unsigned long flags;
 
 	spin_lock_irqsave(&dev->dev_queue_obj.cmd_queue_lock, flags);
-	list_for_each_entry_safe(qr, qr_p, &dev->dev_queue_obj.qobj_list,
-				qr_list) {
-
-		cmd = qr->cmd;
-		t_state = qr->state;
-		list_del(&qr->qr_list);
+	list_for_each_entry_safe(cmd, tcmd, &dev->dev_queue_obj.qobj_list,
+				se_queue_node) {
+		t_state = cmd->t_state;
+		list_del(&cmd->se_queue_node);
 		spin_unlock_irqrestore(&dev->dev_queue_obj.cmd_queue_lock,
 				flags);
 
@@ -5757,9 +5747,7 @@ transport_get_task_from_state_list(struct se_device *dev)
 static void transport_processing_shutdown(struct se_device *dev)
 {
 	struct se_cmd *cmd;
-	struct se_queue_req *qr;
 	struct se_task *task;
-	u8 state;
 	unsigned long flags;
 	/*
 	 * Empty the struct se_device's struct se_task state list.
@@ -5890,12 +5878,10 @@ static void transport_processing_shutdown(struct se_device *dev)
 	/*
 	 * Empty the struct se_device's struct se_cmd list.
 	 */
-	while ((qr = transport_get_qr_from_queue(&dev->dev_queue_obj))) {
-		cmd = qr->cmd;
-		state = qr->state;
+	while ((cmd = transport_get_cmd_from_queue(&dev->dev_queue_obj))) {
 
 		DEBUG_DO("From Device Queue: cmd: %p t_state: %d\n",
-				cmd, state);
+				cmd, cmd->t_state);
 
 		if (atomic_read(&cmd->t_task.t_fe_count)) {
 			transport_send_check_condition_and_sense(cmd,
@@ -5917,10 +5903,9 @@ static void transport_processing_shutdown(struct se_device *dev)
  */
 static int transport_processing_thread(void *param)
 {
-	int ret, t_state;
+	int ret;
 	struct se_cmd *cmd;
 	struct se_device *dev = (struct se_device *) param;
-	struct se_queue_req *qr;
 
 	set_user_nice(current, -20);
 
@@ -5942,14 +5927,11 @@ static int transport_processing_thread(void *param)
 get_cmd:
 		__transport_execute_tasks(dev);
 
-		qr = transport_get_qr_from_queue(&dev->dev_queue_obj);
-		if (!(qr))
+		cmd = transport_get_cmd_from_queue(&dev->dev_queue_obj);
+		if (!cmd)
 			continue;
 
-		cmd = qr->cmd;
-		t_state = qr->state;
-
-		switch (t_state) {
+		switch (cmd->t_state) {
 		case TRANSPORT_NEW_CMD_MAP:
 			if (!(cmd->se_tfo->new_cmd_map)) {
 				printk(KERN_ERR "cmd->se_tfo->new_cmd_map is"
@@ -6000,7 +5982,7 @@ get_cmd:
 		default:
 			printk(KERN_ERR "Unknown t_state: %d deferred_t_state:"
 				" %d for ITT: 0x%08x i_state: %d on SE LUN:"
-				" %u\n", t_state, cmd->deferred_t_state,
+				" %u\n", cmd->t_state, cmd->deferred_t_state,
 				cmd->se_tfo->get_task_tag(cmd),
 				cmd->se_tfo->get_cmd_state(cmd),
 				cmd->se_lun->unpacked_lun);
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index e4818cd..67d490f 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -535,7 +535,7 @@ struct se_cmd {
 	struct se_session	*se_sess;
 	struct se_tmr_req	*se_tmr_req;
 	struct se_transport_task t_task;
-	struct se_queue_req	se_qr;
+	struct list_head	se_queue_node;
 	struct target_core_fabric_ops *se_tfo;
 	int (*transport_emulate_cdb)(struct se_cmd *);
 	void (*transport_split_cdb)(unsigned long long, u32 *, unsigned char *);
-- 
1.7.6

