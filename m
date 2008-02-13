From: "Salyzyn, Mark" <Mark_Salyzyn@adaptec.com>
Subject: RE: [PATCH] scsi: le*_add_cpu conversion
Date: Wed, 13 Feb 2008 06:06:22 -0800
Message-ID: <532ABFBDAAC3A34EB12EBA6CEC2838F439963FA2@ADPE2K703.adaptec.com>
References: <1202857582-15450-1-git-send-email-marcin.slusarz@gmail.com>
 <1202857582-15450-9-git-send-email-marcin.slusarz@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gw3.adaptec.com ([162.62.93.58]:51995 "EHLO
	mail-gw3.adaptec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752759AbYBMOGZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Feb 2008 09:06:25 -0500
In-Reply-To: <1202857582-15450-9-git-send-email-marcin.slusarz@gmail.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "marcin.slusarz@gmail.com" <marcin.slusarz@gmail.com>, LKML <linux-kernel@vger.kernel.org>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>

ACK

Sincerely -- Mark Salyzyn

> -----Original Message-----
> From: marcin.slusarz@gmail.com [mailto:marcin.slusarz@gmail.com]
> Sent: Tuesday, February 12, 2008 6:06 PM
> To: LKML
> Cc: Marcin Slusarz; linux-scsi@vger.kernel.org; AACRAID;
> James.Bottomley@HansenPartnership.com
> Subject: [PATCH] scsi: le*_add_cpu conversion
>
> From: Marcin Slusarz <marcin.slusarz@gmail.com>
>
> replace all:
> little_endian_variable =
> cpu_to_leX(leX_to_cpu(little_endian_variable) +
>                                         expression_in_cpu_byteorder);
> with:
>         leX_add_cpu(&little_endian_variable,
> expression_in_cpu_byteorder);
> generated with semantic patch
>
> Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
> Cc: linux-scsi@vger.kernel.org
> Cc: aacraid@adaptec.com
> Cc: James.Bottomley@HansenPartnership.com
> ---
>  drivers/scsi/aacraid/commsup.c |    2 +-
>  drivers/scsi/ips.c             |    8 ++------
>  2 files changed, 3 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/scsi/aacraid/commsup.c
> b/drivers/scsi/aacraid/commsup.c
> index 81b3692..3ac8c82 100644
> --- a/drivers/scsi/aacraid/commsup.c
> +++ b/drivers/scsi/aacraid/commsup.c
> @@ -594,7 +594,7 @@ void aac_consumer_free(struct aac_dev *
> dev, struct aac_queue *q, u32 qid)
>         if (le32_to_cpu(*q->headers.consumer) >= q->entries)
>                 *q->headers.consumer = cpu_to_le32(1);
>         else
> -               *q->headers.consumer =
> cpu_to_le32(le32_to_cpu(*q->headers.consumer)+1);
> +               le32_add_cpu(q->headers.consumer, 1);
>
>         if (wasfull) {
>                 switch (qid) {
> diff --git a/drivers/scsi/ips.c b/drivers/scsi/ips.c
> index bb152fb..f45770a 100644
> --- a/drivers/scsi/ips.c
> +++ b/drivers/scsi/ips.c
> @@ -3696,9 +3696,7 @@ ips_send_cmd(ips_ha_t * ha, ips_scb_t * scb)
>                         scb->cmd.basic_io.sg_count = scb->sg_len;
>
>                         if (scb->cmd.basic_io.lba)
> -                               scb->cmd.basic_io.lba =
> -                                   cpu_to_le32(le32_to_cpu
> -
> (scb->cmd.basic_io.lba) +
> +                               le32_add_cpu(&scb->cmd.basic_io.lba,
>
> le16_to_cpu(scb->cmd.basic_io.
>
> sector_count));
>                         else
> @@ -3744,9 +3742,7 @@ ips_send_cmd(ips_ha_t * ha, ips_scb_t * scb)
>                         scb->cmd.basic_io.sg_count = scb->sg_len;
>
>                         if (scb->cmd.basic_io.lba)
> -                               scb->cmd.basic_io.lba =
> -                                   cpu_to_le32(le32_to_cpu
> -
> (scb->cmd.basic_io.lba) +
> +                               le32_add_cpu(&scb->cmd.basic_io.lba,
>
> le16_to_cpu(scb->cmd.basic_io.
>
> sector_count));
>                         else
> --
> 1.5.3.7
