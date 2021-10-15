Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7D30C43217
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Oct 2021 17:03:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 85270611C1
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Oct 2021 17:03:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241934AbhJORFg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 15 Oct 2021 13:05:36 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:23256 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241905AbhJORFf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 15 Oct 2021 13:05:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634317408;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=4dN0h5lrPhvnBjfapbewXwM2oI6C3bfdTUY0cpFI420=;
        b=ZB3BlE0CXg+MTcMaXvhJcUXezFYZdtX5KsKpEEWoXceJFdgKkKWgNlQ7I5xz5aOFkUVp/9
        yl8h2Uz58dCcVLdZm5fNpSLAtSii+yH7PG4ohQLPRH0M+Xb/IcOd+KFwSKAweZu80eVu49
        Nh/siCmSXCU16x9Jzmsvpl0mFiTrDmY=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-592-KyxP1k_TORO6U4izZN7L5g-1; Fri, 15 Oct 2021 13:03:27 -0400
X-MC-Unique: KyxP1k_TORO6U4izZN7L5g-1
Received: by mail-wm1-f71.google.com with SMTP id m1-20020a7bca41000000b00322ee09ca1aso355087wml.9
        for <linux-scsi@vger.kernel.org>; Fri, 15 Oct 2021 10:03:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4dN0h5lrPhvnBjfapbewXwM2oI6C3bfdTUY0cpFI420=;
        b=Tq69ZMRUvTrCt49K+DNRslUiJ9/jEi28rCBV3FLn4QCUozCfqqJ+ib0Xi/2AZnJ/fh
         5qrNyWN1ThumSFX3yRCwagZtHWoTYjh34XQIQcvgKlMzIxHSxrKl8F1kh1u9gvxDzYNb
         98QJIcUZWGMB2vrlLnjmV5VL22ufXTiIXK/voQeooKQXJyY0XP8FirTDC6tpbXXRUhWu
         guYvo6mqpWqUQNTLJKHjSC5eFqt9AYUPjcUpWQnzUpWXfIvudtkrDw/OgOKg5WIaXhyi
         VwgNpKRxlYvD4eQoKLC0ULxjRhwN9VXcZ8IGOahC6MikP4N0OCmmgotDj4CTjs9a537l
         rB6w==
X-Gm-Message-State: AOAM531PwvyCm0eCkqI52w6klv2XigSv7SwbhRoGjMtWviTa1PL5+kxc
        sDNYsdkBjPZJgnSB0ka09vPSGRSd63VDZmsAlSE0z+Ol17kkZqZVOGyPT6zQf5ymEJ8VrLwpabh
        N69uHIiFPtZBWTVTh1ahD8XUkRk2nQq+tuNiFhg==
X-Received: by 2002:adf:ab02:: with SMTP id q2mr15557752wrc.263.1634317405767;
        Fri, 15 Oct 2021 10:03:25 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxuITPOE/K90c/SbO06sQj8xZQDKAWVzRhH1M2nwElKhxcOuDwq0V7UNRKWNgSvAODtWO0Um5tIncG3lJ74Y3w=
X-Received: by 2002:adf:ab02:: with SMTP id q2mr15557737wrc.263.1634317405624;
 Fri, 15 Oct 2021 10:03:25 -0700 (PDT)
MIME-Version: 1.0
References: <20211015131115.12720-1-vegard.nossum@oracle.com>
 <20211015133635.GA26418@gondor.apana.org.au> <3bba3fed-b8f8-b7ce-f26f-8d1ed221144a@oracle.com>
In-Reply-To: <3bba3fed-b8f8-b7ce-f26f-8d1ed221144a@oracle.com>
From:   Chris Leech <cleech@redhat.com>
Date:   Fri, 15 Oct 2021 10:03:14 -0700
Message-ID: <CAPnfmXJPQTcZmPkYVDL4feDH7_P742N1H885suQzJc6u2A9QYQ@mail.gmail.com>
Subject: Re: [PATCH] scsi: libiscsi: select CRYPTO_HASH for ISCSI_TCP
To:     Vegard Nossum <vegard.nossum@oracle.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        Lee Duncan <lduncan@suse.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        open-iscsi@googlegroups.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Oct 15, 2021 at 6:54 AM Vegard Nossum <vegard.nossum@oracle.com> wrote:
>
>
> On 10/15/21 3:36 PM, Herbert Xu wrote:
> > On Fri, Oct 15, 2021 at 03:11:15PM +0200, Vegard Nossum wrote:
> >> Fix the following build/link error by adding a dependency on CRYPTO_HASH:
> >>
> >>   ld: drivers/scsi/libiscsi_tcp.o: in function `iscsi_tcp_dgst_header':
> >>   libiscsi_tcp.c:(.text+0x237): undefined reference to `crypto_ahash_digest'
> >>   ld: drivers/scsi/libiscsi_tcp.o: in function `iscsi_tcp_segment_done':
> >>   libiscsi_tcp.c:(.text+0x1325): undefined reference to `crypto_ahash_final'
> >>
> >> Fixes: 5d6ac29b9ebf2 ("iscsi_tcp: Use ahash")
> >> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> >> Signed-off-by: Vegard Nossum <vegard.nossum@oracle.com>
> >> ---
> >>  drivers/scsi/Kconfig | 1 +
> >>  1 file changed, 1 insertion(+)
> >>
> >> diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
> >> index 6e3a04107bb65..09764f3c42447 100644
> >> --- a/drivers/scsi/Kconfig
> >> +++ b/drivers/scsi/Kconfig
> >> @@ -290,6 +290,7 @@ config ISCSI_TCP
> >>      tristate "iSCSI Initiator over TCP/IP"
> >>      depends on SCSI && INET
> >>      select CRYPTO
> >> +    select CRYPTO_HASH
> >>      select CRYPTO_MD5
> >>      select CRYPTO_CRC32C
> >>      select SCSI_ISCSI_ATTRS
> >
> > CRYPTO_MD5 already selects CRYPTO_HASH so this shouldn't be needed.
>
> You're right, my apologies.
>
> libiscsi_tcp.o is built for CONFIG_ISCSI_TCP, but it's _also_ built for
> CONFIG_SCSI_CXGB3_ISCSI and CONFIG_SCSI_CXGB4_ISCSI. I missed that when
> I looked at the Makefile and wrongly assumed that CONFIG_ISCSI_TCP was
> missing the select.
>
> I'm not sure what the right fix here would be -- should
> CONFIG_SCSI_CXGB[34]_ISCSI depend on CONFIG_ISCSI_TCP..? Or should we
> add those CRYPTO* selects in there as well?

(apologies for the HTML reply that got rejected by the lists, and the
double reply to those directly addressed)

Are  Kconfig entries for libiscsi and libiscsi_tcp needed to handle
this properly?  Currently they're added to the object lists with each
configured driver that requires them.  I'm not even sure what happens
if you manage to configure them into both obj-y and obj-m.

- Chris Leech

