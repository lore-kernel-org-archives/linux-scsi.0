From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH 4/4] g_NCR5380: Autoprobe board IRQ by default
Date: Mon,  5 Dec 2016 01:07:20 -0500 (EST)
Message-ID: <fc35f78a06d9ab0cd0e10c337b2168025d080f4e.1480917789.git.fthain@telegraphics.com.au>
References: <cover.1480917789.git.fthain@telegraphics.com.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1480917789.git.fthain@telegraphics.com.au>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Ondrej Zary <linux@rainbow-software.org>, Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Cc: Michael Schmitz <schmitzmic@gmail.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Automatically probe the board irq when no irq parameter is provided,
to simulate PnP. The old default behaviour was to disable the irq.

Update driver documentation accordingly and add some printk messages
to make this behaviour visible.

Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
---
 Documentation/scsi/g_NCR5380.txt | 46 ++++++++++++++++++++--------------------
 drivers/scsi/g_NCR5380.c         | 30 +++++++++++++++-----------
 2 files changed, 41 insertions(+), 35 deletions(-)

diff --git a/Documentation/scsi/g_NCR5380.txt b/Documentation/scsi/g_NCR5380.txt
index e2c1879..37b1967 100644
--- a/Documentation/scsi/g_NCR5380.txt
+++ b/Documentation/scsi/g_NCR5380.txt
@@ -6,17 +6,15 @@ NCR53c400 extensions (c) 1994,1995,1996 Kevin Lentin
 This file documents the NCR53c400 extensions by Kevin Lentin and some
 enhancements to the NCR5380 core.
 
-This driver supports both NCR5380 and NCR53c400 cards in port or memory
-mapped modes. Currently this driver can only support one of those mapping
-modes at a time but it does support both of these chips at the same time.
-The next release of this driver will support port & memory mapped cards at
-the same time. It should be able to handle multiple different cards in the
-same machine.
+This driver supports NCR5380 and NCR53c400 and compatible cards in port or
+memory mapped modes.
 
-The drivers/scsi/Makefile has an override in it for the most common
-NCR53c400 card, the Trantor T130B in its default configuration:
-	Port: 0x350
-	IRQ : 5
+Use of an interrupt is recommended, if supported by the board, as this will
+allow targets to disconnect and thereby improve SCSI bus utilization.
+
+If the irq parameter is 254 or is omitted entirely, the driver will probe
+for the correct IRQ line automatically. If the irq parameter is 0 or 255
+then no IRQ will be used.
 
 The NCR53c400 does not support DMA but it does have Pseudo-DMA which is
 supported by the driver.
@@ -47,22 +45,24 @@ These old-style parameters can support only one card:
   dtc_3181e=1  to set up for a Domex Technology Corp 3181E board
   hp_c2502=1   to set up for a Hewlett Packard C2502 board
 
-e.g.
-OLD: modprobe g_NCR5380 ncr_irq=5 ncr_addr=0x350 ncr_5380=1
-NEW: modprobe g_NCR5380 irq=5 base=0x350 card=0
-  for a port mapped NCR5380 board or
-
-OLD: modprobe g_NCR5380 ncr_irq=255 ncr_addr=0xc8000 ncr_53c400=1
-NEW: modprobe g_NCR5380 irq=255 base=0xc8000 card=1
-  for a memory mapped NCR53C400 board with interrupts disabled or
+E.g. Trantor T130B in its default configuration:
+modprobe g_NCR5380 irq=5 base=0x350 card=1
+or alternatively, using the old syntax,
+modprobe g_NCR5380 ncr_irq=5 ncr_addr=0x350 ncr_53c400=1
 
-NEW: modprobe g_NCR5380 irq=0,7 base=0x240,0x300 card=3,4
-  for two cards: DTC3181 (in non-PnP mode) at 0x240 with no IRQ
-             and HP C2502 at 0x300 with IRQ 7
+E.g. a port mapped NCR5380 board, driver to probe for IRQ:
+modprobe g_NCR5380 base=0x350 card=0
+or alternatively,
+modprobe g_NCR5380 ncr_addr=0x350 ncr_5380=1
 
-(255 should be specified for no or DMA interrupt, 254 to autoprobe for an 
-     IRQ line if overridden on the command line.)
+E.g. a memory mapped NCR53C400 board with no IRQ:
+modprobe g_NCR5380 irq=255 base=0xc8000 card=1
+or alternatively,
+modprobe g_NCR5380 ncr_irq=255 ncr_addr=0xc8000 ncr_53c400=1
 
+E.g. two cards, DTC3181 (in non-PnP mode) at 0x240 with no IRQ
+and HP C2502 at 0x300 with IRQ 7:
+modprobe g_NCR5380 irq=0,7 base=0x240,0x300 card=3,4
 
 Kevin Lentin
 K.Lentin@cs.monash.edu.au
diff --git a/drivers/scsi/g_NCR5380.c b/drivers/scsi/g_NCR5380.c
index 58a0b82..6f9665d 100644
--- a/drivers/scsi/g_NCR5380.c
+++ b/drivers/scsi/g_NCR5380.c
@@ -37,7 +37,7 @@
 #define MAX_CARDS 8
 
 /* old-style parameters for compatibility */
-static int ncr_irq;
+static int ncr_irq = -1;
 static int ncr_addr;
 static int ncr_5380;
 static int ncr_53c400;
@@ -52,9 +52,9 @@ module_param(ncr_53c400a, int, 0);
 module_param(dtc_3181e, int, 0);
 module_param(hp_c2502, int, 0);
 
-static int irq[] = { 0, 0, 0, 0, 0, 0, 0, 0 };
+static int irq[] = { -1, -1, -1, -1, -1, -1, -1, -1 };
 module_param_array(irq, int, NULL, 0);
-MODULE_PARM_DESC(irq, "IRQ number(s)");
+MODULE_PARM_DESC(irq, "IRQ number(s) (0=none, 254=auto [default])");
 
 static int base[] = { 0, 0, 0, 0, 0, 0, 0, 0 };
 module_param_array(base, int, NULL, 0);
@@ -344,6 +344,8 @@ static int generic_NCR5380_init_one(struct scsi_host_template *tpnt,
 	/* Compatibility with documented NCR5380 kernel parameters */
 	if (irq == 255 || irq == 0)
 		irq = NO_IRQ;
+	else if (irq == -1)
+		irq = IRQ_AUTO;
 
 	if (board == BOARD_HP_C2502) {
 		int *irq_table = hp_c2502_irqs;
@@ -370,24 +372,28 @@ static int generic_NCR5380_init_one(struct scsi_host_template *tpnt,
 		magic_configure(port_idx, board_irq, magic);
 	}
 
-	if (irq == IRQ_AUTO)
+	if (irq == IRQ_AUTO) {
 		instance->irq = g_NCR5380_probe_irq(instance);
-	else
+		if (instance->irq == NO_IRQ)
+			shost_printk(KERN_INFO, instance, "no irq detected\n");
+	} else {
 		instance->irq = irq;
+		if (instance->irq == NO_IRQ)
+			shost_printk(KERN_INFO, instance, "no irq provided\n");
+	}
 
 	if (instance->irq != NO_IRQ) {
 		if (request_irq(instance->irq, generic_NCR5380_intr,
 				0, "NCR5380", instance)) {
-			printk(KERN_WARNING "scsi%d : IRQ%d not free, interrupts disabled\n", instance->host_no, instance->irq);
 			instance->irq = NO_IRQ;
+			shost_printk(KERN_INFO, instance,
+			             "irq %d denied\n", instance->irq);
+		} else {
+			shost_printk(KERN_INFO, instance,
+			             "irq %d acquired\n", instance->irq);
 		}
 	}
 
-	if (instance->irq == NO_IRQ) {
-		printk(KERN_INFO "scsi%d : interrupts not enabled. for better interactive performance,\n", instance->host_no);
-		printk(KERN_INFO "scsi%d : please jumper the board for a free IRQ.\n", instance->host_no);
-	}
-
 	ret = scsi_add_host(instance, pdev);
 	if (ret)
 		goto out_free_irq;
@@ -698,7 +704,7 @@ static int __init generic_NCR5380_init(void)
 	int ret = 0;
 
 	/* compatibility with old-style parameters */
-	if (irq[0] == 0 && base[0] == 0 && card[0] == -1) {
+	if (irq[0] == -1 && base[0] == 0 && card[0] == -1) {
 		irq[0] = ncr_irq;
 		base[0] = ncr_addr;
 		if (ncr_5380)
-- 
2.7.3
