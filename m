From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH 2/9] IB: add a proper completion queue abstraction
Date: Wed, 18 Nov 2015 09:55:45 +0200
Message-ID: <564C2F01.6020407@dev.mellanox.co.il>
References: <1447422410-20891-1-git-send-email-hch@lst.de>
 <1447422410-20891-3-git-send-email-hch@lst.de> <564B697A.2020601@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <564B697A.2020601-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: axboe-b10kYP2dOMg@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

Hi Bart,

>> + */
>> +void ib_process_cq_direct(struct ib_cq *cq)
>> +{
>> +    WARN_ON_ONCE(cq->poll_ctx != IB_POLL_DIRECT);
>> +
>> +    __ib_process_cq(cq, INT_MAX);
>> +}
>> +EXPORT_SYMBOL(ib_process_cq_direct);
>
> My proposal is to drop this function and to export __ib_process_cq()
> instead (with or without renaming). That will allow callers of this
> function to compare the poll budget with the number of completions that
> have been processed and use that information to decide whether or not to
> call this function again.

I agree with that.

>
>> +static void ib_cq_poll_work(struct work_struct *work)
>> +{
>> +    struct ib_cq *cq = container_of(work, struct ib_cq, work);
>> +    int completed;
>> +
>> +    completed = __ib_process_cq(cq, IB_POLL_BUDGET_WORKQUEUE);
>> +    if (completed >= IB_POLL_BUDGET_WORKQUEUE ||
>> +        ib_req_notify_cq(cq, IB_POLL_FLAGS) > 0)
>> +        queue_work(ib_comp_wq, &cq->work);
>> +}
>> +
>> +static void ib_cq_completion_workqueue(struct ib_cq *cq, void *private)
>> +{
>> +    queue_work(ib_comp_wq, &cq->work);
>> +}
>
> The above code will cause all polling to occur on the context of the CPU
> that received the completion interrupt. This approach is not powerful
> enough. For certain workloads throughput is higher if work completions
> are processed by another CPU core on the same CPU socket. Has it been
> considered to make the CPU core on which work completions are processed
> configurable ?

The workqueue is unbound. This means that the functionality you are
you are asking for exists.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
