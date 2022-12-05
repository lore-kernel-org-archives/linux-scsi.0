Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85369C4332F
	for <linux-scsi@archiver.kernel.org>; Mon,  5 Dec 2022 20:35:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233095AbiLEUfm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 5 Dec 2022 15:35:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232876AbiLEUfl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Dec 2022 15:35:41 -0500
Received: from mail-vs1-xe2c.google.com (mail-vs1-xe2c.google.com [IPv6:2607:f8b0:4864:20::e2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB4AB10B46
        for <linux-scsi@vger.kernel.org>; Mon,  5 Dec 2022 12:35:40 -0800 (PST)
Received: by mail-vs1-xe2c.google.com with SMTP id b189so6374729vsc.10
        for <linux-scsi@vger.kernel.org>; Mon, 05 Dec 2022 12:35:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qFTi/EIm231UDoHzwjip2wcifKLUtbEyBimAW5q1nBE=;
        b=G9/2zHyJAXWcLuG4CYYyDjsG3wMQ+Os78SrW5PLI0KZyqUQjyjJZWffOpaCYYaa7MU
         yJANfMjLRG8buM1qJRbmILUqUfPnAFeQA1F0rEa1D3JT6KED/tfkZow4zbXMtCKFV6OD
         1GvXvG995vkCUOe4/QGVnnXXgb5WxIRtRwC+rbj1M5ZRSI0nVc5sEfhNPNTf+OawlBFX
         gPzpi4SSqAIYKEZjgN/zEJNeTqGl6zPS7nFdofdcc5ViXPF95cdbLpxH+ZztK+PvZYHZ
         jw7mNAVQUcSxpAzEJwScRLj7Bxuy0Y9vxkuz/6G3412+YK+BEu/6Glz92iyCcjjY30qE
         F8Lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qFTi/EIm231UDoHzwjip2wcifKLUtbEyBimAW5q1nBE=;
        b=1SF7cfZMm5H/x/9JPssLn5XwAos/xBljQas54x29a0oGXa9XhouV7NIZ/hDbHmjEI8
         5rVyWd6ZGAqk1wh8UVeNx/8qrwwRRKGGXsvieapjTO/XwFbRKqpiIFQGTBXj9UeQRSHD
         aujEc+VkgOxjx4DxRxWH74rNjrpYg3J2uHtVgSt/6GSTv/FO9u5O7fnoswVTLMwdL6pu
         /N+6Fllr5FWC5Is5ec7VrRFzsnCymZ46DdM507Sl0lBGKkg/naCZixo5B4f6WEjPvMEO
         readSI5Nll4yr1+lMpWn24LHY3EqJFZxAv/0nq8YTePH/N67G5Eaunyw9AfXnlJXwsKL
         cUSQ==
X-Gm-Message-State: ANoB5pmTFSIvGjfvZUvv+qV9xbpCUgZmvpQeWh499H+51hPZZJzCMeQx
        SvgsZG7w2XWeYnnAhdwcRGuvj57YibxajyXh/4Mxzw==
X-Google-Smtp-Source: AA0mqf7MB2LLmyAgUEmc373KKoUMFotSP/Hm9OtWsUgrY1RZnvtlRZ/+/FkhUm+SUZshtLHs/8QlYlIHB++A57PkUUg=
X-Received: by 2002:a67:f88c:0:b0:3b0:dbae:4115 with SMTP id
 h12-20020a67f88c000000b003b0dbae4115mr12656784vso.32.1670272539806; Mon, 05
 Dec 2022 12:35:39 -0800 (PST)
MIME-Version: 1.0
References: <20221205162035.2261037-1-alvaro.karsz@solid-run.com>
 <fe2800f1-aaae-33e8-aaf0-83fd034162d5@kernel.dk> <CAJs=3_AKOMWBpvKqvX6_c=zN1cwEM7x9dzGr7na=i-5_16rdEg@mail.gmail.com>
 <23c98c7c-3ed0-0d26-24c0-ed8a63266dcc@kernel.dk> <20221205152708-mutt-send-email-mst@kernel.org>
In-Reply-To: <20221205152708-mutt-send-email-mst@kernel.org>
From:   Enrico Granata <egranata@google.com>
Date:   Mon, 5 Dec 2022 13:35:28 -0700
Message-ID: <CAPR809siFTeKSVxGPmnWpbyKHKoiVY-YYVV+Wzv2bVtvc4XBfA@mail.gmail.com>
Subject: Re: [PATCH v3] virtio_blk: add VIRTIO_BLK_F_LIFETIME feature support
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Alvaro Karsz <alvaro.karsz@solid-run.com>,
        virtualization@lists.linux-foundation.org,
        linux-block@vger.kernel.org, dm-devel@redhat.com,
        linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org,
        Jason Wang <jasowang@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The original definitions for these fields come from JESD84-B50, which
is what eMMC storage uses. It has been a while, but I recall UFS doing
something pretty similar.
Systems that don't have a well defined notion of durability would just
not expose the flag (e.g. a spinning disk), and going for what
eMMC/UFS expose already would make implementations fairly seamless for
a lot of common embedded scenarios.

Of course, if you see room for improvement to the spec, I'd be very
interested in hearing your thoughts

Thanks,
- Enrico

Thanks,
- Enrico


On Mon, Dec 5, 2022 at 1:29 PM Michael S. Tsirkin <mst@redhat.com> wrote:
>
> On Mon, Dec 05, 2022 at 11:53:51AM -0700, Jens Axboe wrote:
> > On 12/5/22 11:36=E2=80=AFAM, Alvaro Karsz wrote:
> > > Hi,
> > >
> > >> Is this based on some spec? Because it looks pretty odd to me. There
> > >> can be a pretty wide range of two/three/etc level cells with wildly
> > >> different ranges of durability. And there's really not a lot of slc
> > >> for generic devices these days, if any.
> > >
> > > Yes, this is based on the virtio spec
> > > https://docs.oasis-open.org/virtio/virtio/v1.2/csd01/virtio-v1.2-csd0=
1.html
> > > section  5.2.6
> >
> > And where did this come from?
>
>
> Here's the commit log from the spec:
>         In many embedded systems, virtio-blk implementations are
>         backed by eMMC or UFS storage devices, which are subject to
>         predictable and measurable wear over time due to repeated write
>         cycles.
>
>         For such systems, it can be important to be able to track
>         accurately the amount of wear imposed on the storage over
>         time and surface it to applications. In a native deployments
>         this is generally handled by the physical block device driver
>         but no such provision is made in virtio-blk to expose these
>         metrics for devices where it makes sense to do so.
>
>         This patch adds support to virtio-blk for lifetime and wear
>         metrics to be exposed to the guest when a deployment of
>         virtio-blk is done over compatible eMMC or UFS storage.
>
>         Signed-off-by: Enrico Granata <egranata@google.com>
>
> Cc Enrico Granata as well.
>
>
> > --
> > Jens Axboe
> >
>
