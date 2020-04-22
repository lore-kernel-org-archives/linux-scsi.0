Return-Path: <SRS0=1vX0=6G=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4579C55185
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Apr 2020 18:59:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8587121582
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Apr 2020 18:59:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="g4L0VzqW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726201AbgDVS7h (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Apr 2020 14:59:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726071AbgDVS7h (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Apr 2020 14:59:37 -0400
Received: from mail-qt1-x82b.google.com (mail-qt1-x82b.google.com [IPv6:2607:f8b0:4864:20::82b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1325C03C1AA
        for <linux-scsi@vger.kernel.org>; Wed, 22 Apr 2020 11:59:36 -0700 (PDT)
Received: by mail-qt1-x82b.google.com with SMTP id w29so2631058qtv.3
        for <linux-scsi@vger.kernel.org>; Wed, 22 Apr 2020 11:59:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:references:in-reply-to:mime-version:thread-index:date
         :message-id:subject:to:cc;
        bh=bkZx7Nn/MX4VkYJQu5Mqwo+vKhA4GY0PpBTuq+eQ0nM=;
        b=g4L0VzqWQ3NSDcX4XRf8yJloIa1g618mJr9LIbXI9uSOVwfmguc5B6wFli38Ky2t9/
         DY562mQB/De86OsKiAO2OomrUEPrjtnHk2aQ5RAuJECJPL/VZNb07YUj1cSr9yblAVuR
         UF2Dd3+z/K6Rla7P3iMaNe3LUbf5hdenTrB30=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:references:in-reply-to:mime-version
         :thread-index:date:message-id:subject:to:cc;
        bh=bkZx7Nn/MX4VkYJQu5Mqwo+vKhA4GY0PpBTuq+eQ0nM=;
        b=fh0unmkURGW2wvE7eSad3BaoDtEMdWDhwtetVFj31WuuT2kv194KMjdula84m9cjxc
         tAVxG1x+FZHVFhpCXDSjZ68yIFZwIQA7a7ryYJpFvaUoCtnjHogecy/nAtShEto1bB/9
         g3srXLWSpI5Fh2oz1F3dTX+GeR0hDBKTupiqiJBENKBX9G1Dj4rjbX1LT0kgR9nTkRdB
         Nfa7ulLR+JkU/4iDo/ubQKwDPMRohOF9zWeiNxGROaYmUSIHkH5MHD934FSOoJTFht2b
         e4VBPZSaZy/7XzbiTydSNUMZCoXZuQufxAKJcIhUXPpFOoEko/znvp4XOKPGcDpKeh/s
         IJ3w==
X-Gm-Message-State: AGi0PuYftDuBumk8tbuyY34EBzAitq/re7d2P3D03BUmjf4IpGKCq4/n
        kAvhxCo3EBCJsnxIwwPqRBh35d5Qs0PUWNQzEeaKhQ==
X-Google-Smtp-Source: APiQypJS+OWzM+NdWoOCbWiDOu2FTpT3eVNdfMPDNL6ZL0pLfBn/I0gfAn9RMK9Q/LZiW+y2kFg50JJ3iu5jM/aF3CA=
X-Received: by 2002:aed:34a5:: with SMTP id x34mr74313qtd.216.1587581975830;
 Wed, 22 Apr 2020 11:59:35 -0700 (PDT)
From:   Kashyap Desai <kashyap.desai@broadcom.com>
References: <1583409280-158604-1-git-send-email-john.garry@huawei.com>
 <1583409280-158604-9-git-send-email-john.garry@huawei.com>
 <a1f0399e2e85b2244a9ae40e4a2f1089@mail.gmail.com> <f839f040-8bf4-cf83-7670-dfc208b77326@huawei.com>
 <7cac3eb9fd79b5b988e25da542305b35@mail.gmail.com> <40faaef8-8bfc-639f-747f-cacd4e61464f@huawei.com>
 <7b8c79b0453722023c6c7d53cd24441d@mail.gmail.com> <b759a8ed-09ba-bfe8-8916-c05ab9671cbf@huawei.com>
In-Reply-To: <b759a8ed-09ba-bfe8-8916-c05ab9671cbf@huawei.com>
MIME-Version: 1.0
X-Mailer: Microsoft Outlook 15.0
Thread-Index: AQLPD/Iw6Rn2DAIn/TfwmBaZDWGoTwIxkurkAqxUgoEByxhGKAL7c9G/AhAFW6UBYJrDDwOh6RKhpg3WcoA=
Date:   Thu, 23 Apr 2020 00:29:32 +0530
Message-ID: <260c5decdb38db9f74994988ce7fcaf1@mail.gmail.com>
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

>
> So I tested this on hisi_sas with x12 SAS SSDs, and performance with "mq-
> deadline" is comparable with "none" @ ~ 2M IOPs. But after a while
> performance drops alot, to maybe 700K IOPS. Do you have a similar
> experience?

I am using mq-deadline only for HDD. I have not tried on SSD since it is not
useful scheduler for SSDs.

I noticed that when I used mq-deadline, performance drop starts if I have
more number of drives.
I am running <fio> script which has 64 Drives, 64 thread and all treads are
bound to local numa node which has 36 logical cores.
I noticed that lock contention is in " dd_dispatch_request". I am not sure
why there is a no penalty of same lock in nr_hw_queue  = 1 mode.

static struct request *dd_dispatch_request(struct blk_mq_hw_ctx *hctx)
{
        struct deadline_data *dd = hctx->queue->elevator->elevator_data;
        struct request *rq;

        spin_lock(&dd->lock);
        rq = __dd_dispatch_request(dd);
        spin_unlock(&dd->lock);

        return rq;
}

Here is perf report -

-    1.04%     0.99%  kworker/18:1H+k  [kernel.vmlinux]  [k]
native_queued_spin_lock_slowpath
     0.99% ret_from_fork
    -   kthread
      - worker_thread
         - 0.98% process_one_work
            - 0.98% __blk_mq_run_hw_queue
               - blk_mq_sched_dispatch_requests
                  - 0.98% blk_mq_do_dispatch_sched
                     - 0.97% dd_dispatch_request
                        + 0.97% queued_spin_lock_slowpath
+    1.04%     0.00%  kworker/18:1H+k  [kernel.vmlinux]  [k]
queued_spin_lock_slowpath
+    1.03%     0.95%  kworker/19:1H-k  [kernel.vmlinux]  [k]
native_queued_spin_lock_slowpath
+    1.03%     0.00%  kworker/19:1H-k  [kernel.vmlinux]  [k]
queued_spin_lock_slowpath
+    1.02%     0.97%  kworker/20:1H+k  [kernel.vmlinux]  [k]
native_queued_spin_lock_slowpath
+    1.02%     0.00%  kworker/20:1H+k  [kernel.vmlinux]  [k]
queued_spin_lock_slowpath
+    1.01%     0.96%  kworker/21:1H+k  [kernel.vmlinux]  [k]
native_queued_spin_lock_slowpath


>
> Anyway, I'll have a look.
>
> Thanks,
> John
