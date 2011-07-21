From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 018/103] target: Remove struct se_global
Date: Thu, 21 Jul 2011 00:04:54 -0700
Message-ID: <1311231979-6631-19-git-send-email-nab@linux-iscsi.org>
References: <1311231979-6631-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nm29-vm0.bullet.mail.bf1.yahoo.com ([98.139.213.166]:30226 "HELO
	nm29-vm0.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752100Ab1GUHGB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 21 Jul 2011 03:06:01 -0400
In-Reply-To: <1311231979-6631-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Andy Grover <agrover@redhat.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>

From: Andy Grover <agrover@redhat.com>

Much of what was in se_global was actually only used by one source file,
so those variables could be taken out of se_global and made static in that
file.

Removed unneeded g_ prefixes from variables affected.

Renamed struct list_heads that were there to be put on another list head
from *_list to *_node, which helps to differentiate things a little better.
from list_heads that are actually the heads of lists.

Rename init/release_se_global() to *_kmem_caches(), to reflect the changes.

Signed-off-by: Andy Grover <agrover@redhat.com>
Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_alua.c      |   60 +++++++++++++++++-------------
 drivers/target/target_core_configfs.c  |   63 ++++++++++++++++++--------------
 drivers/target/target_core_device.c    |   27 ++++++++------
 drivers/target/target_core_hba.c       |   19 ++++++----
 drivers/target/target_core_tpg.c       |   22 +++++++----
 drivers/target/target_core_transport.c |   40 +++------------------
 include/target/target_core_base.h      |   30 ++--------------
 include/target/target_core_transport.h |    6 +--
 8 files changed, 122 insertions(+), 145 deletions(-)

diff --git a/drivers/target/target_core_alua.c b/drivers/target/target_core_alua.c
index a993f3c..62522d6 100644
--- a/drivers/target/target_core_alua.c
+++ b/drivers/target/target_core_alua.c
@@ -46,6 +46,14 @@ static int core_alua_set_tg_pt_secondary_state(
 		struct t10_alua_tg_pt_gp_member *tg_pt_gp_mem,
 		struct se_port *port, int explict, int offline);
 
+static u16 alua_lu_gps_counter;
+static u32 alua_lu_gps_count;
+
+static DEFINE_SPINLOCK(lu_gps_lock);
+static LIST_HEAD(lu_gps_list);
+
+struct t10_alua_lu_gp *default_lu_gp;
+
 /*
  * REPORT_TARGET_PORT_GROUPS
  *
@@ -1038,15 +1046,15 @@ core_alua_allocate_lu_gp(const char *name, int def_group)
 		printk(KERN_ERR "Unable to allocate struct t10_alua_lu_gp\n");
 		return ERR_PTR(-ENOMEM);
 	}
-	INIT_LIST_HEAD(&lu_gp->lu_gp_list);
+	INIT_LIST_HEAD(&lu_gp->lu_gp_node);
 	INIT_LIST_HEAD(&lu_gp->lu_gp_mem_list);
 	spin_lock_init(&lu_gp->lu_gp_lock);
 	atomic_set(&lu_gp->lu_gp_ref_cnt, 0);
 
 	if (def_group) {
-		lu_gp->lu_gp_id = se_global->alua_lu_gps_counter++;
+		lu_gp->lu_gp_id = alua_lu_gps_counter++;
 		lu_gp->lu_gp_valid_id = 1;
-		se_global->alua_lu_gps_count++;
+		alua_lu_gps_count++;
 	}
 
 	return lu_gp;
@@ -1065,19 +1073,19 @@ int core_alua_set_lu_gp_id(struct t10_alua_lu_gp *lu_gp, u16 lu_gp_id)
 		return -EINVAL;
 	}
 
-	spin_lock(&se_global->lu_gps_lock);
-	if (se_global->alua_lu_gps_count == 0x0000ffff) {
-		printk(KERN_ERR "Maximum ALUA se_global->alua_lu_gps_count:"
+	spin_lock(&lu_gps_lock);
+	if (alua_lu_gps_count == 0x0000ffff) {
+		printk(KERN_ERR "Maximum ALUA alua_lu_gps_count:"
 				" 0x0000ffff reached\n");
-		spin_unlock(&se_global->lu_gps_lock);
+		spin_unlock(&lu_gps_lock);
 		kmem_cache_free(t10_alua_lu_gp_cache, lu_gp);
 		return -ENOSPC;
 	}
 again:
 	lu_gp_id_tmp = (lu_gp_id != 0) ? lu_gp_id :
-				se_global->alua_lu_gps_counter++;
+				alua_lu_gps_counter++;
 
-	list_for_each_entry(lu_gp_tmp, &se_global->g_lu_gps_list, lu_gp_list) {
+	list_for_each_entry(lu_gp_tmp, &lu_gps_list, lu_gp_node) {
 		if (lu_gp_tmp->lu_gp_id == lu_gp_id_tmp) {
 			if (!(lu_gp_id))
 				goto again;
@@ -1085,16 +1093,16 @@ again:
 			printk(KERN_WARNING "ALUA Logical Unit Group ID: %hu"
 				" already exists, ignoring request\n",
 				lu_gp_id);
-			spin_unlock(&se_global->lu_gps_lock);
+			spin_unlock(&lu_gps_lock);
 			return -EINVAL;
 		}
 	}
 
 	lu_gp->lu_gp_id = lu_gp_id_tmp;
 	lu_gp->lu_gp_valid_id = 1;
-	list_add_tail(&lu_gp->lu_gp_list, &se_global->g_lu_gps_list);
-	se_global->alua_lu_gps_count++;
-	spin_unlock(&se_global->lu_gps_lock);
+	list_add_tail(&lu_gp->lu_gp_node, &lu_gps_list);
+	alua_lu_gps_count++;
+	spin_unlock(&lu_gps_lock);
 
 	return 0;
 }
@@ -1130,11 +1138,11 @@ void core_alua_free_lu_gp(struct t10_alua_lu_gp *lu_gp)
 	 * no associations can be made while we are releasing
 	 * struct t10_alua_lu_gp.
 	 */
-	spin_lock(&se_global->lu_gps_lock);
+	spin_lock(&lu_gps_lock);
 	atomic_set(&lu_gp->lu_gp_shutdown, 1);
-	list_del(&lu_gp->lu_gp_list);
-	se_global->alua_lu_gps_count--;
-	spin_unlock(&se_global->lu_gps_lock);
+	list_del(&lu_gp->lu_gp_node);
+	alua_lu_gps_count--;
+	spin_unlock(&lu_gps_lock);
 	/*
 	 * Allow struct t10_alua_lu_gp * referenced by core_alua_get_lu_gp_by_name()
 	 * in target_core_configfs.c:target_core_store_alua_lu_gp() to be
@@ -1165,9 +1173,9 @@ void core_alua_free_lu_gp(struct t10_alua_lu_gp *lu_gp)
 		 * we want to re-assocate a given lu_gp_mem with default_lu_gp.
 		 */
 		spin_lock(&lu_gp_mem->lu_gp_mem_lock);
-		if (lu_gp != se_global->default_lu_gp)
+		if (lu_gp != default_lu_gp)
 			__core_alua_attach_lu_gp_mem(lu_gp_mem,
-					se_global->default_lu_gp);
+					default_lu_gp);
 		else
 			lu_gp_mem->lu_gp = NULL;
 		spin_unlock(&lu_gp_mem->lu_gp_mem_lock);
@@ -1218,27 +1226,27 @@ struct t10_alua_lu_gp *core_alua_get_lu_gp_by_name(const char *name)
 	struct t10_alua_lu_gp *lu_gp;
 	struct config_item *ci;
 
-	spin_lock(&se_global->lu_gps_lock);
-	list_for_each_entry(lu_gp, &se_global->g_lu_gps_list, lu_gp_list) {
+	spin_lock(&lu_gps_lock);
+	list_for_each_entry(lu_gp, &lu_gps_list, lu_gp_node) {
 		if (!(lu_gp->lu_gp_valid_id))
 			continue;
 		ci = &lu_gp->lu_gp_group.cg_item;
 		if (!(strcmp(config_item_name(ci), name))) {
 			atomic_inc(&lu_gp->lu_gp_ref_cnt);
-			spin_unlock(&se_global->lu_gps_lock);
+			spin_unlock(&lu_gps_lock);
 			return lu_gp;
 		}
 	}
-	spin_unlock(&se_global->lu_gps_lock);
+	spin_unlock(&lu_gps_lock);
 
 	return NULL;
 }
 
 void core_alua_put_lu_gp_from_name(struct t10_alua_lu_gp *lu_gp)
 {
-	spin_lock(&se_global->lu_gps_lock);
+	spin_lock(&lu_gps_lock);
 	atomic_dec(&lu_gp->lu_gp_ref_cnt);
-	spin_unlock(&se_global->lu_gps_lock);
+	spin_unlock(&lu_gps_lock);
 }
 
 /*
@@ -1974,7 +1982,7 @@ int core_setup_alua(struct se_device *dev, int force_pt)
 		alua->alua_state_check = &core_alua_state_check;
 		spin_lock(&lu_gp_mem->lu_gp_mem_lock);
 		__core_alua_attach_lu_gp_mem(lu_gp_mem,
-				se_global->default_lu_gp);
+				default_lu_gp);
 		spin_unlock(&lu_gp_mem->lu_gp_mem_lock);
 
 		printk(KERN_INFO "%s: Adding to default ALUA LU Group:"
diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index 03cda0e..82c8e9a 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -37,6 +37,7 @@
 #include <linux/parser.h>
 #include <linux/syscalls.h>
 #include <linux/configfs.h>
+#include <linux/spinlock.h>
 
 #include <target/target_core_base.h>
 #include <target/target_core_device.h>
@@ -52,6 +53,8 @@
 #include "target_core_rd.h"
 #include "target_core_stat.h"
 
+extern struct t10_alua_lu_gp *default_lu_gp;
+
 static struct list_head g_tf_list;
 static struct mutex g_tf_lock;
 
@@ -61,6 +64,13 @@ struct target_core_configfs_attribute {
 	ssize_t (*store)(void *, const char *, size_t);
 };
 
+static struct config_group target_core_hbagroup;
+static struct config_group alua_group;
+static struct config_group alua_lu_gps_group;
+
+static DEFINE_SPINLOCK(se_device_lock);
+static LIST_HEAD(se_dev_list);
+
 static inline struct se_hba *
 item_to_hba(struct config_item *item)
 {
@@ -2784,9 +2794,9 @@ static struct config_group *target_core_make_subdev(
 			" from allocate_virtdevice()\n");
 		goto out;
 	}
-	spin_lock(&se_global->g_device_lock);
-	list_add_tail(&se_dev->se_dev_node, &se_global->g_se_dev_list);
-	spin_unlock(&se_global->g_device_lock);
+	spin_lock(&se_device_lock);
+	list_add_tail(&se_dev->se_dev_node, &se_dev_list);
+	spin_unlock(&se_device_lock);
 
 	config_group_init_type_name(&se_dev->se_dev_group, name,
 			&target_core_dev_cit);
@@ -2881,9 +2891,9 @@ static void target_core_drop_subdev(
 	mutex_lock(&hba->hba_access_mutex);
 	t = hba->transport;
 
-	spin_lock(&se_global->g_device_lock);
+	spin_lock(&se_device_lock);
 	list_del(&se_dev->se_dev_node);
-	spin_unlock(&se_global->g_device_lock);
+	spin_unlock(&se_device_lock);
 
 	dev_stat_grp = &DEV_STAT_GRP(se_dev)->stat_group;
 	for (i = 0; dev_stat_grp->default_groups[i]; i++) {
@@ -3131,7 +3141,7 @@ static int __init target_core_init_configfs(void)
 	INIT_LIST_HEAD(&g_tf_list);
 	mutex_init(&g_tf_lock);
 	init_scsi_index_table();
-	ret = init_se_global();
+	ret = init_se_kmem_caches();
 	if (ret < 0)
 		return ret;
 	/*
@@ -3146,29 +3156,29 @@ static int __init target_core_init_configfs(void)
 		goto out_global;
 	}
 
-	config_group_init_type_name(&se_global->target_core_hbagroup,
+	config_group_init_type_name(&target_core_hbagroup,
 			"core", &target_core_cit);
-	target_cg->default_groups[0] = &se_global->target_core_hbagroup;
+	target_cg->default_groups[0] = &target_core_hbagroup;
 	target_cg->default_groups[1] = NULL;
 	/*
 	 * Create ALUA infrastructure under /sys/kernel/config/target/core/alua/
 	 */
-	hba_cg = &se_global->target_core_hbagroup;
+	hba_cg = &target_core_hbagroup;
 	hba_cg->default_groups = kzalloc(sizeof(struct config_group) * 2,
 				GFP_KERNEL);
 	if (!(hba_cg->default_groups)) {
 		printk(KERN_ERR "Unable to allocate hba_cg->default_groups\n");
 		goto out_global;
 	}
-	config_group_init_type_name(&se_global->alua_group,
+	config_group_init_type_name(&alua_group,
 			"alua", &target_core_alua_cit);
-	hba_cg->default_groups[0] = &se_global->alua_group;
+	hba_cg->default_groups[0] = &alua_group;
 	hba_cg->default_groups[1] = NULL;
 	/*
 	 * Add ALUA Logical Unit Group and Target Port Group ConfigFS
 	 * groups under /sys/kernel/config/target/core/alua/
 	 */
-	alua_cg = &se_global->alua_group;
+	alua_cg = &alua_group;
 	alua_cg->default_groups = kzalloc(sizeof(struct config_group) * 2,
 			GFP_KERNEL);
 	if (!(alua_cg->default_groups)) {
@@ -3176,9 +3186,9 @@ static int __init target_core_init_configfs(void)
 		goto out_global;
 	}
 
-	config_group_init_type_name(&se_global->alua_lu_gps_group,
+	config_group_init_type_name(&alua_lu_gps_group,
 			"lu_gps", &target_core_alua_lu_gps_cit);
-	alua_cg->default_groups[0] = &se_global->alua_lu_gps_group;
+	alua_cg->default_groups[0] = &alua_lu_gps_group;
 	alua_cg->default_groups[1] = NULL;
 	/*
 	 * Add core/alua/lu_gps/default_lu_gp
@@ -3187,7 +3197,7 @@ static int __init target_core_init_configfs(void)
 	if (IS_ERR(lu_gp))
 		goto out_global;
 
-	lu_gp_cg = &se_global->alua_lu_gps_group;
+	lu_gp_cg = &alua_lu_gps_group;
 	lu_gp_cg->default_groups = kzalloc(sizeof(struct config_group) * 2,
 			GFP_KERNEL);
 	if (!(lu_gp_cg->default_groups)) {
@@ -3199,7 +3209,7 @@ static int __init target_core_init_configfs(void)
 				&target_core_alua_lu_gp_cit);
 	lu_gp_cg->default_groups[0] = &lu_gp->lu_gp_group;
 	lu_gp_cg->default_groups[1] = NULL;
-	se_global->default_lu_gp = lu_gp;
+	default_lu_gp = lu_gp;
 	/*
 	 * Register the target_core_mod subsystem with configfs.
 	 */
@@ -3229,9 +3239,9 @@ out:
 	core_dev_release_virtual_lun0();
 	rd_module_exit();
 out_global:
-	if (se_global->default_lu_gp) {
-		core_alua_free_lu_gp(se_global->default_lu_gp);
-		se_global->default_lu_gp = NULL;
+	if (default_lu_gp) {
+		core_alua_free_lu_gp(default_lu_gp);
+		default_lu_gp = NULL;
 	}
 	if (lu_gp_cg)
 		kfree(lu_gp_cg->default_groups);
@@ -3240,7 +3250,7 @@ out_global:
 	if (hba_cg)
 		kfree(hba_cg->default_groups);
 	kfree(target_cg->default_groups);
-	release_se_global();
+	release_se_kmem_caches();
 	return ret;
 }
 
@@ -3251,10 +3261,9 @@ static void __exit target_core_exit_configfs(void)
 	struct config_item *item;
 	int i;
 
-	se_global->in_shutdown = 1;
 	subsys = target_core_subsystem[0];
 
-	lu_gp_cg = &se_global->alua_lu_gps_group;
+	lu_gp_cg = &alua_lu_gps_group;
 	for (i = 0; lu_gp_cg->default_groups[i]; i++) {
 		item = &lu_gp_cg->default_groups[i]->cg_item;
 		lu_gp_cg->default_groups[i] = NULL;
@@ -3263,7 +3272,7 @@ static void __exit target_core_exit_configfs(void)
 	kfree(lu_gp_cg->default_groups);
 	lu_gp_cg->default_groups = NULL;
 
-	alua_cg = &se_global->alua_group;
+	alua_cg = &alua_group;
 	for (i = 0; alua_cg->default_groups[i]; i++) {
 		item = &alua_cg->default_groups[i]->cg_item;
 		alua_cg->default_groups[i] = NULL;
@@ -3272,7 +3281,7 @@ static void __exit target_core_exit_configfs(void)
 	kfree(alua_cg->default_groups);
 	alua_cg->default_groups = NULL;
 
-	hba_cg = &se_global->target_core_hbagroup;
+	hba_cg = &target_core_hbagroup;
 	for (i = 0; hba_cg->default_groups[i]; i++) {
 		item = &hba_cg->default_groups[i]->cg_item;
 		hba_cg->default_groups[i] = NULL;
@@ -3287,15 +3296,15 @@ static void __exit target_core_exit_configfs(void)
 	configfs_unregister_subsystem(subsys);
 	kfree(subsys->su_group.default_groups);
 
-	core_alua_free_lu_gp(se_global->default_lu_gp);
-	se_global->default_lu_gp = NULL;
+	core_alua_free_lu_gp(default_lu_gp);
+	default_lu_gp = NULL;
 
 	printk(KERN_INFO "TARGET_CORE[0]: Released ConfigFS Fabric"
 			" Infrastructure\n");
 
 	core_dev_release_virtual_lun0();
 	rd_module_exit();
-	release_se_global();
+	release_se_kmem_caches();
 
 	return;
 }
diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index 4d8da32..c9a3f73 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -54,6 +54,11 @@
 static void se_dev_start(struct se_device *dev);
 static void se_dev_stop(struct se_device *dev);
 
+static struct se_hba *lun0_hba;
+static struct se_subsystem_dev *lun0_su_dev;
+/* not static, needed by tpg.c */
+struct se_device *g_lun0_dev;
+
 int transport_get_lun_for_cmd(
 	struct se_cmd *se_cmd,
 	u32 unpacked_lun)
@@ -1579,7 +1584,7 @@ int core_dev_setup_virtual_lun0(void)
 	if (IS_ERR(hba))
 		return PTR_ERR(hba);
 
-	se_global->g_lun0_hba = hba;
+	lun0_hba = hba;
 	t = hba->transport;
 
 	se_dev = kzalloc(sizeof(struct se_subsystem_dev), GFP_KERNEL);
@@ -1612,7 +1617,7 @@ int core_dev_setup_virtual_lun0(void)
 		ret = -ENOMEM;
 		goto out;
 	}
-	se_global->g_lun0_su_dev = se_dev;
+	lun0_su_dev = se_dev;
 
 	memset(buf, 0, 16);
 	sprintf(buf, "rd_pages=8");
@@ -1624,15 +1629,15 @@ int core_dev_setup_virtual_lun0(void)
 		goto out;
 	}
 	se_dev->se_dev_ptr = dev;
-	se_global->g_lun0_dev = dev;
+	g_lun0_dev = dev;
 
 	return 0;
 out:
-	se_global->g_lun0_su_dev = NULL;
+	lun0_su_dev = NULL;
 	kfree(se_dev);
-	if (se_global->g_lun0_hba) {
-		core_delete_hba(se_global->g_lun0_hba);
-		se_global->g_lun0_hba = NULL;
+	if (lun0_hba) {
+		core_delete_hba(lun0_hba);
+		lun0_hba = NULL;
 	}
 	return ret;
 }
@@ -1640,14 +1645,14 @@ out:
 
 void core_dev_release_virtual_lun0(void)
 {
-	struct se_hba *hba = se_global->g_lun0_hba;
-	struct se_subsystem_dev *su_dev = se_global->g_lun0_su_dev;
+	struct se_hba *hba = lun0_hba;
+	struct se_subsystem_dev *su_dev = lun0_su_dev;
 
 	if (!(hba))
 		return;
 
-	if (se_global->g_lun0_dev)
-		se_free_virtual_device(se_global->g_lun0_dev, hba);
+	if (g_lun0_dev)
+		se_free_virtual_device(g_lun0_dev, hba);
 
 	kfree(su_dev);
 	core_delete_hba(hba);
diff --git a/drivers/target/target_core_hba.c b/drivers/target/target_core_hba.c
index 8f3a0c4..bd9da25 100644
--- a/drivers/target/target_core_hba.c
+++ b/drivers/target/target_core_hba.c
@@ -45,6 +45,11 @@
 static LIST_HEAD(subsystem_list);
 static DEFINE_MUTEX(subsystem_mutex);
 
+static u32 hba_id_counter;
+
+static DEFINE_SPINLOCK(hba_lock);
+static LIST_HEAD(hba_list);
+
 int transport_subsystem_register(struct se_subsystem_api *sub_api)
 {
 	struct se_subsystem_api *s;
@@ -125,10 +130,10 @@ core_alloc_hba(const char *plugin_name, u32 plugin_dep_id, u32 hba_flags)
 	if (ret < 0)
 		goto out_module_put;
 
-	spin_lock(&se_global->hba_lock);
-	hba->hba_id = se_global->g_hba_id_counter++;
-	list_add_tail(&hba->hba_list, &se_global->g_hba_list);
-	spin_unlock(&se_global->hba_lock);
+	spin_lock(&hba_lock);
+	hba->hba_id = hba_id_counter++;
+	list_add_tail(&hba->hba_node, &hba_list);
+	spin_unlock(&hba_lock);
 
 	printk(KERN_INFO "CORE_HBA[%d] - Attached HBA to Generic Target"
 			" Core\n", hba->hba_id);
@@ -152,9 +157,9 @@ core_delete_hba(struct se_hba *hba)
 
 	hba->transport->detach_hba(hba);
 
-	spin_lock(&se_global->hba_lock);
-	list_del(&hba->hba_list);
-	spin_unlock(&se_global->hba_lock);
+	spin_lock(&hba_lock);
+	list_del(&hba->hba_node);
+	spin_unlock(&hba_lock);
 
 	printk(KERN_INFO "CORE_HBA[%d] - Detached HBA from Generic Target"
 			" Core\n", hba->hba_id);
diff --git a/drivers/target/target_core_tpg.c b/drivers/target/target_core_tpg.c
index dc024c1..4e2bee9 100644
--- a/drivers/target/target_core_tpg.c
+++ b/drivers/target/target_core_tpg.c
@@ -44,6 +44,12 @@
 #include <target/target_core_fabric_ops.h>
 
 #include "target_core_hba.h"
+#include "target_core_stat.h"
+
+extern struct se_device *g_lun0_dev;
+
+static DEFINE_SPINLOCK(tpg_lock);
+static LIST_HEAD(tpg_list);
 
 /*	core_clear_initiator_node_from_tpg():
  *
@@ -597,7 +603,7 @@ EXPORT_SYMBOL(core_tpg_set_initiator_node_queue_depth);
 static int core_tpg_setup_virtual_lun0(struct se_portal_group *se_tpg)
 {
 	/* Set in core_dev_setup_virtual_lun0() */
-	struct se_device *dev = se_global->g_lun0_dev;
+	struct se_device *dev = g_lun0_dev;
 	struct se_lun *lun = &se_tpg->tpg_virt_lun0;
 	u32 lun_access = TRANSPORT_LUNFLAGS_READ_ONLY;
 	int ret;
@@ -663,7 +669,7 @@ int core_tpg_register(
 	se_tpg->se_tpg_wwn = se_wwn;
 	atomic_set(&se_tpg->tpg_pr_ref_count, 0);
 	INIT_LIST_HEAD(&se_tpg->acl_node_list);
-	INIT_LIST_HEAD(&se_tpg->se_tpg_list);
+	INIT_LIST_HEAD(&se_tpg->se_tpg_node);
 	INIT_LIST_HEAD(&se_tpg->tpg_sess_list);
 	spin_lock_init(&se_tpg->acl_node_lock);
 	spin_lock_init(&se_tpg->session_lock);
@@ -676,9 +682,9 @@ int core_tpg_register(
 		}
 	}
 
-	spin_lock_bh(&se_global->se_tpg_lock);
-	list_add_tail(&se_tpg->se_tpg_list, &se_global->g_se_tpg_list);
-	spin_unlock_bh(&se_global->se_tpg_lock);
+	spin_lock_bh(&tpg_lock);
+	list_add_tail(&se_tpg->se_tpg_node, &tpg_list);
+	spin_unlock_bh(&tpg_lock);
 
 	printk(KERN_INFO "TARGET_CORE[%s]: Allocated %s struct se_portal_group for"
 		" endpoint: %s, Portal Tag: %u\n", tfo->get_fabric_name(),
@@ -701,9 +707,9 @@ int core_tpg_deregister(struct se_portal_group *se_tpg)
 		TPG_TFO(se_tpg)->tpg_get_wwn(se_tpg),
 		TPG_TFO(se_tpg)->tpg_get_tag(se_tpg));
 
-	spin_lock_bh(&se_global->se_tpg_lock);
-	list_del(&se_tpg->se_tpg_list);
-	spin_unlock_bh(&se_global->se_tpg_lock);
+	spin_lock_bh(&tpg_lock);
+	list_del(&se_tpg->se_tpg_node);
+	spin_unlock_bh(&tpg_lock);
 
 	while (atomic_read(&se_tpg->tpg_pr_ref_count) != 0)
 		cpu_relax();
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 56249cf..0f084a1 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -184,7 +184,7 @@
 #define DEBUG_STA(x...)
 #endif
 
-struct se_global *se_global;
+static int sub_api_initialized;
 
 static struct kmem_cache *se_cmd_cache;
 static struct kmem_cache *se_sess_cache;
@@ -227,26 +227,8 @@ static void transport_remove_cmd_from_queue(struct se_cmd *cmd,
 static int transport_set_sense_codes(struct se_cmd *cmd, u8 asc, u8 ascq);
 static void transport_stop_all_task_timers(struct se_cmd *cmd);
 
-int init_se_global(void)
+int init_se_kmem_caches(void)
 {
-	struct se_global *global;
-
-	global = kzalloc(sizeof(struct se_global), GFP_KERNEL);
-	if (!(global)) {
-		printk(KERN_ERR "Unable to allocate memory for struct se_global\n");
-		return -ENOMEM;
-	}
-
-	INIT_LIST_HEAD(&global->g_lu_gps_list);
-	INIT_LIST_HEAD(&global->g_se_tpg_list);
-	INIT_LIST_HEAD(&global->g_hba_list);
-	INIT_LIST_HEAD(&global->g_se_dev_list);
-	spin_lock_init(&global->g_device_lock);
-	spin_lock_init(&global->hba_lock);
-	spin_lock_init(&global->se_tpg_lock);
-	spin_lock_init(&global->lu_gps_lock);
-	spin_lock_init(&global->plugin_class_lock);
-
 	se_cmd_cache = kmem_cache_create("se_cmd_cache",
 			sizeof(struct se_cmd), __alignof__(struct se_cmd), 0, NULL);
 	if (!(se_cmd_cache)) {
@@ -325,8 +307,6 @@ int init_se_global(void)
 		goto out;
 	}
 
-	se_global = global;
-
 	return 0;
 out:
 	if (se_cmd_cache)
@@ -349,18 +329,11 @@ out:
 		kmem_cache_destroy(t10_alua_tg_pt_gp_cache);
 	if (t10_alua_tg_pt_gp_mem_cache)
 		kmem_cache_destroy(t10_alua_tg_pt_gp_mem_cache);
-	kfree(global);
 	return -ENOMEM;
 }
 
-void release_se_global(void)
+void release_se_kmem_caches(void)
 {
-	struct se_global *global;
-
-	global = se_global;
-	if (!(global))
-		return;
-
 	kmem_cache_destroy(se_cmd_cache);
 	kmem_cache_destroy(se_tmr_req_cache);
 	kmem_cache_destroy(se_sess_cache);
@@ -371,9 +344,6 @@ void release_se_global(void)
 	kmem_cache_destroy(t10_alua_lu_gp_mem_cache);
 	kmem_cache_destroy(t10_alua_tg_pt_gp_cache);
 	kmem_cache_destroy(t10_alua_tg_pt_gp_mem_cache);
-	kfree(global);
-
-	se_global = NULL;
 }
 
 /* SCSI statistics table index */
@@ -446,7 +416,7 @@ int transport_subsystem_check_init(void)
 {
 	int ret;
 
-	if (se_global->g_sub_api_initialized)
+	if (sub_api_initialized)
 		return 0;
 	/*
 	 * Request the loading of known TCM subsystem plugins..
@@ -455,7 +425,7 @@ int transport_subsystem_check_init(void)
 	if (ret < 0)
 		return ret;
 
-	se_global->g_sub_api_initialized = 1;
+	sub_api_initialized = 1;
 	return 0;
 }
 
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index 8467a8d..de7bec6 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -235,7 +235,7 @@ struct t10_alua_lu_gp {
 	atomic_t lu_gp_ref_cnt;
 	spinlock_t lu_gp_lock;
 	struct config_group lu_gp_group;
-	struct list_head lu_gp_list;
+	struct list_head lu_gp_node;
 	struct list_head lu_gp_mem_list;
 } ____cacheline_aligned;
 
@@ -840,7 +840,7 @@ struct se_hba {
 	void			*hba_ptr;
 	/* Linked list for struct se_device */
 	struct list_head	hba_dev_list;
-	struct list_head	hba_list;
+	struct list_head	hba_node;
 	spinlock_t		device_lock;
 	struct config_group	hba_group;
 	struct mutex		hba_access_mutex;
@@ -924,7 +924,7 @@ struct se_portal_group {
 	spinlock_t		tpg_lun_lock;
 	/* Pointer to $FABRIC_MOD portal group */
 	void			*se_tpg_fabric_ptr;
-	struct list_head	se_tpg_list;
+	struct list_head	se_tpg_node;
 	/* linked list for initiator ACL list */
 	struct list_head	acl_node_list;
 	struct se_lun		*tpg_lun_list;
@@ -952,28 +952,4 @@ struct se_wwn {
 	struct config_group	fabric_stat_group;
 } ____cacheline_aligned;
 
-struct se_global {
-	u16			alua_lu_gps_counter;
-	int			g_sub_api_initialized;
-	u32			in_shutdown;
-	u32			alua_lu_gps_count;
-	u32			g_hba_id_counter;
-	struct config_group	target_core_hbagroup;
-	struct config_group	alua_group;
-	struct config_group	alua_lu_gps_group;
-	struct list_head	g_lu_gps_list;
-	struct list_head	g_se_tpg_list;
-	struct list_head	g_hba_list;
-	struct list_head	g_se_dev_list;
-	struct se_hba		*g_lun0_hba;
-	struct se_subsystem_dev *g_lun0_su_dev;
-	struct se_device	*g_lun0_dev;
-	struct t10_alua_lu_gp	*default_lu_gp;
-	spinlock_t		g_device_lock;
-	spinlock_t		hba_lock;
-	spinlock_t		se_tpg_lock;
-	spinlock_t		lu_gps_lock;
-	spinlock_t		plugin_class_lock;
-} ____cacheline_aligned;
-
 #endif /* TARGET_CORE_BASE_H */
diff --git a/include/target/target_core_transport.h b/include/target/target_core_transport.h
index 199a404..06b8900 100644
--- a/include/target/target_core_transport.h
+++ b/include/target/target_core_transport.h
@@ -111,8 +111,8 @@ struct se_subsystem_api;
 
 extern struct kmem_cache *se_mem_cache;
 
-extern int init_se_global(void);
-extern void release_se_global(void);
+extern int init_se_kmem_caches(void);
+extern void release_se_kmem_caches(void);
 extern void init_scsi_index_table(void);
 extern u32 scsi_get_new_index(scsi_index_t);
 extern void transport_init_queue_obj(struct se_queue_obj *);
@@ -355,6 +355,4 @@ struct se_subsystem_api {
 #define TRANSPORT(dev)		((dev)->transport)
 #define HBA_TRANSPORT(hba)	((hba)->transport)
 
-extern struct se_global *se_global;
-
 #endif /* TARGET_CORE_TRANSPORT_H */
-- 
1.7.6

