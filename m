From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 079/103] target: Make se_tmr_lock IRQ-safe
Date: Thu, 21 Jul 2011 00:12:02 -0700
Message-ID: <1311232346-6674-80-git-send-email-nab@linux-iscsi.org>
References: <1311232346-6674-63-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nm19.bullet.mail.bf1.yahoo.com ([98.139.212.178]:32372 "HELO
	nm19.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752193Ab1GUHI3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 21 Jul 2011 03:08:29 -0400
In-Reply-To: <1311232346-6674-63-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Roland Dreier <roland@purestorage.com>

From: Roland Dreier <roland@purestorage.com>

transport_lookup_tmr_lun() can be called from interrupt context and
therefore needs to use IRQ-safe spinlock functions.  Fix this up, and
to make the locking work, convert the other uses of se_tmr_lock to be
IRQ-disabling.

Signed-off-by: Roland Dreier <roland@purestorage.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_device.c |    9 +++++----
 drivers/target/target_core_tmr.c    |   16 ++++++++--------
 2 files changed, 13 insertions(+), 12 deletions(-)

diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index 6d93d96..f13e294 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -181,6 +181,7 @@ int transport_lookup_tmr_lun(struct se_cmd *se_cmd, u32 unpacked_lun)
 	struct se_lun *se_lun = NULL;
 	struct se_session *se_sess = se_cmd->se_sess;
 	struct se_tmr_req *se_tmr = se_cmd->se_tmr_req;
+	unsigned long flags;
 
 	if (unpacked_lun >= TRANSPORT_MAX_LUNS_PER_TPG) {
 		se_cmd->scsi_sense_reason = TCM_NON_EXISTENT_LUN;
@@ -188,7 +189,7 @@ int transport_lookup_tmr_lun(struct se_cmd *se_cmd, u32 unpacked_lun)
 		return -ENODEV;
 	}
 
-	spin_lock_irq(&se_sess->se_node_acl->device_list_lock);
+	spin_lock_irqsave(&se_sess->se_node_acl->device_list_lock, flags);
 	se_cmd->se_deve = &se_sess->se_node_acl->device_list[unpacked_lun];
 	deve = se_cmd->se_deve;
 
@@ -200,7 +201,7 @@ int transport_lookup_tmr_lun(struct se_cmd *se_cmd, u32 unpacked_lun)
 		se_cmd->orig_fe_lun = unpacked_lun;
 		se_cmd->se_orig_obj_ptr = se_cmd->se_dev;
 	}
-	spin_unlock_irq(&se_sess->se_node_acl->device_list_lock);
+	spin_unlock_irqrestore(&se_sess->se_node_acl->device_list_lock, flags);
 
 	if (!se_lun) {
 		printk(KERN_INFO "TARGET_CORE[%s]: Detected NON_EXISTENT_LUN"
@@ -223,9 +224,9 @@ int transport_lookup_tmr_lun(struct se_cmd *se_cmd, u32 unpacked_lun)
 	se_cmd->se_dev = se_lun->lun_se_dev;
 	se_tmr->tmr_dev = se_lun->lun_se_dev;
 
-	spin_lock(&se_tmr->tmr_dev->se_tmr_lock);
+	spin_lock_irqsave(&se_tmr->tmr_dev->se_tmr_lock, flags);
 	list_add_tail(&se_tmr->tmr_list, &se_tmr->tmr_dev->dev_tmr_list);
-	spin_unlock(&se_tmr->tmr_dev->se_tmr_lock);
+	spin_unlock_irqrestore(&se_tmr->tmr_dev->se_tmr_lock, flags);
 
 	return 0;
 }
diff --git a/drivers/target/target_core_tmr.c b/drivers/target/target_core_tmr.c
index 5c20de3..f1feea3 100644
--- a/drivers/target/target_core_tmr.c
+++ b/drivers/target/target_core_tmr.c
@@ -80,9 +80,9 @@ void core_tmr_release_req(
 		return;
 	}
 
-	spin_lock(&dev->se_tmr_lock);
+	spin_lock_irq(&dev->se_tmr_lock);
 	list_del(&tmr->tmr_list);
-	spin_unlock(&dev->se_tmr_lock);
+	spin_unlock_irq(&dev->se_tmr_lock);
 
 	kmem_cache_free(se_tmr_req_cache, tmr);
 }
@@ -154,7 +154,7 @@ int core_tmr_lun_reset(
 	 * Release all pending and outgoing TMRs aside from the received
 	 * LUN_RESET tmr..
 	 */
-	spin_lock(&dev->se_tmr_lock);
+	spin_lock_irq(&dev->se_tmr_lock);
 	list_for_each_entry_safe(tmr_p, tmr_pp, &dev->dev_tmr_list, tmr_list) {
 		/*
 		 * Allow the received TMR to return with FUNCTION_COMPLETE.
@@ -176,17 +176,17 @@ int core_tmr_lun_reset(
 		    (core_scsi3_check_cdb_abort_and_preempt(
 					preempt_and_abort_list, cmd) != 0))
 			continue;
-		spin_unlock(&dev->se_tmr_lock);
+		spin_unlock_irq(&dev->se_tmr_lock);
 
 		spin_lock_irqsave(&cmd->t_state_lock, flags);
 		if (!(atomic_read(&cmd->t_transport_active))) {
 			spin_unlock_irqrestore(&cmd->t_state_lock, flags);
-			spin_lock(&dev->se_tmr_lock);
+			spin_lock_irq(&dev->se_tmr_lock);
 			continue;
 		}
 		if (cmd->t_state == TRANSPORT_ISTATE_PROCESSING) {
 			spin_unlock_irqrestore(&cmd->t_state_lock, flags);
-			spin_lock(&dev->se_tmr_lock);
+			spin_lock_irq(&dev->se_tmr_lock);
 			continue;
 		}
 		DEBUG_LR("LUN_RESET: %s releasing TMR %p Function: 0x%02x,"
@@ -196,9 +196,9 @@ int core_tmr_lun_reset(
 		spin_unlock_irqrestore(&cmd->t_state_lock, flags);
 
 		transport_cmd_finish_abort_tmr(cmd);
-		spin_lock(&dev->se_tmr_lock);
+		spin_lock_irq(&dev->se_tmr_lock);
 	}
-	spin_unlock(&dev->se_tmr_lock);
+	spin_unlock_irq(&dev->se_tmr_lock);
 	/*
 	 * Complete outstanding struct se_task CDBs with TASK_ABORTED SAM status.
 	 * This is following sam4r17, section 5.6 Aborting commands, Table 38
-- 
1.7.6

