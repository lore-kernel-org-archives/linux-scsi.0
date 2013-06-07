From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 1/9] target: Add transport_cmd_check_stop write_pending bit
Date: Fri,  7 Jun 2013 21:34:16 +0000
Message-ID: <1370640864-15568-2-git-send-email-nab@linux-iscsi.org>
References: <1370640864-15568-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:48573 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751608Ab3FGVru (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Jun 2013 17:47:50 -0400
In-Reply-To: <1370640864-15568-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Roland Dreier <roland@kernel.org>, Kent Overstreet <koverstreet@google.com>, Asias He <asias@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, Or Gerlitz <ogerlitz@mellanox.com>, Moussa Ba <moussaba@micron.com>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch adds a new transport_cmd_check_stop() parameter for signaling
when TRANSPORT_WRITE_PENDING needs to be set.

This allows transport_generic_new_cmd() to avoid the extra lock acquire/release
of ->t_state_lock in the fast path for DMA_TO_DEVICE operations ahead of
transport_cmd_check_stop() + se_tfo->write_pending().

Cc: Christoph Hellwig <hch@lst.de>
Cc: Roland Dreier <roland@kernel.org>
Cc: Kent Overstreet <koverstreet@google.com>
Cc: Or Gerlitz <ogerlitz@mellanox.com>
Cc: Moussa Ba <moussaba@micron.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_transport.c |   19 +++++++++----------
 1 files changed, 9 insertions(+), 10 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 4a79336..15afa83 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -445,11 +445,15 @@ static void target_remove_from_state_list(struct se_cmd *cmd)
 	spin_unlock_irqrestore(&dev->execute_task_lock, flags);
 }
 
-static int transport_cmd_check_stop(struct se_cmd *cmd, bool remove_from_lists)
+static int transport_cmd_check_stop(struct se_cmd *cmd, bool remove_from_lists,
+				    bool write_pending)
 {
 	unsigned long flags;
 
 	spin_lock_irqsave(&cmd->t_state_lock, flags);
+	if (write_pending)
+		cmd->t_state = TRANSPORT_WRITE_PENDING;
+
 	/*
 	 * Determine if IOCTL context caller in requesting the stopping of this
 	 * command for LUN shutdown purposes.
@@ -514,7 +518,7 @@ static int transport_cmd_check_stop(struct se_cmd *cmd, bool remove_from_lists)
 
 static int transport_cmd_check_stop_to_fabric(struct se_cmd *cmd)
 {
-	return transport_cmd_check_stop(cmd, true);
+	return transport_cmd_check_stop(cmd, true, false);
 }
 
 static void transport_lun_remove_cmd(struct se_cmd *cmd)
@@ -2116,12 +2120,7 @@ transport_generic_new_cmd(struct se_cmd *cmd)
 		target_execute_cmd(cmd);
 		return 0;
 	}
-
-	spin_lock_irq(&cmd->t_state_lock);
-	cmd->t_state = TRANSPORT_WRITE_PENDING;
-	spin_unlock_irq(&cmd->t_state_lock);
-
-	transport_cmd_check_stop(cmd, false);
+	transport_cmd_check_stop(cmd, false, true);
 
 	ret = cmd->se_tfo->write_pending(cmd);
 	if (ret == -EAGAIN || ret == -ENOMEM)
@@ -2325,7 +2324,7 @@ static int transport_lun_wait_for_tasks(struct se_cmd *cmd, struct se_lun *lun)
 		pr_debug("ConfigFS ITT[0x%08x] - CMD_T_STOP, skipping\n",
 			 cmd->se_tfo->get_task_tag(cmd));
 		spin_unlock_irqrestore(&cmd->t_state_lock, flags);
-		transport_cmd_check_stop(cmd, false);
+		transport_cmd_check_stop(cmd, false, false);
 		return -EPERM;
 	}
 	cmd->transport_state |= CMD_T_LUN_FE_STOP;
@@ -2433,7 +2432,7 @@ check_cond:
 
 			spin_unlock_irqrestore(&cmd->t_state_lock,
 					cmd_flags);
-			transport_cmd_check_stop(cmd, false);
+			transport_cmd_check_stop(cmd, false, false);
 			complete(&cmd->transport_lun_fe_stop_comp);
 			spin_lock_irqsave(&lun->lun_cmd_lock, lun_flags);
 			continue;
-- 
1.7.2.5

