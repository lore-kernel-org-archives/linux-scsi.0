From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 03/11] isci: Fix tag leak in tasks and terminated requests.
Date: Thu, 27 Oct 2011 15:05:01 -0700
Message-ID: <20111027220501.4941.32217.stgit@localhost6.localdomain6>
References: <20111027220346.4941.43260.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:39991 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754073Ab1J0WFK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 27 Oct 2011 18:05:10 -0400
In-Reply-To: <20111027220346.4941.43260.stgit@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Jeff Skirvin <jeffrey.d.skirvin@intel.com>

From: Jeff Skirvin <jeffrey.d.skirvin@intel.com>

Make sure terminated requests and completed task tags are freed.

Signed-off-by: Jeff Skirvin <jeffrey.d.skirvin@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/scsi/isci/task.c |   51 ++++++++++++++++++++++++++++------------------
 1 files changed, 31 insertions(+), 20 deletions(-)

diff --git a/drivers/scsi/isci/task.c b/drivers/scsi/isci/task.c
index e8cf17b..7180b04 100644
--- a/drivers/scsi/isci/task.c
+++ b/drivers/scsi/isci/task.c
@@ -552,11 +552,27 @@ static void isci_request_cleanup_completed_loiterer(
 
 	if (isci_request != NULL) {
 		spin_lock_irqsave(&isci_host->scic_lock, flags);
+		isci_free_tag(isci_host, isci_request->io_tag);
+		isci_request_change_state(isci_request, unallocated);
 		list_del_init(&isci_request->dev_node);
 		spin_unlock_irqrestore(&isci_host->scic_lock, flags);
 	}
 }
 
+static int isci_request_is_dealloc_managed(enum isci_request_status stat)
+{
+	switch (stat) {
+	case aborted:
+	case aborting:
+	case terminating:
+	case completed:
+	case dead:
+		return true;
+	default:
+		return false;
+	}
+}
+
 /**
  * isci_terminate_request_core() - This function will terminate the given
  *    request, and wait for it to complete.  This function must only be called
@@ -574,7 +590,6 @@ static void isci_terminate_request_core(struct isci_host *ihost,
 	enum sci_status status      = SCI_SUCCESS;
 	bool was_terminated         = false;
 	bool needs_cleanup_handling = false;
-	enum isci_request_status request_status;
 	unsigned long     flags;
 	unsigned long     termination_completed = 1;
 	struct completion *io_request_completion;
@@ -702,23 +717,11 @@ static void isci_terminate_request_core(struct isci_host *ihost,
 			 * needs to be detached and freed here.
 			 */
 			spin_lock_irqsave(&isci_request->state_lock, flags);
-			request_status = isci_request->status;
-
-			if ((isci_request->ttype == io_task) /* TMFs are in their own thread */
-			    && ((request_status == aborted)
-				|| (request_status == aborting)
-				|| (request_status == terminating)
-				|| (request_status == completed)
-				|| (request_status == dead)
-				)
-			    ) {
-
-				/* The completion routine won't free a request in
-				 * the aborted/aborting/etc. states, so we do
-				 * it here.
-				 */
-				needs_cleanup_handling = true;
-			}
+
+			needs_cleanup_handling
+				= isci_request_is_dealloc_managed(
+					isci_request->status);
+
 			spin_unlock_irqrestore(&isci_request->state_lock, flags);
 
 		}
@@ -1329,8 +1332,16 @@ isci_task_request_complete(struct isci_host *ihost,
 	 */
 	set_bit(IREQ_TERMINATED, &ireq->flags);
 
-	isci_request_change_state(ireq, unallocated);
-	list_del_init(&ireq->dev_node);
+	/* As soon as something is in the terminate path, deallocation is
+	 * managed there.  Note that the final non-managed state of a task
+	 * request is "completed".
+	 */
+	if ((ireq->status == completed) ||
+	    !isci_request_is_dealloc_managed(ireq->status)) {
+		isci_request_change_state(ireq, unallocated);
+		isci_free_tag(ihost, ireq->io_tag);
+		list_del_init(&ireq->dev_node);
+	}
 
 	/* The task management part completes last. */
 	complete(tmf_complete);

