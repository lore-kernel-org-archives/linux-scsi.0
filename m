From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: CPU lock-ups with 4.12.0+ kernels related to usb_storage
Date: Thu, 13 Jul 2017 13:00:29 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1707131258190.1571-100000@iolanthe.rowland.org>
References: <20170712165200.GA29145@lst.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:51432 "HELO
        iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with SMTP id S1751114AbdGMRAb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 13 Jul 2017 13:00:31 -0400
In-Reply-To: <20170712165200.GA29145@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Arthur Marsh <arthur.marsh@internode.on.net>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, USB list <linux-usb@vger.kernel.org>, SCSI development list <linux-scsi@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>

On Wed, 12 Jul 2017, Christoph Hellwig wrote:

> On Wed, Jul 12, 2017 at 12:10:02PM -0400, Alan Stern wrote:
> > This is pretty conclusive.  The problem comes about because
> > usb_stor_control_thread() calls scsi_mq_done() while holding
> > shost->host_lock, and then scsi_eh_scmd_add() tries to acquire that
> > same lock.
> > 
> > I don't know why this didn't show up in earlier kernels.  I guess some
> > element of the call chain listed above must be new in 4.12.
> > 
> > Christoph, what's the best way to fix this?  Should usb-storage release
> > the host lock before issuing the ->scsi_done callback?  If so, does
> > that change need to be applied to any kernels before 4.12?
> 
> 4.12 switched to blk-mq by default, and while the old code used
> a softirq for completions, which is always a difference context
> the blk-mq code might execute in the same context it's called in.
> 
> So yes, for that we'd need to drop host_lock.  But I wonder how
> many more of these are lingering somewhere and if we can find
> another workaround.

All right.  In the meantime, changing usb-storage won't hurt.
Arthur, can you test the patch below?

Alan Stern



Index: usb-4.x/drivers/usb/storage/usb.c
===================================================================
--- usb-4.x.orig/drivers/usb/storage/usb.c
+++ usb-4.x/drivers/usb/storage/usb.c
@@ -315,6 +315,7 @@ static int usb_stor_control_thread(void
 {
 	struct us_data *us = (struct us_data *)__us;
 	struct Scsi_Host *host = us_to_host(us);
+	struct scsi_cmnd *srb;
 
 	for (;;) {
 		usb_stor_dbg(us, "*** thread sleeping\n");
@@ -330,6 +331,7 @@ static int usb_stor_control_thread(void
 		scsi_lock(host);
 
 		/* When we are called with no command pending, we're done */
+		srb = us->srb;
 		if (us->srb == NULL) {
 			scsi_unlock(host);
 			mutex_unlock(&us->dev_mutex);
@@ -398,14 +400,11 @@ static int usb_stor_control_thread(void
 		/* lock access to the state */
 		scsi_lock(host);
 
-		/* indicate that the command is done */
-		if (us->srb->result != DID_ABORT << 16) {
-			usb_stor_dbg(us, "scsi cmd done, result=0x%x\n",
-				     us->srb->result);
-			us->srb->scsi_done(us->srb);
-		} else {
+		/* was the command aborted? */
+		if (us->srb->result == DID_ABORT << 16) {
 SkipForAbort:
 			usb_stor_dbg(us, "scsi command aborted\n");
+			srb = NULL;	/* Don't call srb->scsi_done() */
 		}
 
 		/*
@@ -429,6 +428,13 @@ SkipForAbort:
 
 		/* unlock the device pointers */
 		mutex_unlock(&us->dev_mutex);
+
+		/* now that the locks are released, notify the SCSI core */
+		if (srb) {
+			usb_stor_dbg(us, "scsi cmd done, result=0x%x\n",
+					srb->result);
+			srb->scsi_done(srb);
+		}
 	} /* for (;;) */
 
 	/* Wait until we are told to stop */
