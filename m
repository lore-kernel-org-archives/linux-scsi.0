Received: from mail-oo1-f51.google.com (mail-oo1-f51.google.com [209.85.161.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93AF03033E1
	for <linux-scsi@vger.kernel.org>; Wed,  1 Jul 2026 19:56:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.161.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782935798; cv=pass; b=QQ7Xsy9MqtJ6u7z2yhUXPcaxd1iW/2tfF6IGx6ftH0dS3LnKxAZGDowILVJXnyyFAuJiDcMAnyU6hirgaA4VDz5UwlzdCsLEKtlBGqKFlU128+puwTcVVWZoVw4usp7dSzpL+w5007GgSltkagTWEJEX3W0fFkVAWZXZq2FiKhs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782935798; c=relaxed/simple;
	bh=KoFkJKqOZpBo9LxusJau6YmmTGqiKlHE4BPUGelmuaQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=a0mIrzgfnn45FZW2ouJGBaT/Umhv55nN8TsVIiCy9J586Rg0oV6dAnEMDI6KXpwCsj3XXBY5UNhuZskJQvcqEMfkc1vuhvp28SWR37GMIIDxTjWGTUwnNkCpDAwBSt/rBNxfJQ4JU4VLvU5Fctdjxivno11WmcbPxsn0PYZOigw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=purestorage.com; spf=pass smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=RPTdIJgb; arc=pass smtp.client-ip=209.85.161.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=purestorage.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="RPTdIJgb"
Received: by mail-oo1-f51.google.com with SMTP id 006d021491bc7-6a30c37a24fso46434eaf.1
        for <linux-scsi@vger.kernel.org>; Wed, 01 Jul 2026 12:56:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782935795; cv=none;
        d=google.com; s=arc-20260327;
        b=DntgN0PkDRA9Z/U4lf8G0P5LPjpz49kX1UUqns82VUzlngldHNh9C0/SFhD97GUpxJ
         2dj0sdCWyizIxzAd1TMVsMhV9NMsThk3K3La20Y3xyTW/jAhYEp2QRCbhu53wT+pLoCl
         X6wDidg1P9VdFqOa5pDRP12dVln1imwTP4GKtVc3z2dxkJ5Nlf/vzLwbHMepJrGbe6DG
         LxROxH7Yw6ia9UqW+gcrcCuV45R8vIOCF5+NpZk6na4PB0DopZu0Bi4giR64//1kOuSV
         6KcwFes+DL4uSAV44MteML3SPRABP7MaCckgtyRoKsmUQooOjHrXns+IUHL+b1PPkufB
         SpNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=mtIVN0DqJBgCNlfEAAUMuGRPuwtbmUfKPGcnXNrwZLM=;
        fh=FOUebqfeCvFq5oCxrL5BPjdoXzvei/Sgb5e1547VwGs=;
        b=GDkCkBZdAEF9aA1SnN+8bhF0Ip5rORDguicybnBi4jnemnKHdhPEElnHRNv71qkUAF
         5TuwsdJpQq4bHWhza38guxGgEm1KjsJZdE1oseDGeeWbTc/qN1enl9iYIn5qSBxdNcy2
         iPzAMs70/U8F/BFGwP4j82OTEPkciW72CWdkXlLD88oL8kviJzEYetmY1DTiuZ68wCWE
         nmv9/hilmBB4WkWxWUrDZ2syHtkjVDTTiCTdPY95GZrzF30uCutM4baub6Ey001VIcmB
         JvjnPTOEqVxmQLNH44AvYfQqstsf5NgCgoCWPbYxTh+Iyq0GZDJVsw7LJcOHejxxZMMS
         /SXg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1782935795; x=1783540595; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=mtIVN0DqJBgCNlfEAAUMuGRPuwtbmUfKPGcnXNrwZLM=;
        b=RPTdIJgbadMMMI77vkIsKOaFJYsysluGNmgen+IR0V80ycKF7UOkcEijW97k3md5nE
         7MNcD51WwHnziverBts1qSSELmGIiSLAWZaYpwXb0dMWAxdyBxgIoetCpWnAtcYq1/5H
         Rvz+K2Sggd9LAVrqMwQCovypGAqdyq5nY4gGsIMpe/DOnlouY1wZkjjAQguHWDE23Gew
         S6jlFDLhH65+UxfrJMK2aBOYYWlpYuMyu9TI8FCEk2Q3FDKK2TlGoC7tL2vr0P23BWt/
         D87VcZs8tAz5i3ZhdCvkqbE928thbhsWHmPziB4tU7xNi+bhpf/ZNp6StO4328Unwd4G
         LIWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782935795; x=1783540595;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=mtIVN0DqJBgCNlfEAAUMuGRPuwtbmUfKPGcnXNrwZLM=;
        b=e5g9ZSXwP2+FEkXAoVVSXf+/gcVgZ+REo/r0uF8p/LXSyv2S19PY0gLRPkOdROWV1o
         iQsQlXlthCvA39Fn/jCnib8M8+wj5Nl3Lml9s+2DDtqpTpNxhtiQIf8xQ8tgWtpt/1Bp
         lBu2uB+M/qoYH9LPCv5FrslJoz+sJIvssIdCUqK/dzNaoCF1r+sn7rkvZ7XoIis4kpy2
         L0bLsAg0dJXdplj8OvHwQkvTZb9O6q2qbcy8kxxqYgdHAPUnHc0jEzDHowAoh9nn0+xO
         ZxPwM5m+Av9ZmA6c0igV4oKEMb04XGPXSEZ9hdF4beuiGNPay8lS5l5rpTXe5TaeDpXw
         o3YA==
X-Forwarded-Encrypted: i=1; AFNElJ/NF/DH/tEMnGuQJyvgKfGLS0MI+ipRvrlxBn9v/e99GBzknQYjS3M3GcIPijs9AUZuPnuP3VyXqUbG@vger.kernel.org
X-Gm-Message-State: AOJu0YyXlBefLwivgi1CcHvTc/Gz/IdjVQJsKbKBycLlBR4cJD4UDCU/
	CtRO+WtNA29vxj4A5nalHK2Ke1IrefJEt5CR+Cj5XTqWMKkjvZ4Rud5fdGkJwQjVrsWVANBSPJc
	HvIPImcRarxDl8fdRlk4lGz+iiDrXnn1EBaO0/AbXRg==
X-Gm-Gg: AfdE7cl8dmLGOfwRfHZyT6CRmx8286+pjhkBb4+MzpbIW4NAcdSZN8yLlBcHbYH4uJz
	a9TYRfmdlBIigg8EKOvC31ZUQuG8UnUUraIEVx3AfyK94c8oAdN48Ua2jBzZUgSzdDIPGrnYp9G
	kKDcSPtvBe0BTviVdlC0sLIhDvsw8SgyA0IPNPrMlpcVmEdoI7o3DOJxYuXlUhNqh3vs3QeTlAx
	g3i3UHiYq78c348EfN1+6F0124z/oJ8QGISItLO+PhU0n4HlH+ogfdw9Ilwfvk7NMRVvytP6Qae
	jq/HZc7y
X-Received: by 2002:a05:6820:7705:b0:6a0:ee7d:80ea with SMTP id
 006d021491bc7-6a30974705amr995871eaf.0.1782935795443; Wed, 01 Jul 2026
 12:56:35 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260627054220.2174166-1-csander@purestorage.com> <20260627054220.2174166-2-csander@purestorage.com>
In-Reply-To: <20260627054220.2174166-2-csander@purestorage.com>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Wed, 1 Jul 2026 12:56:24 -0700
X-Gm-Features: AVVi8CcoTxYjhA4dG7f1i1JCHKMq7tvfJVmlu_uynO4PEoI0alXFMGjmDjqio0g
Message-ID: <CADUfDZqE6JLLbugK+qYe=XFSLV5zUwFEQ6qRqvJ-=uVs8OtfVg@mail.gmail.com>
Subject: Re: [PATCH v4 1/5] block: use integrity interval instead of sector as seed
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Anuj Gupta <anuj20.g@samsung.com>, linux-block@vger.kernel.org, 
	linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org, 
	target-devel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>, 
	Chaitanya Kulkarni <kch@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 26, 2026 at 10:42=E2=80=AFPM Caleb Sander Mateos
<csander@purestorage.com> wrote:
>
> bio_integrity_setup_default() and blk_integrity_iterate() set the
> integrity seed (initial reference tag) to the absolute address in the
> block device in units of 512-byte sectors. However, Type 1 and Type 2
> ref tags are actually the least significant bits of the integrity
> interval number. On devices with integrity interval size > 512 bytes,
> the ref tag seed thus isn't the correct initial ref tag. The ref tag
> seed is correctly incremented/decremented in units of integrity
> intervals in bio_integrity_map_iter(), bio_integrity_advance(), and
> blk_integrity_interval().
>
> For REQ_OP_{WRITE,READ}, blk_integrity_{prepare,complete}() covers up
> this ref tag seed discrepancy by adding/subtracting the difference
> between the initial integrity interval and ref tag values to/from each
> ref tag in the protection information. However, REQ_OP_ZONE_APPEND can
> also carry PI but doesn't go through blk_integrity_prepare() because the
> final data location on the zoned block device isn't known until the
> operation completes. As a result, the REQ_OP_ZONE_APPEND PI ref tags
> start from the ref tag seed, which isn't in integrity interval units.
> Subsequent reads of the appended blocks will fail to remap the ref tags
> from the expected integrity interval numbers to sector numbers.
>
> Additionally, NVMe and many SCSI transports support offloading ref tag
> remapping to the device by specifying the expected initial ref tag in
> the command. The kernel doesn't currently take advantage of this, always
> remapping ref tags in software for reads and writes and setting the
> expected initial ref tag to the integrity interval. Setting the ref tag
> seed in units of integrity intervals would be a prerequisite to allowing
> the kernel to skip the software remapping and pass the ref tag seed as
> the expected initial ref tag in the command.
>
> So compute the ref tag seed in units of integrity intervals instead of
> sectors to avoid relying on ref tag remapping for the conversion.

Martin, are you okay with this updated commit message? Would be nice
to get this fix in so auto-integrity works correctly for zone appends
on 4KB-integrity-interval devices.

Thanks,
Caleb


>
> Fixes: 0512a75b98f8 ("block: Introduce REQ_OP_ZONE_APPEND")
> Signed-off-by: Caleb Sander Mateos <csander@purestorage.com>
> Reviewed-by: Anuj Gupta <anuj20.g@samsung.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> ---
>  block/bio-integrity.c | 3 ++-
>  block/t10-pi.c        | 3 ++-
>  2 files changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/block/bio-integrity.c b/block/bio-integrity.c
> index b23e2434d80c..d20f9002c7c9 100644
> --- a/block/bio-integrity.c
> +++ b/block/bio-integrity.c
> @@ -102,12 +102,13 @@ void bio_integrity_free_buf(struct bio_integrity_pa=
yload *bip)
>
>  void bio_integrity_setup_default(struct bio *bio)
>  {
>         struct blk_integrity *bi =3D blk_get_integrity(bio->bi_bdev->bd_d=
isk);
>         struct bio_integrity_payload *bip =3D bio_integrity(bio);
> +       u64 seed =3D bio->bi_iter.bi_sector >> (bi->interval_exp - SECTOR=
_SHIFT);
>
> -       bip_set_seed(bip, bio->bi_iter.bi_sector);
> +       bip_set_seed(bip, seed);
>
>         if (bi->csum_type) {
>                 bip->bip_flags |=3D BIP_CHECK_GUARD;
>                 if (bi->csum_type =3D=3D BLK_INTEGRITY_CSUM_IP)
>                         bip->bip_flags |=3D BIP_IP_CHECKSUM;
> diff --git a/block/t10-pi.c b/block/t10-pi.c
> index a19b4e102a83..e58d5eb6cefb 100644
> --- a/block/t10-pi.c
> +++ b/block/t10-pi.c
> @@ -308,18 +308,19 @@ static blk_status_t blk_integrity_iterate(struct bi=
o *bio,
>                                           struct bvec_iter *data_iter,
>                                           bool verify)
>  {
>         struct blk_integrity *bi =3D blk_get_integrity(bio->bi_bdev->bd_d=
isk);
>         struct bio_integrity_payload *bip =3D bio_integrity(bio);
> +       u64 seed =3D data_iter->bi_sector >> (bi->interval_exp - SECTOR_S=
HIFT);
>         struct blk_integrity_iter iter =3D {
>                 .bio =3D bio,
>                 .bip =3D bip,
>                 .bi =3D bi,
>                 .data_iter =3D *data_iter,
>                 .prot_iter =3D bip->bip_iter,
>                 .interval_remaining =3D 1 << bi->interval_exp,
> -               .seed =3D data_iter->bi_sector,
> +               .seed =3D seed,
>                 .csum =3D 0,
>         };
>         blk_status_t ret =3D BLK_STS_OK;
>
>         while (iter.data_iter.bi_size && ret =3D=3D BLK_STS_OK) {
> --
> 2.54.0
>
