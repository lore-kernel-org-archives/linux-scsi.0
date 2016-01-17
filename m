From: Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 07/13] IB: add a proper completion queue abstraction
Date: Sun, 17 Jan 2016 16:31:46 +0530
Message-ID: <CAG53R5VFRSLjapFS_V=f9iunKg=sXQDeB3Dy8vHaEbjxkzcw0Q@mail.gmail.com>
References: <1449521512-22921-1-git-send-email-hch@lst.de>
	<1449521512-22921-8-git-send-email-hch@lst.de>
	<CAG53R5WYHQ+w3R621KqDMLjUo9VBBjDhnJzwwJtfmo3oUWCxUg@mail.gmail.com>
	<569B5DE3.1010908@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <569B5DE3.1010908-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, axboe-b10kYP2dOMg@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

Hi Sagi,

On Sun, Jan 17, 2016 at 2:54 PM, Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> wrote:
>
>> Hi Christoph, Sagi,
>>
>> On Tue, Dec 8, 2015 at 2:21 AM, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org> wrote:
>>
>>> +static void ib_cq_poll_work(struct work_struct *work)
>>> +{
>>> +       struct ib_cq *cq = container_of(work, struct ib_cq, work);
>>> +       int completed;
>>> +
>>> +       completed = __ib_process_cq(cq, IB_POLL_BUDGET_WORKQUEUE);
>>> +       if (completed >= IB_POLL_BUDGET_WORKQUEUE ||
>>> +           ib_req_notify_cq(cq, IB_POLL_FLAGS) > 0)
>>> +               queue_work(ib_comp_wq, &cq->work);
>>> +}
>>
>>
>> In above code, Let says completion is added in a time window where
>> ib_process_cq is completed (CQ is diarmed in hw at that point) and
>> ib_req_notify_cq is yet to be called.
>> Provider vendor driver say mlx4 or mlx5 as specific case always
>> returns ib_req_notify_cq = 0.
>> Will it result into a missed notification? (so queue_work is not done).
>
>
> If we have not drained the CQ (consumed budget or more) the second
> condition (ib_req_notify_cq) will not be invoked. We are only rearming
> the CQ when we drained it completely. So I don't see how we can end up
> with missed notifications.
We drain the CQ completely for whatever CQEs available at that time,
say for example,
33 CQEs drained at time t1. So now req_notify_cq will be invoked at time t2.
During time delta t2-t1, CQ in hardware remains unarmed.
If cqes are added during that time delta, Will event/interrupt raised
for it, for CQ in unarmed state?

At time time t2, CQ is armed containing pending CQEs. Will
event/interrupt raised for those pending CQEs on next arming?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
