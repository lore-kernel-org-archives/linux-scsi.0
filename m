Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99224C4361B
	for <linux-scsi@archiver.kernel.org>; Mon, 14 Dec 2020 07:08:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 54E00225A9
	for <linux-scsi@archiver.kernel.org>; Mon, 14 Dec 2020 07:08:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438859AbgLNHIF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 14 Dec 2020 02:08:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392940AbgLNHIF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Dec 2020 02:08:05 -0500
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E92F7C0613CF;
        Sun, 13 Dec 2020 23:07:24 -0800 (PST)
Received: by mail-ej1-x643.google.com with SMTP id n26so21039455eju.6;
        Sun, 13 Dec 2020 23:07:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QWzR/ajntQQ8OUu1eo9cHzjXBqYXTELyiik0EYAgp6c=;
        b=BZQh5xNlSsdb6hrrLdcbHcyRgcGFT9VrZOvm68joTduKjVi50NMmX22Yugytx7Xo7H
         w2vZaNPSJQSAYyk8ZabBa2YDHeJqQAC69t+CcHfIfBAxCCOoAlIK0TqYUG6pAk527fWZ
         VGQ5x9zaF8Ai0ogqnOor13smC6PoDtuDitdzZTdLzkkp8hPUmh5XZRzM8M11ukL1h5Nc
         deqr7VXcjIrlzRbxOlaUpVePANjCg54N45MIs+7kgw8s2AtMOBhmHjIF4tbU34Cy+GxZ
         FpsqKBBLubkEmgd74TfY82x27SkLuBNKrz5lpwjmAUyUTzz2Bl/YauGXzLp4xdF3i00q
         Qqww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QWzR/ajntQQ8OUu1eo9cHzjXBqYXTELyiik0EYAgp6c=;
        b=UmsteioTogXDz2FEgusEU1oQZBc+tG8YTU/IyXH0oI7OYnC8urlwjHYfDhUvT5WvFw
         3aBGd17pDC5eFf5NQObOzHYTqQgoXD4RocyzEEMtegh+ix+AqH5cuXowjqw8Rc42s1ZI
         tgLLjmCCL2c5F/NXEurzyWpaOdNu66FYSBVZzNik57rOSTsHHX4jCyQGmdbZdrl6BwLZ
         t7H21lvlM+CNuFWIB5DyM80W5dsFgzMYA141dPl4zKHlC6HUD8YqvEJNZBxNlDvQRjx+
         qOhyEJNA/PscpiQEj51Z/0yQPRf4n6E+vLWW44LHB0wyS+aYfVR5qHxl5EtUEAkgA1rz
         zUvA==
X-Gm-Message-State: AOAM531ku2QqjK3JVMRfv5ts/y7c6awKNSRN+g8yUaqD4TP24vmAvKLL
        sv7vFUTTaNmYOqEMlCjSSjFaH6EoP+o9ZMFajgk=
X-Google-Smtp-Source: ABdhPJznXbr+iFcyZQ0stzB05Z3JXUu6f2/PCyWYcbP3IUZ3HcqQL6yvr7ZEoaMx/h/x22bIeETtTTVWUHBtMe+z7b0=
X-Received: by 2002:a17:906:68d1:: with SMTP id y17mr21530318ejr.447.1607929643589;
 Sun, 13 Dec 2020 23:07:23 -0800 (PST)
MIME-Version: 1.0
References: <20201211135139.49232-1-selvakuma.s1@samsung.com>
 <CGME20201211135200epcas5p217eaa00b35a59b3468c198d85309fd7d@epcas5p2.samsung.com>
 <20201211135139.49232-2-selvakuma.s1@samsung.com> <SN4PR0401MB359867B95139ACD1ACFF0E709BCA0@SN4PR0401MB3598.namprd04.prod.outlook.com>
In-Reply-To: <SN4PR0401MB359867B95139ACD1ACFF0E709BCA0@SN4PR0401MB3598.namprd04.prod.outlook.com>
From:   Selva Jove <selvajove@gmail.com>
Date:   Mon, 14 Dec 2020 12:37:08 +0530
Message-ID: <CAHqX9vYfGONfavB1hLRtdeSwhU6VWrPLzXFfmgwkB6-pgB9o7g@mail.gmail.com>
Subject: Re: [RFC PATCH v3 1/2] block: add simple copy support
To:     Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
Cc:     SelvaKumar S <selvakuma.s1@samsung.com>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "kbusch@kernel.org" <kbusch@kernel.org>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        "hch@lst.de" <hch@lst.de>, "sagi@grimberg.me" <sagi@grimberg.me>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "mpatocka@redhat.com" <mpatocka@redhat.com>,
        "hare@suse.de" <hare@suse.de>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>,
        "snitzer@redhat.com" <snitzer@redhat.com>,
        "nj.shetty@samsung.com" <nj.shetty@samsung.com>,
        "joshi.k@samsung.com" <joshi.k@samsung.com>,
        "javier.gonz@samsung.com" <javier.gonz@samsung.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Dec 11, 2020 at 9:56 PM Johannes Thumshirn
<Johannes.Thumshirn@wdc.com> wrote:
>
> On 11/12/2020 15:57, SelvaKumar S wrote:
> [...]
> > +int blk_copy_emulate(struct block_device *bdev, struct blk_copy_payload *payload,
> > +             gfp_t gfp_mask)
> > +{
> > +     struct request_queue *q = bdev_get_queue(bdev);
> > +     struct bio *bio;
> > +     void *buf = NULL;
> > +     int i, nr_srcs, max_range_len, ret, cur_dest, cur_size;
> > +
> > +     nr_srcs = payload->copy_range;
> > +     max_range_len = q->limits.max_copy_range_sectors << SECTOR_SHIFT;
> > +     cur_dest = payload->dest;
> > +     buf = kvmalloc(max_range_len, GFP_ATOMIC);
>
> Why GFP_ATOMIC and not the passed in gfp_mask? Especially as this is a kvmalloc()
> which has the potential to grow quite big.
>
> > +int __blkdev_issue_copy(struct block_device *bdev, sector_t dest,
> > +             sector_t nr_srcs, struct range_entry *rlist, gfp_t gfp_mask,
> > +             int flags, struct bio **biop)
> > +{
>
> [...]
>
> > +     total_size = struct_size(payload, range, nr_srcs);
> > +     payload = kmalloc(total_size, GFP_ATOMIC | __GFP_NOWARN);
>
> Same here.
>
>
> > diff --git a/block/ioctl.c b/block/ioctl.c
> > index 6b785181344f..a4a507d85e56 100644
> > --- a/block/ioctl.c
> > +++ b/block/ioctl.c
> > @@ -142,6 +142,47 @@ static int blk_ioctl_discard(struct block_device *bdev, fmode_t mode,
> >                                   GFP_KERNEL, flags);
> >  }
> >
> > +static int blk_ioctl_copy(struct block_device *bdev, fmode_t mode,
> > +             unsigned long arg, unsigned long flags)
> > +{
>
> [...]
>
> > +
> > +     rlist = kmalloc_array(crange.nr_range, sizeof(*rlist),
> > +                     GFP_ATOMIC | __GFP_NOWARN);
>
> And here. I think this one can even be GFP_KERNEL.
>
>
>

Thanks. Will fix this.
