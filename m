Return-Path: <SRS0=cdy6=WX=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F94FC3A5A3
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Aug 2019 23:05:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 80950214DA
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Aug 2019 23:05:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726340AbfH0XFL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 27 Aug 2019 19:05:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51492 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725992AbfH0XFL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 27 Aug 2019 19:05:11 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 29CCF85365;
        Tue, 27 Aug 2019 23:05:11 +0000 (UTC)
Received: from ming.t460p (ovpn-8-16.pek2.redhat.com [10.72.8.16])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id DD67560F82;
        Tue, 27 Aug 2019 23:04:57 +0000 (UTC)
Date:   Wed, 28 Aug 2019 07:04:52 +0800
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
Message-ID: <20190827230451.GB5263@ming.t460p>
References: <20190827085344.30799-1-ming.lei@redhat.com>
 <20190827085344.30799-2-ming.lei@redhat.com>
 <alpine.DEB.2.21.1908271633450.1939@nanos.tec.linutronix.de>
 <alpine.DEB.2.21.1908271817180.1939@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.21.1908271817180.1939@nanos.tec.linutronix.de>
User-Agent: Mutt/1.11.3 (2019-02-01)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.25]); Tue, 27 Aug 2019 23:05:11 +0000 (UTC)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Aug 27, 2019 at 06:19:00PM +0200, Thomas Gleixner wrote:
> On Tue, 27 Aug 2019, Thomas Gleixner wrote:
> > On Tue, 27 Aug 2019, Ming Lei wrote:
> > > +/*
> > > + * Update average irq interval with the Exponential Weighted Moving
> > > + * Average(EWMA)
> > > + */
> > > +static void irq_update_interval(void)
> > > +{
> > > +#define IRQ_INTERVAL_EWMA_WEIGHT	128
> > > +#define IRQ_INTERVAL_EWMA_PREV_FACTOR	127
> > > +#define IRQ_INTERVAL_EWMA_CURR_FACTOR	(IRQ_INTERVAL_EWMA_WEIGHT - \
> > > +		IRQ_INTERVAL_EWMA_PREV_FACTOR)
> > 
> > Please do not stick defines into a function body. That's horrible.
> > 
> > > +
> > > +	int cpu = raw_smp_processor_id();
> > > +	struct irq_interval *inter = per_cpu_ptr(&avg_irq_interval, cpu);
> > > +	u64 delta = sched_clock_cpu(cpu) - inter->last_irq_end;
> > 
> > Why are you doing that raw_smp_processor_id() dance? The call site has
> > interrupts and preemption disabled.
> > 
> > Also how is that supposed to work when sched_clock is jiffies based?
> > 
> > > +	inter->avg = (inter->avg * IRQ_INTERVAL_EWMA_PREV_FACTOR +
> > > +		delta * IRQ_INTERVAL_EWMA_CURR_FACTOR) /
> > > +		IRQ_INTERVAL_EWMA_WEIGHT;
> > 
> > We definitely are not going to have a 64bit multiplication and division on
> > every interrupt. Asided of that this breaks 32bit builds all over the place.
> 
> That said, we already have infrastructure for something like this in the
> core interrupt code which is optimized to be lightweight in the fast path.
> 
> kernel/irq/timings.c

irq/timings.c is much more complicated, especially it applies EWMA to
compute each irq's average interval. However, we only need it for
do_IRQ() to cover all interrupt & softirq handler.

Also CONFIG_IRQ_TIMINGS is usually disabled on distributions.

thanks,
Ming
