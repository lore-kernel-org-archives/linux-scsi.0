From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 03/15] megaraid_sas: Use synchronize_irq in target reset
 case
Date: Fri, 30 Jun 2017 15:24:39 +0200
Message-ID: <69030a99-9f77-99b4-81d5-8586c1704a64@suse.de>
References: <1498811409-11157-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
 <1498811409-11157-4-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35114 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752037AbdF3NYm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 30 Jun 2017 09:24:42 -0400
In-Reply-To: <1498811409-11157-4-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>, linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, thenzl@redhat.com, jejb@linux.vnet.ibm.com, kashyap.desai@broadcom.com, sumit.saxena@broadcom.com, hare@suse.com, hch@lst.de

On 06/30/2017 10:29 AM, Shivasharan S wrote:
> Similar to task abort case, use synchronize_irq API in target reset case.
> Also, remove redundant call to megasas_complete_cmd_dpc_fusion
> after calling megasas_sync_irqs in task abort case.
> 
> Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
> Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
> ---
>  drivers/scsi/megaraid/megaraid_sas_fusion.c | 6 +-----
>  1 file changed, 1 insertion(+), 5 deletions(-)
> 
> diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
> index f717fbc..5018a3f 100644
> --- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
> +++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
> @@ -3826,8 +3826,6 @@ megasas_issue_tm(struct megasas_instance *instance, u16 device_handle,
>  		else {
>  			instance->instancet->disable_intr(instance);
>  			megasas_sync_irqs((unsigned long)instance);
> -			megasas_complete_cmd_dpc_fusion
> -					((unsigned long)instance);
>  			instance->instancet->enable_intr(instance);
>  			if (scsi_lookup->scmd == NULL)
>  				break;
> @@ -3839,9 +3837,7 @@ megasas_issue_tm(struct megasas_instance *instance, u16 device_handle,
>  		if ((channel == 0xFFFFFFFF) && (id == 0xFFFFFFFF))
>  			break;
>  		instance->instancet->disable_intr(instance);
> -		msleep(1000);
> -		megasas_complete_cmd_dpc_fusion
> -				((unsigned long)instance);
> +		megasas_sync_irqs((unsigned long)instance);
>  		rc = megasas_track_scsiio(instance, id, channel);
>  		instance->instancet->enable_intr(instance);
>  
> 
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
