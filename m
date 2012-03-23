From: Dan Williams <dan.j.williams@intel.com>
Subject: [isci-rnc PATCH v1 13/37] isci: Only set IDEV_GONE in the device
 stop path.
Date: Thu, 22 Mar 2012 17:29:00 -0700
Message-ID: <20120323002900.18065.11270.stgit@dwillia2-linux.jf.intel.com>
References: <20120323002504.18065.45709.stgit@dwillia2-linux.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:25095 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031470Ab2CWANd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 22 Mar 2012 20:13:33 -0400
In-Reply-To: <20120323002504.18065.45709.stgit@dwillia2-linux.jf.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Jeff Skirvin <jeffrey.d.skirvin@intel.com>

From: Jeff Skirvin <jeffrey.d.skirvin@intel.com>

Signed-off-by: Jeff Skirvin <jeffrey.d.skirvin@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/scsi/isci/port.c          |   23 -----------------------
 drivers/scsi/isci/remote_device.c |    3 ---
 2 files changed, 0 insertions(+), 26 deletions(-)

diff --git a/drivers/scsi/isci/port.c b/drivers/scsi/isci/port.c
index 4858ddd..87944c8 100644
--- a/drivers/scsi/isci/port.c
+++ b/drivers/scsi/isci/port.c
@@ -240,32 +240,9 @@ static void isci_port_link_down(struct isci_host *isci_host,
 				struct isci_phy *isci_phy,
 				struct isci_port *isci_port)
 {
-	struct isci_remote_device *isci_device;
-
 	dev_dbg(&isci_host->pdev->dev,
 		"%s: isci_port = %p\n", __func__, isci_port);
 
-	if (isci_port) {
-
-		/* check to see if this is the last phy on this port. */
-		if (isci_phy->sas_phy.port &&
-		    isci_phy->sas_phy.port->num_phys == 1) {
-			/* change the state for all devices on this port.  The
-			 * next task sent to this device will be returned as
-			 * SAS_TASK_UNDELIVERED, and the scsi mid layer will
-			 * remove the target
-			 */
-			list_for_each_entry(isci_device,
-					    &isci_port->remote_dev_list,
-					    node) {
-				dev_dbg(&isci_host->pdev->dev,
-					"%s: isci_device = %p\n",
-					__func__, isci_device);
-				set_bit(IDEV_GONE, &isci_device->flags);
-			}
-		}
-	}
-
 	/* Notify libsas of the borken link, this will trigger calls to our
 	 * isci_port_deformed and isci_dev_gone functions.
 	 */
diff --git a/drivers/scsi/isci/remote_device.c b/drivers/scsi/isci/remote_device.c
index cf5d554..b26ab05 100644
--- a/drivers/scsi/isci/remote_device.c
+++ b/drivers/scsi/isci/remote_device.c
@@ -195,9 +195,6 @@ static void isci_remote_device_not_ready(struct isci_host *ihost,
 		"%s: isci_device = %p; reason = %d\n", __func__, idev, reason);
 
 	switch (reason) {
-	case SCIC_REMOTE_DEVICE_NOT_READY_STOP_REQUESTED:
-		set_bit(IDEV_GONE, &idev->flags);
-		break;
 	case SCIC_REMOTE_DEVICE_NOT_READY_SATA_SDB_ERROR_FIS_RECEIVED:
 		set_bit(IDEV_IO_NCQERROR, &idev->flags);
 

