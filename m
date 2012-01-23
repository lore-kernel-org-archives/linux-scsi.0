From: Neerav Parikh <neerav.parikh@intel.com>
Subject: [PATCH 5/6] fcoe: Add support for FDMI in fcoe
Date: Sun, 22 Jan 2012 17:30:10 -0800
Message-ID: <20120123013010.923.78823.stgit@localhost6.localdomain6>
References: <20120123012944.923.63220.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:40830 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752528Ab2AWBlY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 22 Jan 2012 20:41:24 -0500
In-Reply-To: <20120123012944.923.63220.stgit@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: JBottomley@parallels.com, james.smart@emulex.com, devel@open-fcoe.org

This adds support for updating the FC-GS FDMI attributes
in the fcoe driver.

Signed-off-by: Neerav Parikh <neerav.parikh@intel.com>
Tested-by: Ross Brattain <ross.b.brattain@intel.com>
Acked-by: Robert Love <robert.w.love@intel.com>
---
 drivers/scsi/fcoe/fcoe.c |   82 ++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 82 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index e959960..b222e2d 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -734,6 +734,85 @@ static int fcoe_shost_config(struct fc_lport *lport, struct device *dev)
 	return 0;
 }
 
+
+/**
+ * fcoe_fdmi_info() - Get FDMI related info from net devive for SW FCoE
+ * @lport:  The local port that is associated with the net device
+ * @netdev: The associated net device
+ *
+ * Must be called after fcoe_shost_config() as it will use local port mutex
+ *
+ */
+static void fcoe_fdmi_info(struct fc_lport *lport, struct net_device *netdev)
+{
+	struct fcoe_interface *fcoe;
+	struct fcoe_port *port;
+	struct net_device *realdev;
+	int rc;
+	struct netdev_fcoe_hbainfo fdmi;
+
+	port = lport_priv(lport);
+	fcoe = port->priv;
+	realdev = fcoe->realdev;
+
+	if (!realdev)
+		return;
+
+	/* No FDMI state m/c for NPIV ports */
+	if (lport->vport)
+		return;
+
+	if (realdev->netdev_ops->ndo_fcoe_get_hbainfo) {
+		memset(&fdmi, 0, sizeof(fdmi));
+		rc = realdev->netdev_ops->ndo_fcoe_get_hbainfo(realdev,
+							       &fdmi);
+		if (rc) {
+			printk(KERN_INFO "fcoe: Failed to retrieve FDMI "
+					"information from netdev.\n");
+			return;
+		}
+
+		snprintf(fc_host_serial_number(lport->host),
+			 FC_SERIAL_NUMBER_SIZE,
+			 "%s",
+			 fdmi.serial_number);
+		snprintf(fc_host_manufacturer(lport->host),
+			 FC_SERIAL_NUMBER_SIZE,
+			 "%s",
+			 fdmi.manufacturer);
+		snprintf(fc_host_model(lport->host),
+			 FC_SYMBOLIC_NAME_SIZE,
+			 "%s",
+			 fdmi.model);
+		snprintf(fc_host_model_description(lport->host),
+			 FC_SYMBOLIC_NAME_SIZE,
+			 "%s",
+			 fdmi.model_description);
+		snprintf(fc_host_hardware_version(lport->host),
+			 FC_VERSION_STRING_SIZE,
+			 "%s",
+			 fdmi.hardware_version);
+		snprintf(fc_host_driver_version(lport->host),
+			 FC_VERSION_STRING_SIZE,
+			 "%s",
+			 fdmi.driver_version);
+		snprintf(fc_host_optionrom_version(lport->host),
+			 FC_VERSION_STRING_SIZE,
+			 "%s",
+			 fdmi.optionrom_version);
+		snprintf(fc_host_firmware_version(lport->host),
+			 FC_VERSION_STRING_SIZE,
+			 "%s",
+			 fdmi.firmware_version);
+
+		/* Enable FDMI lport states */
+		lport->fdmi_enabled = 1;
+	} else {
+		lport->fdmi_enabled = 0;
+		printk(KERN_INFO "fcoe: No FDMI support.\n");
+	}
+}
+
 /**
  * fcoe_oem_match() - The match routine for the offloaded exchange manager
  * @fp: The I/O frame
@@ -1047,6 +1126,9 @@ static struct fc_lport *fcoe_if_create(struct fcoe_interface *fcoe,
 		goto out_lp_destroy;
 	}
 
+	/* Initialized FDMI information */
+	fcoe_fdmi_info(lport, netdev);
+
 	/*
 	 * fcoe_em_alloc() and fcoe_hostlist_add() both
 	 * need to be atomic with respect to other changes to the

