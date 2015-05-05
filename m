From: Suman Tripathi <stripathi@apm.com>
Subject: [PATCH v5 1/3] libahci: Refactoring of ahci_single_irq_intr function.
Date: Wed,  6 May 2015 00:51:10 +0530
Message-ID: <1430853672-6227-2-git-send-email-stripathi@apm.com>
References: <1430853672-6227-1-git-send-email-stripathi@apm.com>
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1430853672-6227-1-git-send-email-stripathi@apm.com>
Sender: linux-ide-owner@vger.kernel.org
To: olof@lixom.net, tj@kernel.org, arnd@arndb.de
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org, mlangsdo@redhat.com, jcm@redhat.com, patches@apm.com, Suman Tripathi <stripathi@apm.com>
List-Id: linux-scsi@vger.kernel.org

This patch refactors the ahci_single_irq_intr function and also rename
it to ahci_single_level_irq_intr as it handles a level triggered latch.

Signed-off-by: Suman tripathi <stripathi@apm.com>
---
 drivers/ata/libahci.c | 51 ++++++++++++++++++++++++++++++---------------------
 1 file changed, 30 insertions(+), 21 deletions(-)

diff --git a/drivers/ata/libahci.c b/drivers/ata/libahci.c
index 61a9c07..aa89c8e 100644
--- a/drivers/ata/libahci.c
+++ b/drivers/ata/libahci.c
@@ -1826,27 +1826,9 @@ static irqreturn_t ahci_multi_irqs_intr(int irq, void *dev_instance)
 	return IRQ_WAKE_THREAD;
 }

-static irqreturn_t ahci_single_irq_intr(int irq, void *dev_instance)
+static u32 ahci_handle_port_intr(struct ata_host *host, u32 irq_masked)
 {
-	struct ata_host *host = dev_instance;
-	struct ahci_host_priv *hpriv;
 	unsigned int i, handled = 0;
-	void __iomem *mmio;
-	u32 irq_stat, irq_masked;
-
-	VPRINTK("ENTER\n");
-
-	hpriv = host->private_data;
-	mmio = hpriv->mmio;
-
-	/* sigh.  0xffffffff is a valid return from h/w */
-	irq_stat = readl(mmio + HOST_IRQ_STAT);
-	if (!irq_stat)
-		return IRQ_NONE;
-
-	irq_masked = irq_stat & hpriv->port_map;
-
-	spin_lock(&host->lock);

 	for (i = 0; i < host->n_ports; i++) {
 		struct ata_port *ap;
@@ -1868,6 +1850,33 @@ static irqreturn_t ahci_single_irq_intr(int irq, void *dev_instance)
 		handled = 1;
 	}

+	return handled;
+}
+
+static irqreturn_t ahci_single_level_irq_intr(int irq, void *dev_instance)
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
+	rc = ahci_handle_port_intr(host, irq_masked);
+
 	/* HOST_IRQ_STAT behaves as level triggered latch meaning that
 	 * it should be cleared after all the port events are cleared;
 	 * otherwise, it will raise a spurious interrupt after each
@@ -1883,7 +1892,7 @@ static irqreturn_t ahci_single_irq_intr(int irq, void *dev_instance)

 	VPRINTK("EXIT\n");

-	return IRQ_RETVAL(handled);
+	return IRQ_RETVAL(rc);
 }

 unsigned int ahci_qc_issue(struct ata_queued_cmd *qc)
@@ -2487,7 +2496,7 @@ int ahci_host_activate(struct ata_host *host, int irq,
 	if (hpriv->flags & AHCI_HFLAG_MULTI_MSI)
 		rc = ahci_host_activate_multi_irqs(host, irq, sht);
 	else
-		rc = ata_host_activate(host, irq, ahci_single_irq_intr,
+		rc = ata_host_activate(host, irq, ahci_single_level_irq_intr,
 				       IRQF_SHARED, sht);
 	return rc;
 }
--
1.8.2.1

