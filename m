From: Borislav Petkov <petkovbb@googlemail.com>
Subject: Re: [PATCH v2 -mm 4/6] ide: avoid DMA on the stack for
	REQ_TYPE_ATA_PC
Date: Mon, 2 Jun 2008 21:14:10 +0200
Message-ID: <20080602191410.GA15555@gollum.tnic>
References: <1212389852-1277-1-git-send-email-fujita.tomonori@lab.ntt.co.jp> <1212389852-1277-2-git-send-email-fujita.tomonori@lab.ntt.co.jp> <1212389852-1277-3-git-send-email-fujita.tomonori@lab.ntt.co.jp> <1212389852-1277-4-git-send-email-fujita.tomonori@lab.ntt.co.jp> <1212389852-1277-5-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Reply-To: petkovbb@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.155]:55829 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751165AbYFBTOM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Jun 2008 15:14:12 -0400
Received: by fg-out-1718.google.com with SMTP id 19so812212fgg.17
        for <linux-scsi@vger.kernel.org>; Mon, 02 Jun 2008 12:14:09 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1212389852-1277-5-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, jens.axboe@oracle.com, tsbogend@alpha.franken.de, bzolnier@gmail.com, James.Bottomley@HansenPartnership.com, jeff@garzik.org, davem@davemloft.net, akpm@linux-foundation.org

On Mon, Jun 02, 2008 at 03:57:30PM +0900, FUJITA Tomonori wrote:
> Some REQ_TYPE_ATA_PC commands uses the stack buffers for DMA, which
> leads to memory corruption on a non-coherent platform.
>=20
> With regard to alignment and padding, ide-cd has the the dma safe
> check for sg requests and REQ_TYPE_ATA_PC. This adds the stack buffer
> check to that check.
>=20
> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> Cc: Borislav Petkov <petkovbb@gmail.com>
> Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> ---
>  drivers/ide/ide-cd.c |    5 +++++
>  1 files changed, 5 insertions(+), 0 deletions(-)
>=20
> diff --git a/drivers/ide/ide-cd.c b/drivers/ide/ide-cd.c
> index e3f085c..e12d602 100644
> --- a/drivers/ide/ide-cd.c
> +++ b/drivers/ide/ide-cd.c
> @@ -1195,6 +1195,7 @@ static ide_startstop_t cdrom_do_block_pc(ide_dr=
ive_t *drive, struct request *rq)
>  		struct request_queue *q =3D drive->queue;
>  		unsigned int alignment;
>  		unsigned long addr;
> +		unsigned long stack_mask =3D ~(THREAD_SIZE - 1);
> =20
>  		if (rq->bio)
>  			addr =3D (unsigned long)bio_data(rq->bio);
> @@ -1212,6 +1213,10 @@ static ide_startstop_t cdrom_do_block_pc(ide_d=
rive_t *drive, struct request *rq)
>  		alignment =3D queue_dma_alignment(q) | q->dma_pad_mask;
>  		if (addr & alignment || rq->data_len & alignment)
>  			info->dma =3D 0;
> +
> +		if (!((addr & stack_mask) ^
> +		      ((unsigned long)current->stack & stack_mask)))
> +			info->dma =3D 0;
>  	}
> =20
>  	/* start sending the command to the drive */
> --=20
> 1.5.4.2

Looks good, thanks.

Acked-by: Borislav Petkov <petkovbb@gmail.com>

--=20
Regards/Gru=DF,
    Boris.
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
