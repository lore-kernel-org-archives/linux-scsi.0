Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 297C8C678D4
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Jan 2023 18:11:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233018AbjAPSLp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 16 Jan 2023 13:11:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231161AbjAPSLQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Jan 2023 13:11:16 -0500
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A50BE31E0A;
        Mon, 16 Jan 2023 09:55:54 -0800 (PST)
Received: by mail-pl1-f178.google.com with SMTP id 20so3722626plo.3;
        Mon, 16 Jan 2023 09:55:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=n44gyOQFk+IY2XBw5wz81ugzRoFTiCYhkNGUM5pGnew=;
        b=1XYS2vA+NVRcCuh9t+xVNaHqjXA4B5lxR4rj9Gvqr6mLeyhS7IjyfPy4qJ2IVkcY1M
         uqEZHTz70M7xJT6knPpROb8dgAaYqqkL8lqZa/ofhyeWEh9wZSPdpXsrTYDOXermubHa
         nGL+BcYC38/LjvpRhoeCNosNvVJZAaDIAbfzSbIqPxnRxyP1y9EbphkAVV+H8bkbtsxC
         rB2QhtrE4Oj8JkNKbRl2UOB20+53dzlbVnykEVp06AiigDKE0E3jyhIdb25fbIOS5uc5
         I3o1DfsqUtxJrZRkrQX5l0WoChmd/21E7AZAi5QMW0nnfxj8iE40LfSW7oP+ElXrl97h
         +t8Q==
X-Gm-Message-State: AFqh2krdwPchmWdHEdfS3KO/P/e1oJyMXGzKBjuBEySaLdaQ7srGI8NQ
        WPspC28pS6n+xBtHZLTAK10=
X-Google-Smtp-Source: AMrXdXtMjtKLe9Zt9+LVmixddOi9QKO0FCyr7q+Tv3NdX0RCe/b48Bcgi+4Kl441vJurln7nh3j8MQ==
X-Received: by 2002:a17:90a:c58b:b0:226:18ca:b53d with SMTP id l11-20020a17090ac58b00b0022618cab53dmr23193993pjt.41.1673891753980;
        Mon, 16 Jan 2023 09:55:53 -0800 (PST)
Received: from [192.168.51.14] ([98.51.102.78])
        by smtp.gmail.com with ESMTPSA id l14-20020a17090aec0e00b0022908f1398dsm7403667pjy.32.2023.01.16.09.55.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Jan 2023 09:55:53 -0800 (PST)
Message-ID: <228d2351-e0ff-e743-6005-3ac0f0daf637@acm.org>
Date:   Mon, 16 Jan 2023 09:55:51 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: kernel BUG scsi_dh_alua sleeping from invalid context && kernel
 WARNING do not call blocking ops when !TASK_RUNNING
Content-Language: en-US
To:     Steffen Maier <maier@linux.ibm.com>,
        linux-scsi <linux-scsi@vger.kernel.org>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        Sachin Sant <sachinp@linux.ibm.com>,
        Hannes Reinecke <hare@suse.de>, Martin Wilck <mwilck@suse.com>,
        Benjamin Block <bblock@linux.ibm.com>,
        linux-s390 <linux-s390@vger.kernel.org>
References: <b49e37d5-edfb-4c56-3eeb-62c7d5855c00@linux.ibm.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <b49e37d5-edfb-4c56-3eeb-62c7d5855c00@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 1/16/23 06:59, Steffen Maier wrote:
> Hi all,
> 
> since a few days/weeks, we sometimes see below alua and sleep related 
> kernel BUG and WARNING (with panic_on_warn) in our CI.
> 
> It reminds me of
> [PATCH 0/2] Rework how the ALUA driver calls scsi_device_put()
> https://lore.kernel.org/linux-scsi/166986602290.2101055.17397734326843853911.b4-ty@oracle.com/
> 
> which I thought was the fix and went into 6.2-rc(1?) on 2022-12-14 with
> [GIT PULL] first round of SCSI updates for the 6.1+ merge window
> https://lore.kernel.org/linux-scsi/b2e824bbd1e40da64d2d01657f2f7a67b98919fb.camel@HansenPartnership.com/T/#u
> 
> Due to limited history, I cannot tell exactly when problems started and 
> whether it really correlates to above.
> 
> Test workload are all kinds of coverage tests for zfcp recovery 
> including scsi device removal and/or rescan.
> 
> [ 4569.045992] BUG: sleeping function called from invalid context at 
> drivers/scsi/device_handler/scsi_dh_alua.c:992
> [ 4569.046003] in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 0, 
> name: swapper/8
> [ 4569.046013] preempt_count: 101, expected: 0
> [ 4569.046023] RCU nest depth: 0, expected: 0
> [ 4569.046033] no locks held by swapper/8/0.
> [ 4569.046042] Preemption disabled at:
> [ 4569.046046] [<000000017e27ce4e>] __slab_alloc.constprop.0+0x36/0xb8
> [ 4569.046072] CPU: 8 PID: 0 Comm: swapper/8 Tainted: G        W 
> 6.2.0-20230114.rc3.git0.46e26dd43df0.300.fc37.s390x+debug #1
> [ 4569.046084] Hardware name: IBM 2964 NC9 702 (z/VM 6.4.0)
> [ 4569.046094] Call Trace:
> [ 4569.046102]  [<000000017ed21bcc>] dump_stack_lvl+0xac/0x100
> [ 4569.046118]  [<000000017df9192c>] __might_resched+0x284/0x2c8
> [ 4569.046131]  [<000003ff7fb9c874>] alua_rtpg_queue+0x3c/0x98 
> [scsi_dh_alua]
> [ 4569.046146]  [<000003ff7fb9cfb2>] alua_check+0x122/0x250 [scsi_dh_alua]
> [ 4569.046167]  [<000003ff7fb9d562>] alua_check_sense+0x172/0x228 
> [scsi_dh_alua]
> [ 4569.046179]  [<000000017e96b3e2>] scsi_check_sense+0x8a/0x2e0
> [ 4569.046191]  [<000000017e96e4b6>] scsi_decide_disposition+0x286/0x298
> [ 4569.046201]  [<000000017e972bca>] scsi_complete+0x6a/0x108
> [ 4569.046212]  [<000000017e746906>] blk_complete_reqs+0x6e/0x88
> [ 4569.046227]  [<000000017ed3830e>] __do_softirq+0x13e/0x6b8
> [ 4569.046238]  [<000000017df57902>] __irq_exit_rcu+0x14a/0x170
> [ 4569.046264]  [<000000017df58472>] irq_exit_rcu+0x22/0x50
> [ 4569.046275]  [<000000017ed2242a>] do_ext_irq+0x10a/0x1d0
> [ 4569.046286]  [<000000017ed36156>] ext_int_handler+0xd6/0x110
> [ 4569.046296]  [<000000017ed362e6>] psw_idle_exit+0x0/0xa
> [ 4569.046307] ([<000000017defc5da>] arch_cpu_idle+0x52/0xe0)
> [ 4569.046318]  [<000000017ed34744>] default_idle_call+0x84/0xd0
> [ 4569.046329]  [<000000017dfbe4cc>] do_idle+0xfc/0x1b8
> [ 4569.046340]  [<000000017dfbe80e>] cpu_startup_entry+0x36/0x40
> [ 4569.046350]  [<000000017df11964>] smp_start_secondary+0x14c/0x160
> [ 4569.046371]  [<000000017ed3658e>] restart_int_handler+0x6e/0x90
> [ 4569.046381] no locks held by swapper/8/0.
Hi Steffen,

Thanks for your report and also for having included this call trace. Is 
my understanding correct that alua_rtpg_queue+0x3c refers to the 
might_sleep() near the start of alua_rtpg_queue()? If so, please help 
with testing the following patch:

diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c 
b/drivers/scsi/device_handler/scsi_dh_alua.c
index 49cc18a87473..79afa7acdfbc 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -989,8 +989,6 @@ static bool alua_rtpg_queue(struct alua_port_group
  	int start_queue = 0;
  	unsigned long flags;

-	might_sleep();
-
  	if (WARN_ON_ONCE(!pg) || scsi_device_get(sdev))
  		return false;


I'm proposing this change because the context from which a request is 
queued should hold a reference on 'sdev' while a request is in progress 
so alua_check_sense() should not trigger the scsi_device_put() call in 
alua_rtpg_queue().

Thanks,

Bart.
