From: Suman Tripathi <stripathi@apm.com>
Subject: [PATCH v8 3/3] ahci_xgene: Fix the link down in first attempt for the APM X-Gene SoC AHCI SATA host controller driver.
Date: Sun, 24 Aug 2014 00:07:27 +0530
Message-ID: <1408819047-17224-4-git-send-email-stripathi@apm.com>
References: <1408819047-17224-1-git-send-email-stripathi@apm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from denmail01-v4020.amcc.com ([192.195.68.30]:43183 "EHLO
	denmail01.apm.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751473AbaHWSi7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 23 Aug 2014 14:38:59 -0400
In-Reply-To: <1408819047-17224-1-git-send-email-stripathi@apm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: olof@lixom.net, tj@kernel.org, arnd@arndb.de
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org, ddutile@redhat.com, jcm@redhat.com, patches@apm.com, Suman Tripathi <stripathi@apm.com>

This patch addresses two HW erratas as described below by retrying the
COMRESET:

1. During speed negotiation, controller is not able to detect ALIGN
at GEN3(6Gbps) within 54.6us and results in a timeout. This issue can
be recovered by issuing a COMRESET.

2. Although ALIGN detection is successful, 8b/10b and disparity bit
errors can occur which result in the signature FIS not received
successfully by the Host controller. Due to this, the PHY communication
between the host and drive is not established because of CDR(clock and
data recovery) circuit doesn't lock. This issue can be recoverd by issuing
a COMRESET.

The above retries are issued only if the port status register PXSTATUS
reports device presence detected but PHY communication not established.
The maximum retry attempts are 3.
---
 drivers/ata/ahci_xgene.c | 25 ++++++++++++++++++-------
 1 file changed, 18 insertions(+), 7 deletions(-)

diff --git a/drivers/ata/ahci_xgene.c b/drivers/ata/ahci_xgene.c
index fd9c137..894fa33 100644
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
@@ -276,15 +279,23 @@ static int xgene_ahci_do_hardreset(struct ata_link *link,
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

