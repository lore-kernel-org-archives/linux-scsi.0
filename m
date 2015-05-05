From: Suman Tripathi <stripathi-qTEPVZfXA3Y@public.gmane.org>
Subject: [PATCH v5 2/3] libahci: Add support to handle HOST_IRQ_STAT as edge trigger latch.
Date: Wed,  6 May 2015 00:51:11 +0530
Message-ID: <1430853672-6227-3-git-send-email-stripathi@apm.com>
References: <1430853672-6227-1-git-send-email-stripathi@apm.com>
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1430853672-6227-1-git-send-email-stripathi-qTEPVZfXA3Y@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: olof-nZhT3qVonbNeoWH0uzbU5w@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org
Cc: linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ide-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, mlangsdo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jcm-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, patches-qTEPVZfXA3Y@public.gmane.org, Suman Tripathi <stripathi-qTEPVZfXA3Y@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

This patch adds the support to handle HOST_IRQ_STAT as edge trigger
latch.

Signed-off-by: Suman Tripathi <stripathi-qTEPVZfXA3Y@public.gmane.org>
---
 drivers/ata/ahci.h    |  2 ++
 drivers/ata/libahci.c | 40 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 42 insertions(+)

diff --git a/drivers/ata/ahci.h b/drivers/ata/ahci.h
index 71262e0..f442960 100644
--- a/drivers/ata/ahci.h
+++ b/drivers/ata/ahci.h
@@ -238,6 +238,8 @@ enum {
 	AHCI_HFLAG_MULTI_MSI		= (1 << 16), /* multiple PCI MSIs */
 	AHCI_HFLAG_NO_DEVSLP		= (1 << 17), /* no device sleep */
 	AHCI_HFLAG_NO_FBS		= (1 << 18), /* no FBS */
+	AHCI_HFLAG_EDGE_IRQ		= (1 << 19), /* HOST_IRQ_STAT behaves as
+							Edge Triggered */

 	/* ap->flags bits */

diff --git a/drivers/ata/libahci.c b/drivers/ata/libahci.c
index aa89c8e..1add5ba 100644
--- a/drivers/ata/libahci.c
+++ b/drivers/ata/libahci.c
@@ -1853,6 +1853,43 @@ static u32 ahci_handle_port_intr(struct ata_host *host, u32 irq_masked)
 	return handled;
 }

+static irqreturn_t ahci_single_edge_irq_intr(int irq, void *dev_instance)
+{
+	struct ata_host *host = dev_instance;
+	struct ahci_host_priv *hpriv;
+	unsigned int rc = 0;
+	void __iomem *mmio;
+	u32 irq_stat, irq_masked;
+
+	VPRINTK("ENTER\n");
+
+	hpriv = host->private_data;
+	mmio = hpriv->mmio;
+
+	/* sigh.  0xffffffff is a valid return from h/w */
+	irq_stat = readl(mmio + HOST_IRQ_STAT);
+	if (!irq_stat)
+		return IRQ_NONE;
+
+	irq_masked = irq_stat & hpriv->port_map;
+
+	spin_lock(&host->lock);
+
+	/*
+	 * HOST_IRQ_STAT behaves as edge triggered latch meaning that
+	 * it should be cleared before all the port events are cleared.
+	 */
+	writel(irq_stat, mmio + HOST_IRQ_STAT);
+
+	rc = ahci_handle_port_intr(host, irq_masked);
+
+	spin_unlock(&host->lock);
+
+	VPRINTK("EXIT\n");
+
+	return IRQ_RETVAL(rc);
+}
+
 static irqreturn_t ahci_single_level_irq_intr(int irq, void *dev_instance)
 {
 	struct ata_host *host = dev_instance;
@@ -2495,6 +2532,9 @@ int ahci_host_activate(struct ata_host *host, int irq,

 	if (hpriv->flags & AHCI_HFLAG_MULTI_MSI)
 		rc = ahci_host_activate_multi_irqs(host, irq, sht);
+	else if (hpriv->flags & AHCI_HFLAG_EDGE_IRQ)
+		rc = ata_host_activate(host, irq, ahci_single_edge_irq_intr,
+				       IRQF_SHARED, sht);
 	else
 		rc = ata_host_activate(host, irq, ahci_single_level_irq_intr,
 				       IRQF_SHARED, sht);
--
1.8.2.1

--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
