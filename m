From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH-v2 3/4] target: Fix change depth se_session reference usage
Date: Sun, 10 Jan 2016 20:28:43 +0000
Message-ID: <1452457724-10629-4-git-send-email-nab@daterainc.com>
References: <1452457724-10629-1-git-send-email-nab@daterainc.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1452457724-10629-1-git-send-email-nab@daterainc.com>
Sender: target-devel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>, Sagi Grimberg <sagig@mellanox.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Andy Grover <agrover@redhat.com>, Vasu Dev <vasu.dev@linux.intel.com>, Vu Pham <vu@mellanox.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch converts core_tpg_set_initiator_node_queue_depth()
to use struct se_node_acl->acl_sess_list when performing
explicit se_tpg_tfo->shutdown_session() for active sessions,
in order for new se_node_acl->queue_depth to take effect.

This follows how core_tpg_del_initiator_node_acl() currently
works when invoking se_tpg_tfo->shutdown-session(), and ahead
of the next patch to take se_node_acl->acl_kref during lookup,
the extra get_initiator_node_acl() can go away.

This is because se_node_acl->acl_group is already protecting
se_node_acl->acl_group reference via configfs, and shutdown
within core_tpg_del_initiator_node_acl() won't occur until
sys_write() to core_tpg_set_initiator_node_queue_depth()
attribute returns back to user-space.

Also, it includes a bug-fix for iscsi-target where explicit
session shutdown in lio_tpg_shutdown_session() was not
obtaining se_portal_group->session_lock for both cases,
plus drop pointless wrapper.

Note iscsi-target is the only user of this code.

Reported-by: Christoph Hellwig <hch@lst.de>
Cc: Sagi Grimberg <sagig@mellanox.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Andy Grover <agrover@redhat.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/iscsi/iscsi_target_configfs.c |  14 +--
 drivers/target/iscsi/iscsi_target_tpg.c      |  10 --
 drivers/target/iscsi/iscsi_target_tpg.h      |   2 -
 drivers/target/target_core_tpg.c             | 143 +++++++++------------------
 drivers/target/target_core_transport.c       |   4 +-
 include/target/target_core_fabric.h          |   4 +-
 6 files changed, 59 insertions(+), 118 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target_configfs.c b/drivers/target/iscsi/iscsi_target_configfs.c
index 255204c..3c04a1c 100644
--- a/drivers/target/iscsi/iscsi_target_configfs.c
+++ b/drivers/target/iscsi/iscsi_target_configfs.c
@@ -726,10 +726,10 @@ static ssize_t lio_target_nacl_cmdsn_depth_store(struct config_item *item,
 	if (iscsit_get_tpg(tpg) < 0)
 		return -EINVAL;
 	/*
-	 * iscsit_tpg_set_initiator_node_queue_depth() assumes force=1
+	 * core_tpg_set_initiator_node_queue_depth() assumes force=1
 	 */
-	ret = iscsit_tpg_set_initiator_node_queue_depth(tpg,
-				config_item_name(acl_ci), cmdsn_depth, 1);
+	ret = core_tpg_set_initiator_node_queue_depth(se_tpg, se_nacl,
+						      cmdsn_depth, 1);
 
 	pr_debug("LIO_Target_ConfigFS: %s/%s Set CmdSN Window: %u for"
 		"InitiatorName: %s\n", config_item_name(wwn_ci),
@@ -1593,28 +1593,30 @@ static int lio_tpg_check_prot_fabric_only(
 }
 
 /*
- * Called with spin_lock_bh(struct se_portal_group->session_lock) held..
- *
  * Also, this function calls iscsit_inc_session_usage_count() on the
  * struct iscsi_session in question.
  */
 static int lio_tpg_shutdown_session(struct se_session *se_sess)
 {
 	struct iscsi_session *sess = se_sess->fabric_sess_ptr;
+	struct se_portal_group *se_tpg = &sess->tpg->tpg_se_tpg;
 
+	spin_lock_bh(&se_tpg->session_lock);
 	spin_lock(&sess->conn_lock);
 	if (atomic_read(&sess->session_fall_back_to_erl0) ||
 	    atomic_read(&sess->session_logout) ||
 	    (sess->time2retain_timer_flags & ISCSI_TF_EXPIRED)) {
 		spin_unlock(&sess->conn_lock);
+		spin_unlock_bh(&se_tpg->session_lock);
 		return 0;
 	}
 	atomic_set(&sess->session_reinstatement, 1);
 	spin_unlock(&sess->conn_lock);
 
 	iscsit_stop_time2retain_timer(sess);
-	iscsit_stop_session(sess, 1, 1);
+	spin_unlock_bh(&se_tpg->session_lock);
 
+	iscsit_stop_session(sess, 1, 1);
 	return 1;
 }
 
diff --git a/drivers/target/iscsi/iscsi_target_tpg.c b/drivers/target/iscsi/iscsi_target_tpg.c
index 23c95cd..0814e58 100644
--- a/drivers/target/iscsi/iscsi_target_tpg.c
+++ b/drivers/target/iscsi/iscsi_target_tpg.c
@@ -590,16 +590,6 @@ int iscsit_tpg_del_network_portal(
 	return iscsit_tpg_release_np(tpg_np, tpg, np);
 }
 
-int iscsit_tpg_set_initiator_node_queue_depth(
-	struct iscsi_portal_group *tpg,
-	unsigned char *initiatorname,
-	u32 queue_depth,
-	int force)
-{
-	return core_tpg_set_initiator_node_queue_depth(&tpg->tpg_se_tpg,
-		initiatorname, queue_depth, force);
-}
-
 int iscsit_ta_authentication(struct iscsi_portal_group *tpg, u32 authentication)
 {
 	unsigned char buf1[256], buf2[256], *none = NULL;
diff --git a/drivers/target/iscsi/iscsi_target_tpg.h b/drivers/target/iscsi/iscsi_target_tpg.h
index 9db32bd..2da2119 100644
--- a/drivers/target/iscsi/iscsi_target_tpg.h
+++ b/drivers/target/iscsi/iscsi_target_tpg.h
@@ -26,8 +26,6 @@ extern struct iscsi_tpg_np *iscsit_tpg_add_network_portal(struct iscsi_portal_gr
 			int);
 extern int iscsit_tpg_del_network_portal(struct iscsi_portal_group *,
 			struct iscsi_tpg_np *);
-extern int iscsit_tpg_set_initiator_node_queue_depth(struct iscsi_portal_group *,
-			unsigned char *, u32, int);
 extern int iscsit_ta_authentication(struct iscsi_portal_group *, u32);
 extern int iscsit_ta_login_timeout(struct iscsi_portal_group *, u32);
 extern int iscsit_ta_netif_timeout(struct iscsi_portal_group *, u32);
diff --git a/drivers/target/target_core_tpg.c b/drivers/target/target_core_tpg.c
index 62103a8..66a2c6f 100644
--- a/drivers/target/target_core_tpg.c
+++ b/drivers/target/target_core_tpg.c
@@ -157,28 +157,25 @@ void core_tpg_add_node_to_devs(
 	mutex_unlock(&tpg->tpg_lun_mutex);
 }
 
-/*      core_set_queue_depth_for_node():
- *
- *
- */
-static int core_set_queue_depth_for_node(
-	struct se_portal_group *tpg,
-	struct se_node_acl *acl)
+static void
+target_set_nacl_queue_depth(struct se_portal_group *tpg,
+			    struct se_node_acl *acl, u32 queue_depth)
 {
+	acl->queue_depth = queue_depth;
+
 	if (!acl->queue_depth) {
-		pr_err("Queue depth for %s Initiator Node: %s is 0,"
+		pr_warn("Queue depth for %s Initiator Node: %s is 0,"
 			"defaulting to 1.\n", tpg->se_tpg_tfo->get_fabric_name(),
 			acl->initiatorname);
 		acl->queue_depth = 1;
 	}
-
-	return 0;
 }
 
 static struct se_node_acl *target_alloc_node_acl(struct se_portal_group *tpg,
 		const unsigned char *initiatorname)
 {
 	struct se_node_acl *acl;
+	u32 queue_depth;
 
 	acl = kzalloc(max(sizeof(*acl), tpg->se_tpg_tfo->node_acl_size),
 			GFP_KERNEL);
@@ -193,24 +190,20 @@ static struct se_node_acl *target_alloc_node_acl(struct se_portal_group *tpg,
 	spin_lock_init(&acl->nacl_sess_lock);
 	mutex_init(&acl->lun_entry_mutex);
 	atomic_set(&acl->acl_pr_ref_count, 0);
+
 	if (tpg->se_tpg_tfo->tpg_get_default_depth)
-		acl->queue_depth = tpg->se_tpg_tfo->tpg_get_default_depth(tpg);
+		queue_depth = tpg->se_tpg_tfo->tpg_get_default_depth(tpg);
 	else
-		acl->queue_depth = 1;
+		queue_depth = 1;
+	target_set_nacl_queue_depth(tpg, acl, queue_depth);
+
 	snprintf(acl->initiatorname, TRANSPORT_IQN_LEN, "%s", initiatorname);
 	acl->se_tpg = tpg;
 	acl->acl_index = scsi_get_new_index(SCSI_AUTH_INTR_INDEX);
 
 	tpg->se_tpg_tfo->set_default_node_attributes(acl);
 
-	if (core_set_queue_depth_for_node(tpg, acl) < 0)
-		goto out_free_acl;
-
 	return acl;
-
-out_free_acl:
-	kfree(acl);
-	return NULL;
 }
 
 static void target_add_node_acl(struct se_node_acl *acl)
@@ -327,7 +320,8 @@ void core_tpg_del_initiator_node_acl(struct se_node_acl *acl)
 		if (sess->sess_tearing_down != 0)
 			continue;
 
-		target_get_session(sess);
+		if (!target_get_session(sess))
+			continue;
 		list_move(&sess->sess_acl_list, &sess_list);
 	}
 	spin_unlock_irqrestore(&acl->nacl_sess_lock, flags);
@@ -365,34 +359,26 @@ void core_tpg_del_initiator_node_acl(struct se_node_acl *acl)
  */
 int core_tpg_set_initiator_node_queue_depth(
 	struct se_portal_group *tpg,
-	unsigned char *initiatorname,
+	struct se_node_acl *acl,
 	u32 queue_depth,
 	int force)
 {
-	struct se_session *sess, *init_sess = NULL;
-	struct se_node_acl *acl;
+	LIST_HEAD(sess_list);
+	struct se_session *sess, *sess_tmp;
 	unsigned long flags;
-	int dynamic_acl = 0;
+	int rc;
 
-	mutex_lock(&tpg->acl_node_mutex);
-	acl = __core_tpg_get_initiator_node_acl(tpg, initiatorname);
-	if (!acl) {
-		pr_err("Access Control List entry for %s Initiator"
-			" Node %s does not exists for TPG %hu, ignoring"
-			" request.\n", tpg->se_tpg_tfo->get_fabric_name(),
-			initiatorname, tpg->se_tpg_tfo->tpg_get_tag(tpg));
-		mutex_unlock(&tpg->acl_node_mutex);
-		return -ENODEV;
-	}
-	if (acl->dynamic_node_acl) {
-		acl->dynamic_node_acl = 0;
-		dynamic_acl = 1;
-	}
-	mutex_unlock(&tpg->acl_node_mutex);
+	/*
+	 * User has requested to change the queue depth for a Initiator Node.
+	 * Change the value in the Node's struct se_node_acl, and call
+	 * target_set_nacl_queue_depth() to set the new queue depth.
+	 */
+	target_set_nacl_queue_depth(tpg, acl, queue_depth);
 
-	spin_lock_irqsave(&tpg->session_lock, flags);
-	list_for_each_entry(sess, &tpg->tpg_sess_list, sess_list) {
-		if (sess->se_node_acl != acl)
+	spin_lock_irqsave(&acl->nacl_sess_lock, flags);
+	list_for_each_entry_safe(sess, sess_tmp, &acl->acl_sess_list,
+				 sess_acl_list) {
+		if (sess->sess_tearing_down != 0)
 			continue;
 
 		if (!force) {
@@ -401,71 +387,36 @@ int core_tpg_set_initiator_node_queue_depth(
 				" operational.  To forcefully change the queue"
 				" depth and force session reinstatement"
 				" use the \"force=1\" parameter.\n",
-				tpg->se_tpg_tfo->get_fabric_name(), initiatorname);
-			spin_unlock_irqrestore(&tpg->session_lock, flags);
-
-			mutex_lock(&tpg->acl_node_mutex);
-			if (dynamic_acl)
-				acl->dynamic_node_acl = 1;
-			mutex_unlock(&tpg->acl_node_mutex);
+				tpg->se_tpg_tfo->get_fabric_name(),
+				acl->initiatorname);
+			spin_unlock_irqrestore(&acl->nacl_sess_lock, flags);
 			return -EEXIST;
 		}
-		/*
-		 * Determine if the session needs to be closed by our context.
-		 */
-		if (!tpg->se_tpg_tfo->shutdown_session(sess))
+		if (!target_get_session(sess))
 			continue;
+		spin_unlock_irqrestore(&acl->nacl_sess_lock, flags);
 
-		init_sess = sess;
-		break;
-	}
-
-	/*
-	 * User has requested to change the queue depth for a Initiator Node.
-	 * Change the value in the Node's struct se_node_acl, and call
-	 * core_set_queue_depth_for_node() to add the requested queue depth.
-	 *
-	 * Finally call  tpg->se_tpg_tfo->close_session() to force session
-	 * reinstatement to occur if there is an active session for the
-	 * $FABRIC_MOD Initiator Node in question.
-	 */
-	acl->queue_depth = queue_depth;
-
-	if (core_set_queue_depth_for_node(tpg, acl) < 0) {
-		spin_unlock_irqrestore(&tpg->session_lock, flags);
 		/*
-		 * Force session reinstatement if
-		 * core_set_queue_depth_for_node() failed, because we assume
-		 * the $FABRIC_MOD has already the set session reinstatement
-		 * bit from tpg->se_tpg_tfo->shutdown_session() called above.
+		 * Finally call tpg->se_tpg_tfo->close_session() to force session
+		 * reinstatement to occur if there is an active session for the
+		 * $FABRIC_MOD Initiator Node in question.
 		 */
-		if (init_sess)
-			tpg->se_tpg_tfo->close_session(init_sess);
-
-		mutex_lock(&tpg->acl_node_mutex);
-		if (dynamic_acl)
-			acl->dynamic_node_acl = 1;
-		mutex_unlock(&tpg->acl_node_mutex);
-		return -EINVAL;
+		rc = tpg->se_tpg_tfo->shutdown_session(sess);
+		target_put_session(sess);
+		if (!rc) {
+			spin_lock_irqsave(&acl->nacl_sess_lock, flags);
+			continue;
+		}
+		target_put_session(sess);
+		spin_lock_irqsave(&acl->nacl_sess_lock, flags);
 	}
-	spin_unlock_irqrestore(&tpg->session_lock, flags);
-	/*
-	 * If the $FABRIC_MOD session for the Initiator Node ACL exists,
-	 * forcefully shutdown the $FABRIC_MOD session/nexus.
-	 */
-	if (init_sess)
-		tpg->se_tpg_tfo->close_session(init_sess);
+	spin_unlock_irqrestore(&acl->nacl_sess_lock, flags);
 
 	pr_debug("Successfully changed queue depth to: %d for Initiator"
-		" Node: %s on %s Target Portal Group: %u\n", queue_depth,
-		initiatorname, tpg->se_tpg_tfo->get_fabric_name(),
+		" Node: %s on %s Target Portal Group: %u\n", acl->queue_depth,
+		acl->initiatorname, tpg->se_tpg_tfo->get_fabric_name(),
 		tpg->se_tpg_tfo->tpg_get_tag(tpg));
 
-	mutex_lock(&tpg->acl_node_mutex);
-	if (dynamic_acl)
-		acl->dynamic_node_acl = 1;
-	mutex_unlock(&tpg->acl_node_mutex);
-
 	return 0;
 }
 EXPORT_SYMBOL(core_tpg_set_initiator_node_queue_depth);
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index eb7aaf0..7b05ebf 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -384,9 +384,9 @@ static void target_release_session(struct kref *kref)
 	se_tpg->se_tpg_tfo->close_session(se_sess);
 }
 
-void target_get_session(struct se_session *se_sess)
+int target_get_session(struct se_session *se_sess)
 {
-	kref_get(&se_sess->sess_kref);
+	return kref_get_unless_zero(&se_sess->sess_kref);
 }
 EXPORT_SYMBOL(target_get_session);
 
diff --git a/include/target/target_core_fabric.h b/include/target/target_core_fabric.h
index de21130..dc6b09e 100644
--- a/include/target/target_core_fabric.h
+++ b/include/target/target_core_fabric.h
@@ -117,7 +117,7 @@ void	__transport_register_session(struct se_portal_group *,
 		struct se_node_acl *, struct se_session *, void *);
 void	transport_register_session(struct se_portal_group *,
 		struct se_node_acl *, struct se_session *, void *);
-void	target_get_session(struct se_session *);
+int	target_get_session(struct se_session *);
 void	target_put_session(struct se_session *);
 ssize_t	target_show_dynamic_sessions(struct se_portal_group *, char *);
 void	transport_free_session(struct se_session *);
@@ -172,7 +172,7 @@ struct se_node_acl *core_tpg_get_initiator_node_acl(struct se_portal_group *tpg,
 struct se_node_acl *core_tpg_check_initiator_node_acl(struct se_portal_group *,
 		unsigned char *);
 int	core_tpg_set_initiator_node_queue_depth(struct se_portal_group *,
-		unsigned char *, u32, int);
+		struct se_node_acl *, u32, int);
 int	core_tpg_set_initiator_node_tag(struct se_portal_group *,
 		struct se_node_acl *, const char *);
 int	core_tpg_register(struct se_wwn *, struct se_portal_group *, int);
-- 
1.9.1
