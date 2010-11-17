From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: block_abort_queue (blk_abort_request) racing with scsi_request_fn
Date: Wed, 17 Nov 2010 16:55:41 -0500
Message-ID: <20101117215541.GA7785@redhat.com>
References: <20100512052336.GB15240@linux.vnet.ibm.com>
 <4CDA4524.4010204@cs.wisc.edu>
 <4CDA49F8.9050406@cs.wisc.edu>
 <20101110163047.GA26201@linux.vnet.ibm.com>
 <4CDB0BAA.8060801@cs.wisc.edu>
 <20101112175440.GA3978@linux.vnet.ibm.com>
 <20101116213904.GA470@redhat.com>
 <20101117174925.GA2176@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56497 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759107Ab0KQVzw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 17 Nov 2010 16:55:52 -0500
Content-Disposition: inline
In-Reply-To: <20101117174925.GA2176@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@linux.vnet.ibm.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>, "dm-devel@redhat.com James Bottomley" <James.Bottomley@suse.de>, linux-scsi@vger.kernel.org

On Wed, Nov 17 2010 at 12:49pm -0500,
Mike Anderson <andmike@linux.vnet.ibm.com> wrote:

> Mike Snitzer <snitzer@redhat.com> wrote:
> > Hi Mike,
> > 
> > On Fri, Nov 12 2010 at 12:54pm -0500,
> > Mike Anderson <andmike@linux.vnet.ibm.com> wrote:
> > 
> > > By not directly timing out the I/O but accelerating the timeout by a
> > > factor. The value could be calculated as a percentage of the queue timeout
> > > value for a default with the option of exposing a sysfs attribute
> > > similar to fast_io_fail_tmo. The attribute could also provide a off
> > > method which we do not have today and is my bad that we do not have one
> > > (I posted the features patch to multipath but did not followup which
> > > would have provided a off).
> > 
> > You're referring to these patches:
> > https://patchwork.kernel.org/patch/96674/
> > https://patchwork.kernel.org/patch/96673/
> > 
> 
> Yes these are the patches that I was referring to.
> 
> > Do you have an interest in pursuing these further? 
> 
> Yes.
> 
> > In the near-term
> > should we default to off (so introduce MP_FEATURE_ABORT_Q) -- given the
> > current race which exposes corruption?
> > 
> 
> Given the current race exposure default to off might be the best choice.

OK, I can work to refresh these patches, invert the logic to default to
off, and repost.  But in addition I'll post a 3rd patch that disallows
anything but off.

> > Or are you now interested in accelerating the timeout?  I'd need to
> > review this thread in more detail to give you an opinion.  But I do know
> > that simply disabling dm-mpath's call to blk_abort_queue() enables some
> > extensive path failure load testing to _not_ cause the list corruption
> > that leads to a crash.
> 
> I think the on/off control plus a fix to address the issue when it is on
> would be good. Since I do not believe we want the impact the normal IO
> path by more lock bouncing adding modification of the blk_abort_queue
> function appeared like one of the least distributive options. There might
> be others.

OK, I'll defer to you (and/or Mike C) to propose that additional fix
to allow us to safely enable the feature.  As part of that patch you'd
revert the small change from my 3rd patch that disallows anything but
off?

Could be that we won't need my 3rd patch -- if your additional fix for
the race can be developed and tested quickly.  But "quickly" is all
relative, the comprehensive load testing I've done is successful if it
lasts ~50 hours without crashing.

Thanks,
Mike
