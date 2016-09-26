From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2 7/7] blk-zoned: implement ioctls
Date: Mon, 26 Sep 2016 09:37:52 -0700
Message-ID: <20160926163752.GA13876@infradead.org>
References: <1474888483-29762-1-git-send-email-damien.lemoal@hgst.com>
 <1474888483-29762-8-git-send-email-damien.lemoal@hgst.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1474888483-29762-8-git-send-email-damien.lemoal@hgst.com>
Sender: linux-block-owner@vger.kernel.org
To: Damien Le Moal <damien.lemoal@hgst.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, "Martin K . Petersen" <martin.petersen@oracle.com>, Shaun Tancheff <shaun.tancheff@seagate.com>
List-Id: linux-scsi@vger.kernel.org

> +	zones = kzalloc(sizeof(struct blk_zone) * rep.nr_zones,
> +			GFP_KERNEL);
> +	if (!zones)
> +		return -ENOMEM;

This should use kcalloc to get us underflow checking for the user
controlled allocation size.

> +	if (copy_to_user(argp, &rep, sizeof(struct blk_zone_report))) {
> +		ret = -EFAULT;
> +		goto out;
> +	}
> +
> +	if (rep.nr_zones) {
> +		if (copy_to_user(argp + sizeof(struct blk_zone_report), zones,
> +				 sizeof(struct blk_zone) * rep.nr_zones))
> +			ret = -EFAULT;
> +	}

We could actually do this with a single big copy_to_user.  Not that
it really matters, though..

> -/*
> - * Zone type.
> - */
> -enum blk_zone_type {
> -	BLK_ZONE_TYPE_UNKNOWN,
> -	BLK_ZONE_TYPE_CONVENTIONAL,
> -	BLK_ZONE_TYPE_SEQWRITE_REQ,
> -	BLK_ZONE_TYPE_SEQWRITE_PREF,
> -};

Please don't move this code around after it was added just two
patches earlier.  I'd say just split adding the new blkzoned.h
uapi header into a patch of it's own and add that before the
core block code.
