Return-Path: <SRS0=JvOq=BQ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68E01C4345B
	for <linux-scsi@archiver.kernel.org>; Thu,  6 Aug 2020 11:17:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A25BE22DA7
	for <linux-scsi@archiver.kernel.org>; Thu,  6 Aug 2020 11:17:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="TCZ0XQve"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726024AbgHFLFN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 6 Aug 2020 07:05:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729386AbgHFKgX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Aug 2020 06:36:23 -0400
Received: from mail-qv1-xf41.google.com (mail-qv1-xf41.google.com [IPv6:2607:f8b0:4864:20::f41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBABDC061575
        for <linux-scsi@vger.kernel.org>; Thu,  6 Aug 2020 03:25:55 -0700 (PDT)
Received: by mail-qv1-xf41.google.com with SMTP id cs12so3950943qvb.2
        for <linux-scsi@vger.kernel.org>; Thu, 06 Aug 2020 03:25:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:references:in-reply-to:mime-version:thread-index:date
         :message-id:subject:to:cc;
        bh=aaR3OT6TJPjlPk+cF0HIX8EJKn+X11PqGrJWWUSncmI=;
        b=TCZ0XQvefoLcv4TDP8wYVVnpoV+RprXbzClVm5PGYZ8sNSnFCr+ToQNbBtQalVheXU
         xoj9hTyauKUkmQChl+VijtSRfepsU0pvKDse0DlcwEYFez/VKLbi+i3/uUjbw41Xq7tU
         E8VbArHzTup4VP2PUEb14STHKRbDHvsxUCyFA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:references:in-reply-to:mime-version
         :thread-index:date:message-id:subject:to:cc;
        bh=aaR3OT6TJPjlPk+cF0HIX8EJKn+X11PqGrJWWUSncmI=;
        b=TsejaM/5Kkc3r1LOcs5KUE4PldRZgZz427LrULTxyNosRs45mFC0fT0fCGqgJ9LRMm
         VaBuBul2CbgtiByEu/eXvNYHz1tQKW20FfN7J9GZgvkvbnrbRjzBEB08eRca/JYp0Dzq
         A31RnF5BXUZWn9cyzjq9kwzn87uHwvesNu/3M2ECr41a3IaWg7lbkue/lmDnTSyWugBq
         dQFBbePpf4QVZmXZ2p/WsmOgoDWDLm1RfVsYDiWitdB6WmIgPWFSGNd6hy+RMTLOKr2/
         AZJaQlfj9EcsLObODR0IJV51PgSDgajJ0ZhaiXa49Rnb6l/o4UzfNWLo2nh+0MRWGjkL
         TYjw==
X-Gm-Message-State: AOAM530+OIZTRYp8pEzQwpJnUOLbqvbzjcm2CCVWTt47buMSSNJiIQlX
        pkr/9hR5SP6t19y7ereC/9XQbR37vHxji3CnuyML8A==
X-Google-Smtp-Source: ABdhPJy/6t4J5UYmaqtAPzKDkVMtV4ysOg1nHTxju0SAwsQo6Ut9l+lylsgDExI0TuRQRnadFRqgrxSoIXO/QCeFqLk=
X-Received: by 2002:a0c:c1cf:: with SMTP id v15mr7849584qvh.192.1596709554390;
 Thu, 06 Aug 2020 03:25:54 -0700 (PDT)
From:   Kashyap Desai <kashyap.desai@broadcom.com>
References: <20200723140758.GA957464@T590> <f4a896a3-756e-68bb-7700-cab1e5523c81@huawei.com>
 <20200724024704.GB957464@T590> <6531e06c-9ce2-73e6-46fc-8e97400f07b2@huawei.com>
 <20200728084511.GA1326626@T590> <965cf22eea98c00618570da8424d0d94@mail.gmail.com>
 <20200729153648.GA1698748@T590> <7f94eaf2318cc26ceb64bde88d59d5e2@mail.gmail.com>
 <20200804083625.GA1958244@T590> <afe5eb1be7f416a48d7b5d473f3053d0@mail.gmail.com>
 <20200805084031.GA1995289@T590>
In-Reply-To: <20200805084031.GA1995289@T590>
MIME-Version: 1.0
X-Mailer: Microsoft Outlook 15.0
Thread-Index: AQIxGEBSWJHHOsgmkT+VJzn9XYkNSgBZ/QfjAT/44nIA/TMF8AMjI78NAhDoE38B/wNHnAH3z9//AiXTC0wDI6cgwwFSJLZtp+KRYSA=
Date:   Thu, 6 Aug 2020 15:55:50 +0530
Message-ID: <5adffdf805179428bdd0dd6c293a4f7d@mail.gmail.com>
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

> > Ming -
> >
> > I noted your comments.
> >
> > I have completed testing and this particular latest performance issue
> > on Volume is outstanding.
> > Currently it is 20-25% performance drop in IOPs and we want that to be
> > closed before shared host tag is enabled for <megaraid_sas> driver.
> > Just for my understanding - What will be the next steps on this ?
> >
> > I can validate any new approach/patch for this issue.
> >
>
> Hello,
>
> What do you think of the following patch?

I tested this patch. I still see IO hang.

>
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c index
> c866a4f33871..49f0fc5c7a63 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -552,8 +552,24 @@ static void scsi_run_queue_async(struct scsi_device
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
> +			blk_mq_run_hw_queues(sdev->request_queue, true);
> +
> +			/*
> +			 * ->restarts has to be kept as non-zero if there
is
> +			 *  new budget contention comes.
> +			 */
> +			atomic_cmpxchg(&sdev->restarts, old, 0);
> +		}
> +	}
>  }
>
>  /* Returns false when no more bytes to process, true if there are more
*/
> @@ -1612,8 +1628,34 @@ static void scsi_mq_put_budget(struct
> request_queue *q)  static bool scsi_mq_get_budget(struct request_queue
*q)
> {
>  	struct scsi_device *sdev = q->queuedata;
> +	int ret = scsi_dev_queue_ready(q, sdev);
>
> -	return scsi_dev_queue_ready(q, sdev);
> +	if (ret)
> +		return true;
> +
> +	/*
> +	 * If all in-flight requests originated from this LUN are
completed
> +	 * before setting .restarts, sdev->device_busy will be observed as
> +	 * zero, then blk_mq_delay_run_hw_queue() will dispatch this
request
> +	 * soon. Otherwise, completion of one of these request will
observe
> +	 * the .restarts flag, and the request queue will be run for
handling
> +	 * this request, see scsi_end_request().
> +	 */
> +	atomic_inc(&sdev->restarts);
> +
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
> +	if (unlikely(atomic_read(&sdev->device_busy) == 0 &&
> +				!scsi_device_blocked(sdev)))
> +		blk_mq_delay_run_hw_queues(sdev->request_queue,
> SCSI_QUEUE_DELAY);

Hi Ming -

There is still some race which is not handled.  Take a case of IO is not
able to get budget and it has already marked <restarts> flag.
<restarts> flag will be seen non-zero in completion path and completion
path will attempt h/w queue run. (But this particular IO is still not in
s/w queue.).
Attempt of running h/w queue from completion path will not flush any IO
since there is no IO in s/w queue.

I think above code is added assuming it should manage this particular
case, but this code also does not help. If some IO in between submitted
directly to the h/w queue then sdev->device_busy will be non-zero.
	
If I move above section of the code into completion path, IO hang is
resolved.  I also verify performance -

Multi Drive R0 	1 workers per VD gives	662K prior to this patch and now
It scale to 1.1M IOPs. (90% improvement)
Multi Drive R0  4 workers per VD gives 1.9M prior to this patch and now It
scale to 3.1M IOPs. (50% improvement)

Here is modified patch -

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 6f50e5c..dcdc5f6 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -594,8 +594,26 @@ static bool scsi_end_request(struct request *req,
blk_status_t error,
        if (scsi_target(sdev)->single_lun ||
            !list_empty(&sdev->host->starved_list))
                kblockd_schedule_work(&sdev->requeue_work);
-       else
-               blk_mq_run_hw_queues(q, true);
+       else {
+               /*
+                * smp_mb() implied in either rq->end_io or
blk_mq_free_request
+                * is for ordering writing .device_busy in
scsi_device_unbusy()
+                * and reading sdev->restarts.
+                */
+               int old = atomic_read(&sdev->restarts);
+
+               if (old) {
+                       blk_mq_run_hw_queues(sdev->request_queue, true);
+
+                       /*
+                        * ->restarts has to be kept as non-zero if there
is
+                        *  new budget contention comes.
+                        */
+                       atomic_cmpxchg(&sdev->restarts, old, 0);
+               } else if (unlikely(atomic_read(&sdev->device_busy) == 0
&&
+                                       !scsi_device_blocked(sdev)))
+                       blk_mq_delay_run_hw_queues(sdev->request_queue,
SCSI_QUEUE_DELAY);
+       }

        percpu_ref_put(&q->q_usage_counter);
        return false;
@@ -1615,8 +1633,31 @@ static bool scsi_mq_get_budget(struct blk_mq_hw_ctx
*hctx)
 {
        struct request_queue *q = hctx->queue;
        struct scsi_device *sdev = q->queuedata;
+       int ret = scsi_dev_queue_ready(q, sdev);
+
+       if (ret)
+               return true;

-       return scsi_dev_queue_ready(q, sdev);
+       /*
+        * If all in-flight requests originated from this LUN are
completed
+        * before setting .restarts, sdev->device_busy will be observed as
+        * zero, then blk_mq_delay_run_hw_queue() will dispatch this
request
+        * soon. Otherwise, completion of one of these request will
observe
+        * the .restarts flag, and the request queue will be run for
handling
+        * this request, see scsi_end_request().
+        */
+       atomic_inc(&sdev->restarts);
+
+       /*
+        * Order writing .restarts and reading .device_busy, and make sure
+        * .restarts is visible to scsi_end_request(). Its pair is implied
by
+        * __blk_mq_end_request() in scsi_end_request() for ordering
+        * writing .device_busy in scsi_device_unbusy() and reading
.restarts.
+        *
+        */
+       smp_mb__after_atomic();
+
+       return false;
 }

 static blk_status_t scsi_queue_rq(struct blk_mq_hw_ctx *hctx,
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index bc59090..ac45058 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -108,7 +108,8 @@ struct scsi_device {

        atomic_t device_busy;           /* commands actually active on
LLDD */
        atomic_t device_blocked;        /* Device returned QUEUE_FULL. */
-
+
+       atomic_t restarts;
        spinlock_t list_lock;
        struct list_head starved_entry;
        unsigned short queue_depth;     /* How deep of a queue we want */
