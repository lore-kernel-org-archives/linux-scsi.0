Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 743404C6D
	for <linux-scsi@vger.kernel.org>; Sat, 11 Jul 2026 15:14:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783782879; cv=none; b=sHfNxoOWZKMaemdSnL8yfhbMGIe3fTeW7wXpNffRqQy9BR/y8qWc+NnHST6PGopfm+JaOWINL7w3X2FYfN6myrDQNKWbkccCqcwJNyqNokUNKJ4mC7C1sgLkwBH3P3+5B38HcUv6krtXC+3LvzFQbVc0pxJZ9TEveTj+rn3Lmzs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783782879; c=relaxed/simple;
	bh=4TukFmOFHYjY8l6i9bLYTCYPI/aEqgtyISPnoCELzJY=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=uNWY5nYtITK5U3LCPqYsS42CugpnDSHUEbEaiLe8mR8ljpX3x7cUqHJUf0Cus95LhMqVU7Xlza+8U0qRBjXwIRWMYjpNUDXsVcKnKQEM6QyFYJbtCbEE3+sMwQkLMMwVHV12uIBHVT6y/FhbrhPu/hbWADYG80PbQBYorpgK5AM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DgkIxNw7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DgkIxNw7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC0711F00A3A;
	Sat, 11 Jul 2026 15:14:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783782878;
	bh=ZklACzRQzFzCKPXNp6u+U85nhVS/kQ6SulLE6sl/Oug=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=DgkIxNw7zs8Mt+U1tqDYq7q5bL6sGfLhWNTwU2LVkY5v5jLSo7pvM3sUBLiDPgMYr
	 vxrYh+Tr+Zay4VZta6h2XdWiuX2hDSi2mT1LFc2Z+Yfea11wja/dbR8fabppp3UuVh
	 q/EN60rj0wY0PlI/ub1z119ojmflknI93dgB461WOL5i46br301LiK2YNUppZvippv
	 1L8IFoBdMkXGuN33AkeVF4aEUHFOgynqBTOlFVmR4Y837bl8+KdjD/65Qy6Sqk3ooG
	 RikHf7LdlqQqW2auJQjukChxZ3ZUqIdQe+UG/0VZP41kHKP/1diGLJ1Veet3l2pdD8
	 sj1g0S+fVMsyA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] scsi: core: bound the VPD page 0x83 designator walk
Reply-To: sashiko-reviews@lists.linux.dev
To: "Michael Bommarito" <michael.bommarito@gmail.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260711150718.2916641-1-michael.bommarito@gmail.com>
References: <20260711150718.2916641-1-michael.bommarito@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 11 Jul 2026 15:14:37 +0000
Message-Id: <20260711151437.DC0711F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Missing descriptor payload length check in `scsi_vpd_tpg_id()` lea=
ds to an out-of-bounds read when accessing `d[6]` and `d[7]`.
--

--- Patch [1]: [PATCH] scsi: core: bound the VPD page 0x83 designator walk =
---
commit 390f380557d52bf9b1b813ffda5cbf376ee027a2
Author: Michael Bommarito <michael.bommarito@gmail.com>

scsi: core: bound the VPD page 0x83 designator walk

This commit fixes an out-of-bounds read in the VPD page 0x83 designator
walk by ensuring the designator length does not exceed the remaining bytes
in the page. It updates scsi_vpd_lun_id(), scsi_vpd_tpg_id(), and
sd_get_unique_id() to bound each iteration.

> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c

[ ... ]

> @@ -3546,8 +3554,14 @@ int scsi_vpd_tpg_id(struct scsi_device *sdev, int =
*rel_id)
>  		return -ENXIO;
>  	}
> =20
> -	d =3D vpd_pg83->data + 4;
> -	while (d < vpd_pg83->data + vpd_pg83->len) {
> +	for (off =3D 4; off < vpd_pg83->len; off +=3D d[3] + 4) {
> +		if (vpd_pg83->len - off < 4)
> +			break;
> +
> +		d =3D vpd_pg83->data + off;
> +		if (d[3] > vpd_pg83->len - off - 4)
> +			break;
> +
>  		switch (d[1] & 0xf) {
>  		case 0x4:
>  			/* Relative target port */
>  			rel_port =3D get_unaligned_be16(&d[6]);
>  			break;
>  		case 0x5:
>  			/* Target port group */
>  			group_id =3D get_unaligned_be16(&d[6]);
>  			break;

[Severity: High]
This is a pre-existing issue, but can this code read out of bounds if the
designator payload length is less than 4?

In scsi_vpd_tpg_id(), the switch statement unconditionally reads d[6] and d=
[7]
via get_unaligned_be16 without verifying that the designator length (d[3]) =
is
at least 4.

If a device or untrusted hypervisor backend provides a VPD page 0x83 contai=
ning
a designator with type 0x4 or 0x5 and a declared length (d[3]) of less than=
 4,
and this designator is positioned at the very end of the buffer, could the
fixed-offset read at &d[6] access memory out of bounds?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260711150718.2916=
641-1-michael.bommarito@gmail.com?part=3D1
