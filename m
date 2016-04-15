From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH 5/9] block: Implement support for zoned block devices
Date: Fri, 15 Apr 2016 10:37:28 -0700
Message-ID: <571126D8.2090807@sandisk.com>
References: <1459764020-126038-1-git-send-email-hare@suse.de>
 <1459764020-126038-6-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bl2on0080.outbound.protection.outlook.com ([65.55.169.80]:62059
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751846AbcDORhg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 15 Apr 2016 13:37:36 -0400
In-Reply-To: <1459764020-126038-6-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Jens Axboe <axboe@fb.com>, linux-block@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, Shaun Tancheff <shaun.tancheff@seagate.com>, Damien Le Moal <damien.lemoal@hgst.com>, linux-scsi@vger.kernel.org, Sathya Prakash <sathya.prakash@broadcom.com>

On 04/04/2016 03:00 AM, Hannes Reinecke wrote:
> +struct blk_zone *blk_lookup_zone(struct request_queue *q, sector_t lba)

A similar comment applies to this function: does this function expect a 
sector_t or an LBA as its second argument?

> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> index 7e5d7e0..f58bcdc 100644
> --- a/include/linux/blkdev.h
> +++ b/include/linux/blkdev.h
> @@ -249,6 +249,50 @@ struct blk_queue_tag {
>   #define BLK_SCSI_MAX_CMDS	(256)
>   #define BLK_SCSI_CMD_PER_LONG	(BLK_SCSI_MAX_CMDS / (sizeof(long) * 8))
>
> +#ifdef CONFIG_BLK_DEV_ZONED
> +enum blk_zone_type {
> +	BLK_ZONE_TYPE_UNKNOWN,
> +	BLK_ZONE_TYPE_CONVENTIONAL,
> +	BLK_ZONE_TYPE_SEQWRITE_REQ,
> +	BLK_ZONE_TYPE_SEQWRITE_PREF,
> +	BLK_ZONE_TYPE_RESERVED,
> +};
> +
> +enum blk_zone_state {
> +	BLK_ZONE_UNKNOWN,
> +	BLK_ZONE_NO_WP,
> +	BLK_ZONE_OPEN,
> +	BLK_ZONE_READONLY,
> +	BLK_ZONE_OFFLINE,
> +	BLK_ZONE_BUSY,
> +};
> +
> +struct blk_zone {
> +	struct rb_node node;
> +	spinlock_t lock;
> +	sector_t start;
> +	size_t len;
> +	sector_t wp;
> +	enum blk_zone_type type;
> +	enum blk_zone_state state;
> +	void *private_data;
> +};
> +
> +#define blk_zone_is_smr(z) ((z)->type == BLK_ZONE_TYPE_SEQWRITE_REQ ||	\
> +			    (z)->type == BLK_ZONE_TYPE_SEQWRITE_PREF)
> +
> +#define blk_zone_is_cmr(z) ((z)->type == BLK_ZONE_TYPE_CONVENTIONAL)
> +#define blk_zone_is_full(z) ((z)->wp == (z)->start + (z)->len)
> +#define blk_zone_is_empty(z) ((z)->wp == (z)->start)
> +
> +extern struct blk_zone *blk_lookup_zone(struct request_queue *, sector_t);
> +extern struct blk_zone *blk_insert_zone(struct request_queue *,
> +					struct blk_zone *);
> +extern void blk_drop_zones(struct request_queue *);
> +#else
> +static inline void blk_drop_zones(struct request_queue *q) { };
> +#endif

Have you considered to create a new header file for these definitions 
instead of adding these to <linux/blkdev.h>?

Bart.
