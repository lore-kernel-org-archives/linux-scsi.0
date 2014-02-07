From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 06/17] scsi: add support for per-host cmd pools
Date: Fri, 07 Feb 2014 03:35:00 -0600
Message-ID: <52F4A8C4.8080602@cs.wisc.edu>
References: <20140205123930.150608699@bombadil.infradead.org> <20140205124019.946278511@bombadil.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:40459 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750868AbaBGJff (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 7 Feb 2014 04:35:35 -0500
In-Reply-To: <20140205124019.946278511@bombadil.infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Jens Axboe <axboe@kernel.dk>, James Bottomley <JBottomley@Parallels.com>, Nicholas Bellinger <nab@linux-iscsi.org>, linux-scsi@vger.kernel.org

On 02/05/2014 06:39 AM, Christoph Hellwig wrote:
> -static struct scsi_host_cmd_pool *scsi_get_host_cmd_pool(gfp_t gfp_mask)
> +static struct scsi_host_cmd_pool *
> +scsi_find_host_cmd_pool(struct Scsi_Host *shost)
>  {
> +	if (shost->hostt->cmd_size)
> +		return shost->hostt->cmd_pool;
> +	if (shost->unchecked_isa_dma)
> +		return &scsi_cmd_dma_pool;
> +	return &scsi_cmd_pool;
> +}
> +

It seems there is a issue with using the cmd_size to indicate the driver
has its own cmd pool and also using that for scsi mq enabled drivers to
indicate that we want the LLD's struct allocated by blk/scsi mq.

If a driver sets cmd_size for only the scsi/blk mq purpose, this patch
wants the driver to also setup a cmd pool which I do not think is used
when doing scsi/blk mq.

