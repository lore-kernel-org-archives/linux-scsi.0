Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7255C433FE
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Dec 2020 17:52:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6BBF8225AA
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Dec 2020 17:52:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729196AbgLIRwK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Dec 2020 12:52:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726449AbgLIRwE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Dec 2020 12:52:04 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0989BC061793;
        Wed,  9 Dec 2020 09:51:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=qEaW85wNUThtYmzPpVh2Uv1WGFjJCT1naEW5fc1KM9I=; b=A6ZF2C2LZqABf8J8WIch1GHoMn
        61E7ro40d5ueErJg1gliDKEje9EgZ/yDSSbAvoa8u/JKXs3Q0wmULVpHXBCfGLRZc26qmAYG8D/Iq
        Eo0W4JSCSw/+v1Yw58I8zTSg7RXmgGZzXyzSLwkgZLLZusJo7GF0cHEMbEoDhFkQvucyJi4PG3HNR
        h+XEpl6giqfoL0AkVW/nn4Ykywz/Grd2EoHbX46/ux0qjqEslcOmkZVv/WluEh4MOM86Z7acSHipA
        /FAMDMUXSE63VMb+5Rosq8f6P3MQpgeMdPhwCmXuJKsM7z2ryGQ6zl7QQGdVNyl8tibGs3TPgrXq/
        U81iQSZw==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kn3cX-0006hp-Ls; Wed, 09 Dec 2020 17:51:21 +0000
Date:   Wed, 9 Dec 2020 17:51:21 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     Tom Yan <tom.ty89@gmail.com>
Cc:     Christoph Hellwig <hch@infradead.org>, linux-block@vger.kernel.org,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH 1/3] block: try one write zeroes request before going
 further
Message-ID: <20201209175121.GB25719@infradead.org>
References: <20201206055332.3144-1-tom.ty89@gmail.com>
 <20201207133658.GC28592@infradead.org>
 <CAGnHSEmzrJxm2RVHqP9qGfT0-5N2Zi8wdhvDz_zy-d7W0g7caQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGnHSEmzrJxm2RVHqP9qGfT0-5N2Zi8wdhvDz_zy-d7W0g7caQ@mail.gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Dec 08, 2020 at 08:48:15PM +0800, Tom Yan wrote:
> You mean like submit_bio_wait() is a blocking operation?

Yes, it blocks to wait for the I/O to complete.
