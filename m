From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Wrong DIF guard tag on ext2 write
Date: Tue, 1 Jun 2010 15:35:28 -0400
Message-ID: <20100601193528.GV8980@think>
References: <20100601103041.GA15922@schmichrtp.mainz.de.ibm.com>
 <1275398876.21962.6.camel@mulgrave.site>
 <20100601133341.GK8980@think>
 <1275399637.21962.11.camel@mulgrave.site>
 <20100601134951.GM8980@think>
 <20100601162929.GC32708@parisc-linux.org>
 <20100601164750.GQ8980@think>
 <1275411293.21962.387.camel@mulgrave.site>
 <20100601180905.GR8980@think>
 <20100601184649.GE9453@laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet10.oracle.com ([148.87.113.121]:44194 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750748Ab0FATgM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Jun 2010 15:36:12 -0400
Content-Disposition: inline
In-Reply-To: <20100601184649.GE9453@laptop>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Nick Piggin <npiggin@suse.de>
Cc: James Bottomley <James.Bottomley@suse.de>, Matthew Wilcox <matthew@wil.cx>, Christof Schmitt <christof.schmitt@de.ibm.com>, Boaz Harrosh <bharrosh@panasas.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org

On Wed, Jun 02, 2010 at 04:46:49AM +1000, Nick Piggin wrote:
> On Tue, Jun 01, 2010 at 02:09:05PM -0400, Chris Mason wrote:
> > On Tue, Jun 01, 2010 at 04:54:53PM +0000, James Bottomley wrote:
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
> Block layer should retry it with bounce pages. That would be a lot nicer
> than forcing all upper layers to avoid the problem.
> 

So the idea is that we have sent down a buffer and it changed in flight.
The block layer is going to say: oh look, the crcs don't match, I'll
bounce it, recrc it and send again.  But, there are at least 3 reasons the crc
will change:

1) filesystem changed it
2) corruption on the wire or in the raid controller
3) the page was corrupted while the IO layer was doing the IO.

1 and 2 are easy, we bounce, retry and everyone continues on with
their lives.  With #3, we'll recrc and send the IO down again thinking
the data is correct when really we're writing garbage.

How can we tell these three cases apart?

-chris

