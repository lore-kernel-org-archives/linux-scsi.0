From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: Actually using the sg table/chain code
Date: Wed, 16 Jan 2008 16:06:46 +0100
Message-ID: <20080116150645.GE6258@kernel.dk>
References: <1200412337.9273.28.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([87.55.233.238]:12566 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751326AbYAPPGt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 16 Jan 2008 10:06:49 -0500
Content-Disposition: inline
In-Reply-To: <1200412337.9273.28.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

On Tue, Jan 15 2008, James Bottomley wrote:
> I thought, now we had this new shiny code to increase the scatterlist
> table size I'd try it out.  It turns out there's a pretty vast block
> conspiracy that prevents us going over 128 entries in a scatterlist.
> 
> The first problems are in SCSI:  The host parameters sg_tablesize and
> max_sectors are used to set the queue limits max_hw_segments and
> max_sectors respectively (the former is the maximum number of entries
> the HBA can tolerate in a scatterlist for each transaction, the latter
> is a total transfer cap on the maxiumum number of 512 byte sectors).
> The default settings, assuming the HBA doesn't vary them are
> sg_tablesize at SG_ALL (255) and max_sectors at SCSI_DEFAULT_MAX_SECTORS
> (1024).  A quick calculation shows the latter is actually 512k or 128
> pages (at 4k pages), hence the persistent 128 entry limit.
> 
> However, raising max_sectors and sg_tablesize together still doesn't
> help:  There's actually an insidious limit sitting in the block layer as
> well.  This is what blk_queue_max_sectors says:
> 
> void blk_queue_max_sectors(struct request_queue *q, unsigned int
> max_sectors)
> {
> 	if ((max_sectors << 9) < PAGE_CACHE_SIZE) {
> 		max_sectors = 1 << (PAGE_CACHE_SHIFT - 9);
> 		printk("%s: set to minimum %d\n", __FUNCTION__, max_sectors);
> 	}
> 
> 	if (BLK_DEF_MAX_SECTORS > max_sectors)
> 		q->max_hw_sectors = q->max_sectors = max_sectors;
>  	else {
> 		q->max_sectors = BLK_DEF_MAX_SECTORS;
> 		q->max_hw_sectors = max_sectors;
> 	}
> }
> 
> So it imposes a maximum possible setting of BLK_DEF_MAX_SECTORS which is
> defined in blkdev.h to .... 1024, thus also forcing the queue down to
> 128 scatterlist entries.
> 
> Once I raised this limit as well, I was able to transfer over 128
> scatterlist elements during benchmark test runs of normal I/O (actually
> kernel compiles seem best, they hit 608 scatterlist entries).
> 
> So my question, is there any reason not to raise this limit to something
> large (like 65536) or even eliminate it altogether?

That function is meant for low level drivers to set their hw limits. So
ideally it should just set ->max_hw_sectors to what the driver asks for.

As Jeff mentions, a long time ago we experimentally decided that going
above 512k typically didn't yield any benefit, so Linux should not
generate commands larger than that for normal fs io. That is what
BLK_DEF_MAX_SECTORS does.

IOW, the driver calls blk_queue_max_sectors() with its real limit - 64mb
for instance. Linux then sets that as the hw limit, and puts a
reasonable limit on the generated size based on a
throughput/latency/memory concern. I think that is quite reasonable, and
there's nothing preventing users from setting a larger size using sysfs
by echoing something into queue/max_sectors_kb. You can set > 512kb
there easily, as long as the max_hw_sectors_kb is honored.

-- 
Jens Axboe

