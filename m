Return-Path: <SRS0=1wnw=BT=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AEB69C433E1
	for <linux-scsi@archiver.kernel.org>; Sun,  9 Aug 2020 02:17:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8A788206E2
	for <linux-scsi@archiver.kernel.org>; Sun,  9 Aug 2020 02:17:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QW083Wsz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726073AbgHICRE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 8 Aug 2020 22:17:04 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:45345 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725988AbgHICRE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 8 Aug 2020 22:17:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596939421;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=mYXQdmzaZ6N4GIvtqoMuI82wQrzXh7PjWvL5d//vkVc=;
        b=QW083Wsz1eZDTeClEHzpYPpnFuJkNbvCnzY7Fpwh/+UXq1PWUL+/HpQ1GwKoGO07Gf/GTp
        cYXm+O+RKs1jKtJicM1BnWDnOKFKyZyKhREgvez1cDCgnmZGzzUOOXl4ikZPL4yCMvGhdr
        DQgwnmArvPnqEAu38d78dnmqKx8Bqhk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-479-6dESzTRyPlCj7ViM1aZSmg-1; Sat, 08 Aug 2020 22:16:57 -0400
X-MC-Unique: 6dESzTRyPlCj7ViM1aZSmg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5AC751009600;
        Sun,  9 Aug 2020 02:16:54 +0000 (UTC)
Received: from T590 (ovpn-12-63.pek2.redhat.com [10.72.12.63])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 19B9B10023A0;
        Sun,  9 Aug 2020 02:16:38 +0000 (UTC)
Date:   Sun, 9 Aug 2020 10:16:33 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Kashyap Desai <kashyap.desai@broadcom.com>
Cc:     John Garry <john.garry@huawei.com>, axboe@kernel.dk,
        jejb@linux.ibm.com, martin.petersen@oracle.com,
        don.brace@microsemi.com, Sumit Saxena <sumit.saxena@broadcom.com>,
        bvanassche@acm.org, hare@suse.com, hch@lst.de,
        Shivasharan Srikanteshwara 
        <shivasharan.srikanteshwara@broadcom.com>,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        esc.storagedev@microsemi.com, chenxiang66@hisilicon.com,
        "PDL,MEGARAIDLINUX" <megaraidlinux.pdl@broadcom.com>
Subject: Re: [PATCH RFC v7 10/12] megaraid_sas: switch fusion adapters to MQ
Message-ID: <20200809021633.GA2134904@T590>
References: <20200729153648.GA1698748@T590>
 <7f94eaf2318cc26ceb64bde88d59d5e2@mail.gmail.com>
 <20200804083625.GA1958244@T590>
 <afe5eb1be7f416a48d7b5d473f3053d0@mail.gmail.com>
 <20200805084031.GA1995289@T590>
 <5adffdf805179428bdd0dd6c293a4f7d@mail.gmail.com>
 <20200806133819.GA2046861@T590>
 <f1ac35dfca34193e6c9bcedbc11911d2@mail.gmail.com>
 <20200806152939.GA2062348@T590>
 <3f35b0f67c73c8c4996fdad80eb6d963@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3f35b0f67c73c8c4996fdad80eb6d963@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sun, Aug 09, 2020 at 12:35:21AM +0530, Kashyap Desai wrote:
> > On Thu, Aug 06, 2020 at 08:07:38PM +0530, Kashyap Desai wrote:
> > > > > Hi Ming -
> > > > >
> > > > > There is still some race which is not handled.  Take a case of IO
> > > > > is not able to get budget and it has already marked <restarts>
> flag.
> > > > > <restarts> flag will be seen non-zero in completion path and
> > > > > completion path will attempt h/w queue run. (But this particular
> > > > > IO is still not in s/w queue.).
> > > > > Attempt of running h/w queue from completion path will not flush
> > > > > any IO since there is no IO in s/w queue.
> > > >
> > > > Then where is the IO to be submitted in case of running out of
> budget?
> > >
> > > Typical race in your latest patch is - (Lets consider command A,B and
> > > C) Command A did not receive budget. Command B completed  (which was
> > > already
> >
> > Command A doesn't get budget, and A is still in sw/scheduler queue
> because
> > we try to acquire budget before dequeuing request from sw/scheduler
> queue,
> > see __blk_mq_do_dispatch_sched() and blk_mq_do_dispatch_ctx().
> >
> > Not consider direct issue, because the hw queue will be run explicitly
> when
> > not getting budget, see __blk_mq_try_issue_directly.
> >
> > Not consider command A being added to hctx->dispatch too, because blk-mq
> > will re-run the queue, see blk_mq_dispatch_rq_list().
> 
> Ming -
> 
> After going through your comment (I noted your comment and thanks for
> correcting my understanding.) and block layer code, I realize that it is a
> different race condition. My previous explanation was not accurate.
> I debug further and figure out what is actually happening - Consider below
> scenario/sequence -
> 
> Thread -1 - Detected budget contention. Set restarts = 1.
> Thread -2 - old restarts = 1. start hw queue.
> Thread -3 - old restarts = 1. start hw queue.
> Thread -2 - move restarts = 0.
> In my testing, I noticed that both thread-2 and thread-3 started h/w queue
> but there was no work for them to do. It is possible because some other
> context of h/w queue run might have done that job.

It should be true, because there is other run queue somewhere, such as
blk-mq's restart or delay run queue.

> It means, IO of thread-1 is already posted.

OK.

> Thread -4 - Detected budget contention. Set restart = 1 (because thread-2
> has move restarts=0).

OK.

> Thread -3 - move restarts = 0 (because this thread see old value = 1 but
> that is actually updated one more time by thread-4 and theread-4 actually
> wanted to run h/w queues). IO of Thread-4 will not be scheduled.

Right.

> 
> We have to make sure that completion IO path do atomic_cmpxchng of
> restarts flag before running the h/w queue.  Below code change - (main fix
> is sequence of atomic_cmpxchg and blk_mq_run_hw_queues) fix the issue.
> 
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -594,8 +594,27 @@ static bool scsi_end_request(struct request *req,
> blk_status_t error,
>         if (scsi_target(sdev)->single_lun ||
>             !list_empty(&sdev->host->starved_list))
>                 kblockd_schedule_work(&sdev->requeue_work);
> -       else
> -               blk_mq_run_hw_queues(q, true);
> +       else {
> +               /*
> +                * smp_mb() implied in either rq->end_io or
> blk_mq_free_request
> +                * is for ordering writing .device_busy in
> scsi_device_unbusy()
> +                * and reading sdev->restarts.
> +                */
> +               int old = atomic_read(&sdev->restarts);
> +
> +               if (old) {
> +                       /*
> +                        * ->restarts has to be kept as non-zero if there
> is
> +                        *  new budget contention comes.
> +                        */
> +                       atomic_cmpxchg(&sdev->restarts, old, 0);
> +
> +                       /* run the queue after restarts flag is updated
> +                        * to avoid race condition with .get_budget
> +                        */
> +                       blk_mq_run_hw_queues(sdev->request_queue, true);
> +               }
> +       }
> 

I think the above change is right, and this patter is basically same with SCHED_RESTART
used in blk_mq_sched_restart().

BTW, could you run your function & performance test against the following new version?
Then I can include your test result in commit log for moving on.


From 06993ddf5c5dbe0e772cc38342919eb61a57bc50 Mon Sep 17 00:00:00 2001
From: Ming Lei <ming.lei@redhat.com>
Date: Wed, 5 Aug 2020 16:35:53 +0800
Subject: [PATCH] scsi: core: only re-run queue in scsi_end_request() if device
 queue is busy

Now the request queue is run in scsi_end_request() unconditionally if both
target queue and host queue is ready. We should have re-run request queue
only after this device queue becomes busy for restarting this LUN only.

Recently Long Li reported that cost of run queue may be very heavy in
case of high queue depth. So improve this situation by only running
the request queue when this LUN is busy.

Cc: Jens Axboe <axboe@kernel.dk>
Cc: Ewan D. Milne <emilne@redhat.com>
Cc: Kashyap Desai <kashyap.desai@broadcom.com>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Bart Van Assche <bvanassche@acm.org>
Cc: Damien Le Moal <damien.lemoal@wdc.com>
Cc: Long Li <longli@microsoft.com>
Reported-by: Long Li <longli@microsoft.com>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
V4:
	- not clear .restarts in get_budget(), instead clearing it
	after re-run queue is done; Kashyap figured out we have to
	update ->restarts before re-run queue in scsi_run_queue_async().

V3:
	- add one smp_mb() in scsi_mq_get_budget() and comment

V2:
	- commit log change, no any code change
	- add reported-by tag

Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 drivers/scsi/scsi_lib.c    | 51 +++++++++++++++++++++++++++++++++++---
 include/scsi/scsi_device.h |  1 +
 2 files changed, 49 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index c866a4f33871..d083250f9518 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -552,8 +552,27 @@ static void scsi_run_queue_async(struct scsi_device *sdev)
 	if (scsi_target(sdev)->single_lun ||
 	    !list_empty(&sdev->host->starved_list))
 		kblockd_schedule_work(&sdev->requeue_work);
-	else
-		blk_mq_run_hw_queues(sdev->request_queue, true);
+	else {
+		/*
+		 * smp_mb() implied in either rq->end_io or blk_mq_free_request
+		 * is for ordering writing .device_busy in scsi_device_unbusy()
+		 * and reading sdev->restarts.
+		 */
+		int old = atomic_read(&sdev->restarts);
+
+		if (old) {
+			/*
+			 * ->restarts has to be kept as non-zero if there is
+			 *  new budget contention comes.
+			 *
+			 *  No need to run queue when either another re-run
+			 *  queue wins in updating ->restarts or one new budget
+			 *  contention comes.
+			 */
+			if (atomic_cmpxchg(&sdev->restarts, old, 0) == old)
+				blk_mq_run_hw_queues(sdev->request_queue, true);
+		}
+	}
 }
 
 /* Returns false when no more bytes to process, true if there are more */
@@ -1612,8 +1631,34 @@ static void scsi_mq_put_budget(struct request_queue *q)
 static bool scsi_mq_get_budget(struct request_queue *q)
 {
 	struct scsi_device *sdev = q->queuedata;
+	int ret = scsi_dev_queue_ready(q, sdev);
+
+	if (ret)
+		return true;
+
+	atomic_inc(&sdev->restarts);
 
-	return scsi_dev_queue_ready(q, sdev);
+	/*
+	 * Order writing .restarts and reading .device_busy, and make sure
+	 * .restarts is visible to scsi_end_request(). Its pair is implied by
+	 * __blk_mq_end_request() in scsi_end_request() for ordering
+	 * writing .device_busy in scsi_device_unbusy() and reading .restarts.
+	 *
+	 */
+	smp_mb__after_atomic();
+
+	/*
+	 * If all in-flight requests originated from this LUN are completed
+	 * before setting .restarts, sdev->device_busy will be observed as
+	 * zero, then blk_mq_delay_run_hw_queues() will dispatch this request
+	 * soon. Otherwise, completion of one of these request will observe
+	 * the .restarts flag, and the request queue will be run for handling
+	 * this request, see scsi_end_request().
+	 */
+	if (unlikely(atomic_read(&sdev->device_busy) == 0 &&
+				!scsi_device_blocked(sdev)))
+		blk_mq_delay_run_hw_queues(sdev->request_queue, SCSI_QUEUE_DELAY);
+	return false;
 }
 
 static blk_status_t scsi_queue_rq(struct blk_mq_hw_ctx *hctx,
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index bc5909033d13..1a5c9a3df6d6 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -109,6 +109,7 @@ struct scsi_device {
 	atomic_t device_busy;		/* commands actually active on LLDD */
 	atomic_t device_blocked;	/* Device returned QUEUE_FULL. */
 
+	atomic_t restarts;
 	spinlock_t list_lock;
 	struct list_head starved_entry;
 	unsigned short queue_depth;	/* How deep of a queue we want */
-- 
2.25.2



Thanks,
Ming

