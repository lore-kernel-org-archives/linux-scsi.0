From: scameron@beardog.cce.hp.com
Subject: Re: Questions about your scsi-mq prototype
Date: Fri, 26 Jul 2013 08:29:40 -0500
Message-ID: <20130726132940.GL24664@beardog.cce.hp.com>
References: <20130715214143.GN24437@beardog.cce.hp.com> <1373996340.7397.818.camel@haakon3.risingtidesystems.com> <1374804999.7397.1476.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g6t0184.atlanta.hp.com ([15.193.32.61]:21917 "EHLO
	g6t0184.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755189Ab3GZNkw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 26 Jul 2013 09:40:52 -0400
Content-Disposition: inline
In-Reply-To: <1374804999.7397.1476.camel@haakon3.risingtidesystems.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: chayan.biswas@sandisk.com, linux-scsi <linux-scsi@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>, Robert Elliot <Elliott@hp.com>, scameron@beardog.cce.hp.com

On Thu, Jul 25, 2013 at 07:16:39PM -0700, Nicholas A. Bellinger wrote:
> On Tue, 2013-07-16 at 10:39 -0700, Nicholas A. Bellinger wrote:
> > On Mon, 2013-07-15 at 16:41 -0500, scameron@beardog.cce.hp.com wrote:
> > > Hi,
> > > 
> > > I have some questions about your scsi-mq prototype.  I have
> > > CC'ed Chayan Biswas from Sandisk who is the other guy working
> > > with me on the scsi-over-pcie driver.  BTW, if you would prefer
> > > I CC linux-kernel or linux-scsi or other people with such
> > > questions (or refrain from bothering you at all) just let me know.
> > > 
> > 
> > Thanks for asking.  Adding CC's to linux-scsi + Jens now..
> > 
> > > I wonder if you can provide a summary of how you envision
> > > a scsi LLD is expected to interact with the scsi-mq code.  I
> > > gather that:
> > > 
> > > 1. scsi_mq in scsi_host_template should be set to true.
> > 
> > Correct.
> > 
> > > 2. scsi LLD should provide queuecommand_mq function
> > >    (in addition to normal queuecommand? or instead of?
> > >     virtio_scsi.c seems to provide both.)
> > 
> > In addition to for the moment, correct.
> > 
> > > 3. LLD should tell scsi mid layer size of its commands via
> > >    scsi_host_template cmd_size field.
> > >    I guess midlayer will pre-allocate per queue to avoid 
> > >    the midlayer threads contending to allocate commands maybe?
> > >    and hands this space to LLD to use via sc->SCp.ptr (sc is struct scsi_cmnd)
> > >    (right? or am I off in the weeds here?)
> > 
> > This is all exactly correct.
> > 
> > The one extra point here wrt ->queuecommand_mq() is that it's using the
> > same parameters for the moment, but once nr_hw_queues > 1 is
> > implemented, we will expect to pass down the associated blk_mq_hw_ctx in
> > order for the LLD to determine which hardware context the struct
> > scsi_cmnd is being dispatched upon.
> > 
> > > 4. Wondering about how the multiple queue thing will work.
> > >    I see this:
> > > 
> > >    #warning FIXME: Need to pass nr_hw_queues into scsi-mq
> > > 
> > >    and I don't see any code setting sdev_mq_reg.nr_hw_queues to
> > >    anything other than 1.
> > > 
> > >    So maybe I'm just looking too early and that part isn't done yet?
> > > 
> > 
> > Correct, not done yet..
> > 
> > However, so far with a single SCSI LUN with nr_hw_queues=1, 4k blocksize
> > randrw performance is on the order of 1M, vs. ~250K using legacy
> > scsi_request_fn().
> > 
> > > In any case, since we switched away from a scsi driver for the scsi-over-pcie
> > > driver to a block driver, the original scsi version of the driver has lain
> > > fallow, and the first thing we would need to do before we could begin to try
> > > to use your code is to update that driver to work with our current hardware, and
> > > take advantage of other code improvements made in the block driver.
> > > 
> > 
> 
> Hi Stephen & Robert,
> 
> Just curious if you've been able to make any progress here..?

Only just started to try to make the scsi variant of the sop driver
work again yesterday and start bringing it up to date since it was
last touched in December, and so I haven't done anything with the
scsi-mq code yet.  Too many other things demanding my attention at
work lately, but at least I was able to spend nearly all day yesterday
working on the scsi SOP driver.

> 
> Also as per our earlier off-list discussion, you should be able to
> safely run existing scsi_request_fn() based LLDs along side new
> SHT->scsi_mq=true enabled code for prototyping purposes.

Thanks, good to know.

> 
> Btw, any chance to get an SOP sample to hack on..?  I'd like to connect
> one of these to IvyBridge-EP silicon for various scsi-mq and target mode
> performance testing.  ;)

You mean hardware?  Not for me to answer, but I'd say it's not very
likely at the moment.

-- steve

