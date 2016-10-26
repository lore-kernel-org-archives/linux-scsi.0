From: Laurence Oberman <loberman@redhat.com>
Subject: Re: [PATCH] scsi_debug: Fix memory leak if LBP enabled and module
 is unloaded
Date: Wed, 26 Oct 2016 12:56:05 -0400 (EDT)
Message-ID: <836409948.4605193.1477500965467.JavaMail.zimbra@redhat.com>
References: <1477495373-1179-1-git-send-email-emilne@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx4-phx2.redhat.com ([209.132.183.25]:41136 "EHLO
        mx4-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752432AbcJZQ4G (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 26 Oct 2016 12:56:06 -0400
In-Reply-To: <1477495373-1179-1-git-send-email-emilne@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Ewan D. Milne" <emilne@redhat.com>
Cc: linux-scsi@vger.kernel.org



----- Original Message -----
> From: "Ewan D. Milne" <emilne@redhat.com>
> To: linux-scsi@vger.kernel.org
> Sent: Wednesday, October 26, 2016 11:22:53 AM
> Subject: [PATCH] scsi_debug: Fix memory leak if LBP enabled and module is unloaded
> 
> From: "Ewan D. Milne" <emilne@redhat.com>
> 
> map_storep was not being vfree()'d in the module_exit call.
> 
> Signed-off-by: Ewan D. Milne <emilne@redhat.com>
> ---
>  drivers/scsi/scsi_debug.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
> index c905709..cf04a36 100644
> --- a/drivers/scsi/scsi_debug.c
> +++ b/drivers/scsi/scsi_debug.c
> @@ -5134,6 +5134,7 @@ static void __exit scsi_debug_exit(void)
>  	bus_unregister(&pseudo_lld_bus);
>  	root_device_unregister(pseudo_primary);
>  
> +	vfree(map_storep);
>  	vfree(dif_storep);
>  	vfree(fake_storep);
>  	kfree(sdebug_q_arr);
> --
> 2.1.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

Looks fine
Reviewed-by: Laurence Oberman <loberman@redhat.com>
