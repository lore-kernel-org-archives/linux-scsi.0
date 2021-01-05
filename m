Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A8AFC433DB
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Jan 2021 12:27:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DB5CB22AAA
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Jan 2021 12:27:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729561AbhAEM00 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 5 Jan 2021 07:26:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728711AbhAEMZt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Jan 2021 07:25:49 -0500
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 102C6C0617A2;
        Tue,  5 Jan 2021 04:24:35 -0800 (PST)
Received: by mail-ed1-x52e.google.com with SMTP id cw27so30862294edb.5;
        Tue, 05 Jan 2021 04:24:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=oWnBpIaY82msqcnyQYiIKgO5+f9glp4Gi0dKxJ4RwK8=;
        b=ANowqoXJgSNo5UWWYWTXj0AkI9yFcIVtdVw2tJa/HPraBBS1ku4Wz+qdLPTq1iROFz
         S8P0knYZ2pw9jLtJlawYKPsADF8Rox520lqk1BM2tufEM6pjhRKiB4v6kewFFfcbWb9N
         sGpjChjVAuWHbGonJDiCElN9HKt/0/zD6jls/gYJNOugsyzCLQQDQ2fGyhTsdcrCwiTd
         wFILC9W7CEIo/k97PrIR8Jqo2lkiE3tlPxE+NdZW1JNqTgif8Mfnyd4yRmhoLtHBRkTS
         uEzFkImeoebqVv/p08b5FA6iMo2njsHfQDZT/3hu801jlQ83Y5D1tsHB0VVg+DkfWUPN
         COHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=oWnBpIaY82msqcnyQYiIKgO5+f9glp4Gi0dKxJ4RwK8=;
        b=D+9fqkH/DX77LztrhFl1C0gjRRcepfmqf0fNGdCUGJVPYsR1Nnj+Yn+GIqyKqt2Z19
         hFqKAvndHbdGV34acCCc1kEERAazeW5pd9vknX1FOdsNHcKduJT78CFA13rtsI0ahJtK
         /d4wX34J2Cc8rimEfvgNIq40TZQfKEqXZgcxvPQE8gPOF3R+t5HTv1qJVloEKABhIm9K
         s/NSri0KzWCCfcYz9FkhW+/2m/L0ND08+9XQX/X77BnodqHoweMP3BhE83e6lseG6YwW
         vMnXf4zDpO4xbsI9NpFoe45Fbisw06NkGh5qTZ1tXBU9i4Qyd79CzzG0hZY1KAYyTpVl
         CpdQ==
X-Gm-Message-State: AOAM533LTc2pC2n3DTM8ERF/dN+Q/3CGo4SEpah+1vIwbIUPVKgoYp74
        E6kRwO9606n4HdtVOGSbL8nrpi0uRuKXHSw2RD8=
X-Google-Smtp-Source: ABdhPJzlfMXa/uJfyo6x1vwnHL5U1TYwo/iteVYd582wqTJH/wQbkw7/CKb+S5ZO5jgTWr+XfAseYwfkiqkiftHGCXg=
X-Received: by 2002:a50:cdc8:: with SMTP id h8mr76805726edj.293.1609849473437;
 Tue, 05 Jan 2021 04:24:33 -0800 (PST)
MIME-Version: 1.0
References: <20210104104159.74236-1-selvakuma.s1@samsung.com>
 <CGME20210104104249epcas5p458d1b5c39b5acfad4e7786eca5dd5c49@epcas5p4.samsung.com>
 <20210104104159.74236-3-selvakuma.s1@samsung.com> <BL0PR04MB651402CFA75F72826AC8EE1CE7D20@BL0PR04MB6514.namprd04.prod.outlook.com>
In-Reply-To: <BL0PR04MB651402CFA75F72826AC8EE1CE7D20@BL0PR04MB6514.namprd04.prod.outlook.com>
From:   Selva Jove <selvajove@gmail.com>
Date:   Tue, 5 Jan 2021 17:54:19 +0530
Message-ID: <CAHqX9vafJ9JwkT-oDJRfbLV0WKym-6FiTQqngcP1pk8J+zgbxQ@mail.gmail.com>
Subject: Re: [RFC PATCH v4 2/3] block: add simple copy support
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
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Thanks for the review, Damien.

On Mon, Jan 4, 2021 at 6:17 PM Damien Le Moal <Damien.LeMoal@wdc.com> wrote=
:
>
> On 2021/01/04 19:48, SelvaKumar S wrote:
> > Add new BLKCOPY ioctl that offloads copying of one or more sources
> > ranges to a destination in the device. Accepts copy_ranges that contain=
s
> > destination, no of sources and pointer to the array of source
> > ranges. Each range_entry contains start and length of source
> > ranges (in bytes).
> >
> > Introduce REQ_OP_COPY, a no-merge copy offload operation. Create
> > bio with control information as payload and submit to the device.
> > REQ_OP_COPY(19) is a write op and takes zone_write_lock when submitted
> > to zoned device.
> >
> > If the device doesn't support copy or copy offload is disabled, then
> > copy is emulated by allocating memory of total copy size. The source
> > ranges are read into memory by chaining bio for each source ranges and
> > submitting them async and the last bio waits for completion. After data
> > is read, it is written to the destination.
> >
> > bio_map_kern() is used to allocate bio and add pages of copy buffer to
> > bio. As bio->bi_private and bio->bi_end_io is needed for chaining the
> > bio and over written, invalidate_kernel_vmap_range() for read is called
> > in the caller.
> >
> > Introduce queue limits for simple copy and other helper functions.
> > Add device limits as sysfs entries.
> >       - copy_offload
> >       - max_copy_sectors
> >       - max_copy_ranges_sectors
> >       - max_copy_nr_ranges
> >
> > copy_offload(=3D 0) is disabled by default.
> > max_copy_sectors =3D 0 indicates the device doesn't support native copy=
.
> >
> > Native copy offload is not supported for stacked devices and is done vi=
a
> > copy emulation.
> >
> > Signed-off-by: SelvaKumar S <selvakuma.s1@samsung.com>
> > Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
> > Signed-off-by: Nitesh Shetty <nj.shetty@samsung.com>
> > Signed-off-by: Javier Gonz=C3=A1lez <javier.gonz@samsung.com>
> > ---
> >  block/blk-core.c          |  94 ++++++++++++++--
> >  block/blk-lib.c           | 223 ++++++++++++++++++++++++++++++++++++++
> >  block/blk-merge.c         |   2 +
> >  block/blk-settings.c      |  10 ++
> >  block/blk-sysfs.c         |  50 +++++++++
> >  block/blk-zoned.c         |   1 +
> >  block/bounce.c            |   1 +
> >  block/ioctl.c             |  43 ++++++++
> >  include/linux/bio.h       |   1 +
> >  include/linux/blk_types.h |  15 +++
> >  include/linux/blkdev.h    |  13 +++
> >  include/uapi/linux/fs.h   |  13 +++
> >  12 files changed, 458 insertions(+), 8 deletions(-)
> >
> > diff --git a/block/blk-core.c b/block/blk-core.c
> > index 96e5fcd7f071..4a5cd3f53cd2 100644
> > --- a/block/blk-core.c
> > +++ b/block/blk-core.c
> > @@ -719,6 +719,17 @@ static noinline int should_fail_bio(struct bio *bi=
o)
> >  }
> >  ALLOW_ERROR_INJECTION(should_fail_bio, ERRNO);
> >
> > +static inline int bio_check_copy_eod(struct bio *bio, sector_t start,
> > +             sector_t nr_sectors, sector_t maxsector)
> > +{
> > +     if (nr_sectors && maxsector &&
> > +         (nr_sectors > maxsector || start > maxsector - nr_sectors)) {
> > +             handle_bad_sector(bio, maxsector);
> > +             return -EIO;
> > +     }
> > +     return 0;
> > +}
> > +
> >  /*
> >   * Check whether this bio extends beyond the end of the device or part=
ition.
> >   * This may well happen - the kernel calls bread() without checking th=
e size of
> > @@ -737,6 +748,65 @@ static inline int bio_check_eod(struct bio *bio, s=
ector_t maxsector)
> >       return 0;
> >  }
> >
> > +/*
> > + * Check for copy limits and remap source ranges if needed.
> > + */
> > +static int blk_check_copy(struct bio *bio)
> > +{
> > +     struct block_device *p =3D NULL;
> > +     struct request_queue *q =3D bio->bi_disk->queue;
> > +     struct blk_copy_payload *payload;
> > +     int i, maxsector, start_sect =3D 0, ret =3D -EIO;
> > +     unsigned short nr_range;
> > +
> > +     rcu_read_lock();
> > +
> > +     p =3D __disk_get_part(bio->bi_disk, bio->bi_partno);
> > +     if (unlikely(!p))
> > +             goto out;
> > +     if (unlikely(should_fail_request(p, bio->bi_iter.bi_size)))
> > +             goto out;
> > +     if (unlikely(bio_check_ro(bio, p)))
> > +             goto out;
> > +
> > +     maxsector =3D  bdev_nr_sectors(p);
> > +     start_sect =3D p->bd_start_sect;
> > +
> > +     payload =3D bio_data(bio);
> > +     nr_range =3D payload->copy_range;
> > +
> > +     /* cannot handle copy crossing nr_ranges limit */
> > +     if (payload->copy_range > q->limits.max_copy_nr_ranges)
> > +             goto out;
>
> If payload->copy_range indicates the number of ranges to be copied, you s=
hould
> name it payload->copy_nr_ranges.
>

Agreed. Will rename the entries.

> > +
> > +     /* cannot handle copy more than copy limits */
>
> Why ? You could loop... Similarly to discard, zone reset etc.
>

Sure. Will add the support for handling copy larger than device limits.

>
> > +     if (payload->copy_size > q->limits.max_copy_sectors)
> > +             goto out;
>
> Shouldn't the list of source ranges give the total size to be copied ?
> Otherwise, if payload->copy_size is user provided, you would need to chec=
k that
> the sum of the source ranges actually is equal to copy_size, no ? That me=
ans
> that dropping copy_size sound like the right thing to do here.
>

payload->copy_size is used in copy emulation to allocate the buffer.
Let me check
one more time if it is possible to do without this.

> > +
> > +     /* check if copy length crosses eod */
> > +     if (unlikely(bio_check_copy_eod(bio, bio->bi_iter.bi_sector,
> > +                                     payload->copy_size, maxsector)))
> > +             goto out;
> > +     bio->bi_iter.bi_sector +=3D start_sect;
> > +
> > +     for (i =3D 0; i < nr_range; i++) {
> > +             if (unlikely(bio_check_copy_eod(bio, payload->range[i].sr=
c,
> > +                                     payload->range[i].len, maxsector)=
))
> > +                     goto out;
> > +
> > +             /* single source range length limit */
> > +             if (payload->range[i].src > q->limits.max_copy_range_sect=
ors)
> > +                     goto out;
> > +             payload->range[i].src +=3D start_sect;
> > +     }
> > +
> > +     bio->bi_partno =3D 0;
> > +     ret =3D 0;
> > +out:
> > +     rcu_read_unlock();
> > +     return ret;
> > +}
> > +
> >  /*
> >   * Remap block n of partition p to block n+start(p) of the disk.
> >   */
> > @@ -826,14 +896,16 @@ static noinline_for_stack bool submit_bio_checks(=
struct bio *bio)
> >       if (should_fail_bio(bio))
> >               goto end_io;
> >
> > -     if (bio->bi_partno) {
> > -             if (unlikely(blk_partition_remap(bio)))
> > -                     goto end_io;
> > -     } else {
> > -             if (unlikely(bio_check_ro(bio, bio->bi_disk->part0)))
> > -                     goto end_io;
> > -             if (unlikely(bio_check_eod(bio, get_capacity(bio->bi_disk=
))))
> > -                     goto end_io;
> > +     if (likely(!op_is_copy(bio->bi_opf))) {
> > +             if (bio->bi_partno) {
> > +                     if (unlikely(blk_partition_remap(bio)))
> > +                             goto end_io;
> > +             } else {
> > +                     if (unlikely(bio_check_ro(bio, bio->bi_disk->part=
0)))
> > +                             goto end_io;
> > +                     if (unlikely(bio_check_eod(bio, get_capacity(bio-=
>bi_disk))))
> > +                             goto end_io;
> > +             }
> >       }
> >
> >       /*
> > @@ -857,6 +929,12 @@ static noinline_for_stack bool submit_bio_checks(s=
truct bio *bio)
> >               if (!blk_queue_discard(q))
> >                       goto not_supported;
> >               break;
> > +     case REQ_OP_COPY:
> > +             if (!blk_queue_copy(q))
> > +                     goto not_supported;
>
> This check could be inside blk_check_copy(). In any case, since you added=
 the
> read-write emulation, why are you even checking this ? That will prevent =
the use
> of the read-write emulation for devices that lack the simple copy support=
, no ?
>

Makes sense. Will remove this check.

>
> > +             if (unlikely(blk_check_copy(bio)))
> > +                     goto end_io;
> > +             break;
> >       case REQ_OP_SECURE_ERASE:
> >               if (!blk_queue_secure_erase(q))
> >                       goto not_supported;
> > diff --git a/block/blk-lib.c b/block/blk-lib.c
> > index 752f9c722062..4c0f12e2ed7c 100644
> > --- a/block/blk-lib.c
> > +++ b/block/blk-lib.c
> > @@ -150,6 +150,229 @@ int blkdev_issue_discard(struct block_device *bde=
v, sector_t sector,
> >  }
> >  EXPORT_SYMBOL(blkdev_issue_discard);
> >
> > +int blk_copy_offload(struct block_device *bdev, struct blk_copy_payloa=
d *payload,
> > +             sector_t dest, gfp_t gfp_mask)
> > +{
> > +     struct bio *bio;
> > +     int ret, total_size;
> > +
> > +     bio =3D bio_alloc(gfp_mask, 1);
> > +     bio->bi_iter.bi_sector =3D dest;
> > +     bio->bi_opf =3D REQ_OP_COPY | REQ_NOMERGE;
> > +     bio_set_dev(bio, bdev);
> > +
> > +     total_size =3D struct_size(payload, range, payload->copy_range);
> > +     ret =3D bio_add_page(bio, virt_to_page(payload), total_size,
>
> How is payload allocated ? If it is a structure on-stack in the caller, I=
 am not
> sure it would be wise to do an IO using the thread stack page...
>
> > +                                        offset_in_page(payload));
> > +     if (ret !=3D total_size) {
> > +             ret =3D -ENOMEM;
> > +             bio_put(bio);
> > +             goto err;
> > +     }
> > +
> > +     ret =3D submit_bio_wait(bio);
> > +err:
> > +     bio_put(bio);
> > +     return ret;
> > +
> > +}
> > +
> > +int blk_read_to_buf(struct block_device *bdev, struct blk_copy_payload=
 *payload,
> > +             gfp_t gfp_mask, void **buf_p)
> > +{
> > +     struct request_queue *q =3D bdev_get_queue(bdev);
> > +     struct bio *bio, *parent =3D NULL;
> > +     void *buf =3D NULL;
> > +     bool is_vmalloc;
> > +     int i, nr_srcs, copy_len, ret, cur_size, t_len =3D 0;
> > +
> > +     nr_srcs =3D payload->copy_range;
> > +     copy_len =3D payload->copy_size << SECTOR_SHIFT;
> > +
> > +     buf =3D kvmalloc(copy_len, gfp_mask);
> > +     if (!buf)
> > +             return -ENOMEM;
> > +     is_vmalloc =3D is_vmalloc_addr(buf);
> > +
> > +     for (i =3D 0; i < nr_srcs; i++) {
> > +             cur_size =3D payload->range[i].len << SECTOR_SHIFT;
> > +
> > +             bio =3D bio_map_kern(q, buf + t_len, cur_size, gfp_mask);
> > +             if (IS_ERR(bio)) {
> > +                     ret =3D PTR_ERR(bio);
> > +                     goto out;
> > +             }
> > +
> > +             bio->bi_iter.bi_sector =3D payload->range[i].src;
> > +             bio->bi_opf =3D REQ_OP_READ;
> > +             bio_set_dev(bio, bdev);
> > +             bio->bi_end_io =3D NULL;
> > +             bio->bi_private =3D NULL;
> > +
> > +             if (parent) {
> > +                     bio_chain(parent, bio);
> > +                     submit_bio(parent);
> > +             }
> > +
> > +             parent =3D bio;
> > +             t_len +=3D cur_size;
> > +     }
> > +
> > +     ret =3D submit_bio_wait(bio);
> > +     bio_put(bio);
> > +     if (is_vmalloc)
> > +             invalidate_kernel_vmap_range(buf, copy_len);
> > +     if (ret)
> > +             goto out;
> > +
> > +     *buf_p =3D buf;
> > +     return 0;
> > +out:
> > +     kvfree(buf);
> > +     return ret;
> > +}
> > +
> > +int blk_write_from_buf(struct block_device *bdev, void *buf, sector_t =
dest,
> > +             int copy_len, gfp_t gfp_mask)
> > +{
> > +     struct request_queue *q =3D bdev_get_queue(bdev);
> > +     struct bio *bio;
> > +     int ret;
> > +
> > +     bio =3D bio_map_kern(q, buf, copy_len, gfp_mask);
> > +     if (IS_ERR(bio)) {
> > +             ret =3D PTR_ERR(bio);
> > +             goto out;
> > +     }
> > +     bio_set_dev(bio, bdev);
> > +     bio->bi_opf =3D REQ_OP_WRITE;
> > +     bio->bi_iter.bi_sector =3D dest;
> > +
> > +     bio->bi_end_io =3D NULL;
> > +     ret =3D submit_bio_wait(bio);
> > +     bio_put(bio);
> > +out:
> > +     return ret;
> > +}
> > +
> > +int blk_prepare_payload(struct block_device *bdev, int nr_srcs, struct=
 range_entry *rlist,
> > +             gfp_t gfp_mask, struct blk_copy_payload **payload_p)
> > +{
> > +
> > +     struct request_queue *q =3D bdev_get_queue(bdev);
> > +     struct blk_copy_payload *payload;
> > +     sector_t bs_mask;
> > +     sector_t src_sects, len =3D 0, total_len =3D 0;
> > +     int i, ret, total_size;
> > +
> > +     if (!q)
> > +             return -ENXIO;
> > +
> > +     if (!nr_srcs)
> > +             return -EINVAL;
> > +
> > +     if (bdev_read_only(bdev))
> > +             return -EPERM;
> > +
> > +     bs_mask =3D (bdev_logical_block_size(bdev) >> 9) - 1;
> > +
> > +     total_size =3D struct_size(payload, range, nr_srcs);
> > +     payload =3D kmalloc(total_size, gfp_mask);
> > +     if (!payload)
> > +             return -ENOMEM;
>
> OK. So this is what goes into the bio. The function blk_copy_offload() as=
sumes
> this is at most one page, so total_size <=3D PAGE_SIZE. Where is that che=
cked ?
>

CMIIW. As payload was allocated via kmalloc, it would be represented by a s=
ingle
contiguous segment. In case it crosses one page, rely on multi-page bio_vec=
 to
cover it.

> > +
> > +     for (i =3D 0; i < nr_srcs; i++) {
> > +             /*  copy payload provided are in bytes */
> > +             src_sects =3D rlist[i].src;
> > +             if (src_sects & bs_mask) {
> > +                     ret =3D  -EINVAL;
> > +                     goto err;
> > +             }
> > +             src_sects =3D src_sects >> SECTOR_SHIFT;
> > +
> > +             if (len & bs_mask) {
> > +                     ret =3D -EINVAL;
> > +                     goto err;
> > +             }
> > +
> > +             len =3D rlist[i].len >> SECTOR_SHIFT;
> > +
> > +             total_len +=3D len;
> > +
> > +             WARN_ON_ONCE((src_sects << 9) > UINT_MAX);
> > +
> > +             payload->range[i].src =3D src_sects;
> > +             payload->range[i].len =3D len;
> > +     }
> > +
> > +     /* storing # of source ranges */
> > +     payload->copy_range =3D i;
> > +     /* storing copy len so far */
> > +     payload->copy_size =3D total_len;
>
> The comments here make the code ugly. Rename the variables and structure =
fields
> to have something self explanatory.
>

Agreed.

> > +
> > +     *payload_p =3D payload;
> > +     return 0;
> > +err:
> > +     kfree(payload);
> > +     return ret;
> > +}
> > +
> > +/**
> > + * blkdev_issue_copy - queue a copy
> > + * @bdev:       source block device
> > + * @nr_srcs: number of source ranges to copy
> > + * @rlist:   array of source ranges (in bytes)
> > + * @dest_bdev:       destination block device
> > + * @dest:    destination (in bytes)
> > + * @gfp_mask:   memory allocation flags (for bio_alloc)
> > + *
> > + * Description:
> > + *   Copy array of source ranges from source block device to
> > + *   destination block devcie.
> > + */
> > +
> > +
> > +int blkdev_issue_copy(struct block_device *bdev, int nr_srcs,
> > +             struct range_entry *src_rlist, struct block_device *dest_=
bdev,
> > +             sector_t dest, gfp_t gfp_mask)
> > +{
> > +     struct request_queue *q =3D bdev_get_queue(bdev);
> > +     struct blk_copy_payload *payload;
> > +     sector_t bs_mask, dest_sect;
> > +     void *buf =3D NULL;
> > +     int ret;
> > +
> > +     ret =3D blk_prepare_payload(bdev, nr_srcs, src_rlist, gfp_mask, &=
payload);
> > +     if (ret)
> > +             return ret;
> > +
> > +     bs_mask =3D (bdev_logical_block_size(dest_bdev) >> 9) - 1;
> > +     if (dest & bs_mask) {
> > +             return -EINVAL;
> > +             goto out;
> > +     }
> > +     dest_sect =3D dest >> SECTOR_SHIFT;
>
> dest should already be a 512B sector as all block layer functions interfa=
ce use
> this unit. What is this doing ?
>

As source ranges and length received were in bytes, to keep things
same, dest was
also chosen to be in bytes. Seems wrong. Will change it to the 512B sector.

>
> > +
> > +     if (bdev =3D=3D dest_bdev && q->limits.copy_offload) {
> > +             ret =3D blk_copy_offload(bdev, payload, dest_sect, gfp_ma=
sk);
> > +             if (ret)
> > +                     goto out;
> > +     } else {
> > +             ret =3D blk_read_to_buf(bdev, payload, gfp_mask, &buf);
> > +             if (ret)
> > +                     goto out;
> > +             ret =3D blk_write_from_buf(dest_bdev, buf, dest_sect,
> > +                             payload->copy_size << SECTOR_SHIFT, gfp_m=
ask);
>
> Arg... This is really not pretty. At the very least, this should all be i=
n a
> blk_copy_emulate() helper or something named like that.
>

Okay. Will move this to a helper.

> My worry though is that this likely slow for large copies, not to mention=
 that
> buf is likely to fail to allocate for large copy cases. As commented prev=
iously,
> dm-kcopyd already does such copy well, with a read-write streaming pipeli=
ne and
> zone support too for the write side. This should really be reused, at lea=
st
> partly, instead of re-implementing this read-write here.
>

I was a bit hesitant to use dm layer code in the block layer. It makes sens=
e to
reuse the code as much as possible. Will try to reuse dm-kcopyd code for co=
py
emulation part.

>
> > +     }
> > +
> > +     if (buf)
> > +             kvfree(buf);
> > +out:
> > +     kvfree(payload);
> > +     return ret;
> > +}
> > +EXPORT_SYMBOL(blkdev_issue_copy);
> > +
> >  /**
> >   * __blkdev_issue_write_same - generate number of bios with same page
> >   * @bdev:    target blockdev
> > diff --git a/block/blk-merge.c b/block/blk-merge.c
> > index 808768f6b174..4e04f24e13c1 100644
> > --- a/block/blk-merge.c
> > +++ b/block/blk-merge.c
> > @@ -309,6 +309,8 @@ void __blk_queue_split(struct bio **bio, unsigned i=
nt *nr_segs)
> >       struct bio *split =3D NULL;
> >
> >       switch (bio_op(*bio)) {
> > +     case REQ_OP_COPY:
> > +                     break;
> >       case REQ_OP_DISCARD:
> >       case REQ_OP_SECURE_ERASE:
> >               split =3D blk_bio_discard_split(q, *bio, &q->bio_split, n=
r_segs);
> > diff --git a/block/blk-settings.c b/block/blk-settings.c
> > index 43990b1d148b..93c15ba45a69 100644
> > --- a/block/blk-settings.c
> > +++ b/block/blk-settings.c
> > @@ -60,6 +60,10 @@ void blk_set_default_limits(struct queue_limits *lim=
)
> >       lim->io_opt =3D 0;
> >       lim->misaligned =3D 0;
> >       lim->zoned =3D BLK_ZONED_NONE;
> > +     lim->copy_offload =3D 0;
> > +     lim->max_copy_sectors =3D 0;
> > +     lim->max_copy_nr_ranges =3D 0;
> > +     lim->max_copy_range_sectors =3D 0;
> >  }
> >  EXPORT_SYMBOL(blk_set_default_limits);
> >
> > @@ -565,6 +569,12 @@ int blk_stack_limits(struct queue_limits *t, struc=
t queue_limits *b,
> >       if (b->chunk_sectors)
> >               t->chunk_sectors =3D gcd(t->chunk_sectors, b->chunk_secto=
rs);
> >
> > +     /* simple copy not supported in stacked devices */
> > +     t->copy_offload =3D 0;
> > +     t->max_copy_sectors =3D 0;
> > +     t->max_copy_range_sectors =3D 0;
> > +     t->max_copy_nr_ranges =3D 0;
> > +
> >       /* Physical block size a multiple of the logical block size? */
> >       if (t->physical_block_size & (t->logical_block_size - 1)) {
> >               t->physical_block_size =3D t->logical_block_size;
> > diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
> > index b513f1683af0..51b35a8311d9 100644
> > --- a/block/blk-sysfs.c
> > +++ b/block/blk-sysfs.c
> > @@ -166,6 +166,47 @@ static ssize_t queue_discard_granularity_show(stru=
ct request_queue *q, char *pag
> >       return queue_var_show(q->limits.discard_granularity, page);
> >  }
> >
> > +static ssize_t queue_copy_offload_show(struct request_queue *q, char *=
page)
> > +{
> > +     return queue_var_show(q->limits.copy_offload, page);
> > +}
> > +
> > +static ssize_t queue_copy_offload_store(struct request_queue *q,
> > +                                    const char *page, size_t count)
> > +{
> > +     unsigned long copy_offload;
> > +     ssize_t ret =3D queue_var_store(&copy_offload, page, count);
> > +
> > +     if (ret < 0)
> > +             return ret;
> > +
> > +     if (copy_offload < 0 || copy_offload > 1)
>
> err... "copy_offload !=3D 1" ?

Initial thought was to keep it either 0 or 1.  I'll change it to 0 or else.

>
> > +             return -EINVAL;
> > +
> > +     if (q->limits.max_copy_sectors =3D=3D 0 && copy_offload =3D=3D 1)
> > +             return -EINVAL;
> > +
> > +     q->limits.copy_offload =3D copy_offload;
> > +     return ret;
> > +}
> > +
> > +static ssize_t queue_max_copy_sectors_show(struct request_queue *q, ch=
ar *page)
> > +{
> > +     return queue_var_show(q->limits.max_copy_sectors, page);
> > +}
> > +
> > +static ssize_t queue_max_copy_range_sectors_show(struct request_queue =
*q,
> > +             char *page)
> > +{
> > +     return queue_var_show(q->limits.max_copy_range_sectors, page);
> > +}
> > +
> > +static ssize_t queue_max_copy_nr_ranges_show(struct request_queue *q,
> > +             char *page)
> > +{
> > +     return queue_var_show(q->limits.max_copy_nr_ranges, page);
> > +}
> > +
> >  static ssize_t queue_discard_max_hw_show(struct request_queue *q, char=
 *page)
> >  {
> >
> > @@ -591,6 +632,11 @@ QUEUE_RO_ENTRY(queue_nr_zones, "nr_zones");
> >  QUEUE_RO_ENTRY(queue_max_open_zones, "max_open_zones");
> >  QUEUE_RO_ENTRY(queue_max_active_zones, "max_active_zones");
> >
> > +QUEUE_RW_ENTRY(queue_copy_offload, "copy_offload");
> > +QUEUE_RO_ENTRY(queue_max_copy_sectors, "max_copy_sectors");
> > +QUEUE_RO_ENTRY(queue_max_copy_range_sectors, "max_copy_range_sectors")=
;
> > +QUEUE_RO_ENTRY(queue_max_copy_nr_ranges, "max_copy_nr_ranges");
> > +
> >  QUEUE_RW_ENTRY(queue_nomerges, "nomerges");
> >  QUEUE_RW_ENTRY(queue_rq_affinity, "rq_affinity");
> >  QUEUE_RW_ENTRY(queue_poll, "io_poll");
> > @@ -636,6 +682,10 @@ static struct attribute *queue_attrs[] =3D {
> >       &queue_discard_max_entry.attr,
> >       &queue_discard_max_hw_entry.attr,
> >       &queue_discard_zeroes_data_entry.attr,
> > +     &queue_copy_offload_entry.attr,
> > +     &queue_max_copy_sectors_entry.attr,
> > +     &queue_max_copy_range_sectors_entry.attr,
> > +     &queue_max_copy_nr_ranges_entry.attr,
> >       &queue_write_same_max_entry.attr,
> >       &queue_write_zeroes_max_entry.attr,
> >       &queue_zone_append_max_entry.attr,
> > diff --git a/block/blk-zoned.c b/block/blk-zoned.c
> > index 7a68b6e4300c..02069178d51e 100644
> > --- a/block/blk-zoned.c
> > +++ b/block/blk-zoned.c
> > @@ -75,6 +75,7 @@ bool blk_req_needs_zone_write_lock(struct request *rq=
)
> >       case REQ_OP_WRITE_ZEROES:
> >       case REQ_OP_WRITE_SAME:
> >       case REQ_OP_WRITE:
> > +     case REQ_OP_COPY:
> >               return blk_rq_zone_is_seq(rq);
> >       default:
> >               return false;
> > diff --git a/block/bounce.c b/block/bounce.c
> > index d3f51acd6e3b..5e052afe8691 100644
> > --- a/block/bounce.c
> > +++ b/block/bounce.c
> > @@ -254,6 +254,7 @@ static struct bio *bounce_clone_bio(struct bio *bio=
_src, gfp_t gfp_mask,
> >       bio->bi_iter.bi_size    =3D bio_src->bi_iter.bi_size;
> >
> >       switch (bio_op(bio)) {
> > +     case REQ_OP_COPY:
> >       case REQ_OP_DISCARD:
> >       case REQ_OP_SECURE_ERASE:
> >       case REQ_OP_WRITE_ZEROES:
> > diff --git a/block/ioctl.c b/block/ioctl.c
> > index d61d652078f4..d50b6abe2883 100644
> > --- a/block/ioctl.c
> > +++ b/block/ioctl.c
> > @@ -133,6 +133,47 @@ static int blk_ioctl_discard(struct block_device *=
bdev, fmode_t mode,
> >                                   GFP_KERNEL, flags);
> >  }
> >
> > +static int blk_ioctl_copy(struct block_device *bdev, fmode_t mode,
> > +             unsigned long arg)
> > +{
> > +     struct copy_range crange;
> > +     struct range_entry *rlist;
> > +     struct request_queue *q =3D bdev_get_queue(bdev);
> > +     sector_t dest;
> > +     int ret;
> > +
> > +     if (!(mode & FMODE_WRITE))
> > +             return -EBADF;
> > +
> > +     if (!blk_queue_copy(q))
> > +             return -EOPNOTSUPP;
>
> But you added the read-write emulation. So what is the point here ? This =
ioctl
> should work for any device, with or without simple copy support. Did you =
test that ?
>

Sorry. It was a mistake. Will fix this.

> > +
> > +     if (copy_from_user(&crange, (void __user *)arg, sizeof(crange)))
> > +             return -EFAULT;
> > +
> > +     if (crange.dest & ((1 << SECTOR_SHIFT) - 1))
> > +             return -EFAULT;
> > +     dest =3D crange.dest;
> > +
> > +     rlist =3D kmalloc_array(crange.nr_range, sizeof(*rlist),
> > +                     GFP_KERNEL);
> > +
>
> Unnecessary blank line here.
>
> > +     if (!rlist)
> > +             return -ENOMEM;
> > +
> > +     if (copy_from_user(rlist, (void __user *)crange.range_list,
> > +                             sizeof(*rlist) * crange.nr_range)) {
> > +             ret =3D -EFAULT;
> > +             goto out;
> > +     }
> > +
> > +     ret =3D blkdev_issue_copy(bdev, crange.nr_range, rlist, bdev, des=
t,
> > +                     GFP_KERNEL);
> > +out:
> > +     kfree(rlist);
> > +     return ret;
> > +}
> > +
> >  static int blk_ioctl_zeroout(struct block_device *bdev, fmode_t mode,
> >               unsigned long arg)
> >  {
> > @@ -458,6 +499,8 @@ static int blkdev_common_ioctl(struct block_device =
*bdev, fmode_t mode,
> >       case BLKSECDISCARD:
> >               return blk_ioctl_discard(bdev, mode, arg,
> >                               BLKDEV_DISCARD_SECURE);
> > +     case BLKCOPY:
> > +             return blk_ioctl_copy(bdev, mode, arg);
> >       case BLKZEROOUT:
> >               return blk_ioctl_zeroout(bdev, mode, arg);
> >       case BLKREPORTZONE:
> > diff --git a/include/linux/bio.h b/include/linux/bio.h
> > index 1edda614f7ce..164313bdfb35 100644
> > --- a/include/linux/bio.h
> > +++ b/include/linux/bio.h
> > @@ -71,6 +71,7 @@ static inline bool bio_has_data(struct bio *bio)
> >  static inline bool bio_no_advance_iter(const struct bio *bio)
> >  {
> >       return bio_op(bio) =3D=3D REQ_OP_DISCARD ||
> > +            bio_op(bio) =3D=3D REQ_OP_COPY ||
> >              bio_op(bio) =3D=3D REQ_OP_SECURE_ERASE ||
> >              bio_op(bio) =3D=3D REQ_OP_WRITE_SAME ||
> >              bio_op(bio) =3D=3D REQ_OP_WRITE_ZEROES;
> > diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
> > index 866f74261b3b..d4d11e9ff814 100644
> > --- a/include/linux/blk_types.h
> > +++ b/include/linux/blk_types.h
> > @@ -380,6 +380,8 @@ enum req_opf {
> >       REQ_OP_ZONE_RESET       =3D 15,
> >       /* reset all the zone present on the device */
> >       REQ_OP_ZONE_RESET_ALL   =3D 17,
> > +     /* copy ranges within device */
> > +     REQ_OP_COPY             =3D 19,
> >
> >       /* SCSI passthrough using struct scsi_request */
> >       REQ_OP_SCSI_IN          =3D 32,
> > @@ -506,6 +508,11 @@ static inline bool op_is_discard(unsigned int op)
> >       return (op & REQ_OP_MASK) =3D=3D REQ_OP_DISCARD;
> >  }
> >
> > +static inline bool op_is_copy(unsigned int op)
> > +{
> > +     return (op & REQ_OP_MASK) =3D=3D REQ_OP_COPY;
> > +}
> > +
> >  /*
> >   * Check if a bio or request operation is a zone management operation,=
 with
> >   * the exception of REQ_OP_ZONE_RESET_ALL which is treated as a specia=
l case
> > @@ -565,4 +572,12 @@ struct blk_rq_stat {
> >       u64 batch;
> >  };
> >
> > +struct blk_copy_payload {
> > +     sector_t        dest;
> > +     int             copy_range;
> > +     int             copy_size;
> > +     int             err;
> > +     struct  range_entry     range[];
> > +};
> > +
> >  #endif /* __LINUX_BLK_TYPES_H */
> > diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> > index 81f9e7bec16c..4c7e861e57e4 100644
> > --- a/include/linux/blkdev.h
> > +++ b/include/linux/blkdev.h
> > @@ -340,10 +340,14 @@ struct queue_limits {
> >       unsigned int            max_zone_append_sectors;
> >       unsigned int            discard_granularity;
> >       unsigned int            discard_alignment;
> > +     unsigned int            copy_offload;
> > +     unsigned int            max_copy_sectors;
> >
> >       unsigned short          max_segments;
> >       unsigned short          max_integrity_segments;
> >       unsigned short          max_discard_segments;
> > +     unsigned short          max_copy_range_sectors;
> > +     unsigned short          max_copy_nr_ranges;
> >
> >       unsigned char           misaligned;
> >       unsigned char           discard_misaligned;
> > @@ -625,6 +629,7 @@ struct request_queue {
> >  #define QUEUE_FLAG_RQ_ALLOC_TIME 27  /* record rq->alloc_time_ns */
> >  #define QUEUE_FLAG_HCTX_ACTIVE       28      /* at least one blk-mq hc=
tx is active */
> >  #define QUEUE_FLAG_NOWAIT       29   /* device supports NOWAIT */
> > +#define QUEUE_FLAG_COPY              30      /* supports copy */
>
> I think this should be called QUEUE_FLAG_SIMPLE_COPY to indicate more pre=
cisely
> the type of copy supported. SCSI XCOPY is more advanced...
>

Agreed.

> >
> >  #define QUEUE_FLAG_MQ_DEFAULT        ((1 << QUEUE_FLAG_IO_STAT) |     =
       \
> >                                (1 << QUEUE_FLAG_SAME_COMP) |          \
> > @@ -647,6 +652,7 @@ bool blk_queue_flag_test_and_set(unsigned int flag,=
 struct request_queue *q);
> >  #define blk_queue_io_stat(q) test_bit(QUEUE_FLAG_IO_STAT, &(q)->queue_=
flags)
> >  #define blk_queue_add_random(q)      test_bit(QUEUE_FLAG_ADD_RANDOM, &=
(q)->queue_flags)
> >  #define blk_queue_discard(q) test_bit(QUEUE_FLAG_DISCARD, &(q)->queue_=
flags)
> > +#define blk_queue_copy(q)    test_bit(QUEUE_FLAG_COPY, &(q)->queue_fla=
gs)
> >  #define blk_queue_zone_resetall(q)   \
> >       test_bit(QUEUE_FLAG_ZONE_RESETALL, &(q)->queue_flags)
> >  #define blk_queue_secure_erase(q) \
> > @@ -1061,6 +1067,9 @@ static inline unsigned int blk_queue_get_max_sect=
ors(struct request_queue *q,
> >               return min(q->limits.max_discard_sectors,
> >                          UINT_MAX >> SECTOR_SHIFT);
> >
> > +     if (unlikely(op =3D=3D REQ_OP_COPY))
> > +             return q->limits.max_copy_sectors;
> > +
> >       if (unlikely(op =3D=3D REQ_OP_WRITE_SAME))
> >               return q->limits.max_write_same_sectors;
> >
> > @@ -1335,6 +1344,10 @@ extern int __blkdev_issue_discard(struct block_d=
evice *bdev, sector_t sector,
> >               sector_t nr_sects, gfp_t gfp_mask, int flags,
> >               struct bio **biop);
> >
> > +extern int blkdev_issue_copy(struct block_device *bdev, int nr_srcs,
> > +             struct range_entry *src_rlist, struct block_device *dest_=
bdev,
> > +             sector_t dest, gfp_t gfp_mask);
> > +
> >  #define BLKDEV_ZERO_NOUNMAP  (1 << 0)  /* do not free blocks */
> >  #define BLKDEV_ZERO_NOFALLBACK       (1 << 1)  /* don't write explicit=
 zeroes */
> >
> > diff --git a/include/uapi/linux/fs.h b/include/uapi/linux/fs.h
> > index f44eb0a04afd..5cadb176317a 100644
> > --- a/include/uapi/linux/fs.h
> > +++ b/include/uapi/linux/fs.h
> > @@ -64,6 +64,18 @@ struct fstrim_range {
> >       __u64 minlen;
> >  };
> >
> > +struct range_entry {
> > +     __u64 src;
> > +     __u64 len;
> > +};
> > +
> > +struct copy_range {
> > +     __u64 dest;
> > +     __u64 nr_range;
> > +     __u64 range_list;
> > +     __u64 rsvd;
> > +};
> > +
> >  /* extent-same (dedupe) ioctls; these MUST match the btrfs ioctl defin=
itions */
> >  #define FILE_DEDUPE_RANGE_SAME               0
> >  #define FILE_DEDUPE_RANGE_DIFFERS    1
> > @@ -184,6 +196,7 @@ struct fsxattr {
> >  #define BLKSECDISCARD _IO(0x12,125)
> >  #define BLKROTATIONAL _IO(0x12,126)
> >  #define BLKZEROOUT _IO(0x12,127)
> > +#define BLKCOPY _IOWR(0x12, 128, struct copy_range)
> >  /*
> >   * A jump here: 130-131 are reserved for zoned block devices
> >   * (see uapi/linux/blkzoned.h)
> >
>
>
> --
> Damien Le Moal
> Western Digital Research

Thanks,
Selva
