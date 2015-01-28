From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH v2 1/2] ata: ahci_platform: fix owner module reference mismatch for scsi host
Date: Thu, 29 Jan 2015 08:30:29 +0900
Message-ID: <1422487830-5366-1-git-send-email-akinobu.mita@gmail.com>
Return-path: <linux-ide-owner@vger.kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: linux-ide@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, Hans de Goede <hdegoede@redhat.com>, Tejun Heo <tj@kernel.org>, Christoph Hellwig <hch@lst.de>, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

The owner module reference of the ahci platform's scsi_host is
initialized to libahci_platform's one, because these drivers use a
scsi_host_template defined in libahci_platform.  So these drivers can
be unloaded even if the scsi device is being accessed.

This fixes it by pushing the scsi_host_template from libahci_platform
to all leaf drivers.  The scsi_host_template is passed through a new
argument of ahci_platform_init_host().

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Hans de Goede <hdegoede@redhat.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-ide@vger.kernel.org
Cc: linux-scsi@vger.kernel.org
---
* Changes in v2
- use the specific platform driver name for each sht
- add comments on top of ATA_BASE_SHT and AHCI_SHT

 drivers/ata/ahci.h             |  4 ++++
 drivers/ata/ahci_da850.c       | 11 +++++++++--
 drivers/ata/ahci_imx.c         | 11 +++++++++--
 drivers/ata/ahci_mvebu.c       | 11 +++++++++--
 drivers/ata/ahci_platform.c    | 11 +++++++++--
 drivers/ata/ahci_st.c          | 11 +++++++++--
 drivers/ata/ahci_sunxi.c       | 11 +++++++++--
 drivers/ata/ahci_tegra.c       | 11 +++++++++--
 drivers/ata/ahci_xgene.c       | 11 +++++++++--
 drivers/ata/libahci_platform.c | 10 ++++------
 include/linux/ahci_platform.h  |  4 +++-
 include/linux/libata.h         |  6 ++++++
 12 files changed, 89 insertions(+), 23 deletions(-)

diff --git a/drivers/ata/ahci.h b/drivers/ata/ahci.h
index 40f0e34..c2d0b06 100644
--- a/drivers/ata/ahci.h
+++ b/drivers/ata/ahci.h
@@ -354,6 +354,10 @@ extern int ahci_ignore_sss;
 extern struct device_attribute *ahci_shost_attrs[];
 extern struct device_attribute *ahci_sdev_attrs[];
 
+/*
+ * This must be instantiated by the edge drivers.  Read the comments
+ * for ATA_BASE_SHT
+ */
 #define AHCI_SHT(drv_name)						\
 	ATA_NCQ_SHT(drv_name),						\
 	.can_queue		= AHCI_MAX_CMDS - 1,			\
diff --git a/drivers/ata/ahci_da850.c b/drivers/ata/ahci_da850.c
index ce8a7a6..267a3d3 100644
--- a/drivers/ata/ahci_da850.c
+++ b/drivers/ata/ahci_da850.c
@@ -16,6 +16,8 @@
 #include <linux/ahci_platform.h>
 #include "ahci.h"
 
+#define DRV_NAME "ahci_da850"
+
 /* SATA PHY Control Register offset from AHCI base */
 #define SATA_P0PHYCR_REG	0x178
 
@@ -59,6 +61,10 @@ static const struct ata_port_info ahci_da850_port_info = {
 	.port_ops	= &ahci_platform_ops,
 };
 
+static struct scsi_host_template ahci_platform_sht = {
+	AHCI_SHT(DRV_NAME),
+};
+
 static int ahci_da850_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
@@ -85,7 +91,8 @@ static int ahci_da850_probe(struct platform_device *pdev)
 
 	da850_sata_init(dev, pwrdn_reg, hpriv->mmio);
 
-	rc = ahci_platform_init_host(pdev, hpriv, &ahci_da850_port_info);
+	rc = ahci_platform_init_host(pdev, hpriv, &ahci_da850_port_info,
+				     &ahci_platform_sht);
 	if (rc)
 		goto disable_resources;
 
@@ -102,7 +109,7 @@ static struct platform_driver ahci_da850_driver = {
 	.probe = ahci_da850_probe,
 	.remove = ata_platform_remove_one,
 	.driver = {
-		.name = "ahci_da850",
+		.name = DRV_NAME,
 		.pm = &ahci_da850_pm_ops,
 	},
 };
diff --git a/drivers/ata/ahci_imx.c b/drivers/ata/ahci_imx.c
index 35d51c5..bd870ec 100644
--- a/drivers/ata/ahci_imx.c
+++ b/drivers/ata/ahci_imx.c
@@ -28,6 +28,8 @@
 #include <linux/libata.h>
 #include "ahci.h"
 
+#define DRV_NAME "ahci-imx"
+
 enum {
 	/* Timer 1-ms Register */
 	IMX_TIMER1MS				= 0x00e0,
@@ -524,6 +526,10 @@ static u32 imx_ahci_parse_props(struct device *dev,
 	return reg_value;
 }
 
+static struct scsi_host_template ahci_platform_sht = {
+	AHCI_SHT(DRV_NAME),
+};
+
 static int imx_ahci_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
@@ -620,7 +626,8 @@ static int imx_ahci_probe(struct platform_device *pdev)
 	reg_val = clk_get_rate(imxpriv->ahb_clk) / 1000;
 	writel(reg_val, hpriv->mmio + IMX_TIMER1MS);
 
-	ret = ahci_platform_init_host(pdev, hpriv, &ahci_imx_port_info);
+	ret = ahci_platform_init_host(pdev, hpriv, &ahci_imx_port_info,
+				      &ahci_platform_sht);
 	if (ret)
 		goto disable_sata;
 
@@ -678,7 +685,7 @@ static struct platform_driver imx_ahci_driver = {
 	.probe = imx_ahci_probe,
 	.remove = ata_platform_remove_one,
 	.driver = {
-		.name = "ahci-imx",
+		.name = DRV_NAME,
 		.of_match_table = imx_ahci_of_match,
 		.pm = &ahci_imx_pm_ops,
 	},
diff --git a/drivers/ata/ahci_mvebu.c b/drivers/ata/ahci_mvebu.c
index 64bb084..23716dd 100644
--- a/drivers/ata/ahci_mvebu.c
+++ b/drivers/ata/ahci_mvebu.c
@@ -19,6 +19,8 @@
 #include <linux/platform_device.h>
 #include "ahci.h"
 
+#define DRV_NAME "ahci-mvebu"
+
 #define AHCI_VENDOR_SPECIFIC_0_ADDR  0xa0
 #define AHCI_VENDOR_SPECIFIC_0_DATA  0xa4
 
@@ -67,6 +69,10 @@ static const struct ata_port_info ahci_mvebu_port_info = {
 	.port_ops  = &ahci_platform_ops,
 };
 
+static struct scsi_host_template ahci_platform_sht = {
+	AHCI_SHT(DRV_NAME),
+};
+
 static int ahci_mvebu_probe(struct platform_device *pdev)
 {
 	struct ahci_host_priv *hpriv;
@@ -88,7 +94,8 @@ static int ahci_mvebu_probe(struct platform_device *pdev)
 	ahci_mvebu_mbus_config(hpriv, dram);
 	ahci_mvebu_regret_option(hpriv);
 
-	rc = ahci_platform_init_host(pdev, hpriv, &ahci_mvebu_port_info);
+	rc = ahci_platform_init_host(pdev, hpriv, &ahci_mvebu_port_info,
+				     &ahci_platform_sht);
 	if (rc)
 		goto disable_resources;
 
@@ -114,7 +121,7 @@ static struct platform_driver ahci_mvebu_driver = {
 	.probe = ahci_mvebu_probe,
 	.remove = ata_platform_remove_one,
 	.driver = {
-		.name = "ahci-mvebu",
+		.name = DRV_NAME,
 		.of_match_table = ahci_mvebu_of_match,
 	},
 };
diff --git a/drivers/ata/ahci_platform.c b/drivers/ata/ahci_platform.c
index 18d5398..78d6ae0 100644
--- a/drivers/ata/ahci_platform.c
+++ b/drivers/ata/ahci_platform.c
@@ -22,6 +22,8 @@
 #include <linux/ahci_platform.h>
 #include "ahci.h"
 
+#define DRV_NAME "ahci"
+
 static const struct ata_port_info ahci_port_info = {
 	.flags		= AHCI_FLAG_COMMON,
 	.pio_mask	= ATA_PIO4,
@@ -29,6 +31,10 @@ static const struct ata_port_info ahci_port_info = {
 	.port_ops	= &ahci_platform_ops,
 };
 
+static struct scsi_host_template ahci_platform_sht = {
+	AHCI_SHT(DRV_NAME),
+};
+
 static int ahci_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
@@ -46,7 +52,8 @@ static int ahci_probe(struct platform_device *pdev)
 	if (of_device_is_compatible(dev->of_node, "hisilicon,hisi-ahci"))
 		hpriv->flags |= AHCI_HFLAG_NO_FBS | AHCI_HFLAG_NO_NCQ;
 
-	rc = ahci_platform_init_host(pdev, hpriv, &ahci_port_info);
+	rc = ahci_platform_init_host(pdev, hpriv, &ahci_port_info,
+				     &ahci_platform_sht);
 	if (rc)
 		goto disable_resources;
 
@@ -75,7 +82,7 @@ static struct platform_driver ahci_driver = {
 	.probe = ahci_probe,
 	.remove = ata_platform_remove_one,
 	.driver = {
-		.name = "ahci",
+		.name = DRV_NAME,
 		.of_match_table = ahci_of_match,
 		.pm = &ahci_pm_ops,
 	},
diff --git a/drivers/ata/ahci_st.c b/drivers/ata/ahci_st.c
index 2f9e831..bc971af 100644
--- a/drivers/ata/ahci_st.c
+++ b/drivers/ata/ahci_st.c
@@ -23,6 +23,8 @@
 
 #include "ahci.h"
 
+#define DRV_NAME  "st_ahci"
+
 #define ST_AHCI_OOBR			0xbc
 #define ST_AHCI_OOBR_WE			BIT(31)
 #define ST_AHCI_OOBR_CWMIN_SHIFT	24
@@ -140,6 +142,10 @@ static const struct ata_port_info st_ahci_port_info = {
 	.port_ops       = &st_ahci_port_ops,
 };
 
+static struct scsi_host_template ahci_platform_sht = {
+	AHCI_SHT(DRV_NAME),
+};
+
 static int st_ahci_probe(struct platform_device *pdev)
 {
 	struct st_ahci_drv_data *drv_data;
@@ -166,7 +172,8 @@ static int st_ahci_probe(struct platform_device *pdev)
 	if (err)
 		return err;
 
-	err = ahci_platform_init_host(pdev, hpriv, &st_ahci_port_info);
+	err = ahci_platform_init_host(pdev, hpriv, &st_ahci_port_info,
+				      &ahci_platform_sht);
 	if (err) {
 		ahci_platform_disable_resources(hpriv);
 		return err;
@@ -229,7 +236,7 @@ MODULE_DEVICE_TABLE(of, st_ahci_match);
 
 static struct platform_driver st_ahci_driver = {
 	.driver = {
-		.name = "st_ahci",
+		.name = DRV_NAME,
 		.pm = &st_ahci_pm_ops,
 		.of_match_table = of_match_ptr(st_ahci_match),
 	},
diff --git a/drivers/ata/ahci_sunxi.c b/drivers/ata/ahci_sunxi.c
index e2e0da5..b264374 100644
--- a/drivers/ata/ahci_sunxi.c
+++ b/drivers/ata/ahci_sunxi.c
@@ -27,6 +27,8 @@
 #include <linux/regulator/consumer.h>
 #include "ahci.h"
 
+#define DRV_NAME "ahci-sunxi"
+
 /* Insmod parameters */
 static bool enable_pmp;
 module_param(enable_pmp, bool, 0);
@@ -169,6 +171,10 @@ static const struct ata_port_info ahci_sunxi_port_info = {
 	.port_ops	= &ahci_platform_ops,
 };
 
+static struct scsi_host_template ahci_platform_sht = {
+	AHCI_SHT(DRV_NAME),
+};
+
 static int ahci_sunxi_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
@@ -200,7 +206,8 @@ static int ahci_sunxi_probe(struct platform_device *pdev)
 	if (!enable_pmp)
 		hpriv->flags |= AHCI_HFLAG_NO_PMP;
 
-	rc = ahci_platform_init_host(pdev, hpriv, &ahci_sunxi_port_info);
+	rc = ahci_platform_init_host(pdev, hpriv, &ahci_sunxi_port_info,
+				     &ahci_platform_sht);
 	if (rc)
 		goto disable_resources;
 
@@ -251,7 +258,7 @@ static struct platform_driver ahci_sunxi_driver = {
 	.probe = ahci_sunxi_probe,
 	.remove = ata_platform_remove_one,
 	.driver = {
-		.name = "ahci-sunxi",
+		.name = DRV_NAME,
 		.of_match_table = ahci_sunxi_of_match,
 		.pm = &ahci_sunxi_pm_ops,
 	},
diff --git a/drivers/ata/ahci_tegra.c b/drivers/ata/ahci_tegra.c
index 0329044..3a62eb2 100644
--- a/drivers/ata/ahci_tegra.c
+++ b/drivers/ata/ahci_tegra.c
@@ -31,6 +31,8 @@
 
 #include "ahci.h"
 
+#define DRV_NAME "tegra-ahci"
+
 #define SATA_CONFIGURATION_0				0x180
 #define SATA_CONFIGURATION_EN_FPCI			BIT(0)
 
@@ -289,6 +291,10 @@ static const struct of_device_id tegra_ahci_of_match[] = {
 };
 MODULE_DEVICE_TABLE(of, tegra_ahci_of_match);
 
+static struct scsi_host_template ahci_platform_sht = {
+	AHCI_SHT(DRV_NAME),
+};
+
 static int tegra_ahci_probe(struct platform_device *pdev)
 {
 	struct ahci_host_priv *hpriv;
@@ -354,7 +360,8 @@ static int tegra_ahci_probe(struct platform_device *pdev)
 	if (ret)
 		return ret;
 
-	ret = ahci_platform_init_host(pdev, hpriv, &ahci_tegra_port_info);
+	ret = ahci_platform_init_host(pdev, hpriv, &ahci_tegra_port_info,
+				      &ahci_platform_sht);
 	if (ret)
 		goto deinit_controller;
 
@@ -370,7 +377,7 @@ static struct platform_driver tegra_ahci_driver = {
 	.probe = tegra_ahci_probe,
 	.remove = ata_platform_remove_one,
 	.driver = {
-		.name = "tegra-ahci",
+		.name = DRV_NAME,
 		.of_match_table = tegra_ahci_of_match,
 	},
 	/* LP0 suspend support not implemented */
diff --git a/drivers/ata/ahci_xgene.c b/drivers/ata/ahci_xgene.c
index cbcd208..1478449 100644
--- a/drivers/ata/ahci_xgene.c
+++ b/drivers/ata/ahci_xgene.c
@@ -30,6 +30,8 @@
 #include <linux/phy/phy.h>
 #include "ahci.h"
 
+#define DRV_NAME "xgene-ahci"
+
 /* Max # of disk per a controller */
 #define MAX_AHCI_CHN_PERCTR		2
 
@@ -446,6 +448,10 @@ static int xgene_ahci_mux_select(struct xgene_ahci_context *ctx)
 	return val & CFG_SATA_ENET_SELECT_MASK ? -1 : 0;
 }
 
+static struct scsi_host_template ahci_platform_sht = {
+	AHCI_SHT(DRV_NAME),
+};
+
 static int xgene_ahci_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
@@ -523,7 +529,8 @@ static int xgene_ahci_probe(struct platform_device *pdev)
 skip_clk_phy:
 	hpriv->flags = AHCI_HFLAG_NO_PMP | AHCI_HFLAG_NO_NCQ;
 
-	rc = ahci_platform_init_host(pdev, hpriv, &xgene_ahci_port_info);
+	rc = ahci_platform_init_host(pdev, hpriv, &xgene_ahci_port_info,
+				     &ahci_platform_sht);
 	if (rc)
 		goto disable_resources;
 
@@ -545,7 +552,7 @@ static struct platform_driver xgene_ahci_driver = {
 	.probe = xgene_ahci_probe,
 	.remove = ata_platform_remove_one,
 	.driver = {
-		.name = "xgene-ahci",
+		.name = DRV_NAME,
 		.of_match_table = xgene_ahci_of_match,
 	},
 };
diff --git a/drivers/ata/libahci_platform.c b/drivers/ata/libahci_platform.c
index 0b03f90..3db4168 100644
--- a/drivers/ata/libahci_platform.c
+++ b/drivers/ata/libahci_platform.c
@@ -34,10 +34,6 @@ struct ata_port_operations ahci_platform_ops = {
 };
 EXPORT_SYMBOL_GPL(ahci_platform_ops);
 
-static struct scsi_host_template ahci_platform_sht = {
-	AHCI_SHT("ahci_platform"),
-};
-
 /**
  * ahci_platform_enable_phys - Enable PHYs
  * @hpriv: host private area to store config values
@@ -399,6 +395,7 @@ EXPORT_SYMBOL_GPL(ahci_platform_get_resources);
  * @pdev: platform device pointer for the host
  * @hpriv: ahci-host private data for the host
  * @pi_template: template for the ata_port_info to use
+ * @sht: scsi_host_template to use when registering
  *
  * This function does all the usual steps needed to bring up an
  * ahci-platform host, note any necessary resources (ie clks, phys, etc.)
@@ -409,7 +406,8 @@ EXPORT_SYMBOL_GPL(ahci_platform_get_resources);
  */
 int ahci_platform_init_host(struct platform_device *pdev,
 			    struct ahci_host_priv *hpriv,
-			    const struct ata_port_info *pi_template)
+			    const struct ata_port_info *pi_template,
+			    struct scsi_host_template *sht)
 {
 	struct device *dev = &pdev->dev;
 	struct ata_port_info pi = *pi_template;
@@ -493,7 +491,7 @@ int ahci_platform_init_host(struct platform_device *pdev,
 	ahci_init_controller(host);
 	ahci_print_info(host, "platform");
 
-	return ahci_host_activate(host, irq, &ahci_platform_sht);
+	return ahci_host_activate(host, irq, sht);
 }
 EXPORT_SYMBOL_GPL(ahci_platform_init_host);
 
diff --git a/include/linux/ahci_platform.h b/include/linux/ahci_platform.h
index 642d6ae..2e6673f 100644
--- a/include/linux/ahci_platform.h
+++ b/include/linux/ahci_platform.h
@@ -21,6 +21,7 @@ struct device;
 struct ata_port_info;
 struct ahci_host_priv;
 struct platform_device;
+struct scsi_host_template;
 
 int ahci_platform_enable_clks(struct ahci_host_priv *hpriv);
 void ahci_platform_disable_clks(struct ahci_host_priv *hpriv);
@@ -30,7 +31,8 @@ struct ahci_host_priv *ahci_platform_get_resources(
 	struct platform_device *pdev);
 int ahci_platform_init_host(struct platform_device *pdev,
 			    struct ahci_host_priv *hpriv,
-			    const struct ata_port_info *pi_template);
+			    const struct ata_port_info *pi_template,
+			    struct scsi_host_template *sht);
 
 int ahci_platform_suspend_host(struct device *dev);
 int ahci_platform_resume_host(struct device *dev);
diff --git a/include/linux/libata.h b/include/linux/libata.h
index 91f705d..61df823 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -1340,6 +1340,12 @@ extern const struct ata_port_operations ata_base_port_ops;
 extern const struct ata_port_operations sata_port_ops;
 extern struct device_attribute *ata_common_sdev_attrs[];
 
+/*
+ * All sht initializers (BASE, PIO, BMDMA, NCQ) must be instantiated
+ * by the edge drivers.  Because the 'module' field of sht must be the
+ * edge driver's module reference, otherwise the driver can be unloaded
+ * even if the scsi_device is being accessed.
+ */
 #define ATA_BASE_SHT(drv_name)					\
 	.module			= THIS_MODULE,			\
 	.name			= drv_name,			\
-- 
1.9.1

