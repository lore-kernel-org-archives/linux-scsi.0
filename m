Return-Path: <SRS0=qxeY=C2=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7EC25C43461
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Sep 2020 15:03:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3F6CF2220D
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Sep 2020 15:03:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727340AbgIQPCj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Sep 2020 11:02:39 -0400
Received: from mout.kundenserver.de ([212.227.126.134]:56841 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727891AbgIQPCN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Sep 2020 11:02:13 -0400
X-Greylist: delayed 333 seconds by postgrey-1.27 at vger.kernel.org; Thu, 17 Sep 2020 11:02:04 EDT
Received: from mail-lj1-f178.google.com ([209.85.208.178]) by
 mrelayeu.kundenserver.de (mreue009 [212.227.15.129]) with ESMTPSA (Nemesis)
 id 1MXp1Q-1k06J73QwW-00YBtl; Thu, 17 Sep 2020 16:56:05 +0200
Received: by mail-lj1-f178.google.com with SMTP id c2so2282441ljj.12;
        Thu, 17 Sep 2020 07:56:05 -0700 (PDT)
X-Gm-Message-State: AOAM531gOuxw6B3HMibCIs7c5PN5vP97LgwXiV1TDUs5+Seel9FGAZx9
        a0mOk6rbITsT3rYNCzNm+zcSies232Zt5I5qGlw=
X-Google-Smtp-Source: ABdhPJyXAeW/X/vUfrjW8LIX+29c3f5FGDUd17W9rK9Pn/Vi9uZ/dih0ocJwvfWpmI4GGWt1IoC+QnOz/UhV92idazI=
X-Received: by 2002:a2e:b161:: with SMTP id a1mr9630509ljm.189.1600354565212;
 Thu, 17 Sep 2020 07:56:05 -0700 (PDT)
MIME-Version: 1.0
References: <20200908213715.3553098-1-arnd@arndb.de> <20200908213715.3553098-3-arnd@arndb.de>
 <20200912074757.GA6688@infradead.org> <CAK8P3a363DxgZnN9x4oNL7W4__kyG1U_34=7Hpqhpc-obAvjWw@mail.gmail.com>
 <20200913065051.GA17932@infradead.org> <CAK8P3a3W1EYts=2uL-6kTWwcgBeigLdv-W4mnxBd+En2ZFReLA@mail.gmail.com>
In-Reply-To: <CAK8P3a3W1EYts=2uL-6kTWwcgBeigLdv-W4mnxBd+En2ZFReLA@mail.gmail.com>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Thu, 17 Sep 2020 16:55:49 +0200
X-Gmail-Original-Message-ID: <CAK8P3a2r=-JQLyVeLhFvDtWrdtJN_pWsPHRoi5VHcgfK0SbQ5g@mail.gmail.com>
Message-ID: <CAK8P3a2r=-JQLyVeLhFvDtWrdtJN_pWsPHRoi5VHcgfK0SbQ5g@mail.gmail.com>
Subject: Re: compat_alloc_user_space removal, was Re: [PATCH 3/3] scsi:
 megaraid_sas: simplify compat_ioctl handling
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Anand Lodnoor <anand.lodnoor@broadcom.com>,
        Chandrakanth Patil <chandrakanth.patil@broadcom.com>,
        Hannes Reinecke <hare@suse.de>, megaraidlinux.pdl@broadcom.com,
        linux-scsi <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:U4pNn/L9pBqEnn0uQRl1oAnkE71gwgvZK+cqa3vHgq8KSmYiB3E
 3KsKvUbLCuC0cmbjsajD/C/Dt2B4vv1nf5tvHv/NsSJ5O/EZctPiMwkp7QCg1+IbBlFfjIM
 5W9TyvIpjBQkWYg8eWIfKLvX5vfsAmAtbOYJHmFEBaZFe4CyEJsvRaLFMEa83jUpoz8t1JG
 aNOECUm/UcrC8imlucwow==
X-UI-Out-Filterresults: notjunk:1;V03:K0:Mn13FfXX9Ws=:MXHVqkdHegh59FkNWjNWl5
 a/8j9by+D3JHCbPGUsb2X+bzOCR3gco8vl71h7tPpm21Xc75B5X0l7i5rWf4fcIU0m4x05BoV
 SK8pOMOnng+d+eQe2J+WF/n9B3Nm8jWKkn9uCPbT5r/0gex6v5F9JVhTJvln/sHxW2bgmkFwB
 I9Kc3swzyd/WERVPEIml+hdJv3FdsnPryh1s1JPjDydx0HlYVMwnRMRJsy6fD9LkNw6NKnrqi
 YnS2ynMTrK+aPZmWsAekilHWAjcRdly69M6V+kGGfYUNrxrFIeXYU/RUbuRhaA3JLP3HyXorm
 jI7ZFyDYh+RLYXIzAQtlvcC0fS5fmszOqq9ZpgEh+B17oRQqKRlHjtXK1UTaEyU6802fO9Rtv
 eQg3Y2Y0DK4HXPppkosSHtCbgF1jwuG7d66RNQ8Jwuboj0fk1AqIGbwR2Ws3MqpOW7x/15ncK
 wlKqkH8d+6eDz6puZ5167Ssp8QKWr3+fY5KAXtSC5CZBeQ0Tf+d+nXS02Y8mm5VJSqlX0zWJQ
 WGRxOHbIqq4iHi8DKgxpbpHfShQWfKfq5r+rOO0e78RkGzAd7vaVHUF2C7Y+rTYKb3NzxLI2j
 GieFnoXl5b5KkkXNdXQeLOvtR4x1TXVenybLvqgEJdatccwCO0AgEoCoOSpfG75PsDgE8R+pu
 MciRgi1W98Ao++x5tU5HWYX0rp0EUXsVSbH/JXrpJCaPqXR6gWX6mnfD5fSP7rf6t2UjXAugH
 nEE4U2IWx/L84IW+J28m87phQTupboi5u1xGdSUR10wUONniu13qtbQ2ot270W4eh2N0b2OEH
 Np95AQXqd1YjTh2HG432bgdsx9SEpXmgZbkak7E4cQyUR4k29u8KNnBtzF+LkuJ8HYnS2F1Sv
 Dr84/IEsKpi+DiDC/K+CmR04q8vVx/ulNKHRBgiG9Wjgu48oPpiaa/d6gof3uPtR4OPpP4zSW
 LqsEWoO+4hLcu3xKX+9jbEEZ51FlyFF/Uki7rb1PKcQHRYIDcRhIE
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sun, Sep 13, 2020 at 1:46 PM Arnd Bergmann <arnd@arndb.de> wrote:
>
> On Sun, Sep 13, 2020 at 8:50 AM Christoph Hellwig <hch@infradead.org> wrote:
> >
> > On Sat, Sep 12, 2020 at 02:49:05PM +0200, Arnd Bergmann wrote:
> > > fs/quota/compat.c: dqblk = compat_alloc_user_space(sizeof(struct if_dqblk));
> > > fs/quota/compat.c: dqblk = compat_alloc_user_space(sizeof(struct if_dqblk));
> > > fs/quota/compat.c: fsqstat = compat_alloc_user_space(sizeof(struct
> > > fs_quota_stat));
> >
> > I sent this out a while ago, an Al has it in a branch, but not in
> > linux-next:
> >
> > https://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs.git/log/?h=work.quota-compat
>
> Nice! Aside from already being queued, your patch is also nicer than
> my version, and it makes it trivial to fix it for arm oabi as well by adding
>
> #ifdef CONFIG_OABI_COMPAT
> #define compat_need_64bit_alignment_fixup in_oabi_syscall
> #endif
>
> to arch/arm/include/asm/compat.h
>
> I had considered fixing that case for arch/arm as well but it ended up being
> harder to do in my version.

Unfortunately, the commit b902bfb3f0e "arm64: stop using <asm/compat.h>
directly" seems to introduce a circular header file inclusion between
linux/compat.h and asm/stat.h, breaking arm64 compilation.

Moving the compat_u64/compat_s64 definitions to include/asm-generic/compat.h
works fine though.

      Arnd
