From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH-FOR-38] target: Fix t_transport_aborted handling in LUN_RESET + active I/O shutdown
Date: Thu, 24 Feb 2011 16:58:20 -0800
Message-ID: <1298595500-1558-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp102.sbc.mail.mud.yahoo.com ([68.142.198.201]:44657 "HELO
	smtp102.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755673Ab1BYA6c (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 24 Feb 2011 19:58:32 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

Hi James and Co,

This is a urgent target bugfix patch 'for-38' mainline.  At this point
everything else is non-critical, and is being queued up in 'for-39-misc'
branch going out to linux-scsi shortly.

Please review and apply,

--nab

-------------------------------------------------------------------------------------

This patch addresses two outstanding bugs related to T_TASK(cmd)->t_transport_aborted
handling during TMR LUN_RESET and active I/O shutdown.

This first involves adding two explict t_transport_aborted=1 assignments in
core_tmr_lun_reset() in order to signal the task has been aborted, and
updating transport_generic_wait_for_tasks() to skip sleeping when
t_transport_aborted=1 has been set.  This fixes an issue where
transport_generic_wait_for_tasks() would end up sleeping indefinately when
called from fabric module context while TMR LUN_RESET was happening with
long outstanding backend struct se_task not yet being completed.

The second adds a missing call to transport_remove_task_from_execute_queue()
when task->task_execute_queue=1 is set in order to fix an OOPs when
task->t_execute_list has not been dropped.  It also fixes the same case in
transport_processing_shutdown() to prevent the issue from happening during
active I/O struct se_device shutdown.

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_tmr.c       |    5 +++++
 drivers/target/target_core_transport.c |    8 ++++++--
 include/target/target_core_transport.h |    2 ++
 3 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/target/target_core_tmr.c b/drivers/target/target_core_tmr.c
index 158cecb..4a10983 100644
--- a/drivers/target/target_core_tmr.c
+++ b/drivers/target/target_core_tmr.c
@@ -282,6 +282,9 @@ int core_tmr_lun_reset(
 
 			atomic_set(&task->task_active, 0);
 			atomic_set(&task->task_stop, 0);
+		} else {
+			if (atomic_read(&task->task_execute_queue) != 0)
+				transport_remove_task_from_execute_queue(task, dev);
 		}
 		__transport_stop_task_timer(task, &flags);
 
@@ -301,6 +304,7 @@ int core_tmr_lun_reset(
 			DEBUG_LR("LUN_RESET: got t_transport_active = 1 for"
 				" task: %p, t_fe_count: %d dev: %p\n", task,
 				fe_count, dev);
+			atomic_set(&T_TASK(cmd)->t_transport_aborted, 1);
 			spin_unlock_irqrestore(&T_TASK(cmd)->t_state_lock,
 						flags);
 			core_tmr_handle_tas_abort(tmr_nacl, cmd, tas, fe_count);
@@ -310,6 +314,7 @@ int core_tmr_lun_reset(
 		}
 		DEBUG_LR("LUN_RESET: Got t_transport_active = 0 for task: %p,"
 			" t_fe_count: %d dev: %p\n", task, fe_count, dev);
+		atomic_set(&T_TASK(cmd)->t_transport_aborted, 1);
 		spin_unlock_irqrestore(&T_TASK(cmd)->t_state_lock, flags);
 		core_tmr_handle_tas_abort(tmr_nacl, cmd, tas, fe_count);
 
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 236e22d..4bbf6c1 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -1207,7 +1207,7 @@ transport_get_task_from_execute_queue(struct se_device *dev)
  *
  *
  */
-static void transport_remove_task_from_execute_queue(
+void transport_remove_task_from_execute_queue(
 	struct se_task *task,
 	struct se_device *dev)
 {
@@ -5549,7 +5549,8 @@ static void transport_generic_wait_for_tasks(
 
 		atomic_set(&T_TASK(cmd)->transport_lun_stop, 0);
 	}
-	if (!atomic_read(&T_TASK(cmd)->t_transport_active))
+	if (!atomic_read(&T_TASK(cmd)->t_transport_active) ||
+	     atomic_read(&T_TASK(cmd)->t_transport_aborted))
 		goto remove;
 
 	atomic_set(&T_TASK(cmd)->t_transport_stop, 1);
@@ -5956,6 +5957,9 @@ static void transport_processing_shutdown(struct se_device *dev)
 
 			atomic_set(&task->task_active, 0);
 			atomic_set(&task->task_stop, 0);
+		} else {
+			if (atomic_read(&task->task_execute_queue) != 0)
+				transport_remove_task_from_execute_queue(task, dev);
 		}
 		__transport_stop_task_timer(task, &flags);
 
diff --git a/include/target/target_core_transport.h b/include/target/target_core_transport.h
index 2469405..2e8ec51 100644
--- a/include/target/target_core_transport.h
+++ b/include/target/target_core_transport.h
@@ -135,6 +135,8 @@ extern void transport_complete_task(struct se_task *, int);
 extern void transport_add_task_to_execute_queue(struct se_task *,
 						struct se_task *,
 						struct se_device *);
+extern void transport_remove_task_from_execute_queue(struct se_task *,
+						struct se_device *);
 unsigned char *transport_dump_cmd_direction(struct se_cmd *);
 extern void transport_dump_dev_state(struct se_device *, char *, int *);
 extern void transport_dump_dev_info(struct se_device *, struct se_lun *,
-- 
1.7.4.1

