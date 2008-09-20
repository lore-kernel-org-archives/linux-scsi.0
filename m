From: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Subject: Re: [PATCH] Fix handling of failed requests in scsi_io_completion
Date: Sat, 20 Sep 2008 12:55:06 -0500
Message-ID: <1221933306.3152.18.camel@localhost.localdomain>
References: <Pine.LNX.4.44L0.0809201241160.13839-100000@netrider.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <Pine.LNX.4.44L0.0809201241160.13839-100000-pYrvlCTfrz9XsRXLowluHWD2FQJk+8+b@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
Cc: Antonio Ospite <ospite-aNJ+ML1ZbiP93QAQaVx+gl6hYfS7NtTn@public.gmane.org>, USB list <linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Boaz Harrosh <bharrosh-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org>, Alan Jenkins <alan-jenkins-cCz0Lq7MMjm9FHfhHBbuYA@public.gmane.org>, Hans de Goede <j.w.r.degoede-fbo2DhPpy/Q@public.gmane.org>, SCSI development list <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Sat, 2008-09-20 at 13:06 -0400, Alan Stern wrote:
> On Sat, 20 Sep 2008, James Bottomley wrote:
> 
> > OK, I looked at it.  Sorry about the delay; I wanted to audit the users
> > to make sure we didn't over complete.  There's lots more than just the
> > last sector bug that relies on partial completions doing request
> > chunking.  I don't like your bytes == 0 micro optimisation, but other
> > than that, it looks fine.
> 
> I'm perfectly happy to remove that micro optimization.  Also it would 
> be good to break all the code motion out into a separate preliminary 
> patch, apart from the functional changes.  (The code motion in itself 
> is a worthwhile cleanup, IMO.)
> 
> > However, there's too much code movement in this for a bug fix that has
> > to go into a late -rc and the stable series.  I think the patch below
> > represents the smallest and simplest (and thus least error prone) fix,
> > doesn't it (the rest can go into scsi-misc as an enhancement)?
> 
> Your patch doesn't seem quite right.  Comments below.
> 
> As regards too much change for this late in -rc...  This bug affects 
> only a handful of devices, so far as we've seen.  It wouldn't hurt to 
> delay the fix until 2.6.27.stable.
> 
> > With regard to what the mid-layer is doing, for the error cases where we
> > send enough bytes to complete the request fully, I think the requeue
> > looks superfluous (it's never going to get into that code in
> > scsi_end_request),
> 
> Agreed.
> 
> > The other strange bit is that I can't find any error
> > cases where we don't complete everything ... i.e. the partial complete
> > and requeue never applies, so we should probably just be using
> > end_dequeued_request().
> 
> These cases can arise from the "last-sector bug" stuff.  As an example,
> suppose a program tries to read the last 2 sectors of the device.  The
> "last-sector bug" code breaks the request in two; the first command
> will read only the second-to-last sector.  If this command fails with
> an error, you're in exactly this case -- an error in which less than
> the entire request has been completed.  Depending on the exact nature 
> of the error, we will choose between failing the entire request or 
> failing just the second-to-last sector (and requeuing the command in 
> order to try reading the last sector).

No ... I understand how they arise:  They arise from any transaction
where the transaction length is less than the request length ... that's
not just the last sector bug stuff.

What I mean is that I can't find an error case that's currently shown
scsi_end_request(cmd, -EIO, this_count, 1) where requeuing after
completing only the currently attempted transfer is valid.  If this had
all been done as a single transaction, we'd have killed everything at
this point.  Just because we split the request into multiple
transactions doesn't mean we should go back around and try a new
transaction after we hit an error.

> >  I also think we could junk scsi_end_request()
> > in faviour of blk_end_request and do the blk_noretry_request() check
> > inline in scsi_io_completion, after we try to complete but before we
> > might retry.
> 
> Possibly.  With the patch in place, scsi_end_request() gets called in 
> only three places, one of which doesn't attempt to do any retries.  But 
> that still leaves two places which might attempt it, so the retry logic 
> would have to be inlined twice.
> 
> > --- a/drivers/scsi/scsi_lib.c
> > +++ b/drivers/scsi/scsi_lib.c
> > @@ -852,7 +852,7 @@ static void scsi_end_bidi_request(struct scsi_cmnd *cmd)
> >  void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
> >  {
> >  	int result = cmd->result;
> > -	int this_count = scsi_bufflen(cmd);
> > +	int this_count;
> >  	struct request_queue *q = cmd->device->request_queue;
> >  	struct request *req = cmd->request;
> >  	int error = 0;
> > @@ -908,6 +908,7 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
> >  	 */
> >  	if (scsi_end_request(cmd, error, good_bytes, result == 0) == NULL)
> >  		return;
> > +	this_count = blk_rq_bytes(req);
> >  
> >  	/* good_bytes = 0, or (inclusive) there were leftovers and
> >  	 * result = 0, so scsi_end_request couldn't retry.
> 
> The problem is what happens in all the "retry" paths that follow.  
> They end up doing this:
> 
> 		scsi_end_request(cmd, -EIO, this_count, 1);
> 
> when in fact they should do this:
> 
> 		scsi_end_request(cmd, -EIO, 0, 1);
> 
> (where the -EIO value is ignored).

Actually, no ... that's just equivalent to scsi_requeue_command(q, cmd)
which is done at several places in the code (correctly) for sense errors
that imply the whole lot should be retried (actually, it's assuming
good_bytes is zero).

> By passing this_count as the third argument, they are telling the block
> layer that the entire remainder of the request completed with an error.  
> Hence blk_end_request() will return 0, scsi_end_request() won't take
> its "blocks left over at the end" pathway, and nothing will be
> requeued.

OK, so look at the current code in scsi_io_completion where we call
scsi_end_request(cmd, -EIO, this_count, 1):

UNIT ATTENTION for removable medium (means medium changed)
ILLEGAL REQUEST where there's no command resize fallback
NOT READY for unknown (non retryable) reasons
VOLUME OVERFLOW

In none of these cases do we want any form of requeuing, we want to kill
the entire request.

James


--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
