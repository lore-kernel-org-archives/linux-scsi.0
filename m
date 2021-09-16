Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26E89C433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Sep 2021 17:44:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0B18960F50
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Sep 2021 17:44:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350380AbhIPRpo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 16 Sep 2021 13:45:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:57156 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1355876AbhIPRmM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 16 Sep 2021 13:42:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C64B1610E9;
        Thu, 16 Sep 2021 17:28:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631813295;
        bh=9VCM3M3EPKlEZj/hB8UyzirJbEWs6hmQLIJjN4neDPs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=e4g8q1oSWgX0D2kYWEXru/0zPNN37iBm/qr6JWhhSJt0pRnDfmP8HghdCs9wjFzn2
         +8lA8Ct48MFpTVSdpgd9k7E6NhRacw/w0GcDFyjmShou5vgMtGmRZnhiiLzGWn/3nw
         Za6lnzvcdeBD39ghEyiC6iyYef+/VTvKgD7ducYM14VMwuXly6BaXohVVAXPoecqvH
         AwcMj7M9RLGApcUyibRI/QziPU0ey3mbaaI7y1poDGEbeKFpLVCweh9e4MrnGqjjE9
         iuOvY8eQe/11b92BaCQQy0v60HVIbGTWIsQ7JeOyCEgtsdtin3OoLOrtwJFrP0DanK
         EHtM5CKuDi2XA==
Date:   Thu, 16 Sep 2021 10:28:14 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-block@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux-scsi@vger.kernel.org, dm-devel@redhat.com,
        Satya Tangirala <satyaprateek2357@gmail.com>
Subject: Re: [PATCH 2/5] blk-crypto-fallback: consolidate static variables
Message-ID: <YUN+rv31Wm3+dfo+@sol.localdomain>
References: <20210913013135.102404-1-ebiggers@kernel.org>
 <20210913013135.102404-3-ebiggers@kernel.org>
 <YUGjSR1g+EH0o2xo@infradead.org>
 <YUIyVajIjZdkPO7F@sol.localdomain>
 <YUL0ytosYfrs7nNi@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YUL0ytosYfrs7nNi@infradead.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Sep 16, 2021 at 08:39:54AM +0100, Christoph Hellwig wrote:
> On Wed, Sep 15, 2021 at 10:50:13AM -0700, Eric Biggers wrote:
> > Using "blk_crypto_fallback_*" for all these variables results in some pretty
> > long names, e.g. "blk_crypto_fallback_crypt_ctx_cache" and
> > "blk_crypto_fallback_num_prealloc_crypt_ctxs".  This proposal gives the best of
> > both worlds; the names are properly "namespaced" but there is also a shortcut to
> > refer to them (struct blk_crypto_fallback *fallback = &blk_crypto_fallback).
> 
> I'd just drop the second crypt in those.
> 
> > If this is going to be controversial I can just drop this patch, but I was
> > hoping there would be a way to make things more consistent.
> 
> I personally detest that pattern.  Not sure if that counts as
> controversial or even matters :)

The names are still pretty long even with the second "crypt" dropped from those
two.  How about just "fallback_*"?  It might be clear enough from the context.

Anyway, I've dropped this patch from the series for now.  This can be done later
we can agree on which approach to take.

- Eric
