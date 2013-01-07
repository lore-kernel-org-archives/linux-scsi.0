From: Roland Dreier <roland@kernel.org>
Subject: [PATCH] iscsi-target: Fix CmdSN comparison (use cmd->cmd_sn instead of cmd->stat_sn)
Date: Mon,  7 Jan 2013 11:45:16 -0800
Message-ID: <1357587916-4870-1-git-send-email-roland@kernel.org>
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, Roland Dreier <roland@purestorage.com>
List-Id: linux-scsi@vger.kernel.org

From: Roland Dreier <roland@purestorage.com>

Commit 64c13330a389 ("iscsi-target: Fix bug in handling of ExpStatSN
ACK during u32 wrap-around") introduced a bug where we compare the
wrong SN against our ExpCmdSN.

Reported-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Roland Dreier <roland@purestorage.com>
---
 drivers/target/iscsi/iscsi_target_erl2.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/target/iscsi/iscsi_target_erl2.c b/drivers/target/iscsi/iscsi_target_erl2.c
index 9ac4c151..ba6091b 100644
--- a/drivers/target/iscsi/iscsi_target_erl2.c
+++ b/drivers/target/iscsi/iscsi_target_erl2.c
@@ -372,7 +372,7 @@ int iscsit_prepare_cmds_for_realligance(struct iscsi_conn *conn)
 		 * made generic here.
 		 */
 		if (!(cmd->cmd_flags & ICF_OOO_CMDSN) && !cmd->immediate_cmd &&
-		     iscsi_sna_gte(cmd->stat_sn, conn->sess->exp_cmd_sn)) {
+		     iscsi_sna_gte(cmd->cmd_sn, conn->sess->exp_cmd_sn)) {
 			list_del(&cmd->i_conn_node);
 			spin_unlock_bh(&conn->cmd_lock);
 			iscsit_free_cmd(cmd);
-- 
1.8.0
