Return-Path: <SRS0=/77Q=XA=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDC6BC3A5A5
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Sep 2019 09:06:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9FFDA2082E
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Sep 2019 09:06:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732160AbfIEJGf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 5 Sep 2019 05:06:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46610 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731737AbfIEJGf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 5 Sep 2019 05:06:35 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 80E5E8A1C9D;
        Thu,  5 Sep 2019 09:06:34 +0000 (UTC)
Received: from ming.t460p (ovpn-8-16.pek2.redhat.com [10.72.8.16])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 4053E5D9CA;
        Thu,  5 Sep 2019 09:06:23 +0000 (UTC)
Date:   Thu, 5 Sep 2019 17:06:19 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Daniel Lezcano <daniel.lezcano@linaro.org>
Cc:     Bart Van Assche <bvanassche@acm.org>, Jens Axboe <axboe@fb.com>,
        Hannes Reinecke <hare@suse.com>,
        Sagi Grimberg <sagi@grimberg.me>, linux-scsi@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Long Li <longli@microsoft.com>,
        John Garry <john.garry@huawei.com>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-nvme@lists.infradead.org,
        Keith Busch <keith.busch@intel.com>,
        Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 1/4] softirq: implement IRQ flood detection mechanism
Message-ID: <20190905090617.GB4432@ming.t460p>
References: <20190828135054.GA23861@ming.t460p>
 <alpine.DEB.2.21.1908281605190.23149@nanos.tec.linutronix.de>
 <20190903033001.GB23861@ming.t460p>
 <299fb6b5-d414-2e71-1dd2-9d6e34ee1c79@linaro.org>
 <20190903063125.GA21022@ming.t460p>
 <6b88719c-782a-4a63-db9f-bf62734a7874@linaro.org>
 <20190903072848.GA22170@ming.t460p>
 <dd96def4-1121-afbe-2431-9e516a06850c@linaro.org>
 <6f3b6557-1767-8c80-f786-1ea667179b39@acm.org>
 <2a8bd278-5384-d82f-c09b-4fce236d2d95@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2a8bd278-5384-d82f-c09b-4fce236d2d95@linaro.org>
User-Agent: Mutt/1.11.3 (2019-02-01)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.69]); Thu, 05 Sep 2019 09:06:34 +0000 (UTC)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Sep 04, 2019 at 07:31:48PM +0200, Daniel Lezcano wrote:
> Hi,
> 
> On 04/09/2019 19:07, Bart Van Assche wrote:
> > On 9/3/19 12:50 AM, Daniel Lezcano wrote:
> >> On 03/09/2019 09:28, Ming Lei wrote:
> >>> On Tue, Sep 03, 2019 at 08:40:35AM +0200, Daniel Lezcano wrote:
> >>>> It is a scheduler problem then ?
> >>>
> >>> Scheduler can do nothing if the CPU is taken completely by handling
> >>> interrupt & softirq, so seems not a scheduler problem, IMO.
> >>
> >> Why? If there is a irq pressure on one CPU reducing its capacity, the
> >> scheduler will balance the tasks on another CPU, no?
> > 
> > Only if CONFIG_IRQ_TIME_ACCOUNTING has been enabled. However, I don't
> > know any Linux distro that enables that option. That's probably because
> > that option introduces two rdtsc() calls in each interrupt. Given the
> > overhead introduced by this option, I don't think this is the solution
> > Ming is looking for.
> 
> Was this overhead reported somewhere ?

The syscall of gettimeofday() calls ktime_get_real_ts64() which finally
calls tk_clock_read() which calls rdtsc too.

But gettimeofday() is often used in fast path, and block IO_STAT needs to
read it too.

> 
> > See also irqtime_account_irq() in kernel/sched/cputime.c.
> 
> From my POV, this framework could be interesting to detect this situation.

Now we are talking about IRQ_TIME_ACCOUNTING instead of IRQ_TIMINGS, and the
former one could be used to implement the detection. And the only sharing
should be the read of timestamp.

Thanks,
Ming
