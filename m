Return-Path: <SRS0=qxeY=C2=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41CD8C433E2
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Sep 2020 15:08:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 118A820795
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Sep 2020 15:08:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727441AbgIQPIL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Sep 2020 11:08:11 -0400
Received: from mout.kundenserver.de ([217.72.192.75]:35939 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727292AbgIQPHx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Sep 2020 11:07:53 -0400
X-Greylist: delayed 310 seconds by postgrey-1.27 at vger.kernel.org; Thu, 17 Sep 2020 11:07:47 EDT
Received: from mail-qv1-f51.google.com ([209.85.219.51]) by
 mrelayeu.kundenserver.de (mreue109 [212.227.15.145]) with ESMTPSA (Nemesis)
 id 1MZTyi-1jxMJo2K0s-00WSnn; Thu, 17 Sep 2020 17:02:34 +0200
Received: by mail-qv1-f51.google.com with SMTP id z18so1114812qvp.6;
        Thu, 17 Sep 2020 08:02:34 -0700 (PDT)
X-Gm-Message-State: AOAM5319yBiLAMHG4Uh9SGJIb67Jv0hLo9ATbvFhGOJ5jEp/ccvakjCd
        xucmZHJk/84VexMEC5v5ewHBysQ+jj2TzN1nu2A=
X-Google-Smtp-Source: ABdhPJwwg51OcIGpQ7qYmV8glkX/F67jzTmoZYd1m5wEPsYFUcifWdhRJzaPKbDt2xZoi3TiNO3sVk708c36klvsPT4=
X-Received: by 2002:a0c:b902:: with SMTP id u2mr27821909qvf.7.1600354952950;
 Thu, 17 Sep 2020 08:02:32 -0700 (PDT)
MIME-Version: 1.0
References: <20200908213715.3553098-1-arnd@arndb.de> <20200912070922.GA1945@infradead.org>
In-Reply-To: <20200912070922.GA1945@infradead.org>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Thu, 17 Sep 2020 17:02:16 +0200
X-Gmail-Original-Message-ID: <CAK8P3a085LEAtMagNm0++UHGKjntYE-6yg_6+VzG96a-hgia_Q@mail.gmail.com>
Message-ID: <CAK8P3a085LEAtMagNm0++UHGKjntYE-6yg_6+VzG96a-hgia_Q@mail.gmail.com>
Subject: Re: [PATCH 1/3] scsi: aacraid: improve compat_ioctl handlers
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Adaptec OEM Raid Solutions <aacraid@microsemi.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Balsundar P <balsundar.p@microsemi.com>,
        Zou Wei <zou_wei@huawei.com>, Hannes Reinecke <hare@suse.de>,
        Sagar Biradar <Sagar.Biradar@microchip.com>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:tdH5RdHOGT01yn08DD7RmONmeXwZPMPHp86hGk2E4IF3abrJQWv
 7GqXVsKZhx5IgLInFQaCf7i57pQ+SQZCemxfvQJVb+kwm8O8657lWkSnRV1jcykTgalprah
 Loldv5Z0o6L3Qm8IILhrA8/fGIW13uJNcu/HTnvLk4PaxGnDuHnQB8dCowjdN5gIJO1nXFQ
 +8Cfcmi5Jk6hf7mnsXl+Q==
X-UI-Out-Filterresults: notjunk:1;V03:K0:JsjqpX9DrTI=:F96vHW9RcymRLrildHRtMl
 uhk7K4gjnVImgJlhtut61+1ZLYkhSuJu4v/VhTbykz6Wx8eEvLtQ9ZrEUJZV0d3Lkk4jK4vsF
 spLtj3Y2VyuN0koLvY+avkS90l6v7O159t2ZuuG8W2Do6b6dcxYL6VRf3YVF4TSy19J+walh1
 0C4r6jWTTb16VdMFXBFk1lpZgdMokg2w06XMVA+r0HJBX733MnmyTPf9fLZs3KwIL5chwfgPm
 mvw1/831030ZkOvVjzOxc0ovayccO98HnA93JHHgudzgcAxRVZmum9EHgc67UvjwMiDZRlHla
 92patzF3ZR2LuPExejLanuun68pcvaTpKK/po9Dh34+rlSxmp9K4R6b6k0wLL28kVFIVRrRVJ
 fWxTuD8lkXewpBv4szNthZObCaXlIhJTWVkUYmMAaWOglLsV0uODMHZRJ7uBiVF2UzCNcTc76
 sMTxlD55tPqBG+niC021b0lXGjcXhFoubbGVL/Uf6Lee6tulKemYGHjJHBfv4QMTVunVtGfMG
 OxsABQGgzwvBMru9reFgxNnNuHiX7zQ0+Ftx4cB7mxH8hoo/1rwI20gdpPhmP6U7/HhSVix5x
 rVCE0KnriixFv0OB304Bkj6qV/ZWmC6w71fLN/CDXdAjQKtVAlJbCUR53Qyd2yTL5O+VqQaUA
 9tNbNH1rPwiDKmg0rUn2yaNFwA95oiw4SQXCfE9vIXOoZa3aGd3uCOnSzoYG0SBMwhpoTUOGh
 yE/UWduQ7mwbz5He91ysHKgXanaq95ZRU/K72FUxisC7WyJdpprdoILyZb1qcZOuCyJnP8k0V
 sYRnecSliKavQ8Xia3d70RkTWy7StJ1dRa8Bl1GKXT072uG8T8DHnmdUQQC3DA9DfThOU/5Ft
 ExUwvQ3Gdvr4OqHtTQD3JO6D7WRAUbMB4k4sxivTYXOI6bj1OKcB1eENZR9MU3zPHDU1c+k0S
 owVP7BzS2kT/VxRwHtorGcjPvQ29+xS+ubF83OZIecHoY4gI6CD9b
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sat, Sep 12, 2020 at 9:09 AM Christoph Hellwig <hch@infradead.org> wrote:
>
> On Tue, Sep 08, 2020 at 11:36:21PM +0200, Arnd Bergmann wrote:
> > @@ -243,8 +244,23 @@ static int next_getadapter_fib(struct aac_dev * dev, void __user *arg)
> >       struct list_head * entry;
> >       unsigned long flags;
> >
> > -     if(copy_from_user((void *)&f, arg, sizeof(struct fib_ioctl)))
> > -             return -EFAULT;
> > +     if (in_compat_syscall()) {
> > +             struct compat_fib_ioctl {
> > +                     u32     fibctx;
> > +                     s32     wait;
> > +                     compat_uptr_t fib;
> > +             } cf;
>
> I find the struct declaration deep down in the function a little
> annoying.
>
> But otherwise this looks good;
>
> Reviewed-by: Christoph Hellwig <hch@lst.de>

I got back to these patches now and moved the struct definition, plus
fixed a typo I noticed while doing so. Thanks!

      Arnd
