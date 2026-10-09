Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADE174F68AD;
	Fri,  9 Oct 2026 18:40:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791571270; cv=none; b=JBVgDnxtlSjBU2DaUPDoK1GHjwoyRmpkNnFZo+FXUKIPhVqBqFOSBeHIctZYKtJJoiAbvf+E25DGhtDUi7ZxSuB5zsvd3GCKNrVuM07NWorYUfOWgDabAeAunHaKc6fhcLfv8zXbwQCMwPkmH2TlkC+mlS1D4oSnqIxY0RoEnfI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791571270; c=relaxed/simple;
	bh=CbUuwLNvkSUIssFDvORMfbSyMCT9GgkV9uxRHbTo96s=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=F32sQAps522dR31NcdUIYGB2gCbBM8Yvo5BtEMoBDJCKmiurfbO63LERecqB6HVCJK+SSN9TW2R2dfzuevjvdUIMA5Ye0UwKsfrJzcyWNX1Xekmp276ZQ044A8Oo6DRrKNm1U76otg7LRz2/yKUTUeQ9/oZKM7jn1SvTYdl7hB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=E4Y08uAp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="E4Y08uAp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F3931F000FF;
	Fri,  9 Oct 2026 18:40:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791571257;
	bh=CbUuwLNvkSUIssFDvORMfbSyMCT9GgkV9uxRHbTo96s=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=E4Y08uAp2X0TJ1+UXhnwyLBOaYf7PZOjfr1WXqfyl3ns5RUHkbX26GBAP2513qsnu
	 ZyunRZPfqjQsFhAJT2oElKuCJcjBNlxYDd6Z13rF8RjjwU2oJ4QFI4u+JG1EUpCYAw
	 l2wjmhumC0qphVQ/4oukfaXW/V5Rj1mETecHWDMOj6ttZhHDGk0Hp5lG+2lsxM05hh
	 QAsuB9XB1AGet5jN3NVr6ZtCvEImjL/H8oUDZYhLZbUbvp36e1SUh4FaPIcHfNUCo0
	 jsd5m0WIG0KNwB4S35j6otn3l43D7wh/EXXorKGmYCoFXH89FNQZSP8509XwDcGEdH
	 ubYqvKuz4z0tA==
Message-ID: <sashiko-outbox-165961@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 22/38] mm/mlock: clear VMA_LOCKED_MASK over mmap
 callback
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TG9yZW56byBTdG9ha2VzIChBUk0p?= <ljs@kernel.org>
Cc: "Heiko Carstens" <hca@linux.ibm.com>, linux-trace-kernel@vger.kernel.org, linux-usb@vger.kernel.org, linux-perf-users@vger.kernel.org, linux-s390@vger.kernel.org, "Oliver
 Upton" <oupton@kernel.org>, kvmarm@lists.linux.dev, bpf@vger.kernel.org, dri-devel@lists.freedesktop.org, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>, "Alexander Gordeev" <agordeev@linux.ibm.com>, linux-rdma@vger.kernel.org, "Vasily
 Gorbik" <gor@linux.ibm.com>, "Marc Zyngier" <maz@kernel.org>, kvm@vger.kernel.org, linux-scsi@vger.kernel.org, selinux@vger.kernel.org
In-Reply-To: <20261009-b4-mmap-prepare-vma-flag-sanify-v5-22-923b70125b1e@kernel.org>
References: <20261009-b4-mmap-prepare-vma-flag-sanify-v5-0-923b70125b1e@kernel.org>
 <20261009-b4-mmap-prepare-vma-flag-sanify-v5-22-923b70125b1e@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 09 Oct 2026 18:40:55 +0000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> Currently there's a confusing mess around VMA_LOCKED_BIT and
> VMA_LOCKONFAULT_BIT.
>=20
> It is permitted for drivers to set any flags they like, with the VMA
> already possessing lock flags.
>=20
> This results in the absurd situation of a VMA possessing both
> VMA_SPECIAL_FLAGS and VMA_LOCKED_MASK flags, which is not permitted.
>=20
> This has resulted in mlock_vma_folio() having a very silly check for this
> scenario to work around it.
>=20
> There is no need for this - just clear the flags before invoking the hook
> and reinstate them afterwards if they are required.
>=20
> Nothing relies upon this being set during the mmap operation.
>=20
> mmap_prepare is unaffected by this so requires no fix.
>=20
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261009-b4-mmap-pr=
epare-vma-flag-sanify-v5-0-923b70125b1e@kernel.org?part=3D22

