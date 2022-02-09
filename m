Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E1BCC433FE
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Feb 2022 10:22:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234666AbiBIKWV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Feb 2022 05:22:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234616AbiBIKWU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Feb 2022 05:22:20 -0500
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 154DCE08F631
        for <linux-scsi@vger.kernel.org>; Wed,  9 Feb 2022 02:16:33 -0800 (PST)
Received: by mail-ed1-x52c.google.com with SMTP id da4so4030977edb.4
        for <linux-scsi@vger.kernel.org>; Wed, 09 Feb 2022 02:16:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=rAKZIFdP28Fau+cOOS9z/0N05/8YiKE8+fxfg8uPyQs=;
        b=YWFqKgZ5ycvsDpd3Js/maaKkL2iEOs7pq1F8qJxkGIxo554G77WEA3/MnBXGdZJ6cn
         S2zOBOKx2p0k6E6nCOGXvUgDHDjckUkdsO4MClCKJRSd3vUEvBl9BHCq4d2KVMB0z23Z
         IYoRQl6Lk58wTLjKRX4ZrVQDstZv2FRuv/uE8mIqPKq99yhwX2LqDrlnQeID6q2GFd1t
         ZgeDSV93cGgQ7/h+xJiGltXLWpkmouQSRZbU1/qqhYmJtIgsKdWYhOA3i7ZoJHPWk4xD
         2xq5lbDdRmAT1Sll/JVr7RWWPBhG/RiI1a3mymQOP2l96/ar+llCZ8IUt2uMw5fBIecl
         b0Ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=rAKZIFdP28Fau+cOOS9z/0N05/8YiKE8+fxfg8uPyQs=;
        b=CXTBymQTz7VTGKh191r1Ho+AOwsJjd0/G3tfCigjcNfbZFHFCaP4XFnwxDdnIHKB8e
         oVr7oXzeHTFrEhRIz5EBGxdeS/pp4xZaxvtMJnuuCybFqSr1uKX/BuAFjbvyhcczZ6Ak
         qKXsKso9UaxIDSDZE3n8j7EAN7Z0M02BOz/4EjGM5kAxEQC9Ipz8i9rGBDDEUs7HKN3H
         eqrsKDJR+52Qb04HOOB3n0AqLNMll6VfynMakxzTDQRF6swRRXob6jk1LMBdwsE7Pw3E
         LmvJUybWzssE554BfxDUVJhefaK3sZyozsYSqCVrSSieElaxdSeWYNQ8Q75hMQ7N/rdo
         GSQg==
X-Gm-Message-State: AOAM532UOc3WEWRFEfzeTGDzU2uq2WEcwJD+7m0IeH5g7OqkphdnkDib
        o1ePWIyS3cglgcP9ef1gdfNo+WtRn9ATSFBELMQHFQ==
X-Google-Smtp-Source: ABdhPJyJl1H6BhQtX6vwv0TWGp6atpb+7BMBNRgisc9vY7m9y/rdk2zMRqBceAy/KYQ8UAkhYC65Cf47LU0RO5V0mS4=
X-Received: by 2002:a05:6402:2916:: with SMTP id ee22mr1661883edb.3.1644401784309;
 Wed, 09 Feb 2022 02:16:24 -0800 (PST)
MIME-Version: 1.0
References: <20220209082828.2629273-1-hch@lst.de> <20220209082828.2629273-4-hch@lst.de>
In-Reply-To: <20220209082828.2629273-4-hch@lst.de>
From:   Jinpu Wang <jinpu.wang@ionos.com>
Date:   Wed, 9 Feb 2022 11:16:13 +0100
Message-ID: <CAMGffE=GMYNsw+mDt1h-BDh3JXkdrP9v2AUF7z0xE7jkumM+RQ@mail.gmail.com>
Subject: Re: [PATCH 3/7] rnbd: drop WRITE_SAME support
To:     Christoph Hellwig <hch@lst.de>
Cc:     axboe@kernel.dk, martin.petersen@oracle.com,
        philipp.reisner@linbit.com, lars.ellenberg@linbit.com,
        target-devel@vger.kernel.org, haris.iqbal@ionos.com,
        manoj@linux.ibm.com, mrochs@linux.ibm.com, ukrishn@linux.ibm.com,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        drbd-dev@lists.linbit.com, dm-devel@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Christoph,


On Wed, Feb 9, 2022 at 9:28 AM Christoph Hellwig <hch@lst.de> wrote:
>
> REQ_OP_WRITE_SAME was only ever submitted by the legacy Linux zeroing
> code, which has switched to use REQ_OP_WRITE_ZEROES long before rnbd was
> even merged.

Do you think if it makes sense to instead of removing
REQ_OP_WRITE_SAME, simply convert it to REQ_OP_WRITE_ZEROES?

Thanks!
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/block/rnbd/rnbd-clt.c   | 7 ++-----
>  drivers/block/rnbd/rnbd-clt.h   | 1 -
>  drivers/block/rnbd/rnbd-proto.h | 6 ------
>  drivers/block/rnbd/rnbd-srv.c   | 3 +--
>  4 files changed, 3 insertions(+), 14 deletions(-)
>
> diff --git a/drivers/block/rnbd/rnbd-clt.c b/drivers/block/rnbd/rnbd-clt.=
c
> index c08971de369fc..dc192d2738854 100644
> --- a/drivers/block/rnbd/rnbd-clt.c
> +++ b/drivers/block/rnbd/rnbd-clt.c
> @@ -82,7 +82,6 @@ static int rnbd_clt_set_dev_attr(struct rnbd_clt_dev *d=
ev,
>         dev->nsectors               =3D le64_to_cpu(rsp->nsectors);
>         dev->logical_block_size     =3D le16_to_cpu(rsp->logical_block_si=
ze);
>         dev->physical_block_size    =3D le16_to_cpu(rsp->physical_block_s=
ize);
> -       dev->max_write_same_sectors =3D le32_to_cpu(rsp->max_write_same_s=
ectors);
>         dev->max_discard_sectors    =3D le32_to_cpu(rsp->max_discard_sect=
ors);
>         dev->discard_granularity    =3D le32_to_cpu(rsp->discard_granular=
ity);
>         dev->discard_alignment      =3D le32_to_cpu(rsp->discard_alignmen=
t);
> @@ -1359,8 +1358,6 @@ static void setup_request_queue(struct rnbd_clt_dev=
 *dev)
>         blk_queue_logical_block_size(dev->queue, dev->logical_block_size)=
;
>         blk_queue_physical_block_size(dev->queue, dev->physical_block_siz=
e);
>         blk_queue_max_hw_sectors(dev->queue, dev->max_hw_sectors);
> -       blk_queue_max_write_same_sectors(dev->queue,
> -                                        dev->max_write_same_sectors);
>
>         /*
>          * we don't support discards to "discontiguous" segments
> @@ -1610,10 +1607,10 @@ struct rnbd_clt_dev *rnbd_clt_map_device(const ch=
ar *sessname,
>         }
>
>         rnbd_clt_info(dev,
> -                      "map_device: Device mapped as %s (nsectors: %zu, l=
ogical_block_size: %d, physical_block_size: %d, max_write_same_sectors: %d,=
 max_discard_sectors: %d, discard_granularity: %d, discard_alignment: %d, s=
ecure_discard: %d, max_segments: %d, max_hw_sectors: %d, rotational: %d, wc=
: %d, fua: %d)\n",
> +                      "map_device: Device mapped as %s (nsectors: %zu, l=
ogical_block_size: %d, physical_block_size: %d, max_discard_sectors: %d, di=
scard_granularity: %d, discard_alignment: %d, secure_discard: %d, max_segme=
nts: %d, max_hw_sectors: %d, rotational: %d, wc: %d, fua: %d)\n",
>                        dev->gd->disk_name, dev->nsectors,
>                        dev->logical_block_size, dev->physical_block_size,
> -                      dev->max_write_same_sectors, dev->max_discard_sect=
ors,
> +                      dev->max_discard_sectors,
>                        dev->discard_granularity, dev->discard_alignment,
>                        dev->secure_discard, dev->max_segments,
>                        dev->max_hw_sectors, dev->rotational, dev->wc, dev=
->fua);
> diff --git a/drivers/block/rnbd/rnbd-clt.h b/drivers/block/rnbd/rnbd-clt.=
h
> index 0c2cae7f39b9f..6946ba23d62e5 100644
> --- a/drivers/block/rnbd/rnbd-clt.h
> +++ b/drivers/block/rnbd/rnbd-clt.h
> @@ -122,7 +122,6 @@ struct rnbd_clt_dev {
>         bool                    wc;
>         bool                    fua;
>         u32                     max_hw_sectors;
> -       u32                     max_write_same_sectors;
>         u32                     max_discard_sectors;
>         u32                     discard_granularity;
>         u32                     discard_alignment;
> diff --git a/drivers/block/rnbd/rnbd-proto.h b/drivers/block/rnbd/rnbd-pr=
oto.h
> index de5d5a8df81d7..3eb8b34bd1886 100644
> --- a/drivers/block/rnbd/rnbd-proto.h
> +++ b/drivers/block/rnbd/rnbd-proto.h
> @@ -249,9 +249,6 @@ static inline u32 rnbd_to_bio_flags(u32 rnbd_opf)
>         case RNBD_OP_SECURE_ERASE:
>                 bio_opf =3D REQ_OP_SECURE_ERASE;
>                 break;
> -       case RNBD_OP_WRITE_SAME:
> -               bio_opf =3D REQ_OP_WRITE_SAME;
> -               break;
>         default:
>                 WARN(1, "Unknown RNBD type: %d (flags %d)\n",
>                      rnbd_op(rnbd_opf), rnbd_opf);
> @@ -284,9 +281,6 @@ static inline u32 rq_to_rnbd_flags(struct request *rq=
)
>         case REQ_OP_SECURE_ERASE:
>                 rnbd_opf =3D RNBD_OP_SECURE_ERASE;
>                 break;
> -       case REQ_OP_WRITE_SAME:
> -               rnbd_opf =3D RNBD_OP_WRITE_SAME;
> -               break;
>         case REQ_OP_FLUSH:
>                 rnbd_opf =3D RNBD_OP_FLUSH;
>                 break;
> diff --git a/drivers/block/rnbd/rnbd-srv.c b/drivers/block/rnbd/rnbd-srv.=
c
> index 132e950685d59..0e6b5687f8321 100644
> --- a/drivers/block/rnbd/rnbd-srv.c
> +++ b/drivers/block/rnbd/rnbd-srv.c
> @@ -548,8 +548,7 @@ static void rnbd_srv_fill_msg_open_rsp(struct rnbd_ms=
g_open_rsp *rsp,
>                 cpu_to_le16(rnbd_dev_get_max_segs(rnbd_dev));
>         rsp->max_hw_sectors =3D
>                 cpu_to_le32(rnbd_dev_get_max_hw_sects(rnbd_dev));
> -       rsp->max_write_same_sectors =3D
> -               cpu_to_le32(bdev_write_same(rnbd_dev->bdev));
> +       rsp->max_write_same_sectors =3D 0;
>         rsp->max_discard_sectors =3D
>                 cpu_to_le32(rnbd_dev_get_max_discard_sects(rnbd_dev));
>         rsp->discard_granularity =3D
> --
> 2.30.2
>
