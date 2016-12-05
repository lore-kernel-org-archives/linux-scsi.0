From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH 3/4] g_NCR5380: Fix automatic IRQ on HP C2502 cards
Date: Mon,  5 Dec 2016 01:07:20 -0500 (EST)
Message-ID: <a49f09b81f372ef91f9b5e52ccbc92bcd1ae2e6f.1480917789.git.fthain@telegraphics.com.au>
References: <cover.1480917789.git.fthain@telegraphics.com.au>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:50458 "EHLO
        kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751020AbcLEGHW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Dec 2016 01:07:22 -0500
In-Reply-To: <cover.1480917789.git.fthain@telegraphics.com.au>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Ondrej Zary <linux@rainbow-software.org>
Cc: Michael Schmitz <schmitzmic@gmail.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

When IRQ_AUTO is used, the interrupt for HP C2502 cards gets disabled.
Fix this by programming the card for a suitable free irq. The code for
the free irq search comes from ALSA.

Also allow IRQ 9 to work (it aliases to IRQ 2 on the card), as per
Ondrej Zary's patch.

Suggested-by: Ondrej Zary <linux@rainbow-software.org>
Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
---
 drivers/scsi/g_NCR5380.c | 70 +++++++++++++++++++++++++++++++++++++++---------
 1 file changed, 57 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/g_NCR5380.c b/drivers/scsi/g_NCR5380.c
index 6d245a7..58a0b82 100644
--- a/drivers/scsi/g_NCR5380.c
+++ b/drivers/scsi/g_NCR5380.c
@@ -131,14 +131,33 @@ static void magic_configure(int idx, u8 irq, u8 magic[])
 	outb(magic[3], 0x379);
 	outb(magic[4], 0x379);
 
-	/* allowed IRQs for HP C2502 */
-	if (irq != 2 && irq != 3 && irq != 4 && irq != 5 && irq != 7)
-		irq = 0;
+	if (irq == 9)
+		irq = 2;
+
 	if (idx >= 0 && idx <= 7)
 		cfg = 0x80 | idx | (irq << 4);
 	outb(cfg, 0x379);
 }
 
+static irqreturn_t legacy_empty_irq_handler(int irq, void *dev_id)
+{
+	return IRQ_HANDLED;
+}
+
+static int legacy_find_free_irq(int *irq_table)
+{
+	while (*irq_table != -1) {
+		if (!request_irq(*irq_table, legacy_empty_irq_handler,
+		                 IRQF_PROBE_SHARED, "Test IRQ",
+		                 (void *)irq_table)) {
+			free_irq(*irq_table, (void *) irq_table);
+			return *irq_table;
+		}
+		irq_table++;
+	}
+	return -1;
+}
+
 static unsigned int ncr_53c400a_ports[] = {
 	0x280, 0x290, 0x300, 0x310, 0x330, 0x340, 0x348, 0x350, 0
 };
@@ -151,6 +170,9 @@ static u8 ncr_53c400a_magic[] = {	/* 53C400A & DTC436 */
 static u8 hp_c2502_magic[] = {	/* HP C2502 */
 	0x0f, 0x22, 0xf0, 0x20, 0x80
 };
+static int hp_c2502_irqs[] = {
+	9, 5, 7, 3, 4, -1
+};
 
 static int generic_NCR5380_init_one(struct scsi_host_template *tpnt,
 			struct device *pdev, int base, int irq, int board)
@@ -319,19 +341,41 @@ static int generic_NCR5380_init_one(struct scsi_host_template *tpnt,
 
 	NCR5380_maybe_reset_bus(instance);
 
-	if (irq != IRQ_AUTO)
-		instance->irq = irq;
-	else
-		instance->irq = g_NCR5380_probe_irq(instance);
-
 	/* Compatibility with documented NCR5380 kernel parameters */
-	if (instance->irq == 255)
-		instance->irq = NO_IRQ;
+	if (irq == 255 || irq == 0)
+		irq = NO_IRQ;
+
+	if (board == BOARD_HP_C2502) {
+		int *irq_table = hp_c2502_irqs;
+		int board_irq = -1;
+
+		switch (irq) {
+		case NO_IRQ:
+			board_irq = 0;
+			break;
+		case IRQ_AUTO:
+			board_irq = legacy_find_free_irq(irq_table);
+			break;
+		default:
+			while (*irq_table != -1)
+				if (*irq_table++ == irq)
+					board_irq = irq;
+		}
+
+		if (board_irq <= 0) {
+			board_irq = 0;
+			irq = NO_IRQ;
+		}
+
+		magic_configure(port_idx, board_irq, magic);
+	}
+
+	if (irq == IRQ_AUTO)
+		instance->irq = g_NCR5380_probe_irq(instance);
+	else
+		instance->irq = irq;
 
 	if (instance->irq != NO_IRQ) {
-		/* set IRQ for HP C2502 */
-		if (board == BOARD_HP_C2502)
-			magic_configure(port_idx, instance->irq, magic);
 		if (request_irq(instance->irq, generic_NCR5380_intr,
 				0, "NCR5380", instance)) {
 			printk(KERN_WARNING "scsi%d : IRQ%d not free, interrupts disabled\n", instance->host_no, instance->irq);
-- 
2.7.3

