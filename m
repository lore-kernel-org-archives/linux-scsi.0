From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [PATCH] sg block layer tcqing fix
Date: 06 Jan 2004 09:14:29 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1073402071.2047.5.camel@mulgrave>
References: <3FF08EAF.9080708@us.ibm.com>  <3FFA426B.2030406@torque.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:54926 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S264505AbUAFPOi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 6 Jan 2004 10:14:38 -0500
In-Reply-To: <3FFA426B.2030406@torque.net>
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: Brian King <brking@us.ibm.com>, dgilbert@interlog.com, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Mon, 2004-01-05 at 23:06, Douglas Gilbert wrote:
> Given that no other ULDs call blk_queue_*_tag() routines it seems
> a bit strange that sg, st and osst need to call blk_queue_end_tag()
> prior to calling scsi_release_request(). Perhaps the cleanup can be
> built into scsi_release_request() or a new variant (e.g.
> scsi_release_special_request() ) could be introduced.

I agree.  Having the ULD stop tags but not start them is a layering
violation.  The attached patch will end the tag in the release request.

It's still appropriate to release the tag earlier, as the mid layer does
to free up tag slots for other requests.  Once the tag is ended, the tag
queue flag is cleared, so the check in release request now fails.

James

===== drivers/scsi/scsi.c 1.132 vs edited =====
--- 1.132/drivers/scsi/scsi.c	Tue Sep 30 09:24:17 2003
+++ edited/drivers/scsi/scsi.c	Tue Jan  6 09:10:25 2004
@@ -142,6 +142,23 @@
 
 void __scsi_release_request(struct scsi_request *sreq)
 {
+	struct request *req = sreq->sr_request;
+
+	/* unlikely because the tag was usually ended earlier
+	 *
+	 * NOTE: the lock should be held while checking the
+	 * flag.  However, any race here requiring the lock
+	 * would be a gross error. */
+	if (unlikely(blk_rq_tagged(req))) {
+		unsigned long flags;
+		struct request_queue *q = req->q;
+
+		spin_lock_irqsave(q->queue_lock, flags);
+		blk_queue_end_tag(q, req);
+		spin_unlock_irqrestore(q->queue_lock, flags);
+	}
+
+
 	if (likely(sreq->sr_command != NULL)) {
 		struct scsi_cmnd *cmd = sreq->sr_command;
 

