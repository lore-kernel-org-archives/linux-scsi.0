Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FD543A963B;
	Sat,  3 Oct 2026 17:56:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791050201; cv=none; b=V8pZPo74fZJTDdMfWTEiMtxMPw1oMTYhYsQSUCdJvWuvclcoumNE8VJhQlRHT4+mytkgQIS7yaEJYm2W04BGJ5T9+heVMFa72exP/rICvAYYz+Kow13j7tZ14PW7p0E7ZtFS1Oj2yVKi9CF4unLqt60AUCnTybNlaxb2+2ZYGR8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791050201; c=relaxed/simple;
	bh=utuERKgoLep/cxcoh+Z99OIRN6MTbRAWgBJ7FwKKQ3g=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=osi+hE9T/a2mZPvkVbZegRVG2ydtvWgh8QJX9XWRivR0KdKm/N5BcsM1pQtJK/63hOTn9eAa4kxikd/32MpcMLH0MSEbGHqjXfqk0uGvqNxLY4Bfdn1kz9r4xKegbBFRaN4KUULvH8NTlZVV04XONHo+CwA4seJbvyr08eBrVrE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JiNAdyOQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JiNAdyOQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 551831F0089C;
	Sat,  3 Oct 2026 17:56:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791050198;
	bh=utuERKgoLep/cxcoh+Z99OIRN6MTbRAWgBJ7FwKKQ3g=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=JiNAdyOQAAfPgev6GAwuWFg0j/jEZRXVE16h+5zG9uQTh/zg/kxLuid0Ni0nfBsOf
	 wRie9rxC08JImIMAUuz+W0s2Ss0p12fMTRZXKKReYauFbH7IRWPj2Jt0ej5RBmMzmp
	 C+LzRaRJKeTIRxhAbg5ziOlftkCXprzQk6PbhR5uzxTj9QUF3hnrZ9E97AwpwVQOto
	 Kb/pW3Yiom60bOLHlxvzrd6cP6W12YoT382VRMS3N3cFdKEzoA+Tc0u7JtJ/u9h3ZO
	 9RLRH3zHjki5r2sy/9waMCnwbyjBWKnTIMn8DPfWIVXaXzgGpXN0ihbF6Y+GRiv67P
	 0TkkBvlENKMyg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 14/38] mm/vma: add vma[_flags]_is_mm_managed()
 predicates
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TG9yZW56byBTdG9ha2VzIChBUk0p?= <ljs@kernel.org>
Cc: "Marc Zyngier" <maz@kernel.org>, linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>, linux-trace-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org, bpf@vger.kernel.org, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, dri-devel@lists.freedesktop.org, kvmarm@lists.linux.dev, "Vasily
 Gorbik" <gor@linux.ibm.com>, kvm@vger.kernel.org, linux-rdma@vger.kernel.org, selinux@vger.kernel.org, "Heiko
 Carstens" <hca@linux.ibm.com>, "Oliver Upton" <oupton@kernel.org>
In-Reply-To: <20261003-b4-mmap-prepare-vma-flag-sanify-v4-14-a1f052500fd7@kernel.org>
References: <20261003-b4-mmap-prepare-vma-flag-sanify-v4-0-a1f052500fd7@kernel.org>
 <20261003-b4-mmap-prepare-vma-flag-sanify-v4-14-a1f052500fd7@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 03 Oct 2026 17:56:36 +0000
Message-Id: <20261003175637.551831F0089C@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> Rather than referring to VMA flags with uncertain meaning, add a new
> predicate that explicitly describes what absence of the VMA_PFNMAP_BIT and
> VMA_MIXEDMAP_BIT flags means, and then refer to that function for
> determining VMA mergeability.
>=20
> If neither of these flags are set, that means the contents of the mapping
> are managed by core mm.
>=20
> Otherwise they are instead owned by some other kernel component, usually a
> driver: the memory may be MMIO, kernel-allocated pages or even ordinary
> pages the driver maps itself, but core mm must not populate, reclaim,
> migrate, copy-on-write or merge the range itself.
>=20
> We initially also treat VMA_IO_BIT as implying a mapping is not mm-manage=
d,
> as by implication it cannot be. (mlock() also sets VMA_IO_BIT transiently
> on ordinary VMAs while locking them, which is addressed later in this
> series.)
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
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261003-b4-mmap-pr=
epare-vma-flag-sanify-v4-0-a1f052500fd7@kernel.org?part=3D14

