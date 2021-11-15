Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA4DFC433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 15 Nov 2021 14:40:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AC92B6321B
	for <linux-scsi@archiver.kernel.org>; Mon, 15 Nov 2021 14:40:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231837AbhKOOnn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 15 Nov 2021 09:43:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233591AbhKOOn0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Nov 2021 09:43:26 -0500
Received: from mail-il1-x12e.google.com (mail-il1-x12e.google.com [IPv6:2607:f8b0:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 588E6C061714
        for <linux-scsi@vger.kernel.org>; Mon, 15 Nov 2021 06:40:27 -0800 (PST)
Received: by mail-il1-x12e.google.com with SMTP id h2so16854135ili.11
        for <linux-scsi@vger.kernel.org>; Mon, 15 Nov 2021 06:40:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=THx+QpR1KF4fxo25IMLRna/kbmWFp1uPvNC37xHQcpo=;
        b=3XMMkL55ToaC2LxfngBhurWV3ts2w5UY+VStn9ZGCHOFvW04BbF2tdGMM5litV9keu
         vf/q6TlmrJeURnW06eZ/QX8ciDuj8QoFyr50Qi/4qDmXhnBMUscQcUGqNg8WE/5L+dqE
         oRYpYFl4lGKlN0BepUmdGQVCd0A+PiuFKL3K0AZwxWa5bp3Ml++CRKTYqRahe+9ax2c9
         BDtrSe2ERqLvNaCirDfvmDmGia/3y0arH3pxT8KUUg/gRF8QtGAmguORHDd1/al7pv51
         ksGAzhmZXegRAmyR/FNTZD37SAtSwU2+xJcAZBF17vJw6RaOll++I8HeuALQCznm25Fa
         6A3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=THx+QpR1KF4fxo25IMLRna/kbmWFp1uPvNC37xHQcpo=;
        b=TP1GpHpgTi3s3MWe27PC/eb72dBv+IEJpZyZMHIrC67IQqRswgx91ZjlKyHcoslF+H
         p2Atthj9e1ZHNdb1WtPOlrJFpxB6+o3rZbfXdtu3+Y+B8wRn/3zziPaABEBmiXe8O+3m
         jHFXP+4Hig8B9RIrTPZj4N/YA6eJMiAE2QuIDVbp7Irny/zN7bzdSENjbb6XcTqDCOj0
         WUrdaof0/ZzrmTaLVAbkTUjWb/dKQE2AvpsrzjMy8vU4UmFjB3xjSy8T8ag2idkCYR6N
         55+5bLzWQShGGdI1RFtaCVcSwmnJgQOjCSIV/XSG1c88UpR/4uhRNCsZ0VFNE2MOIF2v
         4Dgg==
X-Gm-Message-State: AOAM5335dYYTihPHKiBUngMor+AiE8xsYk48tuRSsk9f64Ztv+N0/VJe
        iw2TwmqRwovoe6R2RS/sj/XfZIwBlB4ga8wS
X-Google-Smtp-Source: ABdhPJxs3FxJRu9miHpPUlcKGRm5la5CZAhagJO8dPv9HCIBIhWrpHcx1l/SC0rPQQru3AUZHi2f4Q==
X-Received: by 2002:a05:6e02:20ea:: with SMTP id q10mr21957288ilv.10.1636987226312;
        Mon, 15 Nov 2021 06:40:26 -0800 (PST)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id c11sm8891673ilm.74.2021.11.15.06.40.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 Nov 2021 06:40:25 -0800 (PST)
Subject: Re: [PATCH] blk-mq: sync blk-mq queue in both blk_cleanup_queue and
 disk_release()
To:     Ming Lei <ming.lei@redhat.com>
Cc:     linux-block@vger.kernel.org, ChanghuiZhong <czhong@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Bart Van Assche <bvanassche@acm.org>,
        linux-scsi@vger.kernel.org
References: <20211115075650.578051-1-ming.lei@redhat.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <8bd0c95a-919c-3fd4-99bf-7d98400fe4a6@kernel.dk>
Date:   Mon, 15 Nov 2021 07:40:25 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20211115075650.578051-1-ming.lei@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/15/21 12:56 AM, Ming Lei wrote:
> For avoiding to slow down queue destroy, we don't call
> blk_mq_quiesce_queue() in blk_cleanup_queue(), instead of delaying to
> sync blk-mq queue in blk_release_queue().
> 
> However, this way has caused kernel oops[1], reported by Changhui. The log
> shows that scsi_device can be freed before running blk_release_queue(),
> which is expected too since scsi_device is released after the scsi disk
> is closed and the scsi_device is removed.
> 
> Fixes the issue by sync blk-mq in both blk_cleanup_queue() and
> disk_release():
> 
> 1) when disk_release() is run, the disk has been closed, and any sync
> dispatch activities have been done, so sync blk-mq queue is enough to quiesce
> filesystem dispatch activity.
> 
> 2) in blk_cleanup_queue(), we only focus on passthrough request, and
> passthrough request is always explicitly allocated & freed by
> passthrough request caller, so once queue is frozen, all sync dispatch activity
> for passthrough request has been done, then it is enough to sync blk-mq queue
> for avoiding to run any dispatch activity.
> 
> [1] kernel panic log
> [12622.769416] BUG: kernel NULL pointer dereference, address: 0000000000000300
> [12622.777186] #PF: supervisor read access in kernel mode
> [12622.782918] #PF: error_code(0x0000) - not-present page
> [12622.788649] PGD 0 P4D 0
> [12622.791474] Oops: 0000 [#1] PREEMPT SMP PTI
> [12622.796138] CPU: 10 PID: 744 Comm: kworker/10:1H Kdump: loaded Not tainted 5.15.0+ #1
> [12622.804877] Hardware name: Dell Inc. PowerEdge R730/0H21J3, BIOS 1.5.4 10/002/2015
> [12622.813321] Workqueue: kblockd blk_mq_run_work_fn
> [12622.818572] RIP: 0010:sbitmap_get+0x75/0x190
> [12622.823336] Code: 85 80 00 00 00 41 8b 57 08 85 d2 0f 84 b1 00 00 00 45 31 e4 48 63 cd 48 8d 1c 49 48 c1 e3 06 49 03 5f 10 4c 8d 6b 40 83 f0 01 <48> 8b 33 44 89 f2 4c 89 ef 0f b6 c8 e8 fa f3 ff ff 83 f8 ff 75 58
> [12622.844290] RSP: 0018:ffffb00a446dbd40 EFLAGS: 00010202
> [12622.850120] RAX: 0000000000000001 RBX: 0000000000000300 RCX: 0000000000000004
> [12622.858082] RDX: 0000000000000006 RSI: 0000000000000082 RDI: ffffa0b7a2dfe030
> [12622.866042] RBP: 0000000000000004 R08: 0000000000000001 R09: ffffa0b742721334
> [12622.874003] R10: 0000000000000008 R11: 0000000000000008 R12: 0000000000000000
> [12622.881964] R13: 0000000000000340 R14: 0000000000000000 R15: ffffa0b7a2dfe030
> [12622.889926] FS:  0000000000000000(0000) GS:ffffa0baafb40000(0000) knlGS:0000000000000000
> [12622.898956] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [12622.905367] CR2: 0000000000000300 CR3: 0000000641210001 CR4: 00000000001706e0
> [12622.913328] Call Trace:
> [12622.916055]  <TASK>
> [12622.918394]  scsi_mq_get_budget+0x1a/0x110
> [12622.922969]  __blk_mq_do_dispatch_sched+0x1d4/0x320
> [12622.928404]  ? pick_next_task_fair+0x39/0x390
> [12622.933268]  __blk_mq_sched_dispatch_requests+0xf4/0x140
> [12622.939194]  blk_mq_sched_dispatch_requests+0x30/0x60
> [12622.944829]  __blk_mq_run_hw_queue+0x30/0xa0
> [12622.949593]  process_one_work+0x1e8/0x3c0
> [12622.954059]  worker_thread+0x50/0x3b0
> [12622.958144]  ? rescuer_thread+0x370/0x370
> [12622.962616]  kthread+0x158/0x180
> [12622.966218]  ? set_kthread_struct+0x40/0x40
> [12622.970884]  ret_from_fork+0x22/0x30
> [12622.974875]  </TASK>
> [12622.977309] Modules linked in: scsi_debug rpcsec_gss_krb5 auth_rpcgss nfsv4 dns_resolver nfs lockd grace fscache netfs sunrpc dm_multipath intel_rapl_msr intel_rapl_common dell_wmi_descriptor sb_edac rfkill video x86_pkg_temp_thermal intel_powerclamp dcdbas coretemp kvm_intel kvm mgag200 irqbypass i2c_algo_bit rapl drm_kms_helper ipmi_ssif intel_cstate intel_uncore syscopyarea sysfillrect sysimgblt fb_sys_fops pcspkr cec mei_me lpc_ich mei ipmi_si ipmi_devintf ipmi_msghandler acpi_power_meter drm fuse xfs libcrc32c sr_mod cdrom sd_mod t10_pi sg ixgbe ahci libahci crct10dif_pclmul crc32_pclmul crc32c_intel libata megaraid_sas ghash_clmulni_intel tg3 wdat_wdt mdio dca wmi dm_mirror dm_region_hash dm_log dm_mod [last unloaded: scsi_debug]
> 
> Reported-by: ChanghuiZhong <czhong@redhat.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
> Cc: Bart Van Assche <bvanassche@acm.org>
> Cc: linux-scsi@vger.kernel.org
> Signed-off-by: Ming Lei <ming.lei@redhat.com>
> ---
>  block/blk-core.c  |  4 +++-
>  block/blk-mq.c    | 13 +++++++++++++
>  block/blk-mq.h    |  2 ++
>  block/blk-sysfs.c | 10 ----------
>  block/genhd.c     |  2 ++
>  5 files changed, 20 insertions(+), 11 deletions(-)
> 
> diff --git a/block/blk-core.c b/block/blk-core.c
> index 9ee32f85d74e..78710567cf69 100644
> --- a/block/blk-core.c
> +++ b/block/blk-core.c
> @@ -363,8 +363,10 @@ void blk_cleanup_queue(struct request_queue *q)
>  	blk_queue_flag_set(QUEUE_FLAG_DEAD, q);
>  
>  	blk_sync_queue(q);
> -	if (queue_is_mq(q))
> +	if (queue_is_mq(q)) {
> +		blk_mq_sync_queue(q);
>  		blk_mq_exit_queue(q);
> +	}
>  
>  	/*
>  	 * In theory, request pool of sched_tags belongs to request queue.
> diff --git a/block/blk-mq.c b/block/blk-mq.c
> index 3ab34c4f20da..36260ce0b9ec 100644
> --- a/block/blk-mq.c
> +++ b/block/blk-mq.c
> @@ -4417,6 +4417,19 @@ unsigned int blk_mq_rq_cpu(struct request *rq)
>  }
>  EXPORT_SYMBOL(blk_mq_rq_cpu);
>  
> +void blk_mq_sync_queue(struct request_queue *q)
> +{
> +	if (queue_is_mq(q)) {
> +		struct blk_mq_hw_ctx *hctx;
> +		int i;
> +
> +		cancel_delayed_work_sync(&q->requeue_work);
> +
> +		queue_for_each_hw_ctx(q, hctx, i)
> +			cancel_delayed_work_sync(&hctx->run_work);
> +	}
> +}

Fix looks good to me, but let's rename this function
blk_mq_cancel_work_sync() instead, as that pretty much tells you what it
does without needing to look it up. sync_queue() could have a drastically
different meaning, since 'sync' is a bit overloaded on the storage
front.

-- 
Jens Axboe

