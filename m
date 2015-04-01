From: Suman Tripathi <stripathi@apm.com>
Subject: [PATCH v1] ata: ahci_xgene: Add AHCI Support for second generation of APM X-Gene SoC
Date: Wed,  1 Apr 2015 20:18:02 +0530
Message-ID: <1427899682-10912-2-git-send-email-stripathi@apm.com>
References: <1427899682-10912-1-git-send-email-stripathi@apm.com>
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1427899682-10912-1-git-send-email-stripathi@apm.com>
Sender: linux-ide-owner@vger.kernel.org
To: olof@lixom.net, tj@kernel.org, arnd@arndb.de
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org, mlangsdo@redhat.com, jcm@redhat.com, patches@apm.com, Suman Tripathi <stripathi@apm.com>
List-Id: linux-scsi@vger.kernel.org

This patch enables full AHCI feature support for APM X-Gene SoC SATA host host
controller. The following errata's are removed:

1. 2a0bdff6b95 ("ahci-xgene: fix the dma state machine lockup for the
                 IDENTIFY DEVICE PIO mode command")
2. 09c32aaa368 ("ahci_xgene: Fix the dma state machine lockup for the
                 ATA_CMD_SMART PIO mode command")
3. 1540035da71 ("ahci_xgene: Implement the xgene_ahci_poll_reg_val to
                 support PMP")
4. a3a84bc7c88 ("ahci_xgene: Implement the workaround to support PMP
                 enumeration and discovery")
5. 1102407bb71 ("ahci_xgene: Fix the DMA state machine lockup for the
                 ATA_CMD_PACKET PIO mode command")
6. 72f79f9e35b ("ahci_xgene: Removing NCQ support from the APM X-Gene SoC
                 AHCI SATA Host Controller driver")

In addition, enable PMP support for second generation APM X-Gene SoC.

Signed-off-by : Suman Tripathi <stripathi@apm.com>
---
 drivers/ata/ahci_xgene.c | 21 ++++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

diff --git a/drivers/ata/ahci_xgene.c b/drivers/ata/ahci_xgene.c
index 2e8bb60..0be47b0 100644
--- a/drivers/ata/ahci_xgene.c
+++ b/drivers/ata/ahci_xgene.c
@@ -28,6 +28,8 @@
 #include <linux/of_address.h>
 #include <linux/of_irq.h>
 #include <linux/phy/phy.h>
+#include <asm/cputype.h>
+
 #include "ahci.h"

 #define DRV_NAME "xgene-ahci"
@@ -94,6 +96,11 @@ struct xgene_ahci_context {
 	void __iomem *csr_mux;		/* MUX CSR address of IP */
 };

+static bool xgene_ahci_version1(void)
+{
+	return MIDR_VARIANT(read_cpuid_id()) == 0 ? true : false;
+}
+
 static int xgene_ahci_init_memram(struct xgene_ahci_context *ctx)
 {
 	dev_dbg(ctx->dev, "Release memory from shutdown\n");
@@ -703,7 +710,19 @@ static int xgene_ahci_probe(struct platform_device *pdev)
 	/* Configure the host controller */
 	xgene_ahci_hw_init(hpriv);
 skip_clk_phy:
-	hpriv->flags = AHCI_HFLAG_NO_PMP | AHCI_HFLAG_NO_NCQ;
+
+	if (xgene_ahci_version1()) {
+		/*
+		 * Override the callbacks due to
+		 * XGENE1 ERRATA's.
+		 */
+		hpriv->flags |= AHCI_HFLAG_NO_NCQ;
+		xgene_ahci_ops.qc_issue = xgene_ahci_qc_issue;
+		xgene_ahci_ops.softreset = xgene_ahci_softreset;
+		xgene_ahci_ops.pmp_softreset = xgene_ahci_pmp_softreset;
+	} else {
+		hpriv->flags |= AHCI_HFLAG_YES_FBS;
+	}

 	rc = ahci_platform_init_host(pdev, hpriv, &xgene_ahci_port_info,
 				     &ahci_platform_sht);
--
1.8.2.1

