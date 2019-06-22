From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [PATCH 4/4] dm: add zone open, close and finish support
Date: Sat, 22 Jun 2019 01:15:30 +0000
Message-ID: <BYAPR04MB581688295FDAAF91805CD871E7E60@BYAPR04MB5816.namprd04.prod.outlook.com>
References: <20190621130711.21986-1-mb@lightnvm.io>
 <20190621130711.21986-5-mb@lightnvm.io>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: =?iso-8859-1?Q?Matias_Bj=F8rling?= <mb@lightnvm.io>, "axboe@fb.com" <axboe@fb.com>, "hch@lst.de" <hch@lst.de>, Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>, Dmitry Fomichev <Dmitry.Fomichev@wdc.com>, Ajay Joshi <Ajay.Joshi@wdc.com>, Aravind Ramesh <Aravind.Ramesh@wdc.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>, "agk@redhat.com" <agk@redhat.com>, "snitzer@redhat.com" <snitzer@redhat.com>
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: linux-scsi@vger.kernel.org

On 2019/06/21 22:07, Matias Bj=F8rling wrote:=0A=
> From: Ajay Joshi <ajay.joshi@wdc.com>=0A=
> =0A=
> Implement REQ_OP_ZONE_OPEN, REQ_OP_ZONE_CLOSE and REQ_OP_ZONE_FINISH=0A=
> support to allow explicit control of zone states.=0A=
> =0A=
> Signed-off-by: Ajay Joshi <ajay.joshi@wdc.com>=0A=
> ---=0A=
>  drivers/md/dm-flakey.c    | 7 +++----=0A=
>  drivers/md/dm-linear.c    | 2 +-=0A=
>  drivers/md/dm.c           | 5 +++--=0A=
>  include/linux/blk_types.h | 8 ++++++++=0A=
>  4 files changed, 15 insertions(+), 7 deletions(-)=0A=
> =0A=
> diff --git a/drivers/md/dm-flakey.c b/drivers/md/dm-flakey.c=0A=
> index a9bc518156f2..fff529c0732c 100644=0A=
> --- a/drivers/md/dm-flakey.c=0A=
> +++ b/drivers/md/dm-flakey.c=0A=
> @@ -280,7 +280,7 @@ static void flakey_map_bio(struct dm_target *ti, stru=
ct bio *bio)=0A=
>  	struct flakey_c *fc =3D ti->private;=0A=
>  =0A=
>  	bio_set_dev(bio, fc->dev->bdev);=0A=
> -	if (bio_sectors(bio) || bio_op(bio) =3D=3D REQ_OP_ZONE_RESET)=0A=
> +	if (bio_sectors(bio) || bio_is_zone_mgmt_op(bio))=0A=
>  		bio->bi_iter.bi_sector =3D=0A=
>  			flakey_map_sector(ti, bio->bi_iter.bi_sector);=0A=
>  }=0A=
> @@ -322,8 +322,7 @@ static int flakey_map(struct dm_target *ti, struct bi=
o *bio)=0A=
>  	struct per_bio_data *pb =3D dm_per_bio_data(bio, sizeof(struct per_bio_=
data));=0A=
>  	pb->bio_submitted =3D false;=0A=
>  =0A=
> -	/* Do not fail reset zone */=0A=
> -	if (bio_op(bio) =3D=3D REQ_OP_ZONE_RESET)=0A=
> +	if (bio_is_zone_mgmt_op(bio))=0A=
>  		goto map_bio;=0A=
>  =0A=
>  	/* Are we alive ? */=0A=
> @@ -384,7 +383,7 @@ static int flakey_end_io(struct dm_target *ti, struct=
 bio *bio,=0A=
>  	struct flakey_c *fc =3D ti->private;=0A=
>  	struct per_bio_data *pb =3D dm_per_bio_data(bio, sizeof(struct per_bio_=
data));=0A=
>  =0A=
> -	if (bio_op(bio) =3D=3D REQ_OP_ZONE_RESET)=0A=
> +	if (bio_is_zone_mgmt_op(bio))=0A=
>  		return DM_ENDIO_DONE;=0A=
>  =0A=
>  	if (!*error && pb->bio_submitted && (bio_data_dir(bio) =3D=3D READ)) {=
=0A=
> diff --git a/drivers/md/dm-linear.c b/drivers/md/dm-linear.c=0A=
> index ad980a38fb1e..217a1dee8197 100644=0A=
> --- a/drivers/md/dm-linear.c=0A=
> +++ b/drivers/md/dm-linear.c=0A=
> @@ -90,7 +90,7 @@ static void linear_map_bio(struct dm_target *ti, struct=
 bio *bio)=0A=
>  	struct linear_c *lc =3D ti->private;=0A=
>  =0A=
>  	bio_set_dev(bio, lc->dev->bdev);=0A=
> -	if (bio_sectors(bio) || bio_op(bio) =3D=3D REQ_OP_ZONE_RESET)=0A=
> +	if (bio_sectors(bio) || bio_is_zone_mgmt_op(bio))=0A=
>  		bio->bi_iter.bi_sector =3D=0A=
>  			linear_map_sector(ti, bio->bi_iter.bi_sector);=0A=
>  }=0A=
> diff --git a/drivers/md/dm.c b/drivers/md/dm.c=0A=
> index 5475081dcbd6..f4507ec20a57 100644=0A=
> --- a/drivers/md/dm.c=0A=
> +++ b/drivers/md/dm.c=0A=
> @@ -1176,7 +1176,8 @@ static size_t dm_dax_copy_to_iter(struct dax_device=
 *dax_dev, pgoff_t pgoff,=0A=
>  =0A=
>  /*=0A=
>   * A target may call dm_accept_partial_bio only from the map routine.  I=
t is=0A=
> - * allowed for all bio types except REQ_PREFLUSH and REQ_OP_ZONE_RESET.=
=0A=
> + * allowed for all bio types except REQ_PREFLUSH, REQ_OP_ZONE_RESET,=0A=
> + * REQ_OP_ZONE_OPEN, REQ_OP_ZONE_CLOSE and REQ_OP_ZONE_FINISH.=0A=
>   *=0A=
>   * dm_accept_partial_bio informs the dm that the target only wants to pr=
ocess=0A=
>   * additional n_sectors sectors of the bio and the rest of the data shou=
ld be=0A=
> @@ -1629,7 +1630,7 @@ static blk_qc_t __split_and_process_bio(struct mapp=
ed_device *md,=0A=
>  		ci.sector_count =3D 0;=0A=
>  		error =3D __send_empty_flush(&ci);=0A=
>  		/* dec_pending submits any data associated with flush */=0A=
> -	} else if (bio_op(bio) =3D=3D REQ_OP_ZONE_RESET) {=0A=
> +	} else if (bio_is_zone_mgmt_op(bio)) {=0A=
>  		ci.bio =3D bio;=0A=
>  		ci.sector_count =3D 0;=0A=
>  		error =3D __split_and_process_non_flush(&ci);=0A=
> diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h=0A=
> index 067ef9242275..fd2458cd1a49 100644=0A=
> --- a/include/linux/blk_types.h=0A=
> +++ b/include/linux/blk_types.h=0A=
> @@ -398,6 +398,14 @@ static inline bool op_is_zone_mgmt_op(enum req_opf o=
p)=0A=
>  	}=0A=
>  }=0A=
>  =0A=
> +/*=0A=
> + * Check if the bio is zoned operation.=0A=
> + */=0A=
> +static inline bool bio_is_zone_mgmt_op(struct bio *bio)=0A=
> +{=0A=
> +	return op_is_zone_mgmt_op(bio_op(bio));=0A=
> +}=0A=
> +=0A=
>  static inline bool op_is_write(unsigned int op)=0A=
>  {=0A=
>  	return (op & 1);=0A=
> =0A=
=0A=
Looks good.=0A=
=0A=
Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
