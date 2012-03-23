From: Dan Williams <dan.j.williams@intel.com>
Subject: [isci-rnc PATCH v1 22/37] isci: Callbacks to libsas occur under
 scic_lock and are synchronized.
Date: Thu, 22 Mar 2012 17:29:47 -0700
Message-ID: <20120323002947.18065.29895.stgit@dwillia2-linux.jf.intel.com>
References: <20120323002504.18065.45709.stgit@dwillia2-linux.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:21838 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031470Ab2CWAOT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 22 Mar 2012 20:14:19 -0400
In-Reply-To: <20120323002504.18065.45709.stgit@dwillia2-linux.jf.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Jeff Skirvin <jeffrey.d.skirvin@intel.com>

From: Jeff Skirvin <jeffrey.d.skirvin@intel.com>

This patch changes the callback mechanism to libsas to only occur while
the scic_lock is held; the abort path cleanup of I/Os also checks to make
sure IREQ_ABORT_PATH_ACTIVE is clear before proceding.

Signed-off-by: Jeff Skirvin <jeffrey.d.skirvin@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/scsi/isci/host.c          |   10 +++------
 drivers/scsi/isci/remote_device.c |   43 ++++++++++++++++++++++++++++++++-----
 2 files changed, 40 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/isci/host.c b/drivers/scsi/isci/host.c
index 3cc2a23..cd01e39 100644
--- a/drivers/scsi/isci/host.c
+++ b/drivers/scsi/isci/host.c
@@ -1094,8 +1094,6 @@ void isci_host_completion_routine(unsigned long data)
 	list_splice_init(&ihost->requests_to_complete,
 			 &completed_request_list);
 
-	spin_unlock_irq(&ihost->scic_lock);
-
 	/* Process any completions in the list. */
 	list_for_each_safe(current_position, next_position,
 			   &completed_request_list) {
@@ -1104,7 +1102,6 @@ void isci_host_completion_routine(unsigned long data)
 				     completed_node);
 		task = isci_request_access_task(request);
 
-
 		/* Return the task to libsas */
 		if (task != NULL) {
 
@@ -1130,11 +1127,12 @@ void isci_host_completion_routine(unsigned long data)
 				}
 			}
 		}
+		if (test_and_clear_bit(IREQ_ABORT_PATH_ACTIVE, &request->flags))
+			wake_up_all(&ihost->eventq);
 
-		spin_lock_irq(&ihost->scic_lock);
 		isci_free_tag(ihost, request->io_tag);
-		spin_unlock_irq(&ihost->scic_lock);
 	}
+	spin_unlock_irq(&ihost->scic_lock);
 
 	/* the coalesence timeout doubles at each encoding step, so
 	 * update it based on the ilog2 value of the outstanding requests
@@ -2685,8 +2683,6 @@ enum sci_status sci_controller_complete_io(struct isci_host *ihost,
 
 		index = ISCI_TAG_TCI(ireq->io_tag);
 		clear_bit(IREQ_ACTIVE, &ireq->flags);
-		if (test_bit(IREQ_ABORT_PATH_ACTIVE, &ireq->flags))
-			wake_up_all(&ihost->eventq);
 		return SCI_SUCCESS;
 	default:
 		dev_warn(&ihost->pdev->dev, "%s invalid state: %d\n",
diff --git a/drivers/scsi/isci/remote_device.c b/drivers/scsi/isci/remote_device.c
index d1c2a22..21a9800 100644
--- a/drivers/scsi/isci/remote_device.c
+++ b/drivers/scsi/isci/remote_device.c
@@ -145,6 +145,39 @@ static bool isci_compare_suspendcount(
 	return localcount != idev->rnc.suspend_count;
 }
 
+static bool isci_check_reqterm(
+	struct isci_host *ihost,
+	struct isci_remote_device *idev,
+	struct isci_request *ireq,
+	u32 localcount)
+{
+	unsigned long flags;
+	bool res;
+
+	spin_lock_irqsave(&ihost->scic_lock, flags);
+	res = isci_compare_suspendcount(idev, localcount)
+		&& !test_bit(IREQ_ABORT_PATH_ACTIVE, &ireq->flags);
+	spin_unlock_irqrestore(&ihost->scic_lock, flags);
+
+	return res;
+}
+
+static bool isci_check_devempty(
+	struct isci_host *ihost,
+	struct isci_remote_device *idev,
+	u32 localcount)
+{
+	unsigned long flags;
+	bool res;
+
+	spin_lock_irqsave(&ihost->scic_lock, flags);
+	res = isci_compare_suspendcount(idev, localcount)
+		&& idev->started_request_count == 0;
+	spin_unlock_irqrestore(&ihost->scic_lock, flags);
+
+	return res;
+}
+
 enum sci_status isci_remote_device_terminate_requests(
 	struct isci_host *ihost,
 	struct isci_remote_device *idev,
@@ -179,17 +212,15 @@ enum sci_status isci_remote_device_terminate_requests(
 			sci_remote_device_terminate_req(ihost, idev, 0, ireq);
 			spin_unlock_irqrestore(&ihost->scic_lock, flags);
 			wait_event(ihost->eventq,
-				   (isci_compare_suspendcount(idev,
-							      rnc_suspend_count)
-				    && !test_bit(IREQ_ACTIVE, &ireq->flags)));
+				   isci_check_reqterm(ihost, idev, ireq,
+						      rnc_suspend_count));
 		} else {
 			/* Terminate all TCs. */
 			sci_remote_device_terminate_requests(idev);
 			spin_unlock_irqrestore(&ihost->scic_lock, flags);
 			wait_event(ihost->eventq,
-				   (isci_compare_suspendcount(idev,
-							      rnc_suspend_count)
-				    && idev->started_request_count == 0));
+				   isci_check_devempty(ihost, idev,
+						       rnc_suspend_count));
 		}
 		dev_dbg(&ihost->pdev->dev, "%s: idev=%p, wait done\n",
 			__func__, idev);

