Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E385C4361B
	for <linux-scsi@archiver.kernel.org>; Sun,  6 Dec 2020 13:26:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 256FF2312E
	for <linux-scsi@archiver.kernel.org>; Sun,  6 Dec 2020 13:26:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727918AbgLFN0j (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 6 Dec 2020 08:26:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727395AbgLFN0j (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 6 Dec 2020 08:26:39 -0500
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8033C0613D0;
        Sun,  6 Dec 2020 05:25:58 -0800 (PST)
Received: by mail-ed1-x544.google.com with SMTP id u19so10807864edx.2;
        Sun, 06 Dec 2020 05:25:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=GxWqQ/j2YOqu9/gTu+7og0AIItEtnmz0PFpLQW7gsWM=;
        b=t0E7tHp9cPkMHWkoIg/WVDA6ojGUNAdh4VParnlI/8jMhXdaayg0KFXmcqIPGVhfZ+
         YEaZeXvPXaeGxdCjyPRKSWJJ/wCLKrvjclEjCtlntg3JN/vyo/7UioKK4sKhVQ52z/7v
         fMZcA3s7O3YqHu3hH7glDRtIbkFDlwTDpnop75qUMargdkz/AiiOylvqvYTp+UJA8Xsd
         RnzaP0RrffKmMYQv7RF0UJ+V9cxduPsKLokHKRiW8a/GaIBJU2g7+wv0ZjqOkcMkj/bA
         henOMPY1NDfL0ItHhP89ABIctY3k3iLbMLP62hILqbnbUa0zUVf7K3Bh/7aItYYHWBU/
         WvNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=GxWqQ/j2YOqu9/gTu+7og0AIItEtnmz0PFpLQW7gsWM=;
        b=CskmQUFkjNpnLI9giVy30KhAUVknmZOT75sYNuvo1xhQ4xxJ0aN4LrlCeyLt3xXV1I
         Lk2qY6wOFRJI99eN63w3Rsbru8OkaeFPxUrUwxSpFyCU308HkD+jnAwBQ0pbAFWPPKEi
         /jNjRe3W9Fa/XucsUgcoVmMU6rUkhz7G3d1wJ3eJ1NByW8/nNKgJFhSEYKJTjJm6Emi7
         DHPozMZwK7RdUhCV2a8qPNvpmMOpFDmA2oi5Y7riI7SHovMi3zobxGtDDBkoyHmNjzu0
         uH82GNZLIR9DVV/WY82rE3k7pG4Avp3dU5fsy2hNS0KA9kmqHszBmz6rX7VNsAT2jQJN
         IKBQ==
X-Gm-Message-State: AOAM530T6Wmsy0oXfh3cs3rsPFFs80ERuWTALJM/Lb8nZ2fP6PMDLnYg
        45XnD6/EyTOu7+8le+2a5fqiMbk3MNWQYwrIw+0=
X-Google-Smtp-Source: ABdhPJwrLSE6JAxYKN1jYRQZVwp8iM7Hso0Egy9auneet4BNbk+/w/2cBrEWzmzyeFNF2ldy+eW8CRUyMELDwzHyAp8=
X-Received: by 2002:a50:bc06:: with SMTP id j6mr16526659edh.150.1607261157441;
 Sun, 06 Dec 2020 05:25:57 -0800 (PST)
MIME-Version: 1.0
References: <20201206055332.3144-1-tom.ty89@gmail.com> <7987f7f1-d608-26d0-3f2f-86a7bd7cc03d@suse.de>
In-Reply-To: <7987f7f1-d608-26d0-3f2f-86a7bd7cc03d@suse.de>
From:   Tom Yan <tom.ty89@gmail.com>
Date:   Sun, 6 Dec 2020 21:25:46 +0800
Message-ID: <CAGnHSEmKsbgdprMebd-1gwpU52n4WkWb04cro1_z50g47-QjrQ@mail.gmail.com>
Subject: Re: [PATCH 1/3] block: try one write zeroes request before going further
To:     Hannes Reinecke <hare@suse.de>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

I think you misunderstood it. The goal of this patch is to split the
current situation into two chains (or one unchained bio + a series of
chained bio). The first one is an attempt/trial which makes sure that
the latter large bio chain can actually be handled (as per the
"command capability" of the device).

P.S. I think I missed the fact that it requires my blk_next_bio()
patch to work properly. (It still seems like a typo bug to me.)

On Sun, 6 Dec 2020 at 19:25, Hannes Reinecke <hare@suse.de> wrote:
>
> On 12/6/20 6:53 AM, Tom Yan wrote:
> > At least the SCSI disk driver is "benevolent" when it try to decide
> > whether the device actually supports write zeroes, i.e. unless the
> > device explicity report otherwise, it assumes it does at first.
> >
> > Therefore before we pile up bios that would fail at the end, we try
> > the command/request once, as not doing so could trigger quite a
> > disaster in at least certain case. For example, the host controller
> > can be messed up entirely when one does `blkdiscard -z` a UAS drive.
> >
> > Signed-off-by: Tom Yan <tom.ty89@gmail.com>
> > ---
> >   block/blk-lib.c | 14 +++++++++++++-
> >   1 file changed, 13 insertions(+), 1 deletion(-)
> >
> > diff --git a/block/blk-lib.c b/block/blk-lib.c
> > index e90614fd8d6a..c1e9388a8fb8 100644
> > --- a/block/blk-lib.c
> > +++ b/block/blk-lib.c
> > @@ -250,6 +250,7 @@ static int __blkdev_issue_write_zeroes(struct block=
_device *bdev,
> >       struct bio *bio =3D *biop;
> >       unsigned int max_write_zeroes_sectors;
> >       struct request_queue *q =3D bdev_get_queue(bdev);
> > +     int i =3D 0;
> >
> >       if (!q)
> >               return -ENXIO;
> > @@ -264,7 +265,17 @@ static int __blkdev_issue_write_zeroes(struct bloc=
k_device *bdev,
> >               return -EOPNOTSUPP;
> >
> >       while (nr_sects) {
> > -             bio =3D blk_next_bio(bio, 0, gfp_mask);
> > +             if (i !=3D 1) {
> > +                     bio =3D blk_next_bio(bio, 0, gfp_mask);
> > +             } else {
> > +                     submit_bio_wait(bio);
> > +                     bio_put(bio);
> > +
> > +                     if (bdev_write_zeroes_sectors(bdev) =3D=3D 0)
> > +                             return -EOPNOTSUPP;
> > +                     else
> > +                             bio =3D bio_alloc(gfp_mask, 0);
> > +             }
> >               bio->bi_iter.bi_sector =3D sector;
> >               bio_set_dev(bio, bdev);
> >               bio->bi_opf =3D REQ_OP_WRITE_ZEROES;
> > @@ -280,6 +291,7 @@ static int __blkdev_issue_write_zeroes(struct block=
_device *bdev,
> >                       nr_sects =3D 0;
> >               }
> >               cond_resched();
> > +             i++;
> >       }
> >
> >       *biop =3D bio;
> >
> We do want to keep the chain of bios intact such that end_io processing
> will recurse back to the original end_io callback.
> As such we need to call bio_chain on the first bio, submit that
> (possibly with submit_bio_wait()), and then decide whether we can /
> should continue.
> With your patch we'll lose the information that indeed other bios might
> be linked to the original one.
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
