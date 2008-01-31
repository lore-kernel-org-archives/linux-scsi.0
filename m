From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 01/11] qla2xxx: Correct resource_size_t usages.
Date: Thu, 31 Jan 2008 12:33:44 -0800
Message-ID: <1201811634-19865-1-git-send-email-andrew.vasquez@qlogic.com>
References: <20080131203216.GB19014@plap3.qlogic.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:8343 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759696AbYAaUeG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 31 Jan 2008 15:34:06 -0500
In-Reply-To: <20080131203216.GB19014@plap3.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <james.bottomley@steeleye.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Seokmann Ju <seokmann.ju@qlogic.com>

Hmm, it looks like the conversion to resource_size_t usage
(3776541d8a46347a4924353a192c6ce4a3d04e2e) requires some additional
fixups to cleanup the structure-pointer castings used during IO mapped
accesses to the chip.

There's only a small number of locations, where the driver uses IO
mapped accesses to the hardware, the patch below should take care of
it without introducing to many structural changes to code flow.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_sup.c |   36 +++++++++++++++---------------------
 1 files changed, 15 insertions(+), 21 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_sup.c b/drivers/scsi/qla2xxx/qla_sup.c
index b68fb73..26822c8 100644
--- a/drivers/scsi/qla2xxx/qla_sup.c
+++ b/drivers/scsi/qla2xxx/qla_sup.c
@@ -893,6 +893,8 @@ qla2x00_flip_colors(scsi_qla_host_t *ha, uint16_t *pflags)
 	}
 }
 
+#define PIO_REG(h, r) ((h)->pio_address + offsetof(struct device_reg_2xxx, r))
+
 void
 qla2x00_beacon_blink(struct scsi_qla_host *ha)
 {
@@ -902,15 +904,12 @@ qla2x00_beacon_blink(struct scsi_qla_host *ha)
 	unsigned long flags;
 	struct device_reg_2xxx __iomem *reg = &ha->iobase->isp;
 
-	if (ha->pio_address)
-		reg = (struct device_reg_2xxx __iomem *)ha->pio_address;
-
 	spin_lock_irqsave(&ha->hardware_lock, flags);
 
 	/* Save the Original GPIOE. */
 	if (ha->pio_address) {
-		gpio_enable = RD_REG_WORD_PIO(&reg->gpioe);
-		gpio_data = RD_REG_WORD_PIO(&reg->gpiod);
+		gpio_enable = RD_REG_WORD_PIO(PIO_REG(ha, gpioe));
+		gpio_data = RD_REG_WORD_PIO(PIO_REG(ha, gpiod));
 	} else {
 		gpio_enable = RD_REG_WORD(&reg->gpioe);
 		gpio_data = RD_REG_WORD(&reg->gpiod);
@@ -920,7 +919,7 @@ qla2x00_beacon_blink(struct scsi_qla_host *ha)
 	gpio_enable |= GPIO_LED_MASK;
 
 	if (ha->pio_address) {
-		WRT_REG_WORD_PIO(&reg->gpioe, gpio_enable);
+		WRT_REG_WORD_PIO(PIO_REG(ha, gpioe), gpio_enable);
 	} else {
 		WRT_REG_WORD(&reg->gpioe, gpio_enable);
 		RD_REG_WORD(&reg->gpioe);
@@ -936,7 +935,7 @@ qla2x00_beacon_blink(struct scsi_qla_host *ha)
 
 	/* Set the modified gpio_data values */
 	if (ha->pio_address) {
-		WRT_REG_WORD_PIO(&reg->gpiod, gpio_data);
+		WRT_REG_WORD_PIO(PIO_REG(ha, gpiod), gpio_data);
 	} else {
 		WRT_REG_WORD(&reg->gpiod, gpio_data);
 		RD_REG_WORD(&reg->gpiod);
@@ -962,14 +961,11 @@ qla2x00_beacon_on(struct scsi_qla_host *ha)
 		return QLA_FUNCTION_FAILED;
 	}
 
-	if (ha->pio_address)
-		reg = (struct device_reg_2xxx __iomem *)ha->pio_address;
-
 	/* Turn off LEDs. */
 	spin_lock_irqsave(&ha->hardware_lock, flags);
 	if (ha->pio_address) {
-		gpio_enable = RD_REG_WORD_PIO(&reg->gpioe);
-		gpio_data = RD_REG_WORD_PIO(&reg->gpiod);
+		gpio_enable = RD_REG_WORD_PIO(PIO_REG(ha, gpioe));
+		gpio_data = RD_REG_WORD_PIO(PIO_REG(ha, gpiod));
 	} else {
 		gpio_enable = RD_REG_WORD(&reg->gpioe);
 		gpio_data = RD_REG_WORD(&reg->gpiod);
@@ -978,7 +974,7 @@ qla2x00_beacon_on(struct scsi_qla_host *ha)
 
 	/* Set the modified gpio_enable values. */
 	if (ha->pio_address) {
-		WRT_REG_WORD_PIO(&reg->gpioe, gpio_enable);
+		WRT_REG_WORD_PIO(PIO_REG(ha, gpioe), gpio_enable);
 	} else {
 		WRT_REG_WORD(&reg->gpioe, gpio_enable);
 		RD_REG_WORD(&reg->gpioe);
@@ -987,7 +983,7 @@ qla2x00_beacon_on(struct scsi_qla_host *ha)
 	/* Clear out previously set LED colour. */
 	gpio_data &= ~GPIO_LED_MASK;
 	if (ha->pio_address) {
-		WRT_REG_WORD_PIO(&reg->gpiod, gpio_data);
+		WRT_REG_WORD_PIO(PIO_REG(ha, gpiod), gpio_data);
 	} else {
 		WRT_REG_WORD(&reg->gpiod, gpio_data);
 		RD_REG_WORD(&reg->gpiod);
@@ -1244,13 +1240,12 @@ qla2x00_read_flash_byte(scsi_qla_host_t *ha, uint32_t addr)
 	if (ha->pio_address) {
 		uint16_t data2;
 
-		reg = (struct device_reg_2xxx __iomem *)ha->pio_address;
-		WRT_REG_WORD_PIO(&reg->flash_address, (uint16_t)addr);
+		WRT_REG_WORD_PIO(PIO_REG(ha, flash_address), (uint16_t)addr);
 		do {
-			data = RD_REG_WORD_PIO(&reg->flash_data);
+			data = RD_REG_WORD_PIO(PIO_REG(ha, flash_data));
 			barrier();
 			cpu_relax();
-			data2 = RD_REG_WORD_PIO(&reg->flash_data);
+			data2 = RD_REG_WORD_PIO(PIO_REG(ha, flash_data));
 		} while (data != data2);
 	} else {
 		WRT_REG_WORD(&reg->flash_address, (uint16_t)addr);
@@ -1304,9 +1299,8 @@ qla2x00_write_flash_byte(scsi_qla_host_t *ha, uint32_t addr, uint8_t data)
 
 	/* Always perform IO mapped accesses to the FLASH registers. */
 	if (ha->pio_address) {
-		reg = (struct device_reg_2xxx __iomem *)ha->pio_address;
-		WRT_REG_WORD_PIO(&reg->flash_address, (uint16_t)addr);
-		WRT_REG_WORD_PIO(&reg->flash_data, (uint16_t)data);
+		WRT_REG_WORD_PIO(PIO_REG(ha, flash_address), (uint16_t)addr);
+		WRT_REG_WORD_PIO(PIO_REG(ha, flash_data), (uint16_t)data);
 	} else {
 		WRT_REG_WORD(&reg->flash_address, (uint16_t)addr);
 		RD_REG_WORD(&reg->ctrl_status);		/* PCI Posting. */
-- 
1.5.4.rc5.5.gab98

