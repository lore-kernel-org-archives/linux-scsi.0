From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH v2 5/6] esp_scsi: De-duplicate PIO routines
Date: Sun, 14 Oct 2018 17:12:00 +1100
Message-ID: <d5fe773ea8c922631836dad2ef2dbb952672c7c7.1539497520.git.fthain@telegraphics.com.au>
References: <cover.1539497520.git.fthain@telegraphics.com.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1539497520.git.fthain@telegraphics.com.au>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Michael Schmitz <schmitzmic@gmail.com>, Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org, linux-m68k@lists.linux-m68k.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

As a temporary measure, the code to implement PIO transfers was
duplicated in zorro_esp and mac_esp. Now that it has stabilized
move the common code into the core driver but don't build it unless
needed.

This replaces the inline assembler with more portable writesb() calls.
Optimizing the m68k writesb() implementation is a separate patch.

Tested-by: Stan Johnson <userm57@yahoo.com>
Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
Tested-by: Michael Schmitz <schmitzmic@gmail.com>
---
Changed since v1:
 - Use shost_printk() instead of pr_err().
 - Add new symbol CONFIG_SCSI_ESP_PIO to Kconfig.
---
 drivers/scsi/Kconfig     |   6 +
 drivers/scsi/esp_scsi.c  | 128 +++++++++++++++++++++
 drivers/scsi/esp_scsi.h  |   5 +
 drivers/scsi/mac_esp.c   | 173 +----------------------------
 drivers/scsi/zorro_esp.c | 232 ++++++---------------------------------
 5 files changed, 179 insertions(+), 365 deletions(-)

diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index 35c909bbf8ba..81c6872f24f8 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -42,6 +42,10 @@ config SCSI_DMA
 	bool
 	default n
 
+config SCSI_ESP_PIO
+	bool
+	default n
+
 config SCSI_NETLINK
 	bool
 	default	n
@@ -1355,6 +1359,7 @@ config SCSI_ZORRO_ESP
 	tristate "Zorro ESP SCSI support"
 	depends on ZORRO && SCSI
 	select SCSI_SPI_ATTRS
+	select SCSI_ESP_PIO
 	help
 	  Support for various NCR53C9x (ESP) based SCSI controllers on Zorro
 	  expansion boards for the Amiga.
@@ -1397,6 +1402,7 @@ config SCSI_MAC_ESP
 	tristate "Macintosh NCR53c9[46] SCSI"
 	depends on MAC && SCSI
 	select SCSI_SPI_ATTRS
+	select SCSI_ESP_PIO
 	help
 	  This is the NCR 53c9x SCSI controller found on most of the 68040
 	  based Macintoshes.
diff --git a/drivers/scsi/esp_scsi.c b/drivers/scsi/esp_scsi.c
index 6ccaf818357e..305a322ad13c 100644
--- a/drivers/scsi/esp_scsi.c
+++ b/drivers/scsi/esp_scsi.c
@@ -2776,3 +2776,131 @@ MODULE_PARM_DESC(esp_debug,
 
 module_init(esp_init);
 module_exit(esp_exit);
+
+#ifdef CONFIG_SCSI_ESP_PIO
+static inline unsigned int esp_wait_for_fifo(struct esp *esp)
+{
+	int i = 500000;
+
+	do {
+		unsigned int fbytes = esp_read8(ESP_FFLAGS) & ESP_FF_FBYTES;
+
+		if (fbytes)
+			return fbytes;
+
+		udelay(2);
+	} while (--i);
+
+	shost_printk(KERN_ERR, esp->host, "FIFO is empty (sreg %02x)\n",
+		     esp_read8(ESP_STATUS));
+	return 0;
+}
+
+static inline int esp_wait_for_intr(struct esp *esp)
+{
+	int i = 500000;
+
+	do {
+		esp->sreg = esp_read8(ESP_STATUS);
+		if (esp->sreg & ESP_STAT_INTR)
+			return 0;
+
+		udelay(2);
+	} while (--i);
+
+	shost_printk(KERN_ERR, esp->host, "IRQ timeout (sreg %02x)\n",
+		     esp->sreg);
+	return 1;
+}
+
+#define ESP_FIFO_SIZE 16
+
+void esp_send_pio_cmd(struct esp *esp, u32 addr, u32 esp_count,
+		      u32 dma_count, int write, u8 cmd)
+{
+	u8 phase = esp->sreg & ESP_STAT_PMASK;
+
+	cmd &= ~ESP_CMD_DMA;
+	esp->send_cmd_error = 0;
+
+	if (write) {
+		u8 *dst = (u8 *)addr;
+		u8 mask = ~(phase == ESP_MIP ? ESP_INTR_FDONE : ESP_INTR_BSERV);
+
+		scsi_esp_cmd(esp, cmd);
+
+		while (1) {
+			if (!esp_wait_for_fifo(esp))
+				break;
+
+			*dst++ = esp_read8(ESP_FDATA);
+			--esp_count;
+
+			if (!esp_count)
+				break;
+
+			if (esp_wait_for_intr(esp)) {
+				esp->send_cmd_error = 1;
+				break;
+			}
+
+			if ((esp->sreg & ESP_STAT_PMASK) != phase)
+				break;
+
+			esp->ireg = esp_read8(ESP_INTRPT);
+			if (esp->ireg & mask) {
+				esp->send_cmd_error = 1;
+				break;
+			}
+
+			if (phase == ESP_MIP)
+				scsi_esp_cmd(esp, ESP_CMD_MOK);
+
+			scsi_esp_cmd(esp, ESP_CMD_TI);
+		}
+	} else {
+		unsigned int n = ESP_FIFO_SIZE;
+		u8 *src = (u8 *)addr;
+
+		scsi_esp_cmd(esp, ESP_CMD_FLUSH);
+
+		if (n > esp_count)
+			n = esp_count;
+		writesb(esp->fifo_reg, src, n);
+		src += n;
+		esp_count -= n;
+
+		scsi_esp_cmd(esp, cmd);
+
+		while (esp_count) {
+			if (esp_wait_for_intr(esp)) {
+				esp->send_cmd_error = 1;
+				break;
+			}
+
+			if ((esp->sreg & ESP_STAT_PMASK) != phase)
+				break;
+
+			esp->ireg = esp_read8(ESP_INTRPT);
+			if (esp->ireg & ~ESP_INTR_BSERV) {
+				esp->send_cmd_error = 1;
+				break;
+			}
+
+			n = ESP_FIFO_SIZE -
+			    (esp_read8(ESP_FFLAGS) & ESP_FF_FBYTES);
+
+			if (n > esp_count)
+				n = esp_count;
+			writesb(esp->fifo_reg, src, n);
+			src += n;
+			esp_count -= n;
+
+			scsi_esp_cmd(esp, ESP_CMD_TI);
+		}
+	}
+
+	esp->send_cmd_residual = esp_count;
+}
+EXPORT_SYMBOL(esp_send_pio_cmd);
+#endif
diff --git a/drivers/scsi/esp_scsi.h b/drivers/scsi/esp_scsi.h
index d0c032803749..2590e5eda595 100644
--- a/drivers/scsi/esp_scsi.h
+++ b/drivers/scsi/esp_scsi.h
@@ -431,6 +431,7 @@ struct esp_driver_ops {
 struct esp {
 	void __iomem		*regs;
 	void __iomem		*dma_regs;
+	u8 __iomem		*fifo_reg;
 
 	const struct esp_driver_ops *ops;
 
@@ -540,6 +541,7 @@ struct esp {
 	void			*dma;
 	int			dmarev;
 
+	int			send_cmd_error;
 	int			send_cmd_residual;
 };
 
@@ -581,4 +583,7 @@ extern void scsi_esp_unregister(struct esp *);
 extern irqreturn_t scsi_esp_intr(int, void *);
 extern void scsi_esp_cmd(struct esp *, u8);
 
+extern void esp_send_pio_cmd(struct esp *esp, u32 dma_addr, u32 esp_count,
+			     u32 dma_count, int write, u8 cmd);
+
 #endif /* !(_ESP_SCSI_H) */
diff --git a/drivers/scsi/mac_esp.c b/drivers/scsi/mac_esp.c
index 71879f2207e0..1becf6a195a2 100644
--- a/drivers/scsi/mac_esp.c
+++ b/drivers/scsi/mac_esp.c
@@ -52,7 +52,6 @@ struct mac_esp_priv {
 	struct esp *esp;
 	void __iomem *pdma_regs;
 	void __iomem *pdma_io;
-	int error;
 };
 static struct esp *esp_chips[2];
 static DEFINE_SPINLOCK(esp_chips_lock);
@@ -120,12 +119,11 @@ static void mac_esp_dma_invalidate(struct esp *esp)
 
 static int mac_esp_dma_error(struct esp *esp)
 {
-	return MAC_ESP_GET_PRIV(esp)->error;
+	return esp->send_cmd_error;
 }
 
 static inline int mac_esp_wait_for_empty_fifo(struct esp *esp)
 {
-	struct mac_esp_priv *mep = MAC_ESP_GET_PRIV(esp);
 	int i = 500000;
 
 	do {
@@ -140,7 +138,7 @@ static inline int mac_esp_wait_for_empty_fifo(struct esp *esp)
 
 	printk(KERN_ERR PFX "FIFO is not empty (sreg %02x)\n",
 	       esp_read8(ESP_STATUS));
-	mep->error = 1;
+	esp->send_cmd_error = 1;
 	return 1;
 }
 
@@ -166,7 +164,7 @@ static inline int mac_esp_wait_for_dreq(struct esp *esp)
 
 	printk(KERN_ERR PFX "PDMA timeout (sreg %02x)\n",
 	       esp_read8(ESP_STATUS));
-	mep->error = 1;
+	esp->send_cmd_error = 1;
 	return 1;
 }
 
@@ -233,7 +231,7 @@ static void mac_esp_send_pdma_cmd(struct esp *esp, u32 addr, u32 esp_count,
 {
 	struct mac_esp_priv *mep = MAC_ESP_GET_PRIV(esp);
 
-	mep->error = 0;
+	esp->send_cmd_error = 0;
 
 	if (!write)
 		scsi_esp_cmd(esp, ESP_CMD_FLUSH);
@@ -271,166 +269,6 @@ static void mac_esp_send_pdma_cmd(struct esp *esp, u32 addr, u32 esp_count,
 	} while (esp_count);
 }
 
-/*
- * Programmed IO routines follow.
- */
-
-static inline unsigned int mac_esp_wait_for_fifo(struct esp *esp)
-{
-	int i = 500000;
-
-	do {
-		unsigned int fbytes = esp_read8(ESP_FFLAGS) & ESP_FF_FBYTES;
-
-		if (fbytes)
-			return fbytes;
-
-		udelay(2);
-	} while (--i);
-
-	printk(KERN_ERR PFX "FIFO is empty (sreg %02x)\n",
-	       esp_read8(ESP_STATUS));
-	return 0;
-}
-
-static inline int mac_esp_wait_for_intr(struct esp *esp)
-{
-	struct mac_esp_priv *mep = MAC_ESP_GET_PRIV(esp);
-	int i = 500000;
-
-	do {
-		esp->sreg = esp_read8(ESP_STATUS);
-		if (esp->sreg & ESP_STAT_INTR)
-			return 0;
-
-		udelay(2);
-	} while (--i);
-
-	printk(KERN_ERR PFX "IRQ timeout (sreg %02x)\n", esp->sreg);
-	mep->error = 1;
-	return 1;
-}
-
-#define MAC_ESP_PIO_LOOP(operands, reg1) \
-	asm volatile ( \
-	     "1:     moveb " operands " \n" \
-	     "       subqw #1,%1        \n" \
-	     "       jbne 1b            \n" \
-	     : "+a" (addr), "+r" (reg1) \
-	     : "a" (fifo))
-
-#define MAC_ESP_PIO_FILL(operands, reg1) \
-	asm volatile ( \
-	     "       moveb " operands " \n" \
-	     "       moveb " operands " \n" \
-	     "       moveb " operands " \n" \
-	     "       moveb " operands " \n" \
-	     "       moveb " operands " \n" \
-	     "       moveb " operands " \n" \
-	     "       moveb " operands " \n" \
-	     "       moveb " operands " \n" \
-	     "       moveb " operands " \n" \
-	     "       moveb " operands " \n" \
-	     "       moveb " operands " \n" \
-	     "       moveb " operands " \n" \
-	     "       moveb " operands " \n" \
-	     "       moveb " operands " \n" \
-	     "       moveb " operands " \n" \
-	     "       moveb " operands " \n" \
-	     "       subqw #8,%1        \n" \
-	     "       subqw #8,%1        \n" \
-	     : "+a" (addr), "+r" (reg1) \
-	     : "a" (fifo))
-
-#define MAC_ESP_FIFO_SIZE 16
-
-static void mac_esp_send_pio_cmd(struct esp *esp, u32 addr, u32 esp_count,
-				 u32 dma_count, int write, u8 cmd)
-{
-	struct mac_esp_priv *mep = MAC_ESP_GET_PRIV(esp);
-	u8 __iomem *fifo = esp->regs + ESP_FDATA * 16;
-	u8 phase = esp->sreg & ESP_STAT_PMASK;
-
-	cmd &= ~ESP_CMD_DMA;
-	mep->error = 0;
-
-	if (write) {
-		u8 *dst = (u8 *)addr;
-		u8 mask = ~(phase == ESP_MIP ? ESP_INTR_FDONE : ESP_INTR_BSERV);
-
-		scsi_esp_cmd(esp, cmd);
-
-		while (1) {
-			if (!mac_esp_wait_for_fifo(esp))
-				break;
-
-			*dst++ = esp_read8(ESP_FDATA);
-			--esp_count;
-
-			if (!esp_count)
-				break;
-
-			if (mac_esp_wait_for_intr(esp))
-				break;
-
-			if ((esp->sreg & ESP_STAT_PMASK) != phase)
-				break;
-
-			esp->ireg = esp_read8(ESP_INTRPT);
-			if (esp->ireg & mask) {
-				mep->error = 1;
-				break;
-			}
-
-			if (phase == ESP_MIP)
-				scsi_esp_cmd(esp, ESP_CMD_MOK);
-
-			scsi_esp_cmd(esp, ESP_CMD_TI);
-		}
-	} else {
-		scsi_esp_cmd(esp, ESP_CMD_FLUSH);
-
-		if (esp_count >= MAC_ESP_FIFO_SIZE)
-			MAC_ESP_PIO_FILL("%0@+,%2@", esp_count);
-		else
-			MAC_ESP_PIO_LOOP("%0@+,%2@", esp_count);
-
-		scsi_esp_cmd(esp, cmd);
-
-		while (esp_count) {
-			unsigned int n;
-
-			if (mac_esp_wait_for_intr(esp))
-				break;
-
-			if ((esp->sreg & ESP_STAT_PMASK) != phase)
-				break;
-
-			esp->ireg = esp_read8(ESP_INTRPT);
-			if (esp->ireg & ~ESP_INTR_BSERV) {
-				mep->error = 1;
-				break;
-			}
-
-			n = MAC_ESP_FIFO_SIZE -
-			    (esp_read8(ESP_FFLAGS) & ESP_FF_FBYTES);
-			if (n > esp_count)
-				n = esp_count;
-
-			if (n == MAC_ESP_FIFO_SIZE) {
-				MAC_ESP_PIO_FILL("%0@+,%2@", esp_count);
-			} else {
-				esp_count -= n;
-				MAC_ESP_PIO_LOOP("%0@+,%2@", n);
-			}
-
-			scsi_esp_cmd(esp, ESP_CMD_TI);
-		}
-	}
-
-	esp->send_cmd_residual = esp_count;
-}
-
 static int mac_esp_irq_pending(struct esp *esp)
 {
 	if (esp_read8(ESP_STATUS) & ESP_STAT_INTR)
@@ -553,6 +391,7 @@ static int esp_mac_probe(struct platform_device *dev)
 		mep->pdma_regs = NULL;
 		break;
 	}
+	esp->fifo_reg = esp->regs + ESP_FDATA * 16;
 
 	esp->ops = &mac_esp_ops;
 	if (mep->pdma_io == NULL) {
@@ -560,7 +399,7 @@ static int esp_mac_probe(struct platform_device *dev)
 		esp_write8(0, ESP_TCLOW);
 		esp_write8(0, ESP_TCMED);
 		esp->flags = ESP_FLAG_DISABLE_SYNC;
-		mac_esp_ops.send_dma_cmd = mac_esp_send_pio_cmd;
+		mac_esp_ops.send_dma_cmd = esp_send_pio_cmd;
 	} else {
 		printk(KERN_INFO PFX "using PDMA for controller %d\n", dev->id);
 	}
diff --git a/drivers/scsi/zorro_esp.c b/drivers/scsi/zorro_esp.c
index be79127db594..88e2bbc509ba 100644
--- a/drivers/scsi/zorro_esp.c
+++ b/drivers/scsi/zorro_esp.c
@@ -9,8 +9,6 @@
  *
  * Copyright (C) 2013 Tuomas Vainikka (tuomas.vainikka@aalto.fi) for
  *               Blizzard 1230 DMA and probe function fixes
- *
- * Copyright (C) 2017 Finn Thain for PIO code from Mac ESP driver adapted here
  */
 /*
  * ZORRO bus code from:
@@ -159,7 +157,6 @@ struct fastlane_dma_registers {
 struct zorro_esp_priv {
 	struct esp *esp;		/* our ESP instance - for Scsi_host* */
 	void __iomem *board_base;	/* virtual address (Zorro III board) */
-	int error;			/* PIO error flag */
 	int zorro3;			/* board is Zorro III */
 	unsigned char ctrl_data;	/* shadow copy of ctrl_reg */
 };
@@ -274,192 +271,29 @@ static void fastlane_esp_dma_invalidate(struct esp *esp)
 	z_writel(0, zep->board_base);
 }
 
-/*
- * Programmed IO routines follow.
- */
-
-static inline unsigned int zorro_esp_wait_for_fifo(struct esp *esp)
-{
-	int i = 500000;
-
-	do {
-		unsigned int fbytes = zorro_esp_read8(esp, ESP_FFLAGS)
-							& ESP_FF_FBYTES;
-
-		if (fbytes)
-			return fbytes;
-
-		udelay(2);
-	} while (--i);
-
-	pr_err("FIFO is empty (sreg %02x)\n",
-	       zorro_esp_read8(esp, ESP_STATUS));
-	return 0;
-}
-
-static inline int zorro_esp_wait_for_intr(struct esp *esp)
-{
-	struct zorro_esp_priv *zep = dev_get_drvdata(esp->dev);
-	int i = 500000;
-
-	do {
-		esp->sreg = zorro_esp_read8(esp, ESP_STATUS);
-		if (esp->sreg & ESP_STAT_INTR)
-			return 0;
-
-		udelay(2);
-	} while (--i);
-
-	pr_err("IRQ timeout (sreg %02x)\n", esp->sreg);
-	zep->error = 1;
-	return 1;
-}
-
-/*
- * PIO macros as used in mac_esp.c.
- * Note that addr and fifo arguments are local-scope variables declared
- * in zorro_esp_send_pio_cmd(), the macros are only used in that function,
- * and addr and fifo are referenced in each use of the macros so there
- * is no need to pass them as macro parameters.
- */
-#define ZORRO_ESP_PIO_LOOP(operands, reg1) \
-	asm volatile ( \
-	     "1:     moveb " operands "\n" \
-	     "       subqw #1,%1       \n" \
-	     "       jbne 1b           \n" \
-	     : "+a" (addr), "+r" (reg1) \
-	     : "a" (fifo));
-
-#define ZORRO_ESP_PIO_FILL(operands, reg1) \
-	asm volatile ( \
-	     "       moveb " operands "\n" \
-	     "       moveb " operands "\n" \
-	     "       moveb " operands "\n" \
-	     "       moveb " operands "\n" \
-	     "       moveb " operands "\n" \
-	     "       moveb " operands "\n" \
-	     "       moveb " operands "\n" \
-	     "       moveb " operands "\n" \
-	     "       moveb " operands "\n" \
-	     "       moveb " operands "\n" \
-	     "       moveb " operands "\n" \
-	     "       moveb " operands "\n" \
-	     "       moveb " operands "\n" \
-	     "       moveb " operands "\n" \
-	     "       moveb " operands "\n" \
-	     "       moveb " operands "\n" \
-	     "       subqw #8,%1       \n" \
-	     "       subqw #8,%1       \n" \
-	     : "+a" (addr), "+r" (reg1) \
-	     : "a" (fifo));
-
-#define ZORRO_ESP_FIFO_SIZE 16
-
-static void zorro_esp_send_pio_cmd(struct esp *esp, u32 addr, u32 esp_count,
-				 u32 dma_count, int write, u8 cmd)
-{
-	struct zorro_esp_priv *zep = dev_get_drvdata(esp->dev);
-	u8 __iomem *fifo = esp->regs + ESP_FDATA * 16;
-	u8 phase = esp->sreg & ESP_STAT_PMASK;
-
-	cmd &= ~ESP_CMD_DMA;
-
-	if (write) {
-		u8 *dst = (u8 *)addr;
-		u8 mask = ~(phase == ESP_MIP ? ESP_INTR_FDONE : ESP_INTR_BSERV);
-
-		scsi_esp_cmd(esp, cmd);
-
-		while (1) {
-			if (!zorro_esp_wait_for_fifo(esp))
-				break;
-
-			*dst++ = zorro_esp_read8(esp, ESP_FDATA);
-			--esp_count;
-
-			if (!esp_count)
-				break;
-
-			if (zorro_esp_wait_for_intr(esp))
-				break;
-
-			if ((esp->sreg & ESP_STAT_PMASK) != phase)
-				break;
-
-			esp->ireg = zorro_esp_read8(esp, ESP_INTRPT);
-			if (esp->ireg & mask) {
-				zep->error = 1;
-				break;
-			}
-
-			if (phase == ESP_MIP)
-				scsi_esp_cmd(esp, ESP_CMD_MOK);
-
-			scsi_esp_cmd(esp, ESP_CMD_TI);
-		}
-	} else {	/* unused, as long as we only handle MIP here */
-		scsi_esp_cmd(esp, ESP_CMD_FLUSH);
-
-		if (esp_count >= ZORRO_ESP_FIFO_SIZE)
-			ZORRO_ESP_PIO_FILL("%0@+,%2@", esp_count)
-		else
-			ZORRO_ESP_PIO_LOOP("%0@+,%2@", esp_count)
-
-		scsi_esp_cmd(esp, cmd);
-
-		while (esp_count) {
-			unsigned int n;
-
-			if (zorro_esp_wait_for_intr(esp))
-				break;
-
-			if ((esp->sreg & ESP_STAT_PMASK) != phase)
-				break;
-
-			esp->ireg = zorro_esp_read8(esp, ESP_INTRPT);
-			if (esp->ireg & ~ESP_INTR_BSERV) {
-				zep->error = 1;
-				break;
-			}
-
-			n = ZORRO_ESP_FIFO_SIZE -
-			    (zorro_esp_read8(esp, ESP_FFLAGS) & ESP_FF_FBYTES);
-			if (n > esp_count)
-				n = esp_count;
-
-			if (n == ZORRO_ESP_FIFO_SIZE)
-				ZORRO_ESP_PIO_FILL("%0@+,%2@", esp_count)
-			else {
-				esp_count -= n;
-				ZORRO_ESP_PIO_LOOP("%0@+,%2@", n)
-			}
-
-			scsi_esp_cmd(esp, ESP_CMD_TI);
-		}
-	}
-}
-
 /* Blizzard 1230/60 SCSI-IV DMA */
 
 static void zorro_esp_send_blz1230_dma_cmd(struct esp *esp, u32 addr,
 			u32 esp_count, u32 dma_count, int write, u8 cmd)
 {
-	struct zorro_esp_priv *zep = dev_get_drvdata(esp->dev);
 	struct blz1230_dma_registers __iomem *dregs = esp->dma_regs;
 	u8 phase = esp->sreg & ESP_STAT_PMASK;
 
-	zep->error = 0;
 	/*
 	 * Use PIO if transferring message bytes to esp->command_block_dma.
 	 * PIO requires a virtual address, so substitute esp->command_block
 	 * for addr.
 	 */
 	if (phase == ESP_MIP && addr == esp->command_block_dma) {
-		zorro_esp_send_pio_cmd(esp, (u32) esp->command_block,
-					esp_count, dma_count, write, cmd);
+		esp_send_pio_cmd(esp, (u32)esp->command_block, esp_count,
+				 dma_count, write, cmd);
 		return;
 	}
 
+	/* Clear the results of a possible prior esp->ops->send_dma_cmd() */
+	esp->send_cmd_error = 0;
+	esp->send_cmd_residual = 0;
+
 	if (write)
 		/* DMA receive */
 		dma_sync_single_for_device(esp->dev, addr, esp_count,
@@ -493,18 +327,19 @@ static void zorro_esp_send_blz1230_dma_cmd(struct esp *esp, u32 addr,
 static void zorro_esp_send_blz1230II_dma_cmd(struct esp *esp, u32 addr,
 			u32 esp_count, u32 dma_count, int write, u8 cmd)
 {
-	struct zorro_esp_priv *zep = dev_get_drvdata(esp->dev);
 	struct blz1230II_dma_registers __iomem *dregs = esp->dma_regs;
 	u8 phase = esp->sreg & ESP_STAT_PMASK;
 
-	zep->error = 0;
 	/* Use PIO if transferring message bytes to esp->command_block_dma */
 	if (phase == ESP_MIP && addr == esp->command_block_dma) {
-		zorro_esp_send_pio_cmd(esp, (u32) esp->command_block,
-					esp_count, dma_count, write, cmd);
+		esp_send_pio_cmd(esp, (u32)esp->command_block, esp_count,
+				 dma_count, write, cmd);
 		return;
 	}
 
+	esp->send_cmd_error = 0;
+	esp->send_cmd_residual = 0;
+
 	if (write)
 		/* DMA receive */
 		dma_sync_single_for_device(esp->dev, addr, esp_count,
@@ -537,18 +372,19 @@ static void zorro_esp_send_blz1230II_dma_cmd(struct esp *esp, u32 addr,
 static void zorro_esp_send_blz2060_dma_cmd(struct esp *esp, u32 addr,
 			u32 esp_count, u32 dma_count, int write, u8 cmd)
 {
-	struct zorro_esp_priv *zep = dev_get_drvdata(esp->dev);
 	struct blz2060_dma_registers __iomem *dregs = esp->dma_regs;
 	u8 phase = esp->sreg & ESP_STAT_PMASK;
 
-	zep->error = 0;
 	/* Use PIO if transferring message bytes to esp->command_block_dma */
 	if (phase == ESP_MIP && addr == esp->command_block_dma) {
-		zorro_esp_send_pio_cmd(esp, (u32) esp->command_block,
-					esp_count, dma_count, write, cmd);
+		esp_send_pio_cmd(esp, (u32)esp->command_block, esp_count,
+				 dma_count, write, cmd);
 		return;
 	}
 
+	esp->send_cmd_error = 0;
+	esp->send_cmd_residual = 0;
+
 	if (write)
 		/* DMA receive */
 		dma_sync_single_for_device(esp->dev, addr, esp_count,
@@ -586,14 +422,16 @@ static void zorro_esp_send_cyber_dma_cmd(struct esp *esp, u32 addr,
 	u8 phase = esp->sreg & ESP_STAT_PMASK;
 	unsigned char *ctrl_data = &zep->ctrl_data;
 
-	zep->error = 0;
 	/* Use PIO if transferring message bytes to esp->command_block_dma */
 	if (phase == ESP_MIP && addr == esp->command_block_dma) {
-		zorro_esp_send_pio_cmd(esp, (u32) esp->command_block,
-					esp_count, dma_count, write, cmd);
+		esp_send_pio_cmd(esp, (u32)esp->command_block, esp_count,
+				 dma_count, write, cmd);
 		return;
 	}
 
+	esp->send_cmd_error = 0;
+	esp->send_cmd_residual = 0;
+
 	zorro_esp_write8(esp, (esp_count >> 0) & 0xff, ESP_TCLOW);
 	zorro_esp_write8(esp, (esp_count >> 8) & 0xff, ESP_TCMED);
 
@@ -631,18 +469,19 @@ static void zorro_esp_send_cyber_dma_cmd(struct esp *esp, u32 addr,
 static void zorro_esp_send_cyberII_dma_cmd(struct esp *esp, u32 addr,
 			u32 esp_count, u32 dma_count, int write, u8 cmd)
 {
-	struct zorro_esp_priv *zep = dev_get_drvdata(esp->dev);
 	struct cyberII_dma_registers __iomem *dregs = esp->dma_regs;
 	u8 phase = esp->sreg & ESP_STAT_PMASK;
 
-	zep->error = 0;
 	/* Use PIO if transferring message bytes to esp->command_block_dma */
 	if (phase == ESP_MIP && addr == esp->command_block_dma) {
-		zorro_esp_send_pio_cmd(esp, (u32) esp->command_block,
-					esp_count, dma_count, write, cmd);
+		esp_send_pio_cmd(esp, (u32)esp->command_block, esp_count,
+				 dma_count, write, cmd);
 		return;
 	}
 
+	esp->send_cmd_error = 0;
+	esp->send_cmd_residual = 0;
+
 	zorro_esp_write8(esp, (esp_count >> 0) & 0xff, ESP_TCLOW);
 	zorro_esp_write8(esp, (esp_count >> 8) & 0xff, ESP_TCMED);
 
@@ -676,14 +515,16 @@ static void zorro_esp_send_fastlane_dma_cmd(struct esp *esp, u32 addr,
 	u8 phase = esp->sreg & ESP_STAT_PMASK;
 	unsigned char *ctrl_data = &zep->ctrl_data;
 
-	zep->error = 0;
 	/* Use PIO if transferring message bytes to esp->command_block_dma */
 	if (phase == ESP_MIP && addr == esp->command_block_dma) {
-		zorro_esp_send_pio_cmd(esp, (u32) esp->command_block,
-					esp_count, dma_count, write, cmd);
+		esp_send_pio_cmd(esp, (u32)esp->command_block, esp_count,
+				 dma_count, write, cmd);
 		return;
 	}
 
+	esp->send_cmd_error = 0;
+	esp->send_cmd_residual = 0;
+
 	zorro_esp_write8(esp, (esp_count >> 0) & 0xff, ESP_TCLOW);
 	zorro_esp_write8(esp, (esp_count >> 8) & 0xff, ESP_TCMED);
 
@@ -718,14 +559,7 @@ static void zorro_esp_send_fastlane_dma_cmd(struct esp *esp, u32 addr,
 
 static int zorro_esp_dma_error(struct esp *esp)
 {
-	struct zorro_esp_priv *zep = dev_get_drvdata(esp->dev);
-
-	/* check for error in case we've been doing PIO */
-	if (zep->error == 1)
-		return 1;
-
-	/* do nothing - there seems to be no way to check for DMA errors */
-	return 0;
+	return esp->send_cmd_error;
 }
 
 /* per-board ESP driver ops */
@@ -1033,6 +867,8 @@ static int zorro_esp_probe(struct zorro_dev *z,
 		goto fail_unmap_fastlane;
 	}
 
+	esp->fifo_reg = esp->regs + ESP_FDATA * 4;
+
 	/* Check whether a Blizzard 12x0 or CyberstormII really has SCSI */
 	if (zdd->scsi_option) {
 		zorro_esp_write8(esp, (ESP_CONFIG1_PENABLE | 7), ESP_CFG1);
-- 
2.18.1
