From: Bernd Schubert <bernd.schubert-97jfqw80gc6171pxa8y+qA@public.gmane.org>
Subject: Re: [PATCH] srp: convert SRP_RQ_SHIFT into a module parameter
Date: Mon, 21 May 2012 21:35:13 +0200
Message-ID: <4FBA98F1.40103@fastmail.fm>
References: <4FB39D78.9020300@itwm.fraunhofer.de>  <1337177200.2985.71.camel@dabdike.int.hansenpartnership.com>  <4FB3B9DE.1050903@itwm.fraunhofer.de> <4FB3C75F.3070903@cs.wisc.edu>  <4FB3CDC5.9040608@itwm.fraunhofer.de> <1337187813.21009.14.camel@frustration.ornl.gov> <4FBA6412.7040505@itwm.fraunhofer.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4FBA6412.7040505-mPn0NPGs4xGatNDF+KUbs4QuADTiUCJX@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bernd Schubert <bernd.schubert-mPn0NPGs4xGatNDF+KUbs4QuADTiUCJX@public.gmane.org>
Cc: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>, Mike Christie <michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>, James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, "linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

> @@ -2131,9 +2171,15 @@ static ssize_t srp_create_target(struct device *dev,
>  	target_host->max_id      = 1;
>  	target_host->max_lun     = SRP_MAX_LUN;
>  	target_host->max_cmd_len = sizeof ((struct srp_cmd *) (void *) 0L)->cdb;
> +	target_host->can_queue   = srp_cmd_sq_size;
> +	target_host->cmd_per_lun = srp_cmd_sq_size;
>  
>  	target = host_to_target(target_host);
>  
> +	ret = srp_alloc_target_rings(target);
> +	if (ret)
> +		goto err;


Here is a memory leak if something fails below, I need to add another
goto target.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
