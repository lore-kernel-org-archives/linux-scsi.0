From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] scsi: mq queue stall during command requeue
Date: Thu, 19 Jan 2017 16:12:38 +0100
Message-ID: <20170119151238.GA32178@lst.de>
References: <1484835465-66514-1-git-send-email-hare@suse.de> <20170119144651.GA31548@lst.de> <0a922801-a30b-7d3e-f871-e5401ad1b9b1@suse.de> <31a4a94c-5cd7-ef45-7103-c61a0d60ab46@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:56330 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751576AbdASPiX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 19 Jan 2017 10:38:23 -0500
Content-Disposition: inline
In-Reply-To: <31a4a94c-5cd7-ef45-7103-c61a0d60ab46@kernel.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, Johannes Thumshirn <jth@kernel.org>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>, James Smart <james.smart@broadcom.com>

On Thu, Jan 19, 2017 at 06:58:09AM -0800, Jens Axboe wrote:
> Yeah, I made that patch and grepped the tree. The usage in the fc
> code in nvme looks weird. It's stopping all potential hardware queues,
> yet only delaying one.
> 
> if (op->rq) {                                                   
>         blk_mq_stop_hw_queues(op->rq->q);                       
>         blk_mq_delay_queue(queue->hctx, NVMEFC_QUEUE_DELAY);    
> }                                                               
> return BLK_MQ_RQ_QUEUE_BUSY;
> 
> James/Christoph, what's going on there? I'm going to leave that one
> as-is for now, but add the stop to the delay. If the above stop-all is
> indeed buggy, then it can later just be removed.

It looks broken to me, but I'll need James to confirm.
