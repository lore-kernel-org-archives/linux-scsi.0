From: Martin Peschke3 <MPESCHKE@de.ibm.com>
Subject: [PATCH] 2.4.25-pre8: loss of SCSI I/O initiative
Date: Mon, 2 Feb 2004 18:42:07 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <OFA5E0980A.777ADFCB-ONC1256E2C.00131EB3-C1256E2E.0061B28C@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate5.de.ibm.com ([195.212.29.154]:48335 "EHLO
	mtagate5.de.ibm.com") by vger.kernel.org with ESMTP id S265734AbUBBRmX
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 2 Feb 2004 12:42:23 -0500
List-Id: linux-scsi@vger.kernel.org
To: marcelo.tosatti@cyclades.com, dledford@redhat.com
Cc: linux-scsi@vger.kernel.org, andmike@us.ibm.com, axboe@suse.de, garloff@suse.de





Marcelo, Doug,

here is another patch, which corrects some 'loss of initiative' problems.
We hit the problems using the zfcp driver in SUSE first, but they
also prevail in the vanilla 2.4 kernel.
While the SCSI mid layer is iterating through a SCSI host's
device list in an attempt to keep I/O running by kicking the
respective queues, it untimely quits the loop if it comes
across an indisposed SCSI device. Hence, it fails to kick the
queues of the remaining SCSI devices on the same host.
Jens Axboe, Mike Anderson, Kurt Garloff and I have agreed that
the right fix comprises the removal of those checks which lead
to the faulty 'break', as scsi_request_fn() takes care of the
respective conditions.

Please apply.

Cheers,
Martin

IBM Deutschland Entwicklung GmbH
Linux for eServer Development


--- linux-2.4.25-pre8/drivers/scsi/scsi_error.c 2003-04-22 08:25:35.000000000 -0700
+++ linux-2.4.25-pre8-patched/drivers/scsi/scsi_error.c     2004-01-28 16:31:34.000000000 -0800
@@ -1257,14 +1257,7 @@
       */
      spin_lock_irqsave(&io_request_lock, flags);
      for (SDpnt = host->host_queue; SDpnt; SDpnt = SDpnt->next) {
-           request_queue_t *q;
-           if ((host->can_queue > 0 && (host->host_busy >= host->can_queue))
-               || (host->host_blocked)
-               || (host->host_self_blocked)
-               || (SDpnt->device_blocked)) {
-                 break;
-           }
-           q = &SDpnt->request_queue;
+           request_queue_t *q = &SDpnt->request_queue;
            q->request_fn(q);
      }
      spin_unlock_irqrestore(&io_request_lock, flags);
--- linux-2.4.25-pre8/drivers/scsi/scsi_lib.c   2003-06-12 11:15:16.000000000 -0700
+++ linux-2.4.25-pre8-patched/drivers/scsi/scsi_lib.c 2004-01-28 16:31:34.000000000 -0800
@@ -245,7 +245,6 @@
  */
 void scsi_queue_next_request(request_queue_t * q, Scsi_Cmnd * SCpnt)
 {
-     int all_clear;
      unsigned long flags;
      Scsi_Device *SDpnt;
      struct Scsi_Host *SHpnt;
@@ -283,19 +282,10 @@
      if (SDpnt->single_lun
          && list_empty(&q->queue_head)
          && SDpnt->device_busy == 0) {
-           request_queue_t *q;
-
            for (SDpnt = SHpnt->host_queue;
                 SDpnt;
                 SDpnt = SDpnt->next) {
-                 if (((SHpnt->can_queue > 0)
-                      && (SHpnt->host_busy >= SHpnt->can_queue))
-                     || (SHpnt->host_blocked)
-                     || (SHpnt->host_self_blocked)
-                     || (SDpnt->device_blocked)) {
-                       break;
-                 }
-                 q = &SDpnt->request_queue;
+                 request_queue_t *q = &SDpnt->request_queue;
                  q->request_fn(q);
            }
      }
@@ -308,24 +298,14 @@
       * flag as the queue function releases the lock and thus some
       * other device might have become starved along the way.
       */
-     all_clear = 1;
      if (SHpnt->some_device_starved) {
+           /* ->request_fn() will reset flag to 1, if needed */
+           SHpnt->some_device_starved = 0;
            for (SDpnt = SHpnt->host_queue; SDpnt; SDpnt = SDpnt->next) {
-                 request_queue_t *q;
-                 if ((SHpnt->can_queue > 0 && (SHpnt->host_busy >= SHpnt->can_queue))
-                     || (SHpnt->host_blocked)
-                     || (SHpnt->host_self_blocked)) {
-                       break;
-                 }
-                 if (SDpnt->device_blocked || !SDpnt->starved) {
+                 if (!SDpnt->starved)
                        continue;
-                 }
-                 q = &SDpnt->request_queue;
+                 request_queue_t *q = &SDpnt->request_queue;
                  q->request_fn(q);
-                 all_clear = 0;
-           }
-           if (SDpnt == NULL && all_clear) {
-                 SHpnt->some_device_starved = 0;
            }
      }
      spin_unlock_irqrestore(&io_request_lock, flags);

