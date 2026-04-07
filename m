Received: from mail-oo1-f43.google.com (mail-oo1-f43.google.com [209.85.161.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86F5E3CF04A
	for <linux-scsi@vger.kernel.org>; Tue,  7 Apr 2026 16:49:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.161.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775580545; cv=pass; b=bNHR5aIz9k4dUoCmJhqJ4POMt84PFbQQpm50FZZdi1xkpBBbGY8Kc3BZXBeaVFp/vYUj0cSvnuZQyZwFfn8769Kib+IANmJdsu33BNa+wy2qYue+FpoocFpATonKV6ni6ZNNZU48OWZRbzJ88UONabEPljstIJjF5r3deZilY3A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775580545; c=relaxed/simple;
	bh=nvKu8su4QhAoCTShBYhb8X1jBL0vWh/vW/5aUOBwMVc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=BH3exDMmrCU0e4AnLpks+cfRE0XMezLtJpGUst/v2b/LDovqz1jsfLyZIsf4ZtCM0N6uDqdOlHj0kuLZocyCzoE/mqKj64e+FAEJ4DV6YmtY4b/aeh+jJYhCO+6LK0qEEpSQHcscmIcdJpYw1j8W54E28ZnKnRTlMx+BIERk/IE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=eFq1jPuB; arc=pass smtp.client-ip=209.85.161.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="eFq1jPuB"
Received: by mail-oo1-f43.google.com with SMTP id 006d021491bc7-68240e0d925so109677eaf.1
        for <linux-scsi@vger.kernel.org>; Tue, 07 Apr 2026 09:49:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1775580543; cv=none;
        d=google.com; s=arc-20240605;
        b=A8BSpsxWM42GY/DJyyUVXXDgpIQ7Y1Hra4ZcQuI3lYPBGsiR8q0R762QwNycoq4jkZ
         nFvBqdj6iyIK6GFrk/H/Jxw6ej3TyM8Ixfx/hGJv6AfPyox7DH1Ked/d+nfcHW6vcziz
         x9rsaPX5hy+eAfW9GspBoYPgjto6Cwg5Bdbc1UBCw+ku1IxTIdsL1ShLA+FdEEzspXkf
         v8Bol150lHHg52SPNI0HITj50US5j5ixRbgft2boC9NHd7tKMiIr8+VIyPtpToxKix5p
         RwC9/lEyVTOv4lE87ZVI0+2uWooA7E6AZCjJqJwSLZYkK0e572vvMr0ycylyAO+aeY8P
         XKNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=lazOyKwXnU60c9GoYfvLsxP7atxxk5CZ7DnVJNd+0g0=;
        fh=v0JVESs9CxXDzFvgtUkFgYdHZ1LF8SHjlq7hRQQxFNs=;
        b=MvulFe2ryoZzm6eGYDoNNZC76ekdAQOCsmWbeS/pjfmrYG8Iv95HFmQGakzxjxuZja
         3SZ0XSUMaiML3w5a3M+oZ4wGpgAN9k2rBEGwVv2ycwQGEib32Ec5OfPh2bBwWMsmtVsK
         tEd86lg9O7TlD1Bfw9XMgIXROT5SCulVJ6JFGPp56KNM0CL1xth+M5dsn/HAeQqrKFOS
         MNITrslkZ3U6mb82VMI8yDjRvAV7znbhgiEpiE2MM77K9VyTTb8AMBaaQB6IFECWujYh
         yEEtGBw43qohHSVDyUGnmYsyI+ZIq10ZyVb+baBuCoPZ4U/uZ1tl9tYeF6vJjEb6R+YX
         yxeA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1775580543; x=1776185343; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lazOyKwXnU60c9GoYfvLsxP7atxxk5CZ7DnVJNd+0g0=;
        b=eFq1jPuBo9/nXQu8b60SkzvJFVvLT/scrknaWk9UWNYCfgUBW8Ti7quPN9bDkfYgzN
         uDYU2CfoHdsBOL6mFDdh6tOjRLDJVT4p4QnVuQtN4Rw2haHQ62Stc+nymwh80Iqa/kwD
         sprpBmnP8iXMOpqYmkP80fJHHI0Ggke/VCUn4bHfmT2MMqGcu+j0lgDmkCMHMLG2DC10
         pfntEZI9ssUP6X7W8vdJxWpACRpfEKDp9jDutQ5M0bqoJnaK/X89rYIe8hekZzGSwm6r
         PiZcOILwEoNiHXFnDRT+L7WnUlPV6/w3YlaNcOTnfC31pEw2w81UXDH228q4lbhIPBSv
         TQ1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775580543; x=1776185343;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=lazOyKwXnU60c9GoYfvLsxP7atxxk5CZ7DnVJNd+0g0=;
        b=Sp8fizd3lLywkTKy044CO1xOQrH2XxHMQh99swZI9cI57C9WOJmpqO9OmTNvkXwx8C
         L2/BOkeo2qiPkGV99PTK4RMfzZOm6B/vaSrezZFXy0eVsf0M8Qqm91/hZekKKHaI/l2j
         QL9SAxTRjT8Dvqi2KDV+wOi5++1mNV4dXp/crac1eBSnFJeRtOB4uZYh6rt4XbGnKR3y
         m+k8k2MYCPsM9uKGZ8FfQ3jmpkaAO4Y2JAIY/xEV2GnULlRsBfRrMvAQE/XYW8x9LoN6
         yfgFBifZ2KhrWuhDQ7gCjK3Bc2LwgMEZnJbRMPJcg90lrArXO9xzZW4Wa8St2vGtolOU
         1npg==
X-Forwarded-Encrypted: i=1; AJvYcCW1cZANyBulV/tKNIeBtPr5r2/ugomVLjeSsPTzK5WqM5hIMaYb1A/JyaSzQQJzxyTzqjh1KwK+YXRo@vger.kernel.org
X-Gm-Message-State: AOJu0Yz5JZSn05QepLjXfTEzAWCSGWPYQ/esYpJ86X60Up7bFQBTvKcQ
	8IwS/A1/NC8Xfd000SseEvKER+jKTVOVDO3ZenSZrOSisDf5LGVFbruDJahUxZXGI3aRPNRXctr
	mqarTF4Gdj/VCOhYxVVqq+9vUcm6UNU7iE25fDhuQdA==
X-Gm-Gg: AeBDieu0PTBpSWo3I2yOIqaRAE3GO9B+Ejmu+9mgp/Fec9bjSdGrqCB2nNWiHHTpHFS
	JqiTiMyeKefeRLvP638Bi4cxohxNwBkfGE57jZVVA7LDCS3WZxvnBbNHAh+4YBPdXtr1SFy/TaI
	UebZZYrM9aMIU7NMQLhXcBmFcoQDsMqXFL4kkFxueg78FO6eaSVtX70AmiFCLzi7p1rTrpzQ0yt
	O+x6jDqemOZ6u8EsdhMnnTOokCkxhcIN3O4UXgegzdm4Of6vTJ93dv6wh59n9YivRFrTGW0Nw8i
	KHEkR3rq
X-Received: by 2002:a05:6820:858e:10b0:67c:3021:908a with SMTP id
 006d021491bc7-6821fa67067mr4123248eaf.3.1775580543405; Tue, 07 Apr 2026
 09:49:03 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260403194109.2255933-1-csander@purestorage.com>
 <20260403194109.2255933-3-csander@purestorage.com> <adNUE67FpIGF_x7Q@infradead.org>
In-Reply-To: <adNUE67FpIGF_x7Q@infradead.org>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Tue, 7 Apr 2026 09:48:52 -0700
X-Gm-Features: AQROBzCt_NO9LdYduvYfMd8GPp7cOALx7rkbussdP1UbmbwnR15kmHFzXdPpfAE
Message-ID: <CADUfDZqHyTDO6aYed+mtChU9m3iPgW=hghwfifuCV8Z_CzxoFQ@mail.gmail.com>
Subject: Re: [PATCH 2/6] block: use integrity interval instead of sector as seed
To: Christoph Hellwig <hch@infradead.org>
Cc: Jens Axboe <axboe@kernel.dk>, Sagi Grimberg <sagi@grimberg.me>, 
	Chaitanya Kulkarni <kch@nvidia.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-block@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org, 
	linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Apr 5, 2026 at 11:35=E2=80=AFPM Christoph Hellwig <hch@infradead.or=
g> wrote:
>
> On Fri, Apr 03, 2026 at 01:41:05PM -0600, Caleb Sander Mateos wrote:
> >  void bio_integrity_setup_default(struct bio *bio)
> >  {
> >       struct blk_integrity *bi =3D blk_get_integrity(bio->bi_bdev->bd_d=
isk);
> >       struct bio_integrity_payload *bip =3D bio_integrity(bio);
> >
> > -     bip_set_seed(bip, bio->bi_iter.bi_sector);
> > +     bip_set_seed(bip, bio_integrity_intervals(bi, bio->bi_iter.bi_sec=
tor));
>
> Should we simply switch bip_set_seed to take a bio bvec_iter argument and
> lift all this logic into it?  That feels a lot less fragile.

Perhaps I'm misunderstanding the suggestion, but how would that work
for initializing the seed from struct uio_meta in
bio_integrity_map_iter()?

bip_set_seed(bio_integrity(bio), meta->seed);

Thanks,
Caleb
