From: Mike Anderson <andmike@us.ibm.com>
Subject: [PATCH] aic94xx: sas_alloc_task
Date: Mon, 6 Mar 2006 00:30:25 -0800
Message-ID: <20060306083025.GA27811@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e6.ny.us.ibm.com ([32.97.182.146]:11239 "EHLO e6.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S1752255AbWCFIfT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Mar 2006 03:35:19 -0500
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e6.ny.us.ibm.com (8.12.11/8.12.11) with ESMTP id k268ZGWL029617
	for <linux-scsi@vger.kernel.org>; Mon, 6 Mar 2006 03:35:16 -0500
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay04.pok.ibm.com (8.12.10/NCO/VER6.8) with ESMTP id k268ZGln196274
	for <linux-scsi@vger.kernel.org>; Mon, 6 Mar 2006 03:35:16 -0500
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11/8.13.3) with ESMTP id k268ZGEq004160
	for <linux-scsi@vger.kernel.org>; Mon, 6 Mar 2006 03:35:16 -0500
Received: from hmsbounty.us.ibm.com (sig-9-48-82-56.mts.ibm.com [9.48.82.56])
	by d01av04.pok.ibm.com (8.12.11/8.12.11) with ESMTP id k268ZFKj004146
	for <linux-scsi@vger.kernel.org>; Mon, 6 Mar 2006 03:35:15 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Check kmem_cache_alloc return prior to init of sas_task struct.

Signed-off-by: Mike Anderson <andmike@us.ibm.com>

 include/scsi/sas/sas_task.h |   14 ++++++++------
 1 files changed, 8 insertions(+), 6 deletions(-)

Index: linux-2.6.9-patched/include/scsi/sas/sas_task.h
===================================================================
--- linux-2.6.9-patched.orig/include/scsi/sas/sas_task.h	2005-12-07 15:37:27.000000000 -0800
+++ linux-2.6.9-patched/include/scsi/sas/sas_task.h	2006-01-04 10:25:54.000000000 -0800
@@ -212,12 +212,14 @@ static inline struct sas_task *sas_alloc
 	extern kmem_cache_t *sas_task_cache;
 	struct sas_task *task = kmem_cache_alloc(sas_task_cache, flags);
 
-	memset(task, 0, sizeof(*task));
-	INIT_LIST_HEAD(&task->list);
-	spin_lock_init(&task->task_state_lock);
-	task->task_state_flags = SAS_TASK_STATE_PENDING;
-	init_timer(&task->timer);
-	init_completion(&task->completion);
+	if (task) {
+		memset(task, 0, sizeof(*task));
+		INIT_LIST_HEAD(&task->list);
+		spin_lock_init(&task->task_state_lock);
+		task->task_state_flags = SAS_TASK_STATE_PENDING;
+		init_timer(&task->timer);
+		init_completion(&task->completion);
+	}
 
 	return task;
 }
