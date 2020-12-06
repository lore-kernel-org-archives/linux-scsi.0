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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0794FC4361B
	for <linux-scsi@archiver.kernel.org>; Sun,  6 Dec 2020 13:33:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B7B452310E
	for <linux-scsi@archiver.kernel.org>; Sun,  6 Dec 2020 13:33:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727943AbgLFNdi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 6 Dec 2020 08:33:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727918AbgLFNdi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 6 Dec 2020 08:33:38 -0500
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11F64C0613D0;
        Sun,  6 Dec 2020 05:32:52 -0800 (PST)
Received: by mail-ej1-x643.google.com with SMTP id bo9so15506492ejb.13;
        Sun, 06 Dec 2020 05:32:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=/fbtb/FK/uvVc8I0R2qhwb7a3GTA04O6LfcIRT+PW18=;
        b=qhpTZNAWKiXcJ8rxCUMWodpT/oVHjYdwe7k4QMS+JmoObZnStfihW7xOOz0jZ+pK6u
         kdzxTtDy43SbJjGdfkx6sb1W7DasE3RjEjkAbE8Chgz+Oa8LnQ06X7+2LorxMySeJ9mt
         L3cWYtfkJYOs4kgQmbU3uS67HAX2/h4wEsqzICygDErDRyngMJVf/AystR2YO/C8qpGc
         X830tYOUBg9BqYzQolq27VOPlg4NEaVkH4MZRqQl/J9Bg9tfe2H1jH/D/dNiJ/D6WRbm
         pxp5hZmh3dt5Mu4NePXsdIB2ipijDzYASZGqopDyG2MfS1uFCU7XjnGFq/5VgLukLXIa
         i8KA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=/fbtb/FK/uvVc8I0R2qhwb7a3GTA04O6LfcIRT+PW18=;
        b=RXPgp5h8RFANgxOknBFQJfMPgpqL/sQNmA/DuEAU13oIGe1ta5DXwX7gMiQdEYjgRg
         0X3HE9oMotzUJDXwggKKTyeka0Le9Cm3ZRDSjHqtaDbRUuktis8K14C9p2xqhaWNn1zC
         ciRlWqyWUoBFXeR/10taxhYR6Fx8Yw48LMsd5vbJaIY+42R303ehq3cZ0GHfjDN1fIak
         gB+6nZB1NFYA6AEO1NijKyIuhh9KL/HiWvMaL1TxSQCDcgpPnKkQvn/2uLJF9fwj7azN
         itV5F7UG5fzXhR2OaCimh6ZOUmQcNFcHquSq2G6yN9FOxvQPHTMOgzNST+Xa55RxHSbz
         CBgA==
X-Gm-Message-State: AOAM5325bW4HxuC4QuRZqDB/9prDs7/SZONZQCjVfDoefqVptjBcDIoT
        Ke10EuPqGkmu5AzOXc/qNWwDWRDP4Gae3fV3bJpTxbKH37Y=
X-Google-Smtp-Source: ABdhPJyBfOQ6gkaqq8l/P3et/7uwOSDC6jxcJdDkN45yJwWY7UEtp2N/3qPqcAXbf3oomECalZ7gbZ4iCXAREjEAlLI=
X-Received: by 2002:a17:907:2116:: with SMTP id qn22mr15167432ejb.483.1607261570811;
 Sun, 06 Dec 2020 05:32:50 -0800 (PST)
MIME-Version: 1.0
References: <20201206055332.3144-1-tom.ty89@gmail.com> <20201206055332.3144-3-tom.ty89@gmail.com>
 <2eb8f838-0ec6-3e70-356b-8c04baba2fc4@suse.de>
In-Reply-To: <2eb8f838-0ec6-3e70-356b-8c04baba2fc4@suse.de>
From:   Tom Yan <tom.ty89@gmail.com>
Date:   Sun, 6 Dec 2020 21:32:39 +0800
Message-ID: <CAGnHSEk0C6VNQysGiysPS1yEXwu4U8PVCaVB2RR7oEgnr4Xz=w@mail.gmail.com>
Subject: Re: [PATCH 3/3] block: set REQ_PREFLUSH to the final bio from __blkdev_issue_zero_pages()
To:     Hannes Reinecke <hare@suse.de>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Why? Did you miss that it is in the condition where
__blkdev_issue_zero_pages() is called (i.e. it's not WRITE SAME but
WRITE). From what I gathered REQ_PREFLUSH triggers a write back cache
(that is on the device; not sure about dirty pages) flush, wouldn't it
be a right thing to do after we performed a series of WRITE (which is
more or less purposed to get a drive wiped clean).

On Sun, 6 Dec 2020 at 19:31, Hannes Reinecke <hare@suse.de> wrote:
>
> On 12/6/20 6:53 AM, Tom Yan wrote:
> > Mimicking blkdev_issue_flush(). Seems like a right thing to do, as
> > they are a bunch of REQ_OP_WRITE.
> >
> > Signed-off-by: Tom Yan <tom.ty89@gmail.com>
> > ---
> >   block/blk-lib.c | 2 ++
> >   1 file changed, 2 insertions(+)
> >
> > diff --git a/block/blk-lib.c b/block/blk-lib.c
> > index 354dcab760c7..5579fdea893d 100644
> > --- a/block/blk-lib.c
> > +++ b/block/blk-lib.c
> > @@ -422,6 +422,8 @@ int blkdev_issue_zeroout(struct block_device *bdev,=
 sector_t sector,
> >       } else if (!(flags & BLKDEV_ZERO_NOFALLBACK)) {
> >               ret =3D __blkdev_issue_zero_pages(bdev, sector, nr_sects,
> >                                               gfp_mask, &bio);
> > +             if (bio)
> > +                     bio->bi_opf |=3D REQ_PREFLUSH;
> >       } else {
> >               /* No zeroing offload support */
> >               ret =3D -EOPNOTSUPP;
> >
> PREFLUSH is for the 'flush' machinery (cf blk-flush.c). Which is okay
> for blkdev_issue_flush(), but certainly not for zeroout.
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
