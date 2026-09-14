Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C786F38B7A6;
	Mon, 14 Sep 2026 22:21:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789424503; cv=none; b=qtyeWlCiuK2js3nhWxFnLgCQU8dcRY1cMa8i5QojBs8LV/6Da0t6yMW33LtCejkXIV6d1DPmI2T2PS9GwBhs8nxQuXM2A35jRINNHK2Sq1LUVkIGKQDp/IF27L8g3Zhi/bUkRWOIB9N8SlbBe9IvKEjZc2ETPRAM8wrpo+ljqe8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789424503; c=relaxed/simple;
	bh=TxyqE9qSzKfbftv9np+eWXMq+Nx+z+yADqVfykR+bRw=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=K9KhoSaApd+2kzYw/DV7Wi70ol6NfNVe3o94750YvsX3p3FBlBRtdaGMCSWXjzfhcjLKuYFAJYdQHPPHBv/wHBrAV///E2T5hmEAYZfNPjZqqk6o+Vm+FkpWf8Tfu2MXYciQd1Cy2abxmpQ/mp9Ul07aItM4s00DrxbE/yJMLNk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TgzPu8za; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TgzPu8za"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC2121F000FF;
	Mon, 14 Sep 2026 22:21:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789424499;
	bh=TxyqE9qSzKfbftv9np+eWXMq+Nx+z+yADqVfykR+bRw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=TgzPu8zaFGNsdkBIdojqJ+pflk0NNEtGGpSgGWwxLKoPpSgf7VgjapuUFxxwMipRo
	 O4XJmmZieKI5h8G2jU5imAoCXXCJ5cef3fIBU9uw0qI/Km2lcOrmP7D3zL2QlNY/T8
	 Y2E2kd6urK7GHO4edzfVdlLNkM3R6075jjBP5N83k9iE26UeeN0OR0on5xD/Dyd9W2
	 dnSFlDlnL9db2mMYWsu+ppYpDgoicvhaCMAfqJGPctUtWpI7IJmrnT7J34b219t7jX
	 EcVU1T7q4bvOeDO8FvASbgzbL8TLTBTwD2jzEyh7YdTpNmt8Joak3G1of9v/oh3hDJ
	 /CpPVKaz/yzuA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 34/40] mm: eliminate VMA_SPECIAL_FLAGS usage when
 hugetlb explicitly tested
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TG9yZW56byBTdG9ha2VzIChBUk0p?= <ljs@kernel.org>
Cc: kvmarm@lists.linux.dev, bpf@vger.kernel.org, "Oliver Upton" <oupton@kernel.org>, selinux@vger.kernel.org, linux-s390@vger.kernel.org, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>, linux-rdma@vger.kernel.org, linux-trace-kernel@vger.kernel.org, "Heiko
 Carstens" <hca@linux.ibm.com>, "Alexander Gordeev" <agordeev@linux.ibm.com>, "Marc
 Zyngier" <maz@kernel.org>, linux-scsi@vger.kernel.org, linux-perf-users@vger.kernel.org, kvm@vger.kernel.org, "Vasily
 Gorbik" <gor@linux.ibm.com>, dri-devel@lists.freedesktop.org
In-Reply-To: <20260914-b4-mmap-prepare-vma-flag-sanify-v2-34-7d9781ed5361@kernel.org>
References: <20260914-b4-mmap-prepare-vma-flag-sanify-v2-0-7d9781ed5361@kernel.org>
 <20260914-b4-mmap-prepare-vma-flag-sanify-v2-34-7d9781ed5361@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 14 Sep 2026 22:21:38 +0000
Message-Id: <20260914222138.EC2121F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> It is now an invariant that VMA_IO_BIT is not set except by kernel-owned
> mappings, so each existing VMA_SPECIAL_FLAGS test need only test for
> VMA_DONTEXPAND_BIT, VMA_PFNMAP_BIT and VMA_MIXEDMAP_BIT.
>=20
> This is precisely a test for a kernel-owned or fixed mapping.
>=20
> Update a number of callsites which already explicitly handle hugetlb
> mappings.
>=20
> vma_supports_mlock() and ksm_compatible() also explicitly bail on droppab=
le
> mappings - detecting kernel-owned, fixed or droppable mappings is handled
> by vma_is_persistent(), so in these cases use this predicate.
>=20
> should_skip_vma() tests for locked, kernel-owned or fixed memory (having
> already excluded hugetlb mappings) so simply test for those there.
>=20
> No functional change intended.
>=20
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260914-b4-mmap-pr=
epare-vma-flag-sanify-v2-0-7d9781ed5361@kernel.org?part=3D34

