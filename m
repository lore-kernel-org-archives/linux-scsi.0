Return-Path: <SRS0=QZQu=BU=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F44CC433E0
	for <linux-scsi@archiver.kernel.org>; Mon, 10 Aug 2020 16:39:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 60BCF2076B
	for <linux-scsi@archiver.kernel.org>; Mon, 10 Aug 2020 16:39:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="NM8UdW0Y"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727878AbgHJQjF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 10 Aug 2020 12:39:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727834AbgHJQjE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 10 Aug 2020 12:39:04 -0400
Received: from mail-qk1-x741.google.com (mail-qk1-x741.google.com [IPv6:2607:f8b0:4864:20::741])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9EF7C061787
        for <linux-scsi@vger.kernel.org>; Mon, 10 Aug 2020 09:39:03 -0700 (PDT)
Received: by mail-qk1-x741.google.com with SMTP id j187so8891871qke.11
        for <linux-scsi@vger.kernel.org>; Mon, 10 Aug 2020 09:39:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:references:in-reply-to:mime-version:thread-index:date
         :message-id:subject:to:cc;
        bh=7OISHQ5S7uFDJjSzqApjBijBbbK4ilRz/I7r1jA+1kw=;
        b=NM8UdW0YBwqfiRxeSJHjaVanrZk2HkWNzIMAinQ7ISfxrBfyr/0J/JcGdTR+m07Hjs
         HnB1C85Dv9BnaEj8pCZoAqDJfUopVdegoqRnC3Wp5PvgMEUCdqXKzWvXYfumwczLaR5h
         K+4suADdUCSnrXmCAqBHBvbDdnqhMBI022q00=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:references:in-reply-to:mime-version
         :thread-index:date:message-id:subject:to:cc;
        bh=7OISHQ5S7uFDJjSzqApjBijBbbK4ilRz/I7r1jA+1kw=;
        b=SZJb/2MVP2/JZFitSWFdQTl9Qpd1JUP0L+0Nk+p5keVujkrFUOINDhgAAuwVJhBjJ3
         psOWgzWOcWgeE7nWVM5qo2dZhg9xucN3SPJwHHnMrWzOBVHchmNf+0WbUTLIqlVfi55w
         2CcuNgSRFTzxAV0pY9+2yxMSfe+3ol0qNccsO+HQ2OsZ+9kgM9G3P0cN7odcTbVMR1H/
         GX/+DZc3psZrvLMTrz+gcmfOglJhVRdGca+IsjBi5Be9S2M5b4dgv54o/xw6B+dFWH1l
         k4fK5L0wz2/kWTYNu1d5K/LwzMhga6Vilx3WiAoeDHeNjDlmvcmjoAoIKIcS4grsJxgt
         T5vQ==
X-Gm-Message-State: AOAM530TFyXikI0rPIncb11vwddvf5xgUDILw6QfluruoI0/CBV3+Pag
        GkghqH85n0n9DIcxiR23s1bgdoHfvaOorOoMqA9S/w==
X-Google-Smtp-Source: ABdhPJzCUG0q/IHd/PForZfJGWJDBkbn/RDJgyVlepvwQfsdov3eRyVm2ndvPxbfBnFZ6ofgWYCxe+evXo6X5wsRqV8=
X-Received: by 2002:a05:620a:9c6:: with SMTP id y6mr25485316qky.27.1597077542501;
 Mon, 10 Aug 2020 09:39:02 -0700 (PDT)
From:   Kashyap Desai <kashyap.desai@broadcom.com>
References: <20200729153648.GA1698748@T590> <7f94eaf2318cc26ceb64bde88d59d5e2@mail.gmail.com>
 <20200804083625.GA1958244@T590> <afe5eb1be7f416a48d7b5d473f3053d0@mail.gmail.com>
 <20200805084031.GA1995289@T590> <5adffdf805179428bdd0dd6c293a4f7d@mail.gmail.com>
 <20200806133819.GA2046861@T590> <f1ac35dfca34193e6c9bcedbc11911d2@mail.gmail.com>
 <20200806152939.GA2062348@T590> <3f35b0f67c73c8c4996fdad80eb6d963@mail.gmail.com>
 <20200809021633.GA2134904@T590>
In-Reply-To: <20200809021633.GA2134904@T590>
MIME-Version: 1.0
X-Mailer: Microsoft Outlook 15.0
Thread-Index: AQH/A0eco5N6O5ofbhtFVgRA/dxPrQH3z9//AiXTC0wDI6cgwwFSJLZtAawi+ucB2l0ciQK2moYdAS+j/goBcwPv3wKnjC8NqD+Go4A=
Date:   Mon, 10 Aug 2020 22:08:59 +0530
Message-ID: <6f8790811e7a3238f2b0fa35fbb816bc@mail.gmail.com>
Subject: RE: [PATCH RFC v7 10/12] megaraid_sas: switch fusion adapters to MQ
To:     Ming Lei <ming.lei@redhat.com>
Cc:     John Garry <john.garry@huawei.com>, axboe@kernel.dk,
        jejb@linux.ibm.com, martin.petersen@oracle.com,
        don.brace@microsemi.com, Sumit Saxena <sumit.saxena@broadcom.com>,
        bvanassche@acm.org, hare@suse.com, hch@lst.de,
        Shivasharan Srikanteshwara 
        <shivasharan.srikanteshwara@broadcom.com>,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        esc.storagedev@microsemi.com, chenxiang66@hisilicon.com,
        "PDL,MEGARAIDLINUX" <megaraidlinux.pdl@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> On Sun, Aug 09, 2020 at 12:35:21AM +0530, Kashyap Desai wrote:
> > > On Thu, Aug 06, 2020 at 08:07:38PM +0530, Kashyap Desai wrote:
> > > > > > Hi Ming -
> > > > > >
> > > > > > There is still some race which is not handled.  Take a case of
> > > > > > IO is not able to get budget and it has already marked
> > > > > > <restarts>
> > flag.
> > > > > > <restarts> flag will be seen non-zero in completion path and
> > > > > > completion path will attempt h/w queue run. (But this
> > > > > > particular IO is still not in s/w queue.).
> > > > > > Attempt of running h/w queue from completion path will not
> > > > > > flush any IO since there is no IO in s/w queue.
> > > > >
> > > > > Then where is the IO to be submitted in case of running out of
> > budget?
> > > >
> > > > Typical race in your latest patch is - (Lets consider command A,B
> > > > and
> > > > C) Command A did not receive budget. Command B completed  (which
> > > > was already
> > >
> > > Command A doesn't get budget, and A is still in sw/scheduler queue
> > because
> > > we try to acquire budget before dequeuing request from sw/scheduler
> > queue,
> > > see __blk_mq_do_dispatch_sched() and blk_mq_do_dispatch_ctx().
> > >
> > > Not consider direct issue, because the hw queue will be run
> > > explicitly
> > when
> > > not getting budget, see __blk_mq_try_issue_directly.
> > >
> > > Not consider command A being added to hctx->dispatch too, because
> > > blk-mq will re-run the queue, see blk_mq_dispatch_rq_list().
> >
> > Ming -
> >
> > After going through your comment (I noted your comment and thanks for
> > correcting my understanding.) and block layer code, I realize that it
> > is a different race condition. My previous explanation was not
accurate.
> > I debug further and figure out what is actually happening - Consider
> > below scenario/sequence -
> >
> > Thread -1 - Detected budget contention. Set restarts = 1.
> > Thread -2 - old restarts = 1. start hw queue.
> > Thread -3 - old restarts = 1. start hw queue.
> > Thread -2 - move restarts = 0.
> > In my testing, I noticed that both thread-2 and thread-3 started h/w
> > queue but there was no work for them to do. It is possible because
> > some other context of h/w queue run might have done that job.
>
> It should be true, because there is other run queue somewhere, such as
blk-
> mq's restart or delay run queue.
>
> > It means, IO of thread-1 is already posted.
>
> OK.
>
> > Thread -4 - Detected budget contention. Set restart = 1 (because
> > thread-2 has move restarts=0).
>
> OK.
>
> > Thread -3 - move restarts = 0 (because this thread see old value = 1
> > but that is actually updated one more time by thread-4 and theread-4
> > actually wanted to run h/w queues). IO of Thread-4 will not be
scheduled.
>
> Right.
>
> >
> > We have to make sure that completion IO path do atomic_cmpxchng of
> > restarts flag before running the h/w queue.  Below code change - (main
> > fix is sequence of atomic_cmpxchg and blk_mq_run_hw_queues) fix the
> issue.
> >
> > --- a/drivers/scsi/scsi_lib.c
> > +++ b/drivers/scsi/scsi_lib.c
> > @@ -594,8 +594,27 @@ static bool scsi_end_request(struct request *req,
> > blk_status_t error,
> >         if (scsi_target(sdev)->single_lun ||
> >             !list_empty(&sdev->host->starved_list))
> >                 kblockd_schedule_work(&sdev->requeue_work);
> > -       else
> > -               blk_mq_run_hw_queues(q, true);
> > +       else {
> > +               /*
> > +                * smp_mb() implied in either rq->end_io or
> > blk_mq_free_request
> > +                * is for ordering writing .device_busy in
> > scsi_device_unbusy()
> > +                * and reading sdev->restarts.
> > +                */
> > +               int old = atomic_read(&sdev->restarts);
> > +
> > +               if (old) {
> > +                       /*
> > +                        * ->restarts has to be kept as non-zero if
> > + there
> > is
> > +                        *  new budget contention comes.
> > +                        */
> > +                       atomic_cmpxchg(&sdev->restarts, old, 0);
> > +
> > +                       /* run the queue after restarts flag is
updated
> > +                        * to avoid race condition with .get_budget
> > +                        */
> > +                       blk_mq_run_hw_queues(sdev->request_queue,
true);
> > +               }
> > +       }
> >
>
> I think the above change is right, and this patter is basically same
with
> SCHED_RESTART used in blk_mq_sched_restart().
>
> BTW, could you run your function & performance test against the
following
> new version?
> Then I can include your test result in commit log for moving on.

Ming  - I completed both functional and performance test.

System used for the test -
Manufacturer: Supermicro
Product Name: X11DPG-QT

lscpu <snippet>
CPU(s):                72
On-line CPU(s) list:   0-71
Thread(s) per core:    2
Core(s) per socket:    18
Socket(s):             2
NUMA node(s):          2
Model name:            Intel(R) Xeon(R) Gold 6150 CPU @ 2.70GHz

Controller used -
MegaRAID 9560-16i

Total 24 SAS driver of model "WDC      WUSTM3240ASS200"

Total 3 VD created each VD consist of 8 SAS Drives.

Performance testing -

Fio script -
[global]
ioengine=libaio
direct=1
sync=0
ramp_time=20
runtime=60
cpus_allowed=18,19
bs=4k
rw=randread
ioscheduler=none
iodepth=128

[seqprecon]
filename=/dev/sdc
[seqprecon]
filename=/dev/sdd
[seqprecon]
filename=/dev/sde

Without this patch - 602K IOPS. Perf top snippet -(Note - Usage of
blk_mq_run_hw_queues -> blk_mq_run_hw_queue is very high. It consume more
CPU which leads to less performance.)

     8.70%  [kernel]        [k] blk_mq_run_hw_queue
     5.24%  [megaraid_sas]  [k] complete_cmd_fusion
     4.65%  [kernel]        [k] sbitmap_any_bit_set
     3.93%  [kernel]        [k] irq_entries_start
     3.58%  perf            [.] __symbols__insert
     2.21%  [megaraid_sas]  [k] megasas_build_and_issue_cmd_fusion
     1.91%  [kernel]        [k] blk_mq_run_hw_queues

With this patch - 1110K IOPS. Perf top snippet -

    8.05%  [megaraid_sas]  [k] complete_cmd_fusion
     4.10%  [kernel]        [k] irq_entries_start
     3.71%  [megaraid_sas]  [k] megasas_build_and_issue_cmd_fusion
     2.85%  [kernel]        [k] read_tsc
     2.83%  [kernel]        [k] io_submit_one
     2.26%  [kernel]        [k] entry_SYSCALL_64
     2.08%  [megaraid_sas]  [k] megasas_queue_command


Functional Test -

I cover overnight IO testing using <fio> script which sends 4K rand read,
read, rand write and write IOs to the 24 SAS JBOD drives.
Some of the JBOD has ioscheduler=none and some of the JBOD has
ioscheduler=mq-deadline
I used additional script which change sdev->queue_depth of each device
from 2 to 16 range at the interval of 5 seconds.
I used additional script which toggle "rq_affinity=1" and "rq_affinity=2"
at the interval of 5 seconds.

I did not noticed any IO hang.

Thanks, Kashyap

>
>
> From 06993ddf5c5dbe0e772cc38342919eb61a57bc50 Mon Sep 17 00:00:00
> 2001
> From: Ming Lei <ming.lei@redhat.com>
> Date: Wed, 5 Aug 2020 16:35:53 +0800
> Subject: [PATCH] scsi: core: only re-run queue in scsi_end_request() if
device
> queue is busy
>
> Now the request queue is run in scsi_end_request() unconditionally if
both
> target queue and host queue is ready. We should have re-run request
queue
> only after this device queue becomes busy for restarting this LUN only.
>
> Recently Long Li reported that cost of run queue may be very heavy in
case of
> high queue depth. So improve this situation by only running the request
queue
> when this LUN is busy.
>
> Cc: Jens Axboe <axboe@kernel.dk>
> Cc: Ewan D. Milne <emilne@redhat.com>
> Cc: Kashyap Desai <kashyap.desai@broadcom.com>
> Cc: Hannes Reinecke <hare@suse.de>
> Cc: Bart Van Assche <bvanassche@acm.org>
> Cc: Damien Le Moal <damien.lemoal@wdc.com>
> Cc: Long Li <longli@microsoft.com>
> Reported-by: Long Li <longli@microsoft.com>
> Signed-off-by: Ming Lei <ming.lei@redhat.com>
> ---
> V4:
> 	- not clear .restarts in get_budget(), instead clearing it
> 	after re-run queue is done; Kashyap figured out we have to
> 	update ->restarts before re-run queue in scsi_run_queue_async().
>
> V3:
> 	- add one smp_mb() in scsi_mq_get_budget() and comment
>
> V2:
> 	- commit log change, no any code change
> 	- add reported-by tag
>
> Signed-off-by: Ming Lei <ming.lei@redhat.com>
> ---
>  drivers/scsi/scsi_lib.c    | 51 +++++++++++++++++++++++++++++++++++---
>  include/scsi/scsi_device.h |  1 +
>  2 files changed, 49 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c index
> c866a4f33871..d083250f9518 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -552,8 +552,27 @@ static void scsi_run_queue_async(struct scsi_device
> *sdev)
>  	if (scsi_target(sdev)->single_lun ||
>  	    !list_empty(&sdev->host->starved_list))
>  		kblockd_schedule_work(&sdev->requeue_work);
> -	else
> -		blk_mq_run_hw_queues(sdev->request_queue, true);
> +	else {
> +		/*
> +		 * smp_mb() implied in either rq->end_io or
> blk_mq_free_request
> +		 * is for ordering writing .device_busy in
scsi_device_unbusy()
> +		 * and reading sdev->restarts.
> +		 */
> +		int old = atomic_read(&sdev->restarts);
> +
> +		if (old) {
> +			/*
> +			 * ->restarts has to be kept as non-zero if there
is
> +			 *  new budget contention comes.
> +			 *
> +			 *  No need to run queue when either another
re-run
> +			 *  queue wins in updating ->restarts or one new
> budget
> +			 *  contention comes.
> +			 */
> +			if (atomic_cmpxchg(&sdev->restarts, old, 0) ==
old)
> +				blk_mq_run_hw_queues(sdev-
> >request_queue, true);
> +		}
> +	}
>  }
>
>  /* Returns false when no more bytes to process, true if there are more
*/
> @@ -1612,8 +1631,34 @@ static void scsi_mq_put_budget(struct
> request_queue *q)  static bool scsi_mq_get_budget(struct request_queue
*q)
> {
>  	struct scsi_device *sdev = q->queuedata;
> +	int ret = scsi_dev_queue_ready(q, sdev);
> +
> +	if (ret)
> +		return true;
> +
> +	atomic_inc(&sdev->restarts);
>
> -	return scsi_dev_queue_ready(q, sdev);
> +	/*
> +	 * Order writing .restarts and reading .device_busy, and make sure
> +	 * .restarts is visible to scsi_end_request(). Its pair is implied
by
> +	 * __blk_mq_end_request() in scsi_end_request() for ordering
> +	 * writing .device_busy in scsi_device_unbusy() and reading
.restarts.
> +	 *
> +	 */
> +	smp_mb__after_atomic();
> +
> +	/*
> +	 * If all in-flight requests originated from this LUN are
completed
> +	 * before setting .restarts, sdev->device_busy will be observed as
> +	 * zero, then blk_mq_delay_run_hw_queues() will dispatch this
> request
> +	 * soon. Otherwise, completion of one of these request will
observe
> +	 * the .restarts flag, and the request queue will be run for
handling
> +	 * this request, see scsi_end_request().
> +	 */
> +	if (unlikely(atomic_read(&sdev->device_busy) == 0 &&
> +				!scsi_device_blocked(sdev)))
> +		blk_mq_delay_run_hw_queues(sdev->request_queue,
> SCSI_QUEUE_DELAY);
> +	return false;
>  }
>
>  static blk_status_t scsi_queue_rq(struct blk_mq_hw_ctx *hctx, diff
--git
> a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h index
> bc5909033d13..1a5c9a3df6d6 100644
> --- a/include/scsi/scsi_device.h
> +++ b/include/scsi/scsi_device.h
> @@ -109,6 +109,7 @@ struct scsi_device {
>  	atomic_t device_busy;		/* commands actually active on
LLDD
> */
>  	atomic_t device_blocked;	/* Device returned QUEUE_FULL. */
>
> +	atomic_t restarts;
>  	spinlock_t list_lock;
>  	struct list_head starved_entry;
>  	unsigned short queue_depth;	/* How deep of a queue we want */
> --
> 2.25.2
>
>
>
> Thanks,
> Ming
