From: Suman Tripathi <stripathi@apm.com>
Subject: [PATCH v1 2/3] ata: Fix the link down in first attempt for the APM X-Gene SoC AHCI SATA host controller driver.
Date: Mon, 23 Jun 2014 15:45:37 +0530
Message-ID: <1403518538-30697-3-git-send-email-stripathi@apm.com>
References: <1403518538-30697-1-git-send-email-stripathi@apm.com>
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1403518538-30697-1-git-send-email-stripathi@apm.com>
Sender: linux-ide-owner@vger.kernel.org
To: olof@lixom.net, tj@kernel.org, arnd@arndb.de
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org, ddutile@redhat.com, jcm@redhat.com, patches@apm.com, Suman Tripathi <stripathi@apm.com>, Loc Ho <lho@apm.com>
List-Id: linux-scsi@vger.kernel.org

This patch fixes the link down issue by retry for the APM X-Gene SoC
SATA host controller driver. Due to board design issue and short margin
limitation, it is observed that once out of many thousands power cycle
test, the sata link may not link up.

Signed-off-by: Loc Ho <lho@apm.com>
Signed-off-by: Suman Tripathi <stripathi@apm.com>
---
 drivers/ata/ahci_xgene.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/drivers/ata/ahci_xgene.c b/drivers/ata/ahci_xgene.c
index 03b6b0f..cc26342 100644
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
@@ -234,15 +237,20 @@ static int xgene_ahci_do_hardreset(struct ata_link *link,
 	u8 *d2h_fis = pp->rx_fis + RX_FIS_D2H_REG;
 	void __iomem *port_mmio = ahci_port_base(ap);
 	struct ata_taskfile tf;
+	int link_down_retry = 0;
 	int rc;
 	u32 val;

-	/* clear D2H reception area to properly wait for D2H FIS */
-	ata_tf_init(link->device, &tf);
-	tf.command = ATA_BUSY;
-	ata_tf_to_fis(&tf, 0, 0, d2h_fis);
-	rc = sata_link_hardreset(link, timing, deadline, online,
+	do {
+		/* clear D2H reception area to properly wait for D2H FIS */
+		ata_tf_init(link->device, &tf);
+		tf.command = ATA_BUSY;
+		ata_tf_to_fis(&tf, 0, 0, d2h_fis);
+		rc = sata_link_hardreset(link, timing, deadline, online,
 				 ahci_check_ready);
+		if (*online)
+			break;
+	} while (link_down_retry++ < MAX_LINK_DOWN_RETRY);

 	val = readl(port_mmio + PORT_SCR_ERR);
 	if (val & (SERR_DISPARITY | SERR_10B_8B_ERR))
--
1.8.2.1

