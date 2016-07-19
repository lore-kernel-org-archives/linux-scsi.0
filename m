From: Tom Yan <tom.ty89@gmail.com>
Subject: Re: [PATCH v4] libata-scsi: minor cleanup in ata_mselect_*()
Date: Wed, 20 Jul 2016 07:03:14 +0800
Message-ID: <CAGnHSEkv2y2t3-WD_ifQMdmC8f6FxB7q+B0ReapNxN1xGuZhKA@mail.gmail.com>
References: <578e9008.4500420a.2d828.d131@mx.google.com> <578e979d.d40c620a.f5800.0924@mx.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qk0-f195.google.com ([209.85.220.195]:33270 "EHLO
	mail-qk0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752051AbcGSXDP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Jul 2016 19:03:15 -0400
In-Reply-To: <578e979d.d40c620a.f5800.0924@mx.google.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <tj@kernel.org>, Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, Tom Yan <tom.ty89@gmail.com>

Wrongly marked this as a "v4". It's actually a "v1".

On 20 July 2016 at 05:11,  <tom.ty89@gmail.com> wrote:
> From: Tom Yan <tom.ty89@gmail.com>
>
> 1. Removed a repeated bit masking in ata_mselect_control()
> 2. Moved `wce`/`d_sense` assignment below the page validity checks
> 3. Added/Removed empty lines where appropriate
>
> Signed-off-by: Tom Yan <tom.ty89@gmail.com>
>
> diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
> index b00521b..06afe63 100644
> --- a/drivers/ata/libata-scsi.c
> +++ b/drivers/ata/libata-scsi.c
> @@ -3604,7 +3604,6 @@ static int ata_mselect_caching(struct ata_queued_cmd *qc,
>          * The first two bytes of def_cache_mpage are a header, so offsets
>          * in mpage are off by 2 compared to buf.  Same for len.
>          */
> -
>         if (len != CACHE_MPAGE_LEN - 2) {
>                 if (len < CACHE_MPAGE_LEN - 2)
>                         *fp = len;
> @@ -3613,8 +3612,6 @@ static int ata_mselect_caching(struct ata_queued_cmd *qc,
>                 return -EINVAL;
>         }
>
> -       wce = buf[0] & (1 << 2);
> -
>         /*
>          * Check that read-only bits are not modified.
>          */
> @@ -3628,6 +3625,8 @@ static int ata_mselect_caching(struct ata_queued_cmd *qc,
>                 }
>         }
>
> +       wce = buf[0] & (1 << 2);
> +
>         tf->flags |= ATA_TFLAG_DEVICE | ATA_TFLAG_ISADDR;
>         tf->protocol = ATA_PROT_NODATA;
>         tf->nsect = 0;
> @@ -3660,7 +3659,6 @@ static int ata_mselect_control(struct ata_queued_cmd *qc,
>          * The first two bytes of def_control_mpage are a header, so offsets
>          * in mpage are off by 2 compared to buf.  Same for len.
>          */
> -
>         if (len != CONTROL_MPAGE_LEN - 2) {
>                 if (len < CONTROL_MPAGE_LEN - 2)
>                         *fp = len;
> @@ -3669,8 +3667,6 @@ static int ata_mselect_control(struct ata_queued_cmd *qc,
>                 return -EINVAL;
>         }
>
> -       d_sense = buf[0] & (1 << 2);
> -
>         /*
>          * Check that read-only bits are not modified.
>          */
> @@ -3683,7 +3679,10 @@ static int ata_mselect_control(struct ata_queued_cmd *qc,
>                         return -EINVAL;
>                 }
>         }
> -       if (d_sense & (1 << 2))
> +
> +       d_sense = buf[0] & (1 << 2);
> +
> +       if (d_sense)
>                 dev->flags |= ATA_DFLAG_D_SENSE;
>         else
>                 dev->flags &= ~ATA_DFLAG_D_SENSE;
> --
> 2.9.0
>
