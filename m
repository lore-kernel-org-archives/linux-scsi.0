Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6ECC44F85A2;
	Thu, 17 Sep 2026 17:41:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789666876; cv=none; b=YNhpb91P2PBCcjXuZRpV5ITl9XVP3lTzCNUiihOKQ3Tq/2qmd5143C0CQ7WkaAf91VfMK8csuOIDj4uh+b0W0+9Qp9peJ/5OhjV86bDiyVloDHA8ZU19rgry4uRhjL+LdP0Yt08yv3vr6N7mY9hxOd6ojT2/SUDI16J1JZTdF7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789666876; c=relaxed/simple;
	bh=e8MybWT/ogT/EoRFkZPIJdPf4jZWS1ZGQlK8F51ywWY=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=t6s8kUAn0pvGjBMTtpRbhWxeTxVH6t3XyfLvT706aHvnKFKRAn5vAbiVb1MpFu1cmHaRLZkVlcwA8oBqPnZtsEnP0JGPwR2KLKwyFR3SMLYvV3aOgFxzPX97M2h5QoipibzYiL3aGZhWUI9hDDygHIAJnGZerZG7/szL/P2xLaw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=k7eP4aeC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="k7eP4aeC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EA011F00898;
	Thu, 17 Sep 2026 17:41:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789666874;
	bh=e8MybWT/ogT/EoRFkZPIJdPf4jZWS1ZGQlK8F51ywWY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=k7eP4aeCbOtexFgjNmIu35s7CvYDge8B3AfDt2+Rf1ILHuTYPqtrMHln1XchcVqU7
	 x4ldXnUAi5NxKHv+OMJHyfcU/m0kCdvLK4+Z3mDdKB9f8xRNF/Ev8MvW/YGjvDzObV
	 3SFmA3WpFd9GTEyBHPoCFRhDgwRkDWKFzNGlCnKet3iYxefu6gS1I1gTNtdQV+JeuF
	 9uuFOP+xU1wmbNkireow1avALbMfVy7HMoMJCVM8nqhJVYR123+iyStg9ehIxIuVDp
	 ff5cDhE+LZoVajG5EVwpILgMwTj+J3HJuD6dHifKIk8ZSKpi78N6qZT8gQGh7D418t
	 ScHn87gUIdVkA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 35/40] mm: eliminate VMA_SPECIAL_FLAGS check in
 lru_gen_look_around()
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TG9yZW56byBTdG9ha2VzIChBUk0p?= <ljs@kernel.org>
Cc: linux-trace-kernel@vger.kernel.org, kvm@vger.kernel.org, "Heiko Carstens" <hca@linux.ibm.com>, "Marc
 Zyngier" <maz@kernel.org>, dri-devel@lists.freedesktop.org, "Vasily Gorbik" <gor@linux.ibm.com>, linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, selinux@vger.kernel.org, "Oliver Upton" <oupton@kernel.org>, linux-rdma@vger.kernel.org, linux-perf-users@vger.kernel.org, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>, kvmarm@lists.linux.dev, bpf@vger.kernel.org
In-Reply-To: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-35-4583d8a23bca@kernel.org>
References: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-0-4583d8a23bca@kernel.org>
 <20260917-b4-mmap-prepare-vma-flag-sanify-v3-35-4583d8a23bca@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 17 Sep 2026 17:41:12 +0000
Message-Id: <20260917174113.4EA011F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> A kernel-owned or fixed mapping is one which sets VMA_PFNMAP_BIT,
> VMA_MIXEDMAP_BIT or VMA_DONTEXPAND_BIT, which is precisely what
> VMA_SPECIAL_FLAGS tests for other than VMA_IO_BIT, which is safe to drop =
as
> only kernel-owned mappings may set it.
>=20
> Using these predicates rather than VMA_SPECIAL_FLAGS makes the check
> self-documenting and helps eliminate the confusion around 'special' flags.
>=20
> No functional change intended.
>=20
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260917-b4-mmap-pr=
epare-vma-flag-sanify-v3-0-4583d8a23bca@kernel.org?part=3D35

