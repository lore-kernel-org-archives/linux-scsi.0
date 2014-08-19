From: Suman Tripathi <stripathi@apm.com>
Subject: [PATCH v7 3/3] ahci_xgene: Fix the link down in first attempt for the APM X-Gene SoC AHCI SATA host controller driver.
Date: Tue, 19 Aug 2014 12:01:51 +0530
Message-ID: <1408429911-1406-4-git-send-email-stripathi@apm.com>
References: <1408429911-1406-1-git-send-email-stripathi@apm.com>
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1408429911-1406-1-git-send-email-stripathi@apm.com>
Sender: linux-ide-owner@vger.kernel.org
To: olof@lixom.net, tj@kernel.org, arnd@arndb.de
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org, ddutile@redhat.com, jcm@redhat.com, patches@apm.com, Suman Tripathi <stripathi@apm.com>
List-Id: linux-scsi@vger.kernel.org

The link down issue in first attempt happens due to 2 H/W errata below:

1. Due to HW errata, during speed negotiation, sometimes controller
is not able to detect ALIGN at GEN3(6Gbps) within 54.6us results in
a timeout. This issue can be recovered by issuing a COMRESET again.

2. Due to HW errata, although ALIGH detection is successfull, due to
8b/10b and disparity BERR, sometimes the signature from the drive is
not received successfully by the Host controller. Due to this the
communication with the host and drive is not established due to
locking of CDR(clock and data recovery) circuit. This issue can be
recovered by issuing a COMRESET again.

This patch fixes the above issues by retrying the COMRESET with a
maximum attempts of 3.
---
 drivers/ata/ahci_xgene.c | 25 ++++++++++++++++++-------
 1 file changed, 18 insertions(+), 7 deletions(-)

diff --git a/drivers/ata/ahci_xgene.c b/drivers/ata/ahci_xgene.c
index 0a87f2e..294c9a8 100644
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
@@ -277,15 +280,23 @@ static int xgene_ahci_do_hardreset(struct ata_link *link,
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
+		if (*online)
+			break;
+
+		sata_scr_read(link, SCR_STATUS, &sstatus);
+	} while (link_down_retry++ < MAX_LINK_DOWN_RETRY &&
+		 (sstatus & 0xff) == 0x1);

 	val = readl(port_mmio + PORT_SCR_ERR);
 	if (val & (SERR_DISPARITY | SERR_10B_8B_ERR))
--
1.8.2.1

