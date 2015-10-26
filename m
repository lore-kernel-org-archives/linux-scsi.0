From: John Garry <john.garry-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 05/32] scsi: hisi_sas: scan device tree
Date: Mon, 26 Oct 2015 22:14:36 +0800
Message-ID: <1445868903-183817-6-git-send-email-john.garry@huawei.com>
References: <1445868903-183817-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1445868903-183817-1-git-send-email-john.garry-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: JBottomley-wo1vFcy6AUs@public.gmane.org, robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, pawel.moll-5wv7dgnIgG8@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org, galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org
Cc: linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linuxarm-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, john.garry2-s/0ZXS5h9803lw97EnAbAg@public.gmane.org, hare-l3A5Bk7waGM@public.gmane.org, xuwei5-C8/M+/jPZTeaMJb+Lgu22Q@public.gmane.org, zhangfei.gao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, John Garry <john.garry-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

Scan the device tree for all properties. Also
do this:
- do ioremap for SAS registers
- allocate memory for interrupt names

Signed-off-by: John Garry <john.garry-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 drivers/scsi/hisi_sas/hisi_sas.h      |  9 +++++++++
 drivers/scsi/hisi_sas/hisi_sas_main.c | 38 ++++++++++++++++++++++++++++++++++-
 2 files changed, 46 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas.h b/drivers/scsi/hisi_sas/hisi_sas.h
index 6f57fd1..ace4254 100644
--- a/drivers/scsi/hisi_sas/hisi_sas.h
+++ b/drivers/scsi/hisi_sas/hisi_sas.h
@@ -28,6 +28,9 @@
 #define HISI_SAS_MAX_DEVICES HISI_SAS_MAX_ITCT_ENTRIES
 #define HISI_SAS_COMMAND_ENTRIES 8192
 
+#define HISI_SAS_NAME_LEN 32
+#define HISI_SAS_CTRL_REG_CNT 5
+
 struct hisi_sas_phy {
 	struct asd_sas_phy	sas_phy;
 };
@@ -44,6 +47,9 @@ struct hisi_hba {
 	struct sas_ha_struct *p;
 
 	struct platform_device *pdev;
+	void __iomem *regs;
+	struct regmap *ctrl;
+	u32 ctrl_reg[HISI_SAS_CTRL_REG_CNT];
 	u8 sas_addr[SAS_ADDR_SIZE];
 
 	int n_phy;
@@ -53,6 +59,9 @@ struct hisi_hba {
 	struct Scsi_Host *shost;
 	struct hisi_sas_phy phy[HISI_SAS_MAX_PHYS];
 	struct hisi_sas_port port[HISI_SAS_MAX_PHYS];
+
+	int	queue_count;
+	char	*int_names;
 	const struct hisi_sas_hw *hw;	/* Low level hw interface */
 };
 
diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 7555307..91f6504 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -40,9 +40,13 @@ static struct sas_domain_function_template hisi_sas_transport_ops = {
 static struct Scsi_Host *hisi_sas_shost_alloc(struct platform_device *pdev,
 					      const struct hisi_sas_hw *hw)
 {
+	int num;
+	struct resource *res;
 	struct Scsi_Host *shost;
 	struct hisi_hba *hisi_hba;
 	struct device *dev = &pdev->dev;
+	struct device_node *np = pdev->dev.of_node;
+	struct property *sas_addr_prop;
 
 	shost = scsi_host_alloc(&hisi_sas_sht, sizeof(*hisi_hba));
 	if (!shost)
@@ -54,6 +58,39 @@ static struct Scsi_Host *hisi_sas_shost_alloc(struct platform_device *pdev,
 	hisi_hba->shost = shost;
 	SHOST_TO_SAS_HA(shost) = &hisi_hba->sha;
 
+	sas_addr_prop = of_find_property(np, "sas-addr", NULL);
+	if (!sas_addr_prop || (sas_addr_prop->length != SAS_ADDR_SIZE))
+		goto err_out;
+	memcpy(hisi_hba->sas_addr, sas_addr_prop->value, SAS_ADDR_SIZE);
+
+	if (of_property_read_u32_array(np, "ctrl-reg",
+				       (u32 *) &hisi_hba->ctrl_reg,
+				       HISI_SAS_CTRL_REG_CNT))
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
@@ -80,7 +117,6 @@ int hisi_sas_probe(struct platform_device *pdev,
 	sha = SHOST_TO_SAS_HA(shost);
 	hisi_hba = shost_priv(shost);
 	platform_set_drvdata(pdev, sha);
-	hisi_hba->n_phy = HISI_SAS_MAX_PHYS;
 	phy_nr = port_nr = hisi_hba->n_phy;
 
 	arr_phy = devm_kcalloc(dev, phy_nr, sizeof(void *), GFP_KERNEL);
-- 
1.9.1

--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
