From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH] [Target_Core_Mod 8/12]: Update SE Object code for
	target_core_base.h
Date: Fri, 12 Dec 2008 01:34:08 -0800
Message-ID: <1229074448.4153.653.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp119.sbc.mail.sp1.yahoo.com ([69.147.64.92]:21268 "HELO
	smtp119.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756566AbYLLJeL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 Dec 2008 04:34:11 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Linux-iSCSI.org Target Dev" <linux-iscsi-target-dev@googlegroups.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>

>From 990b366a3257954b7e3ee6a7d35dc24bf5f09a6d Mon Sep 17 00:00:00 2001
From: Nicholas Bellinger <nab@linux-iscsi.org>
Date: Fri, 12 Dec 2008 00:56:59 -0800
Subject: [PATCH] [Target_Core_Mod]: Update SE Object code for target_core_base.h

This patch updates core SE device object functionality for Target_Core_Mod
se_device_t operations.

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/lio-core/target_core_seobj.c |   59 +++++++++++++++------------------
 drivers/lio-core/target_core_seobj.h |    8 ++--
 2 files changed, 31 insertions(+), 36 deletions(-)

diff --git a/drivers/lio-core/target_core_seobj.c b/drivers/lio-core/target_core_seobj.c
index d455fa1..eff0b0e 100644
--- a/drivers/lio-core/target_core_seobj.c
+++ b/drivers/lio-core/target_core_seobj.c
@@ -178,11 +178,11 @@ extern void dev_put_obj (void *p)
 {
 	se_device_t *dev  = (se_device_t *)p;
 
-	core_put_hba(dev->iscsi_hba);
+	core_put_hba(dev->se_hba);
 	return;
 }
 
-extern int dev_obj_export (void *p, iscsi_portal_group_t *tpg, se_lun_t *lun)
+extern int dev_obj_export (void *p, se_portal_group_t *tpg, se_lun_t *lun)
 {
 	se_device_t *dev  = (se_device_t *)p;
 	se_port_t *sep;
@@ -194,9 +194,9 @@ extern int dev_obj_export (void *p, iscsi_portal_group_t *tpg, se_lun_t *lun)
 	memset(sep, 0, sizeof(se_port_t));
 	INIT_LIST_HEAD(&sep->sep_list);
 
-	lun->iscsi_dev = dev;
+	lun->se_dev = dev;
 	if (DEV_OBJ_API(dev)->activate(p) < 0) {
-		lun->iscsi_dev = NULL;
+		lun->se_dev = NULL;
 		kfree(sep);
 		return(-1);
 	}
@@ -220,7 +220,7 @@ extern int dev_obj_export (void *p, iscsi_portal_group_t *tpg, se_lun_t *lun)
 	return(0);
 }
 
-extern void dev_obj_unexport (void *p, iscsi_portal_group_t *tpg, se_lun_t *lun)
+extern void dev_obj_unexport (void *p, se_portal_group_t *tpg, se_lun_t *lun)
 {
 	se_device_t *dev  = (se_device_t *)p;
 	se_port_t *sep = lun->lun_sep;
@@ -244,7 +244,7 @@ extern void dev_obj_unexport (void *p, iscsi_portal_group_t *tpg, se_lun_t *lun)
 	kfree(sep);
 
 	DEV_OBJ_API(dev)->deactivate(p);
-	lun->iscsi_dev = NULL;
+	lun->se_dev = NULL;
 	
 	return;
 }
@@ -420,7 +420,7 @@ extern void *dev_obj_get_transport_req (void *p, se_task_t *task)
 {
 	se_device_t *dev  = (se_device_t *)p;
 
-	task->iscsi_dev = dev;
+	task->se_dev = dev;
 	
 	return(dev->transport->allocate_request(task, dev));
 }
@@ -461,8 +461,8 @@ extern int dev_obj_check_online (void *p)
 	int ret;
 
 	spin_lock(&dev->dev_status_lock);
-	ret = ((dev->dev_status & ISCSI_DEVICE_ACTIVATED) ||
-	       (dev->dev_status & ISCSI_DEVICE_DEACTIVATED)) ? 0 : 1;
+	ret = ((dev->dev_status & TRANSPORT_DEVICE_ACTIVATED) ||
+	       (dev->dev_status & TRANSPORT_DEVICE_DEACTIVATED)) ? 0 : 1;
 	spin_unlock(&dev->dev_status_lock);
 
 	return(ret);
@@ -474,7 +474,7 @@ extern int dev_obj_check_shutdown (void *p)
 	int ret;
 
 	spin_lock(&dev->dev_status_lock);
-	ret = (dev->dev_status & ISCSI_DEVICE_SHUTDOWN);
+	ret = (dev->dev_status & TRANSPORT_DEVICE_SHUTDOWN);
 	spin_unlock(&dev->dev_status_lock);
 
 	return(ret);
@@ -500,15 +500,15 @@ extern void dev_obj_signal_shutdown (void *p)
 	se_device_t *dev  = (se_device_t *)p;
 
 	spin_lock(&dev->dev_status_lock);
-	if ((dev->dev_status & ISCSI_DEVICE_ACTIVATED) ||
-	    (dev->dev_status & ISCSI_DEVICE_DEACTIVATED) ||
-	    (dev->dev_status & ISCSI_DEVICE_OFFLINE_ACTIVATED) ||
-	    (dev->dev_status & ISCSI_DEVICE_OFFLINE_DEACTIVATED)) {
-		dev->dev_status |= ISCSI_DEVICE_SHUTDOWN;
-		dev->dev_status &= ~ISCSI_DEVICE_ACTIVATED;
-		dev->dev_status &= ~ISCSI_DEVICE_DEACTIVATED;
-		dev->dev_status &= ~ISCSI_DEVICE_OFFLINE_ACTIVATED;
-		dev->dev_status &= ~ISCSI_DEVICE_OFFLINE_DEACTIVATED;
+	if ((dev->dev_status & TRANSPORT_DEVICE_ACTIVATED) ||
+	    (dev->dev_status & TRANSPORT_DEVICE_DEACTIVATED) ||
+	    (dev->dev_status & TRANSPORT_DEVICE_OFFLINE_ACTIVATED) ||
+	    (dev->dev_status & TRANSPORT_DEVICE_OFFLINE_DEACTIVATED)) {
+		dev->dev_status |= TRANSPORT_DEVICE_SHUTDOWN;
+		dev->dev_status &= ~TRANSPORT_DEVICE_ACTIVATED;
+		dev->dev_status &= ~TRANSPORT_DEVICE_DEACTIVATED;
+		dev->dev_status &= ~TRANSPORT_DEVICE_OFFLINE_ACTIVATED;
+		dev->dev_status &= ~TRANSPORT_DEVICE_OFFLINE_DEACTIVATED;
 
 		up(&dev->dev_queue_obj->thread_sem);
 	}
@@ -522,9 +522,9 @@ extern void dev_obj_clear_shutdown (void *p)
 	se_device_t *dev  = (se_device_t *)p;
 
 	spin_lock(&dev->dev_status_lock);
-	if (dev->dev_status & ISCSI_DEVICE_SHUTDOWN) {
-		dev->dev_status &= ~ISCSI_DEVICE_SHUTDOWN;
-		dev->dev_status |= ISCSI_DEVICE_DEACTIVATED;
+	if (dev->dev_status & TRANSPORT_DEVICE_SHUTDOWN) {
+		dev->dev_status &= ~TRANSPORT_DEVICE_SHUTDOWN;
+		dev->dev_status |= TRANSPORT_DEVICE_DEACTIVATED;
 	}
 	spin_unlock(&dev->dev_status_lock);
 
@@ -673,19 +673,14 @@ extern int dev_obj_task_failure_complete (void *p, se_cmd_t *cmd)
 	return(transport_failure_tasks_generic(cmd));
 }
 
-extern int dev_add_obj_to_lun (iscsi_portal_group_t *tpg, se_lun_t *lun)
+extern int dev_add_obj_to_lun (se_portal_group_t *tpg, se_lun_t *lun)
 {
 	return(0);
 }
 
-extern int dev_del_obj_from_lun (iscsi_portal_group_t *tpg, se_lun_t *lun)
+extern int dev_del_obj_from_lun (se_portal_group_t *tpg, se_lun_t *lun)
 {
-	struct target_core_fabric_ops *iscsi_tf = target_core_get_iscsi_ops();
-	
-	if (!(iscsi_tf))
-		BUG();
-
-	return(iscsi_tf->dev_del_lun(tpg, lun->iscsi_lun));
+	return(core_dev_del_lun(tpg, lun->unpacked_lun));
 }
 
 extern se_obj_lun_type_t *dev_get_next_obj_api (void *p, void **next_p)
@@ -708,7 +703,7 @@ extern int dev_release_obj_lock (void *p)
 }
 
 #define DEV_OBJ_PLUGIN {						\
-	se_obj_type:		ISCSI_LUN_TYPE_DEVICE,			\
+	se_obj_type:		TRANSPORT_LUN_TYPE_DEVICE,		\
 	get_obj_info:		dev_obj_get_obj_info,			\
 	get_plugin_info:	dev_obj_get_plugin_info,		\
 	get_obj:		dev_obj_get_obj,			\
@@ -816,7 +811,7 @@ extern int se_obj_load_plugins (void)
 	int ret = 0;
 	
 	dev_obj_template.obj_plugin = plugin_register((void *)&dev_obj_template,
-			ISCSI_LUN_TYPE_DEVICE, "dev", PLUGIN_TYPE_OBJ,
+			TRANSPORT_LUN_TYPE_DEVICE, "dev", PLUGIN_TYPE_OBJ,
 			dev_obj_template.get_plugin_info, &ret);
 	if (ret) {
 		TRACE_ERROR("plugin_register() failures\n");
diff --git a/drivers/lio-core/target_core_seobj.h b/drivers/lio-core/target_core_seobj.h
index f925fea..0de9826 100644
--- a/drivers/lio-core/target_core_seobj.h
+++ b/drivers/lio-core/target_core_seobj.h
@@ -53,8 +53,8 @@ typedef struct se_obj_lun_type_s {
 	void (*access_obj)(void *);
 	void (*deaccess_obj)(void *);
 	void (*put_obj)(void *);
-	int (*export_obj)(void *, struct iscsi_portal_group_s *, struct se_lun_s *);
-	void (*unexport_obj)(void *, struct iscsi_portal_group_s *, struct se_lun_s *);
+	int (*export_obj)(void *, struct se_portal_group_s *, struct se_lun_s *);
+	void (*unexport_obj)(void *, struct se_portal_group_s *, struct se_lun_s *);
 	int (*transport_setup_cmd)(void *, struct se_cmd_s *);
 	int (*active_tasks)(void *);
 	int (*add_tasks)(void *, struct se_cmd_s *);
@@ -102,8 +102,8 @@ typedef struct se_obj_lun_type_s {
 	void (*get_evpd_sn)(void *, unsigned char *, u32);
 	int (*get_task_timeout)(void *);
 	int (*task_failure_complete)(void *, struct se_cmd_s *);
-	int (*add_obj_to_lun)(struct iscsi_portal_group_s *, struct se_lun_s *);
-	int (*del_obj_from_lun)(struct iscsi_portal_group_s *, struct se_lun_s *);
+	int (*add_obj_to_lun)(struct se_portal_group_s *, struct se_lun_s *);
+	int (*del_obj_from_lun)(struct se_portal_group_s *, struct se_lun_s *);
 	struct se_obj_lun_type_s *(*get_next_obj_api)(void *, void **);
 	int (*obtain_obj_lock)(void *);
 	int (*release_obj_lock)(void *);
-- 
1.5.4.1



