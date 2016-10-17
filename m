From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 2/7] megaraid_sas: Send correct PhysArm to FW for R1 VD
 downgrade
Date: Mon, 17 Oct 2016 13:29:31 +0200
Message-ID: <d0d7c9f2-da02-ce01-f4ed-ab24da6085da@suse.de>
References: <1476699850-25083-1-git-send-email-sumit.saxena@broadcom.com>
 <1476699850-25083-3-git-send-email-sumit.saxena@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33771 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933351AbcJQL3d (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 17 Oct 2016 07:29:33 -0400
In-Reply-To: <1476699850-25083-3-git-send-email-sumit.saxena@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sumit Saxena <sumit.saxena@broadcom.com>, linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, thenzl@redhat.com, jejb@linux.vnet.ibm.com, kashyap.desai@broadcom.com, Kiran Kumar Kasturi <kiran-kumar.kasturi@broadcom.com>

On 10/17/2016 12:24 PM, Sumit Saxena wrote:
> This patch fixes the issue of wrong PhysArm was sent to firmware for R1
> VD downgrade.
> 
> Signed-off-by: Kiran Kumar Kasturi <kiran-kumar.kasturi@broadcom.com>
> Signed-off-by: Sumit Saxena <sumit.saxena@broadcom.com>
> ---
>  drivers/scsi/megaraid/megaraid_sas_fp.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/megaraid/megaraid_sas_fp.c b/drivers/scsi/megaraid/megaraid_sas_fp.c
> index e413113..f237d00 100644
> --- a/drivers/scsi/megaraid/megaraid_sas_fp.c
> +++ b/drivers/scsi/megaraid/megaraid_sas_fp.c
> @@ -782,7 +782,8 @@ static u8 mr_spanset_get_phy_params(struct megasas_instance *instance, u32 ld,
>  			(raid->regTypeReqOnRead != REGION_TYPE_UNUSED))))
>  			pRAID_Context->regLockFlags = REGION_TYPE_EXCLUSIVE;
>  		else if (raid->level == 1) {
> -			pd = MR_ArPdGet(arRef, physArm + 1, map);
> +			physArm = physArm + 1;
> +			pd = MR_ArPdGet(arRef, physArm, map);
>  			if (pd != MR_PD_INVALID)
>  				*pDevHandle = MR_PdDevHandleGet(pd, map);
>  		}
> @@ -879,7 +880,8 @@ u8 MR_GetPhyParams(struct megasas_instance *instance, u32 ld, u64 stripRow,
>  			pRAID_Context->regLockFlags = REGION_TYPE_EXCLUSIVE;
>  		else if (raid->level == 1) {
>  			/* Get alternate Pd. */
> -			pd = MR_ArPdGet(arRef, physArm + 1, map);
> +			physArm = physArm + 1;
> +			pd = MR_ArPdGet(arRef, physArm, map);
>  			if (pd != MR_PD_INVALID)
>  				/* Get dev handle from Pd */
>  				*pDevHandle = MR_PdDevHandleGet(pd, map);
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
