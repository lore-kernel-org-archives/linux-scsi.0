Return-Path: <SRS0=LwoI=W7=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A16E3C3A5A8
	for <linux-scsi@archiver.kernel.org>; Wed,  4 Sep 2019 18:23:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7DB6422CEA
	for <linux-scsi@archiver.kernel.org>; Wed,  4 Sep 2019 18:23:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="B68GhDH9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388957AbfIDSXh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 4 Sep 2019 14:23:37 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:56662 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388764AbfIDSCc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Sep 2019 14:02:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=YWE0H+jTpcN/XC6vFgWxU0Ifm430UGtAcUQBmeqFffU=; b=B68GhDH9ylcTgqElA2r7zjY7O
        lE6Rf0/LqJ/dbv7yx7jsCmrYsQoXzrSLpLhPKVcAq09WGGtdvjGxnz3fv+EJhtL7AFUeyL4hUtuyt
        SO8pIA93xdezldWmlYuoV9FK9U45Phywr2f2VSWHYoZWaGJ6vERLfLEyOxy6AI5yugAjiWfw2SeTE
        zbIU0h3IF2lpVTqWz7YPsRl3U0CE6wMNg2JLLw7DHSeFIaNu7K1T1oDbBlZnpyhAvdSKmvaSu5HCE
        Pl8vLB1RU4X/IesTI8jJ4p8o22IevZ5TrXbR/ihKRX90p+CdzzdIVoIQQjW6xLbRAVWLBZKQa/0ga
        ZRDX5wwYQ==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by bombadil.infradead.org with esmtpsa (Exim 4.92 #3 (Red Hat Linux))
        id 1i5Zbi-0004qX-Oq; Wed, 04 Sep 2019 18:02:14 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 32C2D3060BF;
        Wed,  4 Sep 2019 20:01:35 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id CD686201265AF; Wed,  4 Sep 2019 20:02:11 +0200 (CEST)
Date:   Wed, 4 Sep 2019 20:02:11 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     Daniel Lezcano <daniel.lezcano@linaro.org>,
        Ming Lei <ming.lei@redhat.com>,
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
Message-ID: <20190904180211.GX2332@hirez.programming.kicks-ass.net>
References: <alpine.DEB.2.21.1908281605190.23149@nanos.tec.linutronix.de>
 <20190903033001.GB23861@ming.t460p>
 <299fb6b5-d414-2e71-1dd2-9d6e34ee1c79@linaro.org>
 <20190903063125.GA21022@ming.t460p>
 <6b88719c-782a-4a63-db9f-bf62734a7874@linaro.org>
 <20190903072848.GA22170@ming.t460p>
 <dd96def4-1121-afbe-2431-9e516a06850c@linaro.org>
 <6f3b6557-1767-8c80-f786-1ea667179b39@acm.org>
 <2a8bd278-5384-d82f-c09b-4fce236d2d95@linaro.org>
 <de16de12-fa1a-666c-ea19-fea5d096c1ca@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <de16de12-fa1a-666c-ea19-fea5d096c1ca@acm.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Sep 04, 2019 at 10:38:59AM -0700, Bart Van Assche wrote:
> On 9/4/19 10:31 AM, Daniel Lezcano wrote:
> > On 04/09/2019 19:07, Bart Van Assche wrote:
> > > Only if CONFIG_IRQ_TIME_ACCOUNTING has been enabled. However, I don't
> > > know any Linux distro that enables that option. That's probably because
> > > that option introduces two rdtsc() calls in each interrupt. Given the
> > > overhead introduced by this option, I don't think this is the solution
> > > Ming is looking for.
> > 
> > Was this overhead reported somewhere ?
>  I think it is widely known that rdtsc is a relatively slow x86 instruction.
> So I expect that using that instruction will cause a measurable overhead if
> it is called frequently enough. I'm not aware of any publicly available
> measurement data however.

https://www.agner.org/optimize/instruction_tables.pdf

RDTSC, Ryzen: ~36
RDTSC, Skylake: ~20

Sadly those same tables don't list the cost of actual exceptions or even
IRET :/
