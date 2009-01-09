From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 3/5] [LIO-Target]: Convert iscsi_ooo_cmdsn_t to use struct
	kmem_cache
Date: Fri, 09 Jan 2009 12:54:27 -0800
Message-ID: <1231534467.4560.1001.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1756894AbZAIUzO@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "Linux-iSCSI.org Target Dev" <linux-iscsi-target-dev@googlegroups.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

>From a85fbc2cce4ecaa68eb7bcf3b4fb158c7ae01650 Mon Sep 17 00:00:00 2001
From: Nicholas Bellinger <nab@linux-iscsi.org>
Date: Fri, 9 Jan 2009 10:42:44 -0800
Subject: [PATCH 3/5] [LIO-Target]: Convert iscsi_ooo_cmdsn_t to use struct kmem_cache

This patch converts usage of the structure iscsi_ooo_cmdsn_t (which is
used for MC/S out of order CmdSN execution) to use struct kmem_cache *lio_ooo_cache.

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/lio-core/iscsi_target.c      |   11 +++++++++++
 drivers/lio-core/iscsi_target_erl1.c |   11 ++++++-----
 2 files changed, 17 insertions(+), 5 deletions(-)

diff --git a/drivers/lio-core/iscsi_target.c b/drivers/lio-core/iscsi_target.c
index 77c0e52..ccfaa48 100644
--- a/drivers/lio-core/iscsi_target.c
+++ b/drivers/lio-core/iscsi_target.c
@@ -98,6 +98,7 @@ struct kmem_cache *lio_cmd_cache = NULL;
 struct kmem_cache *lio_sess_cache = NULL;
 struct kmem_cache *lio_qr_cache = NULL;
 struct kmem_cache *lio_dr_cache = NULL;
+struct kmem_cache *lio_ooo_cache = NULL;
 
 extern int se_allocate_rl_cmd (se_cmd_t *, unsigned char *, u64);
 extern int iscsi_build_report_luns_response (iscsi_cmd_t *);
@@ -1133,6 +1134,13 @@ static int iscsi_target_detect(void)
 		goto out;
 	}
 
+	if (!(lio_ooo_cache = kmem_cache_create("lio_ooo_cache",
+			sizeof(iscsi_ooo_cmdsn_t), __alignof__(iscsi_ooo_cmdsn_t),
+			0, NULL))) {
+		printk(KERN_ERR "Unable to kmem_cache_create() for lio_ooo_cache\n");
+		goto out;
+	}
+
 	if (core_load_discovery_tpg() < 0)
 		goto out;
 
@@ -1150,6 +1158,8 @@ out:
 		kmem_cache_destroy(lio_qr_cache);
 	if (lio_dr_cache)
 		kmem_cache_destroy(lio_dr_cache);
+	if (lio_ooo_cache)
+		kmem_cache_destroy(lio_ooo_cache);
 	iscsi_deallocate_thread_sets(TARGET);
 	iscsi_target_deregister_configfs();
 #ifdef CONFIG_PROC_FS
@@ -1204,6 +1214,7 @@ extern void iscsi_target_release_phase2 (void)
 	kmem_cache_destroy(lio_sess_cache);
 	kmem_cache_destroy(lio_qr_cache);
 	kmem_cache_destroy(lio_dr_cache);
+	kmem_cache_destroy(lio_ooo_cache);
 	core_release_discovery_tpg();
 	core_release_tiqns();
 	plugin_deregister_class(PLUGIN_TYPE_FRONTEND);
diff --git a/drivers/lio-core/iscsi_target_erl1.c b/drivers/lio-core/iscsi_target_erl1.c
index c95ece0..6a30e64 100644
--- a/drivers/lio-core/iscsi_target_erl1.c
+++ b/drivers/lio-core/iscsi_target_erl1.c
@@ -60,6 +60,8 @@
 
 #undef ISCSI_TARGET_ERL1_C
 
+extern struct kmem_cache *lio_ooo_cache;
+
 extern int iscsi_add_reject_from_cmd (u8, int, int, unsigned char *, iscsi_cmd_t *);
 extern int iscsi_build_r2ts_for_cmd (iscsi_cmd_t *, iscsi_conn_t *, int);
 extern int iscsi_build_report_luns_response (iscsi_cmd_t *);
@@ -832,12 +834,11 @@ static inline iscsi_ooo_cmdsn_t *iscsi_allocate_ooo_cmdsn (void)
 	iscsi_ooo_cmdsn_t *ooo_cmdsn = NULL;
 
 	if (!(ooo_cmdsn = (iscsi_ooo_cmdsn_t *)
-	      kmalloc(sizeof(iscsi_ooo_cmdsn_t), GFP_ATOMIC))) {
+	      kmem_cache_zalloc(lio_ooo_cache, GFP_ATOMIC))) {
 		TRACE_ERROR("Unable to allocate memory for"
 			" iscsi_ooo_cmdsn_t.\n");
 		return(NULL);
 	}
-	memset(ooo_cmdsn, 0, sizeof(iscsi_ooo_cmdsn_t));
 
 	return(ooo_cmdsn);
 }
@@ -909,7 +910,7 @@ extern void iscsi_remove_ooo_cmdsn (
 	iscsi_ooo_cmdsn_t *ooo_cmdsn)
 {
 	REMOVE_ENTRY_FROM_LIST(ooo_cmdsn, sess->ooo_cmdsn_head, sess->ooo_cmdsn_tail);
-	kfree(ooo_cmdsn);
+	kmem_cache_free(lio_ooo_cache, ooo_cmdsn);
 
 	return;
 }
@@ -1165,7 +1166,7 @@ extern void iscsi_free_all_ooo_cmdsns (iscsi_session_t *sess)
 	while (ooo_cmdsn) {
 		ooo_cmdsn_next = ooo_cmdsn->next;
 
-		kfree(ooo_cmdsn);
+		kmem_cache_free(lio_ooo_cache, ooo_cmdsn);
 		
 		ooo_cmdsn = ooo_cmdsn_next;
 	}
@@ -1214,7 +1215,7 @@ extern int iscsi_handle_ooo_cmdsn (
 	ooo_cmdsn->cmdsn		= cmdsn;
 
 	if (iscsi_attach_ooo_cmdsn(sess, ooo_cmdsn) < 0) {
-		kfree(ooo_cmdsn);
+		kmem_cache_free(lio_ooo_cache, ooo_cmdsn);
 		return(CMDSN_ERROR_CANNOT_RECOVER);
 	}
 	
-- 
1.5.4.1
