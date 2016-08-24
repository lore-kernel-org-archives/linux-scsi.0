From: Shaun Tancheff <shaun.tancheff@seagate.com>
Subject: Re: [PATCH v2 2/4] On Discard either do Reset WP or Write Same
Date: Wed, 24 Aug 2016 00:19:57 -0500
Message-ID: <CAJVOszBFyYOa8u3ZSuQ5L28hCkWOgWFpfMq9P35-ggu3oZAaaQ@mail.gmail.com>
References: <20160822043116.21168-1-shaun@tancheff.com> <20160822043116.21168-3-shaun@tancheff.com>
 <53c2949f-f8b9-463f-2adf-faf4603429bb@hgst.com> <CAJVOszBYMyx5ODyCAF6ZczC+aU_zpYS9SSfMcOzp+G38HN7BLg@mail.gmail.com>
 <e091a52a-3f6d-ee69-b0a7-9b57f5df6563@hgst.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <e091a52a-3f6d-ee69-b0a7-9b57f5df6563@hgst.com>
Sender: linux-block-owner@vger.kernel.org
To: Damien Le Moal <damien.lemoal@hgst.com>
Cc: Shaun Tancheff <shaun@tancheff.com>, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Hannes Reinecke <hare@suse.de>, Josh Bingaman <josh.bingaman@seagate.com>, Dan Williams <dan.j.williams@intel.com>, Sagi Grimberg <sagig@mellanox.com>, Mike Christie <mchristi@redhat.com>, Toshi Kani <toshi.kani@hpe.com>, Ming Lei <ming.lei@canonical.com>
List-Id: linux-scsi@vger.kernel.org

On Mon, Aug 22, 2016 at 8:25 PM, Damien Le Moal <damien.lemoal@hgst.com> wrote:
>
> Shaun,
>
> On 8/23/16 09:22, Shaun Tancheff wrote:
>> On Mon, Aug 22, 2016 at 6:57 PM, Damien Le Moal <damien.lemoal@hgst.com> wrote:

>> Also you may note that in my patch to get Host Aware working
>> with the zone cache I do not include the runt zone in the cache.
>
> Why not ? The RB-tree will handle it just fine (the insert and lookup
> code as Hannes had them was not relying on a constant zone size).

A good point. I didn't pay too much attention while brining this
forward. I think a few of my hacks may be pointless now. I'll
try to rework it and get rid of the runt check.

>> So as it sits I need this fallback otherwise doing blkdiscard over
>> the whole device ends in a error, as well as mkfs.f2fs et. al.
>
> Got it, but I do not see a problem with including it. I have not checked
> the code, but the split of a big discard call into "chunks" should be
> already handling the last chunk and make sure that the operation does
> not exceed the device capacity (in any case, that's easy to fix in the
> sd_zbc_setup_discard code).

Yes I agree the split of big discards does handle the last chunk correctly.

>>> Some 10TB host managed disks out there have 1% conventional zone space,
>>> that is 100GB of capacity. When issuing a "reset all", doing a write
>>> same in these zones will take forever... If the user really wants zeroes
>>> in those zones, let it issue a zeroout.
>>>
>>> I think that it would a better choice to simply not report
>>> discard_zeroes_data as true and do nothing for conventional zones reset.
>>
>> I think that would be unfortunate for Host Managed but I think it's
>> the right choice for Host Aware at this time. So either we base
>> it on disk type or we have some other config flag added to sysfs.
>
> I do not see any difference between host managed and host aware. Both
> define the same behavior for reset, and both end up in a NOP for
> conventional zone reset (no data "erasure" required by the standard).
> For write pointer zones, reading unwritten LBAs returns the
> initialization pattern, with the exception of host-managed disks with
> the URSWRZ bit set to 0. But that case is covered in sd.c, so the
> behavior is consistent across all models. So why forcing data zeroing
> when the standards do not mandate it ?

Well you do have point.
It appears to be only mkfs and similar tools that are really utilizing
discard zeros data at the moment.

I did a quick test:

mkfs -t ext4 -b 4096 -g 32768 -G 32  \
 -E lazy_itable_init=0,lazy_journal_init=0,offset=0,num_backup_sb=0,packed_meta_blocks=1,discard
  \
 -O flex_bg,extent,sparse_super2

   - discard zeroes data true - 3 minutess
   - discard zeroes data false - 6 minutes
So for the smaller conventional space on the current HA drive
there is some advantage to enabling discard zeroes data.

However for a larger conventional space you are correct the overall
impact is worse performance.

For some reason I had been assuming that some file systems
used or relied on discard zeroes data during normal operation.
Now that I am looking for that I don't seem to be finding any
evidence of it, so aside from mkfs I don't have as good an
argument discard zeroes data as I though I did.

Regards,
Shaun
