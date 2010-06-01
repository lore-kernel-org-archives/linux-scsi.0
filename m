From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Wrong DIF guard tag on ext2 write
Date: Tue, 1 Jun 2010 12:47:50 -0400
Message-ID: <20100601164750.GQ8980@think>
References: <20100531112817.GA16260@schmichrtp.mainz.de.ibm.com>
 <yq1iq64kv9f.fsf@sermon.lab.mkp.net>
 <1275318102.2823.47.camel@mulgrave.site>
 <4C03D5FD.3000202@panasas.com>
 <20100601103041.GA15922@schmichrtp.mainz.de.ibm.com>
 <1275398876.21962.6.camel@mulgrave.site>
 <20100601133341.GK8980@think>
 <1275399637.21962.11.camel@mulgrave.site>
 <20100601134951.GM8980@think>
 <20100601162929.GC32708@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20100601162929.GC32708@parisc-linux.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: James Bottomley <James.Bottomley@suse.de>, Christof Schmitt <christof.schmitt@de.ibm.com>, Boaz Harrosh <bharrosh@panasas.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, Jun 01, 2010 at 10:29:30AM -0600, Matthew Wilcox wrote:
> On Tue, Jun 01, 2010 at 09:49:51AM -0400, Chris Mason wrote:
> > > I agree that a block based retry would close all the holes ... it just
> > > doesn't look elegant to me that the fs will already be repeating the I/O
> > > if it changed the page and so will block.
> > 
> > We might not ever repeat the IO.  We might change the page, write it,
> > change it again, truncate the file and toss the page completely.
> 
> Why does it matter that it was never written in that case?

It matters is the storage layer is going to wait around for the block to
be written again with a correct crc.

Unless there is trim + DIF, but that's a lot of plates to spin just for
a basic implementation.

-chris

