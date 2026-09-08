Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 922E33B1031;
	Tue,  8 Sep 2026 20:28:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788899329; cv=none; b=X1VSLVhQsx2c2DJUJ1aM3Ae31dCeOoOFuBrcKdSnZrGpMhLOT4/yx0zfT/T6uSHTWKiH/+8LjPSs322w7cSD1xtp8EkzZxOGS+QqZWtj0irwQNLjqZfaiPAur7K1/JEWCGeEYhoGDqbRjgMsWd/hFtY7z3jSAfRl7oZpaG6zpEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788899329; c=relaxed/simple;
	bh=S6tE0uEfipTaQVVjMdd6O5/Vs/dJ9VaNo2fdl5bbGRQ=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=A/nGNhJmhR/cs+ey7p7lA524TKJkkezQKw29HOmgaMIozsI2yIsxHhAhkRMHPerDlS7v0W49/aU7CHjiXEJRy94p8QMs0AjXsSq43M+l6mbgSCscq9ge+PjLAoIsPeR/MFP9zGZHy7hXcoGiliIOX2GONJQCc1jRkx2Km7En7NY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QIcU+TT4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QIcU+TT4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89CE71F00A3A;
	Tue,  8 Sep 2026 20:28:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788899324;
	bh=S6tE0uEfipTaQVVjMdd6O5/Vs/dJ9VaNo2fdl5bbGRQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=QIcU+TT4km55OlwvKPUi/HitbxQoemt2pIlAm9eZzSCggpxtY6fmb3BUKG59Q72IB
	 roECK+TdtDGYxye1yC29XAQ9+MzdmocReFcJ4r4tkNnSykIC8SHbjqGCZINuNM37nr
	 D2cSbqXmgDXRHbQp6RXTDcp0qGYYvoYppIzA5IJLdET/4qNPAqpeGujkjtV5M8ijU0
	 jAgJV0g1Pg+/PxM1JxabtVAg9sq/mcdHPEUqxJ1sbpDaqWrteDOjFNaHFUoGVN9Gz6
	 J4bR4d6653K+x88nBNyS0gA3sZ1XVPnzJdLwYpOE5U7mle36yWXGlWIYkJfPfZ9kaL
	 rCccthO2hghKQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 14/39] mm/vma: add vma[_flags]_is_kernel_owned()
 predicates
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TG9yZW56byBTdG9ha2VzIChBUk0p?= <ljs@kernel.org>
Cc: linux-trace-kernel@vger.kernel.org, "Oliver Upton" <oupton@kernel.org>, linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, dri-devel@lists.freedesktop.org, bpf@vger.kernel.org, "Vasily
 Gorbik" <gor@linux.ibm.com>, selinux@vger.kernel.org, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>, "Heiko Carstens" <hca@linux.ibm.com>, linux-perf-users@vger.kernel.org, kvm@vger.kernel.org, kvmarm@lists.linux.dev, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, "Marc Zyngier" <maz@kernel.org>
In-Reply-To: <20260908-b4-mmap-prepare-vma-flag-sanify-v1-14-dacf19cce22b@kernel.org>
References: <20260908-b4-mmap-prepare-vma-flag-sanify-v1-0-dacf19cce22b@kernel.org>
 <20260908-b4-mmap-prepare-vma-flag-sanify-v1-14-dacf19cce22b@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 08 Sep 2026 20:28:43 +0000
Message-Id: <20260908202843.89CE71F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> Rather than referring to VMA flags with uncertain meaning, add a new
> predicate that explicitly describes what possession of the VMA_PFNMAP_BIT
> or VMA_MIXEDMAP_BIT flags mean, and then refer to that function for
> determining VMA mergeability.
>=20
> Either flag means the contents of the mapping are owned by the kernel,
> usually a driver, rather than by the core mm: the memory may be MMIO,
> kernel-allocated pages or even ordinary pages the driver maps itself, but
> the core must not populate, reclaim, migrate, copy-on-write or merge the
> range on its own initiative.
>=20
> We initially also include VMA_IO_BIT here, as by implication, these must =
be
> kernel-owned. (mlock() also sets VMA_IO_BIT transiently on ordinary VMAs
> while locking them, which is addressed later in this series.)
>=20
> However the intent is to in future remove this, as no mapping should be
> marked as an I/O mapping without also being marked with VMA_PFNMAP_BIT.
>=20
> This forms the basis of further work intended to improve how we express V=
MA
> properties such as this.
>=20
> Also update the VMA userland tests to reflect the change.
>=20
> No functional change intended.
>=20
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260908-b4-mmap-pr=
epare-vma-flag-sanify-v1-0-dacf19cce22b@kernel.org?part=3D14

