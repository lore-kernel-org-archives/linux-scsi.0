From: Kashyap Desai <kashyap.desai@avagotech.com>
Subject: RE: [PATCH] megaraid_sas: boot hangs while LD is offline
Date: Mon, 18 Jan 2016 11:18:14 +0530
Message-ID: <4e96fb90476261bae709ac7abfe21e93@mail.gmail.com>
References: <1452865396-9887-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-lb0-f170.google.com ([209.85.217.170]:35926 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751416AbcARFsQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Jan 2016 00:48:16 -0500
Received: by mail-lb0-f170.google.com with SMTP id oh2so341585410lbb.3
        for <linux-scsi@vger.kernel.org>; Sun, 17 Jan 2016 21:48:16 -0800 (PST)
In-Reply-To: <1452865396-9887-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, Sumit Saxena <sumit.saxena@avagotech.com>
Cc: "PDL,MEGARAIDLINUX" <megaraidlinux.pdl@avagotech.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>

> -----Original Message-----
> From: Hannes Reinecke [mailto:hare@suse.de]
> Sent: Friday, January 15, 2016 7:13 PM
> To: Sumit Saxena
> Cc: Kashyap Desai; megaraidlinux.pdl@avagotech.com; Martin K. Petersen;
> James Bottomley; linux-scsi@vger.kernel.org; Hannes Reinecke; Hannes
> Reinecke
> Subject: [PATCH] megaraid_sas: boot hangs while LD is offline
>
> Offline Logical drives (LDs) should not allowed to be visible to the OS,
as the
> OS will hang trying to send commands to it.
> This patch skips offline LDs like it already does for non-system
physical
> drives (PDs).
>
> Signed-off-by: Hannes Reinecke <hare@suse.com>
> ---
>  drivers/scsi/megaraid/megaraid_sas_base.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c
> b/drivers/scsi/megaraid/megaraid_sas_base.c
> index 97a1c1c..f32831b 100644
> --- a/drivers/scsi/megaraid/megaraid_sas_base.c
> +++ b/drivers/scsi/megaraid/megaraid_sas_base.c
> @@ -1760,7 +1760,7 @@ static void megasas_set_dma_alignment(struct
> scsi_device *sdev)
>
>  static int megasas_slave_configure(struct scsi_device *sdev)  {
> -	u16 pd_index = 0;
> +	u16 pd_index = 0, ld_index;
>  	struct megasas_instance *instance;
>
>  	instance = megasas_lookup_instance(sdev->host->host_no);
> @@ -1772,6 +1772,11 @@ static int megasas_slave_configure(struct
> scsi_device *sdev)
>  			if (instance->pd_list[pd_index].driveState !=
>  				MR_PD_STATE_SYSTEM)
>  				return -ENXIO;
> +		} else {
> +			ld_index = ((sdev->channel -
> MEGASAS_MAX_PD_CHANNELS) *
> +				    MEGASAS_MAX_DEV_PER_CHANNEL) +
> sdev->id;
> +			if (instance->ld_ids[ld_index] == 0xff)
> +				return -ENXIO;

Hannes - We attempted this code change for one of the issue in past. This
code drop was just a quick workaround to unblock that customer issue.
Avago provided FW fix for this issue as new FW (again fix was done 2 years
before, so many latest FW will have this fix) return below sense key for
TUR.
SenseKey=0x2, asc=0x4, ascq=0x3(LOGICAL UNIT NOT READY, MANUAL
INTERVENTION REQUIRED)

Have you seen any issue w.r.t VD Offline or trying to optimize code in
megaraid driver ?

>  		}
>  	}
>  	megasas_set_dma_alignment(sdev);
> --
> 1.8.5.6
