From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 035/103] target: Embed qr in struct se_cmd
Date: Thu, 21 Jul 2011 00:07:47 -0700
Message-ID: <1311232135-6653-36-git-send-email-nab@linux-iscsi.org>
References: <1311232135-6653-32-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nm29-vm0.access.bullet.mail.sp2.yahoo.com ([98.139.44.192]:26101
	"HELO nm29-vm0.access.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751970Ab1GUHDS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 21 Jul 2011 03:03:18 -0400
In-Reply-To: <1311232135-6653-32-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Andy Grover <agrover@redhat.com>

From: Andy Grover <agrover@redhat.com>

This saves a call to kmalloc, and means we don't need to remember to
free the struct se_queue_req.

This also makes it possible to make transport_add_cmd_to_queue never
return an error code, which is nice since it wasn't being checked.

Removed an incorrect comment above get_qr_from_queue; cmd_queue_lock
is acquired in the function now, not before.

Signed-off-by: Andy Grover <agrover@redhat.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_transport.c |   25 +++++--------------------
 include/target/target_core_base.h      |    1 +
 2 files changed, 6 insertions(+), 20 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 8a71ad8..969cbe2 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -753,25 +753,18 @@ void transport_cmd_finish_abort_tmr(struct se_cmd *cmd)
 	transport_generic_remove(cmd, 0, 0);
 }
 
-static int transport_add_cmd_to_queue(
+static void transport_add_cmd_to_queue(
 	struct se_cmd *cmd,
 	int t_state)
 {
 	struct se_device *dev = cmd->se_dev;
 	struct se_queue_obj *qobj = &dev->dev_queue_obj;
-	struct se_queue_req *qr;
 	unsigned long flags;
 
-	qr = kzalloc(sizeof(struct se_queue_req), GFP_ATOMIC);
-	if (!(qr)) {
-		printk(KERN_ERR "Unable to allocate memory for"
-				" struct se_queue_req\n");
-		return -ENOMEM;
-	}
-	INIT_LIST_HEAD(&qr->qr_list);
+	INIT_LIST_HEAD(&cmd->se_qr.qr_list);
 
-	qr->cmd = cmd;
-	qr->state = t_state;
+	cmd->se_qr.cmd = cmd;
+	cmd->se_qr.state = t_state;
 
 	if (t_state) {
 		spin_lock_irqsave(&cmd->t_task.t_state_lock, flags);
@@ -781,18 +774,14 @@ static int transport_add_cmd_to_queue(
 	}
 
 	spin_lock_irqsave(&qobj->cmd_queue_lock, flags);
-	list_add_tail(&qr->qr_list, &qobj->qobj_list);
+	list_add_tail(&cmd->se_qr.qr_list, &qobj->qobj_list);
 	atomic_inc(&cmd->t_task.t_transport_queue_active);
 	spin_unlock_irqrestore(&qobj->cmd_queue_lock, flags);
 
 	atomic_inc(&qobj->queue_cnt);
 	wake_up_interruptible(&qobj->thread_wq);
-	return 0;
 }
 
-/*
- * Called with struct se_queue_obj->cmd_queue_lock held.
- */
 static struct se_queue_req *
 transport_get_qr_from_queue(struct se_queue_obj *qobj)
 {
@@ -837,7 +826,6 @@ static void transport_remove_cmd_from_queue(struct se_cmd *cmd,
 		atomic_dec(&qr->cmd->t_task.t_transport_queue_active);
 		atomic_dec(&qobj->queue_cnt);
 		list_del(&qr->qr_list);
-		kfree(qr);
 	}
 	spin_unlock_irqrestore(&qobj->cmd_queue_lock, flags);
 
@@ -1193,7 +1181,6 @@ static void transport_release_all_cmds(struct se_device *dev)
 		cmd = qr->cmd;
 		t_state = qr->state;
 		list_del(&qr->qr_list);
-		kfree(qr);
 		spin_unlock_irqrestore(&dev->dev_queue_obj.cmd_queue_lock,
 				flags);
 
@@ -5906,7 +5893,6 @@ static void transport_processing_shutdown(struct se_device *dev)
 	while ((qr = transport_get_qr_from_queue(&dev->dev_queue_obj))) {
 		cmd = qr->cmd;
 		state = qr->state;
-		kfree(qr);
 
 		DEBUG_DO("From Device Queue: cmd: %p t_state: %d\n",
 				cmd, state);
@@ -5962,7 +5948,6 @@ get_cmd:
 
 		cmd = qr->cmd;
 		t_state = qr->state;
-		kfree(qr);
 
 		switch (t_state) {
 		case TRANSPORT_NEW_CMD_MAP:
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index bdee755..e4818cd 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -535,6 +535,7 @@ struct se_cmd {
 	struct se_session	*se_sess;
 	struct se_tmr_req	*se_tmr_req;
 	struct se_transport_task t_task;
+	struct se_queue_req	se_qr;
 	struct target_core_fabric_ops *se_tfo;
 	int (*transport_emulate_cdb)(struct se_cmd *);
 	void (*transport_split_cdb)(unsigned long long, u32 *, unsigned char *);
-- 
1.7.6

