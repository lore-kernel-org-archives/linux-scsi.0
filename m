From: Shaun Tancheff <shaun.tancheff@seagate.com>
Subject: Re: [PATCHv2 13/14] libata: support device-managed ZAC devices
Date: Thu, 14 Apr 2016 03:50:04 +0700
Message-ID: <CAJVOszC3WOQ+TgfyV5Z6krPtZOR1YBkS7ghtqcXr4Vt2aug9aQ@mail.gmail.com>
References: <1460443678-57934-1-git-send-email-hare@suse.de> <1460443678-57934-14-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-00003501.pphosted.com ([67.231.144.15]:37527 "EHLO
	mx0a-00003501.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752653AbcDMUu0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 13 Apr 2016 16:50:26 -0400
Received: from pps.filterd (m0075554.ppops.net [127.0.0.1])
	by mx0a-00003501.pphosted.com (8.16.0.11/8.16.0.11) with SMTP id u3DKmWim017193
	for <linux-scsi@vger.kernel.org>; Wed, 13 Apr 2016 16:50:25 -0400
Received: from mail-qk0-f199.google.com (mail-qk0-f199.google.com [209.85.220.199])
	by mx0a-00003501.pphosted.com with ESMTP id 229wf000e4-4
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Wed, 13 Apr 2016 16:50:24 -0400
Received: by mail-qk0-f199.google.com with SMTP id b131so105378091qkc.0
        for <linux-scsi@vger.kernel.org>; Wed, 13 Apr 2016 13:50:24 -0700 (PDT)
In-Reply-To: <1460443678-57934-14-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Tejun Heo <tj@kernel.org>, linux-ide@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, Damien Le Moal <damien.lemoal@hgst.com>, linux-scsi@vger.kernel.org

On Tue, Apr 12, 2016 at 1:47 PM, Hannes Reinecke <hare@suse.de> wrote:
> Device-managed ZAC devices just set the zoned capabilities field
> in INQUIRY byte 69 (cf ACS-4). This corresponds to the 'zoned'
> field in the block device characteristics VPD page.
> As this is only defined in SPC-5/SBC-4 we also need to update
> the supported SCSI version descriptor.
>
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>  drivers/ata/libata-scsi.c | 19 ++++++++++---------
>  include/linux/ata.h       |  5 +++++
>  2 files changed, 15 insertions(+), 9 deletions(-)
>
> diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
> index 5f1fc03..a92fbe9 100644
> --- a/drivers/ata/libata-scsi.c
> +++ b/drivers/ata/libata-scsi.c
> @@ -2082,14 +2082,14 @@ static unsigned int ata_scsiop_inq_std(struct ata_scsi_args *args, u8 *rbuf)
>                 0x00,
>                 0xA0,   /* SAM-5 (no version claimed) */
>
> -               0x04,
> -               0xC0,   /* SBC-3 (no version claimed) */
> +               0x06,
> +               0x00,   /* SBC-4 (no version claimed) */
>
> -               0x04,
> -               0x60,   /* SPC-4 (no version claimed) */
> +               0x05,
> +               0xC0,   /* SPC-5 (no version claimed) */
>
>                 0x60,
> -               0x20,   /* ZBC (no version claimed) */
> +               0x24,   /* ZBC r05 */
>         };
>
>         u8 hdr[] = {
> @@ -2109,10 +2109,8 @@ static unsigned int ata_scsiop_inq_std(struct ata_scsi_args *args, u8 *rbuf)
>             (args->dev->link->ap->pflags & ATA_PFLAG_EXTERNAL))
>                 hdr[1] |= (1 << 7);
>
> -       if (args->dev->class == ATA_DEV_ZAC) {
> +       if (args->dev->class == ATA_DEV_ZAC)
>                 hdr[0] = TYPE_ZBC;
> -               hdr[2] = 0x6; /* ZBC is defined in SPC-4 */
> -       }
>
>         memcpy(rbuf, hdr, sizeof(hdr));
>         memcpy(&rbuf[8], "ATA     ", 8);
> @@ -2126,7 +2124,7 @@ static unsigned int ata_scsiop_inq_std(struct ata_scsi_args *args, u8 *rbuf)
>         if (rbuf[32] == 0 || rbuf[32] == ' ')
>                 memcpy(&rbuf[32], "n/a ", 4);
>
> -       if (args->dev->class == ATA_DEV_ZAC)
> +       if (ata_id_zoned_cap(args->id) || args->dev->class == ATA_DEV_ZAC)
>                 memcpy(rbuf + 58, versions_zbc, sizeof(versions_zbc));
>         else
>                 memcpy(rbuf + 58, versions, sizeof(versions));
> @@ -2322,12 +2320,15 @@ static unsigned int ata_scsiop_inq_b1(struct ata_scsi_args *args, u8 *rbuf)
>  {
>         int form_factor = ata_id_form_factor(args->id);
>         int media_rotation_rate = ata_id_rotation_rate(args->id);
> +       u8 zoned = ata_id_zoned_cap(args->id);
>
>         rbuf[1] = 0xb1;
>         rbuf[3] = 0x3c;
>         rbuf[4] = media_rotation_rate >> 8;
>         rbuf[5] = media_rotation_rate;
>         rbuf[7] = form_factor;
> +       if (zoned)
> +               rbuf[8] = (zoned << 4);
>
>         return 0;
>  }
> diff --git a/include/linux/ata.h b/include/linux/ata.h
> index 3fb2d7d..439be2a 100644
> --- a/include/linux/ata.h
> +++ b/include/linux/ata.h
> @@ -932,6 +932,11 @@ static inline bool ata_id_is_ssd(const u16 *id)
>         return id[ATA_ID_ROT_SPEED] == 0x01;
>  }
>
> +static inline u8 ata_id_zoned_cap(const u16 *id)
> +{
> +       return (id[ATA_ID_ADDITIONAL_SUPP] & 0x3);
> +}
> +
>  static inline bool ata_id_pio_need_iordy(const u16 *id, const u8 pio)
>  {
>         /* CF spec. r4.1 Table 22 says no IORDY on PIO5 and PIO6. */
> --
> 1.8.5.6
>
This also covers Host aware zoned drives.

Reviewed-by: Shaun Tancheff <shaun.tancheff@seagate.com>
Tested-by: Shaun Tancheff <shaun.tancheff@seagate.com>

Regards,

Shaun Tancheff
