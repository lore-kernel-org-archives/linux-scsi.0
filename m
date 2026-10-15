Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13D703D4129
	for <linux-scsi@vger.kernel.org>; Thu, 15 Oct 2026 05:08:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792040907; cv=none; b=vAwYGdj01Iay1peNBVyNYsOBfxi+FmsGseLqH2YHYwS0U5ESu0D4Jg4kWbvUulcnYJ1aqoTFOm4ksBgp85sLeUdFKiy4t/ChO/mZtvjLiiM0q/v8zBHfg7Hzsubpedr/KO5srRrzm3iFqacAz7U3dyM2Hj0mznOezKpZZ17tBss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792040907; c=relaxed/simple;
	bh=fuRQYMQ/MzBHiWvepajRdX+NJQd1upRQMv3xP49vBFc=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=X5jpiMMY7bcyF8hASQWl9AOsPbEMlEaCFtOqiW9hwN1YbtY8FIEY/GgJk+D6wtHKYp4X6U+STbdTVrMcEdl5i5Z+dFmZfpK+Pby6n0uYWf3y7WPhtkBJq31jF7an6pgkw7UGDY63AFWqOIjxLYYZ1ghq2by+5p6TWMF9WdeU6Ug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RrNAxE9W; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RrNAxE9W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66C3A1F000C4;
	Thu, 15 Oct 2026 05:08:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792040905;
	bh=SCUoMToQnLM24H+QAN1g4qWOWig75m3A3o3rJzR2/Kw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=RrNAxE9WX9ua+6aTdfWtgm4ZikldbJWfG02Og1S3E0yfLFW4jQddJzvSN5fAw/Hiu
	 S+ifXK5noQq60gk3+gZlzAUQhzihDXK3pP5tbrSprlUvKAThs1DH7Vy5KPyaLZmQMM
	 mzhBy+IKmQf6FBvtpzcqS3z/9G4bJ15cBQ82TjoqxE1YGcdud3vet8Tde87BNHLuzz
	 j49pFCXu5IfqgD0Kvm8HdeC1+DOajYiI77+6QagM/PkAvFOn57LePjq7sa23tRDnSW
	 kQCEjmUvCzhi1geoAdtPFFvfQhAIUu8u4mfVd0A2Y/cBhNCtzWlMTA7n8Yn8ufWMOg
	 MxbzwHAoyWmng==
Message-ID: <sashiko-outbox-172296@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v9 3/9] scsi: mvumi: bound the hotplug event bitmap
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yehyeong Lee" <yhlee@isslab.korea.ac.kr>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20261015045213.3975845-4-yhlee@isslab.korea.ac.kr>
References: <20261015045213.3975845-1-yhlee@isslab.korea.ac.kr>
 <20261015045213.3975845-4-yhlee@isslab.korea.ac.kr>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 15 Oct 2026 05:08:25 +0000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] scsi: mvumi: missing endian conversion for param->size
--

commit 67e2f811bb5307d634893d7bcc1a4ae7f4bb47eb
Author: Yehyeong Lee <yhlee@isslab.korea.ac.kr>

scsi: mvumi: bound the hotplug event bitmap

This commit adds a bounds check to mvumi_proc_msg() to prevent scanning
past the allocated event buffer. It reads the size parameter from the
hotplug event and rejects events where the size exceeds expected limits.

> diff --git a/drivers/scsi/mvumi.c b/drivers/scsi/mvumi.c
> --- a/drivers/scsi/mvumi.c
> +++ b/drivers/scsi/mvumi.c
> @@ -1652,11 +1652,25 @@ static int mvumi_rescan_bus(void *data)
>  static void mvumi_proc_msg(struct mvumi_hba *mhba,
>  					struct mvumi_hotplug_event *param)
>  {
> -	u16 size =3D param->size;
> +	u16 size =3D READ_ONCE(param->size);

[Severity: Medium]
Does param->size require an endianness conversion like le16_to_cpu() here?

If the Marvell hardware writes the event buffer in little-endian format
during normal hotplug events, reading param->size natively on a big-endian
host would yield a heavily swapped value.

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

[Severity: Medium]
Since the newly added bounds check in mvumi_proc_msg() relies on this
size value, would an incorrectly swapped size on big-endian hosts cause
this check to spuriously fail and reject valid hotplug events?

> +		dev_err(&mhba->pdev->dev,
> +			"invalid hotplug event bitmap size %u\n", size);
> +		return;
> +	}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261015045213.3975=
845-1-yhlee@isslab.korea.ac.kr?part=3D3
