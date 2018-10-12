From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [PATCH v4 03/11] scsi: sd_zbc: Fix
 sd_zbc_check_zones() error checks
Date: Fri, 12 Oct 2018 11:41:22 +0000
Message-ID: <BN3PR0401MB164067E9169258F410D40614E7E20@BN3PR0401MB1640.namprd04.prod.outlook.com>
References: <20181012100850.23316-1-damien.lemoal@wdc.com>
	<20181012100850.23316-4-damien.lemoal@wdc.com>
	<ad9d7c12-f2df-a345-895c-f23b18b1ec29@suse.de>
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

On 2018/10/12 19:23, Hannes Reinecke wrote:
> On 10/12/18 12:08 PM, Damien Le Moal wrote:
>> The unsigned 32 bits overflow check for the zone size value is already
>> done within sd_zbc_check_zones() with the test:
>>
>> } else if (logical_to_sectors(sdkp->device, zone_blocks) > UINT_MAX) {
>>
>> so there is no need to check again for an out of range value in
>> sd_zbc_read_zones(). Simplify the code and fix sd_zbc_check_zones()
>> error return to -EFBIG instead of -ENODEV if the zone size is too large.
>> Change the return type of sd_zbc_check_zones() to an int for the error
>> code and return the zone size (zone_blocks) through a u32 pointer to
>> avoid overflowing the signed 32 return value.
>>
>> Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
>> ---
>>   drivers/scsi/sd_zbc.c | 19 ++++++++-----------
>>   1 file changed, 8 insertions(+), 11 deletions(-)
>>
>> diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
>> index ca73c46931c0..0678e1e108b0 100644
>> --- a/drivers/scsi/sd_zbc.c
>> +++ b/drivers/scsi/sd_zbc.c
>> @@ -373,7 +373,7 @@ static int sd_zbc_check_zoned_characteristics(struct scsi_disk *sdkp,
>>    * Returns the zone size in number of blocks upon success or an error code
>>    * upon failure.
>>    */
>> -static s64 sd_zbc_check_zones(struct scsi_disk *sdkp)
>> +static int sd_zbc_check_zones(struct scsi_disk *sdkp, u32 *zblocks)
>>   {
>>   	u64 zone_blocks = 0;
>>   	sector_t max_lba, block = 0;
> 
> Actually I thought to just change the 's32' to 'int', and not adding 
> another parameter; but anyway.

Yes, I understood that. But since chunk_sectors is unsigned int, zone_blocks has
to be too and so returning that through an int would be asking for troubles. If
we ever have see a drive with a 2G LBA zone size that is :)
I thought it was cleaner this way.

> 
> Reviewed-by: Hannes Reinecke <hare@suse.com>

Thanks !

> 
> Hannes
> 


-- 
Damien Le Moal
Western Digital Research
