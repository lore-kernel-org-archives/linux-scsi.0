From: Shaun Tancheff <shaun.tancheff@seagate.com>
Subject: Re: [PATCH v6 0/2] Block layer support ZAC/ZBC commands
Date: Sat, 13 Aug 2016 19:09:06 -0500
Message-ID: <CAJVOszAHL55uOuD4MbCG0gWs3ko7tZVwtAeRBXxDhD-GuD2kGA@mail.gmail.com>
References: <1469818955-20568-1-git-send-email-shaun@tancheff.com>
 <20160801094116.GB14677@lst.de> <CAJVOszCAb4o5LWpJL8Yd66n9jPvy+EMQX2Xfr6awZCxfGJf_CA@mail.gmail.com>
 <6a4a27ac-009d-9825-bf77-0529da77cc36@suse.de> <C7B51F39-AC67-4D96-B1DE-45C70F99134D@hgst.com>
 <CAJVOszDt5HfSKTk_8a3AkqjjAXV_9RaA2TxeqgY5Gp90w89-Lg@mail.gmail.com> <2370d779-3f9b-28a2-7596-42b7b6a89c21@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <2370d779-3f9b-28a2-7596-42b7b6a89c21@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Damien Le Moal <Damien.LeMoal@hgst.com>, Christoph Hellwig <hch@lst.de>, Shaun Tancheff <shaun@tancheff.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>, Jens Axboe <axboe@fb.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Jeff Layton <jlayton@poochiereds.net>, "J . Bruce Fields" <bfields@fieldses.org>, Josh Bingaman <josh.bingaman@seagate.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, Aug 9, 2016 at 1:47 AM, Hannes Reinecke <hare@suse.de> wrote:
> On 08/05/2016 10:35 PM, Shaun Tancheff wrote:
>> On Tue, Aug 2, 2016 at 8:29 PM, Damien Le Moal <Damien.LeMoal@hgst.com> wrote:
>>> Hannes, Shaun,
>>>
>>> Let me add some more comments.
>>>
>>>> On Aug 2, 2016, at 23:35, Hannes Reinecke <hare@suse.de> wrote:
>>>>
>>>> On 08/01/2016 07:07 PM, Shaun Tancheff wrote:
>>>>> On Mon, Aug 1, 2016 at 4:41 AM, Christoph Hellwig <hch@lst.de> wrote:
>>>>>>
>>>>>> Can you please integrate this with Hannes series so that it uses
>>>>>> his cache of the zone information?
>>>>>
>>>>> Adding Hannes and Damien to Cc.
>>>>>
>>>>> Christoph,
>>>>>
>>>>> I can make a patch the marshal Hannes' RB-Tree into to a block report, that is
>>>>> quite simple. I can even have the open/close/reset zone commands update the
>>>>> RB-Tree .. the non-private parts anyway. I would prefer to do this around the
>>>>> CONFIG_SD_ZBC support, offering the existing type of patch for setups that do
>>>>> not need the RB-Tree to function with zoned media.
>>
>> I have posted patches to integrate with the zone cache, hopefully they
>> make sense.
>>
> [ .. ]
>>>> I have thought about condensing the RB tree information, but then I
>>>> figured that for 'real' SMR handling we cannot assume all zones are of
>>>> fixed size, and hence we need all the information there.
>>>> Any condensing method would assume a given structure of the zones, which
>>>> the standard just doesn't provide.
>>>> Or am I missing something here?

Of course you can condense the zone cache without loosing any
information. Here is the layout I used ... I haven't update the patch
to the latest posted patches but this is the basic idea.

[It was originally done as a follow on of making your zone cache work
 with Seagate's HA drive. I did not include the wp-in-arrays patch
 along with the HA drive support that I sent you in May as you were
 quite terse about RB trees when I tried to discuss this approach with
 you at Vault]

struct blk_zone {
        unsigned type:4;
        unsigned state:5;
        unsigned extra:7;
        unsigned wp:40;
        void *private_data;
};

struct contiguous_wps {
        u64 start_lba;
        u64 last_lba; /* or # of blocks */
        u64 zone_size; /* size in blocks */
        unsigned is_zoned:1;
        u32 zone_count;
        spinlock_t lock;
        struct blk_zone zones[0];
};

struct zone_wps {
        u32 wps_count;
        struct contiguous_wps **wps;
};

Then in struct request_queue
-    struct rb_root zones;
+   struct struct zone_wps *zones;

For each contiguous chunk of zones you need a descriptor. In the current
drives you need 1 or 2 descriptors.

Here a conventional drive is encapsulated as zoned media with one
drive sized conventional zone.

I have not spent time building an ad-hoc LVM comprised of zoned and
conventional media so it's not all ironed out yet.
I think you can see the advantage of being able to put conventional space
anywhere you would like to work around zoned media not being laid out
the the best manner for your setup.

Yes things start to break down if every other zone is a different size ..

The point being that even with supporting zones that order 48 bytes.
in size this saves a lot of space with no loss of information.
I still kind of prefer pushing blk_zone down to a u32 by reducing
the max zone size and dropping the private_data ... but that may
be going a bit too far.

blk_lookup_zone then has an [unfortunate] signature change:


/**
 * blk_lookup_zone() - Lookup zones
 * @q: Request Queue
 * @sector: Location to lookup
 * @start: Starting location zone (OUT: Required)
 * @len: Length of zone (OUT: Required)
 * @lock: Spinlock of zones (OUT: Required)
 */
struct blk_zone *blk_lookup_zone(struct request_queue *q, sector_t sector,
                                 sector_t *start, sector_t *len,
                                 spinlock_t **lock)
{
        int iter;
        struct blk_zone *bzone = NULL;
        struct zone_wps *zi = q->zones;

        *start = 0;
        *len = 0;
        *lock = NULL;

        if (!q->zones)
                goto out;

        for (iter = 0; iter < zi->wps_count; iter++) {
                if (sector >= zi->wps[iter]->start_lba &&
                    sector <  zi->wps[iter]->last_lba) {
                        struct contiguous_wps *wp = zi->wps[iter];
                        u64 index = (sector - wp->start_lba) / wp->zone_size;

                        BUG_ON(index >= wp->zone_count);

                        bzone = &wp->zones[index];
                        *len = wp->zone_size;
                        *start = wp->start_lba + (index * wp->zone_size);
                        *lock = &wp->lock;
                }
        }

out:
        return bzone;
}

>>>
>>> Indeed, the standards do not mandate any particular zone configuration,
>>> constant zone size, etc. So writing code so that can be handled is certainly
>>> the right way of doing things. However, if we decide to go forward with
>>> mapping RESET WRITE POINTER command to DISCARD, then at least a constant
>>> zone size (minus the last zone as you said) must be assumed, and that
>>> information can be removed from the entries in the RB tree (as it will be
>>> saved for the sysfs "zone_size" file anyway. Adding a little code to handle
>>> that eventual last runt zone with a different size is not a big problem.
>>
>>>> As for write pointer handling: yes, the write pointer on the zones is
>>>> not really useful for upper-level usage.
>>>> Where we do need it is to detect I/O which is crossing the write pointer
>>>> (eg when doing reads over the entire zone).
>>>> As per spec you will be getting an I/O error here, so we need to split
>>>> the I/O on the write pointer to get valid results back.
>>>
>>> To be precise here, the I/O splitting will be handled by the block layer
>>> thanks to the "chunk_sectors" setting. But that relies on a constant zone
>>> size assumption too.
>>>
>>> The RB-tree here is most useful for reads over or after the write pointer as
>>> this can have different behavior on different drives (URSWRZ bit). The RB-tree
>>> allows us to hide these differences to upper layers and simplify support at
>>> those levels.
>>
>> It is unfortunate that path was chosen rather than returning Made Up Data.
> But how would you return made up data without knowing that you _have_ to
> generate some?
> Of course it's trivial to generate made up data once an I/O error
> occurred, but that's too late as the I/O error already happened.
>
> The general idea behind this is that I _really_ do want to avoid
> triggering an I/O error on initial access. This kind of thing really
> tends to freak out users (connect a new drive and getting I/O errors;
> not the best user experience ...)
>
>> However I don't think this is a file system or device mapper problem as
>> neither of those layers attempt to read blocks they have not written
>> (or discarded).
>> All I can think of something that probes the drive media for a partition table
>> or other identification...isn't the conventional space sufficient to cover
>> those cases?
> Upon device scan the kernel will attempt to read the partition tables,
> which consists of reading the first few megabytes and the last sector
> (for GPT shadow partition tables).
> And depending on the driver manufacturer you might or might not have
> enough conventional space at the right locations.
>
>> Anyway you could just handle the error and sense codes [CHECK CONDITION /
>> ILLEGAL REQUEST / ATTEMPT TO READ INVALID DATA] and return MUD
>> when URSWRZ is 0. It would have the same effect as using the zone cache
>> without the possibility of the zone cache being out-of-sync.
>>
> Yes, but then we would already have registered an I/O error.
> And as indicated above, I really do _not_ want to handle all the
> customer calls for supposed faulty new SMR drives.

Fair enough. I just really want to be sure that all this memory locked
to the zone cache is really being made useful.

>>> I too agree that the write pointer value is not very useful to upper layers
>>> (e.g. FS). What matters most of the times for these layers is an "allocation
>>> pointer" or "submission pointer" which indicates the LBA to use for the next
>>> BIO submission. That LBA will most of the time be in advance of the zone WP
>>> because of request queing in the block scheduler.
>>
>> Which is kind of my point.
>>
>>> Note that from what we have done already, in many cases, upper layers do not
>>> even need this (e.g. F2FS, btrfs) and work fine without needing *any*
>>> zone->private_data because that "allocation pointer" information generally
>>> already exists in a different form (e.g. a bit in a bitmap).
>>
>> Agreed. Log structured and copy on write file systems are a natural fit for
>> these types of drives
>>
>>> For these cases, not having the RB-tree of zones would force a lot
>>> more code to be added to file systems for SMR support.
>>
>> I don't understand how the zone cache (RB-tree) is "helping" F2FS or btrfs.
>> Certainly any of these could trigger the zone cache to be loaded at mkfs
>> and/or mount time?
>>
>>>>> This all tails into domain responsibility. With the RB-Tree doing half of the
>>>>> work and the ‘responsible’ domain handling the active path via private_data
>>>>> why have the split at all? It seems to be a double work to have second object
>>>>> tracking the first so that I/O scheduling can function.
>>>>>
>>>> Tracking the zone states via RB trees is mainly to handly host-managed
>>>> drives seamlessly. Without an RB tree we will be subjected to I/O errors
>>>> during boot, as eg with new drives we inevitably will try to read beyond
>>>> the write pointer, which in turn will generate I/O errors on certain drives.
>>
>> If the zone cache is needed to boot then clearly my objection to reading
>> in the zone report information on drive attach is unfounded. I was under
>> the impression that this was not the case.
>>
>>>> I do agree that there is no strict need to setup an RB tree for
>>>> host-aware drives; I can easily add an attribute/flag to disable RB
>>>> trees for those.
>>>> However, tracking zone information in the RB tree _dramatically_ speeds
>>>> up device initialisation; issuing a blkdev_discard() for the entire
>>>> drive will take _ages_ without it.
>>>
>>> And the RB-tree will also be very useful for speeding up report zones
>>> ioctls too. Unless we want those to force an update of the RB-tree information ?
>>
>> That is debatable. I would tend to argue for both. *If* there must be
>> a zone cache then reading from the zone cache is a must. Forcing and
>> update of the zone cache from the media seems like a reasonable thing
>> to be able to do.
>>
>> Also the zone report is 'slow' in that there is an overhead for the
>> report itself but
>> the number of zones per query can be quite large so 4 or 5 I/Os that
>> run into the
>> hundreds if milliseconds to cache the entire drive isn't really unworkable for
>> something that is used infrequently.
>>
> No, surely not.
> But one of the _big_ advantages for the RB tree is blkdev_discard().
> Without the RB tree any mkfs program will issue a 'discard' for every
> sector. We will be able to coalesce those into one discard per zone, but
> we still need to issue one for _every_ zone.

How can you make coalesce work transparently in the
sd layer _without_ keeping some sort of a discard cache along
with the zone cache?

Currently the block layer's blkdev_issue_discard() is breaking
large discard's into nice granular and aligned chunks but it is
not preventing small discards nor coalescing them.

In the sd layer would there be way to persist or purge an
overly large discard cache? What about honoring
discard_zeroes_data? Once the discard is completed with
discard_zeroes_data you have to return zeroes whenever
a discarded sector is read. Isn't that a log more than just
tracking a write pointer? Couldn't a zone have dozens of holes?

> Which is (as indicated) really slow, and easily takes several minutes.
> With the RB tree we can short-circuit discards to empty zones, and speed
> up processing time dramatically.
> Sure we could be moving the logic into mkfs and friends, but that would
> require us to change the programs and agree on a library (libzbc?) which
> should be handling that.

F2FS's mkfs.f2fs is already reading the zone topology via SG_IO ...
so I'm not sure your argument is valid here.

[..]

>>> 3) Try to condense the blkzone data structure to save memory:
>>> I think that we can at the very least remove the zone length, and also
>>> may be the per zone spinlock too (a single spinlock and proper state flags can
>>> be used).
>>
>> I have a variant that is an array of descriptors that roughly mimics the
>> api from blk-zoned.c that I did a few months ago as an example.
>> I should be able to update that to the current kernel + patches.
>>
> Okay. If we restrict the in-kernel SMR drive handling to devices with
> identical zone sizes of course we can remove the zone length.
> And we can do away with the per-zone spinlock and use a global one instead.

I don't think dropping the zone length is a reasonable thing to do.

What I propose is an array of _descriptors_ it doesn't drop _any_
of the zone information that you are holding in an RB tree, it is
just a condensed format that _mostly_ plugs into your existing
API.

-- 
Shaun Tancheff
