From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 2/4] [Target_Core_Mod/ConfigFS]: Add implict ALUA
	attributes and move tg_pt_gp list
Date: Tue, 18 Aug 2009 16:15:52 -0700
Message-ID: <1250637352.27590.67.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1752149AbZHRXQA@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: LKML <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
Cc: Douglas Gilbert <dgilbert@interlog.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, James Bottomley <James.Bottomley@HansenPartnership.com>, Andrew Morton <akpm@linux-foundation.org>, "H. Peter Anvin" <hpa@zytor.com>, Alasdair G Kergon <agk@redhat.com>, Joel Becker <joel.becker@oracle.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Florian Haas <florian.haas@linbit.com>, Philipp Reisner <philipp.reisner@linbit.com>
List-Id: linux-scsi@vger.kernel.org

Greetings,

This patch updates target_core_mod/ConfigFS to support to move the ALUA target port
group from the global location of /sys/kernel/config/target/core/alua/tg_pt_gps/ to
a per storage object location at /sys/kernel/config/target/core/$HBA/$DEV/alua/

This patch also adds the following new configfs attributes to
/sys/kernel/config/target/core/$HBA/$DEV/alua/

*) alua_access_state: Changing the implict ALUA primary access state.
*) alua_access_type: Currently available ALUA types (INQUIRY TPGS field)
*) nonop_delay_msecs: Millisecond delay for Active/NonOptimized path
*) preferred: Set preferred (PREF=1) bit for target port group

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_configfs.c |  240 ++++++++++++++++++++++++---------
 1 files changed, 175 insertions(+), 65 deletions(-)

diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index 847995a..e1b6154 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -1983,18 +1983,6 @@ static struct target_core_alua_lu_gp_attribute				\
 	target_core_alua_lu_gp_show_attr_##_name);
 
 /*
- * alua_access_state
- */
-static ssize_t target_core_alua_lu_gp_show_attr_alua_access_state(
-	struct t10_alua_lu_gp_s *lu_gp,
-	char *page)
-{
-	return sprintf(page, "%d\n", lu_gp->lu_gp_alua_access_state);
-}
-
-SE_DEV_ALUA_LU_ATTR_RO(alua_access_state);
-
-/*
  * lu_gp_id
  */
 static ssize_t target_core_alua_lu_gp_show_attr_lu_gp_id(
@@ -2087,7 +2075,6 @@ SE_DEV_ALUA_LU_ATTR_RO(members);
 CONFIGFS_EATTR_OPS(target_core_alua_lu_gp, t10_alua_lu_gp_s, lu_gp_group);
 
 static struct configfs_attribute *target_core_alua_lu_gp_attrs[] = {
-	&target_core_alua_lu_gp_alua_access_state.attr,
 	&target_core_alua_lu_gp_lu_gp_id.attr,
 	&target_core_alua_lu_gp_members.attr,
 	NULL,
@@ -2187,7 +2174,116 @@ static ssize_t target_core_alua_tg_pt_gp_show_attr_alua_access_state(
 	return sprintf(page, "%d\n", tg_pt_gp->tg_pt_gp_alua_access_state);
 }
 
-SE_DEV_ALUA_TG_PT_ATTR_RO(alua_access_state);
+static ssize_t target_core_alua_tg_pt_gp_store_attr_alua_access_state(
+	struct t10_alua_tg_pt_gp_s *tg_pt_gp,
+	const char *page,
+	size_t count)
+{
+	se_subsystem_dev_t *su_dev = tg_pt_gp->tg_pt_gp_su_dev;
+	unsigned long tmp;
+	int new_state, ret;
+
+	if (!(tg_pt_gp->tg_pt_gp_valid_id)) {
+		printk(KERN_ERR "Unable to do implict ALUA on non valid"
+			" tg_pt_gp ID: %hu\n", tg_pt_gp->tg_pt_gp_valid_id);
+		return -EINVAL;
+	}
+	
+	ret = strict_strtoul(page, 0, &tmp);
+	if (ret < 0) {
+		printk("Unable to extract new ALUA access state from"
+				" %s\n", page);
+		return -EINVAL;
+	}
+	new_state = (int)tmp;
+
+	if (!(tg_pt_gp->tg_pt_gp_alua_access_type & TPGS_IMPLICT_ALUA)) {
+		printk(KERN_ERR "Unable to process implict configfs ALUA"
+			" transition while TPGS_IMPLICT_ALUA is diabled\n");
+		return -EINVAL;
+	}
+
+	ret = core_alua_do_port_transition(tg_pt_gp, su_dev->se_dev_ptr,
+					NULL, NULL, new_state, 0);
+	return (!ret) ? count : -EINVAL;	
+}
+
+SE_DEV_ALUA_TG_PT_ATTR(alua_access_state, S_IRUGO | S_IWUSR);
+
+/*
+ * alua_access_status
+ */
+static ssize_t target_core_alua_tg_pt_gp_show_attr_alua_access_status(
+	struct t10_alua_tg_pt_gp_s *tg_pt_gp,
+	char *page)
+{
+	return sprintf(page, "%s\n",
+		core_alua_dump_status(tg_pt_gp->tg_pt_gp_alua_access_status));
+}
+
+SE_DEV_ALUA_TG_PT_ATTR_RO(alua_access_status);
+
+/*
+ * alua_access_type
+ */
+static ssize_t target_core_alua_tg_pt_gp_show_attr_alua_access_type(
+	struct t10_alua_tg_pt_gp_s *tg_pt_gp,
+	char *page)
+{
+	return core_alua_show_access_type(tg_pt_gp, page);
+}
+
+static ssize_t target_core_alua_tg_pt_gp_store_attr_alua_access_type(
+	struct t10_alua_tg_pt_gp_s *tg_pt_gp,
+	const char *page,
+	size_t count)
+{
+	return core_alua_store_access_type(tg_pt_gp, page, count);
+}
+
+SE_DEV_ALUA_TG_PT_ATTR(alua_access_type, S_IRUGO | S_IWUSR);
+
+/*
+ * nonop_delay_msecs
+ */
+static ssize_t target_core_alua_tg_pt_gp_show_attr_nonop_delay_msecs(
+	struct t10_alua_tg_pt_gp_s *tg_pt_gp,
+	char *page)
+{
+	return core_alua_show_nonop_delay_msecs(tg_pt_gp, page);
+
+}
+
+static ssize_t target_core_alua_tg_pt_gp_store_attr_nonop_delay_msecs(
+	struct t10_alua_tg_pt_gp_s *tg_pt_gp,
+	const char *page,
+	size_t count)
+{
+	return core_alua_store_nonop_delay_msecs(tg_pt_gp, page, count);
+}
+
+SE_DEV_ALUA_TG_PT_ATTR(nonop_delay_msecs, S_IRUGO | S_IWUSR);
+
+/*
+ * preferred
+ */
+
+static ssize_t target_core_alua_tg_pt_gp_show_attr_preferred(
+	struct t10_alua_tg_pt_gp_s *tg_pt_gp,
+	char *page)
+{
+	return core_alua_show_preferred_bit(tg_pt_gp, page);
+}
+
+static ssize_t target_core_alua_tg_pt_gp_store_attr_preferred(
+	struct t10_alua_tg_pt_gp_s *tg_pt_gp,
+	const char *page,
+	size_t count)
+{
+	return core_alua_store_preferred_bit(tg_pt_gp, page, count);
+}
+
+SE_DEV_ALUA_TG_PT_ATTR(preferred, S_IRUGO | S_IWUSR);
 
 /*
  * tg_pt_gp_id
@@ -2287,6 +2383,10 @@ CONFIGFS_EATTR_OPS(target_core_alua_tg_pt_gp, t10_alua_tg_pt_gp_s,
 
 static struct configfs_attribute *target_core_alua_tg_pt_gp_attrs[] = {
 	&target_core_alua_tg_pt_gp_alua_access_state.attr,
+	&target_core_alua_tg_pt_gp_alua_access_status.attr,
+	&target_core_alua_tg_pt_gp_alua_access_type.attr,
+	&target_core_alua_tg_pt_gp_nonop_delay_msecs.attr,
+	&target_core_alua_tg_pt_gp_preferred.attr,
 	&target_core_alua_tg_pt_gp_tg_pt_gp_id.attr,
 	&target_core_alua_tg_pt_gp_members.attr,
 	NULL,
@@ -2311,11 +2411,14 @@ static struct config_group *target_core_alua_create_tg_pt_gp(
 	struct config_group *group,
 	const char *name)
 {
+	t10_alua_t *alua = container_of(group, t10_alua_t,
+					alua_tg_pt_gps_group);
 	t10_alua_tg_pt_gp_t *tg_pt_gp;
+	se_subsystem_dev_t *su_dev = alua->t10_sub_dev;
 	struct config_group *alua_tg_pt_gp_cg = NULL;
 	struct config_item *alua_tg_pt_gp_ci = NULL;
 
-	tg_pt_gp = core_alua_allocate_tg_pt_gp(name, 0);
+	tg_pt_gp = core_alua_allocate_tg_pt_gp(su_dev, name, 0);
 	if (!(tg_pt_gp))
 		return NULL;
 
@@ -2326,7 +2429,7 @@ static struct config_group *target_core_alua_create_tg_pt_gp(
 			&target_core_alua_tg_pt_gp_cit);
 
 	printk(KERN_INFO "Target_Core_ConfigFS: Allocated ALUA Target Port"
-		" Group: core/alua/tg_pt_gps/%s\n",
+		" Group: alua/tg_pt_gps/%s\n",
 		config_item_name(alua_tg_pt_gp_ci));
 
 	return alua_tg_pt_gp_cg;
@@ -2340,7 +2443,7 @@ static void target_core_alua_drop_tg_pt_gp(
 			t10_alua_tg_pt_gp_t, tg_pt_gp_group);
 
 	printk(KERN_INFO "Target_Core_ConfigFS: Releasing ALUA Target Port"
-		" Group: core/alua/tg_pt_gps/%s, ID: %hu\n",
+		" Group: alua/tg_pt_gps/%s, ID: %hu\n",
 		config_item_name(item), tg_pt_gp->tg_pt_gp_id);
 
 	config_item_put(item);
@@ -2381,11 +2484,12 @@ static struct config_group *target_core_call_createdev(
 	struct config_group *group,
 	const char *name)
 {
+	t10_alua_tg_pt_gp_t *tg_pt_gp;
 	se_subsystem_dev_t *se_dev;
 	se_hba_t *hba;
 	se_subsystem_api_t *t;
 	struct config_item *hba_ci;
-	struct config_group *dev_cg = NULL;
+	struct config_group *dev_cg = NULL, *tg_pt_gp_cg = NULL;
 	int ret = 0;
 
 	hba_ci = &group->cg_item;
@@ -2423,15 +2527,18 @@ static struct config_group *target_core_call_createdev(
 	INIT_LIST_HEAD(&se_dev->t10_reservation.aptpl_reg_list);
 	spin_lock_init(&se_dev->t10_reservation.registration_lock);
 	spin_lock_init(&se_dev->t10_reservation.aptpl_reg_lock);
+	INIT_LIST_HEAD(&se_dev->t10_alua.tg_pt_gps_list);
+	spin_lock_init(&se_dev->t10_alua.tg_pt_gps_lock);
 	spin_lock_init(&se_dev->se_dev_lock);
 	se_dev->t10_reservation.pr_aptpl_buf_len = PR_APTPL_BUF_LEN;
 	se_dev->t10_wwn.t10_sub_dev = se_dev;
+	se_dev->t10_alua.t10_sub_dev = se_dev;
 	se_dev->se_dev_attrib.da_sub_dev = se_dev;
 
 	se_dev->se_dev_hba = hba;
 	dev_cg = &se_dev->se_dev_group;
 
-	dev_cg->default_groups = kzalloc(sizeof(struct config_group) * 5,
+	dev_cg->default_groups = kzalloc(sizeof(struct config_group) * 6,
 			GFP_KERNEL);
 	if (!(dev_cg->default_groups))
 		goto out;
@@ -2466,11 +2573,35 @@ static struct config_group *target_core_call_createdev(
 			&target_core_dev_snap_cit);
 	config_group_init_type_name(&se_dev->t10_wwn.t10_wwn_group, "wwn",
 			&target_core_dev_wwn_cit);
+	config_group_init_type_name(&se_dev->t10_alua.alua_tg_pt_gps_group,
+			"alua", &target_core_alua_tg_pt_gps_cit);
 	dev_cg->default_groups[0] = &se_dev->se_dev_attrib.da_group;
 	dev_cg->default_groups[1] = &se_dev->se_dev_pr_group;
 	dev_cg->default_groups[2] = &se_dev->se_dev_snap_group;
 	dev_cg->default_groups[3] = &se_dev->t10_wwn.t10_wwn_group;
-	dev_cg->default_groups[4] = NULL;
+	dev_cg->default_groups[4] = &se_dev->t10_alua.alua_tg_pt_gps_group;
+	dev_cg->default_groups[5] = NULL;
+	/*
+	 * Add core/$HBA/$DEV/alua/tg_pt_gps/default_tg_pt_gp
+	 */
+	tg_pt_gp = core_alua_allocate_tg_pt_gp(se_dev, "default_tg_pt_gp", 1);
+	if (!(tg_pt_gp))
+		goto out;
+
+	tg_pt_gp_cg = &T10_ALUA(se_dev)->alua_tg_pt_gps_group;
+	tg_pt_gp_cg->default_groups = kzalloc(sizeof(struct config_group) * 2,
+				GFP_KERNEL);
+	if (!(tg_pt_gp_cg->default_groups)) {
+		printk(KERN_ERR "Unable to allocate tg_pt_gp_cg->"
+				"default_groups\n");
+		goto out;
+	}
+
+	config_group_init_type_name(&tg_pt_gp->tg_pt_gp_group,
+			"default_tg_pt_gp", &target_core_alua_tg_pt_gp_cit);
+	tg_pt_gp_cg->default_groups[0] = &tg_pt_gp->tg_pt_gp_group;
+	tg_pt_gp_cg->default_groups[1] = NULL;
+	T10_ALUA(se_dev)->default_tg_pt_gp = tg_pt_gp;
 
 	printk(KERN_INFO "Target_Core_ConfigFS: Allocated se_subsystem_dev_t:"
 		" %p se_dev_su_ptr: %p\n", se_dev, se_dev->se_dev_su_ptr);
@@ -2478,8 +2609,16 @@ static struct config_group *target_core_call_createdev(
 	core_put_hba(hba);
 	return &se_dev->se_dev_group;
 out:
+	if (T10_ALUA(se_dev)->default_tg_pt_gp) {
+		core_alua_free_tg_pt_gp(T10_ALUA(se_dev)->default_tg_pt_gp);
+		T10_ALUA(se_dev)->default_tg_pt_gp = NULL;
+        }
+	if (tg_pt_gp_cg)
+		kfree(tg_pt_gp_cg->default_groups);
 	if (dev_cg)
 		kfree(dev_cg->default_groups);
+	if (se_dev->se_dev_su_ptr)
+		t->free_device(se_dev->se_dev_su_ptr);
 	kfree(se_dev);
 	core_put_hba(hba);
 	return NULL;
@@ -2493,7 +2632,9 @@ static void target_core_call_freedev(
 				se_subsystem_dev_t, se_dev_group);
 	se_hba_t *hba;
 	se_subsystem_api_t *t;
-	int ret = 0;
+	struct config_item *df_item;
+	struct config_group *tg_pt_gp_cg;
+	int i, ret = 0;
 
 	hba = target_core_get_hba_from_item(
 			&se_dev->se_dev_hba->hba_group.cg_item);
@@ -2509,6 +2650,15 @@ static void target_core_call_freedev(
 	list_del(&se_dev->g_se_dev_list);
 	spin_unlock(&se_global->g_device_lock);
 
+	tg_pt_gp_cg = &T10_ALUA(se_dev)->alua_tg_pt_gps_group;
+	for (i = 0; tg_pt_gp_cg->default_groups[i]; i++) {
+		df_item = &tg_pt_gp_cg->default_groups[i]->cg_item;
+		tg_pt_gp_cg->default_groups[i] = NULL;
+		config_item_put(df_item);
+	}
+	core_alua_free_tg_pt_gp(T10_ALUA(se_dev)->default_tg_pt_gp);
+	T10_ALUA(se_dev)->default_tg_pt_gp = NULL;
+
 	config_item_put(item);
 	/*
 	 * This pointer will set when the storage is enabled with:
@@ -2686,13 +2836,12 @@ static struct config_item_type target_core_cit = {
 int target_core_init_configfs(void)
 {
 	struct config_group *target_cg, *hba_cg = NULL, *alua_cg = NULL;
-	struct config_group *lu_gp_cg = NULL, *tg_pt_gp_cg = NULL;
+	struct config_group *lu_gp_cg = NULL;
 	struct configfs_subsystem *subsys;
 #ifdef SNMP_SUPPORT
 	struct proc_dir_entry *scsi_target_proc;
 #endif
 	t10_alua_lu_gp_t *lu_gp;
-	t10_alua_tg_pt_gp_t *tg_pt_gp;
 	int ret;
 
 	printk(KERN_INFO "TARGET_CORE[0]: Loading Generic Kernel Storage"
@@ -2746,7 +2895,7 @@ int target_core_init_configfs(void)
 	 * groups under /sys/kernel/config/target/core/alua/
 	 */
 	alua_cg = &se_global->alua_group;
-	alua_cg->default_groups = kzalloc(sizeof(struct config_group) * 3,
+	alua_cg->default_groups = kzalloc(sizeof(struct config_group) * 2,
 			GFP_KERNEL);
 	if (!(alua_cg->default_groups)) {
 		printk(KERN_ERR "Unable to allocate alua_cg->default_groups\n");
@@ -2755,11 +2904,8 @@ int target_core_init_configfs(void)
 
 	config_group_init_type_name(&se_global->alua_lu_gps_group,
 			"lu_gps", &target_core_alua_lu_gps_cit);
-	config_group_init_type_name(&se_global->alua_tg_pt_gps_group,
-			"tg_pt_gps", &target_core_alua_tg_pt_gps_cit);
 	alua_cg->default_groups[0] = &se_global->alua_lu_gps_group;
-	alua_cg->default_groups[1] = &se_global->alua_tg_pt_gps_group;
-	alua_cg->default_groups[2] = NULL;
+	alua_cg->default_groups[1] = NULL;
 	/*
 	 * Add core/alua/lu_gps/default_lu_gp
 	 */
@@ -2781,27 +2927,6 @@ int target_core_init_configfs(void)
 	lu_gp_cg->default_groups[1] = NULL;
 	se_global->default_lu_gp = lu_gp;
 	/*
-	 * Add core/alua/tg_pt_gps/default_tg_pt_gp
-	 */
-	tg_pt_gp = core_alua_allocate_tg_pt_gp("default_tg_pt_gp", 1);
-	if (!(tg_pt_gp))
-		goto out_global;
-
-	tg_pt_gp_cg = &se_global->alua_tg_pt_gps_group;
-	tg_pt_gp_cg->default_groups = kzalloc(sizeof(struct config_group) * 2,
-				GFP_KERNEL);
-	if (!(tg_pt_gp_cg->default_groups)) {
-		printk(KERN_ERR "Unable to allocate tg_pt_gp_cg->"
-				"default_groups\n");
-		goto out_global;
-	}
-
-	config_group_init_type_name(&tg_pt_gp->tg_pt_gp_group,
-			"default_tg_pt_gp", &target_core_alua_tg_pt_gp_cit);
-	tg_pt_gp_cg->default_groups[0] = &tg_pt_gp->tg_pt_gp_group;
-	tg_pt_gp_cg->default_groups[1] = NULL;
-	se_global->default_tg_pt_gp = tg_pt_gp;
-	/*
 	 * Register the target_core_mod subsystem with configfs.
 	 */
 	ret = configfs_register_subsystem(subsys);
@@ -2838,14 +2963,8 @@ out_global:
 		core_alua_free_lu_gp(se_global->default_lu_gp);
 		se_global->default_lu_gp = NULL;
 	}
-	if (se_global->default_tg_pt_gp) {
-		core_alua_free_tg_pt_gp(se_global->default_tg_pt_gp);
-		se_global->default_tg_pt_gp = NULL;
-	}
 	if (lu_gp_cg)
 		kfree(lu_gp_cg->default_groups);
-	if (tg_pt_gp_cg)
-		kfree(tg_pt_gp_cg->default_groups);
 	if (alua_cg)
 		kfree(alua_cg->default_groups);
 	if (hba_cg)
@@ -2858,22 +2977,13 @@ out_global:
 void target_core_exit_configfs(void)
 {
 	struct configfs_subsystem *subsys;
-	struct config_group *hba_cg, *alua_cg, *lu_gp_cg, *tg_pt_gp_cg;
+	struct config_group *hba_cg, *alua_cg, *lu_gp_cg;
 	struct config_item *item;
 	int i;
 
 	se_global->in_shutdown = 1;
 	subsys = target_core_subsystem[0];
 
-	tg_pt_gp_cg = &se_global->alua_tg_pt_gps_group;
-	for (i = 0; tg_pt_gp_cg->default_groups[i]; i++) {
-		item = &tg_pt_gp_cg->default_groups[i]->cg_item;
-		tg_pt_gp_cg->default_groups[i] = NULL;
-		config_item_put(item);
-	}
-	core_alua_free_tg_pt_gp(se_global->default_tg_pt_gp);
-	se_global->default_tg_pt_gp = NULL;
-
 	lu_gp_cg = &se_global->alua_lu_gps_group;
 	for (i = 0; lu_gp_cg->default_groups[i]; i++) {
 		item = &lu_gp_cg->default_groups[i]->cg_item;
-- 
1.5.4.1
