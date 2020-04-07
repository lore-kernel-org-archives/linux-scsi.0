Return-Path: <SRS0=qNH0=5X=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E284C2BB55
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Apr 2020 11:14:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4448D2078C
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Apr 2020 11:14:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="QC5f1Wgd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728304AbgDGLOs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 7 Apr 2020 07:14:48 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:45507 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728121AbgDGLOs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Apr 2020 07:14:48 -0400
Received: by mail-qk1-f196.google.com with SMTP id o18so1129604qko.12
        for <linux-scsi@vger.kernel.org>; Tue, 07 Apr 2020 04:14:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:references:in-reply-to:mime-version:thread-index:date
         :message-id:subject:to:cc;
        bh=AxGDTBKx0oR0ZEuQlfMPILDmojf+k4jktn+uJ+gBQcA=;
        b=QC5f1Wgd8SpqgnsofxUlKaMX0JYVS6adFdSVh2LduuU0dkTn0XYacyzYTDpllD1zbb
         wDj+bc3KOoqCP5wb/WB+n97nYBaBtv7m6P8XENQlEGfKPa12Zqpkha4O5jg/bFGACgSU
         MklP2zuBOOwn6Kb1krF0ul87B7Kc7WPvOOUk8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:references:in-reply-to:mime-version
         :thread-index:date:message-id:subject:to:cc;
        bh=AxGDTBKx0oR0ZEuQlfMPILDmojf+k4jktn+uJ+gBQcA=;
        b=aNkBAVQ28n5WrKkWyWoL2cx96Gt0mU0jC8VjgQ0zUJZ4rYpyIg1buPj4/0q+WF8X9B
         laeq6BNFsGg1ASMB3+DPt8+kdrLResSoRsf9FOc3kOqvyQuRhhssa/r4qYBKG+FBovDM
         E2DmLXoQkNGyiSWMLaTwyIIF+rBW3tXE3p4dCFMwr+itFbVbTeRJmCPtPDoxSQ1f5SoO
         IvknUoQ/lFkB16wuw5GITLHI/qN5n2ZQBhz5cmKjjdyPQlEqdpCGCo8cLrku8x+DtElt
         0joNIo3a21RrMYoShc+m0yeEsb1b8GtYX9sALbcYKzbdgMVKiEAo+2m2jotiwI4wcepM
         wlGQ==
X-Gm-Message-State: AGi0PuYx/hFqIuqGIZay/qFghKQn7M67yNVMTo3GHAN311zBud3pRMUS
        MmCYWMzt72O9cQmuUBaa4MUfzrsgVWq6GjPxvU+nyw==
X-Google-Smtp-Source: APiQypLNNmE+wIvFexkkU6ncMpEp9ywJ1yjH90oGL9WqPLVeb0/FxG/z17rc6SNK34oTIMiaGfPos41/9reSqbKjE7I=
X-Received: by 2002:a37:8c06:: with SMTP id o6mr1534526qkd.27.1586258086378;
 Tue, 07 Apr 2020 04:14:46 -0700 (PDT)
From:   Kashyap Desai <kashyap.desai@broadcom.com>
References: <1583409280-158604-1-git-send-email-john.garry@huawei.com> <1583409280-158604-9-git-send-email-john.garry@huawei.com>
In-Reply-To: <1583409280-158604-9-git-send-email-john.garry@huawei.com>
MIME-Version: 1.0
X-Mailer: Microsoft Outlook 15.0
Thread-Index: AQLPD/Iw6Rn2DAIn/TfwmBaZDWGoTwIxkurkpmnnpIA=
Date:   Tue, 7 Apr 2020 16:44:42 +0530
Message-ID: <a1f0399e2e85b2244a9ae40e4a2f1089@mail.gmail.com>
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

> --- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
> +++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
> @@ -373,24 +373,24 @@ megasas_get_msix_index(struct megasas_instance
> *instance,  {
>  	int sdev_busy;
>
> -	/* nr_hw_queue = 1 for MegaRAID */
> -	struct blk_mq_hw_ctx *hctx =
> -		scmd->device->request_queue->queue_hw_ctx[0];
> +	struct blk_mq_hw_ctx *hctx = scmd->request->mq_hctx;

Hi John,

There is one outstanding patch which will eventually remove device_busy
from sdev. To fix this interface, we may have to track per scsi device
outstanding within a driver.
For my testing I used below since we still have below interface available.

        sdev_busy = atomic_read(&scmd->device->device_busy);

We have done some level of testing to know performance impact on SAS SSDs
and HDD setup. Here is my finding -
My testing used - Two socket Intel Skylake/Lewisburg/Purley
Output of numactl --hardware

available: 2 nodes (0-1)
node 0 cpus: 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 36 37 38 39 40 41
42 43 44 45 46 47 48 49 50 51 52 53
node 0 size: 31820 MB
node 0 free: 21958 MB
node 1 cpus: 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 54 55
56 57 58 59 60 61 62 63 64 65 66 67 68 69 70 71
node 1 size: 32247 MB
node 1 free: 21068 MB
node distances:
node   0   1
  0:  10  21
  1:  21  10


64 HDD setup -

With higher QD and io schedulder = mq-deadline, shared host tag is not
scaling well. If I use ioscheduler = none, I can see consistent 2.0M IOPs.
This issue is seen only with RFC. Without RFC mq-deadline scales up to
2.0M IOPS.

Perf Top result of RFC - (IOPS = 1.4M IOPS)

   78.20%  [kernel]        [k] native_queued_spin_lock_slowpath
     1.46%  [kernel]        [k] sbitmap_any_bit_set
     1.14%  [kernel]        [k] blk_mq_run_hw_queue
     0.90%  [kernel]        [k] _mix_pool_bytes
     0.63%  [kernel]        [k] _raw_spin_lock
     0.57%  [kernel]        [k] blk_mq_run_hw_queues
     0.56%  [megaraid_sas]  [k] complete_cmd_fusion
     0.54%  [megaraid_sas]  [k] megasas_build_and_issue_cmd_fusion
     0.50%  [kernel]        [k] dd_has_work
     0.38%  [kernel]        [k] _raw_spin_lock_irqsave
     0.36%  [kernel]        [k] gup_pgd_range
     0.35%  [megaraid_sas]  [k] megasas_build_ldio_fusion
     0.31%  [kernel]        [k] io_submit_one
     0.29%  [kernel]        [k] hctx_lock
     0.26%  [kernel]        [k] try_to_grab_pending
     0.24%  [kernel]        [k] scsi_queue_rq
     0.22%  fio             [.] __fio_gettime
     0.22%  [kernel]        [k] insert_work
     0.20%  [kernel]        [k] native_irq_return_iret

Perf top without RFC driver - (IOPS = 2.0 M IOPS)

    58.40%  [kernel]          [k] native_queued_spin_lock_slowpath
     2.06%  [kernel]          [k] _mix_pool_bytes
     1.38%  [kernel]          [k] _raw_spin_lock_irqsave
     0.97%  [kernel]          [k] _raw_spin_lock
     0.91%  [kernel]          [k] scsi_queue_rq
     0.82%  [kernel]          [k] __sbq_wake_up
     0.77%  [kernel]          [k] _raw_spin_unlock_irqrestore
     0.74%  [kernel]          [k] scsi_mq_get_budget
     0.61%  [kernel]          [k] gup_pgd_range
     0.58%  [kernel]          [k] aio_complete_rw
     0.52%  [kernel]          [k] elv_rb_add
     0.50%  [kernel]          [k] llist_add_batch
     0.50%  [kernel]          [k] native_irq_return_iret
     0.48%  [kernel]          [k] blk_rq_map_sg
     0.48%  fio               [.] __fio_gettime
     0.47%  [kernel]          [k] blk_mq_get_tag
     0.44%  [kernel]          [k] blk_mq_dispatch_rq_list
     0.40%  fio               [.] io_u_queued_complete
     0.39%  fio               [.] get_io_u


If you want me to test any top up patch, please let me know.  BTW, we also
wants to provide module parameter for user to switch back to older
nr_hw_queue = 1 mode. I will work on that part.

24 SSD setup -

I am able to see performance using RFC and without RFC is almost same.
There is one specific drop, but that is generic kernel issue. Not related
to RFC.
We can discuss this issue separately. -

5.6 kernel is not able to scale very well if there is heavy outstanding
from application.
Example -
24 SSD setup and BS = 8K QD = 128 gives 1.73M IOPs which is h/w max, but
at QD = 256 it gives 1.4M IOPs. It looks like there are some overhead  of
finding free tags at sdev or shost level which leads drops in IOPs.

Kashyap
