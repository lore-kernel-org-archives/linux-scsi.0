From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 09/12] esp: correctly detect am53c974
Date: Mon, 24 Nov 2014 15:37:27 +0100
Message-ID: <1416839850-30475-10-git-send-email-hare@suse.de>
References: <1416839850-30475-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:46330 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754257AbaKXOhf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 24 Nov 2014 09:37:35 -0500
In-Reply-To: <1416839850-30475-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@lst.de>, Paolo@suse.de, "Bonzini <pbonzini"@redhat.com, "David S. Miller" <davem@davemloft.net>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

The am53c974 returns the same ID as the FAS236, but implements
things slightly differently. So detect the am53c974 by checking
for ESP_CONFIG4 register.

Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/am53c974.c |  2 ++
 drivers/scsi/esp_scsi.c | 17 ++++++++++++++++-
 drivers/scsi/esp_scsi.h | 15 +++++++++++++++
 3 files changed, 33 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/am53c974.c b/drivers/scsi/am53c974.c
index a42e8db..6e88e38 100644
--- a/drivers/scsi/am53c974.c
+++ b/drivers/scsi/am53c974.c
@@ -368,6 +368,8 @@ static void dc390_check_eeprom(struct esp *esp)
 	}
 	esp->scsi_id = EEbuf[DC390_EE_ADAPT_SCSI_ID];
 	esp->num_tags = 2 << EEbuf[DC390_EE_TAG_CMD_NUM];
+	if (EEbuf[DC390_EE_MODE2] & DC390_EE_MODE2_ACTIVE_NEGATION)
+		esp->config4 |= ESP_CONFIG4_RADE | ESP_CONFIG4_RAE;
 }
 
 static int pci_esp_probe_one(struct pci_dev *pdev,
diff --git a/drivers/scsi/esp_scsi.c b/drivers/scsi/esp_scsi.c
index 07b4d93..8a162be 100644
--- a/drivers/scsi/esp_scsi.c
+++ b/drivers/scsi/esp_scsi.c
@@ -268,6 +268,19 @@ static void esp_reset_esp(struct esp *esp)
 	} else {
 		esp->min_period = ((5 * esp->ccycle) / 1000);
 	}
+	if (esp->rev == FAS236) {
+		/*
+		 * The AM53c974 chip returns the same ID as FAS236;
+		 * try to configure glitch eater.
+		 */
+		u8 config4 = ESP_CONFIG4_GE1;
+		esp_write8(config4, ESP_CFG4);
+		config4 = esp_read8(ESP_CFG4);
+		if (config4 & ESP_CONFIG4_GE1) {
+			esp->rev = PCSCSI;
+			esp_write8(esp->config4, ESP_CFG4);
+		}
+	}
 	esp->max_period = (esp->max_period + 3)>>2;
 	esp->min_period = (esp->min_period + 3)>>2;
 
@@ -293,7 +306,8 @@ static void esp_reset_esp(struct esp *esp)
 		/* fallthrough... */
 
 	case FAS236:
-		/* Fast 236 or HME */
+	case PCSCSI:
+		/* Fast 236, AM53c974 or HME */
 		esp_write8(esp->config2, ESP_CFG2);
 		if (esp->rev == FASHME) {
 			u8 cfg3 = esp->target[0].esp_config3;
@@ -2364,6 +2378,7 @@ static const char *esp_chip_names[] = {
 	"FAS100A",
 	"FAST",
 	"FASHME",
+	"AM53C974",
 };
 
 static struct scsi_transport_template *esp_transport_template;
diff --git a/drivers/scsi/esp_scsi.h b/drivers/scsi/esp_scsi.h
index 5fa456c..84dcbe4 100644
--- a/drivers/scsi/esp_scsi.h
+++ b/drivers/scsi/esp_scsi.h
@@ -25,6 +25,7 @@
 #define ESP_CTEST	0x0aUL		/* wo  Chip test register      0x28  */
 #define ESP_CFG2	0x0bUL		/* rw  Second cfg register     0x2c  */
 #define ESP_CFG3	0x0cUL		/* rw  Third cfg register      0x30  */
+#define ESP_CFG4	0x0dUL		/* rw  Fourth cfg register     0x34  */
 #define ESP_TCHI	0x0eUL		/* rw  High bits transf count  0x38  */
 #define ESP_UID		ESP_TCHI	/* ro  Unique ID code          0x38  */
 #define FAS_RLO		ESP_TCHI	/* rw  HME extended counter    0x38  */
@@ -76,6 +77,18 @@
 #define ESP_CONFIG3_IMS       0x80     /* ID msg chk'ng        (esp/fas236)  */
 #define ESP_CONFIG3_OBPUSH    0x80     /* Push odd-byte to dma (hme)         */
 
+/* ESP config register 4 read-write, found only on am53c974 chips */
+#define ESP_CONFIG4_RADE      0x04     /* Active negation */
+#define ESP_CONFIG4_RAE       0x08     /* Active negation on REQ and ACK */
+#define ESP_CONFIG4_PWD       0x20     /* Reduced power feature */
+#define ESP_CONFIG4_GE0       0x40     /* Glitch eater bit 0 */
+#define ESP_CONFIG4_GE1       0x80     /* Glitch eater bit 1 */
+
+#define ESP_CONFIG_GE_12NS    (0)
+#define ESP_CONFIG_GE_25NS    (ESP_CONFIG_GE1)
+#define ESP_CONFIG_GE_35NS    (ESP_CONFIG_GE0)
+#define ESP_CONFIG_GE_0NS     (ESP_CONFIG_GE0 | ESP_CONFIG_GE1)
+
 /* ESP command register read-write */
 /* Group 1 commands:  These may be sent at any point in time to the ESP
  *                    chip.  None of them can generate interrupts 'cept
@@ -254,6 +267,7 @@ enum esp_rev {
 	FAS100A    = 0x04,
 	FAST       = 0x05,
 	FASHME     = 0x06,
+	PCSCSI     = 0x07,  /* AM53c974 */
 };
 
 struct esp_cmd_entry {
@@ -466,6 +480,7 @@ struct esp {
 	u8			bursts;
 	u8			config1;
 	u8			config2;
+	u8			config4;
 
 	u8			scsi_id;
 	u32			scsi_id_mask;
-- 
1.8.5.2

