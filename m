From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] scsi_lib.c: sleeping function called from invalid
 context
Date: Thu, 24 Sep 2009 15:56:04 -0700
Message-ID: <20090924155604.4299aa0a.akpm@linux-foundation.org>
References: <200909231758.47612.strakh@ispras.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43589 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751541AbZIXW53 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 24 Sep 2009 18:57:29 -0400
In-Reply-To: <200909231758.47612.strakh@ispras.ru>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: iceberg <strakh@ispras.ru>
Cc: James.Bottomley@hansenpartnership.com, eric@andante.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Wed, 23 Sep 2009 17:58:47 +0000
iceberg <strakh@ispras.ru> wrote:

> Driver scsi_lib.c might sleep in atomic context, because it calls 
> scsi_device_put under spin_lock_irqsave.
> drivers/scsi/scsi_lib.c:356:
> 	spin_lock_irqsave(shost->host_lock, flags);
> 	scsi_device_put(sdev);
> Path to might_sleep macro from scsi_device_put:
> 1. scsi_device_put calls put_device at ./drivers/scsi/scsi.c:1111 
> 2. put_device calls kobject_put at ./drivers/base/core.c:1038 
> 3. kobject_put calls kref_put at ./lib/kobject.c
> 4. kref_put may call callback function kobject_release at ./lib/kref.c if 
> refcount becomes zero, which might_sleep because it calls user event. Details:
> 	4.1 kobject_cleanup calls kobject_uevent at ./lib/kobject.c:555
> 	4.2 kobject_uevent calls kobject_uevent_env at  ./lib/kobject_uevent.c:282
> 	4.3 kobject_uevent_env calls call_usermodehelper_exec at 
> ./include/linux/kmod.h:83
> 	4.4 call_usermodehelper_exec calls wait_for_completion at 
> ./kernel/kmod.c:481
> 	4.5 wait_for_completion calls wait_for_common at ./kernel/sched.c:5710
> 	4.5 wait_for_common calls might_sleep at ./kernels/sched.c:5692
> 
> Found by Linux Driver Verification project.
> 
> Delete wrong sleeping function calls.
> 
> Signed-off-by: Alexander Strakh <strakh@ispras.ru>
> 
> ---
> diff --git a/./a/drivers/scsi/scsi_lib.c b/./b/drivers/scsi/scsi_lib.c
> index f3c4089..a8f8e2f 100644
> --- a/./a/drivers/scsi/scsi_lib.c
> +++ b/./b/drivers/scsi/scsi_lib.c
> @@ -353,9 +353,9 @@ static void scsi_single_lun_run(struct scsi_device 
> *current_sdev)
>  
>  		spin_unlock_irqrestore(shost->host_lock, flags);
>  		blk_run_queue(sdev->request_queue);
> -		spin_lock_irqsave(shost->host_lock, flags);
>  	
> -		scsi_device_put(sdev);
> +		scsi_device_put(sdev);	
> +		spin_lock_irqsave(shost->host_lock, flags);
>  	}
>   out:
>  	spin_unlock_irqrestore(shost->host_lock, flags);
> 

Well this is strange.  afacit all the code to which you refer is
ancient, so why did this bug just pop up now?


