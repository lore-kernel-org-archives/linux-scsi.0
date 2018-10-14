From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH v2 1/6] zorro_esp: Limit DMA transfers to 65535 bytes
Date: Sun, 14 Oct 2018 17:12:00 +1100
Message-ID: <022a8c581d228f3f01dfa783aadd183a53169daa.1539497520.git.fthain@telegraphics.com.au>
References: <cover.1539497520.git.fthain@telegraphics.com.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1539497520.git.fthain@telegraphics.com.au>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Michael Schmitz <schmitzmic@gmail.com>, Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org, linux-m68k@lists.linux-m68k.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

The core driver, esp_scsi, does not use the ESP_CONFIG2_FENAB bit, so
the chip's Transfer Counter register is only 16 bits wide (not 24).
A larger transfer cannot work and will theoretically result in a failed
command and a "DMA length is zero" error.

Fixes: 3109e5ae0311
Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
Cc: Michael Schmitz <schmitzmic@gmail.com>
Tested-by: Michael Schmitz <schmitzmic@gmail.com>
---
 drivers/scsi/zorro_esp.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/drivers/scsi/zorro_esp.c b/drivers/scsi/zorro_esp.c
index bb70882e6b56..be79127db594 100644
--- a/drivers/scsi/zorro_esp.c
+++ b/drivers/scsi/zorro_esp.c
@@ -245,7 +245,7 @@ static int fastlane_esp_irq_pending(struct esp *esp)
 static u32 zorro_esp_dma_length_limit(struct esp *esp, u32 dma_addr,
 					u32 dma_len)
 {
-	return dma_len > 0xFFFFFF ? 0xFFFFFF : dma_len;
+	return dma_len > 0xFFFF ? 0xFFFF : dma_len;
 }
 
 static void zorro_esp_reset_dma(struct esp *esp)
@@ -484,7 +484,6 @@ static void zorro_esp_send_blz1230_dma_cmd(struct esp *esp, u32 addr,
 	scsi_esp_cmd(esp, ESP_CMD_DMA);
 	zorro_esp_write8(esp, (esp_count >> 0) & 0xff, ESP_TCLOW);
 	zorro_esp_write8(esp, (esp_count >> 8) & 0xff, ESP_TCMED);
-	zorro_esp_write8(esp, (esp_count >> 16) & 0xff, ESP_TCHI);
 
 	scsi_esp_cmd(esp, cmd);
 }
@@ -529,7 +528,6 @@ static void zorro_esp_send_blz1230II_dma_cmd(struct esp *esp, u32 addr,
 	scsi_esp_cmd(esp, ESP_CMD_DMA);
 	zorro_esp_write8(esp, (esp_count >> 0) & 0xff, ESP_TCLOW);
 	zorro_esp_write8(esp, (esp_count >> 8) & 0xff, ESP_TCMED);
-	zorro_esp_write8(esp, (esp_count >> 16) & 0xff, ESP_TCHI);
 
 	scsi_esp_cmd(esp, cmd);
 }
@@ -574,7 +572,6 @@ static void zorro_esp_send_blz2060_dma_cmd(struct esp *esp, u32 addr,
 	scsi_esp_cmd(esp, ESP_CMD_DMA);
 	zorro_esp_write8(esp, (esp_count >> 0) & 0xff, ESP_TCLOW);
 	zorro_esp_write8(esp, (esp_count >> 8) & 0xff, ESP_TCMED);
-	zorro_esp_write8(esp, (esp_count >> 16) & 0xff, ESP_TCHI);
 
 	scsi_esp_cmd(esp, cmd);
 }
@@ -599,7 +596,6 @@ static void zorro_esp_send_cyber_dma_cmd(struct esp *esp, u32 addr,
 
 	zorro_esp_write8(esp, (esp_count >> 0) & 0xff, ESP_TCLOW);
 	zorro_esp_write8(esp, (esp_count >> 8) & 0xff, ESP_TCMED);
-	zorro_esp_write8(esp, (esp_count >> 16) & 0xff, ESP_TCHI);
 
 	if (write) {
 		/* DMA receive */
@@ -649,7 +645,6 @@ static void zorro_esp_send_cyberII_dma_cmd(struct esp *esp, u32 addr,
 
 	zorro_esp_write8(esp, (esp_count >> 0) & 0xff, ESP_TCLOW);
 	zorro_esp_write8(esp, (esp_count >> 8) & 0xff, ESP_TCMED);
-	zorro_esp_write8(esp, (esp_count >> 16) & 0xff, ESP_TCHI);
 
 	if (write) {
 		/* DMA receive */
@@ -691,7 +686,6 @@ static void zorro_esp_send_fastlane_dma_cmd(struct esp *esp, u32 addr,
 
 	zorro_esp_write8(esp, (esp_count >> 0) & 0xff, ESP_TCLOW);
 	zorro_esp_write8(esp, (esp_count >> 8) & 0xff, ESP_TCMED);
-	zorro_esp_write8(esp, (esp_count >> 16) & 0xff, ESP_TCHI);
 
 	if (write) {
 		/* DMA receive */
-- 
2.18.1
