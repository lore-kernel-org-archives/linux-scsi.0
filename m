Return-Path: <SRS0=xi/P=XP=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7746C3A5A2
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Sep 2019 17:15:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A18472086A
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Sep 2019 17:15:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390617AbfITRPA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 20 Sep 2019 13:15:00 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:36987 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726020AbfITRPA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 20 Sep 2019 13:15:00 -0400
Received: by mail-wr1-f66.google.com with SMTP id i1so7524164wro.4;
        Fri, 20 Sep 2019 10:14:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=708i0GXoRU0vfL8rToydhcVIw8EDHt742xBN7rqv9KE=;
        b=V7X+lNgUdCJ8UY2DBB/S53fbT0gar2NXhLRtfIskUF+2WdyCtPNnWJDO46SpSLeR91
         TH+Y8x1cnt6IL0WJGa/6SYlaAA2o+ZZacH9RoEp9Fvy34mOOY0MrgCh1y2mfGGVEbDp/
         NIHbBNy77ihWerNxvv3Yz5WF/707mu8FIzpntfQqgI/tihSe+c5Eg5HgNyyy6CQy9WXv
         2BXfzLnFZQQ9PmOLiqZ8s++ukRxD18EJfi/VERxbw+dv98TSJMCQuj5IPSyEDNZpa2y0
         QZ8lwDWVFSX6TdsOfCI1TeEg2umTlbWOFdyLTWPkVqz6PqsHhz+5LbNM8dnmklzCeuQR
         wZIw==
X-Gm-Message-State: APjAAAVc3wrk2Jmwb0kj0L5muU5ifKDgnOXVx3mJ9+Fe2441mo4HSFs0
        2iogx3AF5bN9w8TINyeU7/o=
X-Google-Smtp-Source: APXvYqz/171cusxLaSHVyRs5RJb8oFkBD2jyqriUI6geMkPG3UnqbrZt869L5/E5GgYi07Y0yuHcyA==
X-Received: by 2002:a05:6000:43:: with SMTP id k3mr13220021wrx.84.1568999697018;
        Fri, 20 Sep 2019 10:14:57 -0700 (PDT)
Received: from ?IPv6:2600:1700:65a0:78e0:514:7862:1503:8e4d? ([2600:1700:65a0:78e0:514:7862:1503:8e4d])
        by smtp.gmail.com with ESMTPSA id m62sm3293682wmm.35.2019.09.20.10.14.53
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 20 Sep 2019 10:14:55 -0700 (PDT)
Subject: Re: [PATCH 1/4] softirq: implement IRQ flood detection mechanism
To:     Long Li <longli@microsoft.com>, Ming Lei <ming.lei@redhat.com>
Cc:     Jens Axboe <axboe@fb.com>, Hannes Reinecke <hare@suse.com>,
        John Garry <john.garry@huawei.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        Keith Busch <keith.busch@intel.com>,
        Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Christoph Hellwig <hch@lst.de>
References: <6b88719c-782a-4a63-db9f-bf62734a7874@linaro.org>
 <20190903072848.GA22170@ming.t460p>
 <dd96def4-1121-afbe-2431-9e516a06850c@linaro.org>
 <6f3b6557-1767-8c80-f786-1ea667179b39@acm.org>
 <2a8bd278-5384-d82f-c09b-4fce236d2d95@linaro.org>
 <20190905090617.GB4432@ming.t460p>
 <6a36ccc7-24cd-1d92-fef1-2c5e0f798c36@linaro.org>
 <20190906014819.GB27116@ming.t460p>
 <ffefcfa0-09b6-9af5-f94e-8e7ddd2eef16@linaro.org>
 <6eb2a745-7b92-73ce-46f5-cc6a5ef08abc@grimberg.me>
 <20190907000100.GC12290@ming.t460p>
 <f5685543-8cd5-6c6a-5b80-c77ef09c6b3b@grimberg.me>
 <CY4PR21MB0741838CE0C9D52556AA4558CE8E0@CY4PR21MB0741.namprd21.prod.outlook.com>
From:   Sagi Grimberg <sagi@grimberg.me>
Message-ID: <30dc6fa9-ea5e-50d6-56f9-fbc9627d8c29@grimberg.me>
Date:   Fri, 20 Sep 2019 10:14:51 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <CY4PR21MB0741838CE0C9D52556AA4558CE8E0@CY4PR21MB0741.namprd21.prod.outlook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


>> Hey Ming,
>>
>>>>> Ok, so the real problem is per-cpu bounded tasks.
>>>>>
>>>>> I share Thomas opinion about a NAPI like approach.
>>>>
>>>> We already have that, its irq_poll, but it seems that for this
>>>> use-case, we get lower performance for some reason. I'm not entirely
>>>> sure why that is, maybe its because we need to mask interrupts
>>>> because we don't have an "arm" register in nvme like network devices
>>>> have?
>>>
>>> Long observed that IOPS drops much too by switching to threaded irq.
>>> If softirqd is waken up for handing softirq, the performance shouldn't
>>> be better than threaded irq.
>>
>> Its true that it shouldn't be any faster, but what irqpoll already has and we
>> don't need to reinvent is a proper budgeting mechanism that needs to occur
>> when multiple devices map irq vectors to the same cpu core.
>>
>> irqpoll already maintains a percpu list and dispatch the ->poll with a budget
>> that the backend enforces and irqpoll multiplexes between them.
>> Having this mechanism in irq (hard or threaded) context sounds unnecessary a
>> bit.
>>
>> It seems like we're attempting to stay in irq context for as long as we can
>> instead of scheduling to softirq/thread context if we have more than a
>> minimal amount of work to do. Without at least understanding why
>> softirq/thread degrades us so much this code seems like the wrong approach
>> to me. Interrupt context will always be faster, but it is not a sufficient reason
>> to spend as much time as possible there, is it?
>>
>> We should also keep in mind, that the networking stack has been doing this
>> for years, I would try to understand why this cannot work for nvme before
>> dismissing.
>>
>>> Especially, Long found that context
>>> switch is increased a lot after applying your irq poll patch.
>>>
>>> https://nam06.safelinks.protection.outlook.com/?url=http%3A%2F%2Flists
>>> .infradead.org%2Fpipermail%2Flinux-nvme%2F2019-
>> August%2F026788.html&am
>>>
>> p;data=02%7C01%7Clongli%40microsoft.com%7C20391b0810844821325908d73
>> 59c
>>>
>> 64d2%7C72f988bf86f141af91ab2d7cd011db47%7C1%7C0%7C637036818140279
>> 742&a
>>>
>> mp;sdata=GyBWILwPvwHYvrTGSAVZbdl%2Fcoz3twSXe2DrH2t1MeQ%3D&am
>> p;reserved
>>> =0
>>
>> Oh, I didn't see that one, wonder why... thanks!
>>
>> 5% improvement, I guess we can buy that for other users as is :)
>>
>> If we suffer from lots of context switches while the CPU is flooded with
>> interrupts, then I would argue that we're re-raising softirq too much.
>> In this use-case, my assumption is that the cpu cannot keep up with the
>> interrupts and not that it doesn't reap enough (we also reap the first batch in
>> interrupt context...)
>>
>> Perhaps making irqpoll continue until it must resched would improve things
>> further? Although this is a latency vs. efficiency tradeoff, looks like
>> MAX_SOFTIRQ_TIME is set to 2ms:
>>
>> "
>>   * The MAX_SOFTIRQ_TIME provides a nice upper bound in most cases, but in
>>   * certain cases, such as stop_machine(), jiffies may cease to
>>   * increment and so we need the MAX_SOFTIRQ_RESTART limit as
>>   * well to make sure we eventually return from this method.
>>   *
>>   * These limits have been established via experimentation.
>>   * The two things to balance is latency against fairness -
>>   * we want to handle softirqs as soon as possible, but they
>>   * should not be able to lock up the box.
>> "
>>
>> Long, does this patch make any difference?
> 
> Sagi,
> 
> Sorry it took a while to bring my system back online.
> 
> With the patch, the IOPS is about the same drop with the 1st patch. I think the excessive context switches are causing the drop in IOPS.
> 
> The following are captured by "perf sched record" for 30 seconds during tests.
> 
> "perf sched latency"
> With patch:
>    fio:(82)              | 937632.706 ms |  1782255 | avg:    0.209 ms | max:   63.123 ms | max at:    768.274023 s
> 
> without patch:
>    fio:(82)              |2348323.432 ms |    18848 | avg:    0.295 ms | max:   28.446 ms | max at:   6447.310255 s

Without patch means the proposed hard-irq patch?

If we are context switching too much, it means the soft-irq operation is
not efficient, not necessarily the fact that the completion path is
running in soft-irq..

Is your kernel compiled with full preemption or voluntary preemption?

> Look closer at each CPU, we can see ksoftirqd is competing CPU with fio (and effectively throttle other fio processes)
> (captured in /sys/kernel/debug/tracing, echo sched:* >set_event)
> 
> On CPU1 with patch: (note that the prev_state for fio is "R", it's preemptively scheduled)
>             <...>-4077  [001] d... 66456.805062: sched_switch: prev_comm=fio prev_pid=4077 prev_prio=120 prev_state=R ==> next_comm=ksoftirqd/1 next_pid=17 next_prio=120
>             <...>-17    [001] d... 66456.805859: sched_switch: prev_comm=ksoftirqd/1 prev_pid=17 prev_prio=120 prev_state=S ==> next_comm=fio next_pid=4077 next_prio=120
>             <...>-4077  [001] d... 66456.844049: sched_switch: prev_comm=fio prev_pid=4077 prev_prio=120 prev_state=R ==> next_comm=ksoftirqd/1 next_pid=17 next_prio=120
>             <...>-17    [001] d... 66456.844607: sched_switch: prev_comm=ksoftirqd/1 prev_pid=17 prev_prio=120 prev_state=S ==> next_comm=fio next_pid=4077 next_prio=120
> 
> On CPU1 without patch: (the prev_state for fio is "S", it's voluntarily scheduled)
>            <idle>-0     [001] d...  6725.392308: sched_switch: prev_comm=swapper/1 prev_pid=0 prev_prio=120 prev_state=R ==> next_comm=fio next_pid=14342 next_prio=120
>               fio-14342 [001] d...  6725.392332: sched_switch: prev_comm=fio prev_pid=14342 prev_prio=120 prev_state=S ==> next_comm=swapper/1 next_pid=0 next_prio=120
>            <idle>-0     [001] d...  6725.392356: sched_switch: prev_comm=swapper/1 prev_pid=0 prev_prio=120 prev_state=R ==> next_comm=fio next_pid=14342 next_prio=120
>               fio-14342 [001] d...  6725.392425: sched_switch: prev_comm=fio prev_pid=14342 prev_prio=120 prev_state=S ==> next_comm=swapper/1 next_pid=0 next_prio=12
