From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 1/5] [LIO-Target]: Convert iscsi_queue_req_t to use struct
	kmem_cache
Date: Fri, 09 Jan 2009 12:53:27 -0800
Message-ID: <1231534407.4560.997.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp116.sbc.mail.sp1.yahoo.com ([69.147.64.89]:47671 "HELO
	smtp116.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753973AbZAIUxw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Jan 2009 15:53:52 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Linux-iSCSI.org Target Dev" <linux-iscsi-target-dev@googlegroups.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>

>From 9c8fd0d95735fad86d7e488d4086eabdc7575c2c Mon Sep 17 00:00:00 2001
From: Nicholas Bellinger <nab@linux-iscsi.org>
Date: Fri, 9 Jan 2009 10:31:03 -0800
Subject: [PATCH 1/5] [LIO-Target]: Convert iscsi_queue_req_t to use struct kmem_cache

This patch converts usage of the structure iscsi_queue_req_t to use
struct kmem_cache *lio_qr_cache.

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/lio-core/iscsi_target.c      |   15 +++++++++++++--
 drivers/lio-core/iscsi_target_util.c |   15 +++++++--------
 2 files changed, 20 insertions(+), 10 deletions(-)

diff --git a/drivers/lio-core/iscsi_target.c b/drivers/lio-core/iscsi_target.c
index d95a506..5c73c82 100644
--- a/drivers/lio-core/iscsi_target.c
+++ b/drivers/lio-core/iscsi_target.c
@@ -96,6 +96,7 @@ iscsi_global_t *iscsi_global = NULL;
 
 struct kmem_cache *lio_cmd_cache = NULL;
 struct kmem_cache *lio_sess_cache = NULL;
+struct kmem_cache *lio_qr_cache = NULL;
 
 extern int se_allocate_rl_cmd (se_cmd_t *, unsigned char *, u64);
 extern int iscsi_build_report_luns_response (iscsi_cmd_t *);
@@ -1117,6 +1118,13 @@ static int iscsi_target_detect(void)
 		goto out;
 	}
 
+	if (!(lio_qr_cache = kmem_cache_create("lio_qr_cache",
+			sizeof(iscsi_queue_req_t), __alignof__(iscsi_queue_req_t),
+			0, NULL))) {
+		printk(KERN_ERR "nable to kmem_cache_create() for lio_qr_cache\n");
+		goto out;
+	}
+
 	if (core_load_discovery_tpg() < 0)
 		goto out;
 
@@ -1130,6 +1138,8 @@ out:
 		kmem_cache_destroy(lio_cmd_cache);
 	if (lio_sess_cache)
 		kmem_cache_destroy(lio_sess_cache);
+	if (lio_qr_cache)
+		kmem_cache_destroy(lio_qr_cache);
 	iscsi_deallocate_thread_sets(TARGET);
 	iscsi_target_deregister_configfs();
 #ifdef CONFIG_PROC_FS
@@ -1182,6 +1192,7 @@ extern void iscsi_target_release_phase2 (void)
 	iscsi_hba_del_all_hbas();
 	kmem_cache_destroy(lio_cmd_cache);
 	kmem_cache_destroy(lio_sess_cache);
+	kmem_cache_destroy(lio_qr_cache);
 	core_release_discovery_tpg();
 	core_release_tiqns();
 	plugin_deregister_class(PLUGIN_TYPE_FRONTEND);
@@ -4262,7 +4273,7 @@ get_immediate:
 			atomic_set(&conn->check_immediate_queue, 0);
 			cmd = qr->cmd;
 			state = qr->state;
-			kfree(qr);
+			kmem_cache_free(lio_qr_cache, qr);
 
 			spin_lock_bh(&cmd->istate_lock);
 			switch (state) {
@@ -4346,7 +4357,7 @@ get_response:
 		if ((qr = iscsi_get_cmd_from_response_queue(conn))) {
 			cmd = qr->cmd;
 			state = qr->state;
-			kfree(qr);
+			kmem_cache_free(lio_qr_cache, qr);
 
 			spin_lock_bh(&cmd->istate_lock);
 check_rsp_state:
diff --git a/drivers/lio-core/iscsi_target_util.c b/drivers/lio-core/iscsi_target_util.c
index cb679b8..d170cdb 100644
--- a/drivers/lio-core/iscsi_target_util.c
+++ b/drivers/lio-core/iscsi_target_util.c
@@ -73,6 +73,7 @@
 extern struct target_fabric_configfs *lio_target_fabric_configfs;
 extern iscsi_global_t *iscsi_global;
 extern struct kmem_cache *lio_cmd_cache;
+extern struct kmem_cache *lio_qr_cache;
 
 extern int iscsi_add_nopin (iscsi_conn_t *, int);
 
@@ -823,11 +824,10 @@ extern void iscsi_add_cmd_to_immediate_queue (iscsi_cmd_t *cmd, iscsi_conn_t *co
 {
 	iscsi_queue_req_t *qr;
 
-	if (!(qr = kmalloc(sizeof(iscsi_queue_req_t), GFP_ATOMIC))) {
+	if (!(qr = kmem_cache_zalloc(lio_qr_cache, GFP_ATOMIC))) {
 		TRACE_ERROR("Unable to allocate memory for iscsi_queue_req_t\n");
 		return;
 	}
-	memset(qr, 0, sizeof(iscsi_queue_req_t));
 #if 0
 	printk("Adding ITT: 0x%08x state: %d to immediate queue\n", cmd->init_task_tag, state);
 #endif
@@ -896,7 +896,7 @@ static void iscsi_remove_cmd_from_immediate_queue (iscsi_cmd_t *cmd, iscsi_conn_
 
 		atomic_dec(&qr->cmd->immed_queue_count);
 		REMOVE_ENTRY_FROM_LIST(qr, conn->immed_queue_head, conn->immed_queue_tail);
-		kfree(qr);
+		kmem_cache_free(lio_qr_cache, qr);
 
 		qr = qr_next;
 	}
@@ -918,11 +918,10 @@ extern void iscsi_add_cmd_to_response_queue (iscsi_cmd_t *cmd, iscsi_conn_t *con
 {
 	iscsi_queue_req_t *qr;
 
-	if (!(qr = kmalloc(sizeof(iscsi_queue_req_t), GFP_ATOMIC))) {
+	if (!(qr = kmem_cache_zalloc(lio_qr_cache, GFP_ATOMIC))) {
 		TRACE_ERROR("Unable to allocate memory for iscsi_queue_req_t\n");
 		return;
 	}
-	memset(qr, 0, sizeof(iscsi_queue_req_t));
 #if 0
 	printk("Adding ITT: 0x%08x state: %d to response queue\n", cmd->init_task_tag, state);
 #endif
@@ -995,7 +994,7 @@ static void iscsi_remove_cmd_from_response_queue (iscsi_cmd_t *cmd, iscsi_conn_t
 		atomic_dec(&qr->cmd->response_queue_count);
 		
 		REMOVE_ENTRY_FROM_LIST(qr, conn->response_queue_head, conn->response_queue_tail);
-		kfree(qr);
+		kmem_cache_free(lio_qr_cache, qr);
 
 		qr = qr_next;
 	}
@@ -1033,7 +1032,7 @@ extern void iscsi_free_queue_reqs_for_conn (iscsi_conn_t *conn)
 		if (qr->cmd)
 			atomic_dec(&qr->cmd->immed_queue_count);
 		
-		kfree(qr);
+		kmem_cache_free(lio_qr_cache, qr);
 		qr = qr_next;
 	}
 	conn->immed_queue_head = conn->immed_queue_tail = NULL;
@@ -1047,7 +1046,7 @@ extern void iscsi_free_queue_reqs_for_conn (iscsi_conn_t *conn)
 		if (qr->cmd)
 			atomic_dec(&qr->cmd->response_queue_count);
 		
-		kfree(qr);
+		kmem_cache_free(lio_qr_cache, qr);
 		qr = qr_next;
 	}
 	conn->response_queue_head = conn->response_queue_tail = NULL;
-- 
1.5.4.1



