From: Dan Williams <dan.j.williams@intel.com>
Subject: [isci-rnc PATCH v1 28/37] isci: Added timeouts to RNC suspensions
 in the abort path.
Date: Thu, 22 Mar 2012 17:30:23 -0700
Message-ID: <20120323003023.18065.12405.stgit@dwillia2-linux.jf.intel.com>
References: <20120323002504.18065.45709.stgit@dwillia2-linux.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:59806 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031572Ab2CWAO4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 22 Mar 2012 20:14:56 -0400
In-Reply-To: <20120323002504.18065.45709.stgit@dwillia2-linux.jf.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Jeff Skirvin <jeffrey.d.skirvin@intel.com>

From: Jeff Skirvin <jeffrey.d.skirvin@intel.com>

This change adds timeouts to the RNC suspension wait.  It makes the
suspend and resume timeouts the same.

The previous resume timeout of 5 ms was too short, and timeouts were
seen in resumptions of devices in the abort task/LUN reset path - which
would receive an RNC resumed message within a tenth of a second later.

Signed-off-by: Jeff Skirvin <jeffrey.d.skirvin@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/scsi/isci/remote_device.c       |   58 +++++++++++++++++++++++++++----
 drivers/scsi/isci/remote_node_context.c |    8 ++--
 2 files changed, 55 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/isci/remote_device.c b/drivers/scsi/isci/remote_device.c
index 37e9bde..be9f0e0 100644
--- a/drivers/scsi/isci/remote_device.c
+++ b/drivers/scsi/isci/remote_device.c
@@ -207,23 +207,67 @@ enum sci_status isci_remote_device_terminate_requests(
 				"about to wait\n",
 			__func__, idev, ireq, idev->started_request_count,
 			rnc_suspend_count, idev->rnc.suspend_count);
+
+		#define MAX_SUSPEND_MSECS 10000
 		if (ireq) {
 			/* Terminate a specific TC. */
 			set_bit(IREQ_NO_AUTO_FREE_TAG, &ireq->flags);
 			sci_remote_device_terminate_req(ihost, idev, 0, ireq);
 			spin_unlock_irqrestore(&ihost->scic_lock, flags);
-			wait_event(ihost->eventq,
-				   isci_check_reqterm(ihost, idev, ireq,
-						      rnc_suspend_count));
+			if (!wait_event_timeout(ihost->eventq,
+						isci_check_reqterm(ihost, idev, ireq,
+								   rnc_suspend_count),
+						msecs_to_jiffies(MAX_SUSPEND_MSECS))) {
+
+				dev_warn(&ihost->pdev->dev, "%s host%d timeout single\n",
+					 __func__, ihost->id);
+				dev_dbg(&ihost->pdev->dev,
+					 "%s: ******* Timeout waiting for "
+					 "suspend; idev=%p, current state %s; "
+					 "started_request_count=%d, flags=%lx\n\t"
+					 "rnc_suspend_count=%d, rnc.suspend_count=%d "
+					 "RNC: current state %s, current "
+					 "suspend_type %x dest state %d;\n"
+					 "ireq=%p, ireq->flags = %lx\n",
+					 __func__, idev,
+					 dev_state_name(idev->sm.current_state_id),
+					 idev->started_request_count, idev->flags,
+					 rnc_suspend_count, idev->rnc.suspend_count,
+					 rnc_state_name(idev->rnc.sm.current_state_id),
+					 idev->rnc.suspend_type,
+					 idev->rnc.destination_state,
+					 ireq, ireq->flags);
+			}
 			clear_bit(IREQ_NO_AUTO_FREE_TAG, &ireq->flags);
 			isci_free_tag(ihost, ireq->io_tag);
 		} else {
 			/* Terminate all TCs. */
 			sci_remote_device_terminate_requests(idev);
 			spin_unlock_irqrestore(&ihost->scic_lock, flags);
-			wait_event(ihost->eventq,
-				   isci_check_devempty(ihost, idev,
-						       rnc_suspend_count));
+			if (!wait_event_timeout(ihost->eventq,
+						isci_check_devempty(ihost, idev,
+								    rnc_suspend_count),
+						msecs_to_jiffies(MAX_SUSPEND_MSECS))) {
+
+				dev_warn(&ihost->pdev->dev, "%s host%d timeout all\n",
+					 __func__, ihost->id);
+				dev_dbg(&ihost->pdev->dev,
+					"%s: ******* Timeout waiting for "
+					"suspend; idev=%p, current state %s; "
+					"started_request_count=%d, flags=%lx\n\t"
+					"rnc_suspend_count=%d, "
+					"RNC: current state %s, "
+					"rnc.suspend_count=%d, current "
+					"suspend_type %x dest state %d\n",
+					__func__, idev,
+					dev_state_name(idev->sm.current_state_id),
+					idev->started_request_count, idev->flags,
+					rnc_suspend_count,
+					rnc_state_name(idev->rnc.sm.current_state_id),
+					idev->rnc.suspend_count,
+					idev->rnc.suspend_type,
+					idev->rnc.destination_state);
+			}
 		}
 		dev_dbg(&ihost->pdev->dev, "%s: idev=%p, wait done\n",
 			__func__, idev);
@@ -1315,7 +1359,7 @@ void isci_remote_device_wait_for_resume_from_abort(
 	dev_dbg(scirdev_to_dev(idev), "%s: starting resume wait: %p\n",
 		 __func__, idev);
 
-	#define MAX_RESUME_MSECS 5
+	#define MAX_RESUME_MSECS 10000
 	if (!wait_event_timeout(ihost->eventq,
 			       (!test_bit(IDEV_ABORT_PATH_RESUME_PENDING,
 					  &idev->flags)
diff --git a/drivers/scsi/isci/remote_node_context.c b/drivers/scsi/isci/remote_node_context.c
index b698081..a0a62e3 100644
--- a/drivers/scsi/isci/remote_node_context.c
+++ b/drivers/scsi/isci/remote_node_context.c
@@ -445,7 +445,7 @@ enum sci_status sci_remote_node_context_event_handler(struct sci_remote_node_con
 			case SCU_EVENT_TYPE_RNC_SUSPEND_TX_RX:
 				/* We really dont care if the hardware is going to suspend
 				 * the device since it's being invalidated anyway */
-				dev_dbg(scirdev_to_dev(rnc_to_dev(sci_rnc)),
+				dev_warn(scirdev_to_dev(rnc_to_dev(sci_rnc)),
 					"%s: SCIC Remote Node Context 0x%p was "
 					"suspeneded by hardware while being "
 					"invalidated.\n", __func__, sci_rnc);
@@ -464,7 +464,7 @@ enum sci_status sci_remote_node_context_event_handler(struct sci_remote_node_con
 			case SCU_EVENT_TYPE_RNC_SUSPEND_TX_RX:
 				/* We really dont care if the hardware is going to suspend
 				 * the device since it's being resumed anyway */
-				dev_dbg(scirdev_to_dev(rnc_to_dev(sci_rnc)),
+				dev_warn(scirdev_to_dev(rnc_to_dev(sci_rnc)),
 					"%s: SCIC Remote Node Context 0x%p was "
 					"suspeneded by hardware while being resumed.\n",
 					__func__, sci_rnc);
@@ -568,9 +568,9 @@ enum sci_status sci_remote_node_context_suspend(
 		RNC_DEST_UNSPECIFIED;
 
 	dev_dbg(scirdev_to_dev(idev),
-		"%s: current state %d, current suspend_type %x dest state %d,"
+		"%s: current state %s, current suspend_type %x dest state %d,"
 			" arg suspend_reason %d, arg suspend_type %x",
-		__func__, state, sci_rnc->suspend_type,
+		__func__, rnc_state_name(state), sci_rnc->suspend_type,
 		sci_rnc->destination_state, suspend_reason,
 		suspend_type);
 

