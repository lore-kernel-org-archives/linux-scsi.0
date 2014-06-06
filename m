From: Suman Tripathi <stripathi@apm.com>
Subject: [PATCH v0 2/2] ata: Fix the dma state machine lockup for the PIO mode commands.
Date: Sat,  7 Jun 2014 02:58:54 +0530
Message-ID: <1402090134-23164-3-git-send-email-stripathi@apm.com>
References: <1402090134-23164-1-git-send-email-stripathi@apm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from denmail01-v4020.amcc.com ([192.195.68.30]:37775 "EHLO
	denmail01.apm.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752544AbaFFWIe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Jun 2014 18:08:34 -0400
In-Reply-To: <1402090134-23164-1-git-send-email-stripathi@apm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: tj@kernel.org, olof@lixom.net, arnd@arndb.de
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org, ddutile@redhat.com, jcm@redhat.com, patches@apm.com, Suman Tripathi <stripathi@apm.com>, Loc Ho <lho@apm.com>

This patches fixes the dma state machine lockup due to the PIO mode
commands. The contoller is unable to clear the BSY bit after receiving the
PIO Setup FIS and results the dma state machine to go into the
CMFatalErrorUpdate state resulting in dma state machine lockup.

Signed-off-by: Loc Ho <lho@apm.com>
Signed-off-by: Suman Tripathi <stripathi@apm.com>
---
 drivers/ata/ahci_xgene.c  | 17 +++--------------
 drivers/ata/libata-core.c | 10 ++++++++++
 include/linux/libata.h    |  2 ++
 3 files changed, 15 insertions(+), 14 deletions(-)

diff --git a/drivers/ata/ahci_xgene.c b/drivers/ata/ahci_xgene.c
index 77c89bf..ed6c60c 100644
--- a/drivers/ata/ahci_xgene.c
+++ b/drivers/ata/ahci_xgene.c
@@ -104,14 +104,12 @@ static int xgene_ahci_init_memram(struct xgene_ahci_context *ctx)
  * @id: data buffer
  *
  * This custom read ID function is required due to the fact that the HW
- * does not support DEVSLP and the controller state machine may get stuck
- * after processing the ID query command.
+ * does not support DEVSLP
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

@@ -304,7 +292,8 @@ static struct ata_port_operations xgene_ahci_ops = {

 static const struct ata_port_info xgene_ahci_port_info = {
 	AHCI_HFLAGS(AHCI_HFLAG_NO_PMP | AHCI_HFLAG_YES_NCQ),
-	.flags = AHCI_FLAG_COMMON | ATA_FLAG_NCQ,
+	.flags = AHCI_FLAG_COMMON | ATA_FLAG_NCQ |
+		 ATA_HORKAGE_BROKEN_PIO_CMD,
 	.pio_mask = ATA_PIO4,
 	.udma_mask = ATA_UDMA6,
 	.port_ops = &xgene_ahci_ops,
diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 18d97d5..a893ed8 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -5072,6 +5072,16 @@ int ata_qc_complete_multiple(struct ata_port *ap, u32 qc_active)
 		if (qc) {
 			ata_qc_complete(qc);
 			nr_done++;
+			/*
+			 * Some controller unable to clear the BSY bit after
+			 * receiving the PIO Setup FIS from device resulting
+			 * the DMA state to go into CMFatalErrorUpdate state.
+			 * So need to restart the dma engine to get the
+			 * controller out of this state.
+			 */
+			if ((ap->flags & ATA_HORKAGE_BROKEN_PIO_CMD) &&
+			    (qc->tf.protocol == ATA_PROT_PIO))
+				ap->ops->restart_engine(ap);
 		}
 		done_mask &= ~(1 << tag);
 	}
diff --git a/include/linux/libata.h b/include/linux/libata.h
index 42ab826..d16bbfa 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -421,6 +421,8 @@ enum {
 	ATA_HORKAGE_NO_NCQ_TRIM	= (1 << 19),	/* don't use queued TRIM */
 	ATA_HORKAGE_NOLPM	= (1 << 20),	/* don't use LPM */
 	ATA_HORKAGE_WD_BROKEN_LPM = (1 << 21),	/* some WDs have broken LPM */
+	ATA_HORKAGE_BROKEN_PIO_CMD = (1 << 22), /* PIO cmds resulting in
+						   HBA dma state lockup */

 	 /* DMA mask for user DMA control: User visible values; DO NOT
 	    renumber */
--
1.8.2.1

