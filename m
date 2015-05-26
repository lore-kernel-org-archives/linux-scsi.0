From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH-v3 01/10] target: Convert se_node_acl->device_list[] to RCU hlist
Date: Tue, 26 May 2015 06:25:21 +0000
Message-ID: <1432621530-24171-2-git-send-email-nab@daterainc.com>
References: <1432621530-24171-1-git-send-email-nab@daterainc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ob0-f177.google.com ([209.85.214.177]:35344 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751246AbbEZGvd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 26 May 2015 02:51:33 -0400
Received: by obbgf1 with SMTP id gf1so26257508obb.2
        for <linux-scsi@vger.kernel.org>; Mon, 25 May 2015 23:51:32 -0700 (PDT)
In-Reply-To: <1432621530-24171-1-git-send-email-nab@daterainc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Sagi Grimberg <sagig@mellanox.com>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch converts se_node_acl->device_list[] table for mappedluns
to modern RCU hlist_head usage in order to support an arbitrary number
of node_acl lun mappings.

It converts transport_lookup_*_lun() fast-path code to use RCU read path
primitives when looking up se_dev_entry.  It adds a new hlist_head at
se_node_acl->lun_entry_hlist for this purpose.

For transport_lookup_cmd_lun() code, it works with existing per-cpu
se_lun->lun_ref when associating se_cmd with se_lun + se_device.
Also, go ahead and update core_create_device_list_for_node() +
core_free_device_list_for_node() to use ->lun_entry_hlist.

It also converts se_dev_entry->pr_ref_count access to use modern
struct kref counting, and updates core_disable_device_list_for_node()
to kref_put() and block on se_deve->pr_comp waiting for outstanding PR
special-case PR references to drop, then invoke kfree_rcu() to wait
for the RCU grace period to complete before releasing memory.

So now that se_node_acl->lun_entry_hlist fast path access uses RCU
protected pointers, go ahead and convert remaining non-fast path
RCU updater code using ->lun_entry_lock to struct mutex to allow
callers to block while walking se_node_acl->lun_entry_hlist.

Finally drop the left-over core_clear_initiator_node_from_tpg() that
originally cleared lun_access during se_node_acl shutdown, as post
RCU conversion it now becomes duplicated logic.

Cc: Hannes Reinecke <hare@suse.de>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Sagi Grimberg <sagig@mellanox.com>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_alua.c            |   2 +-
 drivers/target/target_core_device.c          | 353 ++++++++++++++-------------
 drivers/target/target_core_fabric_configfs.c |  43 ++--
 drivers/target/target_core_internal.h        |   8 +-
 drivers/target/target_core_pr.c              |  72 +++---
 drivers/target/target_core_pscsi.c           |   7 +-
 drivers/target/target_core_spc.c             |  18 +-
 drivers/target/target_core_stat.c            | 197 +++++++--------
 drivers/target/target_core_tpg.c             |  75 +-----
 drivers/target/target_core_ua.c              |  51 ++--
 include/target/target_core_backend.h         |   2 +-
 include/target/target_core_base.h            |  27 +-
 12 files changed, 411 insertions(+), 444 deletions(-)

diff --git a/drivers/target/target_core_alua.c b/drivers/target/target_core_alua.c
index 80b43a7..e832491 100644
--- a/drivers/target/target_core_alua.c
+++ b/drivers/target/target_core_alua.c
@@ -1001,7 +1001,7 @@ static void core_alua_do_transition_tg_pt_work(struct work_struct *work)
 		spin_lock_bh(&port->sep_alua_lock);
 		list_for_each_entry(se_deve, &port->sep_alua_list,
 					alua_port_list) {
-			lacl = se_deve->se_lun_acl;
+			lacl = lockless_dereference(se_deve->se_lun_acl);
 			/*
 			 * se_deve->se_lun_acl pointer may be NULL for a
 			 * entry created without explicit Node+MappedLUN ACLs
diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index 6e58976..a78fa90 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -59,18 +59,17 @@ transport_lookup_cmd_lun(struct se_cmd *se_cmd, u32 unpacked_lun)
 {
 	struct se_lun *se_lun = NULL;
 	struct se_session *se_sess = se_cmd->se_sess;
+	struct se_node_acl *nacl = se_sess->se_node_acl;
 	struct se_device *dev;
-	unsigned long flags;
+	struct se_dev_entry *deve;
 
 	if (unpacked_lun >= TRANSPORT_MAX_LUNS_PER_TPG)
 		return TCM_NON_EXISTENT_LUN;
 
-	spin_lock_irqsave(&se_sess->se_node_acl->device_list_lock, flags);
-	se_cmd->se_deve = se_sess->se_node_acl->device_list[unpacked_lun];
-	if (se_cmd->se_deve->lun_flags & TRANSPORT_LUNFLAGS_INITIATOR_ACCESS) {
-		struct se_dev_entry *deve = se_cmd->se_deve;
-
-		deve->total_cmds++;
+	rcu_read_lock();
+	deve = target_nacl_find_deve(nacl, unpacked_lun);
+	if (deve) {
+		atomic_long_inc(&deve->total_cmds);
 
 		if ((se_cmd->data_direction == DMA_TO_DEVICE) &&
 		    (deve->lun_flags & TRANSPORT_LUNFLAGS_READ_ONLY)) {
@@ -78,17 +77,19 @@ transport_lookup_cmd_lun(struct se_cmd *se_cmd, u32 unpacked_lun)
 				" Access for 0x%08x\n",
 				se_cmd->se_tfo->get_fabric_name(),
 				unpacked_lun);
-			spin_unlock_irqrestore(&se_sess->se_node_acl->device_list_lock, flags);
+			rcu_read_unlock();
 			return TCM_WRITE_PROTECTED;
 		}
 
 		if (se_cmd->data_direction == DMA_TO_DEVICE)
-			deve->write_bytes += se_cmd->data_length;
+			atomic_long_add(se_cmd->data_length,
+					&deve->write_bytes);
 		else if (se_cmd->data_direction == DMA_FROM_DEVICE)
-			deve->read_bytes += se_cmd->data_length;
+			atomic_long_add(se_cmd->data_length,
+					&deve->read_bytes);
 
-		se_lun = deve->se_lun;
-		se_cmd->se_lun = deve->se_lun;
+		se_lun = rcu_dereference(deve->se_lun);
+		se_cmd->se_lun = rcu_dereference(deve->se_lun);
 		se_cmd->pr_res_key = deve->pr_res_key;
 		se_cmd->orig_fe_lun = unpacked_lun;
 		se_cmd->se_cmd_flags |= SCF_SE_LUN_CMD;
@@ -96,7 +97,7 @@ transport_lookup_cmd_lun(struct se_cmd *se_cmd, u32 unpacked_lun)
 		percpu_ref_get(&se_lun->lun_ref);
 		se_cmd->lun_ref_active = true;
 	}
-	spin_unlock_irqrestore(&se_sess->se_node_acl->device_list_lock, flags);
+	rcu_read_unlock();
 
 	if (!se_lun) {
 		/*
@@ -146,24 +147,23 @@ int transport_lookup_tmr_lun(struct se_cmd *se_cmd, u32 unpacked_lun)
 	struct se_dev_entry *deve;
 	struct se_lun *se_lun = NULL;
 	struct se_session *se_sess = se_cmd->se_sess;
+	struct se_node_acl *nacl = se_sess->se_node_acl;
 	struct se_tmr_req *se_tmr = se_cmd->se_tmr_req;
 	unsigned long flags;
 
 	if (unpacked_lun >= TRANSPORT_MAX_LUNS_PER_TPG)
 		return -ENODEV;
 
-	spin_lock_irqsave(&se_sess->se_node_acl->device_list_lock, flags);
-	se_cmd->se_deve = se_sess->se_node_acl->device_list[unpacked_lun];
-	deve = se_cmd->se_deve;
-
-	if (deve->lun_flags & TRANSPORT_LUNFLAGS_INITIATOR_ACCESS) {
-		se_tmr->tmr_lun = deve->se_lun;
-		se_cmd->se_lun = deve->se_lun;
-		se_lun = deve->se_lun;
+	rcu_read_lock();
+	deve = target_nacl_find_deve(nacl, unpacked_lun);
+	if (deve) {
+		se_tmr->tmr_lun = rcu_dereference(deve->se_lun);
+		se_cmd->se_lun = rcu_dereference(deve->se_lun);
+		se_lun = rcu_dereference(deve->se_lun);
 		se_cmd->pr_res_key = deve->pr_res_key;
 		se_cmd->orig_fe_lun = unpacked_lun;
 	}
-	spin_unlock_irqrestore(&se_sess->se_node_acl->device_list_lock, flags);
+	rcu_read_unlock();
 
 	if (!se_lun) {
 		pr_debug("TARGET_CORE[%s]: Detected NON_EXISTENT_LUN"
@@ -185,9 +185,27 @@ int transport_lookup_tmr_lun(struct se_cmd *se_cmd, u32 unpacked_lun)
 }
 EXPORT_SYMBOL(transport_lookup_tmr_lun);
 
+bool target_lun_is_rdonly(struct se_cmd *cmd)
+{
+	struct se_session *se_sess = cmd->se_sess;
+	struct se_dev_entry *deve;
+	bool ret;
+
+	if (cmd->se_lun->lun_access & TRANSPORT_LUNFLAGS_READ_ONLY)
+		return true;
+
+	rcu_read_lock();
+	deve = target_nacl_find_deve(se_sess->se_node_acl, cmd->orig_fe_lun);
+	ret = (deve && deve->lun_flags & TRANSPORT_LUNFLAGS_READ_ONLY);
+	rcu_read_unlock();
+
+	return ret;
+}
+EXPORT_SYMBOL(target_lun_is_rdonly);
+
 /*
  * This function is called from core_scsi3_emulate_pro_register_and_move()
- * and core_scsi3_decode_spec_i_port(), and will increment &deve->pr_ref_count
+ * and core_scsi3_decode_spec_i_port(), and will increment &deve->pr_kref
  * when a matching rtpi is found.
  */
 struct se_dev_entry *core_get_se_deve_from_rtpi(
@@ -196,81 +214,42 @@ struct se_dev_entry *core_get_se_deve_from_rtpi(
 {
 	struct se_dev_entry *deve;
 	struct se_lun *lun;
-	struct se_port *port;
 	struct se_portal_group *tpg = nacl->se_tpg;
-	u32 i;
-
-	spin_lock_irq(&nacl->device_list_lock);
-	for (i = 0; i < TRANSPORT_MAX_LUNS_PER_TPG; i++) {
-		deve = nacl->device_list[i];
-
-		if (!(deve->lun_flags & TRANSPORT_LUNFLAGS_INITIATOR_ACCESS))
-			continue;
 
-		lun = deve->se_lun;
+	rcu_read_lock();
+	hlist_for_each_entry_rcu(deve, &nacl->lun_entry_hlist, link) {
+		lun = rcu_dereference(deve->se_lun);
 		if (!lun) {
 			pr_err("%s device entries device pointer is"
 				" NULL, but Initiator has access.\n",
 				tpg->se_tpg_tfo->get_fabric_name());
 			continue;
 		}
-		port = lun->lun_sep;
-		if (!port) {
-			pr_err("%s device entries device pointer is"
-				" NULL, but Initiator has access.\n",
-				tpg->se_tpg_tfo->get_fabric_name());
-			continue;
-		}
-		if (port->sep_rtpi != rtpi)
+		if (lun->lun_rtpi != rtpi)
 			continue;
 
-		atomic_inc_mb(&deve->pr_ref_count);
-		spin_unlock_irq(&nacl->device_list_lock);
+		kref_get(&deve->pr_kref);
+		rcu_read_unlock();
 
 		return deve;
 	}
-	spin_unlock_irq(&nacl->device_list_lock);
+	rcu_read_unlock();
 
 	return NULL;
 }
 
-int core_free_device_list_for_node(
+void core_free_device_list_for_node(
 	struct se_node_acl *nacl,
 	struct se_portal_group *tpg)
 {
 	struct se_dev_entry *deve;
-	struct se_lun *lun;
-	u32 i;
-
-	if (!nacl->device_list)
-		return 0;
 
-	spin_lock_irq(&nacl->device_list_lock);
-	for (i = 0; i < TRANSPORT_MAX_LUNS_PER_TPG; i++) {
-		deve = nacl->device_list[i];
-
-		if (!(deve->lun_flags & TRANSPORT_LUNFLAGS_INITIATOR_ACCESS))
-			continue;
-
-		if (!deve->se_lun) {
-			pr_err("%s device entries device pointer is"
-				" NULL, but Initiator has access.\n",
-				tpg->se_tpg_tfo->get_fabric_name());
-			continue;
-		}
-		lun = deve->se_lun;
-
-		spin_unlock_irq(&nacl->device_list_lock);
-		core_disable_device_list_for_node(lun, NULL, deve->mapped_lun,
-			TRANSPORT_LUNFLAGS_NO_ACCESS, nacl, tpg);
-		spin_lock_irq(&nacl->device_list_lock);
+	mutex_lock(&nacl->lun_entry_mutex);
+	hlist_for_each_entry_rcu(deve, &nacl->lun_entry_hlist, link) {
+		struct se_lun *lun = lockless_dereference(deve->se_lun);
+		core_disable_device_list_for_node(lun, deve, nacl, tpg);
 	}
-	spin_unlock_irq(&nacl->device_list_lock);
-
-	array_free(nacl->device_list, TRANSPORT_MAX_LUNS_PER_TPG);
-	nacl->device_list = NULL;
-
-	return 0;
+	mutex_unlock(&nacl->lun_entry_mutex);
 }
 
 void core_update_device_list_access(
@@ -280,16 +259,40 @@ void core_update_device_list_access(
 {
 	struct se_dev_entry *deve;
 
-	spin_lock_irq(&nacl->device_list_lock);
-	deve = nacl->device_list[mapped_lun];
-	if (lun_access & TRANSPORT_LUNFLAGS_READ_WRITE) {
-		deve->lun_flags &= ~TRANSPORT_LUNFLAGS_READ_ONLY;
-		deve->lun_flags |= TRANSPORT_LUNFLAGS_READ_WRITE;
-	} else {
-		deve->lun_flags &= ~TRANSPORT_LUNFLAGS_READ_WRITE;
-		deve->lun_flags |= TRANSPORT_LUNFLAGS_READ_ONLY;
+	mutex_lock(&nacl->lun_entry_mutex);
+	deve = target_nacl_find_deve(nacl, mapped_lun);
+	if (deve) {
+		if (lun_access & TRANSPORT_LUNFLAGS_READ_WRITE) {
+			deve->lun_flags &= ~TRANSPORT_LUNFLAGS_READ_ONLY;
+			deve->lun_flags |= TRANSPORT_LUNFLAGS_READ_WRITE;
+		} else {
+			deve->lun_flags &= ~TRANSPORT_LUNFLAGS_READ_WRITE;
+			deve->lun_flags |= TRANSPORT_LUNFLAGS_READ_ONLY;
+		}
 	}
-	spin_unlock_irq(&nacl->device_list_lock);
+	mutex_unlock(&nacl->lun_entry_mutex);
+}
+
+/*
+ * Called with rcu_read_lock or nacl->device_list_lock held.
+ */
+struct se_dev_entry *target_nacl_find_deve(struct se_node_acl *nacl, u32 mapped_lun)
+{
+	struct se_dev_entry *deve;
+
+	hlist_for_each_entry_rcu(deve, &nacl->lun_entry_hlist, link)
+		if (deve->mapped_lun == mapped_lun)
+			return deve;
+
+	return NULL;
+}
+EXPORT_SYMBOL(target_nacl_find_deve);
+
+void target_pr_kref_release(struct kref *kref)
+{
+	struct se_dev_entry *deve = container_of(kref, struct se_dev_entry,
+						 pr_kref);
+	complete(&deve->pr_comp);
 }
 
 /*      core_enable_device_list_for_node():
@@ -305,85 +308,86 @@ int core_enable_device_list_for_node(
 	struct se_portal_group *tpg)
 {
 	struct se_port *port = lun->lun_sep;
-	struct se_dev_entry *deve;
-
-	spin_lock_irq(&nacl->device_list_lock);
-
-	deve = nacl->device_list[mapped_lun];
-
-	/*
-	 * Check if the call is handling demo mode -> explicit LUN ACL
-	 * transition.  This transition must be for the same struct se_lun
-	 * + mapped_lun that was setup in demo mode..
-	 */
-	if (deve->lun_flags & TRANSPORT_LUNFLAGS_INITIATOR_ACCESS) {
-		if (deve->se_lun_acl != NULL) {
-			pr_err("struct se_dev_entry->se_lun_acl"
-			       " already set for demo mode -> explicit"
-			       " LUN ACL transition\n");
-			spin_unlock_irq(&nacl->device_list_lock);
+	struct se_dev_entry *orig, *new;
+
+	new = kzalloc(sizeof(*new), GFP_KERNEL);
+	if (!new) {
+		pr_err("Unable to allocate se_dev_entry memory\n");
+		return -ENOMEM;
+	}
+
+	atomic_set(&new->ua_count, 0);
+	spin_lock_init(&new->ua_lock);
+	INIT_LIST_HEAD(&new->alua_port_list);
+	INIT_LIST_HEAD(&new->ua_list);
+
+	new->mapped_lun = mapped_lun;
+	kref_init(&new->pr_kref);
+	init_completion(&new->pr_comp);
+
+	if (lun_access & TRANSPORT_LUNFLAGS_READ_WRITE)
+		new->lun_flags |= TRANSPORT_LUNFLAGS_READ_WRITE;
+	else
+		new->lun_flags |= TRANSPORT_LUNFLAGS_READ_ONLY;
+
+	new->creation_time = get_jiffies_64();
+	new->attach_count++;
+
+	mutex_lock(&nacl->lun_entry_mutex);
+	orig = target_nacl_find_deve(nacl, mapped_lun);
+	if (orig && orig->se_lun) {
+		struct se_lun *orig_lun = lockless_dereference(orig->se_lun);
+
+		if (orig_lun != lun) {
+			pr_err("Existing orig->se_lun doesn't match new lun"
+			       " for dynamic -> explicit NodeACL conversion:"
+				" %s\n", nacl->initiatorname);
+			mutex_unlock(&nacl->lun_entry_mutex);
+			kfree(new);
 			return -EINVAL;
 		}
-		if (deve->se_lun != lun) {
-			pr_err("struct se_dev_entry->se_lun does"
-			       " match passed struct se_lun for demo mode"
-			       " -> explicit LUN ACL transition\n");
-			spin_unlock_irq(&nacl->device_list_lock);
-			return -EINVAL;
-		}
-		deve->se_lun_acl = lun_acl;
+		BUG_ON(orig->se_lun_acl != NULL);
 
-		if (lun_access & TRANSPORT_LUNFLAGS_READ_WRITE) {
-			deve->lun_flags &= ~TRANSPORT_LUNFLAGS_READ_ONLY;
-			deve->lun_flags |= TRANSPORT_LUNFLAGS_READ_WRITE;
-		} else {
-			deve->lun_flags &= ~TRANSPORT_LUNFLAGS_READ_WRITE;
-			deve->lun_flags |= TRANSPORT_LUNFLAGS_READ_ONLY;
-		}
+		rcu_assign_pointer(new->se_lun, lun);
+		rcu_assign_pointer(new->se_lun_acl, lun_acl);
+		hlist_del_rcu(&orig->link);
+		hlist_add_head_rcu(&new->link, &nacl->lun_entry_hlist);
+		mutex_unlock(&nacl->lun_entry_mutex);
 
-		spin_unlock_irq(&nacl->device_list_lock);
-		return 0;
-	}
+		spin_lock_bh(&port->sep_alua_lock);
+		list_del(&orig->alua_port_list);
+		list_add_tail(&new->alua_port_list, &port->sep_alua_list);
+		spin_unlock_bh(&port->sep_alua_lock);
 
-	deve->se_lun = lun;
-	deve->se_lun_acl = lun_acl;
-	deve->mapped_lun = mapped_lun;
-	deve->lun_flags |= TRANSPORT_LUNFLAGS_INITIATOR_ACCESS;
+		kref_put(&orig->pr_kref, target_pr_kref_release);
+		wait_for_completion(&orig->pr_comp);
 
-	if (lun_access & TRANSPORT_LUNFLAGS_READ_WRITE) {
-		deve->lun_flags &= ~TRANSPORT_LUNFLAGS_READ_ONLY;
-		deve->lun_flags |= TRANSPORT_LUNFLAGS_READ_WRITE;
-	} else {
-		deve->lun_flags &= ~TRANSPORT_LUNFLAGS_READ_WRITE;
-		deve->lun_flags |= TRANSPORT_LUNFLAGS_READ_ONLY;
+		kfree_rcu(orig, rcu_head);
+		return 0;
 	}
 
-	deve->creation_time = get_jiffies_64();
-	deve->attach_count++;
-	spin_unlock_irq(&nacl->device_list_lock);
+	rcu_assign_pointer(new->se_lun, lun);
+	rcu_assign_pointer(new->se_lun_acl, lun_acl);
+	hlist_add_head_rcu(&new->link, &nacl->lun_entry_hlist);
+	mutex_unlock(&nacl->lun_entry_mutex);
 
 	spin_lock_bh(&port->sep_alua_lock);
-	list_add_tail(&deve->alua_port_list, &port->sep_alua_list);
+	list_add_tail(&new->alua_port_list, &port->sep_alua_list);
 	spin_unlock_bh(&port->sep_alua_lock);
 
 	return 0;
 }
 
-/*      core_disable_device_list_for_node():
- *
- *
+/*
+ *	Called with se_node_acl->lun_entry_mutex held.
  */
-int core_disable_device_list_for_node(
+void core_disable_device_list_for_node(
 	struct se_lun *lun,
-	struct se_lun_acl *lun_acl,
-	u32 mapped_lun,
-	u32 lun_access,
+	struct se_dev_entry *orig,
 	struct se_node_acl *nacl,
 	struct se_portal_group *tpg)
 {
 	struct se_port *port = lun->lun_sep;
-	struct se_dev_entry *deve = nacl->device_list[mapped_lun];
-
 	/*
 	 * If the MappedLUN entry is being disabled, the entry in
 	 * port->sep_alua_list must be removed now before clearing the
@@ -398,29 +402,29 @@ int core_disable_device_list_for_node(
 	 * MappedLUN *deve will be released below..
 	 */
 	spin_lock_bh(&port->sep_alua_lock);
-	list_del(&deve->alua_port_list);
+	list_del(&orig->alua_port_list);
 	spin_unlock_bh(&port->sep_alua_lock);
 	/*
-	 * Wait for any in process SPEC_I_PT=1 or REGISTER_AND_MOVE
-	 * PR operation to complete.
+	 * Disable struct se_dev_entry LUN ACL mapping
 	 */
-	while (atomic_read(&deve->pr_ref_count) != 0)
-		cpu_relax();
-
-	spin_lock_irq(&nacl->device_list_lock);
+	core_scsi3_ua_release_all(orig);
+
+	hlist_del_rcu(&orig->link);
+	rcu_assign_pointer(orig->se_lun, NULL);
+	rcu_assign_pointer(orig->se_lun_acl, NULL);
+	orig->lun_flags = 0;
+	orig->creation_time = 0;
+	orig->attach_count--;
 	/*
-	 * Disable struct se_dev_entry LUN ACL mapping
+	 * Before firing off RCU callback, wait for any in process SPEC_I_PT=1
+	 * or REGISTER_AND_MOVE PR operation to complete.
 	 */
-	core_scsi3_ua_release_all(deve);
-	deve->se_lun = NULL;
-	deve->se_lun_acl = NULL;
-	deve->lun_flags = 0;
-	deve->creation_time = 0;
-	deve->attach_count--;
-	spin_unlock_irq(&nacl->device_list_lock);
+	kref_put(&orig->pr_kref, target_pr_kref_release);
+	wait_for_completion(&orig->pr_comp);
+
+	kfree_rcu(orig, rcu_head);
 
 	core_scsi3_free_pr_reg_from_nacl(lun->lun_se_dev, nacl);
-	return 0;
 }
 
 /*      core_clear_lun_from_tpg():
@@ -431,26 +435,21 @@ void core_clear_lun_from_tpg(struct se_lun *lun, struct se_portal_group *tpg)
 {
 	struct se_node_acl *nacl;
 	struct se_dev_entry *deve;
-	u32 i;
 
 	spin_lock_irq(&tpg->acl_node_lock);
 	list_for_each_entry(nacl, &tpg->acl_node_list, acl_list) {
 		spin_unlock_irq(&tpg->acl_node_lock);
 
-		spin_lock_irq(&nacl->device_list_lock);
-		for (i = 0; i < TRANSPORT_MAX_LUNS_PER_TPG; i++) {
-			deve = nacl->device_list[i];
-			if (lun != deve->se_lun)
-				continue;
-			spin_unlock_irq(&nacl->device_list_lock);
+		mutex_lock(&nacl->lun_entry_mutex);
+		hlist_for_each_entry_rcu(deve, &nacl->lun_entry_hlist, link) {
+			struct se_lun *tmp_lun = lockless_dereference(deve->se_lun);
 
-			core_disable_device_list_for_node(lun, NULL,
-				deve->mapped_lun, TRANSPORT_LUNFLAGS_NO_ACCESS,
-				nacl, tpg);
+			if (lun != tmp_lun)
+				continue;
 
-			spin_lock_irq(&nacl->device_list_lock);
+			core_disable_device_list_for_node(lun, deve, nacl, tpg);
 		}
-		spin_unlock_irq(&nacl->device_list_lock);
+		mutex_unlock(&nacl->lun_entry_mutex);
 
 		spin_lock_irq(&tpg->acl_node_lock);
 	}
@@ -582,7 +581,9 @@ int core_dev_export(
 	if (IS_ERR(port))
 		return PTR_ERR(port);
 
+	lun->lun_index = dev->dev_index;
 	lun->lun_se_dev = dev;
+	lun->lun_rtpi = port->sep_rtpi;
 
 	spin_lock(&hba->device_lock);
 	dev->export_count++;
@@ -1368,16 +1369,13 @@ int core_dev_add_initiator_node_lun_acl(
 	return 0;
 }
 
-/*      core_dev_del_initiator_node_lun_acl():
- *
- *
- */
 int core_dev_del_initiator_node_lun_acl(
 	struct se_portal_group *tpg,
 	struct se_lun *lun,
 	struct se_lun_acl *lacl)
 {
 	struct se_node_acl *nacl;
+	struct se_dev_entry *deve;
 
 	nacl = lacl->se_lun_nacl;
 	if (!nacl)
@@ -1388,8 +1386,11 @@ int core_dev_del_initiator_node_lun_acl(
 	atomic_dec_mb(&lun->lun_acl_count);
 	spin_unlock(&lun->lun_acl_lock);
 
-	core_disable_device_list_for_node(lun, NULL, lacl->mapped_lun,
-		TRANSPORT_LUNFLAGS_NO_ACCESS, nacl, tpg);
+	mutex_lock(&nacl->lun_entry_mutex);
+	deve = target_nacl_find_deve(nacl, lacl->mapped_lun);
+	if (deve)
+		core_disable_device_list_for_node(lun, deve, nacl, tpg);
+	mutex_unlock(&nacl->lun_entry_mutex);
 
 	lacl->se_lun = NULL;
 
diff --git a/drivers/target/target_core_fabric_configfs.c b/drivers/target/target_core_fabric_configfs.c
index 6cb4828..0939a54 100644
--- a/drivers/target/target_core_fabric_configfs.c
+++ b/drivers/target/target_core_fabric_configfs.c
@@ -123,16 +123,16 @@ static int target_fabric_mappedlun_link(
 	 * which be will write protected (READ-ONLY) when
 	 * tpg_1/attrib/demo_mode_write_protect=1
 	 */
-	spin_lock_irq(&lacl->se_lun_nacl->device_list_lock);
-	deve = lacl->se_lun_nacl->device_list[lacl->mapped_lun];
-	if (deve->lun_flags & TRANSPORT_LUNFLAGS_INITIATOR_ACCESS)
+	rcu_read_lock();
+	deve = target_nacl_find_deve(lacl->se_lun_nacl, lacl->mapped_lun);
+	if (deve)
 		lun_access = deve->lun_flags;
 	else
 		lun_access =
 			(se_tpg->se_tpg_tfo->tpg_check_prod_mode_write_protect(
 				se_tpg)) ? TRANSPORT_LUNFLAGS_READ_ONLY :
 					   TRANSPORT_LUNFLAGS_READ_WRITE;
-	spin_unlock_irq(&lacl->se_lun_nacl->device_list_lock);
+	rcu_read_unlock();
 	/*
 	 * Determine the actual mapped LUN value user wants..
 	 *
@@ -149,23 +149,13 @@ static int target_fabric_mappedlun_unlink(
 	struct config_item *lun_acl_ci,
 	struct config_item *lun_ci)
 {
-	struct se_lun *lun;
 	struct se_lun_acl *lacl = container_of(to_config_group(lun_acl_ci),
 			struct se_lun_acl, se_lun_group);
-	struct se_node_acl *nacl = lacl->se_lun_nacl;
-	struct se_dev_entry *deve = nacl->device_list[lacl->mapped_lun];
-	struct se_portal_group *se_tpg;
-	/*
-	 * Determine if the underlying MappedLUN has already been released..
-	 */
-	if (!deve->se_lun)
-		return 0;
-
-	lun = container_of(to_config_group(lun_ci), struct se_lun, lun_group);
-	se_tpg = lun->lun_sep->sep_tpg;
+	struct se_lun *lun = container_of(to_config_group(lun_ci),
+			struct se_lun, lun_group);
+	struct se_portal_group *se_tpg = lun->lun_sep->sep_tpg;
 
-	core_dev_del_initiator_node_lun_acl(se_tpg, lun, lacl);
-	return 0;
+	return core_dev_del_initiator_node_lun_acl(se_tpg, lun, lacl);
 }
 
 CONFIGFS_EATTR_STRUCT(target_fabric_mappedlun, se_lun_acl);
@@ -181,14 +171,15 @@ static ssize_t target_fabric_mappedlun_show_write_protect(
 {
 	struct se_node_acl *se_nacl = lacl->se_lun_nacl;
 	struct se_dev_entry *deve;
-	ssize_t len;
-
-	spin_lock_irq(&se_nacl->device_list_lock);
-	deve = se_nacl->device_list[lacl->mapped_lun];
-	len = sprintf(page, "%d\n",
-			(deve->lun_flags & TRANSPORT_LUNFLAGS_READ_ONLY) ?
-			1 : 0);
-	spin_unlock_irq(&se_nacl->device_list_lock);
+	ssize_t len = 0;
+
+	rcu_read_lock();
+	deve = target_nacl_find_deve(se_nacl, lacl->mapped_lun);
+	if (deve) {
+		len = sprintf(page, "%d\n",
+			(deve->lun_flags & TRANSPORT_LUNFLAGS_READ_ONLY) ? 1 : 0);
+	}
+	rcu_read_unlock();
 
 	return len;
 }
diff --git a/drivers/target/target_core_internal.h b/drivers/target/target_core_internal.h
index d0344ad..a04a6e3 100644
--- a/drivers/target/target_core_internal.h
+++ b/drivers/target/target_core_internal.h
@@ -9,13 +9,15 @@ extern struct mutex g_device_mutex;
 extern struct list_head g_device_list;
 
 struct se_dev_entry *core_get_se_deve_from_rtpi(struct se_node_acl *, u16);
-int	core_free_device_list_for_node(struct se_node_acl *,
+void	target_pr_kref_release(struct kref *);
+void	core_free_device_list_for_node(struct se_node_acl *,
 		struct se_portal_group *);
 void	core_update_device_list_access(u32, u32, struct se_node_acl *);
+struct se_dev_entry *target_nacl_find_deve(struct se_node_acl *, u32);
 int	core_enable_device_list_for_node(struct se_lun *, struct se_lun_acl *,
 		u32, u32, struct se_node_acl *, struct se_portal_group *);
-int	core_disable_device_list_for_node(struct se_lun *, struct se_lun_acl *,
-		u32, u32, struct se_node_acl *, struct se_portal_group *);
+void	core_disable_device_list_for_node(struct se_lun *, struct se_dev_entry *,
+		struct se_node_acl *, struct se_portal_group *);
 void	core_clear_lun_from_tpg(struct se_lun *, struct se_portal_group *);
 int	core_dev_export(struct se_device *, struct se_portal_group *,
 		struct se_lun *);
diff --git a/drivers/target/target_core_pr.c b/drivers/target/target_core_pr.c
index 8052d40..f25d877 100644
--- a/drivers/target/target_core_pr.c
+++ b/drivers/target/target_core_pr.c
@@ -48,7 +48,7 @@ struct pr_transport_id_holder {
 	struct t10_pr_registration *dest_pr_reg;
 	struct se_portal_group *dest_tpg;
 	struct se_node_acl *dest_node_acl;
-	struct se_dev_entry *dest_se_deve;
+	struct se_dev_entry __rcu *dest_se_deve;
 	struct list_head dest_list;
 };
 
@@ -232,7 +232,7 @@ target_scsi2_reservation_release(struct se_cmd *cmd)
 	tpg = sess->se_tpg;
 	pr_debug("SCSI-2 Released reservation for %s LUN: %u ->"
 		" MAPPED LUN: %u for %s\n", tpg->se_tpg_tfo->get_fabric_name(),
-		cmd->se_lun->unpacked_lun, cmd->se_deve->mapped_lun,
+		cmd->se_lun->unpacked_lun, cmd->orig_fe_lun,
 		sess->se_node_acl->initiatorname);
 
 out_unlock:
@@ -281,7 +281,7 @@ target_scsi2_reservation_reserve(struct se_cmd *cmd)
 			dev->dev_reserved_node_acl->initiatorname);
 		pr_err("Current attempt - LUN: %u -> MAPPED LUN: %u"
 			" from %s \n", cmd->se_lun->unpacked_lun,
-			cmd->se_deve->mapped_lun,
+			cmd->orig_fe_lun,
 			sess->se_node_acl->initiatorname);
 		ret = TCM_RESERVATION_CONFLICT;
 		goto out_unlock;
@@ -295,7 +295,7 @@ target_scsi2_reservation_reserve(struct se_cmd *cmd)
 	}
 	pr_debug("SCSI-2 Reserved %s LUN: %u -> MAPPED LUN: %u"
 		" for %s\n", tpg->se_tpg_tfo->get_fabric_name(),
-		cmd->se_lun->unpacked_lun, cmd->se_deve->mapped_lun,
+		cmd->se_lun->unpacked_lun, cmd->orig_fe_lun,
 		sess->se_node_acl->initiatorname);
 
 out_unlock:
@@ -320,6 +320,7 @@ static int core_scsi3_pr_seq_non_holder(
 	unsigned char *cdb = cmd->t_task_cdb;
 	struct se_dev_entry *se_deve;
 	struct se_session *se_sess = cmd->se_sess;
+	struct se_node_acl *nacl = se_sess->se_node_acl;
 	int other_cdb = 0, ignore_reg;
 	int registered_nexus = 0, ret = 1; /* Conflict by default */
 	int all_reg = 0, reg_only = 0; /* ALL_REG, REG_ONLY */
@@ -327,7 +328,8 @@ static int core_scsi3_pr_seq_non_holder(
 	int legacy = 0; /* Act like a legacy device and return
 			 * RESERVATION CONFLICT on some CDBs */
 
-	se_deve = se_sess->se_node_acl->device_list[cmd->orig_fe_lun];
+	rcu_read_lock();
+	se_deve = target_nacl_find_deve(nacl, cmd->orig_fe_lun);
 	/*
 	 * Determine if the registration should be ignored due to
 	 * non-matching ISIDs in target_scsi3_pr_reservation_check().
@@ -368,8 +370,10 @@ static int core_scsi3_pr_seq_non_holder(
 			registered_nexus = 1;
 		break;
 	default:
+		rcu_read_unlock();
 		return -EINVAL;
 	}
+	rcu_read_unlock();
 	/*
 	 * Referenced from spc4r17 table 45 for *NON* PR holder access
 	 */
@@ -735,7 +739,7 @@ static struct t10_pr_registration *__core_scsi3_alloc_registration(
 			if (strcmp(nacl->initiatorname, nacl_tmp->initiatorname))
 				continue;
 
-			atomic_inc_mb(&deve_tmp->pr_ref_count);
+			kref_get(&deve_tmp->pr_kref);
 			spin_unlock_bh(&port->sep_alua_lock);
 			/*
 			 * Grab a configfs group dependency that is released
@@ -748,7 +752,7 @@ static struct t10_pr_registration *__core_scsi3_alloc_registration(
 				pr_err("core_scsi3_lunacl_depend"
 						"_item() failed\n");
 				atomic_dec_mb(&port->sep_tg_pt_ref_cnt);
-				atomic_dec_mb(&deve_tmp->pr_ref_count);
+				kref_put(&deve_tmp->pr_kref, target_pr_kref_release);
 				goto out;
 			}
 			/*
@@ -763,7 +767,6 @@ static struct t10_pr_registration *__core_scsi3_alloc_registration(
 						sa_res_key, all_tg_pt, aptpl);
 			if (!pr_reg_atp) {
 				atomic_dec_mb(&port->sep_tg_pt_ref_cnt);
-				atomic_dec_mb(&deve_tmp->pr_ref_count);
 				core_scsi3_lunacl_undepend_item(deve_tmp);
 				goto out;
 			}
@@ -896,7 +899,7 @@ static int __core_scsi3_check_aptpl_registration(
 	struct se_lun *lun,
 	u32 target_lun,
 	struct se_node_acl *nacl,
-	struct se_dev_entry *deve)
+	u32 mapped_lun)
 {
 	struct t10_pr_registration *pr_reg, *pr_reg_tmp;
 	struct t10_reservation *pr_tmpl = &dev->t10_pr;
@@ -924,13 +927,12 @@ static int __core_scsi3_check_aptpl_registration(
 				pr_reg_aptpl_list) {
 
 		if (!strcmp(pr_reg->pr_iport, i_port) &&
-		     (pr_reg->pr_res_mapped_lun == deve->mapped_lun) &&
+		     (pr_reg->pr_res_mapped_lun == mapped_lun) &&
 		    !(strcmp(pr_reg->pr_tport, t_port)) &&
 		     (pr_reg->pr_reg_tpgt == tpgt) &&
 		     (pr_reg->pr_aptpl_target_lun == target_lun)) {
 
 			pr_reg->pr_reg_nacl = nacl;
-			pr_reg->pr_reg_deve = deve;
 			pr_reg->pr_reg_tg_pt_lun = lun;
 
 			list_del(&pr_reg->pr_reg_aptpl_list);
@@ -968,13 +970,12 @@ int core_scsi3_check_aptpl_registration(
 	struct se_node_acl *nacl,
 	u32 mapped_lun)
 {
-	struct se_dev_entry *deve = nacl->device_list[mapped_lun];
-
 	if (dev->dev_reservation_flags & DRF_SPC2_RESERVATIONS)
 		return 0;
 
 	return __core_scsi3_check_aptpl_registration(dev, tpg, lun,
-				lun->unpacked_lun, nacl, deve);
+						     lun->unpacked_lun, nacl,
+						     mapped_lun);
 }
 
 static void __core_scsi3_dump_registration(
@@ -1408,27 +1409,29 @@ static int core_scsi3_lunacl_depend_item(struct se_dev_entry *se_deve)
 
 static void core_scsi3_lunacl_undepend_item(struct se_dev_entry *se_deve)
 {
-	struct se_lun_acl *lun_acl = se_deve->se_lun_acl;
+	struct se_lun_acl *lun_acl;
 	struct se_node_acl *nacl;
 	struct se_portal_group *tpg;
 	/*
 	 * For nacl->dynamic_node_acl=1
 	 */
+	lun_acl = se_deve->se_lun_acl;
 	if (!lun_acl) {
-		atomic_dec_mb(&se_deve->pr_ref_count);
+		kref_put(&se_deve->pr_kref, target_pr_kref_release);
 		return;
 	}
 	nacl = lun_acl->se_lun_nacl;
 	tpg = nacl->se_tpg;
 
 	target_undepend_item(&lun_acl->se_lun_group.cg_item);
-	atomic_dec_mb(&se_deve->pr_ref_count);
+	kref_put(&se_deve->pr_kref, target_pr_kref_release);
 }
 
 static sense_reason_t
 core_scsi3_decode_spec_i_port(
 	struct se_cmd *cmd,
 	struct se_portal_group *tpg,
+	struct se_dev_entry *local_se_deve,
 	unsigned char *l_isid,
 	u64 sa_res_key,
 	int all_tg_pt,
@@ -1439,7 +1442,7 @@ core_scsi3_decode_spec_i_port(
 	struct se_portal_group *dest_tpg = NULL, *tmp_tpg;
 	struct se_session *se_sess = cmd->se_sess;
 	struct se_node_acl *dest_node_acl = NULL;
-	struct se_dev_entry *dest_se_deve = NULL, *local_se_deve;
+	struct se_dev_entry __rcu *dest_se_deve = NULL;
 	struct t10_pr_registration *dest_pr_reg, *local_pr_reg, *pr_reg_e;
 	struct t10_pr_registration *pr_reg_tmp, *pr_reg_tmp_safe;
 	LIST_HEAD(tid_dest_list);
@@ -1452,7 +1455,6 @@ core_scsi3_decode_spec_i_port(
 	int dest_local_nexus;
 	u32 dest_rtpi = 0;
 
-	local_se_deve = se_sess->se_node_acl->device_list[cmd->orig_fe_lun];
 	/*
 	 * Allocate a struct pr_transport_id_holder and setup the
 	 * local_node_acl and local_se_deve pointers and add to
@@ -1467,7 +1469,6 @@ core_scsi3_decode_spec_i_port(
 	INIT_LIST_HEAD(&tidh_new->dest_list);
 	tidh_new->dest_tpg = tpg;
 	tidh_new->dest_node_acl = se_sess->se_node_acl;
-	tidh_new->dest_se_deve = local_se_deve;
 
 	local_pr_reg = __core_scsi3_alloc_registration(cmd->se_dev,
 				se_sess->se_node_acl, local_se_deve, l_isid,
@@ -1476,6 +1477,7 @@ core_scsi3_decode_spec_i_port(
 		kfree(tidh_new);
 		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
 	}
+	rcu_assign_pointer(tidh_new->dest_se_deve, local_se_deve);
 	tidh_new->dest_pr_reg = local_pr_reg;
 	/*
 	 * The local I_T nexus does not hold any configfs dependances,
@@ -1635,7 +1637,7 @@ core_scsi3_decode_spec_i_port(
 		if (core_scsi3_lunacl_depend_item(dest_se_deve)) {
 			pr_err("core_scsi3_lunacl_depend_item()"
 					" failed\n");
-			atomic_dec_mb(&dest_se_deve->pr_ref_count);
+			kref_put(&dest_se_deve->pr_kref, target_pr_kref_release);
 			core_scsi3_nodeacl_undepend_item(dest_node_acl);
 			core_scsi3_tpg_undepend_item(dest_tpg);
 			ret = TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
@@ -1990,6 +1992,7 @@ core_scsi3_emulate_pro_register(struct se_cmd *cmd, u64 res_key, u64 sa_res_key,
 		bool aptpl, bool all_tg_pt, bool spec_i_pt, enum register_type register_type)
 {
 	struct se_session *se_sess = cmd->se_sess;
+	struct se_node_acl *nacl = se_sess->se_node_acl;
 	struct se_device *dev = cmd->se_dev;
 	struct se_dev_entry *se_deve;
 	struct se_lun *se_lun = cmd->se_lun;
@@ -2005,7 +2008,14 @@ core_scsi3_emulate_pro_register(struct se_cmd *cmd, u64 res_key, u64 sa_res_key,
 		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
 	}
 	se_tpg = se_sess->se_tpg;
-	se_deve = se_sess->se_node_acl->device_list[cmd->orig_fe_lun];
+
+	rcu_read_lock();
+	se_deve = target_nacl_find_deve(nacl, cmd->orig_fe_lun);
+	if (!se_deve) {
+		pr_err("Unable to locate se_deve for PRO-REGISTER\n");
+		rcu_read_unlock();
+		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
+	}
 
 	if (se_tpg->se_tpg_tfo->sess_get_initiator_sid) {
 		memset(&isid_buf[0], 0, PR_REG_ISID_LEN);
@@ -2021,14 +2031,16 @@ core_scsi3_emulate_pro_register(struct se_cmd *cmd, u64 res_key, u64 sa_res_key,
 		if (res_key) {
 			pr_warn("SPC-3 PR: Reservation Key non-zero"
 				" for SA REGISTER, returning CONFLICT\n");
+			rcu_read_unlock();
 			return TCM_RESERVATION_CONFLICT;
 		}
 		/*
 		 * Do nothing but return GOOD status.
 		 */
-		if (!sa_res_key)
+		if (!sa_res_key) {
+			rcu_read_unlock();
 			return 0;
-
+		}
 		if (!spec_i_pt) {
 			/*
 			 * Perform the Service Action REGISTER on the Initiator
@@ -2041,6 +2053,7 @@ core_scsi3_emulate_pro_register(struct se_cmd *cmd, u64 res_key, u64 sa_res_key,
 					register_type, 0)) {
 				pr_err("Unable to allocate"
 					" struct t10_pr_registration\n");
+				rcu_read_unlock();
 				return TCM_INVALID_PARAMETER_LIST;
 			}
 		} else {
@@ -2052,14 +2065,17 @@ core_scsi3_emulate_pro_register(struct se_cmd *cmd, u64 res_key, u64 sa_res_key,
 			 * logic from of core_scsi3_alloc_registration() for
 			 * each TransportID provided SCSI Initiator Port/Device
 			 */
-			ret = core_scsi3_decode_spec_i_port(cmd, se_tpg,
+			ret = core_scsi3_decode_spec_i_port(cmd, se_tpg, se_deve,
 					isid_ptr, sa_res_key, all_tg_pt, aptpl);
-			if (ret != 0)
+			if (ret != 0) {
+				rcu_read_unlock();
 				return ret;
+			}
 		}
-
+		rcu_read_unlock();
 		return core_scsi3_update_and_write_aptpl(dev, aptpl);
 	}
+	rcu_read_unlock();
 
 	/* ok, existing registration */
 
@@ -3321,7 +3337,7 @@ after_iport_check:
 
 	if (core_scsi3_lunacl_depend_item(dest_se_deve)) {
 		pr_err("core_scsi3_lunacl_depend_item() failed\n");
-		atomic_dec_mb(&dest_se_deve->pr_ref_count);
+		kref_put(&dest_se_deve->pr_kref, target_pr_kref_release);
 		dest_se_deve = NULL;
 		ret = TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
 		goto out;
diff --git a/drivers/target/target_core_pscsi.c b/drivers/target/target_core_pscsi.c
index f6c954c..7579357 100644
--- a/drivers/target/target_core_pscsi.c
+++ b/drivers/target/target_core_pscsi.c
@@ -47,6 +47,7 @@
 #include <target/target_core_backend_configfs.h>
 
 #include "target_core_alua.h"
+#include "target_core_internal.h"
 #include "target_core_pscsi.h"
 
 #define ISPRINT(a)  ((a >= ' ') && (a <= '~'))
@@ -634,12 +635,14 @@ static void pscsi_transport_complete(struct se_cmd *cmd, struct scatterlist *sg,
 	 * Hack to make sure that Write-Protect modepage is set if R/O mode is
 	 * forced.
 	 */
-	if (!cmd->se_deve || !cmd->data_length)
+	if (!cmd->data_length)
 		goto after_mode_sense;
 
 	if (((cdb[0] == MODE_SENSE) || (cdb[0] == MODE_SENSE_10)) &&
 	     (status_byte(result) << 1) == SAM_STAT_GOOD) {
-		if (cmd->se_deve->lun_flags & TRANSPORT_LUNFLAGS_READ_ONLY) {
+		bool read_only = target_lun_is_rdonly(cmd);
+
+		if (read_only) {
 			unsigned char *buf;
 
 			buf = transport_kmap_data_sg(cmd);
diff --git a/drivers/target/target_core_spc.c b/drivers/target/target_core_spc.c
index 78c0b40..9f995b8 100644
--- a/drivers/target/target_core_spc.c
+++ b/drivers/target/target_core_spc.c
@@ -981,6 +981,7 @@ static sense_reason_t spc_emulate_modesense(struct se_cmd *cmd)
 	int length = 0;
 	int ret;
 	int i;
+	bool read_only = target_lun_is_rdonly(cmd);;
 
 	memset(buf, 0, SE_MODE_PAGE_BUF);
 
@@ -991,9 +992,7 @@ static sense_reason_t spc_emulate_modesense(struct se_cmd *cmd)
 	length = ten ? 3 : 2;
 
 	/* DEVICE-SPECIFIC PARAMETER */
-	if ((cmd->se_lun->lun_access & TRANSPORT_LUNFLAGS_READ_ONLY) ||
-	    (cmd->se_deve &&
-	     (cmd->se_deve->lun_flags & TRANSPORT_LUNFLAGS_READ_ONLY)))
+	if ((cmd->se_lun->lun_access & TRANSPORT_LUNFLAGS_READ_ONLY) || read_only)
 		spc_modesense_write_protect(&buf[length], type);
 
 	/*
@@ -1211,8 +1210,9 @@ sense_reason_t spc_emulate_report_luns(struct se_cmd *cmd)
 {
 	struct se_dev_entry *deve;
 	struct se_session *sess = cmd->se_sess;
+	struct se_node_acl *nacl;
 	unsigned char *buf;
-	u32 lun_count = 0, offset = 8, i;
+	u32 lun_count = 0, offset = 8;
 
 	if (cmd->data_length < 16) {
 		pr_warn("REPORT LUNS allocation length %u too small\n",
@@ -1234,12 +1234,10 @@ sense_reason_t spc_emulate_report_luns(struct se_cmd *cmd)
 		lun_count = 1;
 		goto done;
 	}
+	nacl = sess->se_node_acl;
 
-	spin_lock_irq(&sess->se_node_acl->device_list_lock);
-	for (i = 0; i < TRANSPORT_MAX_LUNS_PER_TPG; i++) {
-		deve = sess->se_node_acl->device_list[i];
-		if (!(deve->lun_flags & TRANSPORT_LUNFLAGS_INITIATOR_ACCESS))
-			continue;
+	rcu_read_lock();
+	hlist_for_each_entry_rcu(deve, &nacl->lun_entry_hlist, link) {
 		/*
 		 * We determine the correct LUN LIST LENGTH even once we
 		 * have reached the initial allocation length.
@@ -1252,7 +1250,7 @@ sense_reason_t spc_emulate_report_luns(struct se_cmd *cmd)
 		int_to_scsilun(deve->mapped_lun, (struct scsi_lun *)&buf[offset]);
 		offset += 8;
 	}
-	spin_unlock_irq(&sess->se_node_acl->device_list_lock);
+	rcu_read_unlock();
 
 	/*
 	 * See SPC3 r07, page 159.
diff --git a/drivers/target/target_core_stat.c b/drivers/target/target_core_stat.c
index 64efee2..ea12879 100644
--- a/drivers/target/target_core_stat.c
+++ b/drivers/target/target_core_stat.c
@@ -1084,17 +1084,17 @@ static ssize_t target_stat_scsi_auth_intr_show_attr_inst(
 	struct se_portal_group *tpg;
 	ssize_t ret;
 
-	spin_lock_irq(&nacl->device_list_lock);
-	deve = nacl->device_list[lacl->mapped_lun];
-	if (!deve->se_lun || !deve->se_lun_acl) {
-		spin_unlock_irq(&nacl->device_list_lock);
+	rcu_read_lock();
+	deve = target_nacl_find_deve(nacl, lacl->mapped_lun);
+	if (!deve) {
+		rcu_read_unlock();
 		return -ENODEV;
 	}
 	tpg = nacl->se_tpg;
 	/* scsiInstIndex */
 	ret = snprintf(page, PAGE_SIZE, "%u\n",
 			tpg->se_tpg_tfo->tpg_get_inst_index(tpg));
-	spin_unlock_irq(&nacl->device_list_lock);
+	rcu_read_unlock();
 	return ret;
 }
 DEV_STAT_SCSI_AUTH_INTR_ATTR_RO(inst);
@@ -1109,16 +1109,16 @@ static ssize_t target_stat_scsi_auth_intr_show_attr_dev(
 	struct se_lun *lun;
 	ssize_t ret;
 
-	spin_lock_irq(&nacl->device_list_lock);
-	deve = nacl->device_list[lacl->mapped_lun];
-	if (!deve->se_lun || !deve->se_lun_acl) {
-		spin_unlock_irq(&nacl->device_list_lock);
+	rcu_read_lock();
+	deve = target_nacl_find_deve(nacl, lacl->mapped_lun);
+	if (!deve) {
+		rcu_read_unlock();
 		return -ENODEV;
 	}
-	lun = deve->se_lun;
+	lun = rcu_dereference(deve->se_lun);
 	/* scsiDeviceIndex */
-	ret = snprintf(page, PAGE_SIZE, "%u\n", lun->lun_se_dev->dev_index);
-	spin_unlock_irq(&nacl->device_list_lock);
+	ret = snprintf(page, PAGE_SIZE, "%u\n", lun->lun_index);
+	rcu_read_unlock();
 	return ret;
 }
 DEV_STAT_SCSI_AUTH_INTR_ATTR_RO(dev);
@@ -1133,16 +1133,16 @@ static ssize_t target_stat_scsi_auth_intr_show_attr_port(
 	struct se_portal_group *tpg;
 	ssize_t ret;
 
-	spin_lock_irq(&nacl->device_list_lock);
-	deve = nacl->device_list[lacl->mapped_lun];
-	if (!deve->se_lun || !deve->se_lun_acl) {
-		spin_unlock_irq(&nacl->device_list_lock);
+	rcu_read_lock();
+	deve = target_nacl_find_deve(nacl, lacl->mapped_lun);
+	if (!deve) {
+		rcu_read_unlock();
 		return -ENODEV;
 	}
 	tpg = nacl->se_tpg;
 	/* scsiAuthIntrTgtPortIndex */
 	ret = snprintf(page, PAGE_SIZE, "%u\n", tpg->se_tpg_tfo->tpg_get_tag(tpg));
-	spin_unlock_irq(&nacl->device_list_lock);
+	rcu_read_unlock();
 	return ret;
 }
 DEV_STAT_SCSI_AUTH_INTR_ATTR_RO(port);
@@ -1156,15 +1156,15 @@ static ssize_t target_stat_scsi_auth_intr_show_attr_indx(
 	struct se_dev_entry *deve;
 	ssize_t ret;
 
-	spin_lock_irq(&nacl->device_list_lock);
-	deve = nacl->device_list[lacl->mapped_lun];
-	if (!deve->se_lun || !deve->se_lun_acl) {
-		spin_unlock_irq(&nacl->device_list_lock);
+	rcu_read_lock();
+	deve = target_nacl_find_deve(nacl, lacl->mapped_lun);
+	if (!deve) {
+		rcu_read_unlock();
 		return -ENODEV;
 	}
 	/* scsiAuthIntrIndex */
 	ret = snprintf(page, PAGE_SIZE, "%u\n", nacl->acl_index);
-	spin_unlock_irq(&nacl->device_list_lock);
+	rcu_read_unlock();
 	return ret;
 }
 DEV_STAT_SCSI_AUTH_INTR_ATTR_RO(indx);
@@ -1178,15 +1178,15 @@ static ssize_t target_stat_scsi_auth_intr_show_attr_dev_or_port(
 	struct se_dev_entry *deve;
 	ssize_t ret;
 
-	spin_lock_irq(&nacl->device_list_lock);
-	deve = nacl->device_list[lacl->mapped_lun];
-	if (!deve->se_lun || !deve->se_lun_acl) {
-		spin_unlock_irq(&nacl->device_list_lock);
+	rcu_read_lock();
+	deve = target_nacl_find_deve(nacl, lacl->mapped_lun);
+	if (!deve) {
+		rcu_read_unlock();
 		return -ENODEV;
 	}
 	/* scsiAuthIntrDevOrPort */
 	ret = snprintf(page, PAGE_SIZE, "%u\n", 1);
-	spin_unlock_irq(&nacl->device_list_lock);
+	rcu_read_unlock();
 	return ret;
 }
 DEV_STAT_SCSI_AUTH_INTR_ATTR_RO(dev_or_port);
@@ -1200,15 +1200,15 @@ static ssize_t target_stat_scsi_auth_intr_show_attr_intr_name(
 	struct se_dev_entry *deve;
 	ssize_t ret;
 
-	spin_lock_irq(&nacl->device_list_lock);
-	deve = nacl->device_list[lacl->mapped_lun];
-	if (!deve->se_lun || !deve->se_lun_acl) {
-		spin_unlock_irq(&nacl->device_list_lock);
+	rcu_read_lock();
+	deve = target_nacl_find_deve(nacl, lacl->mapped_lun);
+	if (!deve) {
+		rcu_read_unlock();
 		return -ENODEV;
 	}
 	/* scsiAuthIntrName */
 	ret = snprintf(page, PAGE_SIZE, "%s\n", nacl->initiatorname);
-	spin_unlock_irq(&nacl->device_list_lock);
+	rcu_read_unlock();
 	return ret;
 }
 DEV_STAT_SCSI_AUTH_INTR_ATTR_RO(intr_name);
@@ -1222,15 +1222,15 @@ static ssize_t target_stat_scsi_auth_intr_show_attr_map_indx(
 	struct se_dev_entry *deve;
 	ssize_t ret;
 
-	spin_lock_irq(&nacl->device_list_lock);
-	deve = nacl->device_list[lacl->mapped_lun];
-	if (!deve->se_lun || !deve->se_lun_acl) {
-		spin_unlock_irq(&nacl->device_list_lock);
+	rcu_read_lock();
+	deve = target_nacl_find_deve(nacl, lacl->mapped_lun);
+	if (!deve) {
+		rcu_read_unlock();
 		return -ENODEV;
 	}
 	/* FIXME: scsiAuthIntrLunMapIndex */
 	ret = snprintf(page, PAGE_SIZE, "%u\n", 0);
-	spin_unlock_irq(&nacl->device_list_lock);
+	rcu_read_unlock();
 	return ret;
 }
 DEV_STAT_SCSI_AUTH_INTR_ATTR_RO(map_indx);
@@ -1244,15 +1244,15 @@ static ssize_t target_stat_scsi_auth_intr_show_attr_att_count(
 	struct se_dev_entry *deve;
 	ssize_t ret;
 
-	spin_lock_irq(&nacl->device_list_lock);
-	deve = nacl->device_list[lacl->mapped_lun];
-	if (!deve->se_lun || !deve->se_lun_acl) {
-		spin_unlock_irq(&nacl->device_list_lock);
+	rcu_read_lock();
+	deve = target_nacl_find_deve(nacl, lacl->mapped_lun);
+	if (!deve) {
+		rcu_read_unlock();
 		return -ENODEV;
 	}
 	/* scsiAuthIntrAttachedTimes */
 	ret = snprintf(page, PAGE_SIZE, "%u\n", deve->attach_count);
-	spin_unlock_irq(&nacl->device_list_lock);
+	rcu_read_unlock();
 	return ret;
 }
 DEV_STAT_SCSI_AUTH_INTR_ATTR_RO(att_count);
@@ -1266,15 +1266,16 @@ static ssize_t target_stat_scsi_auth_intr_show_attr_num_cmds(
 	struct se_dev_entry *deve;
 	ssize_t ret;
 
-	spin_lock_irq(&nacl->device_list_lock);
-	deve = nacl->device_list[lacl->mapped_lun];
-	if (!deve->se_lun || !deve->se_lun_acl) {
-		spin_unlock_irq(&nacl->device_list_lock);
+	rcu_read_lock();
+	deve = target_nacl_find_deve(nacl, lacl->mapped_lun);
+	if (!deve) {
+		rcu_read_unlock();
 		return -ENODEV;
 	}
 	/* scsiAuthIntrOutCommands */
-	ret = snprintf(page, PAGE_SIZE, "%u\n", deve->total_cmds);
-	spin_unlock_irq(&nacl->device_list_lock);
+	ret = snprintf(page, PAGE_SIZE, "%lu\n",
+		       atomic_long_read(&deve->total_cmds));
+	rcu_read_unlock();
 	return ret;
 }
 DEV_STAT_SCSI_AUTH_INTR_ATTR_RO(num_cmds);
@@ -1288,15 +1289,16 @@ static ssize_t target_stat_scsi_auth_intr_show_attr_read_mbytes(
 	struct se_dev_entry *deve;
 	ssize_t ret;
 
-	spin_lock_irq(&nacl->device_list_lock);
-	deve = nacl->device_list[lacl->mapped_lun];
-	if (!deve->se_lun || !deve->se_lun_acl) {
-		spin_unlock_irq(&nacl->device_list_lock);
+	rcu_read_lock();
+	deve = target_nacl_find_deve(nacl, lacl->mapped_lun);
+	if (!deve) {
+		rcu_read_unlock();
 		return -ENODEV;
 	}
 	/* scsiAuthIntrReadMegaBytes */
-	ret = snprintf(page, PAGE_SIZE, "%u\n", (u32)(deve->read_bytes >> 20));
-	spin_unlock_irq(&nacl->device_list_lock);
+	ret = snprintf(page, PAGE_SIZE, "%u\n",
+		      (u32)(atomic_long_read(&deve->read_bytes) >> 20));
+	rcu_read_unlock();
 	return ret;
 }
 DEV_STAT_SCSI_AUTH_INTR_ATTR_RO(read_mbytes);
@@ -1310,15 +1312,16 @@ static ssize_t target_stat_scsi_auth_intr_show_attr_write_mbytes(
 	struct se_dev_entry *deve;
 	ssize_t ret;
 
-	spin_lock_irq(&nacl->device_list_lock);
-	deve = nacl->device_list[lacl->mapped_lun];
-	if (!deve->se_lun || !deve->se_lun_acl) {
-		spin_unlock_irq(&nacl->device_list_lock);
+	rcu_read_lock();
+	deve = target_nacl_find_deve(nacl, lacl->mapped_lun);
+	if (!deve) {
+		rcu_read_unlock();
 		return -ENODEV;
 	}
 	/* scsiAuthIntrWrittenMegaBytes */
-	ret = snprintf(page, PAGE_SIZE, "%u\n", (u32)(deve->write_bytes >> 20));
-	spin_unlock_irq(&nacl->device_list_lock);
+	ret = snprintf(page, PAGE_SIZE, "%u\n",
+		      (u32)(atomic_long_read(&deve->write_bytes) >> 20));
+	rcu_read_unlock();
 	return ret;
 }
 DEV_STAT_SCSI_AUTH_INTR_ATTR_RO(write_mbytes);
@@ -1332,15 +1335,15 @@ static ssize_t target_stat_scsi_auth_intr_show_attr_hs_num_cmds(
 	struct se_dev_entry *deve;
 	ssize_t ret;
 
-	spin_lock_irq(&nacl->device_list_lock);
-	deve = nacl->device_list[lacl->mapped_lun];
-	if (!deve->se_lun || !deve->se_lun_acl) {
-		spin_unlock_irq(&nacl->device_list_lock);
+	rcu_read_lock();
+	deve = target_nacl_find_deve(nacl, lacl->mapped_lun);
+	if (!deve) {
+		rcu_read_unlock();
 		return -ENODEV;
 	}
 	/* FIXME: scsiAuthIntrHSOutCommands */
 	ret = snprintf(page, PAGE_SIZE, "%u\n", 0);
-	spin_unlock_irq(&nacl->device_list_lock);
+	rcu_read_unlock();
 	return ret;
 }
 DEV_STAT_SCSI_AUTH_INTR_ATTR_RO(hs_num_cmds);
@@ -1354,16 +1357,16 @@ static ssize_t target_stat_scsi_auth_intr_show_attr_creation_time(
 	struct se_dev_entry *deve;
 	ssize_t ret;
 
-	spin_lock_irq(&nacl->device_list_lock);
-	deve = nacl->device_list[lacl->mapped_lun];
-	if (!deve->se_lun || !deve->se_lun_acl) {
-		spin_unlock_irq(&nacl->device_list_lock);
+	rcu_read_lock();
+	deve = target_nacl_find_deve(nacl, lacl->mapped_lun);
+	if (!deve) {
+		rcu_read_unlock();
 		return -ENODEV;
 	}
 	/* scsiAuthIntrLastCreation */
 	ret = snprintf(page, PAGE_SIZE, "%u\n", (u32)(((u32)deve->creation_time -
 				INITIAL_JIFFIES) * 100 / HZ));
-	spin_unlock_irq(&nacl->device_list_lock);
+	rcu_read_unlock();
 	return ret;
 }
 DEV_STAT_SCSI_AUTH_INTR_ATTR_RO(creation_time);
@@ -1377,15 +1380,15 @@ static ssize_t target_stat_scsi_auth_intr_show_attr_row_status(
 	struct se_dev_entry *deve;
 	ssize_t ret;
 
-	spin_lock_irq(&nacl->device_list_lock);
-	deve = nacl->device_list[lacl->mapped_lun];
-	if (!deve->se_lun || !deve->se_lun_acl) {
-		spin_unlock_irq(&nacl->device_list_lock);
+	rcu_read_lock();
+	deve = target_nacl_find_deve(nacl, lacl->mapped_lun);
+	if (!deve) {
+		rcu_read_unlock();
 		return -ENODEV;
 	}
 	/* FIXME: scsiAuthIntrRowStatus */
 	ret = snprintf(page, PAGE_SIZE, "Ready\n");
-	spin_unlock_irq(&nacl->device_list_lock);
+	rcu_read_unlock();
 	return ret;
 }
 DEV_STAT_SCSI_AUTH_INTR_ATTR_RO(row_status);
@@ -1450,17 +1453,17 @@ static ssize_t target_stat_scsi_att_intr_port_show_attr_inst(
 	struct se_portal_group *tpg;
 	ssize_t ret;
 
-	spin_lock_irq(&nacl->device_list_lock);
-	deve = nacl->device_list[lacl->mapped_lun];
-	if (!deve->se_lun || !deve->se_lun_acl) {
-		spin_unlock_irq(&nacl->device_list_lock);
+	rcu_read_lock();
+	deve = target_nacl_find_deve(nacl, lacl->mapped_lun);
+	if (!deve) {
+		rcu_read_unlock();
 		return -ENODEV;
 	}
 	tpg = nacl->se_tpg;
 	/* scsiInstIndex */
 	ret = snprintf(page, PAGE_SIZE, "%u\n",
 			tpg->se_tpg_tfo->tpg_get_inst_index(tpg));
-	spin_unlock_irq(&nacl->device_list_lock);
+	rcu_read_unlock();
 	return ret;
 }
 DEV_STAT_SCSI_ATTR_INTR_PORT_ATTR_RO(inst);
@@ -1475,16 +1478,16 @@ static ssize_t target_stat_scsi_att_intr_port_show_attr_dev(
 	struct se_lun *lun;
 	ssize_t ret;
 
-	spin_lock_irq(&nacl->device_list_lock);
-	deve = nacl->device_list[lacl->mapped_lun];
-	if (!deve->se_lun || !deve->se_lun_acl) {
-		spin_unlock_irq(&nacl->device_list_lock);
+	rcu_read_lock();
+	deve = target_nacl_find_deve(nacl, lacl->mapped_lun);
+	if (!deve) {
+		rcu_read_unlock();
 		return -ENODEV;
 	}
-	lun = deve->se_lun;
+	lun = rcu_dereference(deve->se_lun);
 	/* scsiDeviceIndex */
-	ret = snprintf(page, PAGE_SIZE, "%u\n", lun->lun_se_dev->dev_index);
-	spin_unlock_irq(&nacl->device_list_lock);
+	ret = snprintf(page, PAGE_SIZE, "%u\n", lun->lun_index);
+	rcu_read_unlock();
 	return ret;
 }
 DEV_STAT_SCSI_ATTR_INTR_PORT_ATTR_RO(dev);
@@ -1499,16 +1502,16 @@ static ssize_t target_stat_scsi_att_intr_port_show_attr_port(
 	struct se_portal_group *tpg;
 	ssize_t ret;
 
-	spin_lock_irq(&nacl->device_list_lock);
-	deve = nacl->device_list[lacl->mapped_lun];
-	if (!deve->se_lun || !deve->se_lun_acl) {
-		spin_unlock_irq(&nacl->device_list_lock);
+	rcu_read_lock();
+	deve = target_nacl_find_deve(nacl, lacl->mapped_lun);
+	if (!deve) {
+		rcu_read_unlock();
 		return -ENODEV;
 	}
 	tpg = nacl->se_tpg;
 	/* scsiPortIndex */
 	ret = snprintf(page, PAGE_SIZE, "%u\n", tpg->se_tpg_tfo->tpg_get_tag(tpg));
-	spin_unlock_irq(&nacl->device_list_lock);
+	rcu_read_unlock();
 	return ret;
 }
 DEV_STAT_SCSI_ATTR_INTR_PORT_ATTR_RO(port);
@@ -1548,15 +1551,15 @@ static ssize_t target_stat_scsi_att_intr_port_show_attr_port_auth_indx(
 	struct se_dev_entry *deve;
 	ssize_t ret;
 
-	spin_lock_irq(&nacl->device_list_lock);
-	deve = nacl->device_list[lacl->mapped_lun];
-	if (!deve->se_lun || !deve->se_lun_acl) {
-		spin_unlock_irq(&nacl->device_list_lock);
+	rcu_read_lock();
+	deve = target_nacl_find_deve(nacl, lacl->mapped_lun);
+	if (!deve) {
+		rcu_read_unlock();
 		return -ENODEV;
 	}
 	/* scsiAttIntrPortAuthIntrIdx */
 	ret = snprintf(page, PAGE_SIZE, "%u\n", nacl->acl_index);
-	spin_unlock_irq(&nacl->device_list_lock);
+	rcu_read_unlock();
 	return ret;
 }
 DEV_STAT_SCSI_ATTR_INTR_PORT_ATTR_RO(port_auth_indx);
diff --git a/drivers/target/target_core_tpg.c b/drivers/target/target_core_tpg.c
index c0c1f67..0519923 100644
--- a/drivers/target/target_core_tpg.c
+++ b/drivers/target/target_core_tpg.c
@@ -47,42 +47,6 @@ extern struct se_device *g_lun0_dev;
 static DEFINE_SPINLOCK(tpg_lock);
 static LIST_HEAD(tpg_list);
 
-/*	core_clear_initiator_node_from_tpg():
- *
- *
- */
-static void core_clear_initiator_node_from_tpg(
-	struct se_node_acl *nacl,
-	struct se_portal_group *tpg)
-{
-	int i;
-	struct se_dev_entry *deve;
-	struct se_lun *lun;
-
-	spin_lock_irq(&nacl->device_list_lock);
-	for (i = 0; i < TRANSPORT_MAX_LUNS_PER_TPG; i++) {
-		deve = nacl->device_list[i];
-
-		if (!(deve->lun_flags & TRANSPORT_LUNFLAGS_INITIATOR_ACCESS))
-			continue;
-
-		if (!deve->se_lun) {
-			pr_err("%s device entries device pointer is"
-				" NULL, but Initiator has access.\n",
-				tpg->se_tpg_tfo->get_fabric_name());
-			continue;
-		}
-
-		lun = deve->se_lun;
-		spin_unlock_irq(&nacl->device_list_lock);
-		core_disable_device_list_for_node(lun, NULL, deve->mapped_lun,
-			TRANSPORT_LUNFLAGS_NO_ACCESS, nacl, tpg);
-
-		spin_lock_irq(&nacl->device_list_lock);
-	}
-	spin_unlock_irq(&nacl->device_list_lock);
-}
-
 /*	__core_tpg_get_initiator_node_acl():
  *
  *	spin_lock_bh(&tpg->acl_node_lock); must be held when calling
@@ -225,35 +189,6 @@ static void *array_zalloc(int n, size_t size, gfp_t flags)
 	return a;
 }
 
-/*      core_create_device_list_for_node():
- *
- *
- */
-static int core_create_device_list_for_node(struct se_node_acl *nacl)
-{
-	struct se_dev_entry *deve;
-	int i;
-
-	nacl->device_list = array_zalloc(TRANSPORT_MAX_LUNS_PER_TPG,
-			sizeof(struct se_dev_entry), GFP_KERNEL);
-	if (!nacl->device_list) {
-		pr_err("Unable to allocate memory for"
-			" struct se_node_acl->device_list\n");
-		return -ENOMEM;
-	}
-	for (i = 0; i < TRANSPORT_MAX_LUNS_PER_TPG; i++) {
-		deve = nacl->device_list[i];
-
-		atomic_set(&deve->ua_count, 0);
-		atomic_set(&deve->pr_ref_count, 0);
-		spin_lock_init(&deve->ua_lock);
-		INIT_LIST_HEAD(&deve->alua_port_list);
-		INIT_LIST_HEAD(&deve->ua_list);
-	}
-
-	return 0;
-}
-
 static struct se_node_acl *target_alloc_node_acl(struct se_portal_group *tpg,
 		const unsigned char *initiatorname)
 {
@@ -266,10 +201,11 @@ static struct se_node_acl *target_alloc_node_acl(struct se_portal_group *tpg,
 
 	INIT_LIST_HEAD(&acl->acl_list);
 	INIT_LIST_HEAD(&acl->acl_sess_list);
+	INIT_HLIST_HEAD(&acl->lun_entry_hlist);
 	kref_init(&acl->acl_kref);
 	init_completion(&acl->acl_free_comp);
-	spin_lock_init(&acl->device_list_lock);
 	spin_lock_init(&acl->nacl_sess_lock);
+	mutex_init(&acl->lun_entry_mutex);
 	atomic_set(&acl->acl_pr_ref_count, 0);
 	if (tpg->se_tpg_tfo->tpg_get_default_depth)
 		acl->queue_depth = tpg->se_tpg_tfo->tpg_get_default_depth(tpg);
@@ -281,15 +217,11 @@ static struct se_node_acl *target_alloc_node_acl(struct se_portal_group *tpg,
 
 	tpg->se_tpg_tfo->set_default_node_attributes(acl);
 
-	if (core_create_device_list_for_node(acl) < 0)
-		goto out_free_acl;
 	if (core_set_queue_depth_for_node(tpg, acl) < 0)
-		goto out_free_device_list;
+		goto out_free_acl;
 
 	return acl;
 
-out_free_device_list:
-	core_free_device_list_for_node(acl, tpg);
 out_free_acl:
 	kfree(acl);
 	return NULL;
@@ -454,7 +386,6 @@ void core_tpg_del_initiator_node_acl(struct se_node_acl *acl)
 	wait_for_completion(&acl->acl_free_comp);
 
 	core_tpg_wait_for_nacl_pr_ref(acl);
-	core_clear_initiator_node_from_tpg(acl, tpg);
 	core_free_device_list_for_node(acl, tpg);
 
 	pr_debug("%s_TPG[%hu] - Deleted ACL with TCQ Depth: %d for %s"
diff --git a/drivers/target/target_core_ua.c b/drivers/target/target_core_ua.c
index a0bf0d1..6c9616d 100644
--- a/drivers/target/target_core_ua.c
+++ b/drivers/target/target_core_ua.c
@@ -50,9 +50,17 @@ target_scsi3_ua_check(struct se_cmd *cmd)
 	if (!nacl)
 		return 0;
 
-	deve = nacl->device_list[cmd->orig_fe_lun];
-	if (!atomic_read(&deve->ua_count))
+	rcu_read_lock();
+	deve = target_nacl_find_deve(nacl, cmd->orig_fe_lun);
+	if (!deve) {
+		rcu_read_unlock();
 		return 0;
+	}
+	if (!atomic_read(&deve->ua_count)) {
+		rcu_read_unlock();
+		return 0;
+	}
+	rcu_read_unlock();
 	/*
 	 * From sam4r14, section 5.14 Unit attention condition:
 	 *
@@ -103,9 +111,12 @@ int core_scsi3_ua_allocate(
 	ua->ua_asc = asc;
 	ua->ua_ascq = ascq;
 
-	spin_lock_irq(&nacl->device_list_lock);
-	deve = nacl->device_list[unpacked_lun];
-
+	rcu_read_lock();
+	deve = target_nacl_find_deve(nacl, unpacked_lun);
+	if (!deve) {
+		rcu_read_unlock();
+		return -EINVAL;
+	}
 	spin_lock(&deve->ua_lock);
 	list_for_each_entry_safe(ua_p, ua_tmp, &deve->ua_list, ua_nacl_list) {
 		/*
@@ -113,7 +124,7 @@ int core_scsi3_ua_allocate(
 		 */
 		if ((ua_p->ua_asc == asc) && (ua_p->ua_ascq == ascq)) {
 			spin_unlock(&deve->ua_lock);
-			spin_unlock_irq(&nacl->device_list_lock);
+			rcu_read_unlock();
 			kmem_cache_free(se_ua_cache, ua);
 			return 0;
 		}
@@ -158,14 +169,13 @@ int core_scsi3_ua_allocate(
 			list_add_tail(&ua->ua_nacl_list,
 				&deve->ua_list);
 		spin_unlock(&deve->ua_lock);
-		spin_unlock_irq(&nacl->device_list_lock);
 
 		atomic_inc_mb(&deve->ua_count);
+		rcu_read_unlock();
 		return 0;
 	}
 	list_add_tail(&ua->ua_nacl_list, &deve->ua_list);
 	spin_unlock(&deve->ua_lock);
-	spin_unlock_irq(&nacl->device_list_lock);
 
 	pr_debug("[%s]: Allocated UNIT ATTENTION, mapped LUN: %u, ASC:"
 		" 0x%02x, ASCQ: 0x%02x\n",
@@ -173,6 +183,7 @@ int core_scsi3_ua_allocate(
 		asc, ascq);
 
 	atomic_inc_mb(&deve->ua_count);
+	rcu_read_unlock();
 	return 0;
 }
 
@@ -210,10 +221,14 @@ void core_scsi3_ua_for_check_condition(
 	if (!nacl)
 		return;
 
-	spin_lock_irq(&nacl->device_list_lock);
-	deve = nacl->device_list[cmd->orig_fe_lun];
+	rcu_read_lock();
+	deve = target_nacl_find_deve(nacl, cmd->orig_fe_lun);
+	if (!deve) {
+		rcu_read_unlock();
+		return;
+	}
 	if (!atomic_read(&deve->ua_count)) {
-		spin_unlock_irq(&nacl->device_list_lock);
+		rcu_read_unlock();
 		return;
 	}
 	/*
@@ -249,7 +264,7 @@ void core_scsi3_ua_for_check_condition(
 		atomic_dec_mb(&deve->ua_count);
 	}
 	spin_unlock(&deve->ua_lock);
-	spin_unlock_irq(&nacl->device_list_lock);
+	rcu_read_unlock();
 
 	pr_debug("[%s]: %s UNIT ATTENTION condition with"
 		" INTLCK_CTRL: %d, mapped LUN: %u, got CDB: 0x%02x"
@@ -278,10 +293,14 @@ int core_scsi3_ua_clear_for_request_sense(
 	if (!nacl)
 		return -EINVAL;
 
-	spin_lock_irq(&nacl->device_list_lock);
-	deve = nacl->device_list[cmd->orig_fe_lun];
+	rcu_read_lock();
+	deve = target_nacl_find_deve(nacl, cmd->orig_fe_lun);
+	if (!deve) {
+		rcu_read_unlock();
+		return -EINVAL;
+	}
 	if (!atomic_read(&deve->ua_count)) {
-		spin_unlock_irq(&nacl->device_list_lock);
+		rcu_read_unlock();
 		return -EPERM;
 	}
 	/*
@@ -307,7 +326,7 @@ int core_scsi3_ua_clear_for_request_sense(
 		atomic_dec_mb(&deve->ua_count);
 	}
 	spin_unlock(&deve->ua_lock);
-	spin_unlock_irq(&nacl->device_list_lock);
+	rcu_read_unlock();
 
 	pr_debug("[%s]: Released UNIT ATTENTION condition, mapped"
 		" LUN: %u, got REQUEST_SENSE reported ASC: 0x%02x,"
diff --git a/include/target/target_core_backend.h b/include/target/target_core_backend.h
index ab8ed4c..b688826 100644
--- a/include/target/target_core_backend.h
+++ b/include/target/target_core_backend.h
@@ -103,7 +103,7 @@ int	target_alloc_sgl(struct scatterlist **, unsigned int *, u32, bool);
 sense_reason_t	transport_generic_map_mem_to_cmd(struct se_cmd *,
 		struct scatterlist *, u32, struct scatterlist *, u32);
 
-void	array_free(void *array, int n);
+bool	target_lun_is_rdonly(struct se_cmd *);
 
 /* From target_core_configfs.c to setup default backend config_item_types */
 void	target_core_setup_sub_cits(struct se_subsystem_api *);
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index 042a734..b518523 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -160,10 +160,8 @@ enum se_cmd_flags_table {
 
 /* struct se_dev_entry->lun_flags and struct se_lun->lun_access */
 enum transport_lunflags_table {
-	TRANSPORT_LUNFLAGS_NO_ACCESS		= 0x00,
-	TRANSPORT_LUNFLAGS_INITIATOR_ACCESS	= 0x01,
-	TRANSPORT_LUNFLAGS_READ_ONLY		= 0x02,
-	TRANSPORT_LUNFLAGS_READ_WRITE		= 0x04,
+	TRANSPORT_LUNFLAGS_READ_ONLY		= 0x01,
+	TRANSPORT_LUNFLAGS_READ_WRITE		= 0x02,
 };
 
 /*
@@ -584,10 +582,10 @@ struct se_node_acl {
 	char			acl_tag[MAX_ACL_TAG_SIZE];
 	/* Used for PR SPEC_I_PT=1 and REGISTER_AND_MOVE */
 	atomic_t		acl_pr_ref_count;
-	struct se_dev_entry	**device_list;
+	struct hlist_head	lun_entry_hlist;
 	struct se_session	*nacl_sess;
 	struct se_portal_group *se_tpg;
-	spinlock_t		device_list_lock;
+	struct mutex		lun_entry_mutex;
 	spinlock_t		nacl_sess_lock;
 	struct config_group	acl_group;
 	struct config_group	acl_attrib_group;
@@ -644,20 +642,23 @@ struct se_dev_entry {
 	/* See transport_lunflags_table */
 	u32			lun_flags;
 	u32			mapped_lun;
-	u32			total_cmds;
 	u64			pr_res_key;
 	u64			creation_time;
 	u32			attach_count;
-	u64			read_bytes;
-	u64			write_bytes;
+	atomic_long_t		total_cmds;
+	atomic_long_t		read_bytes;
+	atomic_long_t		write_bytes;
 	atomic_t		ua_count;
 	/* Used for PR SPEC_I_PT=1 and REGISTER_AND_MOVE */
-	atomic_t		pr_ref_count;
-	struct se_lun_acl	*se_lun_acl;
+	struct kref		pr_kref;
+	struct completion	pr_comp;
+	struct se_lun_acl __rcu	*se_lun_acl;
 	spinlock_t		ua_lock;
-	struct se_lun		*se_lun;
+	struct se_lun __rcu	*se_lun;
 	struct list_head	alua_port_list;
 	struct list_head	ua_list;
+	struct hlist_node	link;
+	struct rcu_head		rcu_head;
 };
 
 struct se_dev_attrib {
@@ -703,6 +704,7 @@ struct se_port_stat_grps {
 };
 
 struct se_lun {
+	u16			lun_rtpi;
 #define SE_LUN_LINK_MAGIC			0xffff7771
 	u32			lun_link_magic;
 	/* See transport_lun_status_table */
@@ -710,6 +712,7 @@ struct se_lun {
 	u32			lun_access;
 	u32			lun_flags;
 	u32			unpacked_lun;
+	u32			lun_index;
 	atomic_t		lun_acl_count;
 	spinlock_t		lun_acl_lock;
 	spinlock_t		lun_sep_lock;
-- 
1.9.1

