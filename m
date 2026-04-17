Received: from mail-oa1-f45.google.com (mail-oa1-f45.google.com [209.85.160.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31A2224A047
	for <linux-scsi@vger.kernel.org>; Fri, 17 Apr 2026 01:53:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776390799; cv=pass; b=uKoURB+e2BeJsMsQOAMxa1lklG8NVQRPZLq+leNM4ZLYdJSjp25S/IwR+Hgj1TZVTNGG1cDLjxSGHAX+KTCI2XKr81Q/2JkB6u9xW2cRAlFp/aZsubnHcjUW7HJKipOF25FyT4X65cLt2mwWm66doRnVmLJ7rvTmdLMHHRShw10=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776390799; c=relaxed/simple;
	bh=kOPxik6cGe9f5V9/eiojkqgQAZA5gmwpTfXIgNGzy6s=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=muLHXe2otJIT9khS+ItdHsOhOppHLaoJPzreNGs/hVqNIjVqZSyAluWgL3qcIuIb86QYU68e6Jkm5nR90blNpwUs++IsUU183StWtNoI0qE+AIn7bBQSBKGuXYgMHDdmtotkNWg87TPfYCTCKTpPqBW+L+g69gKXTNp5rmUhRLM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=GwU6xmwC; arc=pass smtp.client-ip=209.85.160.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="GwU6xmwC"
Received: by mail-oa1-f45.google.com with SMTP id 586e51a60fabf-40947c81b31so10650fac.1
        for <linux-scsi@vger.kernel.org>; Thu, 16 Apr 2026 18:53:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776390797; cv=none;
        d=google.com; s=arc-20240605;
        b=dm/lHcyG2qMisbzY+dvtS0iEVyRp2VWypjs9ACkDlbOvE0DWWmtCzGBrK5Lssg2a9r
         BqWHqBuyudyxXNlRe3m3xUTfRRpMSSi3GGjSDL3C5dVkk1SUgJdHd0QBrVYo3EISaR9c
         BiVYzUT1iUJ8wCNNaQkrjeKDS9glbRl8iN+gKwMBkPfUa3GUYTB/acN68LNrnIypG0r0
         7o9DKMbq6NbptJ7IyF3AbGA4g1T/e4DjBqo1LRhm8P2fUwm5v75VcgoKxfZRoPqw7k3c
         117ja6roR+6GcFPFo59BBOw7wwvcMj0pEwshTmH/jqhRRYn5RJkXAbn9pf70SzSMB36X
         qrWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=+KsO1NaX9EqdvAZLJ/Ig7h5Lud7184o3UpmgRp/VzKQ=;
        fh=ZNSzOCEG1Ym3clGpNEgARLzbziEiVyKlkh3zszynr5o=;
        b=eZTqxV9gLmHQ5QAKf2FTJ765J129z6V8EuQDp9TEdhfzPm8rbfBSKClD4BcfxN/EPq
         8JO8nZewM1R3q6cUCgnSkdJbFLiTNAwC/WFYmCGhayKPtfqsHjjenR6hkn/ut96YHPXg
         VbKir6uc+bjF/0qCG1EvyI6q5dfdCWilKw7PU1sWiZxkEV4lXueLP9vWfFyCfHwXo11+
         3GNZTXI2jelgW3CE3aKmNXhsX+pqAfiQ71CMbpz8tals6lcTsyiu5mr6FJQBLFW1+YQq
         GyJUueicI8xsX7HRx1Dnu8Jgbzhv124fAy+D1XesTm+hdAJlZ4VFBltFYu/G0KKKz3aJ
         riIA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1776390797; x=1776995597; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+KsO1NaX9EqdvAZLJ/Ig7h5Lud7184o3UpmgRp/VzKQ=;
        b=GwU6xmwCvRkFrguBVDxYY/dZq2a9YCy4ai+T5H7owxALjG17//ep4JHehrP6YAzifb
         2ogTtmAg4CuNGIpB0cc0vWNM1dsvlL2xdE0DpBJ7W325FC4H5dnYOE2CDXZj/eKAfSJC
         iE+jlmKMOcQCvnPxJH1o8lYDI4e9ZAShcU01AseNT8CvEGvyl0cy+ZLvNglGxi+/Gth2
         4GUyCKTDg67W66qR0RVwq0miehQxf8j4gIcpB+mO+gUCZB2dS7/vvR4xqhUlvezX4Ape
         wlLnCo/vZVAc+v+ywf5N9istG+iM/FpxaQj33/FOXT+FAzDSY9DXcyEg6BRrK+ROoGEr
         pjxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776390797; x=1776995597;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=+KsO1NaX9EqdvAZLJ/Ig7h5Lud7184o3UpmgRp/VzKQ=;
        b=T/ne9K+Fpm5YHcuA0miLosaMV7GXWudrJfvejI3V2h3iRC+d1+Ah/RgiqAKp0czlYf
         5VWkg2SEnF4263aSoaAsc3VZc96FSNh8rdzx50HDi0HjAdekJRzju+MqyXfkHCboGwxG
         qhjIRTaOtUpHjDlR3epvA4JFvyt4+gdypPzjH14TZGvcD9iXLvNKgB4IzpFqsjezA1Zv
         DhTsmyc0cy1as3RZooZ9WeZ6yIHLY7qtcs51aPjK4WG9nRmFKzODZYBwnz3CHD8TJP6k
         rnLO9wWxECEB/pBrvxlqBlhZgebQJbh7Rsi565mxG+96aAlDL+/Cpld/LbJacIrpF9a6
         V5cg==
X-Forwarded-Encrypted: i=1; AFNElJ8/Be+ohUGsstkPN311pg53SILdTZz5UYy/l1AJ0KUTaY6RhjrrzjYAaAKogMUqoTZZNjMFrneiqqzK@vger.kernel.org
X-Gm-Message-State: AOJu0YzZgWoRCWpS/1C4ezKruH7st2a1kXd41tWhAXorDa1C0A77JtDF
	/fvkxj+yBGaJgwbgI2g3npnIA1Fz/CtzT78hUeY4WV5GthZgkZKfJ7YuSr/Fk7UbaGulUrqUxRl
	rPCg4ZUHm9O8ko4EQlsy3Hs0srpKo19Rj9MWrxmMDMQ==
X-Gm-Gg: AeBDiesqlM7VPym31O90qA6dhqb/uHcPzaGlZRBTWgqb/j+sILm3rFHfRqbXIaEYb2X
	xrRI289Ia2c+05wwkR7hYpdqgCYyfuchjyeP8WVEuE0uGglDb7TMBTsNdW/zkqskmYXFqKbx3bn
	bcF+0blaylctolBMXCxsq73veKnOR3OfVg7nSzbfnimAz/TpHZrg8Y4U2OH+rMFE0AHGMoEtRHl
	0BSNH7XJZ4lfoHYTiZR9FvO7eNmeOH+quNkHmGIWSkrNn6kd7tGKW61E9+VjPlQqIwIS5XFLHma
	X1/H8dAsY6ayZh4KJaQ=
X-Received: by 2002:a05:6871:ea06:b0:423:e2d:bcd5 with SMTP id
 586e51a60fabf-42abee7a63fmr242473fac.0.1776390796946; Thu, 16 Apr 2026
 18:53:16 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260416002214.2048150-1-csander@purestorage.com>
 <20260416002214.2048150-7-csander@purestorage.com> <20260416052325.GE14950@lst.de>
In-Reply-To: <20260416052325.GE14950@lst.de>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Thu, 16 Apr 2026 18:53:05 -0700
X-Gm-Features: AQROBzCPGHONvWMncmYhZ1NMXp33B6ERld-DgLK_KyRg3_SVXkVvrIxlwuDEnA0
Message-ID: <CADUfDZpbOhO9BUW_mFZYh9-UZU26_o3rFGBffNTpepk0ogJhZw@mail.gmail.com>
Subject: Re: [PATCH v2 6/6] blk-integrity: avoid sector_t in bip_{get,set}_seed()
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Sagi Grimberg <sagi@grimberg.me>, 
	Chaitanya Kulkarni <kch@nvidia.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, 
	Anuj Gupta <anuj20.g@samsung.com>, linux-block@vger.kernel.org, 
	linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org, 
	target-devel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Christoph Hellwig <hch@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 15, 2026 at 10:23=E2=80=AFPM Christoph Hellwig <hch@lst.de> wro=
te:
>
> On Wed, Apr 15, 2026 at 06:22:14PM -0600, Caleb Sander Mateos wrote:
> > bip_set_seed() and big_get_seed() take/return a sector_t value that's
> > actually an integrity interval number. This is confusing, so pass
> > struct blk_integrity and struct bio instead to bip_set_seed() and
> > convert the bio's device address to integrity intervals.
> >
> > Open-code the access to bip->bip_iter.bi_sector in the one caller of
> > bip_set_seed() that doesn't use the bio device address for the seed.
> > Open-code bip_get_seed() in its one caller.
> >
> > Add a comment to struct bvec_iter's bi_sector field explaining its
> > alternate use for bip_iter.
> >
> > Signed-off-by: Caleb Sander Mateos <csander@purestorage.com>
> > Suggested-by: Christoph Hellwig <hch@infradead.org>
> > ---
> >  block/bio-integrity.c               |  5 ++---
> >  block/t10-pi.c                      |  2 +-
> >  drivers/nvme/target/io-cmd-bdev.c   |  3 +--
> >  drivers/target/target_core_iblock.c |  3 +--
> >  include/linux/bio-integrity.h       | 11 -----------
> >  include/linux/blk-integrity.h       | 14 ++++++++++++++
> >  include/linux/bvec.h                |  1 +
> >  7 files changed, 20 insertions(+), 19 deletions(-)
> >
> > diff --git a/block/bio-integrity.c b/block/bio-integrity.c
> > index 3ad6a6799f17..e9ae5db99f64 100644
> > --- a/block/bio-integrity.c
> > +++ b/block/bio-integrity.c
> > @@ -103,13 +103,12 @@ void bio_integrity_free_buf(struct bio_integrity_=
payload *bip)
> >
> >  void bio_integrity_setup_default(struct bio *bio)
> >  {
> >       struct blk_integrity *bi =3D blk_get_integrity(bio->bi_bdev->bd_d=
isk);
> >       struct bio_integrity_payload *bip =3D bio_integrity(bio);
> > -     u64 seed =3D bio->bi_iter.bi_sector >> (bi->interval_exp - SECTOR=
_SHIFT);
> >
> > -     bip_set_seed(bip, seed);
> > +     bip_set_seed(bip, bi, bio);
> >
> >       if (bi->csum_type) {
> >               bip->bip_flags |=3D BIP_CHECK_GUARD;
> >               if (bi->csum_type =3D=3D BLK_INTEGRITY_CSUM_IP)
> >                       bip->bip_flags |=3D BIP_IP_CHECKSUM;
> > @@ -472,11 +471,11 @@ int bio_integrity_map_iter(struct bio *bio, struc=
t uio_meta *meta)
> >
> >       it.count =3D integrity_bytes;
> >       ret =3D bio_integrity_map_user(bio, &it);
> >       if (!ret) {
> >               bio_uio_meta_to_bip(bio, meta);
> > -             bip_set_seed(bio_integrity(bio), meta->seed);
> > +             bio_integrity(bio)->bip_iter.bi_sector =3D meta->seed;
> >               iov_iter_advance(&meta->iter, integrity_bytes);
> >               meta->seed +=3D bio_integrity_intervals(bi, bio_sectors(b=
io));
> >       }
> >       return ret;
> >  }
> > diff --git a/block/t10-pi.c b/block/t10-pi.c
> > index 787950dec50a..71367fd082bd 100644
> > --- a/block/t10-pi.c
> > +++ b/block/t10-pi.c
> > @@ -510,11 +510,11 @@ static void blk_reftag_remap_prepare(struct blk_i=
ntegrity *bi,
> >  static void __blk_reftag_remap(struct bio *bio, struct blk_integrity *=
bi,
> >                              unsigned *intervals, u64 *ref, bool prep)
> >  {
> >       struct bio_integrity_payload *bip =3D bio_integrity(bio);
> >       struct bvec_iter iter =3D bip->bip_iter;
> > -     u64 virt =3D bip_get_seed(bip);
> > +     u64 virt =3D bip->bip_iter.bi_sector;
> >       union pi_tuple *ptuple;
> >       union pi_tuple tuple;
> >
> >       if (prep && bip->bip_flags & BIP_MAPPED_INTEGRITY) {
> >               *ref +=3D bio->bi_iter.bi_size >> bi->interval_exp;
> > diff --git a/drivers/nvme/target/io-cmd-bdev.c b/drivers/nvme/target/io=
-cmd-bdev.c
> > index f2d9e8901df4..2c4b312f2f55 100644
> > --- a/drivers/nvme/target/io-cmd-bdev.c
> > +++ b/drivers/nvme/target/io-cmd-bdev.c
> > @@ -218,12 +218,11 @@ static int nvmet_bdev_alloc_bip(struct nvmet_req =
*req, struct bio *bio,
> >               pr_err("Unable to allocate bio_integrity_payload\n");
> >               return PTR_ERR(bip);
> >       }
> >
> >       /* virtual start sector must be in integrity interval units */
> > -     bip_set_seed(bip, bio->bi_iter.bi_sector >>
> > -                  (bi->interval_exp - SECTOR_SHIFT));
> > +     bip_set_seed(bip, bi, bio);
> >
> >       resid =3D bio_integrity_bytes(bi, bio_sectors(bio));
> >       while (resid > 0 && sg_miter_next(miter)) {
> >               len =3D min_t(size_t, miter->length, resid);
> >               rc =3D bio_integrity_add_page(bio, miter->page, len,
> > diff --git a/drivers/target/target_core_iblock.c b/drivers/target/targe=
t_core_iblock.c
> > index 1087d1d17c36..4e0fa91a08fd 100644
> > --- a/drivers/target/target_core_iblock.c
> > +++ b/drivers/target/target_core_iblock.c
> > @@ -706,12 +706,11 @@ iblock_alloc_bip(struct se_cmd *cmd, struct bio *=
bio,
> >               pr_err("Unable to allocate bio_integrity_payload\n");
> >               return PTR_ERR(bip);
> >       }
> >
> >       /* virtual start sector must be in integrity interval units */
> > -     bip_set_seed(bip, bio->bi_iter.bi_sector >>
> > -                               (bi->interval_exp - SECTOR_SHIFT));
> > +     bip_set_seed(bip, bi, bio);
> >
> >       pr_debug("IBLOCK BIP Size: %u Sector: %llu\n", bip->bip_iter.bi_s=
ize,
> >                (unsigned long long)bip->bip_iter.bi_sector);
> >
> >       resid =3D bio_integrity_bytes(bi, bio_sectors(bio));
> > diff --git a/include/linux/bio-integrity.h b/include/linux/bio-integrit=
y.h
> > index af5178434ec6..edcd0855abba 100644
> > --- a/include/linux/bio-integrity.h
> > +++ b/include/linux/bio-integrity.h
> > @@ -56,21 +56,10 @@ static inline bool bio_integrity_flagged(struct bio=
 *bio, enum bip_flags flag)
> >               return bip->bip_flags & flag;
> >
> >       return false;
> >  }
> >
> > -static inline sector_t bip_get_seed(struct bio_integrity_payload *bip)
> > -{
> > -     return bip->bip_iter.bi_sector;
> > -}
> > -
> > -static inline void bip_set_seed(struct bio_integrity_payload *bip,
> > -                             sector_t seed)
> > -{
> > -     bip->bip_iter.bi_sector =3D seed;
> > -}
> > -
> >  void bio_integrity_init(struct bio *bio, struct bio_integrity_payload =
*bip,
> >               struct bio_vec *bvecs, unsigned int nr_vecs);
> >  struct bio_integrity_payload *bio_integrity_alloc(struct bio *bio, gfp=
_t gfp,
> >               unsigned int nr);
> >  int bio_integrity_add_page(struct bio *bio, struct page *page, unsigne=
d int len,
> > diff --git a/include/linux/blk-integrity.h b/include/linux/blk-integrit=
y.h
> > index 825d777c078b..3a2e55e809c5 100644
> > --- a/include/linux/blk-integrity.h
> > +++ b/include/linux/blk-integrity.h
> > @@ -85,10 +85,24 @@ static inline unsigned int bio_integrity_bytes(stru=
ct blk_integrity *bi,
> >                                              unsigned int sectors)
> >  {
> >       return bio_integrity_intervals(bi, sectors) * bi->metadata_size;
> >  }
> >
> > +/**
> > + * bip_set_seed - Set bip reference tag seed from bio device address
> > + * @bip:     struct bio_integrity_payload whose ref tag seed to set
> > + * @bi:              struct blk_integrity profile for device
> > + * @bio:     struct bio whose device address to use for the ref tag se=
ed
> > + */
> > +static inline void bip_set_seed(struct bio_integrity_payload *bip,
> > +                             const struct blk_integrity *bi,
> > +                             const struct bio *bio)
> > +{
> > +     bip->bip_iter.bi_sector =3D
> > +             bio_integrity_intervals(bi, bio->bi_iter.bi_sector);
>
> The bip is pointed to by the bio, so we don't need to pass it separately.
> Same for struct blk_integrity.

I did consider that, but all callers already have bip and bi in
variables that they also use elsewhere. Seemed like it might be
slightly more efficient to just pass the precomputed values instead of
looking them up again. Not a big deal either way. I'll go ahead and
implement your suggestion.

Thanks,
Caleb
