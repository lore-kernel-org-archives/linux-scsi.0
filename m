From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 13/37] target: simplify transport_put_cmd
Date: Fri, 14 Oct 2011 00:41:45 +0000
Message-ID: <1318552929-13341-14-git-send-email-nab@linux-iscsi.org>
References: <1318552929-13341-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:33413 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753350Ab1JNAoR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 13 Oct 2011 20:44:17 -0400
In-Reply-To: <1318552929-13341-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>

From: Christoph Hellwig <hch@lst.de>

Inline two simple functions only used by it, and replace a goto
with a simple if else construct.

Note that the code moved from transport_dec_and_check seems fairly
buggy - the atomic_read check on a variable where we'd do an
atomic_dec_and_test looks racy if we'll ever get someone increment
it without the lock held around them (which it looks like we do),
and not decrementing the second counter if the first one doesn't
hit zero also at least needs an explanation.

(nab: Fix transport_put_cmd breakage)

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_transport.c |   61 ++++++++++---------------------
 1 files changed, 20 insertions(+), 41 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index bee923f..a650100 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -3732,36 +3732,6 @@ static inline void transport_free_pages(struct se_cmd *cmd)
 	cmd->t_bidi_data_nents = 0;
 }
 
-static inline void transport_release_tasks(struct se_cmd *cmd)
-{
-	transport_free_dev_tasks(cmd);
-}
-
-static inline int transport_dec_and_check(struct se_cmd *cmd)
-{
-	unsigned long flags;
-
-	spin_lock_irqsave(&cmd->t_state_lock, flags);
-	if (atomic_read(&cmd->t_fe_count)) {
-		if (!atomic_dec_and_test(&cmd->t_fe_count)) {
-			spin_unlock_irqrestore(&cmd->t_state_lock,
-					flags);
-			return 1;
-		}
-	}
-
-	if (atomic_read(&cmd->t_se_count)) {
-		if (!atomic_dec_and_test(&cmd->t_se_count)) {
-			spin_unlock_irqrestore(&cmd->t_state_lock,
-					flags);
-			return 1;
-		}
-	}
-	spin_unlock_irqrestore(&cmd->t_state_lock, flags);
-
-	return 0;
-}
-
 /**
  * transport_put_cmd - release a reference to a command
  * @cmd:       command to release
@@ -3771,26 +3741,35 @@ static inline int transport_dec_and_check(struct se_cmd *cmd)
 static bool transport_put_cmd(struct se_cmd *cmd)
 {
 	unsigned long flags;
-
-	if (transport_dec_and_check(cmd))
-		return false;
+	int free_tasks = 0;
 
 	spin_lock_irqsave(&cmd->t_state_lock, flags);
-	if (!atomic_read(&cmd->transport_dev_active)) {
-		spin_unlock_irqrestore(&cmd->t_state_lock, flags);
-		goto free_pages;
+	if (atomic_read(&cmd->t_fe_count)) {
+		if (!atomic_dec_and_test(&cmd->t_fe_count))
+			goto out_busy;
+	}
+
+	if (atomic_read(&cmd->t_se_count)) {
+		if (!atomic_dec_and_test(&cmd->t_se_count))
+			goto out_busy;
+	}
+
+	if (atomic_read(&cmd->transport_dev_active)) {
+		atomic_set(&cmd->transport_dev_active, 0);
+		transport_all_task_dev_remove_state(cmd);
+		free_tasks = 1;
 	}
-	atomic_set(&cmd->transport_dev_active, 0);
-	transport_all_task_dev_remove_state(cmd);
 	spin_unlock_irqrestore(&cmd->t_state_lock, flags);
 
-	transport_release_tasks(cmd);
-	return true;
+	if (free_tasks != 0)
+		transport_free_dev_tasks(cmd);
 
-free_pages:
 	transport_free_pages(cmd);
 	transport_release_cmd(cmd);
 	return true;
+out_busy:
+	spin_unlock_irqrestore(&cmd->t_state_lock, flags);
+	return false;
 }
 
 static int
-- 
1.5.6.5

