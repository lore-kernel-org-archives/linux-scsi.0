From: Luben Tuikov <ltuikov@yahoo.com>
Subject: Re: [PATCH 1/2] [SCSI] Print only a single message "rejecting I/O to device being removed"
Date: Sun, 5 Nov 2006 11:08:11 -0800 (PST)
Message-ID: <267953.40180.qm@web31808.mail.mud.yahoo.com>
References: <20061105113628.GU13555@kernel.dk>
Reply-To: ltuikov@yahoo.com
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web31808.mail.mud.yahoo.com ([68.142.207.71]:2447 "HELO
	web31808.mail.mud.yahoo.com") by vger.kernel.org with SMTP
	id S1161533AbWKETIM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 5 Nov 2006 14:08:12 -0500
In-Reply-To: <20061105113628.GU13555@kernel.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

--- Jens Axboe <jens.axboe@oracle.com> wrote:
> On Sat, Nov 04 2006, Luben Tuikov wrote:
> > --- Jens Axboe <jens.axboe@oracle.com> wrote:
> > > On Fri, Nov 03 2006, Luben Tuikov wrote:
> > > > ... at device removal.
> > > > 
> > > > Signed-off-by: Luben Tuikov <ltuikov@yahoo.com>
> > > > ---
> > > >  drivers/scsi/scsi_lib.c    |   10 +++++++---
> > > >  drivers/scsi/scsi_scan.c   |    1 +
> > > >  include/scsi/scsi_device.h |    3 +++
> > > >  3 files changed, 11 insertions(+), 3 deletions(-)
> > > > 
> > > > diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> > > > index 7b0f9a3..f0de7ca 100644
> > > > --- a/drivers/scsi/scsi_lib.c
> > > > +++ b/drivers/scsi/scsi_lib.c
> > > > @@ -1302,9 +1302,13 @@ static int scsi_prep_fn(struct request_q
> > > >  			if(specials_only == SDEV_QUIESCE ||
> > > >  					specials_only == SDEV_BLOCK)
> > > >  				goto defer;
> > > > -			
> > > > -			sdev_printk(KERN_ERR, sdev,
> > > > -				    "rejecting I/O to device being removed\n");
> > > > +
> > > > +			if (sdev->num_rej_messages > 0) {
> > > > +				sdev->num_rej_messages--;
> > > > +				sdev_printk(KERN_ERR, sdev,
> > > > +					    "rejecting I/O to device "
> > > > +					    "being removed\n");
> > > > +			}
> > > 
> > > How about using some variant of printk_ratelimit() instead?
> > 
> > Jens, I didn't think to use such a heavy-weight as printk_ratelimit()
> > (grabbing irq spinlocks et al), since the device struct would be
> > "freed" shortly.  FWIW, one message is more than enough. I'm being
> > liberal with 5, but would gladly revert it back to the original
> > of one message.
> 
> It's a printk, it doesn't matter how heavy weight it is. Just seems
> silly to re-invent some sort of printk limiter, when one already exists.

As with anything in life -- beauty is in the eye of the beholder.
Having said that, I'll take a patch using printk_ratelimint(), too.

The bottom line was that I didn't want over 2 million messages
of sorts to be printed within very short period of time and
soft-locking all 4 CPUs.

> > Feel free to resubmit using printk_ratelimit().
> 
> Sorry no plans to do that, I'll let James decide what he wants to take
> or not.

You seem to know what is better for upsream Linux, i.e. using
printk_ratelimit() vs. printk() on a device which will be freed.

Why not submit your own version of the same thing "doing it the right
way"?

I'll gladly take your "correct" version.

I've been carrying this patch for 8 months -- git-branch and git-merge
are a wonderful thing -- what makes you think I've any aspirations for
it to go to upstream?  I was merely sharing the conditions I've seen
with SCSI hot-plug and hot-unplug and was surprised that no one has seen
this before and posted a similar patch, for 8 months.

    Luben

