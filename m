From: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>
Subject: [PATCH] sym53c8xx_2: avoid data corruption when disk rejects commands
 with QUEUE FULL
Date: Sun, 8 May 2011 21:00:26 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.1105082057460.15552@artax.karlin.mff.cuni.cz>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>, "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

[ the maintainer is not responding, so I'm sending this to other people ]

sym53c8xx_2: avoid data corruption when disk rejects commands with QUEUE 
FULL

When the controller encounters an error (including QUEUE FULL or BUSY 
status), it aborts all not yet submitted requests in the function 
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
