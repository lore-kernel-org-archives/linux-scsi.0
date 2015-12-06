From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH v2 21/72] ncr5380: Sleep when polling, if possible
Date: Sun, 06 Dec 2015 12:31:47 +1100
Message-ID: <20151206013132.155478463@telegraphics.com.au>
References: <20151206013126.995379403@telegraphics.com.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline; filename=ncr5380-sleep-when-polling
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@odin.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

When in process context, sleep during polling if doing so won't add
significant latency. In interrupt context or if the lock is held, poll
briefly then give up. Keep both core drivers in sync.

Calibrate busy-wait iterations to allow for variation in chip register
access times between different 5380 hardware implementations.

Signed-off-by: Finn Thain <fthain@telegraphics.com.au>

---

Changed since v1:
- Don't rely on loops_per_jiffy to estimate register access speed, measure
  it instead.

---
 drivers/scsi/NCR5380.c       |   77 +++++++++++++++++++++++++------------------
 drivers/scsi/NCR5380.h       |    1 
 drivers/scsi/atari_NCR5380.c |   59 ++++++++++++++++++++------------
 3 files changed, 84 insertions(+), 53 deletions(-)

Index: linux/drivers/scsi/NCR5380.c
===================================================================
--- linux.orig/drivers/scsi/NCR5380.c	2015-12-06 12:29:51.000000000 +1100
+++ linux/drivers/scsi/NCR5380.c	2015-12-06 12:29:54.000000000 +1100
@@ -293,44 +293,48 @@ static inline void initialize_SCp(struct
 }
 
 /**
- *	NCR5380_poll_politely	-	wait for NCR5380 status bits
- *	@instance: controller to poll
- *	@reg: 5380 register to poll
- *	@bit: Bitmask to check
- *	@val: Value required to exit
- *
- *	Polls the NCR5380 in a reasonably efficient manner waiting for
- *	an event to occur, after a short quick poll we begin giving the
- *	CPU back in non IRQ contexts
+ * NCR5380_poll_politely - wait for chip register value
+ * @instance: controller to poll
+ * @reg: 5380 register to poll
+ * @bit: Bitmask to check
+ * @val: Value required to exit
+ * @wait: Time-out in jiffies
+ *
+ * Polls the chip in a reasonably efficient manner waiting for an
+ * event to occur. After a short quick poll we begin to yield the CPU
+ * (if possible). In irq contexts the time-out is arbitrarily limited.
+ * Callers may hold locks as long as they are held in irq mode.
  *
- *	Returns the value of the register or a negative error code.
+ * Returns 0 if event occurred otherwise -ETIMEDOUT.
  */
- 
-static int NCR5380_poll_politely(struct Scsi_Host *instance, int reg, int bit, int val, int t)
+
+static int NCR5380_poll_politely(struct Scsi_Host *instance,
+                                 int reg, int bit, int val, int wait)
 {
-	int n = 500;		/* At about 8uS a cycle for the cpu access */
-	unsigned long end = jiffies + t;
-	int r;
-
-	while( n-- > 0)
-	{
-		r = NCR5380_read(reg);
-		if((r & bit) == val)
+	struct NCR5380_hostdata *hostdata = shost_priv(instance);
+	unsigned long deadline = jiffies + wait;
+	unsigned long n;
+
+	/* Busy-wait for up to 10 ms */
+	n = min(10000U, jiffies_to_usecs(wait));
+	n *= hostdata->accesses_per_ms;
+	n /= 1000;
+	do {
+		if ((NCR5380_read(reg) & bit) == val)
 			return 0;
 		cpu_relax();
-	}
-	
-	/* t time yet ? */
-	while(time_before(jiffies, end))
-	{
-		r = NCR5380_read(reg);
-		if((r & bit) == val)
+	} while (n--);
+
+	if (irqs_disabled() || in_interrupt())
+		return -ETIMEDOUT;
+
+	/* Repeatedly sleep for 1 ms until deadline */
+	while (time_is_after_jiffies(deadline)) {
+		schedule_timeout_uninterruptible(1);
+		if ((NCR5380_read(reg) & bit) == val)
 			return 0;
-		if(!in_interrupt())
-			cond_resched();
-		else
-			cpu_relax();
 	}
+
 	return -ETIMEDOUT;
 }
 
@@ -773,6 +777,7 @@ static int NCR5380_init(struct Scsi_Host
 {
 	int i;
 	struct NCR5380_hostdata *hostdata = (struct NCR5380_hostdata *) instance->hostdata;
+	unsigned long deadline;
 
 	if(in_interrupt())
 		printk(KERN_ERR "NCR5380_init called with interrupts off!\n");
@@ -812,6 +817,16 @@ static int NCR5380_init(struct Scsi_Host
 	NCR5380_write(MODE_REG, MR_BASE);
 	NCR5380_write(TARGET_COMMAND_REG, 0);
 	NCR5380_write(SELECT_ENABLE_REG, 0);
+
+	/* Calibrate register polling loop */
+	i = 0;
+	deadline = jiffies + msecs_to_jiffies(100) + 1;
+	do {
+		NCR5380_read(STATUS_REG);
+		++i;
+	} while (time_is_after_jiffies(deadline));
+	hostdata->accesses_per_ms = i / 100;
+
 	return 0;
 }
 
Index: linux/drivers/scsi/atari_NCR5380.c
===================================================================
--- linux.orig/drivers/scsi/atari_NCR5380.c	2015-12-06 12:29:51.000000000 +1100
+++ linux/drivers/scsi/atari_NCR5380.c	2015-12-06 12:29:54.000000000 +1100
@@ -479,43 +479,48 @@ static inline void initialize_SCp(struct
 }
 
 /**
- * NCR5380_poll_politely - wait for NCR5380 status bits
+ * NCR5380_poll_politely - wait for chip register value
  * @instance: controller to poll
  * @reg: 5380 register to poll
  * @bit: Bitmask to check
  * @val: Value required to exit
+ * @wait: Time-out in jiffies
  *
- * Polls the NCR5380 in a reasonably efficient manner waiting for
- * an event to occur, after a short quick poll we begin giving the
- * CPU back in non IRQ contexts
+ * Polls the chip in a reasonably efficient manner waiting for an
+ * event to occur. After a short quick poll we begin to yield the CPU
+ * (if possible). In irq contexts the time-out is arbitrarily limited.
+ * Callers may hold locks as long as they are held in irq mode.
  *
- * Returns the value of the register or a negative error code.
+ * Returns 0 if event occurred otherwise -ETIMEDOUT.
  */
 
 static int NCR5380_poll_politely(struct Scsi_Host *instance,
-                                 int reg, int bit, int val, int t)
+                                 int reg, int bit, int val, int wait)
 {
-	int n = 500;
-	unsigned long end = jiffies + t;
-	int r;
-
-	while (n-- > 0) {
-		r = NCR5380_read(reg);
-		if ((r & bit) == val)
+	struct NCR5380_hostdata *hostdata = shost_priv(instance);
+	unsigned long deadline = jiffies + wait;
+	unsigned long n;
+
+	/* Busy-wait for up to 10 ms */
+	n = min(10000U, jiffies_to_usecs(wait));
+	n *= hostdata->accesses_per_ms;
+	n /= 1000;
+	do {
+		if ((NCR5380_read(reg) & bit) == val)
 			return 0;
 		cpu_relax();
-	}
+	} while (n--);
 
-	/* t time yet ? */
-	while (time_before(jiffies, end)) {
-		r = NCR5380_read(reg);
-		if ((r & bit) == val)
+	if (irqs_disabled() || in_interrupt())
+		return -ETIMEDOUT;
+
+	/* Repeatedly sleep for 1 ms until deadline */
+	while (time_is_after_jiffies(deadline)) {
+		schedule_timeout_uninterruptible(1);
+		if ((NCR5380_read(reg) & bit) == val)
 			return 0;
-		if (!in_interrupt())
-			cond_resched();
-		else
-			cpu_relax();
 	}
+
 	return -ETIMEDOUT;
 }
 
@@ -811,6 +816,7 @@ static int __init NCR5380_init(struct Sc
 {
 	int i;
 	SETUP_HOSTDATA(instance);
+	unsigned long deadline;
 
 	hostdata->host = instance;
 	hostdata->id_mask = 1 << instance->this_id;
@@ -845,6 +851,15 @@ static int __init NCR5380_init(struct Sc
 	NCR5380_write(TARGET_COMMAND_REG, 0);
 	NCR5380_write(SELECT_ENABLE_REG, 0);
 
+	/* Calibrate register polling loop */
+	i = 0;
+	deadline = jiffies + msecs_to_jiffies(100) + 1;
+	do {
+		NCR5380_read(STATUS_REG);
+		++i;
+	} while (time_is_after_jiffies(deadline));
+	hostdata->accesses_per_ms = i / 100;
+
 	return 0;
 }
 
Index: linux/drivers/scsi/NCR5380.h
===================================================================
--- linux.orig/drivers/scsi/NCR5380.h	2015-12-06 12:29:51.000000000 +1100
+++ linux/drivers/scsi/NCR5380.h	2015-12-06 12:29:54.000000000 +1100
@@ -285,6 +285,7 @@ struct NCR5380_hostdata {
 	unsigned spin_max_w;
 #endif
 	struct workqueue_struct *work_q;
+	unsigned long accesses_per_ms;	/* chip register accesses per ms */
 };
 
 #ifdef __KERNEL__
