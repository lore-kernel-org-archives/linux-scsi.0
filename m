From: scameron@beardog.cca.cpqcorp.net
Subject: Re: [PATCH 2/2] cciss: Fix SCSI device reset handler
Date: Tue, 2 Jun 2009 13:20:51 -0500
Message-ID: <20090602182051.GR30160@beardog.cca.cpqcorp.net>
References: <20090527203007.GA30160@beardog.cca.cpqcorp.net> <20090529124208.531839fe.akpm@linux-foundation.org> <20090602125011.GJ11363@kernel.dk> <20090602105114.fe754481.akpm@linux-foundation.org> <20090602175814.GO11363@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:27767 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752528AbZFBSU2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Jun 2009 14:20:28 -0400
Content-Disposition: inline
In-Reply-To: <20090602175814.GO11363@kernel.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, mikem@beardog.cca.cpqcorp.net


On Tue, Jun 02, 2009 at 07:58:14PM +0200, Jens Axboe wrote:
> On Tue, Jun 02 2009, Andrew Morton wrote:
> > On Tue, 2 Jun 2009 14:50:11 +0200
> > Jens Axboe <jens.axboe@oracle.com> wrote:
> > 
> > > On Fri, May 29 2009, Andrew Morton wrote:
> > > > On Wed, 27 May 2009 15:30:07 -0500
> > > > scameron@beardog.cca.cpqcorp.net wrote:
> > > > 
> > > > > +static int wait_for_device_to_become_ready(ctlr_info_t *h,
> > > > > +	unsigned char lunaddr[])
> > > > > +{
> > > > > +	int rc;
> > > > > +	int count = 0;
> > > > > +	int waittime = HZ;
> > > > > +	CommandList_struct *c;
> > > > > +
> > > > > +	c = cmd_alloc(h, 1);
> > > > > +	if (!c) {
> > > > > +		printk(KERN_WARNING "cciss%d: out of memory in "
> > > > > +			"wait_for_device_to_become_ready.\n", h->ctlr);
> > > > > +		return IO_ERROR;
> > > > > +	}
> > > > > +
> > > > > +	/* Send test unit ready until device ready, or give up. */
> > > > > +	while (count < 20) {
> > > > > +
> > > > > +		/* Wait for a bit.  do this first, because if we send
> > > > > +		 * the TUR right away, the reset will just abort it.
> > > > > +		 */
> > > > > +		set_current_state(TASK_INTERRUPTIBLE);
> > > > > +		schedule_timeout(waittime);
> > > > 
> > > > That's schedule_timeout_interruptible().
> > > > 
> > > > The problem with interruptible sleeps of this nature is that they are
> > > > no-ops if the calling process happens to have signal_pending().  I
> > > > suspect that this condition will break your driver.
> > > > 
> > > > If so, switching to schedule_timeout_uninterruptible() will unbreak it.
> > > 
> > > I added Stephens patch and your fixup.
> > 
> > My cciss-fix-scsi-device-reset-handler-fix.patch was a simple cleanup -
> > it uses schedule_timeout_interruptible().
> > 
> > I believe that this should be changed to
> > schedule_timeout_uninterruptible() for the above reasons, but the cciss
> > guys fell asleep on me.
> 
> It's an improvement, none the less. And I bet it should just be
> uninterruptible sleep, unless it has a good reason to accept signals.
> Mike? Stephen?
> 
> -- 
> Jens Axboe
> 

Sorry for the slow reply.

No good reason that I know to accept signals, I'll defer to your
judgement on that.  When I wrote that schedule_timeout_... line,
I was vaguely wondering if it was quite right.

That being said, I'm working on a set of patches to make the cciss
SCSI error handling stuff work with interrupts enabled, which
means making similar changes to sendcmd_withirq() as I already
did to sendcmd() among some other stuff.   I didn't notice until
just a few days ago that since sometime in 2.4 kernels you no longer 
need to do the SCSI error handling with interrupts disabled as
in 2.2 kernels.  Mike asked me why we did it with interrupts
disabled, and I went looking in the docs to try to find where
it said we needed to do that, and... oh, that requirement is
gone.

So, if I rewrite the stuff to work with interrupts enabled, 
would that change which kind of schedule_timeout() should be used?
Or is that unrelated, and it depends whether you plan to do
something with signals?  I'm not all that clear when to use
one vs. tha other.

-- steve
