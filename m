Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90C2149552C;
	Sat,  3 Oct 2026 17:56:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791050218; cv=none; b=jMRYmJJbfMhx9jxfVMz734eQC78BhzcI8Jdri5DpMvKf2Ys75dlSMwddm61zSFC+nWYlsGoOCuxLPrLQImYBB6/tsNP9ZyMJmdHS+qwdIhVIUPOSoP2JHSGfdm8nDm8vgC/WNWbMMuKZMy0Ps3k7xNasaqaIWOrxRUiVVl52ghw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791050218; c=relaxed/simple;
	bh=yGZ63lBideQLacZz14i18qtGsmnxQTUO08t8Q3rPVsc=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=F/KBc61UJ+FXXNz4IhR8RA4sfVUa6px6SL2FQ/Bdd6xLWNJT3viYIi7q9gfCNViucw+se5xa6DZ9rmz9Je38kLcmlf/3Lt9sdaf8g1koskbxns4Ir1nBiu9YFUXSrFET4bdSw8Ua7x0tK2B2XHpxibjAnxBdwkdHZGpXtxuQzGQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hlKFlBbO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hlKFlBbO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A69F51F0089E;
	Sat,  3 Oct 2026 17:56:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791050217;
	bh=yGZ63lBideQLacZz14i18qtGsmnxQTUO08t8Q3rPVsc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=hlKFlBbOJnLe0+/drHmdYmgNCqpCVEY/mwNelXGzcknf6cbBjO+/2yla0lCk55yMP
	 SLepTAFzZnvpLAuILypiGEqmOvonU3grRCBRl12Q9yghzz86+WsR3THOrAhrrRQiSx
	 polgTrc7NyXF12fphKJDGiRIih/A3W6oyb47fdbwhY+RANeh7Fw1IFogqN/TEKJn2b
	 FP/KXWUCybhKMzKiWLWaS5fmELv2z4B3WyssvnbgwoI34A8rHvz9/tH9FTDknEsdlK
	 XqRz+FOQWhrpRuy2HVg/gPF6fI5pOB97ExuAh19IxcdLjPq++Q0vg0IinM49WSranZ
	 dfTJze7iA9F8A==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 25/38] mm: remove VMA_IO_BIT check in
 vma[_flags]_is_mm_managed()
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TG9yZW56byBTdG9ha2VzIChBUk0p?= <ljs@kernel.org>
Cc: linux-trace-kernel@vger.kernel.org, "Alexander Gordeev" <agordeev@linux.ibm.com>, "Marc
 Zyngier" <maz@kernel.org>, linux-rdma@vger.kernel.org, kvmarm@lists.linux.dev, linux-scsi@vger.kernel.org, linux-perf-users@vger.kernel.org, linux-s390@vger.kernel.org, "Oliver
 Upton" <oupton@kernel.org>, kvm@vger.kernel.org, selinux@vger.kernel.org, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>, "Heiko Carstens" <hca@linux.ibm.com>, "Vasily
 Gorbik" <gor@linux.ibm.com>, dri-devel@lists.freedesktop.org, bpf@vger.kernel.org
In-Reply-To: <20261003-b4-mmap-prepare-vma-flag-sanify-v4-25-a1f052500fd7@kernel.org>
References: <20261003-b4-mmap-prepare-vma-flag-sanify-v4-0-a1f052500fd7@kernel.org>
 <20261003-b4-mmap-prepare-vma-flag-sanify-v4-25-a1f052500fd7@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 03 Oct 2026 17:56:56 +0000
Message-Id: <20261003175656.A69F51F0089E@smtp.kernel.org>
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
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261003-b4-mmap-pr=
epare-vma-flag-sanify-v4-0-a1f052500fd7@kernel.org?part=3D25

