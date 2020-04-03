Return-Path: <SRS0=YASp=5T=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFB14C2BA17
	for <linux-scsi@archiver.kernel.org>; Fri,  3 Apr 2020 01:34:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 82F53206A3
	for <linux-scsi@archiver.kernel.org>; Fri,  3 Apr 2020 01:34:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ElYFBWew"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390222AbgDCBeU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 2 Apr 2020 21:34:20 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:21129 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2389857AbgDCBeU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Apr 2020 21:34:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585877658;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=4M8Y3hxWfPr3npNAdh6s+2Y4APbbKJSdSPJ367pAnSc=;
        b=ElYFBWew3I91IxxAJrHzd0RZFRiw92bUDOwuuvtEceZ37EzQ7IlrjVDxdtnmlcka28Y0Sn
        5bUe4G6t4oiR7gKY9tXF2slPO3lcoDRahdfGHFWHUz9x+vBn1k6FHXl8Gs/WBFp5Qfea/M
        H2xMQ7/1MG5mspYXXbSe+AEZSmcdGeQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-86-XHlpQVaSNMOnetvbnK7G5Q-1; Thu, 02 Apr 2020 21:34:14 -0400
X-MC-Unique: XHlpQVaSNMOnetvbnK7G5Q-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DD0218018A2;
        Fri,  3 Apr 2020 01:34:11 +0000 (UTC)
Received: from ming.t460p (ovpn-8-30.pek2.redhat.com [10.72.8.30])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id DDBF796B99;
        Fri,  3 Apr 2020 01:34:00 +0000 (UTC)
Date:   Fri, 3 Apr 2020 09:33:56 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Douglas Anderson <dianders@chromium.org>
Cc:     axboe@kernel.dk, jejb@linux.ibm.com, martin.petersen@oracle.com,
        paolo.valente@linaro.org, sqazi@google.com,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        groeck@chromium.org, Ajay Joshi <ajay.joshi@wdc.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Bart Van Assche <bvanassche@acm.org>,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        Hou Tao <houtao1@huawei.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] blk-mq: Rerun dispatching in the case of budget
 contention
Message-ID: <20200403013356.GA6987@ming.t460p>
References: <20200402155130.8264-1-dianders@chromium.org>
 <20200402085050.v2.2.I28278ef8ea27afc0ec7e597752a6d4e58c16176f@changeid>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200402085050.v2.2.I28278ef8ea27afc0ec7e597752a6d4e58c16176f@changeid>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Apr 02, 2020 at 08:51:30AM -0700, Douglas Anderson wrote:
> It is possible for two threads to be running
> blk_mq_do_dispatch_sched() at the same time with the same "hctx".
> This is because there can be more than one caller to
> __blk_mq_run_hw_queue() with the same "hctx" and hctx_lock() doesn't
> prevent more than one thread from entering.
> 
> If more than one thread is running blk_mq_do_dispatch_sched() at the
> same time with the same "hctx", they may have contention acquiring
> budget.  The blk_mq_get_dispatch_budget() can eventually translate
> into scsi_mq_get_budget().  If the device's "queue_depth" is 1 (not
> uncommon) then only one of the two threads will be the one to
> increment "device_busy" to 1 and get the budget.
> 
> The losing thread will break out of blk_mq_do_dispatch_sched() and
> will stop dispatching requests.  The assumption is that when more
> budget is available later (when existing transactions finish) the
> queue will be kicked again, perhaps in scsi_end_request().
> 
> The winning thread now has budget and can go on to call
> dispatch_request().  If dispatch_request() returns NULL here then we
> have a potential problem.  Specifically we'll now call

As I mentioned before, it is a BFQ specific issue, it tells blk-mq
that it has work to do, and now the budget is assigned to the only
winning thread, however, dispatch_request() still returns NULL.

> blk_mq_put_dispatch_budget() which translates into
> scsi_mq_put_budget().  That will mark the device as no longer busy but
> doesn't do anything to kick the queue.  This violates the assumption
> that the queue would be kicked when more budget was available.

The queue is still kicked in by BFQ in its idle timer, however that
timer doesn't make forward progress.

Without this idle timer, it is simply a BFQ issue.

> 
> Pictorially:
> 
> Thread A                          Thread B
> ================================= ==================================
> blk_mq_get_dispatch_budget() => 1
> dispatch_request() => NULL
>                                   blk_mq_get_dispatch_budget() => 0
>                                   // because Thread A marked
>                                   // "device_busy" in scsi_device
> blk_mq_put_dispatch_budget()

What if there is only thread A? You need to mention that thread B
is from BFQ.

> 
> The above case was observed in reboot tests and caused a task to hang
> forever waiting for IO to complete.  Traces showed that in fact two
> tasks were running blk_mq_do_dispatch_sched() at the same time with
> the same "hctx".  The task that got the budget did in fact see
> dispatch_request() return NULL.  Both tasks returned and the system
> went on for several minutes (until the hung task delay kicked in)
> without the given "hctx" showing up again in traces.
> 
> Let's attempt to fix this problem by detecting if there was contention
> for the budget in the case where we put the budget without dispatching
> anything.  If we saw contention we kick all hctx's associated with the
> queue where there was contention.  We do this without any locking by
> adding a double-check for budget and accepting a small amount of faux
> contention if the 2nd check gives us budget but then we don't dispatch
> anything (we'll look like we contended with ourselves).
> 
> A few extra notes:
> 
> - This whole thing is only a problem due to the inexact nature of
>   has_work().  Specifically if has_work() always guaranteed that a
>   "true" return meant that dispatch_request() would return non-NULL
>   then we wouldn't have this problem.  That's because we only grab the
>   budget if has_work() returned true.  If we had the non-NULL
>   guarantee then at least one of the threads would actually dispatch
>   work and when the work was done then queues would be kicked
>   normally.
> 
> - One specific I/O scheduler that trips this problem quite a bit is
>   BFQ which definitely returns "true" for has_work() in cases where it
>   wouldn't dispatch.  Making BFQ's has_work() more exact requires that
>   has_work() becomes a much heavier function, including figuring out
>   how to acquire spinlocks in has_work() without tripping circular
>   lock dependencies.  This is prototyped but it's unclear if it's
>   really the way to go when the problem can be solved with a
>   relatively lightweight contention detection mechanism.
> 
> - Because this problem only trips with inexact has_work() it's
>   believed that blk_mq_do_dispatch_ctx() does not need a similar
>   change.

Right, I prefer to fix it in BFQ, given it isn't a generic issue,
not worth of generic solution.

> 
> Signed-off-by: Douglas Anderson <dianders@chromium.org>
> ---
> 
> Changes in v2:
> - Replace ("scsi: core: Fix stall...") w/ ("blk-mq: Rerun dispatch...")
> 
>  block/blk-mq-sched.c   | 26 ++++++++++++++++++++++++--
>  block/blk-mq.c         |  3 +++
>  include/linux/blkdev.h |  2 ++
>  3 files changed, 29 insertions(+), 2 deletions(-)
> 
> diff --git a/block/blk-mq-sched.c b/block/blk-mq-sched.c
> index 74cedea56034..0195d75f5f96 100644
> --- a/block/blk-mq-sched.c
> +++ b/block/blk-mq-sched.c
> @@ -97,12 +97,34 @@ static void blk_mq_do_dispatch_sched(struct blk_mq_hw_ctx *hctx)
>  		if (e->type->ops.has_work && !e->type->ops.has_work(hctx))
>  			break;
>  
> -		if (!blk_mq_get_dispatch_budget(hctx))
> -			break;
> +
> +		if (!blk_mq_get_dispatch_budget(hctx)) {
> +			/*
> +			 * We didn't get budget so set contention.  If
> +			 * someone else had the budget but didn't dispatch
> +			 * they'll kick everything.  NOTE: we check one
> +			 * extra time _after_ setting contention to fully
> +			 * close the race.  If we don't actually dispatch
> +			 * we'll detext faux contention (with ourselves)
> +			 * but that should be rare.
> +			 */
> +			atomic_set(&q->budget_contention, 1);
> +
> +			if (!blk_mq_get_dispatch_budget(hctx))

scsi_mq_get_budget() implies a smp_mb(), so the barrier can order
between blk_mq_get_dispatch_budget() and atomic_set(&q->budget_contention, 0|1).

> +				break;
> +		}
>  
>  		rq = e->type->ops.dispatch_request(hctx);
>  		if (!rq) {
>  			blk_mq_put_dispatch_budget(hctx);
> +
> +			/*
> +			 * We've released the budget but us holding it might
> +			 * have prevented someone else from dispatching.
> +			 * Detect that case and run all queues again.
> +			 */
> +			if (atomic_read(&q->budget_contention))

scsi_mq_put_budget() doesn't imply smp_mb(), so one smp_mb__after_atomic()
is needed between the above two op.

> +				blk_mq_run_hw_queues(q, true);
>  			break;
>  		}
>  
> diff --git a/block/blk-mq.c b/block/blk-mq.c
> index 2cd8d2b49ff4..6163c43ceca5 100644
> --- a/block/blk-mq.c
> +++ b/block/blk-mq.c
> @@ -1528,6 +1528,9 @@ void blk_mq_run_hw_queues(struct request_queue *q, bool async)
>  	struct blk_mq_hw_ctx *hctx;
>  	int i;
>  
> +	/* We're running the queues, so clear the contention detector */
> +	atomic_set(&q->budget_contention, 0);
> +

You add extra cost in fast path.

>  	queue_for_each_hw_ctx(q, hctx, i) {
>  		if (blk_mq_hctx_stopped(hctx))
>  			continue;
> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> index f629d40c645c..07f21e45d993 100644
> --- a/include/linux/blkdev.h
> +++ b/include/linux/blkdev.h
> @@ -583,6 +583,8 @@ struct request_queue {
>  
>  #define BLK_MAX_WRITE_HINTS	5
>  	u64			write_hints[BLK_MAX_WRITE_HINTS];
> +
> +	atomic_t		budget_contention;

It needn't to be a atomic variable, and simple 'unsigned'
int should be fine, what matters is that the order between
R/W this flag and get/put budget.


thanks,
Ming

