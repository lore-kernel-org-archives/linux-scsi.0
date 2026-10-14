Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BB283D7D9F
	for <linux-scsi@vger.kernel.org>; Wed, 14 Oct 2026 16:39:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791995983; cv=none; b=SnESZbBtIF0/b4H5U3WRz5M0KPMaBTvf14XOc8Lyx85qjFNk8qG+WZQhu6ENge0ZptbR51yEJv0MwV/xsU/oK/7otckIWaSqgHNPy1mSGG/z2/pn5zQjd2s8J48p47uweSqkhBLpKw2+soGPiZBRrXkHGjI60c0QYO8LihxyAso=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791995983; c=relaxed/simple;
	bh=kQHju2ccYea81hNOD9+GtPW58tlHTKKw6MstYT+vvN8=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=sKrRbLDHtGHfGhpbzjC0zv+RwyJoZy9bymQabPwcnVxSBXOnuY87rDI2P5jYmiFdJ74E6PzlOjDfhuqGx1VN7vXZYaWsZvM24wAz32k0GHFqp+TfUCGgaX+55I+GJQVIr7Gy4WcXM/NyScjtG6uzThLR/KSgo0NEAaV7WfZb9JQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nM9u3ZMp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nM9u3ZMp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E8ED1F000C4;
	Wed, 14 Oct 2026 16:39:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791995981;
	bh=a9istGm0okFqLytv2+rEhKqRL8/7mddRC6aGzqPEBj0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=nM9u3ZMpZa4Y72X9KeJdcjNUfGHS3siIS4CszCJ1OQx9z9w2s+Qw3Y805qyG17tJW
	 0qt/tvB3B1CY2g9qnV3fYydfQ7NmpKeu2c3yfLQsA40aHMSGnEmgvPVlOlpNXs6evZ
	 QiH0KaZ9JcRmz2JISpInR7xTq2MfKfTFo2r60qygI71UhzeE79/JlD5zRto9OhpvCZ
	 5UZ4K0hJY+7KlCuD+FRwJGcf4s/W4T45j0RvOZ3vAULyKRx+sIyROdzhW6Byyqjp+S
	 4nK5CifcOo2XgCXrlgjBvI6yvidz6OrR5YrwD7s/wnj2bKmaqON+TNXU0g7bbyfpjA
	 UVDPaXqfKBKVw==
Message-ID: <sashiko-outbox-171547@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 3/5] scsi: mvumi: bound the hotplug event bitmap
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yehyeong Lee" <yhlee@isslab.korea.ac.kr>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20261014162413.3649841-4-yhlee@isslab.korea.ac.kr>
References: <20261014162413.3649841-1-yhlee@isslab.korea.ac.kr>
 <20261014162413.3649841-4-yhlee@isslab.korea.ac.kr>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 14 Oct 2026 16:39:41 +0000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] scsi: mvumi: unaligned memory access in find_next_zero_bit()
- [High] scsi: mvumi: unaligned bitmap access and overlap in hotplug event
--

commit 858b7c6c7bb4515208e9ef60baca2c850663e824
Author: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
scsi: mvumi: bound the hotplug event bitmap

This commit bounds the hotplug event bitmap to prevent the firmware from
reading past the event buffer. It checks the hotplug event size against
the expected structure length.

> diff --git a/drivers/scsi/mvumi.c b/drivers/scsi/mvumi.c
> index 2378b676a7a78..9a3dde53dea97 100644
> --- a/drivers/scsi/mvumi.c
> +++ b/drivers/scsi/mvumi.c
> @@ -1652,11 +1652,25 @@ static int mvumi_rescan_bus(void *data)
>  static void mvumi_proc_msg(struct mvumi_hba *mhba,
>  					struct mvumi_hotplug_event *param)
>  {
> -	u16 size =3D param->size;
> +	u16 size =3D READ_ONCE(param->size);
>  	const unsigned long *ar_bitmap;
>  	const unsigned long *re_bitmap;
>  	int index;
> =20
> +	/*
> +	 * The second bitmap starts size bits into the event buffer and
> +	 * find_next_zero_bit() reads it a long at a time, so that is the
> +	 * furthest the two scans reach.  Bound it by the length the firmware
> +	 * was told it may write, not by the buffer: the bytes past that are
> +	 * still zero, and a zero bit here means a device is present.
> +	 */
> +	if (sizeof(*param) + (size >> 3) + BITS_TO_LONGS(size) * sizeof(long) >
> +			sizeof(struct mvumi_event_req)) {

[Severity: High]
Does this code introduce an unaligned memory access and potential overlap
between bitmaps?

Looking at struct mvumi_hotplug_event, the bitmap array sits at a 4-byte
offset:

drivers/scsi/mvumi.h:
struct mvumi_hotplug_event {
	u16 size;
	u8 dummy[2];
	u8 bitmap[];
};

Since param->bitmap sits at a 4-byte offset within the DMA buffer, casting =
it
to unsigned long * and passing it to find_next_zero_bit() in mvumi_proc_msg=
()
will cause an alignment fault on strict-alignment 64-bit architectures.

Additionally, if the firmware provides a size that is not a multiple of 8,
does the size >> 3 offset truncate the remainder?

If truncated, re_bitmap will overlap with ar_bitmap's memory, which might
cause the same bits to be scanned for both device additions and removals.
This new bounds check explicitly relies on the size >> 3 offset without
accounting for the unaligned access or overlap.

> +		dev_err(&mhba->pdev->dev,
> +			"invalid hotplug event bitmap size %u\n", size);
> +		return;
> +	}
> +
>  	if (mhba->fw_flag & MVUMI_FW_ATTACH) {
>  		index =3D -1;
>  		ar_bitmap =3D (const unsigned long *) param->bitmap;

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261014162413.3649=
841-1-yhlee@isslab.korea.ac.kr?part=3D3
