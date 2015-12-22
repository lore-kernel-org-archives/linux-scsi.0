From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH v3 31/77] ncr5380: Fix !REQ timeout in do_abort()
Date: Tue, 22 Dec 2015 12:18:09 +1100
Message-ID: <20151222011746.445511731@telegraphics.com.au>
References: <20151222011737.980475848@telegraphics.com.au>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:40514 "EHLO
	kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752789AbbLVCbP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Dec 2015 21:31:15 -0500
Content-Disposition: inline; filename=ncr5380-do_abort-vs-poll_politely
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@odin.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>

NCR5380_poll_politely() never returns -1. That means do_abort() can fail
to handle a timeout after waiting for the target to negate REQ. Fix this
and cleanup other NCR5380_poll_politely() call sites.

Signed-off-by: Finn Thain <fthain@telegraphics.com.au>

---
 drivers/scsi/NCR5380.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

Index: linux/drivers/scsi/NCR5380.c
===================================================================
--- linux.orig/drivers/scsi/NCR5380.c	2015-12-22 12:16:17.000000000 +1100
+++ linux/drivers/scsi/NCR5380.c	2015-12-22 12:16:18.000000000 +1100
@@ -1271,7 +1271,7 @@ static int NCR5380_select(struct Scsi_Ho
 	err = NCR5380_poll_politely(instance, STATUS_REG, SR_REQ, SR_REQ, HZ);
 	spin_lock_irq(instance->host_lock);
 	
-	if(err) {
+	if (err < 0) {
 		printk(KERN_ERR "scsi%d: timeout at NCR5380.c:%d\n", instance->host_no, __LINE__);
 		NCR5380_write(SELECT_ENABLE_REG, hostdata->id_mask);
 		return -1;
@@ -1490,8 +1490,7 @@ static int do_abort(struct Scsi_Host *in
 	 */
 
 	rc = NCR5380_poll_politely(instance, STATUS_REG, SR_REQ, SR_REQ, 60 * HZ);
-	
-	if(rc < 0)
+	if (rc < 0)
 		return -1;
 
 	tmp = (unsigned char)rc;
@@ -1502,7 +1501,7 @@ static int do_abort(struct Scsi_Host *in
 		NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE | ICR_ASSERT_ATN | ICR_ASSERT_ACK);
 		rc = NCR5380_poll_politely(instance, STATUS_REG, SR_REQ, 0, 3 * HZ);
 		NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE | ICR_ASSERT_ATN);
-		if(rc == -1)
+		if (rc < 0)
 			return -1;
 	}
 	tmp = ABORT;
@@ -2199,7 +2198,8 @@ static void NCR5380_reselect(struct Scsi
 	 * FIXME: timeout needed and fail to work queeu
 	 */
 
-	if(NCR5380_poll_politely(instance, STATUS_REG, SR_REQ, SR_REQ, 2*HZ))
+	if (NCR5380_poll_politely(instance,
+	                          STATUS_REG, SR_REQ, SR_REQ, 2 * HZ) < 0)
 		abort = 1;
 
 	len = 1;


