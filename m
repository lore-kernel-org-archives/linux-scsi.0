From: Alan Stern <stern@rowland.harvard.edu>
Subject: SCSI regression in 2.6.27 and Nokia phones
Date: Tue, 18 Nov 2008 15:54:32 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.0811181524240.23191-100000@netrider.rowland.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from netrider.rowland.org ([192.131.102.5]:1690 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752320AbYKRUyd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Nov 2008 15:54:33 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: USB Storage list <usb-storage@lists.one-eyed-alien.net>, SCSI development list <linux-scsi@vger.kernel.org>, stable@kernel.org

Everybody:

Nokia's phones are a real nuisance.  They've got lots of different 
models, with more coming out all the time, and every single one of them 
has a USB firmware bug causing it to report that it has one more sector 
of mass-storage than it really does.

On other operatings systems this isn't terribly noticeable.  But with 
Linux, things like the EFI GUID partitioning code and udev's vol_id 
program look specifically at the last sector to find partition and 
label information.

As it happens, these phones return no data and NO SENSE when asked for
the nonexistent "last" sector.  Up through 2.6.26 this apparently
worked okay.  There would be "Unable to read sector" errors in the
system log, but at least the owner could use the stupid thing.

However in 2.6.27 something changed, and now the SCSI midlayer goes
into an endless retry loop trying to read the invalid sector.  A bunch
of people have noticed and they are unhappy.

For the models we already know about, there are blacklist entries in
usb-storage indicating that the number of sectors is really one less
than what the device claims.  But this is a losing game: Nokia keeps
coming out with more models, and there are plenty of existing ones not
in the blacklist.  See the later comments in Bugzilla #11768 for 
examples.

How should we handle this?  I have already submitted to James a pair of
patches for 2.6.29 which will (taken together) fix the problem.  (They
were submitted two weeks ago, and so far there has not been any
feedback either positive or negative.)  For 2.6.27 and 2.6.28, the
simpler patch below will also break the endless loop.  But this one
hasn't been reviewed and it conflicts with the pair already submitted
-- and I firmly believe those two are the right way to go.

Since patches aren't supposed to go into a stable tree until they are 
in the mainline kernel, the best course forward isn't clear.  What 
should we do?

Alan Stern


------------------------------------------------------------------


Decrement the request's retry count when it is retried without making
any forward progress.  When the count drops below 0, fail the request.  
This prevents infinite retry loops of the sort seen with Nokia phones
when asked to read their nonexistent "last" sector.

Signed-Off-By: Alan Stern <stern@rowland.harvard.edu>

---

Index: 2.6.27.4/drivers/scsi/scsi_lib.c
===================================================================
--- 2.6.27.4.orig/drivers/scsi/scsi_lib.c
+++ 2.6.27.4/drivers/scsi/scsi_lib.c
@@ -611,6 +611,11 @@ static void scsi_requeue_command(struct 
 	struct request *req = cmd->request;
 	unsigned long flags;
 
+	if (--req->retries < 0) {
+		blk_end_request(req, -EIO, blk_rq_bytes(req));
+		scsi_next_command(cmd);
+		return;
+	}
 	scsi_unprep_request(req);
 	spin_lock_irqsave(q->queue_lock, flags);
 	blk_requeue_request(q, req);
@@ -690,6 +695,8 @@ static struct scsi_cmnd *scsi_end_reques
 				 * leftovers in the front of the
 				 * queue, and goose the queue again.
 				 */
+				if (bytes > 0)		/* Made progress */
+					++req->retries;
 				scsi_requeue_command(q, cmd);
 				cmd = NULL;
 			}

