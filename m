From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] m68k: mac_esp asm fix
Date: Mon, 17 Nov 2008 21:37:07 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0811172135200.14521@anakin>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-m68k-owner@vger.kernel.org>
Sender: linux-m68k-owner@vger.kernel.org
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, Linux/m68k <linux-m68k@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

From: Finn Thain <fthain@telegraphics.com.au>

Fix asm constraints and arguments so as not to transfer an odd byte when 
there may be more words to transfer. The bug would probably also cause 
exceptions sometimes by transferring one too many bytes.

Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
Can I queue it in the m68k tree for 2.6.29, or do you want it to go in through
the SCSI tree?

 drivers/scsi/mac_esp.c |   19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

--- a/drivers/scsi/mac_esp.c
+++ b/drivers/scsi/mac_esp.c
@@ -170,7 +170,7 @@ static inline int mac_esp_wait_for_dreq(
 
 #define MAC_ESP_PDMA_LOOP(operands) \
 	asm volatile ( \
-	     "       tstw %2                   \n" \
+	     "       tstw %1                   \n" \
 	     "       jbeq 20f                  \n" \
 	     "1:     movew " operands "        \n" \
 	     "2:     movew " operands "        \n" \
@@ -188,14 +188,14 @@ static inline int mac_esp_wait_for_dreq(
 	     "14:    movew " operands "        \n" \
 	     "15:    movew " operands "        \n" \
 	     "16:    movew " operands "        \n" \
-	     "       subqw #1,%2               \n" \
+	     "       subqw #1,%1               \n" \
 	     "       jbne 1b                   \n" \
-	     "20:    tstw %3                   \n" \
+	     "20:    tstw %2                   \n" \
 	     "       jbeq 30f                  \n" \
 	     "21:    movew " operands "        \n" \
-	     "       subqw #1,%3               \n" \
+	     "       subqw #1,%2               \n" \
 	     "       jbne 21b                  \n" \
-	     "30:    tstw %4                   \n" \
+	     "30:    tstw %3                   \n" \
 	     "       jbeq 40f                  \n" \
 	     "31:    moveb " operands "        \n" \
 	     "32:    nop                       \n" \
@@ -223,8 +223,8 @@ static inline int mac_esp_wait_for_dreq(
 	     "       .long  31b,40b            \n" \
 	     "       .long  32b,40b            \n" \
 	     "       .previous                 \n" \
-	     : "+a" (addr) \
-	     : "a" (mep->pdma_io), "r" (count32), "r" (count2), "g" (esp_count))
+	     : "+a" (addr), "+r" (count32), "+r" (count2) \
+	     : "g" (count1), "a" (mep->pdma_io))
 
 static void mac_esp_send_pdma_cmd(struct esp *esp, u32 addr, u32 esp_count,
 				  u32 dma_count, int write, u8 cmd)
@@ -247,19 +247,20 @@ static void mac_esp_send_pdma_cmd(struct
 	do {
 		unsigned int count32 = esp_count >> 5;
 		unsigned int count2 = (esp_count & 0x1F) >> 1;
+		unsigned int count1 = esp_count & 1;
 		unsigned int start_addr = addr;
 
 		if (mac_esp_wait_for_dreq(esp))
 			break;
 
 		if (write) {
-			MAC_ESP_PDMA_LOOP("%1@,%0@+");
+			MAC_ESP_PDMA_LOOP("%4@,%0@+");
 
 			esp_count -= addr - start_addr;
 		} else {
 			unsigned int n;
 
-			MAC_ESP_PDMA_LOOP("%0@+,%1@");
+			MAC_ESP_PDMA_LOOP("%0@+,%4@");
 
 			if (mac_esp_wait_for_empty_fifo(esp))
 				break;

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
