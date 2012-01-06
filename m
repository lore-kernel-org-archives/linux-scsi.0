From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH v3 10/14] isci: fix interpretation of "hard" reset
Date: Thu, 05 Jan 2012 16:59:51 -0800
Message-ID: <20120106005951.11464.48682.stgit@localhost6.localdomain6>
References: <20120106005634.11464.64030.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:26145 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030200Ab2AFBAD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 5 Jan 2012 20:00:03 -0500
In-Reply-To: <20120106005634.11464.64030.stgit@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-ide@vger.kernel.org

A hard reset to isci in the direct-attached case is one where the driver
internally manages debouncing the link.  In the sas-expander-attached
case a hard reset is one that clears affiliations.  The driver should
not be prematurely dropping affiliations at run time, that decision (to
force expander hard resets to ata devices) is left to userspace to
manage.  So, arrange for I_T_nexus resets to be sas-link-resets in the
expander-attached case and isci-hard-resets in the direct-attached case.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/scsi/isci/port.c |   31 ++++++++++++++++++++-----------
 drivers/scsi/isci/port.h |    3 ++-
 drivers/scsi/isci/task.c |   24 +++++++++++++++---------
 3 files changed, 37 insertions(+), 21 deletions(-)

diff --git a/drivers/scsi/isci/port.c b/drivers/scsi/isci/port.c
index 255c52f..7e4a9ee 100644
--- a/drivers/scsi/isci/port.c
+++ b/drivers/scsi/isci/port.c
@@ -305,7 +305,9 @@ static void port_state_machine_change(struct isci_port *iport,
 static void isci_port_hard_reset_complete(struct isci_port *isci_port,
 					  enum sci_status completion_status)
 {
-	dev_dbg(&isci_port->isci_host->pdev->dev,
+	struct isci_host *ihost = isci_port->owning_controller;
+
+	dev_dbg(&ihost->pdev->dev,
 		"%s: isci_port = %p, completion_status=%x\n",
 		     __func__, isci_port, completion_status);
 
@@ -316,23 +318,24 @@ static void isci_port_hard_reset_complete(struct isci_port *isci_port,
 
 		/* The reset failed.  The port state is now SCI_PORT_FAILED. */
 		if (isci_port->active_phy_mask == 0) {
+			int phy_idx = isci_port->last_active_phy;
+			struct isci_phy *iphy = &ihost->phys[phy_idx];
 
 			/* Generate the link down now to the host, since it
 			 * was intercepted by the hard reset state machine when
 			 * it really happened.
 			 */
-			isci_port_link_down(isci_port->isci_host,
-					    &isci_port->isci_host->phys[
-						   isci_port->last_active_phy],
-					    isci_port);
+			isci_port_link_down(ihost, iphy, isci_port);
 		}
 		/* Advance the port state so that link state changes will be
-		* noticed.
-		*/
+		 * noticed.
+		 */
 		port_state_machine_change(isci_port, SCI_PORT_SUB_WAITING);
 
 	}
-	complete_all(&isci_port->hard_reset_complete);
+	clear_bit(IPORT_RESET_PENDING, &isci_port->state);
+	wake_up(&ihost->eventq);
+
 }
 
 /* This method will return a true value if the specified phy can be assigned to
@@ -1598,6 +1601,11 @@ void sci_port_broadcast_change_received(struct isci_port *iport, struct isci_phy
 	isci_port_bc_change_received(ihost, iport, iphy);
 }
 
+static void wait_port_reset(struct isci_host *ihost, struct isci_port *iport)
+{
+	wait_event(ihost->eventq, !test_bit(IPORT_RESET_PENDING, &iport->state));
+}
+
 int isci_port_perform_hard_reset(struct isci_host *ihost, struct isci_port *iport,
 				 struct isci_phy *iphy)
 {
@@ -1608,9 +1616,8 @@ int isci_port_perform_hard_reset(struct isci_host *ihost, struct isci_port *ipor
 	dev_dbg(&ihost->pdev->dev, "%s: iport = %p\n",
 		__func__, iport);
 
-	init_completion(&iport->hard_reset_complete);
-
 	spin_lock_irqsave(&ihost->scic_lock, flags);
+	set_bit(IPORT_RESET_PENDING, &iport->state);
 
 	#define ISCI_PORT_RESET_TIMEOUT SCIC_SDS_SIGNATURE_FIS_TIMEOUT
 	status = sci_port_hard_reset(iport, ISCI_PORT_RESET_TIMEOUT);
@@ -1618,7 +1625,7 @@ int isci_port_perform_hard_reset(struct isci_host *ihost, struct isci_port *ipor
 	spin_unlock_irqrestore(&ihost->scic_lock, flags);
 
 	if (status == SCI_SUCCESS) {
-		wait_for_completion(&iport->hard_reset_complete);
+		wait_port_reset(ihost, iport);
 
 		dev_dbg(&ihost->pdev->dev,
 			"%s: iport = %p; hard reset completion\n",
@@ -1632,6 +1639,8 @@ int isci_port_perform_hard_reset(struct isci_host *ihost, struct isci_port *ipor
 				__func__, iport, iport->hard_reset_status);
 		}
 	} else {
+		clear_bit(IPORT_RESET_PENDING, &iport->state);
+		wake_up(&ihost->eventq);
 		ret = TMF_RESP_FUNC_FAILED;
 
 		dev_err(&ihost->pdev->dev,
diff --git a/drivers/scsi/isci/port.h b/drivers/scsi/isci/port.h
index b0b7cc1..78e1e82 100644
--- a/drivers/scsi/isci/port.h
+++ b/drivers/scsi/isci/port.h
@@ -93,7 +93,8 @@ struct isci_port {
 	struct isci_host *isci_host;
 	struct list_head remote_dev_list;
 	struct list_head domain_dev_list;
-	struct completion hard_reset_complete;
+	#define IPORT_RESET_PENDING 0
+	unsigned long state;
 	enum sci_status hard_reset_status;
 	struct sci_base_state_machine sm;
 	bool ready_exit;
diff --git a/drivers/scsi/isci/task.c b/drivers/scsi/isci/task.c
index a6ab49a..0e7429b 100644
--- a/drivers/scsi/isci/task.c
+++ b/drivers/scsi/isci/task.c
@@ -1330,29 +1330,35 @@ isci_task_request_complete(struct isci_host *ihost,
 }
 
 static int isci_reset_device(struct isci_host *ihost,
+			     struct domain_device *dev,
 			     struct isci_remote_device *idev)
 {
-	struct sas_phy *phy = sas_get_local_phy(idev->domain_dev);
-	enum sci_status status;
-	unsigned long flags;
 	int rc;
+	unsigned long flags;
+	enum sci_status status;
+	struct sas_phy *phy = sas_get_local_phy(dev);
+	struct isci_port *iport = dev->port->lldd_port;
 
 	dev_dbg(&ihost->pdev->dev, "%s: idev %p\n", __func__, idev);
 
 	spin_lock_irqsave(&ihost->scic_lock, flags);
 	status = sci_remote_device_reset(idev);
-	if (status != SCI_SUCCESS) {
-		spin_unlock_irqrestore(&ihost->scic_lock, flags);
+	spin_unlock_irqrestore(&ihost->scic_lock, flags);
 
+	if (status != SCI_SUCCESS) {
 		dev_dbg(&ihost->pdev->dev,
 			 "%s: sci_remote_device_reset(%p) returned %d!\n",
 			 __func__, idev, status);
 		rc = TMF_RESP_FUNC_FAILED;
 		goto out;
 	}
-	spin_unlock_irqrestore(&ihost->scic_lock, flags);
 
-	rc = sas_phy_reset(phy, true);
+	if (scsi_is_sas_phy_local(phy)) {
+		struct isci_phy *iphy = &ihost->phys[phy->number];
+
+		rc = isci_port_perform_hard_reset(ihost, iport, iphy);
+	} else
+		rc = sas_phy_reset(phy, !dev_is_sata(dev));
 
 	/* Terminate in-progress I/O now. */
 	isci_remote_device_nuke_requests(ihost, idev);
@@ -1390,7 +1396,7 @@ int isci_task_I_T_nexus_reset(struct domain_device *dev)
 		goto out;
 	}
 
-	ret = isci_reset_device(ihost, idev);
+	ret = isci_reset_device(ihost, dev, idev);
  out:
 	isci_put_device(idev);
 	return ret;
@@ -1413,7 +1419,7 @@ int isci_bus_reset_handler(struct scsi_cmnd *cmd)
 		goto out;
 	}
 
-	ret = isci_reset_device(ihost, idev);
+	ret = isci_reset_device(ihost, dev, idev);
  out:
 	isci_put_device(idev);
 	return ret;

