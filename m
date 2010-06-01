From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: Wrong DIF guard tag on ext2 write
Date: Tue, 01 Jun 2010 08:40:37 -0500
Message-ID: <1275399637.21962.11.camel@mulgrave.site>
References: <20100531112817.GA16260@schmichrtp.mainz.de.ibm.com>
	 <yq1iq64kv9f.fsf@sermon.lab.mkp.net>
	 <1275318102.2823.47.camel@mulgrave.site> <4C03D5FD.3000202@panasas.com>
	 <20100601103041.GA15922@schmichrtp.mainz.de.ibm.com>
	 <1275398876.21962.6.camel@mulgrave.site>  <20100601133341.GK8980@think>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20100601133341.GK8980@think>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Cc: Christof Schmitt <christof.schmitt@de.ibm.com>, Boaz Harrosh <bharrosh@panasas.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, 2010-06-01 at 09:33 -0400, Chris Mason wrote:
> On Tue, Jun 01, 2010 at 01:27:56PM +0000, James Bottomley wrote:
> > On Tue, 2010-06-01 at 12:30 +0200, Christof Schmitt wrote:
> > > What is the best strategy to continue with the invalid guard tags on
> > > write requests? Should this be fixed in the filesystems?
> > 
> > For write requests, as long as the page dirty bit is still set, it's
> > safe to drop the request, since it's already going to be repeated.  What
> > we probably want is an error code we can return that the layer that sees
> > both the request and the page flags can make the call.
> 
> I'm afraid this isn't entirely true.  The FS tends to do this:
> 
> change the page
> <---------> truck sized race right here where the page is clean
> mark the page dirty

Would it be too much work in the fs to mark the page dirty before you
begin altering it (and again after you finish, just in case some cleaner
noticed and initiated a write)?  Or some other flag that indicates page
under modification?  All the process controlling the writeout (which is
pretty high up in the stack) needs to know is if we triggered the check
error by altering the page while it was in flight.

I agree that a block based retry would close all the holes ... it just
doesn't look elegant to me that the fs will already be repeating the I/O
if it changed the page and so will block.

James


James


