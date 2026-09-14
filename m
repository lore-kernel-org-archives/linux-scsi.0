Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9254415B76;
	Mon, 14 Sep 2026 21:09:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789420144; cv=none; b=McuZqfmgoc3NVwgjgl5nSbJxIgwhVUfQvDuJpG9GmodEzKaZUhqhG6YNcGh0giHCdytth+pn0Sjrywx3+JCWSdh4wsqlj/hoh+mx2Zh3iuHeEuvxEXYeeWoGo+910DnD0OAzqZdDLKpyHnyaiLMt20MIgi89VpOw22mrKNLQCD0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789420144; c=relaxed/simple;
	bh=QNKiHNVVQITS2ZEMsnVYihCQciysFQAVe9ZcKtFzzs8=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=nhskfEaj40oNOqZpTiFeZtl7Q6wSMs5v7l0zgzbYD5vEYHOKNrN3+x6ErbTLRJblXyYiAzOinw48hhtAT3W0et5E+JavVJb3/P0tOctEFkW/Y7oymp4gtJyRmH+pj/MyOzLEVxvdqHMdBS+F7LuFJMMFyeFwwJ2oNbPMm01nn1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nA4osmvt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nA4osmvt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD02F1F000FF;
	Mon, 14 Sep 2026 21:09:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789420143;
	bh=QNKiHNVVQITS2ZEMsnVYihCQciysFQAVe9ZcKtFzzs8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=nA4osmvt+3w2NX7xPPnlIGpN/7wQ/mMwDj4YJIz1fLA9C6hm2m5WCMN4Ok0ZGUe7T
	 aV0ebLen3kqvvcsMfRkLpWDzRi8Nhr1V58kpnVXc9EtxLIkrhsJVg0V9j88mTpWgKE
	 dFNp8LYZQyige5E8unVZ1kI06p3hcagR5LU4Abch7PopNvmCAKAXwzADbaOQ2c92is
	 i2VXn2hig+Q2RBbpaYY4atRjmwA4wkD0FxeQBV1VUT+jEtEU+2RGUsLxgVt4g9BP9v
	 weFmhlhM8qNO3b56CJlgO0oY+1lFqL+dRIdOGvWXLFJlck+DxhFXFPILGXCVyAjeWn
	 /rANuoit+rUEg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 23/40] mm/mlock: clear VMA_LOCKED_MASK over mmap
 callback
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TG9yZW56byBTdG9ha2VzIChBUk0p?= <ljs@kernel.org>
Cc: "Heiko Carstens" <hca@linux.ibm.com>, bpf@vger.kernel.org, kvmarm@lists.linux.dev, linux-trace-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org, linux-scsi@vger.kernel.org, "Marc
 Zyngier" <maz@kernel.org>, linux-s390@vger.kernel.org, "Alexander Gordeev" <agordeev@linux.ibm.com>, selinux@vger.kernel.org, linux-rdma@vger.kernel.org, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>, dri-devel@lists.freedesktop.org, "Vasily
 Gorbik" <gor@linux.ibm.com>, "Oliver Upton" <oupton@kernel.org>, kvm@vger.kernel.org
In-Reply-To: <20260914-b4-mmap-prepare-vma-flag-sanify-v2-23-7d9781ed5361@kernel.org>
References: <20260914-b4-mmap-prepare-vma-flag-sanify-v2-0-7d9781ed5361@kernel.org>
 <20260914-b4-mmap-prepare-vma-flag-sanify-v2-23-7d9781ed5361@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 14 Sep 2026 21:09:02 +0000
Message-Id: <20260914210902.BD02F1F000FF@smtp.kernel.org>
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
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260914-b4-mmap-pr=
epare-vma-flag-sanify-v2-0-7d9781ed5361@kernel.org?part=3D23

