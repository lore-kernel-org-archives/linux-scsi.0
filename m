Return-Path: <SRS0=d3SH=WY=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83F7CC3A5A1
	for <linux-scsi@archiver.kernel.org>; Wed, 28 Aug 2019 13:51:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 613A822CF5
	for <linux-scsi@archiver.kernel.org>; Wed, 28 Aug 2019 13:51:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726429AbfH1NvN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 28 Aug 2019 09:51:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12416 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726368AbfH1NvM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 28 Aug 2019 09:51:12 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 518743175296;
        Wed, 28 Aug 2019 13:51:12 +0000 (UTC)
Received: from ming.t460p (ovpn-8-28.pek2.redhat.com [10.72.8.28])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id EFACD60C5D;
        Wed, 28 Aug 2019 13:50:59 +0000 (UTC)
Date:   Wed, 28 Aug 2019 21:50:55 +0800
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
Message-ID: <20190828135054.GA23861@ming.t460p>
References: <20190827085344.30799-1-ming.lei@redhat.com>
 <20190827085344.30799-2-ming.lei@redhat.com>
 <alpine.DEB.2.21.1908271633450.1939@nanos.tec.linutronix.de>
 <20190827225827.GA5263@ming.t460p>
 <alpine.DEB.2.21.1908280104330.1939@nanos.tec.linutronix.de>
 <20190828110633.GC15524@ming.t460p>
 <alpine.DEB.2.21.1908281316230.1869@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.21.1908281316230.1869@nanos.tec.linutronix.de>
User-Agent: Mutt/1.11.3 (2019-02-01)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.49]); Wed, 28 Aug 2019 13:51:12 +0000 (UTC)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Aug 28, 2019 at 01:23:06PM +0200, Thomas Gleixner wrote:
> On Wed, 28 Aug 2019, Ming Lei wrote:
> > On Wed, Aug 28, 2019 at 01:09:44AM +0200, Thomas Gleixner wrote:
> > > > > Also how is that supposed to work when sched_clock is jiffies based?
> > > > 
> > > > Good catch, looks ktime_get_ns() is needed.
> > > 
> > > And what is ktime_get_ns() returning when the only available clocksource is
> > > jiffies?
> > 
> > IMO, it isn't one issue. If the only clocksource is jiffies, we needn't to
> > expect high IO performance. Then it is fine to always handle the irq in
> > interrupt context or thread context.
> > 
> > However, if it can be recognized runtime, irq_flood_detected() can
> > always return true or false.
> 
> Right. The clocksource is determined at runtime. And if there is no high
> resolution clocksource then that function will return crap.

This patch still works even though the only clocksource is jiffies.

>  
> > > No. Talk to Daniel. There is not going to be yet another ad hoc thingy just
> > > to make block happy.
> > 
> > I just take a first glance at the code of 'interrupt timing', and its
> > motivation is to predicate of the next occurrence of interested interrupt
> > for use cases of PM, such as predicate wakeup time.
> > 
> > And predication could be one much more difficult thing, and its implementation
> > requires to record more info: such as irq number, recent multiple irq timestamps,
> > that means its overhead is a bit high. Meantime IRQS_TIMINGS should only be set
> > on interested interrupt(s).
> 
> Well, yes. But it's trivial enough to utilize parts of it for your
> purposes.

From the code of kernel/irq/timing.c:

1) record_irq_time() only records the start time of one irq, and not
consider the time taken in interrupt handler, so we can't figure out
the real interval between two do_IRQ() on one CPU

2) irq/timing doesn't cover softirq

Daniel, could you take a look and see if irq flood detection can be
implemented easily by irq/timing.c?


thanks,
Ming
