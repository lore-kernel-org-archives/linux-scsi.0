From: James Smart <james.smart@avagotech.com>
Subject: Re: [PATCH] lpfc: Destroy lpfc_hba_index IDR on module exit
Date: Fri, 10 Jul 2015 08:33:50 -0400
Message-ID: <559FBBAE.1030809@avagotech.com>
References: <1436368797-30934-1-git-send-email-jthumshirn@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qg0-f41.google.com ([209.85.192.41]:33077 "EHLO
	mail-qg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753915AbbGJMdy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 10 Jul 2015 08:33:54 -0400
Received: by qgef3 with SMTP id f3so78515234qge.0
        for <linux-scsi@vger.kernel.org>; Fri, 10 Jul 2015 05:33:53 -0700 (PDT)
In-Reply-To: <1436368797-30934-1-git-send-email-jthumshirn@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>, Dick Kennedy <dick.kennedy@avagotech.com>, "James E.J. Bottomley" <JBottomley@odin.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

Reviewed-By:  James Smart <james.smart@avagotech.com>

-- james s


On 7/8/2015 11:19 AM, Johannes Thumshirn wrote:
> Destroy lpfc_hba_index IDR on module exit, reclaiming the allocated memory.
>
> This was detected by the following semantic patch (written by Luis Rodriguez
> <mcgrof@suse.com>)
> <SmPL>
> @ defines_module_init @
> declarer name module_init, module_exit;
> declarer name DEFINE_IDR;
> identifier init;
> @@
>
> module_init(init);
>
> @ defines_module_exit @
> identifier exit;
> @@
>
> module_exit(exit);
>
> @ declares_idr depends on defines_module_init && defines_module_exit @
> identifier idr;
> @@
>
> DEFINE_IDR(idr);
>
> @ on_exit_calls_destroy depends on declares_idr && defines_module_exit @
> identifier declares_idr.idr, defines_module_exit.exit;
> @@
>
> exit(void)
> {
>   ...
>   idr_destroy(&idr);
>   ...
> }
>
> @ missing_module_idr_destroy depends on declares_idr && defines_module_exit && !on_exit_calls_destroy @
> identifier declares_idr.idr, defines_module_exit.exit;
> @@
>
> exit(void)
> {
>   ...
>   +idr_destroy(&idr);
> }
> </SmPL>
>
> Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
> ---
>   drivers/scsi/lpfc/lpfc_init.c | 1 +
>   1 file changed, 1 insertion(+)
>
> diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
> index f962118..4bedb06 100644
> --- a/drivers/scsi/lpfc/lpfc_init.c
> +++ b/drivers/scsi/lpfc/lpfc_init.c
> @@ -11477,6 +11477,7 @@ lpfc_exit(void)
>   		free_pages((unsigned long)_dump_buf_dif, _dump_buf_dif_order);
>   	}
>   	kfree(lpfc_used_cpu);
> +	idr_destroy(&lpfc_hba_index);
>   }
>   
>   module_init(lpfc_init);

