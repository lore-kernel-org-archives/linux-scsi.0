From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH] [LIO-Target 9/14]: Updated ErrorRecoveryLevel=2 code to
	use SE_CMD(iscsi_cmd_t)
Date: Fri, 19 Dec 2008 15:35:14 -0800
Message-ID: <1229729714.4560.118.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1756722AbYLSXgB@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "Linux-iSCSI.org Target Dev" <linux-iscsi-target-dev@googlegroups.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

>From a554f37de0a867da33baa4cec8868bfb64b5ecc8 Mon Sep 17 00:00:00 2001
From: Nicholas Bellinger <nab@linux-iscsi.org>
Date: Fri, 19 Dec 2008 14:24:12 -0800
Subject: [PATCH] [LIO-Target]: Updated ErrorRecoveryLevel=2 code to use SE_CMD(iscsi_cmd_t)

This patch adds a conditional to check for the existance of SE_CMD(iscsi_cmd_t),
before looking for SE_CMD(iscsi_cmd_t)->se_cmd_flags in ErrorRecoveryLevel=2 logic.

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/lio-core/iscsi_target_erl2.c |   21 ++++++++++++++-------
 1 files changed, 14 insertions(+), 7 deletions(-)

diff --git a/drivers/lio-core/iscsi_target_erl2.c b/drivers/lio-core/iscsi_target_erl2.c
index e0bad78..070819b 100644
--- a/drivers/lio-core/iscsi_target_erl2.c
+++ b/drivers/lio-core/iscsi_target_erl2.c
@@ -197,7 +197,8 @@ extern void iscsi_free_connection_recovery_entires (iscsi_session_t *sess)
 		
 			cmd->conn = NULL;
 			spin_unlock(&cr->conn_recovery_cmd_lock);
-			if (!(cmd->cmd_flags & ICF_SE_LUN_CMD) ||
+			if (!(SE_CMD(cmd)) ||
+			    !(SE_CMD(cmd)->se_cmd_flags & SCF_SE_LUN_CMD) ||
 			    !(SE_CMD(cmd)->transport_wait_for_tasks))
 				__iscsi_release_cmd_to_pool(cmd, sess);
 			else
@@ -229,7 +230,8 @@ extern void iscsi_free_connection_recovery_entires (iscsi_session_t *sess)
 
 			cmd->conn = NULL;
 			spin_unlock(&cr->conn_recovery_cmd_lock);
-			if (!(cmd->cmd_flags & ICF_SE_LUN_CMD) ||
+			if (!(SE_CMD(cmd)) ||
+			    !(SE_CMD(cmd)->se_cmd_flags & SCF_SE_LUN_CMD) ||
 			    !(SE_CMD(cmd)->transport_wait_for_tasks))
 				__iscsi_release_cmd_to_pool(cmd, sess);
 			else
@@ -373,7 +375,8 @@ extern void iscsi_discard_cr_cmds_by_expstatsn (
 		iscsi_remove_cmd_from_connection_recovery(cmd, sess);
 		
 		spin_unlock(&cr->conn_recovery_cmd_lock);
-		if (!(cmd->cmd_flags & ICF_SE_LUN_CMD) ||
+		if (!(SE_CMD(cmd)) ||
+		    !(SE_CMD(cmd)->se_cmd_flags & SCF_SE_LUN_CMD) ||
 		    !(SE_CMD(cmd)->transport_wait_for_tasks))
 			__iscsi_release_cmd_to_pool(cmd, sess);
 		else
@@ -449,7 +452,8 @@ extern int iscsi_discard_unacknowledged_ooo_cmdsns_for_conn (iscsi_conn_t *conn)
 		iscsi_remove_cmd_from_conn_list(cmd, conn);
 
 		spin_unlock_bh(&conn->cmd_lock);
-		if (!(cmd->cmd_flags & ICF_SE_LUN_CMD) ||
+		if (!(SE_CMD(cmd)) ||
+		    !(SE_CMD(cmd)->se_cmd_flags & SCF_SE_LUN_CMD) ||
 		    !(SE_CMD(cmd)->transport_wait_for_tasks))
 			__iscsi_release_cmd_to_pool(cmd, sess);
 		else
@@ -514,7 +518,8 @@ extern int iscsi_prepare_cmds_for_realligance (iscsi_conn_t *conn)
 			iscsi_remove_cmd_from_conn_list(cmd, conn);
 
 			spin_unlock_bh(&conn->cmd_lock);
-			if (!(cmd->cmd_flags & ICF_SE_LUN_CMD) ||
+			if (!(SE_CMD(cmd)) ||
+			    !(SE_CMD(cmd)->se_cmd_flags & SCF_SE_LUN_CMD) ||
 			    !(SE_CMD(cmd)->transport_wait_for_tasks))
 				__iscsi_release_cmd_to_pool(cmd, SESS(conn));
 			else
@@ -542,7 +547,8 @@ extern int iscsi_prepare_cmds_for_realligance (iscsi_conn_t *conn)
 			iscsi_remove_cmd_from_conn_list(cmd, conn);
 
 			spin_unlock_bh(&conn->cmd_lock);
-			if (!(cmd->cmd_flags & ICF_SE_LUN_CMD) ||
+			if (!(SE_CMD(cmd)) ||
+			    !(SE_CMD(cmd)->se_cmd_flags & SCF_SE_LUN_CMD) ||
 			    !(SE_CMD(cmd)->transport_wait_for_tasks))
 				__iscsi_release_cmd_to_pool(cmd, SESS(conn));
 			else
@@ -570,7 +576,8 @@ extern int iscsi_prepare_cmds_for_realligance (iscsi_conn_t *conn)
 		spin_unlock_bh(&conn->cmd_lock);
 		iscsi_free_all_datain_reqs(cmd);
 
-		if ((cmd->cmd_flags & ICF_SE_LUN_CMD) &&
+		if ((SE_CMD(cmd)) &&
+		    (SE_CMD(cmd)->se_cmd_flags & SCF_SE_LUN_CMD) &&
 		     SE_CMD(cmd)->transport_wait_for_tasks)
 			SE_CMD(cmd)->transport_wait_for_tasks(SE_CMD(cmd), 0, 0);
 
-- 
1.5.4.1
