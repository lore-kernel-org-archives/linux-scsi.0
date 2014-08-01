From: Suman Tripathi <stripathi@apm.com>
Subject: [PATCH v5 3/3] ahci_xgene: Skip the PHY and clock initialization if already configured by the firmware.
Date: Fri,  1 Aug 2014 23:07:18 +0530
Message-ID: <1406914638-24721-4-git-send-email-stripathi@apm.com>
References: <1406914638-24721-1-git-send-email-stripathi@apm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from denmail01-v4020.amcc.com ([192.195.68.30]:45970 "EHLO
	denmail01.apm.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755640AbaHARis (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Aug 2014 13:38:48 -0400
In-Reply-To: <1406914638-24721-1-git-send-email-stripathi@apm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: olof@lixom.net, tj@kernel.org, arnd@arndb.de
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org, ddutile@redhat.com, jcm@redhat.com, patches@apm.com, Suman Tripathi <stripathi@apm.com>, Loc Ho <lho@apm.com>

This patch implements the feature to skip the PHY and clock
initialization if it is already configured by the firmware.

Signed-off-by: Loc Ho <lho@apm.com>
Signed-off-by: Suman Tripathi <stripathi@apm.com>
---
 drivers/ata/ahci_xgene.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/drivers/ata/ahci_xgene.c b/drivers/ata/ahci_xgene.c
index f416495..0a87f2e 100644
--- a/drivers/ata/ahci_xgene.c
+++ b/drivers/ata/ahci_xgene.c
@@ -145,6 +145,16 @@ static unsigned int xgene_ahci_qc_issue(struct ata_queued_cmd *qc)
 	return rc;
 }

+static int xgene_ahci_is_memram_inited(struct xgene_ahci_context *ctx)
+{
+	void __iomem *diagcsr = ctx->csr_diag;
+
+	if (readl(diagcsr + CFG_MEM_RAM_SHUTDOWN) == 0 &&
+	    readl(diagcsr + BLOCK_MEM_RDY) == 0xFFFFFFFF)
+		return 1;
+	return 0;
+}
+
 /**
  * xgene_ahci_read_id - Read ID data from the specified device
  * @dev: device
@@ -468,6 +478,11 @@ static int xgene_ahci_probe(struct platform_device *pdev)
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
@@ -481,6 +496,8 @@ static int xgene_ahci_probe(struct platform_device *pdev)
 	/* Configure the host controller */
 	xgene_ahci_hw_init(hpriv);

+skip_clk_phy:
+
 	hflags = AHCI_HFLAG_NO_PMP | AHCI_HFLAG_NO_NCQ;

 	rc = ahci_platform_init_host(pdev, hpriv, &xgene_ahci_port_info,
--
1.8.2.1

