From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 1/2] block: fix leaks associated with discard request
 payload
Date: Wed, 30 Jun 2010 11:36:03 -0400
Message-ID: <20100630153602.GA6036@redhat.com>
References: <20100622180029.GA15950@redhat.com>
 <1277582211-10725-1-git-send-email-snitzer@redhat.com>
 <1277652576.4366.19.camel@mulgrave.site>
 <Pine.LNX.4.64.1006291811300.27462@hs20-bc2-1.build.redhat.com>
 <1277852600.4379.211.camel@mulgrave.site>
 <Pine.LNX.4.64.1006291925480.11847@hs20-bc2-1.build.redhat.com>
 <1277907738.2839.9.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56911 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751695Ab0F3PgW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Jun 2010 11:36:22 -0400
Content-Disposition: inline
In-Reply-To: <1277907738.2839.9.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: Mikulas Patocka <mpatocka@redhat.com>, device-mapper development <dm-devel@redhat.com>, axboe@kernel.dk, linux-scsi@vger.kernel.org, martin.petersen@oracle.com, linux-kernel@vger.kernel.org, akpm@linux-foundation.org, Christoph Hellwig <hch@lst.de>

On Wed, Jun 30 2010 at 10:22am -0400,
James Bottomley <James.Bottomley@suse.de> wrote:

> On Tue, 2010-06-29 at 20:11 -0400, Mikulas Patocka wrote:
> > > > If the layering violation spans only scsi code, it can be eventually 
> > > > fixed, but this, much worse "layering violation" that will be spanning all 
> > > > block device midlayers, won't ever be fixed.
> > > > 
> > > > Imagine for example --- a discard request arrivers at a dm-snapshot 
> > > > device. The driver splits it into chunks, remaps each chunk to the 
> > > > physical chunk, submits the requests, the elevator merges adjacent 
> > > > requests and submits fewer bigger requests to the device. Now, if you had 
> > > > to allocate a zeroed page each time you are splitting the request, that 
> > > > would exhaust memory and burn cpu needlessly. You delete a 100MB file? --- 
> > > > fine, allocate a 100MB of zeroed pages.
> > > 
> > > This is a straw man:  You've tried to portray a position I've never
> > > taken as mine then attack it ... with what is effectively another bogus
> > > argument.
> > >
> > > It's not an either/or choice.
> > 
> > It is either/or choice. If the interface isn't fixed NOW, the existing 
> > flawed zeroed-page-allocation interface gets into RHEL
> 
> That's a false dichotomy.  You might see an either apply this hack now
> or support the interface choice with RHEL, but upstream has the option
> to fix stuff correctly.  RHEL has never needed my blessing to apply
> random crap to their kernel before ... why is this patch any different?
> 
> > and I and others will have to support it for 7 years.
> 
> It's called a business model ... I believe it's what they pay you for.
> 
> > > I've asked the relevant parties to
> > > combine the approaches and see if a REQ_TYPE_FS path that does the
> > > allocations in the appropriate place, likely the ULD, produces a good
> > > design.
> > 
> > OK, but before you do this research, fix the interface.
> 
> So even in the RHEL world, I think you'd find that analysing the problem
> *before* comping up with a fix is a good way of doing things.
> 
> > > > So I say --- let there be a layering violation in the scsi code, but don't 
> > > > put this problem with a page allocation to all the other bio midlayer 
> > > > developers.
> > > 
> > > Thanks for explaining that you have nothing to contribute, I'll make
> > > sure you're not on my list of relevant parties.
> > 
> > You misunderstand what I meant. You admit that there are design problems 
> > in SCSI.
> 
> No I didn't.
> 
> And the rest of this rubbish is based on that false premise.  It might
> help you to take off your SCSI antipathy and see this as a system
> problem: it actually originates in block and spills out from there.
> Thus it requires a system solution.

As fun as it is for the others monitoring these lists to see redhat.com
vs suse.de banter I think framing this discussion like you (and Mikulas)
continue to do is a complete distraction.

I tried to elevate (and defuse) the discussion yesterday.  But simply
put: patches speak volumes.  I look forward to working with Tomo, hch
and anyone else who has something to contribute that moves us toward a
real fix for discards.

Mike
