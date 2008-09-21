From: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Subject: Re: [PATCH] Fix handling of failed requests in scsi_io_completion
Date: Sun, 21 Sep 2008 14:57:04 -0500
Message-ID: <1222027024.3152.117.camel@localhost.localdomain>
References: <Pine.LNX.4.44L0.0809201640160.16873-100000@netrider.rowland.org>
	 <1221944955.3152.58.camel@localhost.localdomain>
	 <48D64459.2010802@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <48D64459.2010802-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Boaz Harrosh <bharrosh-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org>
Cc: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>, Antonio Ospite <ospite-aNJ+ML1ZbiP93QAQaVx+gl6hYfS7NtTn@public.gmane.org>, USB list <linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Alan Jenkins <alan-jenkins-cCz0Lq7MMjm9FHfhHBbuYA@public.gmane.org>, Hans de Goede <j.w.r.degoede-fbo2DhPpy/Q@public.gmane.org>, SCSI development list <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Sun, 2008-09-21 at 15:55 +0300, Boaz Harrosh wrote:
> James Bottomley wrote:
> >>>
> >>> In none of these cases do we want any form of requeuing, we want to kill
> >>> the entire request.
> >> I take your point.  Which leads to the question: Why was the code ever 
> >> calling scsi_end_request(cmd, -EIO, this_count, 1) in the first place?  
> >> Apparently all of these paths should be setting the last argument to 0, 
> >> always.
> > 
> > Yes, that was the question I asked in my first reply (where I said the
> > requeue looks superfluous).  I think the answer is that there's no
> > point ... that's why I advocated simply eliminating scsi_end_request()
> > in favour of either scsi_requeue_request/blk_run_queue or
> > end_dequeued_request().
> > 
> > So are you happy with the simple fix proposal ... I think rearranging
> > this code needs more debate and discussion.
> > 
> > James
> > 
> 
> It looks to me that your 2-liners is a much deeper change then Alen's
> original patch, with it's big code movements. So it might be a candidate
> for a next release but not as a late -rc bug fix. This is because Allen's
> patch is just a mechanical code change, that we can carefully follow and
> verify to be equivalent code, minus the bug. Your patch changes behavior
> of existing code and should be tested more carefully. What changes is your
> retry behavior.

Both patches change the retry behaviour for multi transaction requests.

>  I am pretty convinced of what you said, about all these retrys
> been impossible/not-wanted, and I think your final deep proposal is the right
> one, I wanted to clean this code up and get rid of scsi_end_request lots of
> times in the passed. But for a late -rc bug fix it feels very dangerous. I have
> observed more then one situation where retrys are a part of a normal IO and
> I would like more time to test all the implications.

OK, so point out that test case in this retry code.  Bearing in mind
that the behaviour in question only applies to the multi-transaction
commands, which aren't the normal case.  I think the principle that if
we could have completed the command in one transaction then we should
behave identically for the multi-transaction one is correct.

> I have reviewed Allen's patch very carefully several times, and have been running
> with it since he posted it. So:
>  Reviewed-by: Boaz Harrosh <bharrosh-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org> 
>  Tested-by: Boaz Harrosh <bharrosh-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org>

Hmm, I think you'll find with the original patch that you can generate
infinite retries with volume overflow because of the retry behaviour
change.  The same is true of any immutable error condition that goes
through the retry: path.

> If you'll dig into the email-thread You'll see that I sent something
> exactly like yours, at the very beginning, but Alen convinced me that it
> is more dangerous, and should be in a following patch.

Like I said, for a single transaction we kill everything after the error
point.  That should be the same for multiple transaction commands
because the behaviour on error shouldn't depend on how the command was
split.

James


--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
