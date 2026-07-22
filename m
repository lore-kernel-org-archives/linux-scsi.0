Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F268369D59
	for <linux-scsi@vger.kernel.org>; Wed, 22 Jul 2026 20:39:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784752773; cv=none; b=FCD3+UIQBQESTjH0PIBJdCuWRivQOhKY33aoaMJ8ccXC2rwgCkQkPKi1wz9TkuN35Fr1l6aSvTvoBkOg80PYKOW5fLhAbr+YiuGwtVMKTJXy9sti0ToWk/yLgA0Rz0JbRdtdG9lu+LwoLePnOyUqFjiWUqOLQ3TgrF4vvk/zNX0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784752773; c=relaxed/simple;
	bh=6HON6ANjZeSu1uTzMcxnQMrrWyRZEK2yHSwiW3ev/tQ=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=UajxP3ZWjpB01euvFre/VkvPS9E3xsCpauzCOki0PzKNzWE0NNmPz+TfWBIpH4JWHgcXuZwnO93HkoqxLYa9nh2L1mXUAzL9KDu7CyzX0OpiJXXjbII8jcUhFQxAuMhz0FmRGv0D2TkGRwDIEsxBBPdykGUR7gMW4Swp7vnKwoQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oyFluLmf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oyFluLmf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C31E71F00A3A;
	Wed, 22 Jul 2026 20:39:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784752772;
	bh=uXq5DLxCwL4NKwydorBQFbc5tmn1w+L5aDobMkwR5Q0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=oyFluLmf08g+V7ixEIS7K4zykPx0KCMJhqAiDYY82ojlPbQS5GQ8Bx6tnvyfDR0zV
	 /Ac1AmxiM6GuFHa8iU3pcveCkGGPoPZ5PY8LkXmTHmNIn+fjw4bQWU4sN2MRZpDvUG
	 BsOiqYvhBHG555lF9/4y+N64Ad8Dy2d5+8oaTPcy/C31uj4S40Wy32R+qsFoD+hXlh
	 o5pZj9tYe1s8A7MsdvYNPzu1CCQ6gzlptBiAnzsntA0B4QtEqwUDqf9GTvlN7fN08P
	 lRkaI87+XJk2yqfOm7PWRzNE5GDhPaGMtNGkCVX2NPdYo6PbDBPBpIf/Lpl+axvr12
	 qLvzJEjK2q7vg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] scsi: smartpqi: add support for CCISS_BIG_PASSTHRU
 ioctl
Reply-To: sashiko-reviews@lists.linux.dev
To: "David Strahan" <david.strahan@microchip.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260722202327.5242-2-david.strahan@microchip.com>
References: <20260722202327.5242-1-david.strahan@microchip.com>
 <20260722202327.5242-2-david.strahan@microchip.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 22 Jul 2026 20:39:31 +0000
Message-Id: <20260722203931.C31E71F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] Unbounded user-controlled kmalloc and hardware transfer violation =
in pqi_big_passthru_ioctl
--

--- Patch [1]: [PATCH] scsi: smartpqi: add support for CCISS_BIG_PASSTHRU i=
octl ---
commit 76afabc08948098cc8542c214646dcdc2c4154bf
Author: David Strahan <David.Strahan@microchip.com>

scsi: smartpqi: add support for CCISS_BIG_PASSTHRU ioctl

This commit adds pqi_big_passthru_ioctl() to handle CCISS_BIG_PASSTHRU ioctl
requests. It allows larger transfer sizes by using BIG_IOCTL_Command_struct
which stores the buffer size as a 32-bit integer.

> diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpq=
i/smartpqi_init.c
> --- a/drivers/scsi/smartpqi/smartpqi_init.c
> +++ b/drivers/scsi/smartpqi/smartpqi_init.c
[ ... ]
> @@ -6918,6 +6918,144 @@ static int pqi_passthru_ioctl(struct pqi_ctrl_inf=
o *ctrl_info, void __user *arg)
[ ... ]
> +static int pqi_big_passthru_ioctl(struct pqi_ctrl_info *ctrl_info, void =
__user *arg)
> +{
[ ... ]
> +	if (iocommand.buf_size > 0) {
> +		kernel_buffer =3D kmalloc(iocommand.buf_size, GFP_KERNEL);

[Severity: High]
Since buf_size is a 32-bit integer controlled by userspace, can passing it
directly to kmalloc() with GFP_KERNEL cause page allocation warnings or
trigger memory pressure if the size is excessively large?

Could this allocation benefit from bounds checking or __GFP_NOWARN?

> +		if (!kernel_buffer)
> +			return -ENOMEM;
[ ... ]
> +	if (iocommand.buf_size > 0) {
> +		put_unaligned_le32(iocommand.buf_size, &request.buffer_length);
> +
> +		rc =3D pqi_map_single(ctrl_info->pci_dev,
> +			&request.sg_descriptors[0], kernel_buffer,
> +			iocommand.buf_size, DMA_BIDIRECTIONAL);

[Severity: High]
Does mapping the entire contiguous buffer into a single SG descriptor ignore
the hardware's max_transfer_size limits and the malloc_size chunking
mechanism?

The BIG_IOCTL_Command_struct is explicitly designed to break large transfers
into malloc_size chunks across multiple SG entries. This implementation
places everything into a single descriptor. Can sending an unchunked oversi=
zed
DMA request crash the controller firmware or cause a hardware hang?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260722202327.5242=
-2-david.strahan@microchip.com?part=3D1
