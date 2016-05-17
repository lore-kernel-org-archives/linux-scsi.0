From: Mike Christie <mchristi@redhat.com>
Subject: Re: [PATCH 1/2] scsi: fix max discard sectors calculation
Date: Mon, 16 May 2016 22:46:15 -0500
Message-ID: <573A9407.1040402@redhat.com>
References: <1463424410-17196-1-git-send-email-mchristi@redhat.com>
 <1463424410-17196-2-git-send-email-mchristi@redhat.com>
 <573A4D60.7080902@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49639 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751332AbcEQDqR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 May 2016 23:46:17 -0400
In-Reply-To: <573A4D60.7080902@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, socketpair@gmail.com
Cc: stable@vger.kernel.org

On 05/16/2016 05:44 PM, Bart Van Assche wrote:
> On 05/16/2016 11:46 AM, mchristi@redhat.com wrote:
>> logical_block_size and max_blocks are 32 bits, so we can
>> overflow when trying to convert SCSI device blocks to linux
>> block layer sectors.
>>
>> Signed-off-by: Mike Christie <mchristi@redhat.com>
>> Cc: stable@vger.kernel.org
>>
>> ---
>>   drivers/scsi/sd.c | 3 ++-
>>   1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
>> index f52b74c..1668e1d 100644
>> --- a/drivers/scsi/sd.c
>> +++ b/drivers/scsi/sd.c
>> @@ -690,7 +690,8 @@ static void sd_config_discard(struct scsi_disk
>> *sdkp, unsigned int mode)
>> -    blk_queue_max_discard_sectors(q, max_blocks * (logical_block_size
>> >> 9));
>> +    blk_queue_max_discard_sectors(q, (u64)max_blocks *
>> +                      (logical_block_size >> 9));
> 
> Hello Mike,
> 
> As far as I can see max_blocks <= 0xffff (SD_MAX_WS10_BLOCKS) and 512 <=
> logical_block_size <= 4096. How can max_blocks * (logical_block_size >>
> 9) be too large for a 32 bit integer?
> 

Oops yeah, you are right. I forgot I modified the code to test the
target patch. The patch is not needed. Thanks.
