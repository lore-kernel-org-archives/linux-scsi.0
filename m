From: Suman Tripathi <stripathi@apm.com>
Subject: [PATCH v3 2/2] ata: Fix the dma state machine lockup for the IDENTIFY DEVICE PIO mode command.
Date: Thu, 19 Jun 2014 12:20:54 +0530
Message-ID: <1403160654-31612-1-git-send-email-stripathi@apm.com>
Return-path: <linux-ide-owner@vger.kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: olof@lixom.net, tj@kernel.org, arnd@arndb.de
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org, ddutile@redhat.com, jcm@redhat.com, patches@apm.com, Suman Tripathi <stripathi@apm.com>, Loc Ho <lho@apm.com>
List-Id: linux-scsi@vger.kernel.org

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
 drivers/ata/ahci_xgene.c | 70 +++++++++++++++++++++++++++++++++++++++---------
 drivers/ata/libahci.c    |  3 ++-
 3 files changed, 60 insertions(+), 14 deletions(-)

diff --git a/drivers/ata/ahci.h b/drivers/ata/ahci.h
index 3c1760e..011d1ea 100644
--- a/drivers/ata/ahci.h
+++ b/drivers/ata/ahci.h
@@ -373,6 +373,7 @@ int ahci_do_softreset(struct ata_link *link, unsigned int *class,
 int ahci_stop_engine(struct ata_port *ap);
 void ahci_start_engine(struct ata_port *ap);
 int ahci_restart_engine(struct ata_port *ap);
+void ahci_sw_activity(struct ata_link *link);
 int ahci_check_ready(struct ata_link *link);
 int ahci_kick_engine(struct ata_port *ap);
 int ahci_port_resume(struct ata_port *ap);
diff --git a/drivers/ata/ahci_xgene.c b/drivers/ata/ahci_xgene.c
index 77c89bf..4b074d5 100644
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
@@ -98,20 +99,72 @@ static int xgene_ahci_init_memram(struct xgene_ahci_context *ctx)
 }

 /**
+ * xgene_ahci_qc_issue - Issue commands to the device
+ * @qc: Command to issue
+ *
+ * Due to H/W errata, for the IENTIFY DEVICE command
+ * controller is unable to clear the BSY bit after
+ * receiving the PIO setup FIS and results the dma
+ * state machine to go into the CMFatalErrorUpdate
+ * state resulting in the dma state machine lockup.
+ * By restarting the dma engine to move it removes
+ * the controller out of lock up state.
+ */
+static unsigned int xgene_ahci_qc_issue(struct ata_queued_cmd *qc)
+{
+	struct ata_port *ap = qc->ap;
+	void __iomem *port_mmio = ahci_port_base(ap);
+	struct ahci_port_priv *pp = ap->private_data;
+	struct ahci_host_priv *hpriv = ap->host->private_data;
+	struct xgene_ahci_context *ctx = hpriv->plat_data;
+
+	/* Keep track of the currently active link.  It will be used
+	 * in completion path to determine whether NCQ phase is in
+	 * progress.
+	 */
+	pp->active_link = qc->dev->link;
+
+	/*
+	 * Restart the dma engine if the last cmd issued
+	 * is IDENTIFY DEVICE command
+	 */
+	if (unlikely(ctx->last_cmd[ap->port_no] == ATA_CMD_ID_ATA))
+		ahci_restart_engine(ap);
+
+	if (qc->tf.protocol == ATA_PROT_NCQ)
+		writel(1 << qc->tag, port_mmio + PORT_SCR_ACT);
+
+	if (pp->fbs_enabled && pp->fbs_last_dev != qc->dev->link->pmp) {
+		u32 fbs = readl(port_mmio + PORT_FBS);
+		fbs &= ~(PORT_FBS_DEV_MASK | PORT_FBS_DEC);
+		fbs |= qc->dev->link->pmp << PORT_FBS_DEV_OFFSET;
+		writel(fbs, port_mmio + PORT_FBS);
+		pp->fbs_last_dev = qc->dev->link->pmp;
+	}
+
+	writel(1 << qc->tag, port_mmio + PORT_CMD_ISSUE);
+
+	/* Save the last command issued */
+	ctx->last_cmd[ap->port_no] = qc->tf.command;
+
+	ahci_sw_activity(qc->dev->link);
+
+	return 0;
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
@@ -133,16 +186,6 @@ static unsigned int xgene_ahci_read_id(struct ata_device *dev,
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

@@ -300,6 +343,7 @@ static struct ata_port_operations xgene_ahci_ops = {
 	.host_stop = xgene_ahci_host_stop,
 	.hardreset = xgene_ahci_hardreset,
 	.read_id = xgene_ahci_read_id,
+	.qc_issue = xgene_ahci_qc_issue,
 };

 static const struct ata_port_info xgene_ahci_port_info = {
diff --git a/drivers/ata/libahci.c b/drivers/ata/libahci.c
index d1c9122..7605ff8 100644
--- a/drivers/ata/libahci.c
+++ b/drivers/ata/libahci.c
@@ -893,7 +893,7 @@ int ahci_reset_controller(struct ata_host *host)
 }
 EXPORT_SYMBOL_GPL(ahci_reset_controller);

-static void ahci_sw_activity(struct ata_link *link)
+void ahci_sw_activity(struct ata_link *link)
 {
 	struct ata_port *ap = link->ap;
 	struct ahci_port_priv *pp = ap->private_data;
@@ -906,6 +906,7 @@ static void ahci_sw_activity(struct ata_link *link)
 	if (!timer_pending(&emp->timer))
 		mod_timer(&emp->timer, jiffies + msecs_to_jiffies(10));
 }
+EXPORT_SYMBOL_GPL(ahci_sw_activity);

 static void ahci_sw_activity_blink(unsigned long arg)
 {
--
1.8.2.1

