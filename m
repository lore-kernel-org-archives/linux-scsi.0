From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH-v3 06/10] target: Convert se_tpg->acl_node_lock to ->acl_node_mutex
Date: Tue, 26 May 2015 06:25:26 +0000
Message-ID: <1432621530-24171-7-git-send-email-nab@daterainc.com>
References: <1432621530-24171-1-git-send-email-nab@daterainc.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1432621530-24171-1-git-send-email-nab@daterainc.com>
Sender: target-devel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Sagi Grimberg <sagig@mellanox.com>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch converts se_tpg->acl_node_lock to struct mutex, so that
->acl_node_acl walkers in core_clear_lun_from_tpg() can block when
calling core_disable_device_list_for_node().

It also updates core_dev_add_lun() to hold ->acl_node_mutex when
calling core_tpg_add_node_to_devs() to build ->lun_entry_hlist
for dynamically generated se_node_acl.

Cc: Hannes Reinecke <hare@suse.de>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Sagi Grimberg <sagig@mellanox.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_device.c    | 14 ++++------
 drivers/target/target_core_pr.c        |  8 +++---
 drivers/target/target_core_tpg.c       | 51 +++++++++++++++++-----------------
 drivers/target/target_core_transport.c | 20 ++++++-------
 drivers/target/tcm_fc/tfc_conf.c       |  4 +--
 include/target/target_core_base.h      |  2 +-
 6 files changed, 48 insertions(+), 51 deletions(-)

diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index 64b2c7b..2da22ce 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -437,9 +437,8 @@ void core_clear_lun_from_tpg(struct se_lun *lun, struct se_portal_group *tpg)
 	struct se_node_acl *nacl;
 	struct se_dev_entry *deve;
 
-	spin_lock_irq(&tpg->acl_node_lock);
+	mutex_lock(&tpg->acl_node_mutex);
 	list_for_each_entry(nacl, &tpg->acl_node_list, acl_list) {
-		spin_unlock_irq(&tpg->acl_node_lock);
 
 		mutex_lock(&nacl->lun_entry_mutex);
 		hlist_for_each_entry_rcu(deve, &nacl->lun_entry_hlist, link) {
@@ -451,10 +450,8 @@ void core_clear_lun_from_tpg(struct se_lun *lun, struct se_portal_group *tpg)
 			core_disable_device_list_for_node(lun, deve, nacl, tpg);
 		}
 		mutex_unlock(&nacl->lun_entry_mutex);
-
-		spin_lock_irq(&tpg->acl_node_lock);
 	}
-	spin_unlock_irq(&tpg->acl_node_lock);
+	mutex_unlock(&tpg->acl_node_mutex);
 }
 
 static struct se_port *core_alloc_port(struct se_device *dev)
@@ -1190,17 +1187,16 @@ int core_dev_add_lun(
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
 
 	return 0;
diff --git a/drivers/target/target_core_pr.c b/drivers/target/target_core_pr.c
index 730f885..e7a5f3b 100644
--- a/drivers/target/target_core_pr.c
+++ b/drivers/target/target_core_pr.c
@@ -1581,12 +1581,12 @@ core_scsi3_decode_spec_i_port(
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
@@ -3298,12 +3298,12 @@ after_iport_check:
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
index 13d34e2..229e827 100644
--- a/drivers/target/target_core_tpg.c
+++ b/drivers/target/target_core_tpg.c
@@ -49,7 +49,7 @@ static LIST_HEAD(tpg_list);
 
 /*	__core_tpg_get_initiator_node_acl():
  *
- *	spin_lock_bh(&tpg->acl_node_lock); must be held when calling
+ *	mutex_lock(&tpg->acl_node_mutex); must be held when calling
  */
 struct se_node_acl *__core_tpg_get_initiator_node_acl(
 	struct se_portal_group *tpg,
@@ -75,9 +75,9 @@ struct se_node_acl *core_tpg_get_initiator_node_acl(
 {
 	struct se_node_acl *acl;
 
-	spin_lock_irq(&tpg->acl_node_lock);
+	mutex_lock(&tpg->acl_node_mutex);
 	acl = __core_tpg_get_initiator_node_acl(tpg, initiatorname);
-	spin_unlock_irq(&tpg->acl_node_lock);
+	mutex_unlock(&tpg->acl_node_mutex);
 
 	return acl;
 }
@@ -198,10 +198,10 @@ static void target_add_node_acl(struct se_node_acl *acl)
 {
 	struct se_portal_group *tpg = acl->se_tpg;
 
-	spin_lock_irq(&tpg->acl_node_lock);
+	mutex_lock(&tpg->acl_node_mutex);
 	list_add_tail(&acl->acl_list, &tpg->acl_node_list);
 	tpg->num_node_acls++;
-	spin_unlock_irq(&tpg->acl_node_lock);
+	mutex_unlock(&tpg->acl_node_mutex);
 
 	pr_debug("%s_TPG[%hu] - Added %s ACL with TCQ Depth: %d for %s"
 		" Initiator Node: %s\n",
@@ -257,7 +257,7 @@ struct se_node_acl *core_tpg_add_initiator_node_acl(
 {
 	struct se_node_acl *acl;
 
-	spin_lock_irq(&tpg->acl_node_lock);
+	mutex_lock(&tpg->acl_node_mutex);
 	acl = __core_tpg_get_initiator_node_acl(tpg, initiatorname);
 	if (acl) {
 		if (acl->dynamic_node_acl) {
@@ -265,7 +265,7 @@ struct se_node_acl *core_tpg_add_initiator_node_acl(
 			pr_debug("%s_TPG[%u] - Replacing dynamic ACL"
 				" for %s\n", tpg->se_tpg_tfo->get_fabric_name(),
 				tpg->se_tpg_tfo->tpg_get_tag(tpg), initiatorname);
-			spin_unlock_irq(&tpg->acl_node_lock);
+			mutex_unlock(&tpg->acl_node_mutex);
 			return acl;
 		}
 
@@ -273,10 +273,10 @@ struct se_node_acl *core_tpg_add_initiator_node_acl(
 			" Node %s already exists for TPG %u, ignoring"
 			" request.\n",  tpg->se_tpg_tfo->get_fabric_name(),
 			initiatorname, tpg->se_tpg_tfo->tpg_get_tag(tpg));
-		spin_unlock_irq(&tpg->acl_node_lock);
+		mutex_unlock(&tpg->acl_node_mutex);
 		return ERR_PTR(-EEXIST);
 	}
-	spin_unlock_irq(&tpg->acl_node_lock);
+	mutex_unlock(&tpg->acl_node_mutex);
 
 	acl = target_alloc_node_acl(tpg, initiatorname);
 	if (!acl)
@@ -294,13 +294,13 @@ void core_tpg_del_initiator_node_acl(struct se_node_acl *acl)
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
@@ -357,21 +357,21 @@ int core_tpg_set_initiator_node_queue_depth(
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
@@ -387,10 +387,10 @@ int core_tpg_set_initiator_node_queue_depth(
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
@@ -425,10 +425,10 @@ int core_tpg_set_initiator_node_queue_depth(
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
@@ -444,10 +444,10 @@ int core_tpg_set_initiator_node_queue_depth(
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
@@ -521,9 +521,9 @@ int core_tpg_register(
 	INIT_LIST_HEAD(&se_tpg->acl_node_list);
 	INIT_LIST_HEAD(&se_tpg->se_tpg_node);
 	INIT_LIST_HEAD(&se_tpg->tpg_sess_list);
-	spin_lock_init(&se_tpg->acl_node_lock);
 	spin_lock_init(&se_tpg->session_lock);
 	mutex_init(&se_tpg->tpg_lun_mutex);
+	mutex_init(&se_tpg->acl_node_mutex);
 
 	if (se_tpg->proto_id >= 0) {
 		if (core_tpg_setup_virtual_lun0(se_tpg) < 0)
@@ -559,25 +559,26 @@ int core_tpg_deregister(struct se_portal_group *se_tpg)
 
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
 		kfree(nacl);
 
-		spin_lock_irq(&se_tpg->acl_node_lock);
+		mutex_lock(&se_tpg->acl_node_mutex);
 	}
-	spin_unlock_irq(&se_tpg->acl_node_lock);
+	mutex_unlock(&se_tpg->acl_node_mutex);
 
 	if (se_tpg->proto_id >= 0)
 		core_tpg_remove_lun(se_tpg, &se_tpg->tpg_virt_lun0);
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 6aa6287..2b9f41a 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -498,7 +498,7 @@ void transport_deregister_session(struct se_session *se_sess)
 	const struct target_core_fabric_ops *se_tfo;
 	struct se_node_acl *se_nacl;
 	unsigned long flags;
-	bool comp_nacl = true;
+	bool comp_nacl = true, drop_nacl = false;
 
 	if (!se_tpg) {
 		transport_free_session(se_sess);
@@ -518,22 +518,22 @@ void transport_deregister_session(struct se_session *se_sess)
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
-			kfree(se_nacl);
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
+		kfree(se_nacl);
+		comp_nacl = false;
+	}
 	pr_debug("TARGET_CORE[%s]: Deregistered fabric_sess\n",
 		se_tpg->se_tpg_tfo->get_fabric_name());
 	/*
diff --git a/drivers/target/tcm_fc/tfc_conf.c b/drivers/target/tcm_fc/tfc_conf.c
index ee56531..8e1a54f 100644
--- a/drivers/target/tcm_fc/tfc_conf.c
+++ b/drivers/target/tcm_fc/tfc_conf.c
@@ -217,7 +217,7 @@ struct ft_node_acl *ft_acl_get(struct ft_tpg *tpg, struct fc_rport_priv *rdata)
 	struct se_portal_group *se_tpg = &tpg->se_tpg;
 	struct se_node_acl *se_acl;
 
-	spin_lock_irq(&se_tpg->acl_node_lock);
+	mutex_lock(&se_tpg->acl_node_mutex);
 	list_for_each_entry(se_acl, &se_tpg->acl_node_list, acl_list) {
 		acl = container_of(se_acl, struct ft_node_acl, se_node_acl);
 		pr_debug("acl %p port_name %llx\n",
@@ -231,7 +231,7 @@ struct ft_node_acl *ft_acl_get(struct ft_tpg *tpg, struct fc_rport_priv *rdata)
 			break;
 		}
 	}
-	spin_unlock_irq(&se_tpg->acl_node_lock);
+	mutex_unlock(&se_tpg->acl_node_mutex);
 	return found;
 }
 
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index c15fa1a..2b6adac 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -876,7 +876,7 @@ struct se_portal_group {
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
