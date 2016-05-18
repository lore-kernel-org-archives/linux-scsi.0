From: Mike Christie <mchristi@redhat.com>
Subject: Re: [PATCH 2/2] target: fix max discard sectors calculation
Date: Wed, 18 May 2016 12:17:57 -0500
Message-ID: <573CA3C5.7050205@redhat.com>
References: <1463424410-17196-1-git-send-email-mchristi@redhat.com>
 <1463424410-17196-3-git-send-email-mchristi@redhat.com>
 <573A1826.3050007@sandisk.com> <yq1y479hlmp.fsf@sermon.lab.mkp.net>
 <573B6006.8010206@sandisk.com> <573B91D7.8020002@redhat.com>
 <573C9EB1.1090208@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33387 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932727AbcERRR7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 18 May 2016 13:17:59 -0400
In-Reply-To: <573C9EB1.1090208@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, socketpair@gmail.com, stable@vger.kernel.org

On 05/18/2016 11:56 AM, Bart Van Assche wrote:
> On 05/17/2016 02:49 PM, Mike Christie wrote:
>> --- a/drivers/target/target_core_device.c
>> +++ b/drivers/target/target_core_device.c
>> @@ -821,13 +821,15 @@ struct se_device *target_alloc_device(struct
>> se_hba *hba, const char *name)
>>    * in ATA and we need to set TPE=1
>>    */
>>   bool target_configure_unmap_from_queue(struct se_dev_attrib *attrib,
>> -                       struct request_queue *q, int block_size)
>> +                       struct request_queue *q)
>>   {
>> +    unsigned short block_size = queue_logical_block_size(q);
>> +
>>       if (!blk_queue_discard(q))
>>           return false;
>>
>> -    attrib->max_unmap_lba_count = (q->limits.max_discard_sectors << 9) /
>> -                                block_size;
>> +    attrib->max_unmap_lba_count = queue_sector_to_logical(q,
>> +                        q->limits.max_discard_sectors);
>>       /*
>>        * Currently hardcoded to 1 in Linux/SCSI code..
>>        */
>> diff --git a/drivers/target/target_core_file.c
>> b/drivers/target/target_core_file.c
>> index 75f0f08..7929186 100644
>> --- a/drivers/target/target_core_file.c
>> +++ b/drivers/target/target_core_file.c
>> @@ -161,8 +161,7 @@ static int fd_configure_device(struct se_device *dev)
>>               dev_size, div_u64(dev_size, fd_dev->fd_block_size),
>>               fd_dev->fd_block_size);
>>
>> -        if (target_configure_unmap_from_queue(&dev->dev_attrib, q,
>> -                              fd_dev->fd_block_size))
>> +        if (target_configure_unmap_from_queue(&dev->dev_attrib, q))
>>               pr_debug("IFILE: BLOCK Discard support available,"
>>                    " disabled by default\n");
>>           /*
>> diff --git a/drivers/target/target_core_iblock.c
>> b/drivers/target/target_core_iblock.c
>> index 026a758..3cbe060 100644
>> --- a/drivers/target/target_core_iblock.c
>> +++ b/drivers/target/target_core_iblock.c
>> @@ -121,8 +121,7 @@ static int iblock_configure_device(struct
>> se_device *dev)
>>       dev->dev_attrib.hw_max_sectors = queue_max_hw_sectors(q);
>>       dev->dev_attrib.hw_queue_depth = q->nr_requests;
>>
>> -    if (target_configure_unmap_from_queue(&dev->dev_attrib, q,
>> -                          dev->dev_attrib.hw_block_size))
>> +    if (target_configure_unmap_from_queue(&dev->dev_attrib, q))
>>           pr_debug("IBLOCK: BLOCK Discard support available,"
>>                " disabled by default\n");
>>
>> [ ... ]
> 
> Hello Mike,
> 
> Are you sure that LIO guarantees that dev_attrib.hw_block_size is
> identical to queue_logical_block_size(q)? The other changes in this
> patch look like a nice improvement to me.
> 

Yeah. In iblock a line above where patch/diff started from above we do:

        dev->dev_attrib.hw_block_size = bdev_logical_block_size(bd);


For the file setup code path we do:

fd_dev->fd_block_size = bdev_logical_block_size(inode->i_bdev);

and then a couple lines later we did:

if (target_configure_unmap_from_queue(&dev->dev_attrib, q,
				fd_dev->fd_block_size))


