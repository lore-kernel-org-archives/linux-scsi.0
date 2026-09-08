Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 479583B5DE9;
	Tue,  8 Sep 2026 20:37:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788899832; cv=none; b=CdPt3dIc9yvJ1pAzSeEEN8itj2ahTMcWZq/MCQmgrxlb/a5eYxFSW7EDcyXt50PEDomhol2Ci+7r9zlo4lfoSR98jwUfjkzYd5KsCrdfU6ZWRVFdQHqTYdyRB1ikVGY/tZlqVOxKahzxUViwSWkPYcjCj7keFvEEV6npY3+Zka0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788899832; c=relaxed/simple;
	bh=vKY+yw4xM33mk6fiECJIDoF9uX3TRcvPPahTr1AkOwI=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=tznSbNEReqP2+Xckzw+S7fw0oGCSozgcZZSQDqRbDaiN2KKVMA4ky7/neYcGOTo6gHI9oVxEQihxhFovvLbQRkKy7QZEavN9pa97XLfGpCCgjO4b7J60o39R5l21y4zC7/iA2mSMdYbnNIj14e6lDkor6Ub859u9FroJTXyavPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NLqvSoZ9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NLqvSoZ9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 474C71F00A3A;
	Tue,  8 Sep 2026 20:37:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788899830;
	bh=vKY+yw4xM33mk6fiECJIDoF9uX3TRcvPPahTr1AkOwI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=NLqvSoZ9u/s7AzQdCGQbOwpQQATcRISGifpcG89xXd60mummWSH13rJhgxmZ89q2l
	 aTDv/ryxne2Dd36UI6UOzlWG/1ScTwNOrJJHzrzTBD81Uoq3Isz9pYyXhA5vwXLk0B
	 JVgL2qSIUHniv05ZRAyur6eZyKlAfLUZsBv9sXQIMm9npiUST0YBWRKdDtIUA+VDXE
	 /Oaa0iJyG+JjPhNyb5E4dMgnvGFGSRv100vFoQnJdISw2Rl39Pow4AN/I20yQyW7IG
	 DWR4fyydePQNnsp3ifWDMdYR1E38Bpnjr5WoHMaDA+L4Bxs065WG4mnjwrXdLHMfsT
	 R7EqJORON9kQg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 25/39] mm: remove VMA_IO_BIT check in
 vma[_flags]_is_kernel_owned()
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TG9yZW56byBTdG9ha2VzIChBUk0p?= <ljs@kernel.org>
Cc: dri-devel@lists.freedesktop.org, linux-s390@vger.kernel.org, kvm@vger.kernel.org, "Marc
 Zyngier" <maz@kernel.org>, bpf@vger.kernel.org, linux-scsi@vger.kernel.org, selinux@vger.kernel.org, "Oliver
 Upton" <oupton@kernel.org>, "Heiko Carstens" <hca@linux.ibm.com>, "Vasily
 Gorbik" <gor@linux.ibm.com>, "Alexander Gordeev" <agordeev@linux.ibm.com>, linux-perf-users@vger.kernel.org, linux-trace-kernel@vger.kernel.org, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>, kvmarm@lists.linux.dev
In-Reply-To: <20260908-b4-mmap-prepare-vma-flag-sanify-v1-25-dacf19cce22b@kernel.org>
References: <20260908-b4-mmap-prepare-vma-flag-sanify-v1-0-dacf19cce22b@kernel.org>
 <20260908-b4-mmap-prepare-vma-flag-sanify-v1-25-dacf19cce22b@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 08 Sep 2026 20:37:08 +0000
Message-Id: <20260908203709.474C71F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> We have now made it such that every driver which sets VMA_IO_BIT marks it
> as kernel-owned.
>=20
> However, vma_flags_is_kernel_owned() currently checks for VMA_IO_BIT. This
> was a product of drivers previously marking a range as kernel-owned by
> setting VMA_IO_BIT alone.
>=20
> Fix this by removing the VMA_IO_BIT check in vma_flags_is_kernel_owned(),
> and update mmap_validate_vma_flags() to use vma_flags_is_kernel_owned()
> rather than open-coding the VMA_PFNMAP_BIT, VMA_MIXEDMAP_BIT check.
>=20
> This change means that vma[_flags]_can_merge() doesn't check VMA_IO_BIT a=
ny
> longer (which is now redundant) as it calls vma_flags_is_kernel_owned().
>=20
> Now that the predicate means precisely VMA_PFNMAP_BIT or VMA_MIXEDMAP_BIT,
> [ ... ]
> Finally, update the VMA userland merge 'special' flag tests to no longer
> assert that VMA_IO_BIT prevents merge as VMA_PFNMAP_BIT, VMA_MIXEDMAP_BIT
> now suffices.
>=20
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260908-b4-mmap-pr=
epare-vma-flag-sanify-v1-0-dacf19cce22b@kernel.org?part=3D25

