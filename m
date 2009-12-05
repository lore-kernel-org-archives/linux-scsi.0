From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH] mac_esp: fix PIO mode, take 2
Date: Sat, 5 Dec 2009 12:30:42 +1100 (EST)
Message-ID: <alpine.OSX.2.00.0912051228050.402@localhost>
References: <alpine.OSX.2.00.0911231452300.468@localhost>  <20091202.154045.142858043.davem@davemloft.net>  <alpine.OSX.2.00.0912042321220.596@localhost> <1259940684.2701.8.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-m68k-owner@vger.kernel.org>
In-Reply-To: <1259940684.2701.8.camel@mulgrave.site>
Sender: linux-m68k-owner@vger.kernel.org
To: David Miller <davem@davemloft.net>
Cc: James Bottomley <James.Bottomley@suse.de>, linux-scsi@vger.kernel.org, linux-m68k@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

The mac_esp PIO algorithm no longer works in 2.6.31 and crashes my Centris 
660av. So here's a better one.

Also, force async with esp_set_offset() rather than esp_slave_configure().

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
 drivers/scsi/esp_scsi.c |   14 ++-----
 drivers/scsi/mac_esp.c  |   95 ++++++++++++++++++++++++------------------------
 2 files changed, 53 insertions(+), 56 deletions(-)

Index: linux-2.6.31/drivers/scsi/mac_esp.c
===================================================================
--- linux-2.6.31.orig/drivers/scsi/mac_esp.c	2009-12-04 22:48:24.000000000 +1100
+++ linux-2.6.31/drivers/scsi/mac_esp.c	2009-12-04 22:49:02.000000000 +1100
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
--- linux-2.6.31.orig/drivers/scsi/esp_scsi.c	2009-12-04 22:48:24.000000000 +1100
+++ linux-2.6.31/drivers/scsi/esp_scsi.c	2009-12-05 12:24:58.000000000 +1100
@@ -1449,9 +1449,6 @@ static void esp_msgin_sdtr(struct esp *e
 	if (offset > 15)
 		goto do_reject;
 
-	if (esp->flags & ESP_FLAG_DISABLE_SYNC)
-		offset = 0;
-
 	if (offset) {
 		int one_clock;
 
@@ -2405,12 +2402,6 @@ static int esp_slave_configure(struct sc
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
@@ -2660,7 +2651,10 @@ static void esp_set_offset(struct scsi_t
 	struct esp *esp = shost_priv(host);
 	struct esp_target_data *tp = &esp->target[target->id];
 
-	tp->nego_goal_offset = offset;
+	if (esp->flags & ESP_FLAG_DISABLE_SYNC)
+		tp->nego_goal_offset = 0;
+	else
+		tp->nego_goal_offset = offset;
 	tp->flags |= ESP_TGT_CHECK_NEGO;
 }
 
