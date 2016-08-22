From: Shaun Tancheff <shaun.tancheff@seagate.com>
Subject: Re: [PATCH 2/2] Migrate zone cache from RB-Tree to arrays of descriptors
Date: Mon, 22 Aug 2016 10:43:29 -0500
Message-ID: <CAJVOszDeLZH2+ifPEBKc=-VRkqUKHauTiS5CVF6d-F4qfT8epA@mail.gmail.com>
References: <20160822043402.8855-1-shaun@tancheff.com> <20160822043402.8855-3-shaun@tancheff.com>
 <ad5c983d-ae7c-bd5b-edef-b56552c3038b@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <ad5c983d-ae7c-bd5b-edef-b56552c3038b@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Shaun Tancheff <shaun@tancheff.com>, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>, Jens Axboe <axboe@fb.com>, Christoph Hellwig <hch@lst.de>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Damien Le Moal <damien.lemoal@hgst.com>, Dan Williams <dan.j.williams@intel.com>, Sagi Grimberg <sagig@mellanox.com>, Mike Christie <mchristi@redhat.com>, Ming Lei <ming.lei@canonical.com>, Josh Bingaman <josh.bingaman@seagate.com>
List-Id: linux-scsi@vger.kernel.org

On Mon, Aug 22, 2016 at 2:11 AM, Hannes Reinecke <hare@suse.de> wrote:
> On 08/22/2016 06:34 AM, Shaun Tancheff wrote:
>> Currently the RB-Tree zone cache is fast and flexible. It does
>> use a rather largish amount of ram. This model reduces the ram
>> required from 120 bytes per zone to 16 bytes per zone with a
>> moderate transformation of the blk_zone_lookup() api.
>>
>> This model is predicated on the belief that most variations
>> on zoned media will follow a pattern of using collections of same
>> sized zones on a single device. Similar to the pattern of erase
>> blocks on flash devices being progressivly larger 16K, 64K, ...
>>
>> The goal is to be able to build a descriptor which is both memory
>> efficient, performant, and flexible.
>>
>> Signed-off-by: Shaun Tancheff <shaun.tancheff@seagate.com>
>> ---
>>  block/blk-core.c       |    2 +-
>>  block/blk-sysfs.c      |   31 +-
>>  block/blk-zoned.c      |  103 +++--
>>  drivers/scsi/sd.c      |    5 +-
>>  drivers/scsi/sd.h      |    4 +-
>>  drivers/scsi/sd_zbc.c  | 1025 +++++++++++++++++++++++++++---------------------
>>  include/linux/blkdev.h |   82 +++-
>>  7 files changed, 716 insertions(+), 536 deletions(-)

> Have you measure the performance impact here?

As far as actual hardware (HostAware) I am seeing the same
I/O performance. I suspect its just that below 100k iops the
zone cache just isn't a bottleneck.

> The main idea behind using an RB-tree is that each single element will
> fit in the CPU cache; using an array will prevent that.
> So we will increase the number of cache flushes, and most likely a
> performance penalty, too.
> Hence I'd rather like to see a performance measurement here before going
> down that road.

I think it will have to be a simulated benchmark, if that's okay.

Of course I'm open to suggestions if there is something you have in mind.
-- 
Regards,
Shaun Tancheff
