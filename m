From: Dan Williams <dan.j.williams@intel.com>
Subject: [isci-rnc PATCH v1 23/37] isci: Manage tag releases differently
 when aborting tasks.
Date: Thu, 22 Mar 2012 17:29:52 -0700
Message-ID: <20120323002952.18065.48616.stgit@dwillia2-linux.jf.intel.com>
References: <20120323002504.18065.45709.stgit@dwillia2-linux.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:13774 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031470Ab2CWAOZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 22 Mar 2012 20:14:25 -0400
In-Reply-To: <20120323002504.18065.45709.stgit@dwillia2-linux.jf.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Jeff Skirvin <jeffrey.d.skirvin@intel.com>

From: Jeff Skirvin <jeffrey.d.skirvin@intel.com>

When an individual request is being terminated, the request's tag
is managed in the terminate function.

Signed-off-by: Jeff Skirvin <jeffrey.d.skirvin@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/scsi/isci/host.c          |    3 ++-
 drivers/scsi/isci/remote_device.c |   11 +++++++----
 drivers/scsi/isci/request.h       |    1 +
 drivers/scsi/isci/task.c          |    3 ++-
 4 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/isci/host.c b/drivers/scsi/isci/host.c
index cd01e39..7061c98 100644
--- a/drivers/scsi/isci/host.c
+++ b/drivers/scsi/isci/host.c
@@ -1130,7 +1130,8 @@ void isci_host_completion_routine(unsigned long data)
 		if (test_and_clear_bit(IREQ_ABORT_PATH_ACTIVE, &request->flags))
 			wake_up_all(&ihost->eventq);
 
-		isci_free_tag(ihost, request->io_tag);
+		if (!test_bit(IREQ_NO_AUTO_FREE_TAG, &request->flags))
+			isci_free_tag(ihost, request->io_tag);
 	}
 	spin_unlock_irq(&ihost->scic_lock);
 
diff --git a/drivers/scsi/isci/remote_device.c b/drivers/scsi/isci/remote_device.c
index 21a9800..adeda64 100644
--- a/drivers/scsi/isci/remote_device.c
+++ b/drivers/scsi/isci/remote_device.c
@@ -104,15 +104,15 @@ static enum sci_status sci_remote_device_terminate_req(
 	int check_abort,
 	struct isci_request *ireq)
 {
-	dev_dbg(&ihost->pdev->dev,
-		"%s: idev=%p; flags=%lx; req=%p; req target=%p\n",
-		__func__, idev, idev->flags, ireq, ireq->target_device);
-
 	if (!test_bit(IREQ_ACTIVE, &ireq->flags) ||
 	    (ireq->target_device != idev) ||
 	    (check_abort && !test_bit(IREQ_PENDING_ABORT, &ireq->flags)))
 		return SCI_SUCCESS;
 
+	dev_dbg(&ihost->pdev->dev,
+		"%s: idev=%p; flags=%lx; req=%p; req target=%p\n",
+		__func__, idev, idev->flags, ireq, ireq->target_device);
+
 	set_bit(IREQ_ABORT_PATH_ACTIVE, &ireq->flags);
 
 	return sci_controller_terminate_request(ihost, idev, ireq);
@@ -209,11 +209,14 @@ enum sci_status isci_remote_device_terminate_requests(
 			rnc_suspend_count, idev->rnc.suspend_count);
 		if (ireq) {
 			/* Terminate a specific TC. */
+			set_bit(IREQ_NO_AUTO_FREE_TAG, &ireq->flags);
 			sci_remote_device_terminate_req(ihost, idev, 0, ireq);
 			spin_unlock_irqrestore(&ihost->scic_lock, flags);
 			wait_event(ihost->eventq,
 				   isci_check_reqterm(ihost, idev, ireq,
 						      rnc_suspend_count));
+			clear_bit(IREQ_NO_AUTO_FREE_TAG, &ireq->flags);
+			isci_free_tag(ihost, ireq->io_tag);
 		} else {
 			/* Terminate all TCs. */
 			sci_remote_device_terminate_requests(idev);
diff --git a/drivers/scsi/isci/request.h b/drivers/scsi/isci/request.h
index d12e975..1a65157 100644
--- a/drivers/scsi/isci/request.h
+++ b/drivers/scsi/isci/request.h
@@ -87,6 +87,7 @@ struct isci_request {
 	#define IREQ_PENDING_ABORT 4 /* Set == device was not suspended yet */
 	#define IREQ_TC_ABORT_POSTED 5
 	#define IREQ_ABORT_PATH_ACTIVE 6
+	#define IREQ_NO_AUTO_FREE_TAG 7 /* Set when being explicitly managed */
 	unsigned long flags;
 	/* XXX kill ttype and ttype_ptr, allocate full sas_task */
 	union ttype_ptr_union {
diff --git a/drivers/scsi/isci/task.c b/drivers/scsi/isci/task.c
index c1c6dd0..e798c6a 100644
--- a/drivers/scsi/isci/task.c
+++ b/drivers/scsi/isci/task.c
@@ -719,7 +719,8 @@ isci_task_request_complete(struct isci_host *ihost,
 	 */
 	set_bit(IREQ_TERMINATED, &ireq->flags);
 
-	isci_free_tag(ihost, ireq->io_tag);
+	if (!test_bit(IREQ_NO_AUTO_FREE_TAG, &ireq->flags))
+		isci_free_tag(ihost, ireq->io_tag);
 
 	/* The task management part completes last. */
 	if (tmf_complete)

