Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDD6F3C0A07;
	Fri,  9 Oct 2026 18:44:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791571443; cv=none; b=RuAs8u+GsIE9cfEP4TQTSrsmhB5YefjZm4TbGH5Et3cNTLDsjWvo95B+Rkgn4VgNWDExerrzY5yAKdEuyHDI409moO9feeYK4ZHO30aVe5ss1fsTJ6GOluZZTeJrwZQHZ1bgU4c736oe422n796NCSt8fqCwIkKhMWpUB7YHe1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791571443; c=relaxed/simple;
	bh=tMkCnvhuZKPJ18phjKy3R2NY9oh2hTQcU5jUe9DRdTI=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=Q2lPDQPiRXnLjcJ++AsExknbIfJDL0JAiDLQXUUpU8oBtX5RVLmzOIvFiKYg+s6wB3yLJmPGdbrgSAeT7QsN62bCc+3C0/Z+dcaZlRev3GButYuAH1dWGjf5Yt5yLFzMOOxXwYnacu9RirA97zmtBHLw3uj58vgSrrz340+369I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lr94gk4Q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lr94gk4Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 032881F000FF;
	Fri,  9 Oct 2026 18:44:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791571442;
	bh=tMkCnvhuZKPJ18phjKy3R2NY9oh2hTQcU5jUe9DRdTI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=lr94gk4QvV6SugCkaAxyZvaLpzRhuXfwtbMfdvIKhnew2haMD/9zIv98qkoEp0kiu
	 RyJbDs7iNmUoGBzakZ2L9THUUGsE/D2R+iLN0f5GWAVPqwpwkCsW6CE67PGfMD0Rld
	 +2juPpBtHE+m1tjGGwS/xP9TUl8Hjhdjwfe5hgR4+4+Hq0+HBC7oItxhbTalc0pvZd
	 AMlSl7emNsN9fxuaF5DBN4paVgVW5oN9r3YAqXMCFeofLR6g1HErIQzCx5cR0+tJnN
	 k2ChFFV3wYO6fjc8v0leW43/c2OlPQyqM3z7MJaNyz94pceI6KuvGCeC9B30p9ISPM
	 q2IrbFY3eJKpA==
Message-ID: <sashiko-outbox-165966@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 29/38] mm/madvise: update is_valid_guard_vma() to use
 vma_can_merge()
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TG9yZW56byBTdG9ha2VzIChBUk0p?= <ljs@kernel.org>
Cc: bpf@vger.kernel.org, selinux@vger.kernel.org, dri-devel@lists.freedesktop.org, linux-trace-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, linux-usb@vger.kernel.org, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>, "Oliver Upton" <oupton@kernel.org>, kvm@vger.kernel.org, "Heiko
 Carstens" <hca@linux.ibm.com>, linux-rdma@vger.kernel.org, linux-perf-users@vger.kernel.org, "Marc
 Zyngier" <maz@kernel.org>, linux-s390@vger.kernel.org, "Vasily Gorbik" <gor@linux.ibm.com>, kvmarm@lists.linux.dev
In-Reply-To: <20261009-b4-mmap-prepare-vma-flag-sanify-v5-29-923b70125b1e@kernel.org>
References: <20261009-b4-mmap-prepare-vma-flag-sanify-v5-0-923b70125b1e@kernel.org>
 <20261009-b4-mmap-prepare-vma-flag-sanify-v5-29-923b70125b1e@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 09 Oct 2026 18:44:00 +0000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> We currently disallow the installation of lightweight guard regions in VM=
As
> whose flags intersect VMA_SPECIAL_FLAGS or VMA_HUGETLB_BIT, or
> VMA_LOCKED_BIT unless allow_locked is set.
>=20
> hugetlb VMAs set VMA_DONTEXPAND_BIT so this was already redundant,
> VMA_SPECIAL_FLAGS already sufficed.
>=20
> However, now that VMA_IO_BIT is only set if VMA_PFNMAP or VMA_MIXEDMAP_BIT
> is set, this check collapses to being the equivalent of
> !vma_can_merge().
>=20
> Update is_valid_guard_vma() to reflect this.
>=20
> No functional change intended.
>=20
> Acked-by: Zi Yan <ziy@nvidia.com>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261009-b4-mmap-pr=
epare-vma-flag-sanify-v5-0-923b70125b1e@kernel.org?part=3D29

