Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B0F851AFDA;
	Fri,  9 Oct 2026 18:29:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791570607; cv=none; b=fySH11pyGd8Fv1Tzur2OlygtQp9LI1oh7V4KLXoJ676nTI1m6650gITiUo18nNBG8AB+JDQt4R/SKj/TnjxM02j4cnlWB84PcTWZVxL9B3TwK05pBjBrYBr9F9bfXy/AU609jYys8q0iClQHlL4jWJZSIfNm/g69VzeshYm1Be8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791570607; c=relaxed/simple;
	bh=D135us/EzyIcaFiwVjMoComriRxqTzNReNuNS5rfgmY=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=MHjdWrz7c42r1uWmSKFYPg4bEpC7R/4eR9UhaEsazkvwQ9Dv5Xd2pn5d1ypKC2HOzQJg1+4SQ+nmyCSbD1hMvNSJFIO8PGJMJsT8xzA5Rat/hv7OSUXqyeOhO2rX5l5PzwFvWyUdN6mshMCZ3B+juSv3dRCSA32wUEqLxG722wU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LyzhLYXo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LyzhLYXo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BE4B1F000FF;
	Fri,  9 Oct 2026 18:29:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791570598;
	bh=D135us/EzyIcaFiwVjMoComriRxqTzNReNuNS5rfgmY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=LyzhLYXo//22UoCiTK0Rx7zMu5p/Vm4aqjtiG8e5cvo2dRKAI3XUEvsXmreGBXAh7
	 XD4JS7duc32FTn4bL7Hck5+iWkkPsCKwW0ckrX2xLeYyxGVkKcp3BZMa+tR8An+FXn
	 W7E+YBQaXpeLhh2JObz7f2Hla1Gikux+m/Pp/tM70JJXGlnzdQybboUV553kYNdsAM
	 YTB14fP4Pa58oQ+Rp5Z6jNre3rhJ9GknimSNUMnKeYYGYyNPIUxseoH1OjwKCinF34
	 ltRaVKIj7jBUVNu0LLLVG+T8QWW2Q+j46Ke+oTnvC3gTapyh7BTF4WpizOZ+/45VZ7
	 A4OnXSVidOSGA==
Message-ID: <sashiko-outbox-165948@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 16/38] mm/vma: add and use
 vma_[flags]_is_fixed_mapping
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TG9yZW56byBTdG9ha2VzIChBUk0p?= <ljs@kernel.org>
Cc: linux-trace-kernel@vger.kernel.org, kvmarm@lists.linux.dev, "Vasily
 Gorbik" <gor@linux.ibm.com>, "Oliver Upton" <oupton@kernel.org>, "Heiko
 Carstens" <hca@linux.ibm.com>, linux-perf-users@vger.kernel.org, "Marc
 Zyngier" <maz@kernel.org>, "Alexander Gordeev" <agordeev@linux.ibm.com>, linux-scsi@vger.kernel.org, selinux@vger.kernel.org, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>, bpf@vger.kernel.org, dri-devel@lists.freedesktop.org, linux-rdma@vger.kernel.org, kvm@vger.kernel.org, linux-s390@vger.kernel.org, linux-usb@vger.kernel.org
In-Reply-To: <20261009-b4-mmap-prepare-vma-flag-sanify-v5-16-923b70125b1e@kernel.org>
References: <20261009-b4-mmap-prepare-vma-flag-sanify-v5-0-923b70125b1e@kernel.org>
 <20261009-b4-mmap-prepare-vma-flag-sanify-v5-16-923b70125b1e@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 09 Oct 2026 18:29:56 +0000
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
> Reviewed-by: Suren Baghdasaryan <surenb@google.com>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261009-b4-mmap-pr=
epare-vma-flag-sanify-v5-0-923b70125b1e@kernel.org?part=3D16

