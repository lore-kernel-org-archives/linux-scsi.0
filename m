Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C9F1C433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Nov 2021 13:14:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2A1E06103E
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Nov 2021 13:14:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236934AbhKQNRF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 Nov 2021 08:17:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235640AbhKQNRE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Nov 2021 08:17:04 -0500
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7E90C061570;
        Wed, 17 Nov 2021 05:14:05 -0800 (PST)
Received: by mail-lf1-x12f.google.com with SMTP id u3so8314887lfl.2;
        Wed, 17 Nov 2021 05:14:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:mime-version:subject:message-id:date:cc:to;
        bh=bGbWYoqOp4VoWzvoiIP9woCc0L8iKhtKFSf31az8TBo=;
        b=eyBE44VSd7ab4IXTIPId7qSYnMLT7/5/0F/mhyFNjDyXBWWw4Hvg4Cmb95bjNV2UnI
         /xapd/yaXfOSOfjQc3yGcSQw0Ppuc0HfkZV4oGdgBEPsLDENT8OVvl4hY25l4aP54O8M
         OW23J42Z15KXzkMAcAsI9sefwyMU88teXV15Ivxl+psIbk9iAojbXb/3ehD1UXgEz8/5
         s/4wn5xb2OAGxCKrQIzAHoTWbYZmoKYsAoK63TyYTHakL74lYOXvJWnvt7J7FpPlF5n4
         Iv07HipgC14POcwxq+uiCXeCd0EXFGDcKDXdT72nvOVeI+xuLavsxmnIn4xqTZeL7+nz
         ECfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:mime-version:subject:message-id:date:cc:to;
        bh=bGbWYoqOp4VoWzvoiIP9woCc0L8iKhtKFSf31az8TBo=;
        b=syP0xFjB9kzQEf+v97rSd3GOdi0mCrOPDLkAsf6FtW53PV3kydtROSGKpnUkranYEI
         AaLUmA48wGrdsqEe6rW/j+zduZzA+DgBTqwgTpWyAiG2lCGoOWIyUU9hsPRCCENX5ruz
         corQqRmJboqYiyy86tjVDcTvH6Mf8Vjeb7woNBTp7XPlfdQeaOK8yRGIWH4PfpQOE4x3
         pRineUqZ1fyrdCwdYg4DSW9aQmZFVHzLqH1J+0mRjsVdGN9KJKgffjShTIPvkoxkIvfx
         gxTMerdPAoiCVEfM12ei+SDC1GkoOb6YkaXUSI+LW72acqfAb3cRcoqLRL9kclLaczjX
         qVyw==
X-Gm-Message-State: AOAM531r+qYQfT0bhrhOVxepLaY5FQadTs78+EWhmdgcJQRpBMA7EF/L
        YbmbNRh8/JOQNSATrrWmSv7+4yY3POCUkzNt
X-Google-Smtp-Source: ABdhPJy/saBY9U/b8p+qOeevpjAIp3B9fq+zvwpUI4j5veCcZctHxfJl0Axx0OhT6A6O52YWOjRBIw==
X-Received: by 2002:a05:6512:33c8:: with SMTP id d8mr15217715lfg.573.1637154844178;
        Wed, 17 Nov 2021 05:14:04 -0800 (PST)
Received: from smtpclient.apple ([5.8.48.45])
        by smtp.gmail.com with ESMTPSA id d22sm1695935lfe.158.2021.11.17.05.14.02
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 17 Nov 2021 05:14:03 -0800 (PST)
From:   Alexey Lyashkov <alexey.lyashkov@gmail.com>
Content-Type: multipart/mixed;
        boundary="Apple-Mail=_C6614723-5315-4C39-B42C-A71A3AFDF89B"
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.120.0.1.13\))
Subject: T10 DIX bug for the md raid with 4k block devices
Message-Id: <08E36BA8-FD6F-42A0-8411-0A3B54FDD0DD@gmail.com>
Date:   Wed, 17 Nov 2021 16:14:02 +0300
Cc:     linux-block@vger.kernel.org, Max Gurtovoy <mgurtovoy@nvidia.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jens Axboe <axboe@kernel.dk>, yann.livis@hpe.com
To:     linux-scsi@vger.kernel.org
X-Mailer: Apple Mail (2.3654.120.0.1.13)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


--Apple-Mail=_C6614723-5315-4C39-B42C-A71A3AFDF89B
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=utf-8

Hello All,

I was requested to create a raid0 device on top NVMe with 4k block size =
and DPS2 enabled.
But this config failed in case bio_intergrity_pre called before =
bio_split.
Some research pointed me to the two fixes related to my problem,
first was=20
commit f36ea50ca0043e7b1204feaf1d2ba6bd68c08d36
Author: Wen Xiong <wenxiong@linux.vnet.ibm.com>
Date:   Wed May 10 08:54:11 2017 -0500

    blk-mq: NVMe 512B/4K+T10 DIF/DIX format returns I/O error on dd with =
split op

    When formatting NVMe to 512B/4K + T10 DIf/DIX, dd with split op =
returns
    "Input/output error". Looks block layer split the bio after calling
    bio_integrity_prep(bio). This patch fixes the issue.

and second was
commit e4dc9a4c31fe10d1751c542702afc85be8a5c56a
Author: Israel Rukshin <israelr@mellanox.com>
Date:   Wed Dec 11 17:36:02 2019 +0200

    scsi: target/iblock: Fix protection error with blocks greater than =
512B

=E2=80=A6
But both ideas not acceptable for me and i continue a research.
Block io trace pointed me to the three functions called in my case, it =
is
t10_pi_generate, bio_integrity_advance, t10_pi_type1_prepare.

Looking in code - t10_pi_generate generate a ref_tag based on =
=E2=80=9Cvirtual=E2=80=9D block number (512b base), and =
t10_pi_type1_prepare - converts this data to the the real ref_tag (aka =
device block number), but sometimes it=E2=80=99s don=E2=80=99t mapped.
Looking to the=20
void bio_integrity_advance(struct bio *bio, unsigned int bytes_done)
{
        struct bio_integrity_payload *bip =3D bio_integrity(bio);
        struct blk_integrity *bi =3D blk_get_integrity(bio->bi_disk);
        unsigned bytes =3D bio_integrity_bytes(bi, bytes_done >> 9);
        bip->bip_iter.bi_sector +=3D bytes_done >> 9;
        bvec_iter_advance(bip->bip_vec, &bip->bip_iter, bytes);
}

it have shit an iterator in the 512b block size base it looks right, but =
wait=E2=80=A6=20
static blk_status_t t10_pi_generate(struct blk_integrity_iter *iter,
                csum_fn *fn, enum t10_dif_type type)
{
        unsigned int i;

        for (i =3D 0 ; i < iter->data_size ; i +=3D iter->interval) {
                struct t10_pi_tuple *pi =3D iter->prot_buf;


                iter->seed++; <<<
        }

        return BLK_STS_OK;
}

t10_pi_generate / t10_pi_type1_prepare have just a increment by =E2=80=9C1=
=E2=80=9D for the integrity internal which is 4k in my case,
so any bio_integrity_advance call will be move an iterator outside of =
generated sequence and t10_pi_type1_prepare can=E2=80=99t be found a =
good virt sector for the mapping.
Changing an increment by =E2=80=9C1=E2=80=9D to be related to the real =
integrity size solve a problem completely.
Attached patch passed my own testing on raid0 with 4k block size.=20


--Apple-Mail=_C6614723-5315-4C39-B42C-A71A3AFDF89B
Content-Disposition: attachment;
	filename=t10-pi-fix-intergrity-iterator.patch
Content-Type: application/octet-stream;
	x-unix-mode=0777;
	name="t10-pi-fix-intergrity-iterator.patch"
Content-Transfer-Encoding: quoted-printable

=46rom=206a8f488be163f8ff33897177d7b744dd70a77203=20Mon=20Sep=2017=20=
00:00:00=202001=0AFrom:=20Alexey=20Lyashkov=20<umka@cloudlinux.com>=0A=
Date:=20Wed,=2017=20Nov=202021=2016:09:20=20+0300=0ASubject:=20[PATCH]=20=
t10-pi:=20fix=20intergrity=20iterator=0A=0AIntegrity=20iterator=20should=20=
be=20in=20the=20SECTOR_SIZE=20units,=0Anot=20an=20count=20interity=20=
intervals=20to=20make=20bio_integrity_advance=0Abe=20happy=20on=20=
bio_split.=0A=0ASigned-off-by:=20Alexey=20Lyashkov=20=
<alexey.lyashkov@gmail.com>=0A---=0A=20block/t10-pi.c=20|=2014=20=
++++++++++----=0A=201=20file=20changed,=2010=20insertions(+),=204=20=
deletions(-)=0A=0Adiff=20--git=20a/block/t10-pi.c=20b/block/t10-pi.c=0A=
index=2025a52a2a09a8..bbdecead214e=20100644=0A---=20a/block/t10-pi.c=0A=
+++=20b/block/t10-pi.c=0A@@=20-31,6=20+31,7=20@@=20static=20blk_status_t=20=
t10_pi_generate(struct=20blk_integrity_iter=20*iter,=0A=20=09=09csum_fn=20=
*fn,=20enum=20t10_dif_type=20type)=0A=20{=0A=20=09unsigned=20int=20i;=0A=
+=09unsigned=20int=20pi_size=20=3D=20iter->interval=20>>=20SECTOR_SHIFT;=0A=
=20=0A=20=09for=20(i=20=3D=200=20;=20i=20<=20iter->data_size=20;=20i=20=
+=3D=20iter->interval)=20{=0A=20=09=09struct=20t10_pi_tuple=20*pi=20=3D=20=
iter->prot_buf;=0A@@=20-45,7=20+46,7=20@@=20static=20blk_status_t=20=
t10_pi_generate(struct=20blk_integrity_iter=20*iter,=0A=20=0A=20=09=09=
iter->data_buf=20+=3D=20iter->interval;=0A=20=09=09iter->prot_buf=20+=3D=20=
sizeof(struct=20t10_pi_tuple);=0A-=09=09iter->seed++;=0A+=09=09=
iter->seed+=3D=20pi_size;=0A=20=09}=0A=20=0A=20=09return=20BLK_STS_OK;=0A=
@@=20-55,6=20+56,7=20@@=20static=20blk_status_t=20t10_pi_verify(struct=20=
blk_integrity_iter=20*iter,=0A=20=09=09csum_fn=20*fn,=20enum=20=
t10_dif_type=20type)=0A=20{=0A=20=09unsigned=20int=20i;=0A+=09unsigned=20=
int=20pi_size=20=3D=20iter->interval=20>>=20SECTOR_SHIFT;=0A=20=0A=20=09=
BUG_ON(type=20=3D=3D=20T10_PI_TYPE0_PROTECTION);=0A=20=0A@@=20-94,7=20=
+96,7=20@@=20static=20blk_status_t=20t10_pi_verify(struct=20=
blk_integrity_iter=20*iter,=0A=20next:=0A=20=09=09iter->data_buf=20+=3D=20=
iter->interval;=0A=20=09=09iter->prot_buf=20+=3D=20sizeof(struct=20=
t10_pi_tuple);=0A-=09=09iter->seed++;=0A+=09=09iter->seed=20+=3D=20=
pi_size;=0A=20=09}=0A=20=0A=20=09return=20BLK_STS_OK;=0A@@=20-135,6=20=
+137,7=20@@=20static=20void=20t10_pi_type1_prepare(struct=20request=20=
*rq)=0A=20=09const=20int=20tuple_sz=20=3D=20rq->q->integrity.tuple_size;=0A=
=20=09u32=20ref_tag=20=3D=20t10_pi_ref_tag(rq);=0A=20=09struct=20bio=20=
*bio;=0A+=09unsigned=20int=20pi_size=20=3D=201=20<<=20=
(rq->q->integrity.interval_exp=20-=20SECTOR_SHIFT);=0A=20=0A=20=09=
__rq_for_each_bio(bio,=20rq)=20{=0A=20=09=09struct=20=
bio_integrity_payload=20*bip=20=3D=20bio_integrity(bio);=0A@@=20-156,7=20=
+159,8=20@@=20static=20void=20t10_pi_type1_prepare(struct=20request=20=
*rq)=0A=20=0A=20=09=09=09=09if=20(be32_to_cpu(pi->ref_tag)=20=3D=3D=20=
virt)=0A=20=09=09=09=09=09pi->ref_tag=20=3D=20cpu_to_be32(ref_tag);=0A-=09=
=09=09=09virt++;=0A+=0A+=09=09=09=09virt=20+=3D=20pi_size;=0A=20=09=09=09=
=09ref_tag++;=0A=20=09=09=09=09p=20+=3D=20tuple_sz;=0A=20=09=09=09}=0A@@=20=
-185,6=20+189,7=20@@=20static=20void=20t10_pi_type1_complete(struct=20=
request=20*rq,=20unsigned=20int=20nr_bytes)=0A=20=09const=20int=20=
tuple_sz=20=3D=20rq->q->integrity.tuple_size;=0A=20=09u32=20ref_tag=20=3D=20=
t10_pi_ref_tag(rq);=0A=20=09struct=20bio=20*bio;=0A+=09unsigned=20int=20=
pi_size=20=3D=201=20<<=20(rq->q->integrity.interval_exp=20-=20=
SECTOR_SHIFT);=0A=20=0A=20=09__rq_for_each_bio(bio,=20rq)=20{=0A=20=09=09=
struct=20bio_integrity_payload=20*bip=20=3D=20bio_integrity(bio);=0A@@=20=
-202,7=20+207,8=20@@=20static=20void=20t10_pi_type1_complete(struct=20=
request=20*rq,=20unsigned=20int=20nr_bytes)=0A=20=0A=20=09=09=09=09if=20=
(be32_to_cpu(pi->ref_tag)=20=3D=3D=20ref_tag)=0A=20=09=09=09=09=09=
pi->ref_tag=20=3D=20cpu_to_be32(virt);=0A-=09=09=09=09virt++;=0A+=0A+=09=09=
=09=09virt+=3D=20pi_size;=0A=20=09=09=09=09ref_tag++;=0A=20=09=09=09=09=
intervals--;=0A=20=09=09=09=09p=20+=3D=20tuple_sz;=0A--=20=0A2.27.0=0A=0A=

--Apple-Mail=_C6614723-5315-4C39-B42C-A71A3AFDF89B
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
	charset=us-ascii



Alex
--Apple-Mail=_C6614723-5315-4C39-B42C-A71A3AFDF89B--
