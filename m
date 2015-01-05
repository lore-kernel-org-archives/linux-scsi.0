From: Suman Tripathi <stripathi@apm.com>
Subject: [PATCH 1/2] ahci_xgene: Fix the xgene_ahci_restart_engine function to support Port Multiplier for APM X-Gene SoC AHCI SATA host controller driver.
Date: Mon,  5 Jan 2015 15:51:44 +0530
Message-ID: <1420453305-15986-2-git-send-email-stripathi@apm.com>
References: <1420453305-15986-1-git-send-email-stripathi@apm.com>
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1420453305-15986-1-git-send-email-stripathi@apm.com>
Sender: linux-ide-owner@vger.kernel.org
To: olof@lixom.net, tj@kernel.org, arnd@arndb.de
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org, mlangsdo@redhat.com, jcm@redhat.com, patches@apm.com, Suman Tripathi <stripathi@apm.com>
List-Id: linux-scsi@vger.kernel.org

This patch implements the function xgene_ahci_poll_reg_val to poll
PxCI for multiple IDENTIFY DEVICE commands to finish before
restarting the DMA engine in case of Port Multiplier.

Signed-off-by: Suman Tripathi <stripathi@apm.com>
---
 drivers/ata/ahci_xgene.c | 56 ++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 54 insertions(+), 2 deletions(-)

diff --git a/drivers/ata/ahci_xgene.c b/drivers/ata/ahci_xgene.c
index 0f8538f..2180223 100644
--- a/drivers/ata/ahci_xgene.c
+++ b/drivers/ata/ahci_xgene.c
@@ -105,17 +105,69 @@ static int xgene_ahci_init_memram(struct xgene_ahci_context *ctx)
 }

 /**
+ * xgene_ahci_poll_reg_val- Poll a register on a specific value.
+ * @ap : ATA port of interest.
+ * @reg : Register of interest.
+ * @val : Value to be attained.
+ * @interval : waiting interval for polling.
+ * @timeout : timeout for achieving the value.
+ */
+static int xgene_ahci_poll_reg_val(struct ata_port *ap,
+				   void __iomem *reg, unsigned
+				   int val, unsigned long interval,
+				   unsigned long timeout)
+{
+	unsigned long deadline;
+	unsigned int tmp;
+
+	tmp = ioread32(reg);
+	deadline = ata_deadline(jiffies, timeout);
+
+	while ((tmp != val) && (time_before(jiffies, deadline))) {
+		ata_msleep(ap, interval);
+		tmp = ioread32(reg);
+	}
+
+	return tmp;
+}
+
+/**
  * xgene_ahci_restart_engine - Restart the dma engine.
  * @ap : ATA port of interest
  *
- * Restarts the dma engine inside the controller.
+ * Waits for completion of multiple commands and restarts
+ * the DMA engine inside the controller.
  */
 static int xgene_ahci_restart_engine(struct ata_port *ap)
 {
 	struct ahci_host_priv *hpriv = ap->host->private_data;
+	struct ahci_port_priv *pp = ap->private_data;
+	void __iomem *port_mmio = ahci_port_base(ap);
+	u32 fbs;
+
+	/*
+	 * In case of PMP multiple IDENTIFY DEVICE commands can be
+	 * issued inside PxCI. So need to poll PxCI for the
+	 * completion of outstanding IDENTIFY DEVICE commands before
+	 * we restart the DMA engine.
+	 */
+	if (xgene_ahci_poll_reg_val(ap, port_mmio +
+				    PORT_CMD_ISSUE, 0x0, 1, 100))
+		  return -EBUSY;

 	ahci_stop_engine(ap);
 	ahci_start_fis_rx(ap);
+
+	/*
+	 * Enable the PxFBS.FBS_EN bit as it
+	 * gets cleared due to stop engine.
+	 */
+	if (pp->fbs_supported) {
+		fbs = readl(port_mmio + PORT_FBS);
+		writel(fbs | PORT_FBS_EN, port_mmio + PORT_FBS);
+		fbs = readl(port_mmio + PORT_FBS);
+	}
+
 	hpriv->start_engine(ap);

 	return 0;
@@ -372,7 +424,7 @@ static struct ata_port_operations xgene_ahci_ops = {
 };

 static const struct ata_port_info xgene_ahci_port_info = {
-	.flags = AHCI_FLAG_COMMON,
+	.flags = AHCI_FLAG_COMMON | ATA_FLAG_PMP,
 	.pio_mask = ATA_PIO4,
 	.udma_mask = ATA_UDMA6,
 	.port_ops = &xgene_ahci_ops,
--
1.8.2.1

