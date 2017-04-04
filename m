From: Hannes Reinecke <hare@suse.de>
Subject: [PATCHv4 5/8] scsi: make eh_eflags persistent
Date: Tue,  4 Apr 2017 16:02:58 +0200
Message-ID: <1491314581-73795-6-git-send-email-hare@suse.de>
References: <1491314581-73795-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34621 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754041AbdDDODK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 4 Apr 2017 10:03:10 -0400
In-Reply-To: <1491314581-73795-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: James Bottomley <james.bottomley@hansenpartnership.com>, Christoph Hellwig <hch@lst.de>, Bart van Assche <bart.vanassche@sandisk.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

If a failed command is retried and fails again we need
to enter SCSI EH, otherwise we will never be able to
recover the command.
To detect this situation we must not clear scmd->eh_eflags
when EH finishes but rather make it persistent throughout
the lifetime of the command.

Reviewed-by: Benjamin Block <bblock@linux.vnet.ibm.com>
Reviewed-by: Bart Van Assche <bart.vanassche@sandisk.com>
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 Documentation/scsi/scsi_eh.txt      | 14 +++++++-------
 drivers/scsi/libsas/sas_scsi_host.c |  2 --
 drivers/scsi/scsi_error.c           |  4 ++--
 include/scsi/scsi_eh.h              |  1 +
 4 files changed, 10 insertions(+), 11 deletions(-)

diff --git a/Documentation/scsi/scsi_eh.txt b/Documentation/scsi/scsi_eh.txt
index 37eca00..4edb9c1c 100644
--- a/Documentation/scsi/scsi_eh.txt
+++ b/Documentation/scsi/scsi_eh.txt
@@ -105,11 +105,14 @@ function
 
  2. If the host supports asynchronous completion (as indicated by the
     no_async_abort setting in the host template) scsi_abort_command()
-    is invoked to schedule an asynchrous abort. If that fails
-    Step #3 is taken.
+    is invoked to schedule an asynchrous abort.
+    Asynchronous abort are not invoked for commands which the
+    SCSI_EH_ABORT_SCHEDULED flag is set (this indicates that the command
+    already had been aborted once, and this is a retry which failed),
+    or when the EH deadline is expired. In these case Step #3 is taken.
 
- 2. scsi_eh_scmd_add(scmd, SCSI_EH_CANCEL_CMD) is invoked for the
-    command.  See [1-3] for more information.
+ 3. scsi_eh_scmd_add(scmd, SCSI_EH_CANCEL_CMD) is invoked for the
+    command.  See [1-4] for more information.
 
 [1-3] Asynchronous command aborts
 
@@ -263,7 +266,6 @@ scmd->allowed.
 
  3. scmd recovered
     ACTION: scsi_eh_finish_cmd() is invoked to EH-finish scmd
-	- clear scmd->eh_eflags
 	- scsi_setup_cmd_retry()
 	- move from local eh_work_q to local eh_done_q
     LOCKING: none
@@ -456,8 +458,6 @@ except for #1 must be implemented by eh_strategy_handler().
 
  - shost->host_failed is zero.
 
- - Each scmd's eh_eflags field is cleared.
-
  - Each scmd is in such a state that scsi_setup_cmd_retry() on the
    scmd doesn't make any difference.
 
diff --git a/drivers/scsi/libsas/sas_scsi_host.c b/drivers/scsi/libsas/sas_scsi_host.c
index ee6b39a..87e5079 100644
--- a/drivers/scsi/libsas/sas_scsi_host.c
+++ b/drivers/scsi/libsas/sas_scsi_host.c
@@ -613,8 +613,6 @@ static void sas_eh_handle_sas_errors(struct Scsi_Host *shost, struct list_head *
 		SAS_DPRINTK("trying to find task 0x%p\n", task);
 		res = sas_scsi_find_task(task);
 
-		cmd->eh_eflags = 0;
-
 		switch (res) {
 		case TASK_IS_DONE:
 			SAS_DPRINTK("%s: task 0x%p is done\n", __func__,
diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 615e6c0..caacf69 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -188,7 +188,6 @@ static int scsi_host_eh_past_deadline(struct Scsi_Host *shost)
 		/*
 		 * Retry after abort failed, escalate to next level.
 		 */
-		scmd->eh_eflags &= ~SCSI_EH_ABORT_SCHEDULED;
 		SCSI_LOG_ERROR_RECOVERY(3,
 			scmd_printk(KERN_INFO, scmd,
 				    "previous abort failed\n"));
@@ -940,6 +939,7 @@ void scsi_eh_prep_cmnd(struct scsi_cmnd *scmd, struct scsi_eh_save *ses,
 	ses->result = scmd->result;
 	ses->underflow = scmd->underflow;
 	ses->prot_op = scmd->prot_op;
+	ses->eh_eflags = scmd->eh_eflags;
 
 	scmd->prot_op = SCSI_PROT_NORMAL;
 	scmd->eh_eflags = 0;
@@ -1003,6 +1003,7 @@ void scsi_eh_restore_cmnd(struct scsi_cmnd* scmd, struct scsi_eh_save *ses)
 	scmd->result = ses->result;
 	scmd->underflow = ses->underflow;
 	scmd->prot_op = ses->prot_op;
+	scmd->eh_eflags = ses->eh_eflags;
 }
 EXPORT_SYMBOL(scsi_eh_restore_cmnd);
 
@@ -1135,7 +1136,6 @@ static int scsi_eh_action(struct scsi_cmnd *scmd, int rtn)
  */
 void scsi_eh_finish_cmd(struct scsi_cmnd *scmd, struct list_head *done_q)
 {
-	scmd->eh_eflags = 0;
 	list_move_tail(&scmd->eh_entry, done_q);
 }
 EXPORT_SYMBOL(scsi_eh_finish_cmd);
diff --git a/include/scsi/scsi_eh.h b/include/scsi/scsi_eh.h
index 98d366b..a25b328 100644
--- a/include/scsi/scsi_eh.h
+++ b/include/scsi/scsi_eh.h
@@ -31,6 +31,7 @@ extern int scsi_get_sense_info_fld(const u8 * sense_buffer, int sb_len,
 struct scsi_eh_save {
 	/* saved state */
 	int result;
+	int eh_eflags;
 	enum dma_data_direction data_direction;
 	unsigned underflow;
 	unsigned char cmd_len;
-- 
1.8.5.6
