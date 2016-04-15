From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH 2/9] block: update chunk_sectors in blk_stack_limits()
Date: Thu, 14 Apr 2016 20:41:20 -0700
Message-ID: <571062E0.2010208@sandisk.com>
References: <1459764020-126038-1-git-send-email-hare@suse.de>
 <1459764020-126038-3-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bl2on0055.outbound.protection.outlook.com ([65.55.169.55]:18592
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751906AbcDODl0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 14 Apr 2016 23:41:26 -0400
In-Reply-To: <1459764020-126038-3-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, Jens Axboe <axboe@fb.com>
Cc: linux-block@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, Shaun Tancheff <shaun.tancheff@seagate.com>, Damien Le Moal <damien.lemoal@hgst.com>, linux-scsi@vger.kernel.org, Sathya Prakash <sathya.prakash@broadcom.com>, Hannes Reinecke <hare@suse.com>

On 04/04/16 03:00, Hannes Reinecke wrote:
> diff --git a/block/blk-settings.c b/block/blk-settings.c
> index c7bb666..29fa900 100644
> --- a/block/blk-settings.c
> +++ b/block/blk-settings.c
> @@ -630,6 +630,9 @@ int blk_stack_limits(struct queue_limits *t, struct queue_limits *b,
>   			t->discard_granularity;
>   	}
>
> +	if (b->chunk_sectors)
> +		t->chunk_sectors = max(t->chunk_sectors, b->chunk_sectors);
> +
>   	return ret;
>   }
>   EXPORT_SYMBOL(blk_stack_limits);

Hello Hannes,

My understanding is that a non-zero chunk_sectors value defines a 
maximum I/O size. Shouldn't max() be changed into min_not_zero()? From 
include/linux/blkdev.h:

static inline unsigned int blk_max_size_offset(struct request_queue *q,
					       sector_t offset)
{
	if (!q->limits.chunk_sectors)
		return q->limits.max_sectors;

	return q->limits.chunk_sectors -
			(offset & (q->limits.chunk_sectors - 1));
}

Bart.

