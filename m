From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH 2/3] iscsi-target: Perform release of acknowledged tags from RX context
Date: Thu,  3 Oct 2013 21:01:11 +0000
Message-ID: <1380834072-25309-3-git-send-email-nab@daterainc.com>
References: <1380834072-25309-1-git-send-email-nab@daterainc.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1380834072-25309-1-git-send-email-nab@daterainc.com>
Sender: target-devel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Thomas Glanzmann <thomas@glanzmann.de>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch converts iscsit_ack_from_expstatsn() to populate a local
ack_list of commands, and call iscsit_free_cmd() directly from RX
thread context, instead of using iscsit_add_cmd_to_immediate_queue()
to queue the acknowledged commands to be released from TX thread
context.

It is helpful to release the acknowledge commands as quickly as
possible, along with the associated percpu_ida tags, in order to
prevent percpu_ida_alloc() from having to steal tags from other
CPUs while waiting for iscsit_free_cmd() to happen from TX thread
context.

Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/iscsi/iscsi_target.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index 35b61f7..38e44b9 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -753,7 +753,8 @@ static void iscsit_unmap_iovec(struct iscsi_cmd *cmd)
 
 static void iscsit_ack_from_expstatsn(struct iscsi_conn *conn, u32 exp_statsn)
 {
-	struct iscsi_cmd *cmd;
+	LIST_HEAD(ack_list);
+	struct iscsi_cmd *cmd, *cmd_p;
 
 	conn->exp_statsn = exp_statsn;
 
@@ -761,19 +762,23 @@ static void iscsit_ack_from_expstatsn(struct iscsi_conn *conn, u32 exp_statsn)
 		return;
 
 	spin_lock_bh(&conn->cmd_lock);
-	list_for_each_entry(cmd, &conn->conn_cmd_list, i_conn_node) {
+	list_for_each_entry_safe(cmd, cmd_p, &conn->conn_cmd_list, i_conn_node) {
 		spin_lock(&cmd->istate_lock);
 		if ((cmd->i_state == ISTATE_SENT_STATUS) &&
 		    iscsi_sna_lt(cmd->stat_sn, exp_statsn)) {
 			cmd->i_state = ISTATE_REMOVE;
 			spin_unlock(&cmd->istate_lock);
-			iscsit_add_cmd_to_immediate_queue(cmd, conn,
-						cmd->i_state);
+			list_move_tail(&cmd->i_conn_node, &ack_list);
 			continue;
 		}
 		spin_unlock(&cmd->istate_lock);
 	}
 	spin_unlock_bh(&conn->cmd_lock);
+
+	list_for_each_entry_safe(cmd, cmd_p, &ack_list, i_conn_node) {
+		list_del(&cmd->i_conn_node);
+		iscsit_free_cmd(cmd, false);
+	}
 }
 
 static int iscsit_allocate_iovecs(struct iscsi_cmd *cmd)
-- 
1.7.10.4
