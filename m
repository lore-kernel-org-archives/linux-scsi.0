From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] Fix handling of failed requests in scsi_io_completion
Date: Sat, 20 Sep 2008 00:31:50 +0000
Message-ID: <1221870710.3428.25.camel@localhost.localdomain>
References: <Pine.LNX.4.44L0.0809191152200.2429-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:48374 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751128AbYITPR3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 20 Sep 2008 11:17:29 -0400
In-Reply-To: <Pine.LNX.4.44L0.0809191152200.2429-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Antonio Ospite <ospite@studenti.unina.it>, USB list <linux-usb@vger.kernel.org>, Boaz Harrosh <bharrosh@panasas.com>, Alan Jenkins <alan-jenkins@tuffmail.co.uk>, Hans de Goede <j.w.r.degoede@hhs.nl>, SCSI development list <linux-scsi@vger.kernel.org>

On Fri, 2008-09-19 at 11:53 -0400, Alan Stern wrote:
> On Fri, 19 Sep 2008, Antonio Ospite wrote:
> 
> > On Fri, 5 Sep 2008 15:35:13 -0400 (EDT)
> > Alan Stern <stern@rowland.harvard.edu> wrote:
> > 
> > > On Wed, 27 Aug 2008, Alan Stern wrote:
> > > 
> > > > This patch (as1133) fixes a bug in the interaction between
> > > > scsi_end_request() and scsi_io_completion().  The bug was triggered by
> > > > recent changes to accomodate USB drives can't access their last few
> > > > sectors using multi-sector transfers (the so-called last_sector_bug
> > > > flag).
> > > > 
> > > > The bug shows up when a multi-sector I/O request has been broken up
> > > > into single-sector commands.  If one of those commands gets an error,
> > > > the remainder of the request never gets completed.  This is because
> > > > the "bytes" value passed to scsi_end_request() is completely wrong; it
> > > > is the transfer size of the current command, not the total transfer
> > > > size of the request.
> > > 
> > > There hasn't been any reply to this patch submission.  For reference,
> > > the original message is at
> > > 
> > > 	http://marc.info/?l=linux-scsi&m=121986305201166&w=2
> > > 
> > > Has it been accepted, rejected, or did it fall through the cracks?
> > > 
> > > Alan Stern
> > >
> > 
> > Hi again,
> > 
> > anything new about this patch? Alan, I'll keep reminding about it from
> > time to time, until it is accepted or rejected.
> 
> All I can tell you is that I asked James Bottomley at the Linux Kernel
> Summit, and he said he has been too busy to look at it but it's got an
> "!" on his to-do list.

OK, I looked at it.  Sorry about the delay; I wanted to audit the users
to make sure we didn't over complete.  There's lots more than just the
last sector bug that relies on partial completions doing request
chunking.  I don't like your bytes == 0 micro optimisation, but other
than that, it looks fine.

However, there's too much code movement in this for a bug fix that has
to go into a late -rc and the stable series.  I think the patch below
represents the smallest and simplest (and thus least error prone) fix,
doesn't it (the rest can go into scsi-misc as an enhancement)?

With regard to what the mid-layer is doing, for the error cases where we
send enough bytes to complete the request fully, I think the requeue
looks superfluous (it's never going to get into that code in
scsi_end_request), The other strange bit is that I can't find any error
cases where we don't complete everything ... i.e. the partial complete
and requeue never applies, so we should probably just be using
end_dequeued_request().  I also think we could junk scsi_end_request()
in faviour of blk_end_request and do the blk_noretry_request() check
inline in scsi_io_completion, after we try to complete but before we
might retry.

James

---

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index ff5d56b..62307bd 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -852,7 +852,7 @@ static void scsi_end_bidi_request(struct scsi_cmnd *cmd)
 void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 {
 	int result = cmd->result;
-	int this_count = scsi_bufflen(cmd);
+	int this_count;
 	struct request_queue *q = cmd->device->request_queue;
 	struct request *req = cmd->request;
 	int error = 0;
@@ -908,6 +908,7 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 	 */
 	if (scsi_end_request(cmd, error, good_bytes, result == 0) == NULL)
 		return;
+	this_count = blk_rq_bytes(req);
 
 	/* good_bytes = 0, or (inclusive) there were leftovers and
 	 * result = 0, so scsi_end_request couldn't retry.


