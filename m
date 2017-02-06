From: Hannes Reinecke <hare@suse.com>
Subject: Re: [PATCH 17/39] megaraid_sas: In validate raid map, raid capability
 is not converted to cpu format for all lds
Date: Mon, 6 Feb 2017 12:18:41 +0100
Message-ID: <8afd1c10-9e2a-a282-8bf1-eb5214a56754@suse.com>
References: <1486375212-17329-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
 <1486375212-17329-18-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.nue.novell.com ([195.135.221.5]:48919 "EHLO
        smtp.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750994AbdBFLSo (ORCPT
        <rfc822;groupwise-linux-scsi@vger.kernel.org:0:0>);
        Mon, 6 Feb 2017 06:18:44 -0500
In-Reply-To: <1486375212-17329-18-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>, linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, thenzl@redhat.com, jejb@linux.vnet.ibm.com, kashyap.desai@broadcom.com, sumit.saxena@broadcom.com

On 02/06/2017 10:59 AM, Shivasharan S wrote:
> On a host, if an ld is deleted there is a hole in the ld array returned
> by the FW. But in MR_ValidateMapInfo we are not accounting for holes in
> the ld array and traverse only upto index num_lds.
> This patch takes care of converting the capability field of all the
> valid lds in the ld raid map.
> 
> Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
> Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
> ---
>  drivers/scsi/megaraid/megaraid_sas_fp.c | 13 ++++++++++---
>  1 file changed, 10 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/scsi/megaraid/megaraid_sas_fp.c b/drivers/scsi/megaraid/megaraid_sas_fp.c
> index d9b0f28..a0b0e68 100644
> --- a/drivers/scsi/megaraid/megaraid_sas_fp.c
> +++ b/drivers/scsi/megaraid/megaraid_sas_fp.c
> @@ -452,7 +452,7 @@ u8 MR_ValidateMapInfo(struct megasas_instance *instance)
>  	struct LD_LOAD_BALANCE_INFO *lbInfo;
>  	PLD_SPAN_INFO ldSpanInfo;
>  	struct MR_LD_RAID         *raid;
> -	u16 ldCount, num_lds;
> +	u16 num_lds, i;
>  	u16 ld;
>  	u32 expected_size;
>  
> @@ -495,10 +495,17 @@ u8 MR_ValidateMapInfo(struct megasas_instance *instance)
>  	num_lds = le16_to_cpu(drv_map->raidMap.ldCount);
>  
>  	/*Convert Raid capability values to CPU arch */
> -	for (ldCount = 0; ldCount < num_lds; ldCount++) {
> -		ld = MR_TargetIdToLdGet(ldCount, drv_map);
> +	for (i = 0; (num_lds > 0) && (i < MAX_LOGICAL_DRIVES_EXT); i++) {
> +		ld = MR_TargetIdToLdGet(i, drv_map);
> +
> +		/* For non existing VDs, iterate to next VD*/
> +		if (ld >= (MAX_LOGICAL_DRIVES_EXT - 1))
> +			continue;
> +
>  		raid = MR_LdRaidGet(ld, drv_map);
>  		le32_to_cpus((u32 *)&raid->capability);
> +
> +		num_lds--;
>  	}
>  
>  	return 1;
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
