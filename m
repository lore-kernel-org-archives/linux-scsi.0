From: Suman Tripathi <stripathi@apm.com>
Subject: [PATCH v4 3/4] ata: Use correct OOB tunning parameters for APM X-Gene SoC AHCI SATA Host controller driver.
Date: Tue, 29 Jul 2014 12:24:51 +0530
Message-ID: <1406616892-30273-4-git-send-email-stripathi@apm.com>
References: <1406616892-30273-1-git-send-email-stripathi@apm.com>
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1406616892-30273-1-git-send-email-stripathi@apm.com>
Sender: linux-ide-owner@vger.kernel.org
To: olof@lixom.net, tj@kernel.org, arnd@arndb.de
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org, ddutile@redhat.com, jcm@redhat.com, patches@apm.com, Suman Tripathi <stripathi@apm.com>, Loc Ho <lho@apm.com>
List-Id: linux-scsi@vger.kernel.org

APM X-Gene SoC AHCI SATA Host controller driver requires
some correction of Phy Control OOB timing for the
COMINIT/COMWAKE parameters to correctly interoperate with
different kinds of disks.

Signed-off-by: Loc Ho <lho@apm.com>
Signed-off-by: Suman Tripathi <stripathi@apm.com>
---
 drivers/ata/ahci_xgene.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/ata/ahci_xgene.c b/drivers/ata/ahci_xgene.c
index 03b6b0f..1d48371 100644
--- a/drivers/ata/ahci_xgene.c
+++ b/drivers/ata/ahci_xgene.c
@@ -163,11 +163,11 @@ static void xgene_ahci_set_phy_cfg(struct xgene_ahci_context *ctx, int channel)
 	/* Disable fix rate */
 	writel(0x0001fffe, mmio + PORTPHY1CFG);
 	readl(mmio + PORTPHY1CFG); /* Force a barrier */
-	writel(0x5018461c, mmio + PORTPHY2CFG);
+	writel(0x28183219, mmio + PORTPHY2CFG);
 	readl(mmio + PORTPHY2CFG); /* Force a barrier */
-	writel(0x1c081907, mmio + PORTPHY3CFG);
+	writel(0x13081008, mmio + PORTPHY3CFG);
 	readl(mmio + PORTPHY3CFG); /* Force a barrier */
-	writel(0x1c080815, mmio + PORTPHY4CFG);
+	writel(0x00480815, mmio + PORTPHY4CFG);
 	readl(mmio + PORTPHY4CFG); /* Force a barrier */
 	/* Set window negotiation */
 	val = readl(mmio + PORTPHY5CFG);
--
1.8.2.1

