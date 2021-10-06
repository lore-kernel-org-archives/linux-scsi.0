Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D60C1C433F5
	for <linux-scsi@archiver.kernel.org>; Wed,  6 Oct 2021 13:28:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BAEC4610A8
	for <linux-scsi@archiver.kernel.org>; Wed,  6 Oct 2021 13:28:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231690AbhJFNaS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 6 Oct 2021 09:30:18 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:33159 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231384AbhJFNaP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Oct 2021 09:30:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633526902;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=1tJD1MyAZSMlO+w5dHejgDl1BZyQkw7PrMG9J/BwPx4=;
        b=Ax0NXD/9LgNZJ+Y+nwoVdqtuG/pOhYCOMCyBssx/lVgR34jWiBIa1YUsv/4/xN4i/YELxY
        nF8n0gRv/MxLN772d4KUa/bjo+waN/SF/ZSxEaH6hx4Bda5brvNkk3NTKd7DUh/N7S/XpA
        YyWmOu7d8tg0LcAIo2gUolVqHUx52Pk=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-238-OxAtSYZdMLaDDvZ-BlWH7g-1; Wed, 06 Oct 2021 09:28:21 -0400
X-MC-Unique: OxAtSYZdMLaDDvZ-BlWH7g-1
Received: by mail-qk1-f198.google.com with SMTP id k3-20020a05620a414300b0045e623cd1afso2112520qko.20
        for <linux-scsi@vger.kernel.org>; Wed, 06 Oct 2021 06:28:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=1tJD1MyAZSMlO+w5dHejgDl1BZyQkw7PrMG9J/BwPx4=;
        b=LPZU4XCW2SYxrx1p4KJfWIGkd726RwYmDQWA/1iaYumqvXvaVHR5DkvXpYIGegsuz3
         H81SSHK+d+8DZsYsNwPMORbNKAe9KgqnRLL+y7II0rLMtpqvVjbgv9QO0NXeqdLRQSvR
         M9PDuO/zmpcmfbuOZ22QE6KzbXNcV9/PzEgpoQpFn6vbiWwaAGemPapVkt29Ts0ZpaHX
         ZFCB/IMofMs4mIXpsyH+iFVZsdZ6k8SUP4VMG7x9j3fP3i5j26HW0qXhwFxGFxBvTUcD
         aSxfQgyQESLngJLOGIw+htJxotvllKBjeKYtRKUQo/qKJBELnY2JzmEuJ/2FWd9zuPoU
         Qkgg==
X-Gm-Message-State: AOAM532LFoXGbWObr32E3yU7Sostgr5Dy/tl/S0CcYTYHPQpu2Posb2v
        fMMoN4DTIbm99R00h8j993FHGK53j8unWS9ooqQ7ahaXjtuWQDS5HCCRrO1Cfmlt7SmHCwHGVd8
        kg9FLmg6OJgMUFEyD7h8L
X-Received: by 2002:a05:622a:614:: with SMTP id z20mr26023528qta.232.1633526901339;
        Wed, 06 Oct 2021 06:28:21 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwQYqJgkQDoER0wVjEnhGOvfMferVnYWL3MCFbh+T5SgAmvWHhmeJb7yIfGG5UVXT07/2sCPA==
X-Received: by 2002:a05:622a:614:: with SMTP id z20mr26023510qta.232.1633526901173;
        Wed, 06 Oct 2021 06:28:21 -0700 (PDT)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net. [68.160.176.52])
        by smtp.gmail.com with ESMTPSA id m1sm1131877qtu.59.2021.10.06.06.28.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Oct 2021 06:28:20 -0700 (PDT)
Date:   Wed, 6 Oct 2021 09:28:20 -0400
From:   Mike Snitzer <snitzer@redhat.com>
To:     linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc:     Satya Tangirala <satyaprateek2357@gmail.com>, dm-devel@redhat.com,
        linux-mmc@vger.kernel.org, linux-scsi@vger.kernel.org,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: Re: [PATCH v4 3/4] blk-crypto: rename blk_keyslot_manager to
 blk_crypto_profile
Message-ID: <YV2kdHeS4GTXUdpi@redhat.com>
References: <20210929163600.52141-1-ebiggers@kernel.org>
 <20210929163600.52141-4-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210929163600.52141-4-ebiggers@kernel.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Sep 29 2021 at 12:35P -0400,
Eric Biggers <ebiggers@kernel.org> wrote:

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
> Acked-by: Ulf Hansson <ulf.hansson@linaro.org> # For MMC
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Unfortunate how fiddley this change forced you to get but it looks
like you've done a very solid job of cleaning it all up to be
consistent.

Reviewed-by: Mike Snitzer <snitzer@redhat.com>

