Return-Path: <SRS0=d3SH=WY=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5ADE2C3A5A1
	for <linux-scsi@archiver.kernel.org>; Wed, 28 Aug 2019 14:07:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 32F9E2189D
	for <linux-scsi@archiver.kernel.org>; Wed, 28 Aug 2019 14:07:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726603AbfH1OH6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 28 Aug 2019 10:07:58 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:47429 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726410AbfH1OH6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 28 Aug 2019 10:07:58 -0400
Received: from [5.158.153.52] (helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1i2ybc-0005Vf-Ga; Wed, 28 Aug 2019 16:07:24 +0200
Date:   Wed, 28 Aug 2019 16:07:19 +0200 (CEST)
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
In-Reply-To: <20190828135054.GA23861@ming.t460p>
Message-ID: <alpine.DEB.2.21.1908281605190.23149@nanos.tec.linutronix.de>
References: <20190827085344.30799-1-ming.lei@redhat.com> <20190827085344.30799-2-ming.lei@redhat.com> <alpine.DEB.2.21.1908271633450.1939@nanos.tec.linutronix.de> <20190827225827.GA5263@ming.t460p> <alpine.DEB.2.21.1908280104330.1939@nanos.tec.linutronix.de>
 <20190828110633.GC15524@ming.t460p> <alpine.DEB.2.21.1908281316230.1869@nanos.tec.linutronix.de> <20190828135054.GA23861@ming.t460p>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 28 Aug 2019, Ming Lei wrote:
> On Wed, Aug 28, 2019 at 01:23:06PM +0200, Thomas Gleixner wrote:
> > On Wed, 28 Aug 2019, Ming Lei wrote:
> > > On Wed, Aug 28, 2019 at 01:09:44AM +0200, Thomas Gleixner wrote:
> > > > > > Also how is that supposed to work when sched_clock is jiffies based?
> > > > > 
> > > > > Good catch, looks ktime_get_ns() is needed.
> > > > 
> > > > And what is ktime_get_ns() returning when the only available clocksource is
> > > > jiffies?
> > > 
> > > IMO, it isn't one issue. If the only clocksource is jiffies, we needn't to
> > > expect high IO performance. Then it is fine to always handle the irq in
> > > interrupt context or thread context.
> > > 
> > > However, if it can be recognized runtime, irq_flood_detected() can
> > > always return true or false.
> > 
> > Right. The clocksource is determined at runtime. And if there is no high
> > resolution clocksource then that function will return crap.
> 
> This patch still works even though the only clocksource is jiffies.

Works by some definition of works, right?

> > Well, yes. But it's trivial enough to utilize parts of it for your
> > purposes.
> 
> >From the code of kernel/irq/timing.c:
> 
> 1) record_irq_time() only records the start time of one irq, and not
> consider the time taken in interrupt handler, so we can't figure out
> the real interval between two do_IRQ() on one CPU

I said utilize and that means that the infrastructure can be used and
extended. I did not say that it solves your problem, right?

> 2) irq/timing doesn't cover softirq

That's solvable, right?
 
> Daniel, could you take a look and see if irq flood detection can be
> implemented easily by irq/timing.c?

I assume you can take a look as well, right?

Thanks,

	tglx
