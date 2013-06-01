From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] [SCSI] libsas: Cocci spatch "ptr_ret.spatch"
Date: Sat, 01 Jun 2013 08:26:43 -0700
Message-ID: <1370100403.2463.14.camel@dabdike>
References: <1370080781.29224.39.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1370080781.29224.39.camel@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
To: Thomas Meyer <thomas@m3y3r.de>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Sat, 2013-06-01 at 11:59 +0200, Thomas Meyer wrote:
> Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
> ---
> 
> diff -u -p a/drivers/scsi/libsas/sas_scsi_host.c b/drivers/scsi/libsas/sas_scsi_host.c
> --- a/drivers/scsi/libsas/sas_scsi_host.c
> +++ b/drivers/scsi/libsas/sas_scsi_host.c
> @@ -1093,9 +1093,7 @@ int sas_init_queue(struct sas_ha_struct
>  
>  	core->queue_thread = kthread_run(sas_queue_thread, sas_ha,
>  					 "sas_queue_%d", core->shost->host_no);
> -	if (IS_ERR(core->queue_thread))
> -		return PTR_ERR(core->queue_thread);
> -	return 0;
> +	return PTR_RET(core->queue_thread);
>  }

Really, no, this is not a good patch.  I know exactly what the current
code is doing by reading it.  With your patch I now have to go and look
up the definition of an obscure and non-standard macro.

If we're sacrificing clarity, I want a good reason and having two lines
fewer code isn't it.

James
