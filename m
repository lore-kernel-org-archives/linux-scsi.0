From: Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH] advansys: ISA support depends on ISA_DMA_API
Date: Fri, 19 Feb 2010 01:38:47 +0000
Message-ID: <1266543527.10567.713.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:38885 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753113Ab0BSBi5 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 18 Feb 2010 20:38:57 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>, "James E.J. Bottomley" <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org

The advansys driver supports ISA cards using DMA but not PIO-only.
Fix the dependency and preprocessor conditions.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/scsi/Kconfig    |    6 +++++-
 drivers/scsi/advansys.c |   36 ++++++++++++++++++------------------
 2 files changed, 23 insertions(+), 19 deletions(-)

diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index 79107f4..6ccb193 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -547,7 +547,7 @@ config SCSI_DPT_I2O
 config SCSI_ADVANSYS
 	tristate "AdvanSys SCSI support"
 	depends on SCSI && VIRT_TO_BUS
-	depends on ISA || EISA || PCI
+	depends on (ISA && ISA_DMA_API) || PCI
 	help
 	  This is a driver for all SCSI host adapters manufactured by
 	  AdvanSys. It is documented in the kernel source in
@@ -556,6 +556,10 @@ config SCSI_ADVANSYS
 	  To compile this driver as a module, choose M here: the
 	  module will be called advansys.
 
+config SCSI_ADVANSYS_ISA
+	def_bool y
+	depends on SCSI_ADVANSYS && ISA && ISA_DMA_API
+
 config SCSI_IN2000
 	tristate "Always IN2000 SCSI support"
 	depends on ISA && SCSI
diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
index b756041..5f3dfb3 100644
--- a/drivers/scsi/advansys.c
+++ b/drivers/scsi/advansys.c
@@ -3132,9 +3132,9 @@ static int asc_prt_asc_board_eeprom(struct Scsi_Host *shost, char *cp, int cplen
 	int len;
 	ASCEEP_CONFIG *ep;
 	int i;
-#ifdef CONFIG_ISA
+#ifdef CONFIG_SCSI_ADVANSYS_ISA
 	int isa_dma_speed[] = { 10, 8, 7, 6, 5, 4, 3, 2 };
-#endif /* CONFIG_ISA */
+#endif /* CONFIG_SCSI_ADVANSYS_ISA */
 	uchar serialstr[13];
 
 	asc_dvc_varp = &boardp->dvc_var.asc_dvc_var;
@@ -3233,14 +3233,14 @@ static int asc_prt_asc_board_eeprom(struct Scsi_Host *shost, char *cp, int cplen
 	len = asc_prt_line(cp, leftlen, "\n");
 	ASC_PRT_NEXT();
 
-#ifdef CONFIG_ISA
+#ifdef CONFIG_SCSI_ADVANSYS_ISA
 	if (asc_dvc_varp->bus_type & ASC_IS_ISA) {
 		len = asc_prt_line(cp, leftlen,
 				   " Host ISA DMA speed:   %d MB/S\n",
 				   isa_dma_speed[ASC_EEP_GET_DMA_SPD(ep)]);
 		ASC_PRT_NEXT();
 	}
-#endif /* CONFIG_ISA */
+#endif /* CONFIG_SCSI_ADVANSYS_ISA */
 
 	return totlen;
 }
@@ -9582,7 +9582,7 @@ AscGetChipVersion(PortAddr iop_base, unsigned short bus_type)
 	return AscGetChipVerNo(iop_base);
 }
 
-#ifdef CONFIG_ISA
+#ifdef CONFIG_SCSI_ADVANSYS_ISA
 static void __devinit AscEnableIsaDma(uchar dma_channel)
 {
 	if (dma_channel < 4) {
@@ -9593,7 +9593,7 @@ static void __devinit AscEnableIsaDma(uchar dma_channel)
 		outp(0x00D4, (ushort)(dma_channel - 4));
 	}
 }
-#endif /* CONFIG_ISA */
+#endif /* CONFIG_SCSI_ADVANSYS_ISA */
 
 static int AscStopQueueExe(PortAddr iop_base)
 {
@@ -9622,7 +9622,7 @@ static ASC_DCNT __devinit AscGetMaxDmaCount(ushort bus_type)
 	return ASC_MAX_PCI_DMA_COUNT;
 }
 
-#ifdef CONFIG_ISA
+#ifdef CONFIG_SCSI_ADVANSYS_ISA
 static ushort __devinit AscGetIsaDmaChannel(PortAddr iop_base)
 {
 	ushort channel;
@@ -9672,7 +9672,7 @@ static uchar __devinit AscSetIsaDmaSpeed(PortAddr iop_base, uchar speed_value)
 	AscSetBank(iop_base, 0);
 	return AscGetIsaDmaSpeed(iop_base);
 }
-#endif /* CONFIG_ISA */
+#endif /* CONFIG_SCSI_ADVANSYS_ISA */
 
 static ushort __devinit AscInitAscDvcVar(ASC_DVC_VAR *asc_dvc)
 {
@@ -9741,7 +9741,7 @@ static ushort __devinit AscInitAscDvcVar(ASC_DVC_VAR *asc_dvc)
 	}
 
 	asc_dvc->cfg->isa_dma_speed = ASC_DEF_ISA_DMA_SPEED;
-#ifdef CONFIG_ISA
+#ifdef CONFIG_SCSI_ADVANSYS_ISA
 	if ((asc_dvc->bus_type & ASC_IS_ISA) != 0) {
 		if (chip_version >= ASC_CHIP_MIN_VER_ISA_PNP) {
 			AscSetChipIFC(iop_base, IFC_INIT_DEFAULT);
@@ -9750,7 +9750,7 @@ static ushort __devinit AscInitAscDvcVar(ASC_DVC_VAR *asc_dvc)
 		asc_dvc->cfg->isa_dma_channel =
 		    (uchar)AscGetIsaDmaChannel(iop_base);
 	}
-#endif /* CONFIG_ISA */
+#endif /* CONFIG_SCSI_ADVANSYS_ISA */
 	for (i = 0; i <= ASC_MAX_TID; i++) {
 		asc_dvc->cur_dvc_qng[i] = 0;
 		asc_dvc->max_dvc_qng[i] = ASC_MAX_SCSI1_QNG;
@@ -10299,12 +10299,12 @@ static int __devinit AscInitSetConfig(struct pci_dev *pdev, struct Scsi_Host *sh
 	    asc_dvc->cfg->chip_scsi_id) {
 		asc_dvc->err_code |= ASC_IERR_SET_SCSI_ID;
 	}
-#ifdef CONFIG_ISA
+#ifdef CONFIG_SCSI_ADVANSYS_ISA
 	if (asc_dvc->bus_type & ASC_IS_ISA) {
 		AscSetIsaDmaChannel(iop_base, asc_dvc->cfg->isa_dma_channel);
 		AscSetIsaDmaSpeed(iop_base, asc_dvc->cfg->isa_dma_speed);
 	}
-#endif /* CONFIG_ISA */
+#endif /* CONFIG_SCSI_ADVANSYS_ISA */
 
 	asc_dvc->init_state |= ASC_INIT_STATE_END_SET_CFG;
 
@@ -11936,7 +11936,7 @@ static int __devinit advansys_board_found(struct Scsi_Host *shost,
 		 * calling AscInitGetConfig().
 		 */
 		switch (asc_dvc_varp->bus_type) {
-#ifdef CONFIG_ISA
+#ifdef CONFIG_SCSI_ADVANSYS_ISA
 		case ASC_IS_ISA:
 			shost->unchecked_isa_dma = TRUE;
 			share_irq = 0;
@@ -11949,7 +11949,7 @@ static int __devinit advansys_board_found(struct Scsi_Host *shost,
 			shost->unchecked_isa_dma = FALSE;
 			share_irq = IRQF_SHARED;
 			break;
-#endif /* CONFIG_ISA */
+#endif /* CONFIG_SCSI_ADVANSYS_ISA */
 #ifdef CONFIG_PCI
 		case ASC_IS_PCI:
 			shost->unchecked_isa_dma = FALSE;
@@ -12257,7 +12257,7 @@ static int __devinit advansys_board_found(struct Scsi_Host *shost,
 
 	/* Register DMA Channel for Narrow boards. */
 	shost->dma_channel = NO_ISA_DMA;	/* Default to no ISA DMA. */
-#ifdef CONFIG_ISA
+#ifdef CONFIG_SCSI_ADVANSYS_ISA
 	if (ASC_NARROW_BOARD(boardp)) {
 		/* Register DMA channel for ISA bus. */
 		if (asc_dvc_varp->bus_type & ASC_IS_ISA) {
@@ -12272,7 +12272,7 @@ static int __devinit advansys_board_found(struct Scsi_Host *shost,
 			AscEnableIsaDma(shost->dma_channel);
 		}
 	}
-#endif /* CONFIG_ISA */
+#endif /* CONFIG_SCSI_ADVANSYS_ISA */
 
 	/* Register IRQ Number. */
 	ASC_DBG(2, "request_irq(%d, %p)\n", boardp->irq, shost);
@@ -12338,7 +12338,7 @@ static int __devinit advansys_board_found(struct Scsi_Host *shost,
 	advansys_wide_free_mem(boardp);
 	free_irq(boardp->irq, shost);
  err_free_dma:
-#ifdef CONFIG_ISA
+#ifdef CONFIG_SCSI_ADVANSYS_ISA
 	if (shost->dma_channel != NO_ISA_DMA)
 		free_dma(shost->dma_channel);
 #endif
@@ -12362,7 +12362,7 @@ static int advansys_release(struct Scsi_Host *shost)
 	ASC_DBG(1, "begin\n");
 	scsi_remove_host(shost);
 	free_irq(board->irq, shost);
-#ifdef CONFIG_ISA
+#ifdef CONFIG_SCSI_ADVANSYS_ISA
 	if (shost->dma_channel != NO_ISA_DMA) {
 		ASC_DBG(1, "free_dma()\n");
 		free_dma(shost->dma_channel);
-- 
1.6.6.2


