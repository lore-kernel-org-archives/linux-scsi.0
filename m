From: Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH] scsi: core: configure runtime pm before calling
 device_add in scsi_add_host_with_dma
Date: Thu, 4 Aug 2016 21:07:16 +0200
Message-ID: <16ebbed1-b5a9-4770-4f6a-33b8f3ab151a@gmail.com>
References: <792dc1a9-2280-d1a2-c088-cfdd28c67df3@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:32798 "EHLO
	mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758467AbcHDTHa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Aug 2016 15:07:30 -0400
Received: by mail-wm0-f68.google.com with SMTP id o80so556474wme.0
        for <linux-scsi@vger.kernel.org>; Thu, 04 Aug 2016 12:07:29 -0700 (PDT)
In-Reply-To: <792dc1a9-2280-d1a2-c088-cfdd28c67df3@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>

Am 03.08.2016 um 21:49 schrieb Heiner Kallweit:
> Runtime PM should be configured already once we call device_add. See also
> the description in this mail thread
> https://lists.linuxfoundation.org/pipermail/linux-pm/2009-November/023198.html
> or the order of calls e.g. in usb_new_device.
> 
> The changed order also helps to avoid scenarios where runtime pm for
> &shost->shost_gendev is activated whilst the parent is suspended,
> resulting in error message "runtime PM trying to activate child device
> hostx but parent yyy is not active".
> 
> In addition properly reverse the runtime pm calls in the error path.
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
> ---
>  drivers/scsi/hosts.c | 12 ++++++++----
>  1 file changed, 8 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
> index ba9af4a..9ab94ad 100644
> --- a/drivers/scsi/hosts.c
> +++ b/drivers/scsi/hosts.c
> @@ -246,10 +246,6 @@ int scsi_add_host_with_dma(struct Scsi_Host *shost, struct device *dev,
>  
>  	shost->dma_dev = dma_dev;
>  
> -	error = device_add(&shost->shost_gendev);
> -	if (error)
> -		goto out_destroy_freelist;
> -
>  	/*
>  	 * Increase usage count temporarily here so that calling
>  	 * scsi_autopm_put_host() will trigger runtime idle if there is
> @@ -260,6 +256,10 @@ int scsi_add_host_with_dma(struct Scsi_Host *shost, struct device *dev,
>  	pm_runtime_enable(&shost->shost_gendev);
>  	device_enable_async_suspend(&shost->shost_gendev);
>  
> +	error = device_add(&shost->shost_gendev);
> +	if (error)
> +		goto out_destroy_freelist;
> +
>  	scsi_host_set_state(shost, SHOST_RUNNING);
>  	get_device(shost->shost_gendev.parent);
>  
> @@ -309,6 +309,10 @@ int scsi_add_host_with_dma(struct Scsi_Host *shost, struct device *dev,
>   out_del_gendev:
>  	device_del(&shost->shost_gendev);
>   out_destroy_freelist:
> +	device_disable_async_suspend(&shost->shost_gendev);
> +	pm_runtime_disable(&shost->shost_gendev);
> +	pm_runtime_set_suspended(&shost->shost_gendev);
> +	pm_runtime_put_noidle(&shost->shost_gendev);
>  	scsi_destroy_command_freelist(shost);
>   out_destroy_tags:
>  	if (shost_use_blk_mq(shost))
> 
Acked-by: Alan Stern <stern@rowland.harvard.edu>

