From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [patch 1/2]percpu_ida: fix a live lock
Date: Tue, 11 Feb 2014 06:53:50 -0800
Message-ID: <20140211145350.GA16453@infradead.org>
References: <20140106204641.GB9037@kmo>
 <52CB1783.4050205@kernel.dk>
 <20140106214726.GD9037@kmo>
 <20140209155006.GA16149@dhcp-26-207.brq.redhat.com>
 <20140210103211.GA28396@infradead.org>
 <52F8FDA7.7070809@kernel.dk>
 <20140210224145.GB2362@kmo>
 <52F95B73.7030205@kernel.dk>
 <20140211091228.GA25567@infradead.org>
 <1392129760.2128.15.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1392129760.2128.15.camel@dabdike.int.hansenpartnership.com>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>, Kent Overstreet <kmo@daterainc.com>, Alexander Gordeev <agordeev@redhat.com>, Shaohua Li <shli@kernel.org>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, Feb 11, 2014 at 06:42:40AM -0800, James Bottomley wrote:
> > Unfortunately that's not true in SCSI land, where most driver do per-lun
> > tagging, and the the cmd_per_lun values are very low and very often
> > single digits, as a simple grep for cmd_per_lun will tell.
> 
> Remember we do shared (all queue) tags on qla, aic and a few other
> drivers (it's actually the mailbox slot tag for the HBA).

That's why I said most and not all.  We have a fair amount of drivers
using host-wide tags.  Having to support both models actually is a bit
of an issue with the blk-mq support in scsi.

At this point I suspect we'll have to detangle the concept of tag space
and the queueing limits that blk-mq merged into a single problem space
again to support SCSI properly.

> >   Now it might
> > be that the tag space actually is much bigger in the hardware and the
> > driver authors for some reason want to limit the number of outstanding
> > commands, but the interface to the drivers doesn't allow them to express
> > such a difference at the moment.
> 
> Tag space is dependent on SCSI protocol.  It's 256 for SPI, 65536 for
> SAS and I'm not sure for FCP.

But that doesn't mean a HBA can support the full space.  Unless we know
each piece of hardware detailed enough we can't simplify increase the
tag space as we can be sure something will break.

> The list seems to be missing prior context but a few SPI drivers use the
> clock algorithm for tag starvation in the driver.  The NCR ones are the
> ones I know about: tag allocation is the hands of a clock sweeping
> around (one for last tag and one for last outstanding tag).  The hands
> are never allowed to cross, so if a tag gets starved the hands try to
> cross and the driver stops issuing until the missing tag returns.  Tag
> starvation used to be a known problem for Parallel devices; I haven't
> seen much in the way of tag starvation algorithms for other types of
> devices, so I assume the problem went away.

As long as the drivers don't rely on the block layer tag handling they
can keep whatever they want to do.  Given that it's mostly SPI drivers
I doubt the tag allocation is a performance bottle neck of any sort for
them anyway.
