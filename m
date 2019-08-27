Return-Path: <SRS0=cdy6=WX=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE6E7C3A5A3
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Aug 2019 16:19:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8DE7321883
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Aug 2019 16:19:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728834AbfH0QTr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 27 Aug 2019 12:19:47 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:44288 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726621AbfH0QTq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 27 Aug 2019 12:19:46 -0400
Received: from p5de0b6c5.dip0.t-ipconnect.de ([93.224.182.197] helo=nanos)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1i2eBS-0002Hz-3S; Tue, 27 Aug 2019 18:19:02 +0200
Date:   Tue, 27 Aug 2019 18:19:00 +0200 (CEST)
From:   Thomas Gleixner <tglx@linutronix.de>
To:     Ming Lei <ming.lei@redhat.com>
cc:     LKML <linux-kernel@vger.kernel.org>,
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
In-Reply-To: <alpine.DEB.2.21.1908271633450.1939@nanos.tec.linutronix.de>
Message-ID: <alpine.DEB.2.21.1908271817180.1939@nanos.tec.linutronix.de>
References: <20190827085344.30799-1-ming.lei@redhat.com> <20190827085344.30799-2-ming.lei@redhat.com> <alpine.DEB.2.21.1908271633450.1939@nanos.tec.linutronix.de>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 27 Aug 2019, Thomas Gleixner wrote:
> On Tue, 27 Aug 2019, Ming Lei wrote:
> > +/*
> > + * Update average irq interval with the Exponential Weighted Moving
> > + * Average(EWMA)
> > + */
> > +static void irq_update_interval(void)
> > +{
> > +#define IRQ_INTERVAL_EWMA_WEIGHT	128
> > +#define IRQ_INTERVAL_EWMA_PREV_FACTOR	127
> > +#define IRQ_INTERVAL_EWMA_CURR_FACTOR	(IRQ_INTERVAL_EWMA_WEIGHT - \
> > +		IRQ_INTERVAL_EWMA_PREV_FACTOR)
> 
> Please do not stick defines into a function body. That's horrible.
> 
> > +
> > +	int cpu = raw_smp_processor_id();
> > +	struct irq_interval *inter = per_cpu_ptr(&avg_irq_interval, cpu);
> > +	u64 delta = sched_clock_cpu(cpu) - inter->last_irq_end;
> 
> Why are you doing that raw_smp_processor_id() dance? The call site has
> interrupts and preemption disabled.
> 
> Also how is that supposed to work when sched_clock is jiffies based?
> 
> > +	inter->avg = (inter->avg * IRQ_INTERVAL_EWMA_PREV_FACTOR +
> > +		delta * IRQ_INTERVAL_EWMA_CURR_FACTOR) /
> > +		IRQ_INTERVAL_EWMA_WEIGHT;
> 
> We definitely are not going to have a 64bit multiplication and division on
> every interrupt. Asided of that this breaks 32bit builds all over the place.

That said, we already have infrastructure for something like this in the
core interrupt code which is optimized to be lightweight in the fast path.

kernel/irq/timings.c

Talk to Daniel Lezcano (Cc'ed) how you can (ab)use that.

Thanks,

	tglx
