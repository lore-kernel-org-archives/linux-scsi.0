From: Suman Tripathi <stripathi@apm.com>
Subject: [PATCH v9 3/3] ahci_xgene: Fix the link down in first attempt for the APM X-Gene SoC AHCI SATA host controller driver.
Date: Thu, 28 Aug 2014 14:51:22 +0530
Message-ID: <1409217682-5759-4-git-send-email-stripathi@apm.com>
References: <1409217682-5759-1-git-send-email-stripathi@apm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from denmail01-v4020.amcc.com ([192.195.68.30]:56400 "EHLO
	denmail01.apm.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S965540AbaH1JX6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 28 Aug 2014 05:23:58 -0400
In-Reply-To: <1409217682-5759-1-git-send-email-stripathi@apm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: olof@lixom.net, tj@kernel.org, arnd@arndb.de
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org, ddutile@redhat.com, jcm@redhat.com, patches@apm.com, Suman Tripathi <stripathi@apm.com>, Loc Ho <lho@apm.com>

Due to HW errata the APM X-Gene AHCI SATA host controller reports link
down even if the device presence is detected. This issue is due to speed
negotiation failure. This patch implements the algorithm to retry the
COMRESET if PxSTAT register reports device presence detected but
PHY communication not established. The maximum retry attempts are 3.

This patch also fixes the code to match the algorithm for the printing
a warning message if the disparity error still exists after link up.

Signed-off-by: Loc Ho <lho@apm.com>
Signed-off-by: Suman Tripathi <stripathi@apm.com>
---
 drivers/ata/ahci_xgene.c | 48 ++++++++++++++++++++++++++++++++++--------------
 1 file changed, 34 insertions(+), 14 deletions(-)

diff --git a/drivers/ata/ahci_xgene.c b/drivers/ata/ahci_xgene.c
index c721887..40d0a76 100644
--- a/drivers/ata/ahci_xgene.c
+++ b/drivers/ata/ahci_xgene.c
@@ -78,6 +78,9 @@
 #define CFG_MEM_RAM_SHUTDOWN		0x00000070
 #define BLOCK_MEM_RDY			0x00000074

+/* Max retry for link down */
+#define MAX_LINK_DOWN_RETRY 3
+
 struct xgene_ahci_context {
 	struct ahci_host_priv *hpriv;
 	struct device *dev;
@@ -237,8 +240,11 @@ static void xgene_ahci_set_phy_cfg(struct xgene_ahci_context *ctx, int channel)
  * and Gen1 (1.5Gbps). Otherwise during long IO stress test, the PHY will
  * report disparity error and etc. In addition, during COMRESET, there can
  * be error reported in the register PORT_SCR_ERR. For SERR_DISPARITY and
- * SERR_10B_8B_ERR, the PHY receiver line must be reseted. The following
- * algorithm is followed to proper configure the hardware PHY during COMRESET:
+ * SERR_10B_8B_ERR, the PHY receiver line must be reseted. Also during long
+ * reboot cycle regression, sometimes the PHY reports link down even if the
+ * device is present because of speed negotiation failure. so need to retry
+ * the COMRESET to get the link up. The following algorithm is followed to
+ * proper configure the hardware PHY during COMRESET:
  *
  * Alg Part 1:
  * 1. Start the PHY at Gen3 speed (default setting)
@@ -254,9 +260,15 @@ static void xgene_ahci_set_phy_cfg(struct xgene_ahci_context *ctx, int channel)
  * Alg Part 2:
  * 1. On link up, if there are any SERR_DISPARITY and SERR_10B_8B_ERR error
  *    reported in the register PORT_SCR_ERR, then reset the PHY receiver line
- * 2. Go to Alg Part 3
+ * 2. Go to Alg Part 4
  *
  * Alg Part 3:
+ * 1. Check the PORT_SCR_STAT to see whether device presence detected but PHY
+ *    communication establishment failed and maximum link down attempts are
+ *    less than Max attempts 3 then goto Alg Part 1.
+ * 2. Go to Alg Part 4.
+ *
+ * Alg Part 4:
  * 1. Clear any pending from register PORT_SCR_ERR.
  *
  * NOTE: For the initial version, we will NOT support Gen1/Gen2. In addition
@@ -275,19 +287,27 @@ static int xgene_ahci_do_hardreset(struct ata_link *link,
 	u8 *d2h_fis = pp->rx_fis + RX_FIS_D2H_REG;
 	void __iomem *port_mmio = ahci_port_base(ap);
 	struct ata_taskfile tf;
+	int link_down_retry = 0;
 	int rc;
-	u32 val;
-
-	/* clear D2H reception area to properly wait for D2H FIS */
-	ata_tf_init(link->device, &tf);
-	tf.command = ATA_BUSY;
-	ata_tf_to_fis(&tf, 0, 0, d2h_fis);
-	rc = sata_link_hardreset(link, timing, deadline, online,
+	u32 val, sstatus;
+
+	do {
+		/* clear D2H reception area to properly wait for D2H FIS */
+		ata_tf_init(link->device, &tf);
+		tf.command = ATA_BUSY;
+		ata_tf_to_fis(&tf, 0, 0, d2h_fis);
+		rc = sata_link_hardreset(link, timing, deadline, online,
 				 ahci_check_ready);
-
-	val = readl(port_mmio + PORT_SCR_ERR);
-	if (val & (SERR_DISPARITY | SERR_10B_8B_ERR))
-		dev_warn(ctx->dev, "link has error\n");
+		if (*online) {
+			val = readl(port_mmio + PORT_SCR_ERR);
+			if (val & (SERR_DISPARITY | SERR_10B_8B_ERR))
+				dev_warn(ctx->dev, "link has error\n");
+			break;
+		}
+
+		sata_scr_read(link, SCR_STATUS, &sstatus);
+	} while (link_down_retry++ < MAX_LINK_DOWN_RETRY &&
+		 (sstatus & 0xff) == 0x1);

 	/* clear all errors if any pending */
 	val = readl(port_mmio + PORT_SCR_ERR);
--
1.8.2.1

