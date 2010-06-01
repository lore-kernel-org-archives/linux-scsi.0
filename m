From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: Wrong DIF guard tag on ext2 write
Date: Tue, 01 Jun 2010 13:27:56 +0000
Message-ID: <1275398876.21962.6.camel@mulgrave.site>
References: <20100531112817.GA16260@schmichrtp.mainz.de.ibm.com>
	 <yq1iq64kv9f.fsf@sermon.lab.mkp.net>
	 <1275318102.2823.47.camel@mulgrave.site> <4C03D5FD.3000202@panasas.com>
	 <20100601103041.GA15922@schmichrtp.mainz.de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20100601103041.GA15922@schmichrtp.mainz.de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Christof Schmitt <christof.schmitt@de.ibm.com>
Cc: Boaz Harrosh <bharrosh@panasas.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, Chris Mason <chris.mason@oracle.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, 2010-06-01 at 12:30 +0200, Christof Schmitt wrote:
> What is the best strategy to continue with the invalid guard tags on
> write requests? Should this be fixed in the filesystems?

For write requests, as long as the page dirty bit is still set, it's
safe to drop the request, since it's already going to be repeated.  What
we probably want is an error code we can return that the layer that sees
both the request and the page flags can make the call.

> Another idea would be to pass invalid guard tags on write requests
> down to the hardware, expect an "invalid guard tag" error and report
> it to the block layer where a new checksum is generated and the
> request is issued again. Basically implement a retry through the whole
> I/O stack. But this also sounds complicated.

No, no ... as long as the guard tag is wrong because the fs changed the
page, the write request for the updated page will already be queued or
in-flight, so there's no need to retry.  We still have to pass checksum
failures on in case the data changed because of some HW (or SW) cockup.
The check for this is page dirty.  If we get a checksum error back and
the page is still clean, we know nothing in the OS changed it, therefore
it's a real bit flip error.

James
