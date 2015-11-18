From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH 2/9] IB: add a proper completion queue abstraction
Date: Wed, 18 Nov 2015 10:20:14 -0800
Message-ID: <564CC15E.7030602@sandisk.com>
References: <1447422410-20891-1-git-send-email-hch@lst.de>
 <1447422410-20891-3-git-send-email-hch@lst.de> <564B697A.2020601@sandisk.com>
 <564C2F01.6020407@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <564C2F01.6020407-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: "axboe-b10kYP2dOMg@public.gmane.org" <axboe-b10kYP2dOMg@public.gmane.org>, "linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On 11/17/2015 11:55 PM, Sagi Grimberg wrote:
>>> +static void ib_cq_poll_work(struct work_struct *work)
>>> +{
>>> +    struct ib_cq *cq = container_of(work, struct ib_cq, work);
>>> +    int completed;
>>> +
>>> +    completed = __ib_process_cq(cq, IB_POLL_BUDGET_WORKQUEUE);
>>> +    if (completed >= IB_POLL_BUDGET_WORKQUEUE ||
>>> +        ib_req_notify_cq(cq, IB_POLL_FLAGS) > 0)
>>> +        queue_work(ib_comp_wq, &cq->work);
>>> +}
>>> +
>>> +static void ib_cq_completion_workqueue(struct ib_cq *cq, void *private)
>>> +{
>>> +    queue_work(ib_comp_wq, &cq->work);
>>> +}
>>
>> The above code will cause all polling to occur on the context of the CPU
>> that received the completion interrupt. This approach is not powerful
>> enough. For certain workloads throughput is higher if work completions
>> are processed by another CPU core on the same CPU socket. Has it been
>> considered to make the CPU core on which work completions are processed
>> configurable ?
>
> The workqueue is unbound. This means that the functionality you are
> you are asking for exists.

Hello Sagi,

Are you perhaps referring to the sysfs CPU mask that allows to control 
workqueue affinity ? I expect that setting the CPU mask for an entire 
pool through sysfs will lead to suboptimal results. What I have learned 
by tuning target systems is that there is a significant performance 
difference (> 30% IOPS) between a configuration where each completion 
thread is pinned to exactly one CPU compared to allowing the scheduler 
to choose a CPU.

Controlling the CPU affinity of worker threads with the taskset command 
is not possible since the function create_worker() in kernel/workqueue.c 
calls kthread_bind_mask(). That function sets PF_NO_SETAFFINITY. From 
sched.h:

#define PF_NO_SETAFFINITY 0x04000000 /* Userland is not allowed to 
meddle with cpus_allowed */

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
