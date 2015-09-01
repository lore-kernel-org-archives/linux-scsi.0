From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH] Update scsi host to use ida for host number
Date: Tue, 01 Sep 2015 10:13:41 +0200
Message-ID: <mqdsi6yimkq.fsf@c203.arch.suse.de>
References: <1441052890-3600-1-git-send-email-leeman.duncan@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37599 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753464AbbIAINm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Sep 2015 04:13:42 -0400
In-Reply-To: <1441052890-3600-1-git-send-email-leeman.duncan@gmail.com>
	(leeman duncan's message of "Mon, 31 Aug 2015 13:28:10 -0700")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: leeman.duncan@gmail.com
Cc: linux-scsi@vger.kernel.org, hare@suse.com, JBottomley@Parallels.com, Lee Duncan <lduncan@suse.com>

leeman.duncan@gmail.com writes:

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
>  drivers/scsi/hosts.c | 43 +++++++++++++++++++++++++++++++++++-------=
-
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
> =20
> =20
> -static atomic_t scsi_host_next_hn =3D ATOMIC_INIT(0);	/* host_no for=
 next new host */
> +static DEFINE_SPINLOCK(host_index_lock);
> +static DEFINE_IDA(host_index_ida);
> =20
> =20
>  static void scsi_host_cls_release(struct device *dev)
> @@ -337,6 +338,10 @@ static void scsi_host_dev_release(struct device =
*dev)
> =20
>  	kfree(shost->shost_data);
> =20
> +	spin_lock(&host_index_lock);
> +	ida_remove(&host_index_ida, shost->host_no);
> +	spin_unlock(&host_index_lock);
> +
>  	if (parent)
>  		put_device(parent);
>  	kfree(shost);
> @@ -353,6 +358,22 @@ static struct device_type scsi_host_type =3D {
>  	.release =3D	scsi_host_dev_release,
>  };
> =20
> +static int host_get_index(int *index)
> +{
> +	int error =3D -ENOMEM;
> +
> +	do {
> +		if (!ida_pre_get(&host_index_ida, GFP_KERNEL))
> +			break;
> +		spin_lock(&host_index_lock);
> +		error =3D ida_get_new(&host_index_ida, index);
> +		spin_unlock(&host_index_lock);
> +	} while (error =3D=3D -EAGAIN);
> +
> +	return error;
> +}
> +
> +
>  /**
>   * scsi_host_alloc - register a scsi host adapter instance.
>   * @sht:	pointer to scsi host template
> @@ -370,6 +391,8 @@ struct Scsi_Host *scsi_host_alloc(struct scsi_hos=
t_template *sht, int privsize)
>  {
>  	struct Scsi_Host *shost;
>  	gfp_t gfp_mask =3D GFP_KERNEL;
> +	int index;
> +	int error;
> =20
>  	if (sht->unchecked_isa_dma && privsize)
>  		gfp_mask |=3D __GFP_DMA;
> @@ -388,11 +411,11 @@ struct Scsi_Host *scsi_host_alloc(struct scsi_h=
ost_template *sht, int privsize)
>  	init_waitqueue_head(&shost->host_wait);
>  	mutex_init(&shost->scan_mutex);
> =20
> -	/*
> -	 * subtract one because we increment first then return, but we need=
 to
> -	 * know what the next host number was before increment
> -	 */
> -	shost->host_no =3D atomic_inc_return(&scsi_host_next_hn) - 1;
> +	error =3D host_get_index(&index);
> +	if (error < 0)
> +		goto fail_kfree;
> +	shost->host_no =3D index;
> +
>  	shost->dma_channel =3D 0xff;
> =20
>  	/* These three are default values which can be overridden */
> @@ -477,7 +500,7 @@ struct Scsi_Host *scsi_host_alloc(struct scsi_hos=
t_template *sht, int privsize)
>  		shost_printk(KERN_WARNING, shost,
>  			"error handler thread failed to spawn, error =3D %ld\n",
>  			PTR_ERR(shost->ehandler));
> -		goto fail_kfree;
> +		goto fail_free_index;
>  	}
> =20
>  	shost->tmf_work_q =3D alloc_workqueue("scsi_tmf_%d",
> @@ -493,6 +516,10 @@ struct Scsi_Host *scsi_host_alloc(struct scsi_ho=
st_template *sht, int privsize)
> =20
>   fail_kthread:
>  	kthread_stop(shost->ehandler);
> + fail_free_index:
> +	spin_lock(&host_index_lock);
> +	ida_remove(&host_index_ida, index);
> +	spin_unlock(&host_index_lock);
>   fail_kfree:
>  	kfree(shost);
>  	return NULL;

Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>

--=20
Johannes Thumshirn                                           Storage
jthumshirn@suse.de                                 +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: Felix Imend=C3=B6rffer, Jane Smithard, Graham Norton
HRB 21284 (AG N=C3=BCrnberg)
Key fingerprint =3D EC38 9CAB C2C4 F25D 8600  D0D0 0393 969D 2D76 0850
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
