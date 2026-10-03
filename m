Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FFB54A485F;
	Sat,  3 Oct 2026 17:57:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791050239; cv=none; b=Mg7byo61P4gtyjmGmXia050Cj7OSHT9b8xVD19mya3LuszKVLdnQut0aFCoAN0mvfZ0ymX53jzhfTt2m2uc2GSBpoQ2cErB7nwdjaT3E+c33n4whfArTMkV0cvOidCNmQvVudPwfAWu17qDwQiITUmFwlc5wMjBOY7GjEFO4gTc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791050239; c=relaxed/simple;
	bh=0mxsnUa9XVZw7tAYkGSJyqCMKbxZYuDBVrOKZUgJJK0=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=FWEOTv+AX5bc7v1SSd/El37yiK49Jm8XdfF74ZnhRqgDmfapIRuiIcZPWl+1RtZuXlCdaq99HjFLqdJ73ldtUTyOPHoVwzOUe9qSvX/6BhQTJVD4iQcZhlVnlSFu7CfTDj0CmQApPNcVOIYGr4zAVMqTESxKykMJ+sGsnYFjxUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iPAg4ffC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iPAg4ffC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 465DD1F008BD;
	Sat,  3 Oct 2026 17:57:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791050238;
	bh=0mxsnUa9XVZw7tAYkGSJyqCMKbxZYuDBVrOKZUgJJK0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=iPAg4ffCGQa76+RxgZDCA2VwMkgafBfFsECijlMW9IyK6gyRRCWwDOD5GlUklSiLo
	 9hUNjVT6IHAJe5udZ8RBy4NHuoPGXXEVxoRgS+3KIbCG00hy9pRe07RUzyoXStkTiN
	 y/+V84A2JgN16tPY2y2GzOFAScwEOd9QswNgs1IRyfoXgmk9bS7lvXSOzVetfvThUy
	 UJxgh5TEhzSBgCHA0pbYh3cNHanZ0YA4gw48kkqFbYMkKTYg7IwmTIbWfqCijwr2zy
	 nXpIc5SILHJ8Pv9/YpB2fqiyeQ7256HEEFg/1CuWW96hmoIrizXwHjsdC5y0wv5slB
	 U7y9glXpF7nmw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 38/38] mm/huge_memory: remove vma_is_special_huge()
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TG9yZW56byBTdG9ha2VzIChBUk0p?= <ljs@kernel.org>
Cc: "Vasily Gorbik" <gor@linux.ibm.com>, kvmarm@lists.linux.dev, "Marc
 Zyngier" <maz@kernel.org>, linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org, selinux@vger.kernel.org, linux-perf-users@vger.kernel.org, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>, "Heiko Carstens" <hca@linux.ibm.com>, dri-devel@lists.freedesktop.org, bpf@vger.kernel.org, "Oliver
 Upton" <oupton@kernel.org>, kvm@vger.kernel.org, "Alexander Gordeev" <agordeev@linux.ibm.com>, linux-scsi@vger.kernel.org, linux-trace-kernel@vger.kernel.org
In-Reply-To: <20261003-b4-mmap-prepare-vma-flag-sanify-v4-38-a1f052500fd7@kernel.org>
References: <20261003-b4-mmap-prepare-vma-flag-sanify-v4-0-a1f052500fd7@kernel.org>
 <20261003-b4-mmap-prepare-vma-flag-sanify-v4-38-a1f052500fd7@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 03 Oct 2026 17:57:16 +0000
Message-Id: <20261003175717.465DD1F008BD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> vma_is_special_huge() tests whether either the VMA_PFNMAP_BIT or
> VMA_MIXEDMAP_BIT is set (i.e. whether the VMA is not mm-managed),
> but with a DAX carve-out.
>=20
> DAX however no longer sets VMA_MIXEDMAP_BIT, so this carve-out is no long=
er
> required.
>=20
> Therefore test for !vma_is_mm_managed() instead and also drop the
> VMA_IO_BIT check, as it is now redundant since it is enforced that
> mm-managed mappings may not set VMA_IO_BIT.
>=20
> This also eliminates another overloaded use of 'special' within mm.
>=20
> No functional change intended.
>=20
> Acked-by: Zi Yan <ziy@nvidia.com>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261003-b4-mmap-pr=
epare-vma-flag-sanify-v4-0-a1f052500fd7@kernel.org?part=3D38

