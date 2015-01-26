From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH 1/2] ata: ahci_platform: fix owner module reference mismatch for scsi host
Date: Tue, 27 Jan 2015 08:34:58 +0900
Message-ID: <1422315299-4614-1-git-send-email-akinobu.mita@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f48.google.com ([209.85.220.48]:56265 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753326AbbAZXfO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 26 Jan 2015 18:35:14 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-ide@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, Hans de Goede <hdegoede@redhat.com>, Tejun Heo <tj@kernel.org>, Christoph Hellwig <hch@lst.de>, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org

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
 drivers/ata/ahci_da850.c       |  7 ++++++-
 drivers/ata/ahci_imx.c         |  7 ++++++-
 drivers/ata/ahci_mvebu.c       |  7 ++++++-
 drivers/ata/ahci_platform.c    |  7 ++++++-
 drivers/ata/ahci_st.c          |  7 ++++++-
 drivers/ata/ahci_sunxi.c       |  7 ++++++-
 drivers/ata/ahci_tegra.c       |  7 ++++++-
 drivers/ata/ahci_xgene.c       |  7 ++++++-
 drivers/ata/libahci_platform.c | 10 ++++------
 include/linux/ahci_platform.h  |  4 +++-
 10 files changed, 55 insertions(+), 15 deletions(-)

diff --git a/drivers/ata/ahci_da850.c b/drivers/ata/ahci_da850.c
index ce8a7a6..26566d0a 100644
--- a/drivers/ata/ahci_da850.c
+++ b/drivers/ata/ahci_da850.c
@@ -59,6 +59,10 @@ static const struct ata_port_info ahci_da850_port_info = {
 	.port_ops	= &ahci_platform_ops,
 };
 
+static struct scsi_host_template ahci_platform_sht = {
+	AHCI_SHT("ahci_platform"),
+};
+
 static int ahci_da850_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
@@ -85,7 +89,8 @@ static int ahci_da850_probe(struct platform_device *pdev)
 
 	da850_sata_init(dev, pwrdn_reg, hpriv->mmio);
 
-	rc = ahci_platform_init_host(pdev, hpriv, &ahci_da850_port_info);
+	rc = ahci_platform_init_host(pdev, hpriv, &ahci_da850_port_info,
+				     &ahci_platform_sht);
 	if (rc)
 		goto disable_resources;
 
diff --git a/drivers/ata/ahci_imx.c b/drivers/ata/ahci_imx.c
index 35d51c5..3916c3a 100644
--- a/drivers/ata/ahci_imx.c
+++ b/drivers/ata/ahci_imx.c
@@ -524,6 +524,10 @@ static u32 imx_ahci_parse_props(struct device *dev,
 	return reg_value;
 }
 
+static struct scsi_host_template ahci_platform_sht = {
+	AHCI_SHT("ahci_platform"),
+};
+
 static int imx_ahci_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
@@ -620,7 +624,8 @@ static int imx_ahci_probe(struct platform_device *pdev)
 	reg_val = clk_get_rate(imxpriv->ahb_clk) / 1000;
 	writel(reg_val, hpriv->mmio + IMX_TIMER1MS);
 
-	ret = ahci_platform_init_host(pdev, hpriv, &ahci_imx_port_info);
+	ret = ahci_platform_init_host(pdev, hpriv, &ahci_imx_port_info,
+				      &ahci_platform_sht);
 	if (ret)
 		goto disable_sata;
 
diff --git a/drivers/ata/ahci_mvebu.c b/drivers/ata/ahci_mvebu.c
index 64bb084..af383cb 100644
--- a/drivers/ata/ahci_mvebu.c
+++ b/drivers/ata/ahci_mvebu.c
@@ -67,6 +67,10 @@ static const struct ata_port_info ahci_mvebu_port_info = {
 	.port_ops  = &ahci_platform_ops,
 };
 
+static struct scsi_host_template ahci_platform_sht = {
+	AHCI_SHT("ahci_platform"),
+};
+
 static int ahci_mvebu_probe(struct platform_device *pdev)
 {
 	struct ahci_host_priv *hpriv;
@@ -88,7 +92,8 @@ static int ahci_mvebu_probe(struct platform_device *pdev)
 	ahci_mvebu_mbus_config(hpriv, dram);
 	ahci_mvebu_regret_option(hpriv);
 
-	rc = ahci_platform_init_host(pdev, hpriv, &ahci_mvebu_port_info);
+	rc = ahci_platform_init_host(pdev, hpriv, &ahci_mvebu_port_info,
+				     &ahci_platform_sht);
 	if (rc)
 		goto disable_resources;
 
diff --git a/drivers/ata/ahci_platform.c b/drivers/ata/ahci_platform.c
index 18d5398..6e63cbf 100644
--- a/drivers/ata/ahci_platform.c
+++ b/drivers/ata/ahci_platform.c
@@ -29,6 +29,10 @@ static const struct ata_port_info ahci_port_info = {
 	.port_ops	= &ahci_platform_ops,
 };
 
+static struct scsi_host_template ahci_platform_sht = {
+	AHCI_SHT("ahci_platform"),
+};
+
 static int ahci_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
@@ -46,7 +50,8 @@ static int ahci_probe(struct platform_device *pdev)
 	if (of_device_is_compatible(dev->of_node, "hisilicon,hisi-ahci"))
 		hpriv->flags |= AHCI_HFLAG_NO_FBS | AHCI_HFLAG_NO_NCQ;
 
-	rc = ahci_platform_init_host(pdev, hpriv, &ahci_port_info);
+	rc = ahci_platform_init_host(pdev, hpriv, &ahci_port_info,
+				     &ahci_platform_sht);
 	if (rc)
 		goto disable_resources;
 
diff --git a/drivers/ata/ahci_st.c b/drivers/ata/ahci_st.c
index 2f9e831..291bcb6 100644
--- a/drivers/ata/ahci_st.c
+++ b/drivers/ata/ahci_st.c
@@ -140,6 +140,10 @@ static const struct ata_port_info st_ahci_port_info = {
 	.port_ops       = &st_ahci_port_ops,
 };
 
+static struct scsi_host_template ahci_platform_sht = {
+	AHCI_SHT("ahci_platform"),
+};
+
 static int st_ahci_probe(struct platform_device *pdev)
 {
 	struct st_ahci_drv_data *drv_data;
@@ -166,7 +170,8 @@ static int st_ahci_probe(struct platform_device *pdev)
 	if (err)
 		return err;
 
-	err = ahci_platform_init_host(pdev, hpriv, &st_ahci_port_info);
+	err = ahci_platform_init_host(pdev, hpriv, &st_ahci_port_info,
+				      &ahci_platform_sht);
 	if (err) {
 		ahci_platform_disable_resources(hpriv);
 		return err;
diff --git a/drivers/ata/ahci_sunxi.c b/drivers/ata/ahci_sunxi.c
index e2e0da5..ca15430 100644
--- a/drivers/ata/ahci_sunxi.c
+++ b/drivers/ata/ahci_sunxi.c
@@ -169,6 +169,10 @@ static const struct ata_port_info ahci_sunxi_port_info = {
 	.port_ops	= &ahci_platform_ops,
 };
 
+static struct scsi_host_template ahci_platform_sht = {
+	AHCI_SHT("ahci_platform"),
+};
+
 static int ahci_sunxi_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
@@ -200,7 +204,8 @@ static int ahci_sunxi_probe(struct platform_device *pdev)
 	if (!enable_pmp)
 		hpriv->flags |= AHCI_HFLAG_NO_PMP;
 
-	rc = ahci_platform_init_host(pdev, hpriv, &ahci_sunxi_port_info);
+	rc = ahci_platform_init_host(pdev, hpriv, &ahci_sunxi_port_info,
+				     &ahci_platform_sht);
 	if (rc)
 		goto disable_resources;
 
diff --git a/drivers/ata/ahci_tegra.c b/drivers/ata/ahci_tegra.c
index 0329044..7f602bd 100644
--- a/drivers/ata/ahci_tegra.c
+++ b/drivers/ata/ahci_tegra.c
@@ -289,6 +289,10 @@ static const struct of_device_id tegra_ahci_of_match[] = {
 };
 MODULE_DEVICE_TABLE(of, tegra_ahci_of_match);
 
+static struct scsi_host_template ahci_platform_sht = {
+	AHCI_SHT("ahci_platform"),
+};
+
 static int tegra_ahci_probe(struct platform_device *pdev)
 {
 	struct ahci_host_priv *hpriv;
@@ -354,7 +358,8 @@ static int tegra_ahci_probe(struct platform_device *pdev)
 	if (ret)
 		return ret;
 
-	ret = ahci_platform_init_host(pdev, hpriv, &ahci_tegra_port_info);
+	ret = ahci_platform_init_host(pdev, hpriv, &ahci_tegra_port_info,
+				      &ahci_platform_sht);
 	if (ret)
 		goto deinit_controller;
 
diff --git a/drivers/ata/ahci_xgene.c b/drivers/ata/ahci_xgene.c
index cbcd208..069d383 100644
--- a/drivers/ata/ahci_xgene.c
+++ b/drivers/ata/ahci_xgene.c
@@ -446,6 +446,10 @@ static int xgene_ahci_mux_select(struct xgene_ahci_context *ctx)
 	return val & CFG_SATA_ENET_SELECT_MASK ? -1 : 0;
 }
 
+static struct scsi_host_template ahci_platform_sht = {
+	AHCI_SHT("ahci_platform"),
+};
+
 static int xgene_ahci_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
@@ -523,7 +527,8 @@ static int xgene_ahci_probe(struct platform_device *pdev)
 skip_clk_phy:
 	hpriv->flags = AHCI_HFLAG_NO_PMP | AHCI_HFLAG_NO_NCQ;
 
-	rc = ahci_platform_init_host(pdev, hpriv, &xgene_ahci_port_info);
+	rc = ahci_platform_init_host(pdev, hpriv, &xgene_ahci_port_info,
+				     &ahci_platform_sht);
 	if (rc)
 		goto disable_resources;
 
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
-- 
1.9.1

