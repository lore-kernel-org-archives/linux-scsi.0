From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [PATCH v3 03/11] scsi: sd_zbc: Fix
 sd_zbc_check_zones() error checks
Date: Fri, 12 Oct 2018 07:50:11 +0000
Message-ID: <BLUPR0401MB163638186F1243B1C22674EFE7E20@BLUPR0401MB1636.namprd04.prod.outlook.com>
References: <20181012023012.29923-1-damien.lemoal@wdc.com>
	<20181012023012.29923-4-damien.lemoal@wdc.com>
	<e45aba21-baf3-caab-de83-0c36925ebfdb@suse.de>
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

On 2018/10/12 16:35, Hannes Reinecke wrote:
> On 10/12/18 4:30 AM, Damien Le Moal wrote:
>> The 32 bits overflow check for the zone size value is already done
>> within sd_zbc_check_zones() with the test:
>>
>> } else if (logical_to_sectors(sdkp->device, zone_blocks) > UINT_MAX) {
>>
>> so there is no need to check again for an out of range value in
>> sd_zbc_read_zones(). Simplify the code and fix sd_zbc_check_zones()
>> error return to -EFBIG instead of -ENODEV if the zone size is too large.
>>
>> Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
>> Reviewed-by: Christoph Hellwig <hch@lst.de>
>> ---
>>   drivers/scsi/sd_zbc.c | 15 ++++++---------
>>   1 file changed, 6 insertions(+), 9 deletions(-)
>>
>> diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
>> index ca73c46931c0..44b64b4a922a 100644
>> --- a/drivers/scsi/sd_zbc.c
>> +++ b/drivers/scsi/sd_zbc.c
>> @@ -373,7 +373,7 @@ static int sd_zbc_check_zoned_characteristics(struct scsi_disk *sdkp,
>>    * Returns the zone size in number of blocks upon success or an error code
>>    * upon failure.
>>    */
>> -static s64 sd_zbc_check_zones(struct scsi_disk *sdkp)
>> +static s32 sd_zbc_check_zones(struct scsi_disk *sdkp)
>>   {
>>   	u64 zone_blocks = 0;
>>   	sector_t max_lba, block = 0;
> Does this have to be an 's32' ?
> Seeing that it's overloaded with an error code, and never sent to any 
> hardware, can't we just make it a simple 'int' ?

OK. Will do.


-- 
Damien Le Moal
Western Digital Research
