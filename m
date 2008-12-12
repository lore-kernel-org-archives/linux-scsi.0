From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH] [Target_Core_Mod 2/12]: Add generic target se_device_t and
	LUN ACL infrastructure
Date: Fri, 12 Dec 2008 01:29:35 -0800
Message-ID: <1229074175.4153.636.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp123.sbc.mail.sp1.yahoo.com ([69.147.64.96]:21086 "HELO
	smtp123.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751133AbYLLJ3j (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 Dec 2008 04:29:39 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Linux-iSCSI.org Target Dev" <linux-iscsi-target-dev@googlegroups.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>

>From 05a1c4a627c980433f7632cb2456aee118a1e5df Mon Sep 17 00:00:00 2001
From: Nicholas Bellinger <nab@linux-iscsi.org>
Date: Fri, 12 Dec 2008 00:43:17 -0800
Subject: [PATCH] [Target_Core_Mod]: Add generic target se_device_t and LUN ACL infrastructure

This patchs adds the following functions, moved and renamed from iscsi_target_device.c:

+extern se_lun_t *core_dev_add_lun (se_portal_group_t *, se_hba_t *, se_device_t *, u32, int *);
+extern int core_dev_del_lun (se_portal_group_t *, u32);
+extern se_lun_t *core_get_lun_from_tpg (se_portal_group_t *, u32);
+extern se_lun_acl_t *core_dev_init_initiator_node_lun_acl (se_portal_group_t *, u32, char *, int *);
+extern int core_dev_add_initiator_node_lun_acl (se_portal_group_t *, se_lun_acl_t *, u32, u32);
+extern int core_dev_del_initiator_node_lun_acl (se_portal_group_t *, se_lun_t *, se_lun_acl_t *);
+extern void core_dev_free_initiator_node_lun_acl (se_portal_group_t *, se_lun_acl_t *lacl);

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/lio-core/target_core_device.c |  533 ++++++++++++++++++++++++++++-----
 drivers/lio-core/target_core_device.h |   15 +-
 2 files changed, 477 insertions(+), 71 deletions(-)

diff --git a/drivers/lio-core/target_core_device.c b/drivers/lio-core/target_core_device.c
index 49be844..132bdef 100644
--- a/drivers/lio-core/target_core_device.c
+++ b/drivers/lio-core/target_core_device.c
@@ -43,16 +43,15 @@
 
 #include <iscsi_linux_os.h>
 #include <iscsi_linux_defs.h>
-
 #include <iscsi_lists.h>
-#include <iscsi_debug.h>
-#include <iscsi_protocol.h>
-#include <iscsi_target_core.h>
+
 #include <target_core_base.h>
 #include <iscsi_target_error.h>
 #include <target_core_device.h>
 #include <target_core_hba.h>
+#include <target_core_tpg.h>
 #include <target_core_transport.h>
+#include <target_core_fabric_ops.h>
 
 #include <target_core_plugin.h>
 #include <target_core_seobj.h>
@@ -106,7 +105,7 @@ extern struct block_device *__linux_blockdevice_claim (int major, int minor, voi
 
 	if (bd_claim(bd, claim_ptr) < 0) {
 #if 0
-		PYXPRINT("Using previously claimed Major:Minor - %d:%d\n",
+		printk("Using previously claimed Major:Minor - %d:%d\n",
 				major, minor);
 #endif
 		*ret = 0;
@@ -178,7 +177,7 @@ extern int linux_blockdevice_check (int major, int minor)
 
 EXPORT_SYMBOL(linux_blockdevice_check);
 
-extern int iscsi_check_devices_access (se_hba_t *hba)
+extern int se_check_devices_access (se_hba_t *hba)
 {
 	int ret = 0;
 	se_device_t *dev = NULL, *dev_next = NULL;
@@ -189,7 +188,7 @@ extern int iscsi_check_devices_access (se_hba_t *hba)
 		dev_next = dev->next;
 
 		if (DEV_OBJ_API(dev)->check_count(&dev->dev_feature_obj) != 0) {
-			TRACE_ERROR("check_count(&dev->dev_feature_obj): %u\n",
+			printk(KERN_ERR "check_count(&dev->dev_feature_obj): %u\n",
 				DEV_OBJ_API(dev)->check_count(&dev->dev_feature_obj));
 			ret = -1;
 		}
@@ -201,11 +200,11 @@ extern int iscsi_check_devices_access (se_hba_t *hba)
 	return(ret);		
 }
 
-/*	iscsi_disable_devices_for_hba():
+/*	se_disable_devices_for_hba():
  *
  *
  */
-extern void iscsi_disable_devices_for_hba (se_hba_t *hba)
+extern void se_disable_devices_for_hba (se_hba_t *hba)
 {
 	se_device_t *dev, *dev_next;
 
@@ -215,15 +214,15 @@ extern void iscsi_disable_devices_for_hba (se_hba_t *hba)
 		dev_next = dev->next;
 		
 		spin_lock(&dev->dev_status_lock);
-		if ((dev->dev_status & ISCSI_DEVICE_ACTIVATED) ||
-		    (dev->dev_status & ISCSI_DEVICE_DEACTIVATED) ||
-		    (dev->dev_status & ISCSI_DEVICE_OFFLINE_ACTIVATED) ||
-		    (dev->dev_status & ISCSI_DEVICE_OFFLINE_DEACTIVATED)) {
-			dev->dev_status |= ISCSI_DEVICE_SHUTDOWN;
-			dev->dev_status &= ~ISCSI_DEVICE_ACTIVATED;
-			dev->dev_status &= ~ISCSI_DEVICE_DEACTIVATED;
-			dev->dev_status &= ~ISCSI_DEVICE_OFFLINE_ACTIVATED;
-			dev->dev_status &= ~ISCSI_DEVICE_OFFLINE_DEACTIVATED;
+		if ((dev->dev_status & TRANSPORT_DEVICE_ACTIVATED) ||
+		    (dev->dev_status & TRANSPORT_DEVICE_DEACTIVATED) ||
+		    (dev->dev_status & TRANSPORT_DEVICE_OFFLINE_ACTIVATED) ||
+		    (dev->dev_status & TRANSPORT_DEVICE_OFFLINE_DEACTIVATED)) {
+			dev->dev_status |= TRANSPORT_DEVICE_SHUTDOWN;
+			dev->dev_status &= ~TRANSPORT_DEVICE_ACTIVATED;
+			dev->dev_status &= ~TRANSPORT_DEVICE_DEACTIVATED;
+			dev->dev_status &= ~TRANSPORT_DEVICE_OFFLINE_ACTIVATED;
+			dev->dev_status &= ~TRANSPORT_DEVICE_OFFLINE_DEACTIVATED;
 
 			up(&dev->dev_queue_obj->thread_sem);
 		}
@@ -247,14 +246,14 @@ extern int __transport_get_lun_for_cmd (
 	int read_only = 0;
 
 	spin_lock_bh(&SE_NODE_ACL(se_sess)->device_list_lock);
-	deve = se_cmd->iscsi_deve = &SE_NODE_ACL(se_sess)->device_list[unpacked_lun];
-	if (deve->lun_flags & ISCSI_LUNFLAGS_INITIATOR_ACCESS) {
+	deve = se_cmd->se_deve = &SE_NODE_ACL(se_sess)->device_list[unpacked_lun];
+	if (deve->lun_flags & TRANSPORT_LUNFLAGS_INITIATOR_ACCESS) {
                 if (se_cmd) {
                         deve->total_cmds++;
                         deve->total_bytes += se_cmd->data_length;
 
                         if (se_cmd->data_direction == SE_DIRECTION_WRITE) {
-                                if (deve->lun_flags & ISCSI_LUNFLAGS_READ_ONLY) {
+                                if (deve->lun_flags & TRANSPORT_LUNFLAGS_READ_ONLY) {
                                         read_only = 1;
                                         goto out;
                                 }
@@ -269,7 +268,7 @@ extern int __transport_get_lun_for_cmd (
                 }
                 deve->deve_cmds++;
 
-                se_lun = se_cmd->iscsi_lun = deve->iscsi_lun;
+                se_lun = se_cmd->se_lun = deve->se_lun;
                 se_cmd->orig_fe_lun = unpacked_lun;
                 se_cmd->se_orig_obj_api = ISCSI_LUN(se_cmd)->lun_obj_api;
                 se_cmd->se_orig_obj_ptr = ISCSI_LUN(se_cmd)->lun_type_ptr;
@@ -280,11 +279,11 @@ out:
         if (!se_lun) {
 		if (read_only) {
 			se_cmd->scsi_sense_reason = WRITE_PROTECTED;
-                        PYXPRINT("Detected WRITE_PROTECTED LUN Access for 0x%08x\n",
+                        printk("Detected WRITE_PROTECTED LUN Access for 0x%08x\n",
 				unpacked_lun);
 		} else {
 			se_cmd->scsi_sense_reason = NON_EXISTENT_LUN;
-                        PYXPRINT("Detected NON_EXISTENT_LUN Access for  0x%08x\n",
+                        printk("Detected NON_EXISTENT_LUN Access for  0x%08x\n",
 				unpacked_lun);
                 }
 		se_cmd->se_cmd_flags |= SCF_SCSI_CDB_EXCEPTION;
@@ -301,7 +300,7 @@ out:
 
 #ifdef SNMP_SUPPORT
 	{
-	se_device_t *dev = se_lun->iscsi_dev;
+	se_device_t *dev = se_lun->se_dev;
 	spin_lock(&dev->stats_lock);
 	dev->num_cmds++;
 	if (se_cmd->data_direction == SE_DIRECTION_WRITE)
@@ -326,27 +325,165 @@ out:
         ADD_ENTRY_TO_LIST_PREFIX(l, se_cmd, se_lun->lun_cmd_head, se_lun->lun_cmd_tail);
         atomic_set(&T_TASK(se_cmd)->transport_lun_active, 1);
 #if 0
-        TRACE_ERROR("Adding ITT: 0x%08x to LUN LIST[%d]\n",
-		CMD_TFO(se_cmd)->get_task_tag(se_cmd), se_lun->iscsi_lun);
+        printk("Adding ITT: 0x%08x to LUN LIST[%d]\n",
+		CMD_TFO(se_cmd)->get_task_tag(se_cmd), se_lun->unpacked_lun);
 #endif
         spin_unlock_irqrestore(&se_lun->lun_cmd_lock, flags);
 
 	return(0);
 }
 
+extern int core_free_device_list_for_node (se_node_acl_t *nacl, se_portal_group_t *tpg)
+{
+        se_dev_entry_t *deve;
+        se_lun_t *lun;
+	u32 i;
+
+        if (!nacl->device_list)
+                return(0);
+
+        spin_lock_bh(&nacl->device_list_lock);
+        for (i = 0; i < TRANSPORT_MAX_LUNS_PER_TPG; i++) {
+                deve = &nacl->device_list[i];
+
+                if (!(deve->lun_flags & TRANSPORT_LUNFLAGS_INITIATOR_ACCESS))
+                        continue;
+
+                if (!deve->se_lun) {
+                        printk(KERN_ERR "%s device entries device pointer is"
+                                " NULL, but Initiator has access.\n",
+				TPG_TFO(tpg)->get_fabric_name());
+                        continue;
+                }
+                lun = deve->se_lun;
+
+                spin_unlock_bh(&nacl->device_list_lock);
+                core_update_device_list_for_node(lun, deve->mapped_lun,
+                                TRANSPORT_LUNFLAGS_NO_ACCESS, nacl, tpg, 0);
+                spin_lock_bh(&nacl->device_list_lock);
+        }
+        spin_unlock_bh(&nacl->device_list_lock);
+
+        kfree(nacl->device_list);
+        nacl->device_list = NULL;
+
+        return(0);
+}
+
+extern void core_update_device_list_access (
+        u32 mapped_lun,
+        u32 lun_access,
+        se_node_acl_t *nacl)
+{
+        se_dev_entry_t *deve;
+
+        spin_lock_bh(&nacl->device_list_lock);
+        deve = &nacl->device_list[mapped_lun];
+        if (lun_access & TRANSPORT_LUNFLAGS_READ_WRITE) {
+                deve->lun_flags &= ~TRANSPORT_LUNFLAGS_READ_ONLY;
+                deve->lun_flags |= TRANSPORT_LUNFLAGS_READ_WRITE;
+        } else {
+                deve->lun_flags &= ~TRANSPORT_LUNFLAGS_READ_WRITE;
+                deve->lun_flags |= TRANSPORT_LUNFLAGS_READ_ONLY;
+        }
+        spin_unlock_bh(&nacl->device_list_lock);
+
+        return;
+}
+
+/*      core_update_device_list_for_node():
+ *
+ *
+ */
+extern void core_update_device_list_for_node (
+        se_lun_t *lun,
+        u32 mapped_lun,
+        u32 lun_access,
+        se_node_acl_t *nacl,
+        se_portal_group_t *tpg,
+        int enable)
+{
+        se_dev_entry_t *deve;
+
+        spin_lock_bh(&nacl->device_list_lock);
+        deve = &nacl->device_list[mapped_lun];
+        if (enable) {
+                deve->se_lun = lun;
+                deve->mapped_lun = mapped_lun;
+                deve->lun_flags |= TRANSPORT_LUNFLAGS_INITIATOR_ACCESS;
+
+                if (lun_access & TRANSPORT_LUNFLAGS_READ_WRITE) {
+                        deve->lun_flags &= ~TRANSPORT_LUNFLAGS_READ_ONLY;
+                        deve->lun_flags |= TRANSPORT_LUNFLAGS_READ_WRITE;
+                } else {
+                        deve->lun_flags &= ~TRANSPORT_LUNFLAGS_READ_WRITE;
+                        deve->lun_flags |= TRANSPORT_LUNFLAGS_READ_ONLY;
+                }
+#ifdef SNMP_SUPPORT
+                deve->creation_time = get_jiffies_64();
+                deve->attach_count++;
+#endif /* SNMP_SUPPORT */
+        } else {
+                deve->se_lun = NULL;
+                deve->lun_flags = 0;
+                deve->creation_time = 0;
+        }
+        spin_unlock_bh(&nacl->device_list_lock);
+
+        return;
+}
+
+/*      core_clear_lun_from_tpg():
+ *
+ *
+ */
+extern void core_clear_lun_from_tpg (se_lun_t *lun, se_portal_group_t *tpg)
+{
+        se_node_acl_t *nacl, *nacl_next;
+        se_dev_entry_t *deve;
+	u32 i;
+
+        spin_lock_bh(&tpg->acl_node_lock);
+        nacl = tpg->acl_node_head;
+        while (nacl) {
+                nacl_next = nacl->next;
+                spin_unlock_bh(&tpg->acl_node_lock);
+
+                spin_lock_bh(&nacl->device_list_lock);
+                for (i = 0; i < TRANSPORT_MAX_LUNS_PER_TPG; i++) {
+                        deve = &nacl->device_list[i];
+                        if (lun != deve->se_lun)
+                                continue;
+                        spin_unlock_bh(&nacl->device_list_lock);
+
+                        core_update_device_list_for_node(lun, deve->mapped_lun,
+                                TRANSPORT_LUNFLAGS_NO_ACCESS, nacl, tpg, 0);
+
+                        spin_lock_bh(&nacl->device_list_lock);
+                }
+                spin_unlock_bh(&nacl->device_list_lock);
+
+                spin_lock_bh(&tpg->acl_node_lock);
+                nacl = nacl_next;
+        }
+        spin_unlock_bh(&tpg->acl_node_lock);
+
+        return;
+}
+
 /*	se_release_device_for_hba():
  *
  *
  */
 extern void se_release_device_for_hba (se_device_t *dev)
 {
-	se_hba_t *hba = dev->iscsi_hba;
+	se_hba_t *hba = dev->se_hba;
 
-	if ((dev->dev_status & ISCSI_DEVICE_ACTIVATED) ||
-	    (dev->dev_status & ISCSI_DEVICE_DEACTIVATED) ||
-	    (dev->dev_status & ISCSI_DEVICE_SHUTDOWN) ||
-	    (dev->dev_status & ISCSI_DEVICE_OFFLINE_ACTIVATED) ||
-	    (dev->dev_status & ISCSI_DEVICE_OFFLINE_DEACTIVATED))
+	if ((dev->dev_status & TRANSPORT_DEVICE_ACTIVATED) ||
+	    (dev->dev_status & TRANSPORT_DEVICE_DEACTIVATED) ||
+	    (dev->dev_status & TRANSPORT_DEVICE_SHUTDOWN) ||
+	    (dev->dev_status & TRANSPORT_DEVICE_OFFLINE_ACTIVATED) ||
+	    (dev->dev_status & TRANSPORT_DEVICE_OFFLINE_DEACTIVATED))
 		se_dev_stop(dev);
 
 	transport_generic_free_device(dev);
@@ -386,9 +523,9 @@ EXPORT_SYMBOL(transport_get_lun_for_cmd);
  */
 extern void se_clear_dev_ports (se_device_t *dev)
 {
-	se_hba_t *hba = dev->iscsi_hba;	
+	se_hba_t *hba = dev->se_hba;	
 	se_lun_t *lun;
-	iscsi_portal_group_t *tpg;
+	se_portal_group_t *tpg;
 	se_port_t *sep, *sep_tmp;
 
 	spin_lock(&dev->se_port_lock);
@@ -434,17 +571,17 @@ EXPORT_SYMBOL(se_free_virtual_device);
 
 extern void se_dev_start (se_device_t *dev)
 {
-	se_hba_t *hba = dev->iscsi_hba;
+	se_hba_t *hba = dev->se_hba;
 	
         spin_lock(&hba->device_lock);
 	DEV_OBJ_API(dev)->inc_count(&dev->dev_obj);
         if (DEV_OBJ_API(dev)->check_count(&dev->dev_obj) == 1) {
-		if (dev->dev_status & ISCSI_DEVICE_DEACTIVATED) {
-			dev->dev_status &= ~ISCSI_DEVICE_DEACTIVATED;
-			dev->dev_status |= ISCSI_DEVICE_ACTIVATED;
-		} else if (dev->dev_status & ISCSI_DEVICE_OFFLINE_DEACTIVATED) {
-			dev->dev_status &= ~ISCSI_DEVICE_OFFLINE_DEACTIVATED;
-			dev->dev_status |= ISCSI_DEVICE_OFFLINE_ACTIVATED;	
+		if (dev->dev_status & TRANSPORT_DEVICE_DEACTIVATED) {
+			dev->dev_status &= ~TRANSPORT_DEVICE_DEACTIVATED;
+			dev->dev_status |= TRANSPORT_DEVICE_ACTIVATED;
+		} else if (dev->dev_status & TRANSPORT_DEVICE_OFFLINE_DEACTIVATED) {
+			dev->dev_status &= ~TRANSPORT_DEVICE_OFFLINE_DEACTIVATED;
+			dev->dev_status |= TRANSPORT_DEVICE_OFFLINE_ACTIVATED;	
 		}
 	}
         spin_unlock(&hba->device_lock);
@@ -454,17 +591,17 @@ extern void se_dev_start (se_device_t *dev)
 
 extern void se_dev_stop (se_device_t *dev)
 {
-	se_hba_t *hba = dev->iscsi_hba;
+	se_hba_t *hba = dev->se_hba;
 
 	spin_lock(&hba->device_lock);
 	DEV_OBJ_API(dev)->dec_count(&dev->dev_obj);
         if (DEV_OBJ_API(dev)->check_count(&dev->dev_obj) == 0) {
-		if (dev->dev_status & ISCSI_DEVICE_ACTIVATED) {
-			dev->dev_status &= ~ISCSI_DEVICE_ACTIVATED;
-			dev->dev_status |= ISCSI_DEVICE_DEACTIVATED;
-		} else if (dev->dev_status & ISCSI_DEVICE_OFFLINE_ACTIVATED) {
-			dev->dev_status &= ~ISCSI_DEVICE_OFFLINE_ACTIVATED;
-			dev->dev_status |= ISCSI_DEVICE_OFFLINE_DEACTIVATED;
+		if (dev->dev_status & TRANSPORT_DEVICE_ACTIVATED) {
+			dev->dev_status &= ~TRANSPORT_DEVICE_ACTIVATED;
+			dev->dev_status |= TRANSPORT_DEVICE_DEACTIVATED;
+		} else if (dev->dev_status & TRANSPORT_DEVICE_OFFLINE_ACTIVATED) {
+			dev->dev_status &= ~TRANSPORT_DEVICE_OFFLINE_ACTIVATED;
+			dev->dev_status |= TRANSPORT_DEVICE_OFFLINE_DEACTIVATED;
 		}
 	}
 	spin_unlock(&hba->device_lock);
@@ -506,12 +643,12 @@ extern void se_dev_set_default_attribs (se_device_t *dev)
 extern int se_dev_set_task_timeout (se_device_t *dev, u32 task_timeout)
 {
 	if (task_timeout > DA_TASK_TIMEOUT_MAX) {
-		TRACE_ERROR("dev[%p]: Passed task_timeout: %u larger then"
+		printk(KERN_ERR "dev[%p]: Passed task_timeout: %u larger then"
 			" DA_TASK_TIMEOUT_MAX\n", dev, task_timeout);
 		return(-1);
 	} else {
 		DEV_ATTRIB(dev)->task_timeout = task_timeout;
-		PYXPRINT("dev[%p]: Set SE Device task_timeout: %u\n", dev, task_timeout);
+		printk("dev[%p]: Set SE Device task_timeout: %u\n", dev, task_timeout);
 	}
 
 	return(0);
@@ -520,14 +657,14 @@ extern int se_dev_set_task_timeout (se_device_t *dev, u32 task_timeout)
 extern int se_dev_set_status_thread (se_device_t *dev, int flag)
 {
 	if ((flag != 0) && (flag != 1)) {
-	 	TRACE_ERROR("Illegal value %d\n", flag);
+	 	printk(KERN_ERR "Illegal value %d\n", flag);
 		return(-1);		
 	}
 
 	if (!flag) {
 		if (DEV_ATTRIB(dev)->status_thread) {
 			if (DEV_OBJ_API(dev)->check_count(&dev->dev_export_obj)) {
-				TRACE_ERROR("dev[%p]: Unable to stop SE Device Status"
+				printk(KERN_ERR "dev[%p]: Unable to stop SE Device Status"
 					" Thread while dev_export_obj: %d count exists\n",
 					dev, DEV_OBJ_API(dev)->check_count(&dev->dev_export_obj));
 				return(-1);
@@ -541,7 +678,7 @@ extern int se_dev_set_status_thread (se_device_t *dev, int flag)
 	}
 
 	DEV_ATTRIB(dev)->status_thread = flag;
-	PYXPRINT("dev[%p]: SE Device Status Thread: %s\n", dev, (flag) ?
+	printk("dev[%p]: SE Device Status Thread: %s\n", dev, (flag) ?
 			"Enabled" : "Disabled");
 	return(0);
 }
@@ -551,7 +688,7 @@ extern int se_dev_set_status_thread_tur (se_device_t *dev, int flag)
 	int start = 0;
 
 	if ((flag != 0) && (flag != 1)) {
-		TRACE_ERROR("Illegal value %d\n", flag);
+		printk(KERN_ERR "Illegal value %d\n", flag);
 		return(-1);
 	}
 
@@ -561,7 +698,7 @@ extern int se_dev_set_status_thread_tur (se_device_t *dev, int flag)
 	DEV_ATTRIB(dev)->status_thread_tur = flag;
 	if (start)
 		transport_start_status_timer(dev);
-	PYXPRINT("dev[%p]: SE Device Status Thread TUR: %s\n", dev, (flag) ?
+	printk("dev[%p]: SE Device Status Thread TUR: %s\n", dev, (flag) ?
 			"Enabled" : "Disabled");
 	return(0);
 }
@@ -574,19 +711,19 @@ extern int se_dev_set_queue_depth (se_device_t *dev, u32 queue_depth)
 	u32 orig_queue_depth = dev->queue_depth;
 
 	if (DEV_OBJ_API(dev)->check_count(&dev->dev_export_obj)) {
-		TRACE_ERROR("dev[%p]: Unable to change SE Device TCQ while"
+		printk(KERN_ERR "dev[%p]: Unable to change SE Device TCQ while"
 			" dev_export_obj: %d count exists\n", dev,
 			DEV_OBJ_API(dev)->check_count(&dev->dev_export_obj));
 		return(-1);
 	}
 	if (!(queue_depth)) {
-		TRACE_ERROR("dev[%p]: Illegal ZERO value for queue_depth\n", dev);
+		printk(KERN_ERR "dev[%p]: Illegal ZERO value for queue_depth\n", dev);
 		return(-1);
 	}
 	
 	if (TRANSPORT(dev)->transport_type == TRANSPORT_PLUGIN_PHBA_PDEV) {
 		if (queue_depth > TRANSPORT(dev)->get_queue_depth(dev)) {
-			TRACE_ERROR("dev[%p]: Passed queue_depth: %u exceeds"
+			printk(KERN_ERR "dev[%p]: Passed queue_depth: %u exceeds"
 				" LIO-Core/SE_Device TCQ: %u\n", dev, queue_depth,
 				TRANSPORT(dev)->get_queue_depth(dev));
 			return(-1);
@@ -594,13 +731,13 @@ extern int se_dev_set_queue_depth (se_device_t *dev, u32 queue_depth)
 	} else {
 		if (queue_depth > TRANSPORT(dev)->get_queue_depth(dev)) {
 			if (!(TRANSPORT(dev)->get_max_queue_depth)) {
-				TRACE_ERROR("dev[%p]: Unable to locate "
+				printk(KERN_ERR "dev[%p]: Unable to locate "
 					"get_max_queue_depth() function"
 					" pointer\n", dev);
 				return(-1);
 			}
 			if (queue_depth > TRANSPORT(dev)->get_max_queue_depth(dev)) {
-				TRACE_ERROR("dev[%p]: Passed queue_depth: %u exceeds"
+				printk(KERN_ERR "dev[%p]: Passed queue_depth: %u exceeds"
 				" LIO-Core/SE_Device MAX TCQ: %u\n", dev, queue_depth,
 					TRANSPORT(dev)->get_max_queue_depth(dev));
 				return(-1);
@@ -614,7 +751,7 @@ extern int se_dev_set_queue_depth (se_device_t *dev, u32 queue_depth)
 	else if (queue_depth < orig_queue_depth)
 		atomic_sub(orig_queue_depth - queue_depth, &dev->depth_left);
 
-	PYXPRINT("dev[%p]: SE Device TCQ Depth changed to: %u\n", dev, queue_depth);
+	printk("dev[%p]: SE Device TCQ Depth changed to: %u\n", dev, queue_depth);
 	return(0);
 }
 
@@ -624,37 +761,37 @@ extern int se_dev_set_max_sectors (se_device_t *dev, u32 max_sectors)
 	int force = 0; /* Force setting for VDEVS */
 
 	if (DEV_OBJ_API(dev)->check_count(&dev->dev_export_obj)) {
-		TRACE_ERROR("dev[%p]: Unable to change SE Device max_sectors"
+		printk(KERN_ERR "dev[%p]: Unable to change SE Device max_sectors"
 			" while dev_export_obj: %d count exists\n", dev,
 			DEV_OBJ_API(dev)->check_count(&dev->dev_export_obj));
 		return(-1);
 	}
 	if (!(max_sectors)) {
-		TRACE_ERROR("dev[%p]: Illegal ZERO value for max_sectors\n", dev);
+		printk(KERN_ERR "dev[%p]: Illegal ZERO value for max_sectors\n", dev);
 		return(-1);
 	}
 	if (max_sectors < DA_STATUS_MAX_SECTORS_MIN) {
-		TRACE_ERROR("dev[%p]: Passed max_sectors: %u less than"
+		printk(KERN_ERR "dev[%p]: Passed max_sectors: %u less than"
 			" DA_STATUS_MAX_SECTORS_MIN: %u\n", dev, max_sectors,
 				DA_STATUS_MAX_SECTORS_MIN);
 		return(-1);
 	}
 	if (TRANSPORT(dev)->transport_type == TRANSPORT_PLUGIN_PHBA_PDEV) {
 		if (max_sectors > TRANSPORT(dev)->get_max_sectors(dev)) {
-			 TRACE_ERROR("dev[%p]: Passed max_sectors: %u greater than"
+			 printk(KERN_ERR "dev[%p]: Passed max_sectors: %u greater than"
 				" LIO-Core/SE_Device max_sectors: %u\n", dev,
 				max_sectors, TRANSPORT(dev)->get_max_sectors(dev));
 			 return(-1);
 		}
 	} else {
 		if (!(force) && (max_sectors > TRANSPORT(dev)->get_max_sectors(dev))) {
-			TRACE_ERROR("dev[%p]: Passed max_sectors: %u greater than"
+			printk(KERN_ERR "dev[%p]: Passed max_sectors: %u greater than"
 				" LIO-Core/SE_Device max_sectors: %u, use force=1 to override.\n",
 				dev, max_sectors, TRANSPORT(dev)->get_max_sectors(dev));
 			return(-1);
 		}
 		if (max_sectors > DA_STATUS_MAX_SECTORS_MAX) {
-			TRACE_ERROR("dev[%p]: Passed max_sectors: %u greater than"
+			printk(KERN_ERR "dev[%p]: Passed max_sectors: %u greater than"
 				" DA_STATUS_MAX_SECTORS_MAX: %u\n", dev,
 				max_sectors, DA_STATUS_MAX_SECTORS_MAX);
 			return(-1);
@@ -662,7 +799,265 @@ extern int se_dev_set_max_sectors (se_device_t *dev, u32 max_sectors)
 	}
 
 	DEV_ATTRIB(dev)->max_sectors = max_sectors;
-	PYXPRINT("dev[%p]: SE Device max_sectors changed to %u\n",
+	printk("dev[%p]: SE Device max_sectors changed to %u\n",
 			dev, max_sectors);
 	return(0);
 }
+
+extern se_lun_t *core_dev_add_lun (
+	se_portal_group_t *tpg,
+	se_hba_t *hba,
+	se_device_t *dev,
+	u32 lun,
+	int *ret)
+{
+        se_lun_t *lun_p;
+        u32 lun_access = 0;
+
+        if (DEV_OBJ_API(dev)->check_count(&dev->dev_access_obj) != 0) {
+                printk(KERN_ERR "Unable to export se_device_t while dev_access_obj: %d\n",
+                        DEV_OBJ_API(dev)->check_count(&dev->dev_access_obj));
+                *ret = ERR_OBJ_ACCESS_COUNT;
+                return(NULL);
+        }
+
+        if (!(lun_p = core_tpg_pre_addlun(tpg, lun, ret)))
+                return(NULL);
+
+        if (DEV_OBJ_API(dev)->get_device_access((void *)dev) == 0)
+                lun_access = TRANSPORT_LUNFLAGS_READ_ONLY;
+        else
+                lun_access = TRANSPORT_LUNFLAGS_READ_WRITE;
+
+        if (core_tpg_post_addlun(tpg, lun_p, TRANSPORT_LUN_TYPE_DEVICE, lun_access,
+                              dev, dev->dev_obj_api) < 0) {
+                *ret = ERR_EXPORT_FAILED;
+                return(NULL);
+        }
+
+        printk("%s_TPG[%u]_LUN[%u] - Activated %s Logical Unit from"
+                " CORE HBA: %u\n", TPG_TFO(tpg)->get_fabric_name(),
+		TPG_TFO(tpg)->tpg_get_tag(tpg), lun_p->unpacked_lun,
+		TPG_TFO(tpg)->get_fabric_name(), hba->hba_id);
+        /*
+         * Update LUN maps for dynamically added initiators when generate_node_acl
+         * is enabled.
+         */
+	if (TPG_TFO(tpg)->tpg_check_demo_mode(tpg)) {
+                se_node_acl_t *acl;
+                spin_lock_bh(&tpg->acl_node_lock);
+                for (acl = tpg->acl_node_head; acl; acl = acl->next) {
+                        if (acl->nodeacl_flags & NAF_DYNAMIC_NODE_ACL) {
+                                spin_unlock_bh(&tpg->acl_node_lock);
+                                core_tpg_add_node_to_devs(acl, tpg);
+                                spin_lock_bh(&tpg->acl_node_lock);
+                        }
+                }
+                spin_unlock_bh(&tpg->acl_node_lock);
+        }
+
+        *ret = 0;
+        return(lun_p);
+}
+
+/*      core_dev_del_lun():
+ *
+ *
+ */
+extern int core_dev_del_lun (
+        se_portal_group_t *tpg,
+        u32 unpacked_lun)
+{
+        se_lun_t *lun;
+        int ret = 0;
+
+        if (!(lun = core_tpg_pre_dellun(tpg, unpacked_lun, TRANSPORT_LUN_TYPE_DEVICE, &ret)))
+                return(ret);
+
+        core_tpg_post_dellun(tpg, lun);
+
+        printk("%s_TPG[%u]_LUN[%u] - Deactivated %s Logical Unit from"
+                " device object\n", TPG_TFO(tpg)->get_fabric_name(),
+		TPG_TFO(tpg)->tpg_get_tag(tpg), unpacked_lun,
+		TPG_TFO(tpg)->get_fabric_name());
+
+        return(0);
+}
+
+extern se_lun_t *core_get_lun_from_tpg (se_portal_group_t *tpg, u32 unpacked_lun)
+{
+        se_lun_t *lun;
+
+        spin_lock(&tpg->tpg_lun_lock);
+        if (unpacked_lun > (TRANSPORT_MAX_LUNS_PER_TPG-1)) {
+                printk(KERN_ERR "%s LUN: %u exceeds TRANSPORT_MAX_LUNS_PER_TPG-1:"
+                        " %u for Target Portal Group: %hu\n",
+			TPG_TFO(tpg)->get_fabric_name(), unpacked_lun,
+                        TRANSPORT_MAX_LUNS_PER_TPG-1, TPG_TFO(tpg)->tpg_get_tag(tpg));
+                        spin_unlock(&tpg->tpg_lun_lock);
+                return(NULL);
+        }
+        lun = &tpg->tpg_lun_list[unpacked_lun];
+
+        if (lun->lun_status != TRANSPORT_LUN_STATUS_FREE) {
+                printk(KERN_ERR "%s Logical Unit Number: %u is not free on"
+                        " Target Portal Group: %hu, ignoring request.\n",
+                        TPG_TFO(tpg)->get_fabric_name(), unpacked_lun,
+			TPG_TFO(tpg)->tpg_get_tag(tpg));
+                spin_unlock(&tpg->tpg_lun_lock);
+                return(NULL);
+        }
+        spin_unlock(&tpg->tpg_lun_lock);
+
+        return(lun);
+}
+
+/*      core_dev_get_lun():
+ *
+ *
+ */
+static se_lun_t *core_dev_get_lun (se_portal_group_t *tpg, u32 unpacked_lun)
+{
+        se_lun_t *lun;
+
+        spin_lock(&tpg->tpg_lun_lock);
+        if (unpacked_lun > (TRANSPORT_MAX_LUNS_PER_TPG-1)) {
+                printk(KERN_ERR "%s LUN: %u exceeds TRANSPORT_MAX_LUNS_PER_TPG-1:"
+                        " %u for Target Portal Group: %hu\n",
+			TPG_TFO(tpg)->get_fabric_name(), unpacked_lun,
+			TRANSPORT_MAX_LUNS_PER_TPG-1, TPG_TFO(tpg)->tpg_get_tag(tpg));
+                spin_unlock(&tpg->tpg_lun_lock);
+                return(NULL);
+        }
+        lun = &tpg->tpg_lun_list[unpacked_lun];
+
+        if (lun->lun_status != TRANSPORT_LUN_STATUS_ACTIVE) {
+                printk(KERN_ERR "%s Logical Unit Number: %u is not active on"
+                        " Target Portal Group: %hu, ignoring request.\n",
+			TPG_TFO(tpg)->get_fabric_name(), unpacked_lun,
+			TPG_TFO(tpg)->tpg_get_tag(tpg));
+                spin_unlock(&tpg->tpg_lun_lock);
+                return(NULL);
+        }
+        spin_unlock(&tpg->tpg_lun_lock);
+
+        return(lun);
+}
+
+extern se_lun_acl_t *core_dev_init_initiator_node_lun_acl (
+        se_portal_group_t *tpg,
+        u32 mapped_lun,
+        char *initiatorname,
+        int *ret)
+{
+        se_lun_acl_t *lacl;
+        se_node_acl_t *nacl;
+
+        if (strlen(initiatorname) > TRANSPORT_IQN_LEN) {
+                printk(KERN_ERR "%s InitiatorName exceeds maximum size.\n",
+			TPG_TFO(tpg)->get_fabric_name());
+                *ret = -EOVERFLOW;
+                return(NULL);
+        }
+        if (!(nacl = core_tpg_get_initiator_node_acl(tpg, initiatorname))) {
+                *ret = -EINVAL;
+                return(NULL);
+        }
+        if (!(lacl = (se_lun_acl_t *) kzalloc(sizeof(se_lun_acl_t), GFP_KERNEL))) {
+                printk(KERN_ERR "Unable to allocate memory for se_lun_acl_t.\n");
+                *ret = -ENOMEM;
+                return(NULL);
+        }
+
+        lacl->mapped_lun = mapped_lun;
+        lacl->se_lun_nacl = nacl;
+        snprintf(lacl->initiatorname, TRANSPORT_IQN_LEN, "%s", initiatorname);
+
+        return(lacl);
+}
+
+extern int core_dev_add_initiator_node_lun_acl (
+        se_portal_group_t *tpg,
+        se_lun_acl_t *lacl,
+        u32 unpacked_lun,
+        u32 lun_access)
+{
+        se_lun_t *lun;
+        se_node_acl_t *nacl;
+
+        if (!(lun = core_dev_get_lun(tpg, unpacked_lun))) {
+                printk(KERN_ERR "%s Logical Unit Number: %u is not active on"
+                        " Target Portal Group: %hu, ignoring request.\n",
+		TPG_TFO(tpg)->get_fabric_name(), unpacked_lun,
+                        TPG_TFO(tpg)->tpg_get_tag(tpg));
+                return(-EINVAL);
+        }
+
+        if (!(nacl = core_tpg_get_initiator_node_acl(tpg, lacl->initiatorname)))
+                return(-EINVAL);
+
+        spin_lock(&lun->lun_acl_lock);
+        ADD_ENTRY_TO_LIST(lacl, lun->lun_acl_head, lun->lun_acl_tail);
+        spin_unlock(&lun->lun_acl_lock);
+
+        if ((lun->lun_access & TRANSPORT_LUNFLAGS_READ_ONLY) &&
+            (lun_access & TRANSPORT_LUNFLAGS_READ_WRITE))
+                lun_access = TRANSPORT_LUNFLAGS_READ_ONLY;
+
+        lacl->se_lun = lun;
+
+        core_update_device_list_for_node(lun, lacl->mapped_lun,
+                        lun_access, nacl, tpg, 1);
+
+        printk("%s_TPG[%hu]_LUN[%u->%u] - Added %s ACL for iSCSI"
+                " InitiatorNode: %s\n", TPG_TFO(tpg)->get_fabric_name(),
+		TPG_TFO(tpg)->tpg_get_tag(tpg), unpacked_lun, lacl->mapped_lun,
+                (lun_access & TRANSPORT_LUNFLAGS_READ_WRITE) ? "RW" : "RO",
+                        lacl->initiatorname);
+        return(0);
+}
+
+/*      core_dev_del_initiator_node_lun_acl():
+ *
+ *
+ */
+extern int core_dev_del_initiator_node_lun_acl (
+        se_portal_group_t *tpg,
+        se_lun_t *lun,
+        se_lun_acl_t *lacl)
+{
+        se_node_acl_t *nacl;
+
+        if (!(nacl = core_tpg_get_initiator_node_acl(tpg, lacl->initiatorname)))
+                return(ERR_DELLUNACL_NODE_ACL_MISSING);
+
+        spin_lock(&lun->lun_acl_lock);
+        REMOVE_ENTRY_FROM_LIST(lacl, lun->lun_acl_head, lun->lun_acl_tail);
+        spin_unlock(&lun->lun_acl_lock);
+
+        core_update_device_list_for_node(lun, lacl->mapped_lun,
+                TRANSPORT_LUNFLAGS_NO_ACCESS, nacl, tpg, 0);
+
+        lacl->se_lun = NULL;
+
+        printk("%s_TPG[%hu]_LUN[%u] - Removed ACL for iSCSI InitiatorNode:"
+                " %s Mapped LUN: %u\n", TPG_TFO(tpg)->get_fabric_name(),
+		TPG_TFO(tpg)->tpg_get_tag(tpg), lun->unpacked_lun,
+                        lacl->initiatorname, lacl->mapped_lun);
+        return(0);
+}
+
+extern void core_dev_free_initiator_node_lun_acl (
+        se_portal_group_t *tpg,
+        se_lun_acl_t *lacl)
+{
+        printk("%s_TPG[%hu] - Freeing ACL for %s InitiatorNode: %s"
+                " Mapped LUN: %u\n", TPG_TFO(tpg)->get_fabric_name(),
+		TPG_TFO(tpg)->tpg_get_tag(tpg), 
+		TPG_TFO(tpg)->get_fabric_name(),
+		lacl->initiatorname, lacl->mapped_lun);
+
+        kfree(lacl);
+        return;
+}
+
diff --git a/drivers/lio-core/target_core_device.h b/drivers/lio-core/target_core_device.h
index 79678ca..6028c3a 100644
--- a/drivers/lio-core/target_core_device.h
+++ b/drivers/lio-core/target_core_device.h
@@ -32,9 +32,13 @@ extern struct block_device *__linux_blockdevice_claim (int, int, void *, int *);
 extern struct block_device *linux_blockdevice_claim (int, int, void *);
 extern int linux_blockdevice_release (int, int, struct block_device *);
 extern int linux_blockdevice_check (int, int);
-extern int iscsi_check_devices_access (se_hba_t *);
-extern void iscsi_disable_devices_for_hba (se_hba_t *);
+extern int se_check_devices_access (se_hba_t *);
+extern void se_disable_devices_for_hba (se_hba_t *);
 extern int transport_get_lun_for_cmd (struct se_cmd_s *, unsigned char *, u32);
+extern int core_free_device_list_for_node (se_node_acl_t *, se_portal_group_t *);
+extern void core_update_device_list_access (u32, u32, se_node_acl_t *);
+extern void core_update_device_list_for_node (se_lun_t *lun, u32, u32, se_node_acl_t *, se_portal_group_t *, int);
+extern void core_clear_lun_from_tpg (se_lun_t *, se_portal_group_t *);
 extern void se_release_device_for_hba (se_device_t *);
 extern void se_clear_dev_ports (se_device_t *);
 extern int se_free_virtual_device (se_device_t *, se_hba_t *);
@@ -46,5 +50,12 @@ extern int se_dev_set_status_thread (se_device_t *, int);
 extern int se_dev_set_status_thread_tur (se_device_t *, int);
 extern int se_dev_set_queue_depth (se_device_t *, u32);
 extern int se_dev_set_max_sectors (se_device_t *, u32);
+extern se_lun_t *core_dev_add_lun (se_portal_group_t *, se_hba_t *, se_device_t *, u32, int *);
+extern int core_dev_del_lun (se_portal_group_t *, u32);
+extern se_lun_t *core_get_lun_from_tpg (se_portal_group_t *, u32);
+extern se_lun_acl_t *core_dev_init_initiator_node_lun_acl (se_portal_group_t *, u32, char *, int *);
+extern int core_dev_add_initiator_node_lun_acl (se_portal_group_t *, se_lun_acl_t *, u32, u32);
+extern int core_dev_del_initiator_node_lun_acl (se_portal_group_t *, se_lun_t *, se_lun_acl_t *);
+extern void core_dev_free_initiator_node_lun_acl (se_portal_group_t *, se_lun_acl_t *lacl);
 
 #endif /* TARGET_CORE_DEVICE_H */
-- 
1.5.4.1



