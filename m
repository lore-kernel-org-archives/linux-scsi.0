From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 037/103] target: Rename list_heads that are nodes in struct se_cmd to "*_node"
Date: Thu, 21 Jul 2011 00:07:49 -0700
Message-ID: <1311232135-6653-38-git-send-email-nab@linux-iscsi.org>
References: <1311232135-6653-32-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nm19.access.bullet.mail.sp2.yahoo.com ([98.139.44.146]:25497
	"HELO nm19.access.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751003Ab1GUHD1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 21 Jul 2011 03:03:27 -0400
In-Reply-To: <1311232135-6653-32-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Andy Grover <agrover@redhat.com>

From: Andy Grover <agrover@redhat.com>

This just help make it clear that se_cmd is being placed on lots of lists,
it doesn't have any list heads itself.

Signed-off-by: Andy Grover <agrover@redhat.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_device.c    |    2 +-
 drivers/target/target_core_transport.c |   26 +++++++++++++-------------
 include/target/target_core_base.h      |    6 +++---
 3 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index c7b9ef7..c8d4654 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -164,7 +164,7 @@ int transport_lookup_cmd_lun(struct se_cmd *se_cmd, u32 unpacked_lun)
 	 * for tracking state of struct se_cmds during LUN shutdown events.
 	 */
 	spin_lock_irqsave(&se_lun->lun_cmd_lock, flags);
-	list_add_tail(&se_cmd->se_lun_list, &se_lun->lun_cmd_list);
+	list_add_tail(&se_cmd->se_lun_node, &se_lun->lun_cmd_list);
 	atomic_set(&se_cmd->t_task.transport_lun_active, 1);
 	spin_unlock_irqrestore(&se_lun->lun_cmd_lock, flags);
 
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 9b76d33..bd445ff 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -722,7 +722,7 @@ static void transport_lun_remove_cmd(struct se_cmd *cmd)
 check_lun:
 	spin_lock_irqsave(&lun->lun_cmd_lock, flags);
 	if (atomic_read(&cmd->t_task.transport_lun_active)) {
-		list_del(&cmd->se_lun_list);
+		list_del(&cmd->se_lun_node);
 		atomic_set(&cmd->t_task.transport_lun_active, 0);
 #if 0
 		printk(KERN_INFO "Removed ITT: 0x%08x from LUN LIST[%d]\n"
@@ -1704,9 +1704,9 @@ void transport_init_se_cmd(
 	int task_attr,
 	unsigned char *sense_buffer)
 {
-	INIT_LIST_HEAD(&cmd->se_lun_list);
-	INIT_LIST_HEAD(&cmd->se_delayed_list);
-	INIT_LIST_HEAD(&cmd->se_ordered_list);
+	INIT_LIST_HEAD(&cmd->se_lun_node);
+	INIT_LIST_HEAD(&cmd->se_delayed_node);
+	INIT_LIST_HEAD(&cmd->se_ordered_node);
 
 	INIT_LIST_HEAD(&cmd->t_task.t_task_list);
 	init_completion(&cmd->t_task.transport_lun_fe_stop_comp);
@@ -2377,7 +2377,7 @@ static inline int transport_execute_task_attr(struct se_cmd *cmd)
 		return 1;
 	} else if (cmd->sam_task_attr == MSG_ORDERED_TAG) {
 		spin_lock(&cmd->se_dev->ordered_cmd_lock);
-		list_add_tail(&cmd->se_ordered_list,
+		list_add_tail(&cmd->se_ordered_node,
 				&cmd->se_dev->ordered_cmd_list);
 		spin_unlock(&cmd->se_dev->ordered_cmd_lock);
 
@@ -2414,7 +2414,7 @@ static inline int transport_execute_task_attr(struct se_cmd *cmd)
 		 */
 		spin_lock(&cmd->se_dev->delayed_cmd_lock);
 		cmd->se_cmd_flags |= SCF_DELAYED_CMD_FROM_SAM_ATTR;
-		list_add_tail(&cmd->se_delayed_list,
+		list_add_tail(&cmd->se_delayed_node,
 				&cmd->se_dev->delayed_cmd_list);
 		spin_unlock(&cmd->se_dev->delayed_cmd_lock);
 
@@ -3652,7 +3652,7 @@ static void transport_complete_task_attr(struct se_cmd *cmd)
 			cmd->se_ordered_id);
 	} else if (cmd->sam_task_attr == MSG_ORDERED_TAG) {
 		spin_lock(&dev->ordered_cmd_lock);
-		list_del(&cmd->se_ordered_list);
+		list_del(&cmd->se_ordered_node);
 		atomic_dec(&dev->dev_ordered_sync);
 		smp_mb__after_atomic_dec();
 		spin_unlock(&dev->ordered_cmd_lock);
@@ -3668,9 +3668,9 @@ static void transport_complete_task_attr(struct se_cmd *cmd)
 	 */
 	spin_lock(&dev->delayed_cmd_lock);
 	list_for_each_entry_safe(cmd_p, cmd_tmp,
-			&dev->delayed_cmd_list, se_delayed_list) {
+			&dev->delayed_cmd_list, se_delayed_node) {
 
-		list_del(&cmd_p->se_delayed_list);
+		list_del(&cmd_p->se_delayed_node);
 		spin_unlock(&dev->delayed_cmd_lock);
 
 		DEBUG_STA("Calling add_tasks() for"
@@ -5232,10 +5232,10 @@ static void __transport_clear_lun_from_sessions(struct se_lun *lun)
 	 * Initiator Port.
 	 */
 	spin_lock_irqsave(&lun->lun_cmd_lock, lun_flags);
-	while (!list_empty_careful(&lun->lun_cmd_list)) {
-		cmd = list_entry(lun->lun_cmd_list.next,
-			struct se_cmd, se_lun_list);
-		list_del(&cmd->se_lun_list);
+	while (!list_empty(&lun->lun_cmd_list)) {
+		cmd = list_first_entry(&lun->lun_cmd_list,
+		       struct se_cmd, se_lun_node);
+		list_del(&cmd->se_lun_node);
 
 		atomic_set(&cmd->t_task.transport_lun_active, 0);
 		/*
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index 67d490f..c84afc3 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -523,9 +523,9 @@ struct se_cmd {
 	atomic_t                transport_sent;
 	/* Used for sense data */
 	void			*sense_buffer;
-	struct list_head	se_delayed_list;
-	struct list_head	se_ordered_list;
-	struct list_head	se_lun_list;
+	struct list_head	se_delayed_node;
+	struct list_head	se_ordered_node;
+	struct list_head	se_lun_node;
 	struct se_device      *se_dev;
 	struct se_dev_entry   *se_deve;
 	struct se_device	*se_obj_ptr;
-- 
1.7.6

