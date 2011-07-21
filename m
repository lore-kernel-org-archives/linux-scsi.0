From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 028/103] target: Inline transport_get_task_from_execute_queue()
Date: Thu, 21 Jul 2011 00:05:04 -0700
Message-ID: <1311231979-6631-29-git-send-email-nab@linux-iscsi.org>
References: <1311231979-6631-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nm25.bullet.mail.bf1.yahoo.com ([98.139.212.184]:31433 "HELO
	nm25.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750834Ab1GUHH4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 21 Jul 2011 03:07:56 -0400
In-Reply-To: <1311231979-6631-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Andy Grover <agrover@redhat.com>

From: Andy Grover <agrover@redhat.com>

Only used in one place, and inline code is pretty short.

(nab: Fix __transport_execute_tasks() bugs from Andy's
 original patch)

Signed-off-by: Andy Grover <agrover@redhat.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_transport.c |   37 ++++++++-----------------------
 1 files changed, 10 insertions(+), 27 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 9c8641ea..e4406c9 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -1105,28 +1105,6 @@ static void transport_add_tasks_from_cmd(struct se_cmd *cmd)
 	spin_unlock_irqrestore(&dev->execute_task_lock, flags);
 }
 
-/*	transport_get_task_from_execute_queue():
- *
- *	Called with dev->execute_task_lock held.
- */
-static struct se_task *
-transport_get_task_from_execute_queue(struct se_device *dev)
-{
-	struct se_task *task;
-
-	if (list_empty(&dev->execute_task_list))
-		return NULL;
-
-	list_for_each_entry(task, &dev->execute_task_list, t_execute_list)
-		break;
-
-	list_del(&task->t_execute_list);
-	atomic_set(&task->task_execute_queue, 0);
-	atomic_dec(&dev->execute_tasks);
-
-	return task;
-}
-
 /*	transport_remove_task_from_execute_queue():
  *
  *
@@ -2541,7 +2519,7 @@ static int __transport_execute_tasks(struct se_device *dev)
 {
 	int error;
 	struct se_cmd *cmd = NULL;
-	struct se_task *task;
+	struct se_task *task = NULL;
 	unsigned long flags;
 
 	/*
@@ -2555,11 +2533,16 @@ check_depth:
 	dev->dev_tcq_window_closed = 0;
 
 	spin_lock_irq(&dev->execute_task_lock);
-	task = transport_get_task_from_execute_queue(dev);
-	spin_unlock_irq(&dev->execute_task_lock);
-
-	if (!task)
+	if (list_empty(&dev->execute_task_list)) {
+		spin_unlock_irq(&dev->execute_task_lock);
 		return 0;
+	}
+	task = list_first_entry(&dev->execute_task_list,
+				struct se_task, t_execute_list);
+	list_del(&task->t_execute_list);
+	atomic_set(&task->task_execute_queue, 0);
+	atomic_dec(&dev->execute_tasks);
+	spin_unlock_irq(&dev->execute_task_lock);
 
 	atomic_dec(&dev->depth_left);
 
-- 
1.7.6

