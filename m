Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F90CC56202
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Nov 2020 10:06:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 18A8C2075A
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Nov 2020 10:06:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=cloud.ionos.com header.i=@cloud.ionos.com header.b="EWvaurrQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727398AbgKKKG4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 11 Nov 2020 05:06:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727357AbgKKKGz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Nov 2020 05:06:55 -0500
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39E8DC0613D4
        for <linux-scsi@vger.kernel.org>; Wed, 11 Nov 2020 02:06:55 -0800 (PST)
Received: by mail-ej1-x641.google.com with SMTP id i19so1947748ejx.9
        for <linux-scsi@vger.kernel.org>; Wed, 11 Nov 2020 02:06:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8BVYeCUTuKi3mlr+D1JejV3WQ4DReZqKao2un+osJdI=;
        b=EWvaurrQLE5Q4yXlmvtPWeVGE0dkpLilBhFACYcpJh5SLgD4k2LHFrfA3fg/phe+gw
         pOXsWhTko+6vmsPMUys1ydyafND8sfafc/BhJ0cLDqzJH5wv7CFdS4PBi4SJJirndEDo
         I3sopJwAoMSpcvKBGOBbJDfAHPo19nxrr5mYxmaUjZAtoeSEinoAPgcqf0tp4SGruWUm
         s+puyVNd/9QM59nJCHGxgwiF4Uhv/qkw3Bh4E6NoIJN/jPJN6bl5siKGHhBBHVdEhBTl
         i9cN1zoK+m/ZDFXKRJbDKDgS4Hb/xEaLU1cJNAhSo0nBcfuCpt/4xbdL/4qVB2KjPelC
         haxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8BVYeCUTuKi3mlr+D1JejV3WQ4DReZqKao2un+osJdI=;
        b=Iud6Hli/EjwFiqfqeLNZ4hg9Ev9VaOqDlIJhhtNdMlbD+057m96FCjCxCV6n+ABdjT
         eg2LNgCbqrYVGot298FQADQdj33+s81BHySm1VRQXHnMa5swarOc63OeDx+kpGTvkF1z
         H/+FMRYf3ghcnFHCPaIWI4lZOJI0gx/rzJNcIAxkS/ajhOBqAeESInj9i7O7rIpG/QOL
         XPzb2nTZilcOjyvPk0kmb8k9PQn4E7eRYkTFjUEUlsPn2Fhj7E6qIIfXusamioj6+B+A
         +w4K5NgJLiabSGH+8AIV8+FSimluChuLztFwfi0a1EEtabf1dmM53WcAt7MR9Zb92gG7
         3iAQ==
X-Gm-Message-State: AOAM530YPs+jSXMpQPmaFa4aGR7Ko0Urf1iLiiXJHGAcEpE9326TM/7y
        d/tcE4OISZp3tq5+PVcsn/IqzdIR0AagnDx30D3YqQ==
X-Google-Smtp-Source: ABdhPJzsSG4n+ejxAi7LIm+JtRF2XZ0Zmfdo/Dim1Bn2zjoT1vntwc6k1ciTHUd7GwTXoyYPdOeDF7UWMmfnel/IKPk=
X-Received: by 2002:a17:907:c05:: with SMTP id ga5mr19170455ejc.212.1605089213881;
 Wed, 11 Nov 2020 02:06:53 -0800 (PST)
MIME-Version: 1.0
References: <20201111082658.3401686-1-hch@lst.de> <20201111082658.3401686-18-hch@lst.de>
 <CAOi1vP-JjnNdAUqd9Gy6YdFgi8Ev4_Jt3zcB9DhAmdAvQhG7Eg@mail.gmail.com>
In-Reply-To: <CAOi1vP-JjnNdAUqd9Gy6YdFgi8Ev4_Jt3zcB9DhAmdAvQhG7Eg@mail.gmail.com>
From:   Jinpu Wang <jinpu.wang@cloud.ionos.com>
Date:   Wed, 11 Nov 2020 11:06:43 +0100
Message-ID: <CAMGffEmU1ezUo68zF8DS4CRZZMosqhmDw3h7uiWzh2nL8tUs9g@mail.gmail.com>
Subject: Re: [PATCH 17/24] rbd: use set_capacity_and_notify
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        Justin Sanders <justin@coraid.com>,
        Josef Bacik <josef@toxicpanda.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        =?UTF-8?Q?Roger_Pau_Monn=C3=A9?= <roger.pau@citrix.com>,
        Minchan Kim <minchan@kernel.org>,
        Mike Snitzer <snitzer@redhat.com>, Song Liu <song@kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        device-mapper development <dm-devel@redhat.com>,
        linux-block <linux-block@vger.kernel.org>,
        Lars Ellenberg <drbd-dev@lists.linbit.com>,
        nbd@other.debian.org,
        Ceph Development <ceph-devel@vger.kernel.org>,
        xen-devel@lists.xenproject.org,
        linux-raid <linux-raid@vger.kernel.org>,
        linux-nvme@lists.infradead.org,
        Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Nov 11, 2020 at 10:55 AM Ilya Dryomov <idryomov@gmail.com> wrote:
>
> On Wed, Nov 11, 2020 at 9:27 AM Christoph Hellwig <hch@lst.de> wrote:
> >
> > Use set_capacity_and_notify to set the size of both the disk and block
> > device.  This also gets the uevent notifications for the resize for free.
> >
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > Acked-by: Jack Wang <jinpu.wang@cloud.ionos.com>
> > ---
> >  drivers/block/rbd.c | 3 +--
> >  1 file changed, 1 insertion(+), 2 deletions(-)
> >
> > diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
> > index f84128abade319..b7a194ffda55b4 100644
> > --- a/drivers/block/rbd.c
> > +++ b/drivers/block/rbd.c
> > @@ -4920,8 +4920,7 @@ static void rbd_dev_update_size(struct rbd_device *rbd_dev)
> >             !test_bit(RBD_DEV_FLAG_REMOVING, &rbd_dev->flags)) {
> >                 size = (sector_t)rbd_dev->mapping.size / SECTOR_SIZE;
> >                 dout("setting size to %llu sectors", (unsigned long long)size);
> > -               set_capacity(rbd_dev->disk, size);
> > -               revalidate_disk_size(rbd_dev->disk, true);
> > +               set_capacity_and_notify(rbd_dev->disk, size);
> >         }
> >  }
> >
> > --
> > 2.28.0
> >
>
> Hi Christoph,
>
> The Acked-by is wrong here.  I acked this patch (17/24, rbd), and Jack
> acked the next one (18/24, rnbd).
right. :)
>
> Thanks,
>
>                 Ilya
