From: Jens Axboe <axboe@suse.de>
Subject: Re: Possible explanation for SCSI benchmark problems in 2.5
Date: Mon, 30 Sep 2002 09:32:15 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020930073215.GB27420@suse.de>
References: <200209292048.g8TKmN424799@localhost.localdomain> <20020929213246.GA3743@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20020929213246.GA3743@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org, Andrew Morton <akpm@digeo.com>

On Sun, Sep 29 2002, Mike Anderson wrote:
> James Bottomley [James.Bottomley@steeleye.com] wrote:
> > Hi All,
> > 
> > While looking at other code (OK, how to get the MCA drivers not to use bounce 
> > buffers...)  I discovered that the way scsi_scan.c calls 
> > scsi_initialize_merge_fn() guarantees (on an x86) that the 
> > blk_queue_bounce_limit is always called with BLK_BOUNCE_HIGH.  This will 
> > probably hurt benchmarks on machines with 1Gb or more of memory.
> > 
> > The problem is that scsi_initialize_merge_fn() checks sdev->type, but this is 
> > always -1 in scsi_alloc_sdev, and thus it never uses the pci dma mask for disk 
> > devices.
> > 
> > The attached patch moves the initialisation to after sdev->type has the 
> > correct value.
> 
> I thought this was previously discussed on this thread.
> http://marc.theaimsgroup.com/?l=linux-kernel&m=103064539622958&w=2
> 
> and I believe the comment from Jens was that this could be killed
> off in 2.5 if someone did a check for safety on all the devices.

(BTW James, patch looks good)

Well that's one way to interpret it. But it really needs to be a good
audit, I refuse to remove the check if someone just assumes that
sr/st/whatnot are safe. It's simply not worth the risk.

-- 
Jens Axboe

