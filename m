Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AC6D511E69;
	Fri,  9 Oct 2026 18:47:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791571682; cv=none; b=GlmGDk8FbVzsa8LWicbaMhEXXeZ+PWp1/1qymIgFtC732zJ81bIevCGwuMyeM0MdIGYW8/cGE7soU2k7EPMvwgq2Jpexi9Y9DF+d62ySbodY948Y21RoQB6TljYpJC74ub4PFjeR+pvXmjOtWEBJn1F5kfAEegRmcVyX7XPZgNw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791571682; c=relaxed/simple;
	bh=7o1Drldq5ym6EDC7xi9J5yjzzRB9pRBrkx72VW4lTBM=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=aZt/VPAge3t5KU6F9oTDn/felrw/Q+y0e9+esTh1auGtv7nIIl3BhZe7pfOds8Cmizr0Hc3oVg/xe6wafNwBjFrGlkU734PfMLZVP0IdxNTwW/Dv35GnRjFPNuXf5vg+0jiuHYMQt0ekpeXByn1iG6LLpvoc6YNlnBRYb1lh+G0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KI6xx+o/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KI6xx+o/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B17B1F000FF;
	Fri,  9 Oct 2026 18:47:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791571675;
	bh=7o1Drldq5ym6EDC7xi9J5yjzzRB9pRBrkx72VW4lTBM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=KI6xx+o/Ry6CCfZrX5TIIve/pOHYuTSpAQgSeqw7PJtQaa3MbTkylRzXS+wCWpIci
	 RyMvUVmPzJ52MssnTeWpOQrYRuKoti9oyfZAJKnaWWr1RBJuxqdtNuJdUY0fjzRVkq
	 DTXW8bZX7LRcKTE6Qgw3DGJfLCPz/PdE6HS1gG+lK5grGesgRfoipHeeMIWHSRNI/b
	 1//NBzxR+a9bCLdo3AgPnAJY73DXj41l8QCzEtNLODcfFSgdr0FPyhAuQu/6BikzSt
	 kWr9WusgSgMzdBFtT8NsxdOI00YWUReQB10qqid4uKNky1QI/VWRPs5vpuXp4e3IPU
	 0Ulq1DbYsxwLg==
Message-ID: <sashiko-outbox-165973@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 33/38] mm: eliminate VMA_SPECIAL_FLAGS usage when
 hugetlb explicitly tested
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TG9yZW56byBTdG9ha2VzIChBUk0p?= <ljs@kernel.org>
Cc: "Alexander Gordeev" <agordeev@linux.ibm.com>, kvmarm@lists.linux.dev, linux-scsi@vger.kernel.org, bpf@vger.kernel.org, "Marc
 Zyngier" <maz@kernel.org>, "Vasily Gorbik" <gor@linux.ibm.com>, linux-trace-kernel@vger.kernel.org, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>, selinux@vger.kernel.org, linux-usb@vger.kernel.org, "Oliver
 Upton" <oupton@kernel.org>, kvm@vger.kernel.org, linux-rdma@vger.kernel.org, "Heiko
 Carstens" <hca@linux.ibm.com>, linux-s390@vger.kernel.org, linux-perf-users@vger.kernel.org, dri-devel@lists.freedesktop.org
In-Reply-To: <20261009-b4-mmap-prepare-vma-flag-sanify-v5-33-923b70125b1e@kernel.org>
References: <20261009-b4-mmap-prepare-vma-flag-sanify-v5-0-923b70125b1e@kernel.org>
 <20261009-b4-mmap-prepare-vma-flag-sanify-v5-33-923b70125b1e@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 09 Oct 2026 18:47:54 +0000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> It is now an invariant that VMA_IO_BIT is not set by mm-managed mappings,
> so each existing VMA_SPECIAL_FLAGS test need only test for
> VMA_DONTEXPAND_BIT, VMA_PFNMAP_BIT and VMA_MIXEDMAP_BIT.
>=20
> This is precisely a test for a fixed or non-mm-managed mapping.
>=20
> Update a number of callsites which already explicitly handle hugetlb
> mappings.
>=20
> vma_supports_mlock() and ksm_compatible() also explicitly bail on droppab=
le
> mappings - excluding non-mm-managed, fixed or droppable mappings is exact=
ly
> what vma_is_mm_backed() tests for, so in these cases use this predicate.
>=20
> should_skip_vma() tests for locked, fixed or non-mm-managed memory (having
> already excluded hugetlb mappings) so simply test for those there.
>=20
> No functional change intended.
>=20
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261009-b4-mmap-pr=
epare-vma-flag-sanify-v5-0-923b70125b1e@kernel.org?part=3D33

