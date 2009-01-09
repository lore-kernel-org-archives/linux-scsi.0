From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 4/5] [LIO-Target]: Convert iscsi_r2t_t to use struct
	kmem_cache
Date: Fri, 09 Jan 2009 12:54:53 -0800
Message-ID: <1231534493.4560.1003.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp114.sbc.mail.mud.yahoo.com ([68.142.198.213]:38228 "HELO
	smtp114.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756012AbZAIUzT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Jan 2009 15:55:19 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Linux-iSCSI.org Target Dev" <linux-iscsi-target-dev@googlegroups.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>

>From 45a2b80a11603c648e7f01423fa23c35cf8b543f Mon Sep 17 00:00:00 2001
From: Nicholas Bellinger <nab@linux-iscsi.org>
Date: Fri, 9 Jan 2009 10:48:49 -0800
Subject: [PATCH 4/5] [LIO-Target]: Convert iscsi_r2t_t to use struct kmem_cache

This patch converts usage of the structure iscsi_r2t_t to use
struct kmem_cache *lio_r2t_cache.  This patch also adds a missing
kmem_cache_free() in iscsi_target_util.c:iscsi_free_r2t(), which is currently
used exclusively by iscsi_target_tmr.c for ErrorRecoveryLevel=2 code.

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/lio-core/iscsi_target.c      |   11 +++++++++++
 drivers/lio-core/iscsi_target_util.c |    7 ++++---
 2 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/drivers/lio-core/iscsi_target.c b/drivers/lio-core/iscsi_target.c
index ccfaa48..bf7b478 100644
--- a/drivers/lio-core/iscsi_target.c
+++ b/drivers/lio-core/iscsi_target.c
@@ -99,6 +99,7 @@ struct kmem_cache *lio_sess_cache = NULL;
 struct kmem_cache *lio_qr_cache = NULL;
 struct kmem_cache *lio_dr_cache = NULL;
 struct kmem_cache *lio_ooo_cache = NULL;
+struct kmem_cache *lio_r2t_cache = NULL;
 
 extern int se_allocate_rl_cmd (se_cmd_t *, unsigned char *, u64);
 extern int iscsi_build_report_luns_response (iscsi_cmd_t *);
@@ -1141,6 +1142,13 @@ static int iscsi_target_detect(void)
 		goto out;
 	}
 
+	if (!(lio_r2t_cache = kmem_cache_create("lio_r2t_cache",
+			sizeof(iscsi_r2t_t), __alignof__(iscsi_r2t_t),
+			0, NULL))) {
+		printk(KERN_ERR "Unable to kmem_cache_create() for lio_r2t_cache\n");
+		goto out;
+	}
+
 	if (core_load_discovery_tpg() < 0)
 		goto out;
 
@@ -1160,6 +1168,8 @@ out:
 		kmem_cache_destroy(lio_dr_cache);
 	if (lio_ooo_cache)
 		kmem_cache_destroy(lio_ooo_cache);
+	if (lio_r2t_cache)
+		kmem_cache_destroy(lio_r2t_cache);
 	iscsi_deallocate_thread_sets(TARGET);
 	iscsi_target_deregister_configfs();
 #ifdef CONFIG_PROC_FS
@@ -1215,6 +1225,7 @@ extern void iscsi_target_release_phase2 (void)
 	kmem_cache_destroy(lio_qr_cache);
 	kmem_cache_destroy(lio_dr_cache);
 	kmem_cache_destroy(lio_ooo_cache);
+	kmem_cache_destroy(lio_r2t_cache);
 	core_release_discovery_tpg();
 	core_release_tiqns();
 	plugin_deregister_class(PLUGIN_TYPE_FRONTEND);
diff --git a/drivers/lio-core/iscsi_target_util.c b/drivers/lio-core/iscsi_target_util.c
index d170cdb..9c83f33 100644
--- a/drivers/lio-core/iscsi_target_util.c
+++ b/drivers/lio-core/iscsi_target_util.c
@@ -74,6 +74,7 @@ extern struct target_fabric_configfs *lio_target_fabric_configfs;
 extern iscsi_global_t *iscsi_global;
 extern struct kmem_cache *lio_cmd_cache;
 extern struct kmem_cache *lio_qr_cache;
+extern struct kmem_cache *lio_r2t_cache;
 
 extern int iscsi_add_nopin (iscsi_conn_t *, int);
 
@@ -197,11 +198,10 @@ extern int iscsi_add_r2t_to_list (
 {
 	iscsi_r2t_t *r2t;
 	
-	if (!(r2t = (iscsi_r2t_t *) kmalloc(sizeof(iscsi_r2t_t), GFP_ATOMIC))) {
+	if (!(r2t = (iscsi_r2t_t *) kmem_cache_zalloc(lio_r2t_cache, GFP_ATOMIC))) {
 		TRACE_ERROR("Unable to allocate memory for iscsi_r2t_t.\n");
 		return(-1);
 	}
-	memset(r2t, 0, sizeof(iscsi_r2t_t));
 
 	r2t->recovery_r2t = recovery;
 	r2t->r2t_sn = (!r2t_sn) ? cmd->r2t_sn++ : r2t_sn;
@@ -280,6 +280,7 @@ extern void iscsi_free_r2t (
 	iscsi_cmd_t *cmd)
 {
 	REMOVE_ENTRY_FROM_LIST(r2t, cmd->r2t_head, cmd->r2t_tail);
+	kmem_cache_free(lio_r2t_cache, r2t);
 
 	return;
 }
@@ -297,7 +298,7 @@ extern void iscsi_free_r2ts_from_list (
 	r2t = cmd->r2t_head;
 	while (r2t) {
 		r2t_next = r2t->next;
-		kfree(r2t);
+		kmem_cache_free(lio_r2t_cache, r2t);
 		r2t = r2t_next;
 	}
 	spin_unlock_bh(&cmd->r2t_lock);
-- 
1.5.4.1



