Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B64CC433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Dec 2021 15:05:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235154AbhLNPF1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 14 Dec 2021 10:05:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232989AbhLNPFT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Dec 2021 10:05:19 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86AF6C061397;
        Tue, 14 Dec 2021 07:04:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=qM3BdsaT/L84lBv+p9s7oavmQoACJ0UenogZIBw0Rzc=; b=T7ExDwUuFaOCaHYrh1uuxkBiON
        5mBpX8Rt6gm39rmpZojDreW2aGB7o+VIjDi3S1mrTqf6AxiV+BDXBQlqq8wATGRWvkyIUNWxgmngi
        /0QU8bhbtzrkoxHP9TZrDVhI5RxGVVdWjZ3HPSby5KFM9YnmM7efWHGiuNLHAqYwm1QunyNZ19zZ9
        hHCGHLLLiukX2bZmgDRFUAocA4HmHEOiRP2RjWn/3fScxJhn8gdj6oPOOXc/rTVJPPNbZN2ExlotV
        LASw4X5V/NIZ3C6NE5JDIyqDhwkuii0fk+og+QovQnTEm+1r/luOUMxjlwv0K83Vg40D3db7IE6oG
        cctuLZeQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mx9M5-00EZhX-PK; Tue, 14 Dec 2021 15:04:37 +0000
Date:   Tue, 14 Dec 2021 07:04:37 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        Dexuan Cui <decui@microsoft.com>,
        Ming Lei <ming.lei@redhat.com>, linux-scsi@vger.kernel.org,
        Tejun Heo <tj@kernel.org>,
        Lai Jiangshan <jiangshanlai@gmail.com>
Subject: Re: [PATCH] block: reduce kblockd_mod_delayed_work_on() CPU
 consumption
Message-ID: <YbiyhcbZmnNbed3O@infradead.org>
References: <bc529a3e-31d5-c266-8633-91095b346b19@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bc529a3e-31d5-c266-8633-91095b346b19@kernel.dk>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Dec 14, 2021 at 07:53:46AM -0700, Jens Axboe wrote:
> Dexuan reports that he's seeing spikes of very heavy CPU utilization when
> running 24 disks and using the 'none' scheduler. This happens off the
> flush path, because SCSI requires the queue to be restarted async, and
> hence we're hammering on mod_delayed_work_on() to ensure that the work
> item gets run appropriately.
> 
> What we care about here is that the queue is run, and we don't need to
> repeatedly re-arm the timer associated with the delayed work item. If we
> check if the work item is pending upfront, then we don't really need to do
> anything else. This is safe as theh work pending bit is cleared before a
> work item is started.
> 
> The only potential caveat here is if we have callers with wildly different
> timeouts specified. That's generally not the case, so don't think we need
> to care for that case.

So why not do a non-delayed queue_work for that case?  Might be good
to get the scsi and workqueue maintaines involved to understand the
issue a bit better first.

> 
> Reported-by: Dexuan Cui <decui@microsoft.com>
> Link: https://lore.kernel.org/linux-block/BYAPR21MB1270C598ED214C0490F47400BF719@BYAPR21MB1270.namprd21.prod.outlook.com/
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> 
> ---
> 
> diff --git a/block/blk-core.c b/block/blk-core.c
> index 1378d084c770..4584fe709c15 100644
> --- a/block/blk-core.c
> +++ b/block/blk-core.c
> @@ -1484,7 +1484,16 @@ EXPORT_SYMBOL(kblockd_schedule_work);
>  int kblockd_mod_delayed_work_on(int cpu, struct delayed_work *dwork,
>  				unsigned long delay)
>  {
> -	return mod_delayed_work_on(cpu, kblockd_workqueue, dwork, delay);
> +	/*
> +	 * Avoid hammering on work addition, if the work item is already
> +	 * pending. This is safe the work pending state is cleared before
> +	 * the work item is started, so if we see it set, then we know that
> +	 * whatever was previously queued on the block side will get run by
> +	 * an existing pending work item.
> +	 */
> +	if (!work_pending(&dwork->work))
> +		return mod_delayed_work_on(cpu, kblockd_workqueue, dwork, delay);
> +	return true;
>  }
>  EXPORT_SYMBOL(kblockd_mod_delayed_work_on);
>  
> -- 
> Jens Axboe
> 
---end quoted text---
