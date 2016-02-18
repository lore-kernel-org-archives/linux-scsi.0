From: Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 7/7] ahci: Add runtime PM support for the host controller
Date: Thu, 18 Feb 2016 10:54:17 +0200
Message-ID: <1455785657-22924-8-git-send-email-mika.westerberg@linux.intel.com>
References: <1455785657-22924-1-git-send-email-mika.westerberg@linux.intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1455785657-22924-1-git-send-email-mika.westerberg@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-block@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Mika Westerberg <mika.westerberg@linux.intel.com>, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

This patch adds runtime PM support for the AHCI host controller driver so
that the host controller is powered down when all SATA ports are runtime
suspended. Powering down the AHCI host controller can reduce power
consumption and possibly allow the CPU to enter lower power idle states
(S0ix) during runtime.

Runtime PM is blocked by default and needs to be unblocked from userspace
as needed (via power/* sysfs nodes).

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
---
 drivers/ata/ahci.c | 73 +++++++++++++++++++++++++++++++++++++++++++++---------
 1 file changed, 61 insertions(+), 12 deletions(-)

diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index 44f9d1c09bbe..fb0c23ae3ce9 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -85,6 +85,7 @@ enum board_ids {
 };
 
 static int ahci_init_one(struct pci_dev *pdev, const struct pci_device_id *ent);
+static void ahci_remove_one(struct pci_dev *dev);
 static int ahci_vt8251_hardreset(struct ata_link *link, unsigned int *class,
 				 unsigned long deadline);
 static int ahci_avn_hardreset(struct ata_link *link, unsigned int *class,
@@ -93,10 +94,14 @@ static void ahci_mcp89_apple_enable(struct pci_dev *pdev);
 static bool is_mcp89_apple(struct pci_dev *pdev);
 static int ahci_p5wdh_hardreset(struct ata_link *link, unsigned int *class,
 				unsigned long deadline);
+#ifdef CONFIG_PM
+static int ahci_pci_device_runtime_suspend(struct device *dev);
+static int ahci_pci_device_runtime_resume(struct device *dev);
 #ifdef CONFIG_PM_SLEEP
 static int ahci_pci_device_suspend(struct device *dev);
 static int ahci_pci_device_resume(struct device *dev);
 #endif
+#endif /* CONFIG_PM */
 
 static struct scsi_host_template ahci_sht = {
 	AHCI_SHT("ahci"),
@@ -559,13 +564,15 @@ static const struct pci_device_id ahci_pci_tbl[] = {
 
 static const struct dev_pm_ops ahci_pci_pm_ops = {
 	SET_SYSTEM_SLEEP_PM_OPS(ahci_pci_device_suspend, ahci_pci_device_resume)
+	SET_RUNTIME_PM_OPS(ahci_pci_device_runtime_suspend,
+			   ahci_pci_device_runtime_resume, NULL)
 };
 
 static struct pci_driver ahci_pci_driver = {
 	.name			= DRV_NAME,
 	.id_table		= ahci_pci_tbl,
 	.probe			= ahci_init_one,
-	.remove			= ata_pci_remove_one,
+	.remove			= ahci_remove_one,
 	.driver.pm		= &ahci_pci_pm_ops,
 };
 
@@ -794,21 +801,13 @@ static int ahci_avn_hardreset(struct ata_link *link, unsigned int *class,
 }
 
 
-#ifdef CONFIG_PM_SLEEP
-static int ahci_pci_device_suspend(struct device *dev)
+#ifdef CONFIG_PM
+static void ahci_pci_disable_interrupts(struct ata_host *host)
 {
-	struct pci_dev *pdev = to_pci_dev(dev);
-	struct ata_host *host = pci_get_drvdata(pdev);
 	struct ahci_host_priv *hpriv = host->private_data;
 	void __iomem *mmio = hpriv->mmio;
 	u32 ctl;
 
-	if (hpriv->flags & AHCI_HFLAG_NO_SUSPEND) {
-		dev_err(&pdev->dev,
-			"BIOS update required for suspend/resume\n");
-		return -EIO;
-	}
-
 	/* AHCI spec rev1.1 section 8.3.3:
 	 * Software must disable interrupts prior to requesting a
 	 * transition of the HBA to D3 state.
@@ -817,7 +816,44 @@ static int ahci_pci_device_suspend(struct device *dev)
 	ctl &= ~HOST_IRQ_EN;
 	writel(ctl, mmio + HOST_CTL);
 	readl(mmio + HOST_CTL); /* flush */
+}
+
+static int ahci_pci_device_runtime_suspend(struct device *dev)
+{
+	struct pci_dev *pdev = to_pci_dev(dev);
+	struct ata_host *host = pci_get_drvdata(pdev);
 
+	ahci_pci_disable_interrupts(host);
+	return 0;
+}
+
+static int ahci_pci_device_runtime_resume(struct device *dev)
+{
+	struct pci_dev *pdev = to_pci_dev(dev);
+	struct ata_host *host = pci_get_drvdata(pdev);
+	int rc;
+
+	rc = ahci_pci_reset_controller(host);
+	if (rc)
+		return rc;
+	ahci_pci_init_controller(host);
+	return 0;
+}
+
+#ifdef CONFIG_PM_SLEEP
+static int ahci_pci_device_suspend(struct device *dev)
+{
+	struct pci_dev *pdev = to_pci_dev(dev);
+	struct ata_host *host = pci_get_drvdata(pdev);
+	struct ahci_host_priv *hpriv = host->private_data;
+
+	if (hpriv->flags & AHCI_HFLAG_NO_SUSPEND) {
+		dev_err(&pdev->dev,
+			"BIOS update required for suspend/resume\n");
+		return -EIO;
+	}
+
+	ahci_pci_disable_interrupts(host);
 	return ata_host_suspend(host, PMSG_SUSPEND);
 }
 
@@ -845,6 +881,8 @@ static int ahci_pci_device_resume(struct device *dev)
 }
 #endif
 
+#endif /* CONFIG_PM */
+
 static int ahci_configure_dma_masks(struct pci_dev *pdev, int using_dac)
 {
 	int rc;
@@ -1664,7 +1702,18 @@ static int ahci_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	pci_set_master(pdev);
 
-	return ahci_host_activate(host, &ahci_sht);
+	rc = ahci_host_activate(host, &ahci_sht);
+	if (rc)
+		return rc;
+
+	pm_runtime_put_noidle(&pdev->dev);
+	return 0;
+}
+
+static void ahci_remove_one(struct pci_dev *pdev)
+{
+	pm_runtime_get_noresume(&pdev->dev);
+	ata_pci_remove_one(pdev);
 }
 
 module_pci_driver(ahci_pci_driver);
-- 
2.7.0
