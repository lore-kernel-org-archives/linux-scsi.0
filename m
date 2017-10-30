From: Mike Christie <mchristi@redhat.com>
Subject: [PATCH 07/19] tcmu: fix unmap thread race
Date: Sun, 29 Oct 2017 22:44:27 -0500
Message-ID: <1509335079-5276-8-git-send-email-mchristi@redhat.com>
References: <1509335079-5276-1-git-send-email-mchristi@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38000 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752200AbdJ3Dou (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 29 Oct 2017 23:44:50 -0400
In-Reply-To: <1509335079-5276-1-git-send-email-mchristi@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, nab@linux-iscsi.org
Cc: Mike Christie <mchristi@redhat.com>

If the unmap thread has already run find_free_blocks
but not yet run prepare_to_wait when a wake_up(&unmap_wait)
call is done, the unmap thread is going to miss the wake
call. Instead of adding checks for if new waiters were added
this just has use a work queue which will run us again
in this type of case.

Signed-off-by: Mike Christie <mchristi@redhat.com>
---
 drivers/target/target_core_user.c | 43 +++++++++------------------------------
 1 file changed, 10 insertions(+), 33 deletions(-)

diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index 15b54fd..14d9b79 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -32,7 +32,7 @@
 #include <linux/highmem.h>
 #include <linux/configfs.h>
 #include <linux/mutex.h>
-#include <linux/kthread.h>
+#include <linux/workqueue.h>
 #include <net/genetlink.h>
 #include <scsi/scsi_common.h>
 #include <scsi/scsi_proto.h>
@@ -176,12 +176,11 @@ struct tcmu_cmd {
 	unsigned long flags;
 };
 
-static struct task_struct *unmap_thread;
-static wait_queue_head_t unmap_wait;
 static DEFINE_MUTEX(root_udev_mutex);
 static LIST_HEAD(root_udev);
 
 static atomic_t global_db_count = ATOMIC_INIT(0);
+static struct work_struct tcmu_unmap_work;
 
 static struct kmem_cache *tcmu_cmd_cache;
 
@@ -389,8 +388,7 @@ static bool tcmu_get_empty_blocks(struct tcmu_dev *udev,
 
 err:
 	udev->waiting_global = true;
-	/* Try to wake up the unmap thread */
-	wake_up(&unmap_wait);
+	schedule_work(&tcmu_unmap_work);
 	return false;
 }
 
@@ -1063,8 +1061,7 @@ static void tcmu_device_timedout(unsigned long data)
 	idr_for_each(&udev->commands, tcmu_check_expired_cmd, NULL);
 	spin_unlock_irqrestore(&udev->commands_lock, flags);
 
-	/* Try to wake up the ummap thread */
-	wake_up(&unmap_wait);
+	schedule_work(&tcmu_unmap_work);
 
 	/*
 	 * We don't need to wakeup threads on wait_cmdr since they have their
@@ -2042,23 +2039,10 @@ static void run_cmdr_queues(void)
 	mutex_unlock(&root_udev_mutex);
 }
 
-static int unmap_thread_fn(void *data)
+static void tcmu_unmap_work_fn(struct work_struct *work)
 {
-	while (!kthread_should_stop()) {
-		DEFINE_WAIT(__wait);
-
-		prepare_to_wait(&unmap_wait, &__wait, TASK_INTERRUPTIBLE);
-		schedule();
-		finish_wait(&unmap_wait, &__wait);
-
-		if (kthread_should_stop())
-			break;
-
-		find_free_blocks();
-		run_cmdr_queues();
-	}
-
-	return 0;
+	find_free_blocks();
+	run_cmdr_queues();
 }
 
 static int __init tcmu_module_init(void)
@@ -2067,6 +2051,8 @@ static int __init tcmu_module_init(void)
 
 	BUILD_BUG_ON((sizeof(struct tcmu_cmd_entry) % TCMU_OP_ALIGN_SIZE) != 0);
 
+	INIT_WORK(&tcmu_unmap_work, tcmu_unmap_work_fn);
+
 	tcmu_cmd_cache = kmem_cache_create("tcmu_cmd_cache",
 				sizeof(struct tcmu_cmd),
 				__alignof__(struct tcmu_cmd),
@@ -2112,17 +2098,8 @@ static int __init tcmu_module_init(void)
 	if (ret)
 		goto out_attrs;
 
-	init_waitqueue_head(&unmap_wait);
-	unmap_thread = kthread_run(unmap_thread_fn, NULL, "tcmu_unmap");
-	if (IS_ERR(unmap_thread)) {
-		ret = PTR_ERR(unmap_thread);
-		goto out_unreg_transport;
-	}
-
 	return 0;
 
-out_unreg_transport:
-	target_backend_unregister(&tcmu_ops);
 out_attrs:
 	kfree(tcmu_attrs);
 out_unreg_genl:
@@ -2137,7 +2114,7 @@ static int __init tcmu_module_init(void)
 
 static void __exit tcmu_module_exit(void)
 {
-	kthread_stop(unmap_thread);
+	cancel_work_sync(&tcmu_unmap_work);
 	target_backend_unregister(&tcmu_ops);
 	kfree(tcmu_attrs);
 	genl_unregister_family(&tcmu_genl_family);
-- 
1.8.3.1
