From: "jianchao.wang" <jianchao.w.wang@oracle.com>
Subject: Re: [PATCH] scsi: core: use blk_mq_requeue_request in
 __scsi_queue_insert
Date: Tue, 27 Feb 2018 12:00:30 +0800
Message-ID: <db9c47e6-d8ea-1e9e-609a-ff1b1db3769c@oracle.com>
References: <1519631932-1730-1-git-send-email-jianchao.w.wang@oracle.com>
 <1519700898.3120.3.camel@wdc.com>
 <3b6ca136-ba62-3eca-6eca-d191490b7754@oracle.com>
 <1519702875.3120.7.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1519702875.3120.7.camel@wdc.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "hch@lst.de" <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

Hi Bart

Thanks for your kindly response.

On 02/27/2018 11:41 AM, Bart Van Assche wrote:
> On Tue, 2018-02-27 at 11:28 +0800, jianchao.wang wrote:
>> If that is true, what if aacraid driver uses block legacy instead of blk-mq ?
>> w/ blk-mq disabled, __scsi_queue_insert just requeue the request with blk_requeue_request.
>>
>> __scsi_queue_insert
>> ...
>> 	if (q->mq_ops) {
>> 		scsi_mq_requeue_cmd(cmd);
>> 		return;
>> 	}
>> 	spin_lock_irqsave(q->queue_lock, flags);
>> 	blk_requeue_request(q, cmd->request);
>> 	kblockd_schedule_work(&device->requeue_work);
>> 	spin_unlock_irqrestore(q->queue_lock, flags);
>> ...
>>
>> no prep/unprep code there for block legacy code.
> 
> Hello Jianchao,
> 
> For the legacy block layer preparing and unpreparing a request happens from
> inside the block layer core. Please have a look at block/blk-core.c and the
> code in that file that handles the request flag RQF_DONTPREP.
Yes, thanks for your directive.

On the other hand, this patch is to align the actions between blk-mq and block legacy code in __scsi_queue_insert.
As we know, __scsi_queue_insert is just to requeue the request back to queue, as the block legacy code segment above:
for block legacy, it just blk_requeue_request for the request and kick the queue run.
However, for the blk-mq, scsi_mq_requeue_cmd will be invoked, it not only requeue the request, but also unprep request.
This is not what __scsi_queue_insert should do, but scsi_io_completion.
When the request is not finished completely, and scsi_io_completion finds it need a ACTION_REPREP, at the moment,
we need requeue and unprep there.

If I missed something, please feel free to point out. :)

Thanks
Jianchao

 

> 
> Thanks,
> 
> Bart.
> 
> 
> 
