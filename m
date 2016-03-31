From: Joao Pinto <Joao.Pinto@synopsys.com>
Subject: [PATCH v12 6/9] added support for DesignWare Controller
Date: Thu, 31 Mar 2016 19:57:19 +0100
Message-ID: <75cb43b16231f67d1e94e174a45ad6ffc68e1df6.1459448160.git.jpinto@synopsys.com>
References: <cover.1459448160.git.jpinto@synopsys.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1459448160.git.jpinto@synopsys.com>
In-Reply-To: <cover.1459448160.git.jpinto@synopsys.com>
References: <cover.1459448160.git.jpinto@synopsys.com>
Sender: linux-kernel-owner@vger.kernel.org
To: tomas.winkler@intel.com
Cc: vinholikatti@gmail.com, julian.calaby@gmail.com, akinobu.mita@gmail.com, hch@infradead.org, gbroner@codeaurora.org, subhashj@codeaurora.org, CARLOS.PALMINHA@synopsys.com, ijc+devicetree@hellion.org.uk, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, devicetree@vger.kernel.org, arnd@arndb.de, mark.rutland@arm.com, Joao Pinto <Joao.Pinto@synopsys.com>
List-Id: linux-scsi@vger.kernel.org

This patch has the goal to add support for DesignWare UFS Controller
specific operations.

Signed-off-by: Joao Pinto <jpinto@synopsys.com>
---
Changes v11->v12 (Tomas Winkler):
- custom_phy_initialization is now phy_initialization
- ufshcd_is_intr_aggr_allowed() has now a DWC tweak
- link status was now moved to a separated patch
Changes v10->v11:
- Nothing changed (just to keep up with patch set version).
Changes v9->v10 (Arnd Bergmann):
- Patch now only has DWC controller specific code
- Added custom_phy_initialization callback for PHY specific code
Changes v8->v9 (Robert Herring):
- drop 0x in the node declaration
- most specific compatibility string declared first
Changes v7->v8 (Akinobu Mita):
- DME sets were simplified for easier reading
- CLK DIV default values definitions names were changed to match the
 register's name
- New line added to dev_err and dev_info statements
Changes v6->v7 (Arnd Bergmann):
- Changed DT node name (to ufs only) and the memory address (to 0xd000000)
- Removed CONFIG_PM from the PCI glue driver (pm.h already does this)
- No other changes are necessary in ufshcd.c because of the link up notify
 function usage (it is simpler now)
- Removed the PHY mentioning since the Test Chip is not a real PHY for real
 world usage, since it is a test chip for prototyping with a very specific
 usage
- Added again the Test Chip 20-bit option
Changes v5->v6:
- Patch bad format fixed
Changes v4->v5 (Akinobu Mita):
- All functions used only locally in ufshcd-dwc are now declared as static
- ufshcd_dwc_configuration() was removed in ufshcd-dwc and a notify
 function (ufshcd_dwc_link_startup_notify) was created to deal with the
 DWC specific init routines
- 20-bit RMMI option was removed from Kconfig. Now if MPHY TC is selected
 and 40-bit is not then it assumes a 20-bit config
Changes v3->v4 (Arnd Bergmann and Mark Rutland):
- SCSI_UFS_DWC_HOOKS is now silent and selected by the SCSI_UFS_DWC_PLAT
 or SCSI_UFS_DWC_PCI
- Compatibility string has the ufs core version for info purposes since
 the driver is capable of getting the controller version from its 
 registers
- Created ufs-dwc-pci glue driver with specific DWC data
- MPHY configuration remains in the ufshcd-dwc since it is unipro
 attribute writting only not following the a linux phy framework logic
Changes v2->v3 (Julian Calaby):
- Implement a common DWC code to be used by the platform and pci glue
 drivers
- Synopsys ID & Class added to the existing pci driver and specific DWC
 was also added to the pci driver
Changes v1->v2 (Akinobu Mita):
- Implement a platform driver that uses the existing UFS core driver
- Add DWC specific code to the existing UFS core driver

 MAINTAINERS                   |   6 ++
 drivers/scsi/ufs/Kconfig      |   3 +
 drivers/scsi/ufs/Makefile     |   1 +
 drivers/scsi/ufs/ufshcd-dwc.c | 150 ++++++++++++++++++++++++++++++++++++++++++
 drivers/scsi/ufs/ufshcd-dwc.h |  26 ++++++++
 drivers/scsi/ufs/ufshcd.h     |   7 ++
 drivers/scsi/ufs/ufshci-dwc.h |  36 ++++++++++
 7 files changed, 229 insertions(+)
 create mode 100644 drivers/scsi/ufs/ufshcd-dwc.c
 create mode 100644 drivers/scsi/ufs/ufshcd-dwc.h
 create mode 100644 drivers/scsi/ufs/ufshci-dwc.h

diff --git a/MAINTAINERS b/MAINTAINERS
index 32bafda..7fc2730 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -11408,6 +11408,12 @@ S:	Supported
 F:	Documentation/scsi/ufs.txt
 F:	drivers/scsi/ufs/
 
+UNIVERSAL FLASH STORAGE HOST CONTROLLER DRIVER DWC HOOKS
+M:	Joao Pinto <Joao.Pinto@synopsys.com>
+L:	linux-scsi@vger.kernel.org
+S:	Supported
+F:	drivers/scsi/ufs/*dwc*
+
 UNSORTED BLOCK IMAGES (UBI)
 M:	Artem Bityutskiy <dedekind1@gmail.com>
 M:	Richard Weinberger <richard@nod.at>
diff --git a/drivers/scsi/ufs/Kconfig b/drivers/scsi/ufs/Kconfig
index 5f45307..647c324 100644
--- a/drivers/scsi/ufs/Kconfig
+++ b/drivers/scsi/ufs/Kconfig
@@ -83,3 +83,6 @@ config SCSI_UFS_QCOM
 
 	  Select this if you have UFS controller on QCOM chipset.
 	  If unsure, say N.
+
+config SCSI_UFS_DWC
+	bool
diff --git a/drivers/scsi/ufs/Makefile b/drivers/scsi/ufs/Makefile
index 8303bcc..ccbad53 100644
--- a/drivers/scsi/ufs/Makefile
+++ b/drivers/scsi/ufs/Makefile
@@ -1,4 +1,5 @@
 # UFSHCD makefile
+obj-$(CONFIG_SCSI_UFS_DWC) += ufshcd-dwc.o
 obj-$(CONFIG_SCSI_UFS_QCOM) += ufs-qcom.o
 obj-$(CONFIG_SCSI_UFSHCD) += ufshcd.o
 obj-$(CONFIG_SCSI_UFSHCD_PCI) += ufshcd-pci.o
diff --git a/drivers/scsi/ufs/ufshcd-dwc.c b/drivers/scsi/ufs/ufshcd-dwc.c
new file mode 100644
index 0000000..9b3ca7f
--- /dev/null
+++ b/drivers/scsi/ufs/ufshcd-dwc.c
@@ -0,0 +1,150 @@
+/*
+ * UFS Host driver for Synopsys Designware Core
+ *
+ * Copyright (C) 2015-2016 Synopsys, Inc. (www.synopsys.com)
+ *
+ * Authors: Joao Pinto <jpinto@synopsys.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include "ufshcd.h"
+#include "unipro.h"
+
+#include "ufshcd-dwc.h"
+#include "ufshci-dwc.h"
+
+int ufshcd_dwc_dme_set_attrs(struct ufs_hba *hba,
+				const struct ufshcd_dme_attr_val *v, int n)
+{
+	int ret = 0;
+	int attr_node = 0;
+
+	for (attr_node = 0; attr_node < n; attr_node++) {
+		ret = ufshcd_dme_set_attr(hba, v[attr_node].attr_sel,
+			ATTR_SET_NOR, v[attr_node].mib_val, v[attr_node].peer);
+
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL(ufshcd_dwc_dme_set_attrs);
+
+/**
+ * ufshcd_dwc_program_clk_div()
+ * This function programs the clk divider value. This value is needed to
+ * provide 1 microsecond tick to unipro layer.
+ * @hba: Private Structure pointer
+ * @divider_val: clock divider value to be programmed
+ *
+ */
+static void ufshcd_dwc_program_clk_div(struct ufs_hba *hba, u32 divider_val)
+{
+	ufshcd_writel(hba, divider_val, DWC_UFS_REG_HCLKDIV);
+}
+
+/**
+ * ufshcd_dwc_link_is_up()
+ * Check if link is up
+ * @hba: private structure poitner
+ *
+ * Returns 0 on success, non-zero value on failure
+ */
+static int ufshcd_dwc_link_is_up(struct ufs_hba *hba)
+{
+	int dme_result = 0;
+
+	ufshcd_dme_get(hba, UIC_ARG_MIB(VS_POWERSTATE), &dme_result);
+
+	if (dme_result == UFSHCD_LINK_IS_UP) {
+		ufshcd_set_link_active(hba);
+		return 0;
+	}
+
+	return 1;
+}
+
+/**
+ * ufshcd_dwc_connection_setup()
+ * This function configures both the local side (host) and the peer side
+ * (device) unipro attributes to establish the connection to application/
+ * cport.
+ * This function is not required if the hardware is properly configured to
+ * have this connection setup on reset. But invoking this function does no
+ * harm and should be fine even working with any ufs device.
+ *
+ * @hba: pointer to drivers private data
+ *
+ * Returns 0 on success non-zero value on failure
+ */
+static int ufshcd_dwc_connection_setup(struct ufs_hba *hba)
+{
+	const struct ufshcd_dme_attr_val setup_attrs[] = {
+		{ UIC_ARG_MIB(T_CONNECTIONSTATE), 0, DME_LOCAL },
+		{ UIC_ARG_MIB(N_DEVICEID), 0, DME_LOCAL },
+		{ UIC_ARG_MIB(N_DEVICEID_VALID), 0, DME_LOCAL },
+		{ UIC_ARG_MIB(T_PEERDEVICEID), 1, DME_LOCAL },
+		{ UIC_ARG_MIB(T_PEERCPORTID), 0, DME_LOCAL },
+		{ UIC_ARG_MIB(T_TRAFFICCLASS), 0, DME_LOCAL },
+		{ UIC_ARG_MIB(T_CPORTFLAGS), 0x6, DME_LOCAL },
+		{ UIC_ARG_MIB(T_CPORTMODE), 1, DME_LOCAL },
+		{ UIC_ARG_MIB(T_CONNECTIONSTATE), 1, DME_LOCAL },
+		{ UIC_ARG_MIB(T_CONNECTIONSTATE), 0, DME_PEER },
+		{ UIC_ARG_MIB(N_DEVICEID), 1, DME_PEER },
+		{ UIC_ARG_MIB(N_DEVICEID_VALID), 1, DME_PEER },
+		{ UIC_ARG_MIB(T_PEERDEVICEID), 1, DME_PEER },
+		{ UIC_ARG_MIB(T_PEERCPORTID), 0, DME_PEER },
+		{ UIC_ARG_MIB(T_TRAFFICCLASS), 0, DME_PEER },
+		{ UIC_ARG_MIB(T_CPORTFLAGS), 0x6, DME_PEER },
+		{ UIC_ARG_MIB(T_CPORTMODE), 1, DME_PEER },
+		{ UIC_ARG_MIB(T_CONNECTIONSTATE), 1, DME_PEER }
+	};
+
+	return ufshcd_dwc_dme_set_attrs(hba, setup_attrs, ARRAY_SIZE(setup_attrs));
+}
+
+/**
+ * ufshcd_dwc_link_startup_notify()
+ * UFS Host DWC specific link startup sequence
+ * @hba: private structure poitner
+ * @status: Callback notify status
+ *
+ * Returns 0 on success, non-zero value on failure
+ */
+int ufshcd_dwc_link_startup_notify(struct ufs_hba *hba,
+					enum ufs_notify_change_status status)
+{
+	int err = 0;
+
+	if (status == PRE_CHANGE) {
+		ufshcd_dwc_program_clk_div(hba, DWC_UFS_REG_HCLKDIV_DIV_125);
+
+		if (hba->vops->phy_initialization) {
+			err = hba->vops->phy_initialization(hba);
+			if (err) {
+				dev_err(hba->dev, "Phy setup failed (%d)\n",
+									err);
+				goto out;
+			}
+		}
+	} else { /* POST_CHANGE */
+		err = ufshcd_dwc_link_is_up(hba);
+		if (err) {
+			dev_err(hba->dev, "Link is not up\n");
+			goto out;
+		}
+
+		err = ufshcd_dwc_connection_setup(hba);
+		if (err)
+			dev_err(hba->dev, "Connection setup failed (%d)\n",
+									err);
+	}
+
+out:
+	return err;
+}
+EXPORT_SYMBOL(ufshcd_dwc_link_startup_notify);
diff --git a/drivers/scsi/ufs/ufshcd-dwc.h b/drivers/scsi/ufs/ufshcd-dwc.h
new file mode 100644
index 0000000..c8be295
--- /dev/null
+++ b/drivers/scsi/ufs/ufshcd-dwc.h
@@ -0,0 +1,26 @@
+/*
+ * UFS Host driver for Synopsys Designware Core
+ *
+ * Copyright (C) 2015-2016 Synopsys, Inc. (www.synopsys.com)
+ *
+ * Authors: Joao Pinto <jpinto@synopsys.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef _UFSHCD_DWC_H
+#define _UFSHCD_DWC_H
+
+struct ufshcd_dme_attr_val {
+	u32 attr_sel;
+	u32 mib_val;
+	u8 peer;
+};
+
+int ufshcd_dwc_link_startup_notify(struct ufs_hba *hba,
+					enum ufs_notify_change_status status);
+int ufshcd_dwc_dme_set_attrs(struct ufs_hba *hba,
+				const struct ufshcd_dme_attr_val *v, int n);
+#endif /* End of Header */
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index e3931d0..c780d14 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -263,6 +263,7 @@ struct ufs_pwr_mode_info {
  * @suspend: called during host controller PM callback
  * @resume: called during host controller PM callback
  * @dbg_register_dump: used to dump controller debug information
+ * @phy_initialization: used to initialize phys
  */
 struct ufs_hba_variant_ops {
 	const char *name;
@@ -284,6 +285,7 @@ struct ufs_hba_variant_ops {
 	int     (*suspend)(struct ufs_hba *, enum ufs_pm_op);
 	int     (*resume)(struct ufs_hba *, enum ufs_pm_op);
 	void	(*dbg_register_dump)(struct ufs_hba *hba);
+	int	(*phy_initialization)(struct ufs_hba *);
 };
 
 /* clock gating state  */
@@ -555,11 +557,16 @@ static inline bool ufshcd_can_autobkops_during_suspend(struct ufs_hba *hba)
 
 static inline bool ufshcd_is_intr_aggr_allowed(struct ufs_hba *hba)
 {
+/* DWC UFS Core has the Interrupt aggregation feature but is not detectable*/
+#ifndef CONFIG_SCSI_UFS_DWC
 	if ((hba->caps & UFSHCD_CAP_INTR_AGGR) &&
 	    !(hba->quirks & UFSHCD_QUIRK_BROKEN_INTR_AGGR))
 		return true;
 	else
 		return false;
+#else
+return true;
+#endif
 }
 
 #define ufshcd_writel(hba, val, reg)	\
diff --git a/drivers/scsi/ufs/ufshci-dwc.h b/drivers/scsi/ufs/ufshci-dwc.h
new file mode 100644
index 0000000..ca341fe
--- /dev/null
+++ b/drivers/scsi/ufs/ufshci-dwc.h
@@ -0,0 +1,36 @@
+/*
+ * UFS Host driver for Synopsys Designware Core
+ *
+ * Copyright (C) 2015-2016 Synopsys, Inc. (www.synopsys.com)
+ *
+ * Authors: Joao Pinto <jpinto@synopsys.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef _UFSHCI_DWC_H
+#define _UFSHCI_DWC_H
+
+/* DWC HC UFSHCI specific Registers */
+enum dwc_specific_registers {
+	DWC_UFS_REG_HCLKDIV	= 0xFC,
+};
+
+/* Clock Divider Values: Hex equivalent of frequency in MHz */
+enum clk_div_values {
+	DWC_UFS_REG_HCLKDIV_DIV_62_5	= 0x3e,
+	DWC_UFS_REG_HCLKDIV_DIV_125	= 0x7d,
+	DWC_UFS_REG_HCLKDIV_DIV_200	= 0xc8,
+};
+
+/* Selector Index */
+enum selector_index {
+	SELIND_LN0_TX		= 0x00,
+	SELIND_LN1_TX		= 0x01,
+	SELIND_LN0_RX		= 0x04,
+	SELIND_LN1_RX		= 0x05,
+};
+
+#endif /* End of Header */
-- 
1.8.1.5
