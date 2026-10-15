Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1ACDA214A84
	for <linux-scsi@vger.kernel.org>; Thu, 15 Oct 2026 02:42:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792032176; cv=none; b=pwtnVGT0fHjkiKZDAWub0oYfFErbDY45QsImGg2orJ0n/oBdPxg2uc6AObihqXKCddsALMg0vAAsh8aoOt1rSHHu/5y27Gj1TuQCzG2ToTdJC3TM6Mi63J/UJ2HnI2jAJiUmuDL47Slgp5dmp1wLKPJNrcvDiePDASmCfJFpxwI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792032176; c=relaxed/simple;
	bh=1bY7krlzMHHtL57PS2lognJOHE+VAl/otBvqMoJbxAA=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=ieETQNjqLfH58NfMSOqNSAasHN6Y/9uqLErN2p0KOqsZVoOU8odCOSl/obK40X407a+OSW2BTClLxdzlectjZaudmvfp9IubtIVD1VWd4qRRh4ALtaUa9sb1l9FZWOOSzfVz3pfU17t4e6iIy+sTBHmTq6DYUeT3tdZJc8fFglY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=K2uTEC2H; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="K2uTEC2H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72EEF1F000C4;
	Thu, 15 Oct 2026 02:42:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792032174;
	bh=Kt6phADSrkBMk2Uoshm2zEZwbupyfyoDIUr5SMwQJxY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=K2uTEC2HfKuZaigW2wLyui9sg/kLPE4pCAlJxzmOo6dExQ+dHHF3H7zKgaEwL1oFG
	 /YMLIR5PJ3eZJ5I7k7LkysCyGHcGMZ9g9Ta/+Gcxzb89ITu6Iyz8eRR02JOyInfjfo
	 6pjDiUIWqd7WuMIXf8QNX3BHm2r+1CTipqwC3ZmaJRdpWUQP4Nzz7n/4ipBd+J2b03
	 kSutw1BkHkhu2+H+1OHPyzPiNWlcXaq/jbBfrL5CEIqXeg09cpqHBrExlZxBCj6xHr
	 dx9ca0QSKdEp6sK+bth0VGiU+WS5vr1+mK0M9XzZv/qefsDe2o0X+Nz9ftiM8x20/O
	 GNZuZwnENz9nw==
Message-ID: <sashiko-outbox-172172@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v8 3/8] scsi: mvumi: bound the hotplug event bitmap
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yehyeong Lee" <yhlee@isslab.korea.ac.kr>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20261015022728.3936714-4-yhlee@isslab.korea.ac.kr>
References: <20261015022728.3936714-1-yhlee@isslab.korea.ac.kr>
 <20261015022728.3936714-4-yhlee@isslab.korea.ac.kr>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 15 Oct 2026 02:42:54 +0000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] scsi: mvumi: missing endianness conversion for firmware size field
--

commit 0540965519d7ac3e42a8417f0ff4a18ecbdc0c77
Author: Yehyeong Lee <yhlee@isslab.korea.ac.kr>

scsi: mvumi: bound the hotplug event bitmap

mvumi_proc_msg() takes size from the hotplug event the firmware DMAs into
the event buffer and uses it twice: as the bit count for two
find_next_zero_bit() scans, and as the byte offset of the second bitmap.
This commit rejects a size whose bitmaps do not fit within the event buffer
to prevent the driver from reading past the allocation.

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

[Severity: High]
Does this code miss an endianness conversion for the firmware size field?

The hardware firmware provides a little-endian size, so on big-endian
architectures, a valid small size (e.g., 0x0040) is natively read as a
massive byte-swapped size (0x4000) when le16_to_cpu() isn't used.

Because of the newly introduced bounds check below, this inflated value will
now fail validation, discarding the valid hotplug event entirely and render=
ing
the driver unable to register attached devices.

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
> +		dev_err(&mhba->pdev->dev,
> +			"invalid hotplug event bitmap size %u\n", size);
> +		return;
> +	}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261015022728.3936=
714-1-yhlee@isslab.korea.ac.kr?part=3D3
