From: Suman Tripathi <stripathi@apm.com>
Subject: [PATCH v6 1/2] ahci_xgene: Removing NCQ support from the APM X-Gene SoC AHCI SATA Host Controller driver.
Date: Fri,  8 Aug 2014 21:44:25 +0530
Message-ID: <1407514466-25312-2-git-send-email-stripathi@apm.com>
References: <1407514466-25312-1-git-send-email-stripathi@apm.com>
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1407514466-25312-1-git-send-email-stripathi@apm.com>
Sender: linux-ide-owner@vger.kernel.org
To: olof@lixom.net, tj@kernel.org, arnd@arndb.de
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org, ddutile@redhat.com, jcm@redhat.com, patches@apm.com, Suman Tripathi <stripathi@apm.com>, Loc Ho <lho@apm.com>
List-Id: linux-scsi@vger.kernel.org

This patch removes the NCQ support from the APM X-Gene SoC AHCI
Host Controller driver as it doesn't support it.

Signed-off-by: Loc Ho <lho@apm.com>
Signed-off-by: Suman Tripathi <stripathi@apm.com>
---
 drivers/ata/ahci_xgene.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/ata/ahci_xgene.c b/drivers/ata/ahci_xgene.c
index 1cfbdca..f416495 100644
--- a/drivers/ata/ahci_xgene.c
+++ b/drivers/ata/ahci_xgene.c
@@ -344,7 +344,7 @@ static struct ata_port_operations xgene_ahci_ops = {
 };

 static const struct ata_port_info xgene_ahci_port_info = {
-	.flags = AHCI_FLAG_COMMON | ATA_FLAG_NCQ,
+	.flags = AHCI_FLAG_COMMON,
 	.pio_mask = ATA_PIO4,
 	.udma_mask = ATA_UDMA6,
 	.port_ops = &xgene_ahci_ops,
@@ -481,7 +481,7 @@ static int xgene_ahci_probe(struct platform_device *pdev)
 	/* Configure the host controller */
 	xgene_ahci_hw_init(hpriv);

-	hflags = AHCI_HFLAG_NO_PMP | AHCI_HFLAG_YES_NCQ;
+	hflags = AHCI_HFLAG_NO_PMP | AHCI_HFLAG_NO_NCQ;

 	rc = ahci_platform_init_host(pdev, hpriv, &xgene_ahci_port_info,
 				     hflags, 0, 0);
--
1.8.2.1

