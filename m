From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 01/14] target: Fix for hang of Ordered task in TCM
Date: Wed,  1 Jun 2016 21:48:34 +0000
Message-ID: <1464817727-9125-2-git-send-email-nab@linux-iscsi.org>
References: <1464817727-9125-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:53450 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752686AbcFAVtc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Jun 2016 17:49:32 -0400
In-Reply-To: <1464817727-9125-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Jens Axboe <axboe@fb.com>, Christoph Hellwig <hch@lst.de>, Martin Petersen <martin.petersen@oracle.com>, Sagi Grimberg <sagi@grimberg.me>, Hannes Reinecke <hare@suse.de>, Mike Christie <michaelc@cs.wisc.edu>, Dave B Minturn <dave.b.minturn@intel.com>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

If a command with a Simple task attribute is failed due to a Unit
Attention, then a subsequent command with an Ordered task attribute
will hang forever.  The reason for this is that the Unit Attention
status is checked for in target_setup_cmd_from_cdb, before the call
to target_execute_cmd, which calls target_handle_task_attr, which
in turn increments dev->simple_cmds.

However, transport_generic_request_failure still calls
transport_complete_task_attr, which will decrement dev->simple_cmds.
In this case, simple_cmds is now -1.  So when a command with the
Ordered task attribute is sent, target_handle_task_attr sees that
dev->simple_cmds is not 0, so it decides it can't execute the
command until all the (nonexistent) Simple commands have completed.

Reported-by: Michael Cyr <mikecyr@linux.vnet.ibm.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_internal.h  |  1 +
 drivers/target/target_core_sbc.c       |  2 +-
 drivers/target/target_core_transport.c | 45 ++++++++++++++++++++++++++--------
 include/target/target_core_fabric.h    |  1 -
 4 files changed, 37 insertions(+), 12 deletions(-)

diff --git a/drivers/target/target_core_internal.h b/drivers/target/target_core_internal.h
index fc91e85..e2c970a 100644
--- a/drivers/target/target_core_internal.h
+++ b/drivers/target/target_core_internal.h
@@ -146,6 +146,7 @@ sense_reason_t	target_cmd_size_check(struct se_cmd *cmd, unsigned int size);
 void	target_qf_do_work(struct work_struct *work);
 bool	target_check_wce(struct se_device *dev);
 bool	target_check_fua(struct se_device *dev);
+void	__target_execute_cmd(struct se_cmd *, bool);
 
 /* target_core_stat.c */
 void	target_stat_setup_dev_default_groups(struct se_device *);
diff --git a/drivers/target/target_core_sbc.c b/drivers/target/target_core_sbc.c
index a9057aa..04f616b 100644
--- a/drivers/target/target_core_sbc.c
+++ b/drivers/target/target_core_sbc.c
@@ -602,7 +602,7 @@ static sense_reason_t compare_and_write_callback(struct se_cmd *cmd, bool succes
 	cmd->transport_state |= CMD_T_ACTIVE|CMD_T_BUSY|CMD_T_SENT;
 	spin_unlock_irq(&cmd->t_state_lock);
 
-	__target_execute_cmd(cmd);
+	__target_execute_cmd(cmd, false);
 
 	kfree(buf);
 	return ret;
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 5ab3967..614ef3f 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -1761,20 +1761,45 @@ queue_full:
 }
 EXPORT_SYMBOL(transport_generic_request_failure);
 
-void __target_execute_cmd(struct se_cmd *cmd)
+void __target_execute_cmd(struct se_cmd *cmd, bool do_checks)
 {
 	sense_reason_t ret;
 
-	if (cmd->execute_cmd) {
-		ret = cmd->execute_cmd(cmd);
-		if (ret) {
-			spin_lock_irq(&cmd->t_state_lock);
-			cmd->transport_state &= ~(CMD_T_BUSY|CMD_T_SENT);
-			spin_unlock_irq(&cmd->t_state_lock);
+	if (!cmd->execute_cmd) {
+		ret = TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
+		goto err;
+	}
+	if (do_checks) {
+		/*
+		 * Check for an existing UNIT ATTENTION condition after
+		 * target_handle_task_attr() has done SAM task attr
+		 * checking, and possibly have already defered execution
+		 * out to target_restart_delayed_cmds() context.
+		 */
+		ret = target_scsi3_ua_check(cmd);
+		if (ret)
+			goto err;
 
-			transport_generic_request_failure(cmd, ret);
+		ret = target_alua_state_check(cmd);
+		if (ret)
+			goto err;
+
+		ret = target_check_reservation(cmd);
+		if (ret) {
+			cmd->scsi_status = SAM_STAT_RESERVATION_CONFLICT;
+			goto err;
 		}
 	}
+
+	ret = cmd->execute_cmd(cmd);
+	if (!ret)
+		return;
+err:
+	spin_lock_irq(&cmd->t_state_lock);
+	cmd->transport_state &= ~(CMD_T_BUSY|CMD_T_SENT);
+	spin_unlock_irq(&cmd->t_state_lock);
+
+	transport_generic_request_failure(cmd, ret);
 }
 
 static int target_write_prot_action(struct se_cmd *cmd)
@@ -1899,7 +1924,7 @@ void target_execute_cmd(struct se_cmd *cmd)
 		return;
 	}
 
-	__target_execute_cmd(cmd);
+	__target_execute_cmd(cmd, true);
 }
 EXPORT_SYMBOL(target_execute_cmd);
 
@@ -1923,7 +1948,7 @@ static void target_restart_delayed_cmds(struct se_device *dev)
 		list_del(&cmd->se_delayed_node);
 		spin_unlock(&dev->delayed_cmd_lock);
 
-		__target_execute_cmd(cmd);
+		__target_execute_cmd(cmd, true);
 
 		if (cmd->sam_task_attr == TCM_ORDERED_TAG)
 			break;
diff --git a/include/target/target_core_fabric.h b/include/target/target_core_fabric.h
index de44462..5cd6faa 100644
--- a/include/target/target_core_fabric.h
+++ b/include/target/target_core_fabric.h
@@ -163,7 +163,6 @@ int	core_tmr_alloc_req(struct se_cmd *, void *, u8, gfp_t);
 void	core_tmr_release_req(struct se_tmr_req *);
 int	transport_generic_handle_tmr(struct se_cmd *);
 void	transport_generic_request_failure(struct se_cmd *, sense_reason_t);
-void	__target_execute_cmd(struct se_cmd *);
 int	transport_lookup_tmr_lun(struct se_cmd *, u64);
 void	core_allocate_nexus_loss_ua(struct se_node_acl *acl);
 
-- 
1.9.1

