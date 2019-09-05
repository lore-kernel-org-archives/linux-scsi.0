Return-Path: <SRS0=/77Q=XA=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A1F1C3A5A5
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Sep 2019 09:11:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0D49D21848
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Sep 2019 09:11:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731558AbfIEJLT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 5 Sep 2019 05:11:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38230 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731167AbfIEJLT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 5 Sep 2019 05:11:19 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 60DC93007C23;
        Thu,  5 Sep 2019 09:11:19 +0000 (UTC)
Received: from ming.t460p (ovpn-8-16.pek2.redhat.com [10.72.8.16])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 18A8D5D9CA;
        Thu,  5 Sep 2019 09:11:08 +0000 (UTC)
Date:   Thu, 5 Sep 2019 17:11:04 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Keith Busch <keith.busch@intel.com>,
        Hannes Reinecke <hare@suse.com>,
        Sagi Grimberg <sagi@grimberg.me>, linux-scsi@vger.kernel.org,
        Long Li <longli@microsoft.com>,
        John Garry <john.garry@huawei.com>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-nvme@lists.infradead.org, Jens Axboe <axboe@fb.com>,
        Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 1/4] softirq: implement IRQ flood detection mechanism
Message-ID: <20190905091103.GC4432@ming.t460p>
References: <299fb6b5-d414-2e71-1dd2-9d6e34ee1c79@linaro.org>
 <20190903063125.GA21022@ming.t460p>
 <6b88719c-782a-4a63-db9f-bf62734a7874@linaro.org>
 <20190903072848.GA22170@ming.t460p>
 <dd96def4-1121-afbe-2431-9e516a06850c@linaro.org>
 <6f3b6557-1767-8c80-f786-1ea667179b39@acm.org>
 <2a8bd278-5384-d82f-c09b-4fce236d2d95@linaro.org>
 <de16de12-fa1a-666c-ea19-fea5d096c1ca@acm.org>
 <20190904180211.GX2332@hirez.programming.kicks-ass.net>
 <9b924e48-e217-9c11-c1fb-46c92a82ea2d@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9b924e48-e217-9c11-c1fb-46c92a82ea2d@acm.org>
User-Agent: Mutt/1.11.3 (2019-02-01)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.40]); Thu, 05 Sep 2019 09:11:19 +0000 (UTC)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Sep 04, 2019 at 12:47:13PM -0700, Bart Van Assche wrote:
> On 9/4/19 11:02 AM, Peter Zijlstra wrote:
> > On Wed, Sep 04, 2019 at 10:38:59AM -0700, Bart Van Assche wrote:
> > > I think it is widely known that rdtsc is a relatively slow x86 instruction.
> > > So I expect that using that instruction will cause a measurable overhead if
> > > it is called frequently enough. I'm not aware of any publicly available
> > > measurement data however.
> > 
> > https://www.agner.org/optimize/instruction_tables.pdf
> > 
> > RDTSC, Ryzen: ~36
> > RDTSC, Skylake: ~20
> > 
> > Sadly those same tables don't list the cost of actual exceptions or even
> > IRET :/
> 
> Thanks Peter for having looked up these numbers. These numbers are much
> better than last time I checked. Ming, would CONFIG_IRQ_TIME_ACCOUNTING help
> your workload?

In my fio test on azure L80sv2, IRQ_TIME_ACCOUNTING isn't enabled.
However the irq flood detection introduces two RDTSC for each do_IRQ(),
not see obvious IOPS difference.

Thanks,
Ming
