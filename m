From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [patch,v2 04/10] scsi: allocate scsi_cmnd-s from the device's
 local numa node
Date: Sat, 03 Nov 2012 17:36:40 +0100
Message-ID: <50954818.8050908@acm.org>
References: <1351892763-21325-1-git-send-email-jmoyer@redhat.com> <1351892763-21325-5-git-send-email-jmoyer@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1351892763-21325-5-git-send-email-jmoyer@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jeff Moyer <jmoyer@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, "James E.J. Bottomley" <JBottomley@parallels.com>
List-Id: linux-scsi@vger.kernel.org

On 11/02/12 22:45, Jeff Moyer wrote:
> diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
> index 2936b44..4db6973 100644
> --- a/drivers/scsi/scsi.c
> +++ b/drivers/scsi/scsi.c
> @@ -173,16 +173,20 @@ static DEFINE_MUTEX(host_cmd_pool_mutex);
>    * NULL on failure
>    */
>   static struct scsi_cmnd *
> -scsi_pool_alloc_command(struct scsi_host_cmd_pool *pool, gfp_t gfp_mask)
> +scsi_pool_alloc_command(struct scsi_host_cmd_pool *pool, gfp_t gfp_mask,
> +			int node)
>   {
>   	struct scsi_cmnd *cmd;
>
> -	cmd = kmem_cache_zalloc(pool->cmd_slab, gfp_mask | pool->gfp_mask);
> +	cmd = kmem_cache_alloc_node(pool->cmd_slab,
> +				    gfp_mask | pool->gfp_mask | __GFP_ZERO,
> +				    node);
>   	if (!cmd)
>   		return NULL;
>
> -	cmd->sense_buffer = kmem_cache_alloc(pool->sense_slab,
> -					     gfp_mask | pool->gfp_mask);
> +	cmd->sense_buffer = kmem_cache_alloc_node(pool->sense_slab,
> +					gfp_mask | pool->gfp_mask | __GFP_ZERO,
> +					node);

It's not clear to me why __GFP_ZERO is added to the allocation flags ?

Bart.
