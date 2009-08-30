From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH 0/7] discard support revisited
Date: Sun, 30 Aug 2009 15:42:29 -0600
Message-ID: <20090830214229.GG22870@parisc-linux.org>
References: <20090829230332.017137693@bombadil.infradead.org> <20090829233718.GD22870@parisc-linux.org> <20090830021534.GA14706@infradead.org> <1251663439.10135.159.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:49280 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753897AbZH3Vm2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 30 Aug 2009 17:42:28 -0400
Content-Disposition: inline
In-Reply-To: <1251663439.10135.159.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, liml@rtr.ca, jens.axboe@oracle.com, dwmw2@infradead.org

On Sun, Aug 30, 2009 at 03:17:19PM -0500, James Bottomley wrote:
> > > Jens had some objections to the block layer bits last time I posted
> > > these.  I forget what they were now (this would have been around May
> > > 2nd, I think).  What I've done instead in my current patchset (which
> > > undoubtedly has bugs because it isn't tested, because I'm not supposed
> > > to be working on the weekends) is to make sd_prep_fn() call a new method
> > > in the scsi_host_template.  That should translate the discard request
> > > into a BLOCK_PC ATA_16 command, and we'll all be happy.
> > > 
> > > It goes a little something like this:
> > > http://git.kernel.org/?p=linux/kernel/git/willy/ssd.git;a=shortlog;h=trim-20090829
> > 
> > Queue flag and handling the discard in the prep function is much better
> > than the prepare function, yes.  I don't like the prep_fn callout to the
> > host a lot.
> 
> Me neither.  I'm sort of OK with a transformed operation, callout for
> the ULD, but I really don't see why a disk only function should go
> through the host template.

I'm fine with putting the function pointer elsewhere ... the host template
seemed like a good place because the two things I see it being useful
for (USB and ATA) are a per-host thing rather than a per-device thing.
Would you like to see it in the scsi_disk instead?  Maybe the scsi_device?

> So the last ATA data set management with TRIM proposal I saw had a set
> of discontiguous ranges, very like UNMAP.  It's certainly possible to do
> the transformation, you just have to drop the sector buffer and add one
> for the ranges (then reverse it in the back translation for the
> completion) but it's not pretty.

Not pretty, and also has some practical problems, in that I cannot figure
out where Linux stores the length.  Even after I put on a new page,
it would only send the first 24 bytes (length of the UNMAP payload)
rather than the 512 bytes of the TRIM payload.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
