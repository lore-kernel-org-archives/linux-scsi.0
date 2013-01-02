From: Roland Dreier <roland@kernel.org>
Subject: [PATCH 2/5] target: Fix use-after-free in LUN RESET handling
Date: Wed,  2 Jan 2013 12:47:58 -0800
Message-ID: <1357159681-24477-3-git-send-email-roland@kernel.org>
References: <1357159681-24477-1-git-send-email-roland@kernel.org>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1357159681-24477-1-git-send-email-roland@kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, Roland Dreier <roland@purestorage.com>
List-Id: linux-scsi@vger.kernel.org

From: Roland Dreier <roland@purestorage.com>

If a backend IO takes a really long then an initiator might abort a
command, and then when it gives up on the abort, send a LUN reset too,
all before we process any of the original command or the abort.  (The
abort will wait for the backend IO to complete too)

When the backend IO final completes (or fails), the abort handling
will proceed and queue up a "return aborted status" operation.  Then,
while that's still pending, the LUN reset might find the original
command still on the LUN's list of commands and try to return aborted
status again, which leads to a use-after free when the first
se_tfo->queue_status call frees the command and then the second
se_tfo->queue_status call runs.

Fix this by removing a command from the LUN state_list when we first
are about to queue aborted status; we shouldn't do anything
LUN-related after we've started returning status, so this seems like
the correct thing to do.

Signed-off-by: Roland Dreier <roland@purestorage.com>
---
 drivers/target/target_core_transport.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 1dd9d66..49390d8 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -541,9 +541,6 @@ static void transport_lun_remove_cmd(struct se_cmd *cmd)
 
 void transport_cmd_finish_abort(struct se_cmd *cmd, int remove)
 {
-	if (!(cmd->se_cmd_flags & SCF_SCSI_TMR_CDB))
-		transport_lun_remove_cmd(cmd);
-
 	if (transport_cmd_check_stop_to_fabric(cmd))
 		return;
 	if (remove)
@@ -2805,6 +2802,8 @@ void transport_send_task_abort(struct se_cmd *cmd)
 	}
 	cmd->scsi_status = SAM_STAT_TASK_ABORTED;
 
+	transport_lun_remove_cmd(cmd);
+
 	pr_debug("Setting SAM_STAT_TASK_ABORTED status for CDB: 0x%02x,"
 		" ITT: 0x%08x\n", cmd->t_task_cdb[0],
 		cmd->se_tfo->get_task_tag(cmd));
-- 
1.8.0
