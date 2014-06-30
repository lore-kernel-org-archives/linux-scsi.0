From: Andy Grover <agrover@redhat.com>
Subject: [PATCHv3 6/8] target: Allocate se_luns only when used
Date: Mon, 30 Jun 2014 16:39:45 -0700
Message-ID: <1404171587-28845-7-git-send-email-agrover@redhat.com>
References: <1404171587-28845-1-git-send-email-agrover@redhat.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1404171587-28845-1-git-send-email-agrover@redhat.com>
Sender: target-devel-owner@vger.kernel.org
To: target-devel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, hch@lst.de, nab@linux-iscsi.org
List-Id: linux-scsi@vger.kernel.org

Instead of allocating the tpg_lun_list and each member of the list when
the tpg is created, make the list part of the parent struct, and use an
element being non-NULL to indicate an active LUN. This will save memory
if less than all the se_luns are actually configured.

Now that things are actually getting freed, split out core_tpg_free_lun
from core_tpg_remove_lun, because we don't want to free() the statically-
allocated virtual_lun0.

Remove array_free and array_zalloc.

Remove core_get_lun_from_tpg.

Change core_dev_add_lun to take a se_lun and return int

Do not allocate tpg_lun_list, put it directly in se_portal_group.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andy Grover <agrover@redhat.com>
---
 drivers/target/sbp/sbp_target.c              |   6 +-
 drivers/target/target_core_device.c          |  43 ++----------
 drivers/target/target_core_fabric_configfs.c |  21 +++---
 drivers/target/target_core_internal.h        |   4 +-
 drivers/target/target_core_tpg.c             | 101 +++++++++------------------
 include/target/target_core_base.h            |  10 +--
 6 files changed, 54 insertions(+), 131 deletions(-)

diff --git a/drivers/target/sbp/sbp_target.c b/drivers/target/sbp/sbp_target.c
index e7e9372..62b9d47 100644
--- a/drivers/target/sbp/sbp_target.c
+++ b/drivers/target/sbp/sbp_target.c
@@ -187,7 +187,7 @@ static struct se_lun *sbp_get_lun_from_tpg(struct sbp_tpg *tpg, int lun)
 	spin_lock(&se_tpg->tpg_lun_lock);
 	se_lun = se_tpg->tpg_lun_list[lun];
 
-	if (se_lun->lun_status != TRANSPORT_LUN_STATUS_ACTIVE)
+	if (!se_lun)
 		se_lun = ERR_PTR(-ENODEV);
 
 	spin_unlock(&se_tpg->tpg_lun_lock);
@@ -1947,7 +1947,7 @@ static int sbp_count_se_tpg_luns(struct se_portal_group *tpg)
 	for (i = 0; i < TRANSPORT_MAX_LUNS_PER_TPG; i++) {
 		struct se_lun *se_lun = tpg->tpg_lun_list[i];
 
-		if (se_lun->lun_status == TRANSPORT_LUN_STATUS_FREE)
+		if (!se_lun)
 			continue;
 
 		count++;
@@ -2027,7 +2027,7 @@ static int sbp_update_unit_directory(struct sbp_tport *tport)
 		struct se_device *dev;
 		int type;
 
-		if (se_lun->lun_status == TRANSPORT_LUN_STATUS_FREE)
+		if (!se_lun)
 			continue;
 
 		spin_unlock(&tport->tpg->se_tpg.tpg_lun_lock);
diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index bd467a4..4b8149b 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -1217,22 +1217,17 @@ int se_dev_set_block_size(struct se_device *dev, u32 block_size)
 	return 0;
 }
 
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
@@ -1257,7 +1252,7 @@ struct se_lun *core_dev_add_lun(
 		spin_unlock_irq(&tpg->acl_node_lock);
 	}
 
-	return lun;
+	return rc;
 }
 
 /*      core_dev_del_lun():
@@ -1274,35 +1269,7 @@ void core_dev_del_lun(
 		tpg->se_tpg_tfo->get_fabric_name());
 
 	core_tpg_remove_lun(tpg, lun);
-}
-
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
+	core_tpg_free_lun(tpg, lun);
 }
 
 struct se_lun_acl *core_dev_init_initiator_node_lun_acl(
diff --git a/drivers/target/target_core_fabric_configfs.c b/drivers/target/target_core_fabric_configfs.c
index 811b2f4..95c1cd5 100644
--- a/drivers/target/target_core_fabric_configfs.c
+++ b/drivers/target/target_core_fabric_configfs.c
@@ -760,7 +760,6 @@ static int target_fabric_port_link(
 	struct config_item *tpg_ci;
 	struct se_lun *lun = container_of(to_config_group(lun_ci),
 				struct se_lun, lun_group);
-	struct se_lun *lun_p;
 	struct se_portal_group *se_tpg;
 	struct se_device *dev =
 		container_of(to_config_group(se_dev_ci), struct se_device, dev_group);
@@ -788,11 +787,10 @@ static int target_fabric_port_link(
 		return -EEXIST;
 	}
 
-	lun_p = core_dev_add_lun(se_tpg, dev, lun->unpacked_lun);
-	if (IS_ERR(lun_p)) {
+	ret = core_dev_add_lun(se_tpg, dev, lun);
+	if (ret < 0) {
 		pr_err("core_dev_add_lun() failed\n");
-		ret = PTR_ERR(lun_p);
-		goto out;
+		return ret;
 	}
 
 	if (tf->tf_ops.fabric_post_link) {
@@ -805,8 +803,6 @@ static int target_fabric_port_link(
 	}
 
 	return 0;
-out:
-	return ret;
 }
 
 static int target_fabric_port_unlink(
@@ -892,16 +888,17 @@ static struct config_group *target_fabric_make_lun(
 	if (unpacked_lun > UINT_MAX)
 		return ERR_PTR(-EINVAL);
 
-	lun = core_get_lun_from_tpg(se_tpg, unpacked_lun);
-	if (!lun)
-		return ERR_PTR(-EINVAL);
+	lun = core_tpg_alloc_lun(se_tpg, unpacked_lun);
+	if (IS_ERR(lun))
+		return ERR_CAST(lun);
 
 	lun_cg = &lun->lun_group;
 	lun_cg->default_groups = kmalloc(sizeof(struct config_group *) * 2,
 				GFP_KERNEL);
 	if (!lun_cg->default_groups) {
 		pr_err("Unable to allocate lun_cg->default_groups\n");
-		return ERR_PTR(-ENOMEM);
+		errno = -ENOMEM;
+		goto out;
 	}
 
 	config_group_init_type_name(&lun->lun_group, name,
@@ -923,6 +920,8 @@ static struct config_group *target_fabric_make_lun(
 
 	return &lun->lun_group;
 out:
+	if (lun)
+		core_tpg_free_lun(se_tpg, lun);
 	if (lun_cg)
 		kfree(lun_cg->default_groups);
 	return ERR_PTR(errno);
diff --git a/drivers/target/target_core_internal.h b/drivers/target/target_core_internal.h
index 42ef4ab..4f3e6d5 100644
--- a/drivers/target/target_core_internal.h
+++ b/drivers/target/target_core_internal.h
@@ -45,9 +45,8 @@ int	se_dev_set_max_sectors(struct se_device *, u32);
 int	se_dev_set_fabric_max_sectors(struct se_device *, u32);
 int	se_dev_set_optimal_sectors(struct se_device *, u32);
 int	se_dev_set_block_size(struct se_device *, u32);
-struct se_lun *core_dev_add_lun(struct se_portal_group *, struct se_device *, u32);
+int	core_dev_add_lun(struct se_portal_group *, struct se_device *, struct se_lun *);
 void	core_dev_del_lun(struct se_portal_group *, struct se_lun *);
-struct se_lun *core_get_lun_from_tpg(struct se_portal_group *, u32);
 struct se_lun_acl *core_dev_init_initiator_node_lun_acl(struct se_portal_group *,
 		struct se_node_acl *, u32, int *);
 int	core_dev_add_initiator_node_lun_acl(struct se_portal_group *,
@@ -83,6 +82,7 @@ struct se_lun *core_tpg_alloc_lun(struct se_portal_group *, u32);
 int	core_tpg_add_lun(struct se_portal_group *, struct se_lun *,
 		u32, struct se_device *);
 void core_tpg_remove_lun(struct se_portal_group *, struct se_lun *);
+void core_tpg_free_lun(struct se_portal_group *, struct se_lun *);
 
 /* target_core_transport.c */
 extern struct kmem_cache *se_tmr_req_cache;
diff --git a/drivers/target/target_core_tpg.c b/drivers/target/target_core_tpg.c
index 5d2c774..a63a3d7 100644
--- a/drivers/target/target_core_tpg.c
+++ b/drivers/target/target_core_tpg.c
@@ -134,7 +134,7 @@ void core_tpg_add_node_to_devs(
 	spin_lock(&tpg->tpg_lun_lock);
 	for (i = 0; i < TRANSPORT_MAX_LUNS_PER_TPG; i++) {
 		lun = tpg->tpg_lun_list[i];
-		if (lun->lun_status != TRANSPORT_LUN_STATUS_ACTIVE)
+		if (!lun)
 			continue;
 
 		dev = lun->lun_se_dev;
@@ -186,34 +186,6 @@ static int core_set_queue_depth_for_node(
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
 /*	core_tpg_check_initiator_node_acl()
  *
  *
@@ -293,8 +265,7 @@ void core_tpg_clear_object_luns(struct se_portal_group *tpg)
 	for (i = 0; i < TRANSPORT_MAX_LUNS_PER_TPG; i++) {
 		lun = tpg->tpg_lun_list[i];
 
-		if ((lun->lun_status != TRANSPORT_LUN_STATUS_ACTIVE) ||
-		    (lun->lun_se_dev == NULL))
+		if ((!lun) || (lun->lun_se_dev == NULL))
 			continue;
 
 		spin_unlock(&tpg->tpg_lun_lock);
@@ -606,7 +577,6 @@ static int core_tpg_setup_virtual_lun0(struct se_portal_group *se_tpg)
 	int ret;
 
 	lun->unpacked_lun = 0;
-	lun->lun_status = TRANSPORT_LUN_STATUS_FREE;
 	atomic_set(&lun->lun_acl_count, 0);
 	init_completion(&lun->lun_shutdown_comp);
 	INIT_LIST_HEAD(&lun->lun_acl_list);
@@ -635,30 +605,6 @@ int core_tpg_register(
 	void *tpg_fabric_ptr,
 	int se_tpg_type)
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
 	se_tpg->se_tpg_type = se_tpg_type;
 	se_tpg->se_tpg_fabric_ptr = tpg_fabric_ptr;
 	se_tpg->se_tpg_tfo = tfo;
@@ -671,13 +617,9 @@ int core_tpg_register(
 	spin_lock_init(&se_tpg->session_lock);
 	spin_lock_init(&se_tpg->tpg_lun_lock);
 
-	if (se_tpg->se_tpg_type == TRANSPORT_TPG_TYPE_NORMAL) {
-		if (core_tpg_setup_virtual_lun0(se_tpg) < 0) {
-			array_free(se_tpg->tpg_lun_list,
-				   TRANSPORT_MAX_LUNS_PER_TPG);
+	if (se_tpg->se_tpg_type == TRANSPORT_TPG_TYPE_NORMAL)
+		if (core_tpg_setup_virtual_lun0(se_tpg) < 0)
 			return -ENOMEM;
-		}
-	}
 
 	spin_lock_bh(&tpg_lock);
 	list_add_tail(&se_tpg->se_tpg_node, &tpg_list);
@@ -734,7 +676,7 @@ int core_tpg_deregister(struct se_portal_group *se_tpg)
 		core_tpg_release_virtual_lun0(se_tpg);
 
 	se_tpg->se_tpg_fabric_ptr = NULL;
-	array_free(se_tpg->tpg_lun_list, TRANSPORT_MAX_LUNS_PER_TPG);
+
 	return 0;
 }
 EXPORT_SYMBOL(core_tpg_deregister);
@@ -743,7 +685,7 @@ struct se_lun *core_tpg_alloc_lun(
 	struct se_portal_group *tpg,
 	u32 unpacked_lun)
 {
-	struct se_lun *lun;
+	struct se_lun *lun, *new_lun;
 
 	if (unpacked_lun > (TRANSPORT_MAX_LUNS_PER_TPG-1)) {
 		pr_err("%s LUN: %u exceeds TRANSPORT_MAX_LUNS_PER_TPG"
@@ -754,9 +696,14 @@ struct se_lun *core_tpg_alloc_lun(
 		return ERR_PTR(-EOVERFLOW);
 	}
 
+	new_lun = kzalloc(sizeof(*lun), GFP_KERNEL);
+	if (!new_lun)
+		return ERR_PTR(-ENOMEM);
+
 	spin_lock(&tpg->tpg_lun_lock);
 	lun = tpg->tpg_lun_list[unpacked_lun];
-	if (lun->lun_status == TRANSPORT_LUN_STATUS_ACTIVE) {
+	if (lun) {
+		kfree(new_lun);
 		pr_err("TPG Logical Unit Number: %u is already active"
 			" on %s Target Portal Group: %u, ignoring request.\n",
 			unpacked_lun, tpg->se_tpg_tfo->get_fabric_name(),
@@ -764,9 +711,21 @@ struct se_lun *core_tpg_alloc_lun(
 		spin_unlock(&tpg->tpg_lun_lock);
 		return ERR_PTR(-EINVAL);
 	}
+
+	new_lun->unpacked_lun = unpacked_lun;
+	new_lun->lun_link_magic = SE_LUN_LINK_MAGIC;
+	atomic_set(&new_lun->lun_acl_count, 0);
+	init_completion(&new_lun->lun_shutdown_comp);
+	INIT_LIST_HEAD(&new_lun->lun_acl_list);
+	spin_lock_init(&new_lun->lun_acl_lock);
+	spin_lock_init(&new_lun->lun_sep_lock);
+	init_completion(&new_lun->lun_ref_comp);
+
+	tpg->tpg_lun_list[unpacked_lun] = new_lun;
+
 	spin_unlock(&tpg->tpg_lun_lock);
 
-	return lun;
+	return new_lun;
 }
 
 int core_tpg_add_lun(
@@ -789,7 +748,6 @@ int core_tpg_add_lun(
 
 	spin_lock(&tpg->tpg_lun_lock);
 	lun->lun_access = lun_access;
-	lun->lun_status = TRANSPORT_LUN_STATUS_ACTIVE;
 	spin_unlock(&tpg->tpg_lun_lock);
 
 	return 0;
@@ -802,8 +760,15 @@ void core_tpg_remove_lun(
 	core_clear_lun_from_tpg(lun, tpg);
 	transport_clear_lun_ref(lun);
 	core_dev_unexport(lun->lun_se_dev, tpg, lun);
+}
 
+void core_tpg_free_lun(
+	struct se_portal_group *tpg,
+	struct se_lun *lun)
+{
 	spin_lock(&tpg->tpg_lun_lock);
-	lun->lun_status = TRANSPORT_LUN_STATUS_FREE;
+	tpg->tpg_lun_list[lun->unpacked_lun] = NULL;
 	spin_unlock(&tpg->tpg_lun_lock);
+
+	kfree(lun);
 }
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index f3761da..e7b3d57 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -125,12 +125,6 @@ enum hba_flags_table {
 	HBA_FLAGS_PSCSI_MODE	= 0x02,
 };
 
-/* struct se_lun->lun_status */
-enum transport_lun_status_table {
-	TRANSPORT_LUN_STATUS_FREE = 0,
-	TRANSPORT_LUN_STATUS_ACTIVE = 1,
-};
-
 /* struct se_portal_group->se_tpg_type */
 enum transport_tpg_type_table {
 	TRANSPORT_TPG_TYPE_NORMAL = 0,
@@ -708,8 +702,6 @@ struct se_port_stat_grps {
 struct se_lun {
 #define SE_LUN_LINK_MAGIC			0xffff7771
 	u32			lun_link_magic;
-	/* See transport_lun_status_table */
-	enum transport_lun_status_table lun_status;
 	u32			lun_access;
 	u32			lun_flags;
 	u32			unpacked_lun;
@@ -878,7 +870,7 @@ struct se_portal_group {
 	struct list_head	se_tpg_node;
 	/* linked list for initiator ACL list */
 	struct list_head	acl_node_list;
-	struct se_lun		**tpg_lun_list;
+	struct se_lun		*tpg_lun_list[TRANSPORT_MAX_LUNS_PER_TPG];
 	struct se_lun		tpg_virt_lun0;
 	/* List of TCM sessions associated wth this TPG */
 	struct list_head	tpg_sess_list;
-- 
1.9.3
