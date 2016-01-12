From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH 2/2] target: Fix LUN_RESET active TMR descriptor handling
Date: Tue, 12 Jan 2016 10:24:05 +0000
Message-ID: <1452594245-921-3-git-send-email-nab@daterainc.com>
References: <1452594245-921-1-git-send-email-nab@daterainc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ob0-f173.google.com ([209.85.214.173]:35467 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964946AbcALK0T (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Jan 2016 05:26:19 -0500
Received: by mail-ob0-f173.google.com with SMTP id py5so55514657obc.2
        for <linux-scsi@vger.kernel.org>; Tue, 12 Jan 2016 02:26:19 -0800 (PST)
In-Reply-To: <1452594245-921-1-git-send-email-nab@daterainc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Quinn Tran <quinn.tran@qlogic.com>, Himanshu Madhani <himanshu.madhani@qlogic.com>, Sagi Grimberg <sagig@mellanox.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Andy Grover <agrover@redhat.com>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch fixes a NULL pointer se_cmd->cmd_kref < 0
refcount bug during TMR LUN_RESET with TMR se_cmd,
triggered during se_cmd + se_tmr_req descriptor
shutdown + release via core_tmr_drain_tmr_list().

It obtains kref_get_unless_zero(&se_cmd->cmd_kref)
following __target_check_io_state() for active I/O
CMD_T_ABORTED, and adds transport_wait_for_tasks()
followed by the final target_put_sess_cmd() to
release TMR logic locally obtained ->cmd_kref.

Also add two new checks within target_tmr_work() to
avoid CMD_T_ABORTED -> TFO->queue_tm_rsp() callbacks
ahead of invoking the backend -> fabric put in
transport_cmd_check_stop_to_fabric().

For good measure, also change core_tmr_release_req()
to use !list_empty() + list_del_init() ahead of
se_tmr_req memory free.

Cc: Quinn Tran <quinn.tran@qlogic.com>
Cc: Himanshu Madhani <himanshu.madhani@qlogic.com>
Cc: Sagi Grimberg <sagig@mellanox.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Andy Grover <agrover@redhat.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_tmr.c       | 24 +++++++++++++++++++++++-
 drivers/target/target_core_transport.c | 17 +++++++++++++++++
 2 files changed, 40 insertions(+), 1 deletion(-)

diff --git a/drivers/target/target_core_tmr.c b/drivers/target/target_core_tmr.c
index af4adb6..894a0b0 100644
--- a/drivers/target/target_core_tmr.c
+++ b/drivers/target/target_core_tmr.c
@@ -68,7 +68,8 @@ void core_tmr_release_req(struct se_tmr_req *tmr)
 
 	if (dev) {
 		spin_lock_irqsave(&dev->se_tmr_lock, flags);
-		list_del(&tmr->tmr_list);
+		if (!list_empty(&tmr->tmr_list))
+			list_del_init(&tmr->tmr_list);
 		spin_unlock_irqrestore(&dev->se_tmr_lock, flags);
 	}
 
@@ -192,9 +193,12 @@ static void core_tmr_drain_tmr_list(
 	struct list_head *preempt_and_abort_list)
 {
 	LIST_HEAD(drain_tmr_list);
+	struct se_session *sess;
 	struct se_tmr_req *tmr_p, *tmr_pp;
 	struct se_cmd *cmd;
 	unsigned long flags;
+	bool rc;
+
 	/*
 	 * Release all pending and outgoing TMRs aside from the received
 	 * LUN_RESET tmr..
@@ -220,6 +224,12 @@ static void core_tmr_drain_tmr_list(
 		if (target_check_cdb_and_preempt(preempt_and_abort_list, cmd))
 			continue;
 
+		sess = cmd->se_sess;
+		if (!sess) {
+			dump_stack();
+			continue;
+		}
+
 		spin_lock(&cmd->t_state_lock);
 		if (!(cmd->transport_state & CMD_T_ACTIVE)) {
 			spin_unlock(&cmd->t_state_lock);
@@ -229,8 +239,16 @@ static void core_tmr_drain_tmr_list(
 			spin_unlock(&cmd->t_state_lock);
 			continue;
 		}
+		cmd->transport_state |= CMD_T_ABORTED;
 		spin_unlock(&cmd->t_state_lock);
 
+		spin_lock(&sess->sess_cmd_lock);
+		rc = kref_get_unless_zero(&cmd->cmd_kref);
+		spin_unlock(&sess->sess_cmd_lock);
+		if (!rc) {
+			printk("LUN_RESET TMR: non-zero kref_get_unless_zero\n");
+			continue;
+		}
 		list_move_tail(&tmr_p->tmr_list, &drain_tmr_list);
 	}
 	spin_unlock_irqrestore(&dev->se_tmr_lock, flags);
@@ -244,7 +262,11 @@ static void core_tmr_drain_tmr_list(
 			(preempt_and_abort_list) ? "Preempt" : "", tmr_p,
 			tmr_p->function, tmr_p->response, cmd->t_state);
 
+		cancel_work_sync(&cmd->work);
+		transport_wait_for_tasks(cmd);
+
 		transport_cmd_finish_abort(cmd, 1);
+		target_put_sess_cmd(cmd);
 	}
 }
 
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index f2c596b..f6ecb60 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -2905,8 +2905,17 @@ static void target_tmr_work(struct work_struct *work)
 	struct se_cmd *cmd = container_of(work, struct se_cmd, work);
 	struct se_device *dev = cmd->se_dev;
 	struct se_tmr_req *tmr = cmd->se_tmr_req;
+	unsigned long flags;
 	int ret;
 
+	spin_lock_irqsave(&cmd->t_state_lock, flags);
+	if (cmd->transport_state & CMD_T_ABORTED) {
+		tmr->response = TMR_FUNCTION_REJECTED;
+		spin_unlock_irqrestore(&cmd->t_state_lock, flags);
+		goto check_stop;
+	}
+	spin_unlock_irqrestore(&cmd->t_state_lock, flags);
+
 	switch (tmr->function) {
 	case TMR_ABORT_TASK:
 		core_tmr_abort_task(dev, tmr, cmd->se_sess);
@@ -2939,9 +2948,17 @@ static void target_tmr_work(struct work_struct *work)
 		break;
 	}
 
+	spin_lock_irqsave(&cmd->t_state_lock, flags);
+	if (cmd->transport_state & CMD_T_ABORTED) {
+		spin_unlock_irqrestore(&cmd->t_state_lock, flags);
+		goto check_stop;
+	}
 	cmd->t_state = TRANSPORT_ISTATE_PROCESSING;
+	spin_unlock_irqrestore(&cmd->t_state_lock, flags);
+
 	cmd->se_tfo->queue_tm_rsp(cmd);
 
+check_stop:
 	transport_cmd_check_stop_to_fabric(cmd);
 }
 
-- 
1.9.1

