From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: Wrong DIF guard tag on ext2 write
Date: Tue, 01 Jun 2010 16:54:53 +0000
Message-ID: <1275411293.21962.387.camel@mulgrave.site>
References: <20100531112817.GA16260@schmichrtp.mainz.de.ibm.com>
	 <yq1iq64kv9f.fsf@sermon.lab.mkp.net>
	 <1275318102.2823.47.camel@mulgrave.site> <4C03D5FD.3000202@panasas.com>
	 <20100601103041.GA15922@schmichrtp.mainz.de.ibm.com>
	 <1275398876.21962.6.camel@mulgrave.site> <20100601133341.GK8980@think>
	 <1275399637.21962.11.camel@mulgrave.site> <20100601134951.GM8980@think>
	 <20100601162929.GC32708@parisc-linux.org>  <20100601164750.GQ8980@think>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:57452 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753078Ab0FAQzQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 1 Jun 2010 12:55:16 -0400
In-Reply-To: <20100601164750.GQ8980@think>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Cc: Matthew Wilcox <matthew@wil.cx>, Christof Schmitt <christof.schmitt@de.ibm.com>, Boaz Harrosh <bharrosh@panasas.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org

On Tue, 2010-06-01 at 12:47 -0400, Chris Mason wrote:
> On Tue, Jun 01, 2010 at 10:29:30AM -0600, Matthew Wilcox wrote:
> > On Tue, Jun 01, 2010 at 09:49:51AM -0400, Chris Mason wrote:
> > > > I agree that a block based retry would close all the holes ... it just
> > > > doesn't look elegant to me that the fs will already be repeating the I/O
> > > > if it changed the page and so will block.
> > > 
> > > We might not ever repeat the IO.  We might change the page, write it,
> > > change it again, truncate the file and toss the page completely.
> > 
> > Why does it matter that it was never written in that case?
> 
> It matters is the storage layer is going to wait around for the block to
> be written again with a correct crc.

Actually, I wasn't advocating that.  I think block should return a guard
mismatch error.  I think somewhere in filesystem writeout is the place
to decide whether the error was self induced or systematic.  For self
induced errors (as long as we can detect them) I think we can just
forget about it ... if the changed page is important, the I/O request
gets repeated (modulo the problem of too great a frequency of changes
leading to us never successfully writing it) or it gets dropped because
the file was truncated or the data deleted for some other reason.

James


