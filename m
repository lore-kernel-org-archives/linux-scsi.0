From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Subject: [PATCH 3/4] libata: remove ATA_FLAG_NO_LEGACY
Date: Fri, 4 Feb 2011 22:05:48 +0300
Message-ID: <201102042205.48834.sshtylyov@ru.mvista.com>
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

All checks of ATA_FLAG_NO_LEGACY have been removed by the commits
c791c30670ea61f19eec390124128bf278e854fe ([libata] minor PCI IDE probe
fixes and cleanups) and f0d36efdc624beb3d9e29b9ab9e9537bf0f25d5b (libata:
update libata core layer to use devres), so I think it's time to finally
get rid of this flag...

Signed-off-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>

---
The patch is against the recent Linus' tree plus 5 patches to
drivers/ata/sata_dwc_460ex.c that I've posted earlier.

 drivers/ata/ahci.c            |    3 +--
 drivers/ata/ahci.h            |    3 +--
 drivers/ata/pata_bf54x.c      |    3 +--
 drivers/ata/pata_ixp4xx_cf.c  |    2 +-
 drivers/ata/pata_macio.c      |    2 +-
 drivers/ata/pata_octeon_cf.c  |    3 +--
 drivers/ata/pata_palmld.c     |    2 +-
 drivers/ata/pata_pdc2027x.c   |    4 ++--
 drivers/ata/pata_rb532_cf.c   |    1 -
 drivers/ata/pata_scc.c        |    2 +-
 drivers/ata/pdc_adma.c        |    3 +--
 drivers/ata/sata_dwc_460ex.c  |    3 +--
 drivers/ata/sata_fsl.c        |    5 ++---
 drivers/ata/sata_mv.c         |    3 +--
 drivers/ata/sata_nv.c         |   14 ++++++--------
 drivers/ata/sata_promise.c    |    3 +--
 drivers/ata/sata_qstor.c      |    3 +--
 drivers/ata/sata_sil.c        |    2 +-
 drivers/ata/sata_sil24.c      |    7 +++----
 drivers/ata/sata_sis.c        |    2 +-
 drivers/ata/sata_svw.c        |   12 +++++-------
 drivers/ata/sata_sx4.c        |    4 ++--
 drivers/ata/sata_uli.c        |    3 +--
 drivers/ata/sata_via.c        |    9 ++++-----
 drivers/ata/sata_vsc.c        |    2 +-
 drivers/scsi/ipr.c            |    2 +-
 drivers/scsi/libsas/sas_ata.c |    3 +--
 include/linux/libata.h        |    1 -
 28 files changed, 43 insertions(+), 63 deletions(-)

Index: linux-2.6/drivers/ata/ahci.c
===================================================================
--- linux-2.6.orig/drivers/ata/ahci.c
+++ linux-2.6/drivers/ata/ahci.c
@@ -175,8 +175,7 @@ static const struct ata_port_info ahci_p
 	{
 		AHCI_HFLAGS	(AHCI_HFLAG_NO_NCQ | AHCI_HFLAG_NO_MSI |
 				 AHCI_HFLAG_MV_PATA | AHCI_HFLAG_NO_PMP),
-		.flags		= ATA_FLAG_SATA | ATA_FLAG_NO_LEGACY |
-				  ATA_FLAG_PIO_DMA,
+		.flags		= ATA_FLAG_SATA | ATA_FLAG_PIO_DMA,
 		.pio_mask	= ATA_PIO4,
 		.udma_mask	= ATA_UDMA6,
 		.port_ops	= &ahci_ops,
Index: linux-2.6/drivers/ata/ahci.h
===================================================================
--- linux-2.6.orig/drivers/ata/ahci.h
+++ linux-2.6/drivers/ata/ahci.h
@@ -213,8 +213,7 @@ enum {
 
 	/* ap->flags bits */
 
-	AHCI_FLAG_COMMON		= ATA_FLAG_SATA | ATA_FLAG_NO_LEGACY |
-					  ATA_FLAG_PIO_DMA |
+	AHCI_FLAG_COMMON		= ATA_FLAG_SATA | ATA_FLAG_PIO_DMA |
 					  ATA_FLAG_ACPI_SATA | ATA_FLAG_AN |
 					  ATA_FLAG_LPM,
 
Index: linux-2.6/drivers/ata/pata_bf54x.c
===================================================================
--- linux-2.6.orig/drivers/ata/pata_bf54x.c
+++ linux-2.6/drivers/ata/pata_bf54x.c
@@ -1454,8 +1454,7 @@ static struct ata_port_operations bfin_p
 
 static struct ata_port_info bfin_port_info[] = {
 	{
-		.flags		= ATA_FLAG_SLAVE_POSS
-				| ATA_FLAG_NO_LEGACY,
+		.flags		= ATA_FLAG_SLAVE_POSS,
 		.pio_mask	= ATA_PIO4,
 		.mwdma_mask	= 0,
 		.udma_mask	= 0,
Index: linux-2.6/drivers/ata/pata_ixp4xx_cf.c
===================================================================
--- linux-2.6.orig/drivers/ata/pata_ixp4xx_cf.c
+++ linux-2.6/drivers/ata/pata_ixp4xx_cf.c
@@ -177,7 +177,7 @@ static __devinit int ixp4xx_pata_probe(s
 
 	ap->ops	= &ixp4xx_port_ops;
 	ap->pio_mask = ATA_PIO4;
-	ap->flags |= ATA_FLAG_NO_LEGACY | ATA_FLAG_NO_ATAPI;
+	ap->flags |= ATA_FLAG_NO_ATAPI;
 
 	ixp4xx_setup_port(ap, data, cs0->start, cs1->start);
 
Index: linux-2.6/drivers/ata/pata_macio.c
===================================================================
--- linux-2.6.orig/drivers/ata/pata_macio.c
+++ linux-2.6/drivers/ata/pata_macio.c
@@ -1053,7 +1053,7 @@ static int __devinit pata_macio_common_i
 	/* Allocate libata host for 1 port */
 	memset(&pinfo, 0, sizeof(struct ata_port_info));
 	pmac_macio_calc_timing_masks(priv, &pinfo);
-	pinfo.flags		= ATA_FLAG_SLAVE_POSS | ATA_FLAG_NO_LEGACY;
+	pinfo.flags		= ATA_FLAG_SLAVE_POSS;
 	pinfo.port_ops		= &pata_macio_ops;
 	pinfo.private_data	= priv;
 
Index: linux-2.6/drivers/ata/pata_octeon_cf.c
===================================================================
--- linux-2.6.orig/drivers/ata/pata_octeon_cf.c
+++ linux-2.6/drivers/ata/pata_octeon_cf.c
@@ -848,8 +848,7 @@ static int __devinit octeon_cf_probe(str
 	cf_port->ap = ap;
 	ap->ops = &octeon_cf_ops;
 	ap->pio_mask = ATA_PIO6;
-	ap->flags |= ATA_FLAG_NO_LEGACY | ATA_FLAG_NO_ATAPI
- 		  | ATA_FLAG_PIO_POLLING;
+	ap->flags |= ATA_FLAG_NO_ATAPI | ATA_FLAG_PIO_POLLING;
 
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
-	ap->flags |= ATA_FLAG_NO_LEGACY | ATA_FLAG_PIO_POLLING;
+	ap->flags |= ATA_FLAG_PIO_POLLING;
 
 	/* memory mapping voodoo */
 	ap->ioaddr.cmd_addr = mem + 0x10;
Index: linux-2.6/drivers/ata/pata_pdc2027x.c
===================================================================
--- linux-2.6.orig/drivers/ata/pata_pdc2027x.c
+++ linux-2.6/drivers/ata/pata_pdc2027x.c
@@ -150,7 +150,7 @@ static struct ata_port_operations pdc202
 static struct ata_port_info pdc2027x_port_info[] = {
 	/* PDC_UDMA_100 */
 	{
-		.flags		= ATA_FLAG_NO_LEGACY | ATA_FLAG_SLAVE_POSS,
+		.flags		= ATA_FLAG_SLAVE_POSS,
 		.pio_mask	= ATA_PIO4,
 		.mwdma_mask	= ATA_MWDMA2,
 		.udma_mask	= ATA_UDMA5,
@@ -158,7 +158,7 @@ static struct ata_port_info pdc2027x_por
 	},
 	/* PDC_UDMA_133 */
 	{
-		.flags		= ATA_FLAG_NO_LEGACY | ATA_FLAG_SLAVE_POSS,
+		.flags		= ATA_FLAG_SLAVE_POSS,
 		.pio_mask	= ATA_PIO4,
 		.mwdma_mask	= ATA_MWDMA2,
 		.udma_mask	= ATA_UDMA6,
Index: linux-2.6/drivers/ata/pata_rb532_cf.c
===================================================================
--- linux-2.6.orig/drivers/ata/pata_rb532_cf.c
+++ linux-2.6/drivers/ata/pata_rb532_cf.c
@@ -91,7 +91,6 @@ static void rb532_pata_setup_ports(struc
 
 	ap->ops		= &rb532_pata_port_ops;
 	ap->pio_mask	= ATA_PIO4;
-	ap->flags	= ATA_FLAG_NO_LEGACY;
 
 	ap->ioaddr.cmd_addr	= info->iobase + RB500_CF_REG_BASE;
 	ap->ioaddr.ctl_addr	= info->iobase + RB500_CF_REG_CTRL;
Index: linux-2.6/drivers/ata/pata_scc.c
===================================================================
--- linux-2.6.orig/drivers/ata/pata_scc.c
+++ linux-2.6/drivers/ata/pata_scc.c
@@ -959,7 +959,7 @@ static struct ata_port_operations scc_pa
 
 static struct ata_port_info scc_port_info[] = {
 	{
-		.flags		= ATA_FLAG_SLAVE_POSS | ATA_FLAG_NO_LEGACY,
+		.flags		= ATA_FLAG_SLAVE_POSS,
 		.pio_mask	= ATA_PIO4,
 		/* No MWDMA */
 		.udma_mask	= ATA_UDMA6,
Index: linux-2.6/drivers/ata/pdc_adma.c
===================================================================
--- linux-2.6.orig/drivers/ata/pdc_adma.c
+++ linux-2.6/drivers/ata/pdc_adma.c
@@ -166,8 +166,7 @@ static struct ata_port_operations adma_a
 static struct ata_port_info adma_port_info[] = {
 	/* board_1841_idx */
 	{
-		.flags		= ATA_FLAG_SLAVE_POSS |
-				  ATA_FLAG_NO_LEGACY | ATA_FLAG_PIO_POLLING,
+		.flags		= ATA_FLAG_SLAVE_POSS | ATA_FLAG_PIO_POLLING,
 		.pio_mask	= ATA_PIO4_ONLY,
 		.udma_mask	= ATA_UDMA4,
 		.port_ops	= &adma_ata_ops,
Index: linux-2.6/drivers/ata/sata_dwc_460ex.c
===================================================================
--- linux-2.6.orig/drivers/ata/sata_dwc_460ex.c
+++ linux-2.6/drivers/ata/sata_dwc_460ex.c
@@ -1618,8 +1618,7 @@ static struct ata_port_operations sata_d
 
 static const struct ata_port_info sata_dwc_port_info[] = {
 	{
-		.flags		= ATA_FLAG_SATA | ATA_FLAG_NO_LEGACY |
-				  ATA_FLAG_NCQ,
+		.flags		= ATA_FLAG_SATA | ATA_FLAG_NCQ,
 		.pio_mask	= ATA_PIO4,
 		.udma_mask	= ATA_UDMA6,
 		.port_ops	= &sata_dwc_ops,
Index: linux-2.6/drivers/ata/sata_fsl.c
===================================================================
--- linux-2.6.orig/drivers/ata/sata_fsl.c
+++ linux-2.6/drivers/ata/sata_fsl.c
@@ -33,9 +33,8 @@ enum {
 	SATA_FSL_MAX_PRD_USABLE	= SATA_FSL_MAX_PRD - 1,
 	SATA_FSL_MAX_PRD_DIRECT	= 16,	/* Direct PRDT entries */
 
-	SATA_FSL_HOST_FLAGS	= (ATA_FLAG_SATA | ATA_FLAG_NO_LEGACY |
-				ATA_FLAG_PIO_DMA | ATA_FLAG_PMP |
-				ATA_FLAG_NCQ | ATA_FLAG_AN),
+	SATA_FSL_HOST_FLAGS	= (ATA_FLAG_SATA | ATA_FLAG_PIO_DMA |
+				ATA_FLAG_PMP | ATA_FLAG_NCQ | ATA_FLAG_AN),
 
 	SATA_FSL_MAX_CMDS	= SATA_FSL_QUEUE_DEPTH,
 	SATA_FSL_CMD_HDR_SIZE	= 16,	/* 4 DWORDS */
Index: linux-2.6/drivers/ata/sata_mv.c
===================================================================
--- linux-2.6.orig/drivers/ata/sata_mv.c
+++ linux-2.6/drivers/ata/sata_mv.c
@@ -160,8 +160,7 @@ enum {
 	/* Host Flags */
 	MV_FLAG_DUAL_HC		= (1 << 30),  /* two SATA Host Controllers */
 
-	MV_COMMON_FLAGS		= ATA_FLAG_SATA | ATA_FLAG_NO_LEGACY |
-				  ATA_FLAG_PIO_POLLING,
+	MV_COMMON_FLAGS		= ATA_FLAG_SATA | ATA_FLAG_PIO_POLLING,
 
 	MV_GEN_I_FLAGS		= MV_COMMON_FLAGS | ATA_FLAG_NO_ATAPI,
 
Index: linux-2.6/drivers/ata/sata_nv.c
===================================================================
--- linux-2.6.orig/drivers/ata/sata_nv.c
+++ linux-2.6/drivers/ata/sata_nv.c
@@ -539,7 +539,7 @@ struct nv_pi_priv {
 static const struct ata_port_info nv_port_info[] = {
 	/* generic */
 	{
-		.flags		= ATA_FLAG_SATA | ATA_FLAG_NO_LEGACY,
+		.flags		= ATA_FLAG_SATA,
 		.pio_mask	= NV_PIO_MASK,
 		.mwdma_mask	= NV_MWDMA_MASK,
 		.udma_mask	= NV_UDMA_MASK,
@@ -548,7 +548,7 @@ static const struct ata_port_info nv_por
 	},
 	/* nforce2/3 */
 	{
-		.flags		= ATA_FLAG_SATA | ATA_FLAG_NO_LEGACY,
+		.flags		= ATA_FLAG_SATA,
 		.pio_mask	= NV_PIO_MASK,
 		.mwdma_mask	= NV_MWDMA_MASK,
 		.udma_mask	= NV_UDMA_MASK,
@@ -557,7 +557,7 @@ static const struct ata_port_info nv_por
 	},
 	/* ck804 */
 	{
-		.flags		= ATA_FLAG_SATA | ATA_FLAG_NO_LEGACY,
+		.flags		= ATA_FLAG_SATA,
 		.pio_mask	= NV_PIO_MASK,
 		.mwdma_mask	= NV_MWDMA_MASK,
 		.udma_mask	= NV_UDMA_MASK,
@@ -566,8 +566,7 @@ static const struct ata_port_info nv_por
 	},
 	/* ADMA */
 	{
-		.flags		= ATA_FLAG_SATA | ATA_FLAG_NO_LEGACY |
-				  ATA_FLAG_NCQ,
+		.flags		= ATA_FLAG_SATA | ATA_FLAG_NCQ,
 		.pio_mask	= NV_PIO_MASK,
 		.mwdma_mask	= NV_MWDMA_MASK,
 		.udma_mask	= NV_UDMA_MASK,
@@ -576,7 +575,7 @@ static const struct ata_port_info nv_por
 	},
 	/* MCP5x */
 	{
-		.flags		= ATA_FLAG_SATA | ATA_FLAG_NO_LEGACY,
+		.flags		= ATA_FLAG_SATA,
 		.pio_mask	= NV_PIO_MASK,
 		.mwdma_mask	= NV_MWDMA_MASK,
 		.udma_mask	= NV_UDMA_MASK,
@@ -585,8 +584,7 @@ static const struct ata_port_info nv_por
 	},
 	/* SWNCQ */
 	{
-		.flags	        = ATA_FLAG_SATA | ATA_FLAG_NO_LEGACY |
-				  ATA_FLAG_NCQ,
+		.flags	        = ATA_FLAG_SATA | ATA_FLAG_NCQ,
 		.pio_mask	= NV_PIO_MASK,
 		.mwdma_mask	= NV_MWDMA_MASK,
 		.udma_mask	= NV_UDMA_MASK,
Index: linux-2.6/drivers/ata/sata_promise.c
===================================================================
--- linux-2.6.orig/drivers/ata/sata_promise.c
+++ linux-2.6/drivers/ata/sata_promise.c
@@ -134,8 +134,7 @@ enum {
 	PDC_IRQ_DISABLE		= (1 << 10),
 	PDC_RESET		= (1 << 11), /* HDMA reset */
 
-	PDC_COMMON_FLAGS	= ATA_FLAG_NO_LEGACY |
-				  ATA_FLAG_PIO_POLLING,
+	PDC_COMMON_FLAGS	= ATA_FLAG_PIO_POLLING,
 
 	/* ap->flags bits */
 	PDC_FLAG_GEN_II		= (1 << 24),
Index: linux-2.6/drivers/ata/sata_qstor.c
===================================================================
--- linux-2.6.orig/drivers/ata/sata_qstor.c
+++ linux-2.6/drivers/ata/sata_qstor.c
@@ -155,8 +155,7 @@ static struct ata_port_operations qs_ata
 static const struct ata_port_info qs_port_info[] = {
 	/* board_2068_idx */
 	{
-		.flags		= ATA_FLAG_SATA | ATA_FLAG_NO_LEGACY |
-				  ATA_FLAG_PIO_POLLING,
+		.flags		= ATA_FLAG_SATA | ATA_FLAG_PIO_POLLING,
 		.pio_mask	= ATA_PIO4_ONLY,
 		.udma_mask	= ATA_UDMA6,
 		.port_ops	= &qs_ata_ops,
Index: linux-2.6/drivers/ata/sata_sil.c
===================================================================
--- linux-2.6.orig/drivers/ata/sata_sil.c
+++ linux-2.6/drivers/ata/sata_sil.c
@@ -61,7 +61,7 @@ enum {
 	SIL_FLAG_RERR_ON_DMA_ACT = (1 << 29),
 	SIL_FLAG_MOD15WRITE	= (1 << 30),
 
-	SIL_DFL_PORT_FLAGS	= ATA_FLAG_SATA | ATA_FLAG_NO_LEGACY,
+	SIL_DFL_PORT_FLAGS	= ATA_FLAG_SATA,
 
 	/*
 	 * Controller IDs
Index: linux-2.6/drivers/ata/sata_sil24.c
===================================================================
--- linux-2.6.orig/drivers/ata/sata_sil24.c
+++ linux-2.6/drivers/ata/sata_sil24.c
@@ -244,10 +244,9 @@ enum {
 	BID_SIL3131		= 2,
 
 	/* host flags */
-	SIL24_COMMON_FLAGS	= ATA_FLAG_SATA | ATA_FLAG_NO_LEGACY |
-				  ATA_FLAG_PIO_DMA | ATA_FLAG_NCQ |
-				  ATA_FLAG_ACPI_SATA | ATA_FLAG_AN |
-				  ATA_FLAG_PMP,
+	SIL24_COMMON_FLAGS	= ATA_FLAG_SATA | ATA_FLAG_PIO_DMA |
+				  ATA_FLAG_NCQ | ATA_FLAG_ACPI_SATA |
+				  ATA_FLAG_AN | ATA_FLAG_PMP,
 	SIL24_FLAG_PCIX_IRQ_WOC	= (1 << 24), /* IRQ loss errata on PCI-X */
 
 	IRQ_STAT_4PORTS		= 0xf,
Index: linux-2.6/drivers/ata/sata_sis.c
===================================================================
--- linux-2.6.orig/drivers/ata/sata_sis.c
+++ linux-2.6/drivers/ata/sata_sis.c
@@ -96,7 +96,7 @@ static struct ata_port_operations sis_op
 };
 
 static const struct ata_port_info sis_port_info = {
-	.flags		= ATA_FLAG_SATA | ATA_FLAG_NO_LEGACY,
+	.flags		= ATA_FLAG_SATA,
 	.pio_mask	= ATA_PIO4,
 	.mwdma_mask	= ATA_MWDMA2,
 	.udma_mask	= ATA_UDMA6,
Index: linux-2.6/drivers/ata/sata_svw.c
===================================================================
--- linux-2.6.orig/drivers/ata/sata_svw.c
+++ linux-2.6/drivers/ata/sata_svw.c
@@ -359,8 +359,7 @@ static struct ata_port_operations k2_sat
 static const struct ata_port_info k2_port_info[] = {
 	/* chip_svw4 */
 	{
-		.flags		= ATA_FLAG_SATA | ATA_FLAG_NO_LEGACY |
-				  K2_FLAG_NO_ATAPI_DMA,
+		.flags		= ATA_FLAG_SATA | K2_FLAG_NO_ATAPI_DMA,
 		.pio_mask	= ATA_PIO4,
 		.mwdma_mask	= ATA_MWDMA2,
 		.udma_mask	= ATA_UDMA6,
@@ -368,8 +367,8 @@ static const struct ata_port_info k2_por
 	},
 	/* chip_svw8 */
 	{
-		.flags		= ATA_FLAG_SATA | ATA_FLAG_NO_LEGACY |
-				  K2_FLAG_NO_ATAPI_DMA | K2_FLAG_SATA_8_PORTS,
+		.flags		= ATA_FLAG_SATA | K2_FLAG_NO_ATAPI_DMA |
+				  K2_FLAG_SATA_8_PORTS,
 		.pio_mask	= ATA_PIO4,
 		.mwdma_mask	= ATA_MWDMA2,
 		.udma_mask	= ATA_UDMA6,
@@ -377,8 +376,7 @@ static const struct ata_port_info k2_por
 	},
 	/* chip_svw42 */
 	{
-		.flags		= ATA_FLAG_SATA | ATA_FLAG_NO_LEGACY |
-				  K2_FLAG_BAR_POS_3,
+		.flags		= ATA_FLAG_SATA | K2_FLAG_BAR_POS_3,
 		.pio_mask	= ATA_PIO4,
 		.mwdma_mask	= ATA_MWDMA2,
 		.udma_mask	= ATA_UDMA6,
@@ -386,7 +384,7 @@ static const struct ata_port_info k2_por
 	},
 	/* chip_svw43 */
 	{
-		.flags		= ATA_FLAG_SATA | ATA_FLAG_NO_LEGACY,
+		.flags		= ATA_FLAG_SATA,
 		.pio_mask	= ATA_PIO4,
 		.mwdma_mask	= ATA_MWDMA2,
 		.udma_mask	= ATA_UDMA6,
Index: linux-2.6/drivers/ata/sata_sx4.c
===================================================================
--- linux-2.6.orig/drivers/ata/sata_sx4.c
+++ linux-2.6/drivers/ata/sata_sx4.c
@@ -273,8 +273,8 @@ static struct ata_port_operations pdc_20
 static const struct ata_port_info pdc_port_info[] = {
 	/* board_20621 */
 	{
-		.flags		= ATA_FLAG_SATA | ATA_FLAG_NO_LEGACY |
-				  ATA_FLAG_NO_ATAPI | ATA_FLAG_PIO_POLLING,
+		.flags		= ATA_FLAG_SATA | ATA_FLAG_NO_ATAPI |
+				  ATA_FLAG_PIO_POLLING,
 		.pio_mask	= ATA_PIO4,
 		.mwdma_mask	= ATA_MWDMA2,
 		.udma_mask	= ATA_UDMA6,
Index: linux-2.6/drivers/ata/sata_uli.c
===================================================================
--- linux-2.6.orig/drivers/ata/sata_uli.c
+++ linux-2.6/drivers/ata/sata_uli.c
@@ -88,8 +88,7 @@ static struct ata_port_operations uli_op
 };
 
 static const struct ata_port_info uli_port_info = {
-	.flags		= ATA_FLAG_SATA | ATA_FLAG_NO_LEGACY |
-			  ATA_FLAG_IGN_SIMPLEX,
+	.flags		= ATA_FLAG_SATA | ATA_FLAG_IGN_SIMPLEX,
 	.pio_mask       = ATA_PIO4,
 	.udma_mask      = ATA_UDMA6,
 	.port_ops       = &uli_ops,
Index: linux-2.6/drivers/ata/sata_via.c
===================================================================
--- linux-2.6.orig/drivers/ata/sata_via.c
+++ linux-2.6/drivers/ata/sata_via.c
@@ -148,7 +148,7 @@ static struct ata_port_operations vt8251
 };
 
 static const struct ata_port_info vt6420_port_info = {
-	.flags		= ATA_FLAG_SATA | ATA_FLAG_NO_LEGACY,
+	.flags		= ATA_FLAG_SATA,
 	.pio_mask	= ATA_PIO4,
 	.mwdma_mask	= ATA_MWDMA2,
 	.udma_mask	= ATA_UDMA6,
@@ -156,7 +156,7 @@ static const struct ata_port_info vt6420
 };
 
 static struct ata_port_info vt6421_sport_info = {
-	.flags		= ATA_FLAG_SATA | ATA_FLAG_NO_LEGACY,
+	.flags		= ATA_FLAG_SATA,
 	.pio_mask	= ATA_PIO4,
 	.mwdma_mask	= ATA_MWDMA2,
 	.udma_mask	= ATA_UDMA6,
@@ -164,7 +164,7 @@ static struct ata_port_info vt6421_sport
 };
 
 static struct ata_port_info vt6421_pport_info = {
-	.flags		= ATA_FLAG_SLAVE_POSS | ATA_FLAG_NO_LEGACY,
+	.flags		= ATA_FLAG_SLAVE_POSS,
 	.pio_mask	= ATA_PIO4,
 	/* No MWDMA */
 	.udma_mask	= ATA_UDMA6,
@@ -172,8 +172,7 @@ static struct ata_port_info vt6421_pport
 };
 
 static struct ata_port_info vt8251_port_info = {
-	.flags		= ATA_FLAG_SATA | ATA_FLAG_SLAVE_POSS |
-			  ATA_FLAG_NO_LEGACY,
+	.flags		= ATA_FLAG_SATA | ATA_FLAG_SLAVE_POSS,
 	.pio_mask	= ATA_PIO4,
 	.mwdma_mask	= ATA_MWDMA2,
 	.udma_mask	= ATA_UDMA6,
Index: linux-2.6/drivers/ata/sata_vsc.c
===================================================================
--- linux-2.6.orig/drivers/ata/sata_vsc.c
+++ linux-2.6/drivers/ata/sata_vsc.c
@@ -340,7 +340,7 @@ static int __devinit vsc_sata_init_one(s
 				       const struct pci_device_id *ent)
 {
 	static const struct ata_port_info pi = {
-		.flags		= ATA_FLAG_SATA | ATA_FLAG_NO_LEGACY,
+		.flags		= ATA_FLAG_SATA,
 		.pio_mask	= ATA_PIO4,
 		.mwdma_mask	= ATA_MWDMA2,
 		.udma_mask	= ATA_UDMA6,
Index: linux-2.6/drivers/scsi/ipr.c
===================================================================
--- linux-2.6.orig/drivers/scsi/ipr.c
+++ linux-2.6/drivers/scsi/ipr.c
@@ -6219,7 +6219,7 @@ static struct ata_port_operations ipr_sa
 };
 
 static struct ata_port_info sata_port_info = {
-	.flags		= ATA_FLAG_SATA | ATA_FLAG_NO_LEGACY | ATA_FLAG_PIO_DMA,
+	.flags		= ATA_FLAG_SATA | ATA_FLAG_PIO_DMA,
 	.pio_mask	= 0x10, /* pio4 */
 	.mwdma_mask = 0x07,
 	.udma_mask	= 0x7f, /* udma0-6 */
Index: linux-2.6/drivers/scsi/libsas/sas_ata.c
===================================================================
--- linux-2.6.orig/drivers/scsi/libsas/sas_ata.c
+++ linux-2.6/drivers/scsi/libsas/sas_ata.c
@@ -362,8 +362,7 @@ static struct ata_port_operations sas_sa
 };
 
 static struct ata_port_info sata_port_info = {
-	.flags = ATA_FLAG_SATA | ATA_FLAG_NO_LEGACY | ATA_FLAG_PIO_DMA |
-		 ATA_FLAG_NCQ,
+	.flags = ATA_FLAG_SATA | ATA_FLAG_PIO_DMA | ATA_FLAG_NCQ,
 	.pio_mask = 0x1f, /* PIO0-4 */
 	.mwdma_mask = 0x07, /* MWDMA0-2 */
 	.udma_mask = ATA_UDMA6,
Index: linux-2.6/include/linux/libata.h
===================================================================
--- linux-2.6.orig/include/linux/libata.h
+++ linux-2.6/include/linux/libata.h
@@ -179,7 +179,6 @@ enum {
 	ATA_FLAG_SLAVE_POSS	= (1 << 0), /* host supports slave dev */
 					    /* (doesn't imply presence) */
 	ATA_FLAG_SATA		= (1 << 1),
-	ATA_FLAG_NO_LEGACY	= (1 << 2), /* no legacy mode check */
 	ATA_FLAG_NO_ATAPI	= (1 << 6), /* No ATAPI support */
 	ATA_FLAG_PIO_DMA	= (1 << 7), /* PIO cmds via DMA */
 	ATA_FLAG_PIO_LBA48	= (1 << 8), /* Host DMA engine is LBA28 only */
