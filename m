From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [PATCH 2/4] null_blk: add zone open, close, and finish support
Date: Sat, 22 Jun 2019 01:02:57 +0000
Message-ID: <BYAPR04MB5816D471063D970DDCF9AEC7E7E60@BYAPR04MB5816.namprd04.prod.outlook.com>
References: <20190621130711.21986-1-mb@lightnvm.io>
 <20190621130711.21986-3-mb@lightnvm.io>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: =?iso-8859-1?Q?Matias_Bj=F8rling?= <mb@lightnvm.io>, "axboe@fb.com" <axboe@fb.com>, "hch@lst.de" <hch@lst.de>, Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>, Dmitry Fomichev <Dmitry.Fomichev@wdc.com>, Ajay Joshi <Ajay.Joshi@wdc.com>, Aravind Ramesh <Aravind.Ramesh@wdc.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>, "agk@redhat.com" <agk@redhat.com>, "snitzer@redhat.com" <snitzer@redhat.com>
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, Matias Bjorling <Matias.Bjorling@wdc.com>
List-Id: linux-scsi@vger.kernel.org

On 2019/06/21 22:07, Matias Bj=F8rling wrote:=0A=
> From: Ajay Joshi <ajay.joshi@wdc.com>=0A=
> =0A=
> Implement REQ_OP_ZONE_OPEN, REQ_OP_ZONE_CLOSE and REQ_OP_ZONE_FINISH=0A=
> support to allow explicit control of zone states.=0A=
> =0A=
> Signed-off-by: Ajay Joshi <ajay.joshi@wdc.com>=0A=
> Signed-off-by: Matias Bj=F8rling <matias.bjorling@wdc.com>=0A=
> ---=0A=
>  drivers/block/null_blk.h       |  4 ++--=0A=
>  drivers/block/null_blk_main.c  | 13 ++++++++++---=0A=
>  drivers/block/null_blk_zoned.c | 33 ++++++++++++++++++++++++++++++---=0A=
>  3 files changed, 42 insertions(+), 8 deletions(-)=0A=
> =0A=
> diff --git a/drivers/block/null_blk.h b/drivers/block/null_blk.h=0A=
> index 34b22d6523ba..62ef65cb0f3e 100644=0A=
> --- a/drivers/block/null_blk.h=0A=
> +++ b/drivers/block/null_blk.h=0A=
> @@ -93,7 +93,7 @@ int null_zone_report(struct gendisk *disk, sector_t sec=
tor,=0A=
>  		     gfp_t gfp_mask);=0A=
>  void null_zone_write(struct nullb_cmd *cmd, sector_t sector,=0A=
>  			unsigned int nr_sectors);=0A=
> -void null_zone_reset(struct nullb_cmd *cmd, sector_t sector);=0A=
> +void null_zone_mgmt_op(struct nullb_cmd *cmd, sector_t sector);=0A=
>  #else=0A=
>  static inline int null_zone_init(struct nullb_device *dev)=0A=
>  {=0A=
> @@ -111,6 +111,6 @@ static inline void null_zone_write(struct nullb_cmd *=
cmd, sector_t sector,=0A=
>  				   unsigned int nr_sectors)=0A=
>  {=0A=
>  }=0A=
> -static inline void null_zone_reset(struct nullb_cmd *cmd, sector_t secto=
r) {}=0A=
> +static inline void null_zone_mgmt_op(struct nullb_cmd *cmd, sector_t sec=
tor) {}=0A=
>  #endif /* CONFIG_BLK_DEV_ZONED */=0A=
>  #endif /* __NULL_BLK_H */=0A=
> diff --git a/drivers/block/null_blk_main.c b/drivers/block/null_blk_main.=
c=0A=
> index 447d635c79a2..5058fb980c9c 100644=0A=
> --- a/drivers/block/null_blk_main.c=0A=
> +++ b/drivers/block/null_blk_main.c=0A=
> @@ -1209,10 +1209,17 @@ static blk_status_t null_handle_cmd(struct nullb_=
cmd *cmd)=0A=
>  			nr_sectors =3D blk_rq_sectors(cmd->rq);=0A=
>  		}=0A=
>  =0A=
> -		if (op =3D=3D REQ_OP_WRITE)=0A=
> +		switch (op) {=0A=
> +		case REQ_OP_WRITE:=0A=
>  			null_zone_write(cmd, sector, nr_sectors);=0A=
> -		else if (op =3D=3D REQ_OP_ZONE_RESET)=0A=
> -			null_zone_reset(cmd, sector);=0A=
> +			break;=0A=
> +		case REQ_OP_ZONE_RESET:=0A=
> +		case REQ_OP_ZONE_OPEN:=0A=
> +		case REQ_OP_ZONE_CLOSE:=0A=
> +		case REQ_OP_ZONE_FINISH:=0A=
> +			null_zone_mgmt_op(cmd, sector);=0A=
> +			break;=0A=
> +		}=0A=
>  	}=0A=
>  out:=0A=
>  	/* Complete IO by inline, softirq or timer */=0A=
> diff --git a/drivers/block/null_blk_zoned.c b/drivers/block/null_blk_zone=
d.c=0A=
> index fca0c97ff1aa..47d956b2e148 100644=0A=
> --- a/drivers/block/null_blk_zoned.c=0A=
> +++ b/drivers/block/null_blk_zoned.c=0A=
> @@ -121,17 +121,44 @@ void null_zone_write(struct nullb_cmd *cmd, sector_=
t sector,=0A=
>  	}=0A=
>  }=0A=
>  =0A=
> -void null_zone_reset(struct nullb_cmd *cmd, sector_t sector)=0A=
> +void null_zone_mgmt_op(struct nullb_cmd *cmd, sector_t sector)=0A=
>  {=0A=
>  	struct nullb_device *dev =3D cmd->nq->dev;=0A=
>  	unsigned int zno =3D null_zone_no(dev, sector);=0A=
>  	struct blk_zone *zone =3D &dev->zones[zno];=0A=
> +	enum req_opf op =3D req_op(cmd->rq);=0A=
>  =0A=
>  	if (zone->type =3D=3D BLK_ZONE_TYPE_CONVENTIONAL) {=0A=
>  		cmd->error =3D BLK_STS_IOERR;=0A=
>  		return;=0A=
>  	}=0A=
>  =0A=
> -	zone->cond =3D BLK_ZONE_COND_EMPTY;=0A=
> -	zone->wp =3D zone->start;=0A=
> +	switch (op) {=0A=
> +	case REQ_OP_ZONE_RESET:=0A=
> +		zone->cond =3D BLK_ZONE_COND_EMPTY;=0A=
> +		zone->wp =3D zone->start;=0A=
> +		return;=0A=
> +	case REQ_OP_ZONE_OPEN:=0A=
> +		if (zone->cond =3D=3D BLK_ZONE_COND_FULL) {=0A=
> +			cmd->error =3D BLK_STS_IOERR;=0A=
> +			return;=0A=
> +		}=0A=
> +		zone->cond =3D BLK_ZONE_COND_EXP_OPEN;=0A=
=0A=
=0A=
With ZBC, open of a full zone is a "nop". No error. So I would rather have =
this as:=0A=
=0A=
		if (zone->cond !=3D BLK_ZONE_COND_FULL)=0A=
			zone->cond =3D BLK_ZONE_COND_EXP_OPEN;=0A=
		=0A=
=0A=
> +		return;=0A=
> +	case REQ_OP_ZONE_CLOSE:=0A=
> +		if (zone->cond =3D=3D BLK_ZONE_COND_FULL) {=0A=
> +			cmd->error =3D BLK_STS_IOERR;=0A=
> +			return;=0A=
> +		}=0A=
> +		zone->cond =3D BLK_ZONE_COND_CLOSED;=0A=
=0A=
Sam as for open. Closing a full zone on ZBC is a nop. And the code above wo=
uld=0A=
also set an empty zone to closed. Finally, if the zone is open but nothing =
was=0A=
written to it, it must be returned to empty condition, not closed. So somet=
hing=0A=
like this is needed.=0A=
=0A=
		switch (zone->cond) {=0A=
		case BLK_ZONE_COND_FULL:=0A=
		case BLK_ZONE_COND_EMPTY:=0A=
			break;=0A=
		case BLK_ZONE_COND_EXP_OPEN:=0A=
			if (zone->wp =3D=3D zone->start) {=0A=
				zone->cond =3D BLK_ZONE_COND_EMPTY;=0A=
				break;=0A=
			}=0A=
		/* fallthrough */=0A=
		default:=0A=
			zone->cond =3D BLK_ZONE_COND_CLOSED;=0A=
		}=0A=
=0A=
> +		return;=0A=
> +	case REQ_OP_ZONE_FINISH:=0A=
> +		zone->cond =3D BLK_ZONE_COND_FULL;=0A=
> +		zone->wp =3D zone->start + zone->len;=0A=
> +		return;=0A=
> +	default:=0A=
> +		/* Invalid zone condition */=0A=
> +		cmd->error =3D BLK_STS_IOERR;=0A=
> +		return;=0A=
> +	}=0A=
>  }=0A=
> =0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
