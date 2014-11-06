From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 08/11] scsi: always assign block layer tags if enabled
Date: Thu, 6 Nov 2014 17:31:44 +0100
Message-ID: <20141106163144.GA23914@lst.de>
References: <1415087656-9491-1-git-send-email-hch@lst.de> <1415087656-9491-9-git-send-email-hch@lst.de> <545BA1B0.8030604@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:57741 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751182AbaKFQbu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 6 Nov 2014 11:31:50 -0500
Content-Disposition: inline
In-Reply-To: <545BA1B0.8030604@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>, Robert Elliott <elliott@hp.com>, Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, Jens Axboe <axboe@fb.com>, Kashyap Desai <kashyap.desai@avagotech.com>, Sreekanth Reddy <sreekanth.reddy@avagotech.com>, Mike Christie <michaelc@cs.wisc.edu>, Guennadi Liakhovetski <g.liakhovetski@gmx.de>, usb-storage@lists.one-eyed-alien.net

On Thu, Nov 06, 2014 at 05:28:32PM +0100, Bart Van Assche wrote:
> Apparently this patch removes the 
> queue_flag_set_unlocked(QUEUE_FLAG_QUEUED, sdev->request_queue) call for 
> the multiqueue case. I think it should be explained in the commit message 
> why that has been done.

Ok, I will update it.

>> -static inline void scsi_deactivate_tcq(struct scsi_device *sdev, int depth)
>> -{
>> -	if (blk_queue_tagged(sdev->request_queue))
>> -		blk_queue_free_tags(sdev->request_queue);
>> -	scsi_adjust_queue_depth(sdev, 0, depth);
>> -}
>
> Hmm ... where has the blk_queue_free_tags() call been moved to ?

It's gone.  Despite the confusing name blk_queue_free_tags just clears
QUEUE_FLAG_QUEUED, which we now never do until the actual tag structure
is freed when the queue is torn via blk_release_queue ->
__blk_queue_free_tags.
