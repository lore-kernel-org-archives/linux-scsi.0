From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 3/8] target: remove se_hba_cache
Date: Tue, 23 Nov 2010 17:30:56 -0500
Message-ID: <20101123223109.874349746@bombadil.infradead.org>
References: <20101123223053.574330460@bombadil.infradead.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:50172 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752991Ab0KWWbK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 23 Nov 2010 17:31:10 -0500
Content-Disposition: inline; filename=lio-kill-se_hba_cache
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: nab@linux-iscsi.org
Cc: linux-scsi@vger.kernel.org

There is no need of a slab cache for the hba structures.  There's very few of
them and their allocation it in a slow path.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: lio-core/drivers/target/target_core_configfs.c
===================================================================
--- lio-core.orig/drivers/target/target_core_configfs.c	2010-11-23 22:12:05.405254018 +0100
+++ lio-core/drivers/target/target_core_configfs.c	2010-11-23 22:33:25.000253320 +0100
@@ -3163,7 +3163,7 @@ static struct config_group *target_core_
 
 	return &hba->hba_group;
 out:
-	kmem_cache_free(se_hba_cache, hba);
+	kfree(hba);
 	return ERR_PTR(ret);
 }
 
Index: lio-core/drivers/target/target_core_device.c
===================================================================
--- lio-core.orig/drivers/target/target_core_device.c	2010-11-23 22:11:59.006253249 +0100
+++ lio-core/drivers/target/target_core_device.c	2010-11-23 22:33:25.014252691 +0100
@@ -1619,7 +1619,7 @@ int core_dev_setup_virtual_lun0(void)
 	ret = se_core_add_hba(hba, "rd_dr", 0);
 	if (ret < 0) {
 		printk("se_core_add_hba() with %d\n", ret);
-		kmem_cache_free(se_hba_cache, hba);
+		kfree(hba);
 		return ret;
 	}
 
Index: lio-core/drivers/target/target_core_hba.c
===================================================================
--- lio-core.orig/drivers/target/target_core_hba.c	2010-11-23 22:12:05.407253459 +0100
+++ lio-core/drivers/target/target_core_hba.c	2010-11-23 22:33:25.026253459 +0100
@@ -48,8 +48,8 @@ struct se_hba *core_alloc_hba(void)
 {
 	struct se_hba *hba;
 
-	hba = kmem_cache_zalloc(se_hba_cache, GFP_KERNEL);
-	if (!(hba)) {
+	hba = kmalloc(sizeof(*hba), GFP_KERNEL);
+	if (!hba) {
 		printk(KERN_ERR "Unable to allocate struct se_hba\n");
 		return NULL;
 	}
@@ -185,6 +185,6 @@ int se_core_del_hba(
 	printk(KERN_INFO "CORE_HBA[%d] - Detached HBA from Generic Target"
 			" Core\n", hba->hba_id);
 
-	kmem_cache_free(se_hba_cache, hba);
+	kfree(hba);
 	return 0;
 }
Index: lio-core/drivers/target/target_core_transport.c
===================================================================
--- lio-core.orig/drivers/target/target_core_transport.c	2010-11-23 22:12:04.780253599 +0100
+++ lio-core/drivers/target/target_core_transport.c	2010-11-23 22:31:34.244253249 +0100
@@ -190,7 +190,6 @@ struct se_global *se_global;
 static struct kmem_cache *se_cmd_cache;
 static struct kmem_cache *se_sess_cache;
 struct kmem_cache *se_tmr_req_cache;
-struct kmem_cache *se_hba_cache;
 struct kmem_cache *se_ua_cache;
 struct kmem_cache *se_mem_cache;
 struct kmem_cache *t10_pr_reg_cache;
@@ -320,14 +319,6 @@ int init_se_global(void)
 				" failed\n");
 		goto out;
 	}
-	se_hba_cache = kmem_cache_create("se_hba_cache",
-			sizeof(struct se_hba), __alignof__(struct se_hba),
-			0, NULL);
-	if (!(se_hba_cache)) {
-		printk(KERN_ERR "kmem_cache_create() for struct se_hba"
-				" failed\n");
-		goto out;
-	}
 	se_ua_cache = kmem_cache_create("se_ua_cache",
 			sizeof(struct se_ua), __alignof__(struct se_ua),
 			0, NULL);
@@ -394,8 +385,6 @@ out:
 		kmem_cache_destroy(se_tmr_req_cache);
 	if (se_sess_cache)
 		kmem_cache_destroy(se_sess_cache);
-	if (se_hba_cache)
-		kmem_cache_destroy(se_hba_cache);
 	if (se_ua_cache)
 		kmem_cache_destroy(se_ua_cache);
 	if (se_mem_cache)
@@ -425,7 +414,6 @@ void release_se_global(void)
 	kmem_cache_destroy(se_cmd_cache);
 	kmem_cache_destroy(se_tmr_req_cache);
 	kmem_cache_destroy(se_sess_cache);
-	kmem_cache_destroy(se_hba_cache);
 	kmem_cache_destroy(se_ua_cache);
 	kmem_cache_destroy(se_mem_cache);
 	kmem_cache_destroy(t10_pr_reg_cache);
Index: lio-core/drivers/target/target_core_hba.h
===================================================================
--- lio-core.orig/drivers/target/target_core_hba.h	2010-11-23 22:12:05.414253529 +0100
+++ lio-core/drivers/target/target_core_hba.h	2010-11-23 22:33:25.033252901 +0100
@@ -1,8 +1,6 @@
 #ifndef TARGET_CORE_HBA_H
 #define TARGET_CORE_HBA_H
 
-extern struct kmem_cache *se_hba_cache;
-
 extern struct se_hba *core_alloc_hba(void);
 extern int se_core_add_hba(struct se_hba *, const char *, u32);
 extern int se_core_del_hba(struct se_hba *);

