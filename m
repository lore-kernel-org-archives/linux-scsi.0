Return-Path: <SRS0=SrIF=DD=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FE58C4741F
	for <linux-scsi@archiver.kernel.org>; Sat, 26 Sep 2020 21:19:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 22F67221EA
	for <linux-scsi@archiver.kernel.org>; Sat, 26 Sep 2020 21:19:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727052AbgIZVTz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 26 Sep 2020 17:19:55 -0400
Received: from mout.kundenserver.de ([217.72.192.75]:56079 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726242AbgIZVTy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 26 Sep 2020 17:19:54 -0400
Received: from mail-qt1-f176.google.com ([209.85.160.176]) by
 mrelayeu.kundenserver.de (mreue106 [212.227.15.145]) with ESMTPSA (Nemesis)
 id 1N94uf-1kXRcs0i5H-0165an; Sat, 26 Sep 2020 23:19:53 +0200
Received: by mail-qt1-f176.google.com with SMTP id o21so4798760qtp.2;
        Sat, 26 Sep 2020 14:19:52 -0700 (PDT)
X-Gm-Message-State: AOAM532tnKVTlmv//yClbChV0fsjMKKEG8UqGLOfS+knfPwgji4jrD4F
        hfJItKYP+kLCtaaezYHDjUYDWsqIjS3Ze4Hz79o=
X-Google-Smtp-Source: ABdhPJy/AOMJj0pC8ENorW52bA9sy1JcYCgw1CaQKXsrJUfL6PJIboV9+0pbNNjqzndycmvRuVWDhircQ8q8ehm1Vq0=
X-Received: by 2002:ac8:64a:: with SMTP id e10mr5970225qth.142.1601155191942;
 Sat, 26 Sep 2020 14:19:51 -0700 (PDT)
MIME-Version: 1.0
References: <20200918120955.1465510-1-arnd@arndb.de> <20200918121543.1466090-1-arnd@arndb.de>
 <20200919052622.GE30063@infradead.org>
In-Reply-To: <20200919052622.GE30063@infradead.org>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Sat, 26 Sep 2020 23:19:36 +0200
X-Gmail-Original-Message-ID: <CAK8P3a01930JPMj6ie=9+GtvRQThPzxH0_ge+OWydcZd7qRkSA@mail.gmail.com>
Message-ID: <CAK8P3a01930JPMj6ie=9+GtvRQThPzxH0_ge+OWydcZd7qRkSA@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] scsi: megaraid_sas: simplify compat_ioctl handling
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Anand Lodnoor <anand.lodnoor@broadcom.com>,
        megaraidlinux.pdl@broadcom.com,
        linux-scsi <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:pV7IwuMt6z/7K3b+atHNe0A3ao3pllVbIVZkUZNnxtTya/MiDha
 4/q/lYRQ2C6cCOBUc4YDfG+x2/a+j0HndeTAHvKyLwczp0GUBlGnmplWPKjyv2RcszbNX8P
 fLWrJlhQYMWsKjte84PEfpn4/hl4qRvso7+/jpFoin3pyb8G6YDTsWHy6SGdG7uj0DCTOfE
 rhlg9M3MYU1+5Fx1AAgAg==
X-UI-Out-Filterresults: notjunk:1;V03:K0:RpxU5NpL5Wk=:EiBoiDw1dnzeMAp7VevoaA
 HVzHeyvWMZr48H8Typ1XCkaqtiyzMuFafSNgYY/vprqk4sxfewH59aJgtEHwpbHwUwz7Z7Ea1
 tyYQ4SoiS7XPy3dD9UX6ueRQkwyooQNDgybuE+2gpjWGXmFpeUUAHaGKnZ6w/lb0Wb8e9DASM
 PsEseK34JFBwl4fwUw2eVn3lXYL92kLFyHiMHETHjf9OVKPGnkoSgFpx65aamKJZ6qiqaoBCG
 cJ44cQKq+9owHz3aKS2mMP4Z8N8a7IgYS279+MWr5WA7Yrwfz5euOLEeNlJU/3M6//zUIG2YJ
 w96jowGntal4tRNRlcHxv+En2HtVXQRl2F5Lb0ugiT/vvaxdHrYsl5AqYZhunzyN2Ks9YkDcd
 3d5rUfhNfi89EvxvL11Fm+xujbpqlderEj2pC+Lkit7sz2rrVYAiN76J60bUYuNssMkhFNJCa
 w4i7JSM0KLKkVgCaR1++Z5YWKcrK5aYqIgNDCTQBq6pxAqjv/yfIaLS7z7V/KWQMN8p8qe8BB
 xzAC1M++TquU5jqNnEZcqcvPSU4rNdw6z5j37eiHxsDm8QMRgTWLtXC8wkTXtVeTjvdqkS6js
 oZWbPCQFzKniCMCGSAM1se3p/WWfiavM5A0x4lTyvipaaO7QfQ441M7GVx4zAA0Z42BOZH6oe
 ujbzjTqIIz8Ck3Xk0NPca38TJVw+pxSLeN9kJK8mDR2kCeiVBjpJupUZPDKNjiAzXJ4FWfveM
 q2zUNDNAe4XcYxewdNdLu8Sx3j2xJsB0CxKUGbgzX4Zjy1oXS0RFIuu2XFkQyKIdbZ7FT0czj
 wGaIPwBl15eoyLKQnBpvcZg8WVhC5kZgJlsP31gRYwFCSLqs3qWYbRxuyfuhc/GhI1BKvn+bl
 4H2ZSXBt6qn+e/0vhCSQmQFPxDDkpUTq8X9VIEnanQaVUa6x212QqGaH6GnhbK/TwriQxs1Qh
 9sfe2c19EEJnlYSHxnNdcwDnVkewvI4V0nuRhczZ7hd2/wVRuJ692
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sat, Sep 19, 2020 at 7:26 AM Christoph Hellwig <hch@infradead.org> wrote:
> On Fri, Sep 18, 2020 at 02:15:43PM +0200, Arnd Bergmann wrote:
> > @@ -8279,16 +8279,18 @@ megasas_mgmt_fw_ioctl(struct megasas_instance *instance,
> >        * copy out the sense
> >        */
> >       if (ioc->sense_len) {
> > +             void __user *uptr;
> >               /*
> >                * sense_ptr points to the location that has the user
> >                * sense buffer address
> >                */
> > +             sense_ptr = (void *)ioc->frame.raw + ioc->sense_off;
> > +             if (in_compat_syscall())
> > +                     uptr = compat_ptr(get_unaligned((u32 *)sense_ptr));
>
> should the u32 * here by a compat_uptr *? Not tat it would make a
> difference, just better document what we are doing.

Ok, changed now. The longer type name leads to a slightly ugly
line break, but you are right that is is the correct thing to do.

> > +     for (i = 0; i < MAX_IOCTL_SGE; i++) {
> > +             compat_uptr_t iov_base;
> > +             if (get_user(iov_base, &cioc->sgl[i].iov_base) ||
> > +                 get_user(ioc->sgl[i].iov_len, &cioc->sgl[i].iov_len)) {
> > +                     goto out;
> > +             }
>
> I don't think we need the braces here.

ok.

> > +     return ioc;
> > +out:
> > +     kfree(ioc);
> > +
> > +     return ERR_PTR(err);
>
> spurious empty line.

ok

     Arnd
