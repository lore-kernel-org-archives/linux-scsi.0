From: Benny Halevy <bhalevy@panasas.com>
Subject: Re: [RFC 7/8] sd.c and sr.c move to scsi_sgtable implementation
Date: Sun, 29 Jul 2007 11:21:56 +0300
Message-ID: <46AC4E24.7040803@panasas.com>
References: <468CDB3C.4060500@panasas.com>	<468CF5A4.5040303@panasas.com> <20070726212135X.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:13978 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760258AbXG2IWW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 29 Jul 2007 04:22:22 -0400
In-Reply-To: <20070726212135X.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, bharrosh@panasas.com
Cc: James.Bottomley@SteelEye.com, akpm@linux-foundation.org, linux-scsi@vger.kernel.org

FUJITA Tomonori wrote:
> From: Boaz Harrosh <bharrosh@panasas.com>
> Subject: [RFC 7/8] sd.c and sr.c move to scsi_sgtable implementation
> Date: Thu, 05 Jul 2007 16:44:04 +0300
> 
>>   - sd and sr would adjust IO size to align on device's block
>>     size. So code needs to change once we move to scsi_sgtable
>>     implementation. (Not compatible with un-converted drivers)
>>   - Convert code to use scsi_for_each_sg
>>   - Use Data accessors wherever is appropriate.
>>
>>  Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
>> ---
>>  drivers/scsi/sd.c |   10 ++++------
>>  drivers/scsi/sr.c |   27 ++++++++++++---------------
>>  2 files changed, 16 insertions(+), 21 deletions(-)
>>
>> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
>> index 448d316..459fd23 100644
>> --- a/drivers/scsi/sd.c
>> +++ b/drivers/scsi/sd.c
>> @@ -338,7 +338,7 @@ static int sd_init_command(struct scsi_cmnd * SCpnt)
>>  	struct request *rq = SCpnt->request;
>>  	struct gendisk *disk = rq->rq_disk;
>>  	sector_t block = rq->sector;
>> -	unsigned int this_count = SCpnt->request_bufflen >> 9;
>> +	unsigned int this_count = scsi_bufflen(SCpnt) >> 9;
>>  	unsigned int timeout = sdp->timeout;
>>  
>>  	SCSI_LOG_HLQUEUE(1, scmd_printk(KERN_INFO, SCpnt,
>> @@ -418,9 +418,6 @@ static int sd_init_command(struct scsi_cmnd * SCpnt)
>>  	} else if (rq_data_dir(rq) == READ) {
>>  		SCpnt->cmnd[0] = READ_6;
>>  		SCpnt->sc_data_direction = DMA_FROM_DEVICE;
>> -	} else {
>> -		scmd_printk(KERN_ERR, SCpnt, "Unknown command %x\n", rq->cmd_flags);
>> -		return 0;
>>  	}
> 
> Why?

This seems to be dead code as rq_data_dir can only be either READ or WRITE.
The else case could be a BUG() but I don't see why it should be handled
gracefully.

> 
> 
>>  	SCSI_LOG_HLQUEUE(2, scmd_printk(KERN_INFO, SCpnt,
>> @@ -480,7 +477,8 @@ static int sd_init_command(struct scsi_cmnd * SCpnt)
>>  		SCpnt->cmnd[4] = (unsigned char) this_count;
>>  		SCpnt->cmnd[5] = 0;
>>  	}
>> -	SCpnt->request_bufflen = this_count * sdp->sector_size;
>> +	BUG_ON(!SCpnt->sgtable);
>> +	SCpnt->sgtable->length = this_count * sdp->sector_size;
>>  
>>  	/*
>>  	 * We shouldn't disconnect in the middle of a sector, so with a dumb
>> @@ -892,7 +890,7 @@ static struct block_device_operations sd_fops = {
>>  static void sd_rw_intr(struct scsi_cmnd * SCpnt)
>>  {
>>  	int result = SCpnt->result;
>> - 	unsigned int xfer_size = SCpnt->request_bufflen;
>> + 	unsigned int xfer_size = scsi_bufflen(SCpnt);
>>   	unsigned int good_bytes = result ? 0 : xfer_size;
>>   	u64 start_lba = SCpnt->request->sector;
>>   	u64 bad_lba;
>> diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
>> index f9a52af..ed61ca9 100644
>> --- a/drivers/scsi/sr.c
>> +++ b/drivers/scsi/sr.c
>> @@ -218,7 +218,7 @@ int sr_media_change(struct cdrom_device_info *cdi, int slot)
>>  static void rw_intr(struct scsi_cmnd * SCpnt)
>>  {
>>  	int result = SCpnt->result;
>> -	int this_count = SCpnt->request_bufflen;
>> +	int this_count = scsi_bufflen(SCpnt);
>>  	int good_bytes = (result == 0 ? this_count : 0);
>>  	int block_sectors = 0;
>>  	long error_sector;
>> @@ -345,23 +345,20 @@ static int sr_init_command(struct scsi_cmnd * SCpnt)
>>  	} else if (rq_data_dir(SCpnt->request) == READ) {
>>  		SCpnt->cmnd[0] = READ_10;
>>  		SCpnt->sc_data_direction = DMA_FROM_DEVICE;
>> -	} else {
>> -		blk_dump_rq_flags(SCpnt->request, "Unknown sr command");
>> -		return 0;
>>  	}
> 
> ditto.

ditto :)

> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

