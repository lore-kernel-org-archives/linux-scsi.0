From: "Dupuis, Chad" <chad.dupuis@cavium.com>
Subject: [PATCH 01/15] qedf: Enable basic FDMI information.
Date: Tue, 23 May 2017 06:19:17 -0700
Message-ID: <20170523131931.1777-2-chad.dupuis@cavium.com>
References: <20170523131931.1777-1-chad.dupuis@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-dm3nam03on0076.outbound.protection.outlook.com ([104.47.41.76]:45395
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S965465AbdEWNTi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 23 May 2017 09:19:38 -0400
In-Reply-To: <20170523131931.1777-1-chad.dupuis@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com, QLogic-Storage-Upstream@cavium.com

For libfc to register FDMI attributes we need to do two things:

- Set the appropriate fc_host attributes that libfc will use to form the
  FDMI registration commands
- Set lport->fdmi_enabled to 1

Signed-off-by: Chad Dupuis <chad.dupuis@cavium.com>
---
 drivers/scsi/qedf/qedf_main.c | 57 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 57 insertions(+)

diff --git a/drivers/scsi/qedf/qedf_main.c b/drivers/scsi/qedf/qedf_main.c
index cceddd9..2949932 100644
--- a/drivers/scsi/qedf/qedf_main.c
+++ b/drivers/scsi/qedf/qedf_main.c
@@ -22,6 +22,7 @@
 #include <linux/if_vlan.h>
 #include <linux/cpu.h>
 #include "qedf.h"
+#include <uapi/linux/pci_regs.h>
 
 const struct qed_fcoe_ops *qed_ops;
 
@@ -1334,6 +1335,60 @@ static void qedf_fcoe_ctlr_setup(struct qedf_ctx *qedf)
 	ether_addr_copy(qedf->ctlr.ctl_src_addr, qedf->mac);
 }
 
+static void qedf_setup_fdmi(struct qedf_ctx *qedf)
+{
+	struct fc_lport *lport = qedf->lport;
+	u8 buf[8];
+	int i, pos;
+
+	/*
+	 * fdmi_enabled needs to be set for libfc to execute FDMI registration.
+	 */
+	lport->fdmi_enabled = 1;
+
+	/*
+	 * Setup the necessary fc_host attributes to that will be used to fill
+	 * in the FDMI information.
+	 */
+
+	/* Get the PCI-e Device Serial Number Capability */
+	pos = pci_find_ext_capability(qedf->pdev, PCI_EXT_CAP_ID_DSN);
+	if (pos) {
+		pos += 4;
+		for (i = 0; i < 8; i++)
+			pci_read_config_byte(qedf->pdev, pos + i, &buf[i]);
+
+		snprintf(fc_host_serial_number(lport->host),
+		    FC_SERIAL_NUMBER_SIZE,
+		    "%02X%02X%02X%02X%02X%02X%02X%02X",
+		    buf[7], buf[6], buf[5], buf[4],
+		    buf[3], buf[2], buf[1], buf[0]);
+	} else
+		snprintf(fc_host_serial_number(lport->host),
+		    FC_SERIAL_NUMBER_SIZE, "Unknown");
+
+	snprintf(fc_host_manufacturer(lport->host),
+	    FC_SERIAL_NUMBER_SIZE, "%s", "Cavium Inc.");
+
+	snprintf(fc_host_model(lport->host),
+	    FC_SYMBOLIC_NAME_SIZE, "%s", "QL41000");
+
+	snprintf(fc_host_model_description(lport->host),
+	    FC_SYMBOLIC_NAME_SIZE, "%s", "QLogic FastLinQ QL41000 Series "
+	    "10/25/40/50GGbE Controller (FCoE)");
+
+	snprintf(fc_host_hardware_version(lport->host),
+	    FC_VERSION_STRING_SIZE, "Rev %d", qedf->pdev->revision);
+
+	snprintf(fc_host_driver_version(lport->host),
+	    FC_VERSION_STRING_SIZE, "%s", QEDF_VERSION);
+
+	snprintf(fc_host_firmware_version(lport->host),
+	    FC_VERSION_STRING_SIZE, "%d.%d.%d.%d",
+	    FW_MAJOR_VERSION, FW_MINOR_VERSION, FW_REVISION_VERSION,
+	    FW_ENGINEERING_VERSION);
+}
+
 static int qedf_lport_setup(struct qedf_ctx *qedf)
 {
 	struct fc_lport *lport = qedf->lport;
@@ -1377,6 +1432,8 @@ static int qedf_lport_setup(struct qedf_ctx *qedf)
 	snprintf(fc_host_symbolic_name(lport->host), 256,
 	    "QLogic %s v%s", QEDF_MODULE_NAME, QEDF_VERSION);
 
+	qedf_setup_fdmi(qedf);
+
 	return 0;
 }
 
-- 
1.8.5.6
