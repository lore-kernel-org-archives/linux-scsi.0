From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH 1/9] block: Add 'zoned' queue limit
Date: Mon, 19 Sep 2016 21:05:03 -0700
Message-ID: <99a58964-121e-3822-aa00-3864dcc69a45@sandisk.com>
References: <1474320454-5264-1-git-send-email-damien.lemoal@hgst.com>
 <1474320454-5264-2-git-send-email-damien.lemoal@hgst.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <1474320454-5264-2-git-send-email-damien.lemoal@hgst.com>
Sender: linux-block-owner@vger.kernel.org
To: Damien Le Moal <damien.lemoal@hgst.com>, linux-scsi@vger.kernel.org, linux-block@vger.kernel.org
Cc: martin.petersen@oracle.com, axboe@kernel.dk, hare@suse.de, shaun.tancheff@seagate.com
List-Id: linux-scsi@vger.kernel.org

On 09/19/16 14:27, Damien Le Moal wrote:
> +/*
> + * Zoned block device models (zoned limit).
> + */
> +enum blk_zoned_model {
> +	BLK_ZONED_NONE,	/* Regular block device */
> +	BLK_ZONED_HA, 	/* Host-aware zoned block device */
> +	BLK_ZONED_HM,	/* Host-managed zoned block device */
> +};

[ ... ]

> +static inline unsigned int blk_queue_zoned(struct request_queue *q)
> +{
> +	return q->limits.zoned;
> +}
> +
>  /*
>   * We regard a request as sync, if either a read or a sync write
>   */
> @@ -1354,6 +1369,16 @@ static inline unsigned int bdev_write_same(struct block_device *bdev)
>  	return 0;
>  }
>
> +static inline unsigned int bdev_zoned(struct block_device *bdev)
> +{
> +	struct request_queue *q = bdev_get_queue(bdev);
> +
> +	if (q)
> +		return blk_queue_zoned(q);
> +
> +	return 0;
> +}

Hello Damien,

Please consider changing the return type of the above two functions into 
"enum blk_zoned_model" to make it clear that both return one of the 
BLK_ZONED_* constants.

Thanks,

Bart.
