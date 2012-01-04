From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH] firmware/isci: update to oem parameter format v1.3
Date: Wed, 04 Jan 2012 01:25:20 -0800
Message-ID: <20120104092339.8562.74674.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:2952 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754522Ab2ADJZV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 4 Jan 2012 04:25:21 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: ben@decadent.org.uk
Cc: linux-scsi@vger.kernel.org

v1.1 allows finer grained tuning of the SSC (spread-spectrum-clocking)
settings for SAS and SATA.  See notes in probe_roms.h

v1.3 allows the attenuation of the attached cables to be specified to
the driver in terms of 'short', 'medium', and 'long' (see probe_roms.h).
These settings (per phy) are retrieved from the platform oem-parameters
(BIOS rom), the fallback firmware blob, or via a module parameter
override.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
for linux-firmware.git

 isci/README            |    2 +
 isci/create_fw.c       |   53 +++++++++++++++--------------
 isci/create_fw.h       |   13 ++++++-
 isci/isci_firmware.bin |  Bin
 isci/probe_roms.h      |   89 ++++++++++++++++++++++++++++++++++++++++++++++--
 5 files changed, 125 insertions(+), 32 deletions(-)

diff --git a/isci/README b/isci/README
index 8056d2b..8e63ac3 100644
--- a/isci/README
+++ b/isci/README
@@ -31,6 +31,6 @@ Header Type - u8: 0xf
 
 ==============================================================================
 
-Place isci_firmware.bin in /lib/firmware
+Place isci_firmware.bin in /lib/firmware/isci
 Be sure to recreate the initramfs image to include the firmware.
 
diff --git a/isci/create_fw.c b/isci/create_fw.c
index 0ad30d8..af037fc 100644
--- a/isci/create_fw.c
+++ b/isci/create_fw.c
@@ -39,7 +39,7 @@ int write_blob(struct isci_orom *isci_orom)
 
 void set_binary_values(struct isci_orom *isci_orom)
 {
-	int ctrl_idx, phy_idx, port_idx;
+	int c, phy_idx, port_idx;
 
 	/* setting OROM signature */
 	strncpy(isci_orom->hdr.signature, sig, strlen(sig));
@@ -48,32 +48,33 @@ void set_binary_values(struct isci_orom *isci_orom)
 	isci_orom->hdr.hdr_length = sizeof(struct sci_bios_oem_param_block_hdr);
 	isci_orom->hdr.num_elements = num_elements;
 
-	for (ctrl_idx = 0; ctrl_idx < 2; ctrl_idx++) {
-		isci_orom->ctrl[ctrl_idx].controller.mode_type = mode_type;
-		isci_orom->ctrl[ctrl_idx].controller.max_concurr_spin_up =
-			max_num_concurrent_dev_spin_up;
-		isci_orom->ctrl[ctrl_idx].controller.do_enable_ssc =
-			enable_ssc;
-
-		for (port_idx = 0; port_idx < 4; port_idx++)
-			isci_orom->ctrl[ctrl_idx].ports[port_idx].phy_mask =
-				phy_mask[ctrl_idx][port_idx];
-
-		for (phy_idx = 0; phy_idx < 4; phy_idx++) {
-			isci_orom->ctrl[ctrl_idx].phys[phy_idx].sas_address.high =
-				(__u32)(sas_addr[ctrl_idx][phy_idx] >> 32);
-			isci_orom->ctrl[ctrl_idx].phys[phy_idx].sas_address.low =
-				(__u32)(sas_addr[ctrl_idx][phy_idx]);
-
-			isci_orom->ctrl[ctrl_idx].phys[phy_idx].afe_tx_amp_control0 =
-				afe_tx_amp_control0;
-			isci_orom->ctrl[ctrl_idx].phys[phy_idx].afe_tx_amp_control1 =
-				afe_tx_amp_control1;
-			isci_orom->ctrl[ctrl_idx].phys[phy_idx].afe_tx_amp_control2 =
-				afe_tx_amp_control2;
-			isci_orom->ctrl[ctrl_idx].phys[phy_idx].afe_tx_amp_control3 =
-				afe_tx_amp_control3;
+	for (c = 0; c < 2; c++) {
+		struct sci_oem_params *ctrl = &isci_orom->ctrl[c];
+		__u8 cable_selection_mask = 0;
+
+		ctrl->controller.mode_type = mode_type;
+		ctrl->controller.max_concurr_spin_up = max_num_concurrent_dev_spin_up;
+		ctrl->controller.do_enable_ssc = enable_ssc;
+
+		for (port_idx = 0; port_idx < SCI_MAX_PORTS; port_idx++)
+			ctrl->ports[port_idx].phy_mask = phy_mask[c][port_idx];
+
+		for (phy_idx = 0; phy_idx < SCI_MAX_PHYS; phy_idx++) {
+			struct sci_phy_oem_params *phy = &ctrl->phys[phy_idx];
+			__u8 cable_phy = cable_selection[c][phy_idx];
+
+			phy->sas_address.high = sas_addr[c][phy_idx] >> 32;
+			phy->sas_address.low = sas_addr[c][phy_idx];
+
+			phy->afe_tx_amp_control0 = afe_tx_amp_control0;
+			phy->afe_tx_amp_control1 = afe_tx_amp_control1;
+			phy->afe_tx_amp_control2 = afe_tx_amp_control2;
+			phy->afe_tx_amp_control3 = afe_tx_amp_control3;
+
+			cable_selection_mask |= (cable_phy & 1) << phy_idx;
+			cable_selection_mask |= (cable_phy & 2) << (phy_idx + 3);
 		}
+		ctrl->controller.cable_selection_mask = cable_selection_mask;
 	}
 }
 
diff --git a/isci/create_fw.h b/isci/create_fw.h
index 78c3ea7..f9b04ba 100644
--- a/isci/create_fw.h
+++ b/isci/create_fw.h
@@ -58,11 +58,20 @@ static const unsigned long long sas_addr[2][4] = { { 0x5FCFFFFF00000001ULL,
 						     0x5FCFFFFF00000002ULL } };
 #endif
 
+static const int cable_selection[2][4];
+
 /* Maximum number of concurrent device spin up */
 static const int max_num_concurrent_dev_spin_up = 1;
 
 /* enable of ssc operation */
-static const int enable_ssc;
+/*
+ * NOTE: also see probe_roms.h. This value can be set for ssc values.
+ * Values can be set for:
+ * ssc_sata_tx_spread_level
+ * ssc_sas_tx_spread_level
+ * ssc_sas_tx_type
+ */
+static const __u8 enable_ssc;
 
 /* AFE_TX_AMP_CONTROL */
 static const unsigned int afe_tx_amp_control0 = 0x000bdd08;
@@ -72,6 +81,6 @@ static const unsigned int afe_tx_amp_control3 = 0x000afc6e;
 
 static const char blob_name[] = "isci_firmware.bin";
 static const char sig[] = "ISCUOEMB";
-static const unsigned char version = 0x10;
+static const unsigned char version = ISCI_ROM_VER_LATEST;
 
 #endif
diff --git a/isci/isci_firmware.bin b/isci/isci_firmware.bin
index 963b3793ebdfef3a311f4aaf1b275ac0e221874c..4254fa4a6d25b70be8c8161aefe8a7b94906111a 100644
GIT binary patch
delta 20
bcmaFC_=1tgGuS!Q-__UY1%rg}M4meUNIM3?

delta 20
bcmaFC_=1tgGuS!Q-__UY1%rgZM4meUNG}Gz

diff --git a/isci/probe_roms.h b/isci/probe_roms.h
index 2c75248..bb0e9d4 100644
--- a/isci/probe_roms.h
+++ b/isci/probe_roms.h
@@ -152,7 +152,7 @@ struct sci_user_parameters {
 #define MAX_CONCURRENT_DEVICE_SPIN_UP_COUNT 4
 
 struct sci_oem_params;
-int sci_oem_parameters_validate(struct sci_oem_params *oem);
+int sci_oem_parameters_validate(struct sci_oem_params *oem, u8 version);
 
 struct isci_orom;
 struct isci_orom *isci_request_oprom(struct pci_dev *pdev);
@@ -191,6 +191,11 @@ struct isci_oem_hdr {
 			0x1a, 0x04, 0xc6)
 #define ISCI_EFI_VAR_NAME	"RstScuO"
 
+#define ISCI_ROM_VER_1_0	0x10
+#define ISCI_ROM_VER_1_1	0x11
+#define ISCI_ROM_VER_1_3	0x13
+#define ISCI_ROM_VER_LATEST	ISCI_ROM_VER_1_3
+
 /* Allowed PORT configuration modes APC Automatic PORT configuration mode is
  * defined by the OEM configuration parameters providing no PHY_MASK parameters
  * for any PORT. i.e. There are no phys assigned to any of the ports at start.
@@ -220,8 +225,86 @@ struct sci_oem_params {
 	struct {
 		uint8_t mode_type;
 		uint8_t max_concurr_spin_up;
-		uint8_t do_enable_ssc;
-		uint8_t reserved;
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
+		/*
+		 * This field indicates length of the SAS/SATA cable between
+		 * host and device.
+		 * This field is used make relationship between analog
+		 * parameters of the phy in the silicon and length of the cable.
+		 * Supported cable attenuation levels:
+		 * "short"- up to 3m, "medium"-3m to 6m, and "long"- more than
+		 * 6m.
+		 *
+		 * This is bit mask field:
+		 *
+		 * BIT:      (MSB) 7     6     5     4
+		 * ASSIGNMENT:   <phy3><phy2><phy1><phy0>  - Medium cable
+		 *                                           length assignment
+		 * BIT:            3     2     1     0  (LSB)
+		 * ASSIGNMENT:   <phy3><phy2><phy1><phy0>  - Long cable length
+		 *                                           assignment
+		 *
+		 * BITS 7-4 are set when the cable length is assigned to medium
+		 * BITS 3-0 are set when the cable length is assigned to long
+		 *
+		 * The BIT positions are clear when the cable length is
+		 * assigned to short.
+		 *
+		 * Setting the bits for both long and medium cable length is
+		 * undefined.
+		 *
+		 * A value of 0x84 would assign
+		 *    phy3 - medium
+		 *    phy2 - long
+		 *    phy1 - short
+		 *    phy0 - short
+		 */
+		uint8_t cable_selection_mask;
 	} controller;
 
 	struct {

