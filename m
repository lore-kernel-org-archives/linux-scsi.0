From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH 34/71] atari_NCR5380: Use arbitration timeout
Date: Wed, 18 Nov 2015 19:35:29 +1100
Message-ID: <20151118083505.011676128@telegraphics.com.au>
References: <20151118083455.331768508@telegraphics.com.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline; filename=atari_NCR5380-use-arbitration-timeout
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@odin.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Allow target selection to fail with a timeout instead of waiting in
infinite loops. This gets rid of the unused NCR_TIMEOUT macro, it is more
defensive and has proved helpful in debugging.

Signed-off-by: Finn Thain <fthain@telegraphics.com.au>

---
 drivers/scsi/NCR5380.c       |   44 ++++++++++++++++++---------------
 drivers/scsi/atari_NCR5380.c |   57 ++++++++++++++++++-------------------------
 2 files changed, 49 insertions(+), 52 deletions(-)

Index: linux/drivers/scsi/atari_NCR5380.c
===================================================================
--- linux.orig/drivers/scsi/atari_NCR5380.c	2015-11-18 19:33:46.000000000 +1100
+++ linux/drivers/scsi/atari_NCR5380.c	2015-11-18 19:33:47.000000000 +1100
@@ -1406,6 +1406,7 @@ static int NCR5380_select(struct Scsi_Ho
 	int len;
 	int err;
 	unsigned long flags;
+	unsigned long timeout;
 
 	NCR5380_dprint(NDEBUG_ARBITRATION, instance);
 	dprintk(NDEBUG_ARBITRATION, "scsi%d: starting arbitration, id = %d\n", HOSTNO,
@@ -1430,42 +1431,28 @@ static int NCR5380_select(struct Scsi_Ho
 	NCR5380_write(OUTPUT_DATA_REG, hostdata->id_mask);
 	NCR5380_write(MODE_REG, MR_ARBITRATE);
 
-	local_irq_restore(flags);
+	/* The chip now waits for BUS FREE phase. Then after the 800 ns
+	 * Bus Free Delay, arbitration will begin.
+	 */
 
-	/* Wait for arbitration logic to complete */
-#if defined(NCR_TIMEOUT)
-	{
-		unsigned long timeout = jiffies + 2*NCR_TIMEOUT;
-
-		while (!(NCR5380_read(INITIATOR_COMMAND_REG) & ICR_ARBITRATION_PROGRESS) &&
-		       time_before(jiffies, timeout) && !hostdata->connected)
-			;
-		if (time_after_eq(jiffies, timeout)) {
-			printk("scsi : arbitration timeout at %d\n", __LINE__);
+	local_irq_restore(flags);
+	timeout = jiffies + HZ;
+	while (1) {
+		if (time_is_before_jiffies(timeout)) {
 			NCR5380_write(MODE_REG, MR_BASE);
-			NCR5380_write(SELECT_ENABLE_REG, hostdata->id_mask);
+			shost_printk(KERN_ERR, instance,
+			             "select: arbitration timeout\n");
 			return -1;
 		}
+		if (!(NCR5380_read(MODE_REG) & MR_ARBITRATE)) {
+			/* Reselection interrupt */
+			return -1;
+		}
+		if (NCR5380_read(INITIATOR_COMMAND_REG) & ICR_ARBITRATION_PROGRESS)
+			break;
 	}
-#else /* NCR_TIMEOUT */
-	while (!(NCR5380_read(INITIATOR_COMMAND_REG) & ICR_ARBITRATION_PROGRESS) &&
-	       !hostdata->connected)
-		;
-#endif
-
-	dprintk(NDEBUG_ARBITRATION, "scsi%d: arbitration complete\n", HOSTNO);
-
-	if (hostdata->connected) {
-		NCR5380_write(MODE_REG, MR_BASE);
-		return -1;
-	}
-	/*
-	 * The arbitration delay is 2.2us, but this is a minimum and there is
-	 * no maximum so we can safely sleep for ceil(2.2) usecs to accommodate
-	 * the integral nature of udelay().
-	 *
-	 */
 
+	/* The SCSI-2 arbitration delay is 2.4 us */
 	udelay(3);
 
 	/* Check for lost arbitration */
@@ -1628,8 +1615,14 @@ static int NCR5380_select(struct Scsi_Ho
 	 */
 
 	/* Wait for start of REQ/ACK handshake */
-	while (!(NCR5380_read(STATUS_REG) & SR_REQ))
-		;
+
+	err = NCR5380_poll_politely(instance, STATUS_REG, SR_REQ, SR_REQ, HZ);
+	if (err < 0) {
+		shost_printk(KERN_ERR, instance, "select: REQ timeout\n");
+		NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
+		NCR5380_write(SELECT_ENABLE_REG, hostdata->id_mask);
+		return -1;
+	}
 
 	dprintk(NDEBUG_SELECTION, "scsi%d: target %d selected, going into MESSAGE OUT phase.\n",
 		   HOSTNO, cmd->device->id);
Index: linux/drivers/scsi/NCR5380.c
===================================================================
--- linux.orig/drivers/scsi/NCR5380.c	2015-11-18 19:33:46.000000000 +1100
+++ linux/drivers/scsi/NCR5380.c	2015-11-18 19:33:47.000000000 +1100
@@ -1076,6 +1076,7 @@ static int NCR5380_select(struct Scsi_Ho
 	unsigned char *data;
 	int len;
 	int err;
+	unsigned long timeout;
 
 	NCR5380_dprint(NDEBUG_ARBITRATION, instance);
 	dprintk(NDEBUG_ARBITRATION, "scsi%d : starting arbitration, id = %d\n", instance->host_no, instance->this_id);
@@ -1094,28 +1095,31 @@ static int NCR5380_select(struct Scsi_Ho
 	NCR5380_write(OUTPUT_DATA_REG, hostdata->id_mask);
 	NCR5380_write(MODE_REG, MR_ARBITRATE);
 
+	/* The chip now waits for BUS FREE phase. Then after the 800 ns
+	 * Bus Free Delay, arbitration will begin.
+	 */
 
-	/* We can be relaxed here, interrupts are on, we are
-	   in workqueue context, the birds are singing in the trees */
 	spin_unlock_irq(instance->host_lock);
-	err = NCR5380_poll_politely(instance, INITIATOR_COMMAND_REG, ICR_ARBITRATION_PROGRESS, ICR_ARBITRATION_PROGRESS, 5*HZ);
-	spin_lock_irq(instance->host_lock);
-	if (err < 0) {
-		printk(KERN_DEBUG "scsi: arbitration timeout at %d\n", __LINE__);
-		NCR5380_write(MODE_REG, MR_BASE);
-		NCR5380_write(SELECT_ENABLE_REG, hostdata->id_mask);
-		return -1;
+	timeout = jiffies + HZ;
+	while (1) {
+		if (time_is_before_jiffies(timeout)) {
+			NCR5380_write(MODE_REG, MR_BASE);
+			shost_printk(KERN_ERR, instance,
+			             "select: arbitration timeout\n");
+			spin_lock_irq(instance->host_lock);
+			return -1;
+		}
+		spin_lock_irq(instance->host_lock);
+		if (!(NCR5380_read(MODE_REG) & MR_ARBITRATE)) {
+			/* Reselection interrupt */
+			return -1;
+		}
+		if (NCR5380_read(INITIATOR_COMMAND_REG) & ICR_ARBITRATION_PROGRESS)
+			break;
+		spin_unlock_irq(instance->host_lock);
 	}
 
-	dprintk(NDEBUG_ARBITRATION, "scsi%d : arbitration complete\n", instance->host_no);
-
-	/* 
-	 * The arbitration delay is 2.2us, but this is a minimum and there is 
-	 * no maximum so we can safely sleep for ceil(2.2) usecs to accommodate
-	 * the integral nature of udelay().
-	 *
-	 */
-
+	/* The SCSI-2 arbitration delay is 2.4 us */
 	udelay(3);
 
 	/* Check for lost arbitration */
@@ -1263,9 +1267,9 @@ static int NCR5380_select(struct Scsi_Ho
 	spin_unlock_irq(instance->host_lock);
 	err = NCR5380_poll_politely(instance, STATUS_REG, SR_REQ, SR_REQ, HZ);
 	spin_lock_irq(instance->host_lock);
-	
 	if (err < 0) {
-		printk(KERN_ERR "scsi%d: timeout at NCR5380.c:%d\n", instance->host_no, __LINE__);
+		shost_printk(KERN_ERR, instance, "select: REQ timeout\n");
+		NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
 		NCR5380_write(SELECT_ENABLE_REG, hostdata->id_mask);
 		return -1;
 	}
