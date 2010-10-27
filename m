From: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>
Subject: sym53c8xx_2 data corruption
Date: Wed, 27 Oct 2010 11:04:40 +0200 (CEST)
Message-ID: <alpine.DEB.1.10.1010271059230.31946@artax.karlin.mff.cuni.cz>
References: <20101027012932.3CB6E4FB4@hiauly1.hia.nrc.ca> <1288155041.19649.354.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-parisc-owner@vger.kernel.org>
In-Reply-To: <1288155041.19649.354.camel@mulgrave.site>
Sender: linux-parisc-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-parisc@vger.kernel.org, linux-scsi@vger.kernel.org, matthew@wil.cx
List-Id: linux-scsi@vger.kernel.org

Hi

I sent this about twice to linux-scsi and got no reseponse, neither from 
conference nor from Matthew. So I'm sending it here, James, you are the 
maintainer of SCSI, could you please look at the patch and incorporate it 
to the kernel in this cycle?

The problem is that if the disk returns QUEUE FULL, the requests are 
aborted with DID_SOFT_ERROR (rather than DID_REQUEUE), which results in 
too few retries and premature errors. The errors happen mostly on writes, 
resulting in data corruption.

Mikulas

---

sym53c8xx_2: Set DID_REQUEUE return code when aborting squeue.

When the controller encounters an error (including QUEUE FULL or BUSY status),
it aborts all not yet submitted requests in the function
sym_dequeue_from_squeue.

This function aborts them with DID_SOFT_ERROR.

If the disk has a full tag queue, the request that caused the overflow is
aborted with QUEUE FULL status (and the scsi midlayer properly retries it
until it is accepted by the disk), but other requests are aborted with
DID_SOFT_ERROR --- for them, the midlayer does just a few retries and then
signals the error up to sd.

The result is that disk returning QUEUE FULL causes request failures.

The error was reproduced on 53c895 with COMPAQ BD03685A24 disk (rebranded
ST336607LC) with command queue 48 or 64 tags. The disk has 64 tags, but
under some access patterns it return QUEUE FULL when there are less than
64 pending tags. The SCSI specification allows returning QUEUE FULL
anytime and it is up to the host to retry.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/scsi/sym53c8xx_2/sym_hipd.c |    4 ++++
 1 file changed, 4 insertions(+)

Index: linux-2.6.36-rc5-fast/drivers/scsi/sym53c8xx_2/sym_hipd.c
===================================================================
--- linux-2.6.36-rc5-fast.orig/drivers/scsi/sym53c8xx_2/sym_hipd.c	2010-09-27 10:25:59.000000000 +0200
+++ linux-2.6.36-rc5-fast/drivers/scsi/sym53c8xx_2/sym_hipd.c	2010-09-27 10:26:27.000000000 +0200
@@ -3000,7 +3000,11 @@ sym_dequeue_from_squeue(struct sym_hcb *
 		if ((target == -1 || cp->target == target) &&
 		    (lun    == -1 || cp->lun    == lun)    &&
 		    (task   == -1 || cp->tag    == task)) {
+#ifdef SYM_OPT_HANDLE_DEVICE_QUEUEING
 			sym_set_cam_status(cp->cmd, DID_SOFT_ERROR);
+#else
+			sym_set_cam_status(cp->cmd, DID_REQUEUE);
+#endif
 			sym_remque(&cp->link_ccbq);
 			sym_insque_tail(&cp->link_ccbq, &np->comp_ccbq);
 		}

