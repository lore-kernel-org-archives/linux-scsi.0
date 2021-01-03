Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D624C433DB
	for <linux-scsi@archiver.kernel.org>; Sun,  3 Jan 2021 18:43:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 282F62080D
	for <linux-scsi@archiver.kernel.org>; Sun,  3 Jan 2021 18:43:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726713AbhACSnC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 3 Jan 2021 13:43:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:44658 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725840AbhACSnB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 3 Jan 2021 13:43:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 19024208BA;
        Sun,  3 Jan 2021 18:42:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609699341;
        bh=4L3XgyChKQ8IA35uR9qT1OHieu31sVWBj36FeIrPlhU=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=YwP80aSk51+7d6ywizEVBMGLHZYoeMfrCE2SkNILF+Hd3a9R0nYnxeiR1/SRQ3LNG
         r2ZF6DXSlAVuI/2oWdZ2FmZNgCAALinA7yKd7scTEABfA4IJD7aI/cYxwn9G619rR2
         6id1kkXdowiKOf3vT6aSIY02o4s4Svn+yeMINJS3bqj3aiQqRvA086IcuogS5hxoMo
         h04pVTy+6ZOSrcklt1O24vtxPee2HbmUwFfQ15NQcZ56Yatw7RgHnm7CwvazjgOrG2
         U7lDZrmQd50NfPbzAZ+ajhS/VjOgOxODquf+tLmyzrlt0SE0NWXrPn1jT+xwnhuA0l
         rr8Z6wiQ7K6/w==
Received: by mail-ot1-f44.google.com with SMTP id d20so24143124otl.3;
        Sun, 03 Jan 2021 10:42:21 -0800 (PST)
X-Gm-Message-State: AOAM532e9tn3uDJZ0c0FYvNiIDf6d/lL7TyVOdGqdDnQf1wZZC653MRR
        xPCd1T81qlvgh7pHCeaK2dwRyh0dCit1UcFUCPM=
X-Google-Smtp-Source: ABdhPJxoV0UHMV47rUjuK1A4YEE7xzMJg5iB8e95Fqv6lVNwHEqau83xxT/Pw7Wf1dw7KEBlht/oVwC3UULWMCMl+TQ=
X-Received: by 2002:a9d:7a4b:: with SMTP id z11mr50452343otm.305.1609699340461;
 Sun, 03 Jan 2021 10:42:20 -0800 (PST)
MIME-Version: 1.0
References: <20210103140132.3866665-1-arnd@kernel.org> <75ecb62269cf425164d0fb6f2717d1d0136f43cd.camel@linux.ibm.com>
In-Reply-To: <75ecb62269cf425164d0fb6f2717d1d0136f43cd.camel@linux.ibm.com>
From:   Arnd Bergmann <arnd@kernel.org>
Date:   Sun, 3 Jan 2021 19:42:04 +0100
X-Gmail-Original-Message-ID: <CAK8P3a0hexuwV4VCNOWjANT8xswGbifKfOATwrwi=_1+wjSpMw@mail.gmail.com>
Message-ID: <CAK8P3a0hexuwV4VCNOWjANT8xswGbifKfOATwrwi=_1+wjSpMw@mail.gmail.com>
Subject: Re: [PATCH] cxgb4: fix TLS dependencies again
To:     "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc:     Karen Xie <kxie@chelsio.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Tom Seewald <tseewald@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Randy Dunlap <rdunlap@infradead.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sun, Jan 3, 2021 at 5:51 PM James Bottomley <jejb@linux.ibm.com> wrote:
> On Sun, 2021-01-03 at 15:01 +0100, Arnd Bergmann wrote:
> > From: Arnd Bergmann <arnd@arndb.de>
> >
> > A previous patch tried to avoid a build failure, but missed one case
> > that Kconfig warns about:
> >
> > WARNING: unmet direct dependencies detected for CHELSIO_T4
> >   Depends on [m]: NETDEVICES [=y] && ETHERNET [=y] &&
> > NET_VENDOR_CHELSIO [=y] && PCI [=y] && (IPV6 [=y] || IPV6 [=y]=n) &&
> > (TLS [=m] || TLS [=m]=n)
> >   Selected by [y]:
> >   - SCSI_CXGB4_ISCSI [=y] && SCSI_LOWLEVEL [=y] && SCSI [=y] && PCI
> > [=y] && INET [=y] && (IPV6 [=y] || IPV6 [=y]=n) && ETHERNET [=y]
> > x86_64-linux-ld: drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.o: in
> > function `cxgb_select_queue':
> > cxgb4_main.c:(.text+0xf5df): undefined reference to
> > `tls_validate_xmit_skb'
> >
> > When any of the dependencies of CHELSIO_T4 are not met, then
> > SCSI_CXGB4_ISCSI must not 'select' it either.
> >
> > Fix it by mirroring the network driver dependencies on the iscsi
> > driver. A more invasive but also more reliable alternative would
> > be to use 'depends on CHELSIO_T4' instead.
> >
> > Fixes: 659fbdcf2f14 ("cxgb4: Fix build failure when CONFIG_TLS=m")
> > Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> > ---
> >  drivers/scsi/cxgbi/cxgb4i/Kconfig | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/drivers/scsi/cxgbi/cxgb4i/Kconfig
> > b/drivers/scsi/cxgbi/cxgb4i/Kconfig
> > index 8b0deece9758..2af88a55fbca 100644
> > --- a/drivers/scsi/cxgbi/cxgb4i/Kconfig
> > +++ b/drivers/scsi/cxgbi/cxgb4i/Kconfig
> > @@ -1,7 +1,7 @@
> >  # SPDX-License-Identifier: GPL-2.0-only
> >  config SCSI_CXGB4_ISCSI
> >       tristate "Chelsio T4 iSCSI support"
> > -     depends on PCI && INET && (IPV6 || IPV6=n)
> > +     depends on PCI && INET && (IPV6 || IPV6=n) && (TLS || TLS=n)
> >       depends on THERMAL || !THERMAL
> >       depends on ETHERNET
> >       depends on TLS || TLS=n
>
> I thought all separated depends statements were the equivalent of && in
> a single statement.  If so, how does repeating TLS || TLS=n twice fix
> the problem?  This sounds more like we have some sort of bug in our
> Kconfig apparatus.

No, just a mistake on my end. I had tried v5.10-rc1 to make sure the
patch was still required, but then rebased on top of torvalds/master
(close to -rc2) before sending it out, and this contains Randy's version
of the same patch, cb5253198f10 ("scsi: cxgb4i: Fix TLS dependency").

       Arnd
