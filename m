From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH 0/7] discard support revisited
Date: Sat, 29 Aug 2009 17:37:19 -0600
Message-ID: <20090829233718.GD22870@parisc-linux.org>
References: <20090829230332.017137693@bombadil.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20090829230332.017137693@bombadil.infradead.org>
Sender: linux-ide-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, liml@rtr.ca, jens.axboe@oracle.com, dwmw2@infradead.org
List-Id: linux-scsi@vger.kernel.org

On Sat, Aug 29, 2009 at 07:03:32PM -0400, Christoph Hellwig wrote:
> I've started working on discard support a little bit more, and I think
> it's time to get an overview over the state we're in right now.  This
> patchswt is what I needed to get the batched discard support in XFS
> properly working.  Many patches are just forward ported from Matthew's
> SSD tree and I hope quilt mail didn't lose the attributions.

Funny, I was working on forward-porting my patches this morning.

>  - blkdev_issue_discard is now a lot more generic - it grows a flags
>    argument to control if we issue a barrier discard request or not
>    or if we wait or not.  That is needed for the batched discard support
>    in XFS which wants to wait just like the ioctl interface.

Seems fine.

>  - I have implemented support for sending WRITE SAME requests with the
>    unmap bit set in sd.  This has been tested with a qemu-based backed
>    only so far, but we'll get some real array coverage soon.

I think we're going to need to figure out whether we should be sending
UNMAP or WRITE SAME ... probably need to dive back into the T10 poostorm
to see what's going on.

>  - there is a new patch to allow larger discard requests.
>  - the last patch is just my old batched discard patch for xfs ported
>    to work ontop of this series.
> 
> I would really love to see some progress on this in the 2.6.32 circle.
> We should at least get the block layer bits in that allow implementing
> a somewhat useful discard function.  I would also love to see the
> actual scsi and libata implementations in so that we can start playing
> around with it.  But given the speed up the current TRIM implementations
> and the expectations for WRITE SAME we should make sure the exact
> TRIM tracking is not actually enabled anywhere by default for now.

Jens had some objections to the block layer bits last time I posted
these.  I forget what they were now (this would have been around May
2nd, I think).  What I've done instead in my current patchset (which
undoubtedly has bugs because it isn't tested, because I'm not supposed
to be working on the weekends) is to make sd_prep_fn() call a new method
in the scsi_host_template.  That should translate the discard request
into a BLOCK_PC ATA_16 command, and we'll all be happy.

It goes a little something like this:
http://git.kernel.org/?p=linux/kernel/git/willy/ssd.git;a=shortlog;h=trim-20090829

Right now, the test tool is telling me 'Operation not supported', and
I haven't tried to figure out why yet.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
