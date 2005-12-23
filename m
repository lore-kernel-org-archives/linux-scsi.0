From: Andrew Morton <akpm@osdl.org>
Subject: Re: [SCSI] fix scsi_reap_target() device_del from atomic context
Date: Thu, 22 Dec 2005 22:13:29 -0800
Message-ID: <20051222221329.5f317b8d.akpm@osdl.org>
References: <200512212359.jBLNxluV016971@hera.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:41964 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S1030437AbVLWGNv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 23 Dec 2005 01:13:51 -0500
In-Reply-To: <200512212359.jBLNxluV016971@hera.kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: linux-scsi@vger.kernel.org

Linux Kernel Mailing List <linux-kernel@vger.kernel.org> wrote:
>
> tree d2f74a0351a09e184e124fd6ecf16e02ab768a0b
> parent 42e33148df38c60b99d984b76b302c64397ebe4c
> author James Bottomley <James.Bottomley@steeleye.com> Fri, 16 Dec 2005 12:01:43 -0800
> committer James Bottomley <jejb@mulgrave.(none)> Sat, 17 Dec 2005 22:48:08 -0600
> 
> [SCSI] fix scsi_reap_target() device_del from atomic context
> 
> scsi_reap_target() was desgined to be called from any context.
> However it must do a device_del() of the target device, which may only
> be called from user context.  Thus we have to reimplement
> scsi_reap_target() via a workqueue.
> 
> Signed-off-by: James Bottomley <James.Bottomley@SteelEye.com>
> 
>  drivers/scsi/scsi_scan.c |   48 +++++++++++++++++++++++++++++++++++++----------
>  1 files changed, 38 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
> index 94e5167..e36c21e 100644
> --- a/drivers/scsi/scsi_scan.c
> +++ b/drivers/scsi/scsi_scan.c
> @@ -400,6 +400,35 @@ static struct scsi_target *scsi_alloc_ta
>  	return found_target;
>  }
>  
> +struct work_queue_wrapper {
> +	struct work_struct	work;
> +	struct scsi_target	*starget;
> +};
> +
> +static void scsi_target_reap_work(void *data) {

Coding style?

> +	struct work_queue_wrapper *wqw = (struct work_queue_wrapper *)data;
> +	struct scsi_target *starget = wqw->starget;
> +	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);
> +	unsigned long flags;
> +
> +	kfree(wqw);
> +
> +	spin_lock_irqsave(shost->host_lock, flags);
> +
> +	if (--starget->reap_ref == 0 && list_empty(&starget->devices)) {
> +		list_del_init(&starget->siblings);
> +		spin_unlock_irqrestore(shost->host_lock, flags);
> +		device_del(&starget->dev);
> +		transport_unregister_device(&starget->dev);
> +		put_device(&starget->dev);
> +		return;
> +
> +	}
> +	spin_unlock_irqrestore(shost->host_lock, flags);
> +
> +	return;
> +}

Given that this can run an arbitrary amount of time later on, how do we
know that *shost is still live?

>  void scsi_target_reap(struct scsi_target *starget)
>  {
> -	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);
> -	unsigned long flags;
> -	spin_lock_irqsave(shost->host_lock, flags);
> +	struct work_queue_wrapper *wqw = 
> +		kzalloc(sizeof(struct work_queue_wrapper), GFP_ATOMIC);

kmalloc() would suffice.

> -	if (--starget->reap_ref == 0 && list_empty(&starget->devices)) {
> -		list_del_init(&starget->siblings);
> -		spin_unlock_irqrestore(shost->host_lock, flags);
> -		device_del(&starget->dev);
> -		transport_unregister_device(&starget->dev);
> -		put_device(&starget->dev);
> +	if (!wqw) {
> +		starget_printk(KERN_ERR, starget,
> +			       "Failed to allocate memory in scsi_reap_target()\n");
>  		return;
>  	}
> -	spin_unlock_irqrestore(shost->host_lock, flags);
> +
> +	INIT_WORK(&wqw->work, scsi_target_reap_work, wqw);
> +	wqw->starget = starget;
> +	schedule_work(&wqw->work);
>  }


