From: Hannes Reinecke <hare@suse.com>
Subject: Re: [PATCH 26/39] megaraid_sas: max_fw_cmds are decremented twice,
 remove duplicate
Date: Mon, 6 Feb 2017 12:24:48 +0100
Message-ID: <eae6f070-8659-42c8-d7d8-9ad2983dbcec@suse.com>
References: <1486375212-17329-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
 <1486375212-17329-27-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.nue.novell.com ([195.135.221.5]:58919 "EHLO
        smtp.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751901AbdBFLYv (ORCPT
        <rfc822;groupwise-linux-scsi@vger.kernel.org:0:0>);
        Mon, 6 Feb 2017 06:24:51 -0500
In-Reply-To: <1486375212-17329-27-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>, linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, thenzl@redhat.com, jejb@linux.vnet.ibm.com, kashyap.desai@broadcom.com, sumit.saxena@broadcom.com

On 02/06/2017 10:59 AM, Shivasharan S wrote:
> Fix to account for the reply_q_sz not exceeding
> the maximum commands that the firmware can support,
> instance->max_fw_cmds is already decremented in
> megasas_fusion_update_can_queue().
> Remove the extra decrement logic in code.
> 
> Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
> Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
> ---
>  drivers/scsi/megaraid/megaraid_sas_fusion.c | 7 -------
>  1 file changed, 7 deletions(-)
> 
> diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
> index 2bfdf6b..e74cbe6d 100644
> --- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
> +++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
> @@ -1282,13 +1282,6 @@ megasas_init_adapter_fusion(struct megasas_instance *instance)
>  	megasas_fusion_update_can_queue(instance, PROBE_CONTEXT);
>  
>  	/*
> -	 * Reduce the max supported cmds by 1. This is to ensure that the
> -	 * reply_q_sz (1 more than the max cmd that driver may send)
> -	 * does not exceed max cmds that the FW can support
> -	 */
> -	instance->max_fw_cmds = instance->max_fw_cmds-1;
> -
> -	/*
>  	 * Only Driver's internal DCMDs and IOCTL DCMDs needs to have MFI frames
>  	 */
>  	instance->max_mfi_cmds =
> 
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.com			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
