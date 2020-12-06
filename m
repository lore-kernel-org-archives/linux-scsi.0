Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1DBEAC433FE
	for <linux-scsi@archiver.kernel.org>; Sun,  6 Dec 2020 13:29:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D6BF32312E
	for <linux-scsi@archiver.kernel.org>; Sun,  6 Dec 2020 13:29:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728039AbgLFN27 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 6 Dec 2020 08:28:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725767AbgLFN27 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 6 Dec 2020 08:28:59 -0500
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02EB8C0613D1;
        Sun,  6 Dec 2020 05:28:19 -0800 (PST)
Received: by mail-ej1-x644.google.com with SMTP id ga15so15583570ejb.4;
        Sun, 06 Dec 2020 05:28:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=s4XDcow++mfXVNWnA/7Jt6BRfIkAMYlS0ednZ2lpyxU=;
        b=hmkf7S8KB5FFVddRjWIJiZuksqVTnznQFrqzSwjNBCV1HFKcsG59fa8CxuLZZh3lcr
         rEqtDjhdXyahQ/IUVV9wF0HL3lu0/1hSHsDiYSMa8ljZsPur6cOX4ZRQd8XuGUjXZz+B
         obbkR5Fd5t8qdA+LP3tz613BFYoFiGOB81taAQCYGsqqJv+3I/Z7MczfrlXHJvQbDbk+
         461XcDnUuLtbUfNgz6wQAQtAVWqSp2pnLGI5gGClyXSEyo6sH5a+C27q1/6IOsLuIoGu
         7bLaseynclBOzPlwZuYc1PFmZ6ESMxhP0IWHjRBS0oH9EzltnlntGlHI/odP0mjzkJgs
         9+Qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=s4XDcow++mfXVNWnA/7Jt6BRfIkAMYlS0ednZ2lpyxU=;
        b=FymSHZs+S6IfmjA9nEXGsB9u8Uu975RcIsnx53JOyMzqrcyU5p33f/9EnpGpkWf6bv
         kBxIMX4pVoXX4G/C3cVq+6DaFG9u9i3EmvSqrkg7sAX34iaT5x4VRsoIF56ZVJh36i5n
         jSWiIP4sYx8JqbtFE9tIG3WYBIFasKdxvbhTC27ZU8jrq1SI5ugIW56BC+24CLX3Lj6d
         x6Q9DNARTXugv8Kj3AHF6F1dKtNDJA8LCYefVcG4xzjCIEw8PWLwWH4wHQYyftGQwLK5
         o1ukPnBFvBUG09k01Aa0kynfIJhtgtYb76/OfnB4AVaP+0DAklLzE15gQfbI+MI2Ad63
         eD3A==
X-Gm-Message-State: AOAM530o7muh3KfJlhwobjS7cc+t/4dGHgrZZNZgocEoMCw+h9XGpFng
        Vtd3YOfpBtunhZGrnVVkEcWFA9flywwTclKDzGs=
X-Google-Smtp-Source: ABdhPJxr5fECVZjpJR7RUt+pU9m12AImE8oyA8ysW6cSkg16x8sITfihINnqMd0vtiqBP6Mrnd4L3Aw9mE3WCVOkSbQ=
X-Received: by 2002:a17:906:c046:: with SMTP id bm6mr14492306ejb.436.1607261297756;
 Sun, 06 Dec 2020 05:28:17 -0800 (PST)
MIME-Version: 1.0
References: <20201206055332.3144-1-tom.ty89@gmail.com> <20201206055332.3144-2-tom.ty89@gmail.com>
 <ed132ef1-b4d0-6e3f-2c7c-a9292bccbfe2@suse.de>
In-Reply-To: <ed132ef1-b4d0-6e3f-2c7c-a9292bccbfe2@suse.de>
From:   Tom Yan <tom.ty89@gmail.com>
Date:   Sun, 6 Dec 2020 21:28:06 +0800
Message-ID: <CAGnHSE=90XL2ck4U8BgYqL6gKrjnTPObGXJ3ETw_LBx75z+0hQ@mail.gmail.com>
Subject: Re: [PATCH 2/3] block: make __blkdev_issue_zero_pages() less confusing
To:     Hannes Reinecke <hare@suse.de>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sun, 6 Dec 2020 at 19:29, Hannes Reinecke <hare@suse.de> wrote:
>
> On 12/6/20 6:53 AM, Tom Yan wrote:
> > Instead of using the same check for the two layers of loops, count
> > bio pages in the inner loop instead.
> >
> > Signed-off-by: Tom Yan <tom.ty89@gmail.com>
> > ---
> >   block/blk-lib.c | 11 +++++------
> >   1 file changed, 5 insertions(+), 6 deletions(-)
> >
> > diff --git a/block/blk-lib.c b/block/blk-lib.c
> > index c1e9388a8fb8..354dcab760c7 100644
> > --- a/block/blk-lib.c
> > +++ b/block/blk-lib.c
> > @@ -318,7 +318,7 @@ static int __blkdev_issue_zero_pages(struct block_d=
evice *bdev,
> >       struct request_queue *q =3D bdev_get_queue(bdev);
> >       struct bio *bio =3D *biop;
> >       int bi_size =3D 0;
> > -     unsigned int sz;
> > +     unsigned int sz, bio_nr_pages;
> >
> >       if (!q)
> >               return -ENXIO;
> > @@ -327,19 +327,18 @@ static int __blkdev_issue_zero_pages(struct block=
_device *bdev,
> >               return -EPERM;
> >
> >       while (nr_sects !=3D 0) {
> > -             bio =3D blk_next_bio(bio, __blkdev_sectors_to_bio_pages(n=
r_sects),
> > -                                gfp_mask);
> > +             bio_nr_pages =3D __blkdev_sectors_to_bio_pages(nr_sects);
> > +             bio =3D blk_next_bio(bio, bio_nr_pages, gfp_mask);
> >               bio->bi_iter.bi_sector =3D sector;
> >               bio_set_dev(bio, bdev);
> >               bio_set_op_attrs(bio, REQ_OP_WRITE, 0);
> >
> > -             while (nr_sects !=3D 0) {
> > +             while (bio_nr_pages !=3D 0) {
> >                       sz =3D min((sector_t) PAGE_SIZE, nr_sects << 9);
>
> nr_sects will need to be modified, too, if we iterate over bio_nr_pages
> instead of nr_sects.
>
> >                       bi_size =3D bio_add_page(bio, ZERO_PAGE(0), sz, 0=
);
> >                       nr_sects -=3D bi_size >> 9;
Not sure what modification you are suggesting. We are still deducting
from it the "added" sectors.
> >                       sector +=3D bi_size >> 9;
> > -                     if (bi_size < sz)
> > -                             break;
> > +                     bio_nr_pages--;
> >               }
> >               cond_resched();
> >       }
> >
>
> Cheers,
>
> Hannes
> --
> Dr. Hannes Reinecke                Kernel Storage Architect
> hare@suse.de                              +49 911 74053 688
> SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
> HRB 36809 (AG N=C3=BCrnberg), Gesch=C3=A4ftsf=C3=BChrer: Felix Imend=C3=
=B6rffer
