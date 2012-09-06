From: Jeff Skirvin <jeffrey.d.skirvin@intel.com>
Subject: [PATCH] isci: Allow SSP tasks into the task management path.
Date: Thu, 06 Sep 2012 10:56:49 -0700
Message-ID: <20120906175608.30998.36898.stgit@jdskirvi-devbox.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:24692 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932075Ab2IFRhr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 6 Sep 2012 13:37:47 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: linux-scsi@vger.kernel.org, jeffrey.d.skirvin@intel.com, dave.jiang@intel.com

This commit fixes a driver bug for SSP tasks that require task management
in the target after they complete in the SCU hardware.  The problem was
manifested in the function "isci_task_abort_task", which tests
to see if the sas_task.lldd_task is non-NULL before allowing task
management; this bug would always NULL lldd_task in the SCU I/O completion
path even if target management was required, which would prevent
task / target manangement from happening.

Note that in the case of SATA/STP targets, error recovery is provided by
the libata error handler which is why SATA/STP device recovery worked
correctly even though SSP handling did not.

Signed-off-by: Jeff Skirvin <jeffrey.d.skirvin@intel.com>
---
Resubmitting to include James...

 drivers/scsi/isci/host.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/isci/host.c b/drivers/scsi/isci/host.c
index 45385f5..446fdd8 100644
--- a/drivers/scsi/isci/host.c
+++ b/drivers/scsi/isci/host.c
@@ -1079,7 +1079,6 @@ static void sci_controller_completion_handler(struct isci_host *ihost)
 
 void ireq_done(struct isci_host *ihost, struct isci_request *ireq, struct sas_task *task)
 {
-	task->lldd_task = NULL;
 	if (!test_bit(IREQ_ABORT_PATH_ACTIVE, &ireq->flags) &&
 	    !(task->task_state_flags & SAS_TASK_STATE_ABORTED)) {
 		if (test_bit(IREQ_COMPLETE_IN_TARGET, &ireq->flags)) {
@@ -1087,16 +1086,19 @@ void ireq_done(struct isci_host *ihost, struct isci_request *ireq, struct sas_ta
 			dev_dbg(&ihost->pdev->dev,
 				"%s: Normal - ireq/task = %p/%p\n",
 				__func__, ireq, task);
-
+			task->lldd_task = NULL;
 			task->task_done(task);
 		} else {
 			dev_dbg(&ihost->pdev->dev,
 				"%s: Error - ireq/task = %p/%p\n",
 				__func__, ireq, task);
-
+			if (sas_protocol_ata(task->task_proto))
+				task->lldd_task = NULL;
 			sas_task_abort(task);
 		}
-	}
+	} else
+		task->lldd_task = NULL;
+
 	if (test_and_clear_bit(IREQ_ABORT_PATH_ACTIVE, &ireq->flags))
 		wake_up_all(&ihost->eventq);
 

