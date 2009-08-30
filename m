From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH 0/7] discard support revisited
Date: Sun, 30 Aug 2009 15:17:19 -0500
Message-ID: <1251663439.10135.159.camel@mulgrave.site>
References: <20090829230332.017137693@bombadil.infradead.org>
	 <20090829233718.GD22870@parisc-linux.org>
	 <20090830021534.GA14706@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20090830021534.GA14706@infradead.org>
Sender: linux-ide-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Matthew Wilcox <matthew@wil.cx>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, liml@rtr.ca, jens.axboe@oracle.com, dwmw2@infradead.org
List-Id: linux-scsi@vger.kernel.org

On Sat, 2009-08-29 at 22:15 -0400, Christoph Hellwig wrote:
> On Sat, Aug 29, 2009 at 05:37:19PM -0600, Matthew Wilcox wrote:
> > >  - I have implemented support for sending WRITE SAME requests with the
> > >    unmap bit set in sd.  This has been tested with a qemu-based backed
> > >    only so far, but we'll get some real array coverage soon.
> > 
> > I think we're going to need to figure out whether we should be sending
> > UNMAP or WRITE SAME ... probably need to dive back into the T10 poostorm
> > to see what's going on.

Actually, I've been keeping an eye on that

> Good question.  Latest I had heard was that at least one array vendor
> prefers the WRITE SAME.  To me it looks like the much saner interface
> for the OS, so unless there are arrays that strongly prefer UNMAP or
> we need to make use of the multiple extends feature in it I'd go with
> WRITE SAME as first choice.

So, since their respective names are on the proposals, it's no real
secret that EMC are pushing WRITE_SAME and Netapp UNMAP, but they are
both working together on this.  I've already communicated to T10 via
intermediaries that we'd like only a single implementation for this,
please.  However, failing that, the current situation where we know from
an inquiry that the array supports thin provisioning, but don't know
whether it supports WRITE_SAME or UNMAP until we get a command failure
is unacceptable.

If we could get some good solid implementation evidence that WRITE_SAME
is much easier for an OS than UNMAP, that might help with the T10
deliberations.

> > > I would really love to see some progress on this in the 2.6.32 circle.
> > > We should at least get the block layer bits in that allow implementing
> > > a somewhat useful discard function.  I would also love to see the
> > > actual scsi and libata implementations in so that we can start playing
> > > around with it.  But given the speed up the current TRIM implementations
> > > and the expectations for WRITE SAME we should make sure the exact
> > > TRIM tracking is not actually enabled anywhere by default for now.
> > 
> > Jens had some objections to the block layer bits last time I posted
> > these.  I forget what they were now (this would have been around May
> > 2nd, I think).  What I've done instead in my current patchset (which
> > undoubtedly has bugs because it isn't tested, because I'm not supposed
> > to be working on the weekends) is to make sd_prep_fn() call a new method
> > in the scsi_host_template.  That should translate the discard request
> > into a BLOCK_PC ATA_16 command, and we'll all be happy.
> > 
> > It goes a little something like this:
> > http://git.kernel.org/?p=linux/kernel/git/willy/ssd.git;a=shortlog;h=trim-20090829
> > 
> > Right now, the test tool is telling me 'Operation not supported', and
> > I haven't tried to figure out why yet.
> 
> Queue flag and handling the discard in the prep function is much better
> than the prepare function, yes.  I don't like the prep_fn callout to the
> host a lot.

Me neither.  I'm sort of OK with a transformed operation, callout for
the ULD, but I really don't see why a disk only function should go
through the host template.

>  If we go with WRITE SAME as prefered discard option for
> scsi translating it to TRIM should be relatively easy, it uses the same
> LBA/length encoding as the regular WRITE_16, except that the payload is
> just a single sector.  That should be not too hard to implement in the
> SAT layer.

So the last ATA data set management with TRIM proposal I saw had a set
of discontiguous ranges, very like UNMAP.  It's certainly possible to do
the transformation, you just have to drop the sector buffer and add one
for the ranges (then reverse it in the back translation for the
completion) but it's not pretty.

James


