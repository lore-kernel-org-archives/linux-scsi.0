From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 2/8] fcoe: Fix smatch warning in fcoe_fdmi_info function
Date: Tue, 09 Jul 2013 12:47:15 -0700
Message-ID: <20130709194715.10724.136.stgit@fritz>
References: <20130709194705.10724.64013.stgit@fritz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:19212 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752863Ab3GITr3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 9 Jul 2013 15:47:29 -0400
In-Reply-To: <20130709194705.10724.64013.stgit@fritz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Jack Morgan <jack.morgan@intel.com>, Fengguang Wu <fengguang.wu@intel.com>, Neerav Parikh <Neerav.Parikh@intel.com>

From: Neerav Parikh <Neerav.Parikh@intel.com>

This patch fixes a smatch warning as below:

smatch warnings:
drivers/scsi/fcoe/fcoe.c:782 fcoe_fdmi_info() warn: 'fdmi' puts 896 bytes on
stack

Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Signed-off-by: Neerav Parikh <Neerav.Parikh@intel.com>
Tested-by: Jack Morgan <jack.morgan@intel.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---
 drivers/scsi/fcoe/fcoe.c |   26 +++++++++++++++-----------
 1 file changed, 15 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index 32ae6c6..3336e57 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -774,7 +774,6 @@ static void fcoe_fdmi_info(struct fc_lport *lport, struct net_device *netdev)
 	struct fcoe_port *port;
 	struct net_device *realdev;
 	int rc;
-	struct netdev_fcoe_hbainfo fdmi;
 
 	port = lport_priv(lport);
 	fcoe = port->priv;
@@ -788,9 +787,13 @@ static void fcoe_fdmi_info(struct fc_lport *lport, struct net_device *netdev)
 		return;
 
 	if (realdev->netdev_ops->ndo_fcoe_get_hbainfo) {
-		memset(&fdmi, 0, sizeof(fdmi));
+		struct netdev_fcoe_hbainfo *fdmi;
+		fdmi = kzalloc(sizeof(*fdmi), GFP_KERNEL);
+		if (!fdmi)
+			return;
+
 		rc = realdev->netdev_ops->ndo_fcoe_get_hbainfo(realdev,
-							       &fdmi);
+							       fdmi);
 		if (rc) {
 			printk(KERN_INFO "fcoe: Failed to retrieve FDMI "
 					"information from netdev.\n");
@@ -800,38 +803,39 @@ static void fcoe_fdmi_info(struct fc_lport *lport, struct net_device *netdev)
 		snprintf(fc_host_serial_number(lport->host),
 			 FC_SERIAL_NUMBER_SIZE,
 			 "%s",
-			 fdmi.serial_number);
+			 fdmi->serial_number);
 		snprintf(fc_host_manufacturer(lport->host),
 			 FC_SERIAL_NUMBER_SIZE,
 			 "%s",
-			 fdmi.manufacturer);
+			 fdmi->manufacturer);
 		snprintf(fc_host_model(lport->host),
 			 FC_SYMBOLIC_NAME_SIZE,
 			 "%s",
-			 fdmi.model);
+			 fdmi->model);
 		snprintf(fc_host_model_description(lport->host),
 			 FC_SYMBOLIC_NAME_SIZE,
 			 "%s",
-			 fdmi.model_description);
+			 fdmi->model_description);
 		snprintf(fc_host_hardware_version(lport->host),
 			 FC_VERSION_STRING_SIZE,
 			 "%s",
-			 fdmi.hardware_version);
+			 fdmi->hardware_version);
 		snprintf(fc_host_driver_version(lport->host),
 			 FC_VERSION_STRING_SIZE,
 			 "%s",
-			 fdmi.driver_version);
+			 fdmi->driver_version);
 		snprintf(fc_host_optionrom_version(lport->host),
 			 FC_VERSION_STRING_SIZE,
 			 "%s",
-			 fdmi.optionrom_version);
+			 fdmi->optionrom_version);
 		snprintf(fc_host_firmware_version(lport->host),
 			 FC_VERSION_STRING_SIZE,
 			 "%s",
-			 fdmi.firmware_version);
+			 fdmi->firmware_version);
 
 		/* Enable FDMI lport states */
 		lport->fdmi_enabled = 1;
+		kfree(fdmi);
 	} else {
 		lport->fdmi_enabled = 0;
 		printk(KERN_INFO "fcoe: No FDMI support.\n");

