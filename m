From: Andy Grover <agrover@redhat.com>
Subject: [PATCHv3 5/8] target: Change core_dev_del_lun to take a se_lun instead of unpacked_lun
Date: Mon, 30 Jun 2014 16:39:44 -0700
Message-ID: <1404171587-28845-6-git-send-email-agrover@redhat.com>
References: <1404171587-28845-1-git-send-email-agrover@redhat.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1404171587-28845-1-git-send-email-agrover@redhat.com>
Sender: target-devel-owner@vger.kernel.org
To: target-devel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, hch@lst.de, nab@linux-iscsi.org
List-Id: linux-scsi@vger.kernel.org

Remove core_tpg_pre_dellun entirely, since we don't need to get/check
a pointer we already have.

Nothing else can return an error, so core_dev_del_lun can return void.

Rename core_tpg_post_dellun to remove_lun - a clearer name, now that
pre_dellun is gone.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andy Grover <agrover@redhat.com>
---
 drivers/target/target_core_device.c          | 18 ++++----------
 drivers/target/target_core_fabric_configfs.c |  2 +-
 drivers/target/target_core_internal.h        |  5 ++--
 drivers/target/target_core_tpg.c             | 36 +++-------------------------
 4 files changed, 11 insertions(+), 50 deletions(-)

diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index 0bac890..bd467a4 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -1264,24 +1264,16 @@ struct se_lun *core_dev_add_lun(
  *
  *
  */
-int core_dev_del_lun(
+void core_dev_del_lun(
 	struct se_portal_group *tpg,
-	u32 unpacked_lun)
+	struct se_lun *lun)
 {
-	struct se_lun *lun;
-
-	lun = core_tpg_pre_dellun(tpg, unpacked_lun);
-	if (IS_ERR(lun))
-		return PTR_ERR(lun);
-
-	core_tpg_post_dellun(tpg, lun);
-
-	pr_debug("%s_TPG[%u]_LUN[%u] - Deactivated %s Logical Unit from"
+	pr_debug("%s_TPG[%u]_LUN[%u] - Deactivating %s Logical Unit from"
 		" device object\n", tpg->se_tpg_tfo->get_fabric_name(),
-		tpg->se_tpg_tfo->tpg_get_tag(tpg), unpacked_lun,
+		tpg->se_tpg_tfo->tpg_get_tag(tpg), lun->unpacked_lun,
 		tpg->se_tpg_tfo->get_fabric_name());
 
-	return 0;
+	core_tpg_remove_lun(tpg, lun);
 }
 
 struct se_lun *core_get_lun_from_tpg(struct se_portal_group *tpg, u32 unpacked_lun)
diff --git a/drivers/target/target_core_fabric_configfs.c b/drivers/target/target_core_fabric_configfs.c
index 0955c948..811b2f4 100644
--- a/drivers/target/target_core_fabric_configfs.c
+++ b/drivers/target/target_core_fabric_configfs.c
@@ -827,7 +827,7 @@ static int target_fabric_port_unlink(
 		tf->tf_ops.fabric_pre_unlink(se_tpg, lun);
 	}
 
-	core_dev_del_lun(se_tpg, lun->unpacked_lun);
+	core_dev_del_lun(se_tpg, lun);
 	return 0;
 }
 
diff --git a/drivers/target/target_core_internal.h b/drivers/target/target_core_internal.h
index 463fddc..42ef4ab 100644
--- a/drivers/target/target_core_internal.h
+++ b/drivers/target/target_core_internal.h
@@ -46,7 +46,7 @@ int	se_dev_set_fabric_max_sectors(struct se_device *, u32);
 int	se_dev_set_optimal_sectors(struct se_device *, u32);
 int	se_dev_set_block_size(struct se_device *, u32);
 struct se_lun *core_dev_add_lun(struct se_portal_group *, struct se_device *, u32);
-int	core_dev_del_lun(struct se_portal_group *, u32);
+void	core_dev_del_lun(struct se_portal_group *, struct se_lun *);
 struct se_lun *core_get_lun_from_tpg(struct se_portal_group *, u32);
 struct se_lun_acl *core_dev_init_initiator_node_lun_acl(struct se_portal_group *,
 		struct se_node_acl *, u32, int *);
@@ -82,8 +82,7 @@ void	core_tpg_wait_for_nacl_pr_ref(struct se_node_acl *);
 struct se_lun *core_tpg_alloc_lun(struct se_portal_group *, u32);
 int	core_tpg_add_lun(struct se_portal_group *, struct se_lun *,
 		u32, struct se_device *);
-struct se_lun *core_tpg_pre_dellun(struct se_portal_group *, u32 unpacked_lun);
-void core_tpg_post_dellun(struct se_portal_group *, struct se_lun *);
+void core_tpg_remove_lun(struct se_portal_group *, struct se_lun *);
 
 /* target_core_transport.c */
 extern struct kmem_cache *se_tmr_req_cache;
diff --git a/drivers/target/target_core_tpg.c b/drivers/target/target_core_tpg.c
index 321268d..5d2c774 100644
--- a/drivers/target/target_core_tpg.c
+++ b/drivers/target/target_core_tpg.c
@@ -298,7 +298,7 @@ void core_tpg_clear_object_luns(struct se_portal_group *tpg)
 			continue;
 
 		spin_unlock(&tpg->tpg_lun_lock);
-		core_dev_del_lun(tpg, lun->unpacked_lun);
+		core_dev_del_lun(tpg, lun);
 		spin_lock(&tpg->tpg_lun_lock);
 	}
 	spin_unlock(&tpg->tpg_lun_lock);
@@ -625,7 +625,7 @@ static void core_tpg_release_virtual_lun0(struct se_portal_group *se_tpg)
 {
 	struct se_lun *lun = &se_tpg->tpg_virt_lun0;
 
-	core_tpg_post_dellun(se_tpg, lun);
+	core_tpg_remove_lun(se_tpg, lun);
 }
 
 int core_tpg_register(
@@ -795,37 +795,7 @@ int core_tpg_add_lun(
 	return 0;
 }
 
-struct se_lun *core_tpg_pre_dellun(
-	struct se_portal_group *tpg,
-	u32 unpacked_lun)
-{
-	struct se_lun *lun;
-
-	if (unpacked_lun > (TRANSPORT_MAX_LUNS_PER_TPG-1)) {
-		pr_err("%s LUN: %u exceeds TRANSPORT_MAX_LUNS_PER_TPG"
-			"-1: %u for Target Portal Group: %u\n",
-			tpg->se_tpg_tfo->get_fabric_name(), unpacked_lun,
-			TRANSPORT_MAX_LUNS_PER_TPG-1,
-			tpg->se_tpg_tfo->tpg_get_tag(tpg));
-		return ERR_PTR(-EOVERFLOW);
-	}
-
-	spin_lock(&tpg->tpg_lun_lock);
-	lun = tpg->tpg_lun_list[unpacked_lun];
-	if (lun->lun_status != TRANSPORT_LUN_STATUS_ACTIVE) {
-		pr_err("%s Logical Unit Number: %u is not active on"
-			" Target Portal Group: %u, ignoring request.\n",
-			tpg->se_tpg_tfo->get_fabric_name(), unpacked_lun,
-			tpg->se_tpg_tfo->tpg_get_tag(tpg));
-		spin_unlock(&tpg->tpg_lun_lock);
-		return ERR_PTR(-ENODEV);
-	}
-	spin_unlock(&tpg->tpg_lun_lock);
-
-	return lun;
-}
-
-void core_tpg_post_dellun(
+void core_tpg_remove_lun(
 	struct se_portal_group *tpg,
 	struct se_lun *lun)
 {
-- 
1.9.3
