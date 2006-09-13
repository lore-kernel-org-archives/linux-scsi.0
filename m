From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 2/2] block: convert bsg, scsi_ioctl and cdrom to new  blk_rq_map_user fns
Date: Wed, 13 Sep 2006 11:32:43 +0200
Message-ID: <20060913093243.GH23515@kernel.dk>
References: <1157835222.4543.11.camel@max> <1157839785.5281.4.camel@max>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([62.242.22.158]:12640 "EHLO kernel.dk")
	by vger.kernel.org with ESMTP id S1750728AbWIMJef (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 13 Sep 2006 05:34:35 -0400
Content-Disposition: inline
In-Reply-To: <1157839785.5281.4.camel@max>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Sat, Sep 09 2006, Mike Christie wrote:
> On Sat, 2006-09-09 at 16:53 -0400, Mike Christie wrote:
> > This patch just converts bsg, scsi_ioctl and cdrom to
> > the new functions. There is not really much of a change
> > for scsi_ioctl and cdrom. The block layer functions
> > handle things like bounce buffers, and bio unmapping accounting
> > for them now.
> > 
> > The bsg change is larger since I based the blk layer functions
> > on it and the scsi lib code, so there are lots of deletions.
> > There were also a couple of bugs that got fixes as a result
> > of using the blk layer API:
> > - If the hdr iovec_count = 0, then the request was not getting
> > freed because blk_unmap_sghdr_rq thought blk_rq_unmap_user
> > would free the request which it does not.
> > - blk_unmap_sghdr_rq would always call bio_unmap_user, even if
> > bio_copy_user was used. This was causing all types of weird bugs
> > like slab corruption.
> > 
> > I have tested the copy and map code with scsi_ioctl.c with large
> > requests having multiple bios. I have not tested bsg or cdrom.
> > And High Mem is not tested well. I am not sure how to force high
> > mem pages to be used for the mapping. Was there a proc or module
> > param that can be used?
> > 
> > Patch was made over Jens's block tree and the bsg branch
> > 
> > Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
> 
> 
> That patch was bad. As you can probably tell, I was trying to use git
> and was hand editing the patch at the same time. The patch below fixes
> the compile errors found in the previous patch.

Thanks, I will rebase bsg on top of the block branch and apply once we
get the 1/2 patch sorted.

-- 
Jens Axboe

