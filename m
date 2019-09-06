Return-Path: <SRS0=yvfi=XB=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9EB1AC00307
	for <linux-scsi@archiver.kernel.org>; Fri,  6 Sep 2019 08:50:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8710020650
	for <linux-scsi@archiver.kernel.org>; Fri,  6 Sep 2019 08:50:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392730AbfIFIur (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 6 Sep 2019 04:50:47 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:38628 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2392632AbfIFIuq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 6 Sep 2019 04:50:46 -0400
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id AB95A56F62A0480BF6C4;
        Fri,  6 Sep 2019 16:50:44 +0800 (CST)
Received: from [127.0.0.1] (10.202.227.238) by DGGEMS409-HUB.china.huawei.com
 (10.3.19.209) with Microsoft SMTP Server id 14.3.439.0; Fri, 6 Sep 2019
 16:50:33 +0800
Subject: Re: [PATCH 4/4] genirq: use irq's affinity for threaded irq with
 IRQF_RESCUE_THREAD
To:     Ming Lei <ming.lei@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
References: <20190827085344.30799-1-ming.lei@redhat.com>
 <20190827085344.30799-5-ming.lei@redhat.com>
CC:     <linux-kernel@vger.kernel.org>, Long Li <longli@microsoft.com>,
        "Ingo Molnar" <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Keith Busch <keith.busch@intel.com>, Jens Axboe <axboe@fb.com>,
        Christoph Hellwig <hch@lst.de>,
        Sagi Grimberg <sagi@grimberg.me>,
        Hannes Reinecke <hare@suse.com>,
        <linux-nvme@lists.infradead.org>, <linux-scsi@vger.kernel.org>,
        chenxiang <chenxiang66@hisilicon.com>,
        <daniel.lezcano@linaro.org>
From:   John Garry <john.garry@huawei.com>
Message-ID: <0214c66d-6496-10b9-7e37-e5b37d3022ef@huawei.com>
Date:   Fri, 6 Sep 2019 09:50:26 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.3.0
MIME-Version: 1.0
In-Reply-To: <20190827085344.30799-5-ming.lei@redhat.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.202.227.238]
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 27/08/2019 09:53, Ming Lei wrote:
> In case of IRQF_RESCUE_THREAD, the threaded handler is only used to
> handle interrupt when IRQ flood comes, use irq's affinity for this thread
> so that scheduler may select other not too busy CPUs for handling the
> interrupt.
>
> Cc: Long Li <longli@microsoft.com>
> Cc: Ingo Molnar <mingo@redhat.com>,
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Keith Busch <keith.busch@intel.com>
> Cc: Jens Axboe <axboe@fb.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Sagi Grimberg <sagi@grimberg.me>
> Cc: John Garry <john.garry@huawei.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Hannes Reinecke <hare@suse.com>
> Cc: linux-nvme@lists.infradead.org
> Cc: linux-scsi@vger.kernel.org
> Signed-off-by: Ming Lei <ming.lei@redhat.com>


> ---
>  kernel/irq/manage.c | 13 ++++++++++++-
>  1 file changed, 12 insertions(+), 1 deletion(-)
>
> diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
> index 1566abbf50e8..03bc041348b7 100644
> --- a/kernel/irq/manage.c
> +++ b/kernel/irq/manage.c
> @@ -968,7 +968,18 @@ irq_thread_check_affinity(struct irq_desc *desc, struct irqaction *action)
>  	if (cpumask_available(desc->irq_common_data.affinity)) {
>  		const struct cpumask *m;
>
> -		m = irq_data_get_effective_affinity_mask(&desc->irq_data);
> +		/*
> +		 * Managed IRQ's affinity is setup gracefull on MUNA locality,

gracefully

> +		 * also if IRQF_RESCUE_THREAD is set, interrupt flood has been
> +		 * triggered, so ask scheduler to run the thread on CPUs
> +		 * specified by this interrupt's affinity.
> +		 */

Hi Ming,

> +		if ((action->flags & IRQF_RESCUE_THREAD) &&
> +				irqd_affinity_is_managed(&desc->irq_data))

This doesn't look to solve the other issue I reported - that being that 
we handle the interrupt in a threaded handler natively, and the hard 
irq+threaded handler fully occupies the cpu, limiting throughput.

So can we expand the scope to cover that scenario also? I don't think 
that it’s right to solve that separately. So if we're continuing this 
approach, can we add separate judgment for spreading the cpumask for the 
threaded part?

Thanks,
John

> +			m = desc->irq_common_data.affinity;
> +		else
> +			m = irq_data_get_effective_affinity_mask(
> +					&desc->irq_data);
>  		cpumask_copy(mask, m);
>  	} else {
>  		valid = false;
>


