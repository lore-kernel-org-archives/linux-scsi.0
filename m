From: Sagi Grimberg <sagig@dev.mellanox.co.il>
Subject: Re: [PATCH 05/14] block: Deprecate the use of the term sector in
 the context of block integrity
Date: Thu, 03 Jul 2014 13:19:37 +0300
Message-ID: <53B52E39.1080309@dev.mellanox.co.il>
References: <1401334128-15499-1-git-send-email-martin.petersen@oracle.com> <1401334128-15499-6-git-send-email-martin.petersen@oracle.com> <53B523FA.2000001@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wi0-f182.google.com ([209.85.212.182]:48171 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754155AbaGCKTn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Jul 2014 06:19:43 -0400
Received: by mail-wi0-f182.google.com with SMTP id bs8so1928917wib.15
        for <linux-scsi@vger.kernel.org>; Thu, 03 Jul 2014 03:19:39 -0700 (PDT)
In-Reply-To: <53B523FA.2000001@dev.mellanox.co.il>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>, axboe@fb.com, nab@daterainc.com, linux-scsi@vger.kernel.org

On 7/3/2014 12:35 PM, Sagi Grimberg wrote:
> On 5/29/2014 6:28 AM, Martin K. Petersen wrote:
>> The protection interval is not necessarily tied to the logical block
>> size of a block device. Stop using the terms sector and sectors.
>>
>> Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
>> ---
>>   block/bio-integrity.c  | 46 
>> +++++++++++++++++++++-------------------------
>>   block/blk-integrity.c  | 10 +++++-----
>>   drivers/scsi/sd_dif.c  | 46 
>> +++++++++++++++++++++++-----------------------
>>   include/linux/blkdev.h |  6 +++---
>>   4 files changed, 52 insertions(+), 56 deletions(-)
>>
>> diff --git a/block/bio-integrity.c b/block/bio-integrity.c
>> index e06b3c807eef..c52a8fd98706 100644
>> --- a/block/bio-integrity.c
>> +++ b/block/bio-integrity.c
>> @@ -191,29 +191,25 @@ bool bio_integrity_enabled(struct bio *bio)
>>   EXPORT_SYMBOL(bio_integrity_enabled);
>>     /**
>> - * bio_integrity_hw_sectors - Convert 512b sectors to hardware ditto
>> + * bio_integrity_intervals - Return number of integrity intervals 
>> for a bio
>>    * @bi:        blk_integrity profile for device
>> - * @sectors:    Number of 512 sectors to convert
>> + * @sectors:    Size of the bio in 512-byte sectors
>>    *
>>    * Description: The block layer calculates everything in 512 byte
>> - * sectors but integrity metadata is done in terms of the hardware
>> - * sector size of the storage device.  Convert the block layer sectors
>> - * to physical sectors.
>> + * sectors but integrity metadata is done in terms of the data 
>> integrity
>> + * interval size of the storage device.  Convert the block layer 
>> sectors
>> + * to the appropriate number of integrity intervals.
>>    */
>> -static inline unsigned int bio_integrity_hw_sectors(struct 
>> blk_integrity *bi,
>> -                            unsigned int sectors)
>> +static inline unsigned int bio_integrity_intervals(struct 
>> blk_integrity *bi,
>> +                           unsigned int sectors)
>>   {
>> -    /* At this point there are only 512b or 4096b DIF/EPP devices */
>> -    if (bi->sector_size == 4096)
>> -        return sectors >>= 3;
>> -
>> -    return sectors;
>> +    return sectors >> (ilog2(bi->interval) - 9);
>>   }
>
> Now that protection information interval does not necessarily match 
> the sector_size, should this routine
> protect against bogus bi->interval (e.g. fail if bi->interval < 
> sector_size for example)? Not sure
> if this check is really needed here, but it might be useful to have 
> (although protection interval
> is still effectively sector_size).
>

For v1 scsi_transfer_length should also be modified to use protection 
interval.

Sagi.
