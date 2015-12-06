From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH v2 09/72] atari_NCR5380: Reset bus on driver initialization if required
Date: Sun, 06 Dec 2015 12:31:35 +1100
Message-ID: <20151206013129.215468214@telegraphics.com.au>
References: <20151206013126.995379403@telegraphics.com.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline; filename=atari_NCR5380-merge-do_reset
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@odin.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Merge the bus reset code from NCR5380.c into atari_NCR5380.c. This allows
for removal of a lot of duplicated code conditional on the RESET_BOOT
macro (in the next patch).

The atari_NCR5380.c fork lacks the do_reset() and NCR5380_poll_politely()
routines from NCR5380.c, so introduce them. They are indispensible. Keep
the two implementations in sync.

Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
Reviewed-by: Hannes Reinecke <hare@suse.com>

---
 drivers/scsi/NCR5380.c       |   33 +++++++-----
 drivers/scsi/atari_NCR5380.c |  113 +++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 134 insertions(+), 12 deletions(-)

Index: linux/drivers/scsi/NCR5380.c
===================================================================
--- linux.orig/drivers/scsi/NCR5380.c	2015-12-06 12:29:33.000000000 +1100
+++ linux/drivers/scsi/NCR5380.c	2015-12-06 12:29:34.000000000 +1100
@@ -838,19 +838,20 @@ static int NCR5380_maybe_reset_bus(struc
 		case 1:
 		case 3:
 		case 5:
-			printk(KERN_INFO "scsi%d: SCSI bus busy, waiting up to five seconds\n", instance->host_no);
-			NCR5380_poll_politely(instance, STATUS_REG, SR_BSY, 0, 5*HZ);
+			shost_printk(KERN_ERR, instance, "SCSI bus busy, waiting up to five seconds\n");
+			NCR5380_poll_politely(instance,
+			                      STATUS_REG, SR_BSY, 0, 5 * HZ);
 			break;
 		case 2:
-			printk(KERN_WARNING "scsi%d: bus busy, attempting abort\n", instance->host_no);
+			shost_printk(KERN_ERR, instance, "bus busy, attempting abort\n");
 			do_abort(instance);
 			break;
 		case 4:
-			printk(KERN_WARNING "scsi%d: bus busy, attempting reset\n", instance->host_no);
+			shost_printk(KERN_ERR, instance, "bus busy, attempting reset\n");
 			do_reset(instance);
 			break;
 		case 6:
-			printk(KERN_ERR "scsi%d: bus locked solid or invalid override\n", instance->host_no);
+			shost_printk(KERN_ERR, instance, "bus locked solid\n");
 			return -ENXIO;
 		}
 	}
@@ -1579,21 +1580,29 @@ static int NCR5380_transfer_pio(struct S
 }
 
 /**
- *	do_reset	-	issue a reset command
- *	@host: adapter to reset
+ * do_reset - issue a reset command
+ * @instance: adapter to reset
  *
- *	Issue a reset sequence to the NCR5380 and try and get the bus
- *	back into sane shape.
+ * Issue a reset sequence to the NCR5380 and try and get the bus
+ * back into sane shape.
  *
- *	Locks: caller holds queue lock
+ * This clears the reset interrupt flag because there may be no handler for
+ * it. When the driver is initialized, the NCR5380_intr() handler has not yet
+ * been installed. And when in EH we may have released the ST DMA interrupt.
  */
  
 static void do_reset(struct Scsi_Host *instance)
 {
-	NCR5380_write(TARGET_COMMAND_REG, PHASE_SR_TO_TCR(NCR5380_read(STATUS_REG) & PHASE_MASK));
+	unsigned long flags;
+
+	local_irq_save(flags);
+	NCR5380_write(TARGET_COMMAND_REG,
+	              PHASE_SR_TO_TCR(NCR5380_read(STATUS_REG) & PHASE_MASK));
 	NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE | ICR_ASSERT_RST);
-	udelay(25);
+	udelay(50);
 	NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
+	(void)NCR5380_read(RESET_PARITY_INTERRUPT_REG);
+	local_irq_restore(flags);
 }
 
 /*
Index: linux/drivers/scsi/atari_NCR5380.c
===================================================================
--- linux.orig/drivers/scsi/atari_NCR5380.c	2015-12-06 12:29:18.000000000 +1100
+++ linux/drivers/scsi/atari_NCR5380.c	2015-12-06 12:29:34.000000000 +1100
@@ -234,6 +234,9 @@
 #define	HOSTNO		instance->host_no
 #define	H_NO(cmd)	(cmd)->device->host->host_no
 
+static int do_abort(struct Scsi_Host *);
+static void do_reset(struct Scsi_Host *);
+
 #ifdef SUPPORT_TAGS
 
 /*
@@ -475,6 +478,47 @@ static inline void initialize_SCp(struct
 	}
 }
 
+/**
+ * NCR5380_poll_politely - wait for NCR5380 status bits
+ * @instance: controller to poll
+ * @reg: 5380 register to poll
+ * @bit: Bitmask to check
+ * @val: Value required to exit
+ *
+ * Polls the NCR5380 in a reasonably efficient manner waiting for
+ * an event to occur, after a short quick poll we begin giving the
+ * CPU back in non IRQ contexts
+ *
+ * Returns the value of the register or a negative error code.
+ */
+
+static int NCR5380_poll_politely(struct Scsi_Host *instance,
+                                 int reg, int bit, int val, int t)
+{
+	int n = 500;
+	unsigned long end = jiffies + t;
+	int r;
+
+	while (n-- > 0) {
+		r = NCR5380_read(reg);
+		if ((r & bit) == val)
+			return 0;
+		cpu_relax();
+	}
+
+	/* t time yet ? */
+	while (time_before(jiffies, end)) {
+		r = NCR5380_read(reg);
+		if ((r & bit) == val)
+			return 0;
+		if (!in_interrupt())
+			cond_resched();
+		else
+			cpu_relax();
+	}
+	return -ETIMEDOUT;
+}
+
 #include <linux/delay.h>
 
 #if NDEBUG
@@ -801,6 +845,49 @@ static int __init NCR5380_init(struct Sc
 }
 
 /**
+ * NCR5380_maybe_reset_bus - Detect and correct bus wedge problems.
+ * @instance: adapter to check
+ *
+ * If the system crashed, it may have crashed with a connected target and
+ * the SCSI bus busy. Check for BUS FREE phase. If not, try to abort the
+ * currently established nexus, which we know nothing about. Failing that
+ * do a bus reset.
+ *
+ * Note that a bus reset will cause the chip to assert IRQ.
+ *
+ * Returns 0 if successful, otherwise -ENXIO.
+ */
+
+static int NCR5380_maybe_reset_bus(struct Scsi_Host *instance)
+{
+	int pass;
+
+	for (pass = 1; (NCR5380_read(STATUS_REG) & SR_BSY) && pass <= 6; ++pass) {
+		switch (pass) {
+		case 1:
+		case 3:
+		case 5:
+			shost_printk(KERN_ERR, instance, "SCSI bus busy, waiting up to five seconds\n");
+			NCR5380_poll_politely(instance,
+			                      STATUS_REG, SR_BSY, 0, 5 * HZ);
+			break;
+		case 2:
+			shost_printk(KERN_ERR, instance, "bus busy, attempting abort\n");
+			do_abort(instance);
+			break;
+		case 4:
+			shost_printk(KERN_ERR, instance, "bus busy, attempting reset\n");
+			do_reset(instance);
+			break;
+		case 6:
+			shost_printk(KERN_ERR, instance, "bus locked solid\n");
+			return -ENXIO;
+		}
+	}
+	return 0;
+}
+
+/**
  * NCR5380_exit - remove an NCR5380
  * @instance: adapter to remove
  *
@@ -1741,6 +1828,32 @@ static int NCR5380_transfer_pio(struct S
 		return -1;
 }
 
+/**
+ * do_reset - issue a reset command
+ * @instance: adapter to reset
+ *
+ * Issue a reset sequence to the NCR5380 and try and get the bus
+ * back into sane shape.
+ *
+ * This clears the reset interrupt flag because there may be no handler for
+ * it. When the driver is initialized, the NCR5380_intr() handler has not yet
+ * been installed. And when in EH we may have released the ST DMA interrupt.
+ */
+
+static void do_reset(struct Scsi_Host *instance)
+{
+	unsigned long flags;
+
+	local_irq_save(flags);
+	NCR5380_write(TARGET_COMMAND_REG,
+	              PHASE_SR_TO_TCR(NCR5380_read(STATUS_REG) & PHASE_MASK));
+	NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE | ICR_ASSERT_RST);
+	udelay(50);
+	NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
+	(void)NCR5380_read(RESET_PARITY_INTERRUPT_REG);
+	local_irq_restore(flags);
+}
+
 /*
  * Function : do_abort (Scsi_Host *host)
  *
