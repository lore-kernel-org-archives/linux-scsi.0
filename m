Return-Path: <SRS0=3hcu=W6=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63CD6C3A5A5
	for <linux-scsi@archiver.kernel.org>; Tue,  3 Sep 2019 06:31:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4679721897
	for <linux-scsi@archiver.kernel.org>; Tue,  3 Sep 2019 06:31:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727148AbfICGbm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 3 Sep 2019 02:31:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51580 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727025AbfICGbm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 3 Sep 2019 02:31:42 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 031D9A36F07;
        Tue,  3 Sep 2019 06:31:42 +0000 (UTC)
Received: from ming.t460p (ovpn-8-25.pek2.redhat.com [10.72.8.25])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 130595DA5B;
        Tue,  3 Sep 2019 06:31:31 +0000 (UTC)
Date:   Tue, 3 Sep 2019 14:31:26 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Daniel Lezcano <daniel.lezcano@linaro.org>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Long Li <longli@microsoft.com>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Keith Busch <keith.busch@intel.com>, Jens Axboe <axboe@fb.com>,
        Christoph Hellwig <hch@lst.de>,
        Sagi Grimberg <sagi@grimberg.me>,
        John Garry <john.garry@huawei.com>,
        Hannes Reinecke <hare@suse.com>,
        linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH 1/4] softirq: implement IRQ flood detection mechanism
Message-ID: <20190903063125.GA21022@ming.t460p>
References: <20190827085344.30799-2-ming.lei@redhat.com>
 <alpine.DEB.2.21.1908271633450.1939@nanos.tec.linutronix.de>
 <20190827225827.GA5263@ming.t460p>
 <alpine.DEB.2.21.1908280104330.1939@nanos.tec.linutronix.de>
 <20190828110633.GC15524@ming.t460p>
 <alpine.DEB.2.21.1908281316230.1869@nanos.tec.linutronix.de>
 <20190828135054.GA23861@ming.t460p>
 <alpine.DEB.2.21.1908281605190.23149@nanos.tec.linutronix.de>
 <20190903033001.GB23861@ming.t460p>
 <299fb6b5-d414-2e71-1dd2-9d6e34ee1c79@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <299fb6b5-d414-2e71-1dd2-9d6e34ee1c79@linaro.org>
User-Agent: Mutt/1.11.3 (2019-02-01)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.68]); Tue, 03 Sep 2019 06:31:42 +0000 (UTC)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Daniel,

On Tue, Sep 03, 2019 at 07:59:39AM +0200, Daniel Lezcano wrote:
> 
> Hi Ming Lei,
> 
> On 03/09/2019 05:30, Ming Lei wrote:
> 
> [ ... ]
> 
> 
> >>> 2) irq/timing doesn't cover softirq
> >>
> >> That's solvable, right?
> > 
> > Yeah, we can extend irq/timing, but ugly for irq/timing, since irq/timing
> > focuses on hardirq predication, and softirq isn't involved in that
> > purpose.
> > 
> >>  
> >>> Daniel, could you take a look and see if irq flood detection can be
> >>> implemented easily by irq/timing.c?
> >>
> >> I assume you can take a look as well, right?
> > 
> > Yeah, I have looked at the code for a while, but I think that irq/timing
> > could become complicated unnecessarily for covering irq flood detection,
> > meantime it is much less efficient for detecting IRQ flood.
> 
> In the series, there is nothing describing rigorously the problem (I can
> only guess) and why the proposed solution solves it.
> 
> What is your definition of an 'irq flood'? A high irq load? An irq
> arriving while we are processing the previous one in the bottom halves?

So far, it means that handling interrupt & softirq takes all utilization
of one CPU, then processes can't be run on this CPU basically, usually
sort of CPU lockup warning will be triggered.

> 
> The patch 2/4 description says "however IO completion is only done on
> one of these submission CPU cores". That describes the bottleneck and
> then the patch says "Add IRQF_RESCUE_THREAD to create one interrupt
> thread handler", what is the rational between the bottleneck (problem)
> and the irqf_rescue_thread (solution)?

The solution is to switch to handle this interrupt on the created rescue
irq thread context when irq flood is detected, and 'this interrupt' means
the interrupt requested with IRQF_RESCUE_THREAD.

> 
> Is it really the solution to track the irq timings to detect a flood?

The solution tracks the time taken on running do_IRQ() for each CPU.


Thanks,
Ming
