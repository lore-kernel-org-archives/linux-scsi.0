From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH] target: Fix task->task_execute_queue=1 clear bug + LUN_RESET OOPs
Date: Mon,  9 May 2011 09:44:16 -0700
Message-ID: <1304959456-21647-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Christoph Hellwig <hch@lst.de>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

Hi James,

This is one more (and hopefully the last) critical target bugfix that needs
to be sent to Linus for .39.  Also please CC stable@kernel.org to ensure
this bugfix makes it into .38.x along with the previous three part series here:

[PATCH 0/3] target: Bugfixes for .39-rc7
http://marc.info/?l=linux-scsi&m=130479565027757&w=2

The original three part for-39 series together with this patch are available
directly here:

  git://git.kernel.org/pub/scm/linux/kernel/git/nab/scsi-post-merge-2.6.git for-39-rc-fixes


Please review and merge.

Thanks,

--nab

---------------------------------------------------------------------------

This patch fixes a bug where task->task_execute_queue=1 was not being
cleared once se_task had been removed from se_device->execute_task_list,
resulting in an OOPs in core_tmr_lun_reset() for the task->task_active=0
case where transport_remove_task_from_execute_queue() was incorrectly
being called.

This patch fixes two cases in transport_get_task_from_execute_queue()
and transport_remove_task_from_execute_queue() to properly clear
task->task_execute_queue=0 once list_del(&task->t_execute_list) has
been called.

It also adds an explict check in transport_remove_task_from_execute_queue()
to dump_stack + return if called with task->task_execute_queue=0.

Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_transport.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 3eeb3e2..beaf8fa 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -1194,6 +1194,7 @@ transport_get_task_from_execute_queue(struct se_device *dev)
 		break;
 
 	list_del(&task->t_execute_list);
+	atomic_set(&task->task_execute_queue, 0);
 	atomic_dec(&dev->execute_tasks);
 
 	return task;
@@ -1209,8 +1210,14 @@ void transport_remove_task_from_execute_queue(
 {
 	unsigned long flags;
 
+	if (atomic_read(&task->task_execute_queue) == 0) {
+		dump_stack();
+		return;
+	}
+
 	spin_lock_irqsave(&dev->execute_task_lock, flags);
 	list_del(&task->t_execute_list);
+	atomic_set(&task->task_execute_queue, 0);
 	atomic_dec(&dev->execute_tasks);
 	spin_unlock_irqrestore(&dev->execute_task_lock, flags);
 }
-- 
1.7.5.1
