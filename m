Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBE4EC4320A
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Aug 2021 08:24:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C08FB60FD8
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Aug 2021 08:24:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237007AbhHJIY1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 10 Aug 2021 04:24:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229967AbhHJIY1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 10 Aug 2021 04:24:27 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63F77C0613D3;
        Tue, 10 Aug 2021 01:24:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=MpQI9YI44CKmRNs2TDALJaYgk5i083wyoLUkLkZlgS8=; b=Qwq0jF7B7YUylIjyyTbB0zZCms
        3v+dliWkB0h8B28isBdE0+Ro366OLLKrxMaQwRe3HBm/M22nk/KTKxhwjiRcsQ1CX4o51+dSkGJWA
        dhK4+0pSlImmoae5XewIRm3XJGEh1oIQayk9tptNLqcIRJSuL7GcCutxoA5AmhHDKqI/SN7KvxhoX
        yJ5UmfNvtN+pDHlhPaKgTRul5BE7ShnVtjKuTXaHEtmDjAKdr7QZRR1aw4OXLGegDx7CRBzgdcsz2
        D9Oc6jYH8/8bkqzhY+dFMkRwEFz7zOiHL3YW7SYzvvgWO5Q1XGdH7WBtSdG4SkJsw4S143D19jNcU
        V2ys5J/A==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mDN32-00BtCg-7w; Tue, 10 Aug 2021 08:23:54 +0000
Date:   Tue, 10 Aug 2021 09:23:44 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Damien Le Moal <damien.lemoal@wdc.com>
Cc:     linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-ide@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v3 1/4] block: Add concurrent positioning ranges support
Message-ID: <YRI3kMc39XPRLe/u@infradead.org>
References: <20210726013806.84815-1-damien.lemoal@wdc.com>
 <20210726013806.84815-2-damien.lemoal@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210726013806.84815-2-damien.lemoal@wdc.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Jul 26, 2021 at 10:38:03AM +0900, Damien Le Moal wrote:
> The Concurrent Positioning Ranges VPD page (for SCSI) and Log (for ATA)
> contain parameters describing the number of sets of contiguous LBAs that
> can be served independently by a single LUN multi-actuator disk. This
> patch provides the blk_queue_set_cranges() function allowing a device
> driver to signal to the block layer that a disk has multiple actuators,
> each one serving a contiguous range of sectors. To describe the set
> of sector ranges representing the different actuators of a device, the
> data type struct blk_cranges is introduced.
> 
> For a device with multiple actuators, a struct blk_cranges is attached
> to the device request queue by the blk_queue_set_cranges() function. The
> function blk_alloc_cranges() is provided for drivers to allocate this
> structure.
> 
> The blk_cranges structure contains kobjects (struct kobject) to register
> with sysfs the set of sector ranges defined by a device. On initial
> device scan, this registration is done from blk_register_queue() using
> the block layer internal function blk_register_cranges(). If a driver
> calls blk_queue_set_cranges() for a registered queue, e.g. when a device
> is revalidated, blk_queue_set_cranges() will execute
> blk_register_cranges() to update the queue sysfs attribute files.
> 
> The sysfs file structure created starts from the cranges sub-directory
> and contains the start sector and number of sectors served by an
> actuator, with the information for each actuator grouped in one
> directory per actuator. E.g. for a dual actuator drive, we have:
> 
> $ tree /sys/block/sdk/queue/cranges/
> /sys/block/sdk/queue/cranges/
> |-- 0
> |   |-- nr_sectors
> |   `-- sector
> `-- 1
>     |-- nr_sectors
>     `-- sector
> 
> For a regular single actuator device, the cranges directory does not
> exist.
> 
> Device revalidation may lead to changes to this structure and to the
> attribute values. When manipulated, the queue sysfs_lock and
> sysfs_dir_lock are held for atomicity, similarly to how the blk-mq and
> elevator sysfs queue sub-directories are protected.
> 
> The code related to the management of cranges is added in the new
> file block/blk-cranges.c.
> 
> Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
> ---
>  block/Makefile         |   2 +-
>  block/blk-cranges.c    | 295 +++++++++++++++++++++++++++++++++++++++++
>  block/blk-sysfs.c      |  13 ++
>  block/blk.h            |   3 +
>  include/linux/blkdev.h |  29 ++++
>  5 files changed, 341 insertions(+), 1 deletion(-)
>  create mode 100644 block/blk-cranges.c
> 
> diff --git a/block/Makefile b/block/Makefile
> index bfbe4e13ca1e..e477e6ca9ea6 100644
> --- a/block/Makefile
> +++ b/block/Makefile
> @@ -9,7 +9,7 @@ obj-$(CONFIG_BLOCK) := bio.o elevator.o blk-core.o blk-sysfs.o \
>  			blk-lib.o blk-mq.o blk-mq-tag.o blk-stat.o \
>  			blk-mq-sysfs.o blk-mq-cpumap.o blk-mq-sched.o ioctl.o \
>  			genhd.o ioprio.o badblocks.o partitions/ blk-rq-qos.o \
> -			disk-events.o
> +			disk-events.o blk-cranges.o
>  
>  obj-$(CONFIG_BOUNCE)		+= bounce.o
>  obj-$(CONFIG_BLK_SCSI_REQUEST)	+= scsi_ioctl.o
> diff --git a/block/blk-cranges.c b/block/blk-cranges.c
> new file mode 100644
> index 000000000000..deaa09e564f7
> --- /dev/null
> +++ b/block/blk-cranges.c
> @@ -0,0 +1,295 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + *  Block device concurrent positioning ranges.
> + *
> + *  Copyright (C) 2021 Western Digital Corporation or its Affiliates.
> + */
> +#include <linux/kernel.h>
> +#include <linux/blkdev.h>
> +#include <linux/slab.h>
> +#include <linux/init.h>
> +
> +#include "blk.h"
> +
> +static ssize_t blk_crange_sector_show(struct blk_crange *cr, char *page)
> +{
> +	return sprintf(page, "%llu\n", cr->sector);
> +}
> +
> +static ssize_t blk_crange_nr_sectors_show(struct blk_crange *cr, char *page)
> +{
> +	return sprintf(page, "%llu\n", cr->nr_sectors);
> +}
> +
> +struct blk_crange_sysfs_entry {
> +	struct attribute attr;
> +	ssize_t (*show)(struct blk_crange *cr, char *page);
> +};
> +
> +static struct blk_crange_sysfs_entry blk_crange_sector_entry = {
> +	.attr = { .name = "sector", .mode = 0444 },
> +	.show = blk_crange_sector_show,
> +};
> +
> +static struct blk_crange_sysfs_entry blk_crange_nr_sectors_entry = {
> +	.attr = { .name = "nr_sectors", .mode = 0444 },
> +	.show = blk_crange_nr_sectors_show,
> +};
> +
> +static struct attribute *blk_crange_attrs[] = {
> +	&blk_crange_sector_entry.attr,
> +	&blk_crange_nr_sectors_entry.attr,
> +	NULL,
> +};
> +ATTRIBUTE_GROUPS(blk_crange);
> +
> +static ssize_t blk_crange_sysfs_show(struct kobject *kobj,
> +				     struct attribute *attr, char *page)
> +{
> +	struct blk_crange_sysfs_entry *entry;
> +	struct blk_crange *cr;
> +	struct request_queue *q;
> +	ssize_t ret;
> +
> +	entry = container_of(attr, struct blk_crange_sysfs_entry, attr);
> +	cr = container_of(kobj, struct blk_crange, kobj);
> +	q = cr->queue;

Nit: I'd find this a little eaier to read if the variables were
initialized at declaration time:

	struct blk_crange_sysfs_entry *entry =
		container_of(attr, struct blk_crange_sysfs_entry, attr);
	struct blk_crange *cr = container_of(kobj, struct blk_crange, kobj);
	struct request_queue *q = cr->queue;

(or maybe even don't bother with the q local variable).

> +/*
> + * Dummy release function to make kobj happy.
> + */
> +static void blk_cranges_sysfs_nop_release(struct kobject *kobj)
> +{
> +}

How do we ensure the kobj is still alive while it is accessed?

> +void blk_queue_set_cranges(struct gendisk *disk, struct blk_cranges *cr)

s/blk_queue/disk/

>  	mutex_lock(&q->sysfs_lock);
> +
> +	ret = blk_register_cranges(disk, NULL);
> +	if (ret) {
> +		mutex_unlock(&q->sysfs_lock);
> +		mutex_unlock(&q->sysfs_dir_lock);
> +		kobject_del(&q->kobj);
> +		blk_trace_remove_sysfs(dev);
> +		kobject_put(&dev->kobj);
> +		return ret;
> +	}
> +
>  	if (q->elevator) {
>  		ret = elv_register_queue(q, false);
>  		if (ret) {
> +			blk_unregister_cranges(disk);
>  			mutex_unlock(&q->sysfs_lock);
>  			mutex_unlock(&q->sysfs_dir_lock);
>  			kobject_del(&q->kobj);

Please use a goto instead of duplicating the code.
