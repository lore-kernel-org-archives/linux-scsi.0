From: Jeff Skirvin <jeffrey.d.skirvin@intel.com>
Subject: [PATCH] [SCSI] isci: Fix a race condition in the SSP task
 management path
Date: Thu, 11 Jul 2013 17:18:58 -0700
Message-ID: <20130712001858.8579.45431.stgit@psthomso-linux>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:52898 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757320Ab3GLPUx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 Jul 2013 11:20:53 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jeffrey.d.skirvin@intel.com, lukasz.dorau@intel.com, patrick.s.thomson@intel.com, JBottomley@parallels.com, linux-scsi@vger.kernel.org

This commit fixes a race condition in the isci driver abort task and SSP
device task management path.  The race is caused when an I/O termination
in the SCU hardware is necessary because of an SSP target timeout condition,
and the check of the I/O end state races against the HW-termination-driven
end state.  The failure of the race meant that no TMF was sent to the device
to clean-up the pending I/O.

Signed-off-by: Jeff Skirvin <jeffrey.d.skirvin@intel.com>
Reviewed-by: Lukasz Dorau <lukasz.dorau@intel.com>
Cc: <stable@vger.kernel.org>
---
 drivers/scsi/isci/task.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/isci/task.c b/drivers/scsi/isci/task.c
index 9bb020a..0d30ca8 100644
--- a/drivers/scsi/isci/task.c
+++ b/drivers/scsi/isci/task.c
@@ -491,6 +491,7 @@ int isci_task_abort_task(struct sas_task *task)
 	struct isci_tmf           tmf;
 	int                       ret = TMF_RESP_FUNC_FAILED;
 	unsigned long             flags;
+	int                       target_done_already = 0;
 
 	/* Get the isci_request reference from the task.  Note that
 	 * this check does not depend on the pending request list
@@ -505,9 +506,11 @@ int isci_task_abort_task(struct sas_task *task)
 	/* If task is already done, the request isn't valid */
 	if (!(task->task_state_flags & SAS_TASK_STATE_DONE) &&
 	    (task->task_state_flags & SAS_TASK_AT_INITIATOR) &&
-	    old_request)
+	    old_request) {
 		idev = isci_get_device(task->dev->lldd_dev);
-
+		target_done_already = test_bit(IREQ_COMPLETE_IN_TARGET,
+					       &old_request->flags);
+	}
 	spin_unlock(&task->task_state_lock);
 	spin_unlock_irqrestore(&ihost->scic_lock, flags);
 
@@ -561,7 +564,7 @@ int isci_task_abort_task(struct sas_task *task)
 
 	if (task->task_proto == SAS_PROTOCOL_SMP ||
 	    sas_protocol_ata(task->task_proto) ||
-	    test_bit(IREQ_COMPLETE_IN_TARGET, &old_request->flags) ||
+	    target_done_already ||
 	    test_bit(IDEV_GONE, &idev->flags)) {
 
 		spin_unlock_irqrestore(&ihost->scic_lock, flags);

