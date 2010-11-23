From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 2/8] target: remove core_get_hba/core_put_hba
Date: Tue, 23 Nov 2010 17:30:55 -0500
Message-ID: <20101123223109.640724989@bombadil.infradead.org>
References: <20101123223053.574330460@bombadil.infradead.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:50171 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752975Ab0KWWbK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 23 Nov 2010 17:31:10 -0500
Content-Disposition: inline; filename=lio-kill-get-put_hba
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: nab@linux-iscsi.org
Cc: linux-scsi@vger.kernel.org

No need for trivial wrappers around the mutex API.  Also replace
target_core_get_hba_from_item with a item_to_hba that just wraps the
container_of instead of including the locking.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: lio-core/drivers/target/target_core_configfs.c
===================================================================
--- lio-core.orig/drivers/target/target_core_configfs.c	2010-11-23 22:11:59.116252830 +0100
+++ lio-core/drivers/target/target_core_configfs.c	2010-11-23 22:12:05.405254018 +0100
@@ -61,18 +61,10 @@ struct target_core_configfs_attribute {
 	ssize_t (*store)(void *, const char *, size_t);
 };
 
-static struct se_hba *target_core_get_hba_from_item(
-	struct config_item *item)
+static inline struct se_hba *
+item_to_hba(struct config_item *item)
 {
-	struct se_hba *hba = container_of(to_config_group(item),
-				struct se_hba, hba_group);
-	if (!(hba))
-		return NULL;
-
-	if (core_get_hba(hba) < 0)
-		return NULL;
-
-	return hba;
+	return container_of(to_config_group(item), struct se_hba, hba_group);
 }
 
 /*
@@ -2815,33 +2807,24 @@ static struct config_group *target_core_
 {
 	struct t10_alua_tg_pt_gp *tg_pt_gp;
 	struct se_subsystem_dev *se_dev;
-	struct se_hba *hba;
 	struct se_subsystem_api *t;
-	struct config_item *hba_ci;
+	struct config_item *hba_ci = &group->cg_item;
+	struct se_hba *hba = item_to_hba(hba_ci);
 	struct config_group *dev_cg = NULL, *tg_pt_gp_cg = NULL;
 
-	hba_ci = &group->cg_item;
-	if (!(hba_ci)) {
-		printk(KERN_ERR "Unable to locate config_item hba_ci\n");
+	if (mutex_lock_interruptible(&hba->hba_access_mutex))
 		return NULL;
-	}
 
-	hba = target_core_get_hba_from_item(hba_ci);
-	if (!(hba)) {
-		printk(KERN_ERR "Unable to locate struct se_hba from struct config_item\n");
-		return NULL;
-	}
 	/*
 	 * Locate the struct se_subsystem_api from parent's struct se_hba.
 	 */
 	t = hba->transport;
 
 	se_dev = kzalloc(sizeof(struct se_subsystem_dev), GFP_KERNEL);
-	if (!(se_dev)) {
+	if (!se_dev) {
 		printk(KERN_ERR "Unable to allocate memory for"
 				" struct se_subsystem_dev\n");
-		core_put_hba(hba);
-		return NULL;
+		goto unlock;
 	}
 	INIT_LIST_HEAD(&se_dev->g_se_dev_list);
 	INIT_LIST_HEAD(&se_dev->t10_wwn.t10_vpd_list);
@@ -2926,7 +2909,7 @@ static struct config_group *target_core_
 	printk(KERN_INFO "Target_Core_ConfigFS: Allocated struct se_subsystem_dev:"
 		" %p se_dev_su_ptr: %p\n", se_dev, se_dev->se_dev_su_ptr);
 
-	core_put_hba(hba);
+	mutex_unlock(&hba->hba_access_mutex);
 	return &se_dev->se_dev_group;
 out:
 	if (T10_ALUA(se_dev)->default_tg_pt_gp) {
@@ -2940,7 +2923,8 @@ out:
 	if (se_dev->se_dev_su_ptr)
 		t->free_device(se_dev->se_dev_su_ptr);
 	kfree(se_dev);
-	core_put_hba(hba);
+unlock:
+	mutex_unlock(&hba->hba_access_mutex);
 	return NULL;
 }
 
@@ -2956,9 +2940,9 @@ static void target_core_drop_subdev(
 	struct config_group *dev_cg, *tg_pt_gp_cg;
 	int i, ret;
 
-	hba = target_core_get_hba_from_item(
-			&se_dev->se_dev_hba->hba_group.cg_item);
-	if (!(hba))
+	hba = item_to_hba(&se_dev->se_dev_hba->hba_group.cg_item);
+
+	if (mutex_lock_interruptible(&hba->hba_access_mutex))
 		goto out;
 
 	t = hba->transport;
@@ -3012,7 +2996,7 @@ static void target_core_drop_subdev(
 		"_dev_t: %p\n", se_dev);
 
 hba_out:
-	core_put_hba(hba);
+	mutex_unlock(&hba->hba_access_mutex);
 out:
 	kfree(se_dev);
 }
@@ -3188,8 +3172,7 @@ static void target_core_call_delhbafromt
 	struct config_group *group,
 	struct config_item *item)
 {
-	struct se_hba *hba = container_of(to_config_group(item), struct se_hba,
-				hba_group);
+	struct se_hba *hba = item_to_hba(item);
 
 	config_item_put(item);
 	se_core_del_hba(hba);
Index: lio-core/drivers/target/target_core_hba.c
===================================================================
--- lio-core.orig/drivers/target/target_core_hba.c	2010-11-23 22:11:59.110252691 +0100
+++ lio-core/drivers/target/target_core_hba.c	2010-11-23 22:12:05.407253459 +0100
@@ -44,12 +44,6 @@
 
 #include "target_core_hba.h"
 
-int core_get_hba(struct se_hba *hba)
-{
-	return ((mutex_lock_interruptible(&hba->hba_access_mutex) != 0) ?
-		-1 : 0);
-}
-
 struct se_hba *core_alloc_hba(void)
 {
 	struct se_hba *hba;
@@ -70,11 +64,6 @@ struct se_hba *core_alloc_hba(void)
 	return hba;
 }
 
-void core_put_hba(struct se_hba *hba)
-{
-	mutex_unlock(&hba->hba_access_mutex);
-}
-
 /*	se_core_add_hba():
  *
  *
Index: lio-core/drivers/target/target_core_hba.h
===================================================================
--- lio-core.orig/drivers/target/target_core_hba.h	2010-11-23 22:12:04.751252552 +0100
+++ lio-core/drivers/target/target_core_hba.h	2010-11-23 22:12:05.414253529 +0100
@@ -3,9 +3,7 @@
 
 extern struct kmem_cache *se_hba_cache;
 
-extern int core_get_hba(struct se_hba *);
 extern struct se_hba *core_alloc_hba(void);
-extern void core_put_hba(struct se_hba *);
 extern int se_core_add_hba(struct se_hba *, const char *, u32);
 extern int se_core_del_hba(struct se_hba *);
 

