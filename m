From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 10/12] esp_scsi: let DMA driver provide a config2 value
Date: Fri, 21 Nov 2014 13:41:54 +0100
Message-ID: <1416573716-73890-11-git-send-email-hare@suse.de>
References: <1416573716-73890-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:51587 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758231AbaKUMmC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 21 Nov 2014 07:42:02 -0500
In-Reply-To: <1416573716-73890-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@lst.de>, Paolo Bonzini <pbonzini@redhat.com>, Guennadi Liakhovetski <g.liakhovetski@gmx.de>, "David S. Miller" <davem@davemloft.net>, linux-scsi@vger.kernel.org

From: Paolo Bonzini <pbonzini@redhat.com>

On PCscsi, the FENAB configuration also enables 24-bit DMA
transfer lengths (and provides the chip id in TCHI after reset).
We want to be able to enable this parameter from the DMA driver.

Check if the caller of scsi_esp_register provided a value for esp->config2.
If this is the case, assume this is not an ESP100, skip the detection
phase and leave esp->config2 untouched.  It will be used in esp_reset_esp.

Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 drivers/scsi/esp_scsi.c | 70 ++++++++++++++++++++++++++-----------------------
 1 file changed, 37 insertions(+), 33 deletions(-)

diff --git a/drivers/scsi/esp_scsi.c b/drivers/scsi/esp_scsi.c
index 797e208..bd17516 100644
--- a/drivers/scsi/esp_scsi.c
+++ b/drivers/scsi/esp_scsi.c
@@ -2219,46 +2219,50 @@ static void esp_get_revision(struct esp *esp)
 	u8 val;
 
 	esp->config1 = (ESP_CONFIG1_PENABLE | (esp->scsi_id & 7));
-	esp->config2 = (ESP_CONFIG2_SCSI2ENAB | ESP_CONFIG2_REGPARITY);
+	if (esp->config2 == 0) {
+		esp->config2 = (ESP_CONFIG2_SCSI2ENAB | ESP_CONFIG2_REGPARITY);
+		esp_write8(esp->config2, ESP_CFG2);
+
+		val = esp_read8(ESP_CFG2);
+		val &= ~ESP_CONFIG2_MAGIC;
+
+		esp->config2 = 0;
+		if (val != (ESP_CONFIG2_SCSI2ENAB | ESP_CONFIG2_REGPARITY)) {
+			/*
+			 * If what we write to cfg2 does not come back,
+			 * cfg2 is not implemented.
+			 * Therefore this must be a plain esp100.
+			 */
+			esp->rev = ESP100;
+			return;
+		}
+	}
+
+	esp_set_all_config3(esp, 5);
+	esp->prev_cfg3 = 5;
 	esp_write8(esp->config2, ESP_CFG2);
+	esp_write8(0, ESP_CFG3);
+	esp_write8(esp->prev_cfg3, ESP_CFG3);
 
-	val = esp_read8(ESP_CFG2);
-	val &= ~ESP_CONFIG2_MAGIC;
-	if (val != (ESP_CONFIG2_SCSI2ENAB | ESP_CONFIG2_REGPARITY)) {
-		/* If what we write to cfg2 does not come back, cfg2 is not
-		 * implemented, therefore this must be a plain esp100.
+	val = esp_read8(ESP_CFG3);
+	if (val != 5) {
+		/* The cfg2 register is implemented, however
+		 * cfg3 is not, must be esp100a.
 		 */
-		esp->rev = ESP100;
+		esp->rev = ESP100A;
 	} else {
-		esp->config2 = 0;
-		esp_set_all_config3(esp, 5);
-		esp->prev_cfg3 = 5;
-		esp_write8(esp->config2, ESP_CFG2);
-		esp_write8(0, ESP_CFG3);
+		esp_set_all_config3(esp, 0);
+		esp->prev_cfg3 = 0;
 		esp_write8(esp->prev_cfg3, ESP_CFG3);
 
-		val = esp_read8(ESP_CFG3);
-		if (val != 5) {
-			/* The cfg2 register is implemented, however
-			 * cfg3 is not, must be esp100a.
-			 */
-			esp->rev = ESP100A;
+		/* All of cfg{1,2,3} implemented, must be one of
+		 * the fas variants, figure out which one.
+		 */
+		if (esp->cfact == 0 || esp->cfact > ESP_CCF_F5) {
+			esp->rev = FAST;
+			esp->sync_defp = SYNC_DEFP_FAST;
 		} else {
-			esp_set_all_config3(esp, 0);
-			esp->prev_cfg3 = 0;
-			esp_write8(esp->prev_cfg3, ESP_CFG3);
-
-			/* All of cfg{1,2,3} implemented, must be one of
-			 * the fas variants, figure out which one.
-			 */
-			if (esp->cfact == 0 || esp->cfact > ESP_CCF_F5) {
-				esp->rev = FAST;
-				esp->sync_defp = SYNC_DEFP_FAST;
-			} else {
-				esp->rev = ESP236;
-			}
-			esp->config2 = 0;
-			esp_write8(esp->config2, ESP_CFG2);
+			esp->rev = ESP236;
 		}
 	}
 }
-- 
1.8.5.2

