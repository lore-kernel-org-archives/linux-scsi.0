From: scameron@beardog.cce.hp.com
Subject: Re: Maximum data size in a single transfer for MS driver
Date: Thu, 25 Feb 2010 10:59:01 -0600
Message-ID: <20100225165901.GZ30797@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t0015.houston.hp.com ([15.201.24.18]:11191 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759333Ab0BYQzx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 25 Feb 2010 11:55:53 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@suse.de, scameron@beardog.cce.hp.com, axboe@kernel.dk


James.Bottomley@suse.de wrote:

> On Mon, 2010-02-22 at 18:20 +0530, Ramya Desai wrote:
> > On Fri, Feb 19, 2010 at 7:56 PM, James Bottomley
> > <James.Bottomley@suse.de> wrote:
> > 
> > > Before we get into that, what architecture is this?  There are a few,
> > > like arm that don't have architecture support for chaining, so they can
> > > never go over 128 segments.
> > 
> > I am using the desktop PC to access my device. i.e, Intel processor
> > with x86 architecture.
> 
> OK, so now see what max_hw_sectors_kb says ... if it's still 512 and
> you're sure you've got sg_tablesize set to something higher, there's
> likely something in the USB stack resetting it ... I suppose it's
> possible there's something else in your kernel doing that for the
> architecture, but you could rule that out by looking at
> max_hw_sectors_kb for either a SCSI or libata device and verifying it's
> much higher than 512.
> 
> James
> 

I might be off in the weeds, but I noticed this while looking at a similar
512k limit hpsa was hitting in the last few days, and I came across this,
in block/blk-settings.c:

void blk_queue_max_hw_sectors(struct request_queue *q, unsigned int max_sectors)
{
        if (BLK_DEF_MAX_SECTORS > max_sectors)
                q->limits.max_hw_sectors = BLK_DEF_MAX_SECTORS;
        else
                q->limits.max_hw_sectors = max_sectors;
}
EXPORT_SYMBOL(blk_queue_max_hw_sectors);


And BLK_DEF_MAX_SECTORS is 1024 (means, 512k), from blkdev.h:
#define MAX_PHYS_SEGMENTS 128
#define MAX_HW_SEGMENTS 128
#define SAFE_MAX_SECTORS 255
#define BLK_DEF_MAX_SECTORS 1024

So if you try to set max_hw_sectors to allow more than 512k via
blk_queue_max_hw_sectors(), it will cap it at 512k.

YOu can set q->limits.max_hw_sectors to a bigger number yourself
without using the helper function, though I don't know if that's
cool (though it seems to work with cciss, for example.)  I haven't
tried it with hpsa, though did try changing blkdev.h BLK_DEF_MAX_SECTORS,
and rebuilding the kernel, and was able to get by the 512k limit.

-- steve

