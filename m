From: Dan Williams <dan.j.williams@intel.com>
Subject: [isci-rnc PATCH v1 37/37] isci: End the RNC resumption wait when
 the RNC is destroyed.
Date: Thu, 22 Mar 2012 17:31:15 -0700
Message-ID: <20120323003115.18065.89007.stgit@dwillia2-linux.jf.intel.com>
References: <20120323002504.18065.45709.stgit@dwillia2-linux.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:1926 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031572Ab2CWAPs (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 22 Mar 2012 20:15:48 -0400
In-Reply-To: <20120323002504.18065.45709.stgit@dwillia2-linux.jf.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Jeff Skirvin <jeffrey.d.skirvin@intel.com>

From: Jeff Skirvin <jeffrey.d.skirvin@intel.com>

While the RNC is suspended for I/O cleanup, the remote device can be
stopped and the RNC setup for destruction.  These changes accomodate that
case in the abort path.

Signed-off-by: Jeff Skirvin <jeffrey.d.skirvin@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/scsi/isci/host.h                |    5 +++++
 drivers/scsi/isci/remote_device.c       |   29 +++++++++++++++++++++--------
 drivers/scsi/isci/remote_node_context.c |    4 ++++
 drivers/scsi/isci/remote_node_context.h |    6 +++---
 4 files changed, 33 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/isci/host.h b/drivers/scsi/isci/host.h
index 81d96f3..a8cc280 100644
--- a/drivers/scsi/isci/host.h
+++ b/drivers/scsi/isci/host.h
@@ -333,6 +333,11 @@ static inline struct isci_host *dev_to_ihost(struct domain_device *dev)
 	return dev->port->ha->lldd_ha;
 }
 
+static inline struct isci_host *idev_to_ihost(struct isci_remote_device *idev)
+{
+	return dev_to_ihost(idev->domain_dev);
+}
+
 /* we always use protocol engine group zero */
 #define ISCI_PEG 0
 
diff --git a/drivers/scsi/isci/remote_device.c b/drivers/scsi/isci/remote_device.c
index a3a6487..c3aa6c5 100644
--- a/drivers/scsi/isci/remote_device.c
+++ b/drivers/scsi/isci/remote_device.c
@@ -1368,27 +1368,40 @@ static void isci_remote_device_resume_from_abort_complete(void *cbparam)
 	wake_up(&ihost->eventq);
 }
 
+static bool isci_remote_device_test_resume_done(
+	struct isci_host *ihost,
+	struct isci_remote_device *idev)
+{
+	unsigned long flags;
+	bool done;
+
+	spin_lock_irqsave(&ihost->scic_lock, flags);
+	done = !test_bit(IDEV_ABORT_PATH_RESUME_PENDING, &idev->flags)
+		|| test_bit(IDEV_STOP_PENDING, &idev->flags)
+		|| sci_remote_node_context_is_being_destroyed(&idev->rnc);
+	spin_unlock_irqrestore(&ihost->scic_lock, flags);
+
+	return done;
+}
 
 void isci_remote_device_wait_for_resume_from_abort(
 	struct isci_host *ihost,
 	struct isci_remote_device *idev)
 {
-	dev_dbg(scirdev_to_dev(idev), "%s: starting resume wait: %p\n",
+	dev_dbg(&ihost->pdev->dev, "%s: starting resume wait: %p\n",
 		 __func__, idev);
 
 	#define MAX_RESUME_MSECS 10000
 	if (!wait_event_timeout(ihost->eventq,
-			       (!test_bit(IDEV_ABORT_PATH_RESUME_PENDING,
-					  &idev->flags)
-				|| test_bit(IDEV_STOP_PENDING, &idev->flags)),
-			       msecs_to_jiffies(MAX_RESUME_MSECS))) {
+				isci_remote_device_test_resume_done(ihost, idev),
+				msecs_to_jiffies(MAX_RESUME_MSECS))) {
 
-		dev_warn(scirdev_to_dev(idev), "%s: #### Timeout waiting for "
+		dev_warn(&ihost->pdev->dev, "%s: #### Timeout waiting for "
 			 "resume: %p\n", __func__, idev);
 	}
 	clear_bit(IDEV_ABORT_PATH_RESUME_PENDING, &idev->flags);
 
-	dev_dbg(scirdev_to_dev(idev), "%s: resume wait done: %p\n",
+	dev_dbg(&ihost->pdev->dev, "%s: resume wait done: %p\n",
 		 __func__, idev);
 }
 
@@ -1414,7 +1427,7 @@ enum sci_status isci_remote_device_resume_from_abort(
 			idev, isci_remote_device_resume_from_abort_complete,
 			idev);
 	spin_unlock_irqrestore(&ihost->scic_lock, flags);
-	if (!destroyed)
+	if (!destroyed && (status == SCI_SUCCESS))
 		isci_remote_device_wait_for_resume_from_abort(ihost, idev);
 	else
 		clear_bit(IDEV_ABORT_PATH_RESUME_PENDING, &idev->flags);
diff --git a/drivers/scsi/isci/remote_node_context.c b/drivers/scsi/isci/remote_node_context.c
index f5792a9..1910100 100644
--- a/drivers/scsi/isci/remote_node_context.c
+++ b/drivers/scsi/isci/remote_node_context.c
@@ -190,9 +190,13 @@ static void sci_remote_node_context_setup_to_destroy(
 	scics_sds_remote_node_context_callback callback,
 	void *callback_parameter)
 {
+	struct isci_host *ihost = idev_to_ihost(rnc_to_dev(sci_rnc));
+
 	sci_rnc->destination_state = RNC_DEST_FINAL;
 	sci_rnc->user_callback     = callback;
 	sci_rnc->user_cookie       = callback_parameter;
+
+	wake_up(&ihost->eventq);
 }
 
 /**
diff --git a/drivers/scsi/isci/remote_node_context.h b/drivers/scsi/isci/remote_node_context.h
index 0d4a24d..a703b9c 100644
--- a/drivers/scsi/isci/remote_node_context.h
+++ b/drivers/scsi/isci/remote_node_context.h
@@ -229,8 +229,8 @@ int sci_remote_node_context_is_safe_to_abort(
 static inline bool sci_remote_node_context_is_being_destroyed(
 	struct sci_remote_node_context *sci_rnc)
 {
-	return ((sci_rnc->sm.current_state_id == SCI_RNC_INVALIDATING)
-		&& (sci_rnc->destination_state == RNC_DEST_FINAL))
-		|| (sci_rnc->sm.current_state_id == SCI_RNC_INITIAL);
+	return (sci_rnc->destination_state == RNC_DEST_FINAL)
+		|| ((sci_rnc->sm.current_state_id == SCI_RNC_INITIAL)
+		    && (sci_rnc->destination_state == RNC_DEST_UNSPECIFIED));
 }
 #endif  /* _SCIC_SDS_REMOTE_NODE_CONTEXT_H_ */

