From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH] mac_esp: fix PIO mode
Date: Mon, 23 Nov 2009 14:57:42 +1100 (EST)
Message-ID: <alpine.OSX.2.00.0911231452300.468@localhost>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-m68k-owner@vger.kernel.org>
Sender: linux-m68k-owner@vger.kernel.org
To: "David S. Miller" <davem@davemloft.net>
Cc: linux-scsi@vger.kernel.org, linux-m68k@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


The mac_esp PIO algorithm no longer works in 2.6.31 and crashes my Centris 
660av. So here's a better one.

One of the SCSI drives I tested still doesn't like the PIO mode and fails 
with "esp: esp0: Reconnect IRQ2 timeout" (the same drive works fine in 
PDMA mode).

This failure happens when esp_reconnect_with_tag() tries to read in two 
tag bytes but the chip only provides one (0x20). I don't know what causes 
this. I decided not to waste any more time trying to fix it because the 
best solution is to rip out the PIO mode altogether and use the DMA 
engine.

Signed-off-by: Finn Thain <fthain@telegraphics.com.au>

---
 drivers/scsi/esp_scsi.c |   11 ++---
 drivers/scsi/mac_esp.c  |   97 ++++++++++++++++++++++++------------------------
 2 files changed, 55 insertions(+), 53 deletions(-)

Index: linux-2.6.31/drivers/scsi/mac_esp.c
===================================================================
--- linux-2.6.31.orig/drivers/scsi/mac_esp.c	2009-11-23 12:52:45.000000000 +1100
+++ linux-2.6.31/drivers/scsi/mac_esp.c	2009-11-23 12:56:15.000000000 +1100
@@ -22,7 +22,6 @@
 
 #include <asm/irq.h>
 #include <asm/dma.h>
-
 #include <asm/macints.h>
 #include <asm/macintosh.h>
 
@@ -278,24 +277,27 @@ static void mac_esp_send_pdma_cmd(struct
  * Programmed IO routines follow.
  */
 
-static inline int mac_esp_wait_for_fifo(struct esp *esp)
+static inline unsigned int mac_esp_wait_for_fifo(struct esp *esp)
 {
 	int i = 500000;
 
 	do {
-		if (esp_read8(ESP_FFLAGS) & ESP_FF_FBYTES)
-			return 0;
+		unsigned int fbytes = esp_read8(ESP_FFLAGS) & ESP_FF_FBYTES;
+
+		if (fbytes)
+			return fbytes;
 
 		udelay(2);
 	} while (--i);
 
 	printk(KERN_ERR PFX "FIFO is empty (sreg %02x)\n",
 	       esp_read8(ESP_STATUS));
-	return 1;
+	return 0;
 }
 
 static inline int mac_esp_wait_for_intr(struct esp *esp)
 {
+	struct mac_esp_priv *mep = MAC_ESP_GET_PRIV(esp);
 	int i = 500000;
 
 	do {
@@ -307,6 +309,7 @@ static inline int mac_esp_wait_for_intr(
 	} while (--i);
 
 	printk(KERN_ERR PFX "IRQ timeout (sreg %02x)\n", esp->sreg);
+	mep->error = 1;
 	return 1;
 }
 
@@ -346,11 +349,10 @@ static inline int mac_esp_wait_for_intr(
 static void mac_esp_send_pio_cmd(struct esp *esp, u32 addr, u32 esp_count,
 				 u32 dma_count, int write, u8 cmd)
 {
-	unsigned long flags;
 	struct mac_esp_priv *mep = MAC_ESP_GET_PRIV(esp);
 	u8 *fifo = esp->regs + ESP_FDATA * 16;
 
-	local_irq_save(flags);
+	disable_irq(esp->host->irq);
 
 	cmd &= ~ESP_CMD_DMA;
 	mep->error = 0;
@@ -358,11 +360,35 @@ static void mac_esp_send_pio_cmd(struct 
 	if (write) {
 		scsi_esp_cmd(esp, cmd);
 
-		if (!mac_esp_wait_for_intr(esp)) {
-			if (mac_esp_wait_for_fifo(esp))
-				esp_count = 0;
-		} else {
-			esp_count = 0;
+		while (1) {
+			unsigned int n;
+
+			n = mac_esp_wait_for_fifo(esp);
+			if (!n)
+				break;
+
+			if (n > esp_count)
+				n = esp_count;
+			esp_count -= n;
+
+			MAC_ESP_PIO_LOOP("%2@,%0@+", n);
+
+			if (!esp_count)
+				break;
+
+			if (mac_esp_wait_for_intr(esp))
+				break;
+
+			if (((esp->sreg & ESP_STAT_PMASK) != ESP_DIP) &&
+			    ((esp->sreg & ESP_STAT_PMASK) != ESP_MIP))
+				break;
+
+			esp->ireg = esp_read8(ESP_INTRPT);
+			if ((esp->ireg & (ESP_INTR_DC | ESP_INTR_BSERV)) !=
+			    ESP_INTR_BSERV)
+				break;
+
+			scsi_esp_cmd(esp, ESP_CMD_TI);
 		}
 	} else {
 		scsi_esp_cmd(esp, ESP_CMD_FLUSH);
@@ -373,47 +399,24 @@ static void mac_esp_send_pio_cmd(struct 
 			MAC_ESP_PIO_LOOP("%0@+,%2@", esp_count);
 
 		scsi_esp_cmd(esp, cmd);
-	}
-
-	while (esp_count) {
-		unsigned int n;
-
-		if (mac_esp_wait_for_intr(esp)) {
-			mep->error = 1;
-			break;
-		}
-
-		if (esp->sreg & ESP_STAT_SPAM) {
-			printk(KERN_ERR PFX "gross error\n");
-			mep->error = 1;
-			break;
-		}
 
-		n = esp_read8(ESP_FFLAGS) & ESP_FF_FBYTES;
-
-		if (write) {
-			if (n > esp_count)
-				n = esp_count;
-			esp_count -= n;
-
-			MAC_ESP_PIO_LOOP("%2@,%0@+", n);
+		while (esp_count) {
+			unsigned int n;
 
-			if ((esp->sreg & ESP_STAT_PMASK) == ESP_STATP)
+			if (mac_esp_wait_for_intr(esp))
 				break;
 
-			if (esp_count) {
-				esp->ireg = esp_read8(ESP_INTRPT);
-				if (esp->ireg & ESP_INTR_DC)
-					break;
+			if (((esp->sreg & ESP_STAT_PMASK) != ESP_DOP) &&
+			    ((esp->sreg & ESP_STAT_PMASK) != ESP_MOP))
+				break;
 
-				scsi_esp_cmd(esp, ESP_CMD_TI);
-			}
-		} else {
 			esp->ireg = esp_read8(ESP_INTRPT);
-			if (esp->ireg & ESP_INTR_DC)
+			if ((esp->ireg & (ESP_INTR_DC | ESP_INTR_BSERV)) !=
+			    ESP_INTR_BSERV)
 				break;
 
-			n = MAC_ESP_FIFO_SIZE - n;
+			n = MAC_ESP_FIFO_SIZE -
+			    (esp_read8(ESP_FFLAGS) & ESP_FF_FBYTES);
 			if (n > esp_count)
 				n = esp_count;
 
@@ -428,7 +431,7 @@ static void mac_esp_send_pio_cmd(struct 
 		}
 	}
 
-	local_irq_restore(flags);
+	enable_irq(esp->host->irq);
 }
 
 static int mac_esp_irq_pending(struct esp *esp)
Index: linux-2.6.31/drivers/scsi/esp_scsi.c
===================================================================
--- linux-2.6.31.orig/drivers/scsi/esp_scsi.c	2009-11-23 12:52:45.000000000 +1100
+++ linux-2.6.31/drivers/scsi/esp_scsi.c	2009-11-23 12:53:30.000000000 +1100
@@ -2405,12 +2405,6 @@ static int esp_slave_configure(struct sc
 	struct esp_target_data *tp = &esp->target[dev->id];
 	int goal_tags, queue_depth;
 
-	if (esp->flags & ESP_FLAG_DISABLE_SYNC) {
-		/* Bypass async domain validation */
-		dev->ppr  = 0;
-		dev->sdtr = 0;
-	}
-
 	goal_tags = 0;
 
 	if (dev->tagged_supported) {
@@ -2433,6 +2427,11 @@ static int esp_slave_configure(struct sc
 	}
 	tp->flags |= ESP_TGT_DISCONNECT;
 
+	if (esp->flags & ESP_FLAG_DISABLE_SYNC) {
+		dev->wdtr = spi_support_wide(dev->sdev_target) = 0;
+		dev->sdtr = spi_support_sync(dev->sdev_target) = 0;
+	}
+
 	if (!spi_initial_dv(dev->sdev_target))
 		spi_dv_device(dev);
 
