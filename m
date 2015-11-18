From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH 21/71] ncr5380: Sleep when polling, if possible
Date: Wed, 18 Nov 2015 19:35:16 +1100
Message-ID: <20151118083501.161956551@telegraphics.com.au>
References: <20151118083455.331768508@telegraphics.com.au>
Return-path: <linux-m68k-owner@vger.kernel.org>
Content-Disposition: inline; filename=ncr5380-sleep-when-polling
Sender: linux-m68k-owner@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@odin.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

When in process context, sleep during polling if doing so won't add
significant latency. In interrupt context or if the lock is held, poll
briefly then give up. Keep both core drivers in sync.

Signed-off-by: Finn Thain <fthain@telegraphics.com.au>

---
 drivers/scsi/NCR5380.c       |   73 +++++++++++++++++++++++++------------------
 drivers/scsi/atari_NCR5380.c |   58 +++++++++++++++++++++-------------
 2 files changed, 79 insertions(+), 52 deletions(-)

Index: linux/drivers/scsi/NCR5380.c
===================================================================
--- linux.orig/drivers/scsi/NCR5380.c	2015-11-18 19:33:27.000000000 +1100
+++ linux/drivers/scsi/NCR5380.c	2015-11-18 19:33:31.000000000 +1100
@@ -293,44 +293,57 @@ static inline void initialize_SCp(struct
 }
 
 /**
- *	NCR5380_poll_politely	-	wait for NCR5380 status bits
- *	@instance: controller to poll
- *	@reg: 5380 register to poll
- *	@bit: Bitmask to check
- *	@val: Value required to exit
+ * NCR5380_poll_politely - wait for chip register value
+ * @instance: controller to poll
+ * @reg: 5380 register to poll
+ * @bit: Bitmask to check
+ * @val: Value required to exit
+ * @wait: Time-out in jiffies
  *
- *	Polls the NCR5380 in a reasonably efficient manner waiting for
- *	an event to occur, after a short quick poll we begin giving the
- *	CPU back in non IRQ contexts
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
+	unsigned long start = jiffies;
+	unsigned long n;
+
+	/* Busy-wait for up to 1 jiffy */
+	n = loops_per_jiffy;
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
+	} while (--n > 0);
+
+	if (--wait <= 0)
+		return -ETIMEDOUT;
+
+	/* Busy-wait for up to 20 ms */
+	n = min(20000U, jiffies_to_usecs(wait));
+	do {
+		udelay(1);
+		if ((NCR5380_read(reg) & bit) == val)
+			return 0;
+		cpu_relax();
+	} while (--n > 0);
+
+	if (irqs_disabled() || in_interrupt())
+		return -ETIMEDOUT;
+
+	/* Repeatedly sleep for 1 ms until deadline */
+	while (time_is_after_jiffies(start + wait)) {
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
 
Index: linux/drivers/scsi/atari_NCR5380.c
===================================================================
--- linux.orig/drivers/scsi/atari_NCR5380.c	2015-11-18 19:33:27.000000000 +1100
+++ linux/drivers/scsi/atari_NCR5380.c	2015-11-18 19:33:31.000000000 +1100
@@ -479,43 +479,57 @@ static inline void initialize_SCp(struct
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
+	unsigned long start = jiffies;
+	unsigned long n;
+
+	/* Busy-wait for up to 1 jiffy */
+	n = loops_per_jiffy;
+	do {
+		if ((NCR5380_read(reg) & bit) == val)
 			return 0;
 		cpu_relax();
-	}
+	} while (--n > 0);
+
+	if (--wait <= 0)
+		return -ETIMEDOUT;
+
+	/* Busy-wait for up to 20 ms */
+	n = min(20000U, jiffies_to_usecs(wait));
+	do {
+		udelay(1);
+		if ((NCR5380_read(reg) & bit) == val)
+			return 0;
+		cpu_relax();
+	} while (--n > 0);
 
-	/* t time yet ? */
-	while (time_before(jiffies, end)) {
-		r = NCR5380_read(reg);
-		if ((r & bit) == val)
+	if (irqs_disabled() || in_interrupt())
+		return -ETIMEDOUT;
+
+	/* Repeatedly sleep for 1 ms until deadline */
+	while (time_is_after_jiffies(start + wait)) {
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
 
