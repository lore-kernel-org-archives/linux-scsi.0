From: Borislav Petkov <petkovbb@googlemail.com>
Subject: Re: [PATCH 3/4] ide: use the dma safe check for REQ_TYPE_ATA_PC
Date: Wed, 28 May 2008 08:43:00 +0200
Message-ID: <20080528064259.GA30300@gollum.tnic>
References: <1211259514-9131-1-git-send-email-fujita.tomonori@lab.ntt.co.jp> <1211259514-9131-2-git-send-email-fujita.tomonori@lab.ntt.co.jp> <1211259514-9131-3-git-send-email-fujita.tomonori@lab.ntt.co.jp> <1211259514-9131-4-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Reply-To: petkovbb@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1211259514-9131-4-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-ide-owner@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, jens.axboe@oracle.com, tsbogend@alpha.franken.de, bzolnier@gmail.com, James.Bottomley@HansenPartnership.com, jeff@garzik.org, akpm@linux-foundation.org, davem@davemloft.net
List-Id: linux-scsi@vger.kernel.org

On Tue, May 20, 2008 at 01:58:33PM +0900, FUJITA Tomonori wrote:
> This uses the dma safe check for REQ_TYPE_ATA_PC. The dma safe check
> is used for only sg requests but it should be used for other non fs
> commands.
>=20
> This uses blk_queue_update_dma_pad to make the intention clear though
> ide don't use the blk APIs so it doesn't change anything.
>=20
> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> ---
>  drivers/ide/ide-cd.c |   17 ++++++++++++-----
>  1 files changed, 12 insertions(+), 5 deletions(-)
>=20
> diff --git a/drivers/ide/ide-cd.c b/drivers/ide/ide-cd.c
> index 68e7f19..1d8d510 100644
> --- a/drivers/ide/ide-cd.c
> +++ b/drivers/ide/ide-cd.c
> @@ -1178,10 +1178,15 @@ static ide_startstop_t cdrom_do_block_pc(ide_=
drive_t *drive, struct request *rq)
>  	info->dma =3D 0;
> =20
>  	/* sg request */
> -	if (rq->bio) {
> -		int mask =3D drive->queue->dma_alignment;
> -		unsigned long addr =3D
> -			(unsigned long)page_address(bio_page(rq->bio));
> +	if (rq->bio || ((rq->cmd_type =3D=3D REQ_TYPE_ATA_PC) && rq->data_l=
en)) {
> +		struct request_queue *q =3D drive->queue;
> +		unsigned int alignment;
> +		unsigned long addr;
> +
> +		if (rq->bio)
> +			addr =3D (unsigned long)bio_data(rq->bio);
> +		else
> +			addr =3D (unsigned long)rq->data;
> =20
>  		info->dma =3D drive->using_dma;
> =20
> @@ -1191,7 +1196,8 @@ static ide_startstop_t cdrom_do_block_pc(ide_dr=
ive_t *drive, struct request *rq)
>  		 * NOTE! The "len" and "addr" checks should possibly have
>  		 * separate masks.
>  		 */
> -		if ((rq->data_len & 15) || (addr & mask))
> +		alignment =3D queue_dma_alignment(q) | q->dma_pad_mask;
> +		if (addr & alignment || rq->data_len & alignment)
>  			info->dma =3D 0;
>  	}
> =20
> @@ -1869,6 +1875,7 @@ static int ide_cdrom_setup(ide_drive_t *drive)
> =20
>  	blk_queue_prep_rq(drive->queue, ide_cdrom_prep_fn);
>  	blk_queue_dma_alignment(drive->queue, 31);
> +	blk_queue_update_dma_pad(drive->queue, 15);
>  	drive->queue->unplug_delay =3D (1 * HZ) / 1000;
>  	if (!drive->queue->unplug_delay)
>  		drive->queue->unplug_delay =3D 1;

Looks good to me.

Acked-by: Borislav Petkov <petkovbb@gmail.com>
--=20
Regards/Gru=DF,
    Boris.
