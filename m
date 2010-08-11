From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] sym53c8xx_2: Set DID_REQUEUE return code when aborting squeue
 (fwd)
Date: Tue, 10 Aug 2010 22:19:35 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.1008102217170.5805@hs20-bc2-1.build.redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:32912 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758146Ab0HKCTo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 10 Aug 2010 22:19:44 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: matthew@wil.cx
Cc: James.Bottomley@suse.de, linux-scsi@vger.kernel.org

Hi

Some times ago I send this patch, but got no response.

This bug is quite serious, writes are randomly failing with sym53c8xx_2. 
Would you consider this patch for this release cycle?

Mikulas

---------- Forwarded message ----------
Date: Tue, 20 Apr 2010 20:57:06 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
To: matthew@wil.cx
Cc: linux-scsi@vger.kernel.org
Subject: [PATCH] sym53c8xx_2: Set DID_REQUEUE return code when aborting squeue

Hi

This fixes failures with sym53c8xx_2 when the disk returns QUEUE FULL 
status:
sd 0:0:0:0: [sda] Unhandled error code
sd 0:0:0:0: [sda] Result: hostbyte=DID_SOFT_ERROR driverbyte=DRIVER_OK
sd 0:0:0:0: [sda] CDB: Write(10): 2a 00 00 01 37 9a 00 00 02 00
lost page write due to I/O error on sda1
sd 0:0:0:0: [sda] Unhandled error code
sd 0:0:0:0: [sda] Result: hostbyte=DID_SOFT_ERROR driverbyte=DRIVER_OK
sd 0:0:0:0: [sda] CDB: Write(10): 2a 00 00 01 38 10 00 00 10 00
lost page write due to I/O error on sda1
...

BTW. FreeBSD has also REQUEUE in this function, not error.

Mikulas

---

sym53c8xx_2: Set DID_REQUEUE return code when aborting squeue

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

Index: linux-2.6.34-rc4-fast-newboot/drivers/scsi/sym53c8xx_2/sym_hipd.c
===================================================================
--- linux-2.6.34-rc4-fast-newboot.orig/drivers/scsi/sym53c8xx_2/sym_hipd.c	2010-04-20 17:45:47.000000000 +0200
+++ linux-2.6.34-rc4-fast-newboot/drivers/scsi/sym53c8xx_2/sym_hipd.c	2010-04-18 22:10:25.000000000 +0200
@@ -3003,7 +3003,11 @@ sym_dequeue_from_squeue(struct sym_hcb *
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
