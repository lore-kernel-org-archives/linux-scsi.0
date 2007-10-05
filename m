From: Matthew Wilcox <matthew@wil.cx>
Subject: [PATCH 12/17] sym53c8xx: Simplify DAC DMA handling
Date: Fri,  5 Oct 2007 15:55:09 -0400
Message-ID: <1191614115650-git-send-email-matthew@wil.cx>
References: <11916141143747-git-send-email-matthew@wil.cx>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.tor.primus.ca ([216.254.136.21]:48189 "EHLO
	mail-09.primus.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761495AbXJETzW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Oct 2007 15:55:22 -0400
In-Reply-To: <11916141143747-git-send-email-matthew@wil.cx>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Matthew Wilcox <matthew@wil.cx>, Matthew Wilcox <willy@linux.intel.com>

By introducing the use_dac(), set_dac() and DMA_DAC_MASK macros, we can
eliminate a lot of ifdefs from the code.  We now rely on the compiler to
optimise away a few things that we'd formerly relied on the preprocessor
to do.  This makes sym_setup_bus_dma_mask() small enough to inline into
its only caller.

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
---
 drivers/scsi/sym53c8xx_2/sym_fw.c   |    2 +-
 drivers/scsi/sym53c8xx_2/sym_glue.c |   32 ++++++--------------------------
 drivers/scsi/sym53c8xx_2/sym_hipd.c |   23 ++++++++---------------
 drivers/scsi/sym53c8xx_2/sym_hipd.h |   11 +++++++++++
 4 files changed, 26 insertions(+), 42 deletions(-)

diff --git a/drivers/scsi/sym53c8xx_2/sym_fw.c b/drivers/scsi/sym53c8xx_2/sym_fw.c
index 3d4db80..aa230d2 100644
--- a/drivers/scsi/sym53c8xx_2/sym_fw.c
+++ b/drivers/scsi/sym53c8xx_2/sym_fw.c
@@ -167,7 +167,7 @@ sym_fw2_patch(struct sym_hcb *np)
 	 *  Remove useless 64 bit DMA specific SCRIPTS, 
 	 *  when this feature is not available.
 	 */
-	if (!np->use_dac) {
+	if (!use_dac(np)) {
 		scripta0->is_dmap_dirty[0] = cpu_to_scr(SCR_NO_OP);
 		scripta0->is_dmap_dirty[1] = 0;
 		scripta0->is_dmap_dirty[2] = cpu_to_scr(SCR_NO_OP);
diff --git a/drivers/scsi/sym53c8xx_2/sym_glue.c b/drivers/scsi/sym53c8xx_2/sym_glue.c
index 7717ab8..e5b2213 100644
--- a/drivers/scsi/sym53c8xx_2/sym_glue.c
+++ b/drivers/scsi/sym53c8xx_2/sym_glue.c
@@ -1265,31 +1265,6 @@ static void sym_free_resources(struct sym_hcb *np, struct pci_dev *pdev)
 }
 
 /*
- *  Ask/tell the system about DMA addressing.
- */
-static int sym_setup_bus_dma_mask(struct sym_hcb *np)
-{
-#if SYM_CONF_DMA_ADDRESSING_MODE > 0
-#if   SYM_CONF_DMA_ADDRESSING_MODE == 1
-#define	DMA_DAC_MASK	DMA_40BIT_MASK
-#elif SYM_CONF_DMA_ADDRESSING_MODE == 2
-#define	DMA_DAC_MASK	DMA_64BIT_MASK
-#endif
-	if ((np->features & FE_DAC) &&
-			!pci_set_dma_mask(np->s.device, DMA_DAC_MASK)) {
-		np->use_dac = 1;
-		return 0;
-	}
-#endif
-
-	if (!pci_set_dma_mask(np->s.device, DMA_32BIT_MASK))
-		return 0;
-
-	printf_warning("%s: No suitable DMA available\n", sym_name(np));
-	return -1;
-}
-
-/*
  *  Host attach and initialisations.
  *
  *  Allocate host data and ncb structure.
@@ -1362,8 +1337,13 @@ static struct Scsi_Host * __devinit sym_attach(struct scsi_host_template *tpnt,
 	strlcpy(np->s.chip_name, dev->chip.name, sizeof(np->s.chip_name));
 	sprintf(np->s.inst_name, "sym%d", np->s.unit);
 
-	if (sym_setup_bus_dma_mask(np))
+	if ((SYM_CONF_DMA_ADDRESSING_MODE > 0) && (np->features & FE_DAC) &&
+			!pci_set_dma_mask(np->s.device, DMA_DAC_MASK)) {
+		set_dac(np);
+	} else if (pci_set_dma_mask(np->s.device, DMA_32BIT_MASK)) {
+		printf_warning("%s: No suitable DMA available\n", sym_name(np));
 		goto attach_failed;
+	}
 
 	/*
 	 *  Try to map the controller chip to
diff --git a/drivers/scsi/sym53c8xx_2/sym_hipd.c b/drivers/scsi/sym53c8xx_2/sym_hipd.c
index 39f84bb..5d0d356 100644
--- a/drivers/scsi/sym53c8xx_2/sym_hipd.c
+++ b/drivers/scsi/sym53c8xx_2/sym_hipd.c
@@ -778,19 +778,12 @@ static int sym_prepare_setting(struct Scsi_Host *shost, struct sym_hcb *np, stru
 	 *  64 bit addressing  (895A/896/1010) ?
 	 */
 	if (np->features & FE_DAC) {
-#if   SYM_CONF_DMA_ADDRESSING_MODE == 0
-		np->rv_ccntl1	|= (DDAC);
-#elif SYM_CONF_DMA_ADDRESSING_MODE == 1
-		if (!np->use_dac)
-			np->rv_ccntl1	|= (DDAC);
-		else
-			np->rv_ccntl1	|= (XTIMOD | EXTIBMV);
-#elif SYM_CONF_DMA_ADDRESSING_MODE == 2
-		if (!np->use_dac)
-			np->rv_ccntl1	|= (DDAC);
-		else
-			np->rv_ccntl1	|= (0 | EXTIBMV);
-#endif
+		if (!use_dac(np))
+			np->rv_ccntl1 |= (DDAC);
+		else if (SYM_CONF_DMA_ADDRESSING_MODE == 1)
+			np->rv_ccntl1 |= (XTIMOD | EXTIBMV);
+		else if (SYM_CONF_DMA_ADDRESSING_MODE == 2)
+			np->rv_ccntl1 |= (0 | EXTIBMV);
 	}
 
 	/*
@@ -1322,7 +1315,7 @@ int sym_lookup_dmap(struct sym_hcb *np, u32 h, int s)
 {
 	int i;
 
-	if (!np->use_dac)
+	if (!use_dac(np))
 		goto weird;
 
 	/* Look up existing mappings */
@@ -1837,7 +1830,7 @@ void sym_start_up (struct sym_hcb *np, int reason)
 	 *  Set up scratch C and DRS IO registers to map the 32 bit 
 	 *  DMA address range our data structures are located in.
 	 */
-	if (np->use_dac) {
+	if (use_dac(np)) {
 		np->dmap_bah[0] = 0;	/* ??? */
 		OUTL(np, nc_scrx[0], np->dmap_bah[0]);
 		OUTL(np, nc_drs, np->dmap_bah[0]);
diff --git a/drivers/scsi/sym53c8xx_2/sym_hipd.h b/drivers/scsi/sym53c8xx_2/sym_hipd.h
index f76b27f..4354571 100644
--- a/drivers/scsi/sym53c8xx_2/sym_hipd.h
+++ b/drivers/scsi/sym53c8xx_2/sym_hipd.h
@@ -1026,6 +1026,14 @@ struct sym_hcb {
 #endif
 };
 
+#if SYM_CONF_DMA_ADDRESSING_MODE == 0
+#define use_dac(np)	0
+#define set_dac(np)	do { } while (0)
+#else
+#define use_dac(np)	(np)->use_dac
+#define set_dac(np)	(np)->use_dac = 1
+#endif
+
 #define HCB_BA(np, lbl)	(np->hcb_ba + offsetof(struct sym_hcb, lbl))
 
 
@@ -1068,18 +1076,21 @@ int sym_hcb_attach(struct Scsi_Host *shost, struct sym_fw *fw, struct sym_nvram
  */
 
 #if   SYM_CONF_DMA_ADDRESSING_MODE == 0
+#define DMA_DAC_MASK	DMA_32BIT_MASK
 #define sym_build_sge(np, data, badd, len)	\
 do {						\
 	(data)->addr = cpu_to_scr(badd);	\
 	(data)->size = cpu_to_scr(len);		\
 } while (0)
 #elif SYM_CONF_DMA_ADDRESSING_MODE == 1
+#define DMA_DAC_MASK	DMA_40BIT_MASK
 #define sym_build_sge(np, data, badd, len)				\
 do {									\
 	(data)->addr = cpu_to_scr(badd);				\
 	(data)->size = cpu_to_scr((((badd) >> 8) & 0xff000000) + len);	\
 } while (0)
 #elif SYM_CONF_DMA_ADDRESSING_MODE == 2
+#define DMA_DAC_MASK	DMA_64BIT_MASK
 int sym_lookup_dmap(struct sym_hcb *np, u32 h, int s);
 static __inline void 
 sym_build_sge(struct sym_hcb *np, struct sym_tblmove *data, u64 badd, int len)
-- 
1.4.4.2

