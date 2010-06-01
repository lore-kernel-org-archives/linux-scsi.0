From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Wrong DIF guard tag on ext2 write
Date: Tue, 1 Jun 2010 18:49:16 -0400
Message-ID: <20100601224916.GY8980@think>
References: <20100601103041.GA15922@schmichrtp.mainz.de.ibm.com>
 <1275398876.21962.6.camel@mulgrave.site>
 <20100601133341.GK8980@think>
 <1275399637.21962.11.camel@mulgrave.site>
 <20100601134951.GM8980@think>
 <20100601162929.GC32708@parisc-linux.org>
 <20100601164750.GQ8980@think>
 <1275411293.21962.387.camel@mulgrave.site>
 <20100601180905.GR8980@think>
 <1275426463.21962.977.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1275426463.21962.977.camel@mulgrave.site>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: Matthew Wilcox <matthew@wil.cx>, Christof Schmitt <christof.schmitt@de.ibm.com>, Boaz Harrosh <bharrosh@panasas.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, Jun 01, 2010 at 04:07:43PM -0500, James Bottomley wrote:
> On Tue, 2010-06-01 at 14:09 -0400, Chris Mason wrote:
> > On Tue, Jun 01, 2010 at 04:54:53PM +0000, James Bottomley wrote:
> > > On Tue, 2010-06-01 at 12:47 -0400, Chris Mason wrote:
> > > > On Tue, Jun 01, 2010 at 10:29:30AM -0600, Matthew Wilcox wrote:
> > > > > On Tue, Jun 01, 2010 at 09:49:51AM -0400, Chris Mason wrote:
> > > > > > > I agree that a block based retry would close all the holes ... it just
> > > > > > > doesn't look elegant to me that the fs will already be repeating the I/O
> > > > > > > if it changed the page and so will block.
> > > > > > 
> > > > > > We might not ever repeat the IO.  We might change the page, write it,
> > > > > > change it again, truncate the file and toss the page completely.
> > > > > 
> > > > > Why does it matter that it was never written in that case?
> > > > 
> > > > It matters is the storage layer is going to wait around for the block to
> > > > be written again with a correct crc.
> > > 
> > > Actually, I wasn't advocating that.  I think block should return a guard
> > > mismatch error.  I think somewhere in filesystem writeout is the place
> > > to decide whether the error was self induced or systematic.
> > 
> > In that case the io error goes to the async page writeback bio-endio
> > handlers.  We don't have a reference on the inode and no ability to
> > reliably restart the IO, but we can set a bit on the address space
> > indicating that somewhere, sometime in the past we had an IO error.
> > 
> > > For self
> > > induced errors (as long as we can detect them) I think we can just
> > > forget about it ... if the changed page is important, the I/O request
> > > gets repeated (modulo the problem of too great a frequency of changes
> > > leading to us never successfully writing it) or it gets dropped because
> > > the file was truncated or the data deleted for some other reason.
> > 
> > Sorry, how can we tell the errors that are self induced from the evil
> > bit flipping cable induced errors?
> 
> We have all the information ... the fs will eventually mark the page
> dirty when it finishes the alterations, we just have to find a way to
> express that.

Eventually?

> 
> If you're thinking of the double fault scenario where the page
> spontaneously corrupts *and* the filesystem alters it, then the only way
> of detecting that is to freeze the page as it undergoes I/O ... which
> involves quite a bit of filesystem surgery, doesn't it?

No, I'm thinking of the case where the page corrupts and the FS doesn't
alter it.  I still don't know how to determine if the FS changed the
page and will write it again, if the FS changed the page and won't write
it again, or if the page corrupted all on its own.  The page dirty bit
isn't sufficient for this.

-chris
