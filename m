From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH 26/71] ncr5380: Fix NCR5380_transfer_pio() result
Date: Wed, 18 Nov 2015 19:35:21 +1100
Message-ID: <20151118083502.752595277@telegraphics.com.au>
References: <20151118083455.331768508@telegraphics.com.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline; filename=ncr5380-fix-transfer_pio
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@odin.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

According to the SCSI-2 draft revision 10L, atari_NCR5380.c is correct
when it says that the phase lines are valid up until ACK is negated
following the transmission of the last byte in MESSAGE IN phase. This is
true for all information transfer phases, from target to initiator.

Sample the phase bits in STATUS_REG so that NCR5380_transfer_pio() can
return the correct result. The return value is presently unused (perhaps
because of bugs like this) but this change at least fixes the caller's
phase variable, which is passed by reference.

Signed-off-by: Finn Thain <fthain@telegraphics.com.au>

---
 drivers/scsi/NCR5380.c       |   12 +++++++++---
 drivers/scsi/atari_NCR5380.c |   11 ++++++-----
 2 files changed, 15 insertions(+), 8 deletions(-)

Index: linux/drivers/scsi/NCR5380.c
===================================================================
--- linux.orig/drivers/scsi/NCR5380.c	2015-11-18 19:33:38.000000000 +1100
+++ linux/drivers/scsi/NCR5380.c	2015-11-18 19:33:39.000000000 +1100
@@ -1386,8 +1386,10 @@ static int NCR5380_transfer_pio(struct S
 			NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE | ICR_ASSERT_ACK);
 		}
 
-		/* FIXME - if this fails bus reset ?? */
-		NCR5380_poll_politely(instance, STATUS_REG, SR_REQ, 0, 5*HZ);
+		if (NCR5380_poll_politely(instance,
+		                          STATUS_REG, SR_REQ, 0, 5 * HZ) < 0)
+			break;
+
 		dprintk(NDEBUG_HANDSHAKE, "scsi%d : req false, handshake complete\n", instance->host_no);
 
 /*
@@ -1414,7 +1416,11 @@ static int NCR5380_transfer_pio(struct S
 	*count = c;
 	*data = d;
 	tmp = NCR5380_read(STATUS_REG);
-	if (tmp & SR_REQ)
+	/* The phase read from the bus is valid if either REQ is (already)
+	 * asserted or if ACK hasn't been released yet. The latter applies if
+	 * we're in MSG IN, DATA IN or STATUS and all bytes have been received.
+	 */
+	if ((tmp & SR_REQ) || ((tmp & SR_IO) && c == 0))
 		*phase = tmp & PHASE_MASK;
 	else
 		*phase = PHASE_UNKNOWN;
Index: linux/drivers/scsi/atari_NCR5380.c
===================================================================
--- linux.orig/drivers/scsi/atari_NCR5380.c	2015-11-18 19:33:38.000000000 +1100
+++ linux/drivers/scsi/atari_NCR5380.c	2015-11-18 19:33:39.000000000 +1100
@@ -1770,8 +1770,9 @@ static int NCR5380_transfer_pio(struct S
 			NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE | ICR_ASSERT_ACK);
 		}
 
-		while (NCR5380_read(STATUS_REG) & SR_REQ)
-			;
+		if (NCR5380_poll_politely(instance,
+		                          STATUS_REG, SR_REQ, 0, 5 * HZ) < 0)
+			break;
 
 		dprintk(NDEBUG_HANDSHAKE, "scsi%d: req false, handshake complete\n", HOSTNO);
 
@@ -1800,10 +1801,10 @@ static int NCR5380_transfer_pio(struct S
 	*data = d;
 	tmp = NCR5380_read(STATUS_REG);
 	/* The phase read from the bus is valid if either REQ is (already)
-	 * asserted or if ACK hasn't been released yet. The latter is the case if
-	 * we're in MSGIN and all wanted bytes have been received.
+	 * asserted or if ACK hasn't been released yet. The latter applies if
+	 * we're in MSG IN, DATA IN or STATUS and all bytes have been received.
 	 */
-	if ((tmp & SR_REQ) || (p == PHASE_MSGIN && c == 0))
+	if ((tmp & SR_REQ) || ((tmp & SR_IO) && c == 0))
 		*phase = tmp & PHASE_MASK;
 	else
 		*phase = PHASE_UNKNOWN;
