From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: Re: [PATCH 2/9] IB: add a proper completion queue abstraction
Date: Wed, 18 Nov 2015 15:00:57 +0100
Message-ID: <20151118140057.GC18820@lst.de>
References: <1447422410-20891-1-git-send-email-hch@lst.de> <1447422410-20891-3-git-send-email-hch@lst.de> <564B697A.2020601@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <564B697A.2020601-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org, axboe-b10kYP2dOMg@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On Tue, Nov 17, 2015 at 09:52:58AM -0800, Bart Van Assche wrote:
> On 11/13/2015 05:46 AM, Christoph Hellwig wrote:
>> + * context and does not ask from completion interrupts from the HCA.
>                                ^^^^
> Should this perhaps be changed into "for" ?

Yes.

>
>> + */
>> +void ib_process_cq_direct(struct ib_cq *cq)
>> +{
>> +	WARN_ON_ONCE(cq->poll_ctx != IB_POLL_DIRECT);
>> +
>> +	__ib_process_cq(cq, INT_MAX);
>> +}
>> +EXPORT_SYMBOL(ib_process_cq_direct);
>
> My proposal is to drop this function and to export __ib_process_cq() 
> instead (with or without renaming). That will allow callers of this 
> function to compare the poll budget with the number of completions that 
> have been processed and use that information to decide whether or not to 
> call this function again.

I'd like to keep the WARN_ON, but we can export the same signature.

Then again my preference would be to remove the direct mode entirely.

>> +static void ib_cq_completion_workqueue(struct ib_cq *cq, void *private)
>> +{
>> +	queue_work(ib_comp_wq, &cq->work);
>> +}
>
> The above code will cause all polling to occur on the context of the CPU 
> that received the completion interrupt. This approach is not powerful 
> enough. For certain workloads throughput is higher if work completions are 
> processed by another CPU core on the same CPU socket. Has it been 
> considered to make the CPU core on which work completions are processed 
> configurable ?

It's an unbound workqueue, so it's not tied to the specific CPU.  However
we'll only run the work_struct once so it's still tied to a single CPU
at a time, but that's not different from the kthread use previously.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
