From: Adrian Bunk <bunk@kernel.org>
Subject: [2.6 patch] cleanup after APUS removal
Date: Wed, 24 Oct 2007 18:26:10 +0200
Message-ID: <20071024162610.GG30533@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailout.stusta.mhn.de ([141.84.69.5]:60972 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759384AbXJXQZl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 24 Oct 2007 12:25:41 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: geert@linux-m68k.org, zippel@linux-m68k.org, bzolnier@gmail.com, kkeil@suse.de, James.Bottomley@SteelEye.com, adaplas@gmail.com
Cc: linux-m68k@lists.linux-m68k.org, linux-ide@vger.kernel.org, isdn4linux@listserv.isdn4linux.de, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

After the APUS removal, some code can be removed.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 arch/m68k/amiga/chipram.c           |    2 
 drivers/ide/ide-probe.c             |    8 +--
 drivers/isdn/hisax/avm_pci.c        |    8 ---
 drivers/scsi/a2091.c                |    3 -
 drivers/scsi/a3000.c                |    3 -
 drivers/scsi/gvp11.c                |    3 -
 drivers/scsi/oktagon_esp.c          |    2 
 drivers/scsi/oktagon_io.S           |   72 ----------------------------
 drivers/video/console/fbcon.c       |    2 
 drivers/video/console/fonts.c       |    4 -
 include/asm-m68k/pgtable.h          |    2 
 sound/oss/dmasound/Kconfig          |    2 
 sound/oss/dmasound/dmasound_paula.c |    4 -
 13 files changed, 12 insertions(+), 103 deletions(-)

557134975b5c1098cd42a6295670723ecfb35b57 
diff --git a/arch/m68k/amiga/chipram.c b/arch/m68k/amiga/chipram.c
index fa015d8..75d4626 100644
--- a/arch/m68k/amiga/chipram.c
+++ b/arch/m68k/amiga/chipram.c
@@ -29,12 +29,10 @@ void __init amiga_chip_init(void)
     if (!AMIGAHW_PRESENT(CHIP_RAM))
 	return;
 
-#ifndef CONFIG_APUS_FAST_EXCEPT
     /*
      *  Remove the first 4 pages where PPC exception handlers will be located
      */
     amiga_chip_size -= 0x4000;
-#endif
     chipram_res.end = amiga_chip_size-1;
     request_resource(&iomem_resource, &chipram_res);
 
diff --git a/drivers/ide/ide-probe.c b/drivers/ide/ide-probe.c
index 6a6f2e0..1664e2d 100644
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -1062,9 +1062,9 @@ static int init_irq (ide_hwif_t *hwif)
 	 */
 	if (!match || match->irq != hwif->irq) {
 		int sa = IRQF_DISABLED;
-#if defined(__mc68000__) || defined(CONFIG_APUS)
+#if defined(__mc68000__)
 		sa = IRQF_SHARED;
-#endif /* __mc68000__ || CONFIG_APUS */
+#endif /* __mc68000__ */
 
 		if (IDE_CHIPSET_IS_PCI(hwif->chipset)) {
 			sa = IRQF_SHARED;
@@ -1107,7 +1107,7 @@ static int init_irq (ide_hwif_t *hwif)
 		spin_unlock_irq(&ide_lock);
 	}
 
-#if !defined(__mc68000__) && !defined(CONFIG_APUS)
+#if !defined(__mc68000__)
 	printk("%s at 0x%03lx-0x%03lx,0x%03lx on irq %d", hwif->name,
 		hwif->io_ports[IDE_DATA_OFFSET],
 		hwif->io_ports[IDE_DATA_OFFSET]+7,
@@ -1115,7 +1115,7 @@ static int init_irq (ide_hwif_t *hwif)
 #else
 	printk("%s at 0x%08lx on irq %d", hwif->name,
 		hwif->io_ports[IDE_DATA_OFFSET], hwif->irq);
-#endif /* __mc68000__ && CONFIG_APUS */
+#endif /* __mc68000__ */
 	if (match)
 		printk(" (%sed with %s)",
 			hwif->sharing_irq ? "shar" : "serializ", match->name);
diff --git a/drivers/isdn/hisax/avm_pci.c b/drivers/isdn/hisax/avm_pci.c
index f8b7978..be55a26 100644
--- a/drivers/isdn/hisax/avm_pci.c
+++ b/drivers/isdn/hisax/avm_pci.c
@@ -263,11 +263,7 @@ hdlc_empty_fifo(struct BCState *bcs, int count)
 		outl(idx, cs->hw.avm.cfg_reg + 4);
 		while (cnt < count) {
 #ifdef __powerpc__
-#ifdef CONFIG_APUS
-			*ptr++ = in_le32((unsigned *)(cs->hw.avm.isac +_IO_BASE));
-#else
 			*ptr++ = in_be32((unsigned *)(cs->hw.avm.isac +_IO_BASE));
-#endif /* CONFIG_APUS */
 #else
 			*ptr++ = inl(cs->hw.avm.isac);
 #endif /* __powerpc__ */
@@ -328,11 +324,7 @@ hdlc_fill_fifo(struct BCState *bcs)
 	if (cs->subtyp == AVM_FRITZ_PCI) {
 		while (cnt<count) {
 #ifdef __powerpc__
-#ifdef CONFIG_APUS
-			out_le32((unsigned *)(cs->hw.avm.isac +_IO_BASE), *ptr++);
-#else
 			out_be32((unsigned *)(cs->hw.avm.isac +_IO_BASE), *ptr++);
-#endif /* CONFIG_APUS */
 #else
 			outl(*ptr++, cs->hw.avm.isac);
 #endif /* __powerpc__ */
diff --git a/drivers/scsi/a2091.c b/drivers/scsi/a2091.c
index b7c5385..0d4c593 100644
--- a/drivers/scsi/a2091.c
+++ b/drivers/scsi/a2091.c
@@ -46,8 +46,7 @@ static int dma_setup(struct scsi_cmnd *cmd, int dir_in)
     struct Scsi_Host *instance = cmd->device->host;
 
     /* don't allow DMA if the physical address is bad */
-    if (addr & A2091_XFER_MASK ||
-	(!dir_in && mm_end_of_chunk (addr, cmd->SCp.this_residual)))
+    if (addr & A2091_XFER_MASK)
     {
 	HDATA(instance)->dma_bounce_len = (cmd->SCp.this_residual + 511)
 	    & ~0x1ff;
diff --git a/drivers/scsi/a3000.c b/drivers/scsi/a3000.c
index 796f1c4..b3a6c58 100644
--- a/drivers/scsi/a3000.c
+++ b/drivers/scsi/a3000.c
@@ -54,8 +54,7 @@ static int dma_setup(struct scsi_cmnd *cmd, int dir_in)
      * end of a physical memory chunk, then allocate a bounce
      * buffer
      */
-    if (addr & A3000_XFER_MASK ||
-	(!dir_in && mm_end_of_chunk (addr, cmd->SCp.this_residual)))
+    if (addr & A3000_XFER_MASK)
     {
 	HDATA(a3000_host)->dma_bounce_len = (cmd->SCp.this_residual + 511)
 	    & ~0x1ff;
diff --git a/drivers/scsi/gvp11.c b/drivers/scsi/gvp11.c
index 37741e9..91f8522 100644
--- a/drivers/scsi/gvp11.c
+++ b/drivers/scsi/gvp11.c
@@ -54,8 +54,7 @@ static int dma_setup(struct scsi_cmnd *cmd, int dir_in)
     static int scsi_alloc_out_of_range = 0;
 
     /* use bounce buffer if the physical address is bad */
-    if (addr & HDATA(cmd->device->host)->dma_xfer_mask ||
-	(!dir_in && mm_end_of_chunk (addr, cmd->SCp.this_residual)))
+    if (addr & HDATA(cmd->device->host)->dma_xfer_mask)
     {
 	HDATA(cmd->device->host)->dma_bounce_len = (cmd->SCp.this_residual + 511)
 	    & ~0x1ff;
diff --git a/drivers/scsi/oktagon_esp.c b/drivers/scsi/oktagon_esp.c
index 8e5eadb..c2c65ac 100644
--- a/drivers/scsi/oktagon_esp.c
+++ b/drivers/scsi/oktagon_esp.c
@@ -7,7 +7,7 @@
  */
 
 
-#if defined(CONFIG_AMIGA) || defined(CONFIG_APUS)
+#if defined(CONFIG_AMIGA)
 #define USE_BOTTOM_HALF
 #endif
 
diff --git a/drivers/scsi/oktagon_io.S b/drivers/scsi/oktagon_io.S
index 8a7340b..d294625 100644
--- a/drivers/scsi/oktagon_io.S
+++ b/drivers/scsi/oktagon_io.S
@@ -24,77 +24,6 @@ int oktag_from_io(long *addr,long *paddr,long len)
  */
 
 
-#ifdef CONFIG_APUS
-
-	.file	"oktagon_io.c"
-
-gcc2_compiled.:
-/*
-	.section ".text"
-*/
-	.align 2
-	.globl oktag_to_io
-	.type	 oktag_to_io,@function
-oktag_to_io:
-	addi 5,5,3
-	srwi 5,5,2
-	cmpwi 1,5,0
-	mr 9,3
-	mr 3,4
-	addi 5,5,-1
-	bc 12,6,.L3
-.L5:
-	cmpwi 1,5,0
-	lwz 0,0(3)
-	addi 3,3,4
-	addi 5,5,-1
-exp1:	stw 0,0(9)
-	bc 4,6,.L5
-.L3:
-ret1:	subf 3,4,3
-	srawi 3,3,2
-	blr
-.Lfe1:
-	.size	 oktag_to_io,.Lfe1-oktag_to_io
-	.align 2
-	.globl oktag_from_io
-	.type	 oktag_from_io,@function
-oktag_from_io:
-	addi 5,5,3
-	srwi 5,5,2
-	cmpwi 1,5,0
-	mr 9,3
-	addi 5,5,-1
-	bc 12,6,.L9
-.L11:
-	cmpwi 1,5,0
-exp2:	lwz 0,0(4)
-	addi 5,5,-1
-	stw 0,0(3)
-	addi 3,3,4
-	bc 4,6,.L11
-.L9:
-ret2:	subf 3,9,3
-	srawi 3,3,2
-	blr
-.Lfe2:
-	.size	 oktag_from_io,.Lfe2-oktag_from_io
-	.ident	"GCC: (GNU) egcs-2.90.29 980515 (egcs-1.0.3 release)"
-
-/*
- * Exception table.
- * Second longword shows where to jump when an exception at the addr the first
- * longword is pointing to is caught.
- */
-
-.section __ex_table,"a"
-	.align	2
-oktagon_except:
-	.long	exp1,ret1
-	.long	exp2,ret2
-
-#else
-
 /*
 The code which follows is for 680x0 based assembler and is meant for
 Linux/m68k. It was created by cross compiling the code using the
@@ -191,4 +120,3 @@ oktagon_except:
 	.long	exp2,ret2
 
 #endif
-#endif
diff --git a/drivers/video/console/fbcon.c b/drivers/video/console/fbcon.c
index 0f32f4a..2cedb49 100644
--- a/drivers/video/console/fbcon.c
+++ b/drivers/video/console/fbcon.c
@@ -84,7 +84,7 @@
 #ifdef CONFIG_MAC
 #include <asm/macints.h>
 #endif
-#if defined(__mc68000__) || defined(CONFIG_APUS)
+#if defined(__mc68000__)
 #include <asm/machdep.h>
 #include <asm/setup.h>
 #endif
diff --git a/drivers/video/console/fonts.c b/drivers/video/console/fonts.c
index 96979c3..d0c03fd 100644
--- a/drivers/video/console/fonts.c
+++ b/drivers/video/console/fonts.c
@@ -15,7 +15,7 @@
 #include <linux/module.h>
 #include <linux/types.h>
 #include <linux/string.h>
-#if defined(__mc68000__) || defined(CONFIG_APUS)
+#if defined(__mc68000__)
 #include <asm/setup.h>
 #endif
 #include <linux/font.h>
@@ -120,7 +120,7 @@ const struct font_desc *get_default_font(int xres, int yres, u32 font_w,
     for(i=0; i<num_fonts; i++) {
 	f = fonts[i];
 	c = f->pref;
-#if defined(__mc68000__) || defined(CONFIG_APUS)
+#if defined(__mc68000__)
 #ifdef CONFIG_FONT_PEARL_8x8
 	if (MACH_IS_AMIGA && f->idx == PEARL8x8_IDX)
 	    c = 100;
diff --git a/include/asm-m68k/pgtable.h b/include/asm-m68k/pgtable.h
index 778a4c5..0b604f0 100644
--- a/include/asm-m68k/pgtable.h
+++ b/include/asm-m68k/pgtable.h
@@ -107,8 +107,6 @@ extern void *empty_zero_page;
 /* 64-bit machines, beware!  SRB. */
 #define SIZEOF_PTR_LOG2			       2
 
-#define mm_end_of_chunk(addr, len)	0
-
 extern void kernel_set_cachemode(void *addr, unsigned long size, int cmode);
 
 /*
diff --git a/sound/oss/dmasound/Kconfig b/sound/oss/dmasound/Kconfig
index 71b3134..3eb7827 100644
--- a/sound/oss/dmasound/Kconfig
+++ b/sound/oss/dmasound/Kconfig
@@ -14,7 +14,7 @@ config DMASOUND_ATARI
 
 config DMASOUND_PAULA
 	tristate "Amiga DMA sound support"
-	depends on (AMIGA || APUS) && SOUND
+	depends on AMIGA && SOUND
 	select DMASOUND
 	help
 	  If you want to use the internal audio of your Amiga in Linux, answer
diff --git a/sound/oss/dmasound/dmasound_paula.c b/sound/oss/dmasound/dmasound_paula.c
index 90fc058..202e810 100644
--- a/sound/oss/dmasound/dmasound_paula.c
+++ b/sound/oss/dmasound/dmasound_paula.c
@@ -91,10 +91,6 @@ static irqreturn_t AmiInterrupt(int irq, void *dummy);
      *  power LED are controlled by the same line.
      */
 
-#ifdef CONFIG_APUS
-#define mach_heartbeat	ppc_md.heartbeat
-#endif
-
 static void (*saved_heartbeat)(int) = NULL;
 
 static inline void disable_heartbeat(void)

