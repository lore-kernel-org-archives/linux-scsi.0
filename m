Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EBF649E14B;
	Sat,  3 Oct 2026 17:57:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791050229; cv=none; b=NDhxM4w7Ie4/8srVxl5vsEy38R5QHAUHeWP0k00uqslaSX+geGI/I7ZTRFBFApVM1eG26RknO6px0jBaxhy3kKLHqwOVfcOUnflpQoQmLneVtS0IU4o18/tUFirD5a8UzjE8gg2PCsYWgbopJ0pdXMWVC/AoxELHeBo2CbJQzx4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791050229; c=relaxed/simple;
	bh=g9mnUfqj7AA9FUkgCYZqJH7dgvQsuwYHk9asH5s1iZU=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=UN6MV6kMMns6s0C930zNZo8iwDWne+270c8A89fV9Fb9Gadr74Zjwdi1+s591MBRuPA4IAlNn3c+ntqdx8coLoNTk8ovExyJnki13lQ5HVAs3ZhN9jVuAE14H/ggbztwayBGGPAg+SI6T/nTpCch040EWOs7TBP5h69FJjvyLwU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NHTZMLD4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NHTZMLD4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B58D1F0089B;
	Sat,  3 Oct 2026 17:57:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791050228;
	bh=g9mnUfqj7AA9FUkgCYZqJH7dgvQsuwYHk9asH5s1iZU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=NHTZMLD4RgI+aFEbU2g2NkOEMfPI1xJV12N/yIM/Nd0v8UICGU30v44uzWIKi18UQ
	 Gx4bORFd1cb/qHk9CQKdggtjn3ZHmIgstRlilsvMGJ3Xxx0fPySRQVhGzCtC7PY9UE
	 b1bWMoh53qAKp8Xi7YCjarsfpFL/IfNHIsUWSiUDdlhE51ChvtR89k4FRwsiB9uzZb
	 qG5P6mUm76AiHDjAGT03ZsaE1UAhEaSYUie+QHKOcS0ric9w4Kf7yYV2Vy6w22vBD/
	 d0K9LKmTGTtq5qcH2duaTg2jOzduhXVNE0Z1aSvc1vBipT8OIj7hq3wIOhP5vKi5Lz
	 girfsM9UOYCMA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 22/38] mm/mlock: clear VMA_LOCKED_MASK over mmap
 callback
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TG9yZW56byBTdG9ha2VzIChBUk0p?= <ljs@kernel.org>
Cc: kvm@vger.kernel.org, dri-devel@lists.freedesktop.org, "Vasily Gorbik" <gor@linux.ibm.com>, "Heiko
 Carstens" <hca@linux.ibm.com>, "Oliver Upton" <oupton@kernel.org>, kvmarm@lists.linux.dev, linux-rdma@vger.kernel.org, selinux@vger.kernel.org, "Marc
 Zyngier" <maz@kernel.org>, linux-trace-kernel@vger.kernel.org, bpf@vger.kernel.org, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, "Christian Borntraeger" <borntraeger@linux.ibm.com>, linux-perf-users@vger.kernel.org, linux-s390@vger.kernel.org, linux-scsi@vger.kernel.org
In-Reply-To: <20261003-b4-mmap-prepare-vma-flag-sanify-v4-22-a1f052500fd7@kernel.org>
References: <20261003-b4-mmap-prepare-vma-flag-sanify-v4-0-a1f052500fd7@kernel.org>
 <20261003-b4-mmap-prepare-vma-flag-sanify-v4-22-a1f052500fd7@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 03 Oct 2026 17:57:07 +0000
Message-Id: <20261003175707.8B58D1F0089B@smtp.kernel.org>
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
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261003-b4-mmap-pr=
epare-vma-flag-sanify-v4-0-a1f052500fd7@kernel.org?part=3D22

