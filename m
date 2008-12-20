From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 6/8] [Target_Core_Mod]: Reenable
	core_tpg_del_initiator_node_acl() and
	core_tpg_set_initiator_node_queue_depth()
Date: Sat, 20 Dec 2008 15:03:10 -0800
Message-ID: <1229814190.4560.204.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp113.sbc.mail.mud.yahoo.com ([68.142.198.212]:41028 "HELO
	smtp113.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752006AbYLTXKW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 20 Dec 2008 18:10:22 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Linux-iSCSI.org Target Dev" <linux-iscsi-target-dev@googlegroups.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>

>From dac2365863d6554c39da256c7b1a0705de90f5d6 Mon Sep 17 00:00:00 2001
From: Nicholas Bellinger <nab@linux-iscsi.org>
Date: Sat, 20 Dec 2008 14:01:35 -0800
Subject: [PATCH 6/8] [Target_Core_Mod]: Reenable core_tpg_del_initiator_node_acl() and core_tpg_set_initiator_node_queue_depth()

This patch reenables the above logic by using newly added function pointers
struct target_core_fabric_ops->shutdown_session() and
struct target_core_fabric_ops->close_session() while removing an se_node_acl_t
or changing se_node_acl_t->queue_depth with core_set_queue_depth_for_node().

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/lio-core/target_core_fabric_ops.h |    5 +
 drivers/lio-core/target_core_tpg.c        |  115 ++++++++++++++---------------
 2 files changed, 61 insertions(+), 59 deletions(-)

diff --git a/drivers/lio-core/target_core_fabric_ops.h b/drivers/lio-core/target_core_fabric_ops.h
index 6499005..5693dac 100644
--- a/drivers/lio-core/target_core_fabric_ops.h
+++ b/drivers/lio-core/target_core_fabric_ops.h
@@ -11,6 +11,11 @@ struct target_core_fabric_ops {
         void (*release_cmd_to_pool)(struct se_cmd_s *);
         void (*release_cmd_direct)(struct se_cmd_s *);
 	int (*dev_del_lun)(struct se_portal_group_s *, __u32);
+	/*
+	 * Called with spin_lock_bh(se_portal_group_t->session_lock held.
+	 */
+	int (*shutdown_session)(struct se_session_s *);
+	void (*close_session)(struct se_session_s *);
 	void (*stop_session)(struct se_session_s *, int, int);
 	void (*fall_back_to_erl0)(struct se_session_s *);
 	int (*write_pending)(struct se_cmd_s *);
diff --git a/drivers/lio-core/target_core_tpg.c b/drivers/lio-core/target_core_tpg.c
index 768890a..9986321 100644
--- a/drivers/lio-core/target_core_tpg.c
+++ b/drivers/lio-core/target_core_tpg.c
@@ -455,13 +455,12 @@ EXPORT_SYMBOL(core_tpg_add_initiator_node_acl);
  *
  *
  */
-#warning FIXME: core_tpg_del_initiator_node_acl() force session shudown is broken
 extern int core_tpg_del_initiator_node_acl (
 	se_portal_group_t *tpg,
 	const char *initiatorname,
 	int force)
 {
-	se_session_t *sess;
+	se_session_t *sess, *init_sess = NULL;
 	se_node_acl_t *acl;
 	int dynamic_acl = 0;
 
@@ -479,55 +478,49 @@ extern int core_tpg_del_initiator_node_acl (
 		dynamic_acl = 1;
 	}
 	spin_unlock_bh(&tpg->acl_node_lock);
-#if 0	
+
 	spin_lock_bh(&tpg->session_lock);
-	for (sess = tpg->session_head; sess; sess = sess->next) {
-		if (sess->node_acl != acl)
+	list_for_each_entry(sess, &tpg->tpg_sess_list, sess_list) {
+		if (sess->se_node_acl != acl)
 			continue;
 
 		if (!force) {
 			printk(KERN_ERR "Unable to delete Access Control List for"
-			" iSCSI Initiator Node: %s while session is operational."
+			" %s Initiator Node: %s while session is operational."
 			"  To forcefully delete the session use the \"force=1\""
-				" parameter.\n", initiatorname);
+				" parameter.\n", TPG_TFO(tpg)->get_fabric_name(),
+				initiatorname);
 			spin_unlock_bh(&tpg->session_lock);
+
 			spin_lock_bh(&tpg->acl_node_lock);
 			if (dynamic_acl)
 				acl->nodeacl_flags |= NAF_DYNAMIC_NODE_ACL;
 			spin_unlock_bh(&tpg->acl_node_lock);
 			return(ERR_INITIATORACL_SESSION_EXISTS);
 		}
-		spin_lock(&sess->conn_lock);
-		if (atomic_read(&sess->session_fall_back_to_erl0) ||
-		    atomic_read(&sess->session_logout) ||
-		    (sess->time2retain_timer_flags & T2R_TF_EXPIRED)) {
-			spin_unlock(&sess->conn_lock);
+		/*
+		 * Determine if the session needs to be closed by our context.
+		 */
+		if (!(TPG_TFO(tpg)->shutdown_session(sess)))
 			continue;
-		}
-		atomic_set(&sess->session_reinstatement, 1);
-		spin_unlock(&sess->conn_lock);
 
-		iscsi_inc_session_usage_count(sess);
-		iscsi_stop_time2retain_timer(sess);
+		init_sess = sess;
 		break;
 	}
 	spin_unlock_bh(&tpg->session_lock);
-#endif
+
 	spin_lock_bh(&tpg->acl_node_lock);
 	REMOVE_ENTRY_FROM_LIST(acl, tpg->acl_node_head, tpg->acl_node_tail);
 	tpg->num_node_acls--;
 	spin_unlock_bh(&tpg->acl_node_lock);
-#if 0	
+
 	/*
-	 * If the iSCSI Session for the iSCSI Initiator Node exists,
-	 * forcefully shutdown the iSCSI NEXUS.
+	 * If the $FABRIC_MOD session for the Initiator Node ACL exists,
+	 * forcefully shutdown the $FABRIC_MOD session/nexus.
 	 */
-	if (sess) {
-		iscsi_stop_session(sess, 1, 1);
-		iscsi_dec_session_usage_count(sess);
-		iscsi_close_session(sess);
-	}
-#endif	
+	if (init_sess)
+		TPG_TFO(tpg)->close_session(init_sess);		
+
 	core_clear_initiator_node_from_tpg(acl, tpg);
 	core_free_device_list_for_node(acl, tpg);
 
@@ -549,16 +542,15 @@ EXPORT_SYMBOL(core_tpg_del_initiator_node_acl);
  *
  *
  */
-#warning FIXME: core_tpg_set_initiator_node_queue_depth() broken
 extern int core_tpg_set_initiator_node_queue_depth (
 	se_portal_group_t *tpg,
 	unsigned char *initiatorname,
 	u32 queue_depth,
 	int force)
 {
-	int dynamic_acl = 0;
-	se_session_t *sess = NULL;
+	se_session_t *sess, *init_sess = NULL;
 	se_node_acl_t *acl;
+	int dynamic_acl = 0;
 	
 	spin_lock_bh(&tpg->acl_node_lock);
 	if (!(acl = __core_tpg_get_initiator_node_acl(tpg, initiatorname))) {
@@ -574,10 +566,10 @@ extern int core_tpg_set_initiator_node_queue_depth (
 		dynamic_acl = 1;
 	}
 	spin_unlock_bh(&tpg->acl_node_lock);
-#if 0	
+
 	spin_lock_bh(&tpg->session_lock);
-	for (sess = tpg->session_head; sess; sess = sess->next) {
-		if (sess->node_acl != acl)
+	list_for_each_entry(sess, &tpg->tpg_sess_list, sess_list) {
+		if (sess->se_node_acl != acl)
 			continue;
 
 		if (!force) {
@@ -587,43 +579,45 @@ extern int core_tpg_set_initiator_node_queue_depth (
 				" use the \"force=1\" parameter.\n",
 				TPG_TFO(tpg)->get_fabric_name(), initiatorname);
 			spin_unlock_bh(&tpg->session_lock);
+
 			spin_lock_bh(&tpg->acl_node_lock);
 			if (dynamic_acl)
 				acl->nodeacl_flags |= NAF_DYNAMIC_NODE_ACL;
 			spin_unlock_bh(&tpg->acl_node_lock);
 			return(-EEXIST);
 		}
-		spin_lock(&sess->conn_lock);
-		if (atomic_read(&sess->session_fall_back_to_erl0) ||
-		    atomic_read(&sess->session_logout) ||
-		    (sess->time2retain_timer_flags & T2R_TF_EXPIRED)) {
-			spin_unlock(&sess->conn_lock);
+		/*
+		 * Determine if the session needs to be closed by our context.
+		 */
+		if (!(TPG_TFO(tpg)->shutdown_session(sess)))
 			continue;
-		}
-		atomic_set(&sess->session_reinstatement, 1);
-		spin_unlock(&sess->conn_lock);
 
-		iscsi_inc_session_usage_count(sess);
-		iscsi_stop_time2retain_timer(sess);
+		init_sess = sess;
 		break;
 	}
-#endif
+
 	/*
 	 * User has requested to change the queue depth for a Initiator Node.
 	 * Change the value in the Node's se_node_acl_t, and call
 	 * core_set_queue_depth_for_node() to add the requested queue depth.
 	 *
-	 * Finally call iscsi_free_session() to force session reinstatement to occur if
-	 * there is an active session for the iSCSI Initiator Node in question.
+	 * Finally call  TPG_TFO(tpg)->close_session() to force session
+	 * reinstatement to occur if there is an active session for the
+	 * $FABRIC_MOD Initiator Node in question.
 	 */
 	acl->queue_depth = queue_depth;
 
 	if (core_set_queue_depth_for_node(tpg, acl) < 0) {
 		spin_unlock_bh(&tpg->session_lock);
-#if 0
-		if (sess)
-			iscsi_dec_session_usage_count(sess);
-#endif
+		/*
+		 * Force session reinstatement if core_set_queue_depth_for_node()
+		 * failed, because we assume the $FABRIC_MOD has already the set
+		 * session reinstatement bit from TPG_TFO(tpg)->shutdown_session().
+		 * called above.
+		 */
+		if (init_sess)
+			TPG_TFO(tpg)->close_session(init_sess);
+
 		spin_lock_bh(&tpg->acl_node_lock);
 		if (dynamic_acl)
 			acl->nodeacl_flags |= NAF_DYNAMIC_NODE_ACL;
@@ -631,13 +625,13 @@ extern int core_tpg_set_initiator_node_queue_depth (
 		return(-EINVAL);
 	}
 	spin_unlock_bh(&tpg->session_lock);
-#if 0
-	if (sess) {
-		iscsi_stop_session(sess, 1, 1);
-		iscsi_dec_session_usage_count(sess);
-		iscsi_close_session(sess);
-	}	
-#endif
+	/*
+	 * If the $FABRIC_MOD session for the Initiator Node ACL exists,
+	 * forcefully shutdown the $FABRIC_MOD session/nexus.
+	 */
+	if (init_sess) 
+		TPG_TFO(tpg)->close_session(init_sess);
+
 	printk("Successfuly changed queue depth to: %d for Initiator Node:"
 		" %s on %s Target Portal Group: %u\n", queue_depth,
 		initiatorname, TPG_TFO(tpg)->get_fabric_name(),
@@ -711,8 +705,11 @@ EXPORT_SYMBOL(core_tpg_register);
 
 extern int core_tpg_deregister (se_portal_group_t *se_tpg)
 {
-	printk("TARGET_CORE[%s]: Deallocating se_portal_group_t for endpoint %s %u\n",
-		TPG_TFO(se_tpg)->get_fabric_name(), TPG_TFO(se_tpg)->tpg_get_wwn(se_tpg),
+	printk("TARGET_CORE[%s]: Deallocating %s se_portal_group_t for"
+		" endpoint: %s Portal Tag %u\n",
+		(se_tpg->se_tpg_type == TRANSPORT_TPG_TYPE_NORMAL) ?
+		"Normal" : "Discovery", TPG_TFO(se_tpg)->get_fabric_name(),
+		TPG_TFO(se_tpg)->tpg_get_wwn(se_tpg),
 		TPG_TFO(se_tpg)->tpg_get_tag(se_tpg));
 
 #warning FIXME: Release se_portal_group from list
-- 
1.5.4.1



