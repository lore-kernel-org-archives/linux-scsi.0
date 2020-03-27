Return-Path: <SRS0=+SnX=5M=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1FD55C43331
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Mar 2020 17:21:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DBA452071B
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Mar 2020 17:21:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="P4N11eZ4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727115AbgC0RVO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 27 Mar 2020 13:21:14 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:50468 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726698AbgC0RVO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 27 Mar 2020 13:21:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=6ac/LcNNJX7E2SWyI2OwYju4+7FIjEx/xjVxOX0DGy8=; b=P4N11eZ4FF6yggEdJhq4oPzUZC
        pdRn9yGf6nSaltcNH8mzu0GGnv/Eu6fcJPUXMrQ1NJK54MMSesMxyKL1MtuiAqpxeb7UgYb5N9I6u
        0+D3/Kx+PepnSkZIOBLBkQudfUYKAmhCBzGlYiIeRwXVI/+PVW8ff7JLcWrhA3hrEX5qhAI36u461
        W/A9gcmBCe87e+MCnCN2hqhyeSIAINzhkW/ZlWcv5BWDPyYOR9bSgDCIYKtzMM1y1t8NokeVsUh2l
        z6JqvswHC42q/UgKt+pzEJ22Rh0xyvypNPQV8rXDUxhP7jfhxePmc5PbroHxHSPwJirDfS2pAK4uy
        czmfpsWg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jHsfR-0004z7-9g; Fri, 27 Mar 2020 17:21:13 +0000
Date:   Fri, 27 Mar 2020 10:21:13 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Johannes Thumshirn <johannes.thumshirn@wdc.com>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Christoph Hellwig <hch@infradead.org>,
        linux-block <linux-block@vger.kernel.org>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        Keith Busch <kbusch@kernel.org>,
        "linux-scsi @ vger . kernel . org" <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "linux-fsdevel @ vger . kernel . org" <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH v3 04/10] block: Introduce zone write pointer offset
 caching
Message-ID: <20200327172113.GF11524@infradead.org>
References: <20200327165012.34443-1-johannes.thumshirn@wdc.com>
 <20200327165012.34443-5-johannes.thumshirn@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200327165012.34443-5-johannes.thumshirn@wdc.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> +static inline unsigned int *blk_alloc_zone_wp_ofst(unsigned int nr_zones)
> +{
> +	return kvcalloc(nr_zones, sizeof(unsigned int), GFP_NOIO);
> +}

This helper seems a bit pointless.

> +int blk_get_zone_wp_offset(struct blk_zone *zone, unsigned int *wp_ofst)
> +{
> +	switch (zone->cond) {
> +	case BLK_ZONE_COND_EMPTY:
> +		*wp_ofst = 0;
> +		return 0;
> +	case BLK_ZONE_COND_IMP_OPEN:
> +	case BLK_ZONE_COND_EXP_OPEN:
> +	case BLK_ZONE_COND_CLOSED:
> +		*wp_ofst = zone->wp - zone->start;
> +		return 0;
> +	case BLK_ZONE_COND_FULL:
> +		*wp_ofst = zone->len;
> +		return 0;
> +	case BLK_ZONE_COND_NOT_WP:
> +	case BLK_ZONE_COND_OFFLINE:
> +	case BLK_ZONE_COND_READONLY:
> +		/*
> +		 * Conventional, offline and read-only zones do not have a valid
> +		 * write pointer. Use 0 as a dummy value.
> +		 */
> +		*wp_ofst = 0;
> +		return 0;
> +	default:
> +		return -ENODEV;
> +	}

Why not just return the offset?  The error case is impossible anyway.
