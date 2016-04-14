From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH 1/9] blk-sysfs: Add 'chunk_sectors' to sysfs attributes
Date: Thu, 14 Apr 2016 12:09:44 -0700
Message-ID: <570FEAF8.7060606@sandisk.com>
References: <1459764020-126038-1-git-send-email-hare@suse.de>
 <1459764020-126038-2-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn1bon0081.outbound.protection.outlook.com ([157.56.111.81]:37139
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750705AbcDNTKK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 14 Apr 2016 15:10:10 -0400
In-Reply-To: <1459764020-126038-2-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, Jens Axboe <axboe@fb.com>
Cc: linux-block@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, Shaun Tancheff <shaun.tancheff@seagate.com>, Damien Le Moal <damien.lemoal@hgst.com>, linux-scsi@vger.kernel.org, Sathya Prakash <sathya.prakash@broadcom.com>

On 04/04/2016 03:00 AM, Hannes Reinecke wrote:
> The queue limits already have a 'chunk_sectors' setting, so
> we should be presenting it via sysfs.

This patch does more than exporting chunk_sectors via sysfs. It also 
makes that parameter configurable. Please mention this in the patch 
description.

My understanding of the block drivers that call 
blk_queue_chunk_sectors() is that increasing the chunk_sectors parameter 
will break these drivers. I think the single queue_limits.chunk_sectors 
parameter needs to be converted into two parameters:
- The value set by the block driver by calling
   blk_queue_chunk_sectors().
- The value configured from user space through sysfs.

This will allow to ensure that the chunk_sectors parameter can be 
increased from user space and also that it cannot be decreased.

> +static ssize_t
> +queue_chunk_sectors_store(struct request_queue *q, const char *page, size_t count)
> +{
> +	unsigned long chunk_sectors;
> +
> +	ssize_t ret = queue_var_store(&chunk_sectors, page, count);
> +	if (ret < 0)
> +		return ret;
> +	spin_lock_irq(q->queue_lock);
> +	blk_queue_chunk_sectors(q, chunk_sectors);
> +	spin_unlock_irq(q->queue_lock);
> +
> +	return ret;
> +}

In blk_queue_chunk_sectors() I found the following:

	BUG_ON(!is_power_of_2(chunk_sectors));

Please make sure that this BUG_ON() cannot be triggered from user space.

Additionally, an update for Documentation/block/queue-sysfs.txt is 
missing from this patch.

Bart.
