From: Ondrej Zary <linux@rainbow-software.org>
Subject: [PATCH 1/3] NCR5380: Use probe_irq_*() for IRQ probing
Date: Sun, 30 Oct 2016 23:40:01 +0100
Message-ID: <1477867203-7480-1-git-send-email-linux@rainbow-software.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Finn Thain <fthain@telegraphics.com.au>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Use standard probe_irq_on() and probe_irq_off() functions instead of own
implementation.
This prevents warning messages like this in the kernel log:
genirq: Flags mismatch irq 1. 00000000 (NCR-probe) vs. 00000080 (i8042)

Move the IRQ trigger code to a separate function so it can be used for
other purposes (testing if the IRQ works).

Also add missing IRQ reset after probe.

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
---
 drivers/scsi/NCR5380.c   |   72 +++++++++++++++++-----------------------------
 drivers/scsi/NCR5380.h   |    3 +-
 drivers/scsi/g_NCR5380.c |    2 +-
 3 files changed, 29 insertions(+), 48 deletions(-)

diff --git a/drivers/scsi/NCR5380.c b/drivers/scsi/NCR5380.c
index d849ffa..01c0027 100644
--- a/drivers/scsi/NCR5380.c
+++ b/drivers/scsi/NCR5380.c
@@ -351,50 +351,13 @@ static void NCR5380_print_phase(struct Scsi_Host *instance)
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
+static void NCR5380_trigger_irq(struct Scsi_Host *instance)
 {
 	struct NCR5380_hostdata *hostdata = shost_priv(instance);
-	unsigned long timeout;
-	int trying_irqs, i, mask;
-
-	for (trying_irqs = 0, i = 1, mask = 2; i < 16; ++i, mask <<= 1)
-		if ((mask & possible) && (request_irq(i, &probe_intr, 0, "NCR-probe", NULL) == 0))
-			trying_irqs |= mask;
-
-	timeout = jiffies + msecs_to_jiffies(250);
-	probe_irq = NO_IRQ;
+	unsigned long timeout = jiffies + msecs_to_jiffies(2500);
 
 	/*
-	 * A interrupt is triggered whenever BSY = false, SEL = true
+	 * An interrupt is triggered whenever BSY = false, SEL = true
 	 * and a bit set in the SELECT_ENABLE_REG is asserted on the
 	 * SCSI bus.
 	 *
@@ -402,23 +365,40 @@ static int __maybe_unused NCR5380_probe_irq(struct Scsi_Host *instance,
 	 * (I/O, C/D, and MSG) match those in the TCR, so we must reset that
 	 * to zero.
 	 */
-
 	NCR5380_write(TARGET_COMMAND_REG, 0);
 	NCR5380_write(SELECT_ENABLE_REG, hostdata->id_mask);
 	NCR5380_write(OUTPUT_DATA_REG, hostdata->id_mask);
 	NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE | ICR_ASSERT_DATA | ICR_ASSERT_SEL);
 
-	while (probe_irq == NO_IRQ && time_before(jiffies, timeout))
+	while (!(NCR5380_read(BUS_AND_STATUS_REG) & BASR_IRQ) &&
+	       time_before(jiffies, timeout))
 		schedule_timeout_uninterruptible(1);
 
 	NCR5380_write(SELECT_ENABLE_REG, 0);
 	NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
+}
 
-	for (i = 1, mask = 2; i < 16; ++i, mask <<= 1)
-		if (trying_irqs & mask)
-			free_irq(i, NULL);
+/**
+ * NCR5380_probe_irq	-	find the IRQ of an NCR5380
+ * @instance: NCR5380 controller
+ *
+ * Autoprobe for the IRQ line used by the NCR5380 by triggering an IRQ
+ * and then looking to see what interrupt actually turned up.
+ */
+
+static int NCR5380_probe_irq(struct Scsi_Host *instance)
+{
+	struct NCR5380_hostdata *hostdata = shost_priv(instance);
+	int irqs, irq;
+
+	irqs = probe_irq_on();
+	NCR5380_trigger_irq(instance);
+	irq = probe_irq_off(irqs);
+	NCR5380_read(RESET_PARITY_INTERRUPT_REG);
+	if (irq < 0)
+		irq = 0;
 
-	return probe_irq;
+	return irq;
 }
 
 /**
diff --git a/drivers/scsi/NCR5380.h b/drivers/scsi/NCR5380.h
index 3c6ce54..b2fca52 100644
--- a/drivers/scsi/NCR5380.h
+++ b/drivers/scsi/NCR5380.h
@@ -290,7 +290,8 @@ static inline struct scsi_cmnd *NCR5380_to_scmd(struct NCR5380_cmd *ncmd_ptr)
 #define NCR5380_dprint_phase(flg, arg) do {} while (0)
 #endif
 
-static int NCR5380_probe_irq(struct Scsi_Host *instance, int possible);
+static void NCR5380_trigger_irq(struct Scsi_Host *instance);
+static int NCR5380_probe_irq(struct Scsi_Host *instance);
 static int NCR5380_init(struct Scsi_Host *instance, int flags);
 static int NCR5380_maybe_reset_bus(struct Scsi_Host *);
 static void NCR5380_exit(struct Scsi_Host *instance);
diff --git a/drivers/scsi/g_NCR5380.c b/drivers/scsi/g_NCR5380.c
index 7299ad9..3790ed5 100644
--- a/drivers/scsi/g_NCR5380.c
+++ b/drivers/scsi/g_NCR5380.c
@@ -265,7 +265,7 @@ static int generic_NCR5380_init_one(struct scsi_host_template *tpnt,
 	if (irq != IRQ_AUTO)
 		instance->irq = irq;
 	else
-		instance->irq = NCR5380_probe_irq(instance, 0xffff);
+		instance->irq = NCR5380_probe_irq(instance);
 
 	/* Compatibility with documented NCR5380 kernel parameters */
 	if (instance->irq == 255)
-- 
Ondrej Zary
