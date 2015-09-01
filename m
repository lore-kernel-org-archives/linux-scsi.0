From: Hannes Reinecke <hare@suse.com>
Subject: Re: [PATCH] Update scsi host to use ida for host number
Date: Tue, 1 Sep 2015 09:16:31 +0200
Message-ID: <55E550CF.8030801@suse.com>
References: <1441052890-3600-1-git-send-email-leeman.duncan@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.nue.novell.com ([195.135.221.5]:52381 "EHLO
	smtp.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752866AbbIAHRA (ORCPT
	<rfc822;groupwise-linux-scsi@vger.kernel.org:0:0>);
	Tue, 1 Sep 2015 03:17:00 -0400
In-Reply-To: <1441052890-3600-1-git-send-email-leeman.duncan@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: leeman.duncan@gmail.com, linux-scsi@vger.kernel.org
Cc: JBottomley@Parallels.com, Lee Duncan <lduncan@suse.com>

On 08/31/2015 10:28 PM, leeman.duncan@gmail.com wrote:
> From: Lee Duncan <lduncan@suse.com>
> 
> Each Scsi_host instance gets a host number starting
> at 0, but this is implemented with an atomic integer,
> and rollover doesn't seem to have been considered.
> Another side-effect of this design is that scsi host
> numbers used by iscsi are never reused, thereby  making
> rollover more likely. This patch converts Scsi_host
> instances to use ida to manage their instance
> numbers.
> 
> This also means that host instance numbers will be
> reused, when available.
> 
> Signed-off-by: Lee Duncan <lduncan@suse.com>
> ---
>  drivers/scsi/hosts.c | 43 +++++++++++++++++++++++++++++++++++--------
>  1 file changed, 35 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
> index 8bb173e01084..dade75478541 100644
> --- a/drivers/scsi/hosts.c
> +++ b/drivers/scsi/hosts.c
> @@ -33,7 +33,7 @@
>  #include <linux/transport_class.h>
>  #include <linux/platform_device.h>
>  #include <linux/pm_runtime.h>
> -
> +#include <linux/idr.h>
>  #include <scsi/scsi_device.h>
>  #include <scsi/scsi_host.h>
>  #include <scsi/scsi_transport.h>
> @@ -42,7 +42,8 @@
>  #include "scsi_logging.h"
>  
>  
> -static atomic_t scsi_host_next_hn = ATOMIC_INIT(0);	/* host_no for next new host */
> +static DEFINE_SPINLOCK(host_index_lock);
> +static DEFINE_IDA(host_index_ida);
>  
>  
>  static void scsi_host_cls_release(struct device *dev)
> @@ -337,6 +338,10 @@ static void scsi_host_dev_release(struct device *dev)
>  
>  	kfree(shost->shost_data);
>  
> +	spin_lock(&host_index_lock);
> +	ida_remove(&host_index_ida, shost->host_no);
> +	spin_unlock(&host_index_lock);
> +
>  	if (parent)
>  		put_device(parent);
>  	kfree(shost);
> @@ -353,6 +358,22 @@ static struct device_type scsi_host_type = {
>  	.release =	scsi_host_dev_release,
>  };
>  
> +static int host_get_index(int *index)
> +{
> +	int error = -ENOMEM;
> +
> +	do {
> +		if (!ida_pre_get(&host_index_ida, GFP_KERNEL))
> +			break;
> +		spin_lock(&host_index_lock);
> +		error = ida_get_new(&host_index_ida, index);
> +		spin_unlock(&host_index_lock);
> +	} while (error == -EAGAIN);
> +
> +	return error;
> +}
> +
> +
>  /**
>   * scsi_host_alloc - register a scsi host adapter instance.
>   * @sht:	pointer to scsi host template
> @@ -370,6 +391,8 @@ struct Scsi_Host *scsi_host_alloc(struct scsi_host_template *sht, int privsize)
>  {
>  	struct Scsi_Host *shost;
>  	gfp_t gfp_mask = GFP_KERNEL;
> +	int index;
> +	int error;
>  
>  	if (sht->unchecked_isa_dma && privsize)
>  		gfp_mask |= __GFP_DMA;
> @@ -388,11 +411,11 @@ struct Scsi_Host *scsi_host_alloc(struct scsi_host_template *sht, int privsize)
>  	init_waitqueue_head(&shost->host_wait);
>  	mutex_init(&shost->scan_mutex);
>  
> -	/*
> -	 * subtract one because we increment first then return, but we need to
> -	 * know what the next host number was before increment
> -	 */
> -	shost->host_no = atomic_inc_return(&scsi_host_next_hn) - 1;
> +	error = host_get_index(&index);
> +	if (error < 0)
> +		goto fail_kfree;
> +	shost->host_no = index;
> +
>  	shost->dma_channel = 0xff;
>  
>  	/* These three are default values which can be overridden */
> @@ -477,7 +500,7 @@ struct Scsi_Host *scsi_host_alloc(struct scsi_host_template *sht, int privsize)
>  		shost_printk(KERN_WARNING, shost,
>  			"error handler thread failed to spawn, error = %ld\n",
>  			PTR_ERR(shost->ehandler));
> -		goto fail_kfree;
> +		goto fail_free_index;
>  	}
>  
>  	shost->tmf_work_q = alloc_workqueue("scsi_tmf_%d",
> @@ -493,6 +516,10 @@ struct Scsi_Host *scsi_host_alloc(struct scsi_host_template *sht, int privsize)
>  
>   fail_kthread:
>  	kthread_stop(shost->ehandler);
> + fail_free_index:
> +	spin_lock(&host_index_lock);
> +	ida_remove(&host_index_ida, index);
> +	spin_unlock(&host_index_lock);
>   fail_kfree:
>  	kfree(shost);
>  	return NULL;
> 
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
