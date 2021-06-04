Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26123C07E94
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Jun 2021 07:53:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0D9E96141A
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Jun 2021 07:53:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230201AbhFDHzY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 4 Jun 2021 03:55:24 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:57640 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230033AbhFDHzX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Jun 2021 03:55:23 -0400
Received: from epcas1p2.samsung.com (unknown [182.195.41.46])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20210604075335epoutp040571e7efc6110040ff4a05b52435e78e~FUdTkeeB93127231272epoutp04B
        for <linux-scsi@vger.kernel.org>; Fri,  4 Jun 2021 07:53:35 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20210604075335epoutp040571e7efc6110040ff4a05b52435e78e~FUdTkeeB93127231272epoutp04B
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1622793215;
        bh=amaw+0H8W+Fhj7Nf7hiWJwJR+lm0YEKlXEFg1GB/dS0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Mf26SfZgU1l7AlqXXdiAYCXZw4cT14tFxsSHsgTr/i6o6QLanIQmCvNE+IjnR27gj
         WXukdK1HDzaEIsdgVVBGO2IWF3Pkb9YnFF37CSiloQtt/3BDUoM6LqQGB7Zw1im/QD
         6jl2Co6n1Nqs1BwiZCoQM2OF0WNEA0RN00ChPb44=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas1p4.samsung.com (KnoxPortal) with ESMTP id
        20210604075334epcas1p4268937892fa3f1e2bb6429a31500b3f7~FUdSVEBbS0341603416epcas1p4r;
        Fri,  4 Jun 2021 07:53:34 +0000 (GMT)
Received: from epsmges1p4.samsung.com (unknown [182.195.40.164]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4FxFPm5DwDz4x9QG; Fri,  4 Jun
        2021 07:53:32 +0000 (GMT)
Received: from epcas1p3.samsung.com ( [182.195.41.47]) by
        epsmges1p4.samsung.com (Symantec Messaging Gateway) with SMTP id
        0A.87.10258.CFBD9B06; Fri,  4 Jun 2021 16:53:32 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20210604075331epcas1p13bb57f9ddfc7b112dec1ba8cf40fdc74~FUdP1FTyV0559505595epcas1p16;
        Fri,  4 Jun 2021 07:53:31 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20210604075331epsmtrp2445529b81b4f263af9325cbba08617be~FUdPylz430440304403epsmtrp2b;
        Fri,  4 Jun 2021 07:53:31 +0000 (GMT)
X-AuditID: b6c32a38-419ff70000002812-89-60b9dbfcdcc7
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        96.83.08637.BFBD9B06; Fri,  4 Jun 2021 16:53:31 +0900 (KST)
Received: from localhost.localdomain (unknown [10.253.99.105]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20210604075331epsmtip1eba947405c410d3e37912210147f064b~FUdPb-wZy0959109591epsmtip1g;
        Fri,  4 Jun 2021 07:53:31 +0000 (GMT)
From:   Changheun Lee <nanich.lee@samsung.com>
To:     damien.lemoal@wdc.com
Cc:     Avri.Altman@wdc.com, Johannes.Thumshirn@wdc.com,
        alex_y_xu@yahoo.ca, alim.akhtar@samsung.com,
        asml.silence@gmail.com, axboe@kernel.dk, bgoncalv@redhat.com,
        bvanassche@acm.org, cang@codeaurora.org,
        gregkh@linuxfoundation.org, hch@infradead.org, jaegeuk@kernel.org,
        jejb@linux.ibm.com, jisoo2146.oh@samsung.com,
        junho89.kim@samsung.com, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        martin.petersen@oracle.com, ming.lei@redhat.com,
        mj0123.lee@samsung.com, nanich.lee@samsung.com, osandov@fb.com,
        patchwork-bot@kernel.org, seunghwan.hyun@samsung.com,
        sookwan7.kim@samsung.com, tj@kernel.org, tom.leiming@gmail.com,
        woosung2.lee@samsung.com, yi.zhang@redhat.com,
        yt0928.kim@samsung.com
Subject: Re: [PATCH v12 1/3] bio: control bio max size
Date:   Fri,  4 Jun 2021 16:34:59 +0900
Message-Id: <20210604073459.29235-1-nanich.lee@samsung.com>
X-Mailer: git-send-email 2.29.0
In-Reply-To: <DM6PR04MB70812AF342F46F453696A447E73B9@DM6PR04MB7081.namprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA01Ta1ATVxSeu7vZDVBkQbTXOBXMWDs8TXh5baG1lTpbrIq1j1GrJIVtcAxJ
        zAbaYrVWrLwRxIoiCFJHHR6mRYshYxAjlkIBrSnGgfIa4wtfkKADitrExan/vnPO953vnnPn
        CHEfAyUSblTpWK1KrhST7kTD+YAFIZO9jTLJ2avz0Yl/ayk0eKiBRGXVDQDdnugmUU3fbhIZ
        /64AaN/IBI7s+qMC9FPmIwxl/KIn0V+FVRiy6UtxVHW1AUN5th0C9DSnH0MPhzhk6glCFmMZ
        iXKtBhIda32GIXNxBoZKTpbh6MpAB4XO93cTaOhIEY662uwCdOjaYvT42AWAHoxbKdRuKMaR
        tWsfifSmCXKxP2P5ZxljKcjHmKKM+xTTWNpHMSePBzKWzlSmvjqbZAqrmgFztryWYkav9xDM
        g6Zukik4VQ0YR/0cJrM5F2PM5qN4vNdaZXQyK09itf6sKlGdtFGliBEvW52wJCEySiINkS5C
        C8X+KnkKGyOO/Tg+ZOlGpXNfYv80uTLVmYqXc5x4wbvRWnWqjvVPVnO6GDGrSVJqpBJNKCdP
        4VJVitBEdcrbUokkLNLJlCmTW4qLBJrDK7+9u6OC3A4mFuUANyGkI6Atoxe4sA9tAPDxiCwH
        uDuxHUDTn0aSDx4B+OzSdeKlov3cOMUXTABeKt9O8IEDwN1DowIXi6SDYcG9HtKFfelZsP32
        2AuM08MC2NQucuHpdBTc21f+oitBvwlbRu2UC3vS78CB/Xco3s0PTg7k4S7sRq+Hp5/0EjzH
        G7YdsBF8Tz+Y8ftB3PUISA+7wUHLkSlxLKwZvIjzeDocbj01lRdBx30TyQtyAczYVQH4oBDA
        IzePYjwrHNodDmdB6LQIgHrjAj49FzY+KQe88zR4/2GewEWBtCfM2uXDU+bBjp0D+Euvm3WN
        Ux0ZaL/VMbW6XwGsP91FFAL/0lcGKn1loNL/nSsBXg1mshouRcFyUk3Eq39cD16cUCAygPJ7
        I6FmgAmBGUAhLvb1PDPfIPPxTJJ/l85q1QnaVCXLmUGkc91FuGhGotp5gypdgjQyLDw8HEVE
        LYyKDBe/7qlYskXmQyvkOnYTy2pY7UsdJnQTbcfW7v7E+8PsGCODFS1zP/zRlfRVDSJDVtaX
        Wm8xMdFWEFy36drSYs5s5jSzqWkgubr79PfnKswp656bDj6JuvDHlrAblVtLPGz2De01X7z1
        hqHyg+jmG6vvuLdsPQBFy+tamvabBjKr05pOSPLnTJJV637eXGL8TT77rtea0Kc1tYr3Lu59
        FJ14+Ti2pyl9RcuKH0tKQj7N9pgZV8cQnTdb1wfqpz/fc/nMyjF9z2ev+Y3VDeuy45d/5Tt0
        47m1s/KKbPMkFbjT7/M426zx2D2zQ3940MmK5ZNJxTN0h7bp38/0eBjXH7xmcFtafkD9182b
        HF4d1uFbQdQGL+voqgBL4d153yw6FyQmuGS5NBDXcvL/ADQVaYXLBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrPIsWRmVeSWpSXmKPExsWy7bCSnO7v2zsTDPqWCFusu7OG3eLBvG1s
        FnNWbWO0ePnzKpvF6rv9bBa7Ls5ntJj24Sezxaf1y1gtWtu/MVk0L17PZnF6wiImiyfrZzFb
        LLqxjcmi50kTq8XfrntMFl8fFlvsvaVtcXnXHDaL7us72CyWH//HZHFocjOTxfTNc5gtrt0/
        w25x+N5VFouHSyYyW5w7+YnVYt5jB4tfy48yWrz/cZ3d4tSOycwW189NY7NYv/cnm4OCx+Ur
        3h6X+3qZPCY2v2P32DnrLrvH5hVaHpfPlnpsWtXJ5jFh0QFGj/1z17B7fHx6i8Xj/b6rbB59
        W1YxenzeJOfRfqCbyePQoWXMAfxRXDYpqTmZZalF+nYJXBlHJk9kLVjoX/GmaT5bA+NPyy5G
        Tg4JAROJUwd/sHcxcnEICexmlHhzdhYTREJK4viJt6xdjBxAtrDE4cPFIGEhgY+MEgem+YLY
        bAI6En1vb7GB2CICkhKnXn5hA5nDLDCJTeJAzxQWkISwgJnElLtzwWwWAVWJIx8/sYPYvALW
        EvdnvGaH2CUv8ed+DzOIzSkQK7H9920WiGUxEgc/NbFC1AtKnJz5BCzODFTfvHU28wRGgVlI
        UrOQpBYwMq1ilEwtKM5Nzy02LDDMSy3XK07MLS7NS9dLzs/dxAhOE1qaOxi3r/qgd4iRiYPx
        EKMEB7OSCO8etR0JQrwpiZVVqUX58UWlOanFhxilOViUxHkvdJ2MFxJITyxJzU5NLUgtgsky
        cXBKNTAtropZazyv7evK4Cl8qYtTVt0QDPVPOXbA8dislHcZu38pxfq0BT/fOdH+RtOk3lrt
        I8IbzIIt1gtfT1jimzGFcUmIeMaH5Nk/XihtKNhfrl5c+7S6p4ovuLvvdMj+p4e3zPU/vNU+
        NzZxDscCAdegj4s97K/ZFvlv3rl2x6x0E++wBee3ey/MXRKg5v/JiqslSEJITq1g6bmz9etO
        5KQfXXrFfb7Q1ryjM8Q5rnrYSfR6Zjq9z3yZu+KhuCGzVWWR4Psf5zl7vj9nOcV2SLhhGkv0
        jD23j5cq/nwkPUXqitWGsyv9FXY2u/frebmdiNjY9jRRUWmr9pW/n69PTepjzc1b89ba6RvD
        BaXvR2yVWIozEg21mIuKEwFL1/xlggMAAA==
X-CMS-MailID: 20210604075331epcas1p13bb57f9ddfc7b112dec1ba8cf40fdc74
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: SVC_REQ_APPROVE
CMS-TYPE: 101P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210604075331epcas1p13bb57f9ddfc7b112dec1ba8cf40fdc74
References: <DM6PR04MB70812AF342F46F453696A447E73B9@DM6PR04MB7081.namprd04.prod.outlook.com>
        <CGME20210604075331epcas1p13bb57f9ddfc7b112dec1ba8cf40fdc74@epcas1p1.samsung.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> On 2021/06/04 14:22, Changheun Lee wrote:
> > bio size can grow up to 4GB after muli-page bvec has been enabled.
> > But sometimes large size of bio would lead to inefficient behaviors.
> > Control of bio max size will be helpful to improve inefficiency.
> > 
> > Below is a example for inefficient behaviours.
> > In case of large chunk direct I/O, - 32MB chunk read in user space -
> > all pages for 32MB would be merged to a bio structure if the pages
> > physical addresses are contiguous. It makes some delay to submit
> > until merge complete. bio max size should be limited to a proper size.
> > 
> > When 32MB chunk read with direct I/O option is coming from userspace,
> > kernel behavior is below now in do_direct_IO() loop. It's timeline.
> > 
> >  | bio merge for 32MB. total 8,192 pages are merged.
> >  | total elapsed time is over 2ms.
> >  |------------------ ... ----------------------->|
> >                                                  | 8,192 pages merged a bio.
> >                                                  | at this time, first bio submit is done.
> >                                                  | 1 bio is split to 32 read request and issue.
> >                                                  |--------------->
> >                                                   |--------------->
> >                                                    |--------------->
> >                                                               ......
> >                                                                    |--------------->
> >                                                                     |--------------->|
> >                           total 19ms elapsed to complete 32MB read done from device. |
> > 
> > If bio max size is limited with 1MB, behavior is changed below.
> > 
> >  | bio merge for 1MB. 256 pages are merged for each bio.
> >  | total 32 bio will be made.
> >  | total elapsed time is over 2ms. it's same.
> >  | but, first bio submit timing is fast. about 100us.
> >  |--->|--->|--->|---> ... -->|--->|--->|--->|--->|
> >       | 256 pages merged a bio.
> >       | at this time, first bio submit is done.
> >       | and 1 read request is issued for 1 bio.
> >       |--------------->
> >            |--------------->
> >                 |--------------->
> >                                       ......
> >                                                  |--------------->
> >                                                   |--------------->|
> >         total 17ms elapsed to complete 32MB read done from device. |
> > 
> > As a result, read request issue timing is faster if bio max size is limited.
> > Current kernel behavior with multipage bvec, super large bio can be created.
> > And it lead to delay first I/O request issue.
> > 
> > Signed-off-by: Changheun Lee <nanich.lee@samsung.com>
> > ---
> >  block/bio.c            | 17 ++++++++++++++---
> >  block/blk-settings.c   | 19 +++++++++++++++++++
> >  include/linux/bio.h    |  4 +++-
> >  include/linux/blkdev.h |  3 +++
> >  4 files changed, 39 insertions(+), 4 deletions(-)
> > 
> > diff --git a/block/bio.c b/block/bio.c
> > index 44205dfb6b60..73b673f1684e 100644
> > --- a/block/bio.c
> > +++ b/block/bio.c
> > @@ -255,6 +255,13 @@ void bio_init(struct bio *bio, struct bio_vec *table,
> >  }
> >  EXPORT_SYMBOL(bio_init);
> >  
> > +unsigned int bio_max_bytes(struct bio *bio)
> > +{
> > +	struct block_device *bdev = bio->bi_bdev;
> > +
> > +	return bdev ? bdev->bd_disk->queue->limits.max_bio_bytes : UINT_MAX;
> > +}
> 
> unsigned int bio_max_bytes(struct bio *bio)
> {
> 	struct block_device *bdev = bio->bi_bdev;
> 
> 	if (!bdev)
> 		return UINT_MAX;
> 	return bdev->bd_disk->queue->limits.max_bio_bytes;
> }
> 
> is a lot more readable...
> Also, I remember there was some problems with bd_disk possibly being null. Was
> that fixed ?

Thank you for review. But I'd like current style, and it's readable enough
now I think. Null of bd_disk was just suspicion. bd_disk is not null if bdev
is not null.

> 
> > +
> >  /**
> >   * bio_reset - reinitialize a bio
> >   * @bio:	bio to reset
> > @@ -866,7 +873,7 @@ bool __bio_try_merge_page(struct bio *bio, struct page *page,
> >  		struct bio_vec *bv = &bio->bi_io_vec[bio->bi_vcnt - 1];
> >  
> >  		if (page_is_mergeable(bv, page, len, off, same_page)) {
> > -			if (bio->bi_iter.bi_size > UINT_MAX - len) {
> > +			if (bio->bi_iter.bi_size > bio_max_bytes(bio) - len) {
> >  				*same_page = false;
> >  				return false;
> >  			}
> > @@ -995,6 +1002,7 @@ static int __bio_iov_iter_get_pages(struct bio *bio, struct iov_iter *iter)
> >  {
> >  	unsigned short nr_pages = bio->bi_max_vecs - bio->bi_vcnt;
> >  	unsigned short entries_left = bio->bi_max_vecs - bio->bi_vcnt;
> > +	unsigned int bytes_left = bio_max_bytes(bio) - bio->bi_iter.bi_size;
> >  	struct bio_vec *bv = bio->bi_io_vec + bio->bi_vcnt;
> >  	struct page **pages = (struct page **)bv;
> >  	bool same_page = false;
> > @@ -1010,7 +1018,8 @@ static int __bio_iov_iter_get_pages(struct bio *bio, struct iov_iter *iter)
> >  	BUILD_BUG_ON(PAGE_PTRS_PER_BVEC < 2);
> >  	pages += entries_left * (PAGE_PTRS_PER_BVEC - 1);
> >  
> > -	size = iov_iter_get_pages(iter, pages, LONG_MAX, nr_pages, &offset);
> > +	size = iov_iter_get_pages(iter, pages, bytes_left, nr_pages,
> > +				  &offset);
> >  	if (unlikely(size <= 0))
> >  		return size ? size : -EFAULT;
> >  
> > @@ -1038,6 +1047,7 @@ static int __bio_iov_append_get_pages(struct bio *bio, struct iov_iter *iter)
> >  {
> >  	unsigned short nr_pages = bio->bi_max_vecs - bio->bi_vcnt;
> >  	unsigned short entries_left = bio->bi_max_vecs - bio->bi_vcnt;
> > +	unsigned int bytes_left = bio_max_bytes(bio) - bio->bi_iter.bi_size;
> >  	struct request_queue *q = bio->bi_bdev->bd_disk->queue;
> >  	unsigned int max_append_sectors = queue_max_zone_append_sectors(q);
> >  	struct bio_vec *bv = bio->bi_io_vec + bio->bi_vcnt;
> > @@ -1058,7 +1068,8 @@ static int __bio_iov_append_get_pages(struct bio *bio, struct iov_iter *iter)
> >  	BUILD_BUG_ON(PAGE_PTRS_PER_BVEC < 2);
> >  	pages += entries_left * (PAGE_PTRS_PER_BVEC - 1);
> >  
> > -	size = iov_iter_get_pages(iter, pages, LONG_MAX, nr_pages, &offset);
> > +	size = iov_iter_get_pages(iter, pages, bytes_left, nr_pages,
> > +				  &offset);
> >  	if (unlikely(size <= 0))
> >  		return size ? size : -EFAULT;
> >  
> > diff --git a/block/blk-settings.c b/block/blk-settings.c
> > index 902c40d67120..e270e31519a1 100644
> > --- a/block/blk-settings.c
> > +++ b/block/blk-settings.c
> > @@ -32,6 +32,7 @@ EXPORT_SYMBOL_GPL(blk_queue_rq_timeout);
> >   */
> >  void blk_set_default_limits(struct queue_limits *lim)
> >  {
> > +	lim->max_bio_bytes = UINT_MAX;
> >  	lim->max_segments = BLK_MAX_SEGMENTS;
> >  	lim->max_discard_segments = 1;
> >  	lim->max_integrity_segments = 0;
> > @@ -100,6 +101,24 @@ void blk_queue_bounce_limit(struct request_queue *q, enum blk_bounce bounce)
> >  }
> >  EXPORT_SYMBOL(blk_queue_bounce_limit);
> >  
> > +/**
> > + * blk_queue_max_bio_bytes - set bio max size for queue
> 
> blk_queue_max_bio_bytes - set max_bio_bytes queue limit
> 
> And then you can drop the not very useful description.

OK. I'll.

> 
> > + * @q: the request queue for the device
> > + * @bytes : bio max bytes to be set
> > + *
> > + * Description:
> > + *    Set proper bio max size to optimize queue operating.
> > + **/
> > +void blk_queue_max_bio_bytes(struct request_queue *q, unsigned int bytes)
> > +{
> > +	struct queue_limits *limits = &q->limits;
> > +	unsigned int max_bio_bytes = round_up(bytes, PAGE_SIZE);
> > +
> > +	limits->max_bio_bytes = max_t(unsigned int, max_bio_bytes,
> > +				      BIO_MAX_VECS * PAGE_SIZE);
> > +}
> > +EXPORT_SYMBOL(blk_queue_max_bio_bytes);
> 
> Setting of the stacked limits is still missing.

max_bio_bytes for stacked device is just default(UINT_MAX) in this patch.
Because blk_set_stacking_limits() call blk_set_default_limits().
I'll work continue for stacked device after this patchowork.

> 
> > +
> >  /**
> >   * blk_queue_max_hw_sectors - set max sectors for a request for this queue
> >   * @q:  the request queue for the device
> > diff --git a/include/linux/bio.h b/include/linux/bio.h
> > index a0b4cfdf62a4..3959cc1a0652 100644
> > --- a/include/linux/bio.h
> > +++ b/include/linux/bio.h
> > @@ -106,6 +106,8 @@ static inline void *bio_data(struct bio *bio)
> >  	return NULL;
> >  }
> >  
> > +extern unsigned int bio_max_bytes(struct bio *bio);
> > +
> >  /**
> >   * bio_full - check if the bio is full
> >   * @bio:	bio to check
> > @@ -119,7 +121,7 @@ static inline bool bio_full(struct bio *bio, unsigned len)
> >  	if (bio->bi_vcnt >= bio->bi_max_vecs)
> >  		return true;
> >  
> > -	if (bio->bi_iter.bi_size > UINT_MAX - len)
> > +	if (bio->bi_iter.bi_size > bio_max_bytes(bio) - len)
> >  		return true;
> >  
> >  	return false;
> > diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> > index 1255823b2bc0..861888501fc0 100644
> > --- a/include/linux/blkdev.h
> > +++ b/include/linux/blkdev.h
> > @@ -326,6 +326,8 @@ enum blk_bounce {
> >  };
> >  
> >  struct queue_limits {
> > +	unsigned int		max_bio_bytes;
> > +
> >  	enum blk_bounce		bounce;
> >  	unsigned long		seg_boundary_mask;
> >  	unsigned long		virt_boundary_mask;
> > @@ -1132,6 +1134,7 @@ extern void blk_abort_request(struct request *);
> >   * Access functions for manipulating queue properties
> >   */
> >  extern void blk_cleanup_queue(struct request_queue *);
> > +extern void blk_queue_max_bio_bytes(struct request_queue *, unsigned int);
> >  void blk_queue_bounce_limit(struct request_queue *q, enum blk_bounce limit);
> >  extern void blk_queue_max_hw_sectors(struct request_queue *, unsigned int);
> >  extern void blk_queue_chunk_sectors(struct request_queue *, unsigned int);
> > 
> 
> 
> -- 
> Damien Le Moal
> Western Digital Research

Thank you,
Changheun Lee
