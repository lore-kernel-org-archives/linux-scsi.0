From: Omar Sandoval <osandov@osandov.com>
Subject: Re: [PATCH V2 2/8] blk-mq: introduce BLK_MQ_F_GLOBAL_TAGS
Date: Tue, 6 Feb 2018 12:33:36 -0800
Message-ID: <20180206203336.GC16027@vader.DHCP.thefacebook.com>
References: <20180205152035.15016-1-ming.lei@redhat.com>
 <20180205152035.15016-3-ming.lei@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:45567 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752852AbeBFUdj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Feb 2018 15:33:39 -0500
Received: by mail-pg0-f67.google.com with SMTP id m136so1554409pga.12
        for <linux-scsi@vger.kernel.org>; Tue, 06 Feb 2018 12:33:39 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <20180205152035.15016-3-ming.lei@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ming Lei <ming.lei@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Mike Snitzer <snitzer@redhat.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Arun Easi <arun.easi@cavium.com>, Omar Sandoval <osandov@fb.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, Christoph Hellwig <hch@lst.de>, Don Brace <don.brace@microsemi.com>, Kashyap Desai <kashyap.desai@broadcom.com>, Peter Rivera <peter.rivera@broadcom.com>, Paolo Bonzini <pbonzini@redhat.com>, Laurence Oberman <loberman@redhat.com>

On Mon, Feb 05, 2018 at 11:20:29PM +0800, Ming Lei wrote:
> Quite a few HBAs(such as HPSA, megaraid, mpt3sas, ..) support multiple
> reply queues, but tags is often HBA wide.
> 
> These HBAs have switched to use pci_alloc_irq_vectors(PCI_IRQ_AFFINITY)
> for automatic affinity assignment.
> 
> Now 84676c1f21e8ff5(genirq/affinity: assign vectors to all possible CPUs)
> has been merged to V4.16-rc, and it is easy to allocate all offline CPUs
> for some irq vectors, this can't be avoided even though the allocation
> is improved.
> 
> So all these drivers have to avoid to ask HBA to complete request in
> reply queue which hasn't online CPUs assigned, and HPSA has been broken
> with v4.15+:
> 
> 	https://marc.info/?l=linux-kernel&m=151748144730409&w=2
> 
> This issue can be solved generically and easily via blk_mq(scsi_mq) multiple
> hw queue by mapping each reply queue into hctx, but one tricky thing is
> the HBA wide(instead of hw queue wide) tags.
> 
> This patch is based on the following Hannes's patch:
> 
> 	https://marc.info/?l=linux-block&m=149132580511346&w=2
> 
> One big difference with Hannes's is that this patch only makes the tags sbitmap
> and active_queues data structure HBA wide, and others are kept as NUMA locality,
> such as request, hctx, tags, ...
> 
> The following patch will support global tags on null_blk, also the performance
> data is provided, no obvious performance loss is observed when the whole
> hw queue depth is same.
> 
> Cc: Hannes Reinecke <hare@suse.de>
> Cc: Arun Easi <arun.easi@cavium.com>
> Cc: Omar Sandoval <osandov@fb.com>,
> Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
> Cc: James Bottomley <james.bottomley@hansenpartnership.com>,
> Cc: Christoph Hellwig <hch@lst.de>,
> Cc: Don Brace <don.brace@microsemi.com>
> Cc: Kashyap Desai <kashyap.desai@broadcom.com>
> Cc: Peter Rivera <peter.rivera@broadcom.com>
> Cc: Mike Snitzer <snitzer@redhat.com>
> Tested-by: Laurence Oberman <loberman@redhat.com>
> Signed-off-by: Ming Lei <ming.lei@redhat.com>
> ---
>  block/blk-mq-debugfs.c |  1 +
>  block/blk-mq-sched.c   | 13 ++++++++++++-
>  block/blk-mq-tag.c     | 23 ++++++++++++++++++-----
>  block/blk-mq-tag.h     |  5 ++++-
>  block/blk-mq.c         | 29 ++++++++++++++++++++++++-----
>  block/blk-mq.h         |  3 ++-
>  include/linux/blk-mq.h |  2 ++
>  7 files changed, 63 insertions(+), 13 deletions(-)
> 
> diff --git a/block/blk-mq-debugfs.c b/block/blk-mq-debugfs.c
> index 0dfafa4b655a..0f0fafe03f5d 100644
> --- a/block/blk-mq-debugfs.c
> +++ b/block/blk-mq-debugfs.c
> @@ -206,6 +206,7 @@ static const char *const hctx_flag_name[] = {
>  	HCTX_FLAG_NAME(SHOULD_MERGE),
>  	HCTX_FLAG_NAME(TAG_SHARED),
>  	HCTX_FLAG_NAME(SG_MERGE),
> +	HCTX_FLAG_NAME(GLOBAL_TAGS),
>  	HCTX_FLAG_NAME(BLOCKING),
>  	HCTX_FLAG_NAME(NO_SCHED),
>  };
> diff --git a/block/blk-mq-sched.c b/block/blk-mq-sched.c
> index 55c0a745b427..385bbec73804 100644
> --- a/block/blk-mq-sched.c
> +++ b/block/blk-mq-sched.c
> @@ -81,6 +81,17 @@ static bool blk_mq_sched_restart_hctx(struct blk_mq_hw_ctx *hctx)
>  	} else
>  		clear_bit(BLK_MQ_S_SCHED_RESTART, &hctx->state);
>  
> +	/* need to restart all hw queues for global tags */
> +	if (hctx->flags & BLK_MQ_F_GLOBAL_TAGS) {
> +		struct blk_mq_hw_ctx *hctx2;
> +		int i;
> +
> +		queue_for_each_hw_ctx(hctx->queue, hctx2, i)
> +			if (blk_mq_run_hw_queue(hctx2, true))
> +				return true;

Is it intentional that we stop after the first hw queue does work? That
seems fine but it's a little confusing because the comment claims we
restart everything.

> +		return false;
> +	}
> +
