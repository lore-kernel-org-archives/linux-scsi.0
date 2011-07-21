From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 020/103] target: Make dev_queue_obj a member of se_device instead of a pointer
Date: Thu, 21 Jul 2011 00:04:56 -0700
Message-ID: <1311231979-6631-21-git-send-email-nab@linux-iscsi.org>
References: <1311231979-6631-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nm26-vm0.bullet.mail.bf1.yahoo.com ([98.139.213.74]:29125 "HELO
	nm26-vm0.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752132Ab1GUHGF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 21 Jul 2011 03:06:05 -0400
In-Reply-To: <1311231979-6631-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Andy Grover <agrover@redhat.com>

From: Andy Grover <agrover@redhat.com>

This saves us having to alloc/free memory for it separately from se_device.

Signed-off-by: Andy Grover <agrover@redhat.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_device.c    |    1 -
 drivers/target/target_core_tmr.c       |    2 +-
 drivers/target/target_core_transport.c |   52 +++++++++++++------------------
 include/target/target_core_base.h      |    2 +-
 4 files changed, 24 insertions(+), 33 deletions(-)

diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index c9a3f73..fe5474c 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -760,7 +760,6 @@ void se_release_device_for_hba(struct se_device *dev)
 	core_scsi3_free_all_registrations(dev);
 	se_release_vpd_for_dev(dev);
 
-	kfree(dev->dev_queue_obj);
 	kfree(dev);
 
 	return;
diff --git a/drivers/target/target_core_tmr.c b/drivers/target/target_core_tmr.c
index 179063d..7cd8e29 100644
--- a/drivers/target/target_core_tmr.c
+++ b/drivers/target/target_core_tmr.c
@@ -117,7 +117,7 @@ int core_tmr_lun_reset(
 	struct se_queue_req *qr, *qr_tmp;
 	struct se_node_acl *tmr_nacl = NULL;
 	struct se_portal_group *tmr_tpg = NULL;
-	struct se_queue_obj *qobj = dev->dev_queue_obj;
+	struct se_queue_obj *qobj = &dev->dev_queue_obj;
 	struct se_tmr_req *tmr_p, *tmr_pp;
 	struct se_task *task, *task_tmp;
 	unsigned long flags;
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 4bfa61f..7e0d69a 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -737,7 +737,7 @@ check_lun:
 
 void transport_cmd_finish_abort(struct se_cmd *cmd, int remove)
 {
-	transport_remove_cmd_from_queue(cmd, SE_DEV(cmd)->dev_queue_obj);
+	transport_remove_cmd_from_queue(cmd, &SE_DEV(cmd)->dev_queue_obj);
 	transport_lun_remove_cmd(cmd);
 
 	if (transport_cmd_check_stop_to_fabric(cmd))
@@ -748,7 +748,7 @@ void transport_cmd_finish_abort(struct se_cmd *cmd, int remove)
 
 void transport_cmd_finish_abort_tmr(struct se_cmd *cmd)
 {
-	transport_remove_cmd_from_queue(cmd, SE_DEV(cmd)->dev_queue_obj);
+	transport_remove_cmd_from_queue(cmd, &SE_DEV(cmd)->dev_queue_obj);
 
 	if (transport_cmd_check_stop_to_fabric(cmd))
 		return;
@@ -761,7 +761,7 @@ static int transport_add_cmd_to_queue(
 	int t_state)
 {
 	struct se_device *dev = cmd->se_dev;
-	struct se_queue_obj *qobj = dev->dev_queue_obj;
+	struct se_queue_obj *qobj = &dev->dev_queue_obj;
 	struct se_queue_req *qr;
 	unsigned long flags;
 
@@ -1213,15 +1213,15 @@ static void transport_release_all_cmds(struct se_device *dev)
 	int bug_out = 0, t_state;
 	unsigned long flags;
 
-	spin_lock_irqsave(&dev->dev_queue_obj->cmd_queue_lock, flags);
-	list_for_each_entry_safe(qr, qr_p, &dev->dev_queue_obj->qobj_list,
+	spin_lock_irqsave(&dev->dev_queue_obj.cmd_queue_lock, flags);
+	list_for_each_entry_safe(qr, qr_p, &dev->dev_queue_obj.qobj_list,
 				qr_list) {
 
 		cmd = qr->cmd;
 		t_state = qr->state;
 		list_del(&qr->qr_list);
 		kfree(qr);
-		spin_unlock_irqrestore(&dev->dev_queue_obj->cmd_queue_lock,
+		spin_unlock_irqrestore(&dev->dev_queue_obj.cmd_queue_lock,
 				flags);
 
 		printk(KERN_ERR "Releasing ITT: 0x%08x, i_state: %u,"
@@ -1232,9 +1232,9 @@ static void transport_release_all_cmds(struct se_device *dev)
 		transport_release_fe_cmd(cmd);
 		bug_out = 1;
 
-		spin_lock_irqsave(&dev->dev_queue_obj->cmd_queue_lock, flags);
+		spin_lock_irqsave(&dev->dev_queue_obj.cmd_queue_lock, flags);
 	}
-	spin_unlock_irqrestore(&dev->dev_queue_obj->cmd_queue_lock, flags);
+	spin_unlock_irqrestore(&dev->dev_queue_obj.cmd_queue_lock, flags);
 #if 0
 	if (bug_out)
 		BUG();
@@ -1563,15 +1563,8 @@ struct se_device *transport_add_device_to_core_hba(
 		printk(KERN_ERR "Unable to allocate memory for se_dev_t\n");
 		return NULL;
 	}
-	dev->dev_queue_obj = kzalloc(sizeof(struct se_queue_obj), GFP_KERNEL);
-	if (!(dev->dev_queue_obj)) {
-		printk(KERN_ERR "Unable to allocate memory for"
-				" dev->dev_queue_obj\n");
-		kfree(dev);
-		return NULL;
-	}
-	transport_init_queue_obj(dev->dev_queue_obj);
 
+	transport_init_queue_obj(&dev->dev_queue_obj);
 	dev->dev_flags		= device_flags;
 	dev->dev_status		|= TRANSPORT_DEVICE_DEACTIVATED;
 	dev->dev_ptr		= (void *) transport_dev;
@@ -1672,7 +1665,6 @@ out:
 
 	se_release_vpd_for_dev(dev);
 
-	kfree(dev->dev_queue_obj);
 	kfree(dev);
 
 	return NULL;
@@ -2405,7 +2397,7 @@ static inline int transport_tcq_window_closed(struct se_device *dev)
 	} else
 		msleep(PYX_TRANSPORT_WINDOW_CLOSED_WAIT_LONG);
 
-	wake_up_interruptible(&dev->dev_queue_obj->thread_wq);
+	wake_up_interruptible(&dev->dev_queue_obj.thread_wq);
 	return 0;
 }
 
@@ -3744,7 +3736,7 @@ static void transport_complete_task_attr(struct se_cmd *cmd)
 	 * to do the processing of the Active tasks.
 	 */
 	if (new_active_tasks != 0)
-		wake_up_interruptible(&dev->dev_queue_obj->thread_wq);
+		wake_up_interruptible(&dev->dev_queue_obj.thread_wq);
 }
 
 static void transport_generic_complete_ok(struct se_cmd *cmd)
@@ -5254,7 +5246,7 @@ static int transport_lun_wait_for_tasks(struct se_cmd *cmd, struct se_lun *lun)
 	atomic_set(&T_TASK(cmd)->transport_lun_fe_stop, 1);
 	spin_unlock_irqrestore(&T_TASK(cmd)->t_state_lock, flags);
 
-	wake_up_interruptible(&SE_DEV(cmd)->dev_queue_obj->thread_wq);
+	wake_up_interruptible(&SE_DEV(cmd)->dev_queue_obj.thread_wq);
 
 	ret = transport_stop_tasks_for_cmd(cmd);
 
@@ -5267,7 +5259,7 @@ static int transport_lun_wait_for_tasks(struct se_cmd *cmd, struct se_lun *lun)
 		DEBUG_TRANSPORT_S("ConfigFS: ITT[0x%08x] - stopped cmd....\n",
 				CMD_TFO(cmd)->get_task_tag(cmd));
 	}
-	transport_remove_cmd_from_queue(cmd, SE_DEV(cmd)->dev_queue_obj);
+	transport_remove_cmd_from_queue(cmd, &SE_DEV(cmd)->dev_queue_obj);
 
 	return 0;
 }
@@ -5480,7 +5472,7 @@ static void transport_generic_wait_for_tasks(
 
 	spin_unlock_irqrestore(&T_TASK(cmd)->t_state_lock, flags);
 
-	wake_up_interruptible(&SE_DEV(cmd)->dev_queue_obj->thread_wq);
+	wake_up_interruptible(&SE_DEV(cmd)->dev_queue_obj.thread_wq);
 
 	wait_for_completion(&T_TASK(cmd)->t_transport_stop_comp);
 
@@ -5898,7 +5890,7 @@ static void transport_processing_shutdown(struct se_device *dev)
 					cmd, TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE,
 					0);
 				transport_remove_cmd_from_queue(cmd,
-					SE_DEV(cmd)->dev_queue_obj);
+					&SE_DEV(cmd)->dev_queue_obj);
 
 				transport_lun_remove_cmd(cmd);
 				transport_cmd_check_stop(cmd, 1, 0);
@@ -5907,7 +5899,7 @@ static void transport_processing_shutdown(struct se_device *dev)
 					&T_TASK(cmd)->t_state_lock, flags);
 
 				transport_remove_cmd_from_queue(cmd,
-					SE_DEV(cmd)->dev_queue_obj);
+					&SE_DEV(cmd)->dev_queue_obj);
 
 				transport_lun_remove_cmd(cmd);
 
@@ -5927,7 +5919,7 @@ static void transport_processing_shutdown(struct se_device *dev)
 			transport_send_check_condition_and_sense(cmd,
 				TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE, 0);
 			transport_remove_cmd_from_queue(cmd,
-				SE_DEV(cmd)->dev_queue_obj);
+				&SE_DEV(cmd)->dev_queue_obj);
 
 			transport_lun_remove_cmd(cmd);
 			transport_cmd_check_stop(cmd, 1, 0);
@@ -5936,7 +5928,7 @@ static void transport_processing_shutdown(struct se_device *dev)
 				&T_TASK(cmd)->t_state_lock, flags);
 
 			transport_remove_cmd_from_queue(cmd,
-				SE_DEV(cmd)->dev_queue_obj);
+				&SE_DEV(cmd)->dev_queue_obj);
 			transport_lun_remove_cmd(cmd);
 
 			if (transport_cmd_check_stop(cmd, 1, 0))
@@ -5949,7 +5941,7 @@ static void transport_processing_shutdown(struct se_device *dev)
 	/*
 	 * Empty the struct se_device's struct se_cmd list.
 	 */
-	while ((qr = transport_get_qr_from_queue(dev->dev_queue_obj))) {
+	while ((qr = transport_get_qr_from_queue(&dev->dev_queue_obj))) {
 		cmd = qr->cmd;
 		state = qr->state;
 		kfree(qr);
@@ -5985,8 +5977,8 @@ static int transport_processing_thread(void *param)
 	set_user_nice(current, -20);
 
 	while (!kthread_should_stop()) {
-		ret = wait_event_interruptible(dev->dev_queue_obj->thread_wq,
-				atomic_read(&dev->dev_queue_obj->queue_cnt) ||
+		ret = wait_event_interruptible(dev->dev_queue_obj.thread_wq,
+				atomic_read(&dev->dev_queue_obj.queue_cnt) ||
 				kthread_should_stop());
 		if (ret < 0)
 			goto out;
@@ -6002,7 +5994,7 @@ static int transport_processing_thread(void *param)
 get_cmd:
 		__transport_execute_tasks(dev);
 
-		qr = transport_get_qr_from_queue(dev->dev_queue_obj);
+		qr = transport_get_qr_from_queue(&dev->dev_queue_obj);
 		if (!(qr))
 			continue;
 
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index 23dd6b7..112eb38 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -778,7 +778,7 @@ struct se_device {
 	struct se_obj		dev_obj;
 	struct se_obj		dev_access_obj;
 	struct se_obj		dev_export_obj;
-	struct se_queue_obj	*dev_queue_obj;
+	struct se_queue_obj	dev_queue_obj;
 	spinlock_t		delayed_cmd_lock;
 	spinlock_t		ordered_cmd_lock;
 	spinlock_t		execute_task_lock;
-- 
1.7.6

