From: Roland Dreier <roland@kernel.org>
Subject: [PATCH 1/4] target: Fix handling of aborted commands
Date: Fri, 16 Nov 2012 08:06:16 -0800
Message-ID: <1353081979-29474-2-git-send-email-roland@kernel.org>
References: <1353081979-29474-1-git-send-email-roland@kernel.org>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1353081979-29474-1-git-send-email-roland@kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, Roland Dreier <roland@purestorage.com>
List-Id: linux-scsi@vger.kernel.org

From: Roland Dreier <roland@purestorage.com>

- If we stop processing an already-aborted command in
  target_execute_cmd(), then we need to complete t_transport_stop_comp
  to wake up the the TMR handling thread, or else it will end up
  waiting forever.

- If we've a already sent an "aborted" status for a command in
  transport_check_aborted_status() then we should bail out of
  transport_send_task_abort() to avoid freeing the command twice.

Signed-off-by: Roland Dreier <roland@purestorage.com>
---
 drivers/target/target_core_transport.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 9097155..dcecbfb 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -1819,8 +1819,10 @@ void target_execute_cmd(struct se_cmd *cmd)
 	/*
 	 * If the received CDB has aleady been aborted stop processing it here.
 	 */
-	if (transport_check_aborted_status(cmd, 1))
+	if (transport_check_aborted_status(cmd, 1)) {
+		complete(&cmd->t_transport_stop_comp);
 		return;
+	}
 
 	/*
 	 * Determine if IOCTL context caller in requesting the stopping of this
@@ -3067,7 +3069,7 @@ void transport_send_task_abort(struct se_cmd *cmd)
 	unsigned long flags;
 
 	spin_lock_irqsave(&cmd->t_state_lock, flags);
-	if (cmd->se_cmd_flags & SCF_SENT_CHECK_CONDITION) {
+	if (cmd->se_cmd_flags & (SCF_SENT_CHECK_CONDITION | SCF_SENT_DELAYED_TAS)) {
 		spin_unlock_irqrestore(&cmd->t_state_lock, flags);
 		return;
 	}
-- 
1.7.10.4
