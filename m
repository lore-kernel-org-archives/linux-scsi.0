From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [dm-devel] [PATCH 1/2] block: fix leaks associated with discard
 request payload
Date: Tue, 29 Jun 2010 20:11:49 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.1006291925480.11847@hs20-bc2-1.build.redhat.com>
References: <20100622180029.GA15950@redhat.com>
 <1277582211-10725-1-git-send-email-snitzer@redhat.com>
 <1277652576.4366.19.camel@mulgrave.site>  <Pine.LNX.4.64.1006291811300.27462@hs20-bc2-1.build.redhat.com>
 <1277852600.4379.211.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1277852600.4379.211.camel@mulgrave.site>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: device-mapper development <dm-devel@redhat.com>, Mike Snitzer <snitzer@redhat.com>, axboe@kernel.dk, linux-scsi@vger.kernel.org, martin.petersen@oracle.com, linux-kernel@vger.kernel.org, akpm@linux-foundation.org, Christoph Hellwig <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

> > If the layering violation spans only scsi code, it can be eventually 
> > fixed, but this, much worse "layering violation" that will be spanning all 
> > block device midlayers, won't ever be fixed.
> > 
> > Imagine for example --- a discard request arrivers at a dm-snapshot 
> > device. The driver splits it into chunks, remaps each chunk to the 
> > physical chunk, submits the requests, the elevator merges adjacent 
> > requests and submits fewer bigger requests to the device. Now, if you had 
> > to allocate a zeroed page each time you are splitting the request, that 
> > would exhaust memory and burn cpu needlessly. You delete a 100MB file? --- 
> > fine, allocate a 100MB of zeroed pages.
> 
> This is a straw man:  You've tried to portray a position I've never
> taken as mine then attack it ... with what is effectively another bogus
> argument.
>
> It's not an either/or choice.

It is either/or choice. If the interface isn't fixed NOW, the existing 
flawed zeroed-page-allocation interface gets into RHEL and I and others 
will have to support it for 7 years.

> I've asked the relevant parties to
> combine the approaches and see if a REQ_TYPE_FS path that does the
> allocations in the appropriate place, likely the ULD, produces a good
> design.

OK, but before you do this research, fix the interface.

> > So I say --- let there be a layering violation in the scsi code, but don't 
> > put this problem with a page allocation to all the other bio midlayer 
> > developers.
> 
> Thanks for explaining that you have nothing to contribute, I'll make
> sure you're not on my list of relevant parties.

You misunderstand what I meant. You admit that there are design problems 
in SCSI. So don't burden other developers with these problems. Don't force 
the others to allocate dummy pages just because you want a cleaner scsi 
code.

You intend to fix the design of SCSI and then remove the dummy pages. But 
by the time you finish it, it will be already late and there will be 
midlayer drivers allocating these dummy pages.

What I mean is that "layering violation" inside one driver is smaller 
problem than misdesigned interface between drivers. So accept the patch 
that creates "layering violation" but cleans up the interface.

Mikulas
