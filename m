From: Andy Grover <agrover@redhat.com>
Subject: [PATCHv2 RESENDv2 5/9] target: Change core_dev_del_lun to take a se_lun instead of unpacked_lun
Date: Mon, 23 Jun 2014 16:55:34 -0700
Message-ID: <1403567738-13310-6-git-send-email-agrover@redhat.com>
References: <1403567738-13310-1-git-send-email-agrover@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:9334 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754344AbaFWXzr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 23 Jun 2014 19:55:47 -0400
In-Reply-To: <1403567738-13310-1-git-send-email-agrover@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, hch@lst.de, nab@linux-iscsi.org

Remove core_tpg_pre_dellun entirely, since we don't need to get/check
a pointer we already have.

Nothing else can return an error, so core_dev_del_lun can return void.

Signed-off-by: Andy Grover <agrover@redhat.com>
---
 drivers/target/target_core_device.c          | 18 +++++-----------
 drivers/target/target_core_fabric_configfs.c |  2 +-
 drivers/target/target_core_internal.h        |  3 +--
 drivers/target/target_core_tpg.c             | 32 +---------------------------
 4 files changed, 8 insertions(+), 47 deletions(-)

diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index c5ed8f8..c90d118 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -1261,24 +1261,16 @@ struct se_lun *core_dev_add_lun(
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
+	core_tpg_post_dellun(tpg, lun);
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
index 463fddc..22c4261 100644
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
@@ -82,7 +82,6 @@ void	core_tpg_wait_for_nacl_pr_ref(struct se_node_acl *);
 struct se_lun *core_tpg_alloc_lun(struct se_portal_group *, u32);
 int	core_tpg_add_lun(struct se_portal_group *, struct se_lun *,
 		u32, struct se_device *);
-struct se_lun *core_tpg_pre_dellun(struct se_portal_group *, u32 unpacked_lun);
 void core_tpg_post_dellun(struct se_portal_group *, struct se_lun *);
 
 /* target_core_transport.c */
diff --git a/drivers/target/target_core_tpg.c b/drivers/target/target_core_tpg.c
index 321268d..b50d667 100644
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
@@ -795,36 +795,6 @@ int core_tpg_add_lun(
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
 void core_tpg_post_dellun(
 	struct se_portal_group *tpg,
 	struct se_lun *lun)
-- 
1.9.3

