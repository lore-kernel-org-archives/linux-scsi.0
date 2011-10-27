From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 05/11] isci: No task_done callbacks in error handler paths.
Date: Thu, 27 Oct 2011 15:05:11 -0700
Message-ID: <20111027220511.4941.50602.stgit@localhost6.localdomain6>
References: <20111027220346.4941.43260.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:36746 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754364Ab1J0WFN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 27 Oct 2011 18:05:13 -0400
In-Reply-To: <20111027220346.4941.43260.stgit@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Jeff Skirvin <jeffrey.d.skirvin@intel.com>

From: Jeff Skirvin <jeffrey.d.skirvin@intel.com>

libsas will cleanup pending sas_tasks after error handler
path functions are called; do not call task_done callbacks.

Signed-off-by: Jeff Skirvin <jeffrey.d.skirvin@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/scsi/isci/task.c |   69 +++++++++-------------------------------------
 1 files changed, 14 insertions(+), 55 deletions(-)

diff --git a/drivers/scsi/isci/task.c b/drivers/scsi/isci/task.c
index 4175f17..c1f439b 100644
--- a/drivers/scsi/isci/task.c
+++ b/drivers/scsi/isci/task.c
@@ -585,53 +585,6 @@ static enum isci_request_status isci_task_validate_request_to_abort(
 	return old_state;
 }
 
-/**
-* isci_request_cleanup_completed_loiterer() - This function will take care of
-*    the final cleanup on any request which has been explicitly terminated.
-* @isci_host: This parameter specifies the ISCI host object
-* @isci_device: This is the device to which the request is pending.
-* @isci_request: This parameter specifies the terminated request object.
-* @task: This parameter is the libsas I/O request.
-*/
-static void isci_request_cleanup_completed_loiterer(
-	struct isci_host          *isci_host,
-	struct isci_remote_device *isci_device,
-	struct isci_request       *isci_request,
-	struct sas_task           *task)
-{
-	unsigned long flags;
-
-	dev_dbg(&isci_host->pdev->dev,
-		"%s: isci_device=%p, request=%p, task=%p\n",
-		__func__, isci_device, isci_request, task);
-
-	if (task != NULL) {
-
-		spin_lock_irqsave(&task->task_state_lock, flags);
-		task->lldd_task = NULL;
-
-		task->task_state_flags &= ~SAS_TASK_NEED_DEV_RESET;
-
-		isci_set_task_doneflags(task);
-
-		/* If this task is not in the abort path, call task_done. */
-		if (!(task->task_state_flags & SAS_TASK_STATE_ABORTED)) {
-
-			spin_unlock_irqrestore(&task->task_state_lock, flags);
-			task->task_done(task);
-		} else
-			spin_unlock_irqrestore(&task->task_state_lock, flags);
-	}
-
-	if (isci_request != NULL) {
-		spin_lock_irqsave(&isci_host->scic_lock, flags);
-		isci_free_tag(isci_host, isci_request->io_tag);
-		isci_request_change_state(isci_request, unallocated);
-		list_del_init(&isci_request->dev_node);
-		spin_unlock_irqrestore(&isci_host->scic_lock, flags);
-	}
-}
-
 static int isci_request_is_dealloc_managed(enum isci_request_status stat)
 {
 	switch (stat) {
@@ -666,7 +619,6 @@ static void isci_terminate_request_core(struct isci_host *ihost,
 	unsigned long     flags;
 	unsigned long     termination_completed = 1;
 	struct completion *io_request_completion;
-	struct sas_task   *task;
 
 	dev_dbg(&ihost->pdev->dev,
 		"%s: device = %p; request = %p\n",
@@ -676,10 +628,6 @@ static void isci_terminate_request_core(struct isci_host *ihost,
 
 	io_request_completion = isci_request->io_request_completion;
 
-	task = (isci_request->ttype == io_task)
-		? isci_request_access_task(isci_request)
-		: NULL;
-
 	/* Note that we are not going to control
 	 * the target to abort the request.
 	 */
@@ -783,9 +731,20 @@ static void isci_terminate_request_core(struct isci_host *ihost,
 			spin_unlock_irqrestore(&isci_request->state_lock, flags);
 
 		}
-		if (needs_cleanup_handling)
-			isci_request_cleanup_completed_loiterer(
-				ihost, idev, isci_request, task);
+		if (needs_cleanup_handling) {
+
+			dev_dbg(&ihost->pdev->dev,
+				"%s: cleanup isci_device=%p, request=%p\n",
+				__func__, idev, isci_request);
+
+			if (isci_request != NULL) {
+				spin_lock_irqsave(&ihost->scic_lock, flags);
+				isci_free_tag(ihost, isci_request->io_tag);
+				isci_request_change_state(isci_request, unallocated);
+				list_del_init(&isci_request->dev_node);
+				spin_unlock_irqrestore(&ihost->scic_lock, flags);
+			}
+		}
 	}
 }
 

