Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 855FA33F590
	for <linux-scsi@vger.kernel.org>; Fri, 24 Jul 2026 15:28:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784906937; cv=none; b=R0AyzNyYcOfj0zHYGraV7fvVUP4IPT9R8dIVMs+hMPWB+dYm8+KrH1iF+k2xoab40T8v/62ydd1QMIp0U2FIrCoovP3G+1tjokxyvmwNIvKMDzVmAHCCgaMo3gZEXIrUlppjCVamChzTuB8m2Ab4BUne0ZMirkcFIxKBM+hpTMc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784906937; c=relaxed/simple;
	bh=58jsv2lQpSjwxp7pjQn4g3rkwX0VqMm8aIkNVQX6o/g=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=rmV2mZ9ohb3B4oeHNo8QHXCB7mi5xDlZsyYnH4ammie5icvHzbob8w7FQBfbOKwCZApuQ4lQ+qGUK4ssLBxNMJ1EFOsaqixKWzzXflcx2bOxlup4ZN17fJ06DGSA4DQPfVBMHGxoiMaL6jWv1Dg9a7QILfQlJiKCM5MNiglJVxA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eNNxc3ov; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eNNxc3ov"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F375F1F000E9;
	Fri, 24 Jul 2026 15:28:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784906936;
	bh=zUDwAhK5UC8uroV/rrueBC0Q3MYRVqxFUSsQ4PsM/RA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=eNNxc3ovdsvbTzj7e5JutvecArfqVIy2ZhFPS98+tCfG08d42fbFQj4FdUtwznGiv
	 xJFZNJ6Xs1OdeX3KJB7EcBNNUg7TVwACL2LzWoTRb8f0OWjxrAIshz8yj0wP0CT3gU
	 Jt4NcLMv/7QDslsguinYVMu31EWCHmibOIx6twbv1B2Gt5vjtBX8ePUIOSxIhc1dTc
	 ljPm9kzAVHjMuyM4gXyQgTYNCK5e2/aHcAdg8kF91nqYzR6vCmfAUZnYrmU6VaQj7W
	 dx0rAWJPgw6FfaGBNF8oPRXKDBHDkbmWrYXULO7H7xgIL/Di4gWrFA/tSUmsyLQCt5
	 RVSqaoqt/ZUgA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2] scsi: core: validate VPD 0x83 descriptor bounds
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jiancheng Huang" <jchuang@seu.edu.cn>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260724151331.1445730-1-jchuang@seu.edu.cn>
References: <20260724151331.1445730-1-jchuang@seu.edu.cn>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 24 Jul 2026 15:28:55 +0000
Message-Id: <20260724152855.F375F1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Out-of-bounds read and descriptor parsing flaw in scsi_vpd_tpg_id(=
).
- [High] Out-of-bounds read and heap information leak in sd_get_unique_id().
--

--- Patch [1]: [PATCH v2] scsi: core: validate VPD 0x83 descriptor bounds -=
--
commit 289135fc8a7b8af10f19120d2fe0f7e66ba6a211
Author: Jiancheng Huang <jchuang@seu.edu.cn>

scsi: core: validate VPD 0x83 descriptor bounds

This patch fixes an out-of-bounds read in scsi_vpd_lun_id() by ensuring
VPD page 0x83 descriptor headers and bodies fit within the retained page
before accessing them. It rejects truncated pages and stops parsing if the
declared length exceeds the remaining page buffer.

> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index daeb3693fe559..5e0b84e2d5813 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
[ ... ]
> @@ -3382,11 +3382,21 @@ int scsi_vpd_lun_id(struct scsi_device *sdev, cha=
r *id, size_t id_len)
>  		return -EINVAL;
>  	}
> =20
> +	if (vpd_pg83->len < 4) {
> +		rcu_read_unlock();
> +		return -EINVAL;
> +	}
> +
>  	memset(id, 0, id_len);
> -	for (d =3D vpd_pg83->data + 4;
> -	     d < vpd_pg83->data + vpd_pg83->len;
> +	end =3D vpd_pg83->data + vpd_pg83->len;
> +	for (d =3D vpd_pg83->data + 4; end - d >=3D 4;
>  	     d +=3D d[3] + 4) {
> -		u8 prio =3D designator_prio(d);
> +		u8 prio;
> +
> +		if (d[3] > end - d - 4)
> +			break;
> +
> +		prio =3D designator_prio(d);

[Severity: High]
This isn't a bug introduced by this patch, but it shares the exact same
vulnerability as the one fixed here in scsi_vpd_lun_id(). Could the same
issue occur in scsi_vpd_tpg_id() located in drivers/scsi/scsi_lib.c?

If a device returns a truncated VPD page 0x83, the loop blindly uses d[3] as
the descriptor length:

drivers/scsi/scsi_lib.c:scsi_vpd_tpg_id() {
	...
	while (d < vpd_pg83->data + vpd_pg83->len) {
		switch (d[1] & 0xf) {
		...
		d +=3D d[3] + 4;
	}
}

If the page length is short (e.g., 5 bytes), the loop executes because d st=
arts
at offset 4. It will then read d[1] and d[3] from beyond the bounds of the
declared VPD page. Should similar bounds checking be applied to
scsi_vpd_tpg_id() to prevent an out-of-bounds read?

[Severity: High]
This is a pre-existing issue, but does sd_get_unique_id() in drivers/scsi/s=
d.c
also suffer from this missing bounds check?

In sd_get_unique_id(), the loop executes without validating that the remain=
ing
bytes can hold a 4-byte descriptor header:

drivers/scsi/sd.c:sd_get_unique_id() {
	...
	for (d =3D vpd->data + 4; d < vpd->data + vpd->len; d +=3D d[3] + 4) {
		...
		len =3D d[3];
		if (len !=3D 8 && len !=3D 12 && len !=3D 16)
			continue;
		ret =3D len;
		memcpy(id, d + 4, len);
		...
}

It reads the descriptor length d[3] from out-of-bounds memory. If this
uninitialized heap byte happens to be 8, 12, or 16, the function uses memcp=
y to
copy out-of-bounds kernel heap memory into the id buffer. Since this buffer=
 can
be visible to userspace, could this result in a kernel heap information lea=
k?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260724151331.1445=
730-1-jchuang@seu.edu.cn?part=3D1
