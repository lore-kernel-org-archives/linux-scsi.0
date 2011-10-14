From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 12/37] target: simplify transport_generic_remove
Date: Fri, 14 Oct 2011 00:41:44 +0000
Message-ID: <1318552929-13341-13-git-send-email-nab@linux-iscsi.org>
References: <1318552929-13341-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:33407 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753350Ab1JNAoI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 13 Oct 2011 20:44:08 -0400
In-Reply-To: <1318552929-13341-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>

From: Christoph Hellwig <hch@lst.de>

Instead of duplicating the code from transport_release_fe_cmd re-use it by
allowing transport_release_fe_cmd to return wether it actually freed the
command or not.  Also rename transport_release_fe_cmd to transport_put_cmd
and add a kerneldoc comment for it to make the use case more obvious.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_transport.c |   33 +++++++++++++------------------
 1 files changed, 14 insertions(+), 19 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 49df097..bee923f 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -88,7 +88,7 @@ static u32 transport_allocate_tasks(struct se_cmd *cmd,
 static int transport_generic_get_mem(struct se_cmd *cmd);
 static int transport_generic_remove(struct se_cmd *cmd,
 		int session_reinstatement);
-static void transport_release_fe_cmd(struct se_cmd *cmd);
+static bool transport_put_cmd(struct se_cmd *cmd);
 static void transport_remove_cmd_from_queue(struct se_cmd *cmd,
 		struct se_queue_obj *qobj);
 static int transport_set_sense_codes(struct se_cmd *cmd, u8 asc, u8 ascq);
@@ -1074,7 +1074,7 @@ static void transport_release_all_cmds(struct se_device *dev)
 			cmd->se_tfo->get_task_tag(cmd),
 			cmd->se_tfo->get_cmd_state(cmd), t_state);
 
-		transport_release_fe_cmd(cmd);
+		transport_put_cmd(cmd);
 		bug_out = 1;
 
 		spin_lock_irqsave(&dev->dev_queue_obj.cmd_queue_lock, flags);
@@ -3762,12 +3762,18 @@ static inline int transport_dec_and_check(struct se_cmd *cmd)
 	return 0;
 }
 
-static void transport_release_fe_cmd(struct se_cmd *cmd)
+/**
+ * transport_put_cmd - release a reference to a command
+ * @cmd:       command to release
+ *
+ * This routine releases our reference to the command and frees it if possible.
+ */
+static bool transport_put_cmd(struct se_cmd *cmd)
 {
 	unsigned long flags;
 
 	if (transport_dec_and_check(cmd))
-		return;
+		return false;
 
 	spin_lock_irqsave(&cmd->t_state_lock, flags);
 	if (!atomic_read(&cmd->transport_dev_active)) {
@@ -3779,9 +3785,12 @@ static void transport_release_fe_cmd(struct se_cmd *cmd)
 	spin_unlock_irqrestore(&cmd->t_state_lock, flags);
 
 	transport_release_tasks(cmd);
+	return true;
+
 free_pages:
 	transport_free_pages(cmd);
 	transport_release_cmd(cmd);
+	return true;
 }
 
 static int
@@ -3789,7 +3798,7 @@ transport_generic_remove(struct se_cmd *cmd, int session_reinstatement)
 {
 	unsigned long flags;
 
-	if (transport_dec_and_check(cmd)) {
+	if (!transport_put_cmd(cmd)) {
 		if (session_reinstatement) {
 			spin_lock_irqsave(&cmd->t_state_lock, flags);
 			transport_all_task_dev_remove_state(cmd);
@@ -3799,20 +3808,6 @@ transport_generic_remove(struct se_cmd *cmd, int session_reinstatement)
 		return 1;
 	}
 
-	spin_lock_irqsave(&cmd->t_state_lock, flags);
-	if (!atomic_read(&cmd->transport_dev_active)) {
-		spin_unlock_irqrestore(&cmd->t_state_lock, flags);
-		goto free_pages;
-	}
-	atomic_set(&cmd->transport_dev_active, 0);
-	transport_all_task_dev_remove_state(cmd);
-	spin_unlock_irqrestore(&cmd->t_state_lock, flags);
-
-	transport_release_tasks(cmd);
-
-free_pages:
-	transport_free_pages(cmd);
-	transport_release_cmd(cmd);
 	return 0;
 }
 
-- 
1.5.6.5

