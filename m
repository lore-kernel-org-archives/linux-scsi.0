From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Subject: [PATCH] libata: remove ATA_FLAG_{SRST|SATA_RESET}
Date: Fri, 4 Feb 2011 21:58:48 +0300
Message-ID: <201102042158.48844.sshtylyov@ru.mvista.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-ide-owner@vger.kernel.org
To: linux-ide@vger.kernel.org, jgarzik@pobox.com
Cc: linux-scsi@vger.kernel.org, James.Bottomley@suse.de, brking@us.ibm.com
List-Id: linux-scsi@vger.kernel.org

These flags are marked as obsolete and the checks for them have been removed
by commit 294440887b32c58d220fb54b73b7a58079b78f20 (libata-sff: kill unused
ata_bus_reset()), so I think it's time to finally get rid of them...

Signed-off-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>

---
The patch is against the recent Linus' tree.

 drivers/ata/pata_acpi.c       |    2 +-
 drivers/ata/pata_sis.c        |    2 +-
 drivers/ata/sata_sx4.c        |    4 ++--
 drivers/scsi/ipr.c            |    4 ++--
 drivers/scsi/libsas/sas_ata.c |    4 ++--
 include/linux/libata.h        |    2 --
 6 files changed, 8 insertions(+), 10 deletions(-)

Index: linux-2.6/drivers/ata/pata_acpi.c
===================================================================
--- linux-2.6.orig/drivers/ata/pata_acpi.c
+++ linux-2.6/drivers/ata/pata_acpi.c
@@ -245,7 +245,7 @@ static struct ata_port_operations pacpi_
 static int pacpi_init_one (struct pci_dev *pdev, const struct pci_device_id *id)
 {
 	static const struct ata_port_info info = {
-		.flags		= ATA_FLAG_SLAVE_POSS | ATA_FLAG_SRST,
+		.flags		= ATA_FLAG_SLAVE_POSS,
 
 		.pio_mask	= ATA_PIO4,
 		.mwdma_mask	= ATA_MWDMA2,
Index: linux-2.6/drivers/ata/pata_sis.c
===================================================================
--- linux-2.6.orig/drivers/ata/pata_sis.c
+++ linux-2.6/drivers/ata/pata_sis.c
@@ -593,7 +593,7 @@ static const struct ata_port_info sis_in
 	.port_ops	= &sis_133_ops,
 };
 const struct ata_port_info sis_info133_for_sata = {
-	.flags		= ATA_FLAG_SLAVE_POSS | ATA_FLAG_SRST,
+	.flags		= ATA_FLAG_SLAVE_POSS,
 	.pio_mask	= ATA_PIO4,
 	/* No MWDMA */
 	.udma_mask	= ATA_UDMA6,
Index: linux-2.6/drivers/ata/sata_sx4.c
===================================================================
--- linux-2.6.orig/drivers/ata/sata_sx4.c
+++ linux-2.6/drivers/ata/sata_sx4.c
@@ -274,8 +274,8 @@ static const struct ata_port_info pdc_po
 	/* board_20621 */
 	{
 		.flags		= ATA_FLAG_SATA | ATA_FLAG_NO_LEGACY |
-				  ATA_FLAG_SRST | ATA_FLAG_MMIO |
-				  ATA_FLAG_NO_ATAPI | ATA_FLAG_PIO_POLLING,
+				  ATA_FLAG_MMIO | ATA_FLAG_NO_ATAPI |
+				  ATA_FLAG_PIO_POLLING,
 		.pio_mask	= ATA_PIO4,
 		.mwdma_mask	= ATA_MWDMA2,
 		.udma_mask	= ATA_UDMA6,
Index: linux-2.6/drivers/scsi/ipr.c
===================================================================
--- linux-2.6.orig/drivers/scsi/ipr.c
+++ linux-2.6/drivers/scsi/ipr.c
@@ -6219,8 +6219,8 @@ static struct ata_port_operations ipr_sa
 };
 
 static struct ata_port_info sata_port_info = {
-	.flags	= ATA_FLAG_SATA | ATA_FLAG_NO_LEGACY | ATA_FLAG_SATA_RESET |
-	ATA_FLAG_MMIO | ATA_FLAG_PIO_DMA,
+	.flags	= ATA_FLAG_SATA | ATA_FLAG_NO_LEGACY | ATA_FLAG_MMIO |
+		  ATA_FLAG_PIO_DMA,
 	.pio_mask	= 0x10, /* pio4 */
 	.mwdma_mask = 0x07,
 	.udma_mask	= 0x7f, /* udma0-6 */
Index: linux-2.6/drivers/scsi/libsas/sas_ata.c
===================================================================
--- linux-2.6.orig/drivers/scsi/libsas/sas_ata.c
+++ linux-2.6/drivers/scsi/libsas/sas_ata.c
@@ -362,8 +362,8 @@ static struct ata_port_operations sas_sa
 };
 
 static struct ata_port_info sata_port_info = {
-	.flags = ATA_FLAG_SATA | ATA_FLAG_NO_LEGACY | ATA_FLAG_SATA_RESET |
-		ATA_FLAG_MMIO | ATA_FLAG_PIO_DMA | ATA_FLAG_NCQ,
+	.flags = ATA_FLAG_SATA | ATA_FLAG_NO_LEGACY | ATA_FLAG_MMIO |
+		 ATA_FLAG_PIO_DMA | ATA_FLAG_NCQ,
 	.pio_mask = 0x1f, /* PIO0-4 */
 	.mwdma_mask = 0x07, /* MWDMA0-2 */
 	.udma_mask = ATA_UDMA6,
Index: linux-2.6/include/linux/libata.h
===================================================================
--- linux-2.6.orig/include/linux/libata.h
+++ linux-2.6/include/linux/libata.h
@@ -181,8 +181,6 @@ enum {
 	ATA_FLAG_SATA		= (1 << 1),
 	ATA_FLAG_NO_LEGACY	= (1 << 2), /* no legacy mode check */
 	ATA_FLAG_MMIO		= (1 << 3), /* use MMIO, not PIO */
-	ATA_FLAG_SRST		= (1 << 4), /* (obsolete) use ATA SRST, not E.D.D. */
-	ATA_FLAG_SATA_RESET	= (1 << 5), /* (obsolete) use COMRESET */
 	ATA_FLAG_NO_ATAPI	= (1 << 6), /* No ATAPI support */
 	ATA_FLAG_PIO_DMA	= (1 << 7), /* PIO cmds via DMA */
 	ATA_FLAG_PIO_LBA48	= (1 << 8), /* Host DMA engine is LBA28 only */
