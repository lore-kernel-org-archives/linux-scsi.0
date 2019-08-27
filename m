Return-Path: <SRS0=cdy6=WX=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE8F2C3A5A3
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Aug 2019 23:10:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9D30020856
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Aug 2019 23:10:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726243AbfH0XKa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 27 Aug 2019 19:10:30 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:45346 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726030AbfH0XK3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 27 Aug 2019 19:10:29 -0400
Received: from p5de0b6c5.dip0.t-ipconnect.de ([93.224.182.197] helo=nanos)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1i2kav-0005Z5-8r; Wed, 28 Aug 2019 01:09:45 +0200
Date:   Wed, 28 Aug 2019 01:09:44 +0200 (CEST)
From:   Thomas Gleixner <tglx@linutronix.de>
To:     Ming Lei <ming.lei@redhat.com>
cc:     linux-kernel@vger.kernel.org, Long Li <longli@microsoft.com>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Keith Busch <keith.busch@intel.com>, Jens Axboe <axboe@fb.com>,
        Christoph Hellwig <hch@lst.de>,
        Sagi Grimberg <sagi@grimberg.me>,
        John Garry <john.garry@huawei.com>,
        Hannes Reinecke <hare@suse.com>,
        linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH 1/4] softirq: implement IRQ flood detection mechanism
In-Reply-To: <20190827225827.GA5263@ming.t460p>
Message-ID: <alpine.DEB.2.21.1908280104330.1939@nanos.tec.linutronix.de>
References: <20190827085344.30799-1-ming.lei@redhat.com> <20190827085344.30799-2-ming.lei@redhat.com> <alpine.DEB.2.21.1908271633450.1939@nanos.tec.linutronix.de> <20190827225827.GA5263@ming.t460p>
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

On Wed, 28 Aug 2019, Ming Lei wrote:
> On Tue, Aug 27, 2019 at 04:42:02PM +0200, Thomas Gleixner wrote:
> > On Tue, 27 Aug 2019, Ming Lei wrote:
> > > +
> > > +	int cpu = raw_smp_processor_id();
> > > +	struct irq_interval *inter = per_cpu_ptr(&avg_irq_interval, cpu);
> > > +	u64 delta = sched_clock_cpu(cpu) - inter->last_irq_end;
> > 
> > Why are you doing that raw_smp_processor_id() dance? The call site has
> > interrupts and preemption disabled.
> 
> OK, will change to __smp_processor_id().

You do not need smp_processor_id() as all.

> > Also how is that supposed to work when sched_clock is jiffies based?
> 
> Good catch, looks ktime_get_ns() is needed.

And what is ktime_get_ns() returning when the only available clocksource is
jiffies?

> > 
> > > +	inter->avg = (inter->avg * IRQ_INTERVAL_EWMA_PREV_FACTOR +
> > > +		delta * IRQ_INTERVAL_EWMA_CURR_FACTOR) /
> > > +		IRQ_INTERVAL_EWMA_WEIGHT;
> > 
> > We definitely are not going to have a 64bit multiplication and division on
> > every interrupt. Asided of that this breaks 32bit builds all over the place.
> 
> I will convert the above into add/subtract/shift only.

No. Talk to Daniel. There is not going to be yet another ad hoc thingy just
to make block happy.

And aside of that why does block not have a "NAPI" mode which was
explicitely designed to avoid all that?

Thanks,

	tglx
