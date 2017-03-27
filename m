From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH 7/7] sd: use ZERO_PAGE for WRITE_SAME payloads
Date: Mon, 27 Mar 2017 23:40:12 +0000
Message-ID: <1490657999.7897.21.camel@sandisk.com>
References: <20170320204319.12628-1-hch@lst.de>
         <20170320204319.12628-8-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170320204319.12628-8-hch@lst.de>
Content-Language: en-US
Content-ID: <D0EA990B7C9E014F9A4C8EE9B6EB8F7B@sandisk.com>
Sender: linux-block-owner@vger.kernel.org
To: "hch@lst.de" <hch@lst.de>, "tj@kernel.org" <tj@kernel.org>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "axboe@kernel.dk" <axboe@kernel.dk>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, 2017-03-20 at 16:43 -0400, Christoph Hellwig wrote:
> We're never touching the contents of the page, so save a memory
> allocation for these cases.
>=20
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/scsi/sd.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index c18fe9ff1f8f..af632e350ab4 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -756,7 +756,7 @@ static int sd_setup_write_same16_cmnd(struct scsi_cmn=
d *cmd)
>  	u32 nr_sectors =3D blk_rq_sectors(rq) >> (ilog2(sdp->sector_size) - 9);
>  	u32 data_len =3D sdp->sector_size;
> =20
> -	rq->special_vec.bv_page =3D alloc_page(GFP_ATOMIC | __GFP_ZERO);
> +	rq->special_vec.bv_page =3D ZERO_PAGE(0);
>  	if (!rq->special_vec.bv_page)
>  		return BLKPREP_DEFER;
>  	rq->special_vec.bv_offset =3D 0;
> @@ -785,7 +785,7 @@ static int sd_setup_write_same10_cmnd(struct scsi_cmn=
d *cmd, bool unmap)
>  	u32 nr_sectors =3D blk_rq_sectors(rq) >> (ilog2(sdp->sector_size) - 9);
>  	u32 data_len =3D sdp->sector_size;
> =20
> -	rq->special_vec.bv_page =3D alloc_page(GFP_ATOMIC | __GFP_ZERO);
> +	rq->special_vec.bv_page =3D ZERO_PAGE(0);
>  	if (!rq->special_vec.bv_page)
>  		return BLKPREP_DEFER;
>  	rq->special_vec.bv_offset =3D 0;
> @@ -1256,7 +1256,8 @@ static void sd_uninit_command(struct scsi_cmnd *SCp=
nt)
>  {
>  	struct request *rq =3D SCpnt->request;
> =20
> -	if (rq->rq_flags & RQF_SPECIAL_PAYLOAD)
> +	if ((rq->rq_flags & RQF_SPECIAL_PAYLOAD) &&
> +	    rq->special_vec.bv_page !=3D ZERO_PAGE(0))
>  		__free_page(rq->special_vec.bv_page);
> =20
>  	if (SCpnt->cmnd !=3D scsi_req(rq)->cmd) {

Reviewed-by: Bart Van Assche <bart.vanassche@sandisk.com>
