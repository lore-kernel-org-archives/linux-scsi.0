Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3378C7EE32
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Mar 2023 04:18:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229808AbjCBESa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 1 Mar 2023 23:18:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229893AbjCBESB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Mar 2023 23:18:01 -0500
Received: from mail-qt1-x82b.google.com (mail-qt1-x82b.google.com [IPv6:2607:f8b0:4864:20::82b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67A315679E
        for <linux-scsi@vger.kernel.org>; Wed,  1 Mar 2023 20:16:47 -0800 (PST)
Received: by mail-qt1-x82b.google.com with SMTP id c3so12561645qtc.8
        for <linux-scsi@vger.kernel.org>; Wed, 01 Mar 2023 20:16:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OiLX93qNxOIggMQE39gtCyYpTO910rpc2HqmiyP4Wqs=;
        b=A1EaYf8tKwM+OSZSx4sx0qUaPdLBesg9gHN2HlrQvObNa2lqTRK6IIiYpalGERQjcF
         pn+3xJBA/2791KiNqkOv//qXihovDpzswgjkqop1IXsV/L8NKh0Reo/ds5+FfnISkwnR
         I4WYiYH26wHIo2lOKIbarUgozHVzZhjq93i0zsrTBDllz8HnRhjt1fP7c+82n2uMukdc
         FrBA3ORoe7jdcFdPw9qrbyGt3C0CW2OrZV5E0sHojytvWDuV8PlYeOB/d3LJNDdjuJSG
         uvSrX/ZjBU8NVnQtHqnVeKjdMBgeElsggH2A6HgKfI3fDqki+55VcLxx2U4VMZJDfP6k
         wNBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OiLX93qNxOIggMQE39gtCyYpTO910rpc2HqmiyP4Wqs=;
        b=dbis8wJp2oq77FL+2p+Rk+EV//SryeQyZUvU+aDlADLgcGZ/JaynZizAk2XHkBHupl
         X6moeFEyX2YgyW9DwjnD0zHLTJsf2T+r5NI83mZA6G0U18SX7nmC4lo8Dn2elNns/+z2
         v/lWkmS5eFG093x4Q+YWlcN24qTp9LjIdqfuAM2FXDTXCWEzNElgEWZ9HKnU4xAxG/Yt
         3xyeRbKEi1VJBEpao5x+zWHX2XaKTDlHuGOrNgqejxMQ7y9O5eBPClCiVyvlgEPs6i56
         +EpVjQrHDVMWEI2HWiUENwv8CtqlOggRclENB83Y17r2zcYIGom0QPIPkgDgVrEefkcY
         ciBg==
X-Gm-Message-State: AO0yUKWWHsc8FRu5BTiMb6HTVCxFGhIqbd7yAUsxR5RnertsRhcXb1Mp
        V7iLcPY+b3wJdaoKm4mIms9AxPlOdEMQNViD7t0klg==
X-Google-Smtp-Source: AK7set/1Qo/2N3JCxnEKF/vVdWvMT8KXKuR0NcpsojQRCVOxjmuWm2l5Wboe2MANA6zXLOiyu1AmcY+R5Hl0TYWvINA=
X-Received: by 2002:ac8:444a:0:b0:3bf:b844:ffc7 with SMTP id
 m10-20020ac8444a000000b003bfb844ffc7mr2387535qtn.12.1677730602197; Wed, 01
 Mar 2023 20:16:42 -0800 (PST)
MIME-Version: 1.0
References: <Y9KtCc+4n5uANB2f@casper.infradead.org> <8448beac-a119-330d-a2af-fc3531bdb930@linux.alibaba.com>
 <Y/UiY/08MuA/tBku@casper.infradead.org> <CA+CK2bBYX-N8T_ZdzsHC7oJnHsmqHufdTUJj5OrdFk17uQ=fzw@mail.gmail.com>
 <ZAAgKTWpwCE1fruV@casper.infradead.org>
In-Reply-To: <ZAAgKTWpwCE1fruV@casper.infradead.org>
From:   Pasha Tatashin <pasha.tatashin@soleen.com>
Date:   Wed, 1 Mar 2023 23:16:06 -0500
Message-ID: <CA+CK2bCxBqjh4b_-ZU8czDR-naaHJVKWo38uhB2_a9x18NWYbQ@mail.gmail.com>
Subject: Re: [LSF/MM/BPF TOPIC] State Of The Page
To:     Matthew Wilcox <willy@infradead.org>
Cc:     Gao Xiang <hsiangkao@linux.alibaba.com>,
        lsf-pc@lists.linux-foundation.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, linux-block@vger.kernel.org,
        linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-nvme@lists.infradead.org, bpf@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Mar 1, 2023 at 11:03=E2=80=AFPM Matthew Wilcox <willy@infradead.org=
> wrote:
>
> On Wed, Mar 01, 2023 at 10:50:24PM -0500, Pasha Tatashin wrote:
> > On Tue, Feb 21, 2023 at 2:58=E2=80=AFPM Matthew Wilcox <willy@infradead=
.org> wrote:
> > > My goal for 2023 is to get to a point where we (a) have struct page
> > > reduced to:
> > >
> > > struct page {
> > >         unsigned long flags;
> > >         struct list_head lru;
> > >         struct address_space *mapping;
> > >         pgoff_t index;
> > >         unsigned long private;
> > >         atomic_t _mapcount;
> > >         atomic_t _refcount;
> > >         unsigned long memcg_data;
> > > #ifdef LAST_CPUPID_NOT_IN_PAGE_FLAGS
> > >         int _last_cpupid;
> > > #endif
> > > };
> >
> > This looks clean, but it is still 64-bytes. I wonder if we could
> > potentially reduce it down to 56 bytes by removing memcg_data.
>
> We need struct page to be 16-byte aligned to make slab work.  We also nee=
d
> it to divide PAGE_SIZE evenly to make CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMA=
P

Hm, can you please elaborate on both of these cases, how do both of
these cases work today with _last_cpuid configs or some other configs
that increase "struct page" above 64-bytes?

> work.  I don't think it's worth nibbling around the edges like this
> anyway; convert everything from page to folio and then we can do the
> big bang conversion where struct page shrinks from 64 bytes to 8.

I agree with general idea that converting to folio and shrinking
"struct page" to 8 bytes can be a big memory consumption win, but even
then we do not want to encourage the memdesc users to use larger than
needed types. If "flags" and "memcgs" are going to be part of almost
every single memdesc type it would be nice to reduce them from
16-bytes to 8-bytes.

Pasha
