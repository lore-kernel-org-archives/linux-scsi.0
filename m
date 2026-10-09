Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A3DD390222;
	Fri,  9 Oct 2026 18:43:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791571428; cv=none; b=u25UJ24Kirw2Bv0c9XrvQm1xjwrzptfM6Bu0/Z499jVSaHg3mgqOpzCSlDwIwBLKlndkKV1t5Kq6+RdU4m25kSrV0AWG3UztuYs7ljWr839NyaAGUHBTCnr9Ps29hdsbCqU5uX2/KSD3rJ5KOjk+e6QN/yDkaJ6bZQ6hgubyB4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791571428; c=relaxed/simple;
	bh=HSwubk9sFN2VqJirmaDtgctb2mn2OA3fmXV5NwYVXXE=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=ajQDZiOUA+yTIAodHgjNIKheh1vhRjVXcsAH7ueL1HqRhOEK/it7LgKr5FuuJ8uJhu9YyFlGYdEyjKWUWf6mLigWbs91WUvQF1CpAJ4fxNeEiXPGjDyi2tzfvbQmiggO5kwCogw+XGje1hwPyO2zVnm6EpqNd9t8gJLLpqlfjg0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FIORP8nR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FIORP8nR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79DF41F000FF;
	Fri,  9 Oct 2026 18:43:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791571426;
	bh=HSwubk9sFN2VqJirmaDtgctb2mn2OA3fmXV5NwYVXXE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=FIORP8nRPdTGuZle36NO/en6zpnKO2M9+cK/GbK1AkIF0pswjLzePJM0iEGhRI2+1
	 e8So402T+YsiJULEhuMm81lht/1M5bAlfBIEfK0Biq/k/sTg5ka7hRAXK9gyZMVDV2
	 yQpB0ax7SPsbw4I9cTpOoN+6WuKkBBgLfzZy+IoFirkXfpDlXG/iZJh8vCMA16vcHe
	 HQ2HatFiLs/NAC1q0AQxHiUNwI3Q5EidqMAZuDNaXEe44GRMxBt+ri+sDIkQm+sghh
	 SGg1V4FbLzF0MmpECVJfG52eSQfEym9Paes6tsL4BsiJdH8yve03ZTzfQCKJ+Xganc
	 i+3zYCJ9xEA2g==
Message-ID: <sashiko-outbox-165963@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 25/38] mm: remove VMA_IO_BIT check in
 vma[_flags]_is_mm_managed()
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TG9yZW56byBTdG9ha2VzIChBUk0p?= <ljs@kernel.org>
Cc: "Marc Zyngier" <maz@kernel.org>, bpf@vger.kernel.org, "Oliver Upton" <oupton@kernel.org>, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, linux-rdma@vger.kernel.org, kvmarm@lists.linux.dev, "Heiko
 Carstens" <hca@linux.ibm.com>, "Vasily Gorbik" <gor@linux.ibm.com>, linux-s390@vger.kernel.org, linux-trace-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org, linux-usb@vger.kernel.org, dri-devel@lists.freedesktop.org, kvm@vger.kernel.org, selinux@vger.kernel.org, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>, linux-scsi@vger.kernel.org
In-Reply-To: <20261009-b4-mmap-prepare-vma-flag-sanify-v5-25-923b70125b1e@kernel.org>
References: <20261009-b4-mmap-prepare-vma-flag-sanify-v5-0-923b70125b1e@kernel.org>
 <20261009-b4-mmap-prepare-vma-flag-sanify-v5-25-923b70125b1e@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 09 Oct 2026 18:43:44 +0000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> We have now made it such that every driver which sets VMA_IO_BIT marks it
> as not mm-managed.
>=20
> However, vma_flags_is_mm_managed() currently treats VMA_IO_BIT as
> disqualifying. This was a product of drivers previously marking a range as
> not mm-managed by
> setting VMA_IO_BIT alone.
>=20
> Fix this by removing the VMA_IO_BIT check in vma_flags_is_mm_managed(),
> and update mmap_validate_vma_flags() to use vma_flags_is_mm_managed()
> rather than open-coding the VMA_PFNMAP_BIT, VMA_MIXEDMAP_BIT check.
>=20
> This change means that vma[_flags]_can_merge() doesn't check VMA_IO_BIT a=
ny
> longer (which is now redundant) as it calls vma_flags_is_mm_managed().
>=20
> [ ... ]
> Finally, update the VMA userland merge 'special' flag tests to no longer
> assert that VMA_IO_BIT prevents merge as VMA_PFNMAP_BIT, VMA_MIXEDMAP_BIT
> now suffices.
>=20
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261009-b4-mmap-pr=
epare-vma-flag-sanify-v5-0-923b70125b1e@kernel.org?part=3D25

