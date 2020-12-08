Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4D8EC433FE
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Dec 2020 12:49:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BB2C523101
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Dec 2020 12:49:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729536AbgLHMtH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Dec 2020 07:49:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729339AbgLHMtH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Dec 2020 07:49:07 -0500
Received: from mail-oi1-x242.google.com (mail-oi1-x242.google.com [IPv6:2607:f8b0:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1F5AC061793;
        Tue,  8 Dec 2020 04:48:26 -0800 (PST)
Received: by mail-oi1-x242.google.com with SMTP id s75so16178870oih.1;
        Tue, 08 Dec 2020 04:48:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vpsjhg6fcKq43vw7SE6Efk7QFeYsFhp+jZPz1TLNgSk=;
        b=XAnPq6GRjSpdDDdGmbX+AE7gqAxX6iZUxJkygbZm+LnDh8nuKYOeXfv7HpwPvw5OYn
         oAkdN100VL04WnKzUL9DxFuUBzUjX8ydl7v8khTnSpCCNr1eQlHY8gPOB7kzAgS9qSUy
         /jUdpDn7xLmSSBmn8OD2waiuE+gSSTW/w0onQsukboCxHoLbGBxwSSaANwtFK3nl3WX3
         dS/LDfvGFcCWBx3gke2eE0qJAex0o+cdHJimwjGK92/Z5g/msYQ8p3vTpJEznSmAvWY2
         Sm+Khcos39U3QyEmKbxqNLRVYOfyEqQCTAY7D5H45jX58dYa0nDmeV9tKBTmoO+Zkzwg
         7r0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vpsjhg6fcKq43vw7SE6Efk7QFeYsFhp+jZPz1TLNgSk=;
        b=fSsBfYgsADJ0cknrVcks/zFK6Uv2h4BIC059aL5YPjGupGGEMGWJxUzpVa3IH/ENva
         e4Fk8i5xbkHaKEHqW+8otjfouTiCtK1Q99j1hZNcckXXjcz4XdC7x9qefzjecXDNlpTN
         AS1B6e5AindWK4d9NUNJAwJ/y60w1hadZdf2WBZ7vGFr/FfwIeyVD3hHuyqZyjydiKo8
         cgwHnGwUM04lstxay2bZEv4Zx5RQMXE/69huF7TVXFdgGN+uDtcl+nZzUBi9AWEx4mSL
         imPPYoP0bAHTgLcPGVAFU+AzaHrTI7GAe94T9vFcSr99cAgSF7H9izLFc/DOAKaoLs+E
         5btA==
X-Gm-Message-State: AOAM532TOkAesPR3TKhNhll260mkz9a4R0m8+8mY7emMRZR9k+sIxISB
        RKIJwr4c1hANHVYgVl5dRRSctcMMrFip98+Nr8l1Dgqv
X-Google-Smtp-Source: ABdhPJxQgTXA+DQabjC3qifqGRbh6mZQU31VZLxWNtUzQUpF97IYhBqfu8ZAphM2PkC0VPHl61EbAMqGKVWexjumAXI=
X-Received: by 2002:a05:6808:a1a:: with SMTP id n26mr2483412oij.94.1607431706183;
 Tue, 08 Dec 2020 04:48:26 -0800 (PST)
MIME-Version: 1.0
References: <20201206055332.3144-1-tom.ty89@gmail.com> <20201207133658.GC28592@infradead.org>
In-Reply-To: <20201207133658.GC28592@infradead.org>
From:   Tom Yan <tom.ty89@gmail.com>
Date:   Tue, 8 Dec 2020 20:48:15 +0800
Message-ID: <CAGnHSEmzrJxm2RVHqP9qGfT0-5N2Zi8wdhvDz_zy-d7W0g7caQ@mail.gmail.com>
Subject: Re: [PATCH 1/3] block: try one write zeroes request before going further
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

You mean like submit_bio_wait() is a blocking operation?

On Mon, 7 Dec 2020 at 21:36, Christoph Hellwig <hch@infradead.org> wrote:
>
> On Sun, Dec 06, 2020 at 01:53:30PM +0800, Tom Yan wrote:
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
> >  block/blk-lib.c | 14 +++++++++++++-
> >  1 file changed, 13 insertions(+), 1 deletion(-)
> >
> > diff --git a/block/blk-lib.c b/block/blk-lib.c
> > index e90614fd8d6a..c1e9388a8fb8 100644
> > --- a/block/blk-lib.c
> > +++ b/block/blk-lib.c
> > @@ -250,6 +250,7 @@ static int __blkdev_issue_write_zeroes(struct block_device *bdev,
> >       struct bio *bio = *biop;
> >       unsigned int max_write_zeroes_sectors;
> >       struct request_queue *q = bdev_get_queue(bdev);
> > +     int i = 0;
> >
> >       if (!q)
> >               return -ENXIO;
> > @@ -264,7 +265,17 @@ static int __blkdev_issue_write_zeroes(struct block_device *bdev,
> >               return -EOPNOTSUPP;
> >
> >       while (nr_sects) {
> > -             bio = blk_next_bio(bio, 0, gfp_mask);
> > +             if (i != 1) {
> > +                     bio = blk_next_bio(bio, 0, gfp_mask);
> > +             } else {
> > +                     submit_bio_wait(bio);
> > +                     bio_put(bio);
> > +
> > +                     if (bdev_write_zeroes_sectors(bdev) == 0)
> > +                             return -EOPNOTSUPP;
> > +                     else
>
> This means you now massively slow down say nvme operations by adding
> a wait.  If at all we need a maybe supports write zeroes flag and
> only do that if the driver hasn't decided yet if write zeroes is
> actually supported.
