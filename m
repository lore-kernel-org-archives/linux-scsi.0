From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH 40/71] ncr5380: Introduce NCR5380_poll_politely2
Date: Wed, 18 Nov 2015 19:35:35 +1100
Message-ID: <20151118083507.181888695@telegraphics.com.au>
References: <20151118083455.331768508@telegraphics.com.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline; filename=ncr5380-poll_politely2
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@odin.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

SCSI bus protocol sometimes requires monitoring two related conditions
simultaneously. Enhance NCR5380_poll_politely() for this purpose, and
put it to use in the arbitration algorithm. It will also find use in
pseudo DMA.

Signed-off-by: Finn Thain <fthain@telegraphics.com.au>

---
 drivers/scsi/NCR5380.c       |   68 +++++++++++++++++++++++++------------------
 drivers/scsi/atari_NCR5380.c |   64 ++++++++++++++++++++++++----------------
 2 files changed, 79 insertions(+), 53 deletions(-)

Index: linux/drivers/scsi/atari_NCR5380.c
===================================================================
--- linux.orig/drivers/scsi/atari_NCR5380.c	2015-11-18 19:33:53.000000000 +1100
+++ linux/drivers/scsi/atari_NCR5380.c	2015-11-18 19:33:55.000000000 +1100
@@ -457,11 +457,14 @@ static inline void initialize_SCp(struct
 }
 
 /**
- * NCR5380_poll_politely - wait for chip register value
+ * NCR5380_poll_politely2 - wait for two chip register values
  * @instance: controller to poll
- * @reg: 5380 register to poll
- * @bit: Bitmask to check
- * @val: Value required to exit
+ * @reg1: 5380 register to poll
+ * @bit1: Bitmask to check
+ * @val1: Expected value
+ * @reg2: Second 5380 register to poll
+ * @bit2: Second bitmask to check
+ * @val2: Second expected value
  * @wait: Time-out in jiffies
  *
  * Polls the chip in a reasonably efficient manner waiting for an
@@ -469,11 +472,12 @@ static inline void initialize_SCp(struct
  * (if possible). In irq contexts the time-out is arbitrarily limited.
  * Callers may hold locks as long as they are held in irq mode.
  *
- * Returns 0 if event occurred otherwise -ETIMEDOUT.
+ * Returns 0 if either or both event(s) occurred otherwise -ETIMEDOUT.
  */
 
-static int NCR5380_poll_politely(struct Scsi_Host *instance,
-                                 int reg, int bit, int val, int wait)
+static int NCR5380_poll_politely2(struct Scsi_Host *instance,
+                                  int reg1, int bit1, int val1,
+                                  int reg2, int bit2, int val2, int wait)
 {
 	unsigned long start = jiffies;
 	unsigned long n;
@@ -481,7 +485,9 @@ static int NCR5380_poll_politely(struct
 	/* Busy-wait for up to 1 jiffy */
 	n = loops_per_jiffy;
 	do {
-		if ((NCR5380_read(reg) & bit) == val)
+		if ((NCR5380_read(reg1) & bit1) == val1)
+			return 0;
+		if ((NCR5380_read(reg2) & bit2) == val2)
 			return 0;
 		cpu_relax();
 	} while (--n > 0);
@@ -493,7 +499,9 @@ static int NCR5380_poll_politely(struct
 	n = min(20000U, jiffies_to_usecs(wait));
 	do {
 		udelay(1);
-		if ((NCR5380_read(reg) & bit) == val)
+		if ((NCR5380_read(reg1) & bit1) == val1)
+			return 0;
+		if ((NCR5380_read(reg2) & bit2) == val2)
 			return 0;
 		cpu_relax();
 	} while (--n > 0);
@@ -504,13 +512,22 @@ static int NCR5380_poll_politely(struct
 	/* Repeatedly sleep for 1 ms until deadline */
 	while (time_is_after_jiffies(start + wait)) {
 		schedule_timeout_uninterruptible(1);
-		if ((NCR5380_read(reg) & bit) == val)
+		if ((NCR5380_read(reg1) & bit1) == val1)
+			return 0;
+		if ((NCR5380_read(reg2) & bit2) == val2)
 			return 0;
 	}
 
 	return -ETIMEDOUT;
 }
 
+static inline int NCR5380_poll_politely(struct Scsi_Host *instance,
+                                        int reg, int bit, int val, int wait)
+{
+	return NCR5380_poll_politely2(instance, reg, bit, val,
+	                                        reg, bit, val, wait);
+}
+
 #include <linux/delay.h>
 
 #if NDEBUG
@@ -1342,7 +1359,6 @@ static int NCR5380_select(struct Scsi_Ho
 	int len;
 	int err;
 	unsigned long flags;
-	unsigned long timeout;
 
 	NCR5380_dprint(NDEBUG_ARBITRATION, instance);
 	dprintk(NDEBUG_ARBITRATION, "scsi%d: starting arbitration, id = %d\n", HOSTNO,
@@ -1372,20 +1388,18 @@ static int NCR5380_select(struct Scsi_Ho
 	 */
 
 	local_irq_restore(flags);
-	timeout = jiffies + HZ;
-	while (1) {
-		if (time_is_before_jiffies(timeout)) {
-			NCR5380_write(MODE_REG, MR_BASE);
-			shost_printk(KERN_ERR, instance,
-			             "select: arbitration timeout\n");
-			return -1;
-		}
-		if (!(NCR5380_read(MODE_REG) & MR_ARBITRATE)) {
-			/* Reselection interrupt */
-			return -1;
-		}
-		if (NCR5380_read(INITIATOR_COMMAND_REG) & ICR_ARBITRATION_PROGRESS)
-			break;
+	err = NCR5380_poll_politely2(instance, MODE_REG, MR_ARBITRATE, 0,
+	                INITIATOR_COMMAND_REG, ICR_ARBITRATION_PROGRESS,
+	                                       ICR_ARBITRATION_PROGRESS, HZ);
+	if (!(NCR5380_read(MODE_REG) & MR_ARBITRATE)) {
+		/* Reselection interrupt */
+		return -1;
+	}
+	if (err < 0) {
+		NCR5380_write(MODE_REG, MR_BASE);
+		shost_printk(KERN_ERR, instance,
+		             "select: arbitration timeout\n");
+		return -1;
 	}
 
 	/* The SCSI-2 arbitration delay is 2.4 us */
Index: linux/drivers/scsi/NCR5380.c
===================================================================
--- linux.orig/drivers/scsi/NCR5380.c	2015-11-18 19:33:53.000000000 +1100
+++ linux/drivers/scsi/NCR5380.c	2015-11-18 19:33:55.000000000 +1100
@@ -262,11 +262,14 @@ static inline void initialize_SCp(struct
 }
 
 /**
- * NCR5380_poll_politely - wait for chip register value
+ * NCR5380_poll_politely2 - wait for two chip register values
  * @instance: controller to poll
- * @reg: 5380 register to poll
- * @bit: Bitmask to check
- * @val: Value required to exit
+ * @reg1: 5380 register to poll
+ * @bit1: Bitmask to check
+ * @val1: Expected value
+ * @reg2: Second 5380 register to poll
+ * @bit2: Second bitmask to check
+ * @val2: Second expected value
  * @wait: Time-out in jiffies
  *
  * Polls the chip in a reasonably efficient manner waiting for an
@@ -274,11 +277,12 @@ static inline void initialize_SCp(struct
  * (if possible). In irq contexts the time-out is arbitrarily limited.
  * Callers may hold locks as long as they are held in irq mode.
  *
- * Returns 0 if event occurred otherwise -ETIMEDOUT.
+ * Returns 0 if either or both event(s) occurred otherwise -ETIMEDOUT.
  */
 
-static int NCR5380_poll_politely(struct Scsi_Host *instance,
-                                 int reg, int bit, int val, int wait)
+static int NCR5380_poll_politely2(struct Scsi_Host *instance,
+                                  int reg1, int bit1, int val1,
+                                  int reg2, int bit2, int val2, int wait)
 {
 	unsigned long start = jiffies;
 	unsigned long n;
@@ -286,7 +290,9 @@ static int NCR5380_poll_politely(struct
 	/* Busy-wait for up to 1 jiffy */
 	n = loops_per_jiffy;
 	do {
-		if ((NCR5380_read(reg) & bit) == val)
+		if ((NCR5380_read(reg1) & bit1) == val1)
+			return 0;
+		if ((NCR5380_read(reg2) & bit2) == val2)
 			return 0;
 		cpu_relax();
 	} while (--n > 0);
@@ -298,7 +304,9 @@ static int NCR5380_poll_politely(struct
 	n = min(20000U, jiffies_to_usecs(wait));
 	do {
 		udelay(1);
-		if ((NCR5380_read(reg) & bit) == val)
+		if ((NCR5380_read(reg1) & bit1) == val1)
+			return 0;
+		if ((NCR5380_read(reg2) & bit2) == val2)
 			return 0;
 		cpu_relax();
 	} while (--n > 0);
@@ -309,13 +317,22 @@ static int NCR5380_poll_politely(struct
 	/* Repeatedly sleep for 1 ms until deadline */
 	while (time_is_after_jiffies(start + wait)) {
 		schedule_timeout_uninterruptible(1);
-		if ((NCR5380_read(reg) & bit) == val)
+		if ((NCR5380_read(reg1) & bit1) == val1)
+			return 0;
+		if ((NCR5380_read(reg2) & bit2) == val2)
 			return 0;
 	}
 
 	return -ETIMEDOUT;
 }
 
+static inline int NCR5380_poll_politely(struct Scsi_Host *instance,
+                                        int reg, int bit, int val, int wait)
+{
+	return NCR5380_poll_politely2(instance, reg, bit, val,
+	                                        reg, bit, val, wait);
+}
+
 static struct {
 	unsigned char value;
 	const char *name;
@@ -1094,7 +1111,6 @@ static int NCR5380_select(struct Scsi_Ho
 	unsigned char *data;
 	int len;
 	int err;
-	unsigned long timeout;
 
 	NCR5380_dprint(NDEBUG_ARBITRATION, instance);
 	dprintk(NDEBUG_ARBITRATION, "scsi%d : starting arbitration, id = %d\n", instance->host_no, instance->this_id);
@@ -1118,23 +1134,19 @@ static int NCR5380_select(struct Scsi_Ho
 	 */
 
 	spin_unlock_irq(instance->host_lock);
-	timeout = jiffies + HZ;
-	while (1) {
-		if (time_is_before_jiffies(timeout)) {
-			NCR5380_write(MODE_REG, MR_BASE);
-			shost_printk(KERN_ERR, instance,
-			             "select: arbitration timeout\n");
-			spin_lock_irq(instance->host_lock);
-			return -1;
-		}
-		spin_lock_irq(instance->host_lock);
-		if (!(NCR5380_read(MODE_REG) & MR_ARBITRATE)) {
-			/* Reselection interrupt */
-			return -1;
-		}
-		if (NCR5380_read(INITIATOR_COMMAND_REG) & ICR_ARBITRATION_PROGRESS)
-			break;
-		spin_unlock_irq(instance->host_lock);
+	err = NCR5380_poll_politely2(instance, MODE_REG, MR_ARBITRATE, 0,
+	                INITIATOR_COMMAND_REG, ICR_ARBITRATION_PROGRESS,
+	                                       ICR_ARBITRATION_PROGRESS, HZ);
+	spin_lock_irq(instance->host_lock);
+	if (!(NCR5380_read(MODE_REG) & MR_ARBITRATE)) {
+		/* Reselection interrupt */
+		return -1;
+	}
+	if (err < 0) {
+		NCR5380_write(MODE_REG, MR_BASE);
+		shost_printk(KERN_ERR, instance,
+		             "select: arbitration timeout\n");
+		return -1;
 	}
 
 	/* The SCSI-2 arbitration delay is 2.4 us */
