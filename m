From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 4/4] isci: add a couple __iomem annotations
Date: Wed, 11 Jul 2012 14:59:44 -0700
Message-ID: <20120711215944.26813.4706.stgit@dwillia2-linux.jf.intel.com>
References: <20120711215901.26813.19955.stgit@dwillia2-linux.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:20003 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754798Ab2GKVm4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 11 Jul 2012 17:42:56 -0400
In-Reply-To: <20120711215901.26813.19955.stgit@dwillia2-linux.jf.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@parallels.com
Cc: linux-scsi@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

These are __iomem.  Sparse complains if we don't have that.

drivers/scsi/isci/phy.c +149 70: warning:
        incorrect type in initializer (different address spaces)

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/scsi/isci/host.c |    2 +-
 drivers/scsi/isci/phy.c  |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/isci/host.c b/drivers/scsi/isci/host.c
index 45385f5..b425ed5 100644
--- a/drivers/scsi/isci/host.c
+++ b/drivers/scsi/isci/host.c
@@ -1973,7 +1973,7 @@ static void sci_controller_afe_initialization(struct isci_host *ihost)
 	}
 
 	for (phy_id = 0; phy_id < SCI_MAX_PHYS; phy_id++) {
-		struct scu_afe_transceiver *xcvr = &afe->scu_afe_xcvr[phy_id];
+		struct scu_afe_transceiver __iomem *xcvr = &afe->scu_afe_xcvr[phy_id];
 		const struct sci_phy_oem_params *oem_phy = &oem->phys[phy_id];
 		int cable_length_long =
 			is_long_cable(phy_id, cable_selection_mask);
diff --git a/drivers/scsi/isci/phy.c b/drivers/scsi/isci/phy.c
index ebb8f53..cb87b2e 100644
--- a/drivers/scsi/isci/phy.c
+++ b/drivers/scsi/isci/phy.c
@@ -169,7 +169,7 @@ sci_phy_link_layer_initialization(struct isci_phy *iphy,
 	phy_cap.gen1_no_ssc = 1;
 	if (ihost->oem_parameters.controller.do_enable_ssc) {
 		struct scu_afe_registers __iomem *afe = &ihost->scu_registers->afe;
-		struct scu_afe_transceiver *xcvr = &afe->scu_afe_xcvr[phy_idx];
+		struct scu_afe_transceiver __iomem *xcvr = &afe->scu_afe_xcvr[phy_idx];
 		struct isci_pci_info *pci_info = to_pci_info(ihost->pdev);
 		bool en_sas = false;
 		bool en_sata = false;

