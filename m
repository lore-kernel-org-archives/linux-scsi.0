From: Mike Anderson <andmike@us.ibm.com>
Subject: [PATCH repost] aic94xx: sas_alloc_task
Date: Thu, 30 Mar 2006 09:13:32 -0800
Message-ID: <20060330171332.GA32555@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.144]:5829 "EHLO e4.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S932256AbWC3RlN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 30 Mar 2006 12:41:13 -0500
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e4.ny.us.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id k2UHf0xn009251
	for <linux-scsi@vger.kernel.org>; Thu, 30 Mar 2006 12:41:03 -0500
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay02.pok.ibm.com (8.12.10/NCO/VER6.8) with ESMTP id k2UHeoo9016102
	for <linux-scsi@vger.kernel.org>; Thu, 30 Mar 2006 12:40:50 -0500
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.12.11/8.13.3) with ESMTP id k2UHeoop024712
	for <linux-scsi@vger.kernel.org>; Thu, 30 Mar 2006 12:40:50 -0500
Received: from hmsbounty.us.ibm.com (sig-9-65-22-248.mts.ibm.com [9.65.22.248])
	by d01av03.pok.ibm.com (8.12.11/8.12.11) with ESMTP id k2UHen3W024410
	for <linux-scsi@vger.kernel.org>; Thu, 30 Mar 2006 12:40:49 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Check kmem_cache_alloc return prior to init of sas_task struct.

Signed-off-by: Mike Anderson <andmike@us.ibm.com>

 include/scsi/sas/sas_task.h |   14 ++++++++------
 1 files changed, 8 insertions(+), 6 deletions(-)

Index: aic94xx-sas-2.6-patched/include/scsi/sas/sas_task.h
===================================================================
--- aic94xx-sas-2.6-patched.orig/include/scsi/sas/sas_task.h	2006-03-28 09:19:29.000000000 -0800
+++ aic94xx-sas-2.6-patched/include/scsi/sas/sas_task.h	2006-03-30 08:46:06.000000000 -0800
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
