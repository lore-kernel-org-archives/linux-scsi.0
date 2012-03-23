From: Dan Williams <dan.j.williams@intel.com>
Subject: [isci-rnc PATCH v1 07/37] isci: Remote device stop also suspends
 the RNC and terminates I/O.
Date: Thu, 22 Mar 2012 17:28:29 -0700
Message-ID: <20120323002829.18065.63243.stgit@dwillia2-linux.jf.intel.com>
References: <20120323002504.18065.45709.stgit@dwillia2-linux.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:20783 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760166Ab2CWANB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 22 Mar 2012 20:13:01 -0400
In-Reply-To: <20120323002504.18065.45709.stgit@dwillia2-linux.jf.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Jeff Skirvin <jeffrey.d.skirvin@intel.com>

From: Jeff Skirvin <jeffrey.d.skirvin@intel.com>

Fixing the remote device state machine to suspend and terminate
all outstanding I/O before the device stopped state is reached.

Signed-off-by: Jeff Skirvin <jeffrey.d.skirvin@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/scsi/isci/remote_device.c |   23 +++++++++++------------
 1 files changed, 11 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/isci/remote_device.c b/drivers/scsi/isci/remote_device.c
index f40d429..3048e02 100644
--- a/drivers/scsi/isci/remote_device.c
+++ b/drivers/scsi/isci/remote_device.c
@@ -263,13 +263,15 @@ enum sci_status sci_remote_device_stop(struct isci_remote_device *idev,
 	case SCI_SMP_DEV_IDLE:
 	case SCI_SMP_DEV_CMD:
 		sci_change_state(sm, SCI_DEV_STOPPING);
-		if (idev->started_request_count == 0) {
+		if (idev->started_request_count == 0)
 			sci_remote_node_context_destruct(&idev->rnc,
-							      rnc_destruct_done, idev);
-			return SCI_SUCCESS;
-		} else
-			return sci_remote_device_terminate_requests(idev);
-		break;
+							 rnc_destruct_done,
+							 idev);
+		else {
+			sci_remote_device_suspend(idev);
+			sci_remote_device_terminate_requests(idev);
+		}
+		return SCI_SUCCESS;
 	case SCI_DEV_STOPPING:
 		/* All requests should have been terminated, but if there is an
 		 * attempt to stop a device already in the stopping state, then
@@ -1403,14 +1405,8 @@ enum sci_status isci_remote_device_stop(struct isci_host *ihost, struct isci_rem
 	spin_lock_irqsave(&ihost->scic_lock, flags);
 	idev->domain_dev->lldd_dev = NULL; /* disable new lookups */
 	set_bit(IDEV_GONE, &idev->flags);
-	spin_unlock_irqrestore(&ihost->scic_lock, flags);
-
-	/* Kill all outstanding requests. */
-	isci_remote_device_nuke_requests(ihost, idev);
 
 	set_bit(IDEV_STOP_PENDING, &idev->flags);
-
-	spin_lock_irqsave(&ihost->scic_lock, flags);
 	status = sci_remote_device_stop(idev, 50);
 	spin_unlock_irqrestore(&ihost->scic_lock, flags);
 
@@ -1420,6 +1416,9 @@ enum sci_status isci_remote_device_stop(struct isci_host *ihost, struct isci_rem
 	else
 		wait_for_device_stop(ihost, idev);
 
+	dev_dbg(&ihost->pdev->dev,
+		"%s: isci_device = %p, waiting done.\n", __func__, idev);
+
 	return status;
 }
 

