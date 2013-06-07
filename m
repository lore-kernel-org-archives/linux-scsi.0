From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 3/9] target: Remove legacy t_fe_count + avoid t_state_lock access in transport_put_cmd
Date: Fri,  7 Jun 2013 21:34:18 +0000
Message-ID: <1370640864-15568-4-git-send-email-nab@linux-iscsi.org>
References: <1370640864-15568-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:48590 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755813Ab3FGVrx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Jun 2013 17:47:53 -0400
In-Reply-To: <1370640864-15568-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Roland Dreier <roland@kernel.org>, Kent Overstreet <koverstreet@google.com>, Asias He <asias@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, Or Gerlitz <ogerlitz@mellanox.com>, Moussa Ba <moussaba@micron.com>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch removes legacy se_cmd->t_fe_count usage in order to avoid
se_cmd->t_state_lock access within transport_put_cmd() during normal
fast path se_cmd descriptor release.

Also drop the left-over parameter usage within core_tmr_handle_tas_abort()

Cc: Christoph Hellwig <hch@lst.de>
Cc: Roland Dreier <roland@kernel.org>
Cc: Kent Overstreet <koverstreet@google.com>
Cc: Or Gerlitz <ogerlitz@mellanox.com>
Cc: Moussa Ba <moussaba@micron.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_tmr.c       |   12 ++----------
 drivers/target/target_core_transport.c |   19 -------------------
 include/target/target_core_base.h      |    1 -
 3 files changed, 2 insertions(+), 30 deletions(-)

diff --git a/drivers/target/target_core_tmr.c b/drivers/target/target_core_tmr.c
index d0b4dd9..0d7cacb 100644
--- a/drivers/target/target_core_tmr.c
+++ b/drivers/target/target_core_tmr.c
@@ -85,13 +85,8 @@ void core_tmr_release_req(
 static void core_tmr_handle_tas_abort(
 	struct se_node_acl *tmr_nacl,
 	struct se_cmd *cmd,
-	int tas,
-	int fe_count)
+	int tas)
 {
-	if (!fe_count) {
-		transport_cmd_finish_abort(cmd, 1);
-		return;
-	}
 	/*
 	 * TASK ABORTED status (TAS) bit support
 	*/
@@ -253,7 +248,6 @@ static void core_tmr_drain_state_list(
 	LIST_HEAD(drain_task_list);
 	struct se_cmd *cmd, *next;
 	unsigned long flags;
-	int fe_count;
 
 	/*
 	 * Complete outstanding commands with TASK_ABORTED SAM status.
@@ -329,12 +323,10 @@ static void core_tmr_drain_state_list(
 		spin_lock_irqsave(&cmd->t_state_lock, flags);
 		target_stop_cmd(cmd, &flags);
 
-		fe_count = atomic_read(&cmd->t_fe_count);
-
 		cmd->transport_state |= CMD_T_ABORTED;
 		spin_unlock_irqrestore(&cmd->t_state_lock, flags);
 
-		core_tmr_handle_tas_abort(tmr_nacl, cmd, tas, fe_count);
+		core_tmr_handle_tas_abort(tmr_nacl, cmd, tas);
 	}
 }
 
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index d062878..daa7aa8 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -1967,24 +1967,8 @@ static void transport_release_cmd(struct se_cmd *cmd)
  */
 static void transport_put_cmd(struct se_cmd *cmd)
 {
-	unsigned long flags;
-
-	spin_lock_irqsave(&cmd->t_state_lock, flags);
-	if (atomic_read(&cmd->t_fe_count) &&
-	    !atomic_dec_and_test(&cmd->t_fe_count)) {
-		spin_unlock_irqrestore(&cmd->t_state_lock, flags);
-		return;
-	}
-
-	if (cmd->transport_state & CMD_T_DEV_ACTIVE) {
-		cmd->transport_state &= ~CMD_T_DEV_ACTIVE;
-		target_remove_from_state_list(cmd);
-	}
-	spin_unlock_irqrestore(&cmd->t_state_lock, flags);
-
 	transport_free_pages(cmd);
 	transport_release_cmd(cmd);
-	return;
 }
 
 void *transport_kmap_data_sg(struct se_cmd *cmd)
@@ -2100,9 +2084,6 @@ transport_generic_new_cmd(struct se_cmd *cmd)
 		if (ret < 0)
 			return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
 	}
-
-	atomic_inc(&cmd->t_fe_count);
-
 	/*
 	 * If this command is not a write we can execute it right here,
 	 * for write buffers we need to notify the fabric driver first
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index e773dfa..3b337b9 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -458,7 +458,6 @@ struct se_cmd {
 	unsigned char		*t_task_cdb;
 	unsigned char		__t_task_cdb[TCM_MAX_COMMAND_SIZE];
 	unsigned long long	t_task_lba;
-	atomic_t		t_fe_count;
 	unsigned int		transport_state;
 #define CMD_T_ABORTED		(1 << 0)
 #define CMD_T_ACTIVE		(1 << 1)
-- 
1.7.2.5

