From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v3 06/11] dm: Use BLK_MQ_S_STOPPED instead of
        QUEUE_FLAG_STOPPED in blk-mq code
Date: Wed, 19 Oct 2016 15:28:04 +0200
Message-ID: <20161019132804.GF6323@lst.de>
References: <b39eb0e7-1007-eb63-8e7f-9a7f08508379@sandisk.com> <e5facfd0-82d5-10cb-712b-13d7950b78b8@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:41991 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S942691AbcJSOqe (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 19 Oct 2016 10:46:34 -0400
Content-Disposition: inline
In-Reply-To: <e5facfd0-82d5-10cb-712b-13d7950b78b8@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Jens Axboe <axboe@fb.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Mike Snitzer <snitzer@redhat.com>, Doug Ledford <dledford@redhat.com>, Keith Busch <keith.busch@intel.com>, Ming Lin <ming.l@ssi.samsung.com>, Laurence Oberman <loberman@redhat.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>

This looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

On Tue, Oct 18, 2016 at 02:51:33PM -0700, Bart Van Assche wrote:
>  static void dm_mq_start_queue(struct request_queue *q)
>  {
> -	unsigned long flags;
> -
> -	spin_lock_irqsave(q->queue_lock, flags);
> -	queue_flag_clear(QUEUE_FLAG_STOPPED, q);
> -	spin_unlock_irqrestore(q->queue_lock, flags);
> -
>  	blk_mq_start_stopped_hw_queues(q, true);
>  	blk_mq_kick_requeue_list(q);

FYI, I'm tempted to say we should always call blk_mq_kick_requeue_list
from blk_mq_start_stopped_hw_queues, but that's a separate issue.
