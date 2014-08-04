From: Juergen Gross <jgross@suse.com>
Subject: Re: [PATCH V4] Save command pool address of Scsi_Host
Date: Mon, 04 Aug 2014 13:28:55 +0200
Message-ID: <53DF6E77.1010804@suse.com>
References: <1407151460-26888-1-git-send-email-jgross@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1407151460-26888-1-git-send-email-jgross@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, hch@infradead.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 08/04/2014 01:24 PM, jgross@suse.com wrote:
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

Please ignore, should have used pool instead hostt->cm_pool for calling
scsi_free_host_cmd_pool(). V5 follows...


Juergen

>
> Signed-off-by: Juergen Gross <jgross@suse.com>
> ---
>   drivers/scsi/scsi.c | 16 ++++++++++++----
>   1 file changed, 12 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
> index 88d46fe..f654ac1 100644
> --- a/drivers/scsi/scsi.c
> +++ b/drivers/scsi/scsi.c
> @@ -380,6 +380,10 @@ scsi_alloc_host_cmd_pool(struct Scsi_Host *shost)
>   		pool->slab_flags |= SLAB_CACHE_DMA;
>   		pool->gfp_mask = __GFP_DMA;
>   	}
> +
> +	if (hostt->cmd_size)
> +		hostt->cmd_pool = pool;
> +
>   	return pool;
>   }
>
> @@ -424,8 +428,10 @@ out:
>   out_free_slab:
>   	kmem_cache_destroy(pool->cmd_slab);
>   out_free_pool:
> -	if (hostt->cmd_size)
> -		scsi_free_host_cmd_pool(pool);
> +	if (hostt->cmd_size) {
> +		scsi_free_host_cmd_pool(hostt->cmd_pool);
> +		hostt->cmd_pool = NULL;
> +	}
>   	goto out;
>   }
>
> @@ -447,8 +453,10 @@ static void scsi_put_host_cmd_pool(struct Scsi_Host *shost)
>   	if (!--pool->users) {
>   		kmem_cache_destroy(pool->cmd_slab);
>   		kmem_cache_destroy(pool->sense_slab);
> -		if (hostt->cmd_size)
> -			scsi_free_host_cmd_pool(pool);
> +		if (hostt->cmd_size) {
> +			scsi_free_host_cmd_pool(hostt->cmd_pool);
> +			hostt->cmd_pool = NULL;
> +		}
>   	}
>   	mutex_unlock(&host_cmd_pool_mutex);
>   }
>
