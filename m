From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH] target: Call transport_new_cmd_failure() while draining qobj_list during LUN_RESET
Date: Wed, 12 Jan 2011 15:41:58 -0800
Message-ID: <1294875718-4555-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nm24.bullet.mail.sp2.yahoo.com ([98.139.91.94]:46701 "HELO
	nm24.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751845Ab1ALXmg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 12 Jan 2011 18:42:36 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: James Bottomley <James.Bottomley@suse.de>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch fixes a bug with TMR LUN_RESET operation for TCM fabric modules that
go into an uninterruptible sleeping state waiting for an unsolicited SCSI WRITE
buffer to become ready.  Currently fabric module code that have this requirement
(SW iSCSI only) will end up sleeping forever if the command being aborted is
from the pre-task execution qobj->qobj_list drain w/ TRANSPORT_NEW_CMD state
at the bottom on core_tmr_lun_reset().

The proper fix adds a call to transport_new_cmd_failure() and subsequent call to
struct target_core_fabric_ops->new_cmd_failure() in order to signal to fabric module
dependent code that the command containing unsolicited data out has been aborted,
and the payload should be dropped.

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_tmr.c       |    9 +++++++++
 drivers/target/target_core_transport.c |    3 +--
 include/target/target_core_transport.h |    1 +
 3 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/target/target_core_tmr.c b/drivers/target/target_core_tmr.c
index 7a54af7..f0d85ad 100644
--- a/drivers/target/target_core_tmr.c
+++ b/drivers/target/target_core_tmr.c
@@ -365,6 +365,15 @@ int core_tmr_lun_reset(
 			" %d t_fe_count: %d\n", (preempt_and_abort_list) ?
 			"Preempt" : "", cmd, state,
 			atomic_read(&T_TASK(cmd)->t_fe_count));
+		/*
+		 * Signal that the command has failed via cmd->se_cmd_flags,
+		 * and call TFO->new_cmd_failure() to wakeup any fabric
+		 * dependent code used to wait for unsolicited data out
+		 * allocation to complete.  The fabric module is expected
+		 * to dump any remaining unsolicited data out for the aborted
+		 * command at this point.
+		 */
+		transport_new_cmd_failure(cmd);
 
 		core_tmr_handle_tas_abort(tmr_nacl, cmd, tas,
 				atomic_read(&T_TASK(cmd)->t_fe_count));
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index e5949a6..a9913f1 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -222,7 +222,6 @@ static int transport_map_sg_to_mem(struct se_cmd *cmd,
 		u32 *se_mem_cnt);
 static void transport_memcpy_se_mem_read_contig(struct se_cmd *cmd,
 		unsigned char *dst, struct list_head *se_mem_list);
-static void transport_new_cmd_failure(struct se_cmd *se_cmd);
 static void transport_release_fe_cmd(struct se_cmd *cmd);
 static void transport_remove_cmd_from_queue(struct se_cmd *cmd,
 		struct se_queue_obj *qobj);
@@ -2704,7 +2703,7 @@ check_depth:
 	return 0;
 }
 
-static void transport_new_cmd_failure(struct se_cmd *se_cmd)
+void transport_new_cmd_failure(struct se_cmd *se_cmd)
 {
 	unsigned long flags;
 	/*
diff --git a/include/target/target_core_transport.h b/include/target/target_core_transport.h
index 7f59308..66f44e5 100644
--- a/include/target/target_core_transport.h
+++ b/include/target/target_core_transport.h
@@ -164,6 +164,7 @@ extern int transport_generic_allocate_tasks(struct se_cmd *, unsigned char *);
 extern int transport_generic_handle_cdb(struct se_cmd *);
 extern int transport_generic_handle_cdb_map(struct se_cmd *);
 extern int transport_generic_handle_data(struct se_cmd *);
+extern void transport_new_cmd_failure(struct se_cmd *);
 extern int transport_generic_handle_tmr(struct se_cmd *);
 extern void __transport_stop_task_timer(struct se_task *, unsigned long *);
 extern unsigned char transport_asciihex_to_binaryhex(unsigned char val[2]);
-- 
1.7.3.5

