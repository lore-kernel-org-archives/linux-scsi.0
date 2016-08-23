From: Damien Le Moal <damien.lemoal@hgst.com>
Subject: Re: [PATCH v2 2/4] On Discard either do Reset WP or Write Same
Date: Tue, 23 Aug 2016 10:25:02 +0900
Message-ID: <e091a52a-3f6d-ee69-b0a7-9b57f5df6563@hgst.com>
References: <20160822043116.21168-1-shaun@tancheff.com>
 <20160822043116.21168-3-shaun@tancheff.com>
 <53c2949f-f8b9-463f-2adf-faf4603429bb@hgst.com>
 <CAJVOszBYMyx5ODyCAF6ZczC+aU_zpYS9SSfMcOzp+G38HN7BLg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAJVOszBYMyx5ODyCAF6ZczC+aU_zpYS9SSfMcOzp+G38HN7BLg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Shaun Tancheff <shaun.tancheff@seagate.com>
Cc: Shaun Tancheff <shaun@tancheff.com>, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Hannes Reinecke <hare@suse.de>, Josh Bingaman <josh.bingaman@seagate.com>, Dan Williams <dan.j.williams@intel.com>, Sagi Grimberg <sagig@mellanox.com>, Mike Christie <mchristi@redhat.com>, Toshi Kani <toshi.kani@hpe.com>, Ming Lei <ming.lei@canonical.com>
List-Id: linux-scsi@vger.kernel.org


Shaun,

On 8/23/16 09:22, Shaun Tancheff wrote:
> On Mon, Aug 22, 2016 at 6:57 PM, Damien Le Moal <damien.lemoal@hgst.com> wrote:
>>
>> Shaun,
>>
>> On 8/22/16 13:31, Shaun Tancheff wrote:
>> [...]
>>> -int sd_zbc_setup_discard(struct scsi_disk *sdkp, struct request *rq,
>>> -                      sector_t sector, unsigned int num_sectors)
>>> +int sd_zbc_setup_discard(struct scsi_cmnd *cmd)
>>>  {
>>> -     struct blk_zone *zone;
>>> +     struct request *rq = cmd->request;
>>> +     struct scsi_device *sdp = cmd->device;
>>> +     struct scsi_disk *sdkp = scsi_disk(rq->rq_disk);
>>> +     sector_t sector = blk_rq_pos(rq);
>>> +     unsigned int nr_sectors = blk_rq_sectors(rq);
>>>       int ret = BLKPREP_OK;
>>> +     struct blk_zone *zone;
>>>       unsigned long flags;
>>> +     u32 wp_offset;
>>> +     bool use_write_same = false;
>>>
>>>       zone = blk_lookup_zone(rq->q, sector);
>>> -     if (!zone)
>>> +     if (!zone) {
>>> +             /* Test for a runt zone before giving up */
>>> +             if (sdp->type != TYPE_ZBC) {
>>> +                     struct request_queue *q = rq->q;
>>> +                     struct rb_node *node;
>>> +
>>> +                     node = rb_last(&q->zones);
>>> +                     if (node)
>>> +                             zone = rb_entry(node, struct blk_zone, node);
>>> +                     if (zone) {
>>> +                             spin_lock_irqsave(&zone->lock, flags);
>>> +                             if ((zone->start + zone->len) <= sector)
>>> +                                     goto out;
>>> +                             spin_unlock_irqrestore(&zone->lock, flags);
>>> +                             zone = NULL;
>>> +                     }
>>> +             }
>>>               return BLKPREP_KILL;
>>> +     }
>>
>> I do not understand the point of this code here to test for the runt
>> zone. As long as sector is within the device maximum capacity (in 512B
>> unit), blk_lookup_zone will return the pointer to the zone structure
>> containing that sector (the RB-tree does not have any constraint
>> regarding zone size). The only case where NULL would be returned is if
>> discard is issued super early right after the disk is probed and before
>> the zone refresh work has completed. We can certainly protect against
>> that by delaying the discard.
> 
> As you can see I am not including Host Managed in the
> runt check.

Indeed, but having a runt zone could also happen with a host-managed disk.

> Also you may note that in my patch to get Host Aware working
> with the zone cache I do not include the runt zone in the cache.

Why not ? The RB-tree will handle it just fine (the insert and lookup
code as Hannes had them was not relying on a constant zone size).

> So as it sits I need this fallback otherwise doing blkdiscard over
> the whole device ends in a error, as well as mkfs.f2fs et. al.

Got it, but I do not see a problem with including it. I have not checked
the code, but the split of a big discard call into "chunks" should be
already handling the last chunk and make sure that the operation does
not exceed the device capacity (in any case, that's easy to fix in the
sd_zbc_setup_discard code).

>>>                                      zone->start, zone->state);
>>>               ret = BLKPREP_DEFER;
>>>               goto out;
>>> @@ -406,46 +428,80 @@ int sd_zbc_setup_discard(struct scsi_disk *sdkp, struct request *rq,
>>>       if (zone->state == BLK_ZONE_OFFLINE) {
>>>               /* let the drive fail the command */
>>>               sd_zbc_debug_ratelimit(sdkp,
>>> -                                    "Discarding offline zone %zu\n",
>>> +                                    "Discarding offline zone %zx\n",
>>>                                      zone->start);
>>>               goto out;
>>>       }
>>> -
>>> -     if (!blk_zone_is_smr(zone)) {
>>> +     if (blk_zone_is_cmr(zone)) {
>>> +             use_write_same = true;
>>>               sd_zbc_debug_ratelimit(sdkp,
>>> -                                    "Discarding %s zone %zu\n",
>>> -                                    blk_zone_is_cmr(zone) ? "CMR" : "unknown",
>>> +                                    "Discarding CMR zone %zx\n",
>>>                                      zone->start);
>>> -             ret = BLKPREP_DONE;
>>>               goto out;
>>>       }
>>
>> Some 10TB host managed disks out there have 1% conventional zone space,
>> that is 100GB of capacity. When issuing a "reset all", doing a write
>> same in these zones will take forever... If the user really wants zeroes
>> in those zones, let it issue a zeroout.
>>
>> I think that it would a better choice to simply not report
>> discard_zeroes_data as true and do nothing for conventional zones reset.
> 
> I think that would be unfortunate for Host Managed but I think it's
> the right choice for Host Aware at this time. So either we base
> it on disk type or we have some other config flag added to sysfs.

I do not see any difference between host managed and host aware. Both
define the same behavior for reset, and both end up in a NOP for
conventional zone reset (no data "erasure" required by the standard).
For write pointer zones, reading unwritten LBAs returns the
initialization pattern, with the exception of host-managed disks with
the URSWRZ bit set to 0. But that case is covered in sd.c, so the
behavior is consistent across all models. So why forcing data zeroing
when the standards do not mandate it ?

Best regards.

-- 
Damien Le Moal, Ph.D.
Sr. Manager, System Software Group, HGST Research,
HGST, a Western Digital brand
Damien.LeMoal@hgst.com
(+81) 0466-98-3593 (ext. 513593)
1 kirihara-cho, Fujisawa, 
Kanagawa, 252-0888 Japan
www.hgst.com
