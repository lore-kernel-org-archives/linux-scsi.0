Return-Path: <SRS0=+9Kw=5P=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBAEBC43331
	for <linux-scsi@archiver.kernel.org>; Mon, 30 Mar 2020 08:59:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C83A320748
	for <linux-scsi@archiver.kernel.org>; Mon, 30 Mar 2020 08:59:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729870AbgC3I7m (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 30 Mar 2020 04:59:42 -0400
Received: from mout.kundenserver.de ([212.227.17.24]:45789 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728759AbgC3I7m (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 30 Mar 2020 04:59:42 -0400
Received: from mail-qk1-f172.google.com ([209.85.222.172]) by
 mrelayeu.kundenserver.de (mreue106 [212.227.15.145]) with ESMTPSA (Nemesis)
 id 1ML9ds-1jb3sM2qQs-00IDHy for <linux-scsi@vger.kernel.org>; Mon, 30 Mar
 2020 10:59:40 +0200
Received: by mail-qk1-f172.google.com with SMTP id q188so18102857qke.8
        for <linux-scsi@vger.kernel.org>; Mon, 30 Mar 2020 01:59:40 -0700 (PDT)
X-Gm-Message-State: ANhLgQ0tQ4G+arUdOamP+SkCCnAeLDfqIdVLo3Atmm3M0tqlUQQShrqq
        +xinIH5pvo5a7L+E1OVLnJvZiXqi62vGrChKVIQ=
X-Google-Smtp-Source: ADFU+vuGH2p5NuBrJxjWUq870mLAthjAyrCUUSB5e/GMRajawG/zHX2eT4Bv7S2Y2Ep+GlzjOqBmL1bUPwfVifeT8ZU=
X-Received: by 2002:a37:d85:: with SMTP id 127mr3562476qkn.3.1585558779548;
 Mon, 30 Mar 2020 01:59:39 -0700 (PDT)
MIME-Version: 1.0
References: <20200330025304.10743-1-bvanassche@acm.org> <1585537587.4510.6.camel@linux.vnet.ibm.com>
In-Reply-To: <1585537587.4510.6.camel@linux.vnet.ibm.com>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Mon, 30 Mar 2020 10:59:23 +0200
X-Gmail-Original-Message-ID: <CAK8P3a2oWs4g+qzQkKJ7LZH9W8zk3762YYk3mLH_q0_dxJQ1gw@mail.gmail.com>
Message-ID: <CAK8P3a2oWs4g+qzQkKJ7LZH9W8zk3762YYk3mLH_q0_dxJQ1gw@mail.gmail.com>
Subject: Re: [PATCH] sr: Fix a recently introduced W=1 compiler warning
To:     James Bottomley <jejb@linux.vnet.ibm.com>
Cc:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi <linux-scsi@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:poC6lTnHhKSERPrGv65wmrs7Cmfw8BPfhcwaXZLe/PxOMdxIygR
 8ZukLf8FqCwAz9hV0wlPtbjFZjRwPYbtMYXNPL+ckDMlSfNrfSM4TOOaRcGM7uyfy8/7C4z
 NOdfCfsdzldVZutyvINU0CjFWacqDSDOJ2xDfqmcYGEE/tnUAdcX2eyUuMAfa1PlbWp7ljG
 RAmmLBG0kNmGJta1svV9A==
X-UI-Out-Filterresults: notjunk:1;V03:K0:etHD84NRoko=:xN4zRg3cP1ImbwF/JOW8gJ
 5R9uq2o3u5Xp4xYTYjuqbGgze+2AniG4BBmXEaQ0NQ/zxMgnF9/uS4ywgPKDYIeXQ8V9T1b19
 cwT5eLXIW7tMd7ouX2sZXztIUVnFzOtiSinHXSZBgCFrf5VTfos4wZj8qzKO0aW1huw9iWs74
 8n2bKHyuQgBdiiJwiGIuVWdzN34habXk/yyqfqyiHVbZYt59zt9MTxAxXFbV2uFzRNbeQBNCM
 6ITARIHNwo701jKhG/Zxxb/uBcrQAichdVyE4w0Mp7qNk61xdmScWti6Cy5RlTYIIlIqnDzG/
 6haYeWtB5NTv8z2cGjo1mrAfNAfNj9iTVsffFiZn/ox8gEmn/yhVx3POt5xd7H43u0yw1UHqT
 L1wD02ir1or0C5pNsLWScJtidiSTLy/GRPnVJA3Md5b7JcDiKoK/jwoMULXd/vrHNi5/pvYkp
 WsE9GK9iLcfeMs5Gd6LnTo3n9LD0+1IYtTDp1N4ItqBcpJjM/gPEk6pJFQiXfltIsMHyGMFSq
 HeF57ocvPcE2l2oSv7Dw+u0kyxZSZ/Er/U1EyPsbIfh+eWMqTX7yg4s2WMew3Ql0xWSGxG5zm
 jlw46+9b1xHBzQtB/j/ZJK/vvPFJf+SL2YaKv+Jc4YMSLXS+niZMmN1v+Ei8nFEAtU/+/lvTU
 cR/0AP4ARkrUngE/v6Ml2SNPZWhSw89Zo6KUeb1I6pB9wauwzaG0ahPVYuJ/WmhjY6/OiWyui
 AjVTNJS98tHHWWpyI8fyrz84CgZH8po8SUmbgNd/uxYGCq90DGaVih8coYceIhuWhgaW7HoTC
 PhZ/7VzoSSxY33yNHxPQPkAyHUp56252V5IW/aZBTY2N+GF6BA=
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Mar 30, 2020 at 5:06 AM James Bottomley <jejb@linux.vnet.ibm.com> wrote:
>
> On Sun, 2020-03-29 at 19:53 -0700, Bart Van Assche wrote:
> >  static unsigned int sr_block_check_events(struct gendisk *disk,
> >                                         unsigned int clearing)
> > @@ -685,8 +685,9 @@ static const struct block_device_operations
> > sr_bdops =
> >       .owner          = THIS_MODULE,
> >       .open           = sr_block_open,
> >       .release        = sr_block_release,
> > +#ifndef CONFIG_COMPAT
> >       .ioctl          = sr_block_ioctl,
> > -#ifdef CONFIG_COMPAT
> > +#else
> >       .ioctl          = sr_block_compat_ioctl,
>
> Well, this is obviously incorrect: we need the compat ioctl for 32 on
> 64 bit and the real for native 64 bit, so both have to be defined.
> What you propose would work if we were only ever 32 on 64.  I think
> what you want to do is change the second .ioctl to .compat_ioctl.

The correct fix was merged into v5.6-rc4, see commit 03264ddde245 ("scsi:
compat_ioctl: cdrom: Replace .ioctl with .compat_ioctl in four appropriate
places").

        Arnd
