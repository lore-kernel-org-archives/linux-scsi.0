From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH 9/9] [RFC] nvme: Fix a race condition
Date: Tue, 27 Sep 2016 09:43:59 -0700
Message-ID: <9d8e0f32-6703-cf23-d424-bcecb65c2a26@sandisk.com>
References: <7948dbb8-6333-dc62-2673-4da35b4dfdbc@sandisk.com>
 <9c372b04-a194-58c4-a64f-b155b52a5244@sandisk.com>
 <013c01d218dc$8a5406c0$9efc1440$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2nam03on0084.outbound.protection.outlook.com ([104.47.42.84]:12160
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S936195AbcI0QoI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 27 Sep 2016 12:44:08 -0400
In-Reply-To: <013c01d218dc$8a5406c0$9efc1440$@opengridcomputing.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Steve Wise <swise@opengridcomputing.com>, 'Jens Axboe' <axboe@fb.com>
Cc: linux-block@vger.kernel.org, 'James Bottomley' <jejb@linux.vnet.ibm.com>, "'Martin K. Petersen'" <martin.petersen@oracle.com>, 'Mike Snitzer' <snitzer@redhat.com>, linux-rdma@vger.kernel.org, linux-nvme@lists.infradead.org, 'Keith Busch' <keith.busch@intel.com>, 'Doug Ledford' <dledford@redhat.com>, linux-scsi@vger.kernel.org, 'Christoph Hellwig' <hch@lst.de>

On 09/27/2016 09:31 AM, Steve Wise wrote:
>> @@ -2079,11 +2075,15 @@ EXPORT_SYMBOL_GPL(nvme_kill_queues);
>>  void nvme_stop_queues(struct nvme_ctrl *ctrl)
>>  {
>>  	struct nvme_ns *ns;
>> +	struct request_queue *q;
>>
>>  	mutex_lock(&ctrl->namespaces_mutex);
>>  	list_for_each_entry(ns, &ctrl->namespaces, list) {
>> -		blk_mq_cancel_requeue_work(ns->queue);
>> -		blk_mq_stop_hw_queues(ns->queue);
>> +		q = ns->queue;
>> +		blk_quiesce_queue(q);
>> +		blk_mq_cancel_requeue_work(q);
>> +		blk_mq_stop_hw_queues(q);
>> +		blk_resume_queue(q);
>>  	}
>>  	mutex_unlock(&ctrl->namespaces_mutex);
>
> Hey Bart, should nvme_stop_queues() really be resuming the blk queue?

Hello Steve,

Would you perhaps prefer that blk_resume_queue(q) is called from 
nvme_start_queues()? I think that would make the NVMe code harder to 
review. The above code won't cause any unexpected side effects if an 
NVMe namespace is removed after nvme_stop_queues() has been called and 
before nvme_start_queues() is called. Moving the blk_resume_queue(q) 
call into nvme_start_queues() will only work as expected if no 
namespaces are added nor removed between the nvme_stop_queues() and 
nvme_start_queues() calls. I'm not familiar enough with the NVMe code to 
know whether or not this change is safe ...

Bart.
