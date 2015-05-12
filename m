From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH 09/12] target: Convert se_portal_group->tpg_lun_list[] to RCU hlist
Date: Tue, 12 May 2015 09:25:33 +0000
Message-ID: <1431422736-29125-10-git-send-email-nab@daterainc.com>
References: <1431422736-29125-1-git-send-email-nab@daterainc.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1431422736-29125-1-git-send-email-nab@daterainc.com>
Sender: linux-kernel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagig@mellanox.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch converts the fixed size se_portal_group->tpg_lun_list[]
to use modern RCU with hlist_head in order to support an arbitary
number of se_lun ports per target endpoint.

It includes dropping core_tpg_alloc_lun() from core_dev_add_lun(),
and calling it directly from target_fabric_make_lun() to allocate
a new se_lun.

Also add a new target_fabric_port_release() configfs item callback
to invoke call_rcu() to release memory during se_lun->lun_group
shutdown.

Also now that se_node_acl->lun_entry_hlist is using RCU, convert
existing tpg_lun_lock to struct mutex so core_tpg_add_node_to_devs()
can perform RCU updater logic without releasing ->tpg_lun_mutex.

FIXME: Figure out how sbp-target se_lun usage should work

Cc: Hannes Reinecke <hare@suse.de>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Sagi Grimberg <sagig@mellanox.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/iscsi/iscsi_target_tpg.c      |   2 -
 drivers/target/sbp/sbp_target.c              |  16 ++--
 drivers/target/target_core_device.c          |  92 ++----------------
 drivers/target/target_core_fabric_configfs.c |  32 ++++---
 drivers/target/target_core_internal.h        |   7 +-
 drivers/target/target_core_tpg.c             | 135 +++++++--------------------
 drivers/xen/xen-scsiback.c                   |  27 +++---
 include/target/target_core_base.h            |   6 +-
 include/target/target_core_fabric.h          |   1 -
 9 files changed, 88 insertions(+), 230 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target_tpg.c b/drivers/target/iscsi/iscsi_target_tpg.c
index 3af76e3..86f888e 100644
--- a/drivers/target/iscsi/iscsi_target_tpg.c
+++ b/drivers/target/iscsi/iscsi_target_tpg.c
@@ -281,8 +281,6 @@ int iscsit_tpg_del_portal_group(
 		return -EPERM;
 	}
 
-	core_tpg_clear_object_luns(&tpg->tpg_se_tpg);
-
 	if (tpg->param_list) {
 		iscsi_release_param_list(tpg->param_list);
 		tpg->param_list = NULL;
diff --git a/drivers/target/sbp/sbp_target.c b/drivers/target/sbp/sbp_target.c
index 5d7755e..e5258d6 100644
--- a/drivers/target/sbp/sbp_target.c
+++ b/drivers/target/sbp/sbp_target.c
@@ -182,13 +182,13 @@ static struct se_lun *sbp_get_lun_from_tpg(struct sbp_tpg *tpg, int lun)
 	if (lun >= TRANSPORT_MAX_LUNS_PER_TPG)
 		return ERR_PTR(-EINVAL);
 
-	spin_lock(&se_tpg->tpg_lun_lock);
+	mutex_lock(&se_tpg->tpg_lun_mutex);
 	se_lun = se_tpg->tpg_lun_list[lun];
 
 	if (se_lun->lun_status != TRANSPORT_LUN_STATUS_ACTIVE)
 		se_lun = ERR_PTR(-ENODEV);
 
-	spin_unlock(&se_tpg->tpg_lun_lock);
+	mutex_unlock(&se_tpg->tpg_lun_mutex);
 
 	return se_lun;
 }
@@ -1828,7 +1828,7 @@ static int sbp_count_se_tpg_luns(struct se_portal_group *tpg)
 {
 	int i, count = 0;
 
-	spin_lock(&tpg->tpg_lun_lock);
+	mutex_lock(&tpg->tpg_lun_mutex);
 	for (i = 0; i < TRANSPORT_MAX_LUNS_PER_TPG; i++) {
 		struct se_lun *se_lun = tpg->tpg_lun_list[i];
 
@@ -1837,7 +1837,7 @@ static int sbp_count_se_tpg_luns(struct se_portal_group *tpg)
 
 		count++;
 	}
-	spin_unlock(&tpg->tpg_lun_lock);
+	mutex_unlock(&tpg->tpg_lun_mutex);
 
 	return count;
 }
@@ -1906,7 +1906,7 @@ static int sbp_update_unit_directory(struct sbp_tport *tport)
 	/* unit unique ID (leaf is just after LUNs) */
 	data[idx++] = 0x8d000000 | (num_luns + 1);
 
-	spin_lock(&tport->tpg->se_tpg.tpg_lun_lock);
+	mutex_lock(&tport->tpg->se_tpg.tpg_lun_mutex);
 	for (i = 0; i < TRANSPORT_MAX_LUNS_PER_TPG; i++) {
 		struct se_lun *se_lun = tport->tpg->se_tpg.tpg_lun_list[i];
 		struct se_device *dev;
@@ -1915,8 +1915,6 @@ static int sbp_update_unit_directory(struct sbp_tport *tport)
 		if (se_lun->lun_status == TRANSPORT_LUN_STATUS_FREE)
 			continue;
 
-		spin_unlock(&tport->tpg->se_tpg.tpg_lun_lock);
-
 		dev = se_lun->lun_se_dev;
 		type = dev->transport->get_device_type(dev);
 
@@ -1924,10 +1922,8 @@ static int sbp_update_unit_directory(struct sbp_tport *tport)
 		data[idx++] = 0x14000000 |
 			((type << 16) & 0x1f0000) |
 			(se_lun->unpacked_lun & 0xffff);
-
-		spin_lock(&tport->tpg->se_tpg.tpg_lun_lock);
 	}
-	spin_unlock(&tport->tpg->se_tpg.tpg_lun_lock);
+	mutex_unlock(&tport->tpg->se_tpg.tpg_lun_mutex);
 
 	/* unit unique ID leaf */
 	data[idx++] = 2 << 16;
diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index 430d3d6..cf52847a 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -1212,22 +1212,17 @@ int se_dev_set_block_size(struct se_device *dev, u32 block_size)
 }
 EXPORT_SYMBOL(se_dev_set_block_size);
 
-struct se_lun *core_dev_add_lun(
+int core_dev_add_lun(
 	struct se_portal_group *tpg,
 	struct se_device *dev,
-	u32 unpacked_lun)
+	struct se_lun *lun)
 {
-	struct se_lun *lun;
 	int rc;
 
-	lun = core_tpg_alloc_lun(tpg, unpacked_lun);
-	if (IS_ERR(lun))
-		return lun;
-
 	rc = core_tpg_add_lun(tpg, lun,
 				TRANSPORT_LUNFLAGS_READ_WRITE, dev);
 	if (rc < 0)
-		return ERR_PTR(rc);
+		return rc;
 
 	pr_debug("%s_TPG[%u]_LUN[%u] - Activated %s Logical Unit from"
 		" CORE HBA: %u\n", tpg->se_tpg_tfo->get_fabric_name(),
@@ -1252,7 +1247,7 @@ struct se_lun *core_dev_add_lun(
 		spin_unlock_irq(&tpg->acl_node_lock);
 	}
 
-	return lun;
+	return 0;
 }
 
 /*      core_dev_del_lun():
@@ -1271,68 +1266,6 @@ void core_dev_del_lun(
 	core_tpg_remove_lun(tpg, lun);
 }
 
-struct se_lun *core_get_lun_from_tpg(struct se_portal_group *tpg, u32 unpacked_lun)
-{
-	struct se_lun *lun;
-
-	spin_lock(&tpg->tpg_lun_lock);
-	if (unpacked_lun > (TRANSPORT_MAX_LUNS_PER_TPG-1)) {
-		pr_err("%s LUN: %u exceeds TRANSPORT_MAX_LUNS"
-			"_PER_TPG-1: %u for Target Portal Group: %hu\n",
-			tpg->se_tpg_tfo->get_fabric_name(), unpacked_lun,
-			TRANSPORT_MAX_LUNS_PER_TPG-1,
-			tpg->se_tpg_tfo->tpg_get_tag(tpg));
-		spin_unlock(&tpg->tpg_lun_lock);
-		return NULL;
-	}
-	lun = tpg->tpg_lun_list[unpacked_lun];
-
-	if (lun->lun_status != TRANSPORT_LUN_STATUS_FREE) {
-		pr_err("%s Logical Unit Number: %u is not free on"
-			" Target Portal Group: %hu, ignoring request.\n",
-			tpg->se_tpg_tfo->get_fabric_name(), unpacked_lun,
-			tpg->se_tpg_tfo->tpg_get_tag(tpg));
-		spin_unlock(&tpg->tpg_lun_lock);
-		return NULL;
-	}
-	spin_unlock(&tpg->tpg_lun_lock);
-
-	return lun;
-}
-
-/*      core_dev_get_lun():
- *
- *
- */
-static struct se_lun *core_dev_get_lun(struct se_portal_group *tpg, u32 unpacked_lun)
-{
-	struct se_lun *lun;
-
-	spin_lock(&tpg->tpg_lun_lock);
-	if (unpacked_lun > (TRANSPORT_MAX_LUNS_PER_TPG-1)) {
-		pr_err("%s LUN: %u exceeds TRANSPORT_MAX_LUNS_PER"
-			"_TPG-1: %u for Target Portal Group: %hu\n",
-			tpg->se_tpg_tfo->get_fabric_name(), unpacked_lun,
-			TRANSPORT_MAX_LUNS_PER_TPG-1,
-			tpg->se_tpg_tfo->tpg_get_tag(tpg));
-		spin_unlock(&tpg->tpg_lun_lock);
-		return NULL;
-	}
-	lun = tpg->tpg_lun_list[unpacked_lun];
-
-	if (lun->lun_status != TRANSPORT_LUN_STATUS_ACTIVE) {
-		pr_err("%s Logical Unit Number: %u is not active on"
-			" Target Portal Group: %hu, ignoring request.\n",
-			tpg->se_tpg_tfo->get_fabric_name(), unpacked_lun,
-			tpg->se_tpg_tfo->tpg_get_tag(tpg));
-		spin_unlock(&tpg->tpg_lun_lock);
-		return NULL;
-	}
-	spin_unlock(&tpg->tpg_lun_lock);
-
-	return lun;
-}
-
 struct se_lun_acl *core_dev_init_initiator_node_lun_acl(
 	struct se_portal_group *tpg,
 	struct se_node_acl *nacl,
@@ -1366,22 +1299,11 @@ struct se_lun_acl *core_dev_init_initiator_node_lun_acl(
 int core_dev_add_initiator_node_lun_acl(
 	struct se_portal_group *tpg,
 	struct se_lun_acl *lacl,
-	u32 unpacked_lun,
+	struct se_lun *lun,
 	u32 lun_access)
 {
-	struct se_lun *lun;
-	struct se_node_acl *nacl;
+	struct se_node_acl *nacl = lacl->se_lun_nacl;
 
-	lun = core_dev_get_lun(tpg, unpacked_lun);
-	if (!lun) {
-		pr_err("%s Logical Unit Number: %u is not active on"
-			" Target Portal Group: %hu, ignoring request.\n",
-			tpg->se_tpg_tfo->get_fabric_name(), unpacked_lun,
-			tpg->se_tpg_tfo->tpg_get_tag(tpg));
-		return -EINVAL;
-	}
-
-	nacl = lacl->se_lun_nacl;
 	if (!nacl)
 		return -EINVAL;
 
@@ -1402,7 +1324,7 @@ int core_dev_add_initiator_node_lun_acl(
 
 	pr_debug("%s_TPG[%hu]_LUN[%u->%u] - Added %s ACL for "
 		" InitiatorNode: %s\n", tpg->se_tpg_tfo->get_fabric_name(),
-		tpg->se_tpg_tfo->tpg_get_tag(tpg), unpacked_lun, lacl->mapped_lun,
+		tpg->se_tpg_tfo->tpg_get_tag(tpg), lun->unpacked_lun, lacl->mapped_lun,
 		(lun_access & TRANSPORT_LUNFLAGS_READ_WRITE) ? "RW" : "RO",
 		lacl->initiatorname);
 	/*
diff --git a/drivers/target/target_core_fabric_configfs.c b/drivers/target/target_core_fabric_configfs.c
index 0dab6d5..7fe69c4 100644
--- a/drivers/target/target_core_fabric_configfs.c
+++ b/drivers/target/target_core_fabric_configfs.c
@@ -81,7 +81,7 @@ static int target_fabric_mappedlun_link(
 			struct se_lun_acl, se_lun_group);
 	struct se_portal_group *se_tpg;
 	struct config_item *nacl_ci, *tpg_ci, *tpg_ci_s, *wwn_ci, *wwn_ci_s;
-	int ret = 0, lun_access;
+	int lun_access;
 
 	if (lun->lun_link_magic != SE_LUN_LINK_MAGIC) {
 		pr_err("Bad lun->lun_link_magic, not a valid lun_ci pointer:"
@@ -137,12 +137,9 @@ static int target_fabric_mappedlun_link(
 	 * Determine the actual mapped LUN value user wants..
 	 *
 	 * This value is what the SCSI Initiator actually sees the
-	 * iscsi/$IQN/$TPGT/lun/lun_* as on their SCSI Initiator Ports.
+	 * $FABRIC/$WWPN/$TPGT/lun/lun_* as on their SCSI Initiator Ports.
 	 */
-	ret = core_dev_add_initiator_node_lun_acl(se_tpg, lacl,
-			lun->unpacked_lun, lun_access);
-
-	return (ret < 0) ? -EINVAL : 0;
+	return core_dev_add_initiator_node_lun_acl(se_tpg, lacl, lun, lun_access);
 }
 
 static int target_fabric_mappedlun_unlink(
@@ -775,7 +772,6 @@ static int target_fabric_port_link(
 	struct config_item *tpg_ci;
 	struct se_lun *lun = container_of(to_config_group(lun_ci),
 				struct se_lun, lun_group);
-	struct se_lun *lun_p;
 	struct se_portal_group *se_tpg;
 	struct se_device *dev =
 		container_of(to_config_group(se_dev_ci), struct se_device, dev_group);
@@ -803,10 +799,9 @@ static int target_fabric_port_link(
 		return -EEXIST;
 	}
 
-	lun_p = core_dev_add_lun(se_tpg, dev, lun->unpacked_lun);
-	if (IS_ERR(lun_p)) {
-		pr_err("core_dev_add_lun() failed\n");
-		ret = PTR_ERR(lun_p);
+	ret = core_dev_add_lun(se_tpg, dev, lun);
+	if (ret) {
+		pr_err("core_dev_add_lun() failed: %d\n", ret);
 		goto out;
 	}
 
@@ -846,9 +841,18 @@ static int target_fabric_port_unlink(
 	return 0;
 }
 
+static void target_fabric_port_release(struct config_item *item)
+{
+	struct se_lun *lun = container_of(to_config_group(item),
+					  struct se_lun, lun_group);
+
+	call_rcu(&lun->rcu_head, target_lun_callrcu);
+}
+
 static struct configfs_item_operations target_fabric_port_item_ops = {
 	.show_attribute		= target_fabric_port_attr_show,
 	.store_attribute	= target_fabric_port_attr_store,
+	.release		= target_fabric_port_release,
 	.allow_link		= target_fabric_port_link,
 	.drop_link		= target_fabric_port_unlink,
 };
@@ -907,15 +911,16 @@ static struct config_group *target_fabric_make_lun(
 	if (unpacked_lun > UINT_MAX)
 		return ERR_PTR(-EINVAL);
 
-	lun = core_get_lun_from_tpg(se_tpg, unpacked_lun);
+	lun = core_tpg_alloc_lun(se_tpg, unpacked_lun);
 	if (!lun)
-		return ERR_PTR(-EINVAL);
+		return ERR_PTR(-ENOMEM);
 
 	lun_cg = &lun->lun_group;
 	lun_cg->default_groups = kmalloc(sizeof(struct config_group *) * 2,
 				GFP_KERNEL);
 	if (!lun_cg->default_groups) {
 		pr_err("Unable to allocate lun_cg->default_groups\n");
+		kfree(lun);
 		return ERR_PTR(-ENOMEM);
 	}
 
@@ -932,6 +937,7 @@ static struct config_group *target_fabric_make_lun(
 	if (!port_stat_grp->default_groups) {
 		pr_err("Unable to allocate port_stat_grp->default_groups\n");
 		kfree(lun_cg->default_groups);
+		kfree(lun);
 		return ERR_PTR(-ENOMEM);
 	}
 	target_stat_setup_port_default_groups(lun);
diff --git a/drivers/target/target_core_internal.h b/drivers/target/target_core_internal.h
index f57bb61..3627299 100644
--- a/drivers/target/target_core_internal.h
+++ b/drivers/target/target_core_internal.h
@@ -23,13 +23,13 @@ int	core_dev_export(struct se_device *, struct se_portal_group *,
 		struct se_lun *);
 void	core_dev_unexport(struct se_device *, struct se_portal_group *,
 		struct se_lun *);
-struct se_lun *core_dev_add_lun(struct se_portal_group *, struct se_device *, u32);
+int	core_dev_add_lun(struct se_portal_group *, struct se_device *,
+		struct se_lun *lun);
 void	core_dev_del_lun(struct se_portal_group *, struct se_lun *);
-struct se_lun *core_get_lun_from_tpg(struct se_portal_group *, u32);
 struct se_lun_acl *core_dev_init_initiator_node_lun_acl(struct se_portal_group *,
 		struct se_node_acl *, u32, int *);
 int	core_dev_add_initiator_node_lun_acl(struct se_portal_group *,
-		struct se_lun_acl *, u32, u32);
+		struct se_lun_acl *, struct se_lun *lun, u32);
 int	core_dev_del_initiator_node_lun_acl(struct se_portal_group *,
 		struct se_lun *, struct se_lun_acl *);
 void	core_dev_free_initiator_node_lun_acl(struct se_portal_group *,
@@ -69,6 +69,7 @@ void	core_tpg_wait_for_nacl_pr_ref(struct se_node_acl *);
 struct se_lun *core_tpg_alloc_lun(struct se_portal_group *, u32);
 int	core_tpg_add_lun(struct se_portal_group *, struct se_lun *,
 		u32, struct se_device *);
+void target_lun_callrcu(struct rcu_head *);
 void core_tpg_remove_lun(struct se_portal_group *, struct se_lun *);
 struct se_node_acl *core_tpg_add_initiator_node_acl(struct se_portal_group *tpg,
 		const char *initiatorname);
diff --git a/drivers/target/target_core_tpg.c b/drivers/target/target_core_tpg.c
index f9487e5..a256d89 100644
--- a/drivers/target/target_core_tpg.c
+++ b/drivers/target/target_core_tpg.c
@@ -124,19 +124,15 @@ void core_tpg_add_node_to_devs(
 	struct se_node_acl *acl,
 	struct se_portal_group *tpg)
 {
-	int i = 0;
 	u32 lun_access = 0;
 	struct se_lun *lun;
 	struct se_device *dev;
 
-	spin_lock(&tpg->tpg_lun_lock);
-	for (i = 0; i < TRANSPORT_MAX_LUNS_PER_TPG; i++) {
-		lun = tpg->tpg_lun_list[i];
+	mutex_lock(&tpg->tpg_lun_mutex);
+	hlist_for_each_entry_rcu(lun, &tpg->tpg_lun_hlist, link) {
 		if (lun->lun_status != TRANSPORT_LUN_STATUS_ACTIVE)
 			continue;
 
-		spin_unlock(&tpg->tpg_lun_lock);
-
 		dev = lun->lun_se_dev;
 		/*
 		 * By default in LIO-Target $FABRIC_MOD,
@@ -163,7 +159,7 @@ void core_tpg_add_node_to_devs(
 			"READ-WRITE" : "READ-ONLY");
 
 		core_enable_device_list_for_node(lun, NULL, lun->unpacked_lun,
-				lun_access, acl, tpg);
+						 lun_access, acl, tpg);
 		/*
 		 * Check to see if there are any existing persistent reservation
 		 * APTPL pre-registrations that need to be enabled for this dynamic
@@ -171,9 +167,8 @@ void core_tpg_add_node_to_devs(
 		 */
 		core_scsi3_check_aptpl_registration(dev, tpg, lun, acl,
 						    lun->unpacked_lun);
-		spin_lock(&tpg->tpg_lun_lock);
 	}
-	spin_unlock(&tpg->tpg_lun_lock);
+	mutex_unlock(&tpg->tpg_lun_mutex);
 }
 
 /*      core_set_queue_depth_for_node():
@@ -194,34 +189,6 @@ static int core_set_queue_depth_for_node(
 	return 0;
 }
 
-void array_free(void *array, int n)
-{
-	void **a = array;
-	int i;
-
-	for (i = 0; i < n; i++)
-		kfree(a[i]);
-	kfree(a);
-}
-
-static void *array_zalloc(int n, size_t size, gfp_t flags)
-{
-	void **a;
-	int i;
-
-	a = kzalloc(n * sizeof(void*), flags);
-	if (!a)
-		return NULL;
-	for (i = 0; i < n; i++) {
-		a[i] = kzalloc(size, flags);
-		if (!a[i]) {
-			array_free(a, n);
-			return NULL;
-		}
-	}
-	return a;
-}
-
 static struct se_node_acl *target_alloc_node_acl(struct se_portal_group *tpg,
 		const unsigned char *initiatorname)
 {
@@ -317,27 +284,6 @@ void core_tpg_wait_for_nacl_pr_ref(struct se_node_acl *nacl)
 		cpu_relax();
 }
 
-void core_tpg_clear_object_luns(struct se_portal_group *tpg)
-{
-	int i;
-	struct se_lun *lun;
-
-	spin_lock(&tpg->tpg_lun_lock);
-	for (i = 0; i < TRANSPORT_MAX_LUNS_PER_TPG; i++) {
-		lun = tpg->tpg_lun_list[i];
-
-		if ((lun->lun_status != TRANSPORT_LUN_STATUS_ACTIVE) ||
-		    (lun->lun_se_dev == NULL))
-			continue;
-
-		spin_unlock(&tpg->tpg_lun_lock);
-		core_dev_del_lun(tpg, lun);
-		spin_lock(&tpg->tpg_lun_lock);
-	}
-	spin_unlock(&tpg->tpg_lun_lock);
-}
-EXPORT_SYMBOL(core_tpg_clear_object_luns);
-
 struct se_node_acl *core_tpg_add_initiator_node_acl(
 	struct se_portal_group *tpg,
 	const char *initiatorname)
@@ -601,30 +547,7 @@ int core_tpg_register(
 	struct se_portal_group *se_tpg,
 	int proto_id)
 {
-	struct se_lun *lun;
-	u32 i;
-
-	se_tpg->tpg_lun_list = array_zalloc(TRANSPORT_MAX_LUNS_PER_TPG,
-			sizeof(struct se_lun), GFP_KERNEL);
-	if (!se_tpg->tpg_lun_list) {
-		pr_err("Unable to allocate struct se_portal_group->"
-				"tpg_lun_list\n");
-		return -ENOMEM;
-	}
-
-	for (i = 0; i < TRANSPORT_MAX_LUNS_PER_TPG; i++) {
-		lun = se_tpg->tpg_lun_list[i];
-		lun->unpacked_lun = i;
-		lun->lun_link_magic = SE_LUN_LINK_MAGIC;
-		lun->lun_status = TRANSPORT_LUN_STATUS_FREE;
-		atomic_set(&lun->lun_acl_count, 0);
-		init_completion(&lun->lun_shutdown_comp);
-		INIT_LIST_HEAD(&lun->lun_acl_list);
-		spin_lock_init(&lun->lun_acl_lock);
-		spin_lock_init(&lun->lun_sep_lock);
-		init_completion(&lun->lun_ref_comp);
-	}
-
+	INIT_HLIST_HEAD(&se_tpg->tpg_lun_hlist);
 	se_tpg->proto_id = proto_id;
 	se_tpg->se_tpg_tfo = tfo;
 	se_tpg->se_tpg_wwn = se_wwn;
@@ -634,14 +557,11 @@ int core_tpg_register(
 	INIT_LIST_HEAD(&se_tpg->tpg_sess_list);
 	spin_lock_init(&se_tpg->acl_node_lock);
 	spin_lock_init(&se_tpg->session_lock);
-	spin_lock_init(&se_tpg->tpg_lun_lock);
+	mutex_init(&se_tpg->tpg_lun_mutex);
 
 	if (se_tpg->proto_id >= 0) {
-		if (core_tpg_setup_virtual_lun0(se_tpg) < 0) {
-			array_free(se_tpg->tpg_lun_list,
-				   TRANSPORT_MAX_LUNS_PER_TPG);
+		if (core_tpg_setup_virtual_lun0(se_tpg) < 0)
 			return -ENOMEM;
-		}
 	}
 
 	spin_lock_bh(&tpg_lock);
@@ -696,7 +616,6 @@ int core_tpg_deregister(struct se_portal_group *se_tpg)
 	if (se_tpg->proto_id >= 0)
 		core_tpg_remove_lun(se_tpg, &se_tpg->tpg_virt_lun0);
 
-	array_free(se_tpg->tpg_lun_list, TRANSPORT_MAX_LUNS_PER_TPG);
 	return 0;
 }
 EXPORT_SYMBOL(core_tpg_deregister);
@@ -716,17 +635,20 @@ struct se_lun *core_tpg_alloc_lun(
 		return ERR_PTR(-EOVERFLOW);
 	}
 
-	spin_lock(&tpg->tpg_lun_lock);
-	lun = tpg->tpg_lun_list[unpacked_lun];
-	if (lun->lun_status == TRANSPORT_LUN_STATUS_ACTIVE) {
-		pr_err("TPG Logical Unit Number: %u is already active"
-			" on %s Target Portal Group: %u, ignoring request.\n",
-			unpacked_lun, tpg->se_tpg_tfo->get_fabric_name(),
-			tpg->se_tpg_tfo->tpg_get_tag(tpg));
-		spin_unlock(&tpg->tpg_lun_lock);
-		return ERR_PTR(-EINVAL);
+	lun = kzalloc(sizeof(*lun), GFP_KERNEL);
+	if (!lun) {
+		pr_err("Unable to allocate se_lun memory\n");
+		return ERR_PTR(-ENOMEM);
 	}
-	spin_unlock(&tpg->tpg_lun_lock);
+	lun->unpacked_lun = unpacked_lun;
+	lun->lun_link_magic = SE_LUN_LINK_MAGIC;
+	lun->lun_status = TRANSPORT_LUN_STATUS_FREE;
+	atomic_set(&lun->lun_acl_count, 0);
+	init_completion(&lun->lun_shutdown_comp);
+	INIT_LIST_HEAD(&lun->lun_acl_list);
+	spin_lock_init(&lun->lun_acl_lock);
+	spin_lock_init(&lun->lun_sep_lock);
+	init_completion(&lun->lun_ref_comp);
 
 	return lun;
 }
@@ -750,14 +672,22 @@ int core_tpg_add_lun(
 		return ret;
 	}
 
-	spin_lock(&tpg->tpg_lun_lock);
+	mutex_lock(&tpg->tpg_lun_mutex);
 	lun->lun_access = lun_access;
 	lun->lun_status = TRANSPORT_LUN_STATUS_ACTIVE;
-	spin_unlock(&tpg->tpg_lun_lock);
+	hlist_add_head_rcu(&lun->link, &tpg->tpg_lun_hlist);
+	mutex_unlock(&tpg->tpg_lun_mutex);
 
 	return 0;
 }
 
+void target_lun_callrcu(struct rcu_head *head)
+{
+	struct se_lun *lun = container_of(head, struct se_lun, rcu_head);
+
+	kfree(lun);
+}
+
 void core_tpg_remove_lun(
 	struct se_portal_group *tpg,
 	struct se_lun *lun)
@@ -767,9 +697,10 @@ void core_tpg_remove_lun(
 
 	core_dev_unexport(lun->lun_se_dev, tpg, lun);
 
-	spin_lock(&tpg->tpg_lun_lock);
+	mutex_lock(&tpg->tpg_lun_mutex);
 	lun->lun_status = TRANSPORT_LUN_STATUS_FREE;
-	spin_unlock(&tpg->tpg_lun_lock);
+	hlist_del_rcu(&lun->link);
+	mutex_unlock(&tpg->tpg_lun_mutex);
 
 	percpu_ref_exit(&lun->lun_ref);
 }
diff --git a/drivers/xen/xen-scsiback.c b/drivers/xen/xen-scsiback.c
index 8b7dd47..555033b 100644
--- a/drivers/xen/xen-scsiback.c
+++ b/drivers/xen/xen-scsiback.c
@@ -866,7 +866,8 @@ static int scsiback_add_translation_entry(struct vscsibk_info *info,
 	struct list_head *head = &(info->v2p_entry_lists);
 	unsigned long flags;
 	char *lunp;
-	unsigned int lun;
+	unsigned int unpacked_lun;
+	struct se_lun *se_lun;
 	struct scsiback_tpg *tpg_entry, *tpg = NULL;
 	char *error = "doesn't exist";
 
@@ -877,7 +878,7 @@ static int scsiback_add_translation_entry(struct vscsibk_info *info,
 	}
 	*lunp = 0;
 	lunp++;
-	if (kstrtouint(lunp, 10, &lun) || lun >= TRANSPORT_MAX_LUNS_PER_TPG) {
+	if (kstrtouint(lunp, 10, &unpacked_lun) || unpacked_lun >= TRANSPORT_MAX_LUNS_PER_TPG) {
 		pr_err("lun number not valid: %s\n", lunp);
 		return -EINVAL;
 	}
@@ -886,15 +887,17 @@ static int scsiback_add_translation_entry(struct vscsibk_info *info,
 	list_for_each_entry(tpg_entry, &scsiback_list, tv_tpg_list) {
 		if (!strcmp(phy, tpg_entry->tport->tport_name) ||
 		    !strcmp(phy, tpg_entry->param_alias)) {
-			spin_lock(&tpg_entry->se_tpg.tpg_lun_lock);
-			if (tpg_entry->se_tpg.tpg_lun_list[lun]->lun_status ==
-			    TRANSPORT_LUN_STATUS_ACTIVE) {
-				if (!tpg_entry->tpg_nexus)
-					error = "nexus undefined";
-				else
-					tpg = tpg_entry;
+			mutex_lock(&tpg_entry->se_tpg.tpg_lun_mutex);
+			hlist_for_each_entry(se_lun, &tpg_entry->se_tpg.tpg_lun_hlist, link) {
+				if (se_lun->unpacked_lun == unpacked_lun) {
+					if (!tpg_entry->tpg_nexus)
+						error = "nexus undefined";
+					else
+						tpg = tpg_entry;
+					break;
+				}
 			}
-			spin_unlock(&tpg_entry->se_tpg.tpg_lun_lock);
+			mutex_unlock(&tpg_entry->se_tpg.tpg_lun_mutex);
 			break;
 		}
 	}
@@ -906,7 +909,7 @@ static int scsiback_add_translation_entry(struct vscsibk_info *info,
 	mutex_unlock(&scsiback_mutex);
 
 	if (!tpg) {
-		pr_err("%s:%d %s\n", phy, lun, error);
+		pr_err("%s:%d %s\n", phy, unpacked_lun, error);
 		return -ENODEV;
 	}
 
@@ -934,7 +937,7 @@ static int scsiback_add_translation_entry(struct vscsibk_info *info,
 	kref_init(&new->kref);
 	new->v = *v;
 	new->tpg = tpg;
-	new->lun = lun;
+	new->lun = unpacked_lun;
 	list_add_tail(&new->l, head);
 
 out:
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index a814063..e342497 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -725,6 +725,8 @@ struct se_lun {
 	struct se_port_stat_grps port_stat_grps;
 	struct completion	lun_ref_comp;
 	struct percpu_ref	lun_ref;
+	struct hlist_node	link;
+	struct rcu_head		rcu_head;
 };
 
 struct se_dev_stat_grps {
@@ -877,11 +879,11 @@ struct se_portal_group {
 	spinlock_t		acl_node_lock;
 	/* Spinlock for adding/removing sessions */
 	spinlock_t		session_lock;
-	spinlock_t		tpg_lun_lock;
+	struct mutex		tpg_lun_mutex;
 	struct list_head	se_tpg_node;
 	/* linked list for initiator ACL list */
 	struct list_head	acl_node_list;
-	struct se_lun		**tpg_lun_list;
+	struct hlist_head	tpg_lun_hlist;
 	struct se_lun		tpg_virt_lun0;
 	/* List of TCM sessions associated wth this TPG */
 	struct list_head	tpg_sess_list;
diff --git a/include/target/target_core_fabric.h b/include/target/target_core_fabric.h
index 55654c9..b1e00a7 100644
--- a/include/target/target_core_fabric.h
+++ b/include/target/target_core_fabric.h
@@ -157,7 +157,6 @@ struct se_node_acl *core_tpg_get_initiator_node_acl(struct se_portal_group *tpg,
 		unsigned char *);
 struct se_node_acl *core_tpg_check_initiator_node_acl(struct se_portal_group *,
 		unsigned char *);
-void	core_tpg_clear_object_luns(struct se_portal_group *);
 int	core_tpg_set_initiator_node_queue_depth(struct se_portal_group *,
 		unsigned char *, u32, int);
 int	core_tpg_set_initiator_node_tag(struct se_portal_group *,
-- 
1.9.1
