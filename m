Return-Path: <SRS0=yvfi=XB=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA511C43331
	for <linux-scsi@archiver.kernel.org>; Fri,  6 Sep 2019 22:19:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BCCF120854
	for <linux-scsi@archiver.kernel.org>; Fri,  6 Sep 2019 22:19:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404523AbfIFWTi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 6 Sep 2019 18:19:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36972 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729244AbfIFWTh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 6 Sep 2019 18:19:37 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 389CB8AC6F9;
        Fri,  6 Sep 2019 22:19:37 +0000 (UTC)
Received: from ming.t460p (ovpn-8-16.pek2.redhat.com [10.72.8.16])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B7E8F6092F;
        Fri,  6 Sep 2019 22:19:26 +0000 (UTC)
Date:   Sat, 7 Sep 2019 06:19:21 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Long Li <longli@microsoft.com>
Cc:     Keith Busch <kbusch@kernel.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Keith Busch <keith.busch@intel.com>,
        Hannes Reinecke <hare@suse.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        John Garry <john.garry@huawei.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        Jens Axboe <axboe@fb.com>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Christoph Hellwig <hch@lst.de>,
        Sagi Grimberg <sagi@grimberg.me>
Subject: Re: [PATCH 1/4] softirq: implement IRQ flood detection mechanism
Message-ID: <20190906221920.GA12290@ming.t460p>
References: <6b88719c-782a-4a63-db9f-bf62734a7874@linaro.org>
 <20190903072848.GA22170@ming.t460p>
 <dd96def4-1121-afbe-2431-9e516a06850c@linaro.org>
 <6f3b6557-1767-8c80-f786-1ea667179b39@acm.org>
 <2a8bd278-5384-d82f-c09b-4fce236d2d95@linaro.org>
 <20190905090617.GB4432@ming.t460p>
 <6a36ccc7-24cd-1d92-fef1-2c5e0f798c36@linaro.org>
 <20190906014819.GB27116@ming.t460p>
 <20190906141858.GA3953@localhost.localdomain>
 <CY4PR21MB0741091795CEE3D4624977CFCEBA0@CY4PR21MB0741.namprd21.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CY4PR21MB0741091795CEE3D4624977CFCEBA0@CY4PR21MB0741.namprd21.prod.outlook.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.69]); Fri, 06 Sep 2019 22:19:37 +0000 (UTC)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Sep 06, 2019 at 05:50:49PM +0000, Long Li wrote:
> >Subject: Re: [PATCH 1/4] softirq: implement IRQ flood detection mechanism
> >
> >On Fri, Sep 06, 2019 at 09:48:21AM +0800, Ming Lei wrote:
> >> When one IRQ flood happens on one CPU:
> >>
> >> 1) softirq handling on this CPU can't make progress
> >>
> >> 2) kernel thread bound to this CPU can't make progress
> >>
> >> For example, network may require softirq to xmit packets, or another
> >> irq thread for handling keyboards/mice or whatever, or rcu_sched may
> >> depend on that CPU for making progress, then the irq flood stalls the
> >> whole system.
> >>
> >> >
> >> > AFAIU, there are fast medium where the responses to requests are
> >> > faster than the time to process them, right?
> >>
> >> Usually medium may not be faster than CPU, now we are talking about
> >> interrupts, which can be originated from lots of devices concurrently,
> >> for example, in Long Li'test, there are 8 NVMe drives involved.
> >
> >Why are all 8 nvmes sharing the same CPU for interrupt handling?
> >Shouldn't matrix_find_best_cpu_managed() handle selecting the least used
> >CPU from the cpumask for the effective interrupt handling?
> 
> The tests run on 10 NVMe disks on a system of 80 CPUs. Each NVMe disk has 32 hardware queues.

Then there are total 320 NVMe MSI/X vectors, and 80 CPUs, so irq matrix
can't avoid effective CPUs overlapping at all.

> It seems matrix_find_best_cpu_managed() has done its job, but we may still have CPUs that service several hardware queues mapped from other issuing CPUs.
> Another thing to consider is that there may be other managed interrupts on the system, so NVMe interrupts may not end up evenly distributed on such a system.

Another improvement could be to try to not overlap effective CPUs among
vectors of fast device first, meantime allow the overlap between slow
vectors and fast vectors.

This way could improve in case that total fast vectors are <= nr_cpu_cores.

thanks,
Ming
