Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08D0D4156C5
	for <linux-scsi@vger.kernel.org>; Thu, 23 Jul 2026 09:51:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784800262; cv=none; b=EYQbbGVBnHKLPJqv2BgJ2sdUb9WKDb5WRihcDv++bp4dUtwHxtE93aHRaXzFjD3rIwoRe7M1bCWyRCzqmPykQcQ+wQfYYUPWGYt8RB5rKXqccset8JzgAklDSWDKk7WX8hiTyNLAkvN2NcPS1hYj9iJPVuO1iEaJA67cxe9+Ri0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784800262; c=relaxed/simple;
	bh=SL1e9lmpeiq+NhbWKuFKvhqP7ZI8SvMsFhm5y/UkHi8=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=tTz/TB0DQGddwHkyZ6ybpZ5IPauGliWVQNxGs7yCa7NvSMancRcZPRBCAc2jEi+/na2UEV7LSHwCnvLG7HQoAPJyoPQspCTKqR/ikfRRHxdpf7p4TCcsWuWbQRl2kKCqSFT5bLL60EfNYKpx+7oUVp7c/TOulfAI9nWMCN2ok4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=P1U/cmzs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="P1U/cmzs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 677F01F00A3A;
	Thu, 23 Jul 2026 09:51:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784800260;
	bh=nsmwpNhnwNB9ru1nBa1AsZyGJ7mxgHp/VU7z3w8JMak=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=P1U/cmzsIzVNlWObu9tRpTLLG7Kl1yvUAn/LzcaiwaDKt5EUBUOfJb1iL26CE0CXX
	 ery5pu7ttDzu5+b4IFgmuq2O/aBTWY1Ka86cXnqEPYaCg0s05k9CUcVkFTXGQVG6mG
	 RTEHEM4dSqM41MdAa02bBruymt8i2Z2cw3Xgi8Uvj76htknRxTv6NXkWEcNaSFj4w/
	 YXFX3gglq27EivtiLiGlOKTAMJrTZ0DC8TL6Zb+JW/y+Ol1kcoWV/B6d5aTicn/W0H
	 /OvsRg5kg7AaknAcZzEhyDFziYMlXR/9J8gtfOzHerhXawxuHX6wTMboxRexDwjP5Y
	 8ps7z/nsQ3Aew==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 01/28] libmultipath: Add initial framework
Reply-To: sashiko-reviews@lists.linux.dev
To: "John Garry" <john.g.garry@oracle.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260723093627.2327456-2-john.g.garry@oracle.com>
References: <20260723093627.2327456-1-john.g.garry@oracle.com>
 <20260723093627.2327456-2-john.g.garry@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 23 Jul 2026 09:50:59 +0000
Message-Id: <20260723095100.677F01F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Low] The workqueue `mpath_wq` is allocated in `mpath_init()` but never u=
sed in the module.
--

--- Patch [1]: [PATCH v4 01/28] libmultipath: Add initial framework ---
commit 170d80e77c0bd0720941ff23ec89cb2a3960288f
Author: John Garry <john.g.garry@oracle.com>

libmultipath: Add initial framework

This commit adds an initial framework for libmultipath, a library for
multipath-capable block drivers. It includes basic support to add and remove
the head structure, mpath_head, and introduces the mpath_device structure.

> diff --git a/lib/multipath.c b/lib/multipath.c
> new file mode 100644
> index 0000000000000..9cc398d266adf
> --- /dev/null
> +++ b/lib/multipath.c

[ ... ]

> +static int __init mpath_init(void)
> +{
> +	mpath_wq =3D alloc_workqueue("mpath-wq",
> +			WQ_UNBOUND | WQ_MEM_RECLAIM | WQ_SYSFS, 0);

[Severity: Low]
Is this workqueue meant to be used in this patch?

The workqueue mpath_wq is allocated in mpath_init() and destroyed in
mpath_exit(), but no work is ever queued to it. Does this allocate an unused
resource, or is it intended to be used by subsequent patches?

> +	if (!mpath_wq)
> +		return -ENOMEM;
> +	return 0;
> +}
> +
> +static void __exit mpath_exit(void)
> +{
> +	destroy_workqueue(mpath_wq);
> +}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260723093627.2327=
456-1-john.g.garry@oracle.com?part=3D1
