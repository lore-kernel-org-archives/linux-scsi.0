From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH 03/13] irq_poll: fold irq_poll_sched_prep into
 irq_poll_sched
Date: Tue, 29 Dec 2015 10:54:18 +0100
Message-ID: <5682584A.5030708@sandisk.com>
References: <1449521512-22921-1-git-send-email-hch@lst.de>
 <1449521512-22921-4-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1449521512-22921-4-git-send-email-hch-jcswGhMUV9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org, bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org, axboe-b10kYP2dOMg@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On 12/07/2015 09:51 PM, Christoph Hellwig wrote:
> diff --git a/lib/irq_poll.c b/lib/irq_poll.c
> index 88af879..13cb149 100644
> --- a/lib/irq_poll.c
> +++ b/lib/irq_poll.c
> @@ -21,13 +21,17 @@ static DEFINE_PER_CPU(struct list_head, blk_cpu_iopoll);
>    *
>    * Description:
>    *     Add this irq_poll structure to the pending poll list and trigger the
> - *     raise of the blk iopoll softirq. The driver must already have gotten a
> - *     successful return from irq_poll_sched_prep() before calling this.
> + *     raise of the blk iopoll softirq.
>    **/
>   void irq_poll_sched(struct irq_poll *iop)
>   {
>   	unsigned long flags;
>
> +	if (test_bit(IRQ_POLL_F_DISABLE, &iop->state))
> +		return;
> +	if (!test_and_set_bit(IRQ_POLL_F_SCHED, &iop->state))
> +		return;
> +
>   	local_irq_save(flags);
>   	list_add_tail(&iop->list, this_cpu_ptr(&blk_cpu_iopoll));
>   	__raise_softirq_irqoff(IRQ_POLL_SOFTIRQ);

After having applied these changes the SRP initiator didn't receive any 
RDMA completions anymore. I could remedy that by changing 
"!test_and_set_bit()" into "test_and_set_bit()":

diff --git a/lib/irq_poll.c b/lib/irq_poll.c
index 43a3370..3a67019 100644
--- a/lib/irq_poll.c
+++ b/lib/irq_poll.c
@@ -29,7 +29,7 @@ void irq_poll_sched(struct irq_poll *iop)

  	if (test_bit(IRQ_POLL_F_DISABLE, &iop->state))
  		return;
-	if (!test_and_set_bit(IRQ_POLL_F_SCHED, &iop->state))
+	if (test_and_set_bit(IRQ_POLL_F_SCHED, &iop->state))
  		return;

  	local_irq_save(flags);
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
