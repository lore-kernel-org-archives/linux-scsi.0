From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH V4 07/16] scsi: sd_zbc: Initialize device request queue
        zoned data
Date: Sun, 24 Sep 2017 17:07:01 +0200
Message-ID: <20170924150701.GF14806@lst.de>
References: <20170924070247.25560-1-damien.lemoal@wdc.com> <20170924070247.25560-8-damien.lemoal@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170924070247.25560-8-damien.lemoal@wdc.com>
Sender: linux-block-owner@vger.kernel.org
To: Damien Le Moal <damien.lemoal@wdc.com>
Cc: linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>, Bart Van Assche <Bart.VanAssche@wdc.com>
List-Id: linux-scsi@vger.kernel.org

> +static inline unsigned long *sd_zbc_alloc_zone_bitmap(struct scsi_disk *sdkp)
> +{
> +	struct request_queue *q = sdkp->disk->queue;
> +
> +	return kzalloc_node(BITS_TO_LONGS(sdkp->nr_zones)
> +			    * sizeof(unsigned long),
> +			    GFP_KERNEL, q->node);

This really screams for kcalloc_node and friends that I think Johannes
volunteered to add.

> + * sd_zbc_setup_seq_zones - Initialize the disk request queue zone type bitmap.
> + * @sdkp: The disk of the bitmap
> + *
> + * Allocate a zone bitmap and initialize it by identifying sequential zones.
> + */
> +static int sd_zbc_setup_seq_zones(struct scsi_disk *sdkp)
> +{
> +	struct request_queue *q = sdkp->disk->queue;
> +	unsigned long *seq_zones;
> +	sector_t block = 0;
> +	unsigned char *buf;
> +	unsigned char *rec;
> +	unsigned int buf_len;
> +	unsigned int list_length;
> +	unsigned int n = 0;
> +	u8 type, cond;
> +	int ret = -ENOMEM;
> +
> +	kfree(q->seq_zones);
> +	q->seq_zones = NULL;

We also free the previous version, which isn't documented above.
Which in general begs the question:  What scheme protects access
to q->seq_zones?

And the previous patch should probably grow a comment to document
that q->seq_zones is entirely managed by the driver.

> +		/*
> +		 * Parse reported zone descriptors to find sequiential zones.
> +		 * Since read-only and offline zones cannot be written, do not
> +		 * mark them as sequential in the bitmap.
> +		 */
> +		list_length = get_unaligned_be32(&buf[0]) + 64;
> +		rec = buf + 64;
> +		buf_len = min(list_length, SD_ZBC_BUF_SIZE);
> +		while (rec < buf + buf_len) {
> +			type = rec[0] & 0x0f;
> +			cond = (rec[1] >> 4) & 0xf;
> +			if (type != ZBC_ZONE_TYPE_CONV &&
> +			    cond != ZBC_ZONE_COND_READONLY &&
> +			    cond != ZBC_ZONE_COND_OFFLINE)
> +				set_bit(n, seq_zones);
> +			block = get_unaligned_be64(&rec[8]) +
> +				get_unaligned_be64(&rec[16]);
> +			rec += 64;
> +			n++;
> +		}

Split this out into a helper?
