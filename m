From: Suman Tripathi <stripathi@apm.com>
Subject: [PATCH v5 1/3] ahci_xgene: Removing NCQ support from the APM X-Gene SoC AHCI SATA Host Controller driver.
Date: Fri,  1 Aug 2014 23:07:16 +0530
Message-ID: <1406914638-24721-2-git-send-email-stripathi@apm.com>
References: <1406914638-24721-1-git-send-email-stripathi@apm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from denmail01-v4020.amcc.com ([192.195.68.30]:45981 "EHLO
	denmail01.apm.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755699AbaHARiw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Aug 2014 13:38:52 -0400
In-Reply-To: <1406914638-24721-1-git-send-email-stripathi@apm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: olof@lixom.net, tj@kernel.org, arnd@arndb.de
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org, ddutile@redhat.com, jcm@redhat.com, patches@apm.com, Suman Tripathi <stripathi@apm.com>, Loc Ho <lho@apm.com>

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

