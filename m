Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90554489FDD;
	Sat,  3 Oct 2026 17:56:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791050215; cv=none; b=a54xYw01748Wz6BADyQF6ZxjcrCVJQ6c9P/FXOk9Ctv6VZhJzk9S8IC+9NZZrHDyzD+AtaYd1r9lPGti0tG1/y7nzCeeOXhSiG77oDZl4MsVBjMSWSdDQf4Ms5UIYXuPQITx+4w84ksJCG79/eRYaFVL8idFcrXo9py9NYqoZiM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791050215; c=relaxed/simple;
	bh=wUABm9EMjezdXKIokehHlzy+QEOSAsliDuXBFbXwkS8=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=gDzXRo0XgmHOzpWS5/Cx4x+uyw4l6nxDYkKPOLtE+i9sb4dUpIyXoECi4rfEpLNrqrPCoyS2yafrwdUpBES5IVDaiYDPIs8eKMcgjLPvK3nW3lyIBzD9zulYg55C2fIxZiNLcwAxyMhYlXBdGSuYL0vy5i7DLLer3UnzwvQNtuQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hjeeCpQ1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hjeeCpQ1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A203B1F0089B;
	Sat,  3 Oct 2026 17:56:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791050213;
	bh=wUABm9EMjezdXKIokehHlzy+QEOSAsliDuXBFbXwkS8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=hjeeCpQ1UlXlFAiYuA2C/sR4hoTmn30Mm8Emn8IQ0eSCvO7b52NN67wXUA6fcLDOG
	 fROTRLYg0mb4lpoXWMddY0Aj+Uqb4Le0Nt5zYp/wrRM2oOHY3yZ/fq3IV5ijcfbXdG
	 FvgBir88NLMQj/YjN04w7GZGzQZAlg75hm49yh8lFRRDn4F6lM0+3KreUxbk6Qe/rO
	 tVdtvXM62F74U5ov/hPwvFKK9Dyj3mfiP3y+XUAbLChTLzVIh4TYNm0F4HAU8Rpk1w
	 CwErgvNfLzc9xYJ+Pi9zp4QW8H0dQHW9jqjBUHCW+6s6d4Nfy7R/80DOgDwRFNjdFa
	 76LJ0toexCG5A==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 16/38] mm/vma: add and use
 vma_[flags]_is_fixed_mapping
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TG9yZW56byBTdG9ha2VzIChBUk0p?= <ljs@kernel.org>
Cc: dri-devel@lists.freedesktop.org, "Heiko Carstens" <hca@linux.ibm.com>, "Marc
 Zyngier" <maz@kernel.org>, "Alexander Gordeev" <agordeev@linux.ibm.com>, linux-rdma@vger.kernel.org, selinux@vger.kernel.org, "Oliver
 Upton" <oupton@kernel.org>, linux-scsi@vger.kernel.org, linux-trace-kernel@vger.kernel.org, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>, kvm@vger.kernel.org, bpf@vger.kernel.org, linux-s390@vger.kernel.org, linux-perf-users@vger.kernel.org, kvmarm@lists.linux.dev, "Vasily
 Gorbik" <gor@linux.ibm.com>
In-Reply-To: <20261003-b4-mmap-prepare-vma-flag-sanify-v4-16-a1f052500fd7@kernel.org>
References: <20261003-b4-mmap-prepare-vma-flag-sanify-v4-0-a1f052500fd7@kernel.org>
 <20261003-b4-mmap-prepare-vma-flag-sanify-v4-16-a1f052500fd7@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 03 Oct 2026 17:56:52 +0000
Message-Id: <20261003175652.A203B1F0089B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> This determines whether a VMA cannot be expanded or merged because what
> they mapped was determined to be a set size at mmap time.
>=20
> This typically refers to mappings not managed by core mm, however
> VMA_DONTEXPAND_BIT
> is not reliably set alongside VMA_PFNMAP_BIT or VMA_MIXEDMAP_BIT, so we
> must explicitly test for this for now.
>=20
> We also explicitly test for VMA_PFNMAP_BIT as VMA_DONTEXPAND_BIT may not =
be
> set for VMA_PFNMAP_BIT's despite the one implying the other.
>=20
> Use this predicate in vma_flags_can_merge() and in check_prep_vma() in the
> mremap logic testing to see if mremap() can expand the VMA. The criteria
> for khugepaged and MADV_COLLAPSE eligibility in
> __thp_vma_allowable_orders() are precisely those for mergeability, so use
> vma_can_merge() there (with an expanded comment).
>=20
> This obviates the need for the VM_NO_KHUGEPAGED mask, so remove it.
>=20
> Hugetlb VMAs remain excluded from khugepaged as hugetlbfs always sets
> VMA_DONTEXPAND_BIT.
>=20
> Also update the userland VMA tests to reflect the change.
>=20
> No functional change intended.
>=20
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261003-b4-mmap-pr=
epare-vma-flag-sanify-v4-0-a1f052500fd7@kernel.org?part=3D16

