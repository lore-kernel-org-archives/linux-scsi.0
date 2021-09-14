Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE3EBC433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Sep 2021 09:04:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C0F126113E
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Sep 2021 09:04:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231510AbhINJGM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 14 Sep 2021 05:06:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230418AbhINJGL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Sep 2021 05:06:11 -0400
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6431C061574
        for <linux-scsi@vger.kernel.org>; Tue, 14 Sep 2021 02:04:53 -0700 (PDT)
Received: by mail-lf1-x134.google.com with SMTP id h16so27265262lfk.10
        for <linux-scsi@vger.kernel.org>; Tue, 14 Sep 2021 02:04:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TxkMbPDfFbLZj7gS8lbkBILCw0qzdwhInbM9Rl7jN2Y=;
        b=Reh4KSfhO4uWMDSUTeWXW3VcT5h3uBKRpQjg39H5GecQ5wxeW84U8vrpTqv+0SzJOP
         rYR4PiJlpe36Aw8Onae3lV1jz9Ajq9FO5Ym1FsY3kPIH7N37aLQgkzqtkoBEl1i+pFoD
         A43CJBDWEziyptxLKRpLl4HBhXj4VLn+9NiHO/lZlf/gFEm2iugTaDrhocDCvIeXbvr6
         ftJS5MnNsLuOuEX4rG23UStaF85BlqADOEnDgwESly0liQVNGebWl9eHQnU9aytoXRmv
         sDjktJt8SWlhr/FsBtujNrthw4UtCozMk35BL5Q4246goHs+quUMXXm8E4nHFZOWYY3u
         KjNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TxkMbPDfFbLZj7gS8lbkBILCw0qzdwhInbM9Rl7jN2Y=;
        b=LfrW0hMwv43SMIuaOT9rj09XElAbYT5ZXf+v9XPpNhh+1EUobCBYkoXJ2HzHa3YlCn
         NP4iEXWA7A0e93SzY4UBd0NVSa5u5gynJfAS8OFod3RGpinkITATiAomzzS2aloHPNRh
         d+GYvpPFrtu/p5kKcDr8yK7+MHKopI2weTOn0GL9c+TJhJySwaaYw+dg5P31PMiGrbZm
         alLNft/PDoV2U+eFEk6vda0DR6VpmcNeUzwOyn47xv8GuZyR2K+z+LrGM6UAiAeuwxTJ
         6Zo2nHYYgF8j/LkCw/+oG0sWoM9X5brSGKx9N0Jsys5YBYI/ow1LDWrjeEfPTkDGKL0a
         z+xw==
X-Gm-Message-State: AOAM532r2cp7qy0I0TcqVWYDBh2AWDVGcamaQ5Ao5jeuT9Tzs/0JTooz
        dD8zruYzz8zlsiCgkNJlA8o+SA2eNkifPp59f/UGVg==
X-Google-Smtp-Source: ABdhPJxmtEn3tJSHkFDVGWx0SpxzVkHAAASInKwE013atEj5O0Z9owxq78OkTQeJkvm7QK88xVAWDaZ3LFcJNo3racU=
X-Received: by 2002:a05:6512:3ca5:: with SMTP id h37mr12218278lfv.254.1631610292303;
 Tue, 14 Sep 2021 02:04:52 -0700 (PDT)
MIME-Version: 1.0
References: <20210913013135.102404-1-ebiggers@kernel.org> <20210913013135.102404-4-ebiggers@kernel.org>
In-Reply-To: <20210913013135.102404-4-ebiggers@kernel.org>
From:   Ulf Hansson <ulf.hansson@linaro.org>
Date:   Tue, 14 Sep 2021 11:04:16 +0200
Message-ID: <CAPDyKFqEmhwT0v8ZWM9ByOSoVPYM62mi4zjDTG9J1bD40_Zfyg@mail.gmail.com>
Subject: Re: [PATCH 3/5] blk-crypto: rename keyslot-manager files to blk-crypto-profile
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
> In preparation for renaming struct blk_keyslot_manager to struct
> blk_crypto_profile, rename the keyslot-manager.h and keyslot-manager.c
> source files.  Renaming these files separately before making a lot of
> changes to their contents makes it easier for git to understand that
> they were renamed.
>
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
>  block/Makefile                                            | 2 +-
>  block/blk-crypto-fallback.c                               | 2 +-
>  block/{keyslot-manager.c => blk-crypto-profile.c}         | 2 +-
>  block/blk-crypto.c                                        | 2 +-
>  drivers/md/dm-core.h                                      | 2 +-
>  drivers/md/dm.c                                           | 2 +-
>  drivers/mmc/host/cqhci-crypto.c                           | 2 +-
>  drivers/scsi/ufs/ufshcd.h                                 | 2 +-
>  include/linux/{keyslot-manager.h => blk-crypto-profile.h} | 0
>  include/linux/mmc/host.h                                  | 2 +-
>  10 files changed, 9 insertions(+), 9 deletions(-)
>  rename block/{keyslot-manager.c => blk-crypto-profile.c} (99%)
>  rename include/linux/{keyslot-manager.h => blk-crypto-profile.h} (100%)

Acked-by: Ulf Hansson <ulf.hansson@linaro.org> # For MMC

[...]

Kind regards
Uffe
