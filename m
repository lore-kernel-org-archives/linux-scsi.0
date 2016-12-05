From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH 2/4] g_NCR5380: Use probe_irq_*() for IRQ probing
Date: Mon,  5 Dec 2016 01:07:20 -0500 (EST)
Message-ID: <c0c695bf707aa79e92774ad7a3d4b271eb71cd9e.1480917789.git.fthain@telegraphics.com.au>
References: <cover.1480917789.git.fthain@telegraphics.com.au>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:50462 "EHLO
        kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750746AbcLEGHW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Dec 2016 01:07:22 -0500
In-Reply-To: <cover.1480917789.git.fthain@telegraphics.com.au>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Ondrej Zary <linux@rainbow-software.org>
Cc: Michael Schmitz <schmitzmic@gmail.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

From: Ondrej Zary <linux@rainbow-software.org>

Use standard probe_irq_on() and probe_irq_off() functions instead of
own implementation.
This prevents warning messages like this in the kernel log:
genirq: Flags mismatch irq 1. 00000000 (NCR-probe) vs. 00000080 (i8042)

Move the IRQ trigger code from NCR5380 to g_NCR5380 where it is used.

Also clear interrupt flag before and after the probe.

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
---
 drivers/scsi/NCR5380.c   | 77 +-----------------------------------------------
 drivers/scsi/NCR5380.h   | 11 -------
 drivers/scsi/g_NCR5380.c | 52 +++++++++++++++++++++++++++++++-
 drivers/scsi/g_NCR5380.h |  2 ++
 4 files changed, 54 insertions(+), 88 deletions(-)

diff --git a/drivers/scsi/NCR5380.c b/drivers/scsi/NCR5380.c
index d849ffa..4f5ca79 100644
--- a/drivers/scsi/NCR5380.c
+++ b/drivers/scsi/NCR5380.c
@@ -97,9 +97,6 @@
  * and macros and include this file in your driver.
  *
  * These macros control options :
- * AUTOPROBE_IRQ - if defined, the NCR5380_probe_irq() function will be
- * defined.
- *
  * AUTOSENSE - if defined, REQUEST SENSE will be performed automatically
  * for commands that return with a CHECK CONDITION status.
  *
@@ -127,9 +124,7 @@
  * NCR5380_dma_residual   - residual byte count
  *
  * The generic driver is initialized by calling NCR5380_init(instance),
- * after setting the appropriate host specific fields and ID.  If the
- * driver wishes to autoprobe for an IRQ line, the NCR5380_probe_irq(instance,
- * possible) function may be used.
+ * after setting the appropriate host specific fields and ID.
  */
 
 #ifndef NCR5380_io_delay
@@ -351,76 +346,6 @@ static void NCR5380_print_phase(struct Scsi_Host *instance)
 }
 #endif
 
-
-static int probe_irq;
-
-/**
- * probe_intr	-	helper for IRQ autoprobe
- * @irq: interrupt number
- * @dev_id: unused
- * @regs: unused
- *
- * Set a flag to indicate the IRQ in question was received. This is
- * used by the IRQ probe code.
- */
-
-static irqreturn_t probe_intr(int irq, void *dev_id)
-{
-	probe_irq = irq;
-	return IRQ_HANDLED;
-}
-
-/**
- * NCR5380_probe_irq	-	find the IRQ of an NCR5380
- * @instance: NCR5380 controller
- * @possible: bitmask of ISA IRQ lines
- *
- * Autoprobe for the IRQ line used by the NCR5380 by triggering an IRQ
- * and then looking to see what interrupt actually turned up.
- */
-
-static int __maybe_unused NCR5380_probe_irq(struct Scsi_Host *instance,
-						int possible)
-{
-	struct NCR5380_hostdata *hostdata = shost_priv(instance);
-	unsigned long timeout;
-	int trying_irqs, i, mask;
-
-	for (trying_irqs = 0, i = 1, mask = 2; i < 16; ++i, mask <<= 1)
-		if ((mask & possible) && (request_irq(i, &probe_intr, 0, "NCR-probe", NULL) == 0))
-			trying_irqs |= mask;
-
-	timeout = jiffies + msecs_to_jiffies(250);
-	probe_irq = NO_IRQ;
-
-	/*
-	 * A interrupt is triggered whenever BSY = false, SEL = true
-	 * and a bit set in the SELECT_ENABLE_REG is asserted on the
-	 * SCSI bus.
-	 *
-	 * Note that the bus is only driven when the phase control signals
-	 * (I/O, C/D, and MSG) match those in the TCR, so we must reset that
-	 * to zero.
-	 */
-
-	NCR5380_write(TARGET_COMMAND_REG, 0);
-	NCR5380_write(SELECT_ENABLE_REG, hostdata->id_mask);
-	NCR5380_write(OUTPUT_DATA_REG, hostdata->id_mask);
-	NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE | ICR_ASSERT_DATA | ICR_ASSERT_SEL);
-
-	while (probe_irq == NO_IRQ && time_before(jiffies, timeout))
-		schedule_timeout_uninterruptible(1);
-
-	NCR5380_write(SELECT_ENABLE_REG, 0);
-	NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
-
-	for (i = 1, mask = 2; i < 16; ++i, mask <<= 1)
-		if (trying_irqs & mask)
-			free_irq(i, NULL);
-
-	return probe_irq;
-}
-
 /**
  * NCR58380_info - report driver and host information
  * @instance: relevant scsi host instance
diff --git a/drivers/scsi/NCR5380.h b/drivers/scsi/NCR5380.h
index 3c6ce54..51a3567 100644
--- a/drivers/scsi/NCR5380.h
+++ b/drivers/scsi/NCR5380.h
@@ -199,16 +199,6 @@
 
 #define PHASE_SR_TO_TCR(phase) ((phase) >> 2)
 
-/*
- * These are "special" values for the irq and dma_channel fields of the 
- * Scsi_Host structure
- */
-
-#define DMA_NONE	255
-#define IRQ_AUTO	254
-#define DMA_AUTO	254
-#define PORT_AUTO	0xffff	/* autoprobe io port for 53c400a */
-
 #ifndef NO_IRQ
 #define NO_IRQ		0
 #endif
@@ -290,7 +280,6 @@ static void NCR5380_print(struct Scsi_Host *instance);
 #define NCR5380_dprint_phase(flg, arg) do {} while (0)
 #endif
 
-static int NCR5380_probe_irq(struct Scsi_Host *instance, int possible);
 static int NCR5380_init(struct Scsi_Host *instance, int flags);
 static int NCR5380_maybe_reset_bus(struct Scsi_Host *);
 static void NCR5380_exit(struct Scsi_Host *instance);
diff --git a/drivers/scsi/g_NCR5380.c b/drivers/scsi/g_NCR5380.c
index 76e3745..6d245a7 100644
--- a/drivers/scsi/g_NCR5380.c
+++ b/drivers/scsi/g_NCR5380.c
@@ -67,6 +67,56 @@ MODULE_PARM_DESC(card, "card type (0=NCR5380, 1=NCR53C400, 2=NCR53C400A, 3=DTC31
 MODULE_ALIAS("g_NCR5380_mmio");
 MODULE_LICENSE("GPL");
 
+static void g_NCR5380_trigger_irq(struct Scsi_Host *instance)
+{
+	struct NCR5380_hostdata *hostdata = shost_priv(instance);
+
+	/*
+	 * An interrupt is triggered whenever BSY = false, SEL = true
+	 * and a bit set in the SELECT_ENABLE_REG is asserted on the
+	 * SCSI bus.
+	 *
+	 * Note that the bus is only driven when the phase control signals
+	 * (I/O, C/D, and MSG) match those in the TCR.
+	 */
+	NCR5380_write(TARGET_COMMAND_REG,
+	              PHASE_SR_TO_TCR(NCR5380_read(STATUS_REG) & PHASE_MASK));
+	NCR5380_write(SELECT_ENABLE_REG, hostdata->id_mask);
+	NCR5380_write(OUTPUT_DATA_REG, hostdata->id_mask);
+	NCR5380_write(INITIATOR_COMMAND_REG,
+	              ICR_BASE | ICR_ASSERT_DATA | ICR_ASSERT_SEL);
+
+	msleep(1);
+
+	NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
+	NCR5380_write(SELECT_ENABLE_REG, 0);
+	NCR5380_write(TARGET_COMMAND_REG, 0);
+}
+
+/**
+ * g_NCR5380_probe_irq - find the IRQ of a NCR5380 or equivalent
+ * @instance: SCSI host instance
+ *
+ * Autoprobe for the IRQ line used by the card by triggering an IRQ
+ * and then looking to see what interrupt actually turned up.
+ */
+
+static int g_NCR5380_probe_irq(struct Scsi_Host *instance)
+{
+	struct NCR5380_hostdata *hostdata = shost_priv(instance);
+	int irq_mask, irq;
+
+	NCR5380_read(RESET_PARITY_INTERRUPT_REG);
+	irq_mask = probe_irq_on();
+	g_NCR5380_trigger_irq(instance);
+	irq = probe_irq_off(irq_mask);
+	NCR5380_read(RESET_PARITY_INTERRUPT_REG);
+
+	if (irq <= 0)
+		return NO_IRQ;
+	return irq;
+}
+
 /*
  * Configure I/O address of 53C400A or DTC436 by writing magic numbers
  * to ports 0x779 and 0x379.
@@ -272,7 +322,7 @@ static int generic_NCR5380_init_one(struct scsi_host_template *tpnt,
 	if (irq != IRQ_AUTO)
 		instance->irq = irq;
 	else
-		instance->irq = NCR5380_probe_irq(instance, 0xffff);
+		instance->irq = g_NCR5380_probe_irq(instance);
 
 	/* Compatibility with documented NCR5380 kernel parameters */
 	if (instance->irq == 255)
diff --git a/drivers/scsi/g_NCR5380.h b/drivers/scsi/g_NCR5380.h
index 3ce5b65..81b22d9 100644
--- a/drivers/scsi/g_NCR5380.h
+++ b/drivers/scsi/g_NCR5380.h
@@ -51,4 +51,6 @@
 #define BOARD_DTC3181E	3
 #define BOARD_HP_C2502	4
 
+#define IRQ_AUTO	254
+
 #endif /* GENERIC_NCR5380_H */
-- 
2.7.3

