Return-Path: <SRS0=wv9C=AK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B0FEC433DF
	for <linux-scsi@archiver.kernel.org>; Mon, 29 Jun 2020 19:45:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3896B206BE
	for <linux-scsi@archiver.kernel.org>; Mon, 29 Jun 2020 19:45:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388041AbgF2Tpb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 29 Jun 2020 15:45:31 -0400
Received: from mout.kundenserver.de ([212.227.126.135]:42755 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388032AbgF2Tpa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Jun 2020 15:45:30 -0400
Received: from mail-qt1-f177.google.com ([209.85.160.177]) by
 mrelayeu.kundenserver.de (mreue012 [212.227.15.129]) with ESMTPSA (Nemesis)
 id 1MoNMu-1j1awT00Rk-00oqeQ for <linux-scsi@vger.kernel.org>; Mon, 29 Jun
 2020 21:45:29 +0200
Received: by mail-qt1-f177.google.com with SMTP id i3so13775473qtq.13
        for <linux-scsi@vger.kernel.org>; Mon, 29 Jun 2020 12:45:28 -0700 (PDT)
X-Gm-Message-State: AOAM530GnC0wfEhaDC3aWanda+kbNJExw9jjYDfB3JcHa09pQ5N9Za8a
        ODVCSASwV3mJQMiBSSuZIQbf2iEoWtSMG8HK9Fw=
X-Google-Smtp-Source: ABdhPJwJJTArFyW18ls47FmeVQ5Yv8pWcd8cwnPK/r7P0yDVg4cIxazFqlwkCcOsh8nYd02ZGv5EY0JjPtmF+FyNG6I=
X-Received: by 2002:ac8:7587:: with SMTP id s7mr17479182qtq.304.1593459927852;
 Mon, 29 Jun 2020 12:45:27 -0700 (PDT)
MIME-Version: 1.0
References: <20200629161051.14943-1-bvanassche@acm.org> <CAK8P3a1H0H82fp_kLDnE4=SihDO4PgB+jDiLjfmUsPfdFYXoCQ@mail.gmail.com>
 <6504926f-3cca-3fe8-464c-9a1c4d8943d3@acm.org>
In-Reply-To: <6504926f-3cca-3fe8-464c-9a1c4d8943d3@acm.org>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Mon, 29 Jun 2020 21:45:11 +0200
X-Gmail-Original-Message-ID: <CAK8P3a1KGCp3FeuHN0SGiL76DuEAUkgePWS5rfwSWmtr23bDTw@mail.gmail.com>
Message-ID: <CAK8P3a1KGCp3FeuHN0SGiL76DuEAUkgePWS5rfwSWmtr23bDTw@mail.gmail.com>
Subject: Re: [PATCH] ch: Do not read past the end of vendor_labels[]
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        Hannes Reinecke <hare@suse.de>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:KNl/+aC12+6IoWAxN+EFij1ghLKPppgMNDd130PZFXSnDYZ68R2
 xp2QUUBO+NQ/5NpKdfDBJyC7T17mzpZL7v3B5TQswhK/uPQWJYdCwDrpxxun/TRFTYuBM8w
 50E8/XBF/zDmrIw7QQtKh0fkc+LnjdLyeTXwvReg0YqOq407S/1axwcqH2fB3MyO+7PE9XT
 H8DolSJ8olZUcWk1wLz2Q==
X-UI-Out-Filterresults: notjunk:1;V03:K0:pODthsIQ6II=:XqDIY4z9e73A5CxVobXHTG
 uIPTbfcfBd6Q+vy5/je2XCVjNYdwHmKCFc986vkrGp4o9okVUc7BjzMLrm+NdHudbpXciq7jc
 83vrThMjV+Qi5fZkfPFev+p5cTQzKdEnGhhnrxXxoO2lt4CR0cOmkJ/x2dOw2xT+GVLA7uLBu
 PNmgfe/YHbw1hfNqxxjOfqyAJxCi95LJTmv8SUPeyvJ+rLnjFnG+xWqCFCwJozxVcQZV9hRwX
 Dow8unO9ZjHk0r8wilFnVlFwge0CYIU1wM/Oqnb6VJCZlglHXzXrtn+Lqsw4GOcZ9QGBbTuxF
 ow1CdiqL71kXTfruNj1WLREv0WRmO4G9FCaCrwy0jvk5F1oNIfCca9s96sgUhufLO2wHxJ1TU
 TEkP6eREYQao9gapQo5xtZL9xUe1eE8k2KSwJ6MMI/8m6ej0adQsn0boElZSjT5ru0QKUVIdB
 PzP849DEC1tdKbKcLapg+5+y8YFrndn3Tctu+i0jXo0CpuUL0fB8zWw1k9Uufm90t6VM0aA38
 LCynryTouoMV5fu6Mk7na7ovbS/W/ut600NKrStBWziySoauVjmjXgs0wnQk8Pv79yb+iHHUA
 DWnC7JzPz9sDTsl4CtWMQYehpvsXScOcLPuSwGK88ytsEbuekOhFgCqsn8k7o8HzuNT9FmBeN
 z9zhQrMpDsTnnEs09UBHsCFsXXFRcemOeAfD97XAWz5MQRjlDWViDq6kzUjSocRfhuYssbVQN
 JSOMZ1OkomxL3i60pF8dzDmd3R5UCoStg43Qxo5SZTbYCBaq3gHUIow4UJH3x0j1xykwllgJV
 djQY/H/ZcpXe6hW2zGMNJEU3x5qVEJ99LN8WAMyRuZNmqjViP4=
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Jun 29, 2020 at 9:26 PM Bart Van Assche <bvanassche@acm.org> wrote:
> On 2020-06-29 11:33, Arnd Bergmann wrote:
> > On Mon, Jun 29, 2020 at 6:11 PM Bart Van Assche <bvanassche@acm.org> wrote:
> >> diff --git a/drivers/scsi/ch.c b/drivers/scsi/ch.c
> >> index b81b397366db..b675a01380eb 100644
> >> --- a/drivers/scsi/ch.c
> >> +++ b/drivers/scsi/ch.c
> >> @@ -651,19 +651,23 @@ static long ch_ioctl(struct file *file,
> >>                 memset(&vparams,0,sizeof(vparams));
> >>                 if (ch->counts[CHET_V1]) {
> >>                         vparams.cvp_n1  = ch->counts[CHET_V1];
> >> -                       memcpy(vparams.cvp_label1,vendor_labels[0],16);
> >> +                       strncpy(vparams.cvp_label1, vendor_labels[0],
> >> +                               ARRAY_SIZE(vparams.cvp_label1));
> >>                 }
> >
> > Against which tree is this? I see in mainline the correct
> >
> >       strncpy(vparams.cvp_label1,vendor_labels[0],16);
> >
> > rather than the broken memcpy. If this was changed recently to the
> > broken version, maybe send a revert, or add a "Fixes" tag?
>
> Hi Arnd,
>
> Thanks for having taken a look. This patch applies to Martin's for-next
> branch. The most recent ch patch I found in Linus' master branch is "ch:
> remove ch_mutex()" from February 2020. I haven't found any more recent
> ch patches in the linux-next/master branch either. Have I perhaps been
> looking at the wrong repository or the wrong branch?

That is the right branch, and I don't see any later changes to the file
after Feb 2020 in there or in mainline either, but I also clearly see it
using strncpy(). See also:

https://elixir.bootlin.com/linux/v5.8-rc3/source/drivers/scsi/ch.c#L647

I think there were some patches under discussion about replacing
a lot of strncpy() calls with the more intuitive memcpy(), strnlcpy()
or strscpy() alternatives, but in this case strncpy() in in fact the
correct one (as you also concluded) and I don't see any patches to
this file getting applied to that effect.

       Arnd
