From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH] sd: Fix a race between closing an sd device and sd I/O
Date: Mon, 25 Mar 2019 18:56:28 -0700
Message-ID: <939cd5ce-6a23-2f2b-616d-39be3440542d@acm.org>
References: <20190325170146.184414-1-bvanassche@acm.org>
 <20190326014402.GD30669@ming.t460p>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20190326014402.GD30669@ming.t460p>
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
To: Ming Lei <ming.lei@redhat.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.com>, Johannes Thumshirn <jthumshirn@suse.de>, Jason Yan <yanaijie@huawei.com>, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 3/25/19 6:44 PM, Ming Lei wrote:
> On Mon, Mar 25, 2019 at 10:01:46AM -0700, Bart Van Assche wrote:
>> The scsi_end_request() function calls scsi_cmd_to_driver() indirectly
>> and hence needs the disk->private_data pointer. Avoid that that pointer
>> is cleared before all affected I/O requests have finished. This patch
>> avoids that the following crash occurs:
>>
>> Unable to handle kernel NULL pointer dereference at virtual address 0000000000000000
>> Call trace:
>>   scsi_mq_uninit_cmd+0x1c/0x30
>>   scsi_end_request+0x7c/0x1b8
>>   scsi_io_completion+0x464/0x668
>>   scsi_finish_command+0xbc/0x160
>>   scsi_eh_flush_done_q+0x10c/0x170
>>   sas_scsi_recover_host+0x84c/0xa98 [libsas]
>>   scsi_error_handler+0x140/0x5b0
>>   kthread+0x100/0x12c
>>   ret_from_fork+0x10/0x18
>>
>> Cc: Christoph Hellwig <hch@lst.de>
>> Cc: Ming Lei <ming.lei@redhat.com>
>> Cc: Hannes Reinecke <hare@suse.com>
>> Cc: Johannes Thumshirn <jthumshirn@suse.de>
>> Cc: Jason Yan <yanaijie@huawei.com>
>> Cc: <stable@vger.kernel.org>
>> Reported-by: Jason Yan <yanaijie@huawei.com>
>> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
>> ---
>>   drivers/scsi/sd.c | 19 +++++++++++++------
>>   1 file changed, 13 insertions(+), 6 deletions(-)
>>
>> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
>> index ed34bfbc3844..0077880c0cc8 100644
>> --- a/drivers/scsi/sd.c
>> +++ b/drivers/scsi/sd.c
>> @@ -1416,11 +1416,6 @@ static void sd_release(struct gendisk *disk, fmode_t mode)
>>   			scsi_set_medium_removal(sdev, SCSI_REMOVAL_ALLOW);
>>   	}
>>   
>> -	/*
>> -	 * XXX and what if there are packets in flight and this close()
>> -	 * XXX is followed by a "rmmod sd_mod"?
>> -	 */
>> -
>>   	scsi_disk_put(sdkp);
>>   }
>>   
>> @@ -3483,9 +3478,21 @@ static void scsi_disk_release(struct device *dev)
>>   {
>>   	struct scsi_disk *sdkp = to_scsi_disk(dev);
>>   	struct gendisk *disk = sdkp->disk;
>> -	
>> +	struct request_queue *q = disk->queue;
>> +
>>   	ida_free(&sd_index_ida, sdkp->index);
>>   
>> +	/*
>> +	 * Wait until all requests that are in progress have completed.
>> +	 * This is necessary to avoid that e.g. scsi_end_request() crashes
>> +	 * due to clearing the disk->private_data pointer. Wait from inside
>> +	 * scsi_disk_release() instead of from sd_release() to avoid that
>> +	 * freezing and unfreezing the request queue affects user space I/O
>> +	 * in case multiple processes open a /dev/sd... node concurrently.
>> +	 */
>> +	blk_mq_freeze_queue(q);
>> +	blk_mq_unfreeze_queue(q);
>> +
>>   	disk->private_data = NULL;
>>   	put_disk(disk);
>>   	put_device(&sdkp->device->sdev_gendev);
> 
> No, this way may cause big performance issue, see my previous comment:
> 
> https://marc.info/?l=linux-scsi&m=155321977714715&w=2

Have you had a look at this patch? Your comment applies to the previous 
version of this patch. I don't think that it applies to the current version.

Bart.
