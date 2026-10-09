Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2791135E1C5;
	Fri,  9 Oct 2026 18:47:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791571660; cv=none; b=B0L6mRTeTC4CQMLW9WeeqYRhiJG3o0iH9sD50ftVwggXbh83nuOghHxgfihxKgW7jBBTLdyJgyu0jQ62VISPd91dGn6Lqz9uW8ppfUSBMDlPIVhD8pS27y7zM09TdhfeOmMK6Yey/y3Jo2r7lnatvTdXLgHPAhfvMdPTzAZU/Ss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791571660; c=relaxed/simple;
	bh=mLlOFaw/IlJZnvJ/4xxpVCtKs3elyFr6/EuYxK+WsAw=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=O+D5m1WQ+8GBV1dYDOI+X4mTBJTNpa0qxwC+CSQ7Ab7i4A0hMrIQ6rHu5GUhE2VPzuRkmK44beGzRdmnenO98mhs6Zoy8kziMkomA+F6S7QUSMj50eTvY44zbYirC49p+gVXtt72M5Mlb8o+Vzt3pf+7nH709lpg3cwdh4jf8k4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HLqJTBNT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HLqJTBNT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6C861F000FF;
	Fri,  9 Oct 2026 18:47:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791571658;
	bh=mLlOFaw/IlJZnvJ/4xxpVCtKs3elyFr6/EuYxK+WsAw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=HLqJTBNTQI+DMSuFOj7AqNFJPmjCsLNI/umMw+QNgwVgaLZlsBcDqiHahrE2PcNv1
	 kqZkhRrN/kDmCtQnsXSSaaT8ga6dT9tFJAwfV+9f9oMuHy1If9uuX5es7diAu3W8sS
	 +dX1b9JMhQMPVlCpbrM9xmL0xp21DKimVpTg3G5OhakXTY1xmjiJLKfJN1P1Gpv6gA
	 fcJ5Kd61r/ENOVuDCagyA/i/laFHRXNNqUrsrrK66WagciziwnY8mjSrpZ0kIkaWLz
	 j/rSdVYAxJ2/0Z+IB0s22fCLlfKRymRSVJ+4l2ouCDQYA97/B+pGwrUdIwcFFRY2qd
	 WWZ6k9ekmOWkA==
Message-ID: <sashiko-outbox-165972@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 32/38] mm/madvise: use predicates for madvise(...,
 MADV_DOFORK)
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TG9yZW56byBTdG9ha2VzIChBUk0p?= <ljs@kernel.org>
Cc: linux-usb@vger.kernel.org, "Vasily Gorbik" <gor@linux.ibm.com>, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, linux-scsi@vger.kernel.org, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>, kvmarm@lists.linux.dev, selinux@vger.kernel.org, linux-s390@vger.kernel.org, linux-trace-kernel@vger.kernel.org, kvm@vger.kernel.org, "Marc
 Zyngier" <maz@kernel.org>, "Heiko Carstens" <hca@linux.ibm.com>, "Oliver
 Upton" <oupton@kernel.org>, bpf@vger.kernel.org, dri-devel@lists.freedesktop.org, linux-rdma@vger.kernel.org, linux-perf-users@vger.kernel.org
In-Reply-To: <20261009-b4-mmap-prepare-vma-flag-sanify-v5-32-923b70125b1e@kernel.org>
References: <20261009-b4-mmap-prepare-vma-flag-sanify-v5-0-923b70125b1e@kernel.org>
 <20261009-b4-mmap-prepare-vma-flag-sanify-v5-32-923b70125b1e@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 09 Oct 2026 18:47:37 +0000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> Make it clear what we're blocking in MADV_DOFORK. Previously we simply
> disallowed VM_SPECIAL i.e. mappings not managed by core mm, fixed mappings
> and
> VMA_IO_BIT.
>=20
> Now the invariant is established that mm-managed mappings may not set
> VMA_IO_BIT, the VMA_IO_BIT check is redundant.
>=20
> The rest is equivalent to testing for a fixed or non-mm-managed mapping,
> i.e. exactly the same check as whether the VMA is permitted to be merged.
>=20
> This was established by commit 0b2758f48f22 ("Require (reasonably) normal
> mappings for MADV_DOFORK") containing my hands-down favourite call out of
> all time.
>=20
> Express the same thing differently - if we wouldn't be allowed to merge i=
t,
> then we aren't allowed to manipulate CoW behaviour on fork.
>=20
> No functional change intended.
>=20
> Acked-by: Zi Yan <ziy@nvidia.com>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261009-b4-mmap-pr=
epare-vma-flag-sanify-v5-0-923b70125b1e@kernel.org?part=3D32

