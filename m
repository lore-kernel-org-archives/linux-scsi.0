From: Hannes Reinecke <hare@suse.com>
Subject: Re: [PATCH 31/39] megaraid_sas: Change build_mpt_mfi_pass_thru to
 return void
Date: Mon, 6 Feb 2017 12:27:20 +0100
Message-ID: <c20b15e2-5f1c-b647-bb77-3864ce168658@suse.com>
References: <1486375212-17329-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
 <1486375212-17329-32-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.nue.novell.com ([195.135.221.5]:35851 "EHLO
        smtp.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750994AbdBFL1X (ORCPT
        <rfc822;groupwise-linux-scsi@vger.kernel.org:0:0>);
        Mon, 6 Feb 2017 06:27:23 -0500
In-Reply-To: <1486375212-17329-32-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>, linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, thenzl@redhat.com, jejb@linux.vnet.ibm.com, kashyap.desai@broadcom.com, sumit.saxena@broadcom.com

On 02/06/2017 11:00 AM, Shivasharan S wrote:
> Code refactoring to build_mpt_mfi_pass_thru to return void.
> 
> Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
> Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
> ---
>  drivers/scsi/megaraid/megaraid_sas_fusion.c | 10 ++--------
>  1 file changed, 2 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
> index 9f3cbaa..8edb6ba 100644
> --- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
> +++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
> @@ -3225,7 +3225,7 @@ irqreturn_t megasas_isr_fusion(int irq, void *devp)
>   * mfi_cmd:			megasas_cmd pointer
>   *
>   */
> -u8
> +void
>  build_mpt_mfi_pass_thru(struct megasas_instance *instance,
>  			struct megasas_cmd *mfi_cmd)
>  {
> @@ -3275,8 +3275,6 @@ build_mpt_mfi_pass_thru(struct megasas_instance *instance,
>  		MPI2_IEEE_SGE_FLAGS_IOCPLBNTA_ADDR;
>  
>  	mpi25_ieee_chain->Length = cpu_to_le32(instance->max_chain_frame_sz);
> -
> -	return 0;
>  }
>  
>  /**
> @@ -3291,11 +3289,7 @@ build_mpt_cmd(struct megasas_instance *instance, struct megasas_cmd *cmd)
>  	union MEGASAS_REQUEST_DESCRIPTOR_UNION *req_desc = NULL;
>  	u16 index;
>  
> -	if (build_mpt_mfi_pass_thru(instance, cmd)) {
> -		dev_err(&instance->pdev->dev, "Couldn't build MFI pass thru cmd\n");
> -		return NULL;
> -	}
> -
> +	build_mpt_mfi_pass_thru(instance, cmd);
>  	index = cmd->context.smid;
>  
>  	req_desc = megasas_get_request_descriptor(instance, index - 1);
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
