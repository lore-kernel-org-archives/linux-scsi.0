Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44768C43381
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Jan 2021 11:29:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 12BBE2333C
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Jan 2021 11:29:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728106AbhATL03 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 20 Jan 2021 06:26:29 -0500
Received: from verein.lst.de ([213.95.11.211]:55354 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730129AbhATKLC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 20 Jan 2021 05:11:02 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id 06F3868AFE; Wed, 20 Jan 2021 11:10:19 +0100 (CET)
Date:   Wed, 20 Jan 2021 11:10:18 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Damien Le Moal <damien.lemoal@wdc.com>
Cc:     linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-nvme@lists.infradead.org, Christoph Hellwig <hch@lst.de>,
        Keith Busch <keith.busch@wdc.com>
Subject: Re: [PATCH v2 1/2] block: introduce zone_write_granularity limit
Message-ID: <20210120101018.GB25746@lst.de>
References: <20210119131723.1637853-1-damien.lemoal@wdc.com> <20210119131723.1637853-2-damien.lemoal@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210119131723.1637853-2-damien.lemoal@wdc.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Jan 19, 2021 at 10:17:22PM +0900, Damien Le Moal wrote:
> Per ZBC and ZAC specifications, host-managed SMR hard-disks mandate that
> all writes into sequential write required zones be aligned to the device
> physical block size. However, NVMe ZNS does not have this constraint and
> allows write operations into sequential zones to be logical block size
> aligned. This inconsistency does not help with portability of software
> across device types.
> To solve this, introduce the zone_write_granularity queue limit to
> indicate the alignment constraint, in bytes, of write operations into
> zones of a zoned block device. This new limit is exported as a
> read-only sysfs queue attribute and the helper
> blk_queue_zone_write_granularity() introduced for drivers to set this
> limit. The scsi disk driver is modified to use this helper to set
> host-managed SMR disk zone write granularity to the disk physical block
> size. The nvme driver zns support use this helper to set the new limit
> to the logical block size of the zoned namespace.
> 
> Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
> ---
>  Documentation/block/queue-sysfs.rst |  7 +++++++
>  block/blk-settings.c                | 28 ++++++++++++++++++++++++++++
>  block/blk-sysfs.c                   |  7 +++++++
>  drivers/nvme/host/zns.c             |  1 +
>  drivers/scsi/sd_zbc.c               | 10 ++++++++++
>  include/linux/blkdev.h              |  3 +++
>  6 files changed, 56 insertions(+)
> 
> diff --git a/Documentation/block/queue-sysfs.rst b/Documentation/block/queue-sysfs.rst
> index 2638d3446b79..c8bf8bc3c03a 100644
> --- a/Documentation/block/queue-sysfs.rst
> +++ b/Documentation/block/queue-sysfs.rst
> @@ -273,4 +273,11 @@ devices are described in the ZBC (Zoned Block Commands) and ZAC
>  do not support zone commands, they will be treated as regular block devices
>  and zoned will report "none".
>  
> +zone_write_granularity (RO)
> +---------------------------
> +This indicates the alignment constraint, in bytes, for write operations in
> +sequential zones of zoned block devices (devices with a zoned attributed
> +that reports "host-managed" or "host-aware"). This value is always 0 for
> +regular block devices.
> +
>  Jens Axboe <jens.axboe@oracle.com>, February 2009
> diff --git a/block/blk-settings.c b/block/blk-settings.c
> index 43990b1d148b..6be6ed9485e3 100644
> --- a/block/blk-settings.c
> +++ b/block/blk-settings.c
> @@ -60,6 +60,7 @@ void blk_set_default_limits(struct queue_limits *lim)
>  	lim->io_opt = 0;
>  	lim->misaligned = 0;
>  	lim->zoned = BLK_ZONED_NONE;
> +	lim->zone_write_granularity = 0;

I think this should default to 512 just like the logic and physical
block size.

>  }
>  EXPORT_SYMBOL(blk_set_default_limits);
>  
> @@ -366,6 +367,31 @@ void blk_queue_physical_block_size(struct request_queue *q, unsigned int size)
>  }
>  EXPORT_SYMBOL(blk_queue_physical_block_size);
>  
> +/**
> + * blk_queue_zone_write_granularity - set zone write granularity for the queue
> + * @q:  the request queue for the zoned device
> + * @size:  the zone write granularity size, in bytes
> + *
> + * Description:
> + *   This should be set to the lowest possible size allowing to write in
> + *   sequential zones of a zoned block device.
> + */
> +void blk_queue_zone_write_granularity(struct request_queue *q,
> +				      unsigned int size)
> +{
> +	if (WARN_ON(!blk_queue_is_zoned(q)))
> +		return;
> +
> +	q->limits.zone_write_granularity = size;
> +
> +	if (q->limits.zone_write_granularity < q->limits.logical_block_size)
> +		q->limits.zone_write_granularity = q->limits.logical_block_size;

I think this should be a WARN_ON_ONCE.

> +	if (q->limits.zone_write_granularity < q->limits.io_min)
> +		q->limits.zone_write_granularity = q->limits.io_min;

I don't think this makes sense at all.

> +static ssize_t queue_zone_write_granularity_show(struct request_queue *q, char *page)

Overly long line.

> +	/*
> +	 * Per ZBC and ZAC specifications, writes in sequential write required
> +	 * zones of host-managed devices must be aligned to the device physical
> +	 * block size.
> +	 */
> +	if (blk_queue_zoned_model(q) == BLK_ZONED_HM)
> +		blk_queue_zone_write_granularity(q, sdkp->physical_block_size);
> +	else
> +		blk_queue_zone_write_granularity(q, sdkp->device->sector_size);

Do we really want to special case HA drives here?  I though we generally
either treat them as drive managed (if they have partitions) or else like
host managed ones.
