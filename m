Return-Path: <SRS0=npVx=CW=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A88AFC433E2
	for <linux-scsi@archiver.kernel.org>; Sun, 13 Sep 2020 11:47:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7280821974
	for <linux-scsi@archiver.kernel.org>; Sun, 13 Sep 2020 11:47:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725943AbgIMLrR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 13 Sep 2020 07:47:17 -0400
Received: from mout.kundenserver.de ([212.227.17.24]:35703 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725940AbgIMLrH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 13 Sep 2020 07:47:07 -0400
Received: from mail-qk1-f179.google.com ([209.85.222.179]) by
 mrelayeu.kundenserver.de (mreue106 [212.227.15.145]) with ESMTPSA (Nemesis)
 id 1MKt3r-1jwsPr2pu1-00LCiW; Sun, 13 Sep 2020 13:47:02 +0200
Received: by mail-qk1-f179.google.com with SMTP id d20so14326539qka.5;
        Sun, 13 Sep 2020 04:47:02 -0700 (PDT)
X-Gm-Message-State: AOAM530Tgy9LzzwR1sraIzeWLKw3Yl4ijSfioPe/KzC2V11xZhyUsarD
        DZqoJO0O0XCRzcMQ/BlfJYRk5yb8ofjEQ5gMXho=
X-Google-Smtp-Source: ABdhPJxE1gLkULR9mt3IFGX3UpiQsPfyt43rxUrCYfTZIHEtuZ7BwGOLTbMeYWmx4iitP5zm0y1kK7RzMFUmDs53cZw=
X-Received: by 2002:a37:5d8:: with SMTP id 207mr8869223qkf.352.1599997621438;
 Sun, 13 Sep 2020 04:47:01 -0700 (PDT)
MIME-Version: 1.0
References: <20200908213715.3553098-1-arnd@arndb.de> <20200908213715.3553098-3-arnd@arndb.de>
 <20200912074757.GA6688@infradead.org> <CAK8P3a363DxgZnN9x4oNL7W4__kyG1U_34=7Hpqhpc-obAvjWw@mail.gmail.com>
 <20200913065051.GA17932@infradead.org>
In-Reply-To: <20200913065051.GA17932@infradead.org>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Sun, 13 Sep 2020 13:46:45 +0200
X-Gmail-Original-Message-ID: <CAK8P3a3W1EYts=2uL-6kTWwcgBeigLdv-W4mnxBd+En2ZFReLA@mail.gmail.com>
Message-ID: <CAK8P3a3W1EYts=2uL-6kTWwcgBeigLdv-W4mnxBd+En2ZFReLA@mail.gmail.com>
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
X-Provags-ID: V03:K1:g+QV2kn+pkrs2ixKHEQ8cZFehVFfFn7YBxb/gT9JxeleY+ZTK4+
 tNP6Qc8Yrb1APP6iNvfpzDx2s6LzjO84vnh3P5qcmhDixyMXn51gakFgNp3+5jTBpfrt37b
 MxbPfza9YF1BtNdFbN0infzA0siupYmNg2Q53ZhG6O3z2g33IYhSygHcFwifs3brNbAtRH7
 n8/g68cfGshoAcrJulVlw==
X-UI-Out-Filterresults: notjunk:1;V03:K0:j+sDjkSteLc=:VlpxX5B7Un0RBBWmU0ae4V
 Kb5bH4zyufTCsOf0nb13v8BjNc6pIr4nqYuVXzLvAcuc6vZ1+TgXkZulFBCowmBpfq4dzphv+
 r5mcMHCWFl4vKMBNwo193/DOqnLqX+RzuvFpVPhl0NIfmRws0fBC4xwVBDHh3ZlwEY6ZmWolR
 EmxkWOx8HTnuyPsDU4whnKVYGynK0yOju9/cRuT9e3i7Gjg5ShDaApmAJjjrmSydwWOBD/ogu
 gjnM/g94dcPQz724yXnr+QIiqL5Ou1MDn218GxDjcPx5N1e8TNjwfYlQGb+giHwZwE+dSel1s
 yK8vNoOwWcjDbjKtPW+l4a6gpRlLPxFNLiMMmnKAhW+GOstvBxd4oaL6OFVOJwMF0kw/ztR9a
 UJCOR0mEplZQcYjFIQNnGL0JEOk6UcdVDLzHkL6qrw7Tgt4blwdCRdwDSK0+6QPdcpZ0jWnkn
 01UaxNCRA/8Ifmukg7wye0Xa057rKPugKW4pJRrpl4QtfASz1X2/pDpSTR6mR6oLS1a2qG1dM
 /S4bAQV1xu61VzaKTp1jV22hDh9qp+gt3l0sgeqwRxy4yRLWmZ72ULUJ/iVWFHqLtRpYy28AH
 A/BoeeRq3HAq2gCZGXqkdIspHj23YwdDM6B9F+faW6MBKAIFqSU+BC7WydKq78Bl+2riUyzMF
 ZuBfK7BrrnmbuAq7laSqeEymh6ikljjoav7ZUvY3MtgSbm2KvvDdMm4VbIc2ZBII14iFcZrIN
 LxGRd4w8Qs1b9heBhNCodicYM2JX38xGmVVYquqUoLPs08IMVtCQJKJxE/1/iBTkLQAWUEvSN
 +Zq4tKxGJkC4m++DeFcaxnsyqYakX0PrtBV9XO9pvB3614qzp2BM9KUGjzrwzLIRVZh+1yo
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sun, Sep 13, 2020 at 8:50 AM Christoph Hellwig <hch@infradead.org> wrote:
>
> On Sat, Sep 12, 2020 at 02:49:05PM +0200, Arnd Bergmann wrote:
> > fs/quota/compat.c: dqblk = compat_alloc_user_space(sizeof(struct if_dqblk));
> > fs/quota/compat.c: dqblk = compat_alloc_user_space(sizeof(struct if_dqblk));
> > fs/quota/compat.c: fsqstat = compat_alloc_user_space(sizeof(struct
> > fs_quota_stat));
>
> I sent this out a while ago, an Al has it in a branch, but not in
> linux-next:
>
> https://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs.git/log/?h=work.quota-compat

Nice! Aside from already being queued, your patch is also nicer than
my version, and it makes it trivial to fix it for arm oabi as well by adding

#ifdef CONFIG_OABI_COMPAT
#define compat_need_64bit_alignment_fixup in_oabi_syscall
#endif

to arch/arm/include/asm/compat.h

I had considered fixing that case for arch/arm as well but it ended up being
harder to do in my version.

> > drivers/staging/media/atomisp/pci/atomisp_compat_ioctl32.c: karg =
> > compat_alloc_user_space(
> >
> > Had a brief look but did not investigate further, it's complicated.
> >
> > drivers/staging/vc04_services/interface/vchiq_arm/vchiq_arm.c: args =
> > compat_alloc_user_space(sizeof(*args));
> > drivers/staging/vc04_services/interface/vchiq_arm/vchiq_arm.c: args =
> > compat_alloc_user_space(sizeof(*args) +
> > drivers/staging/vc04_services/interface/vchiq_arm/vchiq_arm.c: args =
> > compat_alloc_user_space(sizeof(*args));
> > drivers/staging/vc04_services/interface/vchiq_arm/vchiq_arm.c: args =
> > compat_alloc_user_space(sizeof(*args) +
> > drivers/staging/vc04_services/interface/vchiq_arm/vchiq_arm.c: args =
> > compat_alloc_user_space(sizeof(*args));
> > drivers/staging/vc04_services/interface/vchiq_arm/vchiq_arm.c: args =
> > compat_alloc_user_space(sizeof(*args));
> >
> > Should not be too hard, but I have not looked in detail.
>
> We do not have to care about staging drivers when removing interfaces.
> But to be nice you probably ping the maintainers to see what they can
> do.

Right. As both of these are architecture specific, I also considered moving
the compat_alloc_user_space() and copy_in_user() definitions for the
respective architectures into those drivers and adding the removal
into the TODO files.

> I also have the mount side handles in this branch which I need to rebase
> and submit:
>
> http://git.infradead.org/users/hch/misc.git/shortlog/refs/heads/mount-cleanups

I think I had done an almost identical patch for sys_mount() last year
and forgotten about it. Again, yours is slightly better ;-)

       Arnd
