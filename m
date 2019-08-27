Return-Path: <SRS0=cdy6=WX=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45F6DC3A5A3
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Aug 2019 14:37:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1C8BE2186A
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Aug 2019 14:37:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1566916630;
	bh=y61E+yhJrBK2KCajlCMqMIr/TwcC3uDcysWP0uW033Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=gU9dBeSCgeUjfy6eND+3rL4y4svKLx3YokYNKFQplozGrG1rh3h2L67QT2r+1um6A
	 wgHTkiabk832SpG/Bhn6z47m4Xooj+G+KO7h2aX9uIIer1AfV5NmGfu7AYZZAkOU4F
	 C9RuZOIMttklbAfCwhaE9q4skF/sVwRMJRpmMfxw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730058AbfH0OhF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 27 Aug 2019 10:37:05 -0400
Received: from mga04.intel.com ([192.55.52.120]:12656 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728702AbfH0OhF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 27 Aug 2019 10:37:05 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 27 Aug 2019 07:37:04 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,437,1559545200"; 
   d="scan'208";a="192250328"
Received: from unknown (HELO localhost.localdomain) ([10.232.112.69])
  by orsmga002.jf.intel.com with ESMTP; 27 Aug 2019 07:37:03 -0700
Date:   Tue, 27 Aug 2019 08:35:16 -0600
From:   Keith Busch <kbusch@kernel.org>
To:     Ming Lei <ming.lei@redhat.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        Long Li <longli@microsoft.com>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Keith Busch <keith.busch@intel.com>, Jens Axboe <axboe@fb.com>,
        Christoph Hellwig <hch@lst.de>,
        Sagi Grimberg <sagi@grimberg.me>,
        John Garry <john.garry@huawei.com>,
        Hannes Reinecke <hare@suse.com>,
        linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH 4/4] genirq: use irq's affinity for threaded irq with
 IRQF_RESCUE_THREAD
Message-ID: <20190827143516.GB23091@localhost.localdomain>
References: <20190827085344.30799-1-ming.lei@redhat.com>
 <20190827085344.30799-5-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190827085344.30799-5-ming.lei@redhat.com>
User-Agent: Mutt/1.9.1 (2017-09-22)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Aug 27, 2019 at 04:53:44PM +0800, Ming Lei wrote:
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

s/MUNA/NUMA

> +		 * also if IRQF_RESCUE_THREAD is set, interrupt flood has been
> +		 * triggered, so ask scheduler to run the thread on CPUs
> +		 * specified by this interrupt's affinity.
> +		 */
> +		if ((action->flags & IRQF_RESCUE_THREAD) &&
> +				irqd_affinity_is_managed(&desc->irq_data))
> +			m = desc->irq_common_data.affinity;
> +		else
> +			m = irq_data_get_effective_affinity_mask(
> +					&desc->irq_data);
>  		cpumask_copy(mask, m);
>  	} else {
>  		valid = false;
> -- 
