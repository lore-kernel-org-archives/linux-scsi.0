From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH] [LIO-Target 4/14]: Updates for iSCSI Target Portal Group
	logic with generic portal group code
Date: Fri, 19 Dec 2008 15:32:12 -0800
Message-ID: <1229729532.4560.108.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1756463AbYLSXc6@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "Linux-iSCSI.org Target Dev" <linux-iscsi-target-dev@googlegroups.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

>From 497cfb7f51e89e991c6a89304c2f01cf6c3f2e94 Mon Sep 17 00:00:00 2001
From: Nicholas Bellinger <nab@linux-iscsi.org>
Date: Fri, 19 Dec 2008 14:02:34 -0800
Subject: [PATCH] [LIO-Target]: Updates for iSCSI Target Portal Group logic with generic portal group code

This patch adds the following functions that are used with struct target_core_fabric_ops:

lio_tpg_get_endpoint_wwn()
lio_tpg_get_tag()
lio_tpg_get_default_depth()
lio_tpg_check_demo_mode()
lio_tpg_check_demo_mode_cache()
lio_tpg_check_demo_mode_write_protect()
lio_tpg_release_node_acl()
lio_tpg_stop_session()
lio_tpg_fall_back_to_erl0()
lio_tpg_get_inst_index()
lio_set_default_node_attributes()

Also, core_load_discovery_tpg() is updated to use core_tpg_register(), as well as
core_release_discovery_tpg() updated to use core_tpg_deregister().

The following functions have been removed, and have been made generic in
target_core_tpg.c:

iscsi_clear_initiator_node_from_tpg()
__iscsi_tpg_get_initiator_node_acl()
iscsi_tpg_get_initiator_node_acl()
iscsi_tpg_add_node_to_devs()
iscsi_tpg_check_initiator_node_acl()
iscsi_tpg_free_portal_group_node_acls()
iscsi_tpg_clear_object_luns()
iscsi_tpg_pre_addlun()
iscsi_tpg_post_addlun()
iscsi_tpg_pre_dellun()
iscsi_tpg_post_dellun()

Also, iscsi_tpg_add_portal_group(), iscsi_tpg_del_portal_group() and
iscsi_tpg_set_initiator_node_queue_depth() have been updated to use
generic target_core_tpg.c code.

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/lio-core/iscsi_target_tpg.c |  809 ++++++-----------------------------
 drivers/lio-core/iscsi_target_tpg.h |   25 +-
 2 files changed, 157 insertions(+), 677 deletions(-)

diff --git a/drivers/lio-core/iscsi_target_tpg.c b/drivers/lio-core/iscsi_target_tpg.c
index d188163..4def3cb 100644
--- a/drivers/lio-core/iscsi_target_tpg.c
+++ b/drivers/lio-core/iscsi_target_tpg.c
@@ -47,16 +47,21 @@
 #include <iscsi_lists.h>
 #include <iscsi_debug.h>
 #include <iscsi_protocol.h>
-#include <iscsi_target_core.h>
+
 #include <target_core_base.h>
+#include <target_core_transport.h>
+#include <target_core_fabric_ops.h>
+#include <target_core_configfs.h>
+#include <target_core_hba.h>
+#include <target_core_tpg.h>
+
+#include <iscsi_target_core.h>
 #include <iscsi_target_device.h>
 #include <iscsi_target_erl0.h>
 #include <iscsi_target_error.h>
-#include <target_core_hba.h>
 #include <iscsi_target_login.h>
 #include <iscsi_target_nodeattrib.h>
 #include <iscsi_target_tpg.h>
-#include <target_core_transport.h>
 #include <iscsi_target_util.h>
 #include <iscsi_target.h>
 #include <iscsi_parameters.h>
@@ -67,13 +72,95 @@
 #undef ISCSI_TARGET_TPG_C
 
 extern iscsi_global_t *iscsi_global;
+extern struct target_fabric_configfs *lio_target_fabric_configfs;
 
 extern int iscsi_close_session (iscsi_session_t *); 
 extern int iscsi_free_session (iscsi_session_t *);
-extern int iscsi_stop_session (iscsi_session_t *, int, int);
 extern int iscsi_release_sessions_for_tpg (iscsi_portal_group_t *, int);
 extern int iscsi_ta_authentication (iscsi_portal_group_t *, __u32);
 
+extern char *lio_tpg_get_endpoint_wwn (se_portal_group_t *se_tpg)
+{
+	iscsi_portal_group_t *tpg = (iscsi_portal_group_t *)se_tpg->se_tpg_fabric_ptr;
+
+	return(&tpg->tpg_tiqn->tiqn[0]);
+}
+
+extern u32 lio_tpg_get_tag (se_portal_group_t *se_tpg)
+{
+	iscsi_portal_group_t *tpg = (iscsi_portal_group_t *)se_tpg->se_tpg_fabric_ptr;
+
+	return(tpg->tpgt);
+}
+
+extern u32 lio_tpg_get_default_depth (se_portal_group_t *se_tpg)
+{
+	iscsi_portal_group_t *tpg = (iscsi_portal_group_t *)se_tpg->se_tpg_fabric_ptr;
+
+	return(ISCSI_TPG_ATTRIB(tpg)->default_cmdsn_depth);
+}
+
+extern int lio_tpg_check_demo_mode (se_portal_group_t *se_tpg)
+{
+	iscsi_portal_group_t *tpg = (iscsi_portal_group_t *)se_tpg->se_tpg_fabric_ptr;
+
+	return(ISCSI_TPG_ATTRIB(tpg)->generate_node_acls);
+}
+
+extern int lio_tpg_check_demo_mode_cache (se_portal_group_t *se_tpg)
+{
+	iscsi_portal_group_t *tpg = (iscsi_portal_group_t *)se_tpg->se_tpg_fabric_ptr;
+
+	return(ISCSI_TPG_ATTRIB(tpg)->cache_dynamic_acls);
+}
+
+extern int lio_tpg_check_demo_mode_write_protect (se_portal_group_t *se_tpg)
+{
+	iscsi_portal_group_t *tpg = (iscsi_portal_group_t *)se_tpg->se_tpg_fabric_ptr;
+
+	return(ISCSI_TPG_ATTRIB(tpg)->demo_mode_write_protect);
+}
+
+extern void lio_tpg_release_node_acl (se_portal_group_t *se_tpg, se_node_acl_t *se_acl)
+{
+	iscsi_node_acl_t *acl = (iscsi_node_acl_t *)se_acl->fabric_acl_ptr;
+
+	kfree(acl);
+	return;
+}
+
+extern void lio_tpg_stop_session (se_session_t *se_sess, int sess_sleep, int conn_sleep)
+{
+	iscsi_session_t *sess = (iscsi_session_t *)se_sess->fabric_sess_ptr;
+
+	iscsi_stop_session(sess, sess_sleep, conn_sleep);
+	return;
+}
+
+extern void lio_tpg_fall_back_to_erl0 (se_session_t *se_sess)
+{
+	iscsi_session_t *sess = (iscsi_session_t *)se_sess->fabric_sess_ptr;
+
+	iscsi_fall_back_to_erl0(sess);	
+	return;
+}
+
+extern u32 lio_tpg_get_inst_index (se_portal_group_t *se_tpg)
+{
+	iscsi_portal_group_t *tpg = (iscsi_portal_group_t *)se_tpg->se_tpg_fabric_ptr;
+
+	return(tpg->tpg_tiqn->tiqn_index);
+}
+
+extern void lio_set_default_node_attributes (se_node_acl_t *se_acl)
+{
+	iscsi_node_acl_t *acl = (iscsi_node_acl_t *)se_acl->fabric_acl_ptr;
+
+	ISCSI_NODE_ATTRIB(acl)->nacl = acl;
+	iscsi_set_default_node_attribues(acl);
+	return;
+}
+
 /*	init_iscsi_portal_groups():
  *
  *
@@ -103,20 +190,23 @@ extern int core_load_discovery_tpg (void)
 	iscsi_param_t *param;
 	iscsi_portal_group_t *tpg;
 
-	if (!(tpg = kmalloc(sizeof(iscsi_portal_group_t), GFP_KERNEL))) {
+	if (!(tpg = kzalloc(sizeof(iscsi_portal_group_t), GFP_KERNEL))) {
 		TRACE_ERROR("Unable to allocate iscsi_portal_group_t\n");
 		return(-1);
 	}
-	memset(tpg, 0, sizeof(iscsi_portal_group_t));
 
-	tpg->sid        = 1; /* First Assigned iSBE Session ID */
+	if (!(tpg->tpg_se_tpg = core_tpg_register(
+			&lio_target_fabric_configfs->tf_ops, (void *)tpg,
+			TRANSPORT_TPG_TYPE_DISCOVERY))) {
+		kfree(tpg);
+		return(-1);
+	}
+
+	tpg->sid        = 1; /* First Assigned LIO Session ID */
 	INIT_LIST_HEAD(&tpg->tpg_gnp_list);
 	init_MUTEX(&tpg->tpg_access_sem);
 	spin_lock_init(&tpg->tpg_state_lock);
 	init_MUTEX(&tpg->np_login_sem);
-	spin_lock_init(&tpg->acl_node_lock);
-	spin_lock_init(&tpg->session_lock);
-	spin_lock_init(&tpg->tpg_lun_lock);
 	spin_lock_init(&tpg->tpg_np_lock);
 
 	iscsi_set_default_tpg_attribs(tpg);
@@ -143,13 +233,20 @@ extern int core_load_discovery_tpg (void)
 
 	return(0);
 out:
+	if (tpg->tpg_se_tpg)
+		core_tpg_deregister(tpg->tpg_se_tpg);
 	kfree(tpg);
 	return(-1);
 }
 
 extern void core_release_discovery_tpg (void)
 {
-	kfree(iscsi_global->discovery_tpg);
+	iscsi_portal_group_t *tpg = iscsi_global->discovery_tpg;
+
+	core_tpg_deregister(tpg->tpg_se_tpg);
+	tpg->tpg_se_tpg = NULL;
+
+	kfree(tpg);
 	iscsi_global->discovery_tpg = NULL;
 
 	return;
@@ -280,219 +377,6 @@ extern void iscsi_clear_tpg_np_login_threads (
 	return;
 }
 
-/*	iscsi_clear_initiator_node_from_tpg():
- *
- *
- */
-static void iscsi_clear_initiator_node_from_tpg (
-	iscsi_node_acl_t *nacl,
-	iscsi_portal_group_t *tpg)
-{
-	int i;
-	se_dev_entry_t *deve;
-	se_lun_t *lun;
-	se_lun_acl_t *acl;
-
-	spin_lock_bh(&nacl->device_list_lock);
-	for (i = 0; i < ISCSI_MAX_LUNS_PER_TPG; i++) {
-		deve = &nacl->device_list[i];
-
-		if (!(deve->lun_flags & ISCSI_LUNFLAGS_INITIATOR_ACCESS))
-			continue;
-
-		if (!deve->iscsi_lun) {
-			TRACE_ERROR("iSCSI device entries device pointer is"
-				" NULL, but Initiator has access.\n");
-			continue;
-		}
-
-		lun = deve->iscsi_lun;
-		spin_unlock_bh(&nacl->device_list_lock);
-		iscsi_update_device_list_for_node(lun, deve->mapped_lun,
-			ISCSI_LUNFLAGS_NO_ACCESS, nacl, tpg, 0);
-
-		spin_lock(&lun->lun_acl_lock);
-		for (acl = lun->lun_acl_head; acl; acl = acl->next) {
-			if (!(strcmp(acl->initiatorname, nacl->initiatorname)) &&
-			     (acl->mapped_lun == deve->mapped_lun))
-				break;
-		}
-
-		if (!acl) {
-			TRACE_ERROR("Unable to locate se_lun_acl_t for %s, mapped_lun: %u\n",
-				nacl->initiatorname, deve->mapped_lun);
-			spin_unlock(&lun->lun_acl_lock);
-			spin_lock_bh(&nacl->device_list_lock);
-			continue;
-		}
-		
-		REMOVE_ENTRY_FROM_LIST(acl, lun->lun_acl_head, lun->lun_acl_tail);
-		spin_unlock(&lun->lun_acl_lock);
-
-		spin_lock_bh(&nacl->device_list_lock);
-		kfree(acl);
-        }
-	spin_unlock_bh(&nacl->device_list_lock);
-
-	return;
-}
-
-/*	__iscsi_tpg_get_initiator_node_acl():
- *
- *	spin_lock_bh(&tpg->acl_node_lock); must be held when calling
- */
-extern iscsi_node_acl_t *__iscsi_tpg_get_initiator_node_acl (
-	iscsi_portal_group_t *tpg,
-	const char *initiatorname)
-{
-	iscsi_node_acl_t *acl;
-	
-	for (acl = tpg->acl_node_head; acl; acl = acl->next) {
-		if (!(strcmp(acl->initiatorname, initiatorname)))
-			return(acl);
-	}
-
-	return(NULL);
-}
-
-/*	iscsi_tpg_get_initiator_node_acl():
- *
- *
- */     
-extern iscsi_node_acl_t *iscsi_tpg_get_initiator_node_acl (
-	iscsi_portal_group_t *tpg,
-	unsigned char *initiatorname)
-{               
-	iscsi_node_acl_t *acl;
-		                
-	spin_lock_bh(&tpg->acl_node_lock);
-	for (acl = tpg->acl_node_head; acl; acl = acl->next) {
-		if (!(strcmp(acl->initiatorname, initiatorname)) &&
-		   (!(acl->nodeacl_flags & NAF_DYNAMIC_NODE_ACL))) {
-			spin_unlock_bh(&tpg->acl_node_lock);
-			return(acl);
-		}
-	}
-	spin_unlock_bh(&tpg->acl_node_lock);
-
-	return(NULL);
-}
-
-/*	iscsi_tpg_add_node_to_devs():
- *
- *
- */
-extern void iscsi_tpg_add_node_to_devs (
-	iscsi_node_acl_t *acl,
-	iscsi_portal_group_t *tpg)
-{
-	int i = 0;
-	u32 lun_access = 0;
-	se_lun_t *lun;
-
-	spin_lock(&tpg->tpg_lun_lock);
-	for (i = 0; i < ISCSI_MAX_LUNS_PER_TPG; i++) {
-		lun = &tpg->tpg_lun_list[i];
-		if (lun->lun_status != ISCSI_LUN_STATUS_ACTIVE)
-			continue;
-
-		spin_unlock(&tpg->tpg_lun_lock);
-
-		/*
-		 * By default, demo_mode_write_protect is ON, or READ_ONLY;
-		 */
-		if (!(ISCSI_TPG_ATTRIB(tpg)->demo_mode_write_protect)) {
-			if (LUN_OBJ_API(lun)->get_device_access) {
-				if (LUN_OBJ_API(lun)->get_device_access(lun->lun_type_ptr) == 0)
-					lun_access = ISCSI_LUNFLAGS_READ_ONLY;
-	                        else
-                	                lun_access = ISCSI_LUNFLAGS_READ_WRITE;
-			} else
-				lun_access = ISCSI_LUNFLAGS_READ_WRITE;
-		} else {
-                        /*
-                         * Allow only optical drives to issue R/W in default RO demo mode.
-                         */
-                        if (LUN_OBJ_API(lun)->get_device_type(lun->lun_type_ptr) == TYPE_DISK)
-                                lun_access = ISCSI_LUNFLAGS_READ_ONLY;
-			else
-				lun_access = ISCSI_LUNFLAGS_READ_WRITE;
-		}
-
-		PYXPRINT("TPG[%hu]_LUN[%u] - Adding %s access for LUN in Demo Mode\n",
-			tpg->tpgt, lun->iscsi_lun,
-			(lun_access == ISCSI_LUNFLAGS_READ_WRITE) ?
-			"READ-WRITE" : "READ-ONLY");
-
-		iscsi_update_device_list_for_node(lun, lun->iscsi_lun,
-				lun_access, acl, tpg, 1);
-		spin_lock(&tpg->tpg_lun_lock);
-	}
-	spin_unlock(&tpg->tpg_lun_lock);
-
-	return;
-}
-
-/*	iscsi_tpg_check_initiator_node_acl()
- *
- *
- */
-extern iscsi_node_acl_t *iscsi_tpg_check_initiator_node_acl (
-	iscsi_portal_group_t *tpg,
-	unsigned char *initiatorname)
-{
-	iscsi_node_acl_t *acl;
-
-	if ((acl = iscsi_tpg_get_initiator_node_acl(tpg, initiatorname)))
-		return(acl);
-
-	if (!ISCSI_TPG_ATTRIB(tpg)->generate_node_acls)
-		return(NULL);
-
-	if (!(acl = (iscsi_node_acl_t *) kmalloc(
-			sizeof(iscsi_node_acl_t), GFP_KERNEL))) {
-		TRACE_ERROR("Unable to allocate memory for iscsi_node_acl_t.\n");
-		return(NULL);
-	}
-	memset((void *)acl, 0, sizeof(iscsi_node_acl_t));
-
-	spin_lock_init(&acl->device_list_lock);
-	spin_lock_init(&acl->nacl_sess_lock);
-	acl->queue_depth = ISCSI_TPG_ATTRIB(tpg)->default_cmdsn_depth;
-	snprintf(acl->initiatorname, ISCSI_IQN_LEN, "%s", initiatorname);
-	acl->tpg = tpg;
-#ifdef SNMP_SUPPORT
-        acl->acl_index = scsi_get_new_index(SCSI_AUTH_INTR_INDEX);
-        spin_lock_init(&acl->stats_lock);
-#endif /* SNMP_SUPPORT */
-	acl->nodeacl_flags |= NAF_DYNAMIC_NODE_ACL;
-
-	iscsi_set_default_node_attribues(acl);
-
-	if (iscsi_create_device_list_for_node(acl, tpg)  < 0) {
-		kfree(acl);
-		return(NULL);
-	}
-
-	if (iscsi_set_queue_depth_for_node(tpg, acl) < 0) {
-		iscsi_free_device_list_for_node(acl, tpg);
-		kfree(acl);
-		return(NULL);
-	}
-
-	iscsi_tpg_add_node_to_devs(acl, tpg);
-
-	spin_lock_bh(&tpg->acl_node_lock);
-	ADD_ENTRY_TO_LIST(acl, tpg->acl_node_head, tpg->acl_node_tail);
-	tpg->num_node_acls++;
-	spin_unlock_bh(&tpg->acl_node_lock);
-
-	PYXPRINT("iSCSI_TPG[%hu] - Added DYNAMIC ACL with TCQ Depth: %d for iSCSI"
-		" Initiator Node: %s\n", tpg->tpgt, acl->queue_depth, initiatorname);
-
-	return(acl);
-}
-
 /*	iscsi_tpg_dump_params():
  *
  *
@@ -549,38 +433,6 @@ static void iscsi_tpg_free_network_portals (iscsi_portal_group_t *tpg)
 	return;
 }
 
-/*	iscsi_tpg_free_portal_group_node_acls():
- *
- *
- */
-static void iscsi_tpg_free_portal_group_node_acls (iscsi_portal_group_t *tpg)
-{
-	iscsi_node_acl_t *acl = NULL, *acl_next = NULL;
-
-	spin_lock_bh(&tpg->acl_node_lock);
-	acl = tpg->acl_node_head;
-	while (acl) {
-		acl_next = acl->next;
-
-		/*
-		 * The kfree() for dynamically allocated Node ACLS is done in
-		 * iscsi_close_session().
-		 */
-		if (acl->nodeacl_flags & NAF_DYNAMIC_NODE_ACL) {
-			acl = acl_next;
-			continue;
-		}
-
-		kfree(acl);
-		tpg->num_node_acls--;
-		acl = acl_next;
-	}
-	tpg->acl_node_head = tpg->acl_node_tail = NULL;
-	spin_unlock_bh(&tpg->acl_node_lock);
-
-	return;
-}	
-
 /*	iscsi_set_default_tpg_attribs():
  *
  *
@@ -608,50 +460,29 @@ static void iscsi_set_default_tpg_attribs (iscsi_portal_group_t *tpg)
  */
 extern int iscsi_tpg_add_portal_group (iscsi_tiqn_t *tiqn, iscsi_portal_group_t *tpg)
 {
-	int i;
-	se_lun_t *lun;
-	
 	if (tpg->tpg_state != TPG_STATE_FREE) {
 		TRACE_ERROR("Unable to add iSCSI Target Portal Group: %d while"
 			" not in TPG_STATE_FREE state.\n", tpg->tpgt);
 		return(ERR_ADDTPG_ALREADY_EXISTS);
 	}
 
-	iscsi_set_default_tpg_attribs(tpg);
-
-	if (!(tpg->tpg_lun_list = kmalloc((sizeof(se_lun_t) * ISCSI_MAX_LUNS_PER_TPG), GFP_KERNEL))) {
-		TRACE_ERROR("Unable to allocate memory for tpg->tpg_lun_list\n");
+	if (!(tpg->tpg_se_tpg = core_tpg_register(
+			&lio_target_fabric_configfs->tf_ops, (void *)tpg,
+			TRANSPORT_TPG_TYPE_NORMAL)))
 		goto err_out;
-	}
-	memset(tpg->tpg_lun_list, 0, (sizeof(se_lun_t) * ISCSI_MAX_LUNS_PER_TPG));
+
+	iscsi_set_default_tpg_attribs(tpg);
 
 	if (iscsi_create_default_params(&tpg->param_list) < 0)
 		goto err_out;
 
-	tpg->sid	= 1; /* First Assigned iSBE Session ID */
+	tpg->sid	= 1; /* First Assigned LIO-Target Session ID */
 	INIT_LIST_HEAD(&tpg->tpg_gnp_list);
 	init_MUTEX(&tpg->np_login_sem);
-	spin_lock_init(&tpg->acl_node_lock);
-	spin_lock_init(&tpg->session_lock);
-	spin_lock_init(&tpg->tpg_lun_lock);
 	spin_lock_init(&tpg->tpg_np_lock);
 
 	ISCSI_TPG_ATTRIB(tpg)->tpg = tpg;
 
-	for (i = 0; i < ISCSI_MAX_LUNS_PER_TPG; i++) {
-		lun = &tpg->tpg_lun_list[i];
-		lun->iscsi_lun = i;
-		lun->lun_type_ptr = NULL;
-		lun->persistent_reservation_check = &iscsi_tpg_persistent_reservation_check;
-		lun->persistent_reservation_release = &iscsi_tpg_persistent_reservation_release;
-		lun->persistent_reservation_reserve = &iscsi_tpg_persistent_reservation_reserve;
-		lun->lun_status = ISCSI_LUN_STATUS_FREE;
-		spin_lock_init(&lun->lun_acl_lock);
-		spin_lock_init(&lun->lun_cmd_lock);
-		spin_lock_init(&lun->lun_reservation_lock);
-		spin_lock_init(&lun->lun_sep_lock);
-	}
-
 	spin_lock(&tpg->tpg_state_lock);
 	tpg->tpg_state	= TPG_STATE_INACTIVE;
 	spin_unlock(&tpg->tpg_state_lock);
@@ -665,38 +496,16 @@ extern int iscsi_tpg_add_portal_group (iscsi_tiqn_t *tiqn, iscsi_portal_group_t
 	return(0);
 
 err_out:
-	kfree(tpg->tpg_lun_list);
+	if (tpg->tpg_se_tpg)
+		core_tpg_deregister(tpg->tpg_se_tpg);
 	if (tpg->param_list) {
 		iscsi_release_param_list(tpg->param_list);
 		tpg->param_list = NULL;
 	}
-	if (tpg)
-		kfree(tpg);
+	kfree(tpg);
 	return(ERR_NO_MEMORY);
 }	
 
-static void iscsi_tpg_clear_object_luns (iscsi_portal_group_t *tpg)
-{
-	int i, ret;
-	se_lun_t *lun;
-
-	spin_lock(&tpg->tpg_lun_lock);
-	for (i = 0; i < ISCSI_MAX_LUNS_PER_TPG; i++) {
-		lun = &tpg->tpg_lun_list[i];
-
-		if ((lun->lun_status != ISCSI_LUN_STATUS_ACTIVE) ||
-		    (lun->lun_type_ptr == NULL))
-			continue;
-
-		spin_unlock(&tpg->tpg_lun_lock);
-		ret = LUN_OBJ_API(lun)->del_obj_from_lun(tpg, lun);
-		spin_lock(&tpg->tpg_lun_lock);
-	}
-	spin_unlock(&tpg->tpg_lun_lock);
-
-	return;
-}
-
 extern int iscsi_tpg_del_portal_group (
 	iscsi_tiqn_t *tiqn,
 	iscsi_portal_group_t *tpg,
@@ -717,17 +526,17 @@ extern int iscsi_tpg_del_portal_group (
 		return(ERR_DELTPG_SESSIONS_ACTIVE);
 	}
 
-	iscsi_tpg_clear_object_luns(tpg);
+	core_tpg_clear_object_luns(tpg->tpg_se_tpg);
 	iscsi_tpg_free_network_portals(tpg);
-	iscsi_tpg_free_portal_group_node_acls(tpg);
+	core_tpg_free_node_acls(tpg->tpg_se_tpg);
 	
 	if (tpg->param_list) {
 		iscsi_release_param_list(tpg->param_list);
 		tpg->param_list = NULL;
 	}
 
-	kfree(tpg->tpg_lun_list);
-	tpg->tpg_lun_list = NULL;
+	core_tpg_deregister(tpg->tpg_se_tpg);
+	tpg->tpg_se_tpg = NULL;
 
 	spin_lock(&tpg->tpg_state_lock);
 	tpg->tpg_state = TPG_STATE_FREE;
@@ -843,72 +652,22 @@ extern int iscsi_tpg_disable_portal_group (iscsi_portal_group_t *tpg, int force)
 extern iscsi_node_acl_t *iscsi_tpg_add_initiator_node_acl (
 	iscsi_portal_group_t *tpg,
 	const char *initiatorname,
-	__u32 queue_depth,
+	u32 queue_depth,
 	int *ret)
 {
 	iscsi_node_acl_t *acl = NULL;
 
-	spin_lock_bh(&tpg->acl_node_lock);
-	if ((acl = __iscsi_tpg_get_initiator_node_acl(tpg, initiatorname))) {
-		if (acl->nodeacl_flags & NAF_DYNAMIC_NODE_ACL) {
-			acl->nodeacl_flags &= ~NAF_DYNAMIC_NODE_ACL;
-			PYXPRINT("iSCSI_TPG[%hu] - Replacing dynamic ACL for"
-				" %s\n", tpg->tpgt, initiatorname);
-			spin_unlock_bh(&tpg->acl_node_lock);
-			goto done;
-		}
-
-		TRACE_ERROR("ACL entry for iSCSI Initiator"
-			" Node %s already exists for TPG %hu, ignoring"
-			" request.\n", initiatorname, tpg->tpgt);
-		spin_unlock_bh(&tpg->acl_node_lock);
-		*ret = ERR_ADDINITACL_ACL_EXISTS;
-		return(NULL);
-	}
-	spin_unlock_bh(&tpg->acl_node_lock);
-
-	if (!(acl = (iscsi_node_acl_t *) kmalloc(
-			sizeof(iscsi_node_acl_t), GFP_KERNEL))) {
-		TRACE_ERROR("Unable to allocate memory for iscsi_node_acl_t.\n");
-		*ret = ERR_NO_MEMORY;
+	if (!(acl = kzalloc(sizeof(iscsi_node_acl_t), GFP_KERNEL))) {	
+		printk(KERN_ERR "Unable to allocate memory for iscsi_node_acl_t\n");
 		return(NULL);
 	}
-	memset((void *)acl, 0, sizeof(iscsi_node_acl_t));
 
-	spin_lock_init(&acl->device_list_lock);
-	acl->queue_depth = queue_depth;
-	snprintf(acl->initiatorname, ISCSI_IQN_LEN, "%s", initiatorname);
-	acl->tpg = tpg;
-	ISCSI_NODE_ATTRIB(acl)->nacl = acl;
-#ifdef SNMP_SUPPORT
-	acl->acl_index = scsi_get_new_index(SCSI_AUTH_INTR_INDEX);
-	spin_lock_init(&acl->stats_lock);
-#endif /* SNMP_SUPPORT */
-
-	iscsi_set_default_node_attribues(acl);
-      
-	if (iscsi_create_device_list_for_node(acl, tpg)  < 0) {
+	if (!(acl->se_node_acl = core_tpg_add_initiator_node_acl(tpg->tpg_se_tpg,
+			(void *)acl, initiatorname, queue_depth, ret))) {
 		kfree(acl);
-		*ret = ERR_NO_MEMORY;
 		return(NULL);
 	}
-	
-	if (iscsi_set_queue_depth_for_node(tpg, acl) < 0) {
-		iscsi_free_device_list_for_node(acl, tpg);
-		kfree(acl);
-		*ret = ERR_ADDINITACL_QUEUE_SET_FAILED;
-		return(NULL);
-	}
-	
-	spin_lock_bh(&tpg->acl_node_lock);
-	ADD_ENTRY_TO_LIST(acl, tpg->acl_node_head, tpg->acl_node_tail);
-	tpg->num_node_acls++;
-	spin_unlock_bh(&tpg->acl_node_lock);
-
-done:
-	PYXPRINT("iSCSI_TPG[%hu] - Added ACL with TCQ Depth: %d for iSCSI"
-		" Initiator Node: %s\n", tpg->tpgt, acl->queue_depth,
-			initiatorname);
+
 	return(acl);
 }
 
@@ -921,83 +680,24 @@ extern int iscsi_tpg_del_initiator_node_acl (
 	const char *initiatorname,
 	int force)
 {
-	int dynamic_acl = 0;
-	iscsi_session_t *sess;
-	iscsi_node_acl_t *acl;
-
-	spin_lock_bh(&tpg->acl_node_lock);
-	if (!(acl = __iscsi_tpg_get_initiator_node_acl(tpg, initiatorname))) {
-		TRACE_ERROR("Access Control List entry for iSCSI Initiator"
-			" Node %s does not exists for TPG %hu, ignoring"
-			" request.\n", initiatorname, tpg->tpgt);
-		spin_unlock_bh(&tpg->acl_node_lock);
-		return(ERR_INITIATORACL_DOES_NOT_EXIST);
-	}
-	if (acl->nodeacl_flags & NAF_DYNAMIC_NODE_ACL) {
-		acl->nodeacl_flags &= ~NAF_DYNAMIC_NODE_ACL;
-		dynamic_acl = 1;
-	}
-	spin_unlock_bh(&tpg->acl_node_lock);
-	
-	spin_lock_bh(&tpg->session_lock);
-	for (sess = tpg->session_head; sess; sess = sess->next) {
-		if (sess->node_acl != acl)
-			continue;
-
-		if (!force) {
-			TRACE_ERROR("Unable to delete Access Control List for"
-			" iSCSI Initiator Node: %s while session is operational."
-			"  To forcefully delete the session use the \"force=1\""
-				" parameter.\n", initiatorname);
-			spin_unlock_bh(&tpg->session_lock);
-			spin_lock_bh(&tpg->acl_node_lock);
-			if (dynamic_acl)
-				acl->nodeacl_flags |= NAF_DYNAMIC_NODE_ACL;
-			spin_unlock_bh(&tpg->acl_node_lock);
-			return(ERR_INITIATORACL_SESSION_EXISTS);
-		}
-		spin_lock(&sess->conn_lock);
-		if (atomic_read(&sess->session_fall_back_to_erl0) ||
-		    atomic_read(&sess->session_logout) ||
-		    (sess->time2retain_timer_flags & T2R_TF_EXPIRED)) {
-			spin_unlock(&sess->conn_lock);
-			continue;
-		}
-		atomic_set(&sess->session_reinstatement, 1);
-		spin_unlock(&sess->conn_lock);
-
-		iscsi_inc_session_usage_count(sess);
-		iscsi_stop_time2retain_timer(sess);
-		break;
-	}
-	spin_unlock_bh(&tpg->session_lock);
-		
-	spin_lock_bh(&tpg->acl_node_lock);
-	REMOVE_ENTRY_FROM_LIST(acl, tpg->acl_node_head, tpg->acl_node_tail);
-	tpg->num_node_acls--;
-	spin_unlock_bh(&tpg->acl_node_lock);
-	
 	/*
-	 * If the iSCSI Session for the iSCSI Initiator Node exists,
-	 * forcefully shutdown the iSCSI NEXUS.
+	 * TPG_TFO(tpg)->tpg_release_acl() will kfree the iscsi_node_acl_t..
 	 */
-	if (sess) {
-		iscsi_stop_session(sess, 1, 1);
-		iscsi_dec_session_usage_count(sess);
-		iscsi_close_session(sess);
-	}
-	
-	iscsi_clear_initiator_node_from_tpg(acl, tpg);
-	iscsi_free_device_list_for_node(acl, tpg);
+	core_tpg_del_initiator_node_acl(tpg->tpg_se_tpg, initiatorname, force);
 
-	PYXPRINT("iSCSI_TPG[%hu] - Deleted ACL with TCQ Depth: %d for iSCSI"
-		" Initiator Node: %s\n", tpg->tpgt, acl->queue_depth,
-			initiatorname);
-	kfree(acl);
-	
 	return(0);
 }
 
+extern iscsi_node_attrib_t *iscsi_tpg_get_node_attrib (
+	iscsi_session_t *sess)
+{
+	se_session_t *se_sess = sess->se_sess;
+	se_node_acl_t *se_nacl = se_sess->se_node_acl;
+	iscsi_node_acl_t *acl = (iscsi_node_acl_t *)se_nacl->fabric_acl_ptr;
+
+	return(&acl->node_attrib);
+}	
+
 extern iscsi_tpg_np_t *iscsi_tpg_locate_child_np (
 	iscsi_tpg_np_t *tpg_np,
 	int network_transport)
@@ -1193,236 +893,11 @@ extern int iscsi_tpg_del_network_portal (
 extern int iscsi_tpg_set_initiator_node_queue_depth (
 	iscsi_portal_group_t *tpg,
 	unsigned char *initiatorname,
-	__u32 queue_depth,
+	u32 queue_depth,
 	int force)
 {
-	int dynamic_acl = 0;
-	iscsi_session_t *sess = NULL;
-	iscsi_node_acl_t *acl;
-	
-	spin_lock_bh(&tpg->acl_node_lock);
-	if (!(acl = __iscsi_tpg_get_initiator_node_acl(tpg, initiatorname))) {
-		TRACE_ERROR("Access Control List entry for iSCSI Initiator"
-			" Node %s does not exists for TPG %hu, ignoring"
-			" request.\n", initiatorname, tpg->tpgt);
-		spin_unlock_bh(&tpg->acl_node_lock);
-		return(-ENODEV);
-	}
-	if (acl->nodeacl_flags & NAF_DYNAMIC_NODE_ACL) {
-		acl->nodeacl_flags &= ~NAF_DYNAMIC_NODE_ACL;
-		dynamic_acl = 1;
-	}
-	spin_unlock_bh(&tpg->acl_node_lock);
-	
-	spin_lock_bh(&tpg->session_lock);
-	for (sess = tpg->session_head; sess; sess = sess->next) {
-		if (sess->node_acl != acl)
-			continue;
-
-		if (!force) {
-			TRACE_ERROR("Unable to change queue depth for iSCSI Initiator"
-				" Node: %s while session is operational.  To forcefully"
-				" change the queue depth and force session reinstatement"
-				" use the \"force=1\" parameter.\n", initiatorname);
-			spin_unlock_bh(&tpg->session_lock);
-			spin_lock_bh(&tpg->acl_node_lock);
-			if (dynamic_acl)
-				acl->nodeacl_flags |= NAF_DYNAMIC_NODE_ACL;
-			spin_unlock_bh(&tpg->acl_node_lock);
-			return(-EEXIST);
-		}
-		spin_lock(&sess->conn_lock);
-		if (atomic_read(&sess->session_fall_back_to_erl0) ||
-		    atomic_read(&sess->session_logout) ||
-		    (sess->time2retain_timer_flags & T2R_TF_EXPIRED)) {
-			spin_unlock(&sess->conn_lock);
-			continue;
-		}
-		atomic_set(&sess->session_reinstatement, 1);
-		spin_unlock(&sess->conn_lock);
-
-		iscsi_inc_session_usage_count(sess);
-		iscsi_stop_time2retain_timer(sess);
-		break;
-	}
-
-	/*
-	 * User has requested to change the queue depth for a iSCSI Initiator Node.
-	 * Change the value in the Node's iscsi_node_acl_t, and call
-	 * iscsi_set_queue_depth_for_node() to add the requested queue
-	 * depth into the TPG HBA's outstanding queue depth.
-	 * Finally call iscsi_free_session() to force session reinstatement to occur if
-	 * there is an active session for the iSCSI Initiator Node in question.
-	 */
-	acl->queue_depth = queue_depth;
-
-	if (iscsi_set_queue_depth_for_node(tpg, acl) < 0) {
-		spin_unlock_bh(&tpg->session_lock);
-		if (sess)
-			iscsi_dec_session_usage_count(sess);
-		spin_lock_bh(&tpg->acl_node_lock);
-		if (dynamic_acl)
-			acl->nodeacl_flags |= NAF_DYNAMIC_NODE_ACL;
-		spin_unlock_bh(&tpg->acl_node_lock);
-		return(-EINVAL);
-	}
-	spin_unlock_bh(&tpg->session_lock);
-
-	if (sess) {
-		iscsi_stop_session(sess, 1, 1);
-		iscsi_dec_session_usage_count(sess);
-		iscsi_close_session(sess);
-	}	
-
-	PYXPRINT("Successfuly changed queue depth to: %d for Initiator Node:"
-		" %s on iSCSI Target Portal Group: %hu\n", queue_depth,
-			initiatorname, tpg->tpgt);
-
-	spin_lock_bh(&tpg->acl_node_lock);
-	if (dynamic_acl)
-		acl->nodeacl_flags |= NAF_DYNAMIC_NODE_ACL;
-	spin_unlock_bh(&tpg->acl_node_lock);
-		
-	return(0);
-}
-
-extern se_lun_t *iscsi_tpg_pre_addlun (
-	iscsi_portal_group_t *tpg,
-	u32 iscsi_lun,
-	int *ret)
-{
-	se_lun_t *lun;
-	
-	if (iscsi_lun > (ISCSI_MAX_LUNS_PER_TPG-1)) {
-		TRACE_ERROR("iSCSI LUN: %u exceeds ISCSI_MAX_LUNS_PER_TPG-1:"
-			" %u for Target Portal Group: %hu\n", iscsi_lun,
-			ISCSI_MAX_LUNS_PER_TPG-1, tpg->tpgt);
-		*ret = ERR_LUN_EXCEEDS_MAX;
-		return(NULL);
-	}
-
-	spin_lock(&tpg->tpg_lun_lock);
-	lun = &tpg->tpg_lun_list[iscsi_lun];
-	if (lun->lun_status == ISCSI_LUN_STATUS_ACTIVE) {
-		TRACE_ERROR("iSCSI Logical Unit Number: %u is already active"
-			" on iSCSI Target Portal Group: %hu, ignoring request.\n",
-				iscsi_lun, tpg->tpgt);
-		spin_unlock(&tpg->tpg_lun_lock);
-		*ret = ERR_ADDLUN_ALREADY_ACTIVE;
-		return(NULL);
-	}
-	spin_unlock(&tpg->tpg_lun_lock);
-
-	return(lun);
-}
-	
-extern int iscsi_tpg_post_addlun (
-	iscsi_portal_group_t *tpg,
-	se_lun_t *lun,
-	int lun_type,
-	u32 lun_access,
-	void *lun_ptr,
-	struct se_obj_lun_type_s *obj_api)
-{
-	lun->lun_obj_api = obj_api;
-	lun->lun_type_ptr = lun_ptr;
-	if (LUN_OBJ_API(lun)->export_obj(lun_ptr, tpg, lun) < 0) {
-		lun->lun_type_ptr = NULL;
-		lun->lun_obj_api = NULL;
-		return(-1);
-	}
-	
-	spin_lock(&tpg->tpg_lun_lock);
-	lun->lun_access = lun_access;
-	lun->lun_type = lun_type;
-	lun->lun_status = ISCSI_LUN_STATUS_ACTIVE;
-	spin_unlock(&tpg->tpg_lun_lock);
-
-	spin_lock(&tpg->tpg_state_lock);
-	tpg->nluns++;
-	tpg->ndevs++;
-	spin_unlock(&tpg->tpg_state_lock);
-
-	return(0);
-}
-
-extern se_lun_t *iscsi_tpg_pre_dellun (
-	iscsi_portal_group_t *tpg,
-	u32 iscsi_lun,
-	int lun_type,
-	int *ret)
-{
-	se_lun_t *lun;
-	
-	if (iscsi_lun > (ISCSI_MAX_LUNS_PER_TPG-1)) {
-		TRACE_ERROR("iSCSI LUN: %u exceeds ISCSI_MAX_LUNS_PER_TPG-1:"
-			" %u for Target Portal Group: %hu\n", iscsi_lun,
-			ISCSI_MAX_LUNS_PER_TPG-1, tpg->tpgt);
-		*ret = ERR_LUN_EXCEEDS_MAX;
-		return(NULL);
-	}
-
-	spin_lock(&tpg->tpg_lun_lock);
-	lun = &tpg->tpg_lun_list[iscsi_lun];
-	if (lun->lun_status != ISCSI_LUN_STATUS_ACTIVE) {
-		TRACE_ERROR("iSCSI Logical Unit Number: %u is not active on"
-			" iSCSI Target Portal Group: %hu, ignoring request.\n",
-				iscsi_lun, tpg->tpgt);
-		spin_unlock(&tpg->tpg_lun_lock);
-		*ret = ERR_DELLUN_NOT_ACTIVE;
-		return(NULL);
-	}
-
-	if (lun->lun_type != lun_type) {
-		TRACE_ERROR("iSCSI Logical Unit Number: %u type: %d does not"
-			" match passed type: %d\n", iscsi_lun, lun->lun_type,
-				lun_type);
-		spin_unlock(&tpg->tpg_lun_lock);
-		*ret = ERR_DELLUN_TYPE_MISMATCH;
-		return(NULL);
-	}
-	spin_unlock(&tpg->tpg_lun_lock);
-
-	iscsi_clear_lun_from_tpg(lun, tpg);
-
-	return(lun);
-}
-
-extern int iscsi_tpg_post_dellun (
-	iscsi_portal_group_t *tpg,
-	se_lun_t *lun)
-{
-	se_lun_acl_t *acl, *acl_next;
-	
-	transport_clear_lun_from_sessions(lun);
-
-	LUN_OBJ_API(lun)->unexport_obj(lun->lun_type_ptr, tpg, lun);
-	LUN_OBJ_API(lun)->release_obj(lun->lun_type_ptr);
-	
-	spin_lock(&tpg->tpg_lun_lock);
-	lun->lun_status = ISCSI_LUN_STATUS_FREE;
-	lun->lun_type = 0;
-	lun->lun_type_ptr = NULL;
-	spin_unlock(&tpg->tpg_lun_lock);
-
-	spin_lock(&lun->lun_acl_lock);
-	acl = lun->lun_acl_head;
-	while (acl) {
-		acl_next = acl->next;
-		kfree(acl);
-		acl = acl_next;
-	}
-	lun->lun_acl_head = lun->lun_acl_tail = NULL;
-	spin_unlock(&lun->lun_acl_lock);
-
-	spin_lock(&tpg->tpg_state_lock);
-	tpg->nluns--;
-	tpg->ndevs--;
-	spin_unlock(&tpg->tpg_state_lock);
-
-	
-	
-	return(0);	
+	return(core_tpg_set_initiator_node_queue_depth(tpg->tpg_se_tpg,
+		initiatorname, queue_depth, force));
 }
 
 /*	iscsi_ta_authentication():
diff --git a/drivers/lio-core/iscsi_target_tpg.h b/drivers/lio-core/iscsi_target_tpg.h
index 7e8fa42..6b4554f 100644
--- a/drivers/lio-core/iscsi_target_tpg.h
+++ b/drivers/lio-core/iscsi_target_tpg.h
@@ -29,6 +29,18 @@
 #ifndef ISCSI_TARGET_TPG_H
 #define ISCSI_TARGET_TPG_H
 
+extern char *lio_tpg_get_endpoint_wwn (struct se_portal_group_s *);
+extern u32 lio_tpg_get_tag (struct se_portal_group_s *);
+extern u32 lio_tpg_get_default_depth (struct se_portal_group_s *);
+extern int lio_tpg_check_demo_mode (struct se_portal_group_s *);
+extern int lio_tpg_check_demo_mode_cache (struct se_portal_group_s *);
+extern int lio_tpg_check_demo_mode_write_protect (struct se_portal_group_s *);
+extern void lio_tpg_release_node_acl (struct se_portal_group_s *, struct se_node_acl_s *);
+extern void lio_tpg_stop_session (struct se_session_s *, int, int);
+extern void lio_tpg_fall_back_to_erl0 (struct se_session_s *);
+extern u32 lio_tpg_get_inst_index (struct se_portal_group_s *);
+extern void lio_set_default_node_attributes (struct se_node_acl_s *);
+
 extern void init_iscsi_portal_groups (struct iscsi_tiqn_s *);
 extern int core_load_discovery_tpg (void);
 extern void core_release_discovery_tpg (void);
@@ -36,26 +48,19 @@ extern iscsi_portal_group_t *core_get_tpg_from_np (struct iscsi_tiqn_s *, struct
 extern iscsi_portal_group_t *iscsi_get_tpg_from_tpgt (struct iscsi_tiqn_s *, __u16, int);
 extern void iscsi_put_tpg (iscsi_portal_group_t *);
 extern void iscsi_clear_tpg_np_login_threads (iscsi_portal_group_t *, int);
-extern iscsi_node_acl_t *__iscsi_tpg_get_initiator_node_acl (iscsi_portal_group_t *, const char *);
-extern void iscsi_tpg_add_node_to_devs (iscsi_node_acl_t *, iscsi_portal_group_t *);
-extern iscsi_node_acl_t *iscsi_tpg_get_initiator_node_acl (iscsi_portal_group_t *, unsigned char *);
-extern iscsi_node_acl_t *iscsi_tpg_check_initiator_node_acl (iscsi_portal_group_t *, unsigned char *);
 extern void iscsi_tpg_dump_params (iscsi_portal_group_t *);
 extern int iscsi_tpg_add_portal_group (iscsi_tiqn_t *, iscsi_portal_group_t *);
 extern int iscsi_tpg_del_portal_group (iscsi_tiqn_t *, iscsi_portal_group_t *, int);
 extern int iscsi_tpg_enable_portal_group (iscsi_portal_group_t *);
 extern int iscsi_tpg_disable_portal_group (iscsi_portal_group_t *, int);
-extern iscsi_node_acl_t *iscsi_tpg_add_initiator_node_acl (iscsi_portal_group_t *, const char *, __u32, int *);
+extern iscsi_node_acl_t *iscsi_tpg_add_initiator_node_acl (iscsi_portal_group_t *, const char *, u32, int *);
 extern int iscsi_tpg_del_initiator_node_acl (iscsi_portal_group_t *, const char *, int);
+extern iscsi_node_attrib_t *iscsi_tpg_get_node_attrib (iscsi_session_t *);
 extern void iscsi_tpg_del_external_nps (iscsi_tpg_np_t *);
 extern iscsi_tpg_np_t *iscsi_tpg_locate_child_np (iscsi_tpg_np_t *, int);
 extern iscsi_tpg_np_t *iscsi_tpg_add_network_portal (iscsi_portal_group_t *, iscsi_np_addr_t *, iscsi_tpg_np_t *, int);
 extern int iscsi_tpg_del_network_portal (iscsi_portal_group_t *, iscsi_tpg_np_t *);
-extern int iscsi_tpg_set_initiator_node_queue_depth (iscsi_portal_group_t *, unsigned char *, __u32, int);
-extern se_lun_t *iscsi_tpg_pre_addlun (iscsi_portal_group_t *, u32, int *);
-extern int iscsi_tpg_post_addlun (iscsi_portal_group_t *, se_lun_t *, int, u32, void *, struct se_obj_lun_type_s *);
-extern se_lun_t *iscsi_tpg_pre_dellun (iscsi_portal_group_t *, u32, int, int *);
-extern int iscsi_tpg_post_dellun (iscsi_portal_group_t *, se_lun_t *);
+extern int iscsi_tpg_set_initiator_node_queue_depth (iscsi_portal_group_t *, unsigned char *, u32, int);
 extern int iscsi_ta_authentication (iscsi_portal_group_t *, u32);
 extern int iscsi_ta_login_timeout (iscsi_portal_group_t *, u32);
 extern int iscsi_ta_netif_timeout (iscsi_portal_group_t *, u32);
-- 
1.5.4.1
