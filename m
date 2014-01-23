From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] sym53c8xx_2: Set DID_REQUEUE return code when aborting
 squeue.
Date: Thu, 23 Jan 2014 13:23:28 -0500 (EST)
Message-ID: <alpine.LRH.2.02.1401231321580.2946@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:26023 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932156AbaAWSXa (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 23 Jan 2014 13:23:30 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-scsi@vger.kernel.org

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
Cc: stable@vger.kernel.org

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
