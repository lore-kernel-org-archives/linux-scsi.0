Return-Path: <SRS0=iRB6=6A=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EBCEC352BE
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Apr 2020 12:47:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 341F7208E4
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Apr 2020 12:47:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="NDoihVBS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2894473AbgDPMrw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 16 Apr 2020 08:47:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S2894464AbgDPMrs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 16 Apr 2020 08:47:48 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80F64C061A0C;
        Thu, 16 Apr 2020 05:47:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=gvx1/ulNBFgh/kHARyi19ZtC/l/z2neA8FBz9jVLqpk=; b=NDoihVBSGHP6XIKX03JtyTZqVu
        FNvLRQXbet8JArzLrUXD6VXFVqH32Zw7VCulrZzNCmbhGf+ykm+1awW56g1eEloUf9atUETwFoiHM
        vGlUyjdgyuZJKiLRIF8TpI1n43GplAqhftw4IqBgdIY1yPA7o7595JzGnhGfVw6cAVby0lHYE2rec
        C+DIxK8SIjMJ89IrG3WEH2q5cIJgGEs0emzMHC5geCYMhGS/CUUup2x0PLwNGRMieBQ3Vbdq+f6Ys
        QreRM5iSpOFodIBEkF8miqlFVZXDSePerV4WIGSgZOdt1sIx6ud3uOS0LUmDsin0s/Aom7ulXbN7V
        ed7361QA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jP3vn-00053L-P0; Thu, 16 Apr 2020 12:47:47 +0000
Date:   Thu, 16 Apr 2020 05:47:47 -0700
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
Subject: Re: [PATCH v6 04/11] block: Introduce REQ_OP_ZONE_APPEND
Message-ID: <20200416124747.GA6588@infradead.org>
References: <20200415090513.5133-1-johannes.thumshirn@wdc.com>
 <20200415090513.5133-5-johannes.thumshirn@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200415090513.5133-5-johannes.thumshirn@wdc.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> @@ -1000,13 +1000,12 @@ static int __bio_iov_iter_get_pages(struct bio *bio, struct iov_iter *iter)
>  		struct page *page = pages[i];
>  
>  		len = min_t(size_t, PAGE_SIZE - offset, left);
> -
>  		if (__bio_try_merge_page(bio, page, len, offset, &same_page)) {
>  			if (same_page)
>  				put_page(page);
>  		} else {
>  			if (WARN_ON_ONCE(bio_full(bio, len)))
> -                                return -EINVAL;
> +				return -EINVAL;
>  			__bio_add_page(bio, page, len, offset);

spurious whitespace changes.  They both actually look good to me,
but don't really belong into this patch.

Otherwise this looks good to me:

Reviewed-by: Christoph Hellwig <hch@lst.de>
