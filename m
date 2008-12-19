From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH] [Target_Core_Mod 3/6]: Updates for
	transport_[register,deregister]_session() logic
Date: Fri, 19 Dec 2008 15:26:30 -0800
Message-ID: <1229729190.4560.89.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp122.sbc.mail.sp1.yahoo.com ([69.147.64.95]:28905 "HELO
	smtp122.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755431AbYLSX07 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 19 Dec 2008 18:26:59 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Linux-iSCSI.org Target Dev" <linux-iscsi-target-dev@googlegroups.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>

>From 905f1f1bb20cc7f7ca20039e6e43c4195e8911d3 Mon Sep 17 00:00:00 2001
From: Nicholas Bellinger <nab@linux-iscsi.org>
Date: Fri, 19 Dec 2008 13:12:55 -0800
Subject: [PATCH] [Target_Core_Mod]: Updates for transport_[register,deregister]_session() logic

This patch adds __transport_register_session(), and makes transport_register_session()
a wrapper for the former with se_portal_group_t->session_lock held.

This patch also adds transport_deregister_session_configfs(), and updates
transport_deregister_session() with NAF_DYNAMIC_NODE_ACL logic.

Also, this patch reenables PYX_TRANSPORT_OUT_OF_MEMORY_RESOURCES in
transport_generic_request_failure(), removes some stubbed code from
transport_allocate_passthrough() and transport_release_cmd_to_pool()
which has now been made generic.

Also, this patch core_tpg_persistent_reservation_*() to use
se_session_t->se_node_acl.

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/lio-core/target_core_transport.c |  247 ++++++++++++++++--------------
 drivers/lio-core/target_core_transport.h |    6 +-
 2 files changed, 133 insertions(+), 120 deletions(-)

diff --git a/drivers/lio-core/target_core_transport.c b/drivers/lio-core/target_core_transport.c
index aa74d6b..9866584 100644
--- a/drivers/lio-core/target_core_transport.c
+++ b/drivers/lio-core/target_core_transport.c
@@ -256,16 +256,20 @@ extern int init_se_global (void)
 	spin_lock_init(&global->hba_lock);
 	spin_lock_init(&global->plugin_class_lock);
 
-	if (!(se_cmd_cache = KMEM_CACHE(se_cmd_s, 0))) {
-		printk(KERN_ERR "KMEM_CACHE() for se_cmd_t failed\n");
+	if (!(se_cmd_cache = kmem_cache_create("se_cmd_cache",
+			sizeof(se_cmd_t), __alignof__(se_cmd_t), 0, NULL))) {
+		printk(KERN_ERR "kmem_cache_create for se_cmd_t failed\n");
 		goto out;
 	}
-	if (!(se_sess_cache = KMEM_CACHE(se_session_s, 0))) {
-		printk(KERN_ERR "KMEM_CACHE() for se_session_s failed\n");
+	if (!(se_sess_cache = kmem_cache_create("se_sess_cache",
+			sizeof(se_session_t), __alignof__(se_session_t),
+			0, NULL))) {
+		printk(KERN_ERR "kmem_cache_create() for se_session_t failed\n");
 		goto out;
 	}
 
-        if (!(global->hba_list = kzalloc((sizeof(se_hba_t) * TRANSPORT_MAX_GLOBAL_HBAS), GFP_KERNEL))) {
+        if (!(global->hba_list = kzalloc((sizeof(se_hba_t) *
+				TRANSPORT_MAX_GLOBAL_HBAS), GFP_KERNEL))) {
                 TRACE_ERROR("Unable to allocate global->hba_list\n");
                 goto out;
         }
@@ -283,8 +287,8 @@ extern int init_se_global (void)
 #endif
         }
 	
-        if (!(global->plugin_class_list = kzalloc((sizeof(se_plugin_class_t) * MAX_PLUGIN_CLASSES),
-			GFP_KERNEL))) {
+        if (!(global->plugin_class_list = kzalloc((sizeof(se_plugin_class_t) *
+			MAX_PLUGIN_CLASSES), GFP_KERNEL))) {
                 TRACE_ERROR("Unable to allocate global->plugin_class_list\n");
                 goto out;
         }
@@ -571,9 +575,7 @@ extern void transport_check_dev_params_delim (char *ptr, char **cur)
 	return;
 }
 
-extern se_session_t *transport_allocate_session (
-	se_portal_group_t *se_tpg,
-	se_node_acl_t *node_acl)
+extern se_session_t *transport_allocate_session (void)
 {
 	se_session_t *se_sess;
 
@@ -581,32 +583,109 @@ extern se_session_t *transport_allocate_session (
 		printk("Unable to allocate se_session_t from se_sess_cache\n");
 		return(ERR_PTR(-ENOMEM));
 	}
-	se_sess->se_tpg = se_tpg;
-	se_sess->node_acl = node_acl;
-
-	printk("TARGET_CORE[%s]: Allocated se_sess: %p\n",
-		TPG_TFO(se_tpg)->get_fabric_name(), se_sess);
+	INIT_LIST_HEAD(&se_sess->sess_list);
 
 	return(se_sess);
 }
 
-extern int transport_register_session (se_session_t *se_sess, void *fabric_sess)
+EXPORT_SYMBOL(transport_allocate_session);
+
+/*
+ * Called with spin_lock_bh(&se_portal_group_t->session_lock called.
+ */
+extern void __transport_register_session (
+	se_portal_group_t *se_tpg,
+	se_node_acl_t *se_nacl,
+	se_session_t *se_sess,
+	void *fabric_sess_ptr)
 {
-	se_portal_group_t *se_tpg = se_sess->se_tpg;
+	se_sess->se_tpg = se_tpg;
+	se_sess->fabric_sess_ptr = fabric_sess_ptr;
+	/*
+	 * Used by se_node_acl_t's under ConfigFS to locate active se_session-t
+	 *
+	 * Only set for se_session_t's that will actually be moving I/O.
+	 * eg: *NOT* discovery sessions.
+	 */
+	if (se_nacl) {
+		spin_lock_bh(&se_nacl->nacl_sess_lock);
+		se_nacl->nacl_sess = se_sess;
+		spin_unlock_bh(&se_nacl->nacl_sess_lock);	
+	}
+	list_add_tail(&se_sess->sess_list, &se_tpg->tpg_sess_list);
 
-	se_sess->fabric_sess_ptr = fabric_sess;
 	printk("TARGET_CORE[%s]: Registered fabric_sess_ptr: %p\n",
 		TPG_TFO(se_tpg)->get_fabric_name(), se_sess->fabric_sess_ptr);
 
-	return(0);
+	return;
+}
+
+EXPORT_SYMBOL(__transport_register_session);
+
+extern void transport_register_session (
+	se_portal_group_t *se_tpg,
+	se_node_acl_t *se_nacl,
+	se_session_t *se_sess,
+	void *fabric_sess_ptr)
+{
+	spin_lock_bh(&se_tpg->session_lock);
+	__transport_register_session(se_tpg, se_nacl, se_sess, fabric_sess_ptr);	
+	spin_unlock_bh(&se_tpg->session_lock);
+
+	return;
+}
+
+EXPORT_SYMBOL(transport_register_session);
+
+extern void transport_deregister_session_configfs (se_session_t *se_sess)
+{
+	se_node_acl_t *se_nacl;
+
+	/*
+	 * Used by se_node_acl_t's under ConfigFS to locate active se_session_t
+	 */
+	if ((se_nacl = se_sess->se_node_acl)) {
+		spin_lock_bh(&se_nacl->nacl_sess_lock);
+		se_nacl->nacl_sess = NULL;
+		spin_unlock_bh(&se_nacl->nacl_sess_lock);
+	}
+
+	return;
 }
 
+EXPORT_SYMBOL(transport_deregister_session_configfs);
+
 extern void transport_deregister_session (se_session_t *se_sess)
 {
 	se_portal_group_t *se_tpg = se_sess->se_tpg;
+	se_node_acl_t *se_nacl;
 
-	se_sess->node_acl = NULL;
+	spin_lock_bh(&se_tpg->session_lock);
+	list_del(&se_sess->sess_list);	
+	se_sess->se_tpg = NULL;
 	se_sess->fabric_sess_ptr = NULL;
+	spin_unlock_bh(&se_tpg->session_lock);
+
+	/*
+	 * Determine if we need to do extra work for this initiator node's
+	 * se_node_acl_t if it had been previously dynamically generated.
+	 */
+	if ((se_nacl = se_sess->se_node_acl)) {
+		spin_lock_bh(&se_tpg->acl_node_lock);
+		if (se_nacl->nodeacl_flags & NAF_DYNAMIC_NODE_ACL) {
+			if (!(TPG_TFO(se_tpg)->tpg_check_demo_mode_cache(se_tpg))) {
+				REMOVE_ENTRY_FROM_LIST(se_nacl, se_tpg->acl_node_head,
+					se_tpg->acl_node_tail);
+				se_tpg->num_node_acls--;
+				spin_unlock_bh(&se_tpg->acl_node_lock);
+				core_free_device_list_for_node(se_nacl, se_tpg);
+				kfree(se_nacl);
+				spin_lock_bh(&se_tpg->acl_node_lock);
+			}
+		}
+		spin_unlock_bh(&se_tpg->acl_node_lock);
+	}
+
 	kmem_cache_free(se_sess_cache, se_sess);
 
 	printk("TARGET_CORE[%s]: Deregistered fabric_sess\n",
@@ -615,6 +694,8 @@ extern void transport_deregister_session (se_session_t *se_sess)
 	return;
 }
 
+EXPORT_SYMBOL(transport_deregister_session);
+
 /*
  * Called with T_TASK(cmd)->t_state_lock held.
  */
@@ -1955,17 +2036,6 @@ extern int transport_allocate_iovecs_for_cmd (
 	se_cmd_t *cmd,
 	u32 iov_count)
 {
-#if 0
-	/*
-	 * See if we already have enough iovecs from a previous iscsi_cmd_t
-	 * to fulfill the request.
-	 */
-	if (cmd->orig_iov_data_count >= iov_count)
-		return(0);
-
-	if (cmd->iov_data)
-		kfree(cmd->iov_data);
-#endif
 	if (!(cmd->iov_data = (struct iovec *) kzalloc(
 			iov_count * sizeof(struct iovec), GFP_ATOMIC))) {
 		TRACE_ERROR("Unable to allocate memory for"
@@ -2239,6 +2309,7 @@ extern se_cmd_t *__transport_alloc_se_cmd (
 		printk(KERN_ERR "kmem_cache_alloc() failed for se_cmd_cache\n");
 		return(ERR_PTR(-ENOMEM));
 	}
+	printk("Alloced se_cmd: %p from se_cmd_cache\n", cmd);
 
 	if (!(cmd->t_task = (se_transport_task_t *) kmalloc(
 			sizeof(se_transport_task_t), GFP_KERNEL))) {
@@ -2281,12 +2352,17 @@ EXPORT_SYMBOL(transport_alloc_se_cmd);
 extern void transport_free_se_cmd (
 	se_cmd_t *se_cmd)
 {
+	kfree(se_cmd->iov_data);
 	kfree(se_cmd->sense_buffer);
+	kfree(se_cmd->t_task);
+	printk("Releasing se_cmd: %p back to se_cmd_cache\n", se_cmd);
 	kmem_cache_free(se_cmd_cache, se_cmd);
 
 	return;
 }
 
+EXPORT_SYMBOL(transport_free_se_cmd);
+
 static void transport_generic_wait_for_tasks (se_cmd_t *, int, int);
 
 /*	transport_generic_allocate_tasks():
@@ -2599,28 +2675,16 @@ extern void transport_generic_request_failure (se_cmd_t *cmd, se_device_t *dev,
 		cmd->scsi_sense_reason = INVALID_CDB_FIELD;
 		break;
 	case PYX_TRANSPORT_OUT_OF_MEMORY_RESOURCES:
-//#warning FIXME: PYX_TRANSPORT_OUT_OF_MEMORY_RESOURCES needs to be looked at again
 		if (!(cmd->se_cmd_flags & SCF_CMD_PASSTHROUGH)) {
 			if (!sc)
 				transport_new_cmd_failure(cmd);
-#warning FIXME: PYX_TRANSPORT_OUT_OF_MEMORY_RESOURCES broken
-#if 0	
-			if (CONN(cmd) && SESS(CONN(cmd))) {
-				{
-				struct target_core_fabric_ops *iscsi_tf = target_core_get_iscsi_ops();
-				
-				if (!(iscsi_tf))
-					BUG();
+			/*
+			 * Currently for PYX_TRANSPORT_OUT_OF_MEMORY_RESOURCES, we
+			 * force this session to fall back to session recovery.
+			 */
+			CMD_TFO(cmd)->fall_back_to_erl0(cmd->se_sess);
+			CMD_TFO(cmd)->stop_session(cmd->se_sess, 0, 0);
 
-				iscsi_tf->fall_back_to_erl0(CONN(cmd));
-				iscsi_tf->stop_session(SESS(CONN(cmd)), 0, 0);
-				}
-			} else {
-				TRACE_ERROR("Huh, conn and sess are NULL for ITT: 0x%08x"
-					" t_state: %u\n", CMD_TFO(cmd)->get_task_tag(cmd),
-					cmd->t_state);
-			}
-#endif
 			goto check_stop;
 		} else
 			cmd->scsi_sense_reason = LOGICAL_UNIT_COMMUNICATION_FAILURE;
@@ -4518,33 +4582,14 @@ extern se_cmd_t *transport_allocate_passthrough (
 	
 	if (!(cmd = transport_alloc_passthrough_cmd(length, data_direction)))
 		return(NULL);
-#if 0
-	init_MUTEX_LOCKED(&cmd->reject_sem);
-	init_MUTEX_LOCKED(&cmd->unsolicited_data_sem);
-	spin_lock_init(&cmd->datain_lock);
-	spin_lock_init(&cmd->dataout_timeout_lock);
-	spin_lock_init(&cmd->istate_lock);
-	spin_lock_init(&cmd->error_lock);
-	spin_lock_init(&cmd->r2t_lock);
-#endif
-#if 0
-	INIT_LIST_HEAD(&T_TASK(cmd)->t_task_list);
-	init_MUTEX_LOCKED(&T_TASK(cmd)->transport_lun_fe_stop_sem);
-	init_MUTEX_LOCKED(&T_TASK(cmd)->transport_lun_stop_sem);
-	init_MUTEX_LOCKED(&T_TASK(cmd)->t_transport_stop_sem);
-	init_MUTEX_LOCKED(&T_TASK(cmd)->t_transport_passthrough_sem);
-	init_MUTEX_LOCKED(&T_TASK(cmd)->t_transport_passthrough_wsem);
-	spin_lock_init(&T_TASK(cmd)->t_state_lock);
-#endif	
 	/*
-	 * Simulate an iSCSI LUN entry need for passing SCSI CDBs into
+	 * Simulate an SE LUN entry need for passing SCSI CDBs into
 	 * se_cmd_t.
 	 */
-	if (!(cmd->se_lun = kmalloc(sizeof(se_lun_t), GFP_KERNEL))) {
+	if (!(cmd->se_lun = kzalloc(sizeof(se_lun_t), GFP_KERNEL))) {
 		TRACE_ERROR("Unable to allocate cmd->se_lun\n");
 		goto fail;
 	}
-	memset(cmd->se_lun, 0, sizeof(se_lun_t));
 
 	spin_lock_init(&cmd->se_lun->lun_sep_lock);
 	ISCSI_LUN(cmd)->lun_type = obj_api->se_obj_type;
@@ -4637,7 +4682,7 @@ fail:
 		transport_release_tasks(cmd);
 	kfree(T_TASK(cmd));
 	kfree(cmd->se_lun);
-	kfree(cmd);
+	transport_free_se_cmd(cmd);
 	
 	return(NULL);
 }
@@ -4912,8 +4957,8 @@ extern void transport_release_fe_cmd (se_cmd_t *cmd)
 	if (cmd->se_cmd_flags & SCF_CMD_PASSTHROUGH)
 		kfree(cmd->se_lun);
 
-	kfree(T_TASK(cmd));
 	CMD_TFO(cmd)->release_cmd_direct(cmd);
+	transport_free_se_cmd(cmd);
 
         return;
 }       
@@ -4925,7 +4970,7 @@ extern void transport_release_fe_cmd (se_cmd_t *cmd)
 extern int transport_generic_remove (se_cmd_t *cmd, int release_to_pool, int session_reinstatement)
 {
 	unsigned long flags;
-	
+
 	if (!(T_TASK(cmd)))
 		goto release_cmd;
 
@@ -4953,8 +4998,7 @@ release_cmd:
 			kfree(cmd->se_lun);
 
 		CMD_TFO(cmd)->release_cmd_direct(cmd);
-		kfree(T_TASK(cmd));
-		kfree(cmd);
+		transport_free_se_cmd(cmd);
 	}
 
 	return(0);
@@ -5872,7 +5916,7 @@ static int transport_generic_write_pending (se_cmd_t *cmd)
 	 * Call the fabric write_pending function here to let the
 	 * frontend know that WRITE buffers are ready.
 	 */
-#warning FIXME: Use include/asm-generic/errno.h codes if possible
+#warning FIXME: Use include/asm-generic/errno.h codes..
 	if ((ret = CMD_TFO(cmd)->write_pending(cmd)) < 0) {
 		transport_cmd_check_stop(cmd, 1, 0);
 		return(ret);
@@ -5888,46 +5932,14 @@ static int transport_generic_write_pending (se_cmd_t *cmd)
  */
 static void transport_release_cmd_to_pool (se_cmd_t *cmd)
 {
-#if 0
-	if (!CONN(cmd) && !cmd->sess) {
-#if 0
-		TRACE_ERROR("Releasing cmd: %p ITT: 0x%08x i_state: 0x%02x,"
-			" deferred_i_state: 0x%02x directly\n", cmd,
-			CMD_TFO(cmd)->get_task_tag(cmd),
-			CMD_TFO(cmd)->get_cmd_state(cmd),
-			cmd->deferred_i_state);
-#endif
-		{
-		struct target_core_fabric_ops *iscsi_tf = target_core_get_iscsi_ops();
-
-		if (!(iscsi_tf))
-			BUG();
-
-		iscsi_tf->release_cmd_direct(cmd);
-		}
-	} else {
-		iscsi_session_t *sess = (CONN(cmd)) ? CONN(cmd)->sess : cmd->sess;
-		{
-		struct target_core_fabric_ops *iscsi_tf = target_core_get_iscsi_ops();
-		
-		if (!(iscsi_tf))
-			BUG();
-
-		iscsi_tf->release_cmd_to_pool(cmd, sess);
-		}
-	}
-#else
 	if (cmd->se_cmd_flags & SCF_CMD_PASSTHROUGH) 
 		kfree(cmd->se_lun);
-
-	kfree(T_TASK(cmd));
 	/*
 	 * Release se_cmd_t->se_fabric_cmd_ptr in fabric
 	 */
 	CMD_TFO(cmd)->release_cmd_to_pool(cmd);
 
-	kmem_cache_free(se_cmd_cache, cmd);
-#endif
+	transport_free_se_cmd(cmd);
 	return;
 }
 
@@ -5944,7 +5956,7 @@ extern void transport_generic_free_cmd (
 	if (!(cmd->se_cmd_flags & SCF_SE_LUN_CMD) || !T_TASK(cmd))
 		transport_release_cmd_to_pool(cmd);
 	else {
-		CMD_TFO(cmd)->dec_nacl_count(cmd->se_sess->node_acl, cmd);
+		core_dec_lacl_count(cmd->se_sess->se_node_acl, cmd);
 
 		if (ISCSI_LUN(cmd)) {
 #if 0
@@ -6311,7 +6323,7 @@ extern int core_tpg_persistent_reservation_check (se_cmd_t *cmd)
                 spin_unlock(&lun->lun_reservation_lock);
                 return(0);
         }
-        ret = (lun->lun_reserved_node_acl != sess->node_acl) ? -1 : 0;
+        ret = (lun->lun_reserved_node_acl != sess->se_node_acl) ? -1 : 0;
         spin_unlock(&lun->lun_reservation_lock);
 
         return(ret);
@@ -6331,7 +6343,7 @@ extern int core_tpg_persistent_reservation_release (se_cmd_t *cmd)
                 return(0);
         }
 
-        if (lun->lun_reserved_node_acl != sess->node_acl) {
+        if (lun->lun_reserved_node_acl != sess->se_node_acl) {
                 spin_unlock(&lun->lun_reservation_lock);
                 return(0);
         }
@@ -6339,7 +6351,7 @@ extern int core_tpg_persistent_reservation_release (se_cmd_t *cmd)
         PYXPRINT("Released %s TPG LUN: %u -> MAPPED LUN: %u for %s\n",
 		TPG_TFO(tpg)->get_fabric_name(),
 		ISCSI_LUN(cmd)->unpacked_lun, cmd->se_deve->mapped_lun,
-		sess->node_acl->initiatorname);
+		sess->se_node_acl->initiatorname);
         spin_unlock(&lun->lun_reservation_lock);
 
         return(0);
@@ -6347,7 +6359,6 @@ extern int core_tpg_persistent_reservation_release (se_cmd_t *cmd)
 
 EXPORT_SYMBOL(core_tpg_persistent_reservation_release);
 
-#warning FIXME: core_tpg_persistent_reservation_reserve() broken
 extern int core_tpg_persistent_reservation_reserve (se_cmd_t *cmd)
 {
 	se_lun_t *lun = cmd->se_lun;
@@ -6363,23 +6374,23 @@ extern int core_tpg_persistent_reservation_reserve (se_cmd_t *cmd)
 		return(5);
 
         spin_lock(&lun->lun_reservation_lock);
-        if (lun->lun_reserved_node_acl && (lun->lun_reserved_node_acl != sess->node_acl)) {
+        if (lun->lun_reserved_node_acl && (lun->lun_reserved_node_acl != sess->se_node_acl)) {
                 TRACE_ERROR("RESERVATION CONFLIFT for %s fabric\n",
 				TPG_TFO(tpg)->get_fabric_name());
                 TRACE_ERROR("Original reserver TPG LUN: %u %s\n", lun->unpacked_lun,
                                 lun->lun_reserved_node_acl->initiatorname);
                 TRACE_ERROR("Current attempt - TPG LUN: %u -> MAPPED LUN: %u from %s \n",
                                 lun->unpacked_lun, cmd->se_deve->mapped_lun,
-                                sess->node_acl->initiatorname);
+                                sess->se_node_acl->initiatorname);
                 spin_unlock(&lun->lun_reservation_lock);
                 return(5);
         }
 
-        lun->lun_reserved_node_acl = sess->node_acl;
+        lun->lun_reserved_node_acl = sess->se_node_acl;
         PYXPRINT("Reserved %s TPG LUN: %u -> MAPPED LUN: %u for %s\n",
 		TPG_TFO(tpg)->get_fabric_name(),
 		ISCSI_LUN(cmd)->unpacked_lun, cmd->se_deve->mapped_lun,
-		sess->node_acl->initiatorname);
+		sess->se_node_acl->initiatorname);
         spin_unlock(&lun->lun_reservation_lock);
 
         return(0);
diff --git a/drivers/lio-core/target_core_transport.h b/drivers/lio-core/target_core_transport.h
index 8041fe6..dce7bd6 100644
--- a/drivers/lio-core/target_core_transport.h
+++ b/drivers/lio-core/target_core_transport.h
@@ -110,8 +110,10 @@ extern void transport_init_queue_obj (struct se_queue_obj_s *);
 extern void transport_load_plugins (void);
 extern struct se_plugin_s *transport_core_get_plugin_by_name (const char *name);
 extern void transport_check_dev_params_delim (char *, char **);
-extern struct se_session_s *transport_allocate_session (struct se_portal_group_s *, struct se_node_acl_s *);
-extern int transport_register_session (struct se_session_s *, void *);
+extern struct se_session_s *transport_allocate_session (void);
+extern void __transport_register_session (struct se_portal_group_s *, struct se_node_acl_s *, struct se_session_s *, void *);
+extern void transport_register_session (struct se_portal_group_s *, struct se_node_acl_s *, struct se_session_s *, void *);
+extern void transport_deregister_session_configfs (struct se_session_s *);
 extern void transport_deregister_session (struct se_session_s *);
 extern void transport_task_dev_remove_state (struct se_task_s *, struct se_device_s *);
 extern int transport_add_cmd_to_queue (struct se_cmd_s *, struct se_queue_obj_s *, u8);
-- 
1.5.4.1



