From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 23/23] block: remove the discard_zeroes_data flag
Date: Wed, 29 Mar 2017 16:52:36 +0200
Message-ID: <7e76bdb3-c0bf-b135-a5f8-476eaeb0d67a@redhat.com>
References: <20170323143341.31549-1-hch@lst.de>
 <20170323143341.31549-24-hch@lst.de> <1490720411.2573.11.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <1490720411.2573.11.camel@sandisk.com>
Sender: linux-block-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@sandisk.com>, "agk@redhat.com" <agk@redhat.com>, "lars.ellenberg@linbit.com" <lars.ellenberg@linbit.com>, "snitzer@redhat.com" <snitzer@redhat.com>, "hch@lst.de" <hch@lst.de>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "philipp.reisner@linbit.com" <philipp.reisner@linbit.com>, "axboe@kernel.dk" <axboe@kernel.dk>, "shli@kernel.org" <shli@kernel.org>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "drbd-dev@lists.linbit.com" <drbd-dev@lists.linbit.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org



On 28/03/2017 19:00, Bart Van Assche wrote:
> On Thu, 2017-03-23 at 10:33 -0400, Christoph Hellwig wrote:
>> Now that we use the proper REQ_OP_WRITE_ZEROES operation everywhere we can
>> kill this hack.
>>
>> [ ... ]
>>
>> diff --git a/Documentation/ABI/testing/sysfs-block b/Documentation/ABI/testing/sysfs-block
>> index 2da04ce6aeef..dea212db9df3 100644
>> --- a/Documentation/ABI/testing/sysfs-block
>> +++ b/Documentation/ABI/testing/sysfs-block
>> @@ -213,14 +213,8 @@ What:		/sys/block/<disk>/queue/discard_zeroes_data
>>  Date:		May 2011
>>  Contact:	Martin K. Petersen <martin.petersen@oracle.com>
>>  Description:
>> -		Devices that support discard functionality may return
>> -		stale or random data when a previously discarded block
>> -		is read back. This can cause problems if the filesystem
>> -		expects discarded blocks to be explicitly cleared. If a
>> -		device reports that it deterministically returns zeroes
>> -		when a discarded area is read the discard_zeroes_data
>> -		parameter will be set to one. Otherwise it will be 0 and
>> -		the result of reading a discarded area is undefined.
>> +		Will always return 0.  Don't rely on any specific behavior
>> +		for discards, and don't read this file.
>>  
>>  What:		/sys/block/<disk>/queue/write_same_max_bytes
>>  Date:		January 2012
>>
>> [ ... ]
>>
>> --- a/block/blk-sysfs.c
>> +++ b/block/blk-sysfs.c
>> @@ -208,7 +208,7 @@ static ssize_t queue_discard_max_store(struct request_queue *q,
>>  
>>  static ssize_t queue_discard_zeroes_data_show(struct request_queue *q, char *page)
>>  {
>> -	return queue_var_show(queue_discard_zeroes_data(q), page);
>> +	return 0;
>>  }
> 
> Hello Christoph,
> 
> It seems to me like the documentation in Documentation/ABI/testing/sysfs-block
> and the above code are not in sync. I think the above code will cause reading
> from the discard_zeroes_data attribute to return an empty string ("") instead
> of "0\n".
> 
> BTW, my personal preference is to remove this attribute entirely because keeping
> it will cause confusion, no matter how well we document the behavior of this
> attribute.

If you remove it, you should probably remove the BLKDISCARDZEROES ioctl too.

That said, the issue with discard_zeroes_data is that it is badly
defined; it was defined as "if I unmap X, will it read as zeroes?" but
this is not how the SCSI standard defines e.g. the UNMAP command with
LBPRZ=1.  But knowing something like LBPRZ ("if something is unmapped,
will it read as zeroes?") _would_ actually be useful for userspace.
This will be especially true once sd maps lseek(SEEK_HOLE/SEEK_DATA) to
the SCSI GET LBA STATUS command, or once dm-thin supports them.

Secondarily, if the former returns 1, userspace is also interested in
knowing "can REQ_OP_WRITE_ZEROES+REQ_UNMAP ever unmap anything?", i.e.
whether BLKDEV_ZERO_NOFALLBACK will ever return anything but
-EOPNOTSUPP.  For SCSI, this should intuitively mean whether LBPWS or
LBPWS10 are set, but the details depend on how the sd driver implements
REQ_OP_WRITE_ZEROES with REQ_UNMAP.

Paolo
