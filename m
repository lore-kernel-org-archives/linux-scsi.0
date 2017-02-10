From: Shivasharan Srikanteshwara
        <shivasharan.srikanteshwara@broadcom.com>
Subject: RE: [PATCH v3 19/39] megaraid_sas: MR_TargetIdToLdGet u8 to u16 and
 avoid invalid raid-map access
Date: Fri, 10 Feb 2017 17:34:03 +0530
Message-ID: <389bd90e6f4a50671e69c7a76fbe9598@mail.gmail.com>
References: <1486717179-23320-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
 <1486717179-23320-20-git-send-email-shivasharan.srikanteshwara@broadcom.com> <b64c949b-dbd3-2bea-edee-b2c50f0126bd@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qk0-f182.google.com ([209.85.220.182]:33377 "EHLO
        mail-qk0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752467AbdBJMF5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 10 Feb 2017 07:05:57 -0500
Received: by mail-qk0-f182.google.com with SMTP id s140so36475643qke.0
        for <linux-scsi@vger.kernel.org>; Fri, 10 Feb 2017 04:04:05 -0800 (PST)
In-Reply-To: <b64c949b-dbd3-2bea-edee-b2c50f0126bd@suse.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.com>, linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, thenzl@redhat.com, jejb@linux.vnet.ibm.com, Kashyap Desai <kashyap.desai@broadcom.com>, Sumit Saxena <sumit.saxena@broadcom.com>

> -----Original Message-----
> From: Hannes Reinecke [mailto:hare@suse.com]
> Sent: Friday, February 10, 2017 5:05 PM
> To: Shivasharan S; linux-scsi@vger.kernel.org
> Cc: martin.petersen@oracle.com; thenzl@redhat.com;
> jejb@linux.vnet.ibm.com; kashyap.desai@broadcom.com;
> sumit.saxena@broadcom.com
> Subject: Re: [PATCH v3 19/39] megaraid_sas: MR_TargetIdToLdGet u8 to u16
> and avoid invalid raid-map access
>
> On 02/10/2017 09:59 AM, Shivasharan S wrote:
> > Change MR_TargetIdToLdGet return type from u8 to u16.
> >
> > ld id range check is added at two places in this patch -
> > @megasas_build_ldio_fusion and @megasas_build_ld_nonrw_fusion.
> > Previous driver code used different data type for lds TargetId
returned from
> MR_TargetIdToLdGet.
> > Prior to this change, above two functions was safeguarded due to
> > function always return u8 and maximum value of ld id returned was 255.
> >
> > In below check, fw_supported_vd_count as of today is 64 or 256 and
> > valid range  to support is either 0-63 or 0-255. Ideally want to
> > filter accessing raid map for ld ids which are not valid. With the u16
> > change, invalid ld id value is 0xFFFF and we will see kernel panic due
to random
> memory access in MR_LdRaidGet.
> > The changes will ensure we do not call MR_LdRaidGet if ld id is beyond
size of
> ldSpanMap array.
> >
> >                if (ld < instance->fw_supported_vd_count)
> >
> > From firmware perspective,ld id 0xFF is invalid and even though
> > current driver code forward such command, firmware fails with target
not
> available.
> >
> > ld target id issue occurs mainly whenever driver loops to populate
raid map
> (ea. MR_ValidateMapInfo).
> > These are the only two places where we may see out of range target ids
> > and wants to protect raid map access based on range provided by
Firmware
> API.
> >
> > Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
> > Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
> > ---
> >
> > fix in v2 - updated description content.
> >
> >  drivers/scsi/megaraid/megaraid_sas.h        |  2 +-
> >  drivers/scsi/megaraid/megaraid_sas_fp.c     |  5 +++--
> >  drivers/scsi/megaraid/megaraid_sas_fusion.c | 25
> > ++++++++++++++-----------
> >  3 files changed, 18 insertions(+), 14 deletions(-)
> >
> > diff --git a/drivers/scsi/megaraid/megaraid_sas.h
> > b/drivers/scsi/megaraid/megaraid_sas.h
> > index 0a20fff..efc01a3 100644
> > --- a/drivers/scsi/megaraid/megaraid_sas.h
> > +++ b/drivers/scsi/megaraid/megaraid_sas.h
> > @@ -2448,7 +2448,7 @@ MR_BuildRaidContext(struct megasas_instance
> *instance,
> >  		    struct IO_REQUEST_INFO *io_info,
> >  		    struct RAID_CONTEXT *pRAID_Context,
> >  		    struct MR_DRV_RAID_MAP_ALL *map, u8 **raidLUN);
> > -u8 MR_TargetIdToLdGet(u32 ldTgtId, struct MR_DRV_RAID_MAP_ALL *map);
> > +u16 MR_TargetIdToLdGet(u32 ldTgtId, struct MR_DRV_RAID_MAP_ALL
> *map);
> >  struct MR_LD_RAID *MR_LdRaidGet(u32 ld, struct MR_DRV_RAID_MAP_ALL
> > *map);
> >  u16 MR_ArPdGet(u32 ar, u32 arm, struct MR_DRV_RAID_MAP_ALL *map);
> >  u16 MR_LdSpanArrayGet(u32 ld, u32 span, struct MR_DRV_RAID_MAP_ALL
> > *map); diff --git a/drivers/scsi/megaraid/megaraid_sas_fp.c
> > b/drivers/scsi/megaraid/megaraid_sas_fp.c
> > index a0b0e68..9d5d485 100644
> > --- a/drivers/scsi/megaraid/megaraid_sas_fp.c
> > +++ b/drivers/scsi/megaraid/megaraid_sas_fp.c
> > @@ -165,7 +165,7 @@ u16 MR_GetLDTgtId(u32 ld, struct
> MR_DRV_RAID_MAP_ALL *map)
> >  	return le16_to_cpu(map->raidMap.ldSpanMap[ld].ldRaid.targetId);
> >  }
> >
> > -u8 MR_TargetIdToLdGet(u32 ldTgtId, struct MR_DRV_RAID_MAP_ALL *map)
> > +u16 MR_TargetIdToLdGet(u32 ldTgtId, struct MR_DRV_RAID_MAP_ALL
> *map)
> >  {
> >  	return map->raidMap.ldTgtIdToLd[ldTgtId];
> >  }
> > @@ -1151,7 +1151,7 @@ MR_BuildRaidContext(struct megasas_instance
> > *instance,  {
> >  	struct fusion_context *fusion;
> >  	struct MR_LD_RAID  *raid;
> > -	u32         ld, stripSize, stripe_mask;
> > +	u32         stripSize, stripe_mask;
> >  	u64         endLba, endStrip, endRow, start_row, start_strip;
> >  	u64         regStart;
> >  	u32         regSize;
> > @@ -1163,6 +1163,7 @@ MR_BuildRaidContext(struct megasas_instance
> *instance,
> >  	u8	    retval =3D 0;
> >  	u8	    startlba_span =3D SPAN_INVALID;
> >  	u64 *pdBlock =3D &io_info->pdBlock;
> > +	u16	    ld;
> >
> >  	ldStartBlock =3D io_info->ldStartBlock;
> >  	numBlocks =3D io_info->numBlocks;
> > diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c
> > b/drivers/scsi/megaraid/megaraid_sas_fusion.c
> > index 9019b82..4aaf307 100644
> > --- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
> > +++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
> > @@ -1121,7 +1121,8 @@ megasas_sync_map_info(struct megasas_instance
> *instance)
> >  	int i;
> >  	struct megasas_cmd *cmd;
> >  	struct megasas_dcmd_frame *dcmd;
> > -	u32 size_sync_info, num_lds;
> > +	u16 num_lds;
> > +	u32 size_sync_info;
> >  	struct fusion_context *fusion;
> >  	struct MR_LD_TARGET_SYNC *ci =3D NULL;
> >  	struct MR_DRV_RAID_MAP_ALL *map;
> > @@ -1870,7 +1871,7 @@ megasas_set_pd_lba(struct
> MPI2_RAID_SCSI_IO_REQUEST *io_request, u8 cdb_len,
> >  		   struct MR_DRV_RAID_MAP_ALL *local_map_ptr, u32 ref_tag)
> {
> >  	struct MR_LD_RAID *raid;
> > -	u32 ld;
> > +	u16 ld;
> >  	u64 start_blk =3D io_info->pdBlock;
> >  	u8 *cdb =3D io_request->CDB.CDB32;
> >  	u32 num_blocks =3D io_info->numBlocks; @@ -2303,10 +2304,11 @@
> > megasas_build_ldio_fusion(struct megasas_instance *instance,
> >
> >  	local_map_ptr =3D fusion->ld_drv_map[(instance->map_id & 1)];
> >  	ld =3D MR_TargetIdToLdGet(device_id, local_map_ptr);
> > -	raid =3D MR_LdRaidGet(ld, local_map_ptr);
> >
> > -	if ((MR_TargetIdToLdGet(device_id, local_map_ptr) >=3D
> > -		instance->fw_supported_vd_count) ||
(!fusion->fast_path_io)) {
> > +	if (ld < instance->fw_supported_vd_count)
> > +		raid =3D MR_LdRaidGet(ld, local_map_ptr);
> > +
> > +	if (!raid || (!fusion->fast_path_io)) {
> >  		io_request->RaidContext.raid_context.reg_lock_flags  =3D 0;
> >  		fp_possible =3D false;
> >  	} else {
> Is 'raid' correctly set to zero if the above condition is _not_ taken?

Hi Hannes,
'raid' is being initialized to NULL in megasas_build_ldio_fusion.
The initialization code is added in patch 2 of this series which does some
refactoring of code in this function.

-Shivasharan

>
> Cheers,
>
> Hannes
> --
> Dr. Hannes Reinecke		               zSeries & Storage
> hare@suse.com			               +49 911 74053 688
> SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
> GF: F. Imend=C3=B6rffer, J. Smithard, D. Upmanyu, G. Norton HRB 21284 (AG
> N=C3=BCrnberg)
