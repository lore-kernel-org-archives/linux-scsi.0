From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [RFC/PATCH 4/4] block: Add URGENT request notification support to CFQ scheduler
Date: Thu, 11 Jul 2013 14:41:35 -0400
Message-ID: <x49oba9ndls.fsf@segfault.boston.devel.redhat.com>
References: <1373547671-2779-1-git-send-email-tlinder@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-arm-msm-owner@vger.kernel.org>
In-Reply-To: <1373547671-2779-1-git-send-email-tlinder@codeaurora.org> (Tanya
	Brokhman's message of "Thu, 11 Jul 2013 16:01:11 +0300")
Sender: linux-arm-msm-owner@vger.kernel.org
To: Tanya Brokhman <tlinder@codeaurora.org>
Cc: axboe@kernel.dk, linux-arm-msm@vger.kernel.org, linux-mmc@vger.kernel.org, open list <linux-kernel@vger.kernel.org>, "open list:UNIVERSAL FLASH S..." <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Tanya Brokhman <tlinder@codeaurora.org> writes:

> When the scheduler reports to the block layer that there is an urgent
> request pending, the device driver may decide to stop the transmission
> of the current request in order to handle the urgent one. This is done
> in order to reduce the latency of an urgent request. For example:
> long WRITE may be stopped to handle an urgent READ.

In general, I don't like the approach taken.  I would much rather see
a low-level cancellation method, and layer your urgent request handling
on top of that.  That could actually be used by the aio subsystem as
well (with a lot of work, of course).  That aside, I've provided some
comments below.

>
> Signed-off-by: Tatyana Brokhman <tlinder@codeaurora.org>
>
> diff --git a/block/blk-core.c b/block/blk-core.c
> index 3ab3a62..705f4f9 100644
> --- a/block/blk-core.c
> +++ b/block/blk-core.c
> @@ -2090,7 +2090,10 @@ static void blk_account_io_completion(struct request *req, unsigned int bytes)
>  
>  		cpu = part_stat_lock();
>  		part = req->part;
> -		part_stat_add(cpu, part, sectors[rw], bytes >> 9);
> +		if (part == NULL)
> +			pr_err("%s: YANIV - BUG START", __func__);
> +		else
> +			part_stat_add(cpu, part, sectors[rw], bytes >> 9);

This looks like leftover debugging.

>  		part_stat_unlock();
>  	}
>  }
> @@ -2111,12 +2114,13 @@ static void blk_account_io_done(struct request *req)
>  		cpu = part_stat_lock();
>  		part = req->part;
>  
> -		part_stat_inc(cpu, part, ios[rw]);
> -		part_stat_add(cpu, part, ticks[rw], duration);
> -		part_round_stats(cpu, part);
> -		part_dec_in_flight(part, rw);
> -
> -		hd_struct_put(part);
> +		if (req->part != NULL) {
> +			part_stat_inc(cpu, part, ios[rw]);
> +			part_stat_add(cpu, part, ticks[rw], duration);
> +			part_round_stats(cpu, part);
> +			part_dec_in_flight(part, rw);
> +			hd_struct_put(part);
> +		}

A comment about why we now expect req->part might be null would be nice.

>  		part_stat_unlock();
>  	}
>  }
> diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
> index d5bbdcf..f936cb9 100644
> --- a/block/cfq-iosched.c
> +++ b/block/cfq-iosched.c
> @@ -320,6 +320,9 @@ struct cfq_data {
>  	unsigned long workload_expires;
>  	struct cfq_group *serving_group;
>  
> +	unsigned int nr_urgent_pending;
> +	unsigned int nr_urgent_in_flight;
> +
>  	/*
>  	 * Each priority tree is sorted by next_request position.  These
>  	 * trees are used when determining if two or more queues are
> @@ -2783,6 +2786,14 @@ static void cfq_dispatch_insert(struct request_queue *q, struct request *rq)
>  	(RQ_CFQG(rq))->dispatched++;
>  	elv_dispatch_sort(q, rq);
>  
> +	if (rq->cmd_flags & REQ_URGENT) {
> +		if (!cfqd->nr_urgent_pending)
> +			WARN_ON(1);
> +		else
> +			cfqd->nr_urgent_pending--;
> +		cfqd->nr_urgent_in_flight++;
> +	}
> +

This is a rather ugly construct, and gets repeated later.  I'd be
inclined to just BUG.

>  	cfqd->rq_in_flight[cfq_cfqq_sync(cfqq)]++;
>  	cfqq->nr_sectors += blk_rq_sectors(rq);
>  	cfqg_stats_update_dispatch(cfqq->cfqg, blk_rq_bytes(rq), rq->cmd_flags);
> @@ -3909,6 +3920,68 @@ cfq_rq_enqueued(struct cfq_data *cfqd, struct cfq_queue *cfqq,
>  	}
>  }
>  
> +/*
> + * Called when a request (rq) is reinserted (to cfqq). Check if there's
> + * something we should do about it
> + */
> +static void
> +cfq_rq_requeued(struct cfq_data *cfqd, struct cfq_queue *cfqq,
> +		struct request *rq)
> +{
> +	struct cfq_io_cq *cic = RQ_CIC(rq);
> +
> +	cfqd->rq_queued++;
> +	if (rq->cmd_flags & REQ_PRIO)
> +		cfqq->prio_pending++;
> +
> +	cfqq->dispatched--;
> +	(RQ_CFQG(rq))->dispatched--;
> +
> +	cfqd->rq_in_flight[cfq_cfqq_sync(cfqq)]--;
> +
> +	cfq_update_io_thinktime(cfqd, cfqq, cic);
> +	cfq_update_io_seektime(cfqd, cfqq, rq);
> +	cfq_update_idle_window(cfqd, cfqq, cic);
> +
> +	cfqq->last_request_pos = blk_rq_pos(rq) + blk_rq_sectors(rq);
> +
> +	if (cfqq == cfqd->active_queue) {
> +		if (cfq_cfqq_wait_request(cfqq)) {
> +			if (blk_rq_bytes(rq) > PAGE_CACHE_SIZE ||
> +			    cfqd->busy_queues > 1) {
> +				cfq_del_timer(cfqd, cfqq);
> +				cfq_clear_cfqq_wait_request(cfqq);
> +			} else {
> +				cfqg_stats_update_idle_time(cfqq->cfqg);
> +				cfq_mark_cfqq_must_dispatch(cfqq);
> +			}
> +		}
> +	} else if (cfq_should_preempt(cfqd, cfqq, rq)) {
> +		cfq_preempt_queue(cfqd, cfqq);
> +	}
> +}

Huge cut-n-paste of cfq_rq_enqueued.  Please factor the code out.

> +static int cfq_reinsert_request(struct request_queue *q, struct request *rq)
> +{
> +	struct cfq_data *cfqd = q->elevator->elevator_data;
> +	struct cfq_queue *cfqq = RQ_CFQQ(rq);
> +
> +	if (!cfqq || cfqq->cfqd != cfqd)
> +		return -EIO;
> +
> +	cfq_log_cfqq(cfqd, cfqq, "re-insert_request");
> +	list_add(&rq->queuelist, &cfqq->fifo);
> +	cfq_add_rq_rb(rq);
> +
> +	cfq_rq_requeued(cfqd, cfqq, rq);
> +	if (rq->cmd_flags & REQ_URGENT) {
> +			if (cfqd->nr_urgent_in_flight)
> +				cfqd->nr_urgent_in_flight--;
> +			cfqd->nr_urgent_pending++;
> +	}
> +	return 0;
> +}
> +
>  static void cfq_insert_request(struct request_queue *q, struct request *rq)
>  {
>  	struct cfq_data *cfqd = q->elevator->elevator_data;
> @@ -3923,6 +3996,43 @@ static void cfq_insert_request(struct request_queue *q, struct request *rq)
>  	cfqg_stats_update_io_add(RQ_CFQG(rq), cfqd->serving_group,
>  				 rq->cmd_flags);
>  	cfq_rq_enqueued(cfqd, cfqq, rq);
> +
> +	if (rq->cmd_flags & REQ_URGENT) {
> +		WARN_ON(1);
> +		blk_dump_rq_flags(rq, "");
> +		rq->cmd_flags &= ~REQ_URGENT;
> +	}
> +
> +	/*
> +	 * Request is considered URGENT if:
> +	 * 1. The queue being served is of a lower IO priority then the new
> +	 *    request
> +	 * OR:
> +	 * 2. The workload being performed is ASYNC
> +	 * Only READ requests may be considered as URGENT
> +	 */
> +	if ((cfqd->active_queue &&
> +		 cfqq->ioprio_class < cfqd->active_queue->ioprio_class) ||
> +		(cfqd->serving_wl_type == ASYNC_WORKLOAD &&
> +		 rq_data_dir(rq) == READ)) {
> +		rq->cmd_flags |= REQ_URGENT;
> +		cfqd->nr_urgent_pending++;
> +	}

If requests are queued from a higher priority queue, then that queue
will preempt the existing queue.  Why do we also need to interrupt read
requests from the lower priority queue?  You seemed to indicate that
long-running writes were the primary concern.
