Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10D9BC433EF
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Mar 2022 00:53:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231777AbiCAAyL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 28 Feb 2022 19:54:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231164AbiCAAyJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 28 Feb 2022 19:54:09 -0500
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D359D11172
        for <linux-scsi@vger.kernel.org>; Mon, 28 Feb 2022 16:53:29 -0800 (PST)
Received: by mail-ej1-x633.google.com with SMTP id a23so28277798eju.3
        for <linux-scsi@vger.kernel.org>; Mon, 28 Feb 2022 16:53:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BlmDHl6uq7o6y8aC/cJk7fo5oLGvHdeOO4XUoHPiZHY=;
        b=CuWkmdhnuqYUPLlFfSW5kqvLG+/BaUYxswQvwT5TlbeMKdgX0f6Tdop/2MomIxMIWT
         P4yfskuo3sOir2HSEC5b7N//0EkwPlLVbS+ffho6xWO2QaHJfy0oi9bnLtClO4bSDX+r
         dQzBghLtont2uRRAhfDOfzUglX2wpO3DzhpXQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BlmDHl6uq7o6y8aC/cJk7fo5oLGvHdeOO4XUoHPiZHY=;
        b=0vACfkzEu4QmZ6SEpM17ggqEpO2utMy+Ny3oz4vBlx46auSyL3JZWqTL/Y2X9Q6BVN
         6NRo1LhTR6n8o4mTCo6MG3H1kbZ2fmYswZ+oy0gzCRP1YnVq8KoQGrwct/7icaX6HreZ
         eJnom4bRonSzjtHJned31J996U1JFmZv0eKWOf/IwtihuDSU8aec/neiskgJ8XTlgNu0
         Lgd1lmFyI0oMC1LHgnNKEIsNeONA5AcwoEvMF+uOJcUCYC7Q6XRmUeDO1JakNpnYHaM2
         WdU3P0RNqXUVcSJjciv2q5Pf9PSU0VrlEDrh2KKCNycSzcbViCN7waoMmJgxCKhwrE+M
         uZ+w==
X-Gm-Message-State: AOAM531Hk8St3kHZp/wDXd9wgr+WRepg54BUQeozSqsnEPRJGFipp/Ku
        ZiRGpnx0WSyWQz+q9Nh3oGAnItCnZ46zLDcLnp0=
X-Google-Smtp-Source: ABdhPJwgJzxnKiUYp7ZUomSfGYRYIcyyYOCtRK8t+4dxK6dpKgzLyUE65vy2Mw+npn2OTx/zbisYOA==
X-Received: by 2002:a17:907:334c:b0:6cd:76b7:3948 with SMTP id yr12-20020a170907334c00b006cd76b73948mr18579036ejb.55.1646096008283;
        Mon, 28 Feb 2022 16:53:28 -0800 (PST)
Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com. [209.85.208.48])
        by smtp.gmail.com with ESMTPSA id d8-20020a170906304800b006cdf8a1e146sm4775009ejd.217.2022.02.28.16.53.28
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 28 Feb 2022 16:53:28 -0800 (PST)
Received: by mail-ed1-f48.google.com with SMTP id s24so19958203edr.5
        for <linux-scsi@vger.kernel.org>; Mon, 28 Feb 2022 16:53:28 -0800 (PST)
X-Received: by 2002:a05:6512:3042:b0:437:96f5:e68a with SMTP id
 b2-20020a056512304200b0043796f5e68amr14778245lfb.449.1646095527444; Mon, 28
 Feb 2022 16:45:27 -0800 (PST)
MIME-Version: 1.0
References: <20220228110822.491923-1-jakobkoschel@gmail.com>
 <20220228110822.491923-3-jakobkoschel@gmail.com> <2e4e95d6-f6c9-a188-e1cd-b1eae465562a@amd.com>
 <CAHk-=wgQps58DPEOe4y5cTh5oE9EdNTWRLXzgMiETc+mFX7jzw@mail.gmail.com>
 <CAHk-=wj8fkosQ7=bps5K+DDazBXk=ypfn49A0sEq+7-nZnyfXA@mail.gmail.com>
 <CAHk-=wiTCvLQkHcJ3y0hpqH7FEk9D28LDvZZogC6OVLk7naBww@mail.gmail.com>
 <Yh0tl3Lni4weIMkl@casper.infradead.org> <CAHk-=wgBfJ1-cPA2LTvFyyy8owpfmtCuyiZi4+um8DhFNe+CyA@mail.gmail.com>
 <Yh1aMm3hFe/j9ZbI@casper.infradead.org>
In-Reply-To: <Yh1aMm3hFe/j9ZbI@casper.infradead.org>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon, 28 Feb 2022 16:45:11 -0800
X-Gmail-Original-Message-ID: <CAHk-=wi0gSUMBr2SVF01Gy1xC1w1iGtJT5ztju9BPWYKjdh+NA@mail.gmail.com>
Message-ID: <CAHk-=wi0gSUMBr2SVF01Gy1xC1w1iGtJT5ztju9BPWYKjdh+NA@mail.gmail.com>
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

On Mon, Feb 28, 2022 at 3:26 PM Matthew Wilcox <willy@infradead.org> wrote:
>
> #define ___PASTE(a, b)  a##b
> #define __PASTE(a, b) ___PASTE(a, b)
> #define _min(a, b, u) ({         \

Yeah, except that's ugly beyond belief, plus it's literally not what
we do in the kernel.

Really. The "-Wshadow doesn't work on the kernel" is not some new
issue, because you have to do completely insane things to the source
code to enable it.

Just compare your uglier-than-sin version to my straightforward one.
One does the usual and obvious "use a private variable to avoid the
classic multi-use of a macro argument". And the other one is an
abomination.

              Linus
