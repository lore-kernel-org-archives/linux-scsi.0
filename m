From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH v2 10/15] isci: Fix IO fails when pull cable from phy in x4
 wideport in MPC mode.
Date: Wed, 04 Jan 2012 01:33:15 -0800
Message-ID: <20120104093315.9147.18799.stgit@localhost6.localdomain6>
References: <20120104093015.9147.24234.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:35185 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754732Ab2ADJdQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 4 Jan 2012 04:33:16 -0500
In-Reply-To: <20120104093015.9147.24234.stgit@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Marcin Tomczak <marcin.tomczak@intel.com>

From: Marcin Tomczak <marcin.tomczak@intel.com>

Failure seen pulling a cable from a x4 port configured in manual port
configuration (MPC) mode (MPC mode is set by the the OEM paramaters
provided by the platform or isci_firmware.bin).  While IO running to
devices behind and expander, plugging out the cable from phy is causing
IO failures and IO drops on disks and never recover.

It happens because during link up/down the phy were being taken out of
the port.

Fix: during link down the phy is kept in the same logical port.

Signed-off-by: Marcin Tomczak <marcin.tomczak@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/scsi/isci/port.c |   10 +++++++---
 1 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/isci/port.c b/drivers/scsi/isci/port.c
index ac7f277..4cb071d 100644
--- a/drivers/scsi/isci/port.c
+++ b/drivers/scsi/isci/port.c
@@ -674,9 +674,13 @@ void sci_port_deactivate_phy(struct isci_port *iport, struct isci_phy *iphy,
 
 	iphy->max_negotiated_speed = SAS_LINK_RATE_UNKNOWN;
 
-	/* Re-assign the phy back to the LP as if it were a narrow port */
-	writel(iphy->phy_index,
-		&iport->port_pe_configuration_register[iphy->phy_index]);
+	/* Re-assign the phy back to the LP as if it were a narrow port for APC
+	 * mode. For MPC mode, the phy will remain in the port.
+	 */
+	if (iport->owning_controller->oem_parameters.controller.mode_type ==
+		SCIC_PORT_AUTOMATIC_CONFIGURATION_MODE)
+		writel(iphy->phy_index,
+			&iport->port_pe_configuration_register[iphy->phy_index]);
 
 	if (do_notify_user == true)
 		isci_port_link_down(ihost, iphy, iport);

