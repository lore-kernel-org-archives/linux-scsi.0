From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH-v3 5/5] target: Drop legacy se_cmd->task_stop_comp + REQUEST_STOP usage
Date: Sat, 30 Jan 2016 05:37:02 +0000
Message-ID: <1454132222-29009-6-git-send-email-nab@daterainc.com>
References: <1454132222-29009-1-git-send-email-nab@daterainc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ob0-f176.google.com ([209.85.214.176]:33073 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752203AbcA3FkK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 30 Jan 2016 00:40:10 -0500
Received: by mail-ob0-f176.google.com with SMTP id is5so80504456obc.0
        for <linux-scsi@vger.kernel.org>; Fri, 29 Jan 2016 21:40:09 -0800 (PST)
In-Reply-To: <1454132222-29009-1-git-send-email-nab@daterainc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Quinn Tran <quinn.tran@qlogic.com>, Himanshu Madhani <himanshu.madhani@qlogic.com>, Sagi Grimberg <sagig@mellanox.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Andy Grover <agrover@redhat.com>, Mike Christie <mchristi@redhat.com>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

With CMD_T_FABRIC_STOP + se_cmd->cmd_wait_set usage in place,
go ahead and drop left-over CMD_T_REQUEST_STOP checks in
target_complete_cmd() and unused target_stop_cmd().

Cc: Quinn Tran <quinn.tran@qlogic.com>
Cc: Himanshu Madhani <himanshu.madhani@qlogic.com>
Cc: Sagi Grimberg <sagig@mellanox.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Andy Grover <agrover@redhat.com>
Cc: Mike Christie <mchristi@redhat.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_internal.h  |  1 -
 drivers/target/target_core_transport.c | 37 ----------------------------------
 include/target/target_core_base.h      |  4 ----
 3 files changed, 42 deletions(-)

diff --git a/drivers/target/target_core_internal.h b/drivers/target/target_core_internal.h
index dae0750c..db4412f 100644
--- a/drivers/target/target_core_internal.h
+++ b/drivers/target/target_core_internal.h
@@ -141,7 +141,6 @@ void	transport_dump_vpd_proto_id(struct t10_vpd *, unsigned char *, int);
 int	transport_dump_vpd_assoc(struct t10_vpd *, unsigned char *, int);
 int	transport_dump_vpd_ident_type(struct t10_vpd *, unsigned char *, int);
 int	transport_dump_vpd_ident(struct t10_vpd *, unsigned char *, int);
-bool	target_stop_cmd(struct se_cmd *cmd, unsigned long *flags);
 void	transport_clear_lun_ref(struct se_lun *);
 void	transport_send_task_abort(struct se_cmd *);
 sense_reason_t	target_cmd_size_check(struct se_cmd *cmd, unsigned int size);
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 36a70e0..463838d 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -693,15 +693,6 @@ void target_complete_cmd(struct se_cmd *cmd, u8 scsi_status)
 	}
 
 	/*
-	 * See if we are waiting to complete for an exception condition.
-	 */
-	if (cmd->transport_state & CMD_T_REQUEST_STOP) {
-		spin_unlock_irqrestore(&cmd->t_state_lock, flags);
-		complete(&cmd->task_stop_comp);
-		return;
-	}
-
-	/*
 	 * Check for case where an explicit ABORT_TASK has been received
 	 * and transport_wait_for_tasks() will be waiting for completion..
 	 */
@@ -1202,7 +1193,6 @@ void transport_init_se_cmd(
 	INIT_LIST_HEAD(&cmd->state_list);
 	init_completion(&cmd->t_transport_stop_comp);
 	init_completion(&cmd->cmd_wait_comp);
-	init_completion(&cmd->task_stop_comp);
 	spin_lock_init(&cmd->t_state_lock);
 	kref_init(&cmd->cmd_kref);
 	cmd->transport_state = CMD_T_DEV_ACTIVE;
@@ -1634,33 +1624,6 @@ int target_submit_tmr(struct se_cmd *se_cmd, struct se_session *se_sess,
 EXPORT_SYMBOL(target_submit_tmr);
 
 /*
- * If the cmd is active, request it to be stopped and sleep until it
- * has completed.
- */
-bool target_stop_cmd(struct se_cmd *cmd, unsigned long *flags)
-	__releases(&cmd->t_state_lock)
-	__acquires(&cmd->t_state_lock)
-{
-	bool was_active = false;
-
-	if (cmd->transport_state & CMD_T_BUSY) {
-		cmd->transport_state |= CMD_T_REQUEST_STOP;
-		spin_unlock_irqrestore(&cmd->t_state_lock, *flags);
-
-		pr_debug("cmd %p waiting to complete\n", cmd);
-		wait_for_completion(&cmd->task_stop_comp);
-		pr_debug("cmd %p stopped successfully\n", cmd);
-
-		spin_lock_irqsave(&cmd->t_state_lock, *flags);
-		cmd->transport_state &= ~CMD_T_REQUEST_STOP;
-		cmd->transport_state &= ~CMD_T_BUSY;
-		was_active = true;
-	}
-
-	return was_active;
-}
-
-/*
  * Handle SAM-esque emulation for generic transport request failures.
  */
 void transport_generic_request_failure(struct se_cmd *cmd,
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index 1579539e..d71a3ea 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -491,7 +491,6 @@ struct se_cmd {
 #define CMD_T_SENT		(1 << 4)
 #define CMD_T_STOP		(1 << 5)
 #define CMD_T_DEV_ACTIVE	(1 << 7)
-#define CMD_T_REQUEST_STOP	(1 << 8)
 #define CMD_T_BUSY		(1 << 9)
 #define CMD_T_TAS		(1 << 10)
 #define CMD_T_FABRIC_STOP	(1 << 11)
@@ -514,9 +513,6 @@ struct se_cmd {
 
 	struct list_head	state_list;
 
-	/* old task stop completion, consider merging with some of the above */
-	struct completion	task_stop_comp;
-
 	/* backend private data */
 	void			*priv;
 
-- 
1.9.1

