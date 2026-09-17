Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02523470EB6;
	Thu, 17 Sep 2026 17:07:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664880; cv=none; b=cNu0i15piVVumIgDxmFHwFCTMy20No70ncL44F2+n1Ws0/2zpTtWRkuexUwt/DAQHsCJNstZ9MlSQTA/OVQ5ReYt9e2TWI7z91TrKcfBWjpBKHpXea7ywbwC0RtpoFglF76Te8Z/sh3If+DVGhY9BVbFR/SSy7QEsph3gcXC+Fg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664880; c=relaxed/simple;
	bh=K8GmGw+ly7aq2IiC9ErXSqow6NQtT9XEbDR//zdXljU=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=R0rgYQxhvCMDw7PgFyz/72oyjRea9pYGV87AVcyV/TH14/eMUP7QrkCso2Vzi+D6ZBKkN4RpTzUyKK5d3ARutuiHj6r11ZBz7VH98iQlu3fHfu5Np7vuzFGz/lJDgG+Qs64Oddz6gT9GfboH8TDHOw5svcx+nP2D84qJKNa1/o4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hdZQgrxs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hdZQgrxs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 902F61F000FF;
	Thu, 17 Sep 2026 17:07:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789664878;
	bh=K8GmGw+ly7aq2IiC9ErXSqow6NQtT9XEbDR//zdXljU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=hdZQgrxs6PWCLS3JKXPDXs7bWesaG7AZbkjx2CSrftDofYBxyToTyHRdKCOk+PBkM
	 Y1ZaB8sSGiLS0Kf5xWe98tb8iIZAymt9J1USeIKf7kMJQTqbE0i21pK4BVrTELG/p0
	 5GRVCh2uAQGUq6hInjvtU6m360FSvy0uYB0XUle5wV2wOgOk6apbArgRYeN2n/gd3L
	 1a9ZszzFa/6sXe/vnwFjKNx3arPOlEnXc9RzsZaLVP1UFo+E42nn7E06xmtqtwI5vT
	 o4Kxb5vyFvTknKetWC/4iOX9lh0/U9jwKp/k8o+IA29qYo1fLb4GW/FKFx5XYxqW+d
	 vVEA++cPtCLmA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 02/40] mm/vma: predicate setting mmap_prepare VMA
 fields on new vma alloc
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TG9yZW56byBTdG9ha2VzIChBUk0p?= <ljs@kernel.org>
Cc: "Christian Borntraeger" <borntraeger@linux.ibm.com>, "Alexander Gordeev" <agordeev@linux.ibm.com>, dri-devel@lists.freedesktop.org, bpf@vger.kernel.org, linux-perf-users@vger.kernel.org, linux-rdma@vger.kernel.org, "Marc
 Zyngier" <maz@kernel.org>, "Heiko Carstens" <hca@linux.ibm.com>, kvm@vger.kernel.org, "Oliver
 Upton" <oupton@kernel.org>, selinux@vger.kernel.org, "Vasily Gorbik" <gor@linux.ibm.com>, linux-s390@vger.kernel.org, linux-scsi@vger.kernel.org, linux-trace-kernel@vger.kernel.org, kvmarm@lists.linux.dev
In-Reply-To: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-2-4583d8a23bca@kernel.org>
References: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-0-4583d8a23bca@kernel.org>
 <20260917-b4-mmap-prepare-vma-flag-sanify-v3-2-4583d8a23bca@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 17 Sep 2026 17:07:57 +0000
Message-Id: <20260917170757.902F61F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> It only makes sense to manipulate VMA fields if we allocated a new VMA,
> rather than merged it.
>=20
> VMA merging does not compare vm_ops or vm_private_data, so a merged VMA
> keeps its own, which is also what the legacy f_op->mmap path does since it
> never touches an existing VMA. Previously set_vma_user_defined_fields()
> overwrote the merged VMA's fields with those set for the new mapping. In
> practice these are the same values, with rare exceptions such as shmem
> selecting vm_ops based on whether the file has been unlinked, so no
> user-visible change is expected.
>=20
> Make this dependency explicit, and additionally constify have_mmap_prepare
> while we're here.
>=20
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260917-b4-mmap-pr=
epare-vma-flag-sanify-v3-0-4583d8a23bca@kernel.org?part=3D2

