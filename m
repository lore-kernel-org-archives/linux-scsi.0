Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DED0AC433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Sep 2021 17:50:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BCF0961209
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Sep 2021 17:50:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230203AbhIORvf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 15 Sep 2021 13:51:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:38444 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229647AbhIORve (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 15 Sep 2021 13:51:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2B60161131;
        Wed, 15 Sep 2021 17:50:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631728215;
        bh=hltCimG9NnwA23RWooqwhZR6Jz22twio42rXNI9i7DI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qs1XpFY8Mgi6+JvSL53gHe2naRJTqreaYJZA+kNq4z2CBiYl7OKR5gW9tJCAeV0vk
         V+uQDOtfpUjSsmKJUGAiYQSWvmtcFxSB/79rEeWSfFsqsVDwDFdrCtDPaYCu82k3tJ
         Gk8MhOLS+qzFJHUJAHWxh3sN59P2bLDLGgJGzgO4sZbZpiDYtv1dAnJ2qka7s89m2/
         HctxSgIluCkKR0n0ityEI01jPcK/gyUQ7oirh60u/g8cqCFO0SGC4sPswnqsjmi7KE
         Rwzkvqh4ZdakxMyHJqk+PwC9Gp68AGkjHTbEVgiedaSgyntV5bFdelWrjpmjsV9CkV
         gZ3TpFZeUL2GA==
Date:   Wed, 15 Sep 2021 10:50:13 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-block@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux-scsi@vger.kernel.org, dm-devel@redhat.com,
        Satya Tangirala <satyaprateek2357@gmail.com>
Subject: Re: [PATCH 2/5] blk-crypto-fallback: consolidate static variables
Message-ID: <YUIyVajIjZdkPO7F@sol.localdomain>
References: <20210913013135.102404-1-ebiggers@kernel.org>
 <20210913013135.102404-3-ebiggers@kernel.org>
 <YUGjSR1g+EH0o2xo@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YUGjSR1g+EH0o2xo@infradead.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Sep 15, 2021 at 08:39:53AM +0100, Christoph Hellwig wrote:
> On Sun, Sep 12, 2021 at 06:31:32PM -0700, Eric Biggers wrote:
> > From: Eric Biggers <ebiggers@google.com>
> > 
> > blk-crypto-fallback.c has many static variables with inconsistent names,
> > e.g. "blk_crypto_*", "crypto_*", and some unprefixed names.  This is
> > confusing.  Consolidate them all into a struct named
> > "blk_crypto_fallback" so that it's clear what they are.
> 
> I always find this pattern of a single instance global struct rather
> confusing.  What is the advantage over just using a consistent prefix?

Using "blk_crypto_fallback_*" for all these variables results in some pretty
long names, e.g. "blk_crypto_fallback_crypt_ctx_cache" and
"blk_crypto_fallback_num_prealloc_crypt_ctxs".  This proposal gives the best of
both worlds; the names are properly "namespaced" but there is also a shortcut to
refer to them (struct blk_crypto_fallback *fallback = &blk_crypto_fallback).

If this is going to be controversial I can just drop this patch, but I was
hoping there would be a way to make things more consistent.

- Eric
