From: Muli Ben-Yehuda <muli@il.ibm.com>
Subject: Re: [RFC 1/6] bidi support: request dma_data_direction
Date: Mon, 22 Jan 2007 07:29:39 +0200
Message-ID: <20070122052938.GJ3531@rhun.ibm.com>
References: <45B3F578.7090109@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate2.uk.ibm.com ([195.212.29.135]:49679 "EHLO
	mtagate2.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750840AbXAVF3o (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 22 Jan 2007 00:29:44 -0500
Content-Disposition: inline
In-Reply-To: <45B3F578.7090109@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, Christoph Hellwig <hch@infradead.org>, Mike Christie <michaelc@cs.wisc.edu>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, open-iscsi@googlegroups.com, Daniel.E.Messinger@seagate.com, Liran Schour <LIRANS@il.ibm.com>, Benny Halevy <bhalevy@panasas.com>

On Mon, Jan 22, 2007 at 01:21:28AM +0200, Boaz Harrosh wrote:

> - Introduce a new enum dma_data_direction data_dir member in struct request.
>   and remove the RW bit from request->cmd_flag

Some architecture use 'enum dma_data_direction' and some 'int
dma_data_direction'. The consensus was to move to int over
time. Please use 'int dma_data_direction'.

> diff --git a/include/linux/dma-mapping.h b/include/linux/dma-mapping.h
> index ff203c4..abbca7b 100644
> --- a/include/linux/dma-mapping.h
> +++ b/include/linux/dma-mapping.h
> @@ -13,6 +13,28 @@ enum dma_data_direction {
>  	DMA_NONE = 3,
>  };
> 
> +static inline int dma_write_dir(enum dma_data_direction dir)
> +{
> +	return (dir == DMA_TO_DEVICE) || (dir == DMA_BIDIRECTIONAL);
> +}

"write" can mean "write to device" or "write to memory", depending on
context. Not exactly something which should be a generic
helper. Rename to 'dma_to_device(int dir)'?

> +static inline int dma_uni_dir(enum dma_data_direction dir)
> +{
> +	return (dir == DMA_TO_DEVICE) || (dir == DMA_FROM_DEVICE) ||
> +	       (dir == DMA_NONE);
> +}

While this doesn't look very useful. Why is "DMA_NONE" a uni-dir? I
suggest replacing this with an open coded (dir != DMA_BIDIRECTIONAL).

Cheers,
Muli
