From: Dan Williams <dan.j.williams@intel.com>
Subject: [isci-rnc PATCH v1 06/37] isci: Remote device must be suspended for
 NCQ cleanup.
Date: Thu, 22 Mar 2012 17:28:24 -0700
Message-ID: <20120323002824.18065.49036.stgit@dwillia2-linux.jf.intel.com>
References: <20120323002504.18065.45709.stgit@dwillia2-linux.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:20783 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760166Ab2CWAM4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 22 Mar 2012 20:12:56 -0400
In-Reply-To: <20120323002504.18065.45709.stgit@dwillia2-linux.jf.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Jeff Skirvin <jeffrey.d.skirvin@intel.com>

From: Jeff Skirvin <jeffrey.d.skirvin@intel.com>

When the remote device enters the NCQ error state, the device must
be suspended so that the I/O terminations can take place.

Signed-off-by: Jeff Skirvin <jeffrey.d.skirvin@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/scsi/isci/remote_device.c |   25 ++++++++++++-------------
 1 files changed, 12 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/isci/remote_device.c b/drivers/scsi/isci/remote_device.c
index 4f76dcd..f40d429 100644
--- a/drivers/scsi/isci/remote_device.c
+++ b/drivers/scsi/isci/remote_device.c
@@ -72,6 +72,14 @@ const char *dev_state_name(enum sci_remote_device_states state)
 }
 #undef C
 
+static enum sci_status sci_remote_device_suspend(struct isci_remote_device *idev)
+{
+	return sci_remote_node_context_suspend(&idev->rnc,
+					       SCI_SOFTWARE_SUSPENSION,
+					       SCI_SOFTWARE_SUSPEND_EXPECTED_EVENT,
+					       NULL, NULL);
+}
+
 /**
  * isci_remote_device_not_ready() - This function is called by the ihost when
  *    the remote device is not ready. We mark the isci device as ready (not
@@ -96,6 +104,9 @@ static void isci_remote_device_not_ready(struct isci_host *ihost,
 	case SCIC_REMOTE_DEVICE_NOT_READY_SATA_SDB_ERROR_FIS_RECEIVED:
 		set_bit(IDEV_IO_NCQERROR, &idev->flags);
 
+		/* Suspend the remote device so the I/O can be terminated. */
+		sci_remote_device_suspend(idev);
+
 		/* Kill all outstanding requests for the device. */
 		list_for_each_entry(ireq, &idev->reqs_in_process, dev_node) {
 
@@ -103,9 +114,7 @@ static void isci_remote_device_not_ready(struct isci_host *ihost,
 				"%s: isci_device = %p request = %p\n",
 				__func__, idev, ireq);
 
-			sci_controller_terminate_request(ihost,
-							  idev,
-							  ireq);
+			sci_controller_terminate_request(ihost, idev, ireq);
 		}
 		/* Fall through into the default case... */
 	default:
@@ -133,16 +142,6 @@ static void isci_remote_device_ready(struct isci_host *ihost, struct isci_remote
 		wake_up(&ihost->eventq);
 }
 
-static enum sci_status sci_remote_device_suspend(
-	struct isci_remote_device *idev)
-{
-	return sci_remote_node_context_suspend(
-		&idev->rnc,
-		SCI_SOFTWARE_SUSPENSION,
-		SCI_SOFTWARE_SUSPEND_EXPECTED_EVENT,
-		NULL, NULL);
-}
-
 static int isci_remote_device_suspendcheck(struct isci_remote_device *idev)
 {
 	return test_bit(IDEV_TXRX_SUSPENDED, &idev->flags)

