Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8495CC63797
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Jul 2021 16:11:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6AE956128D
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Jul 2021 16:11:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229492AbhGVPax (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 22 Jul 2021 11:30:53 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:41864 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbhGVPaw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 22 Jul 2021 11:30:52 -0400
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 9674C2268D;
        Thu, 22 Jul 2021 16:11:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1626970286; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ArZh2zIjdqxepQL0NgzbcJkU1Qp3agot62JlYPAvHqI=;
        b=uw0sEtWbDFAP36UhtfzxxHmux4RjQnipqeMXdG2Tt+KP2L/+BHJrcCU52/b7ec+ShSXG8e
        XK0AxJr9sYuzy1A/33ZaagqG5+FJ+a519ge1YwEdc0rSbscLN/hj112e9GiGdJX57lJPl7
        FQotbzcUFJVTBOje2Rmv30Rp3gL8NUE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1626970286;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ArZh2zIjdqxepQL0NgzbcJkU1Qp3agot62JlYPAvHqI=;
        b=JBF9k91ddd4O+sdFniSg4ZLrZwUTiDRSHS5MiRurv08u7tl0e3ig4JPTLMPiB2XZWR4vJX
        3PfAP0l6jJ3xgPCw==
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap1.suse-dmz.suse.de (Postfix) with ESMTPS id 702FE13C49;
        Thu, 22 Jul 2021 16:11:26 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap1.suse-dmz.suse.de with ESMTPSA
        id Ea2zGa6Y+WCTJgAAGKfGzw
        (envelope-from <hare@suse.de>); Thu, 22 Jul 2021 16:11:26 +0000
Subject: Re: [PATCH 1/4] block: Add concurrent positioning ranges support
To:     Damien Le Moal <damien.lemoal@wdc.com>,
        linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-ide@vger.kernel.org
References: <20210721104205.885115-1-damien.lemoal@wdc.com>
 <20210721104205.885115-2-damien.lemoal@wdc.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <811ff538-bb0d-d575-faf6-871c2d3b5221@suse.de>
Date:   Thu, 22 Jul 2021 18:11:25 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210721104205.885115-2-damien.lemoal@wdc.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 7/21/21 12:42 PM, Damien Le Moal wrote:
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
>      |-- nr_sectors
>      `-- sector
> 
> For a regular single actuator device, the cranges directory does not
> exist.
> 
Hmm. I do wonder if we need such a detailed layout.
In my patch I have just:

+       unsigned int            num_lba_ranges;
+       sector_t                *lba_ranges;

to hold the information; after all, I don't expect this data to be 
changing very often during the lifetime of the OS.

> Device revalidation may lead to changes to this structure and to the
> attribute values. When manipulated, the queue sysfs_lock and
> sysfs_dir_lock are held for atomicity, similarly to how the blk-mq and
> elevator sysfs queue sub-directories are protected.
> 

Indeed, the values might change with revalidation. But not 
independently; a change in _one_ range will typically affect the 
adjacent ranges, too.
So it should be sufficient to drop them completely and redo from scratch 
for revalidation.

> The code related to the management of cranges is added in the new
> file block/blk-cranges.c.
> 
> Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
> ---
>   block/Makefile            |   2 +-
>   block/blk-cranges.c       | 286 ++++++++++++++++++++++++++++++++++++++
>   block/blk-sysfs.c         |  13 ++
>   block/blk.h               |   3 +
>   drivers/ata/libata-scsi.c |   1 +
>   include/linux/blkdev.h    |  29 ++++
>   6 files changed, 333 insertions(+), 1 deletion(-)
>   create mode 100644 block/blk-cranges.c
> 
> diff --git a/block/Makefile b/block/Makefile
> index bfbe4e13ca1e..e477e6ca9ea6 100644
> --- a/block/Makefile
> +++ b/block/Makefile
> @@ -9,7 +9,7 @@ obj-$(CONFIG_BLOCK) := bio.o elevator.o blk-core.o blk-sysfs.o \
>   			blk-lib.o blk-mq.o blk-mq-tag.o blk-stat.o \
>   			blk-mq-sysfs.o blk-mq-cpumap.o blk-mq-sched.o ioctl.o \
>   			genhd.o ioprio.o badblocks.o partitions/ blk-rq-qos.o \
> -			disk-events.o
> +			disk-events.o blk-cranges.o
>   
>   obj-$(CONFIG_BOUNCE)		+= bounce.o
>   obj-$(CONFIG_BLK_SCSI_REQUEST)	+= scsi_ioctl.o
> diff --git a/block/blk-cranges.c b/block/blk-cranges.c
> new file mode 100644
> index 000000000000..e8ff0d40a5c9
> --- /dev/null
> +++ b/block/blk-cranges.c
> @@ -0,0 +1,286 @@
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
> +
> +	mutex_lock(&q->sysfs_lock);
> +	ret = entry->show(cr, page);
> +	mutex_unlock(&q->sysfs_lock);
> +
> +	return ret;
> +}
> +
> +static const struct sysfs_ops blk_crange_sysfs_ops = {
> +	.show	= blk_crange_sysfs_show,
> +};
> +
> +/*
> + * Dummy release function to make kobj happy.
> + */
> +static void blk_cranges_sysfs_nop_release(struct kobject *kobj)
> +{
> +}
> +
> +static struct kobj_type blk_crange_ktype = {
> +	.sysfs_ops	= &blk_crange_sysfs_ops,
> +	.default_groups	= blk_crange_groups,
> +	.release	= blk_cranges_sysfs_nop_release,
> +};
> +
> +static struct kobj_type blk_cranges_ktype = {
> +	.release	= blk_cranges_sysfs_nop_release,
> +};
> +
> +/**
> + * blk_register_cranges - register with sysfs a set of concurrent ranges
> + * @disk:		Target disk
> + * @new_cranges:	New set of concurrent ranges
> + *
> + * Register with sysfs a set of concurrent ranges for @disk. If @new_cranges
> + * is not NULL, this set of concurrent ranges is registered and the
> + * old set specified by q->cranges is unregistered. Otherwise, q->cranges
> + * is registered if it is not already.
> + */
> +int blk_register_cranges(struct gendisk *disk, struct blk_cranges *new_cranges)
> +{
> +	struct request_queue *q = disk->queue;
> +	struct blk_cranges *cranges;
> +	int i, ret;
> +
> +	lockdep_assert_held(&q->sysfs_dir_lock);
> +	lockdep_assert_held(&q->sysfs_lock);
> +
> +	/* If a new range set is specified, unregister the old one */
> +	if (new_cranges) {
> +		if (q->cranges)
> +			blk_unregister_cranges(disk);
> +		q->cranges = new_cranges;
> +	}
> +
> +	cranges = q->cranges;
> +	if (!cranges)
> +		return 0;
> +
> +	/*
> +	 * At this point, q->cranges is the new set of sector ranges that needs
> +	 * to be registered with sysfs.
> +	 */
> +	WARN_ON(cranges->sysfs_registered);
> +	ret = kobject_init_and_add(&cranges->kobj, &blk_cranges_ktype,
> +				   &q->kobj, "%s", "cranges");
> +	if (ret)
> +		goto free;
> + > +	for (i = 0; i < cranges->nr_ranges; i++) {
> +		cranges->ranges[i].queue = q;
> +		ret = kobject_init_and_add(&cranges->ranges[i].kobj,
> +					   &blk_crange_ktype, &cranges->kobj,
> +					   "%d", i);
> +		if (ret)
> +			goto delete_obj;
> +	}
> +
> +	cranges->sysfs_registered = true;
> +

Do you really need independent kobj here?
As discussed above, the individual ranges are not independent, and it 
might be easier to just lump them into one structure, seeing that all of 
them will have to be redone during revalidation anyway.

> +	return 0;
> +
> +delete_obj:
> +	while (--i >= 0)
> +		kobject_del(&cranges->ranges[i].kobj);
> +	kobject_del(&cranges->kobj);
> +free:
> +	kfree(cranges);
> +	q->cranges = NULL;
> +	return ret;
> +}
> +
> +void blk_unregister_cranges(struct gendisk *disk)
> +{
> +	struct request_queue *q = disk->queue;
> +	struct blk_cranges *cranges = q->cranges;
> +	int i;
> +
> +	lockdep_assert_held(&q->sysfs_dir_lock);
> +	lockdep_assert_held(&q->sysfs_lock);
> +
> +	if (!cranges)
> +		return;
> +
> +	if (cranges->sysfs_registered) {
> +		for (i = 0; i < cranges->nr_ranges; i++)
> +			kobject_del(&cranges->ranges[i].kobj);
> +		kobject_del(&cranges->kobj);
> +	}
> +
> +	kfree(cranges);
> +	q->cranges = NULL;
> +}
> +
> +static bool blk_check_ranges(struct gendisk *disk, struct blk_cranges *cr)
> +{
> +	sector_t capacity = get_capacity(disk);
> +	sector_t min_sector = (sector_t)-1;
> +	sector_t max_sector = 0;
> +	int i;
> +
> +	/*
> +	 * Sector ranges may overlap but should overall contain all sectors
> +	 * within the disk capacity.
> +	 */
> +	for (i = 0; i < cr->nr_ranges; i++) {
> +		min_sector = min(min_sector, cr->ranges[i].sector);
> +		max_sector = max(max_sector, cr->ranges[i].sector +
> +					     cr->ranges[i].nr_sectors);
> +	}
> +

Warm fuzzy feelings.
Sector ranges may overlap? Seriously?

The only way this could happen is when a given LBA will be present in 
_two_ ranges. And this is valid?

> +	if (min_sector != 0 || max_sector < capacity) {
> +		pr_warn("Invalid concurrent ranges: missing sectors\n");
> +		return false;
> +	}
> +
> +	if (max_sector > capacity) {
> +		pr_warn("Invalid concurrent ranges: beyond capacity\n");
> +		return false;
> +	}
> +
> +	return true;
> +}
> +
> +static bool blk_cranges_changed(struct gendisk *disk, struct blk_cranges *new)
> +{
> +	struct blk_cranges *old = disk->queue->cranges;
> +	int i;
> +
> +	if (!old || old->nr_ranges != new->nr_ranges)
> +		return true;
> +
> +	for (i = 0; i < new->nr_ranges; i++) {
> +		if (old->ranges[i].sector != new->ranges[i].sector ||
> +		    old->ranges[i].nr_sectors != new->ranges[i].nr_sectors)
> +			return true;
> +	}
> +
> +	return false;
> +}
> +

As mentioned above: I doubt we need to go into such detail. Just redo 
the ranges on revalidation should be sufficient.

> +/**
> + * blk_alloc_cranges - Allocate a concurrent positioning range structure
> + * @disk:	target disk
> + * @nr_ranges:	Number of concurrent ranges
> + *
> + * Allocate a struct blk_cranges structure with @nr_ranges range descriptors.
> + */
> +struct blk_cranges *blk_alloc_cranges(struct gendisk *disk, int nr_ranges)
> +{
> +	struct blk_cranges *cr;
> +
> +	cr = kzalloc_node(struct_size(cr, ranges, nr_ranges), GFP_KERNEL,
> +			  disk->queue->node);
> +	if (cr)
> +		cr->nr_ranges = nr_ranges;
> +	return cr;
> +}
> +EXPORT_SYMBOL_GPL(blk_alloc_cranges);
> +
> +/**
> + * blk_queue_set_cranges - Set a disk concurrent positioning ranges
> + * @disk:	target disk
> + * @cr:		concurrent ranges structure
> + *
> + * Set the concurrant positioning ranges information of the request queue
> + * of @disk to @cr. If @cr is NULL and the concurrent ranges structure
> + * already set, if any, is cleared. If there are no differences between
> + * @cr and the concurrent ranges structure already set, @cr is freed.
> + */
> +void blk_queue_set_cranges(struct gendisk *disk, struct blk_cranges *cr)
> +{
> +	struct request_queue *q = disk->queue;
> +
> +	if (WARN_ON_ONCE(cr && !cr->nr_ranges)) {
> +		kfree(cr);
> +		cr = NULL;
> +	}
> +
> +	mutex_lock(&q->sysfs_dir_lock);
> +	mutex_lock(&q->sysfs_lock);
> +

And this is what you get for all the complexity.
Having to take _two_ locks, and have a detailed description how the 
function should be used.

I still think that redoing everything is simpler.

> +	if (cr && !blk_check_ranges(disk, cr)) {
> +		kfree(cr);
> +		cr = NULL;
> +	}
> +
> +	if (!blk_cranges_changed(disk, cr)) {
> +		kfree(cr);
> +		goto unlock;
> +	}
> +
> +	/*
> +	 * This may be called for a registered queue. E.g. during a device
> +	 * revalidation. If that is the case, we need to register the new set
> +	 * of concurrent ranges. If the queue is not already registered, the
> +	 * device request queue registration will register the ranges.
> +	 */
> +	if (blk_queue_registered(q)) {
> +		blk_register_cranges(disk, cr);
> +	} else {
> +		swap(q->cranges, cr);
> +		kfree(cr);
> +	}
> +
> +unlock:
> +	mutex_unlock(&q->sysfs_lock);
> +	mutex_unlock(&q->sysfs_dir_lock);
> +}
> +EXPORT_SYMBOL_GPL(blk_queue_set_cranges);
> diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
> index 370d83c18057..aeac98ecc5a0 100644
> --- a/block/blk-sysfs.c
> +++ b/block/blk-sysfs.c
> @@ -899,9 +899,21 @@ int blk_register_queue(struct gendisk *disk)
>   	}
>   
>   	mutex_lock(&q->sysfs_lock);
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
>   	if (q->elevator) {
>   		ret = elv_register_queue(q, false);
>   		if (ret) {
> +			blk_unregister_cranges(disk);
>   			mutex_unlock(&q->sysfs_lock);
>   			mutex_unlock(&q->sysfs_dir_lock);
>   			kobject_del(&q->kobj);
> @@ -985,6 +997,7 @@ void blk_unregister_queue(struct gendisk *disk)
>   	mutex_lock(&q->sysfs_lock);
>   	if (q->elevator)
>   		elv_unregister_queue(q);
> +	blk_unregister_cranges(disk);
>   	mutex_unlock(&q->sysfs_lock);
>   	mutex_unlock(&q->sysfs_dir_lock);
>   
> diff --git a/block/blk.h b/block/blk.h
> index 4b885c0f6708..650c0d87987c 100644
> --- a/block/blk.h
> +++ b/block/blk.h
> @@ -368,4 +368,7 @@ extern struct device_attribute dev_attr_events;
>   extern struct device_attribute dev_attr_events_async;
>   extern struct device_attribute dev_attr_events_poll_msecs;
>   
> +int blk_register_cranges(struct gendisk *disk, struct blk_cranges *new_cranges);
> +void blk_unregister_cranges(struct gendisk *disk);
> +
>   #endif /* BLK_INTERNAL_H */
> diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
> index b9588c52815d..144e8cac44ba 100644
> --- a/drivers/ata/libata-scsi.c
> +++ b/drivers/ata/libata-scsi.c
> @@ -1947,6 +1947,7 @@ static unsigned int ata_scsiop_inq_00(struct ata_scsi_args *args, u8 *rbuf)
>   		0xb1,	/* page 0xb1, block device characteristics page */
>   		0xb2,	/* page 0xb2, thin provisioning page */
>   		0xb6,	/* page 0xb6, zoned block device characteristics */
> +		0xb9,	/* page 0xb9, concurrent positioning ranges */
>   	};
>   
>   	num_pages = sizeof(pages);

And this hunk is here because ... ?

> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> index 3177181c4326..cd58aa1090a3 100644
> --- a/include/linux/blkdev.h
> +++ b/include/linux/blkdev.h
> @@ -378,6 +378,29 @@ static inline int blkdev_zone_mgmt_ioctl(struct block_device *bdev,
>   
>   #endif /* CONFIG_BLK_DEV_ZONED */
>   
> +/*
> + * Concurrent sector ranges: struct blk_crange describes range of
> + * contiguous sectors that can be served by independent resources on the
> + * device. The set of ranges defined in struct blk_cranges must overall
> + * include all sectors within the device capacity.
> + * For a device with multiple ranges, e.g. a single LUN multi-actuator HDD,
> + * requests targeting sectors in different ranges can be executed in parallel.
> + * A request can straddle a range boundary.
> + */
> +struct blk_crange {
> +	struct kobject		kobj;
> +	struct request_queue	*queue;
> +	sector_t		sector;
> +	sector_t		nr_sectors;
> +};
> +
> +struct blk_cranges {
> +	struct kobject		kobj;
> +	bool			sysfs_registered;
> +	unsigned int		nr_ranges;
> +	struct blk_crange	ranges[];
> +};
> +
>   struct request_queue {
>   	struct request		*last_merge;
>   	struct elevator_queue	*elevator;
> @@ -570,6 +593,9 @@ struct request_queue {
>   
>   #define BLK_MAX_WRITE_HINTS	5
>   	u64			write_hints[BLK_MAX_WRITE_HINTS];
> +
> +	/* Concurrent sector ranges */
> +	struct blk_cranges	*cranges;
>   };
>   
>   /* Keep blk_queue_flag_name[] in sync with the definitions below */
> @@ -1163,6 +1189,9 @@ extern void blk_queue_required_elevator_features(struct request_queue *q,
>   extern bool blk_queue_can_use_dma_map_merging(struct request_queue *q,
>   					      struct device *dev);
>   
> +struct blk_cranges *blk_alloc_cranges(struct gendisk *disk, int nr_ranges);
> +void blk_queue_set_cranges(struct gendisk *disk, struct blk_cranges *cr);
> +
>   /*
>    * Number of physical segments as sent to the device.
>    *
> 

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
