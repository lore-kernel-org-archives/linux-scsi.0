From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: Re: [PATCH V2 00/12] scsi-mq support for ZBC disks
Date: Thu, 14 Sep 2017 09:04:13 +0900
Message-ID: <f37599b5-0cb8-175c-226c-a22e078c6f6f@wdc.com>
References: <20170907161640.30465-1-damien.lemoal@wdc.com>
 <20170908082040.GA25719@lst.de>
 <c3305202-43d3-20e3-825a-ae5fff462d54@wdc.com>
 <20170911122411.GA22255@lst.de>
 <36d21ce8-543a-39ad-c729-30f9dbd383d0@wdc.com>
 <20170913201713.GA24926@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170913201713.GA24926@lst.de>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-block@vger.kernel.org, Bart Van Assche <Bart.VanAssche@wdc.com>, Jens Axboe <axboe@kernel.dk>, Ming Lei <ming.lei@redhat.com>
List-Id: linux-scsi@vger.kernel.org

Christoph,

On 9/14/17 05:17, Christoph Hellwig wrote:
> On Tue, Sep 12, 2017 at 05:38:05PM +0900, Damien Le Moal wrote:
>> struct blk_zoned {
>> 	unsigned int nr_zones;
>> 	unsigned long *seq_zones;
>> };
>>
>> struct request_queue {
>> 	...
>> #ifdef CONFIG_BLK_DEV_ZONED
>> 	struct blk_zoned zoned;
>> #endif
>> 	...
> 
> Do we even need a new structure for it?  I'd just hang it off
> the gendisk directly.

Using a structure just seemed cleaner to me. But it is indeed not really
necessary. As for attaching this info to the gendisk, that would indeed
be equivalent. Having the struct on hand in the request queue just makes
it easier to write small helpers in blkdev.h to access the info. Hence
this choice. Should I change it ?

I have a V3 under test using the blk_zoned struct in the request queue
under test. I will post shortly.

> Except for that the idea looks fine to me.

Thanks !

-- 
Damien Le Moal,
Western Digital
