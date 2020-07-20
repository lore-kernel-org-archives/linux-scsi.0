Return-Path: <SRS0=rv89=A7=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71FAEC433E0
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Jul 2020 07:24:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4B8A622B4E
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Jul 2020 07:24:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="c4C6aSft"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726254AbgGTHX7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 20 Jul 2020 03:23:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726428AbgGTHX7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Jul 2020 03:23:59 -0400
Received: from mail-qk1-x742.google.com (mail-qk1-x742.google.com [IPv6:2607:f8b0:4864:20::742])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E42AFC0619D2
        for <linux-scsi@vger.kernel.org>; Mon, 20 Jul 2020 00:23:58 -0700 (PDT)
Received: by mail-qk1-x742.google.com with SMTP id b4so14329076qkn.11
        for <linux-scsi@vger.kernel.org>; Mon, 20 Jul 2020 00:23:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:references:in-reply-to:mime-version:thread-index:date
         :message-id:subject:to:cc;
        bh=1ZdvEQtoQTsKklRiOdXXItC7m6E8GxiS/j8poJfLDnY=;
        b=c4C6aSfti0IzUz0ofptAt99y9cY5kbATBCWjB1eFadVNIVMywhilXgbAw10qSFeF1v
         rXSxtRLA8g+6n2WwPzEXmrsYvdTSKCi9jjCdWHFF8rt3uArMNsNoLRkrAMy4PxNc33Hc
         3f8lIHdmfOj2U9XqSp8bGzIxD1rRPlKmIEWQk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:references:in-reply-to:mime-version
         :thread-index:date:message-id:subject:to:cc;
        bh=1ZdvEQtoQTsKklRiOdXXItC7m6E8GxiS/j8poJfLDnY=;
        b=aQJR8pRj3T/FXsZ867Ad+Fg7rgBLUC6E0JLWnL3H2IkOaN6uNvq0A08WE2wF3La4zT
         3f/8xqGo/+dzitKPayhRlmzZHgPZ+BXUVvPpBDCmNRFx9VOWwEARAT/NATpyv6c0ly00
         2hFi7Qm+VxqLeLayLVABHB5o7+3r2hS8CP68q6m+EJc4jeN87P278G0QkD5aV2mjw6CN
         TQ57RkuMlcwm73jo6wiy5peReMYRcnDfz9zbOgptPJ8QrClHpu3HSgOyCXuWBIEf2RRw
         WnFKSdLopoiRz2lJWJDqRlOgTnS2xINjyw/TXC8++PZVC7rHVENbwJtdKcNttaneGozb
         XL0A==
X-Gm-Message-State: AOAM531NgSoQ3qv0MUKqwzpuk6V9+9/zX5GfgP6o/5MZjRv2TLUqQv+x
        dpcQZ+VXgNM3SbsT0t1IrwwzLm2+1YNEEyzweH/7tA==
X-Google-Smtp-Source: ABdhPJwehSaPP8tkR31fqFSCdrhnoxs1mA1h5JvYNpb/U7dDFm+ZCEY+fJEURvlvM2QIxVYuJ1pLpKZkS33zdz74Ros=
X-Received: by 2002:a37:d0e:: with SMTP id 14mr19177747qkn.27.1595229837769;
 Mon, 20 Jul 2020 00:23:57 -0700 (PDT)
From:   Kashyap Desai <kashyap.desai@broadcom.com>
References: <1591810159-240929-1-git-send-email-john.garry@huawei.com>
 <1591810159-240929-11-git-send-email-john.garry@huawei.com>
 <d55972999b9370f947c20537e41b49bf@mail.gmail.com> <e61593f8-5ee7-5763-9d02-d0ea13aeb49f@huawei.com>
 <92ba1829c9e822e4239a7cdfd94acbce@mail.gmail.com> <10d36c09-9d5b-92e9-23ac-ea1a2628e7d9@huawei.com>
 <0563e53f843c97de1a5a035fae892bf8@mail.gmail.com> <61299951-97dc-b2be-c66c-024dfbd3a1cb@huawei.com>
 <b49c33ebda36b8f116a51bc5c430eb9d@mail.gmail.com> <13d6b63e-3aa8-68fa-29ab-a4c202024280@huawei.com>
 <34a832717fef4702b143ea21aa12b79e@mail.gmail.com> <1dcf2bb9-142c-7bb8-9207-5a1b792eb3f9@huawei.com>
 2314e216d1d546e2072d09bd111b4b58@mail.gmail.com
In-Reply-To: 2314e216d1d546e2072d09bd111b4b58@mail.gmail.com
MIME-Version: 1.0
X-Mailer: Microsoft Outlook 15.0
Thread-Index: AQBVjmvxAE7FMYb7GtMRWGcwtMcECgFIs823Ad7lfqMBmFaE1AGZowweAlKrFcUB/hGY5AG4aoXNAvsHUMYCeW9VQwH6WrIOAzKzW+yrWLxrUIAAzqMQ
Date:   Mon, 20 Jul 2020 12:53:55 +0530
Message-ID: <e69dc243174664efd414a4cd0176e59d@mail.gmail.com>
Subject: RE: [PATCH RFC v7 10/12] megaraid_sas: switch fusion adapters to MQ
To:     John Garry <john.garry@huawei.com>, axboe@kernel.dk,
        jejb@linux.ibm.com, martin.petersen@oracle.com,
        don.brace@microsemi.com, Sumit Saxena <sumit.saxena@broadcom.com>,
        ming.lei@redhat.com, bvanassche@acm.org, hare@suse.com, hch@lst.de,
        Shivasharan Srikanteshwara 
        <shivasharan.srikanteshwara@broadcom.com>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        esc.storagedev@microsemi.com, chenxiang66@hisilicon.com,
        "PDL,MEGARAIDLINUX" <megaraidlinux.pdl@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> > > I also noticed nr_hw_queues are now exposed in sysfs -
> > >
> > >
> /sys/devices/pci0000:85/0000:85:00.0/0000:86:00.0/0000:87:04.0/0000:8b
> > >
> >
> :00.0/0000:8c:00.0/0000:8d:00.0/host14/scsi_host/host14/nr_hw_queues:1
> > > 28
> > > .
> >
> > That's on my v8 wip branch, so I guess you're picking it up from there.
>
> John - I did more testing on v8 wip branch.  CPU hotplug is working as
> expected, but I still see some performance issue on Logical Volumes.
>
> I created 8 Drives Raid-0 VD on MR controller and below is performance
> impact of this RFC. Looks like contention is on single <sdev>.
>
> I used command - "numactl -N 1  fio 1vd.fio --iodepth=128 --bs=4k --
> rw=randread --cpus_allowed_policy=split --ioscheduler=none --
> group_reporting --runtime=200 --numjobs=1"
> IOPS without RFC = 300K IOPS with RFC = 230K.
>
> Perf top (shared host tag. IOPS = 230K)
>
> 13.98%  [kernel]        [k] sbitmap_any_bit_set
>      6.43%  [kernel]        [k] blk_mq_run_hw_queue

blk_mq_run_hw_queue function take more CPU which is called from "
scsi_end_request"
It looks like " blk_mq_hctx_has_pending" handles only elevator (scheduler)
case. If  queue has ioscheduler=none, we can skip. I case of scheduler=none,
IO will be pushed to hardware queue and it by pass software queue.
Based on above understanding, I added below patch and I can see performance
scale back to expectation.

Ming mentioned that - we cannot remove blk_mq_run_hw_queues() from IO
completion path otherwise we may see IO hang. So I have just modified
completion path assuming it is only required for IO scheduler case.
https://www.spinics.net/lists/linux-block/msg55049.html

Please review and let me know if this is good or we have to address with
proper fix.

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 1be7ac5a4040..b6a5b41b7fc2 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -1559,6 +1559,9 @@ void blk_mq_run_hw_queues(struct request_queue *q,
bool async)
        struct blk_mq_hw_ctx *hctx;
        int i;

+       if (!q->elevator)
+               return;
+
        queue_for_each_hw_ctx(q, hctx, i) {
                if (blk_mq_hctx_stopped(hctx))
                        continue;

Kashyap

>      6.00%  [kernel]        [k] __audit_syscall_exit
>      3.47%  [kernel]        [k] read_tsc
>      3.19%  [megaraid_sas]  [k] complete_cmd_fusion
>      3.19%  [kernel]        [k] irq_entries_start
>      2.75%  [kernel]        [k] blk_mq_run_hw_queues
>      2.45%  fio             [.] fio_gettime
>      1.76%  [kernel]        [k] entry_SYSCALL_64
>      1.66%  [kernel]        [k] add_interrupt_randomness
>      1.48%  [megaraid_sas]  [k] megasas_build_and_issue_cmd_fusion
>      1.42%  [kernel]        [k] copy_user_generic_string
>      1.36%  [kernel]        [k] scsi_queue_rq
>      1.03%  [kernel]        [k] kmem_cache_alloc
>      1.03%  [kernel]        [k] internal_get_user_pages_fast
>      1.01%  [kernel]        [k] swapgs_restore_regs_and_return_to_usermode
>      0.96%  [kernel]        [k] kmem_cache_free
>      0.88%  [kernel]        [k] blkdev_direct_IO
>      0.84%  fio             [.] td_io_queue
>      0.83%  [kernel]        [k] __get_user_4
>
> Perf top (shared host tag. IOPS = 300K)
>
>     6.36%  [kernel]        [k] unroll_tree_refs
>      5.77%  [kernel]        [k] __do_softirq
>      4.56%  [kernel]        [k] irq_entries_start
>      4.38%  [kernel]        [k] read_tsc
>      3.95%  [megaraid_sas]  [k] complete_cmd_fusion
>      3.21%  fio             [.] fio_gettime
>      2.98%  [kernel]        [k] add_interrupt_randomness
>      1.79%  [kernel]        [k] entry_SYSCALL_64
>      1.61%  [kernel]        [k] copy_user_generic_string
>      1.61%  [megaraid_sas]  [k] megasas_build_and_issue_cmd_fusion
>      1.34%  [kernel]        [k] scsi_queue_rq
>      1.11%  [kernel]        [k] kmem_cache_free
>      1.05%  [kernel]        [k] blkdev_direct_IO
>      1.05%  [kernel]        [k] internal_get_user_pages_fast
>      1.00%  [kernel]        [k] __memset
>      1.00%  fio             [.] td_io_queue
>      0.98%  [kernel]        [k] kmem_cache_alloc
>      0.94%  [kernel]        [k] __get_user_4
>      0.93%  [kernel]        [k] lookup_ioctx
>      0.88%  [kernel]        [k] sbitmap_any_bit_set
>
> Kashyap
>
> >
> > Thanks,
> > John
