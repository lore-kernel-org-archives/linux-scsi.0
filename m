Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B6A84A014F;
	Sat,  3 Oct 2026 17:57:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791050231; cv=none; b=nS3LG3UCeI1JbiuxRKNXPHjWZHsB74vFBWXRKOwacAkpzKbuVl0Yj6RfVTTNRsj8hXAT3OcziDugP6uDH+Omx7Kq1Qu3KYZN1cYa2YfQKqHPm4G5LwRb+w6t9V7DbZjTO4VnrEXg/fv3qisaccUWPTaj5tZbGoFWZw7HWPWdUVQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791050231; c=relaxed/simple;
	bh=jXVmItd1jWo+YkfeJqvwLb+xsPg3KsljVnNywlc+IwU=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=anPdq/oY7VN+h8VaR9WB64UowMgNKo2Er79JsIkZZ2L/5utYcJ5K437mK71wU2r4x0YgFSZtIw7TBCDA5Gwl7aZ/sJ/yKPxn4raSZulo/rBftDJICi2JLAOPLokpCSJmSjy07tHVHDi6W7YmkHZi+4ikXGVtskeULNsn7Lxq2Rw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Z3z7KAFP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Z3z7KAFP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DED111F00A02;
	Sat,  3 Oct 2026 17:57:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791050229;
	bh=jXVmItd1jWo+YkfeJqvwLb+xsPg3KsljVnNywlc+IwU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Z3z7KAFPb8/z8a9VPJfRi6+FbdhEXpiV3rJ+g2GgKAWW8ifjBmoJV/Vcxvu32Bj4O
	 3VCCpfv1mQwLTFffuWGmwhXkoOuqk/k8VwF+LkxnugaRncQcVTDNoVST7qIgqXmqDd
	 1eyV47+rE21j6F4fe9b31IIyCcAal+3VtQP8nv384qhpHa2BbJvy9A7xDSShdcX+hD
	 e7GLz9DYCLWAQfJH9RZ398BujKwK3Y8sVfW56Hqwa/TUaWZTJ5BSN5QPivFAWRqJKN
	 He0IgOuYPglg8ttw710Y8v3Ypy7m15x8mhO8PYFgAUSuZdL0x1yWe538gIw/beNMzo
	 CVjkaCvkBv2EA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 29/38] mm/madvise: update is_valid_guard_vma() to use
 vma_can_merge()
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TG9yZW56byBTdG9ha2VzIChBUk0p?= <ljs@kernel.org>
Cc: selinux@vger.kernel.org, "Oliver Upton" <oupton@kernel.org>, "Vasily
 Gorbik" <gor@linux.ibm.com>, bpf@vger.kernel.org, kvm@vger.kernel.org, kvmarm@lists.linux.dev, "Heiko
 Carstens" <hca@linux.ibm.com>, dri-devel@lists.freedesktop.org, linux-perf-users@vger.kernel.org, linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, linux-trace-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, "Christian Borntraeger" <borntraeger@linux.ibm.com>, "Marc
 Zyngier" <maz@kernel.org>
In-Reply-To: <20261003-b4-mmap-prepare-vma-flag-sanify-v4-29-a1f052500fd7@kernel.org>
References: <20261003-b4-mmap-prepare-vma-flag-sanify-v4-0-a1f052500fd7@kernel.org>
 <20261003-b4-mmap-prepare-vma-flag-sanify-v4-29-a1f052500fd7@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 03 Oct 2026 17:57:08 +0000
Message-Id: <20261003175708.DED111F00A02@smtp.kernel.org>
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
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261003-b4-mmap-pr=
epare-vma-flag-sanify-v4-0-a1f052500fd7@kernel.org?part=3D29

