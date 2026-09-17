Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C7DD50128D;
	Thu, 17 Sep 2026 17:30:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789666254; cv=none; b=CLzG1vOqyNtpAK0DiTO1ANQi5+BL54KekYOaDY/NjZLutvs1y0ADaAc0RFry4sBbmuCTFku03dEteZvV/2t3aVrT8D9cqMQvFMpSh8jRuD7Pb0QC8vLHpIeUIX5NPAt1U22fXoOkwhIYod9eL41HkLB4slxpErBwINkk824FiP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789666254; c=relaxed/simple;
	bh=4xh76FaC1Y6V3vEMO/lt4Zv37crcHMuvNHrxjU/1JCo=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=FlDhx2gTbU5hzdHNi6lUto/Bcg8bBctj1PVerZJzTa9mb/nbjRKlgLHPnuTrKZNzMwSg0pNcMREXqowKy52CGI+55GUpf6lq67S4+37IIU9r221TGBJa0NoLecr/UCc4fMwXzwGef2oUMx6GaRDVc4GkLQ2xUH0zq7z9SUNNrfA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ia3avcmk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ia3avcmk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC88D1F000FF;
	Thu, 17 Sep 2026 17:30:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789666252;
	bh=4xh76FaC1Y6V3vEMO/lt4Zv37crcHMuvNHrxjU/1JCo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Ia3avcmkpTpvuz+wXWTipzEb3hi+te/YkFH5JTkbB3ipE+deqYcOnP9os8UQB39/j
	 cyjG+j5XV6RzLucZrWm8ducEpdrhj/WVqgFnjQnmoGSKSuPMkT+lH1+zhV1c1R0j2e
	 r2jdMV2orAQZXEYA4b6VrtKIhGz91X3b2bkz1ihjH1KwgocDtfVugEQ4UU3lzZyhRs
	 9pMAkHQA4DgvwceJH2p/PNrXUk/tBXq3zN3fSyFV6qlxKYjpv48IREEJUWkLcbyNSh
	 d/HBfCwCqdGbz3uNYljGTxyAEGSbrXWcsC1zzllz3x5vFZU3Mk2vC9ATlO/95klaPL
	 dvpofggkytP4Q==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 21/40] mm/gup: error out early on !VMA_MAYREAD_BIT
 VMAs
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TG9yZW56byBTdG9ha2VzIChBUk0p?= <ljs@kernel.org>
Cc: bpf@vger.kernel.org, "Alexander Gordeev" <agordeev@linux.ibm.com>, "Heiko
 Carstens" <hca@linux.ibm.com>, "Christian Borntraeger" <borntraeger@linux.ibm.com>, "Marc
 Zyngier" <maz@kernel.org>, "Oliver Upton" <oupton@kernel.org>, kvmarm@lists.linux.dev, linux-trace-kernel@vger.kernel.org, kvm@vger.kernel.org, dri-devel@lists.freedesktop.org, selinux@vger.kernel.org, "Vasily
 Gorbik" <gor@linux.ibm.com>, linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, linux-perf-users@vger.kernel.org, linux-rdma@vger.kernel.org
In-Reply-To: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-21-4583d8a23bca@kernel.org>
References: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-0-4583d8a23bca@kernel.org>
 <20260917-b4-mmap-prepare-vma-flag-sanify-v3-21-4583d8a23bca@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 17 Sep 2026 17:30:51 +0000
Message-Id: <20260917173051.CC88D1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> When populating a VMA range via the aptly named populate_vma_page_range()
> an unreadable VMA will always eventually fail with -EFAULT.
>=20
> That a VMA is accessible is always checked, however VMA_MAYREAD_BIT is no=
t.
>=20
> All user mappings always have VMA_MAYREAD_BIT set, so this check only
> impacts kernel mappings.
>=20
> It is implemented specifically to disallow population of uprobes XOL
> mappings which are exec-only.
>=20
> A nasty interaction with these mappings may occur if they are mlocked, so
> actively disallow this early.
>=20
> This allows a subsequent commit to remove the VM_IO check in
> __mm_populate() which otherwise requires non-MMIO mappings to be wrongly
> flagged simply as a workaround.
>=20
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260917-b4-mmap-pr=
epare-vma-flag-sanify-v3-0-4583d8a23bca@kernel.org?part=3D21

