From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 3/3] scsi: Update documentation
Date: Thu, 31 Oct 2013 14:02:53 +0100
Message-ID: <1383224573-113346-4-git-send-email-hare@suse.de>
References: <1383224573-113346-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:35257 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753447Ab3JaNC6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 31 Oct 2013 09:02:58 -0400
In-Reply-To: <1383224573-113346-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, Ren Mingxin <renmx@cn.fujitsu.com>, Joern Engel <joern@logfs.org>, James Smart <james.smart@emulex.com>, Hannes Reinecke <hare@suse.de>

The documentation has gone out-of-sync, so update it to
the current status.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 Documentation/scsi/scsi_eh.txt          | 69 +++++++++++++++++++--------------
 Documentation/scsi/scsi_mid_low_api.txt |  9 ++++-
 drivers/scsi/scsi.c                     |  6 +--
 3 files changed, 48 insertions(+), 36 deletions(-)

diff --git a/Documentation/scsi/scsi_eh.txt b/Documentation/scsi/scsi_eh.txt
index 6ff16b6..a0c8511 100644
--- a/Documentation/scsi/scsi_eh.txt
+++ b/Documentation/scsi/scsi_eh.txt
@@ -42,20 +42,14 @@ discussion.
 
  Once LLDD gets hold of a scmd, either the LLDD will complete the
 command by calling scsi_done callback passed from midlayer when
-invoking hostt->queuecommand() or SCSI midlayer will time it out.
+invoking hostt->queuecommand() or the block layer will time it out.
 
 
 [1-2-1] Completing a scmd w/ scsi_done
 
  For all non-EH commands, scsi_done() is the completion callback.  It
-does the following.
-
- 1. Delete timeout timer.  If it fails, it means that timeout timer
-    has expired and is going to finish the command.  Just return.
-
- 2. Link scmd to per-cpu scsi_done_q using scmd->en_entry
-
- 3. Raise SCSI_SOFTIRQ
+just calls blk_complete_request() to delete the block layer timer and
+raise SCSI_SOFTIRQ
 
  SCSI_SOFTIRQ handler scsi_softirq calls scsi_decide_disposition() to
 determine what to do with the command.  scsi_decide_disposition()
@@ -64,10 +58,12 @@ with the command.
 
  - SUCCESS
 	scsi_finish_command() is invoked for the command.  The
-	function does some maintenance choirs and notify completion by
-	calling scmd->done() callback, which, for fs requests, would
-	be HLD completion callback - sd:sd_rw_intr, sr:rw_intr,
-	st:st_intr.
+	function does some maintenance chores and then calls
+	scsi_io_completion() to finish the I/O.
+	scsi_io_completion() then notifies the block layer on
+	the completed request by calling blk_end_request and
+	friends or figures out what to do with the remainder
+	of the data in case of an error.
 
  - NEEDS_RETRY
  - ADD_TO_MLQUEUE
@@ -86,33 +82,45 @@ function
  1. invokes optional hostt->eh_timed_out() callback.  Return value can
     be one of
 
-    - EH_HANDLED
-	This indicates that eh_timed_out() dealt with the timeout.  The
-	scmd is passed to __scsi_done() and thus linked into per-cpu
-	scsi_done_q.  Normal command completion described in [1-2-1]
-	follows.
+    - BLK_EH_HANDLED
+	This indicates that eh_timed_out() dealt with the timeout.
+	The command is passed back to the block layer and completed
+	via __blk_complete_requests().
+
+	*NOTE* After returning BLK_EH_HANDLED the SCSI layer is
+	assumed to be finished with the command, and no other
+	functions from the SCSI layer will be called. So this
+	should typically only be returned if the eh_timed_out()
+	handler raced with normal completion.
 
-    - EH_RESET_TIMER
+    - BLK_EH_RESET_TIMER
 	This indicates that more time is required to finish the
 	command.  Timer is restarted.  This action is counted as a
 	retry and only allowed scmd->allowed + 1(!) times.  Once the
-	limit is reached, action for EH_NOT_HANDLED is taken instead.
+	limit is reached, action for BLK_EH_NOT_HANDLED is taken instead.
 
-	*NOTE* This action is racy as the LLDD could finish the scmd
-	after the timeout has expired but before it's added back.  In
-	such cases, scsi_done() would think that timeout has occurred
-	and return without doing anything.  We lose completion and the
-	command will time out again.
-
-    - EH_NOT_HANDLED
-	This is the same as when eh_timed_out() callback doesn't exist.
+    - BLK_EH_NOT_HANDLED
+        eh_timed_out() callback did not handle the command.
 	Step #2 is taken.
 
+ 2. If the host supports asynchronous completion (as indicated by the
+    no_async_abort setting in the host template) scsi_abort_command()
+    is invoked to schedule an asynchrous abort. If that fails
+    Step #3 is taken.
+
  2. scsi_eh_scmd_add(scmd, SCSI_EH_CANCEL_CMD) is invoked for the
     command.  See [1-3] for more information.
 
+[1-3] Asynchronous command aborts
+
+ After a timeout occurs a command abort is scheduled from
+ scsi_abort_command(). If the abort is successful the command
+ will either be retried (if the number of retries is not exhausted)
+ or terminated with DID_TIME_OUT.
+ Otherwise scsi_eh_scmd_add() is invoked for the command.
+ See [1-4] for more information.
 
-[1-3] How EH takes over
+[1-4] How EH takes over
 
  scmds enter EH via scsi_eh_scmd_add(), which does the following.
 
@@ -320,7 +328,8 @@ scmd->allowed.
 
     <<scsi_eh_abort_cmds>>
 
-	This action is taken for each timed out command.
+	This action is taken for each timed out command when
+	no_async_abort is enabled in the host template.
 	hostt->eh_abort_handler() is invoked for each scmd.  The
 	handler returns SUCCESS if it has succeeded to make LLDD and
 	all related hardware forget about the scmd.
diff --git a/Documentation/scsi/scsi_mid_low_api.txt b/Documentation/scsi/scsi_mid_low_api.txt
index 2b06aba..d6a9bde 100644
--- a/Documentation/scsi/scsi_mid_low_api.txt
+++ b/Documentation/scsi/scsi_mid_low_api.txt
@@ -882,8 +882,11 @@ Details:
  *
  *      Calling context: kernel thread
  *
- *      Notes: Invoked from scsi_eh thread. No other commands will be
- *      queued on current host during eh.
+ *      Notes: If 'no_async_abort' is defined this callback
+ *  	will be invoked from scsi_eh thread. No other commands
+ *	will then be queued on current host during eh.
+ *	Otherwise it will be called whenever scsi_times_out()
+ *      is called due to a command timeout.
  *
  *      Optionally defined in: LLD
  **/
@@ -1257,6 +1260,8 @@ of interest:
                    address space
     use_clustering - 1=>SCSI commands in mid level's queue can be merged,
                      0=>disallow SCSI command merging
+    no_async_abort - 1=>Asynchronous aborts are not supported
+                     0=>Timed-out commands will be aborted asynchronously
     hostt        - pointer to driver's struct scsi_host_template from which
                    this struct Scsi_Host instance was spawned
     hostt->proc_name  - name of LLD. This is the driver name that sysfs uses
diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 2b04a57..d8afec8 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -745,15 +745,13 @@ int scsi_dispatch_cmd(struct scsi_cmnd *cmd)
 }
 
 /**
- * scsi_done - Enqueue the finished SCSI command into the done queue.
+ * scsi_done - Invoke completion on finished SCSI command.
  * @cmd: The SCSI Command for which a low-level device driver (LLDD) gives
  * ownership back to SCSI Core -- i.e. the LLDD has finished with it.
  *
  * Description: This function is the mid-level's (SCSI Core) interrupt routine,
  * which regains ownership of the SCSI command (de facto) from a LLDD, and
- * enqueues the command to the done queue for further processing.
- *
- * This is the producer of the done queue who enqueues at the tail.
+ * calls blk_complete_request() for further processing.
  *
  * This function is interrupt context safe.
  */
-- 
1.8.1.4

