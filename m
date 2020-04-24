Return-Path: <SRS0=qHBX=6I=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBE71C54FCB
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Apr 2020 16:31:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ADF9F2063A
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Apr 2020 16:31:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="bwqeMVBE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728113AbgDXQbh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 24 Apr 2020 12:31:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726753AbgDXQbg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 24 Apr 2020 12:31:36 -0400
Received: from mail-qk1-x741.google.com (mail-qk1-x741.google.com [IPv6:2607:f8b0:4864:20::741])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 636E2C09B046
        for <linux-scsi@vger.kernel.org>; Fri, 24 Apr 2020 09:31:36 -0700 (PDT)
Received: by mail-qk1-x741.google.com with SMTP id m67so10700860qke.12
        for <linux-scsi@vger.kernel.org>; Fri, 24 Apr 2020 09:31:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:references:in-reply-to:mime-version:thread-index:date
         :message-id:subject:to:cc;
        bh=FXI4xzkLf6YJJdougzsn8GY5ZHEevU+gU6ll/F2JM/w=;
        b=bwqeMVBEwj5LBX8vzg7oUHeS3/BNUAsFb4ZDtb5Xw9Zwn32KiwoMofPKjJWfLren0D
         NsEjJahsAuy6Sb+VT0MqfrC06pE5/odU3ejsGwLko+0LfY90FX+Kks8a0cxj7GeJZSxO
         X6t4pasHMD+4WPKnFIjstHmKKIiRMj3HFv7ro=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:references:in-reply-to:mime-version
         :thread-index:date:message-id:subject:to:cc;
        bh=FXI4xzkLf6YJJdougzsn8GY5ZHEevU+gU6ll/F2JM/w=;
        b=f5F+54VQJaCqPIb0TrmUZaFP+YBiaQO4uXHCoznJD4H7LiVN50G9aVpBfnv0jVXVTm
         w0UqrErs2UYVflSLDJ1vaHJpDzv+EYs6X25+YjRmg5WHkMysS2tGuGSMf6xDoxizTx5R
         MuQydlGuPFDQ4TyvmJoeum0BEteHk1fsvQkoRzdr1PH6L12xuwLRd4F4gF09V6OlpKqr
         +nG4v/ucffTsAb3HcFPgKHk3BeXvxmT/hbn7iCAyLQ4WSLUjMJH2mMsl0YBSJH6ie3jK
         ZOM8BIZ+0YeeoZWd/XDxEsAXjGCxa/lbG67aPXBohmlK5+TANMQzuAgPWhWOWgYxVsOW
         wVKA==
X-Gm-Message-State: AGi0PuZ874P+X3qJ0kaaw88TB7cw9Xp0lZpXtoZW0riy8wuQFx0kiA3e
        OUA2iCzVHm1S7GUpSPbux3wa5aHyP7i5VF8KMiF+3w==
X-Google-Smtp-Source: APiQypIQnBDRU/vQ/IfDKUJT6rWNMW9FX50Os/dmU0O92/UD2nKYrkXUrKxz5z9Zm/+ollzj1aBGljTEjR+Z0dE/en8=
X-Received: by 2002:a37:66d8:: with SMTP id a207mr9447197qkc.127.1587745895225;
 Fri, 24 Apr 2020 09:31:35 -0700 (PDT)
From:   Kashyap Desai <kashyap.desai@broadcom.com>
References: <1583409280-158604-1-git-send-email-john.garry@huawei.com>
 <1583409280-158604-9-git-send-email-john.garry@huawei.com>
 <a1f0399e2e85b2244a9ae40e4a2f1089@mail.gmail.com> <f839f040-8bf4-cf83-7670-dfc208b77326@huawei.com>
 <7cac3eb9fd79b5b988e25da542305b35@mail.gmail.com> <40faaef8-8bfc-639f-747f-cacd4e61464f@huawei.com>
 <7b8c79b0453722023c6c7d53cd24441d@mail.gmail.com> <b759a8ed-09ba-bfe8-8916-c05ab9671cbf@huawei.com>
 <260c5decdb38db9f74994988ce7fcaf1@mail.gmail.com> <380d3bf2-67ee-a09a-3098-51b24b98f912@huawei.com>
 <e0c5a076-9fe5-4401-fd41-97f457888ad3@huawei.com>
In-Reply-To: <e0c5a076-9fe5-4401-fd41-97f457888ad3@huawei.com>
MIME-Version: 1.0
X-Mailer: Microsoft Outlook 15.0
Thread-Index: AQLPD/Iw6Rn2DAIn/TfwmBaZDWGoTwIxkurkAqxUgoEByxhGKAL7c9G/AhAFW6UBYJrDDwOh6RKhA6E3S3MDBK8nrwGGgqJUpc6S3wA=
Date:   Fri, 24 Apr 2020 22:01:32 +0530
Message-ID: <d2ae343770a83466b870a33ffae5fa23@mail.gmail.com>
Subject: RE: [PATCH RFC v6 08/10] megaraid_sas: switch fusion adapters to MQ
To:     John Garry <john.garry@huawei.com>, axboe@kernel.dk,
        jejb@linux.ibm.com, martin.petersen@oracle.com,
        ming.lei@redhat.com, bvanassche@acm.org, hare@suse.de,
        don.brace@microsemi.com, Sumit Saxena <sumit.saxena@broadcom.com>,
        hch@infradead.org,
        Shivasharan Srikanteshwara 
        <shivasharan.srikanteshwara@broadcom.com>
Cc:     chenxiang66@hisilicon.com, linux-block@vger.kernel.org,
        linux-scsi@vger.kernel.org, esc.storagedev@microsemi.com,
        Hannes Reinecke <hare@suse.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> >
> >>> So I tested this on hisi_sas with x12 SAS SSDs, and performance with
> >>> "mq-
> >>> deadline" is comparable with "none" @ ~ 2M IOPs. But after a while
> >>> performance drops alot, to maybe 700K IOPS. Do you have a similar
> >>> experience?
> >>
> >> I am using mq-deadline only for HDD. I have not tried on SSD since it
> >> is not useful scheduler for SSDs.
> >>
> >
> > I ask as I only have SAS SSDs to test.
> >
> >> I noticed that when I used mq-deadline, performance drop starts if I
> >> have
> >> more number of drives.
> >> I am running <fio> script which has 64 Drives, 64 thread and all
> >> treads are
> >> bound to local numa node which has 36 logical cores.
> >> I noticed that lock contention is in " dd_dispatch_request". I am not
> >> sure
> >> why there is a no penalty of same lock in nr_hw_queue  = 1 mode.
> >
> > So this could be just pre-existing issue of exposing multiple queues for
> > SCSI HBAs combined with mq-deadline iosched. I mean, that's really the
> > only significant change in this series, apart from the shared sbitmap,
> > and, at this point, I don't think that is the issue.
>
> As an experiment, I modified hisi_sas mainline driver to expose hw
> queues and manage tags itself, and I see the same issue I mentioned:
>
> Jobs: 12 (f=12): [R(12)] [14.8% done] [7592MB/0KB/0KB /s] [1943K/0/0
> iops] [eta
> Jobs: 12 (f=12): [R(12)] [16.4% done] [7949MB/0KB/0KB /s] [2035K/0/0
> iops] [eta
> Jobs: 12 (f=12): [R(12)] [18.0% done] [7940MB/0KB/0KB /s] [2033K/0/0
> iops] [eta
> Jobs: 12 (f=12): [R(12)] [19.7% done] [7984MB/0KB/0KB /s] [2044K/0/0
> iops] [eta
> Jobs: 12 (f=12): [R(12)] [21.3% done] [7984MB/0KB/0KB /s] [2044K/0/0
> iops] [eta
> Jobs: 12 (f=12): [R(12)] [23.0% done] [2964MB/0KB/0KB /s] [759K/0/0
> iops] [eta 0
> Jobs: 12 (f=12): [R(12)] [24.6% done] [2417MB/0KB/0KB /s] [619K/0/0
> iops] [eta 0
> Jobs: 12 (f=12): [R(12)] [26.2% done] [2909MB/0KB/0KB /s] [745K/0/0
> iops] [eta 0
> Jobs: 12 (f=12): [R(12)] [27.9% done] [2366MB/0KB/0KB /s] [606K/0/0
> iops] [eta 0
>
> The odd time I see "sched: RT throttling activated" around the time the
> throughput falls. I think issue is the per-queue threaded irq threaded
> handlers consuming too many cycles. With "none" io scheduler, IOPS is
> flat at around 2M.
>
> >
> >>
> >> static struct request *dd_dispatch_request(struct blk_mq_hw_ctx *hctx)
> >> {
> >>          struct deadline_data *dd =
> >> hctx->queue->elevator->elevator_data;
> >>          struct request *rq;
> >>
> >>          spin_lock(&dd->lock);
> >
> > So if multiple hctx's are accessing this lock, then much contention
> > possible.
> >
> >>          rq = __dd_dispatch_request(dd);
> >>          spin_unlock(&dd->lock);
> >>
> >>          return rq;
> >> }
> >>
> >> Here is perf report -
> >>
> >> -    1.04%     0.99%  kworker/18:1H+k  [kernel.vmlinux]  [k]
> >> native_queued_spin_lock_slowpath
> >>       0.99% ret_from_fork
> >>      -   kthread
> >>        - worker_thread
> >>           - 0.98% process_one_work
> >>              - 0.98% __blk_mq_run_hw_queue
> >>                 - blk_mq_sched_dispatch_requests
> >>                    - 0.98% blk_mq_do_dispatch_sched
> >>                       - 0.97% dd_dispatch_request
> >>                          + 0.97% queued_spin_lock_slowpath
> >> +    1.04%     0.00%  kworker/18:1H+k  [kernel.vmlinux]  [k]
> >> queued_spin_lock_slowpath
> >> +    1.03%     0.95%  kworker/19:1H-k  [kernel.vmlinux]  [k]
> >> native_queued_spin_lock_slowpath
> >> +    1.03%     0.00%  kworker/19:1H-k  [kernel.vmlinux]  [k]
> >> queued_spin_lock_slowpath
> >> +    1.02%     0.97%  kworker/20:1H+k  [kernel.vmlinux]  [k]
> >> native_queued_spin_lock_slowpath
> >> +    1.02%     0.00%  kworker/20:1H+k  [kernel.vmlinux]  [k]
> >> queued_spin_lock_slowpath
> >> +    1.01%     0.96%  kworker/21:1H+k  [kernel.vmlinux]  [k]
> >> native_queued_spin_lock_slowpath
> >>
> >
> > I'll try to capture a perf report and compare to mine.
>
> Mine is spending a huge amount of time (circa 33% on a cpu servicing
> completion irqs) in mod_delayed_work_on():
>
> --79.89%--sas_scsi_task_done |
>     |--76.72%--scsi_mq_done
>     |    |
>     |     --76.53%--blk_mq_complete_request
>     |    |
>     |    |--74.81%--scsi_softirq_done
>     |    |    |
>     |    |     --73.91%--scsi_finish_command
>     |    |    |
>     |    |    |--72.11%--scsi_io_completion
>     |    |    |    |
>     |    |    |     --71.89%--scsi_end_request
>     |    |    |    |
>     |    |    |    |--40.82%--blk_mq_run_hw_queues
>     |    |    |    |    |
>     |    |    |    |    |--35.86%--blk_mq_run_hw_queue
>     |    |    |    |    |    |
>     |    |    |    |    |     --33.59%--__blk_mq_delay_run_hw_queue
>     |    |    |    |    |    |
>     |    |    |    |    |     --33.38%--kblockd_mod_delayed_work_on
>     |    |    |    |    |          |
>     |    |    |    |    |                --33.31%--mod_delayed_work_on
>
> hmmmm...

I did some more experiments. It looks like issue is with both <none> and
<mq-deadline> scheduler.  Let me simplify what happens with ioscheduler =
<none>.

Old Driver which has nr_hw_queue = 1 and I issue IOs from <fio>  queue depth
= 128. We get 3.1M IOPS in this config. This eventually exhaust host
can_queue.
Note - Very low contention in sbitmap_get()

-   23.58%     0.25%  fio              [kernel.vmlinux]            [k]
blk_mq_make_request
   - 23.33% blk_mq_make_request
      - 21.68% blk_mq_get_request
         - 20.19% blk_mq_get_tag
            + 10.08% prepare_to_wait_exclusive
            + 4.51% io_schedule
            - 3.59% __sbitmap_queue_get
               - 2.82% sbitmap_get
                    0.86% __sbitmap_get_word
                    0.75% _raw_spin_lock_irqsave
                    0.55% _raw_spin_unlock_irqrestore

Driver with RFC which has nr_hw_queue = N and I issue IOs from <fio>  queue
depth = 128. We get 2.3 M IOPS in this config. This eventually exhaust host
can_queue.
Note - Very high contention in sbitmap_get()

-   42.39%     0.12%  fio              [kernel.vmlinux]            [k]
generic_make_request
   - 42.27% generic_make_request
      - 41.00% blk_mq_make_request
         - 38.28% blk_mq_get_request
            - 33.76% blk_mq_get_tag
               - 30.25% __sbitmap_queue_get
                  - 29.90% sbitmap_get
                     + 9.06% _raw_spin_lock_irqsave
                     + 7.94% _raw_spin_unlock_irqrestore
                     + 3.86% __sbitmap_get_word
                     + 1.78% call_function_single_interrupt
                     + 0.67% ret_from_intr
               + 1.69% io_schedule
                 0.59% prepare_to_wait_exclusive
                 0.55% __blk_mq_get_tag

In this particular case, I observed alloc_hint = zeros which means,
sbitmap_get is not able to find free tags from hint. That may lead to
contention.
This condition is not happening with nr_hw_queue=1 (without RFC) driver.

alloc_hint=
{663, 2425, 3060, 54, 3149, 4319, 4175, 4867, 543, 2481, 0, 4779, 377,
***0***, 2010, 0, 909, 3350, 1546, 2179, 2875, 659, 3902, 2224, 3212, 836,
1892, 1669, 2420,
3415, 1904, 512, 3027, 4810, 2845, 4690, 712, 3105, 0, 0, 0, 3268, 4915,
3897, 1349, 547, 4, 733, 1765, 2068, 979, 51, 880, 0, 370, 3520, 2877, 4097,
418, 4501, 3717,
2893, 604, 508, 759, 3329, 4038, 4829, 715, 842, 1443, 556}

Driver with RFC which has nr_hw_queue = N and I issue IOs from <fio>  queue
depth = 32. We get 3.1M IOPS in this config. This workload does *not*
exhaust host can_queue.

-    5.07%     0.14%  fio              [kernel.vmlinux]  [k]
generic_make_request
   - 4.93% generic_make_request
      - 3.61% blk_mq_make_request
         - 2.04% blk_mq_get_request
            - 1.08% blk_mq_get_tag
               - 0.70% __sbitmap_queue_get
                    0.67% sbitmap_get

In summary, RFC has some performance bottleneck in sbitmap_get () if
outstanding per shost is about to exhaust.  Without this RFC also driver
works in nr_hw_queue = 1, but that case is managed very well.
I am not sure why it happens only with shared host tag ? Theoretically all
the hctx is sharing the same bitmaptag which is same as nr_hw_queue=1, so
why contention is only visible in shared host tag case.

If you want to reproduce this issue, may be you have to reduce the can_queue
in hisi_sas driver.

Kashyap

>
> Thanks,
> John
