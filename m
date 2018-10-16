From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH v3 6/6] esp_scsi: Optimize PIO loops
Date: Tue, 16 Oct 2018 16:31:25 +1100
Message-ID: <946e04372882bea6f6987852a49f006dfa1084ac.1539667885.git.fthain@telegraphics.com.au>
References: <cover.1539667885.git.fthain@telegraphics.com.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1539667885.git.fthain@telegraphics.com.au>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Michael Schmitz <schmitzmic@gmail.com>, Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org, linux-m68k@lists.linux-m68k.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Avoid function calls in the inner PIO loops. On a Centris 660av this
improves throughput for sequential read transfers by about 40% and
sequential write by about 10%.

Unfortunately it is not possible to have methods like .esp_write8
placed inline so this is always going to be slow, even with LTO.

Tested-by: Stan Johnson <userm57@yahoo.com>
Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
Tested-by: Michael Schmitz <schmitzmic@gmail.com>
---
Changed since v1:
 - Don't touch the scsi_esp_cmd(esp, ESP_CMD_FLUSH) as it's outside the loop.
---
 drivers/scsi/esp_scsi.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/esp_scsi.c b/drivers/scsi/esp_scsi.c
index 0f0d486be486..c3077c064522 100644
--- a/drivers/scsi/esp_scsi.c
+++ b/drivers/scsi/esp_scsi.c
@@ -2783,7 +2783,7 @@ static inline unsigned int esp_wait_for_fifo(struct esp *esp)
 		if (fbytes)
 			return fbytes;
 
-		udelay(2);
+		udelay(1);
 	} while (--i);
 
 	shost_printk(KERN_ERR, esp->host, "FIFO is empty. sreg [%02x]\n",
@@ -2800,7 +2800,7 @@ static inline int esp_wait_for_intr(struct esp *esp)
 		if (esp->sreg & ESP_STAT_INTR)
 			return 0;
 
-		udelay(2);
+		udelay(1);
 	} while (--i);
 
 	shost_printk(KERN_ERR, esp->host, "IRQ timeout. sreg [%02x]\n",
@@ -2828,7 +2828,7 @@ void esp_send_pio_cmd(struct esp *esp, u32 addr, u32 esp_count,
 			if (!esp_wait_for_fifo(esp))
 				break;
 
-			*dst++ = esp_read8(ESP_FDATA);
+			*dst++ = readb(esp->fifo_reg);
 			--esp_count;
 
 			if (!esp_count)
@@ -2849,9 +2849,9 @@ void esp_send_pio_cmd(struct esp *esp, u32 addr, u32 esp_count,
 			}
 
 			if (phase == ESP_MIP)
-				scsi_esp_cmd(esp, ESP_CMD_MOK);
+				esp_write8(ESP_CMD_MOK, ESP_CMD);
 
-			scsi_esp_cmd(esp, ESP_CMD_TI);
+			esp_write8(ESP_CMD_TI, ESP_CMD);
 		}
 	} else {
 		unsigned int n = ESP_FIFO_SIZE;
@@ -2891,7 +2891,7 @@ void esp_send_pio_cmd(struct esp *esp, u32 addr, u32 esp_count,
 			src += n;
 			esp_count -= n;
 
-			scsi_esp_cmd(esp, ESP_CMD_TI);
+			esp_write8(ESP_CMD_TI, ESP_CMD);
 		}
 	}
 
-- 
2.18.1
