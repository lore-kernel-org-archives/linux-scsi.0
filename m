From: Andreas Herrmann <aherrmann@suse.com>
Subject: Re: [RFC PATCH v2] blk-mq: Introduce per sw queue time-slice
Date: Tue, 9 Feb 2016 18:12:39 +0100
Message-ID: <20160209171239.GE12437@suselix.suse.de>
References: <20151119120235.GA7966@suselix.suse.de>
 <20160201224340.GA16639@suselix.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160201224340.GA16639@suselix.suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org, Johannes Thumshirn <jthumshirn@suse.de>, Jan Kara <jack@suse.cz>, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
List-Id: linux-scsi@vger.kernel.org

[CC-ing linux-block and linux-scsi and adding some comments]

On Mon, Feb 01, 2016 at 11:43:40PM +0100, Andreas Herrmann wrote:
> This introduces a new blk_mq hw attribute time_slice_us which allows
> to specify a time slice in usecs.
>=20
> Default value is 0 and implies no modification to blk-mq behaviour.
>=20
> A positive value changes blk-mq to service only one software queue
> within this time slice until it expires or the software queue is
> empty. Then the next software queue with pending requests is selected=
=2E
>=20
> Signed-off-by: Andreas Herrmann <aherrmann@suse.com>
> ---
>  block/blk-mq-sysfs.c   |  27 +++++++
>  block/blk-mq.c         | 208 +++++++++++++++++++++++++++++++++++++++=
++--------
>  include/linux/blk-mq.h |   9 +++
>  3 files changed, 211 insertions(+), 33 deletions(-)
>=20
> Hi,
>=20
> This update is long overdue (sorry for the delay).
>=20
> Change to v1:
> - time slice is now specified in usecs instead of msecs.
> - time slice is extended (up to 3 times the initial value) when there
>   was actually a request to be serviced for the software queue
>=20
> Fio test results are sent in a separate mail to this.

See http://marc.info/?l=3Dlinux-kernel&m=3D145436682607949&w=3D2

In short it shows significant performance gains in some tests,
e.g. sequential read iops up by >40% with 8 jobs. But it's never on
par with CFQ when more than 1 job was used during the test.

> Results for fio improved to some extent with this patch. But in
> reality the picture is quite mixed. Performance is highly dependend o=
n
> task scheduling. There is no guarantee that the requests originated
> from one CPU belong to the same process.
>=20
> I think for rotary devices CFQ is by far the best choice. A simple
> illustration is:
>=20
>   Copying two files (750MB in this case) in parallel on a rotary
>   device. The elapsed wall clock time (seconds) for this is
>                                mean    stdev
>    cfq, slice_idle=3D8           16.18   4.95
>    cfq, slice_idle=3D0           23.74   2.82
>    blk-mq, time_slice_usec=3D0   24.37   2.05
>    blk-mq, time_slice_usec=3D250 25.58   3.16

This illustrates that although their was performance gain with fio
tests, the patch can cause higher variance and lower performance in
comparison to unmodified blk-mq with other tests. And it underscores
superiority of CFQ for rotary disks.

Meanwhile my opinion is that it's not really worth to look further
into introduction of I/O scheduling support in blk-mq. I don't see the
need for scheduling support (deadline or something else) for fast
storage devices. And rotary devices should really avoid usage of blk-mq
and stick to CFQ.

Thus I think that introducing some coexistence of blk-mq and the
legacy block with CFQ is the best option.

Recently Johannes sent a patch to enable scsi-mq per driver, see
http://marc.info/?l=3Dlinux-scsi&m=3D145347009631192&w=3D2

Probably that is a good solution (at least in the short term) to allow
users to switch to blk-mq for some host adapters (with fast storage
attached) but to stick to legacy stuff on other host adapters with
rotary devices.

What do others think?


Thanks,

Andreas


> Regards,
>=20
> Andreas
>=20
> diff --git a/block/blk-mq-sysfs.c b/block/blk-mq-sysfs.c
> index 1cf1878..77c875c 100644
> --- a/block/blk-mq-sysfs.c
> +++ b/block/blk-mq-sysfs.c
> @@ -247,6 +247,26 @@ static ssize_t blk_mq_hw_sysfs_cpus_show(struct =
blk_mq_hw_ctx *hctx, char *page)
>  	return ret;
>  }
> =20
> +static ssize_t blk_mq_hw_sysfs_tslice_show(struct blk_mq_hw_ctx *hct=
x,
> +					  char *page)
> +{
> +	return sprintf(page, "%u\n", hctx->tslice_us);
> +}
> +
> +static ssize_t blk_mq_hw_sysfs_tslice_store(struct blk_mq_hw_ctx *hc=
tx,
> +					const char *page, size_t length)
> +{
> +	unsigned long long store;
> +	int err;
> +
> +	err =3D kstrtoull(page, 10, &store);
> +	if (err)
> +		return -EINVAL;
> +
> +	hctx->tslice_us =3D (unsigned)store;
> +	return length;
> +}
> +
>  static struct blk_mq_ctx_sysfs_entry blk_mq_sysfs_dispatched =3D {
>  	.attr =3D {.name =3D "dispatched", .mode =3D S_IRUGO },
>  	.show =3D blk_mq_sysfs_dispatched_show,
> @@ -305,6 +325,12 @@ static struct blk_mq_hw_ctx_sysfs_entry blk_mq_h=
w_sysfs_poll =3D {
>  	.show =3D blk_mq_hw_sysfs_poll_show,
>  };
> =20
> +static struct blk_mq_hw_ctx_sysfs_entry blk_mq_hw_sysfs_tslice =3D {
> +	.attr =3D {.name =3D "time_slice_us", .mode =3D S_IRUGO | S_IWUSR }=
,
> +	.show =3D blk_mq_hw_sysfs_tslice_show,
> +	.store =3D blk_mq_hw_sysfs_tslice_store,
> +};
> +
>  static struct attribute *default_hw_ctx_attrs[] =3D {
>  	&blk_mq_hw_sysfs_queued.attr,
>  	&blk_mq_hw_sysfs_run.attr,
> @@ -314,6 +340,7 @@ static struct attribute *default_hw_ctx_attrs[] =3D=
 {
>  	&blk_mq_hw_sysfs_cpus.attr,
>  	&blk_mq_hw_sysfs_active.attr,
>  	&blk_mq_hw_sysfs_poll.attr,
> +	&blk_mq_hw_sysfs_tslice.attr,
>  	NULL,
>  };
> =20
> diff --git a/block/blk-mq.c b/block/blk-mq.c
> index 4c0622f..97d32f2 100644
> --- a/block/blk-mq.c
> +++ b/block/blk-mq.c
> @@ -68,6 +68,7 @@ static void blk_mq_hctx_mark_pending(struct blk_mq_=
hw_ctx *hctx,
> =20
>  	if (!test_bit(CTX_TO_BIT(hctx, ctx), &bm->word))
>  		set_bit(CTX_TO_BIT(hctx, ctx), &bm->word);
> +	cpumask_set_cpu(ctx->cpu, hctx->cpu_pending_mask);
>  }
> =20
>  static void blk_mq_hctx_clear_pending(struct blk_mq_hw_ctx *hctx,
> @@ -76,6 +77,7 @@ static void blk_mq_hctx_clear_pending(struct blk_mq=
_hw_ctx *hctx,
>  	struct blk_align_bitmap *bm =3D get_bm(hctx, ctx);
> =20
>  	clear_bit(CTX_TO_BIT(hctx, ctx), &bm->word);
> +	cpumask_clear_cpu(ctx->cpu, hctx->cpu_pending_mask);
>  }
> =20
>  void blk_mq_freeze_queue_start(struct request_queue *q)
> @@ -682,15 +684,41 @@ static bool blk_mq_attempt_merge(struct request=
_queue *q,
>  	return false;
>  }
> =20
> +static int tslice_flush_one_ctx(struct blk_mq_hw_ctx *hctx,
> +				struct list_head *list,	int cpu)
> +{
> +	struct request_queue *q =3D hctx->queue;
> +	struct blk_mq_ctx *ctx;
> +
> +	if (cpu =3D=3D -1 || !hctx->tslice_us)
> +		return 0;
> +
> +	ctx =3D __blk_mq_get_ctx(q, cpu);
> +	spin_lock(&ctx->lock);
> +	if (!list_empty(&ctx->rq_list)) {
> +		list_splice_tail_init(&ctx->rq_list, list);
> +		spin_lock(&hctx->lock);
> +		hctx->tslice_inc =3D 1;
> +		blk_mq_hctx_clear_pending(hctx, ctx);
> +		spin_unlock(&hctx->lock);
> +	}
> +	spin_unlock(&ctx->lock);
> +	return 1;
> +}
> +
>  /*
>   * Process software queues that have been marked busy, splicing them
>   * to the for-dispatch
>   */
> -static void flush_busy_ctxs(struct blk_mq_hw_ctx *hctx, struct list_=
head *list)
> +static void flush_busy_ctxs(struct blk_mq_hw_ctx *hctx,
> +			struct list_head *list,	int cpu)
>  {
>  	struct blk_mq_ctx *ctx;
>  	int i;
> =20
> +	if (tslice_flush_one_ctx(hctx, list, cpu))
> +		return;
> +
>  	for (i =3D 0; i < hctx->ctx_map.size; i++) {
>  		struct blk_align_bitmap *bm =3D &hctx->ctx_map.map[i];
>  		unsigned int off, bit;
> @@ -706,9 +734,11 @@ static void flush_busy_ctxs(struct blk_mq_hw_ctx=
 *hctx, struct list_head *list)
>  				break;
> =20
>  			ctx =3D hctx->ctxs[bit + off];
> -			clear_bit(bit, &bm->word);
>  			spin_lock(&ctx->lock);
>  			list_splice_tail_init(&ctx->rq_list, list);
> +			spin_lock(&hctx->lock);
> +			blk_mq_hctx_clear_pending(hctx, ctx);
> +			spin_unlock(&hctx->lock);
>  			spin_unlock(&ctx->lock);
> =20
>  			bit++;
> @@ -717,6 +747,114 @@ static void flush_busy_ctxs(struct blk_mq_hw_ct=
x *hctx, struct list_head *list)
>  }
> =20
>  /*
> + * It'd be great if the workqueue API had a way to pass
> + * in a mask and had some smarts for more clever placement.
> + * For now we just round-robin here, switching for every
> + * BLK_MQ_CPU_WORK_BATCH queued items.
> + */
> +static int blk_mq_hctx_next_cpu(struct blk_mq_hw_ctx *hctx)
> +{
> +	if (hctx->queue->nr_hw_queues =3D=3D 1)
> +		return WORK_CPU_UNBOUND;
> +
> +	if (--hctx->next_cpu_batch <=3D 0) {
> +		int cpu =3D hctx->next_cpu, next_cpu;
> +
> +		next_cpu =3D cpumask_next(hctx->next_cpu, hctx->cpumask);
> +		if (next_cpu >=3D nr_cpu_ids)
> +			next_cpu =3D cpumask_first(hctx->cpumask);
> +
> +		hctx->next_cpu =3D next_cpu;
> +		hctx->next_cpu_batch =3D BLK_MQ_CPU_WORK_BATCH;
> +
> +		return cpu;
> +	}
> +
> +	return hctx->next_cpu;
> +}
> +
> +static int blk_mq_tslice_expired(struct blk_mq_hw_ctx *hctx)
> +{
> +	if (time_after_eq(jiffies, hctx->tslice_expiration))
> +		return 1;
> +
> +	return 0;
> +}
> +
> +static int blk_mq_tslice_next_cpu(struct blk_mq_hw_ctx *hctx)
> +{
> +	int c =3D hctx->tslice_cpu;
> +
> +	/* allow extension of time slice */
> +	if (hctx->tslice_inc && hctx->tslice_inc_count < 4) {
> +		hctx->tslice_inc =3D 0;
> +		hctx->tslice_inc_count++;
> +		goto out;
> +	}
> +	hctx->tslice_inc =3D 0;
> +	hctx->tslice_inc_count =3D 0;
> +
> +	/* clear CPU for which tslice has expired */
> +	if (c !=3D -1)
> +		cpumask_clear_cpu(c, hctx->cpu_service_mask);
> +
> +	/* calculate mask of remaining CPUs with pending work */
> +	if (cpumask_and(hctx->cpu_next_mask, hctx->cpu_pending_mask,
> +				hctx->cpu_service_mask)) {
> +		c =3D cpumask_first(hctx->cpu_next_mask);
> +	} else {
> +		/*
> +		 * no remaining CPUs with pending work, reset epoch,
> +		 * start with first CPU that has requests pending
> +		 */
> +		hctx->tslice_expiration =3D 0;
> +		cpumask_setall(hctx->cpu_service_mask);
> +		c =3D cpumask_first(hctx->cpu_pending_mask);
> +	}
> +
> +	/* no CPU with pending requests */
> +	if (c >=3D nr_cpu_ids)
> +		return -1;
> +
> +out:
> +	hctx->tslice_expiration =3D jiffies + usecs_to_jiffies(hctx->tslice=
_us);
> +	return c;
> +}
> +
> +static int tslice_get_busy_ctx(struct blk_mq_hw_ctx *hctx)
> +{
> +	int cpu =3D -1;
> +
> +	if (hctx->tslice_us) {
> +		spin_lock(&hctx->lock);
> +		if (blk_mq_tslice_expired(hctx))
> +			hctx->tslice_cpu =3D blk_mq_tslice_next_cpu(hctx);
> +		cpu =3D hctx->tslice_cpu;
> +		spin_unlock(&hctx->lock);
> +	}
> +
> +	return cpu;
> +}
> +
> +/*
> + * Ensure that hardware queue is run if there are pending
> + * requests in any software queue.
> + */
> +static void tslice_schedule_pending_work(struct blk_mq_hw_ctx *hctx)
> +{
> +	long t;
> +
> +	if (!hctx->tslice_us || cpumask_empty(hctx->cpu_pending_mask))
> +		return;
> +
> +	t =3D hctx->tslice_expiration - jiffies;
> +	if (t < 0)
> +		t =3D 0;
> +	kblockd_schedule_delayed_work_on(blk_mq_hctx_next_cpu(hctx),
> +					&hctx->run_work, (unsigned int)t);
> +}
> +
> +/*
>   * Run this hardware queue, pulling any software queues mapped to it=
 in.
>   * Note that this function currently has various problems around ord=
ering
>   * of IO. In particular, we'd like FIFO behaviour on handling existi=
ng
> @@ -729,7 +867,7 @@ static void __blk_mq_run_hw_queue(struct blk_mq_h=
w_ctx *hctx)
>  	LIST_HEAD(rq_list);
>  	LIST_HEAD(driver_list);
>  	struct list_head *dptr;
> -	int queued;
> +	int queued, cpu;
> =20
>  	WARN_ON(!cpumask_test_cpu(raw_smp_processor_id(), hctx->cpumask));
> =20
> @@ -739,9 +877,11 @@ static void __blk_mq_run_hw_queue(struct blk_mq_=
hw_ctx *hctx)
>  	hctx->run++;
> =20
>  	/*
> -	 * Touch any software queue that has pending entries.
> +	 * Touch dedicated software queue if time slice is set or any
> +	 * software queue that has pending entries (cpu =3D=3D -1).
>  	 */
> -	flush_busy_ctxs(hctx, &rq_list);
> +	cpu =3D tslice_get_busy_ctx(hctx);
> +	flush_busy_ctxs(hctx, &rq_list, cpu);
> =20
>  	/*
>  	 * If we have previous entries on our dispatch list, grab them
> @@ -826,34 +966,8 @@ static void __blk_mq_run_hw_queue(struct blk_mq_=
hw_ctx *hctx)
>  		 * blk_mq_run_hw_queue() already checks the STOPPED bit
>  		 **/
>  		blk_mq_run_hw_queue(hctx, true);
> -	}
> -}
> -
> -/*
> - * It'd be great if the workqueue API had a way to pass
> - * in a mask and had some smarts for more clever placement.
> - * For now we just round-robin here, switching for every
> - * BLK_MQ_CPU_WORK_BATCH queued items.
> - */
> -static int blk_mq_hctx_next_cpu(struct blk_mq_hw_ctx *hctx)
> -{
> -	if (hctx->queue->nr_hw_queues =3D=3D 1)
> -		return WORK_CPU_UNBOUND;
> -
> -	if (--hctx->next_cpu_batch <=3D 0) {
> -		int cpu =3D hctx->next_cpu, next_cpu;
> -
> -		next_cpu =3D cpumask_next(hctx->next_cpu, hctx->cpumask);
> -		if (next_cpu >=3D nr_cpu_ids)
> -			next_cpu =3D cpumask_first(hctx->cpumask);
> -
> -		hctx->next_cpu =3D next_cpu;
> -		hctx->next_cpu_batch =3D BLK_MQ_CPU_WORK_BATCH;
> -
> -		return cpu;
> -	}
> -
> -	return hctx->next_cpu;
> +	} else
> +		tslice_schedule_pending_work(hctx);
>  }
> =20
>  void blk_mq_run_hw_queue(struct blk_mq_hw_ctx *hctx, bool async)
> @@ -992,7 +1106,10 @@ static void __blk_mq_insert_request(struct blk_=
mq_hw_ctx *hctx,
>  	struct blk_mq_ctx *ctx =3D rq->mq_ctx;
> =20
>  	__blk_mq_insert_req_list(hctx, ctx, rq, at_head);
> +	spin_lock(&hctx->lock);
>  	blk_mq_hctx_mark_pending(hctx, ctx);
> +	spin_unlock(&hctx->lock);
> +
>  }
> =20
>  void blk_mq_insert_request(struct request *rq, bool at_head, bool ru=
n_queue,
> @@ -1583,7 +1700,9 @@ static int blk_mq_hctx_cpu_offline(struct blk_m=
q_hw_ctx *hctx, int cpu)
>  	spin_lock(&ctx->lock);
>  	if (!list_empty(&ctx->rq_list)) {
>  		list_splice_init(&ctx->rq_list, &tmp);
> +		spin_lock(&hctx->lock);
>  		blk_mq_hctx_clear_pending(hctx, ctx);
> +		spin_unlock(&hctx->lock);
>  	}
>  	spin_unlock(&ctx->lock);
> =20
> @@ -1602,7 +1721,9 @@ static int blk_mq_hctx_cpu_offline(struct blk_m=
q_hw_ctx *hctx, int cpu)
>  	}
> =20
>  	hctx =3D q->mq_ops->map_queue(q, ctx->cpu);
> +	spin_lock(&hctx->lock);
>  	blk_mq_hctx_mark_pending(hctx, ctx);
> +	spin_unlock(&hctx->lock);
> =20
>  	spin_unlock(&ctx->lock);
> =20
> @@ -1691,6 +1812,12 @@ static int blk_mq_init_hctx(struct request_que=
ue *q,
>  	hctx->queue_num =3D hctx_idx;
>  	hctx->flags =3D set->flags & ~BLK_MQ_F_TAG_SHARED;
> =20
> +	hctx->tslice_us =3D 0;
> +	hctx->tslice_expiration =3D 0;
> +	hctx->tslice_cpu =3D -1;
> +	hctx->tslice_inc =3D 0;
> +	hctx->tslice_inc_count =3D 0;
> +
>  	blk_mq_init_cpu_notifier(&hctx->cpu_notifier,
>  					blk_mq_hctx_notify, hctx);
>  	blk_mq_register_cpu_notifier(&hctx->cpu_notifier);
> @@ -2006,6 +2133,18 @@ struct request_queue *blk_mq_init_allocated_qu=
eue(struct blk_mq_tag_set *set,
>  						node))
>  			goto err_hctxs;
> =20
> +		if (!zalloc_cpumask_var_node(&hctxs[i]->cpu_pending_mask,
> +						GFP_KERNEL, node))
> +			goto err_hctxs;
> +
> +		if (!zalloc_cpumask_var_node(&hctxs[i]->cpu_service_mask,
> +						GFP_KERNEL, node))
> +			goto err_hctxs;
> +
> +		if (!zalloc_cpumask_var_node(&hctxs[i]->cpu_next_mask,
> +						GFP_KERNEL, node))
> +			goto err_hctxs;
> +
>  		atomic_set(&hctxs[i]->nr_active, 0);
>  		hctxs[i]->numa_node =3D node;
>  		hctxs[i]->queue_num =3D i;
> @@ -2069,6 +2208,9 @@ err_hctxs:
>  		if (!hctxs[i])
>  			break;
>  		free_cpumask_var(hctxs[i]->cpumask);
> +		free_cpumask_var(hctxs[i]->cpu_pending_mask);
> +		free_cpumask_var(hctxs[i]->cpu_service_mask);
> +		free_cpumask_var(hctxs[i]->cpu_next_mask);
>  		kfree(hctxs[i]);
>  	}
>  err_map:
> diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
> index 7fc9296..a8ca685 100644
> --- a/include/linux/blk-mq.h
> +++ b/include/linux/blk-mq.h
> @@ -57,6 +57,15 @@ struct blk_mq_hw_ctx {
> =20
>  	atomic_t		nr_active;
> =20
> +	cpumask_var_t		cpu_service_mask; /* CPUs not yet serviced */
> +	cpumask_var_t		cpu_pending_mask; /* CPUs with pending work */
> +	cpumask_var_t		cpu_next_mask;	/* CPUs to be serviced */
> +	int			tslice_us;	/* time slice in =C2=B5s */
> +	int			tslice_inc;	/* extend time slice */
> +	int			tslice_inc_count;
> +	unsigned long		tslice_expiration; /* in jiffies */
> +	int			tslice_cpu;	/* cpu of time slice */
> +
>  	struct blk_mq_cpu_notifier	cpu_notifier;
>  	struct kobject		kobj;
> =20
> --=20
> 1.9.1
>=20
