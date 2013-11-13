From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH 1/2] iscsi-target: Fix mutex_trylock usage in iscsit_increment_maxcmdsn
Date: Wed, 13 Nov 2013 02:11:42 +0000
Message-ID: <1384308703-10034-2-git-send-email-nab@daterainc.com>
References: <1384308703-10034-1-git-send-email-nab@daterainc.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1384308703-10034-1-git-send-email-nab@daterainc.com>
Sender: target-devel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Moussa Ba <moussaba@micron.com>, Or Gerlitz <ogerlitz@mellanox.com>, Mike Christie <michaelc@cs.wisc.edu>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch fixes a >= v3.10 regression bug with mutex_trylock() usage
within iscsit_increment_maxcmdsn(), that was originally added to allow
for a special case where ->cmdsn_mutex was already held from the
iscsit_execute_cmd() exception path for ib_isert.

When !mutex_trylock() was occuring under contention during normal RX/TX
process context codepaths, the bug was manifesting itself as the following
protocol error:

  Received CmdSN: 0x000fcbb7 is greater than MaxCmdSN: 0x000fcbb6, protocol error.
  Received CmdSN: 0x000fcbb8 is greater than MaxCmdSN: 0x000fcbb6, protocol error.

This patch simply avoids the direct ib_isert callback in lio_queue_status()
for the special iscsi_execute_cmd() exception cases, that allows the problematic
mutex_trylock() usage in iscsit_increment_maxcmdsn() to go away.

Reported-by: Moussa Ba <moussaba@micron.com>
Tested-by: Moussa Ba <moussaba@micron.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/iscsi/iscsi_target_configfs.c |    5 +++++
 drivers/target/iscsi/iscsi_target_device.c   |    6 +-----
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target_configfs.c b/drivers/target/iscsi/iscsi_target_configfs.c
index 1eec37c..fde3624 100644
--- a/drivers/target/iscsi/iscsi_target_configfs.c
+++ b/drivers/target/iscsi/iscsi_target_configfs.c
@@ -1790,6 +1790,11 @@ static int lio_queue_status(struct se_cmd *se_cmd)
 	struct iscsi_cmd *cmd = container_of(se_cmd, struct iscsi_cmd, se_cmd);
 
 	cmd->i_state = ISTATE_SEND_STATUS;
+
+	if (cmd->se_cmd.scsi_status || cmd->sense_reason) {
+		iscsit_add_cmd_to_response_queue(cmd, cmd->conn, cmd->i_state);
+		return 0;
+	}
 	cmd->conn->conn_transport->iscsit_queue_status(cmd->conn, cmd);
 
 	return 0;
diff --git a/drivers/target/iscsi/iscsi_target_device.c b/drivers/target/iscsi/iscsi_target_device.c
index 6c7a510..7087c73 100644
--- a/drivers/target/iscsi/iscsi_target_device.c
+++ b/drivers/target/iscsi/iscsi_target_device.c
@@ -58,11 +58,7 @@ void iscsit_increment_maxcmdsn(struct iscsi_cmd *cmd, struct iscsi_session *sess
 
 	cmd->maxcmdsn_inc = 1;
 
-	if (!mutex_trylock(&sess->cmdsn_mutex)) {
-		sess->max_cmd_sn += 1;
-		pr_debug("Updated MaxCmdSN to 0x%08x\n", sess->max_cmd_sn);
-		return;
-	}
+	mutex_lock(&sess->cmdsn_mutex);
 	sess->max_cmd_sn += 1;
 	pr_debug("Updated MaxCmdSN to 0x%08x\n", sess->max_cmd_sn);
 	mutex_unlock(&sess->cmdsn_mutex);
-- 
1.7.10.4
