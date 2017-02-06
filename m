From: Hannes Reinecke <hare@suse.com>
Subject: Re: [PATCH 06/39] megaraid_sas: RAID map is accessed for SYS PDs when
 use_seqnum_jbod_fp is not set
Date: Mon, 6 Feb 2017 11:40:48 +0100
Message-ID: <50d9298c-1f4e-9f4c-b5dd-61bca957c76f@suse.com>
References: <1486375212-17329-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
 <1486375212-17329-7-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.nue.novell.com ([195.135.221.5]:53469 "EHLO
        smtp.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750937AbdBFKkw (ORCPT
        <rfc822;groupwise-linux-scsi@vger.kernel.org:0:0>);
        Mon, 6 Feb 2017 05:40:52 -0500
In-Reply-To: <1486375212-17329-7-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>, linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, thenzl@redhat.com, jejb@linux.vnet.ibm.com, kashyap.desai@broadcom.com, sumit.saxena@broadcom.com

On 02/06/2017 10:59 AM, Shivasharan S wrote:
> Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
> Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
> ---
>  drivers/scsi/megaraid/megaraid_sas_base.c | 25 ++++++++++++++-----------
>  1 file changed, 14 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
> index 6ca49ef..67a205a 100644
> --- a/drivers/scsi/megaraid/megaraid_sas_base.c
> +++ b/drivers/scsi/megaraid/megaraid_sas_base.c
> @@ -1756,28 +1756,31 @@ void megasas_update_sdev_properties(struct scsi_device *sdev)
>  	fusion = instance->ctrl_context;
>  	mr_device_priv_data = sdev->hostdata;
>  
> -	if (!fusion)
> +	if (!fusion || !mr_device_priv_data)
>  		return;
>  
> -	if (!MEGASAS_IS_LOGICAL(sdev) &&
> -		instance->use_seqnum_jbod_fp) {
> -		pd_index = (sdev->channel * MEGASAS_MAX_DEV_PER_CHANNEL) +
> -			sdev->id;
> -		pd_sync = (void *)fusion->pd_seq_sync
> -				[(instance->pd_seq_map_id - 1) & 1];
> -		mr_device_priv_data->is_tm_capable =
> -			pd_sync->seq[pd_index].capability.tmCapable;
> -	} else {
> +	if (MEGASAS_IS_LOGICAL(sdev)) {
>  		device_id = ((sdev->channel % 2) * MEGASAS_MAX_DEV_PER_CHANNEL)
>  					+ sdev->id;
>  		local_map_ptr = fusion->ld_drv_map[(instance->map_id & 1)];
>  		ld = MR_TargetIdToLdGet(device_id, local_map_ptr);
> +		if (ld >= instance->fw_supported_vd_count)
> +			return;
>  		raid = MR_LdRaidGet(ld, local_map_ptr);
>  
>  		if (raid->capability.ldPiMode == MR_PROT_INFO_TYPE_CONTROLLER)
> -		blk_queue_update_dma_alignment(sdev->request_queue, 0x7);
> +			blk_queue_update_dma_alignment(sdev->request_queue,
> +						       0x7);
> +
>  		mr_device_priv_data->is_tm_capable =
>  			raid->capability.tmCapable;
> +	} else if (instance->use_seqnum_jbod_fp) {
> +		pd_index = (sdev->channel * MEGASAS_MAX_DEV_PER_CHANNEL) +
> +				sdev->id;
> +		pd_sync = (void *)fusion->pd_seq_sync
> +				[(instance->pd_seq_map_id - 1) & 1];
> +		mr_device_priv_data->is_tm_capable =
> +				pd_sync->seq[pd_index].capability.tmCapable;
>  	}
>  }
>  
> 
Don't you need a sanity check on pd_index, too?
Otherwise you easily overflow the ->seq array ...

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.com			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
