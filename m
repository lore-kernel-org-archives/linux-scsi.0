From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [DO NOT APPLY] sd take advantage of rotation speed
Date: Wed, 25 Jun 2008 15:47:05 +0200
Message-ID: <20080625134705.GZ20851@kernel.dk>
References: <20080619160342.GJ4392@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([87.55.233.238]:17168 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755581AbYFYNrK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 25 Jun 2008 09:47:10 -0400
Content-Disposition: inline
In-Reply-To: <20080619160342.GJ4392@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-scsi@vger.kernel.org

On Thu, Jun 19 2008, Matthew Wilcox wrote:
> Use the noop elevator by default for drives that do not spin
> 
> [Not for applying]
> 
> SSDs do not benefit from the elevator.  It just wastes precious CPU cycles.
> By selecting the noop elevator by default, we can shave a few microseconds
> off each IO.
> 
> I've brazenly stolen sd_vpd_inquiry from mkp's patch here:
> 
> http://marc.info/?l=linux-scsi&m=121264354724277&w=2
> 
> No need to have two copies of that ... but this will conflict with his code.
> 
> On to the self-criticism:
> 
> I don't intend the final version of this patch to include a printk for
> the RPM or even a printk to say we switched IO elevator.  I think we're
> too verbose in SCSI as it is.
> 
> I think there's an opportunity to improve sd_vpd_inquiry() to remove
> some of the duplicate code between sd_set_elevator() and sd_block_limits,
> but it's not terribly important.
> 
> The switching of the elevators isn't particularly nice.  I assume that
> elevator_init("noop") cannot fail, which isn't true.  It would be nice
> to use the #if 0 block instead, but that causes a null ptr dereference
> inside sysfs -- I suspect something isn't set up correctly.

I disagree with this approach. For now, lets just add a queue flag that
says the device doesn't have a seek penalty and let the io schedulers do
what they need to avoid that (it'd be a one-liner change to cfq and as).
There's more to io scheduling than just seek reduction, so this is the
wrong direction to take imo.

-- 
Jens Axboe

