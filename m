From: Suman Tripathi <stripathi@apm.com>
Subject: [PATCH] ahci_xgene: Fix the error print invalid resource for APM X-Gene SoC AHCI SATA Host Controller driver.
Date: Mon, 22 Sep 2014 18:31:33 +0530
Message-ID: <1411390893-22911-2-git-send-email-stripathi@apm.com>
References: <1411390893-22911-1-git-send-email-stripathi@apm.com>
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1411390893-22911-1-git-send-email-stripathi@apm.com>
Sender: linux-ide-owner@vger.kernel.org
To: olof@lixom.net, tj@kernel.org, arnd@arndb.de
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org, ddutile@redhat.com, jcm@redhat.com, patches@apm.com, Suman Tripathi <stripathi@apm.com>, Loc Ho <lho@apm.com>
List-Id: linux-scsi@vger.kernel.org

This patch fixes the error print invalid resource for the APM X-Gene
SoC AHCI SATA Host Controller driver. This print was due to the fact
that the controller 3 don't have a mux resource. This didn't result
in any errors but the print seems like meaningless.

Signed-off-by: Loc Ho <lho@apm.com>
Signed-off-by: Suman Tripathi <stripathi@apm.com>
---
 drivers/ata/ahci_xgene.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/ata/ahci_xgene.c b/drivers/ata/ahci_xgene.c
index 40d0a76..26f1f78 100644
--- a/drivers/ata/ahci_xgene.c
+++ b/drivers/ata/ahci_xgene.c
@@ -434,7 +434,7 @@ static int xgene_ahci_mux_select(struct xgene_ahci_context *ctx)
 	u32 val;

 	/* Check for optional MUX resource */
-	if (IS_ERR(ctx->csr_mux))
+	if (!ctx->csr_mux)
 		return 0;

 	val = readl(ctx->csr_mux + SATA_ENET_CONFIG_REG);
@@ -485,7 +485,13 @@ static int xgene_ahci_probe(struct platform_device *pdev)

 	/* Retrieve the optional IP mux resource */
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 4);
-	ctx->csr_mux = devm_ioremap_resource(dev, res);
+	if (res) {
+		void __iomem *csr = devm_ioremap_resource(dev, res);
+		if (IS_ERR(csr))
+			return PTR_ERR(csr);
+
+		ctx->csr_mux = csr;
+	}

 	dev_dbg(dev, "VAddr 0x%p Mmio VAddr 0x%p\n", ctx->csr_core,
 		hpriv->mmio);
--
1.8.2.1

