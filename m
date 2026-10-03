Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EC9B49A3A7;
	Sat,  3 Oct 2026 17:57:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791050221; cv=none; b=myPU2F5JDLW8Fqc57Ucp+N4X2H+v9nYfFo1T2mS0gszOTYTJFSAmvbn2nh9w5snW1c3JseppEsgsTdhm1pxa0Rxx4OxFcaGptDLE0WSYAgCz/5XeAepndCQ4kN0Jlh2ykTNl7lyiP0LRhj/UNVltjaQytGkR5623/Vj3nBRmsuo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791050221; c=relaxed/simple;
	bh=MQxJazrbjhgm0gRarbkFujbF+zlkwv7DxlNa3s+HWj4=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=F7zksDK/BgBSuUIU0nRZwjnBPdVqh8uvZBC4rdxcSL4/1mPG7LHtk6CRw2Bsa6kHVEz9I1s7VjsrRnuAEDZE6ZNiH/z4RGJWIXTWVYcXK4nXgifsk9eNVyXtCRKQsWmLh1OKVADyqrSaEqRL9y3wyQo8MvRkNYlpuloCqC2SpLI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JGKwLDL1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JGKwLDL1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C8171F0089C;
	Sat,  3 Oct 2026 17:56:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791050220;
	bh=MQxJazrbjhgm0gRarbkFujbF+zlkwv7DxlNa3s+HWj4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=JGKwLDL1gw9CF1kbvunBYS9hoASwUwjP/uAAfYAwjXRMKLQODllvvSushKdkFJxSo
	 tk78ZPjNFXNxl49d/ciKHFV/vajcGNQl2vVWSQ+Wqw9+keCnqGfkv5VnD2mAphJWdL
	 D66dq19ybXiijdCVz7ucr8z/d89AiYq9YBF7nfpui3Yy+5uqDdIxiQd6y37hPpTjHw
	 jsVlqh2dgKynbd+5+KJaXB+pdYG43GVHSruDMp2MFoQ9OKAdFL0cnDFrz/b6sUcWgz
	 M+9WkqF9s+C2NrpPe+l8DWI5gvb2QD0dmMV5d1kBNauG5iWa50FVN36vPQNKXvz7FC
	 PHq8xPgEiCIxA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 23/38] mm/mlock: eliminate weird VMA_IO_BIT abuse and
 simplify
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TG9yZW56byBTdG9ha2VzIChBUk0p?= <ljs@kernel.org>
Cc: linux-trace-kernel@vger.kernel.org, "Christian Borntraeger" <borntraeger@linux.ibm.com>, dri-devel@lists.freedesktop.org, linux-perf-users@vger.kernel.org, "Marc
 Zyngier" <maz@kernel.org>, linux-s390@vger.kernel.org, kvmarm@lists.linux.dev, linux-rdma@vger.kernel.org, "Vasily
 Gorbik" <gor@linux.ibm.com>, kvm@vger.kernel.org, "Heiko Carstens" <hca@linux.ibm.com>, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, "Oliver Upton" <oupton@kernel.org>, linux-scsi@vger.kernel.org, selinux@vger.kernel.org, bpf@vger.kernel.org
In-Reply-To: <20261003-b4-mmap-prepare-vma-flag-sanify-v4-23-a1f052500fd7@kernel.org>
References: <20261003-b4-mmap-prepare-vma-flag-sanify-v4-0-a1f052500fd7@kernel.org>
 <20261003-b4-mmap-prepare-vma-flag-sanify-v4-23-a1f052500fd7@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 03 Oct 2026 17:56:58 +0000
Message-Id: <20261003175659.4C8171F0089C@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> When performing mlock() or munlock() otherwise normal VMAs have VMA_IO_BIT
> solely to fix a race with migration which might otherwise double-count
> mlock VMAs.
>=20
> This is unnecessary - at the point of applying folio mlock state, whether
> setting or clearing PG_mlocked, we know whether or not we are locking.
>=20
> Solve this in two ways - thread a boolean through the page table walk
> indicating whether a lock or unlock is being performed, and run a locking
> walk with VMA_LOCKONFAULT_BIT set and VMA_LOCKED_BIT cleared.
>=20
> This state never occurs otherwise, as VMA_LOCKONFAULT_BIT always implies
> VMA_LOCKED_BIT. These are also always cleared together.
>=20
> Then, update folio_add_lru_vma() and mlock_folio() to check only for
> [ ... ]
>=20
> While here, also replace some deprecated VMA flag predicates.
>=20
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261003-b4-mmap-pr=
epare-vma-flag-sanify-v4-0-a1f052500fd7@kernel.org?part=3D23

