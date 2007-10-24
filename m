From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH -mm 09/11] call blk_queue_segment_boundary in __scsi_alloc_queue
Date: Wed, 24 Oct 2007 07:39:16 -0400
Message-ID: <471F2EE4.5000309@garzik.org>
References: <67bb10d9f4e9473ddc84d9839114602c1966f19f.tomof@acm.org> <20071024172611B.tomof@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:54477 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753023AbXJXLjU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 24 Oct 2007 07:39:20 -0400
In-Reply-To: <20071024172611B.tomof@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <tomof@acm.org>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com, fujita.tomonori@lab.ntt.co.jp, Jens Axboe <jens.axboe@oracle.com>

FUJITA Tomonori wrote:
> request_queue and device struct must have the same value of a segment
> size limit. This patch adds blk_queue_segment_boundary in
> __scsi_alloc_queue so LLDs don't need to call both
> blk_queue_segment_boundary and set_dma_max_seg_size. A LLD can change
> the default value (64KB) can call device_dma_parameters accessors like
> pci_set_dma_max_seg_size when allocating scsi_host.
> 
> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> ---
>  drivers/scsi/scsi_lib.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index 61fdaf0..23a30ab 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -1645,6 +1645,7 @@ struct request_queue *__scsi_alloc_queue(struct Scsi_Host *shost,
>  					 request_fn_proc *request_fn)
>  {
>  	struct request_queue *q;
> +	struct device *dev = shost->shost_gendev.parent;
>  
>  	q = blk_init_queue(request_fn, NULL);
>  	if (!q)
> @@ -1673,6 +1674,8 @@ struct request_queue *__scsi_alloc_queue(struct Scsi_Host *shost,
>  	blk_queue_bounce_limit(q, scsi_calculate_bounce_limit(shost));
>  	blk_queue_segment_boundary(q, shost->dma_boundary);
>  
> +	blk_queue_max_segment_size(q, dma_get_max_seg_size(dev));
> +

it would be nice to have something more general that's useable in 
drivers/block/sx8.c (for example), something like

	static inline void
	dev_blk_associate(struct device *dev, request_queue *q)
	{
		blk_queue_max_segment_size(q,
					dma_get_max_seg_size(dev));
	}

still, I will ACK the above patch (#9) in case you wish that to become a 
future cleanup, or others dislike this suggestion

