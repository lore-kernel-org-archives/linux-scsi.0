Return-Path: <SRS0=lUfO=A6=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E37B8C433DF
	for <linux-scsi@archiver.kernel.org>; Sun, 19 Jul 2020 19:07:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C8A3E21744
	for <linux-scsi@archiver.kernel.org>; Sun, 19 Jul 2020 19:07:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="iRGETB51"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726503AbgGSTHh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 19 Jul 2020 15:07:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726473AbgGSTHh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 19 Jul 2020 15:07:37 -0400
Received: from mail-qt1-x82d.google.com (mail-qt1-x82d.google.com [IPv6:2607:f8b0:4864:20::82d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 565FFC0619D4
        for <linux-scsi@vger.kernel.org>; Sun, 19 Jul 2020 12:07:37 -0700 (PDT)
Received: by mail-qt1-x82d.google.com with SMTP id a32so11457812qtb.5
        for <linux-scsi@vger.kernel.org>; Sun, 19 Jul 2020 12:07:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:references:in-reply-to:mime-version:thread-index:date
         :message-id:subject:to:cc;
        bh=y7UVmsUUWW+syouiI5q9i86+HUw5PbC+q5saIQcigd0=;
        b=iRGETB51iiFqAL8vEhkG7ijBOJac/45G6/cxCS3s2r1z3OuqMhtgJ8FyEyyg3gVC2i
         MHsR+u7ZaLWpc0RxBZHIX9SbCD41rK84mAAkuqzLe0NG4cDtXekagqPC7fGdCC6Puyi0
         XNvVdx67kV3x2wderf2hffRdR8jDdgZtNQ+3g=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:references:in-reply-to:mime-version
         :thread-index:date:message-id:subject:to:cc;
        bh=y7UVmsUUWW+syouiI5q9i86+HUw5PbC+q5saIQcigd0=;
        b=Yfw484BCH+BREL9nbDnaBBvhJ2Ex0T1+qV0yS200wZronh8CT9KThRLHcGv5fwqZNA
         SuLvRBUJl47ZNNcsjCOvoGrV9q9fSmQIxkydedIhZx2Z1q8C1j4R3S6EI6wH3HRVeZ+a
         8SLN5+4ZmZo3+P2fySNHQakvobPym1NWxVbL5UmLhnGtcLli+ptXdy9CeNUGzFeshg6P
         XYL07d8XhpSYOlXB1Kqsn8E4vZyF1Xcs8b/BFYlF4Omh2cLWiamTaor5ZrDWUkC8nslg
         hZMoSUxApDOaBvENwBG85IOX1AIBlxHSNcrA9haoC6IC7Ekhzo5woBjd589zAti8VqR1
         TwLw==
X-Gm-Message-State: AOAM5327ji6PgMofVQj/U71JIkY9yL0EV2/+yPiecxgPMJRNjguTq02k
        5HJX/O8+ruaemDdr/8pPDIafKDJM1om6B+ca4epG9A==
X-Google-Smtp-Source: ABdhPJxKi3TygIZ5EUVL8Pwm+D+6VmBDEb60NK8bJIxj0PInxDwlM8iUvWcR6jGgzt36XLpHTcaTBw5cgNjjh1shSqQ=
X-Received: by 2002:ac8:4f50:: with SMTP id i16mr19112429qtw.216.1595185656196;
 Sun, 19 Jul 2020 12:07:36 -0700 (PDT)
From:   Kashyap Desai <kashyap.desai@broadcom.com>
References: <1591810159-240929-1-git-send-email-john.garry@huawei.com>
 <1591810159-240929-11-git-send-email-john.garry@huawei.com>
 <d55972999b9370f947c20537e41b49bf@mail.gmail.com> <e61593f8-5ee7-5763-9d02-d0ea13aeb49f@huawei.com>
 <92ba1829c9e822e4239a7cdfd94acbce@mail.gmail.com> <10d36c09-9d5b-92e9-23ac-ea1a2628e7d9@huawei.com>
 <0563e53f843c97de1a5a035fae892bf8@mail.gmail.com> <61299951-97dc-b2be-c66c-024dfbd3a1cb@huawei.com>
 <b49c33ebda36b8f116a51bc5c430eb9d@mail.gmail.com> <13d6b63e-3aa8-68fa-29ab-a4c202024280@huawei.com>
 <34a832717fef4702b143ea21aa12b79e@mail.gmail.com> <1dcf2bb9-142c-7bb8-9207-5a1b792eb3f9@huawei.com>
In-Reply-To: <1dcf2bb9-142c-7bb8-9207-5a1b792eb3f9@huawei.com>
MIME-Version: 1.0
X-Mailer: Microsoft Outlook 15.0
Thread-Index: AQBVjmvxAE7FMYb7GtMRWGcwtMcECgFIs823Ad7lfqMBmFaE1AGZowweAlKrFcUB/hGY5AG4aoXNAvsHUMYCeW9VQwH6WrIOAzKzW+yrWLxrUA==
Date:   Mon, 20 Jul 2020 00:37:33 +0530
Message-ID: <2314e216d1d546e2072d09bd111b4b58@mail.gmail.com>
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

> > I also noticed nr_hw_queues are now exposed in sysfs -
> >
> > /sys/devices/pci0000:85/0000:85:00.0/0000:86:00.0/0000:87:04.0/0000:8b
> >
> :00.0/0000:8c:00.0/0000:8d:00.0/host14/scsi_host/host14/nr_hw_queues:1
> > 28
> > .
>
> That's on my v8 wip branch, so I guess you're picking it up from there.

John - I did more testing on v8 wip branch.  CPU hotplug is working as
expected, but I still see some performance issue on Logical Volumes.

I created 8 Drives Raid-0 VD on MR controller and below is performance
impact of this RFC. Looks like contention is on single <sdev>.

I used command - "numactl -N 1  fio
1vd.fio --iodepth=128 --bs=4k --rw=randread
--cpus_allowed_policy=split --ioscheduler=none
 --group_reporting --runtime=200 --numjobs=1"
IOPS without RFC = 300K IOPS with RFC = 230K.

Perf top (shared host tag. IOPS = 230K)

13.98%  [kernel]        [k] sbitmap_any_bit_set
     6.43%  [kernel]        [k] blk_mq_run_hw_queue
     6.00%  [kernel]        [k] __audit_syscall_exit
     3.47%  [kernel]        [k] read_tsc
     3.19%  [megaraid_sas]  [k] complete_cmd_fusion
     3.19%  [kernel]        [k] irq_entries_start
     2.75%  [kernel]        [k] blk_mq_run_hw_queues
     2.45%  fio             [.] fio_gettime
     1.76%  [kernel]        [k] entry_SYSCALL_64
     1.66%  [kernel]        [k] add_interrupt_randomness
     1.48%  [megaraid_sas]  [k] megasas_build_and_issue_cmd_fusion
     1.42%  [kernel]        [k] copy_user_generic_string
     1.36%  [kernel]        [k] scsi_queue_rq
     1.03%  [kernel]        [k] kmem_cache_alloc
     1.03%  [kernel]        [k] internal_get_user_pages_fast
     1.01%  [kernel]        [k] swapgs_restore_regs_and_return_to_usermode
     0.96%  [kernel]        [k] kmem_cache_free
     0.88%  [kernel]        [k] blkdev_direct_IO
     0.84%  fio             [.] td_io_queue
     0.83%  [kernel]        [k] __get_user_4

Perf top (shared host tag. IOPS = 300K)

    6.36%  [kernel]        [k] unroll_tree_refs
     5.77%  [kernel]        [k] __do_softirq
     4.56%  [kernel]        [k] irq_entries_start
     4.38%  [kernel]        [k] read_tsc
     3.95%  [megaraid_sas]  [k] complete_cmd_fusion
     3.21%  fio             [.] fio_gettime
     2.98%  [kernel]        [k] add_interrupt_randomness
     1.79%  [kernel]        [k] entry_SYSCALL_64
     1.61%  [kernel]        [k] copy_user_generic_string
     1.61%  [megaraid_sas]  [k] megasas_build_and_issue_cmd_fusion
     1.34%  [kernel]        [k] scsi_queue_rq
     1.11%  [kernel]        [k] kmem_cache_free
     1.05%  [kernel]        [k] blkdev_direct_IO
     1.05%  [kernel]        [k] internal_get_user_pages_fast
     1.00%  [kernel]        [k] __memset
     1.00%  fio             [.] td_io_queue
     0.98%  [kernel]        [k] kmem_cache_alloc
     0.94%  [kernel]        [k] __get_user_4
     0.93%  [kernel]        [k] lookup_ioctx
     0.88%  [kernel]        [k] sbitmap_any_bit_set

Kashyap

>
> Thanks,
> John
