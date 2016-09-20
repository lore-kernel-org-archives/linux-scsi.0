From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH 4/9] block: Define zoned block device operations
Date: Mon, 19 Sep 2016 21:05:13 -0700
Message-ID: <dfc29f8e-50c7-6987-3674-2221720fbba5@sandisk.com>
References: <1474320454-5264-1-git-send-email-damien.lemoal@hgst.com>
 <1474320454-5264-5-git-send-email-damien.lemoal@hgst.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <1474320454-5264-5-git-send-email-damien.lemoal@hgst.com>
Sender: linux-block-owner@vger.kernel.org
To: Damien Le Moal <damien.lemoal@hgst.com>, linux-scsi@vger.kernel.org, linux-block@vger.kernel.org
Cc: martin.petersen@oracle.com, axboe@kernel.dk, hare@suse.de, shaun.tancheff@seagate.com
List-Id: linux-scsi@vger.kernel.org

On 09/19/16 14:27, Damien Le Moal wrote:
> diff --git a/block/blk-core.c b/block/blk-core.c
> index 36c7ac3..4a7f7ba 100644
> --- a/block/blk-core.c
> +++ b/block/blk-core.c
> @@ -1941,6 +1941,13 @@ generic_make_request_checks(struct bio *bio)
>  	case REQ_OP_WRITE_SAME:
>  		if (!bdev_write_same(bio->bi_bdev))
>  			goto not_supported;
> +	case REQ_OP_ZONE_REPORT:
> +	case REQ_OP_ZONE_RESET:
> +	case REQ_OP_ZONE_OPEN:
> +	case REQ_OP_ZONE_CLOSE:
> +	case REQ_OP_ZONE_FINISH:
> +		if (!bdev_zoned(bio->bi_bdev))
> +			goto not_supported;

In patch 1/9 the BLK_ZONED_* constants have been introduced. The above 
code compares the bdev_zoned() return value against 0. That means that 
the above code will break if the numeric value of the BLK_ZONED_* 
constants would be changed. Please change the above code such that it 
compares the bdev_zoned() return value against a BLK_ZONED_* constant.

> + * Operation:
> + * REQ_OP_ZONE_REPORT: Request information for all zones or for a single zone.
> + * REQ_OP_ZONE_RESET: Reset the write pointer of all zones or of a single zone.
> + * REQ_OP_ZONE_OPEN: Explicitely open the maximum allowed number of zones or
> + *                   a single zone. For the former case, the zones that will
> + *                   actually be open are chosen by the disk.
> + * REQ_OP_ZONE_CLOSE: Close all implicitely or explicitely open zones or
> + *                    a single zone.
> + * REQ_OP_ZONE_FINISH: Transition one or all open and closed zones to the full
> + *                     condition.

Please change *plicitely into *plicitly.

Thanks,

Bart.
