Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3ED8FC43333
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Jan 2021 12:44:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0F17F207B1
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Jan 2021 12:44:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726681AbhADMnd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 Jan 2021 07:43:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726236AbhADMnc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Jan 2021 07:43:32 -0500
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76CBCC061793;
        Mon,  4 Jan 2021 04:42:52 -0800 (PST)
Received: by mail-ej1-x635.google.com with SMTP id b9so36656286ejy.0;
        Mon, 04 Jan 2021 04:42:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rZ4LGlK8t6B2Ly3eEurbHpHQoNf2RZlRTogtRk6wi6I=;
        b=OZtau2X7JLY3EeaL0vUwonTH8SRHkJASO32dRB2kYesG//bEP4SaZzuyAHIbE8uRxF
         YQh36KBJ91CaZYIzTSeOtCOZb732OFHaEZkCMVU8elBc+B0c1VwclwtLdl97I/2w/hEy
         IxeqAdS/qUEvl2AXaErOHhqjJlFH9X3MYC8E1JEHDyzpV3bmHF249p4uTdnLX2cwMbvR
         kff7QrA9uV+5VDrIBZIk4l/JAr59DBh5XV0TbcVJ1RtumQyK/+Zyb4BduSG4JOBtFN8X
         HporEIy9BjlXaD9ta87ZqYsiNKLeCUqatx+qz3gKeRdQMYN5Vh/TTuAVA7yejVk/9yDn
         5MPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rZ4LGlK8t6B2Ly3eEurbHpHQoNf2RZlRTogtRk6wi6I=;
        b=mfFE5tRWcdfYTs7h89VlK39eetqE8iUcXy/9L6UcXITMgXTdbozdtLcVKJ292r0hEi
         SCp0D4oLkw2h1xA5aiih/fWIuYa6SKM/FhTRb/LV/J51RFts0YviPBEbsP1+RaXRGxNm
         QsWG90xcF9yhC6RlN66qT/77cIbHgbDYTHknJB38wAbUI1+5LWnr6bPK0d0OURnifDj2
         BFmRrAWa4pPpIM/CHkCI1JYoBNdySv9VKiJJ3daarTocPRvTQKuTr/H28r4mf3QdwvL7
         XUdvG860nGUT4UvohTH1GTXEHG9wxBlNXqw7JMLgILF6xC+MpNtwB77hzTNCYf5XyZaA
         ThOQ==
X-Gm-Message-State: AOAM53186WJZGWwtSCTgtKwQiU9/aenqK+aKU8o9BXqO5GYCwKRr0O+O
        V+pYu5KUiGRnbMFolAfihiw7zZBZ/r/tIEPALxA=
X-Google-Smtp-Source: ABdhPJxwYB1Zb9l3tnKL6RKFyWxN5t6NeOfBATjkNz0+iOKlwVm8wlAvD0ezqYE3Ujva2bM13wJtSYbmW5Co7o5A/i4=
X-Received: by 2002:a17:906:68d1:: with SMTP id y17mr66905761ejr.447.1609764171043;
 Mon, 04 Jan 2021 04:42:51 -0800 (PST)
MIME-Version: 1.0
References: <20210104104159.74236-1-selvakuma.s1@samsung.com>
 <CGME20210104104245epcas5p26ed395efbf74e78a4e44048a6d7d6ba7@epcas5p2.samsung.com>
 <20210104104159.74236-2-selvakuma.s1@samsung.com> <BL0PR04MB6514554D569AC302850BA1DDE7D20@BL0PR04MB6514.namprd04.prod.outlook.com>
In-Reply-To: <BL0PR04MB6514554D569AC302850BA1DDE7D20@BL0PR04MB6514.namprd04.prod.outlook.com>
From:   Selva Jove <selvajove@gmail.com>
Date:   Mon, 4 Jan 2021 18:12:39 +0530
Message-ID: <CAHqX9vbuq=N0LwH25x6fHajy8Q65dyKyKJhJOksKYW1U3YGHZw@mail.gmail.com>
Subject: Re: [RFC PATCH v4 1/3] block: export bio_map_kern()
To:     Damien Le Moal <Damien.LeMoal@wdc.com>
Cc:     SelvaKumar S <selvakuma.s1@samsung.com>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "kbusch@kernel.org" <kbusch@kernel.org>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        Johannes Thumshirn <Johannes.Thumshirn@wdc.com>,
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

Thanks Damien, Will update that.

On Mon, Jan 4, 2021 at 5:45 PM Damien Le Moal <Damien.LeMoal@wdc.com> wrote:
>
> On 2021/01/04 19:48, SelvaKumar S wrote:
> > Export bio_map_kern() so that copy offload emulation can use
> > it to add vmalloced memory to bio.
> >
> > Signed-off-by: SelvaKumar S <selvakuma.s1@samsung.com>
> > ---
> >  block/blk-map.c        | 3 ++-
> >  include/linux/blkdev.h | 2 ++
> >  2 files changed, 4 insertions(+), 1 deletion(-)
> >
> > diff --git a/block/blk-map.c b/block/blk-map.c
> > index 21630dccac62..50d61475bb68 100644
> > --- a/block/blk-map.c
> > +++ b/block/blk-map.c
> > @@ -378,7 +378,7 @@ static void bio_map_kern_endio(struct bio *bio)
> >   *   Map the kernel address into a bio suitable for io to a block
> >   *   device. Returns an error pointer in case of error.
> >   */
> > -static struct bio *bio_map_kern(struct request_queue *q, void *data,
> > +struct bio *bio_map_kern(struct request_queue *q, void *data,
> >               unsigned int len, gfp_t gfp_mask)
> >  {
> >       unsigned long kaddr = (unsigned long)data;
> > @@ -428,6 +428,7 @@ static struct bio *bio_map_kern(struct request_queue *q, void *data,
> >       bio->bi_end_io = bio_map_kern_endio;
> >       return bio;
> >  }
> > +EXPORT_SYMBOL(bio_map_kern);
>
> Simple copy support is a block layer code, so you I do not think you need this.
> You only need to remove the static declaration of the function.
>
> >
> >  static void bio_copy_kern_endio(struct bio *bio)
> >  {
> > diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> > index 070de09425ad..81f9e7bec16c 100644
> > --- a/include/linux/blkdev.h
> > +++ b/include/linux/blkdev.h
> > @@ -936,6 +936,8 @@ extern int blk_rq_map_user(struct request_queue *, struct request *,
> >                          struct rq_map_data *, void __user *, unsigned long,
> >                          gfp_t);
> >  extern int blk_rq_unmap_user(struct bio *);
> > +extern struct bio *bio_map_kern(struct request_queue *q, void *data,
> > +                             unsigned int len, gfp_t gfp_mask);
> >  extern int blk_rq_map_kern(struct request_queue *, struct request *, void *, unsigned int, gfp_t);
> >  extern int blk_rq_map_user_iov(struct request_queue *, struct request *,
> >                              struct rq_map_data *, const struct iov_iter *,
> >
>
>
> --
> Damien Le Moal
> Western Digital Research
