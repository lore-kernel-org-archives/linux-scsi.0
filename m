From: Dan Williams <dan.j.williams@intel.com>
Subject: [isci-rnc PATCH v1 25/37] isci: Wait for RNC resumption before
 leaving the abort path.
Date: Thu, 22 Mar 2012 17:30:03 -0700
Message-ID: <20120323003003.18065.52582.stgit@dwillia2-linux.jf.intel.com>
References: <20120323002504.18065.45709.stgit@dwillia2-linux.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:64012 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031470Ab2CWAOf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 22 Mar 2012 20:14:35 -0400
In-Reply-To: <20120323002504.18065.45709.stgit@dwillia2-linux.jf.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Jeff Skirvin <jeffrey.d.skirvin@intel.com>

From: Jeff Skirvin <jeffrey.d.skirvin@intel.com>

In the case of TMF execution, or device resets, wait for the RNC to fully
resume before returning to the caller.  This ensures that the remote
device will not fail I/O requests while waiting for the RNC resumption to
complete.

Signed-off-by: Jeff Skirvin <jeffrey.d.skirvin@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/scsi/isci/remote_device.c |   52 ++++++++++++++++++++++++++++++++++++-
 drivers/scsi/isci/remote_device.h |    3 ++
 2 files changed, 53 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/isci/remote_device.c b/drivers/scsi/isci/remote_device.c
index adeda64..37e9bde 100644
--- a/drivers/scsi/isci/remote_device.c
+++ b/drivers/scsi/isci/remote_device.c
@@ -1289,6 +1289,48 @@ enum sci_status sci_remote_device_resume(
 	return status;
 }
 
+static void isci_remote_device_resume_from_abort_complete(void *cbparam)
+{
+	struct isci_remote_device *idev = cbparam;
+	struct isci_host *ihost = idev->owning_port->owning_controller;
+	scics_sds_remote_node_context_callback abort_resume_cb =
+		idev->abort_resume_cb;
+
+	dev_dbg(scirdev_to_dev(idev), "%s: passing-along resume: %p\n",
+		__func__, abort_resume_cb);
+
+	if (abort_resume_cb != NULL) {
+		idev->abort_resume_cb = NULL;
+		abort_resume_cb(idev->abort_resume_cbparam);
+	}
+	clear_bit(IDEV_ABORT_PATH_RESUME_PENDING, &idev->flags);
+	wake_up(&ihost->eventq);
+}
+
+
+void isci_remote_device_wait_for_resume_from_abort(
+	struct isci_host *ihost,
+	struct isci_remote_device *idev)
+{
+	dev_dbg(scirdev_to_dev(idev), "%s: starting resume wait: %p\n",
+		 __func__, idev);
+
+	#define MAX_RESUME_MSECS 5
+	if (!wait_event_timeout(ihost->eventq,
+			       (!test_bit(IDEV_ABORT_PATH_RESUME_PENDING,
+					  &idev->flags)
+				|| test_bit(IDEV_STOP_PENDING, &idev->flags)),
+			       msecs_to_jiffies(MAX_RESUME_MSECS))) {
+
+		dev_warn(scirdev_to_dev(idev), "%s: #### Timeout waiting for "
+			 "resume: %p\n", __func__, idev);
+	}
+	clear_bit(IDEV_ABORT_PATH_RESUME_PENDING, &idev->flags);
+
+	dev_dbg(scirdev_to_dev(idev), "%s: resume wait done: %p\n",
+		 __func__, idev);
+}
+
 enum sci_status isci_remote_device_resume_from_abort(
 	struct isci_host *ihost,
 	struct isci_remote_device *idev)
@@ -1300,12 +1342,18 @@ enum sci_status isci_remote_device_resume_from_abort(
 	/* Preserve any current resume callbacks, for instance from other
 	 * resumptions.
 	 */
+	idev->abort_resume_cb = idev->rnc.user_callback;
+	idev->abort_resume_cbparam = idev->rnc.user_cookie;
+	set_bit(IDEV_ABORT_PATH_RESUME_PENDING, &idev->flags);
 	clear_bit(IDEV_ABORT_PATH_ACTIVE, &idev->flags);
-	status = sci_remote_device_resume(idev, idev->rnc.user_callback,
-					  idev->rnc.user_cookie);
+	status = sci_remote_device_resume(
+			idev, isci_remote_device_resume_from_abort_complete,
+			idev);
 	spin_unlock_irqrestore(&ihost->scic_lock, flags);
+	isci_remote_device_wait_for_resume_from_abort(ihost, idev);
 	return status;
 }
+
 /**
  * sci_remote_device_start() - This method will start the supplied remote
  *    device.  This method enables normal IO requests to flow through to the
diff --git a/drivers/scsi/isci/remote_device.h b/drivers/scsi/isci/remote_device.h
index 53564c3..ff34c4e 100644
--- a/drivers/scsi/isci/remote_device.h
+++ b/drivers/scsi/isci/remote_device.h
@@ -87,6 +87,7 @@ struct isci_remote_device {
 	#define IDEV_IO_NCQERROR 5
 	#define IDEV_RNC_LLHANG_ENABLED 6
 	#define IDEV_ABORT_PATH_ACTIVE 7
+	#define IDEV_ABORT_PATH_RESUME_PENDING 8
 	unsigned long flags;
 	struct kref kref;
 	struct isci_port *isci_port;
@@ -101,6 +102,8 @@ struct isci_remote_device {
 	u32 started_request_count;
 	struct isci_request *working_request;
 	u32 not_ready_reason;
+	scics_sds_remote_node_context_callback abort_resume_cb;
+	void *abort_resume_cbparam;
 };
 
 #define ISCI_REMOTE_DEVICE_START_TIMEOUT 5000

