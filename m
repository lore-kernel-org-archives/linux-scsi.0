From: Suman Tripathi <stripathi@apm.com>
Subject: [PATCH v1 2/2] ata: Fix the dma state machine lockup for the PIO mode commands.
Date: Thu, 12 Jun 2014 17:29:22 +0530
Message-ID: <1402574362-24986-3-git-send-email-stripathi@apm.com>
References: <1402574362-24986-1-git-send-email-stripathi@apm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from denmail01-v4020.amcc.com ([192.195.68.30]:60012 "EHLO
	denmail01.apm.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S934004AbaFLMBL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 12 Jun 2014 08:01:11 -0400
In-Reply-To: <1402574362-24986-1-git-send-email-stripathi@apm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: olof@lixom.net, tj@kernel.org, arnd@arndb.de
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org, ddutile@redhat.com, jcm@redhat.com, patches@apm.com, Suman Tripathi <stripathi@apm.com>, Loc Ho <lho@apm.com>

This patch fixes the dma state machine lockup due to the PIO mode
commands. The controller is unable to clear the BSY bit after
receiving the PIO setup FIS and results the dma state machine
to go into the CMFataErrorUpdate state resulting in dma
state machine lockup.

Signed-off-by: Loc Ho <lho@apm.com>
Signed-off-by: Suman Tripathi <stripathi@apm.com>
---
 drivers/ata/ahci.h       |  2 ++
 drivers/ata/ahci_xgene.c | 17 +++--------------
 drivers/ata/libahci.c    | 33 +++++++++++++++++++++++++++++++++
 3 files changed, 38 insertions(+), 14 deletions(-)

diff --git a/drivers/ata/ahci.h b/drivers/ata/ahci.h
index 3c1760e..1f911d1 100644
--- a/drivers/ata/ahci.h
+++ b/drivers/ata/ahci.h
@@ -237,6 +237,8 @@ enum {
 						        error-handling stage) */
 	AHCI_HFLAG_MULTI_MSI		= (1 << 16), /* multiple PCI MSIs */
 	AHCI_HFLAG_NO_DEVSLP		= (1 << 17), /* no device sleep */
+	AHCI_HFLAG_BROKEN_PIO_CMD	= (1 << 18), /* PIO cmds resulting in
+							HBA dma state lockup */

 	/* ap->flags bits */

diff --git a/drivers/ata/ahci_xgene.c b/drivers/ata/ahci_xgene.c
index 77c89bf..87e87a9 100644
--- a/drivers/ata/ahci_xgene.c
+++ b/drivers/ata/ahci_xgene.c
@@ -104,14 +104,12 @@ static int xgene_ahci_init_memram(struct xgene_ahci_context *ctx)
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
@@ -133,16 +131,6 @@ static unsigned int xgene_ahci_read_id(struct ata_device *dev,
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

@@ -303,7 +291,8 @@ static struct ata_port_operations xgene_ahci_ops = {
 };

 static const struct ata_port_info xgene_ahci_port_info = {
-	AHCI_HFLAGS(AHCI_HFLAG_NO_PMP | AHCI_HFLAG_YES_NCQ),
+	AHCI_HFLAGS(AHCI_HFLAG_NO_PMP | AHCI_HFLAG_YES_NCQ |
+		    AHCI_HFLAG_BROKEN_PIO_CMD),
 	.flags = AHCI_FLAG_COMMON | ATA_FLAG_NCQ,
 	.pio_mask = ATA_PIO4,
 	.udma_mask = ATA_UDMA6,
diff --git a/drivers/ata/libahci.c b/drivers/ata/libahci.c
index 3358ce9..06d26b0 100644
--- a/drivers/ata/libahci.c
+++ b/drivers/ata/libahci.c
@@ -1592,6 +1592,31 @@ static void ahci_fbs_dec_intr(struct ata_port *ap)
 		dev_err(ap->host->dev, "failed to clear device error\n");
 }

+int ahci_complete_pio_cmd(struct ata_port *ap, u32 cmd_done)
+{
+	struct ata_queued_cmd *qc;
+
+	while (cmd_done) {
+		unsigned int tag = __ffs(cmd_done);
+
+		qc = ata_qc_from_tag(ap, tag);
+		if (qc) {
+			/*
+			 * Some controller unable to clear the BSY bit after
+			 * receiving the PIO Setup FIS from device resulting
+			 * the DMA state to go into CMFatalErrorUpdate state.
+			 * So need to restart the dma engine to get the
+			 * controller out of this state.
+			 */
+			if (qc->tf.protocol == ATA_PROT_PIO)
+				ahci_restart_engine(ap);
+		}
+		cmd_done &= ~(1 << tag);
+	}
+
+	return 0;
+}
+
 static void ahci_error_intr(struct ata_port *ap, u32 irq_stat)
 {
 	struct ahci_host_priv *hpriv = ap->host->private_data;
@@ -1778,6 +1803,14 @@ static void ahci_handle_port_interrupt(struct ata_port *ap,
 	}


+	/* Due to HW errata, some controllers need special handling
+	 * of the completion of the PIO commands.
+	 */
+       	if (hpriv->flags & AHCI_HFLAG_BROKEN_PIO_CMD) {
+		u32 cmd_done = ap->qc_active ^ qc_active;
+		ahci_complete_pio_cmd(ap, cmd_done);
+	}
+
 	rc = ata_qc_complete_multiple(ap, qc_active);

 	/* while resetting, invalid completions are expected */
--
1.8.2.1

