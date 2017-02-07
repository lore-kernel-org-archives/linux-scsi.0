From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 3/5] target: Fix early transport_generic_handle_tmr abort scenario
Date: Tue,  7 Feb 2017 13:17:48 +0000
Message-ID: <1486473470-15837-4-git-send-email-nab@linux-iscsi.org>
References: <1486473470-15837-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1486473470-15837-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-kernel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>, Nicholas Bellinger <nab@linux-iscsi.org>, Rob Millner <rlm@daterainc.com>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch fixes a bug where incoming task management requests
can be explicitly aborted during an active LUN_RESET, but who's
struct work_struct are canceled in-flight before execution.

This occurs when core_tmr_drain_tmr_list() invokes cancel_work_sync()
for the incoming se_tmr_req->task_cmd->work, resulting in cmd->work
for target_tmr_work() never getting invoked and the aborted TMR
waiting indefinately within transport_wait_for_tasks().

To address this case, perform a CMD_T_ABORTED check early in
transport_generic_handle_tmr(), and invoke the normal path via
transport_cmd_check_stop_to_fabric() to complete any TMR kthreads
blocked waiting for CMD_T_STOP in transport_wait_for_tasks().

Also, move the TRANSPORT_ISTATE_PROCESSING assignment earlier
into transport_generic_handle_tmr() so the existing check in
core_tmr_drain_tmr_list() avoids attempting abort the incoming
se_tmr_req->task_cmd->work if it has already been queued into
se_device->tmr_wq.

Reported-by: Rob Millner <rlm@daterainc.com>
Tested-by: Rob Millner <rlm@daterainc.com>
Cc: Rob Millner <rlm@daterainc.com>
Cc: stable@vger.kernel.org # 3.14+
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_transport.c | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 1cadc9e..8b69843 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -3110,7 +3110,6 @@ static void target_tmr_work(struct work_struct *work)
 		spin_unlock_irqrestore(&cmd->t_state_lock, flags);
 		goto check_stop;
 	}
-	cmd->t_state = TRANSPORT_ISTATE_PROCESSING;
 	spin_unlock_irqrestore(&cmd->t_state_lock, flags);
 
 	cmd->se_tfo->queue_tm_rsp(cmd);
@@ -3123,11 +3122,25 @@ int transport_generic_handle_tmr(
 	struct se_cmd *cmd)
 {
 	unsigned long flags;
+	bool aborted = false;
 
 	spin_lock_irqsave(&cmd->t_state_lock, flags);
-	cmd->transport_state |= CMD_T_ACTIVE;
+	if (cmd->transport_state & CMD_T_ABORTED) {
+		aborted = true;
+	} else {
+		cmd->t_state = TRANSPORT_ISTATE_PROCESSING;
+		cmd->transport_state |= CMD_T_ACTIVE;
+	}
 	spin_unlock_irqrestore(&cmd->t_state_lock, flags);
 
+	if (aborted) {
+		pr_warn_ratelimited("handle_tmr caught CMD_T_ABORTED TMR %d"
+			"ref_tag: %llu tag: %llu\n", cmd->se_tmr_req->function,
+			cmd->se_tmr_req->ref_task_tag, cmd->tag);
+		transport_cmd_check_stop_to_fabric(cmd);
+		return 0;
+	}
+
 	INIT_WORK(&cmd->work, target_tmr_work);
 	queue_work(cmd->se_dev->tmr_wq, &cmd->work);
 	return 0;
-- 
1.9.1
