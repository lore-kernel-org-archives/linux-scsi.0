From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Wrong DIF guard tag on ext2 write
Date: Tue, 1 Jun 2010 09:33:41 -0400
Message-ID: <20100601133341.GK8980@think>
References: <20100531112817.GA16260@schmichrtp.mainz.de.ibm.com>
 <yq1iq64kv9f.fsf@sermon.lab.mkp.net>
 <1275318102.2823.47.camel@mulgrave.site>
 <4C03D5FD.3000202@panasas.com>
 <20100601103041.GA15922@schmichrtp.mainz.de.ibm.com>
 <1275398876.21962.6.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1275398876.21962.6.camel@mulgrave.site>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: Christof Schmitt <christof.schmitt@de.ibm.com>, Boaz Harrosh <bharrosh@panasas.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, Jun 01, 2010 at 01:27:56PM +0000, James Bottomley wrote:
> On Tue, 2010-06-01 at 12:30 +0200, Christof Schmitt wrote:
> > What is the best strategy to continue with the invalid guard tags on
> > write requests? Should this be fixed in the filesystems?
> 
> For write requests, as long as the page dirty bit is still set, it's
> safe to drop the request, since it's already going to be repeated.  What
> we probably want is an error code we can return that the layer that sees
> both the request and the page flags can make the call.

I'm afraid this isn't entirely true.  The FS tends to do this:

change the page
<---------> truck sized race right here where the page is clean
mark the page dirty

-chris
