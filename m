From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH] SCSI: fix /proc memory leak in the SCSI core
Date: Mon, 01 Dec 2008 17:43:06 +0200
Message-ID: <4934060A.9050809@panasas.com>
References: <Pine.LNX.4.44L0.0812011024430.2212-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.172]:27489 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751768AbYLAPnO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Dec 2008 10:43:14 -0500
Received: by ug-out-1314.google.com with SMTP id 39so2704763ugf.37
        for <linux-scsi@vger.kernel.org>; Mon, 01 Dec 2008 07:43:12 -0800 (PST)
In-Reply-To: <Pine.LNX.4.44L0.0812011024430.2212-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, SCSI development list <linux-scsi@vger.kernel.org>

Alan Stern wrote:
> The SCSI core calls scsi_proc_hostdir_add() from within
> scsi_host_alloc(), but the corresponding scsi_proc_hostdir_rm()
> routine is called from within scsi_remove_host().  As a result, if a
> host is allocated and then deallocated without ever being registered,
> the host's directory in /proc is leaked.
> 
> This patch (as1181) fixes this bug in the SCSI core by moving
> scsi_proc_hostdir_add() into scsi_host_add().
> 
> Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
> 

Nice this also fixes the premature visibility of the directory
and the theoretical races, that can cause.

> ---
> 
> Can somebody check to make sure this is compatible with legacy drivers 
> using the non-hotplug API?
> 
> 
> 
> Index: usb-2.6/drivers/scsi/hosts.c
> ===================================================================
> --- usb-2.6.orig/drivers/scsi/hosts.c
> +++ usb-2.6/drivers/scsi/hosts.c
> @@ -206,9 +206,10 @@ int scsi_add_host(struct Scsi_Host *shos
>  	if (error)
>  		goto fail;
>  
> +	scsi_proc_hostdir_add(shost->hostt);
> +
>  	if (!shost->shost_gendev.parent)
>  		shost->shost_gendev.parent = dev ? dev : &platform_bus;
> -
>  	error = device_add(&shost->shost_gendev);
>  	if (error)
>  		goto out;
> @@ -259,6 +260,7 @@ int scsi_add_host(struct Scsi_Host *shos
>   out_del_gendev:
>  	device_del(&shost->shost_gendev);
>   out:
> +	scsi_proc_hostdir_rm(shost->hostt);
>  	scsi_destroy_command_freelist(shost);
>   fail:
>  	return error;
> @@ -407,7 +409,6 @@ struct Scsi_Host *scsi_host_alloc(struct
>  		goto fail_kfree;
>  	}
>  
> -	scsi_proc_hostdir_add(shost->hostt);
>  	return shost;
>  
>   fail_kfree:
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

