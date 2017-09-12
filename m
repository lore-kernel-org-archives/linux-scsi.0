From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: Re: [PATCH V2 00/12] scsi-mq support for ZBC disks
Date: Tue, 12 Sep 2017 17:38:05 +0900
Message-ID: <36d21ce8-543a-39ad-c729-30f9dbd383d0@wdc.com>
References: <20170907161640.30465-1-damien.lemoal@wdc.com>
 <20170908082040.GA25719@lst.de>
 <c3305202-43d3-20e3-825a-ae5fff462d54@wdc.com>
 <20170911122411.GA22255@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170911122411.GA22255@lst.de>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-block@vger.kernel.org, Bart Van Assche <Bart.VanAssche@wdc.com>, Jens Axboe <axboe@kernel.dk>, Ming Lei <ming.lei@redhat.com>
List-Id: linux-scsi@vger.kernel.org

Christoph,

On 9/11/17 21:24, Christoph Hellwig wrote:
> On Fri, Sep 08, 2017 at 09:12:12AM -0700, Damien Le Moal wrote:
>> 1) The zone size and the number of zones of the device (for the bitmaps
>> allocation and offset->zone number conversion).
>> 2) Zone type for the optimization that avoids locking conventional zones.
>>
>> (2) is optional. We can do without, but still really nice to have from a
>> performance perspective as conventional zones tend to be used for
>> storing metadata. So a lot of small random writes is more likely and
>> high queue depth writing would improve performance significantly.
>>
>> For (1), the zone size is known through q->limits.chunk_sectors. But the
>> disk capacity is not known using request_queue only, so the number of
>> zones cannot be calculated... I thought of exporting it through queue
>> limits too, but then stacking of device mappers using ZBC drives becomes
>> a pain as the number of zones needs to be recalculated.
> 
> For 4.14-rc+ you should be able to easily get at the gendisk as the
> whole submission path is now gendisk based, although it might need
> some minor argument reshuffle to pass it instead of the request_queue
> in a few places.  Note that for everything passing the request
> you can get the gendisk from the request as it contains a pointer.

Thank you for the pointers. Ming also mentioned this. I will look into
it for V3. But in any case, this would only allow allocating the zone
write lock bitmap as the device number of zones can now be calculated
using the device capacity (obtained from gendisk) and the device zone
size (obtained from queue limits).

I was thinking of something else very simple, similar to the integrity
code: using a "struct blk_zoned" added to the request queue and
initialized by the low level device driver on disk revalidate. This
structure only needs the number of zones and a zone type bitmap to
indicate sequential zones.

struct blk_zoned {
	unsigned int nr_zones;
	unsigned long *seq_zones;
};

struct request_queue {
	...
#ifdef CONFIG_BLK_DEV_ZONED
	struct blk_zoned zoned;
#endif
	...
};

This would allow implementing (2) trivially and also makes the
information available to any user of the disk (FS and device mappers).

Would this be acceptable ?

> The only annoying issue is that some of our passthrough character
> device callers don't have a gendisk at all, which causes
> problems all over and should probably be fixed at some point.

pass-through requests are completely ignored for zoned block devices and
processed as they come. Any kind of reordering control is the
responsibility of users.

Best regards

-- 
Damien Le Moal,
Western Digital
