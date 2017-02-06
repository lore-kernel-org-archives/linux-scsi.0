From: Hannes Reinecke <hare@suse.com>
Subject: Re: [PATCH 25/39] megaraid_sas: update can_queue only if the new
 value is less
Date: Mon, 6 Feb 2017 12:24:21 +0100
Message-ID: <ce9b0342-92f8-e135-d48d-c6c1aedd093a@suse.com>
References: <1486375212-17329-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
 <1486375212-17329-26-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.nue.novell.com ([195.135.221.5]:37305 "EHLO
        smtp.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751214AbdBFLYa (ORCPT
        <rfc822;groupwise-linux-scsi@vger.kernel.org:0:0>);
        Mon, 6 Feb 2017 06:24:30 -0500
In-Reply-To: <1486375212-17329-26-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>, linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, thenzl@redhat.com, jejb@linux.vnet.ibm.com, kashyap.desai@broadcom.com, sumit.saxena@broadcom.com

On 02/06/2017 10:59 AM, Shivasharan S wrote:
> Minor Optimization: No need to update HBA can_queue value
> if the current max FW commands is equal to earlier value.
> 
> Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
> Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
> ---
>  drivers/scsi/megaraid/megaraid_sas_fusion.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
> index 22965b6..2bfdf6b 100644
> --- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
> +++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
> @@ -259,7 +259,7 @@ megasas_fusion_update_can_queue(struct megasas_instance *instance, int fw_boot_c
>  
>  	if (fw_boot_context == OCR_CONTEXT) {
>  		cur_max_fw_cmds = cur_max_fw_cmds - 1;
> -		if (cur_max_fw_cmds <= instance->max_fw_cmds) {
> +		if (cur_max_fw_cmds < instance->max_fw_cmds) {
>  			instance->cur_can_queue =
>  				cur_max_fw_cmds - (MEGASAS_FUSION_INTERNAL_CMDS +
>  						MEGASAS_FUSION_IOCTL_CMDS);
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
