From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [patch] [SCSI] isci: add a couple __iomem annotations
Date: Wed, 18 Jan 2012 10:44:18 +0300
Message-ID: <20120118074418.GA3582@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:46144 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752947Ab2ARHpB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Jan 2012 02:45:01 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Intel SCU Linux support <intel-linux-scu@intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>, Dave Jiang <dave.jiang@intel.com>, Ed Nadolski <edmund.nadolski@intel.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org

These are __iomem.  Sparse complains if we don't have that.

drivers/scsi/isci/phy.c +149 70: warning:
	incorrect type in initializer (different address spaces)

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/scsi/isci/phy.c b/drivers/scsi/isci/phy.c
index fe18acf..05fd511 100644
--- a/drivers/scsi/isci/phy.c
+++ b/drivers/scsi/isci/phy.c
@@ -146,7 +146,7 @@ sci_phy_link_layer_initialization(struct isci_phy *iphy,
 	phy_cap.gen1_no_ssc = 1;
 	if (ihost->oem_parameters.controller.do_enable_ssc) {
 		struct scu_afe_registers __iomem *afe = &ihost->scu_registers->afe;
-		struct scu_afe_transceiver *xcvr = &afe->scu_afe_xcvr[phy_idx];
+		struct scu_afe_transceiver __iomem *xcvr = &afe->scu_afe_xcvr[phy_idx];
 		struct isci_pci_info *pci_info = to_pci_info(ihost->pdev);
 		bool en_sas = false;
 		bool en_sata = false;
diff --git a/drivers/scsi/isci/host.c b/drivers/scsi/isci/host.c
index 1a65d65..0db7572 100644
--- a/drivers/scsi/isci/host.c
+++ b/drivers/scsi/isci/host.c
@@ -2113,7 +2113,7 @@ static void sci_controller_afe_initialization(struct isci_host *ihost)
 	}
 
 	for (phy_id = 0; phy_id < SCI_MAX_PHYS; phy_id++) {
-		struct scu_afe_transceiver *xcvr = &afe->scu_afe_xcvr[phy_id];
+		struct scu_afe_transceiver __iomem *xcvr = &afe->scu_afe_xcvr[phy_id];
 		const struct sci_phy_oem_params *oem_phy = &oem->phys[phy_id];
 		int cable_length_long =
 			is_long_cable(phy_id, cable_selection_mask);
