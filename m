From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH 32/71] ncr5380: Fix bus phase in do_abort()
Date: Wed, 18 Nov 2015 19:35:27 +1100
Message-ID: <20151118083504.481704824@telegraphics.com.au>
References: <20151118083455.331768508@telegraphics.com.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline; filename=ncr5380-do_abort-vs-bus-phase
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@odin.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

NCR5380_poll_politely() returns either 0 (success) or -ETIMEDOUT. However,
in do_abort(), the return value is incorrectly taken to be the status
register value. This means that the bus is put into DATA OUT phase instead
of MESSAGE OUT. Fix this.

Signed-off-by: Finn Thain <fthain@telegraphics.com.au>

---
 drivers/scsi/NCR5380.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux/drivers/scsi/NCR5380.c
===================================================================
--- linux.orig/drivers/scsi/NCR5380.c	2015-11-18 19:33:44.000000000 +1100
+++ linux/drivers/scsi/NCR5380.c	2015-11-18 19:33:45.000000000 +1100
@@ -1486,11 +1486,11 @@ static int do_abort(struct Scsi_Host *in
 	if (rc < 0)
 		return -1;
 
-	tmp = (unsigned char)rc;
+	tmp = NCR5380_read(STATUS_REG) & PHASE_MASK;
 	
 	NCR5380_write(TARGET_COMMAND_REG, PHASE_SR_TO_TCR(tmp));
 
-	if ((tmp & PHASE_MASK) != PHASE_MSGOUT) {
+	if (tmp != PHASE_MSGOUT) {
 		NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE | ICR_ASSERT_ATN | ICR_ASSERT_ACK);
 		rc = NCR5380_poll_politely(instance, STATUS_REG, SR_REQ, 0, 3 * HZ);
 		NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE | ICR_ASSERT_ATN);
