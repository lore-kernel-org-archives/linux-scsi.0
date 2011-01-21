From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Subject: [PATCH] ipr/sas_ata: use mode mask macros from <linux/ata.h>
Date: Fri, 21 Jan 2011 20:32:01 +0300
Message-ID: <201101212032.01673.sshtylyov@ru.mvista.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-ide-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@suse.de
Cc: linux-ide@vger.kernel.org, brking@us.ibm.com
List-Id: linux-scsi@vger.kernel.org

Commit 14bdef982caeda19afe34010482867c18217c641 ([libata] convert drivers to
use ata.h mode mask defines) didn't convert these two libata driver outside
drivers/ata/...

Signed-off-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>

---
The patch is against the recent Linus' tree.

 drivers/scsi/ipr.c            |    6 +++---
 drivers/scsi/libsas/sas_ata.c |    4 ++--
 2 files changed, 5 insertions(+), 5 deletions(-)

Index: linux-2.6/drivers/scsi/ipr.c
===================================================================
--- linux-2.6.orig/drivers/scsi/ipr.c
+++ linux-2.6/drivers/scsi/ipr.c
@@ -6221,9 +6221,9 @@ static struct ata_port_operations ipr_sa
 static struct ata_port_info sata_port_info = {
 	.flags	= ATA_FLAG_SATA | ATA_FLAG_NO_LEGACY | ATA_FLAG_SATA_RESET |
 	ATA_FLAG_MMIO | ATA_FLAG_PIO_DMA,
-	.pio_mask	= 0x10, /* pio4 */
-	.mwdma_mask = 0x07,
-	.udma_mask	= 0x7f, /* udma0-6 */
+	.pio_mask	= ATA_PIO4_ONLY,
+	.mwdma_mask	= ATA_MWDMA2,
+	.udma_mask	= ATA_UDMA6,
 	.port_ops	= &ipr_sata_ops
 };
 
Index: linux-2.6/drivers/scsi/libsas/sas_ata.c
===================================================================
--- linux-2.6.orig/drivers/scsi/libsas/sas_ata.c
+++ linux-2.6/drivers/scsi/libsas/sas_ata.c
@@ -364,8 +364,8 @@ static struct ata_port_operations sas_sa
 static struct ata_port_info sata_port_info = {
 	.flags = ATA_FLAG_SATA | ATA_FLAG_NO_LEGACY | ATA_FLAG_SATA_RESET |
 		ATA_FLAG_MMIO | ATA_FLAG_PIO_DMA | ATA_FLAG_NCQ,
-	.pio_mask = 0x1f, /* PIO0-4 */
-	.mwdma_mask = 0x07, /* MWDMA0-2 */
+	.pio_mask = ATA_PIO4,
+	.mwdma_mask = ATA_MWDMA2,
 	.udma_mask = ATA_UDMA6,
 	.port_ops = &sas_sata_ops
 };
