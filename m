Return-Path: <SRS0=Y1+o=5Y=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF3E2C2D0EA
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Apr 2020 09:59:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A44E620747
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Apr 2020 09:59:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="Q7CTnj5I"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727648AbgDHJ77 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 8 Apr 2020 05:59:59 -0400
Received: from mail-qv1-f47.google.com ([209.85.219.47]:34916 "EHLO
        mail-qv1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727427AbgDHJ77 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Apr 2020 05:59:59 -0400
Received: by mail-qv1-f47.google.com with SMTP id q73so3325177qvq.2
        for <linux-scsi@vger.kernel.org>; Wed, 08 Apr 2020 02:59:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:references:in-reply-to:mime-version:thread-index:date
         :message-id:subject:to:cc;
        bh=nPlQhBEB+7aVYwEYBOTaGBDVlulI0AdQp3gmPCZo/vA=;
        b=Q7CTnj5IWnm380WPCcbj98FzWsRFGN2fAjjQ5cO5I/fMlUubsaDvkkM8LL3a+lB79M
         sxls6Byjna9HibkMyb6//5GN4LsIpl+Qayn5XtJNp9zgynWmv76E8vYa5i2RFp1N/1m0
         6PaCQX4IkrGxbFZkCkZ8SZoy2PkEogTOVkkc8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:references:in-reply-to:mime-version
         :thread-index:date:message-id:subject:to:cc;
        bh=nPlQhBEB+7aVYwEYBOTaGBDVlulI0AdQp3gmPCZo/vA=;
        b=FOl46MM72LjrxdVv4pMjEOs4A3RL+qaHloyBjmw2uefjwypaun2vbO4hoSDZ3RP4TD
         3uAaMeqIbaxIqMzdqkOuz4RB0YzX3mi1beUWpwcKl29/j8h+1q6pCDe+Sv8cF6OpWyy2
         QmYSbT9M+4efiudnxCLKmvPHsWlKMjzQJreUgJu3pKFe26CB0l4n6l37o9TaxtzQj/rX
         wGImOxTq54yocxSO42pAQw6MfnU05mFmm7iIT26RdKKFXpTqS5MsSYQlTcvCbKBfFulm
         MZY+pzi1AaRO0Oo/FqN1XVtZ9Oh+bcJImBZfK5fEk9sT1alEU9OYnq5yjtstg2gWEhZ7
         2D2A==
X-Gm-Message-State: AGi0PuYinNHxYDo+6F5j7YRm53iOTYiUR0tyvk+zSrJ+hkbTm8JELQV/
        bSSLgW0hqZGsEB0YJqj7XxP7O6rt1uC3HBNo6ZgI0g==
X-Google-Smtp-Source: APiQypICmBQYOzHQx1B4peqgkoW9B1M3uws/RIWCVgrouvZ4UsocRu3k0emWF2RxhJpNTJ8hgiMFrdzWAyWqxSmPer8=
X-Received: by 2002:a05:6214:364:: with SMTP id t4mr6723487qvu.124.1586339996950;
 Wed, 08 Apr 2020 02:59:56 -0700 (PDT)
From:   Kashyap Desai <kashyap.desai@broadcom.com>
References: <1583409280-158604-1-git-send-email-john.garry@huawei.com>
 <1583409280-158604-9-git-send-email-john.garry@huawei.com>
 <a1f0399e2e85b2244a9ae40e4a2f1089@mail.gmail.com> <f839f040-8bf4-cf83-7670-dfc208b77326@huawei.com>
In-Reply-To: <f839f040-8bf4-cf83-7670-dfc208b77326@huawei.com>
MIME-Version: 1.0
X-Mailer: Microsoft Outlook 15.0
Thread-Index: AQLPD/Iw6Rn2DAIn/TfwmBaZDWGoTwIxkurkAqxUgoEByxhGKKZHrWyA
Date:   Wed, 8 Apr 2020 15:29:54 +0530
Message-ID: <7cac3eb9fd79b5b988e25da542305b35@mail.gmail.com>
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

> Hi Kashyap,
>
> >
> > There is one outstanding patch which will eventually remove
> > device_busy from sdev. To fix this interface, we may have to track per
> > scsi device outstanding within a driver.
> > For my testing I used below since we still have below interface
> > available.
> >
> >          sdev_busy = atomic_read(&scmd->device->device_busy);
>
> So please confirm that this is your change in megasas_get_msix_index():
>
> - sdev_busy = atomic_read(&hctx->nr_active);
> + sdev_busy = atomic_read(&scmd->device->device_busy);

That  is correct.

>
> >
> > We have done some level of testing to know performance impact on SAS
> > SSDs and HDD setup. Here is my finding - My testing used - Two socket
> > Intel Skylake/Lewisburg/Purley Output of numactl --hardware
> >
> > available: 2 nodes (0-1)
> > node 0 cpus: 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 36 37 38 39
> > 40 41
> > 42 43 44 45 46 47 48 49 50 51 52 53
> > node 0 size: 31820 MB
> > node 0 free: 21958 MB
> > node 1 cpus: 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 54
> > 55
> > 56 57 58 59 60 61 62 63 64 65 66 67 68 69 70 71 node 1 size: 32247 MB
> > node 1 free: 21068 MB node distances:
> > node   0   1
> >    0:  10  21
> >    1:  21  10
> >
> >
> > 64 HDD setup -
> >
> > With higher QD
>
> what's OD?
>
> > and io schedulder = mq-deadline, shared host tag is not scaling well.
> > If I use ioscheduler = none, I can see consistent 2.0M IOPs.
> > This issue is seen only with RFC. Without RFC mq-deadline scales up to
> > 2.0M IOPS.
>
> I didn't try any scheduler. I can have a look at that.
>
> >
> > Perf Top result of RFC - (IOPS = 1.4M IOPS)
> >
> >     78.20%  [kernel]        [k] native_queued_spin_lock_slowpath
> >       1.46%  [kernel]        [k] sbitmap_any_bit_set
> >       1.14%  [kernel]        [k] blk_mq_run_hw_queue
> >       0.90%  [kernel]        [k] _mix_pool_bytes
> >       0.63%  [kernel]        [k] _raw_spin_lock
> >       0.57%  [kernel]        [k] blk_mq_run_hw_queues
> >       0.56%  [megaraid_sas]  [k] complete_cmd_fusion
> >       0.54%  [megaraid_sas]  [k] megasas_build_and_issue_cmd_fusion
> >       0.50%  [kernel]        [k] dd_has_work
> >       0.38%  [kernel]        [k] _raw_spin_lock_irqsave
> >       0.36%  [kernel]        [k] gup_pgd_range
> >       0.35%  [megaraid_sas]  [k] megasas_build_ldio_fusion
> >       0.31%  [kernel]        [k] io_submit_one
> >       0.29%  [kernel]        [k] hctx_lock
> >       0.26%  [kernel]        [k] try_to_grab_pending
> >       0.24%  [kernel]        [k] scsi_queue_rq
> >       0.22%  fio             [.] __fio_gettime
> >       0.22%  [kernel]        [k] insert_work
> >       0.20%  [kernel]        [k] native_irq_return_iret
> >
> > Perf top without RFC driver - (IOPS = 2.0 M IOPS)
> >
> >      58.40%  [kernel]          [k] native_queued_spin_lock_slowpath
> >       2.06%  [kernel]          [k] _mix_pool_bytes
> >       1.38%  [kernel]          [k] _raw_spin_lock_irqsave
> >       0.97%  [kernel]          [k] _raw_spin_lock
> >       0.91%  [kernel]          [k] scsi_queue_rq
> >       0.82%  [kernel]          [k] __sbq_wake_up
> >       0.77%  [kernel]          [k] _raw_spin_unlock_irqrestore
> >       0.74%  [kernel]          [k] scsi_mq_get_budget
> >       0.61%  [kernel]          [k] gup_pgd_range
> >       0.58%  [kernel]          [k] aio_complete_rw
> >       0.52%  [kernel]          [k] elv_rb_add
> >       0.50%  [kernel]          [k] llist_add_batch
> >       0.50%  [kernel]          [k] native_irq_return_iret
> >       0.48%  [kernel]          [k] blk_rq_map_sg
> >       0.48%  fio               [.] __fio_gettime
> >       0.47%  [kernel]          [k] blk_mq_get_tag
> >       0.44%  [kernel]          [k] blk_mq_dispatch_rq_list
> >       0.40%  fio               [.] io_u_queued_complete
> >       0.39%  fio               [.] get_io_u
> >
> >
> > If you want me to test any top up patch, please let me know.  BTW, we
> > also wants to provide module parameter for user to switch back to
> > older nr_hw_queue = 1 mode. I will work on that part.
>
> ok, but I would just like to reiterate the point that you will not see the
> full
> benefit of blk-mq draining hw queues for cpu hotplug since you hide hw
> queues from blk-mq.

Agree. We have done  minimal testing using this RFC. We want to ACK this RFC
as long as primary performance goal is achieved.

We have done full testing on nr_hw_queue =1 (and that is what customer is
using) so we at least want to give that interface available for customer for
some time (assuming they may find some performance gap between two interface
which we may not have encountered during smoke testing.).
Over a period of time, if nr_hw_queue = N works for (Broadcom will conduct
full performance once RFC is committed in upstream) all the IO profiles, we
will share the information with customer about benefit of using nr_hw_queues
=  N.

Kashyap

>
> >
> > 24 SSD setup -
> >
> > I am able to see performance using RFC and without RFC is almost same.
> > There is one specific drop, but that is generic kernel issue. Not
> > related to RFC.
> > We can discuss this issue separately. -
> >
> > 5.6 kernel is not able to scale very well if there is heavy
> > outstanding from application.
> > Example -
> > 24 SSD setup and BS = 8K QD = 128 gives 1.73M IOPs which is h/w max,
> > but at QD = 256 it gives 1.4M IOPs. It looks like there are some
> > overhead  of finding free tags at sdev or shost level which leads drops
> > in
> IOPs.
> >
>
> Thanks for testing,
> John
>
> >
