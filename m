From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH] Promise 'stex' driver
Date: Thu, 20 Jul 2006 21:25:50 -0400
Message-ID: <44C02D1E.4090206@garzik.org>
References: <NONAMEBMcvsq9IcVux1000001f9@nonameb.ptu.promise.com> <44BFF539.4000700@garzik.org> <1153439728.4754.19.camel@mulgrave> <44C01CD7.4030308@garzik.org> <20060721010724.GB24176@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:32955 "EHLO mail.dvmed.net")
	by vger.kernel.org with ESMTP id S1030428AbWGUBZ4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 20 Jul 2006 21:25:56 -0400
In-Reply-To: <20060721010724.GB24176@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@suse.de>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Ed Lin <ed.lin@promise.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, hch <hch@infradead.org>, linux-kernel <linux-kernel@vger.kernel.org>, akpm <akpm@osdl.org>, promise_linux <promise_linux@promise.com>

Jens Axboe wrote:
> On Thu, Jul 20 2006, Jeff Garzik wrote:
>> James Bottomley wrote:
>>> On Thu, 2006-07-20 at 17:27 -0400, Jeff Garzik wrote:
>>>> Since _no individual SCSI driver_ uses the block layer
>>>> tagging, it is likely that some instability and core kernel
>>>> development
>>>> will occur, in order to make that work.
>>> That's not quite true: 53c700 and tmscsim both use it ... I could with
>>> the usage were wider, but at least 53c700 has pretty regular and
>>> constant usage ... enough I think to validate the block tag code (it's
>>> been using it for the last three years).
>> Not for the case being discussed in this thread, adapter-wide tags.
> 
> That just means the map is shared, otherwise there should be little if
> any difference.
> 
>> AFAICS, no file in include/scsi/* or drivers/scsi/* ever calls 
>> blk_queue_init_tags() with a non-NULL third arg.
> 
> grpe again, it's in scsi_tcq.h.

What tree are you looking at?

There is only one user in the entire tree, and NULL is hardcoded as the 
third arg.  This is 2.6.18-rc2:
> [jgarzik@pretzel linux-2.6]$ grep -r blk_queue_init_tags *
> block/ll_rw_blk.c: * blk_queue_init_tags - initialize the queue tag info
> block/ll_rw_blk.c:int blk_queue_init_tags(request_queue_t *q, int depth,
> block/ll_rw_blk.c:EXPORT_SYMBOL(blk_queue_init_tags);
> Documentation/block/biodoc.txt: blk_queue_init_tags(request_queue_t *q, int depth)
> include/linux/blkdev.h:extern int blk_queue_init_tags(request_queue_t *, int, struct blk_queue_tag *);
> include/scsi/scsi_tcq.h:                blk_queue_init_tags(sdev->request_queue, depth, NULL);

Regards,

	Jeff



