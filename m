Return-Path: <SRS0=yvfi=XB=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F024C43331
	for <linux-scsi@archiver.kernel.org>; Fri,  6 Sep 2019 22:35:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 78C23208C3
	for <linux-scsi@archiver.kernel.org>; Fri,  6 Sep 2019 22:35:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1567809301;
	bh=t0ccCI+8kZUqKdcNW5Uwzzf08BhcuG881ubPr/huBtA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=UsW4XMbY7tNDYfSBfiDsgVOfsJzyD38ik9OKGFA4yGptUH4eE+MeuOA0Fs2OKjatw
	 8fO/G9+XJ21LnF+GZxUxPaF2LP45RLz0gjoAdpAGB+ACTJP/R2/V+ealbuxI1mKmqr
	 qaKT402Lbow6PcQV26AP4uqWjMrsig6lXtVIrn7k=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391726AbfIFWe5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 6 Sep 2019 18:34:57 -0400
Received: from mga01.intel.com ([192.55.52.88]:20193 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730705AbfIFWe5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 6 Sep 2019 18:34:57 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 Sep 2019 15:34:56 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,474,1559545200"; 
   d="scan'208";a="190955919"
Received: from unknown (HELO localhost.localdomain) ([10.232.112.69])
  by FMSMGA003.fm.intel.com with ESMTP; 06 Sep 2019 15:34:55 -0700
Date:   Fri, 6 Sep 2019 16:25:55 -0600
From:   Keith Busch <kbusch@kernel.org>
To:     Ming Lei <ming.lei@redhat.com>
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
Message-ID: <20190906222555.GB4260@localhost.localdomain>
References: <20190903072848.GA22170@ming.t460p>
 <dd96def4-1121-afbe-2431-9e516a06850c@linaro.org>
 <6f3b6557-1767-8c80-f786-1ea667179b39@acm.org>
 <2a8bd278-5384-d82f-c09b-4fce236d2d95@linaro.org>
 <20190905090617.GB4432@ming.t460p>
 <6a36ccc7-24cd-1d92-fef1-2c5e0f798c36@linaro.org>
 <20190906014819.GB27116@ming.t460p>
 <20190906141858.GA3953@localhost.localdomain>
 <CY4PR21MB0741091795CEE3D4624977CFCEBA0@CY4PR21MB0741.namprd21.prod.outlook.com>
 <20190906221920.GA12290@ming.t460p>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190906221920.GA12290@ming.t460p>
User-Agent: Mutt/1.9.1 (2017-09-22)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sat, Sep 07, 2019 at 06:19:21AM +0800, Ming Lei wrote:
> On Fri, Sep 06, 2019 at 05:50:49PM +0000, Long Li wrote:
> > >Subject: Re: [PATCH 1/4] softirq: implement IRQ flood detection mechanism
> > >
> > >Why are all 8 nvmes sharing the same CPU for interrupt handling?
> > >Shouldn't matrix_find_best_cpu_managed() handle selecting the least used
> > >CPU from the cpumask for the effective interrupt handling?
> > 
> > The tests run on 10 NVMe disks on a system of 80 CPUs. Each NVMe disk has 32 hardware queues.
> 
> Then there are total 320 NVMe MSI/X vectors, and 80 CPUs, so irq matrix
> can't avoid effective CPUs overlapping at all.

Sure, but it's at most half, meanwhile the CPU that's dispatching requests
would naturally be throttled by the other half who's completions are
interrupting that CPU, no?
