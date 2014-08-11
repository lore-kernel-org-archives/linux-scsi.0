From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH V4 4/4] Save command pool address of Scsi_Host
Date: Mon, 11 Aug 2014 02:44:08 -0700
Message-ID: <20140811094408.GA5952@infradead.org>
References: <1407483840-31436-1-git-send-email-jgross@suse.com>
 <1407483840-31436-5-git-send-email-jgross@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1407483840-31436-5-git-send-email-jgross@suse.com>
Sender: target-devel-owner@vger.kernel.org
To: jgross@suse.com
Cc: xen-devel@lists.xen.org, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, JBottomley@parallels.com, konrad.wilk@oracle.com, hch@infradead.org, david.vrabel@citrix.com, JBeulich@suse.com, Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, Ewan Milne <emilne@redhat.com>
List-Id: linux-scsi@vger.kernel.org

Any chance to get a review for this once so I can queued it up for 3.17?

On Fri, Aug 08, 2014 at 09:44:00AM +0200, jgross@suse.com wrote:
> From: Juergen Gross <jgross@suse.com>
> 
> If a scsi host driver specifies .cmd_len in it's scsi_host_template, a driver's
> private command pool is needed. scsi_find_host_cmd_pool() will locate it, but
> scsi_alloc_host_cmd_pool() isn't saving the pool address in the host template.
> 
> This will result in an access error when the host is removed.
> 
> Avoid the problem by saving the address of a new allocated command pool where
> it is expected.
> 
> Signed-off-by: Juergen Gross <jgross@suse.com>
> ---
>  drivers/scsi/scsi.c | 12 ++++++++++--
>  1 file changed, 10 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
> index 88d46fe..b0cef5b 100644
> --- a/drivers/scsi/scsi.c
> +++ b/drivers/scsi/scsi.c
> @@ -380,6 +380,10 @@ scsi_alloc_host_cmd_pool(struct Scsi_Host *shost)
>  		pool->slab_flags |= SLAB_CACHE_DMA;
>  		pool->gfp_mask = __GFP_DMA;
>  	}
> +
> +	if (hostt->cmd_size)
> +		hostt->cmd_pool = pool;
> +
>  	return pool;
>  }
>  
> @@ -424,8 +428,10 @@ out:
>  out_free_slab:
>  	kmem_cache_destroy(pool->cmd_slab);
>  out_free_pool:
> -	if (hostt->cmd_size)
> +	if (hostt->cmd_size) {
>  		scsi_free_host_cmd_pool(pool);
> +		hostt->cmd_pool = NULL;
> +	}
>  	goto out;
>  }
>  
> @@ -447,8 +453,10 @@ static void scsi_put_host_cmd_pool(struct Scsi_Host *shost)
>  	if (!--pool->users) {
>  		kmem_cache_destroy(pool->cmd_slab);
>  		kmem_cache_destroy(pool->sense_slab);
> -		if (hostt->cmd_size)
> +		if (hostt->cmd_size) {
>  			scsi_free_host_cmd_pool(pool);
> +			hostt->cmd_pool = NULL;
> +		}
>  	}
>  	mutex_unlock(&host_cmd_pool_mutex);
>  }
> -- 
> 1.8.4.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
---end quoted text---
