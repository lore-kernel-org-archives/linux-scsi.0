From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH V3 03/12] block: Add zoned block device information to
        request queue
Date: Fri, 15 Sep 2017 19:48:39 +0200
Message-ID: <20170915174839.GD8578@lst.de>
References: <20170915100645.17999-1-damien.lemoal@wdc.com> <20170915100645.17999-4-damien.lemoal@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170915100645.17999-4-damien.lemoal@wdc.com>
Sender: linux-block-owner@vger.kernel.org
To: Damien Le Moal <damien.lemoal@wdc.com>
Cc: linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>, Bart Van Assche <Bart.VanAssche@wdc.com>
List-Id: linux-scsi@vger.kernel.org

> +struct blk_zoned {
> +	unsigned int	nr_zones;
> +	unsigned long	*seq_zones;
> +};
> +
>  struct blk_zone_report_hdr {
>  	unsigned int	nr_zones;
>  	u8		padding[60];
> @@ -492,6 +497,10 @@ struct request_queue {
>  	struct blk_integrity integrity;
>  #endif	/* CONFIG_BLK_DEV_INTEGRITY */
>  
> +#ifdef CONFIG_BLK_DEV_ZONED
> +	struct blk_zoned	zoned;
> +#endif

I'd prefer to just add the two fields direct to struct request_queue
instead of the container structure.

> +static inline unsigned int blk_queue_nr_zones(struct request_queue *q)
> +{
> +	return blk_queue_is_zoned(q) ? q->zoned.nr_zones : 0;
> +}

I don't think this is going to compile without CONFIG_BLK_DEV_ZONED,
we'd either need two versions of it, or just always add nr_zones to
the request queue.

With nr_zones always present we could then remove the first check,
too as it would always be initialized to zero.
