From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 1/2] megaraid_sas: Add High Availability clustering
 support using shared Logical Disks
Date: Fri, 06 Sep 2013 11:34:06 -0700
Message-ID: <1378492446.2063.28.camel@dabdike.int.hansenpartnership.com>
References: <CAHtARFGNHZ4u8bKksuRDUokNkxrM3sRXV0woy-Rshang3tpUBA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:51538 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750708Ab3IFSeK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Sep 2013 14:34:10 -0400
In-Reply-To: <CAHtARFGNHZ4u8bKksuRDUokNkxrM3sRXV0woy-Rshang3tpUBA@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: adam radford <aradford@gmail.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Kashyap Desai <Kashyap.Desai@lsi.com>

On Sat, 2013-08-31 at 16:54 -0700, adam radford wrote:
> --- scsi-misc.old/drivers/scsi/megaraid/megaraid_sas_fusion.c
> 2013-08-31 16:17:56.909172648 -0700
> +++ scsi-misc.new/drivers/scsi/megaraid/megaraid_sas_fusion.c
> 2013-08-31 16:24:51.861078589 -0700
> @@ -77,9 +77,12 @@
>  MR_BuildRaidContext(struct megasas_instance *instance,
>      struct IO_REQUEST_INFO *io_info,
>      struct RAID_CONTEXT *pRAID_Context,
> -    struct MR_FW_RAID_MAP_ALL *map);
> +    struct MR_FW_RAID_MAP_ALL *map, u8 **raidLUN);
>  u16 MR_TargetIdToLdGet(u32 ldTgtId, struct MR_FW_RAID_MAP_ALL *map);
>  struct MR_LD_RAID *MR_LdRaidGet(u32 ld, struct MR_FW_RAID_MAP_ALL *map);
> +u16 MR_ArPdGet(u32 ar, u32 arm, struct MR_FW_RAID_MAP_ALL *map);
> +u16 MR_LdSpanArrayGet(u32 ld, u32 span, struct MR_FW_RAID_MAP_ALL *map);
> +u16 MR_PdDevHandleGet(u32 pd, struct MR_FW_RAID_MAP_ALL *map);
> 
>  u16 MR_GetLDTgtId(u32 ld, struct MR_FW_RAID_MAP_ALL *map);

Checkpatch doesn't like this.  It thinks (correctly) that these should
all be in megaraid_sas.h so we can't get the prototype different from
the actual function without some type of warning.  Can you move them,
please?

Thanks,

James


