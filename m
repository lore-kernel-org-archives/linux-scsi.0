From: Dan Williams <dan.j.williams@intel.com>
Subject: [3.2-rc PATCH 4/8] isci: oem parameter format v1.3 (cable select)
Date: Fri, 16 Dec 2011 16:53:31 -0800
Message-ID: <20111217005331.14133.11618.stgit@localhost6.localdomain6>
References: <20111217004820.14133.19249.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:59293 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751955Ab1LQAxc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 16 Dec 2011 19:53:32 -0500
In-Reply-To: <20111217004820.14133.19249.stgit@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Jeff Skirvin <jeffrey.d.skirvin@intel.com>, Jiangbi Liu <jiangbi.liu@intel.com>

From: Jeff Skirvin <jeffrey.d.skirvin@intel.com>

v1.3 allows the attenuation of the attached cables to be specified to
the driver in terms of 'short', 'medium', and 'long' (see probe_roms.h).
These settings (per phy) are retrieved from the platform oem-parameters
(BIOS rom) or via a module parameter override.

Reviewed-by: Jiangbi Liu <jiangbi.liu@intel.com>
Signed-off-by: Jeff Skirvin <jeffrey.d.skirvin@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/scsi/isci/firmware/create_fw.c |    6 ++++
 drivers/scsi/isci/firmware/create_fw.h |    2 +
 drivers/scsi/isci/host.c               |   43 ++++++++++++++++++++++++++++++--
 drivers/scsi/isci/host.h               |   18 +++++++++++++
 drivers/scsi/isci/init.c               |   16 ++++++++++++
 drivers/scsi/isci/isci.h               |    1 +
 drivers/scsi/isci/probe_roms.h         |   38 +++++++++++++++++++++++++++-
 7 files changed, 119 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/isci/firmware/create_fw.c b/drivers/scsi/isci/firmware/create_fw.c
index 36eabef..fd0674b 100644
--- a/drivers/scsi/isci/firmware/create_fw.c
+++ b/drivers/scsi/isci/firmware/create_fw.c
@@ -51,6 +51,7 @@ void set_binary_values(struct isci_orom *isci_orom)
 
 	for (c = 0; c < 2; c++) {
 		struct sci_oem_params *ctrl = &isci_orom->ctrl[c];
+		__u8 cable_selection_mask = 0;
 
 		ctrl->controller.mode_type = mode_type;
 		ctrl->controller.max_concurr_spin_up = max_num_concurrent_dev_spin_up;
@@ -61,6 +62,7 @@ void set_binary_values(struct isci_orom *isci_orom)
 
 		for (phy_idx = 0; phy_idx < SCI_MAX_PHYS; phy_idx++) {
 			struct sci_phy_oem_params *phy = &ctrl->phys[phy_idx];
+			__u8 cable_phy = cable_selection[c][phy_idx];
 
 			phy->sas_address.high = sas_addr[c][phy_idx] >> 32;
 			phy->sas_address.low = sas_addr[c][phy_idx];
@@ -69,7 +71,11 @@ void set_binary_values(struct isci_orom *isci_orom)
 			phy->afe_tx_amp_control1 = afe_tx_amp_control1;
 			phy->afe_tx_amp_control2 = afe_tx_amp_control2;
 			phy->afe_tx_amp_control3 = afe_tx_amp_control3;
+
+			cable_selection_mask |= (cable_phy & 1) << phy_idx;
+			cable_selection_mask |= (cable_phy & 2) << (phy_idx + 3);
 		}
+		ctrl->controller.cable_selection_mask = cable_selection_mask;
 	}
 }
 
diff --git a/drivers/scsi/isci/firmware/create_fw.h b/drivers/scsi/isci/firmware/create_fw.h
index e12dbd7..0602813 100644
--- a/drivers/scsi/isci/firmware/create_fw.h
+++ b/drivers/scsi/isci/firmware/create_fw.h
@@ -58,6 +58,8 @@ static const unsigned long long sas_addr[2][4] = { { 0x5FCFFFFF00000001ULL,
 						     0x5FCFFFFF00000002ULL } };
 #endif
 
+static const int cable_selection[2][4];
+
 /* Maximum number of concurrent device spin up */
 static const int max_num_concurrent_dev_spin_up = 1;
 
diff --git a/drivers/scsi/isci/host.c b/drivers/scsi/isci/host.c
index 2521cee..3374f1b 100644
--- a/drivers/scsi/isci/host.c
+++ b/drivers/scsi/isci/host.c
@@ -1666,6 +1666,9 @@ static void sci_controller_set_default_config_parameters(struct isci_host *ihost
 	/* Default to no SSC operation. */
 	ihost->oem_parameters.controller.do_enable_ssc = false;
 
+	/* Default to short cables on all phys. */
+	ihost->oem_parameters.controller.cable_selection_mask = 0;
+
 	/* Initialize all of the port parameter information to narrow ports. */
 	for (index = 0; index < SCI_MAX_PORTS; index++) {
 		ihost->oem_parameters.ports[index].phy_mask = 0;
@@ -1953,12 +1956,46 @@ void sci_controller_power_control_queue_remove(struct isci_host *ihost,
 
 static int is_long_cable(int phy, unsigned char selection_byte)
 {
-	return 0;
+	return !!(selection_byte & (1 << phy));
 }
 
 static int is_medium_cable(int phy, unsigned char selection_byte)
 {
-	return 0;
+	return !!(selection_byte & (1 << (phy + 4)));
+}
+
+static enum cable_selections decode_selection_byte(
+	int phy,
+	unsigned char selection_byte)
+{
+	return ((selection_byte & (1 << phy)) ? 1 : 0)
+		+ (selection_byte & (1 << (phy + 4)) ? 2 : 0);
+}
+
+unsigned char *cable_selection_byte_ptr(struct isci_host *ihost)
+{
+	if (is_cable_select_overridden())
+		return ((unsigned char *)&cable_selection_override)
+			+ ihost->id;
+	else
+		return &ihost->oem_parameters.controller.cable_selection_mask;
+}
+
+enum cable_selections decode_cable_selection(struct isci_host *ihost, int phy)
+{
+	return decode_selection_byte(phy, *cable_selection_byte_ptr(ihost));
+}
+
+char *lookup_cable_names(enum cable_selections selection)
+{
+	static char *cable_names[] = {
+		[short_cable]     = "short",
+		[long_cable]      = "long",
+		[medium_cable]    = "medium",
+		[undefined_cable] = "<undefined, assumed long>" /* bit 0==1 */
+	};
+	return (selection <= undefined_cable) ? cable_names[selection]
+					      : cable_names[undefined_cable];
 }
 
 #define AFE_REGISTER_WRITE_DELAY 10
@@ -1967,10 +2004,10 @@ static void sci_controller_afe_initialization(struct isci_host *ihost)
 {
 	struct scu_afe_registers __iomem *afe = &ihost->scu_registers->afe;
 	const struct sci_oem_params *oem = &ihost->oem_parameters;
-	unsigned char cable_selection_mask = 0;
 	struct pci_dev *pdev = ihost->pdev;
 	u32 afe_status;
 	u32 phy_id;
+	unsigned char cable_selection_mask = *cable_selection_byte_ptr(ihost);
 
 	/* Clear DFX Status registers */
 	writel(0x0081000f, &afe->afe_dfx_master_control0);
diff --git a/drivers/scsi/isci/host.h b/drivers/scsi/isci/host.h
index 4573075..5477f0f 100644
--- a/drivers/scsi/isci/host.h
+++ b/drivers/scsi/isci/host.h
@@ -447,6 +447,24 @@ static inline bool is_c1(struct pci_dev *pdev)
 	return false;
 }
 
+enum cable_selections {
+	short_cable     = 0,
+	long_cable      = 1,
+	medium_cable    = 2,
+	undefined_cable = 3
+};
+
+#define CABLE_OVERRIDE_DISABLED (0x10000)
+
+static inline int is_cable_select_overridden(void)
+{
+	return cable_selection_override < CABLE_OVERRIDE_DISABLED;
+}
+
+enum cable_selections decode_cable_selection(struct isci_host *ihost, int phy);
+void validate_cable_selections(struct isci_host *ihost);
+char *lookup_cable_names(enum cable_selections);
+
 /* set hw control for 'activity', even though active enclosures seem to drive
  * the activity led on their own.  Skip setting FSENG control on 'status' due
  * to unexpected operation and 'error' due to not being a supported automatic
diff --git a/drivers/scsi/isci/init.c b/drivers/scsi/isci/init.c
index 8a34fd9..1047108 100644
--- a/drivers/scsi/isci/init.c
+++ b/drivers/scsi/isci/init.c
@@ -122,6 +122,14 @@ unsigned char max_concurr_spinup;
 module_param(max_concurr_spinup, byte, 0);
 MODULE_PARM_DESC(max_concurr_spinup, "Max concurrent device spinup");
 
+uint cable_selection_override = CABLE_OVERRIDE_DISABLED;
+module_param(cable_selection_override, uint, 0);
+
+MODULE_PARM_DESC(cable_selection_override,
+		 "This field indicates length of the SAS/SATA cable between "
+		 "host and device. If any bits > 15 are set (default) "
+		 "indicates \"use platform defaults\"");
+
 static ssize_t isci_show_id(struct device *dev, struct device_attribute *attr, char *buf)
 {
 	struct Scsi_Host *shost = container_of(dev, typeof(*shost), shost_dev);
@@ -412,6 +420,14 @@ static struct isci_host *isci_host_alloc(struct pci_dev *pdev, int id)
 		return NULL;
 	isci_host->shost = shost;
 
+	dev_info(&pdev->dev, "%sSCU controller %d: phy 3-0 cables: "
+		 "{%s, %s, %s, %s}\n",
+		 (is_cable_select_overridden() ? "* " : ""), isci_host->id,
+		 lookup_cable_names(decode_cable_selection(isci_host, 3)),
+		 lookup_cable_names(decode_cable_selection(isci_host, 2)),
+		 lookup_cable_names(decode_cable_selection(isci_host, 1)),
+		 lookup_cable_names(decode_cable_selection(isci_host, 0)));
+
 	err = isci_host_init(isci_host);
 	if (err)
 		goto err_shost;
diff --git a/drivers/scsi/isci/isci.h b/drivers/scsi/isci/isci.h
index 8efeb6b..234ab46 100644
--- a/drivers/scsi/isci/isci.h
+++ b/drivers/scsi/isci/isci.h
@@ -480,6 +480,7 @@ extern u16 ssp_inactive_to;
 extern u16 stp_inactive_to;
 extern unsigned char phy_gen;
 extern unsigned char max_concurr_spinup;
+extern uint cable_selection_override;
 
 irqreturn_t isci_msix_isr(int vec, void *data);
 irqreturn_t isci_intx_isr(int vec, void *data);
diff --git a/drivers/scsi/isci/probe_roms.h b/drivers/scsi/isci/probe_roms.h
index 42dd054..bb0e9d4 100644
--- a/drivers/scsi/isci/probe_roms.h
+++ b/drivers/scsi/isci/probe_roms.h
@@ -193,7 +193,8 @@ struct isci_oem_hdr {
 
 #define ISCI_ROM_VER_1_0	0x10
 #define ISCI_ROM_VER_1_1	0x11
-#define ISCI_ROM_VER_LATEST	ISCI_ROM_VER_1_1
+#define ISCI_ROM_VER_1_3	0x13
+#define ISCI_ROM_VER_LATEST	ISCI_ROM_VER_1_3
 
 /* Allowed PORT configuration modes APC Automatic PORT configuration mode is
  * defined by the OEM configuration parameters providing no PHY_MASK parameters
@@ -270,7 +271,40 @@ struct sci_oem_params {
 			};
 			uint8_t do_enable_ssc;
 		};
-		uint8_t reserved;
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

