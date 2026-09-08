Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D26D3B6352;
	Tue,  8 Sep 2026 20:42:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788900177; cv=none; b=Qof+jU+t3zI9fri+gW473Kbh9PQLLTxa23NtbeTbTcj67raKKVeBweBS3kqdDqWrSCk99WrjSwBHLuBf0/+ZEODXWVGV6CMCcIdWu3AdMHsEO4zaHqm1OuVbNkKLRdPLvljlIreHwg2HwNbxu8wvWhMDd1Q4XR9iuhZ4LyIHECE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788900177; c=relaxed/simple;
	bh=HPnuUPLge9NsP89LHUM1W/NUU4VwcdvDMeWDBqRiaoU=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=orHW4Q6CCz7lbXvycDvSeMvlLQBEq/Pm9lMYUHzc5qaVyplKvD+SGLM/Hwy1R2JelbPbD/MgV5vJ0hMEoYqvoTvKTocKyNIV3G3rNGpiBT07Qjj5Tw5XouKHBJv59Xn60rYk1cQphBc5lJCcUEgzXc59MQpUh7wHZUH/lWZVReU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gzG4DFce; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gzG4DFce"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AEA91F00A3A;
	Tue,  8 Sep 2026 20:42:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788900176;
	bh=HPnuUPLge9NsP89LHUM1W/NUU4VwcdvDMeWDBqRiaoU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=gzG4DFce0xQy5gOuNRxwgGMb97lIHOSIz0AuOpPXY6kkJzVRDVdI7eUegWWVd6SMf
	 j/hstwi8mv97hIKxlxjfO+SKolfBZtqS8z2OaEj3EicCft1e2ML9akPvsBqDoHpkeF
	 raCA1Zwyc1dIXNvdy+pWhh+8yOIR5rC+5Y/HESivYyOJBGIKm1C+XY09+eRhyj144C
	 7w3t6hoIPB1mmtYFlpir3E+9IfGboPr7OGCaIhvECuBHGYY+TPq0SrfHlIbPBZCsOV
	 x+ZuutBiAa1F0t3F2k7xQcCR8SaqjRiWDuRm1anjkIUDTGYllV7v5oGUCGZUTleIIi
	 shpQ5CXK9Bpkg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 33/39] mm: eliminate VMA_SPECIAL_FLAGS usage when
 hugetlb explicitly tested
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TG9yZW56byBTdG9ha2VzIChBUk0p?= <ljs@kernel.org>
Cc: bpf@vger.kernel.org, kvm@vger.kernel.org, "Heiko Carstens" <hca@linux.ibm.com>, dri-devel@lists.freedesktop.org, linux-s390@vger.kernel.org, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, linux-trace-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-perf-users@vger.kernel.org, kvmarm@lists.linux.dev, "Oliver
 Upton" <oupton@kernel.org>, "Vasily Gorbik" <gor@linux.ibm.com>, selinux@vger.kernel.org, "Marc
 Zyngier" <maz@kernel.org>, "Christian Borntraeger" <borntraeger@linux.ibm.com>
In-Reply-To: <20260908-b4-mmap-prepare-vma-flag-sanify-v1-33-dacf19cce22b@kernel.org>
References: <20260908-b4-mmap-prepare-vma-flag-sanify-v1-0-dacf19cce22b@kernel.org>
 <20260908-b4-mmap-prepare-vma-flag-sanify-v1-33-dacf19cce22b@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 08 Sep 2026 20:42:54 +0000
Message-Id: <20260908204255.5AEA91F00A3A@smtp.kernel.org>
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
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260908-b4-mmap-pr=
epare-vma-flag-sanify-v1-0-dacf19cce22b@kernel.org?part=3D33

