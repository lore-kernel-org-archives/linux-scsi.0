From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH V4 07/16] scsi: sd_zbc: Initialize device request queue
 zoned data
Date: Mon, 25 Sep 2017 11:36:21 +0200
Message-ID: <20170925093621.42xue3qnvdvlzik3@linux-x5ow.site>
References: <20170924070247.25560-1-damien.lemoal@wdc.com>
 <20170924070247.25560-8-damien.lemoal@wdc.com>
 <20170924150701.GF14806@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170924150701.GF14806@lst.de>
Sender: linux-block-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Damien Le Moal <damien.lemoal@wdc.com>, linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, Bart Van Assche <Bart.VanAssche@wdc.com>
List-Id: linux-scsi@vger.kernel.org

On Sun, Sep 24, 2017 at 05:07:01PM +0200, Christoph Hellwig wrote:
> > +static inline unsigned long *sd_zbc_alloc_zone_bitmap(struct scsi_disk *sdkp)
> > +{
> > +	struct request_queue *q = sdkp->disk->queue;
> > +
> > +	return kzalloc_node(BITS_TO_LONGS(sdkp->nr_zones)
> > +			    * sizeof(unsigned long),
> > +			    GFP_KERNEL, q->node);
> 
> This really screams for kcalloc_node and friends that I think Johannes
> volunteered to add.

Thanks for the reminder, I'll send out the series today.

-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
