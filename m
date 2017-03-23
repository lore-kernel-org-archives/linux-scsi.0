From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: support ranges TRIM for libata
Date: Thu, 23 Mar 2017 10:35:06 -0400
Message-ID: <1490279706.2202.17.camel@HansenPartnership.com>
References: <20170320204319.12628-1-hch@lst.de>
         <20170321185901.GB3706@htj.duckdns.org> <20170322181947.GA4733@lst.de>
         <1490276861.2202.8.camel@HansenPartnership.com>
         <20170323135521.GA30361@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20170323135521.GA30361@lst.de>
Sender: linux-ide-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Tejun Heo <tj@kernel.org>, martin.petersen@oracle.com, axboe@kernel.dk, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-block@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, 2017-03-23 at 14:55 +0100, Christoph Hellwig wrote:
> On Thu, Mar 23, 2017 at 09:47:41AM -0400, James Bottomley wrote:
> > > The current implementation already has the issue of that it does
> > > corrupt user data reliably if the using SG_IO for WRITE SAME
> > > commands.
> > 
> > That does need fixing.
> 
> I don't think it's fixable as long as we translate the data payload.
> 
> > Why can't we do what the t10 sat document recommends: if the ATA 
> > device doesn't support the XL version (32 bit ranges) then 
> > translate unmap to multiple non-XL commands?
> 
> Because libata sits underneath the tag allocator we'd getting into
> a giant set of problems.  Where do you expect the new commands to
> magically come from?  And adhere to the queueing limits and not 
> actually deadlock in one way or another?

I'm certainly not saying we blindly follow t10, but I believe their
intent is to issue the next command from the completion of the first
(we can do this using qc->complete_fn, like atapi_request_sense).  That
way we don't get any tag problems because there's only one command
outstanding at once; reusing the qc means no allocation issues either.

The t10 approach does mean the SG_IO problem is actually fixable rather
than simply erroring out.

> > I don't necessarily object to the vendor specific 1<->1 approach, 
> > it's just it won't fix the problem you cited above (SG_IO WRITE 
> > SAME), its just that now we error the command, which may cause some
> > surprise.
> 
> We now error WRITE SAME for passthrough consistently.  Before we only
> accepted it only with the unmap bit set, and even did so incorrectly
> (not checking that the payload was all zeros).

If it never worked for anyone, I'm OK with changing it to error out.

> > I also wonder if we couldn't simply do an ATA_16 TRIM if we're
> > already going to all the trouble of recognising ATA devices in the 
> > sd discard path?
> 
> We probably could do that as well.  But that would drag a lot more
> ATA-specific code into sd.c than just formatting the ranges.

That's up to you ... from the point of view of code documenting itself,
forming the ATA_16 TRIM in sd and not doing any satl transformation is
easier for others to follow, but if it's going to cause more code, I'm
only marginal on the advantages of easier to follow code.

James

