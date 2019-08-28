Return-Path: <SRS0=d3SH=WY=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2F58C3A5A1
	for <linux-scsi@archiver.kernel.org>; Wed, 28 Aug 2019 11:06:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 94B59208CB
	for <linux-scsi@archiver.kernel.org>; Wed, 28 Aug 2019 11:06:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726310AbfH1LGu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 28 Aug 2019 07:06:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56100 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725991AbfH1LGt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 28 Aug 2019 07:06:49 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 436273087958;
        Wed, 28 Aug 2019 11:06:49 +0000 (UTC)
Received: from ming.t460p (ovpn-8-32.pek2.redhat.com [10.72.8.32])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C6336194B2;
        Wed, 28 Aug 2019 11:06:39 +0000 (UTC)
Date:   Wed, 28 Aug 2019 19:06:34 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     linux-kernel@vger.kernel.org, Long Li <longli@microsoft.com>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Keith Busch <keith.busch@intel.com>, Jens Axboe <axboe@fb.com>,
        Christoph Hellwig <hch@lst.de>,
        Sagi Grimberg <sagi@grimberg.me>,
        John Garry <john.garry@huawei.com>,
        Hannes Reinecke <hare@suse.com>,
        linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH 1/4] softirq: implement IRQ flood detection mechanism
Message-ID: <20190828110633.GC15524@ming.t460p>
References: <20190827085344.30799-1-ming.lei@redhat.com>
 <20190827085344.30799-2-ming.lei@redhat.com>
 <alpine.DEB.2.21.1908271633450.1939@nanos.tec.linutronix.de>
 <20190827225827.GA5263@ming.t460p>
 <alpine.DEB.2.21.1908280104330.1939@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.21.1908280104330.1939@nanos.tec.linutronix.de>
User-Agent: Mutt/1.11.3 (2019-02-01)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.45]); Wed, 28 Aug 2019 11:06:49 +0000 (UTC)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Aug 28, 2019 at 01:09:44AM +0200, Thomas Gleixner wrote:
> On Wed, 28 Aug 2019, Ming Lei wrote:
> > On Tue, Aug 27, 2019 at 04:42:02PM +0200, Thomas Gleixner wrote:
> > > On Tue, 27 Aug 2019, Ming Lei wrote:
> > > > +
> > > > +	int cpu = raw_smp_processor_id();
> > > > +	struct irq_interval *inter = per_cpu_ptr(&avg_irq_interval, cpu);
> > > > +	u64 delta = sched_clock_cpu(cpu) - inter->last_irq_end;
> > > 
> > > Why are you doing that raw_smp_processor_id() dance? The call site has
> > > interrupts and preemption disabled.
> > 
> > OK, will change to __smp_processor_id().
> 
> You do not need smp_processor_id() as all.

OK.

> 
> > > Also how is that supposed to work when sched_clock is jiffies based?
> > 
> > Good catch, looks ktime_get_ns() is needed.
> 
> And what is ktime_get_ns() returning when the only available clocksource is
> jiffies?

IMO, it isn't one issue. If the only clocksource is jiffies, we needn't to
expect high IO performance. Then it is fine to always handle the irq in
interrupt context or thread context.

However, if it can be recognized runtime, irq_flood_detected() can
always return true or false.

> 
> > > 
> > > > +	inter->avg = (inter->avg * IRQ_INTERVAL_EWMA_PREV_FACTOR +
> > > > +		delta * IRQ_INTERVAL_EWMA_CURR_FACTOR) /
> > > > +		IRQ_INTERVAL_EWMA_WEIGHT;
> > > 
> > > We definitely are not going to have a 64bit multiplication and division on
> > > every interrupt. Asided of that this breaks 32bit builds all over the place.
> > 
> > I will convert the above into add/subtract/shift only.
> 
> No. Talk to Daniel. There is not going to be yet another ad hoc thingy just
> to make block happy.

I just take a first glance at the code of 'interrupt timing', and its
motivation is to predicate of the next occurrence of interested interrupt
for use cases of PM, such as predicate wakeup time.

And predication could be one much more difficult thing, and its implementation
requires to record more info: such as irq number, recent multiple irq timestamps,
that means its overhead is a bit high. Meantime IRQS_TIMINGS should only be set
on interested interrupt(s).

Yeah, irq timing uses the Exponential Weighted Moving Average(EWMA) for computing
average irq interval for each interrupt.

So either motivation or approaches taken are totally different between
irq timing and irq flood detection.

Daniel, correct me if I am wrong.

For the case of detecting IRQ flood, we only need to sum the average
interval of any do_IRQ() on each CPU, and the overhead is quite low since
just two read & write on one percpu varible is required. We don't
care what the exact irq number is. However, we have to account time
taken by softirq handler, which can't be covered by interrupt timing.

Also it is quite simple to use EWMA to compute average interrupt
interval, however we can't reuse irq timing's result which is done on
each irq. IRQ flood detection simply computes the average interval
of any do_IRQ() on each CPU for covering handling interrupt and softirq.

> 
> And aside of that why does block not have a "NAPI" mode which was
> explicitely designed to avoid all that?

Block layer knows nothing about interrupt, even don't know which context
is run for completing IO request, which is decided by driver, could
be interrupt context, softirq context, or process context.

Also it is hard for block layer to figure out when IRQ flood is triggered.
CPU is shared resource, all kinds of interrupt sources may contribute
some for IRQ flood. That is why this patch implements the detection
mechanism in genirq/softirq code.

In theory, this patch provides one simple generic mechanism for avoiding
IRQ flood/CPU lockup, which could be used for any devices, not only high
performance storage.


Thanks,
Ming
