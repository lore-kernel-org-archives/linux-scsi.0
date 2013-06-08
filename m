From: Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH 1/3] Percpu tag allocator
Date: Sat, 8 Jun 2013 17:07:34 +0200
Message-ID: <20130608150734.GA6818@redhat.com>
References: <1370659338-23841-1-git-send-email-nab@linux-iscsi.org> <1370659338-23841-2-git-send-email-nab@linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36146 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751875Ab3FHPMM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 8 Jun 2013 11:12:12 -0400
Content-Disposition: inline
In-Reply-To: <1370659338-23841-2-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Roland Dreier <roland@kernel.org>, Kent Overstreet <koverstreet@google.com>, Asias He <asias@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, Or Gerlitz <ogerlitz@mellanox.com>, Moussa Ba <moussaba@micron.com>, Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@linux-foundation.org>, Ingo Molnar <mingo@redhat.com>

On 06/08, Nicholas A. Bellinger wrote:
>
> +unsigned tag_alloc(struct tag_pool *pool, bool wait)
> +{
> +	struct tag_cpu_freelist *tags;
> +	unsigned long flags;
> +	unsigned ret;
> +retry:
> +	preempt_disable();
> +	local_irq_save(flags);
> +	tags = this_cpu_ptr(pool->tag_cpu);
> +
> +	while (!tags->nr_free) {
> +		spin_lock(&pool->lock);
> +
> +		if (pool->nr_free)
> +			move_tags(tags->free, &tags->nr_free,
> +				  pool->free, &pool->nr_free,
> +				  min(pool->nr_free, pool->watermark));
> +		else if (wait) {
> +			struct tag_waiter wait = { .task = current };
> +
> +			__set_current_state(TASK_UNINTERRUPTIBLE);
> +			list_add(&wait.list, &pool->wait);
> +
> +			spin_unlock(&pool->lock);
> +			local_irq_restore(flags);
> +			preempt_enable();
> +
> +			schedule();
> +
> +			if (!list_empty_careful(&wait.list)) {
> +				spin_lock_irqsave(&pool->lock, flags);
> +				list_del_init(&wait.list);
> +				spin_unlock_irqrestore(&pool->lock, flags);
> +			}
> +
> +			goto retry;
> +		} else
> +			goto fail;
> +
> +		spin_unlock(&pool->lock);
> +	}
> +
> +	ret = tags->free[--tags->nr_free];
> +
> +	local_irq_restore(flags);
> +	preempt_enable();
> +
> +	return ret;
> +fail:
> +	local_irq_restore(flags);
> +	preempt_enable();
> +	return 0;
> +}

I still think this code should use the normal wait_event().

See http://marc.info/?l=linux-kernel&m=136863269729888

> +void tag_free(struct tag_pool *pool, unsigned tag)
> +{
> +	struct tag_cpu_freelist *tags;
> +	unsigned long flags;
> +
> +	preempt_disable();
> +	local_irq_save(flags);
> +	tags = this_cpu_ptr(pool->tag_cpu);
> +
> +	tags->free[tags->nr_free++] = tag;
> +
> +	if (tags->nr_free == pool->watermark * 2) {
> +		spin_lock(&pool->lock);
> +
> +		move_tags(pool->free, &pool->nr_free,
> +			  tags->free, &tags->nr_free,
> +			  pool->watermark);
> +
> +		while (!list_empty(&pool->wait)) {
> +			struct tag_waiter *wait;
> +			wait = list_first_entry(&pool->wait,
> +						struct tag_waiter, list);
> +			list_del_init(&wait->list);
> +			wake_up_process(wait->task);

And this still looks racy.
see http://marc.info/?l=linux-kernel&m=136853955229504

And probably the changelog should mention that cpu_down() can
lose the tags.

Oleg.

