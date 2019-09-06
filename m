Return-Path: <SRS0=yvfi=XB=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9A41C43331
	for <linux-scsi@archiver.kernel.org>; Fri,  6 Sep 2019 01:48:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EB79E206CD
	for <linux-scsi@archiver.kernel.org>; Fri,  6 Sep 2019 01:48:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404271AbfIFBsp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 5 Sep 2019 21:48:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42136 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404265AbfIFBsp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 5 Sep 2019 21:48:45 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id A106218C4266;
        Fri,  6 Sep 2019 01:48:44 +0000 (UTC)
Received: from ming.t460p (ovpn-8-16.pek2.redhat.com [10.72.8.16])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 8744860C18;
        Fri,  6 Sep 2019 01:48:26 +0000 (UTC)
Date:   Fri, 6 Sep 2019 09:48:21 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Daniel Lezcano <daniel.lezcano@linaro.org>
Cc:     Keith Busch <keith.busch@intel.com>,
        Hannes Reinecke <hare@suse.com>,
        Bart Van Assche <bvanassche@acm.org>,
        linux-scsi@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Long Li <longli@microsoft.com>,
        John Garry <john.garry@huawei.com>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-nvme@lists.infradead.org, Jens Axboe <axboe@fb.com>,
        Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Christoph Hellwig <hch@lst.de>,
        Sagi Grimberg <sagi@grimberg.me>
Subject: Re: [PATCH 1/4] softirq: implement IRQ flood detection mechanism
Message-ID: <20190906014819.GB27116@ming.t460p>
References: <20190903033001.GB23861@ming.t460p>
 <299fb6b5-d414-2e71-1dd2-9d6e34ee1c79@linaro.org>
 <20190903063125.GA21022@ming.t460p>
 <6b88719c-782a-4a63-db9f-bf62734a7874@linaro.org>
 <20190903072848.GA22170@ming.t460p>
 <dd96def4-1121-afbe-2431-9e516a06850c@linaro.org>
 <6f3b6557-1767-8c80-f786-1ea667179b39@acm.org>
 <2a8bd278-5384-d82f-c09b-4fce236d2d95@linaro.org>
 <20190905090617.GB4432@ming.t460p>
 <6a36ccc7-24cd-1d92-fef1-2c5e0f798c36@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6a36ccc7-24cd-1d92-fef1-2c5e0f798c36@linaro.org>
User-Agent: Mutt/1.11.3 (2019-02-01)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.62]); Fri, 06 Sep 2019 01:48:44 +0000 (UTC)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Daniel,

On Thu, Sep 05, 2019 at 12:37:13PM +0200, Daniel Lezcano wrote:
> 
> Hi Ming,
> 
> On 05/09/2019 11:06, Ming Lei wrote:
> > On Wed, Sep 04, 2019 at 07:31:48PM +0200, Daniel Lezcano wrote:
> >> Hi,
> >>
> >> On 04/09/2019 19:07, Bart Van Assche wrote:
> >>> On 9/3/19 12:50 AM, Daniel Lezcano wrote:
> >>>> On 03/09/2019 09:28, Ming Lei wrote:
> >>>>> On Tue, Sep 03, 2019 at 08:40:35AM +0200, Daniel Lezcano wrote:
> >>>>>> It is a scheduler problem then ?
> >>>>>
> >>>>> Scheduler can do nothing if the CPU is taken completely by handling
> >>>>> interrupt & softirq, so seems not a scheduler problem, IMO.
> >>>>
> >>>> Why? If there is a irq pressure on one CPU reducing its capacity, the
> >>>> scheduler will balance the tasks on another CPU, no?
> >>>
> >>> Only if CONFIG_IRQ_TIME_ACCOUNTING has been enabled. However, I don't
> >>> know any Linux distro that enables that option. That's probably because
> >>> that option introduces two rdtsc() calls in each interrupt. Given the
> >>> overhead introduced by this option, I don't think this is the solution
> >>> Ming is looking for.
> >>
> >> Was this overhead reported somewhere ?
> > 
> > The syscall of gettimeofday() calls ktime_get_real_ts64() which finally
> > calls tk_clock_read() which calls rdtsc too.
> > 
> > But gettimeofday() is often used in fast path, and block IO_STAT needs to
> > read it too.
> > 
> >>
> >>> See also irqtime_account_irq() in kernel/sched/cputime.c.
> >>
> >> From my POV, this framework could be interesting to detect this situation.
> > 
> > Now we are talking about IRQ_TIME_ACCOUNTING instead of IRQ_TIMINGS, and the
> > former one could be used to implement the detection. And the only sharing
> > should be the read of timestamp.
> 
> You did not share yet the analysis of the problem (the kernel warnings
> give the symptoms) and gave the reasoning for the solution. It is hard
> to understand what you are looking for exactly and how to connect the dots.

Let me explain it one more time:

When one IRQ flood happens on one CPU:

1) softirq handling on this CPU can't make progress

2) kernel thread bound to this CPU can't make progress

For example, network may require softirq to xmit packets, or another irq
thread for handling keyboards/mice or whatever, or rcu_sched may depend
on that CPU for making progress, then the irq flood stalls the whole
system.

> 
> AFAIU, there are fast medium where the responses to requests are faster
> than the time to process them, right?

Usually medium may not be faster than CPU, now we are talking about
interrupts, which can be originated from lots of devices concurrently,
for example, in Long Li'test, there are 8 NVMe drives involved.

> 
> I don't see how detecting IRQ flooding and use a threaded irq is the
> solution, can you explain?

When IRQ flood is detected, we reserve a bit little time for providing
chance to make softirq/threads scheduled by scheduler, then the above
problem can be avoided.

> 
> If the responses are coming at a very high rate, whatever the solution
> (interrupts, threaded interrupts, polling), we are still in the same
> situation.

When we moving the interrupt handling into irq thread, other softirq/
threaded interrupt/thread gets chance to be scheduled, so we can avoid
to stall the whole system.

> 
> My suggestion was initially to see if the interrupt load will be taken
> into accounts in the cpu load and favorize task migration with the
> scheduler load balance to a less loaded CPU, thus the CPU processing
> interrupts will end up doing only that while other CPUs will handle the
> "threaded" side.
> 
> Beside that, I'm wondering if the block scheduler should be somehow
> involved in that [1]

For NVMe or any multi-queue storage, the default scheduler is 'none',
which basically does nothing except for submitting IO asap.


Thanks,
Ming
