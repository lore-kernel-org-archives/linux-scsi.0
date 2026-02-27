Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49C74274B46
	for <linux-scsi@vger.kernel.org>; Fri, 27 Feb 2026 01:34:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772156093; cv=pass; b=YE8qVFyJVy3zCeQLjytlPrBdAP8dZySqK1QOMI2Qx9lm5wdS1Bpyad3sAnAJn0UDuyAbCCyv5HccdwN6nCexmQT7urhj3APXPLDGW+jq3VIJM2nVwgHhRE/zSxjpmt6Rw/MDkym/f+PH3WCyQC8ofluZVGM2tqsn08e2JlyVaX8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772156093; c=relaxed/simple;
	bh=z+/M+lo5ksz1TRd449byu/D3ls0drNyd6IdGp40lVms=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jQShjAUv8n0YvAnjMdEzyYHkThPpF73MiRdi4Gq8I5Id2XhHp1vrhtA4sc1w7N1k8fLq0298pNffX2PYU1J343wcCXKNrYXhHNsYLUW3v1Vicfy6zyy9tD1tQZ6e79C2POT+tB8Lk2a6m7iT7npUkKee49kgIxvbFM9al6d1GSI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=BeRI+Wh5; arc=pass smtp.client-ip=209.85.208.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="BeRI+Wh5"
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-65fe2d2b744so4655a12.1
        for <linux-scsi@vger.kernel.org>; Thu, 26 Feb 2026 17:34:52 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772156090; cv=none;
        d=google.com; s=arc-20240605;
        b=gQQrjJ+KHhJ9vSCr85hXl1sd/iXKo+IXH5tF/G6Po1lWY+Gu+Y511IL28il8ytfrXm
         qtywyzhpkhi44b6pDB+1uPvpasH4E2jGsfvNTS9HBoiWjh6b7GTwmqd3U6yd29u07IsR
         VFn2RG+JxViEmYKD3Okhunm6tjZThNsQ2cBV75VSsY2F/7dvwbU0zTRgdvewueG8NNjt
         TgUnyttNcVu9NqFz+GuHwmV+jLkTZ0r6jjmJrxT+4f0nM7uT3U9tArZ1NHMefU45Kwxh
         a/L2JY63L9g0uw44cLjhqPNbblr5Fk9xA7A55vTbm2uOgnOGdnPkc3TsHrgXaAjQxhFa
         ulhw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=1Xe9R0FTdq/8KgfEwhSHbjVGMoqD5nAmJr57+aBN6PM=;
        fh=wwZlXBB3tw/yLjLfyk7YPR5nRNOu/xtxWy9+Lf161wo=;
        b=QH5A0MKXMH52WkhGRJ6ZokbusjO10RytmQTg2n7IM1D0CKvI78MfudiX6fzbgm9PXs
         JsKN1pkkyvVkp1CZNCjan9lVaXFT4UcmG3jbOAM8reUE+/zJ0x1Ps80tQoNILeaFUh6l
         keqimWIxqOMEr9vNLJYs5oHMe9EV3sWKqpXfDn8e6zsssX4sJLIt5ie8VLEfqYVW07Gm
         b9yrNgGbMx2wnHngIASaRjs4Oh0yr4nN76tK/rFdKi3Pc0yi4mD4hnXNT5BizG8xjm62
         Qw0fM9OeZoodVHvs3eql9AgYipkfiV1s0Vsf8p4HRH07JGBc8R+4FzCaHjWegq9Bj+sd
         Z9nA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772156090; x=1772760890; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1Xe9R0FTdq/8KgfEwhSHbjVGMoqD5nAmJr57+aBN6PM=;
        b=BeRI+Wh5WTJFXPpAO//O5/1HAJ5+vou94hrn7khhu1RzG/2/bODRUMJv4V/u6eTbfW
         NreLdbIWJzpRyRed7cFqkyd2iek3ahMqM0JpuQLl1tbgNtxBub7PyJdyMTk9RW3XC718
         iDlkX5DjV0vBvLAhlNxlLUbyhsOjjClbCMHWa2BtkA7KlgGhyRIQ7WbYmiX9YxOOJP1C
         FfJFHM+qV0Yk1FJNxESiwAMA2CDgQZOPgTquekLKY85lJxN/E4dqKeyPhssMiBUobQZO
         AHiFRWWqCGHDb8NuMRnTNie2mZB4KaE2Px0zGiAw4SrnZefetlY9RbSHRygqetVUVXYi
         PB3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772156090; x=1772760890;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=1Xe9R0FTdq/8KgfEwhSHbjVGMoqD5nAmJr57+aBN6PM=;
        b=ep2lhGSk3ZAuBTjbyKD8Kp+YhT67bH8m7DjrHEsjwQRRg1xc0sgBvtcSyVEKIySPZX
         AVctboJa5/xredbYGw5RQiNG0ORVqzWz1zlzFwi5MWG3SFJFY/Z6fuFU1B1xVqP5zas+
         JqfJ+vAVSPIO03iYGn7/86DcLSqE+QseF0OwOO5aAzBrX7yOTmwp99Fc8q8Lleubf4BL
         JhSDz5s1ffliBv8Iwva3Lfz0wEBqns+ramPIdZqt4vL8kHN0DZgo7rLGVCL+07EULMAZ
         8C0W9SsRCsoJm9qNBoMjv1wXdUPoMI2walTqhVF8k/O+SGDYGjt1AOXPoSKOheHIsdFf
         yilQ==
X-Forwarded-Encrypted: i=1; AJvYcCW1Z81zFAwQFUsxRNrQasZl8Ua3JbxjLPgMaGCdg+Z2qn5fVHTdZ5N7Op4KMvx56nmKE2ekvcpJaEse@vger.kernel.org
X-Gm-Message-State: AOJu0YzSf2OE4WLtVRDI7YkYE/bGyy0WjRy5ihH/Z38Iw5Wspw1Yw3IP
	BVSdjDvmdd6o7N6NRxOSXu5p4wBrUtrWQwbmvXIWKateuNnqpdT8AbatgmnFZuqXQLcQy/bcF9I
	Jmg6D+MxJXgABc+b7stuV4gt9+JQI7Sr4mv6qK3xG
X-Gm-Gg: ATEYQzyMI5GDT7eZriHqrQ+aRNEizOzQS7LQsGbcXqK5ciV8hcRQMot2w1VG3WUnhUL
	av/mBIGQ1kvqkOSntNWDGFe9574Q58DzoB20OFou8X0pa1xt8wpaeMdUbFa0D4Qppg2gGNqTqK+
	6+wWGR/Ab6VeofsDqa3AaUgxHh8wfaUUDH6UWVf8q25xxhEUO71qMhmf5/RwnusfOCdTdVdNrVe
	QEB4NAsuJCdrhYu6y9ePOM6f3cawZFQnkOM9vgmLEtc+JwnLH3I6dtL3U3DDMboOnjZjYlTK3bo
	HhmUopc1kS5HB9ale8M3yPMeFS3eWeOg0bYr5w==
X-Received: by 2002:a05:6402:4619:10b0:65f:76c8:b92f with SMTP id
 4fb4d7f45d1cf-65fab2c4155mr103050a12.0.1772156090158; Thu, 26 Feb 2026
 17:34:50 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250619111806.3546162-3-yi.zhang@huaweicloud.com>
 <20260225000531.3658802-1-robertpang@google.com> <7d2a3f65-4272-46c1-991a-356f0d2323cb@huaweicloud.com>
 <CAJhEC05L7QEc9iY7gFZVK3SPYvFhtFyURss6xQgZ-qWwZZkFjA@mail.gmail.com> <8a45c55f-8abe-4cdf-be70-208550edf320@huaweicloud.com>
In-Reply-To: <8a45c55f-8abe-4cdf-be70-208550edf320@huaweicloud.com>
From: Robert Pang <robertpang@google.com>
Date: Thu, 26 Feb 2026 17:34:38 -0800
X-Gm-Features: AaiRm52oy9vcXDycCt3HX0a8oowZo0wXmgzHk3BLllBwVjMbefXMCEMxh3i5upc
Message-ID: <CAJhEC04Vpo96SKN7iRjV0fUKXEj3oQ698RdoVAdWjRjVLpgvGw@mail.gmail.com>
Subject: Re: [PATCH v2 2/9] nvme: set max_hw_wzeroes_unmap_sectors if device
 supports DEAC bit
To: Zhang Yi <yi.zhang@huaweicloud.com>
Cc: Zhang Yi <yi.zhang@huawei.com>, bmarzins@redhat.com, brauner@kernel.org, 
	chaitanyak@nvidia.com, chengzhihao1@huawei.com, djwong@kernel.org, 
	dm-devel@lists.linux.dev, hch@lst.de, john.g.garry@oracle.com, 
	linux-block@vger.kernel.org, linux-ext4@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org, 
	linux-xfs@vger.kernel.org, martin.petersen@oracle.com, 
	shinichiro.kawasaki@wdc.com, tytso@mit.edu, yangerkun@huawei.com, 
	yukuai3@huawei.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Dear Zhang Yi

On Thu, Feb 26, 2026 at 3:09=E2=80=AFAM Zhang Yi <yi.zhang@huaweicloud.com>=
 wrote:
>
> On 2/26/2026 5:43 AM, Robert Pang wrote:
> > Dear Zhang Yi
> >
> > Thank you for your quick response. Please see my comments below:
> >
> > On Tue, Feb 24, 2026 at 6:32=E2=80=AFPM Zhang Yi <yi.zhang@huaweicloud.=
com> wrote:
> >>
> >> Hi Robert!
> >>
> >> On 2/25/2026 8:05 AM, Robert Pang wrote:
> >>> Dear Zhang Yi,
> >>>
> >>> In reviewing your patch series implementing support for the
> >>> FALLOC_FL_WRITE_ZEROES flag, I noted the logic propagating
> >>> max_write_zeroes_sectors to max_hw_wzeroes_unmap_sectors in commit 54=
5fb46e5bc6
> >>> "nvme: set max_hw_wzeroes_unmap_sectors if device supports DEAC bit" =
[1]. This
> >>> appears to be intended for devices that support the Write Zeroes comm=
and
> >>> alongside the DEAC bit to indicate unmap capability.
> >>>
> >>> Furthermore, within core.c, the NVME_QUIRK_DEALLOCATE_ZEROES quirk al=
ready
> >>> identifies devices that deterministically return zeroes after a deall=
ocate
> >>> command [2]. This quirk currently enables Write Zeroes support via di=
scard in
> >>> existing implementations [3, 4].
> >>>
> >>> Given this, would it be appropriate to respect NVME_QUIRK_DEALLOCATE_=
ZEROES also
> >>> to enable unmap Write Zeroes for these devices, following the prior c=
ommit
> >>> 6e02318eaea5 "nvme: add support for the Write Zeroes command" [5]? I =
have
> >>> included a proposed change to nvme_update_ns_info_block() below for y=
our
> >>> consideration.
> >>>
> >>
> >> Thank you for your point. Overall, this makes sense to me, but I have =
one
> >> question below.
> >>
> >>> Best regards
> >>> Robert Pang
> >>>
> >>> diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
> >>> index f5ebcaa2f859..9c7e2cabfab3 100644
> >>> --- a/drivers/nvme/host/core.c
> >>> +++ b/drivers/nvme/host/core.c
> >>> @@ -2422,7 +2422,9 @@ static int nvme_update_ns_info_block(struct nvm=
e_ns *ns,
> >>>          * require that, it must be a no-op if reads from deallocated=
 data
> >>>          * do not return zeroes.
> >>>          */
> >>> -       if ((id->dlfeat & 0x7) =3D=3D 0x1 && (id->dlfeat & (1 << 3)))=
 {
> >>> +       if ((id->dlfeat & 0x7) =3D=3D 0x1 && (id->dlfeat & (1 << 3)) =
||
> >>> +           (ns->ctrl->quirks & NVME_QUIRK_DEALLOCATE_ZEROES) &&
> >>> +           (ns->ctrl->oncs & NVME_CTRL_ONCS_DSM)) {
> >>                                 ^^^^^^^^^^^^^^^^^^
> >> Why do you want to add a check for NVME_CTRL_ONCS_DSM? In nvme_config_=
discard(),
> >> it appears that we prioritize ctrl->dmrsl, allowing discard to still b=
e
> >> supported even on some non-standard devices where NVME_CTRL_ONCS_DSM i=
s not set.
> >> In nvme_update_disk_info(), if the device only has NVME_QUIRK_DEALLOCA=
TE_ZEROES,
> >> we still populate lim->max_write_zeroes_sectors (which might be non-ze=
ro on
> >> devices that support NVME_CTRL_ONCS_WRITE_ZEROES). Right? So I'm not s=
ure if we
> >> only need to check for NVME_QUIRK_DEALLOCATE_ZEROES here.
> >>
> > The check for NVME_CTRL_ONCS_DSM is to follow the same check in [3]. Th=
ere, the
> > check was added by 58a0c875ce02 "nvme: don't apply NVME_QUIRK_DEALLOCAT=
E_ZEROES
> > when DSM is not supported" [6]. The idea is to limit
> > NVME_QUIRK_DEALLOCATE_ZEROES
> > to those devices that support DSM.
> >
>
> OK.
>
> >>>                 ns->head->features |=3D NVME_NS_DEAC;
> >>
> >> I think we should not set NVME_NS_DEAC for the quirks case.
> >>
> > Make sense. In that case, will it be more appropriate to set
> > max_hw_wzeroes_unmap_sectors in nvme_update_disk_info() where
> > NVME_QUIRK_DEALLOCATE_ZEROES is checked? I.e.
> >
> > diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
> > index f5ebcaa2f859..3f5dd3f867e9 100644
> > --- a/drivers/nvme/host/core.c
> > +++ b/drivers/nvme/host/core.c
> > @@ -2120,9 +2120,10 @@ static bool nvme_update_disk_info(struct
> > nvme_ns *ns, struct nvme_id_ns *id,
> >         lim->io_min =3D phys_bs;
> >         lim->io_opt =3D io_opt;
> >         if ((ns->ctrl->quirks & NVME_QUIRK_DEALLOCATE_ZEROES) &&
> > -           (ns->ctrl->oncs & NVME_CTRL_ONCS_DSM))
> > +           (ns->ctrl->oncs & NVME_CTRL_ONCS_DSM)) {
> >                 lim->max_write_zeroes_sectors =3D UINT_MAX;
> > -       else
> > +               lim->max_hw_wzeroes_unmap_sectors =3D UINT_MAX;
> > +       } else
> >                 lim->max_write_zeroes_sectors =3D ns->ctrl->max_zeroes_=
sectors;
> >         return valid;
> >  }
> >
>
> Yeah, it looks good to me.

Thank you for your confirmation. I will follow up and submit the patch
to other maintainers for their review.

Best regards,
Robert

> Best regards,
> Yi.
>
> > Best regards
> > Robert
> >
> >> Cheers,
> >> Yi.
> >>
> >>>                 lim.max_hw_wzeroes_unmap_sectors =3D lim.max_write_ze=
roes_sectors;
> >>>         }
> >>>
> >>> [1] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.gi=
t/commit/?id=3D545fb46e5bc6
> >>> [2] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.gi=
t/tree/drivers/nvme/host/nvme.h#n72
> >>> [3] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.gi=
t/tree/drivers/nvme/host/core.c#n938
> >>> [4] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.gi=
t/tree/drivers/nvme/host/core.c#n2122
> >>> [5] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.gi=
t/commit/?id=3D6e02318eaea5
> > [6] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/=
commit/?id=3D58a0c875ce02
>
