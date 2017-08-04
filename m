From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH 2/5] scsi/mac_esp: Fix PIO transfers for MESSAGE IN phase
Date: Fri,  4 Aug 2017 01:43:19 -0400 (EDT)
Message-ID: <a816cbea4e64c26987e2ea07f29539bf7f4df406.1501825111.git.fthain@telegraphics.com.au>
References: <cover.1501825111.git.fthain@telegraphics.com.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1501825111.git.fthain@telegraphics.com.au>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>, David Miller <davem@davemloft.net>, Hannes Reinecke <hare@suse.com>, Meelis Roos <mroos@linux.ee>, Michael Schmitz <schmitzmic@gmail.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

When in MESSAGE IN phase, the ESP device does not automatically
acknowledge each byte that is transferred by PIO. The mac_esp driver
neglects to explicitly ack them, which causes a timeout during messages
larger than one byte (e.g. tag bytes during reconnect). Fix this with an
ESP_CMD_MOK command after each byte.

The MESSAGE IN phase is also different in that each byte transferred
raises ESP_INTR_FDONE. So don't exit the transfer loop for this interrupt,
for this phase.

That resolves the "Reconnect IRQ2 timeout" error on those Macs which use
PIO transfers instead of PDMA. This patch also improves on the weak tests
for unexpected interrupts and phase changes during PIO transfers.

Tested-by: Stan Johnson <userm57@yahoo.com>
Fixes: 02507a80b35e ("[PATCH] [SCSI] mac_esp: fix PIO mode, take 2")
Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
---
 drivers/scsi/mac_esp.c | 35 ++++++++++++++++++-----------------
 1 file changed, 18 insertions(+), 17 deletions(-)

diff --git a/drivers/scsi/mac_esp.c b/drivers/scsi/mac_esp.c
index 253142f3cf6f..eb551f3cc471 100644
--- a/drivers/scsi/mac_esp.c
+++ b/drivers/scsi/mac_esp.c
@@ -349,25 +349,23 @@ static void mac_esp_send_pio_cmd(struct esp *esp, u32 addr, u32 esp_count,
 {
 	struct mac_esp_priv *mep = MAC_ESP_GET_PRIV(esp);
 	u8 __iomem *fifo = esp->regs + ESP_FDATA * 16;
+	u8 phase = esp->sreg & ESP_STAT_PMASK;
 
 	cmd &= ~ESP_CMD_DMA;
 	mep->error = 0;
 
 	if (write) {
+		u8 *dst = (u8 *)addr;
+		u8 mask = ~(phase == ESP_MIP ? ESP_INTR_FDONE : ESP_INTR_BSERV);
+
 		scsi_esp_cmd(esp, cmd);
 
 		while (1) {
-			unsigned int n;
-
-			n = mac_esp_wait_for_fifo(esp);
-			if (!n)
+			if (!mac_esp_wait_for_fifo(esp))
 				break;
 
-			if (n > esp_count)
-				n = esp_count;
-			esp_count -= n;
-
-			MAC_ESP_PIO_LOOP("%2@,%0@+", n);
+			*dst++ = esp_read8(ESP_FDATA);
+			--esp_count;
 
 			if (!esp_count)
 				break;
@@ -375,14 +373,17 @@ static void mac_esp_send_pio_cmd(struct esp *esp, u32 addr, u32 esp_count,
 			if (mac_esp_wait_for_intr(esp))
 				break;
 
-			if (((esp->sreg & ESP_STAT_PMASK) != ESP_DIP) &&
-			    ((esp->sreg & ESP_STAT_PMASK) != ESP_MIP))
+			if ((esp->sreg & ESP_STAT_PMASK) != phase)
 				break;
 
 			esp->ireg = esp_read8(ESP_INTRPT);
-			if ((esp->ireg & (ESP_INTR_DC | ESP_INTR_BSERV)) !=
-			    ESP_INTR_BSERV)
+			if (esp->ireg & mask) {
+				mep->error = 1;
 				break;
+			}
+
+			if (phase == ESP_MIP)
+				scsi_esp_cmd(esp, ESP_CMD_MOK);
 
 			scsi_esp_cmd(esp, ESP_CMD_TI);
 		}
@@ -402,14 +403,14 @@ static void mac_esp_send_pio_cmd(struct esp *esp, u32 addr, u32 esp_count,
 			if (mac_esp_wait_for_intr(esp))
 				break;
 
-			if (((esp->sreg & ESP_STAT_PMASK) != ESP_DOP) &&
-			    ((esp->sreg & ESP_STAT_PMASK) != ESP_MOP))
+			if ((esp->sreg & ESP_STAT_PMASK) != phase)
 				break;
 
 			esp->ireg = esp_read8(ESP_INTRPT);
-			if ((esp->ireg & (ESP_INTR_DC | ESP_INTR_BSERV)) !=
-			    ESP_INTR_BSERV)
+			if (esp->ireg & ~ESP_INTR_BSERV) {
+				mep->error = 1;
 				break;
+			}
 
 			n = MAC_ESP_FIFO_SIZE -
 			    (esp_read8(ESP_FFLAGS) & ESP_FF_FBYTES);
-- 
2.13.0
