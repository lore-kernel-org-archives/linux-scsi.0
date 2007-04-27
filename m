From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC PATCH]: Rewritten ESP driver, porters needed!
Date: Fri, 27 Apr 2007 16:16:58 +0100
Message-ID: <20070427151658.GA21669@infradead.org>
References: <20070423.151322.111205472.davem@davemloft.net> <20070424122235.GA26242@infradead.org> <20070424.134440.45874613.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <sparclinux-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20070424.134440.45874613.davem@davemloft.net>
Sender: sparclinux-owner@vger.kernel.org
To: David Miller <davem@davemloft.net>
Cc: hch@infradead.org, linux-scsi@vger.kernel.org, jskov@cygnus.co.uk, weisd3458@uni.edu, tymm@computer.org, tsbogend@alpha.franken.de, flo@rfc822.org, airlied@linux.ie, ralf@linux-mips.org, sparclinux@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Sorry for the late reply.  I'll stay in this thead despite the
new version beeing posted to not lose the context.

On Tue, Apr 24, 2007 at 01:44:40PM -0700, David Miller wrote:
> I did all of this, and it's fine, but there is one site which is much
> less pleasant, device reconnect.
> 
> With the esp_target_data->lun[] mapping the lookup during device
> reconnect was O(1), now I have to use __scsi_device_lookup_by_target()
> which is O(num_active_luns).
> 
> In fact the efficiency of that lookup was why I did the data
> structures the way I did in the first place.
> 
> But anyways this is cleaner for now and I doubt it matters for
> the setups people have with this chip.

The import bit is to have the 1:1 kmalloc/kfree pairing in slave_alloc
and slave_destroy to have consistant lifetime rules.  Using ->hostdata
is just ad tad cleaner ontop.   And given the number of targets an SPI
bus has, aswell as the number of luns seen on them the complexity
should not be a problem at all - if this was needed in a hotish path
in a fibrechannel drivers things would be different :)

> > >  
> > > +	esp_maybe_execute_command(esp);
> > 
> > You still have internal queueing in the driver, and I think this
> > is avoidable.  Instead you should just try to directly issue
> > the command and return SCSI_MLQUEUE_DEVICE_BUSY/SCSI_MLQUEUE_EH_RETRY
> > if you can't do it at this point.  The midlayer keeps proper per-lun
> > and per-host busy counters to call into ->queuecommand once the
> > next command returned and the lun/host is not busy anymore.
> 
> Hmmm, OK.  But which of those two error codes should I use?

SCSI_MLQUEUE_DEVICE_BUSY if you couldn't execute it due to a
lun/target-level resource shortage, or SCSI_MLQUEUE_HOST_BUSY
if it's a host-level or global resource shortage.  The
SCSI_MLQUEUE_EH_RETRY above was a typo no one notices and should
not be returned at all.

> Actually I don't think it's avoidable.  I set cmd_per_lun to "2"
> and in this way when a command completes I'll always be able to
> immediately issue another command for the same device even if
> disconnect is disabled.
> 
> Otherwise I have to wait for the softirq to run (after ->scsi_done())
> and then the scsi mid-layer to feed me another command.  Meanwhile
> the scsi bus will be idle when it could be instead running commands.
> 
> That is the reason behind this.  It's not simply for queueing up at
> ->queuecommand().  FWIW, I learned this technique from the aic7xxx
> driver :-)

aic7xxx might not be the best driver to look at either :)  In practice
a softirq has short enough latency so this doesn't matter, but you
should probably benchmark it on your hardware.  53x700.c which is
the most modern scsi driver and is in about the same hardware class
as the esp gets away without using internal queues, but it also
has a nice internal buffer where commands can just be put into slots
for later execution.

Btw, using the block layer tcq code and the scsi wrappers for it
would be nice aswell.


> unique_id is only 32-bits, the MMIO address on sparc64 systems often
> only differ in the upper 32bits, in fact I do remember one big sparc64
> box where the ESP register addresses only differed like that.
> 
> That's why I implemented it this way, I did look at other drivers
> and consider going the MMIO route but I simply can't :-)

As I said the value really doesn't matter.  We should probably get rid
of it and generate an uniqueue enough value in the midlayer instead to
keep the legacy API users happy.
