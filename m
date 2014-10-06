From: Suman Tripathi <stripathi@apm.com>
Subject: (unknown)
Date: Mon,  6 Oct 2014 12:26:02 +0530
Message-ID: <1412578562-11749-1-git-send-email-stripathi@apm.com>
Return-path: <linux-ide-owner@vger.kernel.org>
Subject: 
Sender: linux-ide-owner@vger.kernel.org
To: olof@lixom.net, tj@kernel.org, arnd@arndb.de
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org, ddutile@redhat.com, jcm@redhat.com, patches@apm.com, Suman Tripathi <stripathi@apm.com>, Loc Ho <lho@apm.com>, Ben Hutchings <ben@decadent.org.uk>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>
List-Id: linux-scsi@vger.kernel.org

commit 72f79f9e35bd3f78ee8853f2fcacaa197d23ebac upstream.
Subject: [PATCH 3.16 350/357] ahci_xgene: Removing NCQ support from the APM X-Gene SoC AHCI SATA Host Controller driver.

This patch removes the NCQ support from the APM X-Gene SoC AHCI
Host Controller driver as it doesn't support it.

Signed-off-by: Loc Ho <lho@apm.com>
Signed-off-by: Suman Tripathi <stripathi@apm.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
[bwh: Backported to 3.16: host flags are passed to ahci_platform_init_host()]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Acked-by: Suman Tripathi <stripathi@apm.com>

---
 drivers/ata/ahci_xgene.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/ata/ahci_xgene.c
+++ b/drivers/ata/ahci_xgene.c
@@ -337,7 +337,7 @@ static struct ata_port_operations xgene_
 };
 
 static const struct ata_port_info xgene_ahci_port_info = {
-	.flags = AHCI_FLAG_COMMON | ATA_FLAG_NCQ,
+	.flags = AHCI_FLAG_COMMON,
 	.pio_mask = ATA_PIO4,
 	.udma_mask = ATA_UDMA6,
 	.port_ops = &xgene_ahci_ops,
@@ -484,7 +484,7 @@ static int xgene_ahci_probe(struct platf
 		goto disable_resources;
 	}
 
-	hflags = AHCI_HFLAG_NO_PMP | AHCI_HFLAG_YES_NCQ;
+	hflags = AHCI_HFLAG_NO_PMP | AHCI_HFLAG_NO_NCQ;
 
 	rc = ahci_platform_init_host(pdev, hpriv, &xgene_ahci_port_info,
 				     hflags, 0, 0);
