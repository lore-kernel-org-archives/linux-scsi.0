From: Suman Tripathi <stripathi@apm.com>
Subject: [PATCH v9 2/3] ahci_xgene: Skip the PHY and clock initialization if already configured by the firmware.
Date: Thu, 28 Aug 2014 14:51:21 +0530
Message-ID: <1409217682-5759-3-git-send-email-stripathi@apm.com>
References: <1409217682-5759-1-git-send-email-stripathi@apm.com>
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1409217682-5759-1-git-send-email-stripathi@apm.com>
Sender: linux-ide-owner@vger.kernel.org
To: olof@lixom.net, tj@kernel.org, arnd@arndb.de
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org, ddutile@redhat.com, jcm@redhat.com, patches@apm.com, Suman Tripathi <stripathi@apm.com>, Loc Ho <lho@apm.com>
List-Id: linux-scsi@vger.kernel.org

This patch implements the feature to skip the PHY and clock
initialization if it is already configured by the firmware.

Signed-off-by: Loc Ho <lho@apm.com>
Signed-off-by: Suman Tripathi <stripathi@apm.com>
---
 drivers/ata/ahci_xgene.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/ata/ahci_xgene.c b/drivers/ata/ahci_xgene.c
index f416495..c721887 100644
--- a/drivers/ata/ahci_xgene.c
+++ b/drivers/ata/ahci_xgene.c
@@ -145,6 +145,14 @@ static unsigned int xgene_ahci_qc_issue(struct ata_queued_cmd *qc)
 	return rc;
 }

+static bool xgene_ahci_is_memram_inited(struct xgene_ahci_context *ctx)
+{
+	void __iomem *diagcsr = ctx->csr_diag;
+
+	return (readl(diagcsr + CFG_MEM_RAM_SHUTDOWN) == 0 &&
+	        readl(diagcsr + BLOCK_MEM_RDY) == 0xFFFFFFFF);
+}
+
 /**
  * xgene_ahci_read_id - Read ID data from the specified device
  * @dev: device
@@ -468,6 +476,11 @@ static int xgene_ahci_probe(struct platform_device *pdev)
 		return -ENODEV;
 	}

+	if (xgene_ahci_is_memram_inited(ctx)) {
+		dev_info(dev, "skip clock and PHY initialization\n");
+		goto skip_clk_phy;
+	}
+
 	/* Due to errata, HW requires full toggle transition */
 	rc = ahci_platform_enable_clks(hpriv);
 	if (rc)
@@ -481,6 +494,8 @@ static int xgene_ahci_probe(struct platform_device *pdev)
 	/* Configure the host controller */
 	xgene_ahci_hw_init(hpriv);

+skip_clk_phy:
+
 	hflags = AHCI_HFLAG_NO_PMP | AHCI_HFLAG_NO_NCQ;

 	rc = ahci_platform_init_host(pdev, hpriv, &xgene_ahci_port_info,
--
1.8.2.1

