From: Ondrej Zary <linux@rainbow-software.org>
Subject: [PATCH 4/6] g_NCR5380: Add IRQ auto-configuration for HP C2502
Date: Mon, 31 Oct 2016 21:18:30 +0100
Message-ID: <1477945112-25659-5-git-send-email-linux@rainbow-software.org>
References: <1477945112-25659-1-git-send-email-linux@rainbow-software.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1477945112-25659-1-git-send-email-linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Finn Thain <fthain@telegraphics.com.au>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Find free and working IRQ automatically on HP C2502 cards.
Also allow IRQ 9 to work (aliases to IRQ 2 on the card).

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
---
 drivers/scsi/g_NCR5380.c |   29 +++++++++++++++++++++++++++--
 1 file changed, 27 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/g_NCR5380.c b/drivers/scsi/g_NCR5380.c
index e713dba..27fc499 100644
--- a/drivers/scsi/g_NCR5380.c
+++ b/drivers/scsi/g_NCR5380.c
@@ -156,6 +156,8 @@ static void magic_configure(int idx, u8 irq, u8 magic[])
 	outb(magic[4], 0x379);
 
 	/* allowed IRQs for HP C2502 */
+	if (irq == 9)
+		irq = 2;
 	if (irq != 2 && irq != 3 && irq != 4 && irq != 5 && irq != 7)
 		irq = 0;
 	if (idx >= 0 && idx <= 7)
@@ -163,6 +165,21 @@ static void magic_configure(int idx, u8 irq, u8 magic[])
 	outb(cfg, 0x379);
 }
 
+/* find a free and working IRQ (for HP C2502) */
+static int NCR5380_find_irq(struct Scsi_Host *instance, u8 irqs[],
+			    int port_idx, u8 magic[])
+{
+	int i;
+
+	for (i = 0; irqs[i]; i++) {
+		magic_configure(port_idx, irqs[i], magic);
+		if (NCR5380_test_irq(instance, irqs[i]) == 0)
+			return irqs[i];
+	}
+	magic_configure(port_idx, 0, magic);
+	return NO_IRQ;
+}
+
 static unsigned int ncr_53c400a_ports[] = {
 	0x280, 0x290, 0x300, 0x310, 0x330, 0x340, 0x348, 0x350, 0
 };
@@ -175,6 +192,9 @@ static void magic_configure(int idx, u8 irq, u8 magic[])
 static u8 hp_c2502_magic[] = {	/* HP C2502 */
 	0x0f, 0x22, 0xf0, 0x20, 0x80
 };
+static u8 hp_c2502_irqs[] = {
+	9, 5, 7, 3, 4, 0
+};
 
 static int generic_NCR5380_init_one(struct scsi_host_template *tpnt,
 			struct device *pdev, int base, int irq, int board)
@@ -345,8 +365,13 @@ static int generic_NCR5380_init_one(struct scsi_host_template *tpnt,
 
 	if (irq != IRQ_AUTO)
 		instance->irq = irq;
-	else
-		instance->irq = NCR5380_probe_irq(instance);
+	else {
+		if (board == BOARD_HP_C2502)
+			instance->irq = NCR5380_find_irq(instance,
+						hp_c2502_irqs, port_idx, magic);
+		else
+			instance->irq = NCR5380_probe_irq(instance);
+	}
 
 	/* Compatibility with documented NCR5380 kernel parameters */
 	if (instance->irq == 255)
-- 
Ondrej Zary
