From: Shaun Tancheff <shaun.tancheff@seagate.com>
Subject: Re: [PATCH v2 2/4] On Discard either do Reset WP or Write Same
Date: Mon, 22 Aug 2016 19:22:36 -0500
Message-ID: <CAJVOszBYMyx5ODyCAF6ZczC+aU_zpYS9SSfMcOzp+G38HN7BLg@mail.gmail.com>
References: <20160822043116.21168-1-shaun@tancheff.com> <20160822043116.21168-3-shaun@tancheff.com>
 <53c2949f-f8b9-463f-2adf-faf4603429bb@hgst.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-00003501.pphosted.com ([67.231.144.15]:32861 "EHLO
        mx0a-000cda01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752930AbcHWAW6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 22 Aug 2016 20:22:58 -0400
Received: from pps.filterd (m0075552.ppops.net [127.0.0.1])
        by mx0a-00003501.pphosted.com (8.16.0.17/8.16.0.17) with SMTP id u7N0KN5I030364
        for <linux-scsi@vger.kernel.org>; Mon, 22 Aug 2016 20:22:57 -0400
Received: from mail-qk0-f197.google.com (mail-qk0-f197.google.com [209.85.220.197])
        by mx0a-00003501.pphosted.com with ESMTP id 250409a4hk-12
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Mon, 22 Aug 2016 20:22:57 -0400
Received: by mail-qk0-f197.google.com with SMTP id m184so264773471qkb.2
        for <linux-scsi@vger.kernel.org>; Mon, 22 Aug 2016 17:22:57 -0700 (PDT)
In-Reply-To: <53c2949f-f8b9-463f-2adf-faf4603429bb@hgst.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Damien Le Moal <damien.lemoal@hgst.com>
Cc: Shaun Tancheff <shaun@tancheff.com>, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Hannes Reinecke <hare@suse.de>, Josh Bingaman <josh.bingaman@seagate.com>, Dan Williams <dan.j.williams@intel.com>, Sagi Grimberg <sagig@mellanox.com>, Mike Christie <mchristi@redhat.com>, Toshi Kani <toshi.kani@hpe.com>, Ming Lei <ming.lei@canonical.com>

On Mon, Aug 22, 2016 at 6:57 PM, Damien Le Moal <damien.lemoal@hgst.com> wrote:
>
> Shaun,
>
> On 8/22/16 13:31, Shaun Tancheff wrote:
> [...]
>> -int sd_zbc_setup_discard(struct scsi_disk *sdkp, struct request *rq,
>> -                      sector_t sector, unsigned int num_sectors)
>> +int sd_zbc_setup_discard(struct scsi_cmnd *cmd)
>>  {
>> -     struct blk_zone *zone;
>> +     struct request *rq = cmd->request;
>> +     struct scsi_device *sdp = cmd->device;
>> +     struct scsi_disk *sdkp = scsi_disk(rq->rq_disk);
>> +     sector_t sector = blk_rq_pos(rq);
>> +     unsigned int nr_sectors = blk_rq_sectors(rq);
>>       int ret = BLKPREP_OK;
>> +     struct blk_zone *zone;
>>       unsigned long flags;
>> +     u32 wp_offset;
>> +     bool use_write_same = false;
>>
>>       zone = blk_lookup_zone(rq->q, sector);
>> -     if (!zone)
>> +     if (!zone) {
>> +             /* Test for a runt zone before giving up */
>> +             if (sdp->type != TYPE_ZBC) {
>> +                     struct request_queue *q = rq->q;
>> +                     struct rb_node *node;
>> +
>> +                     node = rb_last(&q->zones);
>> +                     if (node)
>> +                             zone = rb_entry(node, struct blk_zone, node);
>> +                     if (zone) {
>> +                             spin_lock_irqsave(&zone->lock, flags);
>> +                             if ((zone->start + zone->len) <= sector)
>> +                                     goto out;
>> +                             spin_unlock_irqrestore(&zone->lock, flags);
>> +                             zone = NULL;
>> +                     }
>> +             }
>>               return BLKPREP_KILL;
>> +     }
>
> I do not understand the point of this code here to test for the runt
> zone. As long as sector is within the device maximum capacity (in 512B
> unit), blk_lookup_zone will return the pointer to the zone structure
> containing that sector (the RB-tree does not have any constraint
> regarding zone size). The only case where NULL would be returned is if
> discard is issued super early right after the disk is probed and before
> the zone refresh work has completed. We can certainly protect against
> that by delaying the discard.

As you can see I am not including Host Managed in the
runt check.

Also you may note that in my patch to get Host Aware working
with the zone cache I do not include the runt zone in the cache.
So as it sits I need this fallback otherwise doing blkdiscard over
the whole device ends in a error, as well as mkfs.f2fs et. al.

>>       spin_lock_irqsave(&zone->lock, flags);
>> -
>>       if (zone->state == BLK_ZONE_UNKNOWN ||
>>           zone->state == BLK_ZONE_BUSY) {
>>               sd_zbc_debug_ratelimit(sdkp,
>> -                                    "Discarding zone %zu state %x, deferring\n",
>> +                                    "Discarding zone %zx state %x, deferring\n",
>
> Sector values are usually displayed in decimal. Why use Hex here ? At
> least "0x" would be needed to avoid confusion I think.

Yeah, my brain is lazy about converting very large
numbers to powers of 2. So it's much easier to spot
zone alignment here.



>>                                      zone->start, zone->state);
>>               ret = BLKPREP_DEFER;
>>               goto out;
>> @@ -406,46 +428,80 @@ int sd_zbc_setup_discard(struct scsi_disk *sdkp, struct request *rq,
>>       if (zone->state == BLK_ZONE_OFFLINE) {
>>               /* let the drive fail the command */
>>               sd_zbc_debug_ratelimit(sdkp,
>> -                                    "Discarding offline zone %zu\n",
>> +                                    "Discarding offline zone %zx\n",
>>                                      zone->start);
>>               goto out;
>>       }
>> -
>> -     if (!blk_zone_is_smr(zone)) {
>> +     if (blk_zone_is_cmr(zone)) {
>> +             use_write_same = true;
>>               sd_zbc_debug_ratelimit(sdkp,
>> -                                    "Discarding %s zone %zu\n",
>> -                                    blk_zone_is_cmr(zone) ? "CMR" : "unknown",
>> +                                    "Discarding CMR zone %zx\n",
>>                                      zone->start);
>> -             ret = BLKPREP_DONE;
>>               goto out;
>>       }
>
> Some 10TB host managed disks out there have 1% conventional zone space,
> that is 100GB of capacity. When issuing a "reset all", doing a write
> same in these zones will take forever... If the user really wants zeroes
> in those zones, let it issue a zeroout.
>
> I think that it would a better choice to simply not report
> discard_zeroes_data as true and do nothing for conventional zones reset.

I think that would be unfortunate for Host Managed but I think it's
the right choice for Host Aware at this time. So either we base
it on disk type or we have some other config flag added to sysfs.

>> -     if (blk_zone_is_empty(zone)) {
>> -             sd_zbc_debug_ratelimit(sdkp,
>> -                                    "Discarding empty zone %zu\n",
>> -                                    zone->start);
>> -             ret = BLKPREP_DONE;
>> +     if (zone->start != sector || zone->len < nr_sectors) {
>> +             sd_printk(KERN_ERR, sdkp,
>> +                       "Misaligned RESET WP %zx/%x on zone %zx/%zx\n",
>> +                       sector, nr_sectors, zone->start, zone->len);
>> +             ret = BLKPREP_KILL;
>>               goto out;
>>       }
>> -
>> -     if (zone->start != sector ||
>> -         zone->len < num_sectors) {
>> +     /* Protect against Reset WP when more data had been written to the
>> +      * zone than is being discarded.
>> +      */
>> +     wp_offset = zone->wp - zone->start;
>> +     if (wp_offset > nr_sectors) {
>>               sd_printk(KERN_ERR, sdkp,
>> -                       "Misaligned RESET WP, start %zu/%zu "
>> -                       "len %zu/%u\n",
>> -                       zone->start, sector, zone->len, num_sectors);
>> +                       "Will Corrupt RESET WP %zx/%x/%x on zone %zx/%zx/%zx\n",
>> +                       sector, wp_offset, nr_sectors,
>> +                       zone->start, zone->wp, zone->len);
>>               ret = BLKPREP_KILL;
>>               goto out;
>>       }

---
Shaun Tancheff
