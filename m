Return-Path: <SRS0=yvfi=XB=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E603CC43331
	for <linux-scsi@archiver.kernel.org>; Fri,  6 Sep 2019 23:13:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C908D207FC
	for <linux-scsi@archiver.kernel.org>; Fri,  6 Sep 2019 23:13:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390355AbfIFXNj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 6 Sep 2019 19:13:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46626 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729017AbfIFXNj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 6 Sep 2019 19:13:39 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 7C1848E2B62;
        Fri,  6 Sep 2019 23:13:38 +0000 (UTC)
Received: from ming.t460p (ovpn-8-16.pek2.redhat.com [10.72.8.16])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id CE8935D721;
        Fri,  6 Sep 2019 23:13:27 +0000 (UTC)
Date:   Sat, 7 Sep 2019 07:13:22 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Keith Busch <kbusch@kernel.org>
Cc:     Long Li <longli@microsoft.com>,
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
Message-ID: <20190906231321.GB12290@ming.t460p>
References: <dd96def4-1121-afbe-2431-9e516a06850c@linaro.org>
 <6f3b6557-1767-8c80-f786-1ea667179b39@acm.org>
 <2a8bd278-5384-d82f-c09b-4fce236d2d95@linaro.org>
 <20190905090617.GB4432@ming.t460p>
 <6a36ccc7-24cd-1d92-fef1-2c5e0f798c36@linaro.org>
 <20190906014819.GB27116@ming.t460p>
 <20190906141858.GA3953@localhost.localdomain>
 <CY4PR21MB0741091795CEE3D4624977CFCEBA0@CY4PR21MB0741.namprd21.prod.outlook.com>
 <20190906221920.GA12290@ming.t460p>
 <20190906222555.GB4260@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190906222555.GB4260@localhost.localdomain>
User-Agent: Mutt/1.11.3 (2019-02-01)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.69]); Fri, 06 Sep 2019 23:13:38 +0000 (UTC)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Sep 06, 2019 at 04:25:55PM -0600, Keith Busch wrote:
> On Sat, Sep 07, 2019 at 06:19:21AM +0800, Ming Lei wrote:
> > On Fri, Sep 06, 2019 at 05:50:49PM +0000, Long Li wrote:
> > > >Subject: Re: [PATCH 1/4] softirq: implement IRQ flood detection mechanism
> > > >
> > > >Why are all 8 nvmes sharing the same CPU for interrupt handling?
> > > >Shouldn't matrix_find_best_cpu_managed() handle selecting the least used
> > > >CPU from the cpumask for the effective interrupt handling?
> > > 
> > > The tests run on 10 NVMe disks on a system of 80 CPUs. Each NVMe disk has 32 hardware queues.
> > 
> > Then there are total 320 NVMe MSI/X vectors, and 80 CPUs, so irq matrix
> > can't avoid effective CPUs overlapping at all.
> 
> Sure, but it's at most half, meanwhile the CPU that's dispatching requests
> would naturally be throttled by the other half who's completions are
> interrupting that CPU, no?

The root cause is that multiple submission vs. single completion.

Let's see two cases:

1) 10 NVMe, each 8 queues, 80 CPU cores
- suppose genriq matrix can avoid effective cpu overlap, each cpu
  only handles one nvme interrupt
- there can be concurrent submissions from 10 CPUs, and all may be
  completed on one CPU
- IRQ flood couldn't happen for this case, given each CPU is only
  handling completion from one NVMe drive, which shouldn't be fast
  than CPU.

2) 10 NVMe, each 32 queues, 80 CPU cores
- one CPU may handle 4 NVMe interrupts, each from different NVMe drive
- then there may be 4*3 submissions aimed at single completion, then IRQ
  flood should be easy triggered on CPU for handing 4 NVMe interrupts.
  Because IO from 4 NVMe drive may be quicker than one CPU.

I can observe IRQ flood on the case #1, but there are still CPUs for
handling 2 NVMe interrupt, as the reason mentioned by Long. We could
improve for this case.

Thanks,
Ming
