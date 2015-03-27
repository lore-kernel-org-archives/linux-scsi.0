From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [RFC 14/22] target: Convert se_node_acl->lun_entry_lock to ->lun_entry_mutex
Date: Fri, 27 Mar 2015 08:05:04 +0000
Message-ID: <1427443512-8925-15-git-send-email-nab@daterainc.com>
References: <1427443512-8925-1-git-send-email-nab@daterainc.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1427443512-8925-1-git-send-email-nab@daterainc.com>
Sender: target-devel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagig@mellanox.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

Now that se_node_acl->lun_entry_hlist[] fast path access uses RCU,
go ahead and convert se_node_acl->lun_entry_lock to struct mutex,
for non fast-path RCU updater code.

Cc: Hannes Reinecke <hare@suse.de>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Sagi Grimberg <sagig@mellanox.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_device.c | 18 ++++++++----------
 drivers/target/target_core_pr.c     | 12 ++++++------
 drivers/target/target_core_tpg.c    | 14 ++++++--------
 include/target/target_core_base.h   |  3 +--
 4 files changed, 21 insertions(+), 26 deletions(-)

diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index 965d81e..2a5fa88 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -304,7 +304,7 @@ void core_update_device_list_access(
 {
 	struct se_dev_entry *deve;
 
-	spin_lock_irq(&nacl->lun_entry_lock);
+	mutex_lock(&nacl->lun_entry_mutex);
 	deve = rcu_dereference(nacl->lun_entry_hlist[mapped_lun]);
 	if (lun_access & TRANSPORT_LUNFLAGS_READ_WRITE) {
 		deve->lun_flags &= ~TRANSPORT_LUNFLAGS_READ_ONLY;
@@ -313,7 +313,7 @@ void core_update_device_list_access(
 		deve->lun_flags &= ~TRANSPORT_LUNFLAGS_READ_WRITE;
 		deve->lun_flags |= TRANSPORT_LUNFLAGS_READ_ONLY;
 	}
-	spin_unlock_irq(&nacl->lun_entry_lock);
+	mutex_unlock(&nacl->lun_entry_mutex);
 
 	synchronize_rcu();
 }
@@ -345,7 +345,7 @@ int core_enable_device_list_for_node(
 	 * transition.  This transition must be for the same struct se_lun
 	 * + mapped_lun that was setup in demo mode..
 	 */
-	spin_lock_irq(&nacl->lun_entry_lock);
+	mutex_lock(&nacl->lun_entry_mutex);
 	deve = nacl->lun_entry_hlist[mapped_lun];
 	if (deve->lun_flags & TRANSPORT_LUNFLAGS_INITIATOR_ACCESS) {
 		BUG_ON(deve->se_lun_acl != NULL);
@@ -359,7 +359,7 @@ int core_enable_device_list_for_node(
 			deve->lun_flags |= TRANSPORT_LUNFLAGS_READ_ONLY;
 		}
 		rcu_assign_pointer(deve->se_lun_acl, lun_acl);
-		spin_unlock_irq(&nacl->lun_entry_lock);
+		mutex_unlock(&nacl->lun_entry_mutex);
 
 		synchronize_rcu();
 		return 0;
@@ -384,7 +384,7 @@ int core_enable_device_list_for_node(
 
 	rcu_assign_pointer(deve->se_lun, lun);
 	rcu_assign_pointer(deve->se_lun_acl, lun_acl);
-	spin_unlock_irq(&nacl->lun_entry_lock);
+	mutex_unlock(&nacl->lun_entry_mutex);
 
 	spin_lock_bh(&port->sep_alua_lock);
 	list_add_tail(&deve->alua_port_list, &port->sep_alua_list);
@@ -409,8 +409,8 @@ int core_disable_device_list_for_node(
 	struct se_port *port = lun->lun_sep;
 	struct se_dev_entry *deve;
 
-	rcu_read_lock();
-	deve = rcu_dereference(nacl->lun_entry_hlist[mapped_lun]);
+	mutex_lock(&nacl->lun_entry_mutex);
+	deve = (nacl->lun_entry_hlist[mapped_lun]);
 	/*
 	 * If the MappedLUN entry is being disabled, the entry in
 	 * port->sep_alua_list must be removed now before clearing the
@@ -430,7 +430,6 @@ int core_disable_device_list_for_node(
 	/*
 	 * Disable struct se_dev_entry LUN ACL mapping
 	 */
-	spin_lock_irq(&nacl->lun_entry_lock);
 	core_scsi3_ua_release_all(deve);
 	rcu_assign_pointer(deve->pr_reg, NULL);
 	rcu_assign_pointer(deve->se_lun, NULL);
@@ -438,8 +437,7 @@ int core_disable_device_list_for_node(
 	deve->lun_flags = 0;
 	deve->creation_time = 0;
 	deve->attach_count--;
-	spin_unlock_irq(&nacl->lun_entry_lock);
-	rcu_read_unlock();
+	mutex_unlock(&nacl->lun_entry_mutex);
 
 	/*
 	 * Wait for RCU read critical sections to complete after
diff --git a/drivers/target/target_core_pr.c b/drivers/target/target_core_pr.c
index 3b83026..93e109e 100644
--- a/drivers/target/target_core_pr.c
+++ b/drivers/target/target_core_pr.c
@@ -1030,10 +1030,10 @@ static void __core_scsi3_add_registration(
 	__core_scsi3_dump_registration(tfo, dev, nacl, pr_reg, register_type);
 	spin_unlock(&pr_tmpl->registration_lock);
 
-	spin_lock(&nacl->lun_entry_lock);
+	mutex_lock(&nacl->lun_entry_mutex);
 	deve = nacl->lun_entry_hlist[pr_reg->pr_res_mapped_lun];
 	rcu_assign_pointer(deve->pr_reg, pr_reg);
-	spin_unlock(&nacl->lun_entry_lock);
+	mutex_unlock(&nacl->lun_entry_mutex);
 	/*
 	 * Wait for read path critical RCU in core_scsi3_pr_seq_non_holder()
 	 * conditional checks for deve->pr_reg pointer access complete.
@@ -1065,10 +1065,10 @@ static void __core_scsi3_add_registration(
 					       register_type);
 		spin_unlock(&pr_tmpl->registration_lock);
 
-		spin_lock(&nacl->lun_entry_lock);
+		mutex_lock(&nacl->lun_entry_mutex);
 		deve = nacl_tmp->lun_entry_hlist[pr_reg_tmp->pr_res_mapped_lun];
 		rcu_assign_pointer(deve->pr_reg, pr_reg_tmp);
-		spin_unlock(&nacl->lun_entry_lock);
+		mutex_unlock(&nacl->lun_entry_mutex);
 		/*
 		 * Wait for read path critical RCU in core_scsi3_pr_seq_non_holder()
 		 * conditional checks for deve->pr_reg pointer access complete.
@@ -1280,10 +1280,10 @@ static void __core_scsi3_free_registration(
 		cpu_relax();
 	}
 
-	spin_lock(&nacl->lun_entry_lock);
+	mutex_lock(&nacl->lun_entry_mutex);
 	deve = nacl->lun_entry_hlist[pr_reg->pr_res_mapped_lun];
 	rcu_assign_pointer(deve->pr_reg, NULL);
-	spin_unlock(&nacl->lun_entry_lock);
+	mutex_unlock(&nacl->lun_entry_mutex);
 	/*
 	 * Wait for read path critical RCU in core_scsi3_pr_seq_non_holder()
 	 * conditional checks for deve->pr_reg pointer access complete.
diff --git a/drivers/target/target_core_tpg.c b/drivers/target/target_core_tpg.c
index 027707a..3d81a72 100644
--- a/drivers/target/target_core_tpg.c
+++ b/drivers/target/target_core_tpg.c
@@ -275,9 +275,8 @@ struct se_node_acl *core_tpg_check_initiator_node_acl(
 	INIT_LIST_HEAD(&acl->acl_sess_list);
 	kref_init(&acl->acl_kref);
 	init_completion(&acl->acl_free_comp);
-	spin_lock_init(&acl->device_list_lock);
 	spin_lock_init(&acl->nacl_sess_lock);
-	spin_lock_init(&acl->lun_entry_lock);
+	mutex_init(&acl->lun_entry_mutex);
 	atomic_set(&acl->acl_pr_ref_count, 0);
 	acl->queue_depth = tpg->se_tpg_tfo->tpg_get_default_depth(tpg);
 	snprintf(acl->initiatorname, TRANSPORT_IQN_LEN, "%s", initiatorname);
@@ -331,7 +330,7 @@ void core_tpg_clear_object_luns(struct se_portal_group *tpg)
 	int i;
 	struct se_lun *lun;
 
-	spin_lock(&tpg->tpg_lun_lock);
+	mutex_lock(&tpg->tpg_lun_mutex);
 	for (i = 0; i < TRANSPORT_MAX_LUNS_PER_TPG; i++) {
 		lun = tpg->tpg_lun_list[i];
 
@@ -339,11 +338,11 @@ void core_tpg_clear_object_luns(struct se_portal_group *tpg)
 		    (lun->lun_se_dev == NULL))
 			continue;
 
-		spin_unlock(&tpg->tpg_lun_lock);
+		mutex_unlock(&tpg->tpg_lun_mutex);
 		core_dev_del_lun(tpg, lun);
-		spin_lock(&tpg->tpg_lun_lock);
+		mutex_lock(&tpg->tpg_lun_mutex);
 	}
-	spin_unlock(&tpg->tpg_lun_lock);
+	mutex_unlock(&tpg->tpg_lun_mutex);
 }
 EXPORT_SYMBOL(core_tpg_clear_object_luns);
 
@@ -403,9 +402,8 @@ struct se_node_acl *core_tpg_add_initiator_node_acl(
 	INIT_LIST_HEAD(&acl->acl_sess_list);
 	kref_init(&acl->acl_kref);
 	init_completion(&acl->acl_free_comp);
-	spin_lock_init(&acl->device_list_lock);
 	spin_lock_init(&acl->nacl_sess_lock);
-	spin_lock_init(&acl->lun_entry_lock);
+	mutex_init(&acl->lun_entry_mutex);
 	atomic_set(&acl->acl_pr_ref_count, 0);
 	acl->queue_depth = queue_depth;
 	snprintf(acl->initiatorname, TRANSPORT_IQN_LEN, "%s", initiatorname);
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index 20b01cf..ab25709 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -599,8 +599,7 @@ struct se_node_acl {
 	struct se_dev_entry	**device_list;
 	struct se_session	*nacl_sess;
 	struct se_portal_group *se_tpg;
-	spinlock_t		device_list_lock;
-	spinlock_t		lun_entry_lock;
+	struct mutex		lun_entry_mutex;
 	spinlock_t		nacl_sess_lock;
 	struct config_group	acl_group;
 	struct config_group	acl_attrib_group;
-- 
1.9.1
