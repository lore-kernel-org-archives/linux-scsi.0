From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Subject: [PATCH] libata: remove ATA_FLAG_MMIO
Date: Fri, 4 Feb 2011 22:02:30 +0300
Message-ID: <201102042202.30930.sshtylyov@ru.mvista.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-ide-owner@vger.kernel.org
To: linux-ide@vger.kernel.org, jgarzik@pobox.com
Cc: linux-scsi@vger.kernel.org, James.Bottomley@suse.de, brking@us.ibm.com, mikpe@it.uu.se
List-Id: linux-scsi@vger.kernel.org

Commit 0d5ff566779f894ca9937231a181eb31e4adff0e (libata: convert to iomap)
removed all checks of ATA_FLAG_MMIO but neglected to remove the flag itself.
Do it now, at last...

Signed-off-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>

---
The patch is against the recent Linus' tree plus 5 patches to
drivers/ata/sata_dwc_460ex.c that I've posted earlier.

 drivers/ata/ahci.c            |    2 +-
 drivers/ata/ahci.h            |    2 +-
 drivers/ata/libata-acpi.c     |    3 +--
 drivers/ata/pata_at32.c       |    2 +-
 drivers/ata/pata_bf54x.c      |    1 -
 drivers/ata/pata_ixp4xx_cf.c  |    2 +-
 drivers/ata/pata_macio.c      |    3 +--
 drivers/ata/pata_octeon_cf.c  |    4 ++--
 drivers/ata/pata_palmld.c     |    2 +-
 drivers/ata/pata_pdc2027x.c   |    6 ++----
 drivers/ata/pata_pxa.c        |    1 -
 drivers/ata/pata_rb532_cf.c   |    2 +-
 drivers/ata/pata_samsung_cf.c |    1 -
 drivers/ata/pata_scc.c        |    2 +-
 drivers/ata/pdc_adma.c        |    3 +--
 drivers/ata/sata_dwc_460ex.c  |    2 +-
 drivers/ata/sata_fsl.c        |    4 ++--
 drivers/ata/sata_mv.c         |    2 +-
 drivers/ata/sata_nv.c         |    2 +-
 drivers/ata/sata_promise.c    |    1 -
 drivers/ata/sata_qstor.c      |    2 +-
 drivers/ata/sata_sil.c        |    3 +--
 drivers/ata/sata_sil24.c      |    6 +++---
 drivers/ata/sata_svw.c        |   10 ++++------
 drivers/ata/sata_sx4.c        |    3 +--
 drivers/ata/sata_vsc.c        |    3 +--
 drivers/scsi/ipr.c            |    3 +--
 drivers/scsi/libsas/sas_ata.c |    4 ++--
 include/linux/libata.h        |    1 -
 29 files changed, 33 insertions(+), 49 deletions(-)

Index: linux-2.6/drivers/ata/ahci.c
===================================================================
--- linux-2.6.orig/drivers/ata/ahci.c
+++ linux-2.6/drivers/ata/ahci.c
@@ -176,7 +176,7 @@ static const struct ata_port_info ahci_p
 		AHCI_HFLAGS	(AHCI_HFLAG_NO_NCQ | AHCI_HFLAG_NO_MSI |
 				 AHCI_HFLAG_MV_PATA | AHCI_HFLAG_NO_PMP),
 		.flags		= ATA_FLAG_SATA | ATA_FLAG_NO_LEGACY |
-				  ATA_FLAG_MMIO | ATA_FLAG_PIO_DMA,
+				  ATA_FLAG_PIO_DMA,
 		.pio_mask	= ATA_PIO4,
 		.udma_mask	= ATA_UDMA6,
 		.port_ops	= &ahci_ops,
Index: linux-2.6/drivers/ata/ahci.h
===================================================================
--- linux-2.6.orig/drivers/ata/ahci.h
+++ linux-2.6/drivers/ata/ahci.h
@@ -214,7 +214,7 @@ enum {
 	/* ap->flags bits */
 
 	AHCI_FLAG_COMMON		= ATA_FLAG_SATA | ATA_FLAG_NO_LEGACY |
-					  ATA_FLAG_MMIO | ATA_FLAG_PIO_DMA |
+					  ATA_FLAG_PIO_DMA |
 					  ATA_FLAG_ACPI_SATA | ATA_FLAG_AN |
 					  ATA_FLAG_LPM,
 
Index: linux-2.6/drivers/ata/libata-acpi.c
===================================================================
--- linux-2.6.orig/drivers/ata/libata-acpi.c
+++ linux-2.6/drivers/ata/libata-acpi.c
@@ -660,8 +660,7 @@ static int ata_acpi_filter_tf(struct ata
  * @dev: target ATA device
  * @gtf: raw ATA taskfile register set (0x1f1 - 0x1f7)
  *
- * Outputs ATA taskfile to standard ATA host controller using MMIO
- * or PIO as indicated by the ATA_FLAG_MMIO flag.
+ * Outputs ATA taskfile to standard ATA host controller.
  * Writes the control, feature, nsect, lbal, lbam, and lbah registers.
  * Optionally (ATA_TFLAG_LBA48) writes hob_feature, hob_nsect,
  * hob_lbal, hob_lbam, and hob_lbah.
Index: linux-2.6/drivers/ata/pata_at32.c
===================================================================
--- linux-2.6.orig/drivers/ata/pata_at32.c
+++ linux-2.6/drivers/ata/pata_at32.c
@@ -194,7 +194,7 @@ static int __init pata_at32_init_one(str
 	/* Setup ATA bindings */
 	ap->ops	     = &at32_port_ops;
 	ap->pio_mask = PIO_MASK;
-	ap->flags   |= ATA_FLAG_MMIO | ATA_FLAG_SLAVE_POSS;
+	ap->flags   |= ATA_FLAG_SLAVE_POSS;
 
 	/*
 	 * Since all 8-bit taskfile transfers has to go on the lower
Index: linux-2.6/drivers/ata/pata_bf54x.c
===================================================================
--- linux-2.6.orig/drivers/ata/pata_bf54x.c
+++ linux-2.6/drivers/ata/pata_bf54x.c
@@ -1455,7 +1455,6 @@ static struct ata_port_operations bfin_p
 static struct ata_port_info bfin_port_info[] = {
 	{
 		.flags		= ATA_FLAG_SLAVE_POSS
-				| ATA_FLAG_MMIO
 				| ATA_FLAG_NO_LEGACY,
 		.pio_mask	= ATA_PIO4,
 		.mwdma_mask	= 0,
Index: linux-2.6/drivers/ata/pata_ixp4xx_cf.c
===================================================================
--- linux-2.6.orig/drivers/ata/pata_ixp4xx_cf.c
+++ linux-2.6/drivers/ata/pata_ixp4xx_cf.c
@@ -177,7 +177,7 @@ static __devinit int ixp4xx_pata_probe(s
 
 	ap->ops	= &ixp4xx_port_ops;
 	ap->pio_mask = ATA_PIO4;
-	ap->flags |= ATA_FLAG_MMIO | ATA_FLAG_NO_LEGACY | ATA_FLAG_NO_ATAPI;
+	ap->flags |= ATA_FLAG_NO_LEGACY | ATA_FLAG_NO_ATAPI;
 
 	ixp4xx_setup_port(ap, data, cs0->start, cs1->start);
 
Index: linux-2.6/drivers/ata/pata_macio.c
===================================================================
--- linux-2.6.orig/drivers/ata/pata_macio.c
+++ linux-2.6/drivers/ata/pata_macio.c
@@ -1053,8 +1053,7 @@ static int __devinit pata_macio_common_i
 	/* Allocate libata host for 1 port */
 	memset(&pinfo, 0, sizeof(struct ata_port_info));
 	pmac_macio_calc_timing_masks(priv, &pinfo);
-	pinfo.flags		= ATA_FLAG_SLAVE_POSS | ATA_FLAG_MMIO |
-				  ATA_FLAG_NO_LEGACY;
+	pinfo.flags		= ATA_FLAG_SLAVE_POSS | ATA_FLAG_NO_LEGACY;
 	pinfo.port_ops		= &pata_macio_ops;
 	pinfo.private_data	= priv;
 
Index: linux-2.6/drivers/ata/pata_octeon_cf.c
===================================================================
--- linux-2.6.orig/drivers/ata/pata_octeon_cf.c
+++ linux-2.6/drivers/ata/pata_octeon_cf.c
@@ -848,8 +848,8 @@ static int __devinit octeon_cf_probe(str
 	cf_port->ap = ap;
 	ap->ops = &octeon_cf_ops;
 	ap->pio_mask = ATA_PIO6;
-	ap->flags |= ATA_FLAG_MMIO | ATA_FLAG_NO_LEGACY
-		  | ATA_FLAG_NO_ATAPI | ATA_FLAG_PIO_POLLING;
+	ap->flags |= ATA_FLAG_NO_LEGACY | ATA_FLAG_NO_ATAPI
+ 		  | ATA_FLAG_PIO_POLLING;
 
 	base = cs0 + ocd->base_region_bias;
 	if (!ocd->is16bit) {
Index: linux-2.6/drivers/ata/pata_palmld.c
===================================================================
--- linux-2.6.orig/drivers/ata/pata_palmld.c
+++ linux-2.6/drivers/ata/pata_palmld.c
@@ -85,7 +85,7 @@ static __devinit int palmld_pata_probe(s
 	ap = host->ports[0];
 	ap->ops	= &palmld_port_ops;
 	ap->pio_mask = ATA_PIO4;
-	ap->flags |= ATA_FLAG_MMIO | ATA_FLAG_NO_LEGACY | ATA_FLAG_PIO_POLLING;
+	ap->flags |= ATA_FLAG_NO_LEGACY | ATA_FLAG_PIO_POLLING;
 
 	/* memory mapping voodoo */
 	ap->ioaddr.cmd_addr = mem + 0x10;
Index: linux-2.6/drivers/ata/pata_pdc2027x.c
===================================================================
--- linux-2.6.orig/drivers/ata/pata_pdc2027x.c
+++ linux-2.6/drivers/ata/pata_pdc2027x.c
@@ -150,8 +150,7 @@ static struct ata_port_operations pdc202
 static struct ata_port_info pdc2027x_port_info[] = {
 	/* PDC_UDMA_100 */
 	{
-		.flags		= ATA_FLAG_NO_LEGACY | ATA_FLAG_SLAVE_POSS |
-		                  ATA_FLAG_MMIO,
+		.flags		= ATA_FLAG_NO_LEGACY | ATA_FLAG_SLAVE_POSS,
 		.pio_mask	= ATA_PIO4,
 		.mwdma_mask	= ATA_MWDMA2,
 		.udma_mask	= ATA_UDMA5,
@@ -159,8 +158,7 @@ static struct ata_port_info pdc2027x_por
 	},
 	/* PDC_UDMA_133 */
 	{
-		.flags		= ATA_FLAG_NO_LEGACY | ATA_FLAG_SLAVE_POSS |
-                        	  ATA_FLAG_MMIO,
+		.flags		= ATA_FLAG_NO_LEGACY | ATA_FLAG_SLAVE_POSS,
 		.pio_mask	= ATA_PIO4,
 		.mwdma_mask	= ATA_MWDMA2,
 		.udma_mask	= ATA_UDMA6,
Index: linux-2.6/drivers/ata/pata_pxa.c
===================================================================
--- linux-2.6.orig/drivers/ata/pata_pxa.c
+++ linux-2.6/drivers/ata/pata_pxa.c
@@ -292,7 +292,6 @@ static int __devinit pxa_ata_probe(struc
 	ap->ops		= &pxa_ata_port_ops;
 	ap->pio_mask	= ATA_PIO4;
 	ap->mwdma_mask	= ATA_MWDMA2;
-	ap->flags	= ATA_FLAG_MMIO;
 
 	ap->ioaddr.cmd_addr	= devm_ioremap(&pdev->dev, cmd_res->start,
 						resource_size(cmd_res));
Index: linux-2.6/drivers/ata/pata_rb532_cf.c
===================================================================
--- linux-2.6.orig/drivers/ata/pata_rb532_cf.c
+++ linux-2.6/drivers/ata/pata_rb532_cf.c
@@ -91,7 +91,7 @@ static void rb532_pata_setup_ports(struc
 
 	ap->ops		= &rb532_pata_port_ops;
 	ap->pio_mask	= ATA_PIO4;
-	ap->flags	= ATA_FLAG_NO_LEGACY | ATA_FLAG_MMIO;
+	ap->flags	= ATA_FLAG_NO_LEGACY;
 
 	ap->ioaddr.cmd_addr	= info->iobase + RB500_CF_REG_BASE;
 	ap->ioaddr.ctl_addr	= info->iobase + RB500_CF_REG_CTRL;
Index: linux-2.6/drivers/ata/pata_samsung_cf.c
===================================================================
--- linux-2.6.orig/drivers/ata/pata_samsung_cf.c
+++ linux-2.6/drivers/ata/pata_samsung_cf.c
@@ -531,7 +531,6 @@ static int __init pata_s3c_probe(struct 
 	}
 
 	ap = host->ports[0];
-	ap->flags |= ATA_FLAG_MMIO;
 	ap->pio_mask = ATA_PIO4;
 
 	if (cpu_type == TYPE_S3C64XX) {
Index: linux-2.6/drivers/ata/pata_scc.c
===================================================================
--- linux-2.6.orig/drivers/ata/pata_scc.c
+++ linux-2.6/drivers/ata/pata_scc.c
@@ -959,7 +959,7 @@ static struct ata_port_operations scc_pa
 
 static struct ata_port_info scc_port_info[] = {
 	{
-		.flags		= ATA_FLAG_SLAVE_POSS | ATA_FLAG_MMIO | ATA_FLAG_NO_LEGACY,
+		.flags		= ATA_FLAG_SLAVE_POSS | ATA_FLAG_NO_LEGACY,
 		.pio_mask	= ATA_PIO4,
 		/* No MWDMA */
 		.udma_mask	= ATA_UDMA6,
Index: linux-2.6/drivers/ata/pdc_adma.c
===================================================================
--- linux-2.6.orig/drivers/ata/pdc_adma.c
+++ linux-2.6/drivers/ata/pdc_adma.c
@@ -167,8 +167,7 @@ static struct ata_port_info adma_port_in
 	/* board_1841_idx */
 	{
 		.flags		= ATA_FLAG_SLAVE_POSS |
-				  ATA_FLAG_NO_LEGACY | ATA_FLAG_MMIO |
-				  ATA_FLAG_PIO_POLLING,
+				  ATA_FLAG_NO_LEGACY | ATA_FLAG_PIO_POLLING,
 		.pio_mask	= ATA_PIO4_ONLY,
 		.udma_mask	= ATA_UDMA4,
 		.port_ops	= &adma_ata_ops,
Index: linux-2.6/drivers/ata/sata_dwc_460ex.c
===================================================================
--- linux-2.6.orig/drivers/ata/sata_dwc_460ex.c
+++ linux-2.6/drivers/ata/sata_dwc_460ex.c
@@ -1619,7 +1619,7 @@ static struct ata_port_operations sata_d
 static const struct ata_port_info sata_dwc_port_info[] = {
 	{
 		.flags		= ATA_FLAG_SATA | ATA_FLAG_NO_LEGACY |
-				  ATA_FLAG_MMIO | ATA_FLAG_NCQ,
+				  ATA_FLAG_NCQ,
 		.pio_mask	= ATA_PIO4,
 		.udma_mask	= ATA_UDMA6,
 		.port_ops	= &sata_dwc_ops,
Index: linux-2.6/drivers/ata/sata_fsl.c
===================================================================
--- linux-2.6.orig/drivers/ata/sata_fsl.c
+++ linux-2.6/drivers/ata/sata_fsl.c
@@ -34,8 +34,8 @@ enum {
 	SATA_FSL_MAX_PRD_DIRECT	= 16,	/* Direct PRDT entries */
 
 	SATA_FSL_HOST_FLAGS	= (ATA_FLAG_SATA | ATA_FLAG_NO_LEGACY |
-				ATA_FLAG_MMIO | ATA_FLAG_PIO_DMA |
-				ATA_FLAG_PMP | ATA_FLAG_NCQ | ATA_FLAG_AN),
+				ATA_FLAG_PIO_DMA | ATA_FLAG_PMP |
+				ATA_FLAG_NCQ | ATA_FLAG_AN),
 
 	SATA_FSL_MAX_CMDS	= SATA_FSL_QUEUE_DEPTH,
 	SATA_FSL_CMD_HDR_SIZE	= 16,	/* 4 DWORDS */
Index: linux-2.6/drivers/ata/sata_mv.c
===================================================================
--- linux-2.6.orig/drivers/ata/sata_mv.c
+++ linux-2.6/drivers/ata/sata_mv.c
@@ -161,7 +161,7 @@ enum {
 	MV_FLAG_DUAL_HC		= (1 << 30),  /* two SATA Host Controllers */
 
 	MV_COMMON_FLAGS		= ATA_FLAG_SATA | ATA_FLAG_NO_LEGACY |
-				  ATA_FLAG_MMIO | ATA_FLAG_PIO_POLLING,
+				  ATA_FLAG_PIO_POLLING,
 
 	MV_GEN_I_FLAGS		= MV_COMMON_FLAGS | ATA_FLAG_NO_ATAPI,
 
Index: linux-2.6/drivers/ata/sata_nv.c
===================================================================
--- linux-2.6.orig/drivers/ata/sata_nv.c
+++ linux-2.6/drivers/ata/sata_nv.c
@@ -567,7 +567,7 @@ static const struct ata_port_info nv_por
 	/* ADMA */
 	{
 		.flags		= ATA_FLAG_SATA | ATA_FLAG_NO_LEGACY |
-				  ATA_FLAG_MMIO | ATA_FLAG_NCQ,
+				  ATA_FLAG_NCQ,
 		.pio_mask	= NV_PIO_MASK,
 		.mwdma_mask	= NV_MWDMA_MASK,
 		.udma_mask	= NV_UDMA_MASK,
Index: linux-2.6/drivers/ata/sata_promise.c
===================================================================
--- linux-2.6.orig/drivers/ata/sata_promise.c
+++ linux-2.6/drivers/ata/sata_promise.c
@@ -135,7 +135,6 @@ enum {
 	PDC_RESET		= (1 << 11), /* HDMA reset */
 
 	PDC_COMMON_FLAGS	= ATA_FLAG_NO_LEGACY |
-				  ATA_FLAG_MMIO |
 				  ATA_FLAG_PIO_POLLING,
 
 	/* ap->flags bits */
Index: linux-2.6/drivers/ata/sata_qstor.c
===================================================================
--- linux-2.6.orig/drivers/ata/sata_qstor.c
+++ linux-2.6/drivers/ata/sata_qstor.c
@@ -156,7 +156,7 @@ static const struct ata_port_info qs_por
 	/* board_2068_idx */
 	{
 		.flags		= ATA_FLAG_SATA | ATA_FLAG_NO_LEGACY |
-				  ATA_FLAG_MMIO | ATA_FLAG_PIO_POLLING,
+				  ATA_FLAG_PIO_POLLING,
 		.pio_mask	= ATA_PIO4_ONLY,
 		.udma_mask	= ATA_UDMA6,
 		.port_ops	= &qs_ata_ops,
Index: linux-2.6/drivers/ata/sata_sil.c
===================================================================
--- linux-2.6.orig/drivers/ata/sata_sil.c
+++ linux-2.6/drivers/ata/sata_sil.c
@@ -61,8 +61,7 @@ enum {
 	SIL_FLAG_RERR_ON_DMA_ACT = (1 << 29),
 	SIL_FLAG_MOD15WRITE	= (1 << 30),
 
-	SIL_DFL_PORT_FLAGS	= ATA_FLAG_SATA | ATA_FLAG_NO_LEGACY |
-				  ATA_FLAG_MMIO,
+	SIL_DFL_PORT_FLAGS	= ATA_FLAG_SATA | ATA_FLAG_NO_LEGACY,
 
 	/*
 	 * Controller IDs
Index: linux-2.6/drivers/ata/sata_sil24.c
===================================================================
--- linux-2.6.orig/drivers/ata/sata_sil24.c
+++ linux-2.6/drivers/ata/sata_sil24.c
@@ -245,9 +245,9 @@ enum {
 
 	/* host flags */
 	SIL24_COMMON_FLAGS	= ATA_FLAG_SATA | ATA_FLAG_NO_LEGACY |
-				  ATA_FLAG_MMIO | ATA_FLAG_PIO_DMA |
-				  ATA_FLAG_NCQ | ATA_FLAG_ACPI_SATA |
-				  ATA_FLAG_AN | ATA_FLAG_PMP,
+				  ATA_FLAG_PIO_DMA | ATA_FLAG_NCQ |
+				  ATA_FLAG_ACPI_SATA | ATA_FLAG_AN |
+				  ATA_FLAG_PMP,
 	SIL24_FLAG_PCIX_IRQ_WOC	= (1 << 24), /* IRQ loss errata on PCI-X */
 
 	IRQ_STAT_4PORTS		= 0xf,
Index: linux-2.6/drivers/ata/sata_svw.c
===================================================================
--- linux-2.6.orig/drivers/ata/sata_svw.c
+++ linux-2.6/drivers/ata/sata_svw.c
@@ -360,7 +360,7 @@ static const struct ata_port_info k2_por
 	/* chip_svw4 */
 	{
 		.flags		= ATA_FLAG_SATA | ATA_FLAG_NO_LEGACY |
-				  ATA_FLAG_MMIO | K2_FLAG_NO_ATAPI_DMA,
+				  K2_FLAG_NO_ATAPI_DMA,
 		.pio_mask	= ATA_PIO4,
 		.mwdma_mask	= ATA_MWDMA2,
 		.udma_mask	= ATA_UDMA6,
@@ -369,8 +369,7 @@ static const struct ata_port_info k2_por
 	/* chip_svw8 */
 	{
 		.flags		= ATA_FLAG_SATA | ATA_FLAG_NO_LEGACY |
-				  ATA_FLAG_MMIO | K2_FLAG_NO_ATAPI_DMA |
-				  K2_FLAG_SATA_8_PORTS,
+				  K2_FLAG_NO_ATAPI_DMA | K2_FLAG_SATA_8_PORTS,
 		.pio_mask	= ATA_PIO4,
 		.mwdma_mask	= ATA_MWDMA2,
 		.udma_mask	= ATA_UDMA6,
@@ -379,7 +378,7 @@ static const struct ata_port_info k2_por
 	/* chip_svw42 */
 	{
 		.flags		= ATA_FLAG_SATA | ATA_FLAG_NO_LEGACY |
-				  ATA_FLAG_MMIO | K2_FLAG_BAR_POS_3,
+				  K2_FLAG_BAR_POS_3,
 		.pio_mask	= ATA_PIO4,
 		.mwdma_mask	= ATA_MWDMA2,
 		.udma_mask	= ATA_UDMA6,
@@ -387,8 +386,7 @@ static const struct ata_port_info k2_por
 	},
 	/* chip_svw43 */
 	{
-		.flags		= ATA_FLAG_SATA | ATA_FLAG_NO_LEGACY |
-				  ATA_FLAG_MMIO,
+		.flags		= ATA_FLAG_SATA | ATA_FLAG_NO_LEGACY,
 		.pio_mask	= ATA_PIO4,
 		.mwdma_mask	= ATA_MWDMA2,
 		.udma_mask	= ATA_UDMA6,
Index: linux-2.6/drivers/ata/sata_sx4.c
===================================================================
--- linux-2.6.orig/drivers/ata/sata_sx4.c
+++ linux-2.6/drivers/ata/sata_sx4.c
@@ -274,8 +274,7 @@ static const struct ata_port_info pdc_po
 	/* board_20621 */
 	{
 		.flags		= ATA_FLAG_SATA | ATA_FLAG_NO_LEGACY |
-				  ATA_FLAG_MMIO | ATA_FLAG_NO_ATAPI |
-				  ATA_FLAG_PIO_POLLING,
+				  ATA_FLAG_NO_ATAPI | ATA_FLAG_PIO_POLLING,
 		.pio_mask	= ATA_PIO4,
 		.mwdma_mask	= ATA_MWDMA2,
 		.udma_mask	= ATA_UDMA6,
Index: linux-2.6/drivers/ata/sata_vsc.c
===================================================================
--- linux-2.6.orig/drivers/ata/sata_vsc.c
+++ linux-2.6/drivers/ata/sata_vsc.c
@@ -340,8 +340,7 @@ static int __devinit vsc_sata_init_one(s
 				       const struct pci_device_id *ent)
 {
 	static const struct ata_port_info pi = {
-		.flags		= ATA_FLAG_SATA | ATA_FLAG_NO_LEGACY |
-				  ATA_FLAG_MMIO,
+		.flags		= ATA_FLAG_SATA | ATA_FLAG_NO_LEGACY,
 		.pio_mask	= ATA_PIO4,
 		.mwdma_mask	= ATA_MWDMA2,
 		.udma_mask	= ATA_UDMA6,
Index: linux-2.6/drivers/scsi/ipr.c
===================================================================
--- linux-2.6.orig/drivers/scsi/ipr.c
+++ linux-2.6/drivers/scsi/ipr.c
@@ -6219,8 +6219,7 @@ static struct ata_port_operations ipr_sa
 };
 
 static struct ata_port_info sata_port_info = {
-	.flags	= ATA_FLAG_SATA | ATA_FLAG_NO_LEGACY | ATA_FLAG_MMIO |
-		  ATA_FLAG_PIO_DMA,
+	.flags		= ATA_FLAG_SATA | ATA_FLAG_NO_LEGACY | ATA_FLAG_PIO_DMA,
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
-	.flags = ATA_FLAG_SATA | ATA_FLAG_NO_LEGACY | ATA_FLAG_MMIO |
-		 ATA_FLAG_PIO_DMA | ATA_FLAG_NCQ,
+	.flags = ATA_FLAG_SATA | ATA_FLAG_NO_LEGACY | ATA_FLAG_PIO_DMA |
+		 ATA_FLAG_NCQ,
 	.pio_mask = 0x1f, /* PIO0-4 */
 	.mwdma_mask = 0x07, /* MWDMA0-2 */
 	.udma_mask = ATA_UDMA6,
Index: linux-2.6/include/linux/libata.h
===================================================================
--- linux-2.6.orig/include/linux/libata.h
+++ linux-2.6/include/linux/libata.h
@@ -180,7 +180,6 @@ enum {
 					    /* (doesn't imply presence) */
 	ATA_FLAG_SATA		= (1 << 1),
 	ATA_FLAG_NO_LEGACY	= (1 << 2), /* no legacy mode check */
-	ATA_FLAG_MMIO		= (1 << 3), /* use MMIO, not PIO */
 	ATA_FLAG_NO_ATAPI	= (1 << 6), /* No ATAPI support */
 	ATA_FLAG_PIO_DMA	= (1 << 7), /* PIO cmds via DMA */
 	ATA_FLAG_PIO_LBA48	= (1 << 8), /* Host DMA engine is LBA28 only */
