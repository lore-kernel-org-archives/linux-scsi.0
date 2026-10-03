Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECC384A8A38;
	Sat,  3 Oct 2026 17:57:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791050244; cv=none; b=SPVqi6JnrGsWiW2XADWcX1G4h7jAeuEP6pmXV9TLVB1u0yMn19gqLzoJcMGbNQgb+c2yLlGPF8vg5zfmYXrQ9HDUUNogytGwk107+0Vwt9FLgyWkgIjksgBKiWOwmmu5EkC3b4BSq1INFCNj7VcEfrBy9zvc8Eggd8ttILEQcFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791050244; c=relaxed/simple;
	bh=7Um4pPBPzqQcMhGMaJ+OHmmN7XhRcKfHF8LaYrkwRCo=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=uiVmaNkSmUg5FZwJ8uxS67PYdvgKV+xNYMRs/UsNVJQmVx4yEvRUuVCalqvCXUaWWwSOvjBjR2unsUPww3BDlJp0lcWyx3fTOzhq2f3It8i7LlekSaLNDZFUL0gr2V5gE35PClXw1xIcID1wVn/mFWRoG0nrK1LiOx6cA3V8ZE0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PucaSBu+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PucaSBu+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40FB41F0089C;
	Sat,  3 Oct 2026 17:57:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791050242;
	bh=7Um4pPBPzqQcMhGMaJ+OHmmN7XhRcKfHF8LaYrkwRCo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=PucaSBu+zbZcpjr9Tb+bDQcwcTDGGmpceCXkF2W6EP0xKjFzNtiLKvvO783LoDZAJ
	 urxk3xJ1CHcyT/I5Zb7BwHaZ83IZZ32XtQQlivCxGrUyNhdtCgljx2SFEqVYagdP+c
	 qF5V+OxtHsC6/DOifSICaEvB6VCV1bCvSKmAW5aOXOBb2+/j9nSkzqPG0Htirwa95D
	 QodGt073U673QNMR9T050r7ql7HKlllBV+U37meYR0Fm7gP269yvG9WEZ050dFSh+K
	 ciFFf5B9m/GenDNcOlVgft1U80DGgYtBmqGiE1MHuPDLlqC0iQUmkozOVwRRnrg6Vi
	 M6sK4od/xbZ1A==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 33/38] mm: eliminate VMA_SPECIAL_FLAGS usage when
 hugetlb explicitly tested
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TG9yZW56byBTdG9ha2VzIChBUk0p?= <ljs@kernel.org>
Cc: linux-trace-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, "Heiko
 Carstens" <hca@linux.ibm.com>, bpf@vger.kernel.org, "Marc Zyngier" <maz@kernel.org>, linux-perf-users@vger.kernel.org, kvmarm@lists.linux.dev, dri-devel@lists.freedesktop.org, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, linux-s390@vger.kernel.org, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>, "Vasily Gorbik" <gor@linux.ibm.com>, linux-scsi@vger.kernel.org, "Oliver
 Upton" <oupton@kernel.org>, kvm@vger.kernel.org, selinux@vger.kernel.org
In-Reply-To: <20261003-b4-mmap-prepare-vma-flag-sanify-v4-33-a1f052500fd7@kernel.org>
References: <20261003-b4-mmap-prepare-vma-flag-sanify-v4-0-a1f052500fd7@kernel.org>
 <20261003-b4-mmap-prepare-vma-flag-sanify-v4-33-a1f052500fd7@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 03 Oct 2026 17:57:21 +0000
Message-Id: <20261003175722.40FB41F0089C@smtp.kernel.org>
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
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261003-b4-mmap-pr=
epare-vma-flag-sanify-v4-0-a1f052500fd7@kernel.org?part=3D33

