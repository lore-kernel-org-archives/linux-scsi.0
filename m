From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH 05/12] target: Convert transport_lookup_*_lun to RCU reader
Date: Tue, 12 May 2015 09:25:29 +0000
Message-ID: <1431422736-29125-6-git-send-email-nab@daterainc.com>
References: <1431422736-29125-1-git-send-email-nab@daterainc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ob0-f173.google.com ([209.85.214.173]:35882 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932391AbbELJ2F (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 12 May 2015 05:28:05 -0400
Received: by obbkp3 with SMTP id kp3so864573obb.3
        for <linux-scsi@vger.kernel.org>; Tue, 12 May 2015 02:28:04 -0700 (PDT)
In-Reply-To: <1431422736-29125-1-git-send-email-nab@daterainc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagig@mellanox.com>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch converts transport_lookup_*_lun() fast-path code to
use RCU read path primitives when looking up se_dev_entry.  It
adds a new array of pointers in se_node_acl->lun_entry_hlist
for this purpose.

For transport_lookup_cmd_lun() code, it works with existing per-cpu
se_lun->lun_ref when associating se_cmd with se_lun + se_device.
Also, go ahead and update core_create_device_list_for_node() +
core_free_device_list_for_node() to use ->lun_entry_hlist.

Finally, now that se_node_acl->lun_entry_hlist fast path access
uses RCU protected pointers, go ahead and convert remaining non-fast
path RCU updater code using ->lun_entry_lock to struct mutex.

Cc: Hannes Reinecke <hare@suse.de>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Sagi Grimberg <sagig@mellanox.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_device.c | 60 +++++++++++++++++++++++--------------
 drivers/target/target_core_pr.c     |  1 +
 drivers/target/target_core_tpg.c    | 38 ++---------------------
 include/target/target_core_base.h   |  3 +-
 4 files changed, 42 insertions(+), 60 deletions(-)

diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index 1df14ce..36e7d13 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -59,17 +59,24 @@ transport_lookup_cmd_lun(struct se_cmd *se_cmd, u32 unpacked_lun)
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
+	rcu_read_lock();
+	deve = target_nacl_find_deve(nacl, unpacked_lun);
+	if (deve && deve->lun_flags & TRANSPORT_LUNFLAGS_INITIATOR_ACCESS) {
+		/*
+		 * Make sure that target_enable_device_list_for_node()
+		 * has not already cleared the RCU protected pointers.
+		 */
+		if (!deve->se_lun) {
+			rcu_read_unlock();
+			goto check_lun;
+		}
 		deve->total_cmds++;
 
 		if ((se_cmd->data_direction == DMA_TO_DEVICE) &&
@@ -78,7 +85,7 @@ transport_lookup_cmd_lun(struct se_cmd *se_cmd, u32 unpacked_lun)
 				" Access for 0x%08x\n",
 				se_cmd->se_tfo->get_fabric_name(),
 				unpacked_lun);
-			spin_unlock_irqrestore(&se_sess->se_node_acl->device_list_lock, flags);
+			rcu_read_unlock();
 			return TCM_WRITE_PROTECTED;
 		}
 
@@ -96,8 +103,9 @@ transport_lookup_cmd_lun(struct se_cmd *se_cmd, u32 unpacked_lun)
 		percpu_ref_get(&se_lun->lun_ref);
 		se_cmd->lun_ref_active = true;
 	}
-	spin_unlock_irqrestore(&se_sess->se_node_acl->device_list_lock, flags);
+	rcu_read_unlock();
 
+check_lun:
 	if (!se_lun) {
 		/*
 		 * Use the se_portal_group->tpg_virt_lun0 to allow for
@@ -146,25 +154,33 @@ int transport_lookup_tmr_lun(struct se_cmd *se_cmd, u32 unpacked_lun)
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
+	rcu_read_lock();
+	deve = target_nacl_find_deve(nacl, unpacked_lun);
+	if (deve && deve->lun_flags & TRANSPORT_LUNFLAGS_INITIATOR_ACCESS) {
+		/*
+		 * Make sure that target_enable_device_list_for_node()
+		 * has not already cleared the RCU protected pointers.
+		 */
+		if (!deve->se_lun) {
+			rcu_read_unlock();
+			goto check_lun;
+		}
 		se_tmr->tmr_lun = deve->se_lun;
 		se_cmd->se_lun = deve->se_lun;
 		se_lun = deve->se_lun;
 		se_cmd->pr_res_key = deve->pr_res_key;
 		se_cmd->orig_fe_lun = unpacked_lun;
 	}
-	spin_unlock_irqrestore(&se_sess->se_node_acl->device_list_lock, flags);
+	rcu_read_unlock();
 
+check_lun:
 	if (!se_lun) {
 		pr_debug("TARGET_CORE[%s]: Detected NON_EXISTENT_LUN"
 			" Access for 0x%08x\n",
@@ -269,7 +285,7 @@ void core_update_device_list_access(
 {
 	struct se_dev_entry *deve;
 
-	spin_lock_irq(&nacl->lun_entry_lock);
+	mutex_lock(&nacl->lun_entry_mutex);
 	deve = target_nacl_find_deve(nacl, mapped_lun);
 	if (deve) {
 		if (lun_access & TRANSPORT_LUNFLAGS_READ_WRITE) {
@@ -280,7 +296,7 @@ void core_update_device_list_access(
 			deve->lun_flags |= TRANSPORT_LUNFLAGS_READ_ONLY;
 		}
 	}
-	spin_unlock_irq(&nacl->lun_entry_lock);
+	mutex_unlock(&nacl->lun_entry_mutex);
 
 	synchronize_rcu();
 }
@@ -345,7 +361,7 @@ int core_enable_device_list_for_node(
 	new->creation_time = get_jiffies_64();
 	new->attach_count++;
 
-	spin_lock_irq(&nacl->device_list_lock);
+	mutex_lock(&nacl->lun_entry_mutex);
 	orig = target_nacl_find_deve(nacl, mapped_lun);
 	if (orig && orig->lun_flags & TRANSPORT_LUNFLAGS_INITIATOR_ACCESS) {
 		BUG_ON(orig->se_lun_acl != NULL);
@@ -354,7 +370,7 @@ int core_enable_device_list_for_node(
 		rcu_assign_pointer(new->se_lun, lun);
 		rcu_assign_pointer(new->se_lun_acl, lun_acl);
 		hlist_add_head_rcu(&new->link, &nacl->lun_entry_hlist);
-		spin_unlock_irq(&nacl->device_list_lock);
+		mutex_unlock(&nacl->lun_entry_mutex);
 
 		spin_lock_bh(&port->sep_alua_lock);
 		list_del(&orig->alua_port_list);
@@ -368,7 +384,7 @@ int core_enable_device_list_for_node(
 	rcu_assign_pointer(new->se_lun, lun);
 	rcu_assign_pointer(new->se_lun_acl, lun_acl);
 	hlist_add_head_rcu(&new->link, &nacl->lun_entry_hlist);
-	spin_unlock_irq(&nacl->device_list_lock);
+	mutex_unlock(&nacl->lun_entry_mutex);
 
 	spin_lock_bh(&port->sep_alua_lock);
 	list_add_tail(&new->alua_port_list, &port->sep_alua_list);
@@ -393,10 +409,10 @@ int core_disable_device_list_for_node(
 	struct se_port *port = lun->lun_sep;
 	struct se_dev_entry *orig;
 
-	spin_lock_irq(&nacl->device_list_lock);
+	mutex_lock(&nacl->lun_entry_mutex);
 	orig = target_nacl_find_deve(nacl, mapped_lun);
 	if (!orig) {
-		spin_unlock_irq(&nacl->device_list_lock);
+		mutex_unlock(&nacl->lun_entry_mutex);
 		return 0;
 	}
 	/*
@@ -432,7 +448,7 @@ int core_disable_device_list_for_node(
 	orig->creation_time = 0;
 	orig->attach_count--;
 	hlist_del_rcu(&orig->link);
-	spin_unlock_irq(&nacl->device_list_lock);
+	mutex_unlock(&nacl->lun_entry_mutex);
 
 	/*
 	 * Fire off RCU callback to wait for any in process SPEC_I_PT=1
diff --git a/drivers/target/target_core_pr.c b/drivers/target/target_core_pr.c
index 8052d40..721b664 100644
--- a/drivers/target/target_core_pr.c
+++ b/drivers/target/target_core_pr.c
@@ -1066,6 +1066,7 @@ static void __core_scsi3_add_registration(
 				pr_reg_tmp->pr_reg_nacl, pr_reg_tmp,
 				register_type);
 		spin_unlock(&pr_tmpl->registration_lock);
+
 		/*
 		 * Drop configfs group dependency reference from
 		 * __core_scsi3_alloc_registration()
diff --git a/drivers/target/target_core_tpg.c b/drivers/target/target_core_tpg.c
index dbdd3e3..f9487e5 100644
--- a/drivers/target/target_core_tpg.c
+++ b/drivers/target/target_core_tpg.c
@@ -222,35 +222,6 @@ static void *array_zalloc(int n, size_t size, gfp_t flags)
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
@@ -266,9 +237,8 @@ static struct se_node_acl *target_alloc_node_acl(struct se_portal_group *tpg,
 	INIT_HLIST_HEAD(&acl->lun_entry_hlist);
 	kref_init(&acl->acl_kref);
 	init_completion(&acl->acl_free_comp);
-	spin_lock_init(&acl->device_list_lock);
 	spin_lock_init(&acl->nacl_sess_lock);
-	spin_lock_init(&acl->lun_entry_lock);
+	mutex_init(&acl->lun_entry_mutex);
 	atomic_set(&acl->acl_pr_ref_count, 0);
 	if (tpg->se_tpg_tfo->tpg_get_default_depth)
 		acl->queue_depth = tpg->se_tpg_tfo->tpg_get_default_depth(tpg);
@@ -280,15 +250,11 @@ static struct se_node_acl *target_alloc_node_acl(struct se_portal_group *tpg,
 
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
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index 6fb38df..3057eff 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -588,8 +588,7 @@ struct se_node_acl {
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

