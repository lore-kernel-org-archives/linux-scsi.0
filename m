From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH 9/9] [RFC] nvme: Fix a race condition
Date: Tue, 27 Sep 2016 10:09:20 -0700
Message-ID: <3fb86a78-de3a-b764-a493-cb5bc5b6d8b6@sandisk.com>
References: <7948dbb8-6333-dc62-2673-4da35b4dfdbc@sandisk.com>
 <9c372b04-a194-58c4-a64f-b155b52a5244@sandisk.com>
 <013c01d218dc$8a5406c0$9efc1440$@opengridcomputing.com>
 <9d8e0f32-6703-cf23-d424-bcecb65c2a26@sandisk.com>
 <1474995360.2716.19.camel@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1474995360.2716.19.camel-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: James Bottomley <jejb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, 'Jens Axboe' <axboe-b10kYP2dOMg@public.gmane.org>
Cc: linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "'Martin K. Petersen'" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, 'Mike Snitzer' <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, 'Keith Busch' <keith.busch-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Doug Ledford' <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, 'Christoph Hellwig' <hch-jcswGhMUV9g@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org



On 09/27/2016 09:56 AM, James Bottomley wrote:
> On Tue, 2016-09-27 at 09:43 -0700, Bart Van Assche wrote:
>> On 09/27/2016 09:31 AM, Steve Wise wrote:
>>>> @@ -2079,11 +2075,15 @@ EXPORT_SYMBOL_GPL(nvme_kill_queues);
>>>>  void nvme_stop_queues(struct nvme_ctrl *ctrl)
>>>>  {
>>>>  	struct nvme_ns *ns;
>>>> +	struct request_queue *q;
>>>>
>>>>  	mutex_lock(&ctrl->namespaces_mutex);
>>>>  	list_for_each_entry(ns, &ctrl->namespaces, list) {
>>>> -		blk_mq_cancel_requeue_work(ns->queue);
>>>> -		blk_mq_stop_hw_queues(ns->queue);
>>>> +		q = ns->queue;
>>>> +		blk_quiesce_queue(q);
>>>> +		blk_mq_cancel_requeue_work(q);
>>>> +		blk_mq_stop_hw_queues(q);
>>>> +		blk_resume_queue(q);
>>>>  	}
>>>>  	mutex_unlock(&ctrl->namespaces_mutex);
>>>
>>> Hey Bart, should nvme_stop_queues() really be resuming the blk
>>> queue?
>>
>> Hello Steve,
>>
>> Would you perhaps prefer that blk_resume_queue(q) is called from
>> nvme_start_queues()? I think that would make the NVMe code harder to
>> review. The above code won't cause any unexpected side effects if an
>> NVMe namespace is removed after nvme_stop_queues() has been called
>> and before nvme_start_queues() is called. Moving the
>> blk_resume_queue(q) call into nvme_start_queues() will only work as
>> expected if no namespaces are added nor removed between the
>> nvme_stop_queues() and nvme_start_queues() calls. I'm not familiar
>> enough with the NVMe code to know whether or not this change is safe
>> ...
>
> It's something that looks obviously wrong, so explain why you need to
> do it, preferably in a comment above the function.

Hello James and Steve,

I will add a comment.

Please note that the above patch does not change the behavior of 
nvme_stop_queues() except that it causes nvme_stop_queues() to wait 
until any ongoing nvme_queue_rq() calls have finished. 
blk_resume_queue() does not affect the value of the BLK_MQ_S_STOPPED bit 
that has been set by blk_mq_stop_hw_queues(). All it does is to resume 
pending blk_queue_enter() calls and to ensure that future 
blk_queue_enter() calls do not block. Even after blk_resume_queue() has 
been called if a new request is queued queue_rq() won't be invoked 
because the BLK_MQ_S_STOPPED bit is still set. Patch "dm: Fix a race 
condition related to stopping and starting queues" realizes a similar 
change in the dm driver and that change has been tested extensively.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
