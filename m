From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH V2 09/12] scsi: sd_zbc: Limit zone write locking to
 sequential zones
Date: Fri, 8 Sep 2017 10:39:25 +0200
Message-ID: <20170908083925.kw4ungsvxxsgtb4i@linux-x5ow.site>
References: <20170907161640.30465-1-damien.lemoal@wdc.com>
 <20170907161640.30465-10-damien.lemoal@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170907161640.30465-10-damien.lemoal@wdc.com>
Sender: linux-block-owner@vger.kernel.org
To: Damien Le Moal <damien.lemoal@wdc.com>
Cc: linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>, Bart Van Assche <Bart.VanAssche@wdc.com>
List-Id: linux-scsi@vger.kernel.org

On Fri, Sep 08, 2017 at 01:16:37AM +0900, Damien Le Moal wrote:
> +/*
> + * Allocate a zone bitmap (one bit per zone).
> + */
> +static inline unsigned long *sd_zbc_alloc_zone_bitmap(struct scsi_disk *sdkp)
> +{
> +	struct request_queue *q = sdkp->disk->queue;
> +
> +	return kzalloc_node(BITS_TO_LONGS(sdkp->nr_zones)
> +			    * sizeof(unsigned long),
> +			    GFP_KERNEL, q->node);
> +}

It's a shame we have all this overflow checking kcalloc() and
kmalloc_array() functions but none of them is taking NUMA nodes into
account.

But that has nothing to do with your patch, just a general rant,
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>

-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
