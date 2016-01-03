From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH v4 31/78] ncr5380: Fix !REQ timeout in do_abort()
Date: Sun, 03 Jan 2016 16:05:32 +1100
Message-ID: <20160103050509.242739149@telegraphics.com.au>
References: <20160103050501.042035135@telegraphics.com.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline; filename=ncr5380-do_abort-vs-poll_politely
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@odin.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

NCR5380_poll_politely() never returns -1. That means do_abort() can fail
to handle a timeout after waiting for the target to negate REQ. Fix this
and cleanup other NCR5380_poll_politely() call sites.

Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
Reviewed-by: Hannes Reinecke <hare@suse.com>
Tested-by: Ondrej Zary <linux@rainbow-software.org>

---
 drivers/scsi/NCR5380.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

Index: linux/drivers/scsi/NCR5380.c
===================================================================
--- linux.orig/drivers/scsi/NCR5380.c	2016-01-03 16:03:40.000000000 +1100
+++ linux/drivers/scsi/NCR5380.c	2016-01-03 16:03:41.000000000 +1100
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
