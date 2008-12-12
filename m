From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH] [Target_Core_Mod 11/12]: Update target_core_transport.c
	for new generic code
Date: Fri, 12 Dec 2008 01:36:16 -0800
Message-ID: <1229074576.4153.661.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp119.sbc.mail.sp1.yahoo.com ([69.147.64.92]:21404 "HELO
	smtp119.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757830AbYLLJgV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 Dec 2008 04:36:21 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Linux-iSCSI.org Target Dev" <linux-iscsi-target-dev@googlegroups.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>

>From 9f4c356b82b22367698120ebdf098c793e0bc388 Mon Sep 17 00:00:00 2001
From: Nicholas Bellinger <nab@linux-iscsi.org>
Date: Fri, 12 Dec 2008 01:04:38 -0800
Subject: [PATCH] [Target_Core_Mod]: Update target_core_transport.c for new generic code

This patch updates the core storage engine code to use generic (eg: non iSCSI)
specific naming and data structures.  It also renames and reenables support for

extern int core_tpg_persistent_reservation_check (se_cmd_t *);
extern int core_tpg_persistent_reservation_release (se_cmd_t *);
extern int core_tpg_persistent_reservation_reserve (se_cmd_t *);

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/lio-core/target_core_transport.c |  400 +++++++++++++++---------------
 drivers/lio-core/target_core_transport.h |   15 +-
 2 files changed, 208 insertions(+), 207 deletions(-)

diff --git a/drivers/lio-core/target_core_transport.c b/drivers/lio-core/target_core_transport.c
index aeb5b4a..aa74d6b 100644
--- a/drivers/lio-core/target_core_transport.c
+++ b/drivers/lio-core/target_core_transport.c
@@ -252,6 +252,7 @@ extern int init_se_global (void)
 		return(-1);
 	};
 
+	INIT_LIST_HEAD(&global->g_se_tpg_list);
 	spin_lock_init(&global->hba_lock);
 	spin_lock_init(&global->plugin_class_lock);
 
@@ -264,13 +265,12 @@ extern int init_se_global (void)
 		goto out;
 	}
 
-        if (!(global->hba_list = kmalloc((sizeof(se_hba_t) * ISCSI_MAX_GLOBAL_HBAS), GFP_KERNEL))) {
+        if (!(global->hba_list = kzalloc((sizeof(se_hba_t) * TRANSPORT_MAX_GLOBAL_HBAS), GFP_KERNEL))) {
                 TRACE_ERROR("Unable to allocate global->hba_list\n");
                 goto out;
         }
-        memset(global->hba_list, 0, (sizeof(se_hba_t) * ISCSI_MAX_GLOBAL_HBAS));
 
-        for (i = 0; i < ISCSI_MAX_GLOBAL_HBAS; i++) {
+        for (i = 0; i < TRANSPORT_MAX_GLOBAL_HBAS; i++) {
                 hba = &global->hba_list[i];
 
                 hba->hba_status |= HBA_STATUS_FREE;
@@ -283,12 +283,11 @@ extern int init_se_global (void)
 #endif
         }
 	
-        if (!(global->plugin_class_list = kmalloc((sizeof(se_plugin_class_t) * MAX_PLUGIN_CLASSES),
+        if (!(global->plugin_class_list = kzalloc((sizeof(se_plugin_class_t) * MAX_PLUGIN_CLASSES),
 			GFP_KERNEL))) {
                 TRACE_ERROR("Unable to allocate global->plugin_class_list\n");
                 goto out;
         }
-        memset(global->plugin_class_list, 0, (sizeof(se_plugin_class_t) * MAX_PLUGIN_CLASSES));
 
 	se_global = global;
 
@@ -334,36 +333,36 @@ extern int __iscsi_debug_dev (se_device_t *dev)
 	struct scsi_device *sd;
 
 	spin_lock(&se_global->debug_dev_lock);
-	switch (dev->iscsi_hba->type) {
+	switch (dev->se_hba->type) {
 	case PSCSI:
 		sd = (struct scsi_device *) dev->dev_ptr;
 		if (dev->dev_flags & DF_DEV_DEBUG) {
-			TRACE_ERROR("iSCSI_HBA[%u] - Failing PSCSI Task for %d/%d/%d\n",
-				dev->iscsi_hba->hba_id, sd->channel, sd->id, sd->lun);
+			TRACE_ERROR("HBA[%u] - Failing PSCSI Task for %d/%d/%d\n",
+				dev->se_hba->hba_id, sd->channel, sd->id, sd->lun);
 			fail_task = 1;
 		}
 		break;
 	case FILEIO:    
 		fd_dev = (fd_dev_t *) dev->dev_ptr;
 		if (dev->dev_flags & DF_DEV_DEBUG) {
-			TRACE_ERROR("iSCSI_HBA[%u] - Failing FILEIO Task for %u\n",
-				dev->iscsi_hba->hba_id, fd_dev->fd_dev_id);
+			TRACE_ERROR("HBA[%u] - Failing FILEIO Task for %u\n",
+				dev->se_hba->hba_id, fd_dev->fd_dev_id);
 			fail_task = 1;
 		}
 		break;
 	case VTAPE:    
 		vt_dev = (vt_dev_t *) dev->dev_ptr;
 		if (dev->dev_flags & DF_DEV_DEBUG) {
-			TRACE_ERROR("iSCSI_HBA[%u] - Failing VTAPE Task for %u\n",
-				dev->iscsi_hba->hba_id, vt_dev->vt_dev_id);
+			TRACE_ERROR("HBA[%u] - Failing VTAPE Task for %u\n",
+				dev->se_hba->hba_id, vt_dev->vt_dev_id);
 			fail_task = 1;
 		}
 		break;
 	case MEDIA_CHANGER:    
 		mc_dev = (mc_dev_t *) dev->dev_ptr;
 		if (dev->dev_flags & DF_DEV_DEBUG) {
-			TRACE_ERROR("iSCSI_HBA[%u] - Failing MEDIA_CHANGER Task for %u\n",
-				dev->iscsi_hba->hba_id, mc_dev->mc_dev_id);
+			TRACE_ERROR("HBA[%u] - Failing MEDIA_CHANGER Task for %u\n",
+				dev->se_hba->hba_id, mc_dev->mc_dev_id);
 			fail_task = 1;
 		}
 		break;
@@ -371,15 +370,15 @@ extern int __iscsi_debug_dev (se_device_t *dev)
 	case RAMDISK_MCP:
 		rd_dev = (rd_dev_t *) dev->dev_ptr;
 		if (dev->dev_flags & DF_DEV_DEBUG) {
-			TRACE_ERROR("iSCSI_HBA[%u] - Failing RAMDISK Task for %u\n",
-				dev->iscsi_hba->hba_id, rd_dev->rd_dev_id);
+			TRACE_ERROR("HBA[%u] - Failing RAMDISK Task for %u\n",
+				dev->se_hba->hba_id, rd_dev->rd_dev_id);
 			fail_task = 1;
 		}
 		break;
 	default:
 		if (dev->dev_flags & DF_DEV_DEBUG) {
-			TRACE_ERROR("iSCSI_HBA[%u] - Failing unknown Task\n",
-				dev->iscsi_hba->hba_id);
+			TRACE_ERROR("HBA[%u] - Failing unknown Task\n",
+				dev->se_hba->hba_id);
 			fail_task = 1;
 		}
 		break;
@@ -400,36 +399,36 @@ extern int iscsi_debug_dev (se_device_t *dev)
 	struct scsi_device *sd;
 
 	spin_lock_irq(&se_global->debug_dev_lock);
-	switch (dev->iscsi_hba->type) {
+	switch (dev->se_hba->type) {
 	case PSCSI:
 		sd = (struct scsi_device *) dev->dev_ptr;
 		if (dev->dev_flags & DF_DEV_DEBUG) {
-			TRACE_ERROR("iSCSI_HBA[%u] - Failing PSCSI Task for %d/%d/%d\n",
-				dev->iscsi_hba->hba_id, sd->channel, sd->id, sd->lun);
+			TRACE_ERROR("HBA[%u] - Failing PSCSI Task for %d/%d/%d\n",
+				dev->se_hba->hba_id, sd->channel, sd->id, sd->lun);
 			fail_task = 1;
 		}
 		break;
 	case FILEIO:
 		fd_dev = (fd_dev_t *) dev->dev_ptr;
 		if (dev->dev_flags & DF_DEV_DEBUG) {
-			TRACE_ERROR("iSCSI_HBA[%u] - Failing FILEIO Task for %u\n",
-				dev->iscsi_hba->hba_id, fd_dev->fd_dev_id);
+			TRACE_ERROR("HBA[%u] - Failing FILEIO Task for %u\n",
+				dev->se_hba->hba_id, fd_dev->fd_dev_id);
 			fail_task = 1;
 		}
 		break;
 	case VTAPE:
 		vt_dev = (vt_dev_t *) dev->dev_ptr;
 		if (dev->dev_flags & DF_DEV_DEBUG) {
-			TRACE_ERROR("iSCSI_HBA[%u] - Failing VTAPE Task for %u\n",
-				dev->iscsi_hba->hba_id, vt_dev->vt_dev_id);
+			TRACE_ERROR("HBA[%u] - Failing VTAPE Task for %u\n",
+				dev->se_hba->hba_id, vt_dev->vt_dev_id);
 			fail_task = 1;
 		}
 		break;
 	case MEDIA_CHANGER:
 		mc_dev = (mc_dev_t *) dev->dev_ptr;
 		if (dev->dev_flags & DF_DEV_DEBUG) {
-			TRACE_ERROR("iSCSI_HBA[%u] - Failing MEDIA_CHANGER Task for %u\n",
-				dev->iscsi_hba->hba_id, mc_dev->mc_dev_id);
+			TRACE_ERROR("HBA[%u] - Failing MEDIA_CHANGER Task for %u\n",
+				dev->se_hba->hba_id, mc_dev->mc_dev_id);
 			fail_task = 1;
 		}
 		break;
@@ -437,15 +436,15 @@ extern int iscsi_debug_dev (se_device_t *dev)
 	case RAMDISK_MCP:
 		rd_dev = (rd_dev_t *) dev->dev_ptr;
 		if (dev->dev_flags & DF_DEV_DEBUG) {
-			TRACE_ERROR("iSCSI_HBA[%u] - Failing RAMDISK Task for %u\n",
-				dev->iscsi_hba->hba_id, rd_dev->rd_dev_id);
+			TRACE_ERROR("HBA[%u] - Failing RAMDISK Task for %u\n",
+				dev->se_hba->hba_id, rd_dev->rd_dev_id);
 			fail_task = 1;
 		}
 		break;
 	default:
 		if (dev->dev_flags & DF_DEV_DEBUG) {
-			TRACE_ERROR("iSCSI_HBA[%u] - Failing unknown Task\n",
-				dev->iscsi_hba->hba_id);
+			TRACE_ERROR("HBA[%u] - Failing unknown Task\n",
+				dev->se_hba->hba_id);
 			fail_task = 1;
 		}
 		break;
@@ -572,7 +571,9 @@ extern void transport_check_dev_params_delim (char *ptr, char **cur)
 	return;
 }
 
-extern se_session_t *transport_register_session (se_node_acl_t *node_acl, void *fabric_sess)
+extern se_session_t *transport_allocate_session (
+	se_portal_group_t *se_tpg,
+	se_node_acl_t *node_acl)
 {
 	se_session_t *se_sess;
 
@@ -580,15 +581,37 @@ extern se_session_t *transport_register_session (se_node_acl_t *node_acl, void *
 		printk("Unable to allocate se_session_t from se_sess_cache\n");
 		return(ERR_PTR(-ENOMEM));
 	}
+	se_sess->se_tpg = se_tpg;
 	se_sess->node_acl = node_acl;
-	se_sess->fabric_sess_ptr = fabric_sess;
+
+	printk("TARGET_CORE[%s]: Allocated se_sess: %p\n",
+		TPG_TFO(se_tpg)->get_fabric_name(), se_sess);
 
 	return(se_sess);
 }
 
-extern void transport_release_session (se_session_t *se_sess)
+extern int transport_register_session (se_session_t *se_sess, void *fabric_sess)
+{
+	se_portal_group_t *se_tpg = se_sess->se_tpg;
+
+	se_sess->fabric_sess_ptr = fabric_sess;
+	printk("TARGET_CORE[%s]: Registered fabric_sess_ptr: %p\n",
+		TPG_TFO(se_tpg)->get_fabric_name(), se_sess->fabric_sess_ptr);
+
+	return(0);
+}
+
+extern void transport_deregister_session (se_session_t *se_sess)
 {
+	se_portal_group_t *se_tpg = se_sess->se_tpg;
+
+	se_sess->node_acl = NULL;
+	se_sess->fabric_sess_ptr = NULL;
 	kmem_cache_free(se_sess_cache, se_sess);
+
+	printk("TARGET_CORE[%s]: Deregistered fabric_sess\n",
+		TPG_TFO(se_tpg)->get_fabric_name());
+
 	return;
 }
 
@@ -605,7 +628,7 @@ static void transport_all_task_dev_remove_state (se_cmd_t *cmd)
 		return;
 
 	list_for_each_entry(task, &T_TASK(cmd)->t_task_list, t_list) {
-		if (!(dev = task->iscsi_dev))
+		if (!(dev = task->se_dev))
 			continue;
 		
 		if (atomic_read(&task->task_active))
@@ -735,11 +758,11 @@ static int transport_cmd_check_stop (se_cmd_t *cmd, int transport_off, u8 t_stat
 			transport_all_task_dev_remove_state(cmd);
 
 		/*
-		 * Clear se_cmd_t->iscsi_lun before the transport_off == 2 handoff
+		 * Clear se_cmd_t->se_lun before the transport_off == 2 handoff
 		 * to FE.
 		 */
 		if ((transport_off == 2) && !(cmd->se_cmd_flags & SCF_CMD_PASSTHROUGH))
-			cmd->iscsi_lun = NULL;
+			cmd->se_lun = NULL;
 		spin_unlock_irqrestore(&T_TASK(cmd)->t_state_lock, flags);
 		
 		up(&T_TASK(cmd)->t_transport_stop_sem);
@@ -751,11 +774,11 @@ static int transport_cmd_check_stop (se_cmd_t *cmd, int transport_off, u8 t_stat
 			transport_all_task_dev_remove_state(cmd);
 
 		/*
-		 * Clear se_cmd_t->iscsi_lun before the transport_off == 2 handoff
+		 * Clear se_cmd_t->se_lun before the transport_off == 2 handoff
 		 * to FE.
 		 */
 		if ((transport_off == 2) && !(cmd->se_cmd_flags & SCF_CMD_PASSTHROUGH))
-			cmd->iscsi_lun = NULL;
+			cmd->se_lun = NULL;
 		spin_unlock_irqrestore(&T_TASK(cmd)->t_state_lock, flags);
 
 		return(0);
@@ -794,7 +817,7 @@ static void transport_lun_remove_cmd (se_cmd_t *cmd)
 		atomic_set(&T_TASK(cmd)->transport_lun_active, 0);
 #if 0
 		TRACE_ERROR("Removed ITT: 0x%08x from LUN LIST[%d]\n"
-			CMD_TFO(cmd)->get_task_tag(cmd), lun->iscsi_lun);
+			CMD_TFO(cmd)->get_task_tag(cmd), lun->unpacked_lun);
 #endif
 	}
 	spin_unlock_irqrestore(&lun->lun_cmd_lock, flags);
@@ -835,7 +858,7 @@ extern int transport_add_cmd_to_queue (se_cmd_t *cmd, se_queue_obj_t *qobj, u8 t
 
 static int transport_add_cmd_to_dev_queue (se_cmd_t *cmd, u8 t_state)
 {
-	se_device_t *dev = cmd->iscsi_dev;
+	se_device_t *dev = cmd->se_dev;
 	
 	return(transport_add_cmd_to_queue(cmd, dev->dev_queue_obj, t_state));
 }
@@ -966,7 +989,7 @@ extern void transport_complete_cmd (se_cmd_t *cmd, int success)
 extern void transport_complete_task (se_task_t *task, int success)
 {
 	se_cmd_t *cmd = TASK_CMD(task);
-	se_device_t *dev = task->iscsi_dev;
+	se_device_t *dev = task->se_dev;
 	int t_state;
 	unsigned long flags;
 #if 0
@@ -1075,7 +1098,7 @@ check_task_stop:
 
 /*	__transport_add_task_to_execute_queue():
  *
- *	Called with iscsi_dev_t->execute_task_lock called.
+ *	Called with se_dev_t->execute_task_lock called.
  */
 static void __transport_add_task_to_execute_queue (se_task_t *task, se_device_t *dev)
 {
@@ -1146,7 +1169,7 @@ static void transport_add_tasks_to_state_queue (se_cmd_t *cmd)
 
 	spin_lock_irqsave(&T_TASK(cmd)->t_state_lock, flags);
 	list_for_each_entry(task, &T_TASK(cmd)->t_task_list, t_list) {
-		dev = task->iscsi_dev;
+		dev = task->se_dev;
 
 		if (atomic_read(&task->task_state_active))
 			continue;
@@ -1251,23 +1274,23 @@ static void transport_remove_task_from_execute_queue (se_task_t *task, se_device
  *
  *
  */
-extern int transport_check_device_tcq (se_device_t *dev, __u32 iscsi_lun, __u32 device_tcq)
+extern int transport_check_device_tcq (se_device_t *dev, __u32 unpacked_lun, __u32 device_tcq)
 {
 	if (device_tcq > dev->queue_depth) {
 		TRACE_ERROR("Attempting to set storage device queue depth to"
-		" %d while transport maximum is %d on iSCSI LUN: %u,"
-		" ignoring request\n", device_tcq, dev->queue_depth, iscsi_lun);
+		" %d while transport maximum is %d on LUN: %u,"
+		" ignoring request\n", device_tcq, dev->queue_depth, unpacked_lun);
 		return(-1);
 	} else if (!device_tcq) {
 		TRACE_ERROR("Attempting to set storage device queue depth to"
-			" 0 on iSCSI LUN: %u, ignoring request\n", iscsi_lun);
+			" 0 on LUN: %u, ignoring request\n", unpacked_lun);
 		return(-1);
 	}
 
 	dev->queue_depth = device_tcq;
 	atomic_set(&dev->depth_left, dev->queue_depth);
-	printk("Reset Device Queue Depth to %u for iSCSI Logical Unit Number:"
-			" %u\n", dev->queue_depth, iscsi_lun);
+	printk("Reset Device Queue Depth to %u for Logical Unit Number:"
+			" %u\n", dev->queue_depth, unpacked_lun);
 
 	return(0);
 }	
@@ -1281,17 +1304,17 @@ extern void transport_dump_dev_state (
 {
 	*bl += sprintf(b+*bl, "Status: ");
 	switch (dev->dev_status) {
-	case ISCSI_DEVICE_ACTIVATED:
+	case TRANSPORT_DEVICE_ACTIVATED:
 		*bl += sprintf(b+*bl, "ACTIVATED");
 		break;
-	case ISCSI_DEVICE_DEACTIVATED:
+	case TRANSPORT_DEVICE_DEACTIVATED:
 		*bl += sprintf(b+*bl, "DEACTIVATED");
                 break;
-	case ISCSI_DEVICE_SHUTDOWN:
+	case TRANSPORT_DEVICE_SHUTDOWN:
 		*bl += sprintf(b+*bl, "SHUTDOWN");
 		break;
-	case ISCSI_DEVICE_OFFLINE_ACTIVATED:
-	case ISCSI_DEVICE_OFFLINE_DEACTIVATED:
+	case TRANSPORT_DEVICE_OFFLINE_ACTIVATED:
+	case TRANSPORT_DEVICE_OFFLINE_DEACTIVATED:
 		*bl += sprintf(b+*bl, "OFFLINE");
 		break;
 	default:
@@ -1347,8 +1370,8 @@ extern void transport_dump_dev_info (
 		*bl += sprintf(b+*bl, "  FREE\n");
 
 	if (lun) {
-		*bl += sprintf(b+*bl, "        iSCSI Host ID: %u iSCSI LUN: %u",
-			dev->iscsi_hba->hba_id, lun->iscsi_lun);
+		*bl += sprintf(b+*bl, "        Core Host ID: %u LUN: %u",
+			dev->se_hba->hba_id, lun->unpacked_lun);
 		if (!(TRANSPORT(dev)->get_device_type(dev))) {
 			*bl += sprintf(b+*bl, "  Active Cmds: %d  Total Bytes: %llu\n",
 				atomic_read(&dev->active_cmds), total_bytes);
@@ -1357,11 +1380,11 @@ extern void transport_dump_dev_info (
 		}
 	} else {
 		if (!(TRANSPORT(dev)->get_device_type(dev))) {
-			*bl += sprintf(b+*bl, "        iSCSI Host ID: %u  Active Cmds: %d  Total Bytes: %llu\n",
-				dev->iscsi_hba->hba_id, atomic_read(&dev->active_cmds), total_bytes);
+			*bl += sprintf(b+*bl, "        Core Host ID: %u  Active Cmds: %d  Total Bytes: %llu\n",
+				dev->se_hba->hba_id, atomic_read(&dev->active_cmds), total_bytes);
 		} else {
-			*bl += sprintf(b+*bl, "        iSCSI Host ID: %u  Active Cmds: %d\n",
-				dev->iscsi_hba->hba_id, atomic_read(&dev->active_cmds));
+			*bl += sprintf(b+*bl, "        CoreI Host ID: %u  Active Cmds: %d\n",
+				dev->se_hba->hba_id, atomic_read(&dev->active_cmds));
 		}
 	}
 
@@ -1650,7 +1673,7 @@ extern se_device_t *transport_add_device_to_core_hba (
 	se_device_t  *dev;
 
 	if (!(dev = (se_device_t *) kmalloc(sizeof(se_device_t), GFP_KERNEL))) {
-		TRACE_ERROR("Unable to allocate memory for iscsi_dev_t\n");
+		TRACE_ERROR("Unable to allocate memory for se_dev_t\n");
 		return(NULL);
 	}
 	memset(dev, 0, sizeof (se_device_t));
@@ -1675,10 +1698,10 @@ extern se_device_t *transport_add_device_to_core_hba (
 	transport_init_queue_obj(dev->dev_status_queue_obj);
 	
 	dev->dev_flags		= device_flags;
-	dev->dev_status		|= ISCSI_DEVICE_DEACTIVATED;
+	dev->dev_status		|= TRANSPORT_DEVICE_DEACTIVATED;
 	dev->type		= transport->type;
 	dev->dev_ptr		= (void *) transport_dev;
-	dev->iscsi_hba		= hba;
+	dev->se_hba		= hba;
 	dev->se_sub_dev		= se_dev;
 	dev->transport		= transport;
 	atomic_set(&dev->active_cmds, 0);
@@ -1716,7 +1739,7 @@ extern se_device_t *transport_add_device_to_core_hba (
 	/*
 	 * Get this se_device_t's API from the device object plugin.
 	 */
-	if (!(dev->dev_obj_api = se_obj_get_api(ISCSI_LUN_TYPE_DEVICE)))
+	if (!(dev->dev_obj_api = se_obj_get_api(TRANSPORT_LUN_TYPE_DEVICE)))
 		goto out;
 	
 	transport_generic_activate_device(dev);
@@ -1847,8 +1870,8 @@ extern int transport_generic_claim_phydevice (se_device_t *dev)
 	if (dev->dev_flags & DF_CLAIMED_BLOCKDEV)
 		return(0);
 		
-	if (!(hba = dev->iscsi_hba)) {
-		TRACE_ERROR("se_device_t->iscsi_hba is NULL!\n");
+	if (!(hba = dev->se_hba)) {
+		TRACE_ERROR("se_device_t->se_hba is NULL!\n");
 		return(-1);
 	}
 		
@@ -2193,13 +2216,14 @@ static int transport_generic_cmd_sequencer (se_cmd_t *, unsigned char *);
 extern void transport_device_setup_cmd (se_cmd_t *cmd)
 {
 	cmd->transport_add_cmd_to_queue = &transport_add_cmd_to_dev_queue;
-	cmd->iscsi_dev = ISCSI_LUN(cmd)->iscsi_dev;
+	cmd->se_dev = ISCSI_LUN(cmd)->se_dev;
 
 	return;
 }
 
 extern se_cmd_t *__transport_alloc_se_cmd (
 	struct target_core_fabric_ops *tfo,
+	se_session_t *se_sess,
 	void *fabric_cmd_ptr,
 	u32 data_length,
 	int data_direction)
@@ -2233,6 +2257,7 @@ extern se_cmd_t *__transport_alloc_se_cmd (
 	spin_lock_init(&T_TASK(cmd)->t_state_lock);
 
 	cmd->se_tfo = tfo;
+	cmd->se_sess = se_sess;
 	cmd->se_fabric_cmd_ptr = fabric_cmd_ptr;
 	cmd->data_length = data_length;
 	cmd->data_direction = data_direction;
@@ -2242,12 +2267,13 @@ extern se_cmd_t *__transport_alloc_se_cmd (
 
 extern se_cmd_t *transport_alloc_se_cmd (
 	struct target_core_fabric_ops *tfo_api,
+	se_session_t *se_sess,
 	void *fabric_cmd_ptr,
 	u32 data_length,
 	int data_direction)
 {
-	return(__transport_alloc_se_cmd(tfo_api, fabric_cmd_ptr, data_length,
-					data_direction));
+	return(__transport_alloc_se_cmd(tfo_api, se_sess, fabric_cmd_ptr,
+				data_length, data_direction));
 }
 
 EXPORT_SYMBOL(transport_alloc_se_cmd);
@@ -2294,10 +2320,10 @@ extern int transport_generic_allocate_tasks (
 	memcpy(T_TASK(cmd)->t_task_cdb, cdb, SCSI_CDB_SIZE);
 
 #ifdef SNMP_SUPPORT
-        spin_lock(&cmd->iscsi_lun->lun_sep_lock);
-        if (cmd->iscsi_lun->lun_sep)
-                cmd->iscsi_lun->lun_sep->sep_stats.cmd_pdus++;
-        spin_unlock(&cmd->iscsi_lun->lun_sep_lock);
+        spin_lock(&cmd->se_lun->lun_sep_lock);
+        if (cmd->se_lun->lun_sep)
+                cmd->se_lun->lun_sep->sep_stats.cmd_pdus++;
+        spin_unlock(&cmd->se_lun->lun_sep_lock);
 #endif /* SNMP_SUPPORT */
 
 	switch (non_data_cdb) {
@@ -2414,7 +2440,7 @@ EXPORT_SYMBOL(transport_generic_handle_data);
  */
 extern int transport_generic_handle_tmr (
 	se_cmd_t *cmd,
-	iscsi_tmr_req_t *req)
+	se_tmr_req_t *req)
 {
 	cmd->transport_add_cmd_to_queue(cmd, TRANSPORT_PROCESS_TMR);
 	return(0);
@@ -2445,7 +2471,7 @@ extern void transport_stop_tasks_for_cmd (se_cmd_t *cmd)
 		if (!atomic_read(&task->task_sent) &&
 		    !atomic_read(&task->task_active)) {
 			spin_unlock_irqrestore(&T_TASK(cmd)->t_state_lock, flags);
-			transport_remove_task_from_execute_queue(task, task->iscsi_dev);
+			transport_remove_task_from_execute_queue(task, task->se_dev);
 
 			DEBUG_TS("task_no[%d] - Removed from execute queue\n", task->task_no);
 			spin_lock_irqsave(&T_TASK(cmd)->t_state_lock, flags);
@@ -3497,7 +3523,7 @@ static void transport_nop_wait_for_tasks (se_cmd_t *, int, int);
 
 static inline u32 transport_get_sectors_6 (unsigned char *cdb, se_cmd_t *cmd, int *ret)
 {
-	se_device_t *dev = ISCSI_LUN(cmd)->iscsi_dev;
+	se_device_t *dev = ISCSI_LUN(cmd)->se_dev;
 	
 	/*
 	 * Assume TYPE_DISK for non se_device_t objects.
@@ -3522,7 +3548,7 @@ type_disk:
 
 static inline u32 transport_get_sectors_10 (unsigned char *cdb, se_cmd_t *cmd, int *ret)
 {
-	se_device_t *dev = ISCSI_LUN(cmd)->iscsi_dev;
+	se_device_t *dev = ISCSI_LUN(cmd)->se_dev;
 
 	/*
 	 * Assume TYPE_DISK for non se_device_t objects.
@@ -3549,7 +3575,7 @@ type_disk:
 
 static inline u32 transport_get_sectors_12 (unsigned char *cdb, se_cmd_t *cmd, int *ret)
 {
-	se_device_t *dev = ISCSI_LUN(cmd)->iscsi_dev;
+	se_device_t *dev = ISCSI_LUN(cmd)->se_dev;
 
 	/*
 	 * Assume TYPE_DISK for non se_device_t objects.
@@ -3576,7 +3602,7 @@ type_disk:
 
 static inline u32 transport_get_sectors_16 (unsigned char *cdb, se_cmd_t *cmd, int *ret)
 {
-	se_device_t *dev = ISCSI_LUN(cmd)->iscsi_dev;
+	se_device_t *dev = ISCSI_LUN(cmd)->se_dev;
 	
 	/*
 	 * Assume TYPE_DISK for non se_device_t objects.
@@ -3846,8 +3872,8 @@ extern int transport_generic_emulate_modesense (
 		buf[0] = (offset >> 8) & 0xff;
 		buf[1] = offset & 0xff;
 
-		if ((ISCSI_LUN(cmd)->lun_access & ISCSI_LUNFLAGS_READ_ONLY) ||
-		    (cmd->iscsi_deve && (cmd->iscsi_deve->lun_flags & ISCSI_LUNFLAGS_READ_ONLY)))
+		if ((ISCSI_LUN(cmd)->lun_access & TRANSPORT_LUNFLAGS_READ_ONLY) ||
+		    (cmd->se_deve && (cmd->se_deve->lun_flags & TRANSPORT_LUNFLAGS_READ_ONLY)))
 			transport_modesense_write_protect(&buf[3], type);
 
 		if ((offset + 2) > cmd->data_length)
@@ -3857,8 +3883,8 @@ extern int transport_generic_emulate_modesense (
 		offset -= 1;
 		buf[0] = offset & 0xff;
 
-		if ((ISCSI_LUN(cmd)->lun_access & ISCSI_LUNFLAGS_READ_ONLY) ||
-		    (cmd->iscsi_deve && (cmd->iscsi_deve->lun_flags & ISCSI_LUNFLAGS_READ_ONLY)))
+		if ((ISCSI_LUN(cmd)->lun_access & TRANSPORT_LUNFLAGS_READ_ONLY) ||
+		    (cmd->se_deve && (cmd->se_deve->lun_flags & TRANSPORT_LUNFLAGS_READ_ONLY)))
 			transport_modesense_write_protect(&buf[2], type);
 
 		if ((offset + 1) > cmd->data_length)
@@ -3902,7 +3928,7 @@ extern int transport_get_sense_data (se_cmd_t *cmd)
 		if (!task->task_sense)
 			continue;
 
-		if (!(dev = task->iscsi_dev))
+		if (!(dev = task->se_dev))
 			continue;
 
 		if (!TRANSPORT(dev)->get_sense_buffer) {
@@ -3923,7 +3949,7 @@ extern int transport_get_sense_data (se_cmd_t *cmd)
 		cmd->scsi_sense_length = TRANSPORT_SENSE_SEGMENT_LENGTH; /* Automatically padded */
 
 		PYXPRINT("HBA_[%u]_PLUG[%s]: Set SAM STATUS: 0x%02x\n",
-			dev->iscsi_hba->hba_id, TRANSPORT(dev)->name, cmd->scsi_status);
+			dev->se_hba->hba_id, TRANSPORT(dev)->name, cmd->scsi_status);
 
 		return(0);
 	}
@@ -4473,7 +4499,7 @@ static inline se_cmd_t *transport_alloc_passthrough_cmd (
         u32 data_length,
 	int data_direction)
 {
-        return(__transport_alloc_se_cmd(&passthrough_fabric_ops, NULL,
+        return(__transport_alloc_se_cmd(&passthrough_fabric_ops, NULL, NULL,
                 data_length, data_direction));
 }
 
@@ -4514,13 +4540,13 @@ extern se_cmd_t *transport_allocate_passthrough (
 	 * Simulate an iSCSI LUN entry need for passing SCSI CDBs into
 	 * se_cmd_t.
 	 */
-	if (!(cmd->iscsi_lun = kmalloc(sizeof(se_lun_t), GFP_KERNEL))) {
-		TRACE_ERROR("Unable to allocate cmd->iscsi_lun\n");
+	if (!(cmd->se_lun = kmalloc(sizeof(se_lun_t), GFP_KERNEL))) {
+		TRACE_ERROR("Unable to allocate cmd->se_lun\n");
 		goto fail;
 	}
-	memset(cmd->iscsi_lun, 0, sizeof(se_lun_t));
+	memset(cmd->se_lun, 0, sizeof(se_lun_t));
 
-	spin_lock_init(&cmd->iscsi_lun->lun_sep_lock);
+	spin_lock_init(&cmd->se_lun->lun_sep_lock);
 	ISCSI_LUN(cmd)->lun_type = obj_api->se_obj_type;
 	ISCSI_LUN(cmd)->lun_type_ptr = type_ptr;
 	ISCSI_LUN(cmd)->lun_obj_api = obj_api;
@@ -4528,7 +4554,7 @@ extern se_cmd_t *transport_allocate_passthrough (
 	cmd->se_orig_obj_api = obj_api;
 	cmd->se_orig_obj_ptr = type_ptr;
 	cmd->se_cmd_flags = se_cmd_flags;
-	ISCSI_LUN(cmd)->iscsi_dev = (se_device_t *) type_ptr;
+	ISCSI_LUN(cmd)->se_dev = (se_device_t *) type_ptr;
 
 	/*
 	 * Double check that the passed object is currently accepting CDBs
@@ -4540,9 +4566,9 @@ extern se_cmd_t *transport_allocate_passthrough (
 		}
 	}
 
-	ISCSI_LUN(cmd)->persistent_reservation_check = &iscsi_tpg_persistent_reservation_check;
-	ISCSI_LUN(cmd)->persistent_reservation_release = &iscsi_tpg_persistent_reservation_release;
-	ISCSI_LUN(cmd)->persistent_reservation_reserve = &iscsi_tpg_persistent_reservation_reserve;
+	ISCSI_LUN(cmd)->persistent_reservation_check = &core_tpg_persistent_reservation_check;
+	ISCSI_LUN(cmd)->persistent_reservation_release = &core_tpg_persistent_reservation_release;
+	ISCSI_LUN(cmd)->persistent_reservation_reserve = &core_tpg_persistent_reservation_reserve;
 	cmd->data_length = length;
 	cmd->data_direction = data_direction;
 	cmd->se_cmd_flags |= SCF_CMD_PASSTHROUGH;
@@ -4552,7 +4578,7 @@ extern se_cmd_t *transport_allocate_passthrough (
 
 	memset(&ti, 0, sizeof(se_transform_info_t));
 	ti.ti_data_length = cmd->data_length;
-	ti.ti_dev = ISCSI_LUN(cmd)->iscsi_dev;
+	ti.ti_dev = ISCSI_LUN(cmd)->se_dev;
 	ti.ti_se_cmd = cmd;
 	ti.se_obj_ptr = type_ptr;
 	ti.se_obj_api = ISCSI_LUN(cmd)->lun_obj_api;
@@ -4610,7 +4636,7 @@ fail:
 	if (T_TASK(cmd))
 		transport_release_tasks(cmd);
 	kfree(T_TASK(cmd));
-	kfree(cmd->iscsi_lun);
+	kfree(cmd->se_lun);
 	kfree(cmd);
 	
 	return(NULL);
@@ -4734,19 +4760,19 @@ extern void transport_generic_complete_ok (se_cmd_t *cmd)
 	switch (cmd->data_direction) {
 	case SE_DIRECTION_READ:
 #ifdef SNMP_SUPPORT
-		spin_lock(&cmd->iscsi_lun->lun_sep_lock);
+		spin_lock(&cmd->se_lun->lun_sep_lock);
 		if (ISCSI_LUN(cmd)->lun_sep)
 			ISCSI_LUN(cmd)->lun_sep->sep_stats.tx_data_octets += cmd->data_length;
-		spin_unlock(&cmd->iscsi_lun->lun_sep_lock);
+		spin_unlock(&cmd->se_lun->lun_sep_lock);
 #endif
 		CMD_TFO(cmd)->queue_data_in(cmd);
 		break;
 	case SE_DIRECTION_WRITE:
 #ifdef SNMP_SUPPORT
-		spin_lock(&cmd->iscsi_lun->lun_sep_lock);
+		spin_lock(&cmd->se_lun->lun_sep_lock);
 		if (ISCSI_LUN(cmd)->lun_sep)
 			ISCSI_LUN(cmd)->lun_sep->sep_stats.rx_data_octets += cmd->data_length;
-		spin_unlock(&cmd->iscsi_lun->lun_sep_lock);
+		spin_unlock(&cmd->se_lun->lun_sep_lock);
 #endif
 		/* Fall through for SE_DIRECTION_WRITE */
 	case SE_DIRECTION_NONE:
@@ -4778,10 +4804,10 @@ extern void transport_free_dev_tasks (se_cmd_t *cmd)
 		kfree(task->task_sg);
 		
 		spin_unlock_irqrestore(&T_TASK(cmd)->t_state_lock, flags);
-		if (task->iscsi_dev)
-			TRANSPORT(task->iscsi_dev)->free_task(task);
+		if (task->se_dev)
+			TRANSPORT(task->se_dev)->free_task(task);
 		else
-			TRACE_ERROR("task[%u] - task->iscsi_dev is NULL\n", task->task_no);
+			TRACE_ERROR("task[%u] - task->se_dev is NULL\n", task->task_no);
 		spin_lock_irqsave(&T_TASK(cmd)->t_state_lock, flags);
 		
 		list_del(&task->t_list);
@@ -4884,7 +4910,7 @@ extern void transport_release_fe_cmd (se_cmd_t *cmd)
 	transport_free_pages(cmd);
 
 	if (cmd->se_cmd_flags & SCF_CMD_PASSTHROUGH)
-		kfree(cmd->iscsi_lun);
+		kfree(cmd->se_lun);
 
 	kfree(T_TASK(cmd));
 	CMD_TFO(cmd)->release_cmd_direct(cmd);
@@ -4924,7 +4950,7 @@ release_cmd:
 		transport_release_cmd_to_pool(cmd);
 	else {
 		if (cmd->se_cmd_flags & SCF_CMD_PASSTHROUGH)
-			kfree(cmd->iscsi_lun);
+			kfree(cmd->se_lun);
 
 		CMD_TFO(cmd)->release_cmd_direct(cmd);
 		kfree(T_TASK(cmd));
@@ -5892,7 +5918,7 @@ static void transport_release_cmd_to_pool (se_cmd_t *cmd)
 	}
 #else
 	if (cmd->se_cmd_flags & SCF_CMD_PASSTHROUGH) 
-		kfree(cmd->iscsi_lun);
+		kfree(cmd->se_lun);
 
 	kfree(T_TASK(cmd));
 	/*
@@ -5918,23 +5944,8 @@ extern void transport_generic_free_cmd (
 	if (!(cmd->se_cmd_flags & SCF_SE_LUN_CMD) || !T_TASK(cmd))
 		transport_release_cmd_to_pool(cmd);
 	else {
-#warning FIXME: CMD_TFO(cmd)->dec_nacl_count() broken
-#if 0
-		iscsi_session_t *sess = (CONN(cmd)) ? CONN(cmd)->sess : cmd->sess;
-
-		if (!sess) {
-			TRACE_ERROR("Unable to locate iscsi_session_t\n");
-			BUG();
-		}
-		{
-		struct target_core_fabric_ops *iscsi_tf = target_core_get_iscsi_ops();
-
-		if (!(iscsi_tf))
-			BUG();
+		CMD_TFO(cmd)->dec_nacl_count(cmd->se_sess->node_acl, cmd);
 
-		iscsi_tf->dec_nacl_count(SESS_NODE_ACL(sess), cmd);
-		}
-#endif
 		if (ISCSI_LUN(cmd)) {
 #if 0
 			TRACE_ERROR("cmd: %p ITT: 0x%08x contains ISCSI_LUN(cmd)!!!\n",
@@ -6032,7 +6043,7 @@ extern void transport_clear_lun_from_sessions (se_lun_t *lun)
                  */
                 spin_lock(&T_TASK(cmd)->t_state_lock);
                 DEBUG_CLEAR_L("SE_LUN[%d] - Setting T_TASK(cmd)->transport"
-			"_lun_stop for  ITT: 0x%08x\n", ISCSI_LUN(cmd)->iscsi_lun,
+			"_lun_stop for  ITT: 0x%08x\n", ISCSI_LUN(cmd)->unpacked_lun,
 				CMD_TFO(cmd)->get_task_tag(cmd));
                 atomic_set(&T_TASK(cmd)->transport_lun_stop, 1);
                 spin_unlock(&T_TASK(cmd)->t_state_lock);
@@ -6051,7 +6062,7 @@ extern void transport_clear_lun_from_sessions (se_lun_t *lun)
                  * stop its context.
                  */
                 DEBUG_CLEAR_L("SE_LUN[%d] - ITT: 0x%08x before transport"
-			"_lun_wait_for_tasks()\n", ISCSI_LUN(cmd)->iscsi_lun,
+			"_lun_wait_for_tasks()\n", ISCSI_LUN(cmd)->unpacked_lun,
 			CMD_TFO(cmd)->get_task_tag(cmd));
 
                 if (transport_lun_wait_for_tasks(cmd, ISCSI_LUN(cmd)) < 0) {
@@ -6060,7 +6071,7 @@ extern void transport_clear_lun_from_sessions (se_lun_t *lun)
                 }
 
                 DEBUG_CLEAR_L("SE_LUN[%d] - ITT: 0x%08x after transport_lun"
-			"_wait_for_tasks(): SUCCESS\n", ISCSI_LUN(cmd)->iscsi_lun,
+			"_wait_for_tasks(): SUCCESS\n", ISCSI_LUN(cmd)->unpacked_lun,
 				CMD_TFO(cmd)->get_task_tag(cmd));
                 /*
                  * The Storage engine stopped this iscsi_cmd_t before it was
@@ -6077,7 +6088,7 @@ extern void transport_clear_lun_from_sessions (se_lun_t *lun)
                 spin_lock_irqsave(&T_TASK(cmd)->t_state_lock, flags);
                 if (atomic_read(&T_TASK(cmd)->transport_lun_fe_stop)) {
                         DEBUG_CLEAR_L("SE_LUN[%d] - Detected FE stop for"
-				" iscsi_cmd_t: %p ITT: 0x%08x\n", lun->iscsi_lun,
+				" iscsi_cmd_t: %p ITT: 0x%08x\n", lun->unpacked_lun,
 				cmd, CMD_TFO(cmd)->get_task_tag(cmd));
 
                         spin_unlock_irqrestore(&T_TASK(cmd)->t_state_lock, flags);
@@ -6088,7 +6099,7 @@ extern void transport_clear_lun_from_sessions (se_lun_t *lun)
                 atomic_set(&T_TASK(cmd)->transport_lun_stop, 0);
                 
                 DEBUG_CLEAR_L("SE_LUN[%d] - ITT: 0x%08x finished processing\n",
-                        lun->iscsi_lun, CMD_TFO(cmd)->get_task_tag(cmd));
+                        lun->unpacked_lun, CMD_TFO(cmd)->get_task_tag(cmd));
 
                 spin_unlock_irqrestore(&T_TASK(cmd)->t_state_lock, flags);
                 spin_lock_irqsave(&lun->lun_cmd_lock, flags);
@@ -6289,107 +6300,92 @@ after_reason:
 
 EXPORT_SYMBOL(iscsi_send_check_condition_and_sense);
 
-#warning FIXME: iscsi_tpg_persistent_reservation_check() is broken
-extern int iscsi_tpg_persistent_reservation_check (se_cmd_t *cmd)
+extern int core_tpg_persistent_reservation_check (se_cmd_t *cmd)
 {
+	se_lun_t *lun = cmd->se_lun;
+	se_session_t *sess = cmd->se_sess;
         int ret;
-#if 0
-        iscsi_conn_t *conn = CONN(cmd);
-        se_lun_t *lun = ISCSI_LUN(cmd);
-
-        if (!CONN(cmd))
-                return(0);
 
         spin_lock(&lun->lun_reservation_lock);
-        if (!lun->lun_reserved_node_acl) {
+        if (!lun->lun_reserved_node_acl || !sess) {
                 spin_unlock(&lun->lun_reservation_lock);
                 return(0);
         }
-        ret = (lun->lun_reserved_node_acl != SESS(conn)->node_acl) ? -1 : 0;
+        ret = (lun->lun_reserved_node_acl != sess->node_acl) ? -1 : 0;
         spin_unlock(&lun->lun_reservation_lock);
-#else
-	printk("iscsi_tpg_persistent_reservation_check() not complete!!\n");
-	return(0);
-#endif
+
         return(ret);
 }
 
-EXPORT_SYMBOL(iscsi_tpg_persistent_reservation_check);
+EXPORT_SYMBOL(core_tpg_persistent_reservation_check);
 
-#warning FIXME: iscsi_tpg_persistent_reservation_release() broken
-extern int iscsi_tpg_persistent_reservation_release (se_cmd_t *cmd)
+extern int core_tpg_persistent_reservation_release (se_cmd_t *cmd)
 {
-#if 0
-        iscsi_conn_t *conn = CONN(cmd);
-        se_lun_t *lun = ISCSI_LUN(cmd);
-
-        if (!CONN(cmd)) {
-                TRACE_ERROR("iscsi_conn_t is NULL!\n");
-                return(5);
-        }
+	se_lun_t *lun = cmd->se_lun;
+	se_session_t *sess = cmd->se_sess;
+	se_portal_group_t *tpg = sess->se_tpg;
 
         spin_lock(&lun->lun_reservation_lock);
-        if (!lun->lun_reserved_node_acl) {
+        if (!lun->lun_reserved_node_acl || !sess) {
                 spin_unlock(&lun->lun_reservation_lock);
                 return(0);
         }
 
-        if (lun->lun_reserved_node_acl != SESS(conn)->node_acl) {
+        if (lun->lun_reserved_node_acl != sess->node_acl) {
                 spin_unlock(&lun->lun_reservation_lock);
                 return(0);
         }
         lun->lun_reserved_node_acl = NULL;
-        PYXPRINT("Released TPG LUN: %u -> MAPPED LUN: %u for %s\n", ISCSI_LUN(cmd)->iscsi_lun,
-                cmd->iscsi_deve->mapped_lun, SESS(conn)->node_acl->initiatorname);
+        PYXPRINT("Released %s TPG LUN: %u -> MAPPED LUN: %u for %s\n",
+		TPG_TFO(tpg)->get_fabric_name(),
+		ISCSI_LUN(cmd)->unpacked_lun, cmd->se_deve->mapped_lun,
+		sess->node_acl->initiatorname);
         spin_unlock(&lun->lun_reservation_lock);
-#else
-	BUG();
-#endif
+
         return(0);
 }
 
-EXPORT_SYMBOL(iscsi_tpg_persistent_reservation_release);
+EXPORT_SYMBOL(core_tpg_persistent_reservation_release);
 
-#warning FIXME: iscsi_tpg_persistent_reservation_reserve() broken
-extern int iscsi_tpg_persistent_reservation_reserve (se_cmd_t *cmd)
+#warning FIXME: core_tpg_persistent_reservation_reserve() broken
+extern int core_tpg_persistent_reservation_reserve (se_cmd_t *cmd)
 {
-#if 0
-        iscsi_conn_t *conn = CONN(cmd);
-        se_lun_t *lun = ISCSI_LUN(cmd);
-
-        if (!CONN(cmd)) {
-                TRACE_ERROR("iscsi_conn_t is NULL!\n");
-                return(5);
-        }
+	se_lun_t *lun = cmd->se_lun;
+	se_session_t *sess = cmd->se_sess;
+	se_portal_group_t *tpg = sess->se_tpg;
 
         if ((T_TASK(cmd)->t_task_cdb[1] & 0x01) && (T_TASK(cmd)->t_task_cdb[1] & 0x02)) {
                 TRACE_ERROR("LongIO and Obselete Bits set, returning ILLEGAL_REQUEST\n");
                 return(7);
         }
 
+	if (!(sess))
+		return(5);
+
         spin_lock(&lun->lun_reservation_lock);
-        if (lun->lun_reserved_node_acl && (lun->lun_reserved_node_acl != SESS(conn)->node_acl)) {
-                TRACE_ERROR("RESERVATION CONFLIFT\n");
-                TRACE_ERROR("Original reserver TPG LUN: %u %s\n", lun->iscsi_lun,
+        if (lun->lun_reserved_node_acl && (lun->lun_reserved_node_acl != sess->node_acl)) {
+                TRACE_ERROR("RESERVATION CONFLIFT for %s fabric\n",
+				TPG_TFO(tpg)->get_fabric_name());
+                TRACE_ERROR("Original reserver TPG LUN: %u %s\n", lun->unpacked_lun,
                                 lun->lun_reserved_node_acl->initiatorname);
                 TRACE_ERROR("Current attempt - TPG LUN: %u -> MAPPED LUN: %u from %s \n",
-                                lun->iscsi_lun, cmd->iscsi_deve->mapped_lun,
-                                SESS(conn)->node_acl->initiatorname);
+                                lun->unpacked_lun, cmd->se_deve->mapped_lun,
+                                sess->node_acl->initiatorname);
                 spin_unlock(&lun->lun_reservation_lock);
                 return(5);
         }
 
-        lun->lun_reserved_node_acl = SESS(conn)->node_acl;
-        PYXPRINT("Reserved TPG LUN: %u -> MAPPED LUN: %u for %s\n", ISCSI_LUN(cmd)->iscsi_lun,
-                cmd->iscsi_deve->mapped_lun, SESS(conn)->node_acl->initiatorname);
+        lun->lun_reserved_node_acl = sess->node_acl;
+        PYXPRINT("Reserved %s TPG LUN: %u -> MAPPED LUN: %u for %s\n",
+		TPG_TFO(tpg)->get_fabric_name(),
+		ISCSI_LUN(cmd)->unpacked_lun, cmd->se_deve->mapped_lun,
+		sess->node_acl->initiatorname);
         spin_unlock(&lun->lun_reservation_lock);
-#else
-	BUG();
-#endif
+
         return(0);
 }
 
-EXPORT_SYMBOL(iscsi_tpg_persistent_reservation_reserve);
+EXPORT_SYMBOL(core_tpg_persistent_reservation_reserve);
 
 /*	transport_generic_lun_reset():
  *
@@ -6428,7 +6424,7 @@ static void transport_generic_cold_reset (se_hba_t *hba)
 	 * terminating all sessions on this target portal group.
 	 */
 	spin_lock(&iscsi_global->tpg_lock);
-	for (i = 0 ; i < ISCSI_MAX_TPGS; i++) {
+	for (i = 0 ; i < TRANSPORT_MAX_TPGS; i++) {
 		tpg = &iscsi_global->tpg_list[i];
 		spin_lock(&tpg->tpg_state_lock);
 		if (tpg->tpg_state == TPG_STATE_COLD_RESET) {
@@ -6491,12 +6487,12 @@ extern int transport_generic_do_tmr (se_cmd_t *cmd)
 		req->response = FUNCTION_REJECTED;
 		break;
 	case TARGET_WARM_RESET:
-		transport_generic_host_reset(dev->iscsi_hba);
+		transport_generic_host_reset(dev->se_hba);
 		req->response = FUNCTION_REJECTED;
 		break;
 	case TARGET_COLD_RESET:
-		transport_generic_host_reset(dev->iscsi_hba);
-		transport_generic_cold_reset(dev->iscsi_hba);
+		transport_generic_host_reset(dev->se_hba);
+		transport_generic_cold_reset(dev->se_hba);
 		req->response = FUNCTION_COMPLETE;
 		break;
 	default:
@@ -6739,12 +6735,12 @@ extern void transport_status_thr_force_offline (
 extern int transport_status_thr_dev_online (se_device_t *dev)
 {
 	spin_lock(&dev->dev_status_lock);
-	if (dev->dev_status & ISCSI_DEVICE_OFFLINE_ACTIVATED) {
-		dev->dev_status |= ISCSI_DEVICE_ACTIVATED;
-		dev->dev_status &= ~ISCSI_DEVICE_OFFLINE_ACTIVATED;
-	} else if (dev->dev_status & ISCSI_DEVICE_OFFLINE_DEACTIVATED) {
-		dev->dev_status |= ISCSI_DEVICE_DEACTIVATED;
-		dev->dev_status &= ~ISCSI_DEVICE_OFFLINE_DEACTIVATED;
+	if (dev->dev_status & TRANSPORT_DEVICE_OFFLINE_ACTIVATED) {
+		dev->dev_status |= TRANSPORT_DEVICE_ACTIVATED;
+		dev->dev_status &= ~TRANSPORT_DEVICE_OFFLINE_ACTIVATED;
+	} else if (dev->dev_status & TRANSPORT_DEVICE_OFFLINE_DEACTIVATED) {
+		dev->dev_status |= TRANSPORT_DEVICE_DEACTIVATED;
+		dev->dev_status &= ~TRANSPORT_DEVICE_OFFLINE_DEACTIVATED;
 	}
 	spin_unlock(&dev->dev_status_lock);
 
@@ -6754,12 +6750,12 @@ extern int transport_status_thr_dev_online (se_device_t *dev)
 extern int transport_status_thr_dev_offline (se_device_t *dev)
 {
 	spin_lock(&dev->dev_status_lock);
-	if (dev->dev_status & ISCSI_DEVICE_ACTIVATED) {
-		dev->dev_status |= ISCSI_DEVICE_OFFLINE_ACTIVATED;
-		dev->dev_status &= ~ISCSI_DEVICE_ACTIVATED;
-	} else if (dev->dev_status & ISCSI_DEVICE_DEACTIVATED) {
-		dev->dev_status |= ISCSI_DEVICE_OFFLINE_DEACTIVATED;
-		dev->dev_status &= ~ISCSI_DEVICE_DEACTIVATED;
+	if (dev->dev_status & TRANSPORT_DEVICE_ACTIVATED) {
+		dev->dev_status |= TRANSPORT_DEVICE_OFFLINE_ACTIVATED;
+		dev->dev_status &= ~TRANSPORT_DEVICE_ACTIVATED;
+	} else if (dev->dev_status & TRANSPORT_DEVICE_DEACTIVATED) {
+		dev->dev_status |= TRANSPORT_DEVICE_OFFLINE_DEACTIVATED;
+		dev->dev_status &= ~TRANSPORT_DEVICE_DEACTIVATED;
 	}
 	spin_unlock(&dev->dev_status_lock);
 
@@ -6967,7 +6963,7 @@ static int transport_status_thread (void *p)
 			goto out;
 
 		spin_lock(&dev->dev_status_lock);
-		if (dev->dev_status & ISCSI_DEVICE_SHUTDOWN) {
+		if (dev->dev_status & TRANSPORT_DEVICE_SHUTDOWN) {
 			spin_unlock(&dev->dev_status_lock);
 			continue;
 		}
@@ -7239,7 +7235,7 @@ static int transport_processing_thread (void *param)
 			goto out;
 
 		spin_lock(&dev->dev_status_lock);
-		if (dev->dev_status & ISCSI_DEVICE_SHUTDOWN) {
+		if (dev->dev_status & TRANSPORT_DEVICE_SHUTDOWN) {
 			spin_unlock(&dev->dev_status_lock);
 			transport_processing_shutdown(dev);
 			continue;
@@ -7290,7 +7286,7 @@ get_cmd:
 					t_state, cmd->deferred_t_state,
 				CMD_TFO(cmd)->get_task_tag(cmd),
 				CMD_TFO(cmd)->get_cmd_state(cmd),
-				ISCSI_LUN(cmd)->iscsi_lun);
+				ISCSI_LUN(cmd)->unpacked_lun);
 			BUG();
 		}
 
diff --git a/drivers/lio-core/target_core_transport.h b/drivers/lio-core/target_core_transport.h
index 5c94271..8041fe6 100644
--- a/drivers/lio-core/target_core_transport.h
+++ b/drivers/lio-core/target_core_transport.h
@@ -30,6 +30,8 @@
 #ifndef TARGET_CORE_TRANSPORT_H
 #define TARGET_CORE_TRANSPORT_H
 
+#define TARGET_CORE_VERSION			"v3.0.0"
+
 #define PYX_TRANSPORT_WINDOW_CLOSED_THRESHOLD	3  /* Attempts before moving from SHORT to LONG */
 #define PYX_TRANSPORT_WINDOW_CLOSED_WAIT_SHORT	3  /* In milliseconds */
 #define PYX_TRANSPORT_WINDOW_CLOSED_WAIT_LONG	10 /* In milliseconds */
@@ -108,6 +110,9 @@ extern void transport_init_queue_obj (struct se_queue_obj_s *);
 extern void transport_load_plugins (void);
 extern struct se_plugin_s *transport_core_get_plugin_by_name (const char *name);
 extern void transport_check_dev_params_delim (char *, char **);
+extern struct se_session_s *transport_allocate_session (struct se_portal_group_s *, struct se_node_acl_s *);
+extern int transport_register_session (struct se_session_s *, void *);
+extern void transport_deregister_session (struct se_session_s *);
 extern void transport_task_dev_remove_state (struct se_task_s *, struct se_device_s *);
 extern int transport_add_cmd_to_queue (struct se_cmd_s *, struct se_queue_obj_s *, u8);
 extern void transport_complete_cmd (se_cmd_t *, int);
@@ -128,11 +133,11 @@ extern void transport_generic_free_device (se_device_t *);
 extern int transport_allocate_iovecs_for_cmd (struct se_cmd_s *, u32);
 extern int transport_generic_obj_start (struct se_transform_info_s *, struct se_obj_lun_type_s *, void *, unsigned long long);
 extern void transport_device_setup_cmd (se_cmd_t *);
-extern se_cmd_t *transport_alloc_se_cmd (struct target_core_fabric_ops *, void *, u32, int);
+extern se_cmd_t *transport_alloc_se_cmd (struct target_core_fabric_ops *, struct se_session_s *, void *, u32, int);
 extern int transport_generic_allocate_tasks (se_cmd_t *, unsigned char *);
 extern int transport_generic_handle_cdb (se_cmd_t *);
 extern int transport_generic_handle_data (se_cmd_t *);
-extern int transport_generic_handle_tmr (se_cmd_t *, iscsi_tmr_req_t *);
+extern int transport_generic_handle_tmr (se_cmd_t *, se_tmr_req_t *);
 extern void transport_stop_tasks_for_cmd (struct se_cmd_s *);
 extern int transport_failure_tasks_generic (se_cmd_t *);
 extern void transport_generic_request_failure (se_cmd_t *, se_device_t *, int, int); 
@@ -172,9 +177,9 @@ extern int transport_generic_remove (se_cmd_t *, int, int);
 extern int transport_lun_wait_for_tasks (se_cmd_t *, se_lun_t *);
 extern void transport_clear_lun_from_sessions (se_lun_t *);
 extern int iscsi_send_check_condition_and_sense (se_cmd_t *, __u8, int);
-extern int iscsi_tpg_persistent_reservation_check (se_cmd_t *);
-extern int iscsi_tpg_persistent_reservation_release (se_cmd_t *);
-extern int iscsi_tpg_persistent_reservation_reserve (se_cmd_t *);
+extern int core_tpg_persistent_reservation_check (se_cmd_t *);
+extern int core_tpg_persistent_reservation_release (se_cmd_t *);
+extern int core_tpg_persistent_reservation_reserve (se_cmd_t *);
 extern void transport_generic_free_cmd (se_cmd_t *, int, int, int);
 extern void transport_generic_wait_for_cmds (se_cmd_t *, int);
 extern int transport_generic_do_transform (struct se_cmd_s *, struct se_transform_info_s *);
-- 
1.5.4.1



