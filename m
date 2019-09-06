Return-Path: <SRS0=yvfi=XB=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB45AC43331
	for <linux-scsi@archiver.kernel.org>; Fri,  6 Sep 2019 14:28:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 84E832067B
	for <linux-scsi@archiver.kernel.org>; Fri,  6 Sep 2019 14:28:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1567780085;
	bh=Zo2VJdJX1Ps5/i22vtJyz2+zmt2xqvUUooftfFoP9Sk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=E9+n0eAemm68I61qUhSqOFkOumc8GlSa+K4vrlbYL4tXWHvugc4GbZzze6AlX56oE
	 CbEIbIuo9PciWTRzcCR5u4bSm/ut22PW/oweNUDmOOsxR8r/xe7+l7JmI0sN/+WgNP
	 1myFHbpiQfvJLjPKZShRyzVOLk0aSkq+ANKmWE8Y=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394421AbfIFO2B (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 6 Sep 2019 10:28:01 -0400
Received: from mga03.intel.com ([134.134.136.65]:63411 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731142AbfIFO2B (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 6 Sep 2019 10:28:01 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 Sep 2019 07:28:00 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,473,1559545200"; 
   d="scan'208";a="188327645"
Received: from unknown (HELO localhost.localdomain) ([10.232.112.69])
  by orsmga006.jf.intel.com with ESMTP; 06 Sep 2019 07:27:59 -0700
Date:   Fri, 6 Sep 2019 08:18:58 -0600
From:   Keith Busch <kbusch@kernel.org>
To:     Ming Lei <ming.lei@redhat.com>
Cc:     Daniel Lezcano <daniel.lezcano@linaro.org>,
        Keith Busch <keith.busch@intel.com>,
        Hannes Reinecke <hare@suse.com>,
        Bart Van Assche <bvanassche@acm.org>,
        linux-scsi@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Long Li <longli@microsoft.com>,
        John Garry <john.garry@huawei.com>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-nvme@lists.infradead.org, Jens Axboe <axboe@fb.com>,
        Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Christoph Hellwig <hch@lst.de>,
        Sagi Grimberg <sagi@grimberg.me>
Subject: Re: [PATCH 1/4] softirq: implement IRQ flood detection mechanism
Message-ID: <20190906141858.GA3953@localhost.localdomain>
References: <299fb6b5-d414-2e71-1dd2-9d6e34ee1c79@linaro.org>
 <20190903063125.GA21022@ming.t460p>
 <6b88719c-782a-4a63-db9f-bf62734a7874@linaro.org>
 <20190903072848.GA22170@ming.t460p>
 <dd96def4-1121-afbe-2431-9e516a06850c@linaro.org>
 <6f3b6557-1767-8c80-f786-1ea667179b39@acm.org>
 <2a8bd278-5384-d82f-c09b-4fce236d2d95@linaro.org>
 <20190905090617.GB4432@ming.t460p>
 <6a36ccc7-24cd-1d92-fef1-2c5e0f798c36@linaro.org>
 <20190906014819.GB27116@ming.t460p>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190906014819.GB27116@ming.t460p>
User-Agent: Mutt/1.9.1 (2017-09-22)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Sep 06, 2019 at 09:48:21AM +0800, Ming Lei wrote:
> When one IRQ flood happens on one CPU:
> 
> 1) softirq handling on this CPU can't make progress
> 
> 2) kernel thread bound to this CPU can't make progress
> 
> For example, network may require softirq to xmit packets, or another irq
> thread for handling keyboards/mice or whatever, or rcu_sched may depend
> on that CPU for making progress, then the irq flood stalls the whole
> system.
> 
> > 
> > AFAIU, there are fast medium where the responses to requests are faster
> > than the time to process them, right?
> 
> Usually medium may not be faster than CPU, now we are talking about
> interrupts, which can be originated from lots of devices concurrently,
> for example, in Long Li'test, there are 8 NVMe drives involved.

Why are all 8 nvmes sharing the same CPU for interrupt handling?
Shouldn't matrix_find_best_cpu_managed() handle selecting the least used
CPU from the cpumask for the effective interrupt handling?
