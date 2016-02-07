From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH-v4 5/5] target: Fix race with SCF_SEND_DELAYED_TAS handling
Date: Sun,  7 Feb 2016 03:18:02 +0000
Message-ID: <1454815082-15380-6-git-send-email-nab@daterainc.com>
References: <1454815082-15380-1-git-send-email-nab@daterainc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ob0-f172.google.com ([209.85.214.172]:34627 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753250AbcBGDVW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 6 Feb 2016 22:21:22 -0500
Received: by mail-ob0-f172.google.com with SMTP id wb13so121411335obb.1
        for <linux-scsi@vger.kernel.org>; Sat, 06 Feb 2016 19:21:20 -0800 (PST)
In-Reply-To: <1454815082-15380-1-git-send-email-nab@daterainc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Quinn Tran <quinn.tran@qlogic.com>, Himanshu Madhani <himanshu.madhani@qlogic.com>, Sagi Grimberg <sagig@mellanox.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Andy Grover <agrover@redhat.com>, Mike Christie <mchristi@redhat.com>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch fixes a race between setting of SCF_SEND_DELAYED_TAS
in transport_send_task_abort(), and check of the same bit in
transport_check_aborted_status().

It adds a __transport_check_aborted_status() version that is
used by target_execute_cmd() when se_cmd->t_state_lock is
held, and a transport_check_aborted_status() wrapper for
all other existing callers.

Also, it handles the case where the check happens before
transport_send_task_abort() gets called.  For this, go
ahead and set SCF_SEND_DELAYED_TAS early when necessary,
and have transport_send_task_abort() send the abort.

Cc: Quinn Tran <quinn.tran@qlogic.com>
Cc: Himanshu Madhani <himanshu.madhani@qlogic.com>
Cc: Sagi Grimberg <sagig@mellanox.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Andy Grover <agrover@redhat.com>
Cc: Mike Christie <mchristi@redhat.com>
Cc: stable@vger.kernel.org # 3.10+
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_transport.c | 53 ++++++++++++++++++++++++++--------
 1 file changed, 41 insertions(+), 12 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 3441b15..2e0b23a 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -1858,19 +1858,21 @@ static bool target_handle_task_attr(struct se_cmd *cmd)
 	return true;
 }
 
+static int __transport_check_aborted_status(struct se_cmd *, int);
+
 void target_execute_cmd(struct se_cmd *cmd)
 {
 	/*
-	 * If the received CDB has aleady been aborted stop processing it here.
-	 */
-	if (transport_check_aborted_status(cmd, 1))
-		return;
-
-	/*
 	 * Determine if frontend context caller is requesting the stopping of
 	 * this command for frontend exceptions.
+	 *
+	 * If the received CDB has aleady been aborted stop processing it here.
 	 */
 	spin_lock_irq(&cmd->t_state_lock);
+	if (__transport_check_aborted_status(cmd, 1)) {
+		spin_unlock_irq(&cmd->t_state_lock);
+		return;
+	}
 	if (cmd->transport_state & CMD_T_STOP) {
 		pr_debug("%s:%d CMD_T_STOP for ITT: 0x%08llx\n",
 			__func__, __LINE__, cmd->tag);
@@ -2911,28 +2913,49 @@ transport_send_check_condition_and_sense(struct se_cmd *cmd,
 }
 EXPORT_SYMBOL(transport_send_check_condition_and_sense);
 
-int transport_check_aborted_status(struct se_cmd *cmd, int send_status)
+static int __transport_check_aborted_status(struct se_cmd *cmd, int send_status)
+	__releases(&cmd->t_state_lock)
+	__acquires(&cmd->t_state_lock)
 {
+	assert_spin_locked(&cmd->t_state_lock);
+	WARN_ON_ONCE(!irqs_disabled());
+
 	if (!(cmd->transport_state & CMD_T_ABORTED))
 		return 0;
-
 	/*
 	 * If cmd has been aborted but either no status is to be sent or it has
 	 * already been sent, just return
 	 */
-	if (!send_status || !(cmd->se_cmd_flags & SCF_SEND_DELAYED_TAS))
+	if (!send_status || !(cmd->se_cmd_flags & SCF_SEND_DELAYED_TAS)) {
+		if (send_status)
+			cmd->se_cmd_flags |= SCF_SEND_DELAYED_TAS;
 		return 1;
+	}
 
-	pr_debug("Sending delayed SAM_STAT_TASK_ABORTED status for CDB: 0x%02x ITT: 0x%08llx\n",
-		 cmd->t_task_cdb[0], cmd->tag);
+	pr_debug("Sending delayed SAM_STAT_TASK_ABORTED status for CDB:"
+		" 0x%02x ITT: 0x%08llx\n", cmd->t_task_cdb[0], cmd->tag);
 
 	cmd->se_cmd_flags &= ~SCF_SEND_DELAYED_TAS;
 	cmd->scsi_status = SAM_STAT_TASK_ABORTED;
 	trace_target_cmd_complete(cmd);
+
+	spin_unlock_irq(&cmd->t_state_lock);
 	cmd->se_tfo->queue_status(cmd);
+	spin_lock_irq(&cmd->t_state_lock);
 
 	return 1;
 }
+
+int transport_check_aborted_status(struct se_cmd *cmd, int send_status)
+{
+	int ret;
+
+	spin_lock_irq(&cmd->t_state_lock);
+	ret = __transport_check_aborted_status(cmd, send_status);
+	spin_unlock_irq(&cmd->t_state_lock);
+
+	return ret;
+}
 EXPORT_SYMBOL(transport_check_aborted_status);
 
 void transport_send_task_abort(struct se_cmd *cmd)
@@ -2954,11 +2977,17 @@ void transport_send_task_abort(struct se_cmd *cmd)
 	 */
 	if (cmd->data_direction == DMA_TO_DEVICE) {
 		if (cmd->se_tfo->write_pending_status(cmd) != 0) {
-			cmd->transport_state |= CMD_T_ABORTED;
+			spin_lock_irqsave(&cmd->t_state_lock, flags);
+			if (cmd->se_cmd_flags & SCF_SEND_DELAYED_TAS) {
+				spin_unlock_irqrestore(&cmd->t_state_lock, flags);
+				goto send_abort;
+			}
 			cmd->se_cmd_flags |= SCF_SEND_DELAYED_TAS;
+			spin_unlock_irqrestore(&cmd->t_state_lock, flags);
 			return;
 		}
 	}
+send_abort:
 	cmd->scsi_status = SAM_STAT_TASK_ABORTED;
 
 	transport_lun_remove_cmd(cmd);
-- 
1.9.1

