From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 04/14] fcoe: create/destroy fcoe Rx threads on CPU
	hotplug events
Date: Mon, 23 Mar 2009 00:59:16 +0000
Message-ID: <1237769956.4712.14.camel@localhost.localdomain>
References: <20090317184124.22987.65368.stgit@fritz>
	 <20090317184145.22987.97528.stgit@fritz>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:47110 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757198AbZCWA7T (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 22 Mar 2009 20:59:19 -0400
In-Reply-To: <20090317184145.22987.97528.stgit@fritz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Robert Love <robert.w.love@intel.com>
Cc: linux-scsi@vger.kernel.org

On Tue, 2009-03-17 at 11:41 -0700, Robert Love wrote:
> This patch adds support for dynamically created Rx threads
> upon CPU hotplug events.
> 
> There were existing synchronization problems that this patch
> attempts to resolve. The main problem had to do with fcoe_rcv()
> running in a different context than the hotplug notifications.
> This opened the possiblity that fcoe_rcv() would target a Rx
> thread for a skb. However, that thread could become NULL if
> the CPU was made offline.
> 
> This patch uses the Rx queue's (a skb_queue) lock to protect
> the thread it's associated with and we use the 'thread' member
> of the fcoe_percpu_s to determine if the thread is ready to
> accept new skbs.
> 
> The patch also attempts to do a better job of cleaning up, both
> if hotplug registration fails as well as when the module is
> removed.
> 
> Contribution provided by Joe Eykholt <jeykholt@cisco.com> to
> fix incorrect use of __cpuinitdata.
> 
> Signed-off-by: Yi Zou <yi.zou@intel.com>
> Signed-off-by: Robert Love <robert.w.love@intel.com>
> ---
> 
>  drivers/scsi/fcoe/libfcoe.c |  246 +++++++++++++++++++++++++++++++++++--------
>  1 files changed, 199 insertions(+), 47 deletions(-)
> 
> diff --git a/drivers/scsi/fcoe/libfcoe.c b/drivers/scsi/fcoe/libfcoe.c
> index 648a2fc..951d244 100644
> --- a/drivers/scsi/fcoe/libfcoe.c
> +++ b/drivers/scsi/fcoe/libfcoe.c
> @@ -81,6 +81,156 @@ static struct notifier_block fcoe_notifier = {
>  };
>  
>  /**
> + * fcoe_percpu_thread_create() - Create a receive thread for an online cpu
> + * @cpu: cpu index for the online cpu
> + */
> +static void fcoe_percpu_thread_create(unsigned int cpu)
> +{
> +	struct fcoe_percpu_s *p;
> +	struct task_struct *thread;
> +
> +	p = &per_cpu(fcoe_percpu, cpu);
> +
> +	thread = kthread_create(fcoe_percpu_receive_thread,
> +				(void *)p, "fcoethread/%d", cpu);
> +
> +	if (likely(!IS_ERR(p->thread))) {
> +		kthread_bind(thread, cpu);
> +		wake_up_process(thread);
> +
> +		spin_lock_bh(&p->fcoe_rx_list.lock);
> +		p->thread = thread;
> +		spin_unlock_bh(&p->fcoe_rx_list.lock);
> +	}
> +}
> +
> +/**
> + * fcoe_percpu_thread_destroy() - removes the rx thread for the given cpu
> + * @cpu: cpu index the rx thread is to be removed
> + *
> + * Destroys a per-CPU Rx thread. Any pending skbs are moved to the
> + * current CPU's Rx thread. If the thread being destroyed is bound to
> + * the CPU processing this context the skbs will be freed.
> + */
> +static void fcoe_percpu_thread_destroy(unsigned int cpu)
> +{
> +	struct fcoe_percpu_s *p;
> +	struct task_struct *thread;
> +	struct page *crc_eof;
> +	struct sk_buff *skb;
> +#ifdef CONFIG_SMP
> +	struct fcoe_percpu_s *p0;
> +	unsigned targ_cpu = smp_processor_id();
> +#endif /* CONFIG_SMP */
> +
> +	printk(KERN_DEBUG "fcoe: Destroying receive thread for CPU %d\n", cpu);
> +
> +	/* Prevent any new skbs from being queued for this CPU. */
> +	p = &per_cpu(fcoe_percpu, cpu);
> +	spin_lock_bh(&p->fcoe_rx_list.lock);
> +	thread = p->thread;
> +	p->thread = NULL;
> +	crc_eof = p->crc_eof_page;
> +	p->crc_eof_page = NULL;
> +	p->crc_eof_offset = 0;
> +	spin_unlock_bh(&p->fcoe_rx_list.lock);
> +
> +#ifdef CONFIG_SMP
> +	/*
> +	 * Don't bother moving the skb's if this context is running
> +	 * on the same CPU that is having its thread destroyed. This
> +	 * can easily happen when the module is removed.
> +	 */
> +	if (cpu != targ_cpu) {
> +		p0 = &per_cpu(fcoe_percpu, targ_cpu);
> +		spin_lock_bh(&p0->fcoe_rx_list.lock);
> +		if (p0->thread) {
> +			FC_DBG("Moving frames from CPU %d to CPU %d\n",
> +			       cpu, targ_cpu);
> +
> +			while ((skb = __skb_dequeue(&p->fcoe_rx_list)) != NULL)
> +				__skb_queue_tail(&p0->fcoe_rx_list, skb);
> +			spin_unlock_bh(&p0->fcoe_rx_list.lock);
> +		} else {
> +			/*
> +			 * The targeted CPU is not initialized and cannot accept
> +			 * new  skbs. Unlock the targeted CPU and drop the skbs
> +			 * on the CPU that is going offline.
> +			 */
> +			while ((skb = __skb_dequeue(&p->fcoe_rx_list)) != NULL)
> +				kfree_skb(skb);
> +			spin_unlock_bh(&p0->fcoe_rx_list.lock);
> +		}
> +	} else {
> +		/*
> +		 * This scenario occurs when the module is being removed
> +		 * and all threads are being destroyed. skbs will continue
> +		 * to be shifted from the CPU thread that is being removed
> +		 * to the CPU thread associated with the CPU that is processing
> +		 * the module removal. Once there is only one CPU Rx thread it
> +		 * will reach this case and we will drop all skbs and later
> +		 * stop the thread.
> +		 */
> +		spin_lock_bh(&p->fcoe_rx_list.lock);
> +		while ((skb = __skb_dequeue(&p->fcoe_rx_list)) != NULL)
> +			kfree_skb(skb);
> +		spin_unlock_bh(&p->fcoe_rx_list.lock);
> +	}
> +#else
> +	/*
> +	 * This a non-SMP scenario where the singluar Rx thread is
> +	 * being removed. Free all skbs and stop the thread.
> +	 */
> +	spin_lock_bh(&p->fcoe_rx_list.lock);
> +	while ((skb = __skb_dequeue(&p->fcoe_rx_list)) != NULL)
> +		kfree_skb(skb);
> +	spin_unlock_bh(&p->fcoe_rx_list.lock);
> +#endif
> +
> +	if (thread)
> +		kthread_stop(thread);

Don't you need a kthread_unbind() somewhere in here?  Under most of your
calling conditions (CPU_DEAD events) the bound CPU is toast, so the
thread isn't going to be able to wake up on it.

James


