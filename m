Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 011C8C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Sep 2021 09:05:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E0D0161151
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Sep 2021 09:04:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231366AbhINJGQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 14 Sep 2021 05:06:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230418AbhINJGP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Sep 2021 05:06:15 -0400
Received: from mail-lj1-x233.google.com (mail-lj1-x233.google.com [IPv6:2a00:1450:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F50AC061764
        for <linux-scsi@vger.kernel.org>; Tue, 14 Sep 2021 02:04:58 -0700 (PDT)
Received: by mail-lj1-x233.google.com with SMTP id o11so14968159ljp.8
        for <linux-scsi@vger.kernel.org>; Tue, 14 Sep 2021 02:04:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hJGnWAchz/HDqF7HydjX2fUZvRJTYMKYHvyvKYF6LTA=;
        b=gsRYdLNT2BSVgBpZbeqTFVqbuZ67wWkrXvsQwtq0WLXmHe/pl4s2ggGSn5W150c6NX
         fqT6OzdCP/P+GMEGsvZfkMrRsKlKoV3bs+aoh/pJox88oCfQMj88wXcJE7q+p0vyhBwM
         4Z3Hfsw8LQ9OEXmd1bMlCw/9a0W4y/J57kJYDMkw8QFf+RZVkF1pgx66wlTAyPzANWAB
         EDg5+DOWidgpAJINmPs8zJ6LA2IrDSsIJkDGlR+E6bSssBbgs0qkB4oM8g1NGMpIdX16
         KVwjrQ8QX9r0CbMGHrPAXko2ja5ROaV1asQSeSU6nAMbC8+DA0OSoV/OUL75BLVJ5Y8b
         iKBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hJGnWAchz/HDqF7HydjX2fUZvRJTYMKYHvyvKYF6LTA=;
        b=JdCBs8OlgXiff/J5e00+fD2960P/2EiYRG84SQjKlRxIVFTpHLRRvtmyUn3PNFpgbK
         5sOTSahGIjVF3V8kfPNVwi1+EvLONVnjSw8JBeqM3ho5d/DhNJvJ/Ec96NOzybwenNtr
         YstvWyGOTHrKT06Mpfe7MpeGgL3Qk/GqTAwrf7k7Ibe1VGgwdyR6zwcj5V+zT4ZiLCdG
         p64Dpgeqjnr0ufYo6VZ3/g0f8Tb4XptTf6wNi5Cg2or/mPaAnOjhnuPkQzIADwpPjSiM
         chjl+ef+nfsG1qEfOQUZldq7d9lX42V1Cf9/LeqaIgm8qwvGwQd4afdwW0xxDW8/8n7W
         uQoA==
X-Gm-Message-State: AOAM533HFCmLV0wctCDWqdhbQZf5nVSOcA/ai3OYKLbwLXPJWBVCRFYR
        rxbBIRxtOeWQBn6vEMkxeF7HR0qg5CKTOktTj2/hfw==
X-Google-Smtp-Source: ABdhPJxZC/j49j+CcIzIqzNYUN//TpHs73k6VRwmbWS0R4xoDibBWk/HYQNi25ajG7KIqw46sDy4K+S8GNnu6KTzYqE=
X-Received: by 2002:a2e:960c:: with SMTP id v12mr14672590ljh.300.1631610296769;
 Tue, 14 Sep 2021 02:04:56 -0700 (PDT)
MIME-Version: 1.0
References: <20210913013135.102404-1-ebiggers@kernel.org> <20210913013135.102404-5-ebiggers@kernel.org>
In-Reply-To: <20210913013135.102404-5-ebiggers@kernel.org>
From:   Ulf Hansson <ulf.hansson@linaro.org>
Date:   Tue, 14 Sep 2021 11:04:20 +0200
Message-ID: <CAPDyKFpvZAQ+5niZkw2tk-q_6w=VAuK=P-OVGjQA7QbJW7OvgQ@mail.gmail.com>
Subject: Re: [PATCH 4/5] blk-crypto: rename blk_keyslot_manager to blk_crypto_profile
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-block <linux-block@vger.kernel.org>,
        linux-mmc <linux-mmc@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>, dm-devel@redhat.com,
        Satya Tangirala <satyaprateek2357@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 13 Sept 2021 at 03:35, Eric Biggers <ebiggers@kernel.org> wrote:
>
> From: Eric Biggers <ebiggers@google.com>
>
> blk_keyslot_manager is misnamed because it doesn't necessarily manage
> keyslots.  It actually does several different things:
>
>   - Contains the crypto capabilities of the device.
>
>   - Provides functions to control the inline encryption hardware.
>     Originally these were just for programming/evicting keyslots;
>     however, new functionality (hardware-wrapped keys) will require new
>     functions here which are unrelated to keyslots.  Moreover,
>     device-mapper devices already (ab)use "keyslot_evict" to pass key
>     eviction requests to their underlying devices even though
>     device-mapper devices don't have any keyslots themselves (so it
>     really should be "evict_key", not "keyslot_evict").
>
>   - Sometimes (but not always!) it manages keyslots.  Originally it
>     always did, but device-mapper devices don't have keyslots
>     themselves, so they use a "passthrough keyslot manager" which
>     doesn't actually manage keyslots.  This hack works, but the
>     terminology is unnatural.  Also, some hardware doesn't have keyslots
>     and thus also uses a "passthrough keyslot manager" (support for such
>     hardware is yet to be upstreamed, but it will happen eventually).
>
> Let's stop having keyslot managers which don't actually manage keyslots.
> Instead, rename blk_keyslot_manager to blk_crypto_profile.
>
> This is a fairly big change, since for consistency it also has to update
> keyslot manager-related function names, variable names, and comments --
> not just the actual struct name.  However it's still a fairly
> straightforward change, as it doesn't change any actual functionality.
>
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
>  block/blk-crypto-fallback.c        |  60 ++--
>  block/blk-crypto-profile.c         | 518 ++++++++++++++---------------
>  block/blk-crypto.c                 |  25 +-
>  block/blk-integrity.c              |   2 +-
>  drivers/md/dm-core.h               |   2 +-
>  drivers/md/dm-table.c              | 168 +++++-----
>  drivers/md/dm.c                    |   8 +-
>  drivers/mmc/core/crypto.c          |  11 +-
>  drivers/mmc/host/cqhci-crypto.c    |  31 +-
>  drivers/scsi/ufs/ufshcd-crypto.c   |  32 +-
>  drivers/scsi/ufs/ufshcd-crypto.h   |   9 +-
>  drivers/scsi/ufs/ufshcd.c          |   2 +-
>  drivers/scsi/ufs/ufshcd.h          |   4 +-
>  include/linux/blk-crypto-profile.h | 164 +++++----
>  include/linux/blkdev.h             |  18 +-
>  include/linux/device-mapper.h      |   4 +-
>  include/linux/mmc/host.h           |   2 +-
>  17 files changed, 548 insertions(+), 512 deletions(-)
>

Acked-by: Ulf Hansson <ulf.hansson@linaro.org> # For MMC

[...]

Kind regards
Uffe
