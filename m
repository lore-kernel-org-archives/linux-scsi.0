From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCHSET] libata: implement ->set_capacity()
Date: Thu, 13 May 2010 12:18:51 -0500
Message-ID: <1273771131.4353.300.camel@mulgrave.site>
References: <1273766206-17402-1-git-send-email-tj@kernel.org>
	 <1273766778.4353.200.camel@mulgrave.site>  <4BEC272E.10508@kernel.org>
	 <1273768687.4353.235.camel@mulgrave.site>  <4BEC2ED7.9080001@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4BEC2ED7.9080001@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: jeff@garzik.org, linux-ide@vger.kernel.org, jens.axboe@oracle.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, ben@decadent.org.uk
List-Id: linux-scsi@vger.kernel.org

On Thu, 2010-05-13 at 18:54 +0200, Tejun Heo wrote:
> Hello,
> 
> On 05/13/2010 06:38 PM, James Bottomley wrote:
> > Instead of making this a block sysfs attribute, since HPA is SATA only,
> > why not make it a libata attribute for the disk?
> > 
> > That way on unlock, you can unlock the HPA and then trigger a partition
> > rescan of the block device (BLKRRPART) ... this is an ioctl, so you need
> > user context, but you have it if you do it from the sysfs write routine.
> > This looks to be a lot simpler than threading it up through SCSI and
> > block.
> 
> This doesn't have anything to do with sysfs.  It's called from block
> partition scan code when it detects a partition extends beyond the end
> of the device.  No user intervention at all and the mechanism has been
> there for quite some years and possibly predates sysfs.  Am I being
> really slow or are you looking at something else?

OK, so maybe I'm misunderstanding what you're trying to do.  I thought
this set_capacity thing was trying to unlock the HPA and then cause
block to see a new capacity ... the latter is what calling BLKRRPART
from the sysfs write would do.

If it's just to unlock the HPA, then forget the RRPART piece.

So I think the bit I missed was you're trying to do this programatically
from boot time partition read to detect if the user previously disabled
the HPA and partitioned the device?  In which case you still have user
context, you can call BLKRRPART here too.

James
