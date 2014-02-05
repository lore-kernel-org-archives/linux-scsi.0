From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 05/17] scsi: simplify command allocation and freeing a
 bit
Date: Wed, 05 Feb 2014 15:51:35 -0800
Message-ID: <1391644295.2213.65.camel@dabdike.int.hansenpartnership.com>
References: <20140205123930.150608699@bombadil.infradead.org>
	 <20140205124019.766741239@bombadil.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:46411 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751387AbaBEXvh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Feb 2014 18:51:37 -0500
In-Reply-To: <20140205124019.766741239@bombadil.infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Jens Axboe <axboe@kernel.dk>, Nicholas Bellinger <nab@linux-iscsi.org>, linux-scsi@vger.kernel.org

On Wed, 2014-02-05 at 04:39 -0800, Christoph Hellwig wrote:

> Just have one level of alloc/free functions that take a host instead
> of two levels for the allocation and different calling conventions
> for the free.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/scsi/scsi.c |   77 +++++++++++++++------------------------------------
>  1 file changed, 22 insertions(+), 55 deletions(-)
> 
> diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
> index 4139486..5347f7d 100644
> --- a/drivers/scsi/scsi.c
> +++ b/drivers/scsi/scsi.c
> @@ -160,79 +160,46 @@ static struct scsi_host_cmd_pool scsi_cmd_dma_pool = {
>  
>  static DEFINE_MUTEX(host_cmd_pool_mutex);
>  
> -/**
> - * scsi_pool_alloc_command - internal function to get a fully allocated command
> - * @pool:	slab pool to allocate the command from
> - * @gfp_mask:	mask for the allocation
> - *
> - * Returns a fully allocated command (with the allied sense buffer) or
> - * NULL on failure
> - */
> -static struct scsi_cmnd *
> -scsi_pool_alloc_command(struct scsi_host_cmd_pool *pool, gfp_t gfp_mask)
> -{
> -	struct scsi_cmnd *cmd;
> -
> -	cmd = kmem_cache_zalloc(pool->cmd_slab, gfp_mask | pool->gfp_mask);
> -	if (!cmd)
> -		return NULL;
> -
> -	cmd->sense_buffer = kmem_cache_alloc(pool->sense_slab,
> -					     gfp_mask | pool->gfp_mask);
> -	if (!cmd->sense_buffer) {
> -		kmem_cache_free(pool->cmd_slab, cmd);
> -		return NULL;
> -	}
> -
> -	return cmd;
> -}
> -
> -/**
> - * scsi_pool_free_command - internal function to release a command
> - * @pool:	slab pool to allocate the command from
> - * @cmd:	command to release
> - *
> - * the command must previously have been allocated by
> - * scsi_pool_alloc_command.
> - */
>  static void
> -scsi_pool_free_command(struct scsi_host_cmd_pool *pool,
> -			 struct scsi_cmnd *cmd)
> +scsi_host_free_command(struct Scsi_Host *shost, struct scsi_cmnd *cmd)

You lost the docbook function description here when you changed the name.

>  {
> +	struct scsi_host_cmd_pool *pool = shost->cmd_pool;
> +
>  	if (cmd->prot_sdb)
>  		kmem_cache_free(scsi_sdb_cache, cmd->prot_sdb);
> -
>  	kmem_cache_free(pool->sense_slab, cmd->sense_buffer);
>  	kmem_cache_free(pool->cmd_slab, cmd);
>  }
>  
> -/**
> - * scsi_host_alloc_command - internal function to allocate command
> - * @shost:	SCSI host whose pool to allocate from
> - * @gfp_mask:	mask for the allocation
> - *
> - * Returns a fully allocated command with sense buffer and protection
> - * data buffer (where applicable) or NULL on failure
> - */

This docbook elimination looks spurious; why do it?

James

>  static struct scsi_cmnd *
>  scsi_host_alloc_command(struct Scsi_Host *shost, gfp_t gfp_mask)
>  {
> +	struct scsi_host_cmd_pool *pool = shost->cmd_pool;
>  	struct scsi_cmnd *cmd;
>  
> -	cmd = scsi_pool_alloc_command(shost->cmd_pool, gfp_mask);
> +	cmd = kmem_cache_zalloc(pool->cmd_slab, gfp_mask | pool->gfp_mask);
>  	if (!cmd)
> -		return NULL;
> +		goto fail;
> +
> +	cmd->sense_buffer = kmem_cache_alloc(pool->sense_slab,
> +					     gfp_mask | pool->gfp_mask);
> +	if (!cmd->sense_buffer)
> +		goto fail_free_cmd;
>  
>  	if (scsi_host_get_prot(shost) >= SHOST_DIX_TYPE0_PROTECTION) {
>  		cmd->prot_sdb = kmem_cache_zalloc(scsi_sdb_cache, gfp_mask);
> -
> -		if (!cmd->prot_sdb) {
> -			scsi_pool_free_command(shost->cmd_pool, cmd);
> -			return NULL;
> -		}
> +		if (!cmd->prot_sdb)
> +			goto fail_free_sense;
>  	}
>  
>  	return cmd;
> +
> +fail_free_sense:
> +	kmem_cache_free(pool->sense_slab, cmd->sense_buffer);
> +fail_free_cmd:
> +	kmem_cache_free(pool->cmd_slab, cmd);
> +fail:
> +	return NULL;
>  }
>  
>  /**
> @@ -330,7 +297,7 @@ void __scsi_put_command(struct Scsi_Host *shost, struct scsi_cmnd *cmd,
>  	}
>  
>  	if (cmd)
> -		scsi_pool_free_command(shost->cmd_pool, cmd);
> +		scsi_host_free_command(shost, cmd);
>  
>  	put_device(dev);
>  }
> @@ -469,7 +436,7 @@ void scsi_destroy_command_freelist(struct Scsi_Host *shost)
>  
>  		cmd = list_entry(shost->free_list.next, struct scsi_cmnd, list);
>  		list_del_init(&cmd->list);
> -		scsi_pool_free_command(shost->cmd_pool, cmd);
> +		scsi_host_free_command(shost, cmd);
>  	}
>  	shost->cmd_pool = NULL;
>  	scsi_put_host_cmd_pool(shost->unchecked_isa_dma ? GFP_DMA : GFP_KERNEL);
> -- 
> 1.7.10.4


