From: James Bottomley <James.Bottomley@suse.de>
Subject: [GIT PATCH] SCSI bug fixes for 2.6.38-rc8
Date: Fri, 11 Mar 2011 18:32:48 -0600
Message-ID: <1299889968.6938.25.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

This is basically a single update for another couple of oopses in the
target code.

The patch is available here:

master.kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-rc-fixes-2.6.git

The short changelog is:

target: Fix t_transport_aborted handling in LUN_RESET + active I/O shutdown

The diffstat is:

 drivers/target/target_core_tmr.c       |    5 +++++
 drivers/target/target_core_transport.c |    8 ++++++--
 include/target/target_core_transport.h |    2 ++
 3 files changed, 13 insertions(+), 2 deletions(-)

And the patch is below.

James

---

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
