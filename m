From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: virtio-scsi: two questions related with picking up queue
Date: Wed, 07 May 2014 18:43:45 +0200
Message-ID: <536A62C1.6000905@redhat.com>
References: <CACVXFVNeBbJgA6h5n1Mt7vp7_Es67N5KEpZ0en4O+9GnD6wp+A@mail.gmail.com>	<5368E0DB.5010000@redhat.com> <20140508002437.0dd549e8@tom-ThinkPad-T410>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:10272 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754021AbaEGQoG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 7 May 2014 12:44:06 -0400
In-Reply-To: <20140508002437.0dd549e8@tom-ThinkPad-T410>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ming Lei <tom.leiming@gmail.com>
Cc: Linux SCSI List <linux-scsi@vger.kernel.org>, Wanlong Gao <gaowanlong@cn.fujitsu.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, Rusty Russell <rusty@rustcorp.com.au>

Il 07/05/2014 18:24, Ming Lei ha scritto:
> On Tue, 06 May 2014 15:17:15 +0200
> Paolo Bonzini <pbonzini@redhat.com> wrote:
>
>> Il 06/05/2014 11:26, Ming Lei ha scritto:
>>> Hi Paolo and All,
>>>
>>> One question is about ACCESS_ONCE() in virtscsi_pick_vq(),
>>> looks it needn't since both reading and writing tgt->req_vq holds
>>> tgt->tgt_lock.
>>
>> You're right.  It should be possible to avoid the lock in
>> virtscsi_pick_vq like this:
>>
>> 	value = atomic_read(&tgt->reqs);
>> retry:
>> 	if (value != 0) {
>> 		old_value = atomic_cmpxchg(&tgt->regs, value, value + 1)
>> 		if (old_value != value) {
>> 			value = old_value;
>> 			goto retry;
>> 		}
>>
>> 		smp_mb__after_atomic_cmpxchg(); // you get the idea :)
>> 		vq = ACCESS_ONCE(tgt->req_vq);
>> 	} else {
>> 	        spin_lock_irqsave(&tgt->tgt_lock, flags);
>>
>> 		// tgt->reqs may not be 0 anymore, need to recheck
>> 		value = atomic_read(&tgt->reqs);
>> 		if (atomic_read(&tgt->reqs) != 0) {
>> 		        spin_unlock_irqrestore(&tgt->tgt_lock, flags);
>> 			goto retry;
>> 		}
>>
>> 		// tgt->reqs now will remain fixed to 0.
>> 		...
>> 		tgt->req_vq = vq = ...;
>> 		smp_wmb();
>> 		atomic_set(&tgt->reqs, 1);
>> 	        spin_unlock_irqrestore(&tgt->tgt_lock, flags);
>> 	}
>>
>> 	return vq;
>>
>
> Another approach I thought of is to use percpu spinlock, and
> the idea is simple:
>
> 	- all perpcu locks are held for writing req_vq, and
> 	- only percpu lock is needed for reading req_vq.
>
> What do you think about the below patch?

Per-CPU spinlocks have bad scalability problems, especially if you're 
overcommitting.  Writing req_vq is not at all rare.

Paolo

> diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
> index 697fa53..00deab4 100644
> --- a/drivers/scsi/virtio_scsi.c
> +++ b/drivers/scsi/virtio_scsi.c
> @@ -82,7 +82,7 @@ struct virtio_scsi_vq {
>   */
>  struct virtio_scsi_target_state {
>  	/* This spinlock never held at the same time as vq_lock. */
> -	spinlock_t tgt_lock;
> +	spinlock_t __percpu *lock;
>
>  	/* Count of outstanding requests. */
>  	atomic_t reqs;
> @@ -517,21 +517,46 @@ static struct virtio_scsi_vq *virtscsi_pick_vq(struct virtio_scsi *vscsi,
>  {
>  	struct virtio_scsi_vq *vq;
>  	unsigned long flags;
> -	u32 queue_num;
> +	u32 cpu = get_cpu();
> +	spinlock_t	*lock = per_cpu_ptr(tgt->lock, cpu);
>
> -	spin_lock_irqsave(&tgt->tgt_lock, flags);
> +	spin_lock_irqsave(lock, flags);
>
>  	if (atomic_inc_return(&tgt->reqs) > 1)
>  		vq = tgt->req_vq;
>  	else {
> -		queue_num = smp_processor_id();
> +		u32 queue_num = cpu;
> +		int i;
> +
>  		while (unlikely(queue_num >= vscsi->num_queues))
>  			queue_num -= vscsi->num_queues;
>
> -		tgt->req_vq = vq = &vscsi->req_vqs[queue_num];
> +		/*
> +		 * there should be only one writing because of atomic
> +		 * counter, so we don't worry about deadlock, but
> +		 * might need to teach lockdep to not complain it
> +		 */
> +		for_each_possible_cpu(i) {
> +			spinlock_t *other = per_cpu_ptr(tgt->lock, i);
> +			if (i != cpu)
> +				spin_lock(other);
> +		}
> +
> +		/* only update req_vq when reqs is one*/
> +		if (atomic_read(&tgt->reqs) == 1)
> +			tgt->req_vq = vq = &vscsi->req_vqs[queue_num];
> +		else
> +			vq = tgt->req_vq;
> +
> +		for_each_possible_cpu(i) {
> +			spinlock_t *other = per_cpu_ptr(tgt->lock, i);
> +			if (i != cpu)
> +				spin_unlock(other);
> +		}
>  	}
>
> -	spin_unlock_irqrestore(&tgt->tgt_lock, flags);
> +	spin_unlock_irqrestore(lock, flags);
> +	put_cpu();
>  	return vq;
>  }
>
> @@ -618,10 +643,22 @@ static int virtscsi_target_alloc(struct scsi_target *starget)
>  {
>  	struct virtio_scsi_target_state *tgt =
>  				kmalloc(sizeof(*tgt), GFP_KERNEL);
> +	int i;
> +
>  	if (!tgt)
>  		return -ENOMEM;
>
> -	spin_lock_init(&tgt->tgt_lock);
> +	tgt->lock = alloc_percpu(spinlock_t);
> +	if (!tgt->lock) {
> +		kfree(tgt);
> +		return -ENOMEM;
> +	}
> +
> +	for_each_possible_cpu(i) {
> +		spinlock_t *lock = per_cpu_ptr(tgt->lock, i);
> +		spin_lock_init(lock);
> +	}
> +
>  	atomic_set(&tgt->reqs, 0);
>  	tgt->req_vq = NULL;
>
> @@ -632,6 +669,7 @@ static int virtscsi_target_alloc(struct scsi_target *starget)
>  static void virtscsi_target_destroy(struct scsi_target *starget)
>  {
>  	struct virtio_scsi_target_state *tgt = starget->hostdata;
> +	free_percpu(tgt->lock);
>  	kfree(tgt);
>  }
>
>
> Thanks,
>

