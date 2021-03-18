Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D100C433E0
	for <linux-scsi@archiver.kernel.org>; Thu, 18 Mar 2021 11:31:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0ACFA64F24
	for <linux-scsi@archiver.kernel.org>; Thu, 18 Mar 2021 11:31:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229908AbhCRLap (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 18 Mar 2021 07:30:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229987AbhCRLae (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 18 Mar 2021 07:30:34 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DE3BC06174A;
        Thu, 18 Mar 2021 04:30:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=lMeDLmyG5bjRtOO5ITinr/ZiktpkdDw1zgsC8f+PGgc=; b=CozYDPOuPOw7f/I9TDCAi+jSfN
        DMDk9wzh6NBox+YCQlb6C/oV1o7DBPt1lulw/SHwwb1xK0vzKARwrzZ9Fbn2BkuDhJkt/ZMTNbQJ+
        P06zz5DEMBt9jwbaVmeP3AdM5pEmZjbWX+cP039J2LvYbm56yfobSiN42f/RaI7yuAKJLyfuZOB8d
        jSB4XslANaoeO/AsLSJ6++z41LtuwVR2ZD14PxVnJNcvvURs+2aqh1SNCFh+Xb1aheCPIOpeo6IxA
        L0+LuXSHJX9MxX3zwGyxt1lMmr+Fk3HTBNHNLBF9hcK2KEUlnaa1ha24du4iVPdWyy2fIDIS1fLcW
        52vHn9VA==;
Received: from willy by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lMqqc-002twM-Hn; Thu, 18 Mar 2021 11:29:58 +0000
Date:   Thu, 18 Mar 2021 11:29:50 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Jens Axboe <axboe@kernel.dk>, Khalid Aziz <khalid@gonehiking.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Hannes Reinecke <hare@suse.com>,
        Ondrej Zary <linux@rainbow-software.org>,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH 7/8] block: refactor the bounce buffering code
Message-ID: <20210318112950.GL3420@casper.infradead.org>
References: <20210318063923.302738-1-hch@lst.de>
 <20210318063923.302738-8-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210318063923.302738-8-hch@lst.de>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Mar 18, 2021 at 07:39:22AM +0100, Christoph Hellwig wrote:
> @@ -536,7 +518,7 @@ int blk_stack_limits(struct queue_limits *t, struct queue_limits *b,
>  					b->max_write_zeroes_sectors);
>  	t->max_zone_append_sectors = min(t->max_zone_append_sectors,
>  					b->max_zone_append_sectors);
> -	t->bounce_pfn = min_not_zero(t->bounce_pfn, b->bounce_pfn);
> +	t->bounce = min_not_zero(t->bounce, b->bounce);

I see how min_not_zero() made sense when it was a pfn.  Does it still
make sense now it's an enum?  I would have thought it'd now be 'max()',
given the definitions later on.

> +/*
> + * BLK_BOUNCE_NONE:	never bounce (default)
> + * BLK_BOUNCE_HIGH:	bounce all highmem pages
> + */
> +enum blk_bounce {
> +	BLK_BOUNCE_NONE,
> +	BLK_BOUNCE_HIGH,
> +};
> +
>  struct queue_limits {
> -	unsigned long		bounce_pfn;
> +	enum blk_bounce		bounce;
>  	unsigned long		seg_boundary_mask;
>  	unsigned long		virt_boundary_mask;
>  
