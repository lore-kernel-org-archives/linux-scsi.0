From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH 5/7] block: add a max_discard_segment_size queue limit
Date: Mon, 27 Mar 2017 23:09:56 +0000
Message-ID: <1490656182.7897.17.camel@sandisk.com>
References: <20170320204319.12628-1-hch@lst.de>
         <20170320204319.12628-6-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170320204319.12628-6-hch@lst.de>
Content-Language: en-US
Content-ID: <D25CE31AFBAA5449BA824E4C033F2D0A@sandisk.com>
Sender: linux-block-owner@vger.kernel.org
To: "hch@lst.de" <hch@lst.de>, "tj@kernel.org" <tj@kernel.org>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "axboe@kernel.dk" <axboe@kernel.dk>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, 2017-03-20 at 16:43 -0400, Christoph Hellwig wrote:
> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> index 5a7da607ca04..3b3bd646f580 100644
> --- a/include/linux/blkdev.h
> +++ b/include/linux/blkdev.h
> @@ -333,6 +333,7 @@ struct queue_limits {
>  	unsigned short		max_segments;
>  	unsigned short		max_integrity_segments;
>  	unsigned short		max_discard_segments;
> +	unsigned int		max_discard_segment_size;
> =20
>  	unsigned char		misaligned;
>  	unsigned char		discard_misaligned;
> @@ -1150,6 +1151,8 @@ extern void blk_queue_max_segments(struct request_q=
ueue *, unsigned short);
>  extern void blk_queue_max_discard_segments(struct request_queue *,
>  		unsigned short);
>  extern void blk_queue_max_segment_size(struct request_queue *, unsigned =
int);
> +extern void blk_queue_max_discard_segment_size(struct request_queue *,
> +		unsigned int);
>  extern void blk_queue_max_discard_sectors(struct request_queue *q,
>  		unsigned int max_discard_sectors);
>  extern void blk_queue_max_write_same_sectors(struct request_queue *q,
> @@ -1415,6 +1418,11 @@ static inline unsigned int queue_max_segment_size(=
struct request_queue *q)
>  	return q->limits.max_segment_size;
>  }
> =20
> +static inline unsigned int queue_max_discard_segment_size(struct request=
_queue *q)
> +{
> +	return q->limits.max_discard_segment_size;
> +}
> +
>  static inline unsigned short queue_logical_block_size(struct request_que=
ue *q)
>  {
>  	int retval =3D 512;

Hello Christoph,

It's probably a good idea to add a comment somewhere that the unit of
max_discard_segment_size is one byte.

Additionally, should it be mentioned in the commit message that this
patch limits the maximum discard segment size to 4 GB?

Thanks,

Bart.=
