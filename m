From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH v3 26/77] ncr5380: Fix NCR5380_transfer_pio() result
Date: Tue, 22 Dec 2015 12:18:04 +1100
Message-ID: <20151222011745.091589071@telegraphics.com.au>
References: <20151222011737.980475848@telegraphics.com.au>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:40446 "EHLO
	kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752738AbbLVCbN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Dec 2015 21:31:13 -0500
Content-Disposition: inline; filename=ncr5380-fix-transfer_pio
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@odin.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>

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
--- linux.orig/drivers/scsi/NCR5380.c	2015-12-22 12:16:10.000000000 +1100
+++ linux/drivers/scsi/NCR5380.c	2015-12-22 12:16:12.000000000 +1100
@@ -1393,8 +1393,10 @@ static int NCR5380_transfer_pio(struct S
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
@@ -1421,7 +1423,11 @@ static int NCR5380_transfer_pio(struct S
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
--- linux.orig/drivers/scsi/atari_NCR5380.c	2015-12-22 12:16:10.000000000 +1100
+++ linux/drivers/scsi/atari_NCR5380.c	2015-12-22 12:16:12.000000000 +1100
@@ -1776,8 +1776,9 @@ static int NCR5380_transfer_pio(struct S
 			NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE | ICR_ASSERT_ACK);
 		}
 
-		while (NCR5380_read(STATUS_REG) & SR_REQ)
-			;
+		if (NCR5380_poll_politely(instance,
+		                          STATUS_REG, SR_REQ, 0, 5 * HZ) < 0)
+			break;
 
 		dprintk(NDEBUG_HANDSHAKE, "scsi%d: req false, handshake complete\n", HOSTNO);
 
@@ -1806,10 +1807,10 @@ static int NCR5380_transfer_pio(struct S
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


