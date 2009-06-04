From: Grant Grundler <grundler@google.com>
Subject: Re: [PATCH] advansys: remove dma_cache_sync misuse
Date: Thu, 4 Jun 2009 10:26:08 -0700
Message-ID: <da824cf30906041026r5c2edf60j30cd5ee47edb7441@mail.gmail.com>
References: <20090604193240S.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.33.17]:34357 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751060AbZFDR0N convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Jun 2009 13:26:13 -0400
Received: from zps18.corp.google.com (zps18.corp.google.com [172.25.146.18])
	by smtp-out.google.com with ESMTP id n54HQAB2007479
	for <linux-scsi@vger.kernel.org>; Thu, 4 Jun 2009 18:26:10 +0100
Received: from wf-out-1314.google.com (wff29.prod.google.com [10.142.6.29])
	by zps18.corp.google.com with ESMTP id n54HQ85g008229
	for <linux-scsi@vger.kernel.org>; Thu, 4 Jun 2009 10:26:08 -0700
Received: by wf-out-1314.google.com with SMTP id 29so364289wff.32
        for <linux-scsi@vger.kernel.org>; Thu, 04 Jun 2009 10:26:08 -0700 (PDT)
In-Reply-To: <20090604193240S.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: James.Bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org, matthew@wil.cx

On Thu, Jun 4, 2009 at 3:33 AM, FUJITA Tomonori
<fujita.tomonori@lab.ntt.co.jp> wrote:
> dma_cache_sync() is supposed to be used only with
> dma_alloc_noncoherent().
>
> We don't need to call any dma_sync_ functions here too.
>
> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

Reviewed-by: Grant Grundler <grundler@google.com>

(jejb should probably also add his here too)

thanks,
grant

> ---
> =C2=A0drivers/scsi/advansys.c | =C2=A0 =C2=A02 --
> =C2=A01 files changed, 0 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
> index b756041..6b72e2d 100644
> --- a/drivers/scsi/advansys.c
> +++ b/drivers/scsi/advansys.c
> @@ -8349,8 +8349,6 @@ static __le32 advansys_get_sense_buffer_dma(str=
uct scsi_cmnd *scp)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0struct asc_board *board =3D shost_priv(scp=
->device->host);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0scp->SCp.dma_handle =3D dma_map_single(boa=
rd->dev, scp->sense_buffer,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 SCSI_SENSE_BUFFERSIZE, DMA_FROM_DEVICE);
> - =C2=A0 =C2=A0 =C2=A0 dma_cache_sync(board->dev, scp->sense_buffer,
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0SCSI_SENSE_BUFFERSIZE, DMA_FROM_DEVICE);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0return cpu_to_le32(scp->SCp.dma_handle);
> =C2=A0}
>
> --
> 1.6.0.6
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml
>
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
