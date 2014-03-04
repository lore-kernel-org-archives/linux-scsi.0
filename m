From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH 2/6] iscsi/iser-target: Use list_del_init for ->i_conn_node
Date: Tue,  4 Mar 2014 00:01:01 +0000
Message-ID: <1393891265-22910-3-git-send-email-nab@daterainc.com>
References: <1393891265-22910-1-git-send-email-nab@daterainc.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1393891265-22910-1-git-send-email-nab@daterainc.com>
Sender: target-devel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-rdma <linux-rdma@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Or Gerlitz <ogerlitz@mellanox.com>, Sagi Grimberg <sagig@mellanox.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

There are a handful of uses of list_empty() for cmd->i_conn_node
within iser-target code that expect to return false once a cmd
has been removed from the per connect list.

This patch changes all uses of list_del -> list_del_init in order
to ensure that list_empty() returns false as expected.

Cc: Sagi Grimberg <sagig@mellanox.com>
Cc: Or Gerlitz <ogerlitz@mellanox.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/infiniband/ulp/isert/ib_isert.c  |    6 +++---
 drivers/target/iscsi/iscsi_target.c      |    6 +++---
 drivers/target/iscsi/iscsi_target_erl2.c |   16 ++++++++--------
 3 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index 63bcf69..05a575e 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -1451,7 +1451,7 @@ isert_put_cmd(struct isert_cmd *isert_cmd)
 	case ISCSI_OP_SCSI_CMD:
 		spin_lock_bh(&conn->cmd_lock);
 		if (!list_empty(&cmd->i_conn_node))
-			list_del(&cmd->i_conn_node);
+			list_del_init(&cmd->i_conn_node);
 		spin_unlock_bh(&conn->cmd_lock);
 
 		if (cmd->data_direction == DMA_TO_DEVICE)
@@ -1463,7 +1463,7 @@ isert_put_cmd(struct isert_cmd *isert_cmd)
 	case ISCSI_OP_SCSI_TMFUNC:
 		spin_lock_bh(&conn->cmd_lock);
 		if (!list_empty(&cmd->i_conn_node))
-			list_del(&cmd->i_conn_node);
+			list_del_init(&cmd->i_conn_node);
 		spin_unlock_bh(&conn->cmd_lock);
 
 		transport_generic_free_cmd(&cmd->se_cmd, 0);
@@ -1473,7 +1473,7 @@ isert_put_cmd(struct isert_cmd *isert_cmd)
 	case ISCSI_OP_TEXT:
 		spin_lock_bh(&conn->cmd_lock);
 		if (!list_empty(&cmd->i_conn_node))
-			list_del(&cmd->i_conn_node);
+			list_del_init(&cmd->i_conn_node);
 		spin_unlock_bh(&conn->cmd_lock);
 
 		/*
diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index a99637e..72f1576 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -784,7 +784,7 @@ static void iscsit_ack_from_expstatsn(struct iscsi_conn *conn, u32 exp_statsn)
 	spin_unlock_bh(&conn->cmd_lock);
 
 	list_for_each_entry_safe(cmd, cmd_p, &ack_list, i_conn_node) {
-		list_del(&cmd->i_conn_node);
+		list_del_init(&cmd->i_conn_node);
 		iscsit_free_cmd(cmd, false);
 	}
 }
@@ -3709,7 +3709,7 @@ iscsit_immediate_queue(struct iscsi_conn *conn, struct iscsi_cmd *cmd, int state
 		break;
 	case ISTATE_REMOVE:
 		spin_lock_bh(&conn->cmd_lock);
-		list_del(&cmd->i_conn_node);
+		list_del_init(&cmd->i_conn_node);
 		spin_unlock_bh(&conn->cmd_lock);
 
 		iscsit_free_cmd(cmd, false);
@@ -4152,7 +4152,7 @@ static void iscsit_release_commands_from_conn(struct iscsi_conn *conn)
 	spin_lock_bh(&conn->cmd_lock);
 	list_for_each_entry_safe(cmd, cmd_tmp, &conn->conn_cmd_list, i_conn_node) {
 
-		list_del(&cmd->i_conn_node);
+		list_del_init(&cmd->i_conn_node);
 		spin_unlock_bh(&conn->cmd_lock);
 
 		iscsit_increment_maxcmdsn(cmd, sess);
diff --git a/drivers/target/iscsi/iscsi_target_erl2.c b/drivers/target/iscsi/iscsi_target_erl2.c
index 33be1fb..4ca8fd2 100644
--- a/drivers/target/iscsi/iscsi_target_erl2.c
+++ b/drivers/target/iscsi/iscsi_target_erl2.c
@@ -138,7 +138,7 @@ void iscsit_free_connection_recovery_entires(struct iscsi_session *sess)
 		list_for_each_entry_safe(cmd, cmd_tmp,
 				&cr->conn_recovery_cmd_list, i_conn_node) {
 
-			list_del(&cmd->i_conn_node);
+			list_del_init(&cmd->i_conn_node);
 			cmd->conn = NULL;
 			spin_unlock(&cr->conn_recovery_cmd_lock);
 			iscsit_free_cmd(cmd, true);
@@ -160,7 +160,7 @@ void iscsit_free_connection_recovery_entires(struct iscsi_session *sess)
 		list_for_each_entry_safe(cmd, cmd_tmp,
 				&cr->conn_recovery_cmd_list, i_conn_node) {
 
-			list_del(&cmd->i_conn_node);
+			list_del_init(&cmd->i_conn_node);
 			cmd->conn = NULL;
 			spin_unlock(&cr->conn_recovery_cmd_lock);
 			iscsit_free_cmd(cmd, true);
@@ -216,7 +216,7 @@ int iscsit_remove_cmd_from_connection_recovery(
 	}
 	cr = cmd->cr;
 
-	list_del(&cmd->i_conn_node);
+	list_del_init(&cmd->i_conn_node);
 	return --cr->cmd_count;
 }
 
@@ -297,7 +297,7 @@ int iscsit_discard_unacknowledged_ooo_cmdsns_for_conn(struct iscsi_conn *conn)
 		if (!(cmd->cmd_flags & ICF_OOO_CMDSN))
 			continue;
 
-		list_del(&cmd->i_conn_node);
+		list_del_init(&cmd->i_conn_node);
 
 		spin_unlock_bh(&conn->cmd_lock);
 		iscsit_free_cmd(cmd, true);
@@ -335,7 +335,7 @@ int iscsit_prepare_cmds_for_realligance(struct iscsi_conn *conn)
 	/*
 	 * Only perform connection recovery on ISCSI_OP_SCSI_CMD or
 	 * ISCSI_OP_NOOP_OUT opcodes.  For all other opcodes call
-	 * list_del(&cmd->i_conn_node); to release the command to the
+	 * list_del_init(&cmd->i_conn_node); to release the command to the
 	 * session pool and remove it from the connection's list.
 	 *
 	 * Also stop the DataOUT timer, which will be restarted after
@@ -351,7 +351,7 @@ int iscsit_prepare_cmds_for_realligance(struct iscsi_conn *conn)
 				" CID: %hu\n", cmd->iscsi_opcode,
 				cmd->init_task_tag, cmd->cmd_sn, conn->cid);
 
-			list_del(&cmd->i_conn_node);
+			list_del_init(&cmd->i_conn_node);
 			spin_unlock_bh(&conn->cmd_lock);
 			iscsit_free_cmd(cmd, true);
 			spin_lock_bh(&conn->cmd_lock);
@@ -371,7 +371,7 @@ int iscsit_prepare_cmds_for_realligance(struct iscsi_conn *conn)
 		 */
 		if (!(cmd->cmd_flags & ICF_OOO_CMDSN) && !cmd->immediate_cmd &&
 		     iscsi_sna_gte(cmd->cmd_sn, conn->sess->exp_cmd_sn)) {
-			list_del(&cmd->i_conn_node);
+			list_del_init(&cmd->i_conn_node);
 			spin_unlock_bh(&conn->cmd_lock);
 			iscsit_free_cmd(cmd, true);
 			spin_lock_bh(&conn->cmd_lock);
@@ -393,7 +393,7 @@ int iscsit_prepare_cmds_for_realligance(struct iscsi_conn *conn)
 
 		cmd->sess = conn->sess;
 
-		list_del(&cmd->i_conn_node);
+		list_del_init(&cmd->i_conn_node);
 		spin_unlock_bh(&conn->cmd_lock);
 
 		iscsit_free_all_datain_reqs(cmd);
-- 
1.7.10.4
