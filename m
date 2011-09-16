From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 1/5] target: Fix race between multiple invocations of target_qf_do_work()
Date: Fri, 16 Sep 2011 10:38:22 +0000
Message-ID: <1316169506-4441-2-git-send-email-nab@linux-iscsi.org>
References: <1316169506-4441-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:54896 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752811Ab1IPLEn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 16 Sep 2011 07:04:43 -0400
In-Reply-To: <1316169506-4441-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Roland Dreier <roland@purestorage.com>

From: Roland Dreier <roland@purestorage.com>

When work is scheduled with schedule_work(), the work can end up
running on multiple CPUs at the same time -- this happens if
the work is already running on one CPU and schedule_work() is called
on another CPU.  This leads to list corruption with target_qf_do_work(),
which is roughly doing:

	spin_lock(...);
	list_for_each_entry_safe(...) {
		list_del(...);
		spin_unlock(...);

		// do stuff

		spin_lock(...);
	}

With multiple CPUs running this code, one CPU can end up deleting the
list entry that the other CPU is about to work on.

Fix this by splicing the list entries onto a local list and then
operating on that in the work function.  This way, each invocation of
target_qf_do_work() operates on its own local list and so multiple
invocations don't corrupt each other's list.  This also avoids dropping
and reacquiring the lock for each list entry.

Signed-off-by: Roland Dreier <roland@purestorage.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_transport.c |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 8d0c58e..a4b0a8d 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -977,15 +977,17 @@ static void target_qf_do_work(struct work_struct *work)
 {
 	struct se_device *dev = container_of(work, struct se_device,
 					qf_work_queue);
+	LIST_HEAD(qf_cmd_list);
 	struct se_cmd *cmd, *cmd_tmp;
 
 	spin_lock_irq(&dev->qf_cmd_lock);
-	list_for_each_entry_safe(cmd, cmd_tmp, &dev->qf_cmd_list, se_qf_node) {
+	list_splice_init(&dev->qf_cmd_list, &qf_cmd_list);
+	spin_unlock_irq(&dev->qf_cmd_lock);
 
+	list_for_each_entry_safe(cmd, cmd_tmp, &qf_cmd_list, se_qf_node) {
 		list_del(&cmd->se_qf_node);
 		atomic_dec(&dev->dev_qf_count);
 		smp_mb__after_atomic_dec();
-		spin_unlock_irq(&dev->qf_cmd_lock);
 
 		pr_debug("Processing %s cmd: %p QUEUE_FULL in work queue"
 			" context: %s\n", cmd->se_tfo->get_fabric_name(), cmd,
@@ -997,10 +999,7 @@ static void target_qf_do_work(struct work_struct *work)
 		 * has been added to head of queue
 		 */
 		transport_add_cmd_to_queue(cmd, cmd->t_state);
-
-		spin_lock_irq(&dev->qf_cmd_lock);
 	}
-	spin_unlock_irq(&dev->qf_cmd_lock);
 }
 
 unsigned char *transport_dump_cmd_direction(struct se_cmd *cmd)
-- 
1.5.6.5

