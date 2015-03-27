From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [RFC 13/22] target: Convert se_tpg->acl_node_lock to ->acl_node_mutex
Date: Fri, 27 Mar 2015 08:05:03 +0000
Message-ID: <1427443512-8925-14-git-send-email-nab@daterainc.com>
References: <1427443512-8925-1-git-send-email-nab@daterainc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-oi0-f54.google.com ([209.85.218.54]:32796 "EHLO
	mail-oi0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753601AbbC0IGW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 27 Mar 2015 04:06:22 -0400
Received: by oifl3 with SMTP id l3so70050781oif.0
        for <linux-scsi@vger.kernel.org>; Fri, 27 Mar 2015 01:06:21 -0700 (PDT)
In-Reply-To: <1427443512-8925-1-git-send-email-nab@daterainc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagig@mellanox.com>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch converts se_tpg->acl_node_lock to struct mutex, so that
->acl_node_acl walkers in core_clear_lun_from_tpg() can block when
calling core_disable_device_list_for_node().

It also updates core_dev_add_lun() to hold ->acl_node_mutex when
calling core_tpg_add_node_to_devs() to build ->lun_entry_hlist[]
for dynamically generated se_node_acl.

Cc: Hannes Reinecke <hare@suse.de>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Sagi Grimberg <sagig@mellanox.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_device.c    | 14 ++++-----
 drivers/target/target_core_pr.c        |  8 ++---
 drivers/target/target_core_tpg.c       | 55 +++++++++++++++++-----------------
 drivers/target/target_core_transport.c | 20 ++++++-------
 drivers/target/tcm_fc/tfc_conf.c       |  4 +--
 include/target/target_core_base.h      |  2 +-
 6 files changed, 50 insertions(+), 53 deletions(-)

diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index 014c1b6..965d81e 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -468,9 +468,8 @@ void core_clear_lun_from_tpg(struct se_lun *lun, struct se_portal_group *tpg)
 	struct se_dev_entry *deve;
 	u32 i, mapped_lun;
 
-	spin_lock_irq(&tpg->acl_node_lock);
+	mutex_lock(&tpg->acl_node_mutex);
 	list_for_each_entry(nacl, &tpg->acl_node_list, acl_list) {
-		spin_unlock_irq(&tpg->acl_node_lock);
 
 		for (i = 0; i < TRANSPORT_MAX_LUNS_PER_TPG; i++) {
 			rcu_read_lock();
@@ -485,10 +484,8 @@ void core_clear_lun_from_tpg(struct se_lun *lun, struct se_portal_group *tpg)
 			core_disable_device_list_for_node(lun, NULL, mapped_lun,
 					TRANSPORT_LUNFLAGS_NO_ACCESS, nacl, tpg);
 		}
-
-		spin_lock_irq(&tpg->acl_node_lock);
 	}
-	spin_unlock_irq(&tpg->acl_node_lock);
+	mutex_unlock(&tpg->acl_node_mutex);
 }
 
 static struct se_port *core_alloc_port(struct se_device *dev)
@@ -1231,17 +1228,16 @@ struct se_lun *core_dev_add_lun(
 	 */
 	if (tpg->se_tpg_tfo->tpg_check_demo_mode(tpg)) {
 		struct se_node_acl *acl;
-		spin_lock_irq(&tpg->acl_node_lock);
+
+		mutex_lock(&tpg->acl_node_mutex);
 		list_for_each_entry(acl, &tpg->acl_node_list, acl_list) {
 			if (acl->dynamic_node_acl &&
 			    (!tpg->se_tpg_tfo->tpg_check_demo_mode_login_only ||
 			     !tpg->se_tpg_tfo->tpg_check_demo_mode_login_only(tpg))) {
-				spin_unlock_irq(&tpg->acl_node_lock);
 				core_tpg_add_node_to_devs(acl, tpg);
-				spin_lock_irq(&tpg->acl_node_lock);
 			}
 		}
-		spin_unlock_irq(&tpg->acl_node_lock);
+		mutex_unlock(&tpg->acl_node_mutex);
 	}
 
 	return lun;
diff --git a/drivers/target/target_core_pr.c b/drivers/target/target_core_pr.c
index c1283c6..3b83026 100644
--- a/drivers/target/target_core_pr.c
+++ b/drivers/target/target_core_pr.c
@@ -1611,12 +1611,12 @@ core_scsi3_decode_spec_i_port(
 			 * from the decoded fabric module specific TransportID
 			 * at *i_str.
 			 */
-			spin_lock_irq(&tmp_tpg->acl_node_lock);
+			mutex_lock(&tmp_tpg->acl_node_mutex);
 			dest_node_acl = __core_tpg_get_initiator_node_acl(
 						tmp_tpg, i_str);
 			if (dest_node_acl)
 				atomic_inc_mb(&dest_node_acl->acl_pr_ref_count);
-			spin_unlock_irq(&tmp_tpg->acl_node_lock);
+			mutex_unlock(&tmp_tpg->acl_node_mutex);
 
 			if (!dest_node_acl) {
 				core_scsi3_tpg_undepend_item(tmp_tpg);
@@ -3342,12 +3342,12 @@ after_iport_check:
 	/*
 	 * Locate the destination struct se_node_acl from the received Transport ID
 	 */
-	spin_lock_irq(&dest_se_tpg->acl_node_lock);
+	mutex_lock(&dest_se_tpg->acl_node_mutex);
 	dest_node_acl = __core_tpg_get_initiator_node_acl(dest_se_tpg,
 				initiator_str);
 	if (dest_node_acl)
 		atomic_inc_mb(&dest_node_acl->acl_pr_ref_count);
-	spin_unlock_irq(&dest_se_tpg->acl_node_lock);
+	mutex_unlock(&dest_se_tpg->acl_node_mutex);
 
 	if (!dest_node_acl) {
 		pr_err("Unable to locate %s dest_node_acl for"
diff --git a/drivers/target/target_core_tpg.c b/drivers/target/target_core_tpg.c
index 1a12532..027707a 100644
--- a/drivers/target/target_core_tpg.c
+++ b/drivers/target/target_core_tpg.c
@@ -85,7 +85,7 @@ static void core_clear_initiator_node_from_tpg(
 
 /*	__core_tpg_get_initiator_node_acl():
  *
- *	spin_lock_bh(&tpg->acl_node_lock); must be held when calling
+ *	mutex_lock(&tpg->acl_node_mutex); must be held when calling
  */
 struct se_node_acl *__core_tpg_get_initiator_node_acl(
 	struct se_portal_group *tpg,
@@ -111,9 +111,9 @@ struct se_node_acl *core_tpg_get_initiator_node_acl(
 {
 	struct se_node_acl *acl;
 
-	spin_lock_irq(&tpg->acl_node_lock);
+	mutex_lock(&tpg->acl_node_mutex);
 	acl = __core_tpg_get_initiator_node_acl(tpg, initiatorname);
-	spin_unlock_irq(&tpg->acl_node_lock);
+	mutex_unlock(&tpg->acl_node_mutex);
 
 	return acl;
 }
@@ -306,10 +306,10 @@ struct se_node_acl *core_tpg_check_initiator_node_acl(
 	    (tpg->se_tpg_tfo->tpg_check_demo_mode_login_only(tpg) != 1))
 		core_tpg_add_node_to_devs(acl, tpg);
 
-	spin_lock_irq(&tpg->acl_node_lock);
+	mutex_lock(&tpg->acl_node_mutex);
 	list_add_tail(&acl->acl_list, &tpg->acl_node_list);
 	tpg->num_node_acls++;
-	spin_unlock_irq(&tpg->acl_node_lock);
+	mutex_unlock(&tpg->acl_node_mutex);
 
 	pr_debug("%s_TPG[%u] - Added DYNAMIC ACL with TCQ Depth: %d for %s"
 		" Initiator Node: %s\n", tpg->se_tpg_tfo->get_fabric_name(),
@@ -359,7 +359,7 @@ struct se_node_acl *core_tpg_add_initiator_node_acl(
 {
 	struct se_node_acl *acl = NULL;
 
-	spin_lock_irq(&tpg->acl_node_lock);
+	mutex_lock(&tpg->acl_node_mutex);
 	acl = __core_tpg_get_initiator_node_acl(tpg, initiatorname);
 	if (acl) {
 		if (acl->dynamic_node_acl) {
@@ -367,7 +367,7 @@ struct se_node_acl *core_tpg_add_initiator_node_acl(
 			pr_debug("%s_TPG[%u] - Replacing dynamic ACL"
 				" for %s\n", tpg->se_tpg_tfo->get_fabric_name(),
 				tpg->se_tpg_tfo->tpg_get_tag(tpg), initiatorname);
-			spin_unlock_irq(&tpg->acl_node_lock);
+			mutex_unlock(&tpg->acl_node_mutex);
 			/*
 			 * Release the locally allocated struct se_node_acl
 			 * because * core_tpg_add_initiator_node_acl() returned
@@ -383,10 +383,10 @@ struct se_node_acl *core_tpg_add_initiator_node_acl(
 			" Node %s already exists for TPG %u, ignoring"
 			" request.\n",  tpg->se_tpg_tfo->get_fabric_name(),
 			initiatorname, tpg->se_tpg_tfo->tpg_get_tag(tpg));
-		spin_unlock_irq(&tpg->acl_node_lock);
+		mutex_unlock(&tpg->acl_node_mutex);
 		return ERR_PTR(-EEXIST);
 	}
-	spin_unlock_irq(&tpg->acl_node_lock);
+	mutex_unlock(&tpg->acl_node_mutex);
 
 	if (!se_nacl) {
 		pr_err("struct se_node_acl pointer is NULL\n");
@@ -425,10 +425,10 @@ struct se_node_acl *core_tpg_add_initiator_node_acl(
 		return ERR_PTR(-EINVAL);
 	}
 
-	spin_lock_irq(&tpg->acl_node_lock);
+	mutex_lock(&tpg->acl_node_mutex);
 	list_add_tail(&acl->acl_list, &tpg->acl_node_list);
 	tpg->num_node_acls++;
-	spin_unlock_irq(&tpg->acl_node_lock);
+	mutex_unlock(&tpg->acl_node_mutex);
 
 done:
 	pr_debug("%s_TPG[%hu] - Added ACL with TCQ Depth: %d for %s"
@@ -454,13 +454,13 @@ int core_tpg_del_initiator_node_acl(
 	unsigned long flags;
 	int rc;
 
-	spin_lock_irq(&tpg->acl_node_lock);
+	mutex_lock(&tpg->acl_node_mutex);
 	if (acl->dynamic_node_acl) {
 		acl->dynamic_node_acl = 0;
 	}
 	list_del(&acl->acl_list);
 	tpg->num_node_acls--;
-	spin_unlock_irq(&tpg->acl_node_lock);
+	mutex_unlock(&tpg->acl_node_mutex);
 
 	spin_lock_irqsave(&acl->nacl_sess_lock, flags);
 	acl->acl_stop = 1;
@@ -519,21 +519,21 @@ int core_tpg_set_initiator_node_queue_depth(
 	unsigned long flags;
 	int dynamic_acl = 0;
 
-	spin_lock_irq(&tpg->acl_node_lock);
+	mutex_lock(&tpg->acl_node_mutex);
 	acl = __core_tpg_get_initiator_node_acl(tpg, initiatorname);
 	if (!acl) {
 		pr_err("Access Control List entry for %s Initiator"
 			" Node %s does not exists for TPG %hu, ignoring"
 			" request.\n", tpg->se_tpg_tfo->get_fabric_name(),
 			initiatorname, tpg->se_tpg_tfo->tpg_get_tag(tpg));
-		spin_unlock_irq(&tpg->acl_node_lock);
+		mutex_unlock(&tpg->acl_node_mutex);
 		return -ENODEV;
 	}
 	if (acl->dynamic_node_acl) {
 		acl->dynamic_node_acl = 0;
 		dynamic_acl = 1;
 	}
-	spin_unlock_irq(&tpg->acl_node_lock);
+	mutex_unlock(&tpg->acl_node_mutex);
 
 	spin_lock_irqsave(&tpg->session_lock, flags);
 	list_for_each_entry(sess, &tpg->tpg_sess_list, sess_list) {
@@ -549,10 +549,10 @@ int core_tpg_set_initiator_node_queue_depth(
 				tpg->se_tpg_tfo->get_fabric_name(), initiatorname);
 			spin_unlock_irqrestore(&tpg->session_lock, flags);
 
-			spin_lock_irq(&tpg->acl_node_lock);
+			mutex_lock(&tpg->acl_node_mutex);
 			if (dynamic_acl)
 				acl->dynamic_node_acl = 1;
-			spin_unlock_irq(&tpg->acl_node_lock);
+			mutex_unlock(&tpg->acl_node_mutex);
 			return -EEXIST;
 		}
 		/*
@@ -587,10 +587,10 @@ int core_tpg_set_initiator_node_queue_depth(
 		if (init_sess)
 			tpg->se_tpg_tfo->close_session(init_sess);
 
-		spin_lock_irq(&tpg->acl_node_lock);
+		mutex_lock(&tpg->acl_node_mutex);
 		if (dynamic_acl)
 			acl->dynamic_node_acl = 1;
-		spin_unlock_irq(&tpg->acl_node_lock);
+		mutex_unlock(&tpg->acl_node_mutex);
 		return -EINVAL;
 	}
 	spin_unlock_irqrestore(&tpg->session_lock, flags);
@@ -606,10 +606,10 @@ int core_tpg_set_initiator_node_queue_depth(
 		initiatorname, tpg->se_tpg_tfo->get_fabric_name(),
 		tpg->se_tpg_tfo->tpg_get_tag(tpg));
 
-	spin_lock_irq(&tpg->acl_node_lock);
+	mutex_lock(&tpg->acl_node_mutex);
 	if (dynamic_acl)
 		acl->dynamic_node_acl = 1;
-	spin_unlock_irq(&tpg->acl_node_lock);
+	mutex_unlock(&tpg->acl_node_mutex);
 
 	return 0;
 }
@@ -708,9 +708,9 @@ int core_tpg_register(
 	INIT_LIST_HEAD(&se_tpg->acl_node_list);
 	INIT_LIST_HEAD(&se_tpg->se_tpg_node);
 	INIT_LIST_HEAD(&se_tpg->tpg_sess_list);
-	spin_lock_init(&se_tpg->acl_node_lock);
 	spin_lock_init(&se_tpg->session_lock);
 	mutex_init(&se_tpg->tpg_lun_mutex);
+	mutex_init(&se_tpg->acl_node_mutex);
 
 	if (se_tpg->se_tpg_type == TRANSPORT_TPG_TYPE_NORMAL) {
 		if (core_tpg_setup_virtual_lun0(se_tpg) < 0) {
@@ -751,25 +751,26 @@ int core_tpg_deregister(struct se_portal_group *se_tpg)
 
 	while (atomic_read(&se_tpg->tpg_pr_ref_count) != 0)
 		cpu_relax();
+
 	/*
 	 * Release any remaining demo-mode generated se_node_acl that have
 	 * not been released because of TFO->tpg_check_demo_mode_cache() == 1
 	 * in transport_deregister_session().
 	 */
-	spin_lock_irq(&se_tpg->acl_node_lock);
+	mutex_lock(&se_tpg->acl_node_mutex);
 	list_for_each_entry_safe(nacl, nacl_tmp, &se_tpg->acl_node_list,
 			acl_list) {
 		list_del(&nacl->acl_list);
 		se_tpg->num_node_acls--;
-		spin_unlock_irq(&se_tpg->acl_node_lock);
+		mutex_unlock(&se_tpg->acl_node_mutex);
 
 		core_tpg_wait_for_nacl_pr_ref(nacl);
 		core_free_device_list_for_node(nacl, se_tpg);
 		se_tpg->se_tpg_tfo->tpg_release_fabric_acl(se_tpg, nacl);
 
-		spin_lock_irq(&se_tpg->acl_node_lock);
+		mutex_lock(&se_tpg->acl_node_mutex);
 	}
-	spin_unlock_irq(&se_tpg->acl_node_lock);
+	mutex_unlock(&se_tpg->acl_node_mutex);
 
 	if (se_tpg->se_tpg_type == TRANSPORT_TPG_TYPE_NORMAL)
 		core_tpg_remove_lun(se_tpg, &se_tpg->tpg_virt_lun0);
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 1fd0f12..dfd78dd 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -473,7 +473,7 @@ void transport_deregister_session(struct se_session *se_sess)
 	struct target_core_fabric_ops *se_tfo;
 	struct se_node_acl *se_nacl;
 	unsigned long flags;
-	bool comp_nacl = true;
+	bool comp_nacl = true, drop_nacl = false;
 
 	if (!se_tpg) {
 		transport_free_session(se_sess);
@@ -493,22 +493,22 @@ void transport_deregister_session(struct se_session *se_sess)
 	 */
 	se_nacl = se_sess->se_node_acl;
 
-	spin_lock_irqsave(&se_tpg->acl_node_lock, flags);
+	mutex_lock(&se_tpg->acl_node_mutex);
 	if (se_nacl && se_nacl->dynamic_node_acl) {
 		if (!se_tfo->tpg_check_demo_mode_cache(se_tpg)) {
 			list_del(&se_nacl->acl_list);
 			se_tpg->num_node_acls--;
-			spin_unlock_irqrestore(&se_tpg->acl_node_lock, flags);
-			core_tpg_wait_for_nacl_pr_ref(se_nacl);
-			core_free_device_list_for_node(se_nacl, se_tpg);
-			se_tfo->tpg_release_fabric_acl(se_tpg, se_nacl);
-
-			comp_nacl = false;
-			spin_lock_irqsave(&se_tpg->acl_node_lock, flags);
+			drop_nacl = true;
 		}
 	}
-	spin_unlock_irqrestore(&se_tpg->acl_node_lock, flags);
+	mutex_unlock(&se_tpg->acl_node_mutex);
 
+	if (drop_nacl) {
+		core_tpg_wait_for_nacl_pr_ref(se_nacl);
+		core_free_device_list_for_node(se_nacl, se_tpg);
+		se_tfo->tpg_release_fabric_acl(se_tpg, se_nacl);
+		comp_nacl = false;
+	}
 	pr_debug("TARGET_CORE[%s]: Deregistered fabric_sess\n",
 		se_tpg->se_tpg_tfo->get_fabric_name());
 	/*
diff --git a/drivers/target/tcm_fc/tfc_conf.c b/drivers/target/tcm_fc/tfc_conf.c
index efdcb96..72187c6 100644
--- a/drivers/target/tcm_fc/tfc_conf.c
+++ b/drivers/target/tcm_fc/tfc_conf.c
@@ -249,7 +249,7 @@ struct ft_node_acl *ft_acl_get(struct ft_tpg *tpg, struct fc_rport_priv *rdata)
 	struct se_portal_group *se_tpg = &tpg->se_tpg;
 	struct se_node_acl *se_acl;
 
-	spin_lock_irq(&se_tpg->acl_node_lock);
+	mutex_lock(&se_tpg->acl_node_mutex);
 	list_for_each_entry(se_acl, &se_tpg->acl_node_list, acl_list) {
 		acl = container_of(se_acl, struct ft_node_acl, se_node_acl);
 		pr_debug("acl %p port_name %llx\n",
@@ -263,7 +263,7 @@ struct ft_node_acl *ft_acl_get(struct ft_tpg *tpg, struct fc_rport_priv *rdata)
 			break;
 		}
 	}
-	spin_unlock_irq(&se_tpg->acl_node_lock);
+	mutex_unlock(&se_tpg->acl_node_mutex);
 	return found;
 }
 
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index 5a7a8fa..20b01cf 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -880,7 +880,7 @@ struct se_portal_group {
 	/* Used for PR SPEC_I_PT=1 and REGISTER_AND_MOVE */
 	atomic_t		tpg_pr_ref_count;
 	/* Spinlock for adding/removing ACLed Nodes */
-	spinlock_t		acl_node_lock;
+	struct mutex		acl_node_mutex;
 	/* Spinlock for adding/removing sessions */
 	spinlock_t		session_lock;
 	struct mutex		tpg_lun_mutex;
-- 
1.9.1

