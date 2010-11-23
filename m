From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 5/8] target: simplify subsystem registration and lookup
Date: Tue, 23 Nov 2010 17:30:58 -0500
Message-ID: <20101123223110.413122129@bombadil.infradead.org>
References: <20101123223053.574330460@bombadil.infradead.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:50176 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753180Ab0KWWbL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 23 Nov 2010 17:31:11 -0500
Content-Disposition: inline; filename=lio-move-subsystem-registration
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: nab@linux-iscsi.org
Cc: linux-scsi@vger.kernel.org

Move the subsystem registration and lookup into target_core_hba.c, and
make the list of subsystems local to the file.  Get rid of the sub_api_hba_cnt
field and instead to proper reference counting of the module inside the
subsystem_mutex to make it non-racy vs module removal.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: lio-core/drivers/target/target_core_hba.c
===================================================================
--- lio-core.orig/drivers/target/target_core_hba.c	2010-11-23 22:36:42.000000000 +0100
+++ lio-core/drivers/target/target_core_hba.c	2010-11-23 22:43:18.977254087 +0100
@@ -44,10 +43,63 @@
 
 #include "target_core_hba.h"
 
+static LIST_HEAD(subsystem_list);
+static DEFINE_MUTEX(subsystem_mutex);
+
+int transport_subsystem_register(struct se_subsystem_api *sub_api)
+{
+	struct se_subsystem_api *s;
+
+	INIT_LIST_HEAD(&sub_api->sub_api_list);
+
+	mutex_lock(&subsystem_mutex);
+	list_for_each_entry(s, &subsystem_list, sub_api_list) {
+		if (!(strcmp(s->name, sub_api->name))) {
+			printk(KERN_ERR "%p is already registered with"
+				" duplicate name %s, unable to process"
+				" request\n", s, s->name);
+			mutex_unlock(&subsystem_mutex);
+			return -EEXIST;
+		}
+	}
+	list_add_tail(&sub_api->sub_api_list, &subsystem_list);
+	mutex_unlock(&subsystem_mutex);
+
+	printk(KERN_INFO "TCM: Registered subsystem plugin: %s struct module:"
+			" %p\n", sub_api->name, sub_api->owner);
+	return 0;
+}
+EXPORT_SYMBOL(transport_subsystem_register);
+
+void transport_subsystem_release(struct se_subsystem_api *sub_api)
+{
+	mutex_lock(&subsystem_mutex);
+	list_del(&sub_api->sub_api_list);
+	mutex_unlock(&subsystem_mutex);
+}
+EXPORT_SYMBOL(transport_subsystem_release);
+
+static struct se_subsystem_api *core_get_backend(const char *sub_name)
+{
+	struct se_subsystem_api *s;
+
+	mutex_lock(&subsystem_mutex);
+	list_for_each_entry(s, &subsystem_list, sub_api_list) {
+		if (!strcmp(s->name, sub_name))
+			goto found;
+	}
+	mutex_unlock(&subsystem_mutex);
+	return NULL;
+found:
+	if (s->owner && !try_module_get(s->owner))
+		s = NULL;
+	mutex_unlock(&subsystem_mutex);
+	return s;
+}
+
 struct se_hba *
 core_alloc_hba(const char *plugin_name, u32 plugin_dep_id, u32 hba_flags)
 {
-	struct se_subsystem_api *t;
 	struct se_hba *hba;
 	int ret = 0;
 
@@ -68,30 +120,13 @@ core_alloc_hba(const char *plugin_name,
 	atomic_set(&hba->max_queue_depth, 0);
 	atomic_set(&hba->left_queue_depth, 0);
 
-	t = transport_core_get_sub_by_name(plugin_name);
-	if (!t) {
+	hba->transport = core_get_backend(plugin_name);
+	if (!hba->transport) {
 		ret = -EINVAL;
 		goto out_free_hba;
 	}
 
-	hba->transport = t;
-
-	/*
-	 * Get TCM subsystem api struct module reference to struct se_hba
-	 */
-	if (t->owner) {
-		/*
-		 * Grab a struct module reference count for subsystem plugin
-		 */
-		if (!try_module_get(t->owner)) {
-			printk(KERN_ERR "try_module_get() failed for %s\n",
-				t->owner->name);
-			ret = -EINVAL;
-			goto out_put_subsystem;
-		}
-	}
-
-	ret = t->attach_hba(hba, plugin_dep_id);
+	ret = hba->transport->attach_hba(hba, plugin_dep_id);
 	if (ret < 0)
 		goto out_module_put;
 
@@ -106,11 +141,9 @@ core_alloc_hba(const char *plugin_name,
 	return hba;
 
 out_module_put:
-	if (t->owner)
-		module_put(t->owner);
-out_put_subsystem:
+	if (hba->transport->owner)
+		module_put(hba->transport->owner);
 	hba->transport = NULL;
-	transport_core_put_sub(t);
 out_free_hba:
 	kfree(hba);
 	return ERR_PTR(ret);
@@ -134,11 +167,6 @@ core_delete_hba(struct se_hba *hba)
 	spin_unlock(&hba->device_lock);
 
 	hba->transport->detach_hba(hba);
-	if (hba->transport->owner)
-		module_put(hba->transport->owner);
-
-	if (!(hba->hba_flags & HBA_FLAGS_INTERNAL_USE))
-		transport_core_put_sub(hba->transport);
 
 	spin_lock(&se_global->hba_lock);
 	list_del(&hba->hba_list);
@@ -149,6 +177,8 @@ core_delete_hba(struct se_hba *hba)
 	printk(KERN_INFO "CORE_HBA[%d] - Detached HBA from Generic Target"
 			" Core\n", hba->hba_id);
 
+	if (hba->transport->owner)
+		module_put(hba->transport->owner);
 	kfree(hba);
 	return 0;
 }
Index: lio-core/drivers/target/target_core_transport.c
===================================================================
--- lio-core.orig/drivers/target/target_core_transport.c	2010-11-23 22:34:07.000000000 +0100
+++ lio-core/drivers/target/target_core_transport.c	2010-11-23 22:37:25.121253389 +0100
@@ -289,13 +289,11 @@ int init_se_global(void)
 	INIT_LIST_HEAD(&global->g_se_tpg_list);
 	INIT_LIST_HEAD(&global->g_hba_list);
 	INIT_LIST_HEAD(&global->g_se_dev_list);
-	INIT_LIST_HEAD(&global->g_sub_api_list);
 	spin_lock_init(&global->g_device_lock);
 	spin_lock_init(&global->hba_lock);
 	spin_lock_init(&global->se_tpg_lock);
 	spin_lock_init(&global->lu_gps_lock);
 	spin_lock_init(&global->plugin_class_lock);
-	mutex_init(&global->g_sub_api_mutex);
 
 	se_cmd_cache = kmem_cache_create("se_cmd_cache",
 			sizeof(struct se_cmd), __alignof__(struct se_cmd), 0, NULL);
@@ -472,64 +470,6 @@ int transport_subsystem_check_init(void)
 	return 0;
 }
 
-int transport_subsystem_register(
-	struct se_subsystem_api *sub_api)
-{
-	struct se_subsystem_api *s;
-
-	INIT_LIST_HEAD(&sub_api->sub_api_list);
-
-	mutex_lock(&se_global->g_sub_api_mutex);
-	list_for_each_entry(s, &se_global->g_sub_api_list, sub_api_list) {
-		if (!(strcmp(s->name, sub_api->name))) {
-			printk(KERN_ERR "%p is already registered with"
-				" duplicate name %s, unable to process"
-				" request\n", s, s->name);
-			mutex_unlock(&se_global->g_sub_api_mutex);
-			return -EEXIST;
-		}
-	}
-	list_add_tail(&sub_api->sub_api_list, &se_global->g_sub_api_list);
-	mutex_unlock(&se_global->g_sub_api_mutex);
-
-	printk(KERN_INFO "TCM: Registered subsystem plugin: %s struct module:"
-			" %p\n", sub_api->name, sub_api->owner);
-	return 0;
-}
-EXPORT_SYMBOL(transport_subsystem_register);
-
-void transport_subsystem_release(struct se_subsystem_api *sub_api)
-{
-	mutex_lock(&se_global->g_sub_api_mutex);
-	list_del(&sub_api->sub_api_list);
-	mutex_unlock(&se_global->g_sub_api_mutex);
-}
-EXPORT_SYMBOL(transport_subsystem_release);
-
-struct se_subsystem_api *transport_core_get_sub_by_name(const char *sub_name)
-{
-	struct se_subsystem_api *s;
-
-	mutex_lock(&se_global->g_sub_api_mutex);
-	list_for_each_entry(s, &se_global->g_sub_api_list, sub_api_list) {
-		if (!(strcmp(s->name, sub_name))) {
-			atomic_inc(&s->sub_api_hba_cnt);
-			smp_mb__after_atomic_inc();
-			mutex_unlock(&se_global->g_sub_api_mutex);
-			return s;
-		}
-	}
-	mutex_unlock(&se_global->g_sub_api_mutex);
-
-	return NULL;
-}
-
-void transport_core_put_sub(struct se_subsystem_api *s)
-{
-	atomic_dec(&s->sub_api_hba_cnt);
-	smp_mb__after_atomic_dec();
-}
-
 struct se_session *transport_init_session(void)
 {
 	struct se_session *se_sess;
Index: lio-core/include/target/target_core_base.h
===================================================================
--- lio-core.orig/include/target/target_core_base.h	2010-11-23 22:34:08.000000000 +0100
+++ lio-core/include/target/target_core_base.h	2010-11-23 22:37:20.333253110 +0100
@@ -983,12 +983,10 @@ struct se_global {
 	struct list_head	g_se_tpg_list;
 	struct list_head	g_hba_list;
 	struct list_head	g_se_dev_list;
-	struct list_head	g_sub_api_list;
 	struct se_hba		*g_lun0_hba;
 	struct se_subsystem_dev *g_lun0_su_dev;
 	struct se_device	*g_lun0_dev;
 	struct t10_alua_lu_gp	*default_lu_gp;
-	struct mutex		g_sub_api_mutex;
 	spinlock_t		g_device_lock;
 	spinlock_t		hba_lock;
 	spinlock_t		se_tpg_lock;
Index: lio-core/include/target/target_core_transport.h
===================================================================
--- lio-core.orig/include/target/target_core_transport.h	2010-11-23 22:34:08.000000000 +0100
+++ lio-core/include/target/target_core_transport.h	2010-11-23 22:38:54.534253179 +0100
@@ -130,8 +130,6 @@ extern int transport_subsystem_check_ini
 extern int transport_subsystem_register(struct se_subsystem_api *);
 extern void transport_subsystem_release(struct se_subsystem_api *);
 extern void transport_load_plugins(void);
-extern struct se_subsystem_api *transport_core_get_sub_by_name(const char *);
-extern void transport_core_put_sub(struct se_subsystem_api *);
 extern struct se_session *transport_init_session(void);
 extern void __transport_register_session(struct se_portal_group *,
 					struct se_node_acl *,
@@ -238,10 +236,6 @@ struct se_subsystem_api {
 	 */
 	struct module *owner;
 	/*
-	 * Counter for struct se_hba reference
-	 */
-	atomic_t sub_api_hba_cnt;
-	/*
 	 * Used for global se_subsystem_api list_head
 	 */
 	struct list_head sub_api_list;

