From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH 1/5] add dma_max_segment_size option to
	scsi_host_template
Date: Wed, 26 Sep 2007 11:05:34 +0200
Message-ID: <20070926090534.GA4243@kernel.dk>
References: <20070925142144Z.tomof@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([87.55.233.238]:3131 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754149AbXIZJEG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 26 Sep 2007 05:04:06 -0400
Content-Disposition: inline
In-Reply-To: <20070925142144Z.tomof@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <tomof@acm.org>
Cc: James.Bottomley@SteelEye.com, hch@infradead.org, jeff@garzik.org, gregkh@suse.de, hare@suse.de, linux-scsi@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp

On Wed, Sep 26 2007, FUJITA Tomonori wrote:
> This patch moves blk_queue_max_segment_size to scsi_alloc_queue from
> llds. It enables scsi_add_host to tells iommu lld's
> dma_max_segment_size. If a low-level driver doesn't specify
> dma_max_segment_size, scsi-ml uses 65536 (MAX_SEGMENT_SIZE). So there
> are not any functional changes.
> 
> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> ---
>  drivers/scsi/hosts.c     |    5 +++++
>  drivers/scsi/scsi_lib.c  |    1 +
>  include/scsi/scsi_host.h |    6 ++++++
>  3 files changed, 12 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
> index 96bc312..22877d3 100644
> --- a/drivers/scsi/hosts.c
> +++ b/drivers/scsi/hosts.c
> @@ -365,6 +365,11 @@ struct Scsi_Host *scsi_host_alloc(struct scsi_host_template *sht, int privsize)
>  	else
>  		shost->dma_boundary = 0xffffffff;
>  
> +	if (sht->dma_max_segment_size)
> +		shost->dma_max_segment_size = sht->dma_max_segment_size;
> +	else
> +		shost->dma_max_segment_size = 65536;

Use MAX_SEGMENT_SIZE here, instead of manually entering 64k?

Otherwise everything looks good from a quick look, it's definitely
missing functionality that we have wanted for quite some time!

-- 
Jens Axboe

