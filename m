From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: [PATCH] fix scsi process problems and clean up the target reap issues
Date: Tue, 28 Feb 2006 09:24:36 -0800
Message-ID: <20060228172436.GA1456@us.ibm.com>
References: <1140726438.2809.18.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.141]:7134 "EHLO e1.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S1751817AbWB1RZL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Feb 2006 12:25:11 -0500
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e1.ny.us.ibm.com (8.12.11/8.12.11) with ESMTP id k1SHPAbV007619
	for <linux-scsi@vger.kernel.org>; Tue, 28 Feb 2006 12:25:10 -0500
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay02.pok.ibm.com (8.12.10/NCO/VER6.8) with ESMTP id k1SHPADB074464
	for <linux-scsi@vger.kernel.org>; Tue, 28 Feb 2006 12:25:10 -0500
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.12.11/8.13.3) with ESMTP id k1SHP9qS022728
	for <linux-scsi@vger.kernel.org>; Tue, 28 Feb 2006 12:25:10 -0500
Content-Disposition: inline
In-Reply-To: <1140726438.2809.18.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

James Bottomley <James.Bottomley@SteelEye.com> wrote:
>  static void scsi_target_reap_usercontext(void *data)
> @@ -391,21 +400,13 @@
>  	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);
>  	unsigned long flags;
>  
> +	transport_remove_device(&starget->dev);
> +	device_del(&starget->dev);
> +	transport_destroy_device(&starget->dev);
>  	spin_lock_irqsave(shost->host_lock, flags);
> -
> -	if (--starget->reap_ref == 0 && list_empty(&starget->devices)) {
> -		list_del_init(&starget->siblings);
> -		spin_unlock_irqrestore(shost->host_lock, flags);
> -		transport_remove_device(&starget->dev);
> -		device_del(&starget->dev);
> -		transport_destroy_device(&starget->dev);
> -		put_device(&starget->dev);
> -		return;
> -
> -	}
> +	list_del_init(&starget->siblings);
>  	spin_unlock_irqrestore(shost->host_lock, flags);
> -
> -	return;
> +	put_device(&starget->dev);
>  }
>  
>  /**


The patch was tried on the aic7xxx ahc_linux_target_alloc issue I
previously mentioned and it did not change the result of a BUG_ON.

Is there some reason we cannot do the list_del_init(&starget->siblings) in
scsi_target_dev_release post calling target_destroy? It would appear with
the check for STARGET_DEL that being on the list longer should not be a
problem.

For the sdev we call the slave_destroy in __scsi_remove_device and then pull
it off the list in the release.

-andmike
--
Michael Anderson
andmike@us.ibm.com
