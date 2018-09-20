From: Janek Kotas <jank@cadence.com>
Subject: [PATCH v4 2/2] scsi: ufs: Add UFS platform driver for Cadence UFS
Date: Thu, 20 Sep 2018 13:08:30 +0000
Message-ID: <C77CE2E3-F88A-4B1E-BECB-5D031E2930E3@global.cadence.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Language: en-US
Content-ID: <5EAC3CABE857BB4D9BB2A1286629A158@namprd07.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "robh+dt@kernel.org" <robh+dt@kernel.org>, "mark.rutland@arm.com" <mark.rutland@arm.com>, "vinholikatti@gmail.com" <vinholikatti@gmail.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

This patch adds a device tree platform driver for
Cadence UFS Host Controller.
It can be enabled with SCSI_UFS_CDNS_PLATFORM Kconfig option.

Signed-off-by: Jan Kotas <jank@cadence.com>
---
 drivers/scsi/ufs/Kconfig       |   8 +++
 drivers/scsi/ufs/Makefile      |   1 +
 drivers/scsi/ufs/cdns-pltfrm.c | 149 +++++++++++++++++++++++++++++++++++++=
++++
 3 files changed, 158 insertions(+)
 create mode 100644 drivers/scsi/ufs/cdns-pltfrm.c

diff --git a/drivers/scsi/ufs/Kconfig b/drivers/scsi/ufs/Kconfig
index e09fe6a..8f884c3 100644
--- a/drivers/scsi/ufs/Kconfig
+++ b/drivers/scsi/ufs/Kconfig
@@ -80,6 +80,14 @@ config SCSI_UFSHCD_PLATFORM
=20
 	  If unsure, say N.
=20
+config SCSI_UFS_CDNS_PLATFORM
+	tristate "Cadence UFS Controller platform driver"
+	depends on SCSI_UFSHCD_PLATFORM
+	help
+	This selects the Cadence specific additions to UFSHCD platform driver.
+
+	  If unsure, say N.
+
 config SCSI_UFS_DWC_TC_PLATFORM
 	tristate "DesignWare platform support using a G210 Test Chip"
 	depends on SCSI_UFSHCD_PLATFORM
diff --git a/drivers/scsi/ufs/Makefile b/drivers/scsi/ufs/Makefile
index 2c50f03..e17d14a 100644
--- a/drivers/scsi/ufs/Makefile
+++ b/drivers/scsi/ufs/Makefile
@@ -2,6 +2,7 @@
 # UFSHCD makefile
 obj-$(CONFIG_SCSI_UFS_DWC_TC_PCI) +=3D tc-dwc-g210-pci.o ufshcd-dwc.o tc-d=
wc-g210.o
 obj-$(CONFIG_SCSI_UFS_DWC_TC_PLATFORM) +=3D tc-dwc-g210-pltfrm.o ufshcd-dw=
c.o tc-dwc-g210.o
+obj-$(CONFIG_SCSI_UFS_CDNS_PLATFORM) +=3D cdns-pltfrm.o
 obj-$(CONFIG_SCSI_UFS_QCOM) +=3D ufs-qcom.o
 obj-$(CONFIG_SCSI_UFSHCD) +=3D ufshcd-core.o
 ufshcd-core-objs :=3D ufshcd.o ufs-sysfs.o
diff --git a/drivers/scsi/ufs/cdns-pltfrm.c b/drivers/scsi/ufs/cdns-pltfrm.=
c
new file mode 100644
index 0000000..8bcf863
--- /dev/null
+++ b/drivers/scsi/ufs/cdns-pltfrm.c
@@ -0,0 +1,149 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Platform UFS Host driver for Cadence controller
+ *
+ * Copyright (C) 2018 Cadence Design Systems, Inc.
+ *
+ * Authors:
+ *	Jan Kotas <jank@cadence.com>
+ *
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/of.h>
+#include <linux/time.h>
+
+#include "ufshcd-pltfrm.h"
+
+#define CDNS_UFS_REG_HCLKDIV 0xFC
+
+/**
+ * Sets HCLKDIV register value based on the core_clk
+ * @hba: host controller instance
+ *
+ * Return zero for success and non-zero for failure
+ */
+static int cdns_ufs_set_hclkdiv(struct ufs_hba *hba)
+{
+	struct ufs_clk_info *clki;
+	struct list_head *head =3D &hba->clk_list_head;
+	unsigned long core_clk_rate =3D 0;
+	u32 core_clk_div =3D 0;
+
+	if (list_empty(head))
+		return 0;
+
+	list_for_each_entry(clki, head, list) {
+		if (IS_ERR_OR_NULL(clki->clk))
+			continue;
+		if (!strcmp(clki->name, "core_clk"))
+			core_clk_rate =3D clk_get_rate(clki->clk);
+	}
+
+	if (!core_clk_rate) {
+		dev_err(hba->dev, "%s: unable to find core_clk rate\n",
+			__func__);
+		return -EINVAL;
+	}
+
+	core_clk_div =3D core_clk_rate / USEC_PER_SEC;
+
+	ufshcd_writel(hba, core_clk_div, CDNS_UFS_REG_HCLKDIV);
+	/**
+	 * Make sure the register was updated,
+	 * UniPro layer will not work with an incorrect value.
+	 */
+	mb();
+
+	return 0;
+}
+
+/**
+ * Sets clocks used by the controller
+ * @hba: host controller instance
+ * @on: if true, enable clocks, otherwise disable
+ * @status: notify stage (pre, post change)
+ *
+ * Return zero for success and non-zero for failure
+ */
+static int cdns_ufs_setup_clocks(struct ufs_hba *hba, bool on,
+				 enum ufs_notify_change_status status)
+{
+	if ((!on) || (status =3D=3D PRE_CHANGE))
+		return 0;
+
+	return cdns_ufs_set_hclkdiv(hba);
+}
+
+static struct ufs_hba_variant_ops cdns_pltfm_hba_vops =3D {
+	.name =3D "cdns-ufs-pltfm",
+	.setup_clocks =3D cdns_ufs_setup_clocks,
+};
+
+/**
+ * cdns_ufs_pltfrm_probe - probe routine of the driver
+ * @pdev: pointer to platform device handle
+ *
+ * Return zero for success and non-zero for failure
+ */
+static int cdns_ufs_pltfrm_probe(struct platform_device *pdev)
+{
+	int err;
+	struct device *dev =3D &pdev->dev;
+
+	/* Perform generic probe */
+	err =3D ufshcd_pltfrm_init(pdev, &cdns_pltfm_hba_vops);
+	if (err)
+		dev_err(dev, "ufshcd_pltfrm_init() failed %d\n", err);
+
+	return err;
+}
+
+/**
+ * cdns_ufs_pltfrm_remove - removes the ufs driver
+ * @pdev: pointer to platform device handle
+ *
+ * Always returns 0
+ */
+static int cdns_ufs_pltfrm_remove(struct platform_device *pdev)
+{
+	struct ufs_hba *hba =3D  platform_get_drvdata(pdev);
+
+	ufshcd_remove(hba);
+	return 0;
+}
+
+static const struct of_device_id cdns_ufs_of_match[] =3D {
+	{ .compatible =3D "cdns,ufshc" },
+	{},
+};
+
+MODULE_DEVICE_TABLE(of, cdns_ufs_of_match);
+
+static const struct dev_pm_ops cdns_ufs_dev_pm_ops =3D {
+	.suspend         =3D ufshcd_pltfrm_suspend,
+	.resume          =3D ufshcd_pltfrm_resume,
+	.runtime_suspend =3D ufshcd_pltfrm_runtime_suspend,
+	.runtime_resume  =3D ufshcd_pltfrm_runtime_resume,
+	.runtime_idle    =3D ufshcd_pltfrm_runtime_idle,
+};
+
+static struct platform_driver cdns_ufs_pltfrm_driver =3D {
+	.probe	=3D cdns_ufs_pltfrm_probe,
+	.remove	=3D cdns_ufs_pltfrm_remove,
+	.driver	=3D {
+		.name   =3D "cdns-ufshcd",
+		.owner  =3D THIS_MODULE,
+		.pm     =3D &cdns_ufs_dev_pm_ops,
+		.of_match_table =3D cdns_ufs_of_match,
+	},
+};
+
+module_platform_driver(cdns_ufs_pltfrm_driver);
+
+MODULE_AUTHOR("Jan Kotas <jank@cadence.com>");
+MODULE_DESCRIPTION("Cadence UFS host controller platform driver");
+MODULE_LICENSE("GPL v2");
+MODULE_VERSION(UFSHCD_DRIVER_VERSION);
--=20
1.9.0
