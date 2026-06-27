Received: from mail-oa1-f52.google.com (mail-oa1-f52.google.com [209.85.160.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF9A4241686
	for <linux-scsi@vger.kernel.org>; Sat, 27 Jun 2026 06:44:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782542666; cv=pass; b=P95rGqnUi6YORe6ASyWh65QyeHo86m14gxEfWKD5u0yhTiwkB0gqBdDD/egcJr/hQcf61m0bt1iV9QA4DvE/5fOfOPDGXQwy2SEPZKwqLznYv2q5g+o6zEQrQwGDMZbeUOKCZk1BUBOY19c8lNJvC6Q//XA53zSbYtRquQ3nfT0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782542666; c=relaxed/simple;
	bh=WouwHE1R8U8JJEuE6C2SQ/+2+qm602jhJmCk2kVq6KQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hWMsCxwnczp6I8WEuSKX8svjVmzlPXEDNjRmOcTU3ZCfh1zcOYgKQixDOw440PJcb7Tsuu8Aw4gk+jpyhVHm32EofodoEDyA/ZPyVassr/gUp76MowqxMJ4LQINxyxWEEPFXBcPexG9Bxb5CftKsiUxf5X9EVnAGACbNrkOeWhA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=purestorage.com; spf=pass smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=IFVh20dI; arc=pass smtp.client-ip=209.85.160.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=purestorage.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="IFVh20dI"
Received: by mail-oa1-f52.google.com with SMTP id 586e51a60fabf-441049736aeso380578fac.1
        for <linux-scsi@vger.kernel.org>; Fri, 26 Jun 2026 23:44:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782542664; cv=none;
        d=google.com; s=arc-20260327;
        b=gqYJPdFFHw/Woyhc+ynoWX+8uyC7xZ4zlHP+nvaV+3jq/2jpRoU6KFH+ucOq0kmnu1
         sRTADlVphnnANkkr7FcHTX5ugjAJX+s0x93cOnwr1mfyFmq+mBxCN+UaUaBjzJJedjY7
         UzpuVVNw9HCqOE9o2Iz6rU8KpBnOhoEopIQ9mpeGsNh6b1t4YIgpjugPAfDzCxG74dFb
         rs0x/GRtzzLMFnGqtYGlrnEEjRNcBI6NvmgQloaJK5RKAx5lAOOj4JHb3alkIuCVEHNC
         UOtSyztvwNgbYZ2t7yj5I0cY0ev44vhVjehabJIuQC3fMnEmgnt4EzIBBye0Fw0U2Csf
         VcIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=PqJ9f6zF79jUlRWV2DsV7aIRWOIhIBa9bZOZESr1l8A=;
        fh=gUfsL9ppqjROwdjOOpA7gVU01au1qshFQ+BhECdF0Kg=;
        b=dhNAV7+ULZX7BjSjI9EUcWO6GfwTLCKBNxNutgwkkciZg1ylOop7FQt8fhv1ikm6B0
         gnxoxSfOrcwgAXpbtS2t2gkC28pfQCcgKpx0GKkRDApxrSCxWE5ui5xUhToDVKiw+Zau
         Ag2FQcm+uNaxJL73YTd13ehdmq7IWrXLZdsaiLr5JINZfise48uvaoAP9ITm4p8BTD4E
         1RLKc2xzF8OaU1N8WPJ/We7OkJ6gSUOCwMbirEmvHsEoszfHiQGqZKAQxXqqO46jmoZz
         IZzD/GTLDhdStgj5xqov+i7BX+HGBKAML8s3iDffCUvnODKMJIjg2mnUHo4/sRG2bmhb
         bDKg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1782542664; x=1783147464; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=PqJ9f6zF79jUlRWV2DsV7aIRWOIhIBa9bZOZESr1l8A=;
        b=IFVh20dIZ6ZIIbH17KZcgVA6LWaGpJPIQOVYaH+PSxKkvDSaVKsgBG9qsspAetYHWc
         9hy9bUiuqrynpwlvTLiIT1BafuuxlQJAT/j7VlAwJzDcihIW583d9W+UHZJGadRR9m/j
         EfKwuHV89Lt5hBpE0VdC83g3FkI2EUxsNzjn+6iqjGwYfvSzBeoY1H3z5JTEQOcDkCBB
         3+y4EtEuFdzC7eRc44Rvo5rjuB/ZgRxEbBzpgSYsxTpg7R5i96fLijnstrU/BmK6NP5y
         ijq9hvJ/3h7SiDQ9dq/OsWTgDhS+GaBZ+nXZ2t31U0nWvCeLhbxrf/wxhd4CfXpiykDa
         eeBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782542664; x=1783147464;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=PqJ9f6zF79jUlRWV2DsV7aIRWOIhIBa9bZOZESr1l8A=;
        b=QC7PRa1UjlnsmxiETBmkunKd0xsFefD0YOuR49pO//0IV09YzncHcsuLVsQnRFe73P
         pyMa7omfMH7/0ICOTlpQAz2Ni84HXC5AfeTbzym+tnlRN9VuVkS/4hAxGfzEp8qIr2fS
         vS0rAUAdkKCaj60/Q/rrE3rEUKeh2vfSvjaWA+i3h+zUK71uV0oryXjHtQVQ+tKcGX2y
         TGEYLlQBcFwVMLyPbzRIgnpXG2JA9WYcTwASEQGHgvxxNj8hMllMA+FTcto0ht1ZekFn
         becGu5fz275j54Esg6nuQu+fetQG4UuMT7stTSOhzvLjn3ZemFHP8GOwL66wcRptheKa
         xEJw==
X-Gm-Message-State: AOJu0Yyem06tBZfPTlXOEpckbpBD/S8JlNMDRPxxk03EY2emT6npGvsb
	4FRRlPWwup5yYGI9XWMkSfFatSi3+IAV50gvAJY5xYLjia5RM3EAQofqINedPoXx46J5QK9Y0VU
	PYYHKHNxZAMuvJWfwcmjhRmQfqywTwFFQXWmeWGj8kQ==
X-Gm-Gg: AfdE7cnNPwOMqOKSTYeJlJXLXMbBy0G/lem/roISPyvfVD/t/mdTpnaTAANvPcJXoGH
	QtTSG9i2lEvD89kR1/8z4wo+zpchZ0nki0KatkIVRi8q0GNiGHDRuMmcDUj6mxm9d1gbR2OXJBh
	76TmefNxKtN/9t+ZJ0XeXu6GTnG8JvVEXcYqc6w6HlMRezZ0SNG2Egn66xIuvaUPHhp5ZOqD5f3
	cKf7+D/UsGQ0CDoW/Jpep+8OR9zgecFL3EM5pbRaJMDYDpd9z5582eXHsW7YCI8Xk30YL4QXg==
X-Received: by 2002:a05:6830:6016:b0:7dc:c92d:975f with SMTP id
 46e09a7af769-7e99c2c3954mr5237814a34.7.1782542663550; Fri, 26 Jun 2026
 23:44:23 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260627054220.2174166-1-csander@purestorage.com>
 <20260627054220.2174166-4-csander@purestorage.com> <20260627055516.D92931F000E9@smtp.kernel.org>
In-Reply-To: <20260627055516.D92931F000E9@smtp.kernel.org>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Fri, 26 Jun 2026 23:44:12 -0700
X-Gm-Features: AVVi8CdF4ey9DwUemi-8_MWi9xL91q88EPfQDj5c8BCHtq_hCdh93CmdLkhChlM
Message-ID: <CADUfDZog=MMxOxen56t9QgDb=D3cA+r5W-SSEw+qXHVRqmphFA@mail.gmail.com>
Subject: Re: [PATCH v4 3/5] bio-integrity-fs: use integrity interval instead
 of sector as seed
To: sashiko-reviews@lists.linux.dev
Cc: linux-scsi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 26, 2026 at 10:55=E2=80=AFPM <sashiko-bot@kernel.org> wrote:
>
> Thank you for your contribution! Sashiko AI review found 1 potential issu=
e(s) to consider:
>
> Pre-existing issues:
> - [High] Unconditional dereference of `bip` and `bi` in `fs_bio_integrity=
_verify` and `fs_bio_integrity_free` causing a kernel panic.
> --
>
> commit 1da3b7d905f7d5c0c600e7d3a5fbf3cb0dc853c7
> Author: Caleb Sander Mateos <csander@purestorage.com>
>
> bio-integrity-fs: use integrity interval instead of sector as seed
>
> bip_iter.bi_sector is meant to be in units of integrity intervals rather
> than 512-byte sectors. bio_integrity_verify() doesn't actually use it
> currently (it uses the passed in struct bvec_iter's bi_sector instead).
> But let's set it to the expected value for consistency.
>
> > diff --git a/block/bio-integrity-fs.c b/block/bio-integrity-fs.c
> > index 9c5fe5fa8f0da..770eacb2220ff 100644
> > --- a/block/bio-integrity-fs.c
> > +++ b/block/bio-integrity-fs.c
> > @@ -67,7 +67,7 @@ int fs_bio_integrity_verify(struct bio *bio, sector_t=
 sector, unsigned int size)
> >        * bio.  Requires the submitter to remember the sector and the si=
ze.
> >        */
> >       memset(&bip->bip_iter, 0, sizeof(bip->bip_iter));
> > -     bip->bip_iter.bi_sector =3D sector;
> > +     bip->bip_iter.bi_sector =3D bio_integrity_intervals(bi, sector);
>
> [Severity: High]
> This is a pre-existing issue, but can this unconditionally dereference bi=
p
> and bi?
>
> Looking at iomap_bio_read_folio_range_sync() in fs/iomap/bio.c, it calls
> fs_bio_integrity_verify() and fs_bio_integrity_free() without validating =
if
> the integrity payload was actually allocated:
>
> fs/iomap/bio.c:iomap_bio_read_folio_range_sync() {
>     ...
>     if (!error)
>         error =3D fs_bio_integrity_verify(&bio, sector, len);
>     fs_bio_integrity_free(&bio);
>     ...
> }

fs_bio_integrity_verify() is only called if IOMAP_F_INTEGRITY is set,
which means fs_bio_integrity_alloc() was called earlier:

if (srcmap->flags & IOMAP_F_INTEGRITY)
        fs_bio_integrity_alloc(&bio);
error =3D submit_bio_wait(&bio);
if (srcmap->flags & IOMAP_F_INTEGRITY) {
        if (!error)
                error =3D fs_bio_integrity_verify(&bio, sector, len);
        fs_bio_integrity_free(&bio);
}

Which will allocate a bip unless bio_integrity_action() returns 0:

unsigned int fs_bio_integrity_alloc(struct bio *bio)
{
        struct fs_bio_integrity_buf *iib;
        unsigned int action;

        action =3D bio_integrity_action(bio);
        if (!action)
                return 0;

        iib =3D mempool_alloc(&fs_bio_integrity_pool, GFP_NOFS);
        bio_integrity_init(bio, &iib->bip, &iib->bvec, 1);

        bio_integrity_alloc_buf(bio, GFP_NOFS, action & BI_ACT_ZERO);
        if (action & BI_ACT_CHECK)
                bio_integrity_setup_default(bio);
        return action;
}

But IOMAP_F_INTEGRITY is only set in the first place the block device
supports a protection information guard tag, so certainly it supports
integrity (which means bi is non-NULL):

if (bdev_has_integrity_csum(iomap->bdev))
        iomap->flags |=3D IOMAP_F_INTEGRITY;

And thus bio_integrity_action() will call __bio_integrity_action() (if
the bio doesn't already have a bip attached):

static inline unsigned int bio_integrity_action(struct bio *bio)
{
        if (!blk_get_integrity(bio->bi_bdev->bd_disk))
                return 0;
        if (bio_integrity(bio))
                return 0;
        return __bio_integrity_action(bio);
}

Which I guess could return 0 if integrity verification is disabled:

case REQ_OP_READ:
        if (bi->flags & BLK_INTEGRITY_NOVERIFY) {
                if (bi_offload_capable(bi))
                        return 0;
                return BI_ACT_BUFFER;
        }
        return BI_ACT_BUFFER | BI_ACT_CHECK;

So it seems possible that bip might be NULL.

>
> If fs_bio_integrity_alloc() returns 0 without actually allocating a
> bio_integrity_payload, bio_integrity(bio) will be NULL. This can happen i=
f
> the device's integrity profile is unregistered concurrently, or if the
> operation doesn't require integrity checks.
>
> When that happens, fs_bio_integrity_verify() would dereference a NULL bip
> during the memset(&bip->bip_iter, 0, ...) call, and a NULL bi at the call=
 to
> bio_integrity_intervals(bi, sector). Similarly, fs_bio_integrity_free() w=
ould
> subsequently dereference bip on the same path.
>
> Could we add a check for a valid bip and bi before these accesses?
>
> >       bip->bip_iter.bi_size =3D bio_integrity_bytes(bi, size >> SECTOR_=
SHIFT);
> >       return blk_status_to_errno(bio_integrity_verify(bio, &data_iter))=
;
> >  }
>
> --
> Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260627054220.21=
74166-1-csander@purestorage.com?part=3D3
