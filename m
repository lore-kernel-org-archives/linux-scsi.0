From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Subject: Re: [PATCHv3 13/14] libata: support device-managed ZAC devices
Date: Mon, 25 Apr 2016 15:17:16 +0300
Message-ID: <c14d4d8f-4d8f-9c8e-a00c-5cb5010bb66f@cogentembedded.com>
References: <1461581156-92581-1-git-send-email-hare@suse.de>
 <1461581156-92581-14-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-lf0-f47.google.com ([209.85.215.47]:34612 "EHLO
	mail-lf0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932346AbcDYMRU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 25 Apr 2016 08:17:20 -0400
Received: by mail-lf0-f47.google.com with SMTP id j11so115419332lfb.1
        for <linux-scsi@vger.kernel.org>; Mon, 25 Apr 2016 05:17:19 -0700 (PDT)
In-Reply-To: <1461581156-92581-14-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, Tejun Heo <tj@kernel.org>
Cc: linux-ide@vger.kernel.org, Shaun Tancheff <shaun.tancheff@seagate.com>, Damien Le Moal <damien.lemoal@hgst.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org

Hello.

On 4/25/2016 1:45 PM, Hannes Reinecke wrote:

> Device-managed ZAC devices just set the zoned capabilities field
> in INQUIRY byte 69 (cf ACS-4). This corresponds to the 'zoned'
> field in the block device characteristics VPD page.
> As this is only defined in SPC-5/SBC-4 we also need to update
> the supported SCSI version descriptor.
>
> Reviewed-by: Shaun Tancheff <shaun.tancheff@seagate.com>
> Tested-by: Shaun Tancheff <shaun.tancheff@seagate.com>
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>  drivers/ata/libata-scsi.c | 19 ++++++++++---------
>  include/linux/ata.h       |  5 +++++
>  2 files changed, 15 insertions(+), 9 deletions(-)
>
> diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
> index 43403aa..96abd42 100644
> --- a/drivers/ata/libata-scsi.c
> +++ b/drivers/ata/libata-scsi.c
[...]
> @@ -2322,12 +2320,15 @@ static unsigned int ata_scsiop_inq_b1(struct ata_scsi_args *args, u8 *rbuf)
>  {
>  	int form_factor = ata_id_form_factor(args->id);
>  	int media_rotation_rate = ata_id_rotation_rate(args->id);
> +	u8 zoned = ata_id_zoned_cap(args->id);
>
>  	rbuf[1] = 0xb1;
>  	rbuf[3] = 0x3c;
>  	rbuf[4] = media_rotation_rate >> 8;
>  	rbuf[5] = media_rotation_rate;
>  	rbuf[7] = form_factor;
> +	if (zoned)
> +		rbuf[8] = (zoned << 4);

    Parens not needed here...

[...]
> diff --git a/include/linux/ata.h b/include/linux/ata.h
> index e627032..ac1cb93 100644
> --- a/include/linux/ata.h
> +++ b/include/linux/ata.h
> @@ -935,6 +935,11 @@ static inline bool ata_id_is_ssd(const u16 *id)
>  	return id[ATA_ID_ROT_SPEED] == 0x01;
>  }
>
> +static inline u8 ata_id_zoned_cap(const u16 *id)
> +{
> +	return (id[ATA_ID_ADDITIONAL_SUPP] & 0x3);

    And here as well...

[...]

MBR, Sergei

