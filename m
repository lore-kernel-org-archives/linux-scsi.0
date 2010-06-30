From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [dm-devel] [PATCH 1/2] block: fix leaks associated with
 discard request payload
Date: Wed, 30 Jun 2010 09:22:18 -0500
Message-ID: <1277907738.2839.9.camel@mulgrave.site>
References: <20100622180029.GA15950@redhat.com>
	 <1277582211-10725-1-git-send-email-snitzer@redhat.com>
	 <1277652576.4366.19.camel@mulgrave.site>
	 <Pine.LNX.4.64.1006291811300.27462@hs20-bc2-1.build.redhat.com>
	 <1277852600.4379.211.camel@mulgrave.site>
	 <Pine.LNX.4.64.1006291925480.11847@hs20-bc2-1.build.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:35518 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754016Ab0F3OWZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Jun 2010 10:22:25 -0400
In-Reply-To: <Pine.LNX.4.64.1006291925480.11847@hs20-bc2-1.build.redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>, Mike Snitzer <snitzer@redhat.com>, axboe@kernel.dk, linux-scsi@vger.kernel.org, martin.petersen@oracle.com, linux-kernel@vger.kernel.org, akpm@linux-foundation.org, Christoph Hellwig <hch@lst.de>

On Tue, 2010-06-29 at 20:11 -0400, Mikulas Patocka wrote:
> > > If the layering violation spans only scsi code, it can be eventually 
> > > fixed, but this, much worse "layering violation" that will be spanning all 
> > > block device midlayers, won't ever be fixed.
> > > 
> > > Imagine for example --- a discard request arrivers at a dm-snapshot 
> > > device. The driver splits it into chunks, remaps each chunk to the 
> > > physical chunk, submits the requests, the elevator merges adjacent 
> > > requests and submits fewer bigger requests to the device. Now, if you had 
> > > to allocate a zeroed page each time you are splitting the request, that 
> > > would exhaust memory and burn cpu needlessly. You delete a 100MB file? --- 
> > > fine, allocate a 100MB of zeroed pages.
> > 
> > This is a straw man:  You've tried to portray a position I've never
> > taken as mine then attack it ... with what is effectively another bogus
> > argument.
> >
> > It's not an either/or choice.
> 
> It is either/or choice. If the interface isn't fixed NOW, the existing 
> flawed zeroed-page-allocation interface gets into RHEL

That's a false dichotomy.  You might see an either apply this hack now
or support the interface choice with RHEL, but upstream has the option
to fix stuff correctly.  RHEL has never needed my blessing to apply
random crap to their kernel before ... why is this patch any different?

> and I and others will have to support it for 7 years.

It's called a business model ... I believe it's what they pay you for.

> > I've asked the relevant parties to
> > combine the approaches and see if a REQ_TYPE_FS path that does the
> > allocations in the appropriate place, likely the ULD, produces a good
> > design.
> 
> OK, but before you do this research, fix the interface.

So even in the RHEL world, I think you'd find that analysing the problem
*before* comping up with a fix is a good way of doing things.

> > > So I say --- let there be a layering violation in the scsi code, but don't 
> > > put this problem with a page allocation to all the other bio midlayer 
> > > developers.
> > 
> > Thanks for explaining that you have nothing to contribute, I'll make
> > sure you're not on my list of relevant parties.
> 
> You misunderstand what I meant. You admit that there are design problems 
> in SCSI.

No I didn't.

And the rest of this rubbish is based on that false premise.  It might
help you to take off your SCSI antipathy and see this as a system
problem: it actually originates in block and spills out from there.
Thus it requires a system solution.

James

> So don't burden other developers with these problems. Don't force 
> the others to allocate dummy pages just because you want a cleaner scsi 
> code.
> 
> You intend to fix the design of SCSI and then remove the dummy pages. But 
> by the time you finish it, it will be already late and there will be 
> midlayer drivers allocating these dummy pages.
> 
> What I mean is that "layering violation" inside one driver is smaller 
> problem than misdesigned interface between drivers. So accept the patch 
> that creates "layering violation" but cleans up the interface.
> 
> Mikulas


