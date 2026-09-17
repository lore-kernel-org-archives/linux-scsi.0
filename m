Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90B324E9C0D;
	Thu, 17 Sep 2026 17:37:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789666624; cv=none; b=aLqO6ZJE+ALjtgksMBi4qjzdnQcgF5dTCOnhXlm1PgkpwCxLbVO+8Q9hTn6AG1ujaG/5G7enmzoFayKNsrl8LYHkK74vKSwccAAhtUTjafB5DEkmkpmL8VkDntwrPl2x0R018msNxIAhyrbQ2Nd+eGzSQHoID2H8uH3h6/7eD5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789666624; c=relaxed/simple;
	bh=vYign4VA5EdKOebAsdtcDdj4hWPOQrArCDSqgsSaCgw=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=o7XOKEoZBvOqjbG0lT20emgBITfhRL/Ksk+8nlhyu9/MdBP4739ZXm2594fO1bldkVDj6vqT5hsObH7l7bfnTs61TGym/y1QrSzaV0gHtMMSNIHrEO0J2N0XbPD9Ziilham8mDosYXiMK59IwtzSCoxkWlGwGse/aTptpwMFLDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Sb1sytnv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Sb1sytnv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AF311F00893;
	Thu, 17 Sep 2026 17:37:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789666623;
	bh=vYign4VA5EdKOebAsdtcDdj4hWPOQrArCDSqgsSaCgw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Sb1sytnvw54TiwcmCbwClwSDgNd2Qm4VeIJOz/gPMjcBrHJ7/FSBagGxxuKRXwlhN
	 kuFOB/t4mqgjtc4GrwWlSqGgtG1iyKTHytpbmDVhIoRiI2Ox6DMOu4Ah0HnPyvJaXL
	 22LntCf7AvnFZ8GKKvM8B5UpRWiM5hml8TjbmBgZT/lyYBTp+CuGl7ZUp9ZXjN+EI7
	 mybj86AgDUlX+I5vu5vmXcBPF221IiGTyRWDjBcm+r9+OrKMy0gmQWfDvLChuRng0Q
	 PPGOu8vZEctzoEBHAdz7AJ/ApNNkjm6AARUyehjKrU/IdUrukF99/JqYAMpe+04baL
	 mRcsSzS4QNsig==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 30/40] mm/madvise: update is_valid_guard_vma() to use
 vma_can_merge()
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TG9yZW56byBTdG9ha2VzIChBUk0p?= <ljs@kernel.org>
Cc: linux-scsi@vger.kernel.org, "Heiko Carstens" <hca@linux.ibm.com>, kvmarm@lists.linux.dev, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, selinux@vger.kernel.org, "Marc Zyngier" <maz@kernel.org>, linux-rdma@vger.kernel.org, "Oliver
 Upton" <oupton@kernel.org>, linux-trace-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org, kvm@vger.kernel.org, linux-perf-users@vger.kernel.org, linux-s390@vger.kernel.org, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>, "Vasily Gorbik" <gor@linux.ibm.com>, bpf@vger.kernel.org
In-Reply-To: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-30-4583d8a23bca@kernel.org>
References: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-0-4583d8a23bca@kernel.org>
 <20260917-b4-mmap-prepare-vma-flag-sanify-v3-30-4583d8a23bca@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 17 Sep 2026 17:37:02 +0000
Message-Id: <20260917173702.9AF311F00893@smtp.kernel.org>
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
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260917-b4-mmap-pr=
epare-vma-flag-sanify-v3-0-4583d8a23bca@kernel.org?part=3D30

