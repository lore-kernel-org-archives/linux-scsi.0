From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [PATCH v3 09/11] block: Expose queue nr_zones in
	sysfs
Date: Fri, 12 Oct 2018 07:55:17 +0000
Message-ID: <BLUPR0401MB1636E66F2F7AA1F7D2529794E7E20@BLUPR0401MB1636.namprd04.prod.outlook.com>
References: <20181012023012.29923-1-damien.lemoal@wdc.com>
	<20181012023012.29923-10-damien.lemoal@wdc.com>
	<c13f3820-9a69-6a74-e967-b561d7778bcf@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Hannes Reinecke <hare@suse.de>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Martin K .
	Petersen" <martin.petersen@oracle.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>, Mike Snitzer <snitzer@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, Matias Bjorling <Matias.Bjorling@wdc.com>
List-Id: linux-scsi@vger.kernel.org

On 2018/10/12 16:41, Hannes Reinecke wrote:
> On 10/12/18 4:30 AM, Damien Le Moal wrote:
>> Expose through sysfs the nr_zones field of struct request_queue.
>> Exposing this value helps in debugging disk issues as well as
>> facilitating scripts based use of the disk (e.g. blktests).
>>
>> For zoned block devices, the nr_zones field indicates the total number
>> of zones of the device calculated using the known disk capacity and
>> zone size. This number of zones is always 0 for regular block devices.
>>
>> Since nr_zones is defined conditionally with CONFIG_BLK_DEV_ZONED,
>> introduce the blk_queue_nr_zones() function to return the correct value
>> for any device, regardless if CONFIG_BLK_DEV_ZONED is set.
>>
>> Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
>> ---
>>   block/blk-sysfs.c      | 11 +++++++++++
>>   include/linux/blkdev.h | 10 ++++++++++
>>   2 files changed, 21 insertions(+)
>>
>> diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
>> index 3772671cf2bc..92be8092ca4f 100644
>> --- a/block/blk-sysfs.c
>> +++ b/block/blk-sysfs.c
>> @@ -300,6 +300,11 @@ static ssize_t queue_zoned_show(struct request_queue *q, char *page)
>>   	}
>>   }
>>   
>> +static ssize_t queue_nr_zones_show(struct request_queue *q, char *page)
>> +{
>> +	return queue_var_show(blk_queue_nr_zones(q), page);
>> +}
>> +
>>   static ssize_t queue_nomerges_show(struct request_queue *q, char *page)
>>   {
>>   	return queue_var_show((blk_queue_nomerges(q) << 1) |
>> @@ -637,6 +642,11 @@ static struct queue_sysfs_entry queue_zoned_entry = {
>>   	.show = queue_zoned_show,
>>   };
>>   
>> +static struct queue_sysfs_entry queue_nr_zones_entry = {
>> +	.attr = {.name = "nr_zones", .mode = 0444 },
>> +	.show = queue_nr_zones_show,
>> +};
>> +
>>   static struct queue_sysfs_entry queue_nomerges_entry = {
>>   	.attr = {.name = "nomerges", .mode = 0644 },
>>   	.show = queue_nomerges_show,
>> @@ -727,6 +737,7 @@ static struct attribute *default_attrs[] = {
>>   	&queue_write_zeroes_max_entry.attr,
>>   	&queue_nonrot_entry.attr,
>>   	&queue_zoned_entry.attr,
>> +	&queue_nr_zones_entry.attr,
>>   	&queue_nomerges_entry.attr,
>>   	&queue_rq_affinity_entry.attr,
>>   	&queue_iostats_entry.attr,
>> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
>> index c24969b1741b..879753b10263 100644
>> --- a/include/linux/blkdev.h
>> +++ b/include/linux/blkdev.h
>> @@ -804,6 +804,11 @@ static inline unsigned int blk_queue_zone_sectors(struct request_queue *q)
>>   }
>>   
>>   #ifdef CONFIG_BLK_DEV_ZONED
>> +static inline unsigned int blk_queue_nr_zones(struct request_queue *q)
>> +{
>> +	return blk_queue_is_zoned(q) ? q->nr_zones : 0;
>> +}
>> +
>>   static inline unsigned int blk_queue_zone_no(struct request_queue *q,
>>   					     sector_t sector)
>>   {
>> @@ -819,6 +824,11 @@ static inline bool blk_queue_zone_is_seq(struct request_queue *q,
>>   		return false;
>>   	return test_bit(blk_queue_zone_no(q, sector), q->seq_zones_bitmap);
>>   }
>> +#else /* CONFIG_BLK_DEV_ZONED */
>> +static inline unsigned int blk_queue_nr_zones(struct request_queue *q)
>> +{
>> +	return 0;
>> +}
>>   #endif /* CONFIG_BLK_DEV_ZONED */
>>   
>>   static inline bool rq_is_sync(struct request *rq)
>>
> Actually, we should be checking whether we can't blank out this 
> attribute via the is_visible mechanism; after all, not every block 
> device is zoned, and those which are not have no need of the attribute...

Yes we could. But it is somewhat the same as drives that do not support trim:
they get max_discard_sectors to 0. The attribute says "not supported because the
value is 0". I followed the same principle for nr_zones: value of 0 says "no
zones", hopefully in sync with "zoned" saying "none". And if these 2 are not in
sync as such, then we have a defective drive or a bug. So actually always having
nr_zones is useful I think.

But I can make it invisible for regular disks if you insist :)

-- 
Damien Le Moal
Western Digital Research
