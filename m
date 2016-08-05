From: Shaun Tancheff <shaun.tancheff@seagate.com>
Subject: Re: [PATCH v6 0/2] Block layer support ZAC/ZBC commands
Date: Fri, 5 Aug 2016 15:35:58 -0500
Message-ID: <CAJVOszDt5HfSKTk_8a3AkqjjAXV_9RaA2TxeqgY5Gp90w89-Lg@mail.gmail.com>
References: <1469818955-20568-1-git-send-email-shaun@tancheff.com>
 <20160801094116.GB14677@lst.de> <CAJVOszCAb4o5LWpJL8Yd66n9jPvy+EMQX2Xfr6awZCxfGJf_CA@mail.gmail.com>
 <6a4a27ac-009d-9825-bf77-0529da77cc36@suse.de> <C7B51F39-AC67-4D96-B1DE-45C70F99134D@hgst.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <C7B51F39-AC67-4D96-B1DE-45C70F99134D@hgst.com>
Sender: linux-block-owner@vger.kernel.org
To: Damien Le Moal <Damien.LeMoal@hgst.com>
Cc: Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>, Shaun Tancheff <shaun@tancheff.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>, Jens Axboe <axboe@fb.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Jeff Layton <jlayton@poochiereds.net>, "J . Bruce Fields" <bfields@fieldses.org>, Josh Bingaman <josh.bingaman@seagate.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, Aug 2, 2016 at 8:29 PM, Damien Le Moal <Damien.LeMoal@hgst.com> wrote:
> Hannes, Shaun,
>
> Let me add some more comments.
>
>> On Aug 2, 2016, at 23:35, Hannes Reinecke <hare@suse.de> wrote:
>>
>> On 08/01/2016 07:07 PM, Shaun Tancheff wrote:
>>> On Mon, Aug 1, 2016 at 4:41 AM, Christoph Hellwig <hch@lst.de> wrote:
>>>>
>>>> Can you please integrate this with Hannes series so that it uses
>>>> his cache of the zone information?
>>>
>>> Adding Hannes and Damien to Cc.
>>>
>>> Christoph,
>>>
>>> I can make a patch the marshal Hannes' RB-Tree into to a block report, that is
>>> quite simple. I can even have the open/close/reset zone commands update the
>>> RB-Tree .. the non-private parts anyway. I would prefer to do this around the
>>> CONFIG_SD_ZBC support, offering the existing type of patch for setups that do
>>> not need the RB-Tree to function with zoned media.

I have posted patches to integrate with the zone cache, hopefully they
make sense.

>>>
>>> I do still have concerns with the approach which I have shared in smaller
>>> forums but perhaps I have to bring them to this group.
>>>
>>> First is the memory consumption. This isn't really much of a concern for large
>>> servers with few drives but I think the embedded NAS market will grumble as
>>> well as the large data pods trying to stuff 300+ drives in a chassis.
>>>
>>> As of now the RB-Tree needs to hold ~30000 zones.
>>> sizeof() reports struct blk_zone to use 120 bytes on x86_64. This yields
>>> around 3.5 MB per zoned drive attached.
>>> Which is fine if it is really needed, but most of it is fixed information
>>> and it can be significantly condensed (I have proposed 8 bytes per zone held
>>> in an array as more than adequate). Worse is that the crucial piece of
>>> information, the current wp needed for scheduling the next write, is mostly
>>> out of date because it is updated only after the write completes and zones
>>> being actively written to must work off of the last location / size that was
>>> submitted, not completed. The work around is for that tracking to be handled
>>> in the private_data member. I am not saying that updating the wp on
>>> completing a write isn’t important, I am saying that the bi_end_io hook is
>>> the existing hook that works just fine.
>>>
>> Which _actually_ is not true; with my patches I'll update the write
>> pointer prior to submit the I/O (on the reasoning that most of the time
>> I/O will succeed) and re-read the zone information if an I/O failed.
>> (Which I'll have to do anyway as after an I/O failure the write pointer
>> status is not clearly defined.)

Apologies for my mis-characterization.

>> I have thought about condensing the RB tree information, but then I
>> figured that for 'real' SMR handling we cannot assume all zones are of
>> fixed size, and hence we need all the information there.
>> Any condensing method would assume a given structure of the zones, which
>> the standard just doesn't provide.
>> Or am I missing something here?
>
> Indeed, the standards do not mandate any particular zone configuration,
> constant zone size, etc. So writing code so that can be handled is certainly
> the right way of doing things. However, if we decide to go forward with
> mapping RESET WRITE POINTER command to DISCARD, then at least a constant
> zone size (minus the last zone as you said) must be assumed, and that
> information can be removed from the entries in the RB tree (as it will be
> saved for the sysfs "zone_size" file anyway. Adding a little code to handle
> that eventual last runt zone with a different size is not a big problem.

>> As for write pointer handling: yes, the write pointer on the zones is
>> not really useful for upper-level usage.
>> Where we do need it is to detect I/O which is crossing the write pointer
>> (eg when doing reads over the entire zone).
>> As per spec you will be getting an I/O error here, so we need to split
>> the I/O on the write pointer to get valid results back.
>
> To be precise here, the I/O splitting will be handled by the block layer
> thanks to the "chunk_sectors" setting. But that relies on a constant zone
> size assumption too.
>
> The RB-tree here is most useful for reads over or after the write pointer as
> this can have different behavior on different drives (URSWRZ bit). The RB-tree
> allows us to hide these differences to upper layers and simplify support at
> those levels.

It is unfortunate that path was chosen rather than returning Made Up Data.
However I don't think this is a file system or device mapper problem as
neither of those layers attempt to read blocks they have not written
(or discarded).
All I can think of something that probes the drive media for a partition table
or other identification...isn't the conventional space sufficient to cover
those cases?
Anyway you could just handle the error and sense codes [CHECK CONDITION /
ILLEGAL REQUEST / ATTEMPT TO READ INVALID DATA] and return MUD
when URSWRZ is 0. It would have the same effect as using the zone cache
without the possibility of the zone cache being out-of-sync.

> I too agree that the write pointer value is not very useful to upper layers
> (e.g. FS). What matters most of the times for these layers is an "allocation
> pointer" or "submission pointer" which indicates the LBA to use for the next
> BIO submission. That LBA will most of the time be in advance of the zone WP
> because of request queing in the block scheduler.

Which is kind of my point.

> Note that from what we have done already, in many cases, upper layers do not
> even need this (e.g. F2FS, btrfs) and work fine without needing *any*
> zone->private_data because that "allocation pointer" information generally
> already exists in a different form (e.g. a bit in a bitmap).

Agreed. Log structured and copy on write file systems are a natural fit for
these types of drives

> For these cases, not having the RB-tree of zones would force a lot
> more code to be added to file systems for SMR support.

I don't understand how the zone cache (RB-tree) is "helping" F2FS or btrfs.
Certainly any of these could trigger the zone cache to be loaded at mkfs
and/or mount time?

>>> This all tails into domain responsibility. With the RB-Tree doing half of the
>>> work and the ‘responsible’ domain handling the active path via private_data
>>> why have the split at all? It seems to be a double work to have second object
>>> tracking the first so that I/O scheduling can function.
>>>
>> Tracking the zone states via RB trees is mainly to handly host-managed
>> drives seamlessly. Without an RB tree we will be subjected to I/O errors
>> during boot, as eg with new drives we inevitably will try to read beyond
>> the write pointer, which in turn will generate I/O errors on certain drives.

If the zone cache is needed to boot then clearly my objection to reading
in the zone report information on drive attach is unfounded. I was under
the impression that this was not the case.

>> I do agree that there is no strict need to setup an RB tree for
>> host-aware drives; I can easily add an attribute/flag to disable RB
>> trees for those.
>> However, tracking zone information in the RB tree _dramatically_ speeds
>> up device initialisation; issuing a blkdev_discard() for the entire
>> drive will take _ages_ without it.
>
> And the RB-tree will also be very useful for speeding up report zones
> ioctls too. Unless we want those to force an update of the RB-tree information ?

That is debatable. I would tend to argue for both. *If* there must be
a zone cache
then reading from the zone cache is a must. Forcing and update of the zone cache
from the media seems like a reasonable thing to be able to do.

Also the zone report is 'slow' in that there is an overhead for the
report itself but
the number of zones per query can be quite large so 4 or 5 I/Os that
run into the
hundreds if milliseconds to cache the entire drive isn't really unworkable for
something that is used infrequently.

>>> Finally is the error handling path when the RB-Tree encounters and error it
>>> attempts to requery the drive topology virtually guaranteeing that the
>>> private_data is now out-of-sync with the RB-Tree. Again this is something
>>> that can be better encapsulated in the bi_end_io to be informed of the
>>> failed I/O and schedule the appropriate recovery (including re-querying the
>>> zone information of the affected zone(s)).
>>>
>> Well, if we have an RB tree with write pointers of course we need to
>> re-read the zone information on failure (and I thought I did that?).
>> Plus the error information will be propagated via the usual mechanism,
>> so they need to take care of updating any information in ->private_data.
>>
>> I'm perfectly fine with integrating your patches for the various
>> blkdev_XX callouts and associated ioctls; Jens favours that approach,
>> too, so we should be combining those efforts.
>
> Can we agree on an interface ?
> Summarizing all the discussions we had, I am all in favor of the following:
>
> 1) A "zone_size" sysfs attribute to indicate that a drive is zoned:
> The already existing device type file can tell us if this is an host
> managed disk (type==20) or a host aware disk (type==0). Drive managed
> disks could also be detected, but since no information on their zone
> configuration can be obtained, lets treat those as regular drives.

Since disk type == 0 for everything that isn't HM so I would prefer the
sysfs 'zoned' file just report if the drive is HA or HM.

> 2) Add ioctls for zone management:
> Report zones (get information from RB tree), reset zone (simple wrapper
> to ioctl for block discard), open zone, close zone and finish zone. That
> will allow mkfs like tools to get zone information without having to parse
> thousands of sysfs files (and can also be integrated in libzbc block backend
> driver for a unified interface with the direct SG_IO path for kernels without
> the ZBC code enabled).

I can add finish zone ... but I really can't think of a use for it, myself.

> 3) Try to condense the blkzone data structure to save memory:
> I think that we can at the very least remove the zone length, and also
> may be the per zone spinlock too (a single spinlock and proper state flags can
> be used).

I have a variant that is an array of descriptors that roughly mimics the
api from blk-zoned.c that I did a few months ago as an example.
I should be able to update that to the current kernel + patches.

-- 
Shaun Tancheff
