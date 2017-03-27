From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH 6/7] sd: support multi-range TRIM for ATA disks
Date: Mon, 27 Mar 2017 23:38:59 +0000
Message-ID: <1490657921.7897.20.camel@sandisk.com>
References: <20170320204319.12628-1-hch@lst.de>
         <20170320204319.12628-7-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20170320204319.12628-7-hch@lst.de>
Content-Language: en-US
Content-ID: <24380228EE945E478170EF1B65BE223B@sandisk.com>
Sender: linux-ide-owner@vger.kernel.org
To: "hch@lst.de" <hch@lst.de>, "tj@kernel.org" <tj@kernel.org>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "axboe@kernel.dk" <axboe@kernel.dk>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, 2017-03-20 at 16:43 -0400, Christoph Hellwig wrote:
> @@ -698,13 +698,19 @@ static void sd_config_discard(struct scsi_disk *sdk=
p, unsigned int mode)
>  		break;
> =20
>  	case SD_LBP_ATA_TRIM:
> -		max_blocks =3D 65535 * (512 / sizeof(__le64));
> +		max_ranges =3D 512 / sizeof(__le64);
> +		max_range_size =3D USHRT_MAX;
> +		max_blocks =3D max_ranges * max_range_size;
>  		if (sdkp->device->ata_trim_zeroes_data)
>  			q->limits.discard_zeroes_data =3D 1;
>  		break;
>  	}
> =20
>  	blk_queue_max_discard_sectors(q, max_blocks * (logical_block_size >> 9)=
);
> +	if (max_ranges)
> +		blk_queue_max_discard_segments(q, max_ranges);
> +	if (max_range_size)
> +		blk_queue_max_discard_segment_size(q, max_range_size);
>  	queue_flag_set_unlocked(QUEUE_FLAG_DISCARD, q);
>  }

Hello Christoph,

Does blk_queue_max_discard_segment_size() expect a second argument that is =
a
number of bytes? Is max_range_size a number of logical blocks that each hav=
e
a size 1 << sector_shift?

> @@ -826,14 +832,21 @@ static int sd_setup_ata_trim_cmnd(struct scsi_cmnd =
*cmd)
>  	cmd->cmnd[8] =3D data_len;
> =20
>  	buf =3D page_address(rq->special_vec.bv_page);
> -	for (i =3D 0; i < (data_len >> 3); i++) {
> -		u64 n =3D min(nr_sectors, 0xffffu);
> +	__rq_for_each_bio(bio, rq) {
> +		u64 sector =3D bio->bi_iter.bi_sector >> (sector_shift - 9);
> +		u32 nr_sectors =3D bio->bi_iter.bi_size >> sector_shift;
> =20
> -		buf[i] =3D cpu_to_le64(sector | (n << 48));
> -		if (nr_sectors <=3D 0xffff)
> -			break;
> -		sector +=3D 0xffff;
> -		nr_sectors -=3D 0xffff;
> +		do {
> +			u64 n =3D min(nr_sectors, 0xffffu);
> +
> +			buf[i] =3D cpu_to_le64(sector | (n << 48));
> +			if (nr_sectors <=3D 0xffff)
> +				break;
> +			sector +=3D 0xffff;
> +			nr_sectors -=3D 0xffff;
> +			i++;
> +
> +		} while (!WARN_ON_ONCE(i >=3D data_len >> 3));
>  	}
> =20
>  	cmd->allowed =3D SD_MAX_RETRIES;

It's unfortunate that the loop-end test occurs twice (i < data_len >> 3).
Please consider using put_unaligned_le64() instead of cpu_to_le64() such
that the data type of buf can be changed from __le64* into void *. With
that change and by introducing e.g. the following:

void *end;
[ ... ]
end =3D (void *)buf + data_len;

the loop variable 'i' can be eliminated. If buf[i++] =3D ... would be
changed into *buf++ =3D ... then that would allow to change the two
occurrences of (i < data_len >> 3) into (buf < end).

Thanks,

Bart.=
