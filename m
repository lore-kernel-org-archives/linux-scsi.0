Return-Path: <SRS0=1vX0=6G=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E95ADC38A30
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Apr 2020 06:39:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C014220706
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Apr 2020 06:39:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="N5vel+ov"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726041AbgDVGjH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Apr 2020 02:39:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725308AbgDVGjH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Apr 2020 02:39:07 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3254AC03C1A6
        for <linux-scsi@vger.kernel.org>; Tue, 21 Apr 2020 23:39:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=DJskjLLll3RrRgyRSd8BJD57+3yri98TRvEr9dSIZbY=; b=N5vel+ov1hDI8Hhe7zXwR6BZdW
        kMU3wovo9UR3BEei5L3cerAzlt0AJ242tUh553CJLgAHCb0QgpgX7NzKga4LV/rL/77aFQRjjCf1h
        F6L67zCHo1qWpoG1x5CNpaG5sjO7Zi5cmzeqixhh8yDYlWmLMiO34L7935NU72x69nMR/pQELggeq
        JE2/1zFcs/bsiW7JmxSMKaOV6HMNqLLzKxKQGU+QXb/7NraqFieN46e5qWjRhl6L09Fo0udmeCwTp
        5ltpdJLb1ANOPiQRW47KEaU/BUHFsZYzomO0ECFwY1IvOAcs+GdQoI3pMhax57aurbJDRxGTzCzfl
        XlxSTe8g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jR92J-0000xT-1k; Wed, 22 Apr 2020 06:39:07 +0000
Date:   Tue, 21 Apr 2020 23:39:07 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Suganath Prabu <suganath-prabu.subramani@broadcom.com>
Cc:     linux-scsi@vger.kernel.org, hch@infradead.org,
        Sathya.Prakash@broadcom.com, sreekanth.reddy@broadcom.com
Subject: Re: [v1 3/5] mpt3sas: Separate out RDPQ allocation to new function.
Message-ID: <20200422063907.GD20318@infradead.org>
References: <1586957125-19460-1-git-send-email-suganath-prabu.subramani@broadcom.com>
 <1586957125-19460-4-git-send-email-suganath-prabu.subramani@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1586957125-19460-4-git-send-email-suganath-prabu.subramani@broadcom.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Apr 15, 2020 at 09:25:23AM -0400, Suganath Prabu wrote:
> From: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
> 
> For readability separate out RDPQ allocations to new function
> base_alloc_rdpq_dma_pool().
> 
> Signed-off-by: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
> ---
>  drivers/scsi/mpt3sas/mpt3sas_base.c | 85 ++++++++++++++++++++++---------------
>  1 file changed, 51 insertions(+), 34 deletions(-)
> 
> diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
> index 7f7b5af..27c829e 100644
> --- a/drivers/scsi/mpt3sas/mpt3sas_base.c
> +++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
> @@ -4944,6 +4944,55 @@ mpt3sas_check_same_4gb_region(long reply_pool_start_address, u32 pool_sz)
>  }
>  
>  /**
> + * base_alloc_rdpq_dma_pool - Allocating DMA'able memory
> + *                     for reply queues.
> + * @ioc: per adapter object
> + * @sz: DMA Pool size
> + * Return: 0 for success, non-zero for failure.
> + */
> +static int
> +base_alloc_rdpq_dma_pool(struct MPT3SAS_ADAPTER *ioc, int sz)
> +{
> +	int i;
> +
> +	ioc->reply_post = kcalloc((ioc->rdpq_array_enable) ?
> +	    (ioc->reply_queue_count):1,
> +	    sizeof(struct reply_post_struct), GFP_KERNEL);

Odd use of whitespaces.  Also this would benefit from a little
untangling as well:

	int count = ioc->rdpq_array_enable ? ioc->reply_queue_count : 1;

	ioc->reply_post = kcalloc(count, sizeof(struct reply_post_struct),
			GFP_KERNEL);
> +
> +	if (!ioc->reply_post) {
> +		ioc_err(ioc, "reply_post_free pool: kcalloc failed\n");
> +		return -ENOMEM;
> +	}
> +	ioc->reply_post_free_dma_pool = dma_pool_create("reply_post_free pool",
> +			&ioc->pdev->dev, sz, 16, 0);
> +	if (!ioc->reply_post_free_dma_pool) {
> +		ioc_err(ioc, "reply_post_free pool: dma_pool_create failed\n");
> +		return -ENOMEM;

We normally don't print error messages for memory allocation failures,
as the allocator already prints one including a stack trace.

Same for additional allocations below.

> +	} while (ioc->rdpq_array_enable && (++i < ioc->reply_queue_count));

no need for the inner braces.

> +	total_sz += sz * (!ioc->rdpq_array_enable ? 1 : ioc->reply_queue_count);

	if (ioc->rdpq_array_enable)
		total_sz += sz * ioc->reply_queue_count;
	else
		total_sz += sz;
