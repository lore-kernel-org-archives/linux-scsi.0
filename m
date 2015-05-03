From: Suman Tripathi <stripathi-qTEPVZfXA3Y@public.gmane.org>
Subject: [PATCH v3 1/2] libahci: Add support to handle HOST_IRQ_STAT as edge trigger latch.
Date: Sun,  3 May 2015 21:03:39 +0530
Message-ID: <1430667220-23477-2-git-send-email-stripathi@apm.com>
References: <1430667220-23477-1-git-send-email-stripathi@apm.com>
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1430667220-23477-1-git-send-email-stripathi-qTEPVZfXA3Y@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: olof-nZhT3qVonbNeoWH0uzbU5w@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org
Cc: linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ide-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, mlangsdo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jcm-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, patches-qTEPVZfXA3Y@public.gmane.org, Suman Tripathi <stripathi-qTEPVZfXA3Y@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

This patch adds the support to handle HOST_IRQ_STAT as edge trigger
latch.

Signed-off-by: Suman Tripathi <stripathi-qTEPVZfXA3Y@public.gmane.org>
---
 drivers/ata/ahci.h    |  2 ++
 drivers/ata/libahci.c | 19 +++++++++++++++++++
 2 files changed, 21 insertions(+)

diff --git a/drivers/ata/ahci.h b/drivers/ata/ahci.h
index 71262e0..2df2237 100644
--- a/drivers/ata/ahci.h
+++ b/drivers/ata/ahci.h
@@ -238,6 +238,8 @@ enum {
 	AHCI_HFLAG_MULTI_MSI		= (1 << 16), /* multiple PCI MSIs */
 	AHCI_HFLAG_NO_DEVSLP		= (1 << 17), /* no device sleep */
 	AHCI_HFLAG_NO_FBS		= (1 << 18), /* no FBS */
+	AHCI_HFLAG_EDGE_TRIG_IRQ	= (1 << 19), /* HOST_IRQ_STAT behaves as
+							Edge Triggered */

 	/* ap->flags bits */

diff --git a/drivers/ata/libahci.c b/drivers/ata/libahci.c
index 61a9c07..0e7e8b4 100644
--- a/drivers/ata/libahci.c
+++ b/drivers/ata/libahci.c
@@ -1879,6 +1879,25 @@ static irqreturn_t ahci_single_irq_intr(int irq, void *dev_instance)
 	 */
 	writel(irq_stat, mmio + HOST_IRQ_STAT);

+	/*
+	 * HOST_IRQ_STAT behaves as edge trigger latch. When HOST_IRQ_STAT
+	 * detects a egde from PORT_IRQ_STAT, it happens to loose interrupts
+	 * when interrupts are triggered from both ports. So handling of
+	 * the residual interrupt is required.
+	 */
+	if (hpriv->flags & AHCI_HFLAG_EDGE_TRIG_IRQ) {
+		for (i = 0; i < host->n_ports; i++) {
+			struct ata_port *ap;
+
+			ap = host->ports[i];
+			if (ap) {
+				ahci_port_intr(ap);
+				VPRINTK("Residual irq from port %u\n", i);
+			}
+			handled = 1;
+		}
+	}
+
 	spin_unlock(&host->lock);

 	VPRINTK("EXIT\n");
--
1.8.2.1

--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
