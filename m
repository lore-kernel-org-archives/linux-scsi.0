From: Suman Tripathi <stripathi@apm.com>
Subject: [PATCH v4 2/2] ata: Fix the dma state machine lockup for the IDENTIFY DEVICE PIO mode command.
Date: Mon, 23 Jun 2014 15:23:13 +0530
Message-ID: <1403517193-29776-3-git-send-email-stripathi@apm.com>
References: <1403517193-29776-1-git-send-email-stripathi@apm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from denmail01-v4020.amcc.com ([192.195.68.30]:44222 "EHLO
	denmail01.apm.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752490AbaFWJyf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Jun 2014 05:54:35 -0400
In-Reply-To: <1403517193-29776-1-git-send-email-stripathi@apm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: olof@lixom.net, tj@kernel.org, arnd@arndb.de
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org, ddutile@redhat.com, jcm@redhat.com, patches@apm.com, Suman Tripathi <stripathi@apm.com>, Loc Ho <lho@apm.com>

This patch fixes the dma state machine lockup due to the processing
of IDENTIFY DEVICE PIO mode command. The X-Gene AHCI controller
has an errata in which it cannot clear the BSY bit after
receiving the PIO setup FIS and results the dma state machine to go
into the CMFatalErrorUpdate state resulting in the dma state
machine lockup. This patch also removes the dma restart workaround
from the read_id function as the read_id function is only called by
libata layer for ATA_INTERNAL commands. But for somecases eg:
PORT MULTIPLIER and udev, the framework will enumerate using SCSI
commands and it will not call read_id function.

Signed-off-by: Loc Ho <lho@apm.com>
Signed-off-by: Suman Tripathi <stripathi@apm.com>
---
 drivers/ata/ahci.h       |  1 +
 drivers/ata/ahci_xgene.c | 48 +++++++++++++++++++++++++++++++++++-------------
 drivers/ata/libahci.c    |  4 ++--
 3 files changed, 38 insertions(+), 15 deletions(-)

diff --git a/drivers/ata/ahci.h b/drivers/ata/ahci.h
index 3c1760e..1ea804f 100644
--- a/drivers/ata/ahci.h
+++ b/drivers/ata/ahci.h
@@ -373,6 +373,7 @@ int ahci_do_softreset(struct ata_link *link, unsigned int *class,
 int ahci_stop_engine(struct ata_port *ap);
 void ahci_start_engine(struct ata_port *ap);
 int ahci_restart_engine(struct ata_port *ap);
+unsigned int ahci_qc_issue(struct ata_queued_cmd *qc);
 int ahci_check_ready(struct ata_link *link);
 int ahci_kick_engine(struct ata_port *ap);
 int ahci_port_resume(struct ata_port *ap);
diff --git a/drivers/ata/ahci_xgene.c b/drivers/ata/ahci_xgene.c
index 77c89bf..4a367c9 100644
--- a/drivers/ata/ahci_xgene.c
+++ b/drivers/ata/ahci_xgene.c
@@ -78,6 +78,7 @@
 struct xgene_ahci_context {
 	struct ahci_host_priv *hpriv;
 	struct device *dev;
+	u8 last_cmd[MAX_AHCI_CHN_PERCTR]; /* tracking the last command */
 	void __iomem *csr_core;		/* Core CSR address of IP */
 	void __iomem *csr_diag;		/* Diag CSR address of IP */
 	void __iomem *csr_axi;		/* AXI CSR address of IP */
@@ -98,20 +99,50 @@ static int xgene_ahci_init_memram(struct xgene_ahci_context *ctx)
 }

 /**
+ * xgene_ahci_qc_issue - Issue commands to the device
+ * @qc: Command to issue
+ *
+ * Due to H/W errata, for the IDENTIFY DEVICE command controller is unable to
+ * clear the BSY bit after receiving the PIO setup FIS and results the dma
+ * state machine to go into the CMFatalErrorUpdate state resulting in the dma
+ * state machine lockup. By restarting the dma engine to move it removes the
+ * controller out of lock up state.
+ */
+static unsigned int xgene_ahci_qc_issue(struct ata_queued_cmd *qc)
+{
+	struct ata_port *ap = qc->ap;
+	struct ahci_host_priv *hpriv = ap->host->private_data;
+	struct xgene_ahci_context *ctx = hpriv->plat_data;
+	int rc = 0;
+
+	/*
+	 * Restart the dma engine if the last cmd issued
+	 * is IDENTIFY DEVICE command
+	 */
+	if (unlikely(ctx->last_cmd[ap->port_no] == ATA_CMD_ID_ATA))
+		ahci_restart_engine(ap);
+
+	rc = ahci_qc_issue(qc);
+
+	/* Save the last command issued */
+	ctx->last_cmd[ap->port_no] = qc->tf.command;
+
+	return rc;
+}
+
+/**
  * xgene_ahci_read_id - Read ID data from the specified device
  * @dev: device
  * @tf: proposed taskfile
  * @id: data buffer
  *
  * This custom read ID function is required due to the fact that the HW
- * does not support DEVSLP and the controller state machine may get stuck
- * after processing the ID query command.
+ * does not support DEVSLP.
  */
 static unsigned int xgene_ahci_read_id(struct ata_device *dev,
 				       struct ata_taskfile *tf, u16 *id)
 {
 	u32 err_mask;
-	void __iomem *port_mmio = ahci_port_base(dev->link->ap);

 	err_mask = ata_do_dev_read_id(dev, tf, id);
 	if (err_mask)
@@ -133,16 +164,6 @@ static unsigned int xgene_ahci_read_id(struct ata_device *dev,
 	 */
 	id[ATA_ID_FEATURE_SUPP] &= ~(1 << 8);

-	/*
-	 * Due to HW errata, restart the port if no other command active.
-	 * Otherwise the controller may get stuck.
-	 */
-	if (!readl(port_mmio + PORT_CMD_ISSUE)) {
-		writel(PORT_CMD_FIS_RX, port_mmio + PORT_CMD);
-		readl(port_mmio + PORT_CMD);	/* Force a barrier */
-		writel(PORT_CMD_FIS_RX | PORT_CMD_START, port_mmio + PORT_CMD);
-		readl(port_mmio + PORT_CMD);	/* Force a barrier */
-	}
 	return 0;
 }

@@ -300,6 +321,7 @@ static struct ata_port_operations xgene_ahci_ops = {
 	.host_stop = xgene_ahci_host_stop,
 	.hardreset = xgene_ahci_hardreset,
 	.read_id = xgene_ahci_read_id,
+	.qc_issue = xgene_ahci_qc_issue,
 };

 static const struct ata_port_info xgene_ahci_port_info = {
diff --git a/drivers/ata/libahci.c b/drivers/ata/libahci.c
index d1c9122..1b86cf4 100644
--- a/drivers/ata/libahci.c
+++ b/drivers/ata/libahci.c
@@ -68,7 +68,6 @@ static ssize_t ahci_transmit_led_message(struct ata_port *ap, u32 state,

 static int ahci_scr_read(struct ata_link *link, unsigned int sc_reg, u32 *val);
 static int ahci_scr_write(struct ata_link *link, unsigned int sc_reg, u32 val);
-static unsigned int ahci_qc_issue(struct ata_queued_cmd *qc);
 static bool ahci_qc_fill_rtf(struct ata_queued_cmd *qc);
 static int ahci_port_start(struct ata_port *ap);
 static void ahci_port_stop(struct ata_port *ap);
@@ -1952,7 +1951,7 @@ irqreturn_t ahci_interrupt(int irq, void *dev_instance)
 }
 EXPORT_SYMBOL_GPL(ahci_interrupt);

-static unsigned int ahci_qc_issue(struct ata_queued_cmd *qc)
+unsigned int ahci_qc_issue(struct ata_queued_cmd *qc)
 {
 	struct ata_port *ap = qc->ap;
 	void __iomem *port_mmio = ahci_port_base(ap);
@@ -1981,6 +1980,7 @@ static unsigned int ahci_qc_issue(struct ata_queued_cmd *qc)

 	return 0;
 }
+EXPORT_SYMBOL_GPL(ahci_qc_issue);

 static bool ahci_qc_fill_rtf(struct ata_queued_cmd *qc)
 {
--
1.8.2.1

