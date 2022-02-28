Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0B5CC433F5
	for <linux-scsi@archiver.kernel.org>; Mon, 28 Feb 2022 20:43:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229613AbiB1UoM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 28 Feb 2022 15:44:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229929AbiB1UoJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 28 Feb 2022 15:44:09 -0500
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A97942BB04
        for <linux-scsi@vger.kernel.org>; Mon, 28 Feb 2022 12:43:29 -0800 (PST)
Received: by mail-lf1-x133.google.com with SMTP id y24so23465905lfg.1
        for <linux-scsi@vger.kernel.org>; Mon, 28 Feb 2022 12:43:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=S/LNP14iVGpJY7HEU3KoWC3rGBeIOldyeXi/18P4YEg=;
        b=JCfpf2EkV0u8p2DIwI3SoZoRhHthQMEAy9/7LEkowc8JnTmPgsFXHlzh4U3t+Q6SEk
         Lc7ftzGO2kIrejoWkV3dzzd0jpx1zu67BigJ1Dmt6MH2aSREOTU5VOooJKZjMGKU+kco
         F0IyOo2hDxkf3WtcbllN4ffR7kqC0AZqO0I4w=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=S/LNP14iVGpJY7HEU3KoWC3rGBeIOldyeXi/18P4YEg=;
        b=hJEy0MU+rAXf/J1EVC3X31DiLMidJZm+0BITzsAqg0aTLEVpQOk1ucR5Uyul2WBue+
         MBdx4dKaaxMjMe/jzPZnNf/7/5zSqYRA+mOEPPSc9E/nA8M8p+InBfOzGnCqgxj9MlOR
         NWL0q80FeH206tBJl28wVQ1p50cN1aNeKxvejWkTXVZ2/7y4s60KXhFWD3w6YxNZuv/y
         XPjnaXNbVGVvrxcX+ncJ3qbV13g09434KR1U5aXDS12rCK7m/6dwOHhgpYk0i37yMjEi
         UKz+bAXi/PUsgOwX8b27s/cec7Bl0E37d4neCfwL+XsBMggLgwJ8U92Y9MyGfZWsB3ip
         v85Q==
X-Gm-Message-State: AOAM53262HAgEyTsN4y9XXloEX9jBf9qJihPbyY/zUf1QZ49hTQS8tcW
        18VDItbO/NoB7Y2l6rwFtZZiaEflZxogiPDwdpo=
X-Google-Smtp-Source: ABdhPJy0cQGpypt9o0c2PzBxCzgWpdjbK0WD6WzUKXXRF3thlEw+PqcbV4dmxYDrzgjiI7qRLRSQ+w==
X-Received: by 2002:a05:6512:224b:b0:443:ac94:3de3 with SMTP id i11-20020a056512224b00b00443ac943de3mr13630081lfu.60.1646081007854;
        Mon, 28 Feb 2022 12:43:27 -0800 (PST)
Received: from mail-lj1-f181.google.com (mail-lj1-f181.google.com. [209.85.208.181])
        by smtp.gmail.com with ESMTPSA id 10-20020a2e154a000000b00246876c0bb7sm877610ljv.74.2022.02.28.12.43.27
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 28 Feb 2022 12:43:27 -0800 (PST)
Received: by mail-lj1-f181.google.com with SMTP id t14so19067834ljh.8
        for <linux-scsi@vger.kernel.org>; Mon, 28 Feb 2022 12:43:27 -0800 (PST)
X-Received: by 2002:a2e:924d:0:b0:246:370c:5618 with SMTP id
 v13-20020a2e924d000000b00246370c5618mr15158756ljg.358.1646080652034; Mon, 28
 Feb 2022 12:37:32 -0800 (PST)
MIME-Version: 1.0
References: <20220228110822.491923-1-jakobkoschel@gmail.com>
 <20220228110822.491923-3-jakobkoschel@gmail.com> <2e4e95d6-f6c9-a188-e1cd-b1eae465562a@amd.com>
 <CAHk-=wgQps58DPEOe4y5cTh5oE9EdNTWRLXzgMiETc+mFX7jzw@mail.gmail.com>
 <CAHk-=wj8fkosQ7=bps5K+DDazBXk=ypfn49A0sEq+7-nZnyfXA@mail.gmail.com>
 <CAHk-=wiTCvLQkHcJ3y0hpqH7FEk9D28LDvZZogC6OVLk7naBww@mail.gmail.com> <Yh0tl3Lni4weIMkl@casper.infradead.org>
In-Reply-To: <Yh0tl3Lni4weIMkl@casper.infradead.org>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon, 28 Feb 2022 12:37:15 -0800
X-Gmail-Original-Message-ID: <CAHk-=wgBfJ1-cPA2LTvFyyy8owpfmtCuyiZi4+um8DhFNe+CyA@mail.gmail.com>
Message-ID: <CAHk-=wgBfJ1-cPA2LTvFyyy8owpfmtCuyiZi4+um8DhFNe+CyA@mail.gmail.com>
Subject: Re: [PATCH 2/6] treewide: remove using list iterator after loop body
 as a ptr
To:     Matthew Wilcox <willy@infradead.org>
Cc:     =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
        Jakob Koschel <jakobkoschel@gmail.com>,
        alsa-devel@alsa-project.org, linux-aspeed@lists.ozlabs.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        linux-iio@vger.kernel.org, nouveau@lists.freedesktop.org,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        Cristiano Giuffrida <c.giuffrida@vu.nl>,
        amd-gfx list <amd-gfx@lists.freedesktop.org>,
        samba-technical@lists.samba.org,
        linux1394-devel@lists.sourceforge.net, drbd-dev@lists.linbit.com,
        linux-arch <linux-arch@vger.kernel.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-rdma <linux-rdma@vger.kernel.org>,
        linux-staging@lists.linux.dev, "Bos, H.J." <h.j.bos@vu.nl>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        intel-wired-lan@lists.osuosl.org,
        kgdb-bugreport@lists.sourceforge.net,
        bcm-kernel-feedback-list@broadcom.com,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Arnd Bergman <arnd@arndb.de>,
        Linux PM <linux-pm@vger.kernel.org>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        Brian Johannesmeyer <bjohannesmeyer@gmail.com>,
        Nathan Chancellor <nathan@kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        v9fs-developer@lists.sourceforge.net,
        linux-tegra <linux-tegra@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        linux-sgx@vger.kernel.org,
        linux-block <linux-block@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>, linux-usb@vger.kernel.org,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux F2FS Dev Mailing List 
        <linux-f2fs-devel@lists.sourceforge.net>,
        tipc-discussion@lists.sourceforge.net,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        dma <dmaengine@vger.kernel.org>,
        linux-mediatek@lists.infradead.org,
        Andrew Morton <akpm@linux-foundation.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Mike Rapoport <rppt@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Feb 28, 2022 at 12:16 PM Matthew Wilcox <willy@infradead.org> wrote:
>
> Then we can never use -Wshadow ;-(  I'd love to be able to turn it on;
> it catches real bugs.

Oh, we already can never use -Wshadow regardless of things like this.
That bridge hasn't just been burned, it never existed in the first
place.

The whole '-Wshadow' thing simply cannot work with local variables in
macros - something that we've used since day 1.

Try this (as a "p.c" file):

        #define min(a,b) ({                     \
                typeof(a) __a = (a);            \
                typeof(b) __b = (b);            \
                __a < __b ? __a : __b; })

        int min3(int a, int b, int c)
        {
                return min(a,min(b,c));
        }

and now do "gcc -O2 -S t.c".

Then try it with -Wshadow.

In other words, -Wshadow is simply not acceptable. Never has been,
never will be, and that has nothing to do with the

        typeof(pos) pos

kind of thing.

Your argument just isn't an argument.

              Linus
