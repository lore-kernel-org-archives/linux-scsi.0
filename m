From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 4/5] target: Fix multi-session dynamic se_node_acl double
 free OOPs
Date: Tue, 7 Feb 2017 15:07:01 -0800
Message-ID: <20170207230701.GA28123@infradead.org>
References: <1486473470-15837-1-git-send-email-nab@linux-iscsi.org>
 <1486473470-15837-5-git-send-email-nab@linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1486473470-15837-5-git-send-email-nab@linux-iscsi.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>, Rob Millner <rlm@daterainc.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, Feb 07, 2017 at 01:17:49PM +0000, Nicholas A. Bellinger wrote:
> -	list_del(&acl->acl_list);
> +	list_del_init(&acl->acl_list);

All these list_del_init changes don't make sense to me - the whole target
code never does a list_empty check on ->acl_list.


Looking further I think all nacls should be switched to the direct
free from the kref release callback scheme - there is no real need
to wait for freeing the nacl I think.

Untested patch below:

diff --git a/drivers/target/target_core_internal.h b/drivers/target/target_core_internal.h
index 9ab7090f7c83..96c38f30069d 100644
--- a/drivers/target/target_core_internal.h
+++ b/drivers/target/target_core_internal.h
@@ -152,6 +152,7 @@ void	target_qf_do_work(struct work_struct *work);
 bool	target_check_wce(struct se_device *dev);
 bool	target_check_fua(struct se_device *dev);
 void	__target_execute_cmd(struct se_cmd *, bool);
+void	target_put_nacl(struct se_node_acl *);
 
 /* target_core_stat.c */
 void	target_stat_setup_dev_default_groups(struct se_device *);
diff --git a/drivers/target/target_core_tpg.c b/drivers/target/target_core_tpg.c
index d99752c6cd60..08738c87e5b0 100644
--- a/drivers/target/target_core_tpg.c
+++ b/drivers/target/target_core_tpg.c
@@ -197,7 +197,6 @@ static struct se_node_acl *target_alloc_node_acl(struct se_portal_group *tpg,
 	INIT_LIST_HEAD(&acl->acl_sess_list);
 	INIT_HLIST_HEAD(&acl->lun_entry_hlist);
 	kref_init(&acl->acl_kref);
-	init_completion(&acl->acl_free_comp);
 	spin_lock_init(&acl->nacl_sess_lock);
 	mutex_init(&acl->lun_entry_mutex);
 	atomic_set(&acl->acl_pr_ref_count, 0);
@@ -370,21 +369,6 @@ void core_tpg_del_initiator_node_acl(struct se_node_acl *acl)
 	target_shutdown_sessions(acl);
 
 	target_put_nacl(acl);
-	/*
-	 * Wait for last target_put_nacl() to complete in target_complete_nacl()
-	 * for active fabric session transport_deregister_session() callbacks.
-	 */
-	wait_for_completion(&acl->acl_free_comp);
-
-	core_tpg_wait_for_nacl_pr_ref(acl);
-	core_free_device_list_for_node(acl, tpg);
-
-	pr_debug("%s_TPG[%hu] - Deleted ACL with TCQ Depth: %d for %s"
-		" Initiator Node: %s\n", tpg->se_tpg_tfo->get_fabric_name(),
-		tpg->se_tpg_tfo->tpg_get_tag(tpg), acl->queue_depth,
-		tpg->se_tpg_tfo->get_fabric_name(), acl->initiatorname);
-
-	kfree(acl);
 }
 
 /*	core_tpg_set_initiator_node_queue_depth():
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 1cadc9eefa21..72718283e553 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -453,19 +453,25 @@ ssize_t target_show_dynamic_sessions(struct se_portal_group *se_tpg, char *page)
 }
 EXPORT_SYMBOL(target_show_dynamic_sessions);
 
-static void target_complete_nacl(struct kref *kref)
+static void target_destroy_nacl(struct kref *kref)
 {
 	struct se_node_acl *nacl = container_of(kref,
 				struct se_node_acl, acl_kref);
+	struct se_portal_group *se_tpg = nacl->se_tpg;
 
-	complete(&nacl->acl_free_comp);
+	mutex_lock(&se_tpg->acl_node_mutex);
+	list_del(&nacl->acl_list);
+	mutex_unlock(&se_tpg->acl_node_mutex);
+
+	core_tpg_wait_for_nacl_pr_ref(nacl);
+	core_free_device_list_for_node(nacl, se_tpg);
+	kfree(nacl);
 }
 
 void target_put_nacl(struct se_node_acl *nacl)
 {
-	kref_put(&nacl->acl_kref, target_complete_nacl);
+	kref_put(&nacl->acl_kref, target_destroy_nacl);
 }
-EXPORT_SYMBOL(target_put_nacl);
 
 void transport_deregister_session_configfs(struct se_session *se_sess)
 {
@@ -499,12 +505,39 @@ EXPORT_SYMBOL(transport_deregister_session_configfs);
 void transport_free_session(struct se_session *se_sess)
 {
 	struct se_node_acl *se_nacl = se_sess->se_node_acl;
+
 	/*
 	 * Drop the se_node_acl->nacl_kref obtained from within
 	 * core_tpg_get_initiator_node_acl().
 	 */
 	if (se_nacl) {
+		struct se_portal_group *se_tpg = se_nacl->se_tpg;
+		const struct target_core_fabric_ops *se_tfo = se_tpg->se_tpg_tfo;
+		unsigned long flags;
+
 		se_sess->se_node_acl = NULL;
+
+		/*
+		 * Also determine if we need to drop the extra ->cmd_kref if
+		 * it had been previously dynamically generated, and
+		 * the endpoint is not caching dynamic ACLs.
+		 */
+		mutex_lock(&se_tpg->acl_node_mutex);
+		if (se_nacl->dynamic_node_acl &&
+		    !se_tfo->tpg_check_demo_mode_cache(se_tpg)) {
+			spin_lock_irqsave(&se_nacl->nacl_sess_lock, flags);
+			if (list_empty(&se_nacl->acl_sess_list))
+				stop = true;
+			spin_unlock_irqrestore(&se_nacl->nacl_sess_lock, flags);
+
+			if (stop)
+				list_del_init(&se_nacl->acl_list);
+		}
+		mutex_unlock(&se_tpg->acl_node_mutex);
+
+		if (stop)
+			target_put_nacl(se_nacl);
+
 		target_put_nacl(se_nacl);
 	}
 	if (se_sess->sess_cmd_map) {
@@ -518,16 +551,12 @@ EXPORT_SYMBOL(transport_free_session);
 void transport_deregister_session(struct se_session *se_sess)
 {
 	struct se_portal_group *se_tpg = se_sess->se_tpg;
-	const struct target_core_fabric_ops *se_tfo;
-	struct se_node_acl *se_nacl;
 	unsigned long flags;
-	bool drop_nacl = false;
 
 	if (!se_tpg) {
 		transport_free_session(se_sess);
 		return;
 	}
-	se_tfo = se_tpg->se_tpg_tfo;
 
 	spin_lock_irqsave(&se_tpg->session_lock, flags);
 	list_del(&se_sess->sess_list);
@@ -535,35 +564,8 @@ void transport_deregister_session(struct se_session *se_sess)
 	se_sess->fabric_sess_ptr = NULL;
 	spin_unlock_irqrestore(&se_tpg->session_lock, flags);
 
-	/*
-	 * Determine if we need to do extra work for this initiator node's
-	 * struct se_node_acl if it had been previously dynamically generated.
-	 */
-	se_nacl = se_sess->se_node_acl;
-
-	mutex_lock(&se_tpg->acl_node_mutex);
-	if (se_nacl && se_nacl->dynamic_node_acl) {
-		if (!se_tfo->tpg_check_demo_mode_cache(se_tpg)) {
-			list_del(&se_nacl->acl_list);
-			drop_nacl = true;
-		}
-	}
-	mutex_unlock(&se_tpg->acl_node_mutex);
-
-	if (drop_nacl) {
-		core_tpg_wait_for_nacl_pr_ref(se_nacl);
-		core_free_device_list_for_node(se_nacl, se_tpg);
-		se_sess->se_node_acl = NULL;
-		kfree(se_nacl);
-	}
 	pr_debug("TARGET_CORE[%s]: Deregistered fabric_sess\n",
 		se_tpg->se_tpg_tfo->get_fabric_name());
-	/*
-	 * If last kref is dropping now for an explicit NodeACL, awake sleeping
-	 * ->acl_free_comp caller to wakeup configfs se_node_acl->acl_group
-	 * removal context from within transport_free_session() code.
-	 */
-
 	transport_free_session(se_sess);
 }
 EXPORT_SYMBOL(transport_deregister_session);
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index 43edf82e54ff..edad452c3c25 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -557,7 +557,6 @@ struct se_node_acl {
 	struct config_group	acl_fabric_stat_group;
 	struct list_head	acl_list;
 	struct list_head	acl_sess_list;
-	struct completion	acl_free_comp;
 	struct kref		acl_kref;
 };
 
diff --git a/include/target/target_core_fabric.h b/include/target/target_core_fabric.h
index 358041bad1da..1c417731b63d 100644
--- a/include/target/target_core_fabric.h
+++ b/include/target/target_core_fabric.h
@@ -125,7 +125,6 @@ void	transport_register_session(struct se_portal_group *,
 		struct se_node_acl *, struct se_session *, void *);
 ssize_t	target_show_dynamic_sessions(struct se_portal_group *, char *);
 void	transport_free_session(struct se_session *);
-void	target_put_nacl(struct se_node_acl *);
 void	transport_deregister_session_configfs(struct se_session *);
 void	transport_deregister_session(struct se_session *);
 
