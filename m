Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0FEBC433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Sep 2021 07:41:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7FF0061185
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Sep 2021 07:41:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234767AbhIPHm2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 16 Sep 2021 03:42:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231548AbhIPHm2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Sep 2021 03:42:28 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09C2DC061574;
        Thu, 16 Sep 2021 00:41:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=vEZFptEZf5C9wRGghO4u+IkMlTZuTR381CNg4i5h8B0=; b=cQ6t6UOHrPMRezCitQxT6m0n9m
        fW8nbQq4dEBfm79pCSyxm/HpzM3k0v+8qw2PSQ9S3UOMe6r3Lfy4LBTyXm54hoDpxuCoPdjl/ERH2
        7YtUSTaSX3pzlsWCMDWRI+v0ADHsr6beejt+aEdhh4KcZN+cqBHGdyEPD/Yr0pKeYjt2A3A2s9UF1
        lDnfzDBKu+p9YdSFRwFfed2C16+e0HJ9cKX4S8VPFw0KhkoH+K+IhM/i2rLBWXclpdQL94M9gG6vM
        FdQDW6KQFIwt9vOcDYgcM0akoYFE9fml1UoX9we0DAlf2+NaR0ZCvo7fCwXRt2xr29RexCfJI63wL
        dT0K2wZg==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mQlzu-00GQSI-82; Thu, 16 Sep 2021 07:40:06 +0000
Date:   Thu, 16 Sep 2021 08:39:54 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Christoph Hellwig <hch@infradead.org>, linux-block@vger.kernel.org,
        linux-mmc@vger.kernel.org, linux-scsi@vger.kernel.org,
        dm-devel@redhat.com, Satya Tangirala <satyaprateek2357@gmail.com>
Subject: Re: [PATCH 2/5] blk-crypto-fallback: consolidate static variables
Message-ID: <YUL0ytosYfrs7nNi@infradead.org>
References: <20210913013135.102404-1-ebiggers@kernel.org>
 <20210913013135.102404-3-ebiggers@kernel.org>
 <YUGjSR1g+EH0o2xo@infradead.org>
 <YUIyVajIjZdkPO7F@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YUIyVajIjZdkPO7F@sol.localdomain>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Sep 15, 2021 at 10:50:13AM -0700, Eric Biggers wrote:
> Using "blk_crypto_fallback_*" for all these variables results in some pretty
> long names, e.g. "blk_crypto_fallback_crypt_ctx_cache" and
> "blk_crypto_fallback_num_prealloc_crypt_ctxs".  This proposal gives the best of
> both worlds; the names are properly "namespaced" but there is also a shortcut to
> refer to them (struct blk_crypto_fallback *fallback = &blk_crypto_fallback).

I'd just drop the second crypt in those.

> If this is going to be controversial I can just drop this patch, but I was
> hoping there would be a way to make things more consistent.

I personally detest that pattern.  Not sure if that counts as
controversial or even matters :)
