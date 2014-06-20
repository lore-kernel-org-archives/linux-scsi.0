From: Suman Tripathi <stripathi@apm.com>
Subject: [PATCH v0 2/3] ata: Fix the link down in first attempt for the APM X-Gene SoC AHCI SATA host controller driver.
Date: Fri, 20 Jun 2014 14:02:26 +0530
Message-ID: <1403253147-14341-3-git-send-email-stripathi@apm.com>
References: <1403253147-14341-1-git-send-email-stripathi@apm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from denmail01-v4020.amcc.com ([192.195.68.30]:46583 "EHLO
	denmail01.apm.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S934834AbaFTId1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 20 Jun 2014 04:33:27 -0400
In-Reply-To: <1403253147-14341-1-git-send-email-stripathi@apm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: olof@lixom.net, tj@kernel.org, arnd@arndb.de
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org, ddutile@redhat.com, jcm@redhat.com, patches@apm.com, Suman Tripathi <stripathi@apm.com>, Loc Ho <lho@apm.com>

This patch fixes the link down issue by retry for the APM X-Gene SoC
SATA host controller driver. Due to board design issue and short margin
limitation, it is observed that once out of many thousands power cycle
test, the sata link may not link up.

Signed-off-by: Loc Ho <lho@apm.com>
Signed-off-by: Suman Tripathi <stripathi@apm.com>
---
 drivers/ata/ahci_xgene.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/ata/ahci_xgene.c b/drivers/ata/ahci_xgene.c
index 5f0f750..d43b6ce 100644
--- a/drivers/ata/ahci_xgene.c
+++ b/drivers/ata/ahci_xgene.c
@@ -79,6 +79,9 @@
 #define CFG_MEM_RAM_SHUTDOWN		0x00000070
 #define BLOCK_MEM_RDY			0x00000074

+/* Max retry for link down */
+#define MAX_LINK_DOWN_RETRY 3
+
 struct xgene_ahci_context {
 	struct ahci_host_priv *hpriv;
 	struct device *dev;
@@ -235,15 +238,21 @@ static int xgene_ahci_do_hardreset(struct ata_link *link,
 	u8 *d2h_fis = pp->rx_fis + RX_FIS_D2H_REG;
 	void __iomem *port_mmio = ahci_port_base(ap);
 	struct ata_taskfile tf;
+	int link_down_retry = 0;
 	int rc;
 	u32 val;

+hardreset_retry:
 	/* clear D2H reception area to properly wait for D2H FIS */
 	ata_tf_init(link->device, &tf);
 	tf.command = ATA_BUSY;
 	ata_tf_to_fis(&tf, 0, 0, d2h_fis);
 	rc = sata_link_hardreset(link, timing, deadline, online,
 				 ahci_check_ready);
+
+	if (!*online)
+		if (link_down_retry++ < MAX_LINK_DOWN_RETRY)
+			goto hardreset_retry;

 	val = readl(port_mmio + PORT_SCR_ERR);
 	if (val & (SERR_DISPARITY | SERR_10B_8B_ERR))
--
1.8.2.1

