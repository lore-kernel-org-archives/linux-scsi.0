Return-Path: <SRS0=3hcu=W6=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B45DC3A5A5
	for <linux-scsi@archiver.kernel.org>; Tue,  3 Sep 2019 03:30:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 56975207E0
	for <linux-scsi@archiver.kernel.org>; Tue,  3 Sep 2019 03:30:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726200AbfICDaY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 2 Sep 2019 23:30:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48956 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725839AbfICDaY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 2 Sep 2019 23:30:24 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 7A7D948FD;
        Tue,  3 Sep 2019 03:30:23 +0000 (UTC)
Received: from ming.t460p (ovpn-8-19.pek2.redhat.com [10.72.8.19])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id AAF345C21A;
        Tue,  3 Sep 2019 03:30:13 +0000 (UTC)
Date:   Tue, 3 Sep 2019 11:30:08 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Long Li <longli@microsoft.com>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Keith Busch <keith.busch@intel.com>, Jens Axboe <axboe@fb.com>,
        Christoph Hellwig <hch@lst.de>,
        Sagi Grimberg <sagi@grimberg.me>,
        John Garry <john.garry@huawei.com>,
        Hannes Reinecke <hare@suse.com>,
        linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Subject: Re: [PATCH 1/4] softirq: implement IRQ flood detection mechanism
Message-ID: <20190903033001.GB23861@ming.t460p>
References: <20190827085344.30799-1-ming.lei@redhat.com>
 <20190827085344.30799-2-ming.lei@redhat.com>
 <alpine.DEB.2.21.1908271633450.1939@nanos.tec.linutronix.de>
 <20190827225827.GA5263@ming.t460p>
 <alpine.DEB.2.21.1908280104330.1939@nanos.tec.linutronix.de>
 <20190828110633.GC15524@ming.t460p>
 <alpine.DEB.2.21.1908281316230.1869@nanos.tec.linutronix.de>
 <20190828135054.GA23861@ming.t460p>
 <alpine.DEB.2.21.1908281605190.23149@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.21.1908281605190.23149@nanos.tec.linutronix.de>
User-Agent: Mutt/1.11.3 (2019-02-01)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.71]); Tue, 03 Sep 2019 03:30:23 +0000 (UTC)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Aug 28, 2019 at 04:07:19PM +0200, Thomas Gleixner wrote:
> On Wed, 28 Aug 2019, Ming Lei wrote:
> > On Wed, Aug 28, 2019 at 01:23:06PM +0200, Thomas Gleixner wrote:
> > > On Wed, 28 Aug 2019, Ming Lei wrote:
> > > > On Wed, Aug 28, 2019 at 01:09:44AM +0200, Thomas Gleixner wrote:
> > > > > > > Also how is that supposed to work when sched_clock is jiffies based?
> > > > > > 
> > > > > > Good catch, looks ktime_get_ns() is needed.
> > > > > 
> > > > > And what is ktime_get_ns() returning when the only available clocksource is
> > > > > jiffies?
> > > > 
> > > > IMO, it isn't one issue. If the only clocksource is jiffies, we needn't to
> > > > expect high IO performance. Then it is fine to always handle the irq in
> > > > interrupt context or thread context.
> > > > 
> > > > However, if it can be recognized runtime, irq_flood_detected() can
> > > > always return true or false.
> > > 
> > > Right. The clocksource is determined at runtime. And if there is no high
> > > resolution clocksource then that function will return crap.
> > 
> > This patch still works even though the only clocksource is jiffies.
> 
> Works by some definition of works, right?

I am not sure there is such system which doesn't provide any high resolution
clocksource, meantime there is one high performance storage device
attached, and expect top IO performance can be reached.

Suppose there is such system: I mean that irq_flood_detected() returns either
true or false, then the actual IO performance should be accepted on
system without high resolution clocksource from user view.

> 
> > > Well, yes. But it's trivial enough to utilize parts of it for your
> > > purposes.
> > 
> > >From the code of kernel/irq/timing.c:
> > 
> > 1) record_irq_time() only records the start time of one irq, and not
> > consider the time taken in interrupt handler, so we can't figure out
> > the real interval between two do_IRQ() on one CPU
> 
> I said utilize and that means that the infrastructure can be used and
> extended. I did not say that it solves your problem, right?

The infrastructure is for predicating when the next interrupt comes,
which is used in PM cases(usually for mobile phone or power sensitive
cases). However, IRQ flood is used in high performance system(usually
enterprise case). The two use cases are actually orthogonal, also:

1) if the irq timing infrastructure is used, we have to apply the
management code on irq flood detection, for example, we have to
build the irq timing code in kernel and enable it. Then performance
regression might be caused for enterprise application.

2) irq timing's runtime overload is much higher, irq_timings_push()
touches much more memory footprint, since it records recent 32
irq's timestamp. That isn't what IRQ flood detection wants, also
not enough for flood detection.

3) irq flood detection itself is very simple, just one EWMA
calculation, see the following code:

irq_update_interval() (called from irq_enter())
        int cpu = raw_smp_processor_id();
        struct irq_interval *inter = per_cpu_ptr(&avg_irq_interval, cpu);
        u64 delta = sched_clock_cpu(cpu) - inter->last_irq_end;

        inter->avg = (inter->avg * IRQ_INTERVAL_EWMA_PREV_FACTOR +
                delta * IRQ_INTERVAL_EWMA_CURR_FACTOR) /
                IRQ_INTERVAL_EWMA_WEIGHT;

bool irq_flood_detected(void) (called from __handle_irq_event_percpu())
{
        return raw_cpu_ptr(&avg_irq_interval)->avg <= IRQ_FLOOD_THRESHOLD_NS;
}

irq_exit()
	inter->last_irq_end = sched_clock_cpu(smp_processor_id());

So there is basically nothing shared between the two, only one percpu
variable is needed for detecting irq flood.

> 
> > 2) irq/timing doesn't cover softirq
> 
> That's solvable, right?

Yeah, we can extend irq/timing, but ugly for irq/timing, since irq/timing
focuses on hardirq predication, and softirq isn't involved in that
purpose.

>  
> > Daniel, could you take a look and see if irq flood detection can be
> > implemented easily by irq/timing.c?
> 
> I assume you can take a look as well, right?

Yeah, I have looked at the code for a while, but I think that irq/timing
could become complicated unnecessarily for covering irq flood detection,
meantime it is much less efficient for detecting IRQ flood.

thanks,
Ming
