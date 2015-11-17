From: John Garry <john.garry@huawei.com>
Subject: [PATCH v5 05/32] scsi: hisi_sas: scan device tree
Date: Wed, 18 Nov 2015 00:50:32 +0800
Message-ID: <1447779059-136143-6-git-send-email-john.garry@huawei.com>
References: <1447779059-136143-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from szxga01-in.huawei.com ([58.251.152.64]:37301 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754176AbbKQQgo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Nov 2015 11:36:44 -0500
In-Reply-To: <1447779059-136143-1-git-send-email-john.garry@huawei.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@odin.com, robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com, ijc+devicetree@hellion.org.uk, galak@codeaurora.org, arnd@arndb.de
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, devicetree@vger.kernel.org, linuxarm@huawei.com, john.garry2@mail.dcu.ie, hare@suse.de, xuwei5@hisilicon.com, zhangfei.gao@linaro.org, john.garry@huawei.com

Scan the device tree for all properties. Also
do this:
- do ioremap for SAS registers
- allocate memory for interrupt names

Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas.h      | 10 ++++++++
 drivers/scsi/hisi_sas/hisi_sas_main.c | 45 ++++++++++++++++++++++++++++++++++-
 2 files changed, 54 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas.h b/drivers/scsi/hisi_sas/hisi_sas.h
index 6f57fd1..87f4b61 100644
--- a/drivers/scsi/hisi_sas/hisi_sas.h
+++ b/drivers/scsi/hisi_sas/hisi_sas.h
@@ -28,6 +28,8 @@
 #define HISI_SAS_MAX_DEVICES HISI_SAS_MAX_ITCT_ENTRIES
 #define HISI_SAS_COMMAND_ENTRIES 8192
 
+#define HISI_SAS_NAME_LEN 32
+
 struct hisi_sas_phy {
 	struct asd_sas_phy	sas_phy;
 };
@@ -44,6 +46,11 @@ struct hisi_hba {
 	struct sas_ha_struct *p;
 
 	struct platform_device *pdev;
+	void __iomem *regs;
+	struct regmap *ctrl;
+	u32 ctrl_reset_reg;
+	u32 ctrl_reset_sts_reg;
+	u32 ctrl_clock_ena_reg;
 	u8 sas_addr[SAS_ADDR_SIZE];
 
 	int n_phy;
@@ -53,6 +60,9 @@ struct hisi_hba {
 	struct Scsi_Host *shost;
 	struct hisi_sas_phy phy[HISI_SAS_MAX_PHYS];
 	struct hisi_sas_port port[HISI_SAS_MAX_PHYS];
+
+	int	queue_count;
+	char	*int_names;
 	const struct hisi_sas_hw *hw;	/* Low level hw interface */
 };
 
diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 4fd000e..4fc5a6c 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -39,9 +39,13 @@ static struct sas_domain_function_template hisi_sas_transport_ops = {
 static struct Scsi_Host *hisi_sas_shost_alloc(struct platform_device *pdev,
 					      const struct hisi_sas_hw *hw)
 {
+	struct resource *res;
 	struct Scsi_Host *shost;
 	struct hisi_hba *hisi_hba;
 	struct device *dev = &pdev->dev;
+	struct device_node *np = pdev->dev.of_node;
+	struct property *sas_addr_prop;
+	int num;
 
 	shost = scsi_host_alloc(&hisi_sas_sht, sizeof(*hisi_hba));
 	if (!shost)
@@ -53,6 +57,46 @@ static struct Scsi_Host *hisi_sas_shost_alloc(struct platform_device *pdev,
 	hisi_hba->shost = shost;
 	SHOST_TO_SAS_HA(shost) = &hisi_hba->sha;
 
+	sas_addr_prop = of_find_property(np, "sas-addr", NULL);
+	if (!sas_addr_prop || (sas_addr_prop->length != SAS_ADDR_SIZE))
+		goto err_out;
+	memcpy(hisi_hba->sas_addr, sas_addr_prop->value, SAS_ADDR_SIZE);
+
+	if (of_property_read_u32(np, "ctrl-reset-reg",
+				 &hisi_hba->ctrl_reset_reg))
+		goto err_out;
+
+	if (of_property_read_u32(np, "ctrl-reset-sts-reg",
+				 &hisi_hba->ctrl_reset_sts_reg))
+		goto err_out;
+
+	if (of_property_read_u32(np, "ctrl-clock-ena-reg",
+				 &hisi_hba->ctrl_clock_ena_reg))
+		goto err_out;
+
+	if (of_property_read_u32(np, "phy-count", &hisi_hba->n_phy))
+		goto err_out;
+
+	if (of_property_read_u32(np, "queue-count", &hisi_hba->queue_count))
+		goto err_out;
+
+	num = of_irq_count(np);
+	hisi_hba->int_names = devm_kcalloc(dev, num,
+					   HISI_SAS_NAME_LEN,
+					   GFP_KERNEL);
+	if (!hisi_hba->int_names)
+		goto err_out;
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	hisi_hba->regs = devm_ioremap_resource(dev, res);
+	if (IS_ERR(hisi_hba->regs))
+		goto err_out;
+
+	hisi_hba->ctrl = syscon_regmap_lookup_by_phandle(
+				np, "hisilicon,sas-syscon");
+	if (IS_ERR(hisi_hba->ctrl))
+		goto err_out;
+
 	return shost;
 err_out:
 	dev_err(dev, "shost alloc failed\n");
@@ -79,7 +123,6 @@ int hisi_sas_probe(struct platform_device *pdev,
 	sha = SHOST_TO_SAS_HA(shost);
 	hisi_hba = shost_priv(shost);
 	platform_set_drvdata(pdev, sha);
-	hisi_hba->n_phy = HISI_SAS_MAX_PHYS;
 	phy_nr = port_nr = hisi_hba->n_phy;
 
 	arr_phy = devm_kcalloc(dev, phy_nr, sizeof(void *), GFP_KERNEL);
-- 
1.9.1

