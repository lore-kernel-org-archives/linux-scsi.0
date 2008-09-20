From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] Fix handling of failed requests in scsi_io_completion
Date: Sat, 20 Sep 2008 16:09:15 -0500
Message-ID: <1221944955.3152.58.camel@localhost.localdomain>
References: <Pine.LNX.4.44L0.0809201640160.16873-100000@netrider.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:41485 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751387AbYITVJ3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 20 Sep 2008 17:09:29 -0400
In-Reply-To: <Pine.LNX.4.44L0.0809201640160.16873-100000@netrider.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Antonio Ospite <ospite@studenti.unina.it>, USB list <linux-usb@vger.kernel.org>, Boaz Harrosh <bharrosh@panasas.com>, Alan Jenkins <alan-jenkins@tuffmail.co.uk>, Hans de Goede <j.w.r.degoede@hhs.nl>, SCSI development list <linux-scsi@vger.kernel.org>

On Sat, 2008-09-20 at 16:49 -0400, Alan Stern wrote:
> On Sat, 20 Sep 2008, James Bottomley wrote:
> 
> > What I mean is that I can't find an error case that's currently shown
> > scsi_end_request(cmd, -EIO, this_count, 1) where requeuing after
> > completing only the currently attempted transfer is valid.  If this had
> > all been done as a single transaction, we'd have killed everything at
> > this point.  Just because we split the request into multiple
> > transactions doesn't mean we should go back around and try a new
> > transaction after we hit an error.
> 
> Yes, that makes sense.
> 
> > > They end up doing this:
> > > 
> > > 		scsi_end_request(cmd, -EIO, this_count, 1);
> > > 
> > > when in fact they should do this:
> > > 
> > > 		scsi_end_request(cmd, -EIO, 0, 1);
> > > 
> > > (where the -EIO value is ignored).
> > 
> > Actually, no ... that's just equivalent to scsi_requeue_command(q, cmd)
> > which is done at several places in the code (correctly) for sense errors
> > that imply the whole lot should be retried (actually, it's assuming
> > good_bytes is zero).
> 
> Except that those places don't do the blk_noretry_request test.  Should 
> they?  And even if they do, what's to prevent an infinite retry loop?

Well, that's another oddity ... the retries occur at a lower level
(scsi_decide_disposition) ... there's no reason to make that check if
all the error paths complete everything.  Now if we find an error where
we should be moving on to the next transaction, then we'd need to do
that test.  However, I think I've demonstrated so far that there isn't
one.  I also don't think we want to make the test for the obviously
retryable conditions like UNIT_ATTENTION because that will cause paths
to flip on irrelevant AEN conditions.

> > OK, so look at the current code in scsi_io_completion where we call
> > scsi_end_request(cmd, -EIO, this_count, 1):
> > 
> > UNIT ATTENTION for removable medium (means medium changed)
> > ILLEGAL REQUEST where there's no command resize fallback
> > NOT READY for unknown (non retryable) reasons
> > VOLUME OVERFLOW
> > 
> > In none of these cases do we want any form of requeuing, we want to kill
> > the entire request.
> 
> I take your point.  Which leads to the question: Why was the code ever 
> calling scsi_end_request(cmd, -EIO, this_count, 1) in the first place?  
> Apparently all of these paths should be setting the last argument to 0, 
> always.

Yes, that was the question I asked in my first reply (where I said the
requeue looks superfluous).  I think the answer is that there's no
point ... that's why I advocated simply eliminating scsi_end_request()
in favour of either scsi_requeue_request/blk_run_queue or
end_dequeued_request().

So are you happy with the simple fix proposal ... I think rearranging
this code needs more debate and discussion.

James


