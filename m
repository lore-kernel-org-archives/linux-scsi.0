From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCHSET block#for-2.6.36-post] block: replace barrier with sequenced flush
Date: Thu, 19 Aug 2010 12:20:23 +0200
Message-ID: <20100819102023.GA6736@lst.de>
References: <1281616891-5691-1-git-send-email-tj@kernel.org> <20100818094620.GA14707@lst.de> <4C6D0021.4040601@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:58783 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752072Ab0HSKUx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 19 Aug 2010 06:20:53 -0400
Content-Disposition: inline
In-Reply-To: <4C6D0021.4040601@kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, jaxboe@fusionio.com, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, James.Bottomley@suse.de, tytso@mit.edu, chris.mason@oracle.com, swhiteho@redhat.com, konishi.ryusuke@lab.ntt.co.jp, dm-devel@redhat.com, vst@vlnb.net, jack@suse.cz, rwheeler@redhat.com, hare@suse.de

On Thu, Aug 19, 2010 at 11:57:53AM +0200, Tejun Heo wrote:
> On 08/18/2010 11:46 AM, Christoph Hellwig wrote:
> > FYI: One issue with this series is that make_request based drivers
> > not have to access all REQ_FLUSH and REQ_FUA requests.  We'll either
> > need to add handling to empty REQ_FLUSH requests to all of them or
> > figure out a way to prevent them getting sent.  That is assuming they'll
> > simply ignore REQ_FLUSH/REQ_FUA on normal writes.
> 
> Can you be a bit more specific?  In most cases, request based drivers
> should be fine.  They sit behind the front most request_queue which
> would discompose REQ_FLUSH/FUAs into appropriate command sequence.

I said make_request based drivers, that is drivers taking bios.   These
get bios directly from __generic_make_request and need to deal with
REQ_FLUSH/FUA themselves.  We have quite a few more than just dm/md of
this kind:

arch/powerpc/sysdev/axonram.c:	blk_queue_make_request(bank->disk->queue, axon_ram_make_request);
drivers/block/aoe/aoeblk.c:     blk_queue_make_request(d->blkq, aoeblk_make_request);
drivers/block/brd.c:		blk_queue_make_request(brd->brd_queue, brd_make_request);
drivers/block/drbd/drbd_main.c: blk_queue_make_request(q, drbd_make_request_26);
drivers/block/loop.c:		blk_queue_make_request(lo->lo_queue, loop_make_request);
drivers/block/pktcdvd.c:        blk_queue_make_request(q, pkt_make_request);
drivers/block/ps3vram.c:        blk_queue_make_request(queue, ps3vram_make_request);
drivers/block/umem.c:		blk_queue_make_request(card->queue, mm_make_request);
drivers/s390/block/dcssblk.c:	blk_queue_make_request(dev_info->dcssblk_queue, dcssblk_make_request);
drivers/s390/block/xpram.c:	blk_queue_make_request(xpram_queues[i], xpram_make_request);
drivers/staging/zram/zram_drv.c:blk_queue_make_request(zram->queue, zram_make_request);


