From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH v4 32/78] ncr5380: Fix bus phase in do_abort()
Date: Sun, 03 Jan 2016 16:05:33 +1100
Message-ID: <20160103050509.501820978@telegraphics.com.au>
References: <20160103050501.042035135@telegraphics.com.au>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:49460 "EHLO
	kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751662AbcACFSR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 3 Jan 2016 00:18:17 -0500
Content-Disposition: inline; filename=ncr5380-do_abort-vs-bus-phase
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@odin.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

NCR5380_poll_politely() returns either 0 (success) or -ETIMEDOUT. However,
in do_abort(), the return value is incorrectly taken to be the status
register value. This means that the bus is put into DATA OUT phase instead
of MESSAGE OUT. Fix this.

Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
Reviewed-by: Hannes Reinecke <hare@suse.com>
Tested-by: Ondrej Zary <linux@rainbow-software.org>

---
 drivers/scsi/NCR5380.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux/drivers/scsi/NCR5380.c
===================================================================
--- linux.orig/drivers/scsi/NCR5380.c	2016-01-03 16:03:41.000000000 +1100
+++ linux/drivers/scsi/NCR5380.c	2016-01-03 16:03:42.000000000 +1100
@@ -1493,11 +1493,11 @@ static int do_abort(struct Scsi_Host *in
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


