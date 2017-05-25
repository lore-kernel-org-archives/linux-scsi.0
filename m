From: John Garry <john.garry@huawei.com>
Subject: [PATCH v2 07/22] scsi: hisi_sas: create hisi_sas_get_fw_info()
Date: Thu, 25 May 2017 20:04:56 +0800
Message-ID: <1495713911-80476-8-git-send-email-john.garry@huawei.com>
References: <1495713911-80476-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1495713911-80476-1-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: john.garry2@mail.dcu.ie, linuxarm@huawei.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, arnd@arndb.de, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

Move the functionality to retrieve the fw info into
a dedicated device type-agnostic function,
hisi_sas_get_fw_info().

The reasoning is that this function will be required
for future pci-based platforms.

Also add some debug prints for failure.

Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas.h      |   1 +
 drivers/scsi/hisi_sas/hisi_sas_main.c | 103 ++++++++++++++++++++++------------
 2 files changed, 67 insertions(+), 37 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas.h b/drivers/scsi/hisi_sas/hisi_sas.h
index 18044b7..d029aba 100644
--- a/drivers/scsi/hisi_sas/hisi_sas.h
+++ b/drivers/scsi/hisi_sas/hisi_sas.h
@@ -364,6 +364,7 @@ struct hisi_sas_command_table_ssp {
 extern void hisi_sas_sata_done(struct sas_task *task,
 			    struct hisi_sas_slot *slot);
 extern int hisi_sas_get_ncq_tag(struct sas_task *task, u32 *tag);
+extern int hisi_sas_get_fw_info(struct hisi_hba *hisi_hba);
 extern int hisi_sas_probe(struct platform_device *pdev,
 			  const struct hisi_sas_hw *ops);
 extern int hisi_sas_remove(struct platform_device *pdev);
diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index d4809cf..58c6cf0 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -1729,66 +1729,95 @@ static void hisi_sas_rst_work_handler(struct work_struct *work)
 	hisi_sas_controller_reset(hisi_hba);
 }
 
-static struct Scsi_Host *hisi_sas_shost_alloc(struct platform_device *pdev,
-					      const struct hisi_sas_hw *hw)
+int hisi_sas_get_fw_info(struct hisi_hba *hisi_hba)
 {
-	struct resource *res;
-	struct Scsi_Host *shost;
-	struct hisi_hba *hisi_hba;
-	struct device *dev = &pdev->dev;
-	struct device_node *np = pdev->dev.of_node;
+	struct device *dev = hisi_hba->dev;
+	struct platform_device *pdev = hisi_hba->platform_dev;
+	struct device_node *np = pdev ? pdev->dev.of_node : NULL;
 	struct clk *refclk;
 
-	shost = scsi_host_alloc(&hisi_sas_sht, sizeof(*hisi_hba));
-	if (!shost) {
-		dev_err(dev, "scsi host alloc failed\n");
-		return NULL;
-	}
-	hisi_hba = shost_priv(shost);
-
-	INIT_WORK(&hisi_hba->rst_work, hisi_sas_rst_work_handler);
-	hisi_hba->hw = hw;
-	hisi_hba->platform_dev = pdev;
-	hisi_hba->dev = dev;
-	hisi_hba->shost = shost;
-	SHOST_TO_SAS_HA(shost) = &hisi_hba->sha;
-
-	init_timer(&hisi_hba->timer);
-
 	if (device_property_read_u8_array(dev, "sas-addr", hisi_hba->sas_addr,
-					  SAS_ADDR_SIZE))
-		goto err_out;
+					  SAS_ADDR_SIZE)) {
+		dev_err(dev, "could not get property sas-addr\n");
+		return -ENOENT;
+	}
 
 	if (np) {
 		hisi_hba->ctrl = syscon_regmap_lookup_by_phandle(np,
 					"hisilicon,sas-syscon");
-		if (IS_ERR(hisi_hba->ctrl))
-			goto err_out;
+		if (IS_ERR(hisi_hba->ctrl)) {
+			dev_err(dev, "could not get syscon\n");
+			return -ENOENT;
+		}
 
 		if (device_property_read_u32(dev, "ctrl-reset-reg",
-					     &hisi_hba->ctrl_reset_reg))
-			goto err_out;
+					     &hisi_hba->ctrl_reset_reg)) {
+			dev_err(dev,
+				"could not get property ctrl-reset-reg\n");
+			return -ENOENT;
+		}
 
 		if (device_property_read_u32(dev, "ctrl-reset-sts-reg",
-					     &hisi_hba->ctrl_reset_sts_reg))
-			goto err_out;
+					     &hisi_hba->ctrl_reset_sts_reg)) {
+			dev_err(dev,
+				"could not get property ctrl-reset-sts-reg\n");
+			return -ENOENT;
+		}
 
 		if (device_property_read_u32(dev, "ctrl-clock-ena-reg",
-					     &hisi_hba->ctrl_clock_ena_reg))
-			goto err_out;
+					     &hisi_hba->ctrl_clock_ena_reg)) {
+			dev_err(dev,
+				"could not get property ctrl-clock-ena-reg\n");
+			return -ENOENT;
+		}
 	}
 
-	refclk = devm_clk_get(&pdev->dev, NULL);
+	refclk = devm_clk_get(dev, NULL);
 	if (IS_ERR(refclk))
 		dev_dbg(dev, "no ref clk property\n");
 	else
 		hisi_hba->refclk_frequency_mhz = clk_get_rate(refclk) / 1000000;
 
-	if (device_property_read_u32(dev, "phy-count", &hisi_hba->n_phy))
-		goto err_out;
+	if (device_property_read_u32(dev, "phy-count", &hisi_hba->n_phy)) {
+		dev_err(dev, "could not get property phy-count\n");
+		return -ENOENT;
+	}
 
 	if (device_property_read_u32(dev, "queue-count",
-				     &hisi_hba->queue_count))
+				     &hisi_hba->queue_count)) {
+		dev_err(dev, "could not get property queue-count\n");
+		return -ENOENT;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(hisi_sas_get_fw_info);
+
+static struct Scsi_Host *hisi_sas_shost_alloc(struct platform_device *pdev,
+					      const struct hisi_sas_hw *hw)
+{
+	struct resource *res;
+	struct Scsi_Host *shost;
+	struct hisi_hba *hisi_hba;
+	struct device *dev = &pdev->dev;
+
+	shost = scsi_host_alloc(&hisi_sas_sht, sizeof(*hisi_hba));
+	if (!shost) {
+		dev_err(dev, "scsi host alloc failed\n");
+		return NULL;
+	}
+	hisi_hba = shost_priv(shost);
+
+	INIT_WORK(&hisi_hba->rst_work, hisi_sas_rst_work_handler);
+	hisi_hba->hw = hw;
+	hisi_hba->dev = dev;
+	hisi_hba->platform_dev = pdev;
+	hisi_hba->shost = shost;
+	SHOST_TO_SAS_HA(shost) = &hisi_hba->sha;
+
+	init_timer(&hisi_hba->timer);
+
+	if (hisi_sas_get_fw_info(hisi_hba) < 0)
 		goto err_out;
 
 	if (dma_set_mask_and_coherent(dev, DMA_BIT_MASK(64)) &&
-- 
1.9.1
