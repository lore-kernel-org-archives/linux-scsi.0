From: Nick Piggin <npiggin@suse.de>
Subject: Re: Wrong DIF guard tag on ext2 write
Date: Wed, 2 Jun 2010 04:46:49 +1000
Message-ID: <20100601184649.GE9453__27414.0097586953$1275418045$gmane$org@laptop>
References: <4C03D5FD.3000202@panasas.com>
 <20100601103041.GA15922@schmichrtp.mainz.de.ibm.com>
 <1275398876.21962.6.camel@mulgrave.site>
 <20100601133341.GK8980@think>
 <1275399637.21962.11.camel@mulgrave.site>
 <20100601134951.GM8980@think>
 <20100601162929.GC32708@parisc-linux.org>
 <20100601164750.GQ8980@think>
 <1275411293.21962.387.camel@mulgrave.site>
 <20100601180905.GR8980@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:60605 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751282Ab0FASrI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 1 Jun 2010 14:47:08 -0400
Content-Disposition: inline
In-Reply-To: <20100601180905.GR8980@think>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>, James Bottomley <James.Bottomley@suse.de>, Matthew Wilcox <matthew@wil.cx>, Christof Schmitt <christof.schmitt@de.ibm.com>, Boaz Harrosh <bharro>

On Tue, Jun 01, 2010 at 02:09:05PM -0400, Chris Mason wrote:
> On Tue, Jun 01, 2010 at 04:54:53PM +0000, James Bottomley wrote:
> > On Tue, 2010-06-01 at 12:47 -0400, Chris Mason wrote:
> > > On Tue, Jun 01, 2010 at 10:29:30AM -0600, Matthew Wilcox wrote:
> > > > On Tue, Jun 01, 2010 at 09:49:51AM -0400, Chris Mason wrote:
> > > > > > I agree that a block based retry would close all the holes ... it just
> > > > > > doesn't look elegant to me that the fs will already be repeating the I/O
> > > > > > if it changed the page and so will block.
> > > > > 
> > > > > We might not ever repeat the IO.  We might change the page, write it,
> > > > > change it again, truncate the file and toss the page completely.
> > > > 
> > > > Why does it matter that it was never written in that case?
> > > 
> > > It matters is the storage layer is going to wait around for the block to
> > > be written again with a correct crc.
> > 
> > Actually, I wasn't advocating that.  I think block should return a guard
> > mismatch error.  I think somewhere in filesystem writeout is the place
> > to decide whether the error was self induced or systematic.
> 
> In that case the io error goes to the async page writeback bio-endio
> handlers.  We don't have a reference on the inode and no ability to
> reliably restart the IO, but we can set a bit on the address space
> indicating that somewhere, sometime in the past we had an IO error.
> 
> > For self
> > induced errors (as long as we can detect them) I think we can just
> > forget about it ... if the changed page is important, the I/O request
> > gets repeated (modulo the problem of too great a frequency of changes
> > leading to us never successfully writing it) or it gets dropped because
> > the file was truncated or the data deleted for some other reason.
> 
> Sorry, how can we tell the errors that are self induced from the evil
> bit flipping cable induced errors?

Block layer should retry it with bounce pages. That would be a lot nicer
than forcing all upper layers to avoid the problem.

