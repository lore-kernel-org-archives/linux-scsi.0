Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF49CC4361B
	for <linux-scsi@archiver.kernel.org>; Mon, 14 Dec 2020 06:59:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6ADC022583
	for <linux-scsi@archiver.kernel.org>; Mon, 14 Dec 2020 06:59:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437659AbgLNG6a (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 14 Dec 2020 01:58:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727672AbgLNG63 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Dec 2020 01:58:29 -0500
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66581C0613CF;
        Sun, 13 Dec 2020 22:57:49 -0800 (PST)
Received: by mail-ed1-x541.google.com with SMTP id u19so16016238edx.2;
        Sun, 13 Dec 2020 22:57:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SBDQ/ozr1+cMGjDjwKraN3A/q+s0aVrfJg3tJsBwW/c=;
        b=QvmF/vu64Ei8tR6QADdulsd7lyo1cn3N/x/le8e6+ICWMme6u7X1yVHpDnKhVV1PQu
         Ci3yOVEl0AVBmWSoyDWaBpd//YjERpJdy+Bni0re0LDz8TAHm7NrDKOPmoKrubq5MZ+2
         toB9XQXCemEc1yBiPwEk7S21aNkH6ZTAb0+Qdefdy/w44TZf5ag9SPLvrPnkPgoyTqV2
         PIC04Jaoe0g/SfzCNn6CzA2xcaLGe8ZkWY4AwmrvC2uixpwrStNMvX+2I1aMwGYmmUyQ
         Oh73T2RxBcRhpKRTo1ilj0rxuYeNHGtGyCU3rzgQ0obM6wvNwAxtLFDXLAXD5eTagEIL
         sIFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SBDQ/ozr1+cMGjDjwKraN3A/q+s0aVrfJg3tJsBwW/c=;
        b=F+VCFJj3a8m+gOzPRsSrRgmlEDvnkVUPtccUIjm9setfiGUDnFgy2okwBMRddFVXPT
         WhLOpVPdNhfRAjOBIepwptS0Kj3a9CtAA+DK3Ea5gfT7wtubPpYpv2sztqem2CStNzGm
         TieCktatzOeqbqeLheJtufNOHX9SPcDkWdO25vb1jYIKgNykOSHP/jl7HiKZoIFUL3Ae
         3lTgljLdMrY2JdxppO5BPdJi4lMqn8jA94HFApJs7nRqM8rbtAL/32u7qJKj4aPD3IZ7
         tx55Q5b6WUwW4pvfWzHa9P0ac4FpxF9BYAmvgsRG63fCfxdLoDRxMQ2L82bikNhBXUzk
         HnXA==
X-Gm-Message-State: AOAM531G9c1GHBR2j3mfQgxdkE9zSk2Mf4N8fGHAXjnkAA3FHOcsonOg
        /WMvDtzeLd5EEzFrggnrBX1b8zxHd9mYkqs2MYo=
X-Google-Smtp-Source: ABdhPJy9fRCeat4gb5XKvmqoE7tXBBH2nVrfV3qBRQb1jokU/DqVjpgFa/P//03AdoLMtwqozlQM7SSYPoT/nhq5KVs=
X-Received: by 2002:a05:6402:17a3:: with SMTP id j3mr23295833edy.333.1607929067913;
 Sun, 13 Dec 2020 22:57:47 -0800 (PST)
MIME-Version: 1.0
References: <20201211135139.49232-1-selvakuma.s1@samsung.com>
 <CGME20201211135200epcas5p217eaa00b35a59b3468c198d85309fd7d@epcas5p2.samsung.com>
 <20201211135139.49232-2-selvakuma.s1@samsung.com> <20201211180451.GA9103@redsun51.ssa.fujisawa.hgst.com>
In-Reply-To: <20201211180451.GA9103@redsun51.ssa.fujisawa.hgst.com>
From:   Selva Jove <selvajove@gmail.com>
Date:   Mon, 14 Dec 2020 12:27:32 +0530
Message-ID: <CAHqX9vYFudV1WX-R0oRBW7rKpCJzt_DgmW9FWZdDzOwMoCxfCw@mail.gmail.com>
Subject: Re: [RFC PATCH v3 1/2] block: add simple copy support
To:     Keith Busch <kbusch@kernel.org>
Cc:     SelvaKumar S <selvakuma.s1@samsung.com>,
        linux-nvme@lists.infradead.org, axboe@kernel.dk,
        Damien Le Moal <damien.lemoal@wdc.com>,
        Johannes Thumshirn <Johannes.Thumshirn@wdc.com>, hch@lst.de,
        sagi@grimberg.me, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        martin.petersen@oracle.com, bvanassche@acm.org,
        mpatocka@redhat.com, hare@suse.de, dm-devel@redhat.com,
        snitzer@redhat.com, nj.shetty@samsung.com, joshi.k@samsung.com,
        javier.gonz@samsung.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Dec 11, 2020 at 11:35 PM Keith Busch <kbusch@kernel.org> wrote:
>
> On Fri, Dec 11, 2020 at 07:21:38PM +0530, SelvaKumar S wrote:
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
>
> The default value for this limit is 0, and this is the function for when
> the device doesn't support copy. Are we expecting drivers to set this
> value to something else for that case?

Sorry. Missed that. Will add a fix.

>
> > +     cur_dest = payload->dest;
> > +     buf = kvmalloc(max_range_len, GFP_ATOMIC);
> > +     if (!buf)
> > +             return -ENOMEM;
> > +
> > +     for (i = 0; i < nr_srcs; i++) {
> > +             bio = bio_alloc(gfp_mask, 1);
> > +             bio->bi_iter.bi_sector = payload->range[i].src;
> > +             bio->bi_opf = REQ_OP_READ;
> > +             bio_set_dev(bio, bdev);
> > +
> > +             cur_size = payload->range[i].len << SECTOR_SHIFT;
> > +             ret = bio_add_page(bio, virt_to_page(buf), cur_size,
> > +                                                offset_in_page(payload));
>
> 'buf' is vmalloc'ed, so we don't necessarily have congituous pages. I
> think you need to allocate the bio with bio_map_kern() or something like
> that instead with that kind of memory.
>

Sure. Will use bio_map_kern().

> > +             if (ret != cur_size) {
> > +                     ret = -ENOMEM;
> > +                     goto out;
> > +             }
> > +
> > +             ret = submit_bio_wait(bio);
> > +             bio_put(bio);
> > +             if (ret)
> > +                     goto out;
> > +
> > +             bio = bio_alloc(gfp_mask, 1);
> > +             bio_set_dev(bio, bdev);
> > +             bio->bi_opf = REQ_OP_WRITE;
> > +             bio->bi_iter.bi_sector = cur_dest;
> > +             ret = bio_add_page(bio, virt_to_page(buf), cur_size,
> > +                                                offset_in_page(payload));
> > +             if (ret != cur_size) {
> > +                     ret = -ENOMEM;
> > +                     goto out;
> > +             }
> > +
> > +             ret = submit_bio_wait(bio);
> > +             bio_put(bio);
> > +             if (ret)
> > +                     goto out;
> > +
> > +             cur_dest += payload->range[i].len;
> > +     }
>
> I think this would be a faster implementation if the reads were
> asynchronous with a payload buffer allocated specific to that read, and
> the callback can enqueue the write part. This would allow you to
> accumulate all the read data and write it in a single call.

Sounds like a better approach. Will add this implementation in v4.
