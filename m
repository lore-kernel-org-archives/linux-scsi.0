From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH v4 33/78] atari_NCR5380: Set do_abort() timeouts
Date: Sun, 03 Jan 2016 16:05:34 +1100
Message-ID: <20160103050509.771815158@telegraphics.com.au>
References: <20160103050501.042035135@telegraphics.com.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline; filename=atari_NCR5380-do_abort-timeouts
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@odin.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Use timeouts in do_abort() in atari_NCR5380.c instead of infinite loops.
Also fix the kernel-doc comment. Keep the two core driver forks in sync.

Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
Reviewed-by: Hannes Reinecke <hare@suse.com>
Tested-by: Ondrej Zary <linux@rainbow-software.org>
Tested-by: Michael Schmitz <schmitzmic@gmail.com>

---
 drivers/scsi/NCR5380.c       |   26 +++++++++++++-------------
 drivers/scsi/atari_NCR5380.c |   34 +++++++++++++++++++++-------------
 2 files changed, 34 insertions(+), 26 deletions(-)

Index: linux/drivers/scsi/atari_NCR5380.c
===================================================================
--- linux.orig/drivers/scsi/atari_NCR5380.c	2016-01-03 16:03:39.000000000 +1100
+++ linux/drivers/scsi/atari_NCR5380.c	2016-01-03 16:03:43.000000000 +1100
@@ -1835,19 +1835,19 @@ static void do_reset(struct Scsi_Host *i
 	local_irq_restore(flags);
 }
 
-/*
- * Function : do_abort (Scsi_Host *host)
+/**
+ * do_abort - abort the currently established nexus by going to
+ * MESSAGE OUT phase and sending an ABORT message.
+ * @instance: relevant scsi host instance
  *
- * Purpose : abort the currently established nexus.  Should only be
- *	called from a routine which can drop into a
- *
- * Returns : 0 on success, -1 on failure.
+ * Returns 0 on success, -1 on failure.
  */
 
 static int do_abort(struct Scsi_Host *instance)
 {
 	unsigned char tmp, *msgptr, phase;
 	int len;
+	int rc;
 
 	/* Request message out phase */
 	NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE | ICR_ASSERT_ATN);
@@ -1862,16 +1862,20 @@ static int do_abort(struct Scsi_Host *in
 	 * the target sees, so we just handshake.
 	 */
 
-	while (!((tmp = NCR5380_read(STATUS_REG)) & SR_REQ))
-		;
+	rc = NCR5380_poll_politely(instance, STATUS_REG, SR_REQ, SR_REQ, 10 * HZ);
+	if (rc < 0)
+		goto timeout;
+
+	tmp = NCR5380_read(STATUS_REG) & PHASE_MASK;
 
 	NCR5380_write(TARGET_COMMAND_REG, PHASE_SR_TO_TCR(tmp));
 
-	if ((tmp & PHASE_MASK) != PHASE_MSGOUT) {
-		NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE | ICR_ASSERT_ATN |
-			      ICR_ASSERT_ACK);
-		while (NCR5380_read(STATUS_REG) & SR_REQ)
-			;
+	if (tmp != PHASE_MSGOUT) {
+		NCR5380_write(INITIATOR_COMMAND_REG,
+		              ICR_BASE | ICR_ASSERT_ATN | ICR_ASSERT_ACK);
+		rc = NCR5380_poll_politely(instance, STATUS_REG, SR_REQ, 0, 3 * HZ);
+		if (rc < 0)
+			goto timeout;
 		NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE | ICR_ASSERT_ATN);
 	}
 
@@ -1887,6 +1891,10 @@ static int do_abort(struct Scsi_Host *in
 	 */
 
 	return len ? -1 : 0;
+
+timeout:
+	NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
+	return -1;
 }
 
 #if defined(REAL_DMA)
Index: linux/drivers/scsi/NCR5380.c
===================================================================
--- linux.orig/drivers/scsi/NCR5380.c	2016-01-03 16:03:42.000000000 +1100
+++ linux/drivers/scsi/NCR5380.c	2016-01-03 16:03:43.000000000 +1100
@@ -1458,16 +1458,12 @@ static void do_reset(struct Scsi_Host *i
 	local_irq_restore(flags);
 }
 
-/*
- * Function : do_abort (Scsi_Host *host)
- * 
- * Purpose : abort the currently established nexus.  Should only be 
- *      called from a routine which can drop into a 
- * 
- * Returns : 0 on success, -1 on failure.
+/**
+ * do_abort - abort the currently established nexus by going to
+ * MESSAGE OUT phase and sending an ABORT message.
+ * @instance: relevant scsi host instance
  *
- * Locks: queue lock held by caller
- *	FIXME: sort this out and get new_eh running
+ * Returns 0 on success, -1 on failure.
  */
 
 static int do_abort(struct Scsi_Host *instance)
@@ -1489,9 +1485,9 @@ static int do_abort(struct Scsi_Host *in
 	 * the target sees, so we just handshake.
 	 */
 
-	rc = NCR5380_poll_politely(instance, STATUS_REG, SR_REQ, SR_REQ, 60 * HZ);
+	rc = NCR5380_poll_politely(instance, STATUS_REG, SR_REQ, SR_REQ, 10 * HZ);
 	if (rc < 0)
-		return -1;
+		goto timeout;
 
 	tmp = NCR5380_read(STATUS_REG) & PHASE_MASK;
 	
@@ -1500,9 +1496,9 @@ static int do_abort(struct Scsi_Host *in
 	if (tmp != PHASE_MSGOUT) {
 		NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE | ICR_ASSERT_ATN | ICR_ASSERT_ACK);
 		rc = NCR5380_poll_politely(instance, STATUS_REG, SR_REQ, 0, 3 * HZ);
-		NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE | ICR_ASSERT_ATN);
 		if (rc < 0)
-			return -1;
+			goto timeout;
+		NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE | ICR_ASSERT_ATN);
 	}
 	tmp = ABORT;
 	msgptr = &tmp;
@@ -1516,6 +1512,10 @@ static int do_abort(struct Scsi_Host *in
 	 */
 
 	return len ? -1 : 0;
+
+timeout:
+	NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
+	return -1;
 }
 
 #if defined(REAL_DMA) || defined(PSEUDO_DMA) || defined (REAL_DMA_POLL)
