Return-Path: <SRS0=DHhn=XN=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 601A3C4CEC9
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Sep 2019 14:37:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4146621924
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Sep 2019 14:37:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730029AbfIROhs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 18 Sep 2019 10:37:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34886 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725902AbfIROhs (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 18 Sep 2019 10:37:48 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id BB26AA3D38D;
        Wed, 18 Sep 2019 14:37:47 +0000 (UTC)
Received: from ming.t460p (ovpn-8-16.pek2.redhat.com [10.72.8.16])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 5FA5A1001B36;
        Wed, 18 Sep 2019 14:37:37 +0000 (UTC)
Date:   Wed, 18 Sep 2019 22:37:33 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Sagi Grimberg <sagi@grimberg.me>
Cc:     Keith Busch <keith.busch@intel.com>,
        Hannes Reinecke <hare@suse.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Bart Van Assche <bvanassche@acm.org>,
        linux-scsi@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Long Li <longli@microsoft.com>,
        John Garry <john.garry@huawei.com>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-nvme@lists.infradead.org, Jens Axboe <axboe@fb.com>,
        Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 1/4] softirq: implement IRQ flood detection mechanism
Message-ID: <20190918143732.GA19364@ming.t460p>
References: <dd96def4-1121-afbe-2431-9e516a06850c@linaro.org>
 <6f3b6557-1767-8c80-f786-1ea667179b39@acm.org>
 <2a8bd278-5384-d82f-c09b-4fce236d2d95@linaro.org>
 <20190905090617.GB4432@ming.t460p>
 <6a36ccc7-24cd-1d92-fef1-2c5e0f798c36@linaro.org>
 <20190906014819.GB27116@ming.t460p>
 <ffefcfa0-09b6-9af5-f94e-8e7ddd2eef16@linaro.org>
 <6eb2a745-7b92-73ce-46f5-cc6a5ef08abc@grimberg.me>
 <20190907000100.GC12290@ming.t460p>
 <f5685543-8cd5-6c6a-5b80-c77ef09c6b3b@grimberg.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f5685543-8cd5-6c6a-5b80-c77ef09c6b3b@grimberg.me>
User-Agent: Mutt/1.11.3 (2019-02-01)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.68]); Wed, 18 Sep 2019 14:37:48 +0000 (UTC)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Sep 09, 2019 at 08:10:07PM -0700, Sagi Grimberg wrote:
> Hey Ming,
> 
> > > > Ok, so the real problem is per-cpu bounded tasks.
> > > > 
> > > > I share Thomas opinion about a NAPI like approach.
> > > 
> > > We already have that, its irq_poll, but it seems that for this
> > > use-case, we get lower performance for some reason. I'm not
> > > entirely sure why that is, maybe its because we need to mask interrupts
> > > because we don't have an "arm" register in nvme like network devices
> > > have?
> > 
> > Long observed that IOPS drops much too by switching to threaded irq. If
> > softirqd is waken up for handing softirq, the performance shouldn't
> > be better than threaded irq.
> 
> Its true that it shouldn't be any faster, but what irqpoll already has
> and we don't need to reinvent is a proper budgeting mechanism that
> needs to occur when multiple devices map irq vectors to the same cpu
> core.
> 
> irqpoll already maintains a percpu list and dispatch the ->poll with
> a budget that the backend enforces and irqpoll multiplexes between them.
> Having this mechanism in irq (hard or threaded) context sounds
> unnecessary a bit.
> 
> It seems like we're attempting to stay in irq context for as long as we
> can instead of scheduling to softirq/thread context if we have more than
> a minimal amount of work to do. Without at least understanding why
> softirq/thread degrades us so much this code seems like the wrong
> approach to me. Interrupt context will always be faster, but it is
> not a sufficient reason to spend as much time as possible there, is it?

If extra latency is added in IO completion path, this latency will be
introduced in the submission path, because the hw queue depth is fixed,
which is often small. Especially in case of multiple submission vs.
single(shared) completion, the whole hw queue tags can be exhausted
easily. 

I guess no such effect for networking IO.

> 
> We should also keep in mind, that the networking stack has been doing
> this for years, I would try to understand why this cannot work for nvme
> before dismissing.

The above may be one reason.

Thanks,
Ming
