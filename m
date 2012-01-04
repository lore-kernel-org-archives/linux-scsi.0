From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH v2 04/15] isci: oem parameter format v1.1 (ssc select)
Date: Wed, 04 Jan 2012 01:32:44 -0800
Message-ID: <20120104093244.9147.48298.stgit@localhost6.localdomain6>
References: <20120104093015.9147.24234.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:13453 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754805Ab2ADJcp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 4 Jan 2012 04:32:45 -0500
In-Reply-To: <20120104093015.9147.24234.stgit@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Dave Jiang <dave.jiang@intel.com>

From: Dave Jiang <dave.jiang@intel.com>

v1.1 allows finer grained tuning of the SSC (spread-spectrum-clocking)
settings for SAS and SATA.  See notes in probe_roms.h

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/scsi/isci/host.c       |   47 ++++++++++++++++++++++++++++++++++-
 drivers/scsi/isci/init.c       |    3 ++
 drivers/scsi/isci/phy.c        |   51 ++++++++++++++++++++++++++++++++++++++
 drivers/scsi/isci/probe_roms.h |   53 ++++++++++++++++++++++++++++++++++++++--
 4 files changed, 148 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/isci/host.c b/drivers/scsi/isci/host.c
index 383bb69..ed1441c 100644
--- a/drivers/scsi/isci/host.c
+++ b/drivers/scsi/isci/host.c
@@ -1759,7 +1759,7 @@ static enum sci_status sci_controller_construct(struct isci_host *ihost,
 	return sci_controller_reset(ihost);
 }
 
-int sci_oem_parameters_validate(struct sci_oem_params *oem)
+int sci_oem_parameters_validate(struct sci_oem_params *oem, u8 version)
 {
 	int i;
 
@@ -1791,18 +1791,61 @@ int sci_oem_parameters_validate(struct sci_oem_params *oem)
 	    oem->controller.max_concurr_spin_up < 1)
 		return -EINVAL;
 
+	if (oem->controller.do_enable_ssc) {
+		if (version < ISCI_ROM_VER_1_1 && oem->controller.do_enable_ssc != 1)
+			return -EINVAL;
+
+		if (version >= ISCI_ROM_VER_1_1) {
+			u8 test = oem->controller.ssc_sata_tx_spread_level;
+
+			switch (test) {
+			case 0:
+			case 2:
+			case 3:
+			case 6:
+			case 7:
+				break;
+			default:
+				return -EINVAL;
+			}
+
+			test = oem->controller.ssc_sas_tx_spread_level;
+			if (oem->controller.ssc_sas_tx_type == 0) {
+				switch (test) {
+				case 0:
+				case 2:
+				case 3:
+					break;
+				default:
+					return -EINVAL;
+				}
+			} else if (oem->controller.ssc_sas_tx_type == 1) {
+				switch (test) {
+				case 0:
+				case 3:
+				case 6:
+					break;
+				default:
+					return -EINVAL;
+				}
+			}
+		}
+	}
+
 	return 0;
 }
 
 static enum sci_status sci_oem_parameters_set(struct isci_host *ihost)
 {
 	u32 state = ihost->sm.current_state_id;
+	struct isci_pci_info *pci_info = to_pci_info(ihost->pdev);
 
 	if (state == SCIC_RESET ||
 	    state == SCIC_INITIALIZING ||
 	    state == SCIC_INITIALIZED) {
 
-		if (sci_oem_parameters_validate(&ihost->oem_parameters))
+		if (sci_oem_parameters_validate(&ihost->oem_parameters,
+						pci_info->orom->hdr.version))
 			return SCI_FAILURE_INVALID_PARAMETER_VALUE;
 
 		return SCI_SUCCESS;
diff --git a/drivers/scsi/isci/init.c b/drivers/scsi/isci/init.c
index a97edab..8a34fd9 100644
--- a/drivers/scsi/isci/init.c
+++ b/drivers/scsi/isci/init.c
@@ -466,7 +466,8 @@ static int __devinit isci_pci_probe(struct pci_dev *pdev, const struct pci_devic
 		orom = isci_request_oprom(pdev);
 
 	for (i = 0; orom && i < ARRAY_SIZE(orom->ctrl); i++) {
-		if (sci_oem_parameters_validate(&orom->ctrl[i])) {
+		if (sci_oem_parameters_validate(&orom->ctrl[i],
+						orom->hdr.version)) {
 			dev_warn(&pdev->dev,
 				 "[%d]: invalid oem parameters detected, falling back to firmware\n", i);
 			devm_kfree(&pdev->dev, orom);
diff --git a/drivers/scsi/isci/phy.c b/drivers/scsi/isci/phy.c
index c650d30..61000cd 100644
--- a/drivers/scsi/isci/phy.c
+++ b/drivers/scsi/isci/phy.c
@@ -144,10 +144,59 @@ sci_phy_link_layer_initialization(struct isci_phy *iphy,
 	phy_cap.gen3_no_ssc = 1;
 	phy_cap.gen2_no_ssc = 1;
 	phy_cap.gen1_no_ssc = 1;
-	if (ihost->oem_parameters.controller.do_enable_ssc == true) {
+	if (ihost->oem_parameters.controller.do_enable_ssc) {
+		struct scu_afe_registers __iomem *afe = &ihost->scu_registers->afe;
+		struct scu_afe_transceiver *xcvr = &afe->scu_afe_xcvr[phy_idx];
+		struct isci_pci_info *pci_info = to_pci_info(ihost->pdev);
+		bool en_sas = false;
+		bool en_sata = false;
+		u32 sas_type = 0;
+		u32 sata_spread = 0x2;
+		u32 sas_spread = 0x2;
+
 		phy_cap.gen3_ssc = 1;
 		phy_cap.gen2_ssc = 1;
 		phy_cap.gen1_ssc = 1;
+
+		if (pci_info->orom->hdr.version < ISCI_ROM_VER_1_1)
+			en_sas = en_sata = true;
+		else {
+			sata_spread = ihost->oem_parameters.controller.ssc_sata_tx_spread_level;
+			sas_spread = ihost->oem_parameters.controller.ssc_sas_tx_spread_level;
+
+			if (sata_spread)
+				en_sata = true;
+
+			if (sas_spread) {
+				en_sas = true;
+				sas_type = ihost->oem_parameters.controller.ssc_sas_tx_type;
+			}
+
+		}
+
+		if (en_sas) {
+			u32 reg;
+
+			reg = readl(&xcvr->afe_xcvr_control0);
+			reg |= (0x00100000 | (sas_type << 19));
+			writel(reg, &xcvr->afe_xcvr_control0);
+
+			reg = readl(&xcvr->afe_tx_ssc_control);
+			reg |= sas_spread << 8;
+			writel(reg, &xcvr->afe_tx_ssc_control);
+		}
+
+		if (en_sata) {
+			u32 reg;
+
+			reg = readl(&xcvr->afe_tx_ssc_control);
+			reg |= sata_spread;
+			writel(reg, &xcvr->afe_tx_ssc_control);
+
+			reg = readl(&llr->stp_control);
+			reg |= 1 << 12;
+			writel(reg, &llr->stp_control);
+		}
 	}
 
 	/* The SAS specification indicates that the phy_capabilities that
diff --git a/drivers/scsi/isci/probe_roms.h b/drivers/scsi/isci/probe_roms.h
index 2c75248..42dd054 100644
--- a/drivers/scsi/isci/probe_roms.h
+++ b/drivers/scsi/isci/probe_roms.h
@@ -152,7 +152,7 @@ struct sci_user_parameters {
 #define MAX_CONCURRENT_DEVICE_SPIN_UP_COUNT 4
 
 struct sci_oem_params;
-int sci_oem_parameters_validate(struct sci_oem_params *oem);
+int sci_oem_parameters_validate(struct sci_oem_params *oem, u8 version);
 
 struct isci_orom;
 struct isci_orom *isci_request_oprom(struct pci_dev *pdev);
@@ -191,6 +191,10 @@ struct isci_oem_hdr {
 			0x1a, 0x04, 0xc6)
 #define ISCI_EFI_VAR_NAME	"RstScuO"
 
+#define ISCI_ROM_VER_1_0	0x10
+#define ISCI_ROM_VER_1_1	0x11
+#define ISCI_ROM_VER_LATEST	ISCI_ROM_VER_1_1
+
 /* Allowed PORT configuration modes APC Automatic PORT configuration mode is
  * defined by the OEM configuration parameters providing no PHY_MASK parameters
  * for any PORT. i.e. There are no phys assigned to any of the ports at start.
@@ -220,7 +224,52 @@ struct sci_oem_params {
 	struct {
 		uint8_t mode_type;
 		uint8_t max_concurr_spin_up;
-		uint8_t do_enable_ssc;
+		/*
+		 * This bitfield indicates the OEM's desired default Tx
+		 * Spread Spectrum Clocking (SSC) settings for SATA and SAS.
+		 * NOTE: Default SSC Modulation Frequency is 31.5KHz.
+		 */
+		union {
+			struct {
+			/*
+			 * NOTE: Max spread for SATA is +0 / -5000 PPM.
+			 * Down-spreading SSC (only method allowed for SATA):
+			 *  SATA SSC Tx Disabled                    = 0x0
+			 *  SATA SSC Tx at +0 / -1419 PPM Spread    = 0x2
+			 *  SATA SSC Tx at +0 / -2129 PPM Spread    = 0x3
+			 *  SATA SSC Tx at +0 / -4257 PPM Spread    = 0x6
+			 *  SATA SSC Tx at +0 / -4967 PPM Spread    = 0x7
+			 */
+				uint8_t ssc_sata_tx_spread_level:4;
+			/*
+			 * SAS SSC Tx Disabled                     = 0x0
+			 *
+			 * NOTE: Max spread for SAS down-spreading +0 /
+			 *	 -2300 PPM
+			 * Down-spreading SSC:
+			 *  SAS SSC Tx at +0 / -1419 PPM Spread     = 0x2
+			 *  SAS SSC Tx at +0 / -2129 PPM Spread     = 0x3
+			 *
+			 * NOTE: Max spread for SAS center-spreading +2300 /
+			 *	 -2300 PPM
+			 * Center-spreading SSC:
+			 *  SAS SSC Tx at +1064 / -1064 PPM Spread  = 0x3
+			 *  SAS SSC Tx at +2129 / -2129 PPM Spread  = 0x6
+			 */
+				uint8_t ssc_sas_tx_spread_level:3;
+			/*
+			 * NOTE: Refer to the SSC section of the SAS 2.x
+			 * Specification for proper setting of this field.
+			 * For standard SAS Initiator SAS PHY operation it
+			 * should be 0 for Down-spreading.
+			 * SAS SSC Tx spread type:
+			 *  Down-spreading SSC      = 0
+			 *  Center-spreading SSC    = 1
+			 */
+				uint8_t ssc_sas_tx_type:1;
+			};
+			uint8_t do_enable_ssc;
+		};
 		uint8_t reserved;
 	} controller;
 

