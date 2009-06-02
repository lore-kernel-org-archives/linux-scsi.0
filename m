From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/2] cciss: Fix SCSI device reset handler
Date: Tue, 2 Jun 2009 10:51:14 -0700
Message-ID: <20090602105114.fe754481.akpm@linux-foundation.org>
References: <20090527203007.GA30160@beardog.cca.cpqcorp.net>
	<20090529124208.531839fe.akpm@linux-foundation.org>
	<20090602125011.GJ11363@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37951 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755231AbZFBRvY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Jun 2009 13:51:24 -0400
In-Reply-To: <20090602125011.GJ11363@kernel.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: scameron@beardog.cca.cpqcorp.net, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, mikem@beardog.cca.cpqcorp.net

On Tue, 2 Jun 2009 14:50:11 +0200
Jens Axboe <jens.axboe@oracle.com> wrote:

> On Fri, May 29 2009, Andrew Morton wrote:
> > On Wed, 27 May 2009 15:30:07 -0500
> > scameron@beardog.cca.cpqcorp.net wrote:
> > 
> > > +static int wait_for_device_to_become_ready(ctlr_info_t *h,
> > > +	unsigned char lunaddr[])
> > > +{
> > > +	int rc;
> > > +	int count = 0;
> > > +	int waittime = HZ;
> > > +	CommandList_struct *c;
> > > +
> > > +	c = cmd_alloc(h, 1);
> > > +	if (!c) {
> > > +		printk(KERN_WARNING "cciss%d: out of memory in "
> > > +			"wait_for_device_to_become_ready.\n", h->ctlr);
> > > +		return IO_ERROR;
> > > +	}
> > > +
> > > +	/* Send test unit ready until device ready, or give up. */
> > > +	while (count < 20) {
> > > +
> > > +		/* Wait for a bit.  do this first, because if we send
> > > +		 * the TUR right away, the reset will just abort it.
> > > +		 */
> > > +		set_current_state(TASK_INTERRUPTIBLE);
> > > +		schedule_timeout(waittime);
> > 
> > That's schedule_timeout_interruptible().
> > 
> > The problem with interruptible sleeps of this nature is that they are
> > no-ops if the calling process happens to have signal_pending().  I
> > suspect that this condition will break your driver.
> > 
> > If so, switching to schedule_timeout_uninterruptible() will unbreak it.
> 
> I added Stephens patch and your fixup.

My cciss-fix-scsi-device-reset-handler-fix.patch was a simple cleanup -
it uses schedule_timeout_interruptible().

I believe that this should be changed to
schedule_timeout_uninterruptible() for the above reasons, but the cciss
guys fell asleep on me.

