From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [DO NOT APPLY] sd take advantage of rotation speed
Date: Wed, 25 Jun 2008 19:59:03 +0200
Message-ID: <20080625175903.GF20851@kernel.dk>
References: <20080619160342.GJ4392@parisc-linux.org> <20080625134705.GZ20851@kernel.dk> <4862552A.5010900@gmail.com> <48627184.9010609@panasas.com> <20080625165759.GC20851@kernel.dk> <20080625172015.GR4392@parisc-linux.org> <20080625172638.GE20851@kernel.dk> <20080625173444.GS4392@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([87.55.233.238]:26596 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752187AbYFYR7G (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 25 Jun 2008 13:59:06 -0400
Content-Disposition: inline
In-Reply-To: <20080625173444.GS4392@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Boaz Harrosh <bharrosh@panasas.com>, Ric Wheeler <ricwheeler@gmail.com>, linux-scsi@vger.kernel.org

On Wed, Jun 25 2008, Matthew Wilcox wrote:
> On Wed, Jun 25, 2008 at 07:26:39PM +0200, Jens Axboe wrote:
> > Uhm, but it IS "a blatant layering violation", it's doing things from
> > the wrong side up :-)
> 
> That's just "doing things from a spot Jens doesn't approve of".  A
> layering violation would be SCSI knowing how elevators work.

And that's what the patch is doing, it knows that CFQ/AS idles and thus
chooses noop. So it's even doing it wrong, since that disables other
goodness as well. The whole sd_set_elevator() is a mess, I honestly
can't see how you can even start to defend it.

I don't really appreciate the personal bit either.

> > I don't think udev is a particularly good idea either. My plan was to
> > introduce device profiles for the queue, but it is probably a bad idea
> > to over-engineer this. So I'll keep it simple, stick to a 'zero cost
> > seek' flag instead and allow drivers to signal that. libata/ide needs to
> > check the ID page word to detect SSD drives as well, so they need a few
> > lines of change too.
> 
> One of the other patches in this mess was the libata piece to translate
> ATA8's rotation speed to SCSI's b1 VPD page, so ide is the only
> remaining work left to do (can't it die already?)

IDE is definitely low priority :-). I had a pata ssd drive, but IDE is
only really interesting for the bits that can't be libata driven. So not
very interesting.

ATA8 seems to have changed the SSD detection scheme. I don't have an SSD
disk so I cannot check what the current models report.

-- 
Jens Axboe

