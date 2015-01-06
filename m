From: Suman Tripathi <stripathi-qTEPVZfXA3Y@public.gmane.org>
Subject: [PATCH v1 1/2] ahci_xgene: Implement the xgene_ahci_poll_reg_val to support PMP.
Date: Tue,  6 Jan 2015 15:32:15 +0530
Message-ID: <1420538536-32165-2-git-send-email-stripathi@apm.com>
References: <1420538536-32165-1-git-send-email-stripathi@apm.com>
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1420538536-32165-1-git-send-email-stripathi-qTEPVZfXA3Y@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: olof-nZhT3qVonbNeoWH0uzbU5w@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org
Cc: linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ide-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, mlangsdo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jcm-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, patches-qTEPVZfXA3Y@public.gmane.org, Suman Tripathi <stripathi-qTEPVZfXA3Y@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

This patch implements the function xgene_ahci_poll_reg_val
to poll PxCI for multiple IDENTIFY DEVICE commands to finish before
restarting the DMA engine.

Signed-off-by: Suman Tripathi <stripathi-qTEPVZfXA3Y@public.gmane.org>
---
 drivers/ata/ahci_xgene.c | 56 ++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 54 insertions(+), 2 deletions(-)

diff --git a/drivers/ata/ahci_xgene.c b/drivers/ata/ahci_xgene.c
index cbcd208..afa9c03 100644
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
+	while (tmp != val && time_before(jiffies, deadline)) {
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
+	 * gets cleared due to stopping the engine.
+	 */
+	if (pp->fbs_supported) {
+		fbs = readl(port_mmio + PORT_FBS);
+		writel(fbs | PORT_FBS_EN, port_mmio + PORT_FBS);
+		fbs = readl(port_mmio + PORT_FBS);
+	}
+
 	hpriv->start_engine(ap);

 	return 0;
@@ -374,7 +426,7 @@ static struct ata_port_operations xgene_ahci_ops = {
 };

 static const struct ata_port_info xgene_ahci_port_info = {
-	.flags = AHCI_FLAG_COMMON,
+	.flags = AHCI_FLAG_COMMON | ATA_FLAG_PMP,
 	.pio_mask = ATA_PIO4,
 	.udma_mask = ATA_UDMA6,
 	.port_ops = &xgene_ahci_ops,
--
1.8.2.1

--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
