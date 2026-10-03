Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A8783A453F;
	Sat,  3 Oct 2026 17:56:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791050211; cv=none; b=dENLLDJE/6yCIM/+LY+57vwhZFR5L4TZyekWHaoBNhi5qRO7ooGLdCAuxDyHHXy1dtSMEk+hGx9Etwvct0quWaqFuq9o65FeiboXFRREsXeo9YHtdSkKB7fD+mJRdQgVIdHMlEPWoOOzWrYSfPlgAciFYpp/8Lm3sF0Ev9c9oPM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791050211; c=relaxed/simple;
	bh=fNKwmJ2FDVtdTL3y0GyvDzG8/ozv3dIUrcZXx4kuy5U=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=ANvkeuBFyD48kRRziClrCmCXq9mp81pnYpUGM9kfYHQnVeQrUOvAD/IIhWHAmtn59oPDFIih0aqGbVYuMoSGOUi4ZI8P1HGg0aY4F1uDYdmowtHM3JvngUTw+MX7xuAfvohN//V02S2XQkgS9KlWi3IQYEx4+A8sfT+/WEN8L8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ITluEL17; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ITluEL17"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 661101F0089E;
	Sat,  3 Oct 2026 17:56:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791050206;
	bh=fNKwmJ2FDVtdTL3y0GyvDzG8/ozv3dIUrcZXx4kuy5U=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ITluEL17r/l5dxzeCCMkWLqEdNBuvzRsEvb3UDBJbboW/2tLB6eYdO8tMNFWwx6rB
	 +TEhLX2hqPLhJA05tAalVcTKxFUmB8SUxJ6BYYdDxUcoIQBs+kW6S3Yi96C7dhTOsV
	 qkGM9XaKxkMYnzfCanEJA+oy/N6wYtQjwAWZpRduOAlrHvW/jduWOkAxGnaGNx5+ZX
	 ekFnfxI1d7cIx+m/p6JTMAXu3bQUgCnnv+K8oeo5Z6tGLHUQYIRIrcKIZh0If66BEy
	 m77u7gzPh1gKp1b2fHeyZ5vgF7CHrR83qsgU9MQE+pxoCz5f7L+rteJWw4JQ9BA3LM
	 aDRvYVqR0H2tQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 26/38] mm: remove hugetlb_inline.h
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TG9yZW56byBTdG9ha2VzIChBUk0p?= <ljs@kernel.org>
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org, "Vasily Gorbik" <gor@linux.ibm.com>, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, "Oliver Upton" <oupton@kernel.org>, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>, linux-perf-users@vger.kernel.org, "Heiko
 Carstens" <hca@linux.ibm.com>, dri-devel@lists.freedesktop.org, kvmarm@lists.linux.dev, bpf@vger.kernel.org, linux-trace-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, "Marc
 Zyngier" <maz@kernel.org>, selinux@vger.kernel.org, linux-rdma@vger.kernel.org
In-Reply-To: <20261003-b4-mmap-prepare-vma-flag-sanify-v4-26-a1f052500fd7@kernel.org>
References: <20261003-b4-mmap-prepare-vma-flag-sanify-v4-0-a1f052500fd7@kernel.org>
 <20261003-b4-mmap-prepare-vma-flag-sanify-v4-26-a1f052500fd7@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 03 Oct 2026 17:56:44 +0000
Message-Id: <20261003175645.661101F0089E@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> This header really makes little sense - every place it is included mm.h is
> also included, and the header itself includes mm.h, so it does nothing to
> reduce header size.
>=20
> It also oddly does an #ifdef around checking VMA_HUGETLB_BIT, however
> VMA_HUGETLB_BIT is unconditionally available, and will never be set if
> hugetlb is not enabled.
>=20
> Simply remove the header, eliminate the odd ifdeffery and place the
> predicates in mm.h.
>=20
> The naming of these predicates is odd, but to keep changes separate, we
> will address this in a separate patch.
>=20
> The file was never put into MAINTAINERS so there's no change required
> there.
>=20
> No functional change intended.
>=20
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261003-b4-mmap-pr=
epare-vma-flag-sanify-v4-0-a1f052500fd7@kernel.org?part=3D26

