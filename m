Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 639D2C433FE
	for <linux-scsi@archiver.kernel.org>; Sun,  6 Dec 2020 14:08:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2F3AF2312F
	for <linux-scsi@archiver.kernel.org>; Sun,  6 Dec 2020 14:08:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728039AbgLFOIi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 6 Dec 2020 09:08:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727989AbgLFOIh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 6 Dec 2020 09:08:37 -0500
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67831C0613D0;
        Sun,  6 Dec 2020 06:07:57 -0800 (PST)
Received: by mail-ed1-x543.google.com with SMTP id d18so10850654edt.7;
        Sun, 06 Dec 2020 06:07:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=aPZZJwlWG0at/TteZM/eCvvmq6bb2WZ0OxZRPSGS3iw=;
        b=KtFyW/cooS3YMe5bAdo6WcZUOOCmHZxsIS7Fh6G77AA7GPyHYnVpJiL0mEZtcDxpBR
         z6OjUX+nOBBhita63EKkfe+OzZOWKWbX+QRBv4oztbKRxxcMA4Q9uiir0qGcSA4ZBFha
         5inZDHxadoIg9HB/mKcdX/q6VLcRRl5tVeETs0mlts9oBxQFh0lCzIGLdRkwwTom9L6o
         cljSC6Jmo8yfgUJRwKuwNaJd60J8B24evKcEDoXLwyvXES6/tqTeFcOdclVUkNqP1713
         UueEoD4OrWRTVncFfw9hCB24K0OiCvuMfkawZAmFA4IXsbno2hgBYEM5HXf4vIH41z0L
         3/lQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=aPZZJwlWG0at/TteZM/eCvvmq6bb2WZ0OxZRPSGS3iw=;
        b=qo8r7/kGnw3plRGMCJNHzIJeDeGm85d3h0Kr9vXMC9hWPJO2yAPJxMleXD7pcexmON
         RMP2pQjdgVCje/ZcAyrW2JJ5AcL26uia8eQHTwRqzsaUh7sWVKDDpnUd6yubKwOszhFr
         8E1Si5aGd5QQwc8jC4uEAUTXuNRaJXGoQ7WjPb4Wm6n7WlbT/esJ5JdEldnZBzHyUq6q
         bFSiLV3AtVriBDfZ6cJbZxisM7Pj/izinfoJ2Ousi6WGnbEQn+mLRRJSYwgXvZVV8c5M
         McQEMAwELY3R/DPYyWbLh/XNgaQMdQEiGM4ux+mSfKjcVWCDsddaKqt73h7BKITDynYW
         6C/w==
X-Gm-Message-State: AOAM530EjKg/5+FghY/7kwv997b5xhfdlqi1wotiVgzZPulcvagdzFsp
        4pz0Rvj9ltK0cLADVFRhAxxeYiG9b+NVnrUdTVo=
X-Google-Smtp-Source: ABdhPJxlXVw4t3l+Mr6a3bmux/YN56LiLdE3Rr50zdAPF5glIWS5QBf/TWvHS84sHC0oNTu/8k1gp56WF/bpCAJ2isE=
X-Received: by 2002:aa7:d545:: with SMTP id u5mr15739906edr.113.1607263676017;
 Sun, 06 Dec 2020 06:07:56 -0800 (PST)
MIME-Version: 1.0
References: <20201206055332.3144-1-tom.ty89@gmail.com> <7987f7f1-d608-26d0-3f2f-86a7bd7cc03d@suse.de>
 <CAGnHSEmKsbgdprMebd-1gwpU52n4WkWb04cro1_z50g47-QjrQ@mail.gmail.com> <ba469342-b94b-4d2d-4af0-085711979a52@suse.de>
In-Reply-To: <ba469342-b94b-4d2d-4af0-085711979a52@suse.de>
From:   Tom Yan <tom.ty89@gmail.com>
Date:   Sun, 6 Dec 2020 22:07:44 +0800
Message-ID: <CAGnHSEkTZAvRZc3UyHAsOFdV8r=QpgV=KauqQqYwYHJUF+kAFg@mail.gmail.com>
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

Yes it does have "dependency" to the blk_next_bio() patch. I just
somehow missed that.

The problem is, I don't think I'm trying to change the logic of
bio_chain(), or even that of blk_next_bio(). It really just looks like
a careless mistake, that the arguments were typed in the wrong order.

Adding those who signed off the original commit (block: remove struct
bio_batch / 9082e87b) here too to the CC list.


On Sun, 6 Dec 2020 at 21:56, Hannes Reinecke <hare@suse.de> wrote:
>
> On 12/6/20 2:25 PM, Tom Yan wrote:
> > I think you misunderstood it. The goal of this patch is to split the
> > current situation into two chains (or one unchained bio + a series of
> > chained bio). The first one is an attempt/trial which makes sure that
> > the latter large bio chain can actually be handled (as per the
> > "command capability" of the device).
> >
> Oh, I think I do get what you're trying to do. And, in fact, I don't
> argue with what you're trying to achieve.
>
> What I would like to see, though, is keep the current bio_chain logic
> intact (irrespective of your previous patch, which should actually be
> part of this series), and just lift the first check out of the loop:
>
> @@ -262,9 +262,14 @@ static int __blkdev_issue_write_zeroes(struct
> block_device *bdev,
>
>          if (max_write_zeroes_sectors =3D=3D 0)
>                  return -EOPNOTSUPP;
> -
> +       new =3D bio_alloc(gfp_mask, 0);
> +       bio_chain(bio, new);
> +       if (submit_bio_wait(bio) =3D=3D BLK_STS_NOTSUPP) {
> +               bio_put(new);
> +               return -ENOPNOTSUPP;
> +       }
> +       bio =3D new;
>          while (nr_sects) {
> -               bio =3D blk_next_bio(bio, 0, gfp_mask);
>                  bio->bi_iter.bi_sector =3D sector;
>                  bio_set_dev(bio, bdev);
>                  bio->bi_opf =3D REQ_OP_WRITE_ZEROES;
> @@ -279,6 +284,7 @@ static int __blkdev_issue_write_zeroes(struct
> block_device *bdev,
>                          bio->bi_iter.bi_size =3D nr_sects << 9;
>                          nr_sects =3D 0;
>                  }
> +               bio =3D blk_next_bio(bio, 0, gfp_mask);
>                  cond_resched();
>          }
>
> (The error checking from submit_bio_wait() could be improved :-)
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
