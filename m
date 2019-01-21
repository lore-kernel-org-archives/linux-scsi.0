From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH 2/2] RDMA/srp: Rework SCSI device reset handling
Date: Mon, 21 Jan 2019 13:08:14 -0800
Message-ID: <9ac0cf58-c8fc-876b-9b82-2c78416bf5fa@acm.org>
References: <20190117002717.84686-1-bvanassche@acm.org>
 <20190117002717.84686-3-bvanassche@acm.org>
 <20190119100452.GC24246@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20190119100452.GC24246@infradead.org>
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, Doug Ledford <dledford@redhat.com>, linux-rdma@vger.kernel.org, Sergey Gorenko <sergeygo@mellanox.com>, Max Gurtovoy <maxg@mellanox.com>, Laurence Oberman <loberman@redhat.com>, stable@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 1/19/19 2:04 AM, Christoph Hellwig wrote:
>> +	/* Check whether all requests have finished. */
>> +	blk_freeze_queue_start(q);
>> +	time_left = blk_mq_freeze_queue_wait_timeout(q, 1 * HZ);
>> +	blk_mq_unfreeze_queue(q);
>>   
>> +	return time_left > 0 ? SUCCESS : FAILED;
> 
> This is entirely generic SCSI/block evel functionality.  I'd rather have
> a new WAIT_FOR_FREEZE return value from ->eh_device_reset_handler and
> handle this in the SCSI midlayer.

Hi Christoph,

Since a SCSI device must only reply to a reset task management function 
after all affected commands have completed, the only case in which that 
wait code is useful is if a regular reply is sent concurrently with the 
SCSI reset reply and the two replies get reordered. Since the SCSI error 
handler is able to deal with pending commands after a device reset, how 
about leaving out the queue freeze / unfreeze code?

Thanks,

Bart.
