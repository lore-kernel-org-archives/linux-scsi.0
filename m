From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH] libsas: export sas_alloc_task()
Date: Fri, 27 May 2011 18:02:02 -0700
Message-ID: <20110528010202.13696.25504.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:49134 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757667Ab1E1BCD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 May 2011 21:02:03 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@parallels.com
Cc: Lindar Liu <lindar_liu@usish.com>, Xiangliang Yu <yuxiangl@marvell.com>, linux-scsi@vger.kernel.org, Jack Wang <jack_wang@usish.com>

Before isci adds a 3rd open coded user of this functionality just share
the libsas version.

Cc: Jack Wang <jack_wang@usish.com>
Cc: Lindar Liu <lindar_liu@usish.com>
Cc: Xiangliang Yu <yuxiangl@marvell.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/scsi/libsas/sas_init.c   |   27 ++++++++++++++++++++++++++-
 drivers/scsi/mvsas/mv_sas.c      |   28 +++-------------------------
 drivers/scsi/pm8001/pm8001_sas.c |   36 ++++++------------------------------
 include/scsi/libsas.h            |   26 ++------------------------
 4 files changed, 37 insertions(+), 80 deletions(-)

diff --git a/drivers/scsi/libsas/sas_init.c b/drivers/scsi/libsas/sas_init.c
index 2dc5534..408a46b 100644
--- a/drivers/scsi/libsas/sas_init.c
+++ b/drivers/scsi/libsas/sas_init.c
@@ -37,7 +37,32 @@
 
 #include "../scsi_sas_internal.h"
 
-struct kmem_cache *sas_task_cache;
+static struct kmem_cache *sas_task_cache;
+
+struct sas_task *sas_alloc_task(gfp_t flags)
+{
+	struct sas_task *task = kmem_cache_zalloc(sas_task_cache, flags);
+
+	if (task) {
+		INIT_LIST_HEAD(&task->list);
+		spin_lock_init(&task->task_state_lock);
+		task->task_state_flags = SAS_TASK_STATE_PENDING;
+		init_timer(&task->timer);
+		init_completion(&task->completion);
+	}
+
+	return task;
+}
+EXPORT_SYMBOL_GPL(sas_alloc_task);
+
+void sas_free_task(struct sas_task *task)
+{
+	if (task) {
+		BUG_ON(!list_empty(&task->list));
+		kmem_cache_free(sas_task_cache, task);
+	}
+}
+EXPORT_SYMBOL_GPL(sas_free_task);
 
 /*------------ SAS addr hash -----------*/
 void sas_hash_addr(u8 *hashed, const u8 *sas_addr)
diff --git a/drivers/scsi/mvsas/mv_sas.c b/drivers/scsi/mvsas/mv_sas.c
index 0ef2742..cc4c183 100644
--- a/drivers/scsi/mvsas/mv_sas.c
+++ b/drivers/scsi/mvsas/mv_sas.c
@@ -1518,28 +1518,6 @@ void mvs_dev_gone(struct domain_device *dev)
 	mvs_dev_gone_notify(dev);
 }
 
-static  struct sas_task *mvs_alloc_task(void)
-{
-	struct sas_task *task = kzalloc(sizeof(struct sas_task), GFP_KERNEL);
-
-	if (task) {
-		INIT_LIST_HEAD(&task->list);
-		spin_lock_init(&task->task_state_lock);
-		task->task_state_flags = SAS_TASK_STATE_PENDING;
-		init_timer(&task->timer);
-		init_completion(&task->completion);
-	}
-	return task;
-}
-
-static  void mvs_free_task(struct sas_task *task)
-{
-	if (task) {
-		BUG_ON(!list_empty(&task->list));
-		kfree(task);
-	}
-}
-
 static void mvs_task_done(struct sas_task *task)
 {
 	if (!del_timer(&task->timer))
@@ -1564,7 +1542,7 @@ static int mvs_exec_internal_tmf_task(struct domain_device *dev,
 	struct sas_task *task = NULL;
 
 	for (retry = 0; retry < 3; retry++) {
-		task = mvs_alloc_task();
+		task = sas_alloc_task(GFP_KERNEL);
 		if (!task)
 			return -ENOMEM;
 
@@ -1622,7 +1600,7 @@ static int mvs_exec_internal_tmf_task(struct domain_device *dev,
 				    SAS_ADDR(dev->sas_addr),
 				    task->task_status.resp,
 				    task->task_status.stat);
-			mvs_free_task(task);
+			sas_free_task(task);
 			task = NULL;
 
 		}
@@ -1630,7 +1608,7 @@ static int mvs_exec_internal_tmf_task(struct domain_device *dev,
 ex_err:
 	BUG_ON(retry == 3 && task != NULL);
 	if (task != NULL)
-		mvs_free_task(task);
+		sas_free_task(task);
 	return res;
 }
 
diff --git a/drivers/scsi/pm8001/pm8001_sas.c b/drivers/scsi/pm8001/pm8001_sas.c
index 6ae059e..412ee4b 100644
--- a/drivers/scsi/pm8001/pm8001_sas.c
+++ b/drivers/scsi/pm8001/pm8001_sas.c
@@ -669,30 +669,6 @@ int pm8001_dev_found(struct domain_device *dev)
 	return pm8001_dev_found_notify(dev);
 }
 
-/**
-  * pm8001_alloc_task - allocate a task structure for TMF
-  */
-static struct sas_task *pm8001_alloc_task(void)
-{
-	struct sas_task *task = kzalloc(sizeof(*task), GFP_KERNEL);
-	if (task) {
-		INIT_LIST_HEAD(&task->list);
-		spin_lock_init(&task->task_state_lock);
-		task->task_state_flags = SAS_TASK_STATE_PENDING;
-		init_timer(&task->timer);
-		init_completion(&task->completion);
-	}
-	return task;
-}
-
-static void pm8001_free_task(struct sas_task *task)
-{
-	if (task) {
-		BUG_ON(!list_empty(&task->list));
-		kfree(task);
-	}
-}
-
 static void pm8001_task_done(struct sas_task *task)
 {
 	if (!del_timer(&task->timer))
@@ -728,7 +704,7 @@ static int pm8001_exec_internal_tmf_task(struct domain_device *dev,
 	struct pm8001_hba_info *pm8001_ha = pm8001_find_ha_by_dev(dev);
 
 	for (retry = 0; retry < 3; retry++) {
-		task = pm8001_alloc_task();
+		task = sas_alloc_task(GFP_KERNEL);
 		if (!task)
 			return -ENOMEM;
 
@@ -789,14 +765,14 @@ static int pm8001_exec_internal_tmf_task(struct domain_device *dev,
 				SAS_ADDR(dev->sas_addr),
 				task->task_status.resp,
 				task->task_status.stat));
-			pm8001_free_task(task);
+			sas_free_task(task);
 			task = NULL;
 		}
 	}
 ex_err:
 	BUG_ON(retry == 3 && task != NULL);
 	if (task != NULL)
-		pm8001_free_task(task);
+		sas_free_task(task);
 	return res;
 }
 
@@ -811,7 +787,7 @@ pm8001_exec_internal_task_abort(struct pm8001_hba_info *pm8001_ha,
 	struct sas_task *task = NULL;
 
 	for (retry = 0; retry < 3; retry++) {
-		task = pm8001_alloc_task();
+		task = sas_alloc_task(GFP_KERNEL);
 		if (!task)
 			return -ENOMEM;
 
@@ -864,14 +840,14 @@ pm8001_exec_internal_task_abort(struct pm8001_hba_info *pm8001_ha,
 				SAS_ADDR(dev->sas_addr),
 				task->task_status.resp,
 				task->task_status.stat));
-			pm8001_free_task(task);
+			sas_free_task(task);
 			task = NULL;
 		}
 	}
 ex_err:
 	BUG_ON(retry == 3 && task != NULL);
 	if (task != NULL)
-		pm8001_free_task(task);
+		sas_free_task(task);
 	return res;
 }
 
diff --git a/include/scsi/libsas.h b/include/scsi/libsas.h
index 8f6bb9c..60d9e24 100644
--- a/include/scsi/libsas.h
+++ b/include/scsi/libsas.h
@@ -555,36 +555,14 @@ struct sas_task {
 	struct work_struct abort_work;
 };
 
-extern struct kmem_cache *sas_task_cache;
-
 #define SAS_TASK_STATE_PENDING      1
 #define SAS_TASK_STATE_DONE         2
 #define SAS_TASK_STATE_ABORTED      4
 #define SAS_TASK_NEED_DEV_RESET     8
 #define SAS_TASK_AT_INITIATOR       16
 
-static inline struct sas_task *sas_alloc_task(gfp_t flags)
-{
-	struct sas_task *task = kmem_cache_zalloc(sas_task_cache, flags);
-
-	if (task) {
-		INIT_LIST_HEAD(&task->list);
-		spin_lock_init(&task->task_state_lock);
-		task->task_state_flags = SAS_TASK_STATE_PENDING;
-		init_timer(&task->timer);
-		init_completion(&task->completion);
-	}
-
-	return task;
-}
-
-static inline void sas_free_task(struct sas_task *task)
-{
-	if (task) {
-		BUG_ON(!list_empty(&task->list));
-		kmem_cache_free(sas_task_cache, task);
-	}
-}
+extern struct sas_task *sas_alloc_task(gfp_t flags);
+extern void sas_free_task(struct sas_task *task);
 
 struct sas_domain_function_template {
 	/* The class calls these to notify the LLDD of an event. */

