Return-Path: <SRS0=Uzsj=6E=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86015C3A5A0
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Apr 2020 17:47:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6713E22261
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Apr 2020 17:47:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="N52v1uVI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726829AbgDTRrk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 20 Apr 2020 13:47:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726021AbgDTRrk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 20 Apr 2020 13:47:40 -0400
Received: from mail-qt1-x841.google.com (mail-qt1-x841.google.com [IPv6:2607:f8b0:4864:20::841])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2CE8C061A0C
        for <linux-scsi@vger.kernel.org>; Mon, 20 Apr 2020 10:47:39 -0700 (PDT)
Received: by mail-qt1-x841.google.com with SMTP id q17so9280499qtp.4
        for <linux-scsi@vger.kernel.org>; Mon, 20 Apr 2020 10:47:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:references:in-reply-to:mime-version:thread-index:date
         :message-id:subject:to:cc;
        bh=AhhDhRwdqJtrG1H5rRz06k35stVl8xEU8jEUKXBgAss=;
        b=N52v1uVI31oqQHseA/U3TZaVNCqFaedQ12DxMzAkSohHbkh2hH4hK2vnW9K/nIizfv
         Ou3iEMq1cjzlu9zUQr9zVrfTP37JGKcab6s9PYhqr4kvx2CgabjhMUZdfVRLPR8Jp64I
         0HAmeRvUGRVsxnP2op5ULVJcaw6aLFrrPHIZ0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:references:in-reply-to:mime-version
         :thread-index:date:message-id:subject:to:cc;
        bh=AhhDhRwdqJtrG1H5rRz06k35stVl8xEU8jEUKXBgAss=;
        b=Z37vb5Qy3G9+ACmWjgVYRKxJoU7N2vTEUtbT/SJ3h/S1+Y/k19fOL1yvKfUiH3Sc5g
         Wkt4ClbloYLGCVLSGccnCzRdYamOUaoagYnH3pe9kF8WpdLTpNFeyRVBmnZ4LgF4R5jm
         igupuHNnWtek9t7sL2WIYV1cz9V2VyN5ZUPxjkeZPUDBRQMneHy0YN8KjcfXIcfwvRO2
         n8Soed4asizMApoLMpnrmV5UMWqAQWzlKJ/gA7lXJeIaR+UGvJ+1pPpayWAdjl0eN/A+
         DJSzx61Ep2Ppl8F4t5Pf5c8d5O1GhQKnG66EvJv42KfBoAmnNjl9wV10js7XMiJYp9UO
         QvSw==
X-Gm-Message-State: AGi0PuZ4qDrzYJGNpL5yddaJiU+tIeKXCE+0ZuEXGFlt5qQj3tmWhmps
        Lx/rkmb+2sAaDLLt3EmB7MxHA0gXDGChbH9K5XHtkQ==
X-Google-Smtp-Source: APiQypLGL524AgNe9FOwkYdrGIFa/8cEphqEBE/xY2lBk9LuIZdBwpP2/Za5OIBjjNcQTa3SKN20i0Suuo9Bmu36Xmw=
X-Received: by 2002:ac8:6f66:: with SMTP id u6mr7108620qtv.201.1587404858839;
 Mon, 20 Apr 2020 10:47:38 -0700 (PDT)
From:   Kashyap Desai <kashyap.desai@broadcom.com>
References: <1583409280-158604-1-git-send-email-john.garry@huawei.com>
 <1583409280-158604-9-git-send-email-john.garry@huawei.com>
 <a1f0399e2e85b2244a9ae40e4a2f1089@mail.gmail.com> <f839f040-8bf4-cf83-7670-dfc208b77326@huawei.com>
 <7cac3eb9fd79b5b988e25da542305b35@mail.gmail.com> <40faaef8-8bfc-639f-747f-cacd4e61464f@huawei.com>
In-Reply-To: <40faaef8-8bfc-639f-747f-cacd4e61464f@huawei.com>
MIME-Version: 1.0
X-Mailer: Microsoft Outlook 15.0
Thread-Index: AQLPD/Iw6Rn2DAIn/TfwmBaZDWGoTwIxkurkAqxUgoEByxhGKAL7c9G/AhAFW6WmMrHooA==
Date:   Mon, 20 Apr 2020 23:17:35 +0530
Message-ID: <7b8c79b0453722023c6c7d53cd24441d@mail.gmail.com>
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

> On 08/04/2020 10:59, Kashyap Desai wrote:
>
> Hi Kashyap,
>
> >
> >>> We have done some level of testing to know performance impact on SAS
> >>> SSDs and HDD setup. Here is my finding - My testing used - Two
> >>> socket Intel Skylake/Lewisburg/Purley Output of numactl --hardware
> >>>
> >>> available: 2 nodes (0-1)
> >>> node 0 cpus: 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 36 37 38 39
> >>> 40 41
> >>> 42 43 44 45 46 47 48 49 50 51 52 53
> >>> node 0 size: 31820 MB
> >>> node 0 free: 21958 MB
> >>> node 1 cpus: 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35
> >>> 54
> >>> 55
> >>> 56 57 58 59 60 61 62 63 64 65 66 67 68 69 70 71 node 1 size: 32247
> >>> MB node 1 free: 21068 MB node distances:
> >>> node   0   1
> >>>     0:  10  21
> >>>     1:  21  10
>
> Do you have other info, like IRQ-CPU affinity dump and controller PCI
> vendor+device ID? Also /proc/interrupts info would be good after a run,
> like supplied by Sumit here:
>
> https://lore.kernel.org/linux-
> scsi/CAL2rwxotoWakFS4DPe85hZ4VAgd_zw8pL+B5ckHR9NwEf+-
> L=g@mail.gmail.com/

Controller performance mode is = IOPs which will create 8 extra reply
queues.
In this case it is 72 online CPU + 8 = 80 reply queue (MSIx) driver will
create.

First 8 vectors are non-managed and they are mapped to local numa node -1.

Here is IRQ-CPU affinity -

irq 256, cpu list 18-35,54-71
irq 257, cpu list 18-35,54-71
irq 258, cpu list 18-35,54-71
irq 259, cpu list 18-35,54-71
irq 260, cpu list 18-35,54-71
irq 261, cpu list 18-35,54-71
irq 262, cpu list 18-35,54-71
irq 263, cpu list 18-35,54-71
irq 264, cpu list 18
irq 265, cpu list 19
irq 266, cpu list 20
irq 267, cpu list 21
irq 268, cpu list 22
irq 269, cpu list 23
irq 270, cpu list 24
irq 271, cpu list 25
irq 272, cpu list 26
irq 273, cpu list 27
irq 274, cpu list 28
irq 275, cpu list 29
irq 276, cpu list 30
irq 277, cpu list 31
irq 278, cpu list 32
irq 279, cpu list 33
irq 280, cpu list 34
irq 281, cpu list 35
irq 282, cpu list 54
irq 283, cpu list 55
irq 284, cpu list 56
irq 285, cpu list 57
irq 286, cpu list 58
irq 287, cpu list 59
irq 288, cpu list 60
irq 289, cpu list 61
irq 290, cpu list 62
irq 291, cpu list 63
irq 292, cpu list 64
irq 293, cpu list 65
irq 294, cpu list 66
irq 295, cpu list 67
irq 296, cpu list 68
irq 297, cpu list 69
irq 298, cpu list 70
irq 299, cpu list 71
irq 300, cpu list 0
irq 301, cpu list 1
irq 302, cpu list 2
irq 303, cpu list 3
irq 304, cpu list 4
irq 305, cpu list 5
irq 306, cpu list 6
irq 307, cpu list 7
irq 308, cpu list 8
irq 309, cpu list 9
irq 310, cpu list 10
irq 311, cpu list 11
irq 312, cpu list 12
irq 313, cpu list 13
irq 314, cpu list 14
irq 315, cpu list 15
irq 316, cpu list 16
irq 317, cpu list 17
irq 318, cpu list 36
irq 319, cpu list 37
irq 320, cpu list 38
irq 321, cpu list 39
irq 322, cpu list 40
irq 323, cpu list 41
irq 324, cpu list 42
irq 325, cpu list 43
irq 326, cpu list 44
irq 327, cpu list 45
irq 328, cpu list 46
irq 329, cpu list 47
irq 330, cpu list 48
irq 331, cpu list 49
irq 332, cpu list 50
irq 333, cpu list 51
irq 334, cpu list 52
irq 335, cpu list 53

>
> Are you enabling some special driver perf mode?
>
> >>>
> >>>
> >>> 64 HDD setup -
> >>>
> >>> With higher QD
> >> what's OD?

I mean higher Queue Depth (QD). Higher Queue Depth is required because
congestion will happen at Sdev->queue_depth and shost->can_queue level.
If outstanding is not hitting per sdev queue depth OR shost can queue depth,
we will not see performance issue.

> >>
> >>> and io schedulder = mq-deadline, shared host tag is not scaling well.
> >>>  >>> If
> I use ioscheduler = none, I can see consistent 2.0M IOPs.
> >>> This issue is seen only with RFC. Without RFC mq-deadline scales up to
> >>> 2.0M IOPS.
>
> In theory, from this driver perspective, we should not be making a
> difference. That's after your change to use sdev-> device busy count,
> rather than the hctx nr_active count. As I understand, that's the only
> difference you made.
>
> But I will try an IO scheduler on hisi sas for ssd to see if any
> difference.
>
> >> I didn't try any scheduler. I can have a look at that.
> >>
> >>> Perf Top result of RFC - (IOPS = 1.4M IOPS)
> >>>
> >>>      78.20%  [kernel]        [k] native_queued_spin_lock_slowpath
> >>>        1.46%  [kernel]        [k] sbitmap_any_bit_set
> >>>        1.14%  [kernel]        [k] blk_mq_run_hw_queue
> >>>        0.90%  [kernel]        [k] _mix_pool_bytes
> >>>        0.63%  [kernel]        [k] _raw_spin_lock
> >>>        0.57%  [kernel]        [k] blk_mq_run_hw_queues
> >>>        0.56%  [megaraid_sas]  [k] complete_cmd_fusion
> >>>        0.54%  [megaraid_sas]  [k] megasas_build_and_issue_cmd_fusion
> >>>        0.50%  [kernel]        [k] dd_has_work
> >>>        0.38%  [kernel]        [k] _raw_spin_lock_irqsave
> >>>        0.36%  [kernel]        [k] gup_pgd_range
> >>>        0.35%  [megaraid_sas]  [k] megasas_build_ldio_fusion
> >>>        0.31%  [kernel]        [k] io_submit_one
> >>>        0.29%  [kernel]        [k] hctx_lock
> >>>        0.26%  [kernel]        [k] try_to_grab_pending
> >>>        0.24%  [kernel]        [k] scsi_queue_rq
> >>>        0.22%  fio             [.] __fio_gettime
> >>>        0.22%  [kernel]        [k] insert_work
> >>>        0.20%  [kernel]        [k] native_irq_return_iret
> >>>
> >>> Perf top without RFC driver - (IOPS = 2.0 M IOPS)
> >>>
> >>>       58.40%  [kernel]          [k] native_queued_spin_lock_slowpath
> >>>        2.06%  [kernel]          [k] _mix_pool_bytes
> >>>        1.38%  [kernel]          [k] _raw_spin_lock_irqsave
> >>>        0.97%  [kernel]          [k] _raw_spin_lock
> >>>        0.91%  [kernel]          [k] scsi_queue_rq
> >>>        0.82%  [kernel]          [k] __sbq_wake_up
> >>>        0.77%  [kernel]          [k] _raw_spin_unlock_irqrestore
> >>>        0.74%  [kernel]          [k] scsi_mq_get_budget
> >>>        0.61%  [kernel]          [k] gup_pgd_range
> >>>        0.58%  [kernel]          [k] aio_complete_rw
> >>>        0.52%  [kernel]          [k] elv_rb_add
> >>>        0.50%  [kernel]          [k] llist_add_batch
> >>>        0.50%  [kernel]          [k] native_irq_return_iret
> >>>        0.48%  [kernel]          [k] blk_rq_map_sg
> >>>        0.48%  fio               [.] __fio_gettime
> >>>        0.47%  [kernel]          [k] blk_mq_get_tag
> >>>        0.44%  [kernel]          [k] blk_mq_dispatch_rq_list
> >>>        0.40%  fio               [.] io_u_queued_complete
> >>>        0.39%  fio               [.] get_io_u
> >>>
> >>>
> >>> If you want me to test any top up patch, please let me know.  BTW, we
> >>> also wants to provide module parameter for user to switch back to
> >>> older nr_hw_queue = 1 mode. I will work on that part.
> >> ok, but I would just like to reiterate the point that you will not see
> >> the
> >> full
> >> benefit of blk-mq draining hw queues for cpu hotplug since you hide hw
> >> queues from blk-mq.
> > Agree. We have done  minimal testing using this RFC. We want to ACK this
> RFC
> > as long as primary performance goal is achieved.
> >
> > We have done full testing on nr_hw_queue =1 (and that is what customer
> > is
> > using) so we at least want to give that interface available for customer
> > for
> > some time (assuming they may find some performance gap between two
> interface
> > which we may not have encountered during smoke testing.).
> > Over a period of time, if nr_hw_queue = N works for (Broadcom will
> > conduct
> > full performance once RFC is committed in upstream) all the IO profiles,
> > we
> > will share the information with customer about benefit of using
> nr_hw_queues
> > =  N.
>
> Hopefully you can use nr_hw_queues = N always.
>
> >
>
> Thanks,
> john
