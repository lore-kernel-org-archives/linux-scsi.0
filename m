Return-Path: <SRS0=ejtk=BS=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CE3AC433DF
	for <linux-scsi@archiver.kernel.org>; Sat,  8 Aug 2020 19:05:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EBFEF20678
	for <linux-scsi@archiver.kernel.org>; Sat,  8 Aug 2020 19:05:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="W7+tfcNT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726536AbgHHTF1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 8 Aug 2020 15:05:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726346AbgHHTF0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 8 Aug 2020 15:05:26 -0400
Received: from mail-qt1-x82f.google.com (mail-qt1-x82f.google.com [IPv6:2607:f8b0:4864:20::82f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 851B6C061A27
        for <linux-scsi@vger.kernel.org>; Sat,  8 Aug 2020 12:05:26 -0700 (PDT)
Received: by mail-qt1-x82f.google.com with SMTP id s16so3845968qtn.7
        for <linux-scsi@vger.kernel.org>; Sat, 08 Aug 2020 12:05:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:references:in-reply-to:mime-version:thread-index:date
         :message-id:subject:to:cc;
        bh=yL2/UZwpI1fKUgMiVTUcG0n2gTeUCe4ep7Qh3IOPQe4=;
        b=W7+tfcNTadux9ZruydDOwvn25cK3jUiSZFc16ccW/MZfXQpxkZu851dMozMIgBCpXo
         SmNST2s9nIRlDyg7rGsxUPTOfuPq2hE2FLOc0fQsRwH9eHM67asHmjHVQ0T9eap+rZ33
         w/F/xIOUjLN1FFkegvRY5W5xjA2N/wZWaQt5E=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:references:in-reply-to:mime-version
         :thread-index:date:message-id:subject:to:cc;
        bh=yL2/UZwpI1fKUgMiVTUcG0n2gTeUCe4ep7Qh3IOPQe4=;
        b=oB5dFJk9/L9jDXLhqqSVwiNRU1RefRVftHxC3J+8HN+Z+SFYwUn1VpiuRgy6Clf3BN
         zj28Nddck7dDzDVf0oBrLNRWLNljnVncNbazC0HYL6d7xfRctrDRsA4VzPG6Lvl7Lnk9
         7hIlVS77Qcb0tIbgEXSOFkLaWfAYqKnyoWcXvGcg8hms26ATO6bxN5mBIhxlb4cA62S+
         GaUUN4p6gQoGWTWMYzMpIbqw13C3UFmEy26Ar1RtvKLyv1lZMCTtS6FNQZM7CZ9p+VRv
         EBo42U1eYAUgm9LobDANnFHXddm+R8OQ5nZz9hXSDg3b65ak5ewm/G0ICLt2lGcuDmjE
         IEHA==
X-Gm-Message-State: AOAM531Q8TT3PQJwmD9AvcdUCdS6IYKN3iF6aU2R/C+02Q1vxUIoZKc2
        9bADqZkvvnuAihakt7VEZh0deYircWuZOd7mj2TDyA==
X-Google-Smtp-Source: ABdhPJxSDSvoxmQ/18LDhxUUacOJwztXKNmzsKQZ9/amd5uvd5KoQ8N7La375Ji8nJ7hS9NO5RxU4crYPZSEmZV/AoU=
X-Received: by 2002:ac8:faf:: with SMTP id b44mr20343687qtk.190.1596913524420;
 Sat, 08 Aug 2020 12:05:24 -0700 (PDT)
From:   Kashyap Desai <kashyap.desai@broadcom.com>
References: <20200728084511.GA1326626@T590> <965cf22eea98c00618570da8424d0d94@mail.gmail.com>
 <20200729153648.GA1698748@T590> <7f94eaf2318cc26ceb64bde88d59d5e2@mail.gmail.com>
 <20200804083625.GA1958244@T590> <afe5eb1be7f416a48d7b5d473f3053d0@mail.gmail.com>
 <20200805084031.GA1995289@T590> <5adffdf805179428bdd0dd6c293a4f7d@mail.gmail.com>
 <20200806133819.GA2046861@T590> <f1ac35dfca34193e6c9bcedbc11911d2@mail.gmail.com>
 <20200806152939.GA2062348@T590>
In-Reply-To: <20200806152939.GA2062348@T590>
MIME-Version: 1.0
X-Mailer: Microsoft Outlook 15.0
Thread-Index: AQMjI78N3hI4nYPl7m+8RPNdz72u+AIQ6BN/Af8DR5wB98/f/wIl0wtMAyOnIMMBUiS2bQGsIvrnAdpdHIkCtpqGHQEvo/4KpfSfM2A=
Date:   Sun, 9 Aug 2020 00:35:21 +0530
Message-ID: <3f35b0f67c73c8c4996fdad80eb6d963@mail.gmail.com>
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

> On Thu, Aug 06, 2020 at 08:07:38PM +0530, Kashyap Desai wrote:
> > > > Hi Ming -
> > > >
> > > > There is still some race which is not handled.  Take a case of IO
> > > > is not able to get budget and it has already marked <restarts>
flag.
> > > > <restarts> flag will be seen non-zero in completion path and
> > > > completion path will attempt h/w queue run. (But this particular
> > > > IO is still not in s/w queue.).
> > > > Attempt of running h/w queue from completion path will not flush
> > > > any IO since there is no IO in s/w queue.
> > >
> > > Then where is the IO to be submitted in case of running out of
budget?
> >
> > Typical race in your latest patch is - (Lets consider command A,B and
> > C) Command A did not receive budget. Command B completed  (which was
> > already
>
> Command A doesn't get budget, and A is still in sw/scheduler queue
because
> we try to acquire budget before dequeuing request from sw/scheduler
queue,
> see __blk_mq_do_dispatch_sched() and blk_mq_do_dispatch_ctx().
>
> Not consider direct issue, because the hw queue will be run explicitly
when
> not getting budget, see __blk_mq_try_issue_directly.
>
> Not consider command A being added to hctx->dispatch too, because blk-mq
> will re-run the queue, see blk_mq_dispatch_rq_list().

Ming -

After going through your comment (I noted your comment and thanks for
correcting my understanding.) and block layer code, I realize that it is a
different race condition. My previous explanation was not accurate.
I debug further and figure out what is actually happening - Consider below
scenario/sequence -

Thread -1 - Detected budget contention. Set restarts = 1.
Thread -2 - old restarts = 1. start hw queue.
Thread -3 - old restarts = 1. start hw queue.
Thread -2 - move restarts = 0.
In my testing, I noticed that both thread-2 and thread-3 started h/w queue
but there was no work for them to do. It is possible because some other
context of h/w queue run might have done that job.
It means, IO of thread-1 is already posted.
Thread -4 - Detected budget contention. Set restart = 1 (because thread-2
has move restarts=0).
Thread -3 - move restarts = 0 (because this thread see old value = 1 but
that is actually updated one more time by thread-4 and theread-4 actually
wanted to run h/w queues). IO of Thread-4 will not be scheduled.

We have to make sure that completion IO path do atomic_cmpxchng of
restarts flag before running the h/w queue.  Below code change - (main fix
is sequence of atomic_cmpxchg and blk_mq_run_hw_queues) fix the issue.

--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -594,8 +594,27 @@ static bool scsi_end_request(struct request *req,
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
+                       /*
+                        * ->restarts has to be kept as non-zero if there
is
+                        *  new budget contention comes.
+                        */
+                       atomic_cmpxchg(&sdev->restarts, old, 0);
+
+                       /* run the queue after restarts flag is updated
+                        * to avoid race condition with .get_budget
+                        */
+                       blk_mq_run_hw_queues(sdev->request_queue, true);
+               }
+       }

        percpu_ref_put(&q->q_usage_counter);
        return false;

Kashyap
