From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 2/6] target: fix potential race window in target_sess_cmd_list_waiting()
Date: Mon, 22 Aug 2016 10:54:07 +0200
Message-ID: <1471856051-87398-3-git-send-email-hare@suse.de>
References: <1471856051-87398-1-git-send-email-hare@suse.de>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1471856051-87398-1-git-send-email-hare@suse.de>
Sender: target-devel-owner@vger.kernel.org
To: Nic Bellinger <nab@linux-iscsi.org>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, Martin Wilck <martin.wilck@suse.com>, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>
List-Id: linux-scsi@vger.kernel.org

target_sess_cmd_list_waiting() might hit on a condition where
the kref for the command is already 0, but the destructor has
not been called yet (or is stuck in waiting for a spin lock).
Rather than leaving the command on the list we should explicitly
remove it to avoid race issues later on.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/target/target_core_transport.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 2e1a6d8..ce136f0 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -2547,8 +2547,8 @@ int target_get_sess_cmd(struct se_cmd *se_cmd, bool ack_kref)
 	 * fabric acknowledgement that requires two target_put_sess_cmd()
 	 * invocations before se_cmd descriptor release.
 	 */
-	if (ack_kref)
-		kref_get(&se_cmd->cmd_kref);
+	if (ack_kref && !kref_get_unless_zero(&se_cmd->cmd_kref))
+		return -EINVAL;
 
 	spin_lock_irqsave(&se_sess->sess_cmd_lock, flags);
 	if (se_sess->sess_tearing_down) {
@@ -2627,7 +2627,7 @@ EXPORT_SYMBOL(target_put_sess_cmd);
  */
 void target_sess_cmd_list_set_waiting(struct se_session *se_sess)
 {
-	struct se_cmd *se_cmd;
+	struct se_cmd *se_cmd, *tmp_cmd;
 	unsigned long flags;
 	int rc;
 
@@ -2639,7 +2639,8 @@ void target_sess_cmd_list_set_waiting(struct se_session *se_sess)
 	se_sess->sess_tearing_down = 1;
 	list_splice_init(&se_sess->sess_cmd_list, &se_sess->sess_wait_list);
 
-	list_for_each_entry(se_cmd, &se_sess->sess_wait_list, se_cmd_list) {
+	list_for_each_entry_safe(se_cmd, tmp_cmd,
+				 &se_sess->sess_wait_list, se_cmd_list) {
 		rc = kref_get_unless_zero(&se_cmd->cmd_kref);
 		if (rc) {
 			spin_lock(&se_cmd->t_state_lock);
@@ -2648,7 +2649,8 @@ void target_sess_cmd_list_set_waiting(struct se_session *se_sess)
 				se_cmd->transport_state |= CMD_T_FABRIC_STOP;
 			}
 			spin_unlock(&se_cmd->t_state_lock);
-		}
+		} else
+			list_del_init(&se_cmd->se_cmd_list);
 	}
 
 	spin_unlock_irqrestore(&se_sess->sess_cmd_lock, flags);
-- 
1.8.5.6
