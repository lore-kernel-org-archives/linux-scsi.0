From: Andy Grover <agrover@redhat.com>
Subject: [PATCH 1/3] target: Remove TRANSPORT_LUNFLAGS_READ_WRITE
Date: Thu, 13 Nov 2014 12:50:56 -0800
Message-ID: <1415911858-3123-1-git-send-email-agrover@redhat.com>
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: target-devel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, hch@lst.de, nab@linux-iscsi.org
List-Id: linux-scsi@vger.kernel.org

LUNFLAGS_READ_WRITE is always the inverse of LUNFLAGS_READ_ONLY.

Removing this enum value resulted in some spots where a parameter's value
can be just true or false, which we can represent with a bool instead of
u32. Change to a bool named "lun_access_ro".

Signed-off-by: Andy Grover <agrover@redhat.com>
---
 drivers/target/target_core_device.c          | 46 ++++++++++------------------
 drivers/target/target_core_fabric_configfs.c | 18 +++++------
 drivers/target/target_core_internal.h        |  6 ++--
 drivers/target/target_core_tpg.c             | 16 +++++-----
 include/target/target_core_base.h            |  1 -
 5 files changed, 34 insertions(+), 53 deletions(-)

diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index c45f9e9..f32a02d 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -275,20 +275,17 @@ int core_free_device_list_for_node(
 
 void core_update_device_list_access(
 	u32 mapped_lun,
-	u32 lun_access,
+	bool lun_access_ro,
 	struct se_node_acl *nacl)
 {
 	struct se_dev_entry *deve;
 
 	spin_lock_irq(&nacl->device_list_lock);
 	deve = nacl->device_list[mapped_lun];
-	if (lun_access & TRANSPORT_LUNFLAGS_READ_WRITE) {
-		deve->lun_flags &= ~TRANSPORT_LUNFLAGS_READ_ONLY;
-		deve->lun_flags |= TRANSPORT_LUNFLAGS_READ_WRITE;
-	} else {
-		deve->lun_flags &= ~TRANSPORT_LUNFLAGS_READ_WRITE;
+	if (lun_access_ro)
 		deve->lun_flags |= TRANSPORT_LUNFLAGS_READ_ONLY;
-	}
+	else
+		deve->lun_flags &= ~TRANSPORT_LUNFLAGS_READ_ONLY;
 	spin_unlock_irq(&nacl->device_list_lock);
 }
 
@@ -300,7 +297,7 @@ int core_enable_device_list_for_node(
 	struct se_lun *lun,
 	struct se_lun_acl *lun_acl,
 	u32 mapped_lun,
-	u32 lun_access,
+	bool lun_access_ro,
 	struct se_node_acl *nacl,
 	struct se_portal_group *tpg)
 {
@@ -333,13 +330,10 @@ int core_enable_device_list_for_node(
 		}
 		deve->se_lun_acl = lun_acl;
 
-		if (lun_access & TRANSPORT_LUNFLAGS_READ_WRITE) {
-			deve->lun_flags &= ~TRANSPORT_LUNFLAGS_READ_ONLY;
-			deve->lun_flags |= TRANSPORT_LUNFLAGS_READ_WRITE;
-		} else {
-			deve->lun_flags &= ~TRANSPORT_LUNFLAGS_READ_WRITE;
+		if (lun_access_ro)
 			deve->lun_flags |= TRANSPORT_LUNFLAGS_READ_ONLY;
-		}
+		else
+			deve->lun_flags &= ~TRANSPORT_LUNFLAGS_READ_ONLY;
 
 		spin_unlock_irq(&nacl->device_list_lock);
 		return 0;
@@ -350,13 +344,10 @@ int core_enable_device_list_for_node(
 	deve->mapped_lun = mapped_lun;
 	deve->lun_flags |= TRANSPORT_LUNFLAGS_INITIATOR_ACCESS;
 
-	if (lun_access & TRANSPORT_LUNFLAGS_READ_WRITE) {
-		deve->lun_flags &= ~TRANSPORT_LUNFLAGS_READ_ONLY;
-		deve->lun_flags |= TRANSPORT_LUNFLAGS_READ_WRITE;
-	} else {
-		deve->lun_flags &= ~TRANSPORT_LUNFLAGS_READ_WRITE;
+	if (lun_access_ro)
 		deve->lun_flags |= TRANSPORT_LUNFLAGS_READ_ONLY;
-	}
+	else
+		deve->lun_flags &= ~TRANSPORT_LUNFLAGS_READ_ONLY;
 
 	deve->creation_time = get_jiffies_64();
 	deve->attach_count++;
@@ -1231,8 +1222,7 @@ struct se_lun *core_dev_add_lun(
 	if (IS_ERR(lun))
 		return lun;
 
-	rc = core_tpg_add_lun(tpg, lun,
-				TRANSPORT_LUNFLAGS_READ_WRITE, dev);
+	rc = core_tpg_add_lun(tpg, lun, false, dev);
 	if (rc < 0)
 		return ERR_PTR(rc);
 
@@ -1374,7 +1364,7 @@ int core_dev_add_initiator_node_lun_acl(
 	struct se_portal_group *tpg,
 	struct se_lun_acl *lacl,
 	u32 unpacked_lun,
-	u32 lun_access)
+	bool lun_access_ro)
 {
 	struct se_lun *lun;
 	struct se_node_acl *nacl;
@@ -1392,14 +1382,13 @@ int core_dev_add_initiator_node_lun_acl(
 	if (!nacl)
 		return -EINVAL;
 
-	if ((lun->lun_access & TRANSPORT_LUNFLAGS_READ_ONLY) &&
-	    (lun_access & TRANSPORT_LUNFLAGS_READ_WRITE))
-		lun_access = TRANSPORT_LUNFLAGS_READ_ONLY;
+	if (lun->lun_access & TRANSPORT_LUNFLAGS_READ_ONLY)
+	    lun_access_ro = true;
 
 	lacl->se_lun = lun;
 
 	if (core_enable_device_list_for_node(lun, lacl, lacl->mapped_lun,
-			lun_access, nacl, tpg) < 0)
+			lun_access_ro, nacl, tpg) < 0)
 		return -EINVAL;
 
 	spin_lock(&lun->lun_acl_lock);
@@ -1410,8 +1399,7 @@ int core_dev_add_initiator_node_lun_acl(
 	pr_debug("%s_TPG[%hu]_LUN[%u->%u] - Added %s ACL for "
 		" InitiatorNode: %s\n", tpg->se_tpg_tfo->get_fabric_name(),
 		tpg->se_tpg_tfo->tpg_get_tag(tpg), unpacked_lun, lacl->mapped_lun,
-		(lun_access & TRANSPORT_LUNFLAGS_READ_WRITE) ? "RW" : "RO",
-		lacl->initiatorname);
+		lun_access_ro ? "RO" : "RW", lacl->initiatorname);
 	/*
 	 * Check to see if there are any existing persistent reservation APTPL
 	 * pre-registrations that need to be enabled for this LUN ACL..
diff --git a/drivers/target/target_core_fabric_configfs.c b/drivers/target/target_core_fabric_configfs.c
index 0c3f901..8a5d735 100644
--- a/drivers/target/target_core_fabric_configfs.c
+++ b/drivers/target/target_core_fabric_configfs.c
@@ -69,7 +69,8 @@ static int target_fabric_mappedlun_link(
 			struct se_lun_acl, se_lun_group);
 	struct se_portal_group *se_tpg;
 	struct config_item *nacl_ci, *tpg_ci, *tpg_ci_s, *wwn_ci, *wwn_ci_s;
-	int ret = 0, lun_access;
+	int ret = 0;
+	bool lun_access_ro;
 
 	if (lun->lun_link_magic != SE_LUN_LINK_MAGIC) {
 		pr_err("Bad lun->lun_link_magic, not a valid lun_ci pointer:"
@@ -114,12 +115,10 @@ static int target_fabric_mappedlun_link(
 	spin_lock_irq(&lacl->se_lun_nacl->device_list_lock);
 	deve = lacl->se_lun_nacl->device_list[lacl->mapped_lun];
 	if (deve->lun_flags & TRANSPORT_LUNFLAGS_INITIATOR_ACCESS)
-		lun_access = deve->lun_flags;
+		lun_access_ro = (deve->lun_flags & TRANSPORT_LUNFLAGS_READ_ONLY);
 	else
-		lun_access =
-			(se_tpg->se_tpg_tfo->tpg_check_prod_mode_write_protect(
-				se_tpg)) ? TRANSPORT_LUNFLAGS_READ_ONLY :
-					   TRANSPORT_LUNFLAGS_READ_WRITE;
+		lun_access_ro = se_tpg->se_tpg_tfo->tpg_check_prod_mode_write_protect(
+			se_tpg);
 	spin_unlock_irq(&lacl->se_lun_nacl->device_list_lock);
 	/*
 	 * Determine the actual mapped LUN value user wants..
@@ -128,7 +127,7 @@ static int target_fabric_mappedlun_link(
 	 * iscsi/$IQN/$TPGT/lun/lun_* as on their SCSI Initiator Ports.
 	 */
 	ret = core_dev_add_initiator_node_lun_acl(se_tpg, lacl,
-			lun->unpacked_lun, lun_access);
+			lun->unpacked_lun, lun_access_ro);
 
 	return (ret < 0) ? -EINVAL : 0;
 }
@@ -198,10 +197,7 @@ static ssize_t target_fabric_mappedlun_store_write_protect(
 	if ((op != 1) && (op != 0))
 		return -EINVAL;
 
-	core_update_device_list_access(lacl->mapped_lun, (op) ?
-			TRANSPORT_LUNFLAGS_READ_ONLY :
-			TRANSPORT_LUNFLAGS_READ_WRITE,
-			lacl->se_lun_nacl);
+	core_update_device_list_access(lacl->mapped_lun, op, lacl->se_lun_nacl);
 
 	pr_debug("%s_ConfigFS: Changed Initiator ACL: %s"
 		" Mapped LUN: %u Write Protect bit to %s\n",
diff --git a/drivers/target/target_core_internal.h b/drivers/target/target_core_internal.h
index e31f42f..2aab22b 100644
--- a/drivers/target/target_core_internal.h
+++ b/drivers/target/target_core_internal.h
@@ -8,9 +8,9 @@ extern struct t10_alua_lu_gp *default_lu_gp;
 struct se_dev_entry *core_get_se_deve_from_rtpi(struct se_node_acl *, u16);
 int	core_free_device_list_for_node(struct se_node_acl *,
 		struct se_portal_group *);
-void	core_update_device_list_access(u32, u32, struct se_node_acl *);
+void	core_update_device_list_access(u32, bool, struct se_node_acl *);
 int	core_enable_device_list_for_node(struct se_lun *, struct se_lun_acl *,
-		u32, u32, struct se_node_acl *, struct se_portal_group *);
+		u32, bool, struct se_node_acl *, struct se_portal_group *);
 int	core_disable_device_list_for_node(struct se_lun *, struct se_lun_acl *,
 		u32, u32, struct se_node_acl *, struct se_portal_group *);
 void	core_clear_lun_from_tpg(struct se_lun *, struct se_portal_group *);
@@ -52,7 +52,7 @@ struct se_lun *core_get_lun_from_tpg(struct se_portal_group *, u32);
 struct se_lun_acl *core_dev_init_initiator_node_lun_acl(struct se_portal_group *,
 		struct se_node_acl *, u32, int *);
 int	core_dev_add_initiator_node_lun_acl(struct se_portal_group *,
-		struct se_lun_acl *, u32, u32);
+		struct se_lun_acl *, u32, bool);
 int	core_dev_del_initiator_node_lun_acl(struct se_portal_group *,
 		struct se_lun *, struct se_lun_acl *);
 void	core_dev_free_initiator_node_lun_acl(struct se_portal_group *,
diff --git a/drivers/target/target_core_tpg.c b/drivers/target/target_core_tpg.c
index 0696de9..da21294 100644
--- a/drivers/target/target_core_tpg.c
+++ b/drivers/target/target_core_tpg.c
@@ -128,7 +128,7 @@ void core_tpg_add_node_to_devs(
 	struct se_portal_group *tpg)
 {
 	int i = 0;
-	u32 lun_access = 0;
+	bool lun_access_ro = true;
 	struct se_lun *lun;
 	struct se_device *dev;
 
@@ -146,27 +146,26 @@ void core_tpg_add_node_to_devs(
 		 * demo_mode_write_protect is ON, or READ_ONLY;
 		 */
 		if (!tpg->se_tpg_tfo->tpg_check_demo_mode_write_protect(tpg)) {
-			lun_access = TRANSPORT_LUNFLAGS_READ_WRITE;
+			lun_access_ro = false;
 		} else {
 			/*
 			 * Allow only optical drives to issue R/W in default RO
 			 * demo mode.
 			 */
 			if (dev->transport->get_device_type(dev) == TYPE_DISK)
-				lun_access = TRANSPORT_LUNFLAGS_READ_ONLY;
+				lun_access_ro = true;
 			else
-				lun_access = TRANSPORT_LUNFLAGS_READ_WRITE;
+				lun_access_ro = false;
 		}
 
 		pr_debug("TARGET_CORE[%s]->TPG[%u]_LUN[%u] - Adding %s"
 			" access for LUN in Demo Mode\n",
 			tpg->se_tpg_tfo->get_fabric_name(),
 			tpg->se_tpg_tfo->tpg_get_tag(tpg), lun->unpacked_lun,
-			(lun_access == TRANSPORT_LUNFLAGS_READ_WRITE) ?
-			"READ-WRITE" : "READ-ONLY");
+			lun_access_ro ? "RO" : "RW");
 
 		core_enable_device_list_for_node(lun, NULL, lun->unpacked_lun,
-				lun_access, acl, tpg);
+				lun_access_ro, acl, tpg);
 		/*
 		 * Check to see if there are any existing persistent reservation
 		 * APTPL pre-registrations that need to be enabled for this dynamic
@@ -652,7 +651,6 @@ static int core_tpg_setup_virtual_lun0(struct se_portal_group *se_tpg)
 	/* Set in core_dev_setup_virtual_lun0() */
 	struct se_device *dev = g_lun0_dev;
 	struct se_lun *lun = &se_tpg->tpg_virt_lun0;
-	u32 lun_access = TRANSPORT_LUNFLAGS_READ_ONLY;
 	int ret;
 
 	lun->unpacked_lun = 0;
@@ -664,7 +662,7 @@ static int core_tpg_setup_virtual_lun0(struct se_portal_group *se_tpg)
 	spin_lock_init(&lun->lun_sep_lock);
 	init_completion(&lun->lun_ref_comp);
 
-	ret = core_tpg_add_lun(se_tpg, lun, lun_access, dev);
+	ret = core_tpg_add_lun(se_tpg, lun, true, dev);
 	if (ret < 0)
 		return ret;
 
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index 23c518a..1a3aa44 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -178,7 +178,6 @@ enum transport_lunflags_table {
 	TRANSPORT_LUNFLAGS_NO_ACCESS		= 0x00,
 	TRANSPORT_LUNFLAGS_INITIATOR_ACCESS	= 0x01,
 	TRANSPORT_LUNFLAGS_READ_ONLY		= 0x02,
-	TRANSPORT_LUNFLAGS_READ_WRITE		= 0x04,
 };
 
 /*
-- 
1.9.3
