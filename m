Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1FD6C433FE
	for <linux-scsi@archiver.kernel.org>; Sun,  6 Dec 2020 14:29:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 99ED723159
	for <linux-scsi@archiver.kernel.org>; Sun,  6 Dec 2020 14:29:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726202AbgLFO3J (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 6 Dec 2020 09:29:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726147AbgLFO3I (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 6 Dec 2020 09:29:08 -0500
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F3C0C0613D0;
        Sun,  6 Dec 2020 06:28:28 -0800 (PST)
Received: by mail-ed1-x543.google.com with SMTP id l5so10862189edq.11;
        Sun, 06 Dec 2020 06:28:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=3bO7I64pflvkvZ5aJNYIhQqVbxU4bvom16k6Uh1HhZU=;
        b=E2bdWOoC+fgHQ5fPmvzTG8XWK/R52fFspGzjcZL9qz8iBZ3Pw2d6Yt7cAQceuZVef7
         5cMfwlStegQT8kSLmhC4E+LG5ELMsxnwuZTErzHBzeOs+vNnWx45rY8FqMi+OqTT+/Pw
         vp7CmMQOCwcNvbFRKNYFX7g32blyeL/YmQTGKJeU2bx6P1Ys9Mm86Bfy2TlltfDS48Mp
         Xe9wlh1X/4YuciqwnGjuW5JBHq00lUbP1DuMiCMYqUXNB6gBgMxN2JkpApnUKSKfGODq
         dyTfs7EF5FXHi6G95LUygUVStwnis59E2KubV6tZR0gLDMIAOjyJFVs4Nj2Til2i2DCU
         +CZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=3bO7I64pflvkvZ5aJNYIhQqVbxU4bvom16k6Uh1HhZU=;
        b=L+JwRdAr0inSUahLJMXzslrK0o0fyszZ+rUqZ8R99Uj/ZEM/MkmP0beZBXTG3DAFo9
         AUT3UXKjE+jMu0agjtWnp23qusgwkZmZteQzjpkztkeEbljCRr/QjdK6KnnQ8rf3L8Qn
         Ol03wDobxzyVb7CTL6ukRCtN6CyJPrvU/1pbjTxrMwZmSYjuKkuyvYP5vN95PCWd/OWn
         5AheKjOBzEQYzPSeHZ4gaNp3Pl2c7ebony9Y/nsTdTwK2ulQPDwLy2JsKGn+5kDuTNKm
         Yb/ALSgAWDSmXL3dONOHRnVTEvogpfLZiN6VvqnWcfmPBy57YTicNi8FIdYh1bM98Liu
         PbTA==
X-Gm-Message-State: AOAM532n5sCIlleeO6fdIKeqaNynD9DzY3x7JPzYSLsLV/C/no7+1sjX
        PaifXq4rTB/MBW77/+hCwOE7Gdmke1288LYgAKY=
X-Google-Smtp-Source: ABdhPJxtzE+HXfcDBrDatvLGdSI/VrMBGoaEbdaQkgitSqka8Dut8nGdNHltDA5w62/5qPKcZnZ/XXGrS4HYK6JqIWE=
X-Received: by 2002:aa7:c749:: with SMTP id c9mr12123168eds.3.1607264906901;
 Sun, 06 Dec 2020 06:28:26 -0800 (PST)
MIME-Version: 1.0
References: <20201206055332.3144-1-tom.ty89@gmail.com> <7987f7f1-d608-26d0-3f2f-86a7bd7cc03d@suse.de>
 <CAGnHSEmKsbgdprMebd-1gwpU52n4WkWb04cro1_z50g47-QjrQ@mail.gmail.com>
 <ba469342-b94b-4d2d-4af0-085711979a52@suse.de> <CAGnHSEkTZAvRZc3UyHAsOFdV8r=QpgV=KauqQqYwYHJUF+kAFg@mail.gmail.com>
In-Reply-To: <CAGnHSEkTZAvRZc3UyHAsOFdV8r=QpgV=KauqQqYwYHJUF+kAFg@mail.gmail.com>
From:   Tom Yan <tom.ty89@gmail.com>
Date:   Sun, 6 Dec 2020 22:28:15 +0800
Message-ID: <CAGnHSEmGktrM23UWTLf31DzXM07_RSLmwuTuL1uymYXtixePpg@mail.gmail.com>
Subject: Re: [PATCH 1/3] block: try one write zeroes request before going further
To:     Hannes Reinecke <hare@suse.de>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>, tom.leiming@gmail.com,
        axboe@fb.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Btw, while this series relies on the blk_next_bio() patch to work, it
was not the reason that I sent the latter. It was just because the way
it calls bio_chain() doesn't look right to any of the functions that
make use of it (or in other words, the apparent logic of itself).
That's actually why I didn't have it in the same series.

On Sun, 6 Dec 2020 at 22:07, Tom Yan <tom.ty89@gmail.com> wrote:
>
> Yes it does have "dependency" to the blk_next_bio() patch. I just
> somehow missed that.
>
> The problem is, I don't think I'm trying to change the logic of
> bio_chain(), or even that of blk_next_bio(). It really just looks like
> a careless mistake, that the arguments were typed in the wrong order.
>
> Adding those who signed off the original commit (block: remove struct
> bio_batch / 9082e87b) here too to the CC list.
>
>
> On Sun, 6 Dec 2020 at 21:56, Hannes Reinecke <hare@suse.de> wrote:
> >
> > On 12/6/20 2:25 PM, Tom Yan wrote:
> > > I think you misunderstood it. The goal of this patch is to split the
> > > current situation into two chains (or one unchained bio + a series of
> > > chained bio). The first one is an attempt/trial which makes sure that
> > > the latter large bio chain can actually be handled (as per the
> > > "command capability" of the device).
> > >
> > Oh, I think I do get what you're trying to do. And, in fact, I don't
> > argue with what you're trying to achieve.
> >
> > What I would like to see, though, is keep the current bio_chain logic
> > intact (irrespective of your previous patch, which should actually be
> > part of this series), and just lift the first check out of the loop:
> >
> > @@ -262,9 +262,14 @@ static int __blkdev_issue_write_zeroes(struct
> > block_device *bdev,
> >
> >          if (max_write_zeroes_sectors =3D=3D 0)
> >                  return -EOPNOTSUPP;
> > -
> > +       new =3D bio_alloc(gfp_mask, 0);
> > +       bio_chain(bio, new);
> > +       if (submit_bio_wait(bio) =3D=3D BLK_STS_NOTSUPP) {
> > +               bio_put(new);
> > +               return -ENOPNOTSUPP;
> > +       }
> > +       bio =3D new;
> >          while (nr_sects) {
> > -               bio =3D blk_next_bio(bio, 0, gfp_mask);
> >                  bio->bi_iter.bi_sector =3D sector;
> >                  bio_set_dev(bio, bdev);
> >                  bio->bi_opf =3D REQ_OP_WRITE_ZEROES;
> > @@ -279,6 +284,7 @@ static int __blkdev_issue_write_zeroes(struct
> > block_device *bdev,
> >                          bio->bi_iter.bi_size =3D nr_sects << 9;
> >                          nr_sects =3D 0;
> >                  }
> > +               bio =3D blk_next_bio(bio, 0, gfp_mask);
> >                  cond_resched();
> >          }
> >
> > (The error checking from submit_bio_wait() could be improved :-)
> >
> > Cheers,
> >
> > Hannes
> > --
> > Dr. Hannes Reinecke                Kernel Storage Architect
> > hare@suse.de                              +49 911 74053 688
> > SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
> > HRB 36809 (AG N=C3=BCrnberg), Gesch=C3=A4ftsf=C3=BChrer: Felix Imend=C3=
=B6rffer
