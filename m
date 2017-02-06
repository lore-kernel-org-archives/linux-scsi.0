From: Hannes Reinecke <hare@suse.com>
Subject: Re: [PATCH 18/39] megaraid_sas: MR_TargetIdToLdGet u8 to u16 and
 avoid invalid raid-map access
Date: Mon, 6 Feb 2017 12:20:43 +0100
Message-ID: <8c157e93-c67c-0678-92af-dee663ad0f0b@suse.com>
References: <1486375212-17329-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
 <1486375212-17329-19-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.nue.novell.com ([195.135.221.5]:41083 "EHLO
        smtp.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750953AbdBFLUq (ORCPT
        <rfc822;groupwise-linux-scsi@vger.kernel.org:0:0>);
        Mon, 6 Feb 2017 06:20:46 -0500
In-Reply-To: <1486375212-17329-19-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>, linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, thenzl@redhat.com, jejb@linux.vnet.ibm.com, kashyap.desai@broadcom.com, sumit.saxena@broadcom.com

On 02/06/2017 10:59 AM, Shivasharan S wrote:
> If MR_TargetIdToLdGet return >= 0xFF, it is invalid entry.
> Consider that entry as invalid and do not access raid map for further operation.
> 
> Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
> Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
> ---
>  drivers/scsi/megaraid/megaraid_sas.h        |  2 +-
>  drivers/scsi/megaraid/megaraid_sas_fp.c     |  5 +++--
>  drivers/scsi/megaraid/megaraid_sas_fusion.c | 25 ++++++++++++++-----------
>  3 files changed, 18 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/scsi/megaraid/megaraid_sas.h b/drivers/scsi/megaraid/megaraid_sas.h
> index f023e23..ec5f003 100644
> --- a/drivers/scsi/megaraid/megaraid_sas.h
> +++ b/drivers/scsi/megaraid/megaraid_sas.h
> @@ -2448,7 +2448,7 @@ MR_BuildRaidContext(struct megasas_instance *instance,
>  		    struct IO_REQUEST_INFO *io_info,
>  		    struct RAID_CONTEXT *pRAID_Context,
>  		    struct MR_DRV_RAID_MAP_ALL *map, u8 **raidLUN);
> -u8 MR_TargetIdToLdGet(u32 ldTgtId, struct MR_DRV_RAID_MAP_ALL *map);
> +u16 MR_TargetIdToLdGet(u32 ldTgtId, struct MR_DRV_RAID_MAP_ALL *map);
>  struct MR_LD_RAID *MR_LdRaidGet(u32 ld, struct MR_DRV_RAID_MAP_ALL *map);
>  u16 MR_ArPdGet(u32 ar, u32 arm, struct MR_DRV_RAID_MAP_ALL *map);
>  u16 MR_LdSpanArrayGet(u32 ld, u32 span, struct MR_DRV_RAID_MAP_ALL *map);
> diff --git a/drivers/scsi/megaraid/megaraid_sas_fp.c b/drivers/scsi/megaraid/megaraid_sas_fp.c
> index a0b0e68..9d5d485 100644
> --- a/drivers/scsi/megaraid/megaraid_sas_fp.c
> +++ b/drivers/scsi/megaraid/megaraid_sas_fp.c
> @@ -165,7 +165,7 @@ u16 MR_GetLDTgtId(u32 ld, struct MR_DRV_RAID_MAP_ALL *map)
>  	return le16_to_cpu(map->raidMap.ldSpanMap[ld].ldRaid.targetId);
>  }
>  
> -u8 MR_TargetIdToLdGet(u32 ldTgtId, struct MR_DRV_RAID_MAP_ALL *map)
> +u16 MR_TargetIdToLdGet(u32 ldTgtId, struct MR_DRV_RAID_MAP_ALL *map)
>  {
>  	return map->raidMap.ldTgtIdToLd[ldTgtId];
>  }
> @@ -1151,7 +1151,7 @@ MR_BuildRaidContext(struct megasas_instance *instance,
>  {
>  	struct fusion_context *fusion;
>  	struct MR_LD_RAID  *raid;
> -	u32         ld, stripSize, stripe_mask;
> +	u32         stripSize, stripe_mask;
>  	u64         endLba, endStrip, endRow, start_row, start_strip;
>  	u64         regStart;
>  	u32         regSize;
> @@ -1163,6 +1163,7 @@ MR_BuildRaidContext(struct megasas_instance *instance,
>  	u8	    retval = 0;
>  	u8	    startlba_span = SPAN_INVALID;
>  	u64 *pdBlock = &io_info->pdBlock;
> +	u16	    ld;
>  
>  	ldStartBlock = io_info->ldStartBlock;
>  	numBlocks = io_info->numBlocks;
> diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
> index 2f523f2..3d4d4b8 100644
> --- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
> +++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
> @@ -1120,7 +1120,8 @@ megasas_sync_map_info(struct megasas_instance *instance)
>  	int i;
>  	struct megasas_cmd *cmd;
>  	struct megasas_dcmd_frame *dcmd;
> -	u32 size_sync_info, num_lds;
> +	u16 num_lds;
> +	u32 size_sync_info;
>  	struct fusion_context *fusion;
>  	struct MR_LD_TARGET_SYNC *ci = NULL;
>  	struct MR_DRV_RAID_MAP_ALL *map;
> @@ -1867,7 +1868,7 @@ megasas_set_pd_lba(struct MPI2_RAID_SCSI_IO_REQUEST *io_request, u8 cdb_len,
>  		   struct MR_DRV_RAID_MAP_ALL *local_map_ptr, u32 ref_tag)
>  {
>  	struct MR_LD_RAID *raid;
> -	u32 ld;
> +	u16 ld;
>  	u64 start_blk = io_info->pdBlock;
>  	u8 *cdb = io_request->CDB.CDB32;
>  	u32 num_blocks = io_info->numBlocks;
> @@ -2300,10 +2301,11 @@ megasas_build_ldio_fusion(struct megasas_instance *instance,
>  
>  	local_map_ptr = fusion->ld_drv_map[(instance->map_id & 1)];
>  	ld = MR_TargetIdToLdGet(device_id, local_map_ptr);
> -	raid = MR_LdRaidGet(ld, local_map_ptr);
>  
> -	if ((MR_TargetIdToLdGet(device_id, local_map_ptr) >=
> -		instance->fw_supported_vd_count) || (!fusion->fast_path_io)) {
> +	if (ld < instance->fw_supported_vd_count)
> +		raid = MR_LdRaidGet(ld, local_map_ptr);
> +
> +	if (!raid || (!fusion->fast_path_io)) {
>  		io_request->RaidContext.raid_context.reg_lock_flags  = 0;
>  		fp_possible = false;
>  	} else {
> @@ -2475,12 +2477,12 @@ static void megasas_build_ld_nonrw_fusion(struct megasas_instance *instance,
>  {
>  	u32 device_id;
>  	struct MPI2_RAID_SCSI_IO_REQUEST *io_request;
> -	u16 pd_index = 0;
> +	u16 pd_index = 0, ld;
>  	struct MR_DRV_RAID_MAP_ALL *local_map_ptr;
>  	struct fusion_context *fusion = instance->ctrl_context;
>  	u8                          span, physArm;
>  	__le16                      devHandle;
> -	u32                         ld, arRef, pd;
> +	u32                         arRef, pd;
>  	struct MR_LD_RAID                  *raid;
>  	struct RAID_CONTEXT                *pRAID_Context;
>  	u8 fp_possible = 1;
> @@ -2503,10 +2505,11 @@ static void megasas_build_ld_nonrw_fusion(struct megasas_instance *instance,
>  		ld = MR_TargetIdToLdGet(device_id, local_map_ptr);
>  		if (ld >= instance->fw_supported_vd_count)
>  			fp_possible = 0;
> -
> -		raid = MR_LdRaidGet(ld, local_map_ptr);
> -		if (!(raid->capability.fpNonRWCapable))
> -			fp_possible = 0;
> +		else {
> +			raid = MR_LdRaidGet(ld, local_map_ptr);
> +			if (!(raid->capability.fpNonRWCapable))
> +				fp_possible = 0;
> +		}
>  	} else
>  		fp_possible = 0;
>  
> 
I must be missing something obvious.
Where do you actually _check_ for 0xFF in the patches?
The descriptions doesn't really match the patch itself AFAICS...

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.com			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
