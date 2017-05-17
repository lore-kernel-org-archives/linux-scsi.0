From: John Garry <john.garry@huawei.com>
Subject: [PATCH 07/22] scsi: hisi_sas: add the initialisation for pci-based controller
Date: Wed, 17 May 2017 18:49:42 +0800
Message-ID: <1495018197-120535-8-git-send-email-john.garry@huawei.com>
References: <1495018197-120535-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1495018197-120535-1-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: john.garry2@mail.dcu.ie, linuxarm@huawei.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, arnd@arndb.de, John Garry <john.garry@huawei.com>, Xiang Chen <chenxiang66@hisilicon.com>
List-Id: linux-scsi@vger.kernel.org

Add the code to initialise controller which is based on pci device
in hisi_sas_pci_init.c

The main functionality added is for probing and initialisation of
the controller based on pci device.

The core controller routines are still in hisi_sas_main.c; some
common initialisation functions and structures are also exported from
hisi_sas_main.c for pci init.

For platform device-based controller, controller properties - like
phy count - were read from the firmware. For pci-based controller this
information is hard-coded in the driver, in new struct hisi_sas_pci_hw.

Signed-off-by: John Garry <john.garry@huawei.com>
Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
---
 drivers/scsi/hisi_sas/Kconfig             |  10 +-
 drivers/scsi/hisi_sas/Makefile            |   1 +
 drivers/scsi/hisi_sas/hisi_sas.h          |  19 ++++
 drivers/scsi/hisi_sas/hisi_sas_main.c     |  18 ++-
 drivers/scsi/hisi_sas/hisi_sas_pci_init.c | 182 ++++++++++++++++++++++++++++++
 5 files changed, 223 insertions(+), 7 deletions(-)
 create mode 100644 drivers/scsi/hisi_sas/hisi_sas_pci_init.c

diff --git a/drivers/scsi/hisi_sas/Kconfig b/drivers/scsi/hisi_sas/Kconfig
index 374a329..d42f29a 100644
--- a/drivers/scsi/hisi_sas/Kconfig
+++ b/drivers/scsi/hisi_sas/Kconfig
@@ -6,4 +6,12 @@ config SCSI_HISI_SAS
 	select BLK_DEV_INTEGRITY
 	depends on ATA
 	help
-		This driver supports HiSilicon's SAS HBA
+		This driver supports HiSilicon's SAS HBA, including support based
+		on platform device
+
+config SCSI_HISI_SAS_PCI
+	tristate "HiSilicon SAS on PCI bus"
+	depends on SCSI_HISI_SAS
+	depends on PCI
+	help
+		This driver supports HiSilicon's SAS HBA based on PCI device
diff --git a/drivers/scsi/hisi_sas/Makefile b/drivers/scsi/hisi_sas/Makefile
index c6d3a1b..3a036a8 100644
--- a/drivers/scsi/hisi_sas/Makefile
+++ b/drivers/scsi/hisi_sas/Makefile
@@ -1,2 +1,3 @@
 obj-$(CONFIG_SCSI_HISI_SAS)		+= hisi_sas_main.o
 obj-$(CONFIG_SCSI_HISI_SAS)		+= hisi_sas_v1_hw.o hisi_sas_v2_hw.o
+obj-$(CONFIG_SCSI_HISI_SAS_PCI)		+= hisi_sas_pci_init.o
diff --git a/drivers/scsi/hisi_sas/hisi_sas.h b/drivers/scsi/hisi_sas/hisi_sas.h
index 18044b7..9bc9550 100644
--- a/drivers/scsi/hisi_sas/hisi_sas.h
+++ b/drivers/scsi/hisi_sas/hisi_sas.h
@@ -186,6 +186,12 @@ struct hisi_sas_hw {
 	int complete_hdr_size;
 };
 
+struct hisi_sas_pci_hw {
+	int n_phy;
+	int queue_count;
+	const struct hisi_sas_hw *hw;
+};
+
 struct hisi_hba {
 	/* This must be the first element, used by SHOST_TO_SAS_HA */
 	struct sas_ha_struct *p;
@@ -359,6 +365,19 @@ struct hisi_sas_command_table_ssp {
 	struct hisi_sas_command_table_stp stp;
 };
 
+extern struct scsi_transport_template *hisi_sas_stt;
+extern struct scsi_host_template *hisi_sas_sht;
+
+extern void hisi_sas_init_add(struct hisi_hba *hisi_hba);
+extern int hisi_sas_alloc(struct hisi_hba *hisi_hba, struct Scsi_Host *shost);
+extern void hisi_sas_free(struct hisi_hba *hisi_hba);
+
+#if IS_ENABLED(CONFIG_SCSI_HISI_SAS_PCI)
+extern int hisi_sas_pci_probe(struct pci_dev *pdev,
+		       const struct hisi_sas_pci_hw *hw);
+extern void hisi_sas_pci_remove(struct pci_dev *pdev);
+#endif
+
 extern u8 hisi_sas_get_ata_protocol(u8 cmd, int direction);
 extern struct hisi_sas_port *to_hisi_sas_port(struct asd_sas_port *sas_port);
 extern void hisi_sas_sata_done(struct sas_task *task,
diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index d20a2f2..33bd3c45 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -1476,9 +1476,10 @@ void hisi_sas_rescan_topology(struct hisi_hba *hisi_hba, u32 old_state,
 }
 EXPORT_SYMBOL_GPL(hisi_sas_rescan_topology);
 
-static struct scsi_transport_template *hisi_sas_stt;
+struct scsi_transport_template *hisi_sas_stt;
+EXPORT_SYMBOL_GPL(hisi_sas_stt);
 
-static struct scsi_host_template hisi_sas_sht = {
+static struct scsi_host_template _hisi_sas_sht = {
 	.module			= THIS_MODULE,
 	.name			= DRV_NAME,
 	.queuecommand		= sas_queuecommand,
@@ -1498,6 +1499,8 @@ void hisi_sas_rescan_topology(struct hisi_hba *hisi_hba, u32 old_state,
 	.target_destroy		= sas_target_destroy,
 	.ioctl			= sas_ioctl,
 };
+struct scsi_host_template *hisi_sas_sht = &_hisi_sas_sht;
+EXPORT_SYMBOL_GPL(hisi_sas_sht);
 
 static struct sas_domain_function_template hisi_sas_transport_ops = {
 	.lldd_dev_found		= hisi_sas_dev_found,
@@ -1545,7 +1548,7 @@ void hisi_sas_init_mem(struct hisi_hba *hisi_hba)
 }
 EXPORT_SYMBOL_GPL(hisi_sas_init_mem);
 
-static int hisi_sas_alloc(struct hisi_hba *hisi_hba, struct Scsi_Host *shost)
+int hisi_sas_alloc(struct hisi_hba *hisi_hba, struct Scsi_Host *shost)
 {
 	struct device *dev = hisi_hba->dev;
 	int i, s, max_command_entries = hisi_hba->hw->max_command_entries;
@@ -1664,8 +1667,9 @@ static int hisi_sas_alloc(struct hisi_hba *hisi_hba, struct Scsi_Host *shost)
 err_out:
 	return -ENOMEM;
 }
+EXPORT_SYMBOL_GPL(hisi_sas_alloc);
 
-static void hisi_sas_free(struct hisi_hba *hisi_hba)
+void hisi_sas_free(struct hisi_hba *hisi_hba)
 {
 	struct device *dev = hisi_hba->dev;
 	int i, s, max_command_entries = hisi_hba->hw->max_command_entries;
@@ -1720,6 +1724,7 @@ static void hisi_sas_free(struct hisi_hba *hisi_hba)
 	if (hisi_hba->wq)
 		destroy_workqueue(hisi_hba->wq);
 }
+EXPORT_SYMBOL_GPL(hisi_sas_free);
 
 static void hisi_sas_rst_work_handler(struct work_struct *work)
 {
@@ -1739,7 +1744,7 @@ static struct Scsi_Host *hisi_sas_shost_alloc(struct platform_device *pdev,
 	struct device_node *np = pdev->dev.of_node;
 	struct clk *refclk;
 
-	shost = scsi_host_alloc(&hisi_sas_sht, sizeof(*hisi_hba));
+	shost = scsi_host_alloc(hisi_sas_sht, sizeof(*hisi_hba));
 	if (!shost) {
 		dev_err(dev, "scsi host alloc failed\n");
 		return NULL;
@@ -1814,7 +1819,7 @@ static struct Scsi_Host *hisi_sas_shost_alloc(struct platform_device *pdev,
 	return NULL;
 }
 
-static void hisi_sas_init_add(struct hisi_hba *hisi_hba)
+void hisi_sas_init_add(struct hisi_hba *hisi_hba)
 {
 	int i;
 
@@ -1823,6 +1828,7 @@ static void hisi_sas_init_add(struct hisi_hba *hisi_hba)
 		       hisi_hba->sas_addr,
 		       SAS_ADDR_SIZE);
 }
+EXPORT_SYMBOL_GPL(hisi_sas_init_add);
 
 int hisi_sas_probe(struct platform_device *pdev,
 			 const struct hisi_sas_hw *hw)
diff --git a/drivers/scsi/hisi_sas/hisi_sas_pci_init.c b/drivers/scsi/hisi_sas/hisi_sas_pci_init.c
new file mode 100644
index 0000000..e00b482
--- /dev/null
+++ b/drivers/scsi/hisi_sas/hisi_sas_pci_init.c
@@ -0,0 +1,182 @@
+/*
+ * Copyright (c) 2017 Hisilicon Limited.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ */
+
+#include "hisi_sas.h"
+#define DRV_NAME "hisi_sas_pci"
+
+static struct Scsi_Host *
+hisi_sas_shost_alloc_pci(struct pci_dev *pdev,
+			 const struct hisi_sas_pci_hw *hw)
+{
+	struct Scsi_Host *shost;
+	struct hisi_hba *hisi_hba;
+	struct device *dev = &pdev->dev;
+
+	shost = scsi_host_alloc(hisi_sas_sht, sizeof(*hisi_hba));
+	if (!shost)
+		goto err_out;
+	hisi_hba = shost_priv(shost);
+
+	hisi_hba->hw = hw->hw;
+	hisi_hba->queue_count = hw->queue_count;
+	hisi_hba->n_phy = hw->n_phy;
+	hisi_hba->pci_dev = pdev;
+	hisi_hba->dev = dev;
+	hisi_hba->shost = shost;
+	SHOST_TO_SAS_HA(shost) = &hisi_hba->sha;
+
+	init_timer(&hisi_hba->timer);
+
+	if (hisi_sas_alloc(hisi_hba, shost)) {
+		hisi_sas_free(hisi_hba);
+		goto err_out;
+	}
+
+	return shost;
+err_out:
+	dev_err(dev, "shost alloc failed\n");
+	return NULL;
+}
+
+int hisi_sas_pci_probe(struct pci_dev *pdev,
+		       const struct hisi_sas_pci_hw *hw)
+{
+	struct Scsi_Host *shost;
+	struct hisi_hba *hisi_hba;
+	struct device *dev = &pdev->dev;
+	struct asd_sas_phy **arr_phy;
+	struct asd_sas_port **arr_port;
+	struct sas_ha_struct *sha;
+	int rc, phy_nr, port_nr, i;
+
+	rc = pci_enable_device(pdev);
+	if (rc)
+		goto err_out;
+
+	pci_set_master(pdev);
+
+	rc = pci_request_regions(pdev, DRV_NAME);
+	if (rc)
+		goto err_out_disable_device;
+
+	if ((pci_set_dma_mask(pdev, DMA_BIT_MASK(64)) != 0) ||
+	    (pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(64)) != 0)) {
+		if ((pci_set_dma_mask(pdev, DMA_BIT_MASK(32)) != 0) ||
+		   (pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(32)) != 0)) {
+			dev_err(dev, "No usable DMA addressing method\n");
+			rc = -EIO;
+			goto err_out_regions;
+		}
+	}
+
+	shost = hisi_sas_shost_alloc_pci(pdev, hw);
+	if (!shost) {
+		rc = -ENOMEM;
+		goto err_out_regions;
+	}
+
+	sha = SHOST_TO_SAS_HA(shost);
+	hisi_hba = shost_priv(shost);
+	dev_set_drvdata(dev, sha);
+
+	hisi_hba->regs = pcim_iomap(pdev, 5, 0);
+	if (!hisi_hba->regs) {
+		dev_err(dev, "cannot map register.\n");
+		rc = -ENOMEM;
+		goto err_out_ha;
+	}
+
+	phy_nr = port_nr = hisi_hba->n_phy;
+
+	arr_phy = devm_kcalloc(dev, phy_nr, sizeof(void *), GFP_KERNEL);
+	arr_port = devm_kcalloc(dev, port_nr, sizeof(void *), GFP_KERNEL);
+	if (!arr_phy || !arr_port) {
+		rc = -ENOMEM;
+		goto err_out_ha;
+	}
+
+	sha->sas_phy = arr_phy;
+	sha->sas_port = arr_port;
+	sha->core.shost = shost;
+	sha->lldd_ha = hisi_hba;
+
+	shost->transportt = hisi_sas_stt;
+	shost->max_id = HISI_SAS_MAX_DEVICES;
+	shost->max_lun = ~0;
+	shost->max_channel = 1;
+	shost->max_cmd_len = 16;
+	shost->sg_tablesize = min_t(u16, SG_ALL, HISI_SAS_SGE_PAGE_CNT);
+	shost->can_queue = hisi_hba->hw->max_command_entries;
+	shost->cmd_per_lun = hisi_hba->hw->max_command_entries;
+
+	sha->sas_ha_name = DRV_NAME;
+	sha->dev = dev;
+	sha->lldd_module = THIS_MODULE;
+	sha->sas_addr = &hisi_hba->sas_addr[0];
+	sha->num_phys = hisi_hba->n_phy;
+	sha->core.shost = hisi_hba->shost;
+
+	for (i = 0; i < hisi_hba->n_phy; i++) {
+		sha->sas_phy[i] = &hisi_hba->phy[i].sas_phy;
+		sha->sas_port[i] = &hisi_hba->port[i].sas_port;
+	}
+
+	hisi_sas_init_add(hisi_hba);
+
+	rc = scsi_add_host(shost, dev);
+	if (rc)
+		goto err_out_ha;
+
+	rc = sas_register_ha(sha);
+	if (rc)
+		goto err_out_register_ha;
+
+	rc = hisi_hba->hw->hw_init(hisi_hba);
+	if (rc)
+		goto err_out_register_ha;
+
+	scsi_scan_host(shost);
+
+	return 0;
+
+err_out_register_ha:
+	scsi_remove_host(shost);
+err_out_ha:
+	kfree(shost);
+err_out_regions:
+	pci_release_regions(pdev);
+err_out_disable_device:
+	pci_disable_device(pdev);
+err_out:
+	return rc;
+}
+EXPORT_SYMBOL_GPL(hisi_sas_pci_probe);
+
+void hisi_sas_pci_remove(struct pci_dev *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct sas_ha_struct *sha = dev_get_drvdata(dev);
+	struct hisi_hba *hisi_hba = sha->lldd_ha;
+
+	scsi_remove_host(sha->core.shost);
+	sas_unregister_ha(sha);
+	sas_remove_host(sha->core.shost);
+
+	hisi_sas_free(hisi_hba);
+	pci_release_regions(pdev);
+	pci_disable_device(pdev);
+}
+EXPORT_SYMBOL_GPL(hisi_sas_pci_remove);
+
+MODULE_VERSION(DRV_VERSION);
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("John Garry <john.garry@huawei.com>");
+MODULE_DESCRIPTION("HISILICON SAS pci controller driver");
+MODULE_ALIAS("platform:" DRV_NAME);
-- 
1.9.1
