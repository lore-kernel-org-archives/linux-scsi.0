From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: Re: [PATCH V4 07/16] scsi: sd_zbc: Initialize device request queue
 zoned data
Date: Sun, 24 Sep 2017 18:44:17 +0200
Message-ID: <359bd206-c9b1-2d58-0358-77fe06e5c0b2@wdc.com>
References: <20170924070247.25560-1-damien.lemoal@wdc.com>
 <20170924070247.25560-8-damien.lemoal@wdc.com>
 <20170924150701.GF14806@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170924150701.GF14806@lst.de>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, Bart Van Assche <Bart.VanAssche@wdc.com>
List-Id: linux-scsi@vger.kernel.org

On 9/24/17 17:07, Christoph Hellwig wrote:
>> +static inline unsigned long *sd_zbc_alloc_zone_bitmap(struct scsi_disk *sdkp)
>> +{
>> +	struct request_queue *q = sdkp->disk->queue;
>> +
>> +	return kzalloc_node(BITS_TO_LONGS(sdkp->nr_zones)
>> +			    * sizeof(unsigned long),
>> +			    GFP_KERNEL, q->node);
> 
> This really screams for kcalloc_node and friends that I think Johannes
> volunteered to add.

OK. Should I wait for Johannes patches ? That can be easily changed
later though.

>> + * sd_zbc_setup_seq_zones - Initialize the disk request queue zone type bitmap.
>> + * @sdkp: The disk of the bitmap
>> + *
>> + * Allocate a zone bitmap and initialize it by identifying sequential zones.
>> + */
>> +static int sd_zbc_setup_seq_zones(struct scsi_disk *sdkp)
>> +{
>> +	struct request_queue *q = sdkp->disk->queue;
>> +	unsigned long *seq_zones;
>> +	sector_t block = 0;
>> +	unsigned char *buf;
>> +	unsigned char *rec;
>> +	unsigned int buf_len;
>> +	unsigned int list_length;
>> +	unsigned int n = 0;
>> +	u8 type, cond;
>> +	int ret = -ENOMEM;
>> +
>> +	kfree(q->seq_zones);
>> +	q->seq_zones = NULL;
> 
> We also free the previous version, which isn't documented above.
> Which in general begs the question:  What scheme protects access
> to q->seq_zones?

Yes, indeed, the comments do not mention that. I will add that.
As for the protection, there is none necessary I think. The reason is
that the previous version free+alloc can only happen if sd_revalidate is
called, at which point there are no write commands on-going, so no
references to seq_zones. Is this correct/not correct ?

I am not even sure if the reallocation/reinit is even necessary though.
Since sd_revalidate() will at worst result in the disk capacity going to
0 (if the disk is non responsive for instance), accesses beyond
seq_zones size will never happen. And the zone types never change, so it
may be better to drop this reallocation+reinit. Same for the zones_wlock
bitmap. What do you hink ?

> And the previous patch should probably grow a comment to document
> that q->seq_zones is entirely managed by the driver.

Will do.

>> +		/*
>> +		 * Parse reported zone descriptors to find sequiential zones.
>> +		 * Since read-only and offline zones cannot be written, do not
>> +		 * mark them as sequential in the bitmap.
>> +		 */
>> +		list_length = get_unaligned_be32(&buf[0]) + 64;
>> +		rec = buf + 64;
>> +		buf_len = min(list_length, SD_ZBC_BUF_SIZE);
>> +		while (rec < buf + buf_len) {
>> +			type = rec[0] & 0x0f;
>> +			cond = (rec[1] >> 4) & 0xf;
>> +			if (type != ZBC_ZONE_TYPE_CONV &&
>> +			    cond != ZBC_ZONE_COND_READONLY &&
>> +			    cond != ZBC_ZONE_COND_OFFLINE)
>> +				set_bit(n, seq_zones);
>> +			block = get_unaligned_be64(&rec[8]) +
>> +				get_unaligned_be64(&rec[16]);
>> +			rec += 64;
>> +			n++;
>> +		}
> 
> Split this out into a helper?

Yes, that would be a nice cleanup. Will do.

Thanks.


-- 
Damien Le Moal
Western Digital Research
