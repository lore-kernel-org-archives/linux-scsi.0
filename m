From: Andy Grover <agrover@redhat.com>
Subject: [PATCH 19/20] target/iscsi: Simplify two small bits
Date: Fri,  8 Jul 2011 18:18:48 -0700
Message-ID: <1310174329-22228-20-git-send-email-agrover@redhat.com>
References: <1310078011-15504-1-git-send-email-agrover@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34235 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752631Ab1GIBTE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 8 Jul 2011 21:19:04 -0400
In-Reply-To: <1310078011-15504-1-git-send-email-agrover@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org

I came across these in the paren purge, but wanted to break them out in
a separate patchset so they didn't get lost in the sea of boringness that
those csets embody.

The first bit decrements np->np_exports outside the conditional, and
removes the double-negativity, for clarity.

The second bit removes the test for &cmd->se_cmd entirely, since if cmd
is valid, there's no way the test will ever fail.

Signed-off-by: Andy Grover <agrover@redhat.com>
---
 drivers/target/iscsi/iscsi_target.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index 6b92b5b..1645aab 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -445,7 +445,8 @@ int iscsit_del_np_comm(struct iscsi_np *np)
 int iscsit_del_np(struct iscsi_np *np)
 {
 	spin_lock_bh(&np->np_thread_lock);
-	if (!(--np->np_exports == 0)) {
+	np->np_exports--;
+	if (np->np_exports) {
 		spin_unlock_bh(&np->np_thread_lock);
 		return 0;
 	}
@@ -3941,8 +3942,7 @@ static void iscsit_release_commands_from_conn(struct iscsi_conn *conn)
 	 */
 	spin_lock_bh(&conn->cmd_lock);
 	list_for_each_entry_safe(cmd, cmd_tmp, &conn->conn_cmd_list, i_list) {
-		if (!(&cmd->se_cmd) ||
-		    !(cmd->se_cmd.se_cmd_flags & SCF_SE_LUN_CMD)) {
+		if (!(cmd->se_cmd.se_cmd_flags & SCF_SE_LUN_CMD)) {
 
 			list_del(&cmd->i_list);
 			spin_unlock_bh(&conn->cmd_lock);
-- 
1.7.1

